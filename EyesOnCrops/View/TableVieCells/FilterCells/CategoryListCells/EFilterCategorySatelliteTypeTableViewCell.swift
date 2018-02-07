//
//  EFilterCategorySatelliteTypeTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 2/6/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterCategorySatelliteTypeTableViewCell: UITableViewCell {

    
    @IBOutlet weak var switchAqua: UISwitch!
    
    
    
    @IBOutlet weak var switchTerra: UISwitch!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
