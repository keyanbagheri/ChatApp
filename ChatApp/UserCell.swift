//
//  UserCell.swift
//  SimpleFirebase
//
//  Created by Max Jala on 12/04/2017.
//  Copyright © 2017 Max Jala. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    static let cellIdentifier = "UserCell"
    static let cellNib = UINib(nibName: UserCell.cellIdentifier, bundle: Bundle.main)
    
    
    @IBOutlet weak var imageViewProfile: UIImageView!
    
    @IBOutlet weak var labelProfileName: UILabel!
    
    @IBOutlet weak var labelProfileStatus: UILabel!
    
    @IBOutlet weak var customView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


