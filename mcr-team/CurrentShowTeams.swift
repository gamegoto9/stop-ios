//
//  CurrentShowTeams.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation

class CurrentShowTeams {
    var _countSum: Int!
    var _countryName: String!
    var _teamName: String!
    var _id: Int!
    
    var id: Int {
        if _id == nil {
            _id = 0
        }
        return _id
    }
    
    var countSum: Int {
        if _countSum == nil {
            _countSum = 0
        }
        return _countSum
    }
    
    var countryName: String {
        if _countryName == nil {
            _countryName = ""
        }
        return _countryName
    }
    
    var teamName: String {
        if _teamName == nil {
            _teamName = ""
        }
        return _teamName
    }
    
    
    init(TeamDict: Dictionary<String, AnyObject>) {
        
        
        var country_lang: String!
        var team_lang: String!
        
        if LANGUAGE == 0{
            country_lang = "CountryNameEN"
            team_lang = "TeamNameEN"
            
        }else{
            country_lang = "CountryNameTH"
            team_lang = "TeamNameTH"
        }
        
        
        if let coluam = TeamDict["MemberCount"] as? Int {
            self._countSum = coluam
            
        }
        
        if let coluam = TeamDict[country_lang] as? String {
            self._countryName = coluam.capitalized
            
        }
        
        if let coluam = TeamDict[team_lang] as? String {
            self._teamName = coluam.capitalized
            
        }
        
        if let coluam = TeamDict["ID"] as? Int {
            self._id = coluam
            
        }
    }

}
