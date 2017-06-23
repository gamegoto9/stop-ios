//
//  ImagePostCollectionViewCell.swift
//  mcr-team
//
//  Created by LIKIT on 3/11/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Kingfisher
class ImagePostCollectionViewCell: UICollectionViewCell {
    
    var _image: String!
    
    var image : String! {
        get {
            return _image
        }
        set {
            _image = newValue
            
            debugPrint(_image)
            
            updateUI(linkImg: _image)
        }
    }
    
    @IBOutlet weak var imagePost_1: UIImageView!
    
    
    func updateUI(linkImg: String!) {
        
       let url = URL(string: linkImg)!
        
        debugPrint(url)
        
        imagePost_1.kf.setImage(with: url)
        
    }
}
