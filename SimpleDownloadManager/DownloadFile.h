//
//  DownloadFIle.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^downloadProgressBlock)(CGFloat progress, NSString* write, NSString* total);
typedef void(^isCompletedDownloadingBlock)(BOOL isCompleted);
typedef void(^downloadTimeBlock)(NSString* time);

@interface DownloadFile : NSObject

@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (strong, nonatomic) NSString  *fileName;
@property (strong, nonatomic) NSURL     *url;
@property (strong, nonatomic) NSDate    *dateStartDownload;
@property (strong, nonatomic) NSDate    *dateCompletDownload;
@property (strong, nonatomic) NSString  *statusCompleted;


@property (copy,nonatomic) downloadProgressBlock progressBlock;
@property (copy,nonatomic) isCompletedDownloadingBlock isCompletedDownloadingBlock;
@property (copy,nonatomic) downloadTimeBlock downloadTimeBlock;

-(instancetype) initWithFileName:(NSString*)fileName
                       urlString:(NSString*)urlString;
@end
