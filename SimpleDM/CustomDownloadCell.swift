//
//  DownloadCustomCell.swift
//  SimpleDM
//
//  Created by Sam on 11/21/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit

class CustomDownloadCell: UITableViewCell {


    var index: NSInteger?
    var manager: DownloadManager?
    
    
    @IBOutlet weak var progressBar:     UIProgressView!
    @IBOutlet weak var downloadButton:  UIButton!
    @IBOutlet weak var pauseButton:     UIButton!
    @IBOutlet weak var timeLable:       UILabel!
    @IBOutlet weak var mbLable:         UILabel!
    @IBOutlet weak var nameLable:       UILabel!
   
    func changeEnable()
    {
         downloadButton.isEnabled = !downloadButton.isEnabled
         pauseButton.isEnabled =    !pauseButton.isEnabled
    }
    
    @IBAction func pauseAction(_ sender: AnyObject) {
        changeEnable()
       manager?.pauseForIndex(index: index!)
    }
    @IBAction func downloadAction(_ sender: AnyObject) {
        changeEnable()
        manager?.startForIndex(index: index!)
    }
    func showInfo()
    {
        manager?.downloadInfoForIndex(index: index!,
        progressBlocK: { (progress, progressStr) in
            self.progressBar.progress = progress
            self.mbLable.text = progressStr
            },
        isCompletedDownloadingBlock: { (isCompleted) in
               self.mbLable.text = isCompleted ? "Ready" : "Fail"
            })
        { (time) in
            self.timeLable.text = time;
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
