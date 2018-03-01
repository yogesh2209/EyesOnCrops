//
//  EFilterLevelListOptionTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 2/7/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterLevelListOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCheckMark: UIImageView!
    @IBOutlet weak var labelOption: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

