//
//  DownloadManager.swift
//  SimpleDM
//
//  Created by Sam on 11/21/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit
import CoreData


class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate{
    

  
    // MARK: Default initialization
    
     var downloadFiles = NSMutableArray()
     let maxDownloadQuantity = 7
    
      lazy  var downloadSession:URLSession =
        {
            
            struct SessionProperties{
            static let identifier:String! = "myBackgroundSession";
                        }
            
            let sessionConfig = URLSessionConfiguration.background(
                withIdentifier:SessionProperties.identifier)
//            sessionConfig.timeoutIntervalForRequest = 0
//            sessionConfig.timeoutIntervalForResource = 0
    
            return URLSession(configuration: sessionConfig,
                                   delegate: self,
                              delegateQueue: nil)
        }()
  
       // MARK: Creat Methods
    
    
    func addDownloadFileForUrl(urlString: String,
                      withName titleName: String)->Void
    {
        let file = DownloadFile(titleName: titleName, urlString: urlString)
        file.dateStartDownload = NSDate()
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
    
    
    // MARK: CoreDate
    
    func seveIntoCoreDate(file: DownloadFile) -> () {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        let task = DownloadEntity(context:context)
        task.titleName = file.titleName;
        task.dateStart = file.dateStartDownload;
        task.dateFinished = file.dateCompletDownload;
        task.finishStaus = file.statusCompleted;
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
   
  // MARK: Action Methods
    
    func startForIndex(index:NSInteger)->Void
    {
       if let file:DownloadFile =
        self.downloadFiles.object(at: index) as? DownloadFile{
        
        file.downloadTask!.resume()
        }
    }
    
    func pauseForIndex(index:NSInteger)->Void
    {
       if let file:DownloadFile =
        self.downloadFiles.object(at: index) as? DownloadFile{
        
        file.downloadTask!.suspend()
        }
    }
    
    func removeDownloadFileAtIndex(index: NSInteger)
    {
        if let file:DownloadFile =
            self.downloadFiles.object(at: index) as? DownloadFile{
         file.downloadTask!.cancel()
         downloadFiles.remove(file)
        }
    }

   // MARK: URLSession
        
        func urlSession(_ session: URLSession,
                     downloadTask: URLSessionDownloadTask,
  didFinishDownloadingTo location: URL)
    {
       
        if let file = getFileForTaskIdentifier(identifier: downloadTask.taskIdentifier)
        {
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
            
        }
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
                
                DispatchQueue.main.async {
                    file.isCompletedDownloadingBlock!(isSeccess)
                }
            
        }
        
        
        file.dateCompletDownload = NSDate();
        file.statusCompleted = isSeccess ? "Successfully" : "Fail"
        seveIntoCoreDate(file:file)
        }
    }

    
    
    
    
    
    
    func urlSession(_ session: URLSession,
                 downloadTask: URLSessionDownloadTask,
    didWriteData bytesWritten: Int64,
            totalBytesWritten: Int64,
    totalBytesExpectedToWrite: Int64){
    
    if let file = getFileForTaskIdentifier(identifier: downloadTask.taskIdentifier)
    {
    let progress = Float(totalBytesWritten)/Float(totalBytesExpectedToWrite)
        
    let written:String = convertSizeToMB(size: totalBytesWritten)
    let total:String = convertSizeToMB(size: totalBytesExpectedToWrite)
    
    let progressStr = String(format: "%@ Mb/%@ Mb",written, total)
        
    let remainedTime:String = timeForDownloadFile(file: file,
                                     totalBytesWritten: totalBytesWritten,
                             totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
            
            DispatchQueue.main.async {
                file.progressBlock!(progress,progressStr)
                file.downloadTimeBlock!(remainedTime)
            }
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
    
    
    
    //MARK: Other Methods
    func convertSizeToMB(size: Int64)->String
    {
        let oneMB:Float = 1000000
        let resultInMB = Float(size)/oneMB
        return String(format: "%.2f", resultInMB)
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
        
        let timeInterval = NSDate().timeIntervalSince(file.dateStartDownload! as Date)
        let speed:NSInteger = NSInteger(totalBytesWritten)/Int (timeInterval)
        
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






