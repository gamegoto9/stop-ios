//
//  CurrentShowUsers.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation


class CurrentShowUsers {
    
    var _imgProfile: String!
    var _userName: String!
    var _teamName: String!
    var _id: Int!
    
    var id: Int {
        if _id == nil {
            _id = 0
        }
        return _id
    }
    
    var imgProfile: String {
        if _imgProfile == nil {
            _imgProfile = "user.png"
        }
        return _imgProfile
    }
    
    var userName: String {
        if _userName == nil {
            _userName = ""
        }
        return _userName
    }
    
    var teamName: String {
        if _teamName == nil {
            _teamName = ""
        }
        return _teamName
    }
    
    
    init(UsersDict: Dictionary<String, AnyObject>) {
        
        
        var Name_lang: String!
        
        
        if LANGUAGE == 0{
            Name_lang = "NameEN"
            
            
        }else{
            Name_lang = "NameTH"
            
        }
        
      
        
        
        
        if let coluam = UsersDict["ProfileImage"] as? String {
            self._imgProfile = coluam
            
        }
        
        if let coluam = UsersDict["FullName"] as? String {
            self._userName = coluam.capitalized
            
        }
        
        if let coluam = UsersDict[Name_lang] as? String {
            self._teamName = coluam.capitalized
            
        }
        
        if let coluam = UsersDict["ID"] as? Int {
            self._id = coluam
            
        }
    }
    
    
}
