//
//  UserTableViewCell.swift
//  LocalHost
//
//  Created by Mari Husain on 11/11/17.
//  Copyright © 2017 Mari Husain. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
