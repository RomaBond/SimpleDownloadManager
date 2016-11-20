//
//  MainViewController.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/17/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadManager;
@interface MainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)editAction:(UIBarButtonItem *)sender;


@property (strong, nonatomic) DownloadManager * DM;
@property (weak, nonatomic) IBOutlet UITableView *table;
@end
