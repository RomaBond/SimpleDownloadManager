//
//  DownloadTableCell.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadFile.h"
#import "DownloadManager.h"
@interface CustomeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *progressLable;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;



@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress;

@property (weak, nonatomic) DownloadManager* downloadManager;
@property (nonatomic)NSInteger index;

-(void) showInfo;

- (IBAction)startOrPauseDownloadButton:(UIButton *)sender;
- (IBAction)stopDownloadButton:(UIButton *)sender;


@end
