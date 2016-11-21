//
//  DownloadFIle.m
//  SimpleDownloadManager
//
//  Created by Sam on 11/11/16.
//  Copyright © 2016 Roma. All rights reserved.
//

#import "DownloadFile.h"

@implementation DownloadFile


-(instancetype) initWithTitleName:(NSString*)titleName
                       urlString:(NSString*)urlString;
{
    
        self = [super init];
        if (self) {
            self.titleName  = titleName;
            self.url       = [NSURL URLWithString:urlString];
        }
    return self;
}







@end
