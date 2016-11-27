//
//  CustomHistoryCell.swift
//  SimpleDM
//
//  Created by Sam on 11/23/16.
//  Copyright © 2016 Roma. All rights reserved.
//

import UIKit

class CustomHistoryCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel:            UILabel!
    @IBOutlet weak var dateStartLabel:       UILabel!
    @IBOutlet weak var dateFinishedLabel:    UILabel!
    @IBOutlet weak var completedStatusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
