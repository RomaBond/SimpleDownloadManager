//
//  HistoryTableVC.swift
//  SimpleDM
//
//  Created by Sam on 11/23/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit

class HistoryTableVC: UIViewController ,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var table: UITableView!
    var downloadInfo:[DownloadEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDate()
        self.table.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView,
          numberOfRowsInSection section: Int) -> Int {
        //return 2;
        return downloadInfo.count
    }

  
    func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell")as!CustomHistoryCell
        let downloadFileInfo = downloadInfo[indexPath.row]
        
        
        let strDateStart = convertDateToString(date: downloadFileInfo.dateStart!)
        let strDateFinished = convertDateToString(date: downloadFileInfo.dateFinished!)
        
        cell.nameLabel.text = downloadFileInfo.titleName
        cell.dateStartLabel.text = strDateStart
        cell.dateFinishedLabel.text = strDateFinished
        cell.completedStatusLabel.text = downloadFileInfo.finishStaus
        
        return cell
    }
 

    func tableView(_ tableView: UITableView,
                 canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView,
                    commit editingStyle: UITableViewCellEditingStyle,
                     forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let downloadFileInfo = downloadInfo[indexPath.row]
            context.delete(downloadFileInfo)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do{
                downloadInfo = try context.fetch(DownloadEntity.fetchRequest())
            }
            catch{
                print("Error")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        let isEditing = !(self.table.isEditing)
        self.table.setEditing(isEditing, animated: true)
        sender.title = isEditing ? "Done" : "Edit"
        sender.tintColor = isEditing ? UIColor.green : UIColor.red
    }

       // MARK: Other Methods
   
    func getDate()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            downloadInfo = try context.fetch(DownloadEntity.fetchRequest())
        }
        catch{
            print("Error")
        }
        
    }
    
    func convertDateToString (date: NSDate) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let DateInFormat = dateFormatter.string(from: date as Date)
        
        return DateInFormat
    }

}
