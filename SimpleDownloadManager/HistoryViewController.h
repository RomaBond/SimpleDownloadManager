//
//  HistoryViewController.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/18/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic)  NSMutableArray * downloadInfo;
@end
