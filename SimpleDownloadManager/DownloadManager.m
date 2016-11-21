//
//  DownloadManager.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/13/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <CoreData/NSManagedObject.h>
#import "DownloadManager.h"
#import "DownloadFile.h"
#import "AppDelegate.h"


@interface DownloadManager () <NSURLSessionDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSURLSession *session;
@end

@implementation DownloadManager



- (instancetype)initSession{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
        
            
            
        NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:[[NSBundle mainBundle] bundleIdentifier]];
       
            static NSInteger maxQuantity = 7;
        backgroundConfig.HTTPMaximumConnectionsPerHost = maxQuantity;
        _maxDownloadQuantity = maxQuantity;
            
        self.session = [NSURLSession sessionWithConfiguration:backgroundConfig
                                                     delegate:self
                                                delegateQueue:nil];
            
        
        self.downloadFiles = [NSMutableArray array];
        });
  }
    
    return self;
}




-(void) addDownloadFileForUrl:(NSString *)urlString
                     withName:(NSString *)titleName
{
    
    DownloadFile *file = [[DownloadFile alloc] initWithTitleName:titleName
                                                      urlString:urlString];
    file.dateStartDownload = [NSDate date];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:file.url];
    
    file.downloadTask = [self.session downloadTaskWithRequest:request];
    
    [self.downloadFiles addObject:file];
    //[self setToCoreData:file];
    
    
}
#pragma mark - CoreData

-(NSManagedObjectContext *) managedObjectContext
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext * context = appDelegate.mainContext;
    
    return context ;
    
}


-(void)setToCoreData:(DownloadFile*)file
{
    NSManagedObjectContext * context = [self managedObjectContext];
    
    NSManagedObject * downloadInfo = [NSEntityDescription insertNewObjectForEntityForName:@"DownloadEntity" inManagedObjectContext:context];
    
    [downloadInfo setValue:file.titleName forKey:@"name"];
    [downloadInfo setValue:file.dateStartDownload forKey:@"dateStartDownload"];
    [downloadInfo setValue:file.dateCompletDownload forKey:@"dateCompletedDownload"];
    [downloadInfo setValue:file.statusCompleted forKey:@"status"];
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
}


-(void) downlodInfoForIndex:(NSInteger) index
              progressBlock:(void(^)(CGFloat progress, NSString* write, NSString* total))progressBlock
          downloadTimeBlock:(void(^)(NSString* time))downloadTimeBlock
 isCompletedDowloadindBlock:(void(^)(BOOL isCompleted))isCompletedDownloadingBlock{
    
    DownloadFile * file = [self.downloadFiles objectAtIndex:index];
    if(file)
    {
    file.progressBlock = progressBlock;
    file.downloadTimeBlock = downloadTimeBlock;
    file.isCompletedDownloadingBlock = isCompletedDownloadingBlock;
    }
}

#pragma mark - Action Method
-(void) pauseForIndex:(NSInteger) index{
    DownloadFile* file = [self.downloadFiles objectAtIndex:index];
    [file.downloadTask suspend];
}

-(void) startForIndex:(NSInteger) index{
    DownloadFile* file = [self.downloadFiles objectAtIndex:index];
    [file.downloadTask resume];
}
-(void) removeDownloadFileAtIndex:(NSInteger) index
{
    DownloadFile* file = [self.downloadFiles objectAtIndex:index];
    if (file)
    {
        [file.downloadTask cancel];
        [self.downloadFiles removeObject:file];
    }
}
-(void) cancelForIndex:(NSInteger) index{
    DownloadFile* file = [self.downloadFiles objectAtIndex:index];
    [file.downloadTask cancel];
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    

DownloadFile * file = [self getFileForTaskIndetifier:downloadTask.taskIdentifier];
   
    if (file) {
        CGFloat progress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            NSLog(@"Progres # %f.2 #, Name:%@ ***",progress, file.titleName );
            NSString* totalMbWritten = [self convertSizeToMB:totalBytesWritten];
            NSString* totalMbExpectedToWrite = [self convertSizeToMB:totalBytesExpectedToWrite];
           if(file.progressBlock)
           {
               file.progressBlock(progress,totalMbWritten,totalMbExpectedToWrite);
           }
                });
    NSString* time = [self timeForDownloadFile:file
                             totalBytesWritten:totalBytesWritten
                     totalBytesExpectedToWrite:totalBytesExpectedToWrite];

          if (file.downloadTimeBlock) {
           dispatch_async(dispatch_get_main_queue(), ^(void) {
                if (file.downloadTimeBlock) {
                    file.downloadTimeBlock((NSString*)time);
                }
             });
         }       
   }

}
- (NSString*)timeForDownloadFile:(DownloadFile *)file
               totalBytesWritten:(int64_t)totalBytesWritten
       totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
        
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:file.dateStartDownload];
    
    CGFloat speed = (CGFloat)totalBytesWritten / (CGFloat)timeInterval;
    NSInteger remainedBytes = totalBytesExpectedToWrite - totalBytesWritten;
    NSInteger remainedTimeSecond =  remainedBytes / speed;
    
        NSInteger seconds = remainedTimeSecond % 60;
        NSInteger minutes = (remainedTimeSecond / 60) % 60;
        NSInteger hours = remainedTimeSecond / 3600;
        
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
 
}
    

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {

    
    DownloadFile * file = [self getFileForTaskIndetifier:downloadTask.taskIdentifier];

    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *destinationFilename = downloadTask.originalRequest.URL.lastPathComponent;
    NSURL *destinationURL = [[self getDirectoryUrlPath] URLByAppendingPathComponent:destinationFilename];
    
    if ([fileManager fileExistsAtPath:[destinationURL path]]) {
        [fileManager removeItemAtURL:destinationURL error:nil];
    }
    
    BOOL success = [fileManager copyItemAtURL:location
                                        toURL:destinationURL
                                        error:&error];
    
    if (success)
    {
        file.dateCompletDownload = [NSDate date];
        file.statusCompleted = @"Successfully";
        if (file.isCompletedDownloadingBlock) {
            NSLog(@"%@", location);
            dispatch_async(dispatch_get_main_queue(), ^(void){
                file.isCompletedDownloadingBlock(success);

        });
            
            
    }
        else
        {
            file.statusCompleted = @"Fail";
        }
       
        [self setToCoreData:file];
    }
    
}



-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
    NSString * massage = nil;
    if (error) {
        massage = [NSString stringWithFormat:@"Error: %@", [error localizedDescription]];
    }
    else{
       
        massage = @"Successfully";
    }
   
        [self callCompletionHandlerIfFinished];
}

    - (NSURL *)getDirectoryUrlPath {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *getDirectory = [paths objectAtIndex:0];
        NSURL *getDirectoryUrl = [NSURL fileURLWithPath:getDirectory];
        return getDirectoryUrl;
    }


- (void)callCompletionHandlerIfFinished
{
    NSLog(@"call completion handler");
    [self.session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        NSUInteger count = [dataTasks count] + [uploadTasks count] + [downloadTasks count];
        if (count == 0) {
           
            NSLog(@"all tasks ended");
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            if (appDelegate.backgroundTransferCompletionHandler == nil) return;
            void (^comletionHandler)() = appDelegate.backgroundTransferCompletionHandler;
            appDelegate.backgroundTransferCompletionHandler = nil;
            comletionHandler();
        }
    }];
}

#pragma mark - Other Method

-(DownloadFile*)getFileForTaskIndetifier:(NSInteger)downloadTask
{
    
    for (int i = 0; i < [self.downloadFiles count]; ++i)
    {
        DownloadFile* download = [self.downloadFiles objectAtIndex:i];
        {
            if (download.downloadTask.taskIdentifier == downloadTask)
            {
                return download;
            }
        }
    }
    return nil;
}

-(NSString*) convertSizeToMB:(int64_t) size
{
    const CGFloat oneMb = 1000000.f;
    CGFloat resultInMB = (CGFloat)size/oneMb;
    return [NSString stringWithFormat:@"%.2f Mb", resultInMB];
}

@end
