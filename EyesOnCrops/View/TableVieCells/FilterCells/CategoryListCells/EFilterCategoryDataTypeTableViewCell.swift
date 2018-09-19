//
//  EFilterCategoryDataTypeTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/19/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterCategoryDataTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelHeading: UILabel!
    @IBOutlet weak var switchDataType: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
