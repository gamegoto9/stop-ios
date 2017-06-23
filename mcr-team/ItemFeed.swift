//
//  ItemFeed.swift
//  mcr-team
//
//  Created by LIKIT on 2/15/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Kingfisher
import UIKit

class ItemFeed: UITableViewCell {
    
    
    @IBOutlet weak var name: UILabel!
        
    @IBOutlet weak var dDate: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imageShow: UIImageView!
    var ID: Int = 0
    
    
    @IBOutlet weak var desc: UILabel!
    
    
    
    func configureCell(currentFeeds: CurrentFeeds) {
        
        name.text = currentFeeds.fullname
        dDate.text = currentFeeds.updateTime1
        //note.text = currentFeeds.desc
        status.text = currentFeeds.title1
        ID = currentFeeds.id
        desc.text = currentFeeds.desc
        
        ProfileImage = currentFeeds.profileImg
        
        var path = "http://www.mcr-team.m-society.go.th/api/upload/profile/"
        
        var url = URL(string: "\(path)\(currentFeeds.profileImg)")
        
        debugPrint(url)
        
        //url = URL(string: "http://www.mcr-team.m-society.go.th/api/upload/profile/59778F2B-3D0C-BF48-0341-C7B18C531CFB.jpg")
        
        
        
        imgView.kf.setImage(with: url)
        
        //        title.text = item.title
        //        price.text = "$\(item.price)"
        //        details.text = item.details
        
        //        thumb.image = item.toImage?.image as? UIImage
        
       path = "http://www.mcr-team.m-society.go.th/api/upload/images/\(ID)/"
        
        debugPrint(path)
        
    
        if(currentFeeds.titleImg == ""){
            url = URL(string: "http://www.mcr-team.m-society.go.th/api/upload/images/default.png")
            debugPrint("\(url)")
        }else{
            url = URL(string: "\(path)\(currentFeeds.titleImg)")
            debugPrint("\(url)")
        }
        
        imageShow.kf.setImage(with: url)
 
        
       
        
    }

}
