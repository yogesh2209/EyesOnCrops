//
//  EFilterColorSchemeOptionTableViewCell.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/24/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import UIKit

class EFilterColorSchemeOptionTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewCheckmark: UIImageView!
    @IBOutlet weak var imageViewColorScheme: UIImageView!
    @IBOutlet weak var labelSchemeName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
