//
//  EFilterCategoryMapTypeOptionTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/16/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterCategoryMapTypeOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var labelMapDetail: UILabel!
    @IBOutlet weak var labelMapHeading: UILabel!
    @IBOutlet weak var switchMapType: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
