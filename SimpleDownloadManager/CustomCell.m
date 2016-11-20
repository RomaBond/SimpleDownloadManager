//
//  DownloadTableCell.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import "DownloadTableCell.h"
#import "AppDelegate.h"
#import "DownloadManager.h"
@interface DownloadTableCell()

@end

@implementation DownloadTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
}

- (IBAction)startOrPauseDownloadButton:(UIButton *)sender {
    [self.downloadManager startForIndex:(self.index)];
    
    
    
}


- (IBAction)stopDownloadButton:(UIButton *)sender {
    [self.downloadManager pauseForIndex:(self.index)];
}

-(void) showInfo
{
    DownloadFile *file=[self.downloadManager.downloadFiles objectAtIndex:self.index];
    self.titleName.text = file.fileName;
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
                self.downloadProgress.hidden = YES;
                self.progressLable.text = @"Ready";
            }
                       else
                       {
                          
                       }
                       
                   }];
}


@end
