//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Andrea Perazzi on 18/04/15.
//  Copyright (c) 2015 Andrea Perazzi. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    
    @IBOutlet var topText: UILabel!
    
    @IBOutlet var bottomText: UILabel!
    
    @IBOutlet var originalImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
