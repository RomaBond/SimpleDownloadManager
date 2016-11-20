//
//  AddFileViewController.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/18/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import "AddFileViewController.h"
#import "MainViewController.h"
#import "DownloadManager.h"
@interface AddFileViewController ()<UITextFieldDelegate>

@end

@implementation AddFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.url becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL) isCorectFill {
    
    BOOL isCorect = YES;
        if ([self.url.text isEqualToString:@""] ||
            [self.titleName.text isEqualToString:@""])
                isCorect = NO;
    
    
    return isCorect;
}

-(void)addDownloadFile
{
    NSInteger maxQuantity = self.mainViewController.DM.maxDownloadQuantity ;
    NSInteger quantityNow = [self.mainViewController.DM.downloadFiles count];
    
    if(quantityNow <maxQuantity ){
    [self.mainViewController.DM addDownloadFileForUrl:self.url.text
                                             withName:self.titleName.text];
    [self.mainViewController.table reloadData];
    }
    else
    {
    UIAlertController *alertController = [UIAlertController
                                   alertControllerWithTitle:@"Max quantity"
                                                    message:@"Remove completed downloads"
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController
                           animated:YES
                         completion:nil];
        
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    if ([textField isEqual:self.url]) {
        [self.titleName becomeFirstResponder];

    } else {

        if ([self isCorectFill]) {
            [self.titleName resignFirstResponder];
            self.doneButton.enabled = YES;
        }
    }

       return YES;
}



- (IBAction)doneAction:(id)sender {
    [self addDownloadFile];
    [self.navigationController popToViewController:self.mainViewController
                                          animated:YES];
}
@end
