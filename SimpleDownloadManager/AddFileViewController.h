//
//  AddFileViewController.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/18/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;
@interface AddFileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *url;
@property (weak, nonatomic) IBOutlet UITextField *titleName;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) MainViewController* mainViewController;

- (IBAction)doneAction:(id)sender;

@end
