//
//  CurrentFeeds.swift
//  mcr-team
//
//  Created by LIKIT on 2/3/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class CurrentFeeds {
    
        
    var username_login: String!
    var password_login : String!
    var filetoken_login: String!
    
    var _title: String!
    var _fullname: String!
    var _desc: String!
    var _lat: String!
    var _lon: String!
    var _id: Int!
    var _profileImg: String!
    var _name: String!
    var _nametype: String!
    var _updateTime:String!
    var _team: String!
    var _titleImg: String!

    
    
    //*
    var image : UIImage?
    
    
    
    
    var _error: String!
    var _errorCheck = false
    
    
    var error: String {
        if _error == nil {
            _error = "ไม่มีข้อมุล"
        }
        return _error
    }
    var title1: String {
        if _title == nil {
            _title = ""
        }
        debugPrint(_title)
        return _title
    }
    
    var fullname: String {
        if _fullname == nil {
            _fullname = ""
        }
        
        return _fullname
    }
    
    
    var desc: String {
        if _desc == nil {
            _desc = ""
        }
        
        return _desc
    }
    
    var lat: String {
        if _lat == nil {
            _lat = ""
        }
        
        return _lat
    }
    var lon: String {
        if _lon == nil {
            _lon = ""
        }
        
        return _lon
    }

    var id: Int {
        if _id == nil {
            _id = 0
        }
        
        return _id
    }
    
    var profileImg: String {
        if _profileImg == nil {
            _profileImg = ""
        }
        
        return _profileImg
    }
    
    
    var name: String {
        if _name == nil {
            _name = ""
        }
        debugPrint(_name)
        return _name
    }
    
    var nameType: String {
        if _nametype == nil {
            _nametype = ""
        }
        return _nametype
    }
    
    var team: String {
        if _team == nil {
            _team = ""
        }
        return _team
    }
    
    var updateTime1: String {
        if _updateTime == nil {
            _updateTime = ""
        }
        return _updateTime
    }
    
    var titleImg: String {
        if _titleImg == nil {
            _titleImg = ""
        }
        return _titleImg
    }
    
    
    init(FeedsDict: Dictionary<String, AnyObject>) {
    
        
        if let title1 = FeedsDict["Title"] as? String {
            self._title = title1.capitalized
            
        }
        
        if let desc1 = FeedsDict["Desc"] as? String {
            self._desc = desc1.capitalized
            
        }
        
        if let fullname1 = FeedsDict["FullName"] as? String {
            self._fullname = fullname1.capitalized
            //print("debug : fullname = \(self._fullname)")
            
        }
        
        if let updatetime1 = FeedsDict["UpdateTime"] as? String {
            self._updateTime = updatetime1.capitalized
            //print("debug : updateTime = \(self._updateTime)")
        
        }
        
        if let id1 = FeedsDict["ID"] as? Int {
            self._id = id1
            //print("debug : updateTime = \(self._updateTime)")
            
        }
        
        if let profileimage1 = FeedsDict["ProfileImage"] as? String {
            self._profileImg = profileimage1
            print("debug : profile image = \(self._profileImg)")
            
            
        }
        
        if let temp = FeedsDict["Attachments"] as? [Dictionary<String,AnyObject>] {
        
            if temp.count > 0 {
                if let image1 = temp[0]["FileName"] as? String {
                    
                    self._titleImg = image1
                    print("debug : image title = \(self._titleImg)")
                    
                }
            }
            
        }
        
       
        
        
    }
}


