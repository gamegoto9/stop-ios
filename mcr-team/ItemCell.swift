//
//  ItemCell.swift
//  core_data_full
//
//  Created by LIKIT on 1/27/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Kingfisher
import UIKit

class ItemCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var dDate: UILabel!
    
    @IBOutlet weak var note: UILabel!
    
    @IBOutlet weak var status: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    
    func configureCell(currentFeeds: CurrentFeeds) {
        
        name.text = currentFeeds.fullname
        dDate.text = currentFeeds.updateTime1
        note.text = currentFeeds.desc
        status.text = currentFeeds.title1
        
        let path = "http://www.mcr-team.m-society.go.th/api/upload/profile/"
        
        var url = URL(string: "\(path)\(currentFeeds._profileImg!)")
        
        url = URL(string: "http://www.mcr-team.m-society.go.th/api/upload/profile/59778F2B-3D0C-BF48-0341-C7B18C531CFB.jpg")
        
        debugPrint("\(path)\(currentFeeds._profileImg!)")
        imgView.kf.setImage(with: url)
        
//        title.text = item.title
//        price.text = "$\(item.price)"
//        details.text = item.details
        
//        thumb.image = item.toImage?.image as? UIImage
        
    }
    
}
