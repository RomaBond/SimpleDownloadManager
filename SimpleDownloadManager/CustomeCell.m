//
//  DownloadTableCell.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import "CustomeCell.h"
#import "AppDelegate.h"
#import "DownloadManager.h"
@interface CustomeCell()

@end

@implementation CustomeCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}

- (IBAction)startOrPauseDownloadButton:(UIButton *)sender {
    sender.enabled = NO;
    self.pauseButton.enabled = YES;
    [self.downloadManager startForIndex:(self.index)];
 
}


- (IBAction)pauseDownloadButton:(UIButton *)sender {
    sender.enabled = NO;
    self.downloadButton.enabled = YES;
    [self.downloadManager pauseForIndex:(self.index)];
}

-(void) showInfo
{
    DownloadFile *file=[self.downloadManager.downloadFiles objectAtIndex:self.index];
    self.titleName.text = file.titleName;
    
    [self.downloadManager downlodInfoForIndex:self.index
     
    progressBlock:^(CGFloat progress, NSString* write,NSString* total) {
        
        self.downloadProgress.progress = progress;
        self.progressLable.text =[NSString stringWithFormat:@"%@ / %@", write,total];
    }
    downloadTimeBlock:^(NSString* time){
        self.timeLable.text=time;
    }
    isCompletedDowloadindBlock:^(BOOL isCompleted) {
                                            
                       
        if(isCompleted)
            {
                self.progressLable.text = @"Ready";
            }
                       else
                       {
                         self.progressLable.text = @"Error";
                       }
        self.downloadProgress.hidden = YES;
        self.downloadButton.enabled =NO;
        self.pauseButton.enabled = NO;
                   }];
}


@end
