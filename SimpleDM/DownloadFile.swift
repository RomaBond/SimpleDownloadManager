//
//  DownloadFile.swift
//  SimpleDM
//
//  Created by Sam on 11/21/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit

typealias downloadProgressBlock = (Float,String)->()
typealias isCompletedDownloadingBlock = (Bool)->();
typealias downloadTimeBlock = (String)->();


class DownloadFile: NSObject {
    
    internal var downloadTask:URLSessionDownloadTask?;
    
    let titleName:String!;
    let url:URL!;
    
     var dateStartDownload:NSDate?;
     var dateCompletDownload:NSDate?;
     var statusCompleted:String?;
    
     var isInit = false
    
    var progressBlock:downloadProgressBlock?;
    var isCompletedDownloadingBlock:isCompletedDownloadingBlock?;
    var downloadTimeBlock:downloadTimeBlock?;

    
    init (titleName:String, urlString:String)
    {
        self.titleName = titleName;
        self.url = URL(string: urlString)!;
    
    }
    
   
}
