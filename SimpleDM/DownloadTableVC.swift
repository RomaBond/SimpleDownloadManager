//
//  DownloadTableVC.swift
//  SimpleDM
//
//  Created by Sam on 11/21/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit




class DownloadTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate  {

    let URL = "http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-cd/debian-8.6.0-amd64-CD-1.iso"
    
//    let URL2 = "http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-dvd/debian-8.6.0-amd64-DVD-1.iso"
    let URL3 = "https://www.google.com.ua/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwid-afura7QAhVJVSwKHUSjAFoQFggZMAA&url=https%3A%2F%2Fwww.tutorialspoint.com%2Fios%2Fios_tutorial.pdf&usg=AFQjCNF16ShFVH5ggXdImtKEpPlq21nVmg&sig2=MZl3l_drGLAn_SffES5uzw"

    
    
    
    
    @IBOutlet weak var table: UITableView!
    var downloadManager = DownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadManager.addDownloadFileForUrl(urlString: URL, withName: "1")
        downloadManager.addDownloadFileForUrl(urlString: URL3, withName: "2")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }

    func tableView(_ tableView: UITableView,
 numberOfRowsInSection section: Int) -> Int {
        return downloadManager.downloadFiles.count;
    }

   
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell:CustomDownloadCell = tableView.dequeueReusableCell(withIdentifier: "downloadCell")as! CustomDownloadCell
        
       let file = downloadManager.downloadFiles[indexPath.row]as!DownloadFile
        
       if (!file.isInit)
       {
        cell.nameLable.text = file.titleName
        cell.progressBar.progress = 0
        cell.timeLable.text = "Time"
        cell.mbLable.text = "MB"
        cell.downloadButton.isEnabled = true
        cell.pauseButton.isEnabled = false
        file.isInit = true
       }
        
        cell.index = indexPath.row
        cell.manager = self.downloadManager
        cell.showInfo()
        return cell;
    }
    

    
     func tableView(_ tableView: UITableView,
                 canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    
     func tableView(_ tableView: UITableView,
            commit editingStyle: UITableViewCellEditingStyle,
             forRowAt indexPath: IndexPath) {
        
       
        if editingStyle == .delete {
            downloadManager.removeDownloadFileAtIndex(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
           
        }
    }


    @IBAction func edditAction(_ sender: UIBarButtonItem) {
        let isEditing = !(self.table.isEditing)
        self.table.setEditing(isEditing, animated: true)
        sender.title = isEditing ? "Done" : "Edit"
        sender.tintColor = isEditing ? UIColor.green : UIColor.red
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier?.isEqual("addDownloadFile"))!
        {
          
          let  addDownloadFile = segue.destination as! AddFileVC
          addDownloadFile.downloadTableVC = self
        }
    }
    
    
   }
