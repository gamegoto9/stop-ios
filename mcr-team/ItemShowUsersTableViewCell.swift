//
//  ItemShowUsersTableViewCell.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Kingfisher
class ItemShowUsersTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var teamName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    
    func configureCell(currentFeeds: CurrentShowUsers) {
        self.userName.text = currentFeeds.userName
        self.teamName.text = currentFeeds.teamName
        
        let imgfile = String(currentFeeds.imgProfile)!
        
        self.imageProfile.layoutIfNeeded()
        self.imageProfile.layer.cornerRadius = self.imageProfile.bounds.size.height / 2
        self.imageProfile.clipsToBounds = true
        self.imageProfile.layer.borderWidth = 1
        self.imageProfile.layer.borderColor = UIColor.white.cgColor
        
        debugPrint(imgfile)
        
        
        let url = URL(string: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(imgfile)")!
        
        debugPrint(url)
        
        self.imageProfile.kf.setImage(with: url)
    }

}
