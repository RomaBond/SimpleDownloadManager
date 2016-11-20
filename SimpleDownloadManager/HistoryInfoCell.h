//
//  HistoryInfoCell.h
//  SimpleDownloadManager
//
//  Created by Sam on 11/18/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *dateStartDownload;
@property (weak, nonatomic) IBOutlet UILabel *dateFinisedDownload;
@property (weak, nonatomic) IBOutlet UILabel *status;


@end
