//
//  DownloadManager.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/13/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DownloadFile;

@interface DownloadManager : NSObject
@property (strong, nonatomic) NSMutableArray *downloadFiles;
@property (readonly,nonatomic)  NSInteger maxDownloadQuantity ;
-(void) addDownloadFileForUrl:(NSString *)urlString
                     withName:(NSString *)fileName;

-(void) downlodInfoForIndex:(NSInteger) index
              progressBlock:(void(^)(CGFloat progress, NSString* write, NSString* total))progressBlock
          downloadTimeBlock:(void(^)(NSString* time))downloadTimeBlock
 isCompletedDowloadindBlock:(void(^)(BOOL isCompleted))isCompletedDownloadingBlock;

-(void) startForIndex: (NSInteger) index;
-(void) pauseForIndex: (NSInteger) index;
-(void) cancelForIndex:(NSInteger) index;

-(void) removeDownloadFileAtIndex:(NSInteger) index;

- (instancetype)initSession;

@end
