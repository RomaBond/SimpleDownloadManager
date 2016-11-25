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
    let URL2 = "http://cdimage.debian.org/debian-cd/8.6.0/amd64/iso-dvd/debian-8.6.0-amd64-DVD-1.iso"
    let URL3 = "https://www.google.com.ua/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwid-afura7QAhVJVSwKHUSjAFoQFggZMAA&url=https%3A%2F%2Fwww.tutorialspoint.com%2Fios%2Fios_tutorial.pdf&usg=AFQjCNF16ShFVH5ggXdImtKEpPlq21nVmg&sig2=MZl3l_drGLAn_SffES5uzw"

    
    
    
    
    @IBOutlet weak var table: UITableView!
    var downloadManager = DownloadManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        downloadManager.addDownloadFileForUrl(urlString: URL, withName: "1")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1;
    }

    func tableView(_ tableView: UITableView,
 numberOfRowsInSection section: Int) -> Int {
        return downloadManager.downloadFiles.count;
      //  return 1;
    }

   
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CustomDownloadCell = tableView.dequeueReusableCell(withIdentifier: "downloadCell")as! CustomDownloadCell
        
        cell.manager = self.downloadManager
        cell.index = indexPath.row
        cell.showInfo()
        return cell;
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
