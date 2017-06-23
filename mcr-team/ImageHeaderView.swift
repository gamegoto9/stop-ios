//
//  ImageHeaderCell.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/3/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import Kingfisher
import FontAwesome_swift

class ImageHeaderView : UIView {
    
    @IBOutlet weak var profileImage : UIImageView!
    @IBOutlet weak var backgroundImage : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(red: 224, green: 224, blue: 224)
        self.profileImage.layoutIfNeeded()
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.borderWidth = 1
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        
        let path = "http://www.mcr-team.m-society.go.th/api/upload/profile/\(ProfileImage2)"
        let url =  URL(string: "\(path)")
        
        debugPrint(url)
        self.profileImage.kf.setImage(with: url!)
        
        self.backgroundImage.kf.setImage(with: url)
    }
    
  
    
    func downloadWeatherDelails(completed: @escaping DownloadComplete){
        
        self.backgroundColor = UIColor(red: 224, green: 224, blue: 224)
        self.profileImage?.layoutIfNeeded()
        self.profileImage?.layer.cornerRadius = self.profileImage.bounds.size.height / 2
        self.profileImage?.clipsToBounds = true
        self.profileImage?.layer.borderWidth = 1
        self.profileImage?.layer.borderColor = UIColor.white.cgColor
        
        
        let path = "http://www.mcr-team.m-society.go.th/api/upload/profile/\(ProfileImage2)"
        let url =  URL(string: "\(path)")
        
        debugPrint(url)
               DispatchQueue.main.async {
                self.profileImage?.kf.setImage(with: url!)
                
                self.backgroundImage?.kf.setImage(with: url)

            debugPrint("loop in")
        }
    }
    
    
}
