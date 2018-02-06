//
//  EFilterCategoryListOptionTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 2/5/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterCategoryListOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelOption: UILabel!
    
    
    @IBOutlet weak var labelSelectedOption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
