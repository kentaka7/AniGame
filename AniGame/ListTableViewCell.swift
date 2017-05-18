//
//  ListTableViewCell.swift
//  SampleFirebase
//
//  Created by takakura naohiro on 2017/05/18.
//  Copyright © 2017年 GeoMagnet. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var postDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
