//
//  ESideMenuProfileTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 12/20/17.
//  Copyright © 2017 Yogesh Kohli. All rights reserved.
//

import UIKit

class ESideMenuProfileTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelMemberSince: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
