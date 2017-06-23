//
//  ImageCollectionViewCell.swift
//  mcr-team
//
//  Created by LIKIT on 2/4/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    var image : UIImage! {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
   
    @IBOutlet weak var imageView1: UIImageView!
    
    @IBOutlet weak var image_post: UIImageView!
    
    
   
    
    
    
    func updateUI() {
        
        imageView.image = self.image
        imageView1.image = self.image
        
        image_post.image = self.image
       
        
    }
    
}
