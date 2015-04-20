//
//  Meme.swift
//  MemeMe
//
//  Created by Andrea Perazzi on 11/04/15.
//  Copyright (c) 2015 Andrea Perazzi. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    // Original elements of meme
    var topText: String?
    var bottomText: String?
    var image: UIImage?
    
    // Combine texts and image
    var memedImage: UIImage?
    
    // Default initialization
    init(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
        
    }
}
