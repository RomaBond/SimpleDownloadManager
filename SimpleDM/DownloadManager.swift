//
//  DownloadManager.swift
//  SimpleDM
//
//  Created by Sam on 11/21/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit



class DownloadManager: NSObject, URLSessionDownloadDelegate {
    

  

    

    
      lazy  var downloadSession:URLSession =
        {
            
            struct SessionProperties{
            static let identifier:String! = "myBackgroundSession";
                        }
            
            let sessionConfig = URLSessionConfiguration.background(
                withIdentifier:SessionProperties.identifier)
            //sessionConfig.timeoutIntervalForRequest = 0
           // sessionConfig.timeoutIntervalForResource = 0
    
            return URLSession(configuration: sessionConfig,
                                   delegate: self,
                              delegateQueue: nil)
        }()
  
    
    
    
  
    var downloadFiles = NSMutableArray()
    let maxDownloadQuantity = 7
  

    func addDownloadFileForUrl(urlString: String,
                      withName titleName: String)->Void
    {
        let file = DownloadFile(titleName: titleName, urlString: urlString)
        file.dateStartDownload = NSDate()
       // let urlRequest = URLRequest(url:file.url)
        file.downloadTask = self.downloadSession.downloadTask(with: file.url);       downloadFiles.add(file)
    }
    
    func downloadInfoForIndex(index:NSInteger,
                      progressBlocK:@escaping(Float,String)->(),
        isCompletedDownloadingBlock:@escaping(Bool)->(),
                  downloadTimeBlock:@escaping(String)->())
    {
        let file:DownloadFile =
            self.downloadFiles.object(at: index) as! DownloadFile
        
        file.progressBlock = progressBlocK
        file.isCompletedDownloadingBlock = isCompletedDownloadingBlock
        file.downloadTimeBlock = downloadTimeBlock
    }
    
    func startForIndex(index:NSInteger)->Void
    {
        let file:DownloadFile =
            self.downloadFiles.object(at: index) as! DownloadFile
        
        file.downloadTask!.resume()
    }
    
    func pauseForIndex(index:NSInteger)->Void
    {
        let file:DownloadFile =
            self.downloadFiles.object(at: index) as! DownloadFile
        
        file.downloadTask?.suspend()
    }
    
    func removeDownloadFileAtIndex(index: NSInteger)
    {
         let file:DownloadFile =
            self.downloadFiles.object(at: index) as! DownloadFile
        
         downloadFiles.remove(file)
    }

    
    func urlSession(_ session: URLSession,
                         task: URLSessionTask,
   didCompleteWithError error: Error?)
    {
        
        if (error != nil) {
            print("Error")
        }else{
            print("Successfully")
        }
        
        
    }
    
        func urlSession(_ session: URLSession,
                     downloadTask: URLSessionDownloadTask,
  didFinishDownloadingTo location: URL)
    {
        let file = getFileForTaskIdentifier(identifier: downloadTask.taskIdentifier)
        var isSeccess = true
        
        let fileManager = FileManager.default
        let destinationURLForFile:URL = getDirectoryUrlPath()
        
        if fileManager.fileExists(atPath: destinationURLForFile.path)
        {
            print(destinationURLForFile.path)
        }
        else{
            do {
                try fileManager.moveItem(at: location,
                                         to: destinationURLForFile)
               print(destinationURLForFile.path)
            }catch{
                isSeccess = false
            }
        }//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        file?.isCompletedDownloadingBlock!(isSeccess)
        
    }

    
    
    
    
    
    
    func urlSession(_ session: URLSession,
                 downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
            totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64){
    
    let file = getFileForTaskIdentifier(identifier: downloadTask.taskIdentifier)
        
    let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
    let written:String = convertSizeToMB(size: totalBytesWritten)
    let total:String = convertSizeToMB(size: totalBytesExpectedToWrite)
    
    let progressStr = String(format: "%@ Mb/%@ Mb",written, total)
        
    let remainedTime:String = timeForDownloadFile(file: (file)!,
                                     totalBytesWritten: totalBytesWritten,
                             totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
            
            DispatchQueue.main.async {
                file?.progressBlock!(progress,progressStr)
                file?.downloadTimeBlock!(remainedTime)
            }
        }
       }
    
    

    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                DispatchQueue.main.async {
                    completionHandler()
                }
            }
        }
    }
    
    
    
    
    func convertSizeToMB(size: Int64)->String
    {
        let oneMB:Float = 1000000
        let resultInMB = Float(size)/oneMB
        return String(format: "%f.2", resultInMB)
    }
    
    func getFileForTaskIdentifier(identifier: NSInteger)->DownloadFile?
    {
        
        for element in downloadFiles
        {
            if ((element as! DownloadFile).downloadTask?.taskIdentifier == identifier)
            {
                return element as? DownloadFile
            }
        }
      return nil
    }
    
    func getDirectoryUrlPath() -> URL
    {
        let path = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let documentDirectoryPath:String = path[0]
        let getDirectoryUrl:URL = URL(fileURLWithPath:documentDirectoryPath)
        return getDirectoryUrl
    }
    
    func timeForDownloadFile(file:DownloadFile,
                totalBytesWritten:Int64 ,
        totalBytesExpectedToWrite:Int64)->String    {
        let timeInterval = 10//TimeInterval = NSDate.timeIntervalSince(file.dateStartDownload!)
        
        let speed:NSInteger = NSInteger(totalBytesWritten)/NSInteger(timeInterval)
        
        let remainedBytes:NSInteger = totalBytesExpectedToWrite - totalBytesWritten
        let remainedTimeSecond:NSInteger =  remainedBytes / NSInteger(speed)
        
        
        return convertTimeToString(time: remainedTimeSecond)
        
    }
    
    func convertTimeToString(time: NSInteger)->String
    {
        let seconds:NSInteger = time % 60;
        let minutes:NSInteger = (time / 60) % 60;
        let hours:NSInteger = time / 3600;
        return String(format: "%02ld:%02ld:%02ld", hours, minutes,seconds)
    }
  
 
}






