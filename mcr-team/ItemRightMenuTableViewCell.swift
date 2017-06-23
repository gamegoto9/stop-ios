//
//  ItemRightMenuTableViewCell.swift
//  mcr-team
//
//  Created by LIKIT on 3/26/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Kingfisher

class ItemRightMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var profileimg: UIImageView!
    
    @IBOutlet weak var username: UILabel!

    @IBOutlet weak var team_name: UILabel!

    
    func configureCell(currentFeeds: CurrentRightMenu) {
        
        self.username.text = currentFeeds.userName
        self.team_name.text = currentFeeds.teamName
        
        let imgfile = String(currentFeeds.imgProfile)!
        
        self.profileimg.layoutIfNeeded()
        self.profileimg.layer.cornerRadius = self.profileimg.bounds.size.height / 2
        self.profileimg.clipsToBounds = true
        self.profileimg.layer.borderWidth = 1
        self.profileimg.layer.borderColor = UIColor.white.cgColor
        
        debugPrint(imgfile)
        

        let url = URL(string: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(imgfile)")!
        
        debugPrint(url)
        
        self.profileimg.kf.setImage(with: url)
        
    }
}
