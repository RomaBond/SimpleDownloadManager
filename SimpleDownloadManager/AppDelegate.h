//
//  AppDelegate.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <UserNotifications/UserNotifications.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (readonly, strong) NSManagedObjectContext * mainContext;
- (void)saveContext;
@property (nonatomic, copy) void(^backgroundTransferCompletionHandler)();




@end

