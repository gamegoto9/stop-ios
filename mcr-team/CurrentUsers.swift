//
//  CurrentUsers.swift
//  mcr-team
//
//  Created by LIKIT on 2/2/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class CurrentUsers: UIViewController {
    
    var login: Login!
    
    var username_login: String!
    var password_login : String!
    
    var fullname_login : String!
    var email_login : String!
    
    var filetoken_login: String!
    
    var verifytype_login: Int!
    var userType_login: Int!
    
    var _username: String!
    var _fullname: String!
    var _tel: String!
    var _email: String!
    var _id: Int!
    var _profileImg: String!
    var _teamId: Int!
    var _usertype: Int!
    var _verifytype: Int!
    var _filebasetoken: String!
    var _error: String!
    var _errorCheck = false
    
    
    var error: String {
        if _error == nil {
            _error = "ไม่มีข้อมุล"
        }
        return _error
    }
    var username: String {
        if _username == nil {
            _username = ""
        }
        
        return _username
    }
    
    var fullname: String {
        if _fullname == nil {
            _fullname = ""
        }
        
        return _fullname
    }
    
    
    var tel: String {
        if _tel == nil {
            _tel = ""
        }
        
        return _tel
    }
    
    var email: String {
        if _email == nil {
            _email = ""
        }
        
        return _email
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
    var teamId: Int {
        if _teamId == nil {
            _teamId = 0
        }
        
        return _teamId
    }
    var userType: Int {
        if _usertype == nil {
            _usertype = 0
        }
        
        return _usertype
    }
    
    var verifytype: Int {
        if _verifytype == nil {
            _verifytype = 0
        }
        
        return _verifytype
    }
    var filebaseToken: String {
        if _filebasetoken == nil {
            _filebasetoken = ""
        }
        
        return _filebasetoken
    }
    
    var setUsername : String! {
        set(newData){
            username_login = newData
            print("debug: \(username_login)")
        }
        get{
            return username_login
        }
    }
    
    var setPassword : String! {
        set(newData){
            password_login = newData
            print("debug: \(password_login)")
        }
        get{
            return password_login
        }
    }
    
    var setFirebaseToken : String! {
        set(newData){
            filetoken_login = newData
            print("debug: \(filetoken_login)")
        }
        get{
            return filetoken_login
        }
    }
    
    var setFullname : String! {
        set(newData){
            fullname_login = newData
            print("debug: \(fullname_login)")
        }
        get{
            return fullname_login
        }
    }
    var setEmail : String! {
        set(newData){
            email_login = newData
            print("debug: \(email_login)")
        }
        get{
            return email_login
        }
    }
    
    var setVerifyType : Int! {
        set(newData){
            verifytype_login = newData
            print("debug: \(verifytype_login)")
        }
        get{
            return verifytype_login
        }
    }
    
    var setUerType : Int! {
        set(newData){
            userType_login = newData
            print("debug: \(userType_login)")
        }
        get{
            return verifytype_login
        }
    }

    
    
    func downloadWeatherDelails(completed: @escaping DownloadComplete){
        
        //Alamofire download


        
        let loginURL = URL(string: URL_LOGIN)!
        
        
        print("debug: username_ \(username_login)")
        
        
        
        let postString = ["UserName" : username_login,
                          "Password": password_login,
                          "FirebaseToken":filetoken_login]
        
        
        
        Alamofire.request(loginURL, method: HTTPMethod.post, parameters: postString,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let error = dict["error"] as? String {
                            self._error = error.capitalized
                            self._errorCheck = true
                            
                            
                            print("debug : error = \(self._error)")
                            
                        }else{
                            
                            if let fullname = dict["FullName"] as? String {
                                self._fullname = fullname.capitalized
                                print("debug : name = \(self._fullname)")
                                
                            }
                            if let email = dict["Email"] as? String {
                                self._email = email.capitalized
                                print("debug : email = \(self._email)")
                                
                            }
                            if let firebasetoken = dict["FirebaseToken"] as? String {
                                self._filebasetoken = firebasetoken.capitalized
                                print("debug : firebase = \(self._filebasetoken)")
                                
                            }
                            if let colume1 = dict["ID"] as? Int {
                                self._id = colume1
                                print("debug: id \(self._id)")
                                
                                
                            }else{
                                print("debug: id nil")
                            }
                            if let colume = dict["ProfileImage"] as? String {
                                self._profileImg = colume.capitalized
                                ProfileImage2 = colume
                                ProfileImage = colume
                                
                                
                            }
                            if let colume = dict["TeamID"] as? Int {
                                self._teamId = colume
                                
                                
                            }
                            if let colume = dict["TelephoneNumber"] as? String {
                                self._tel = colume.capitalized
                                
                                
                            }
                            if let colume = dict["UserName"] as? String {
                                self._username = colume.capitalized
                                
                                
                            }
                            if let colume = dict["UserType"] as? Int {
                                self._usertype = colume
                                
                                
                            }
                            if let colume = dict["VerifyType"] as? Int {
                                self._verifytype = colume
                                
                                
                            }
                        }
                        
                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                //self.alert()
                self._error = "เกิดข้อผิดพลาดในการเชื่อมต่อ"
                self._errorCheck = true

                completed()
                break
            }


        }
        
        
        
//            Alamofire.request(currentWeatherURL, method: HTTPMethod.get).responseJSON{
//                response in
//                let result = response.result
//                
//                print(response)
//                
//                if let dict = result.value as? Dictionary<String, AnyObject> {
//                    
//                    if let name = dict["name"] as? String {
//                        self._cityName = name.capitalized
//                        print(self._cityName)
//                        
//                    }
//                    
//                    if let weather = dict["weather"] as? [Dictionary<String,AnyObject>]{
//                        
//                        if let main = weather[0]["main"] as? String {
//                            self._weatherType = main.capitalized
//                            print(self._weatherType)
//                        }
//                    }
//                    
//                    
//                    if let main = dict["main"] as? Dictionary<String,AnyObject>{
//                        if let currentTemperature = main["temp"] as? Double {
//                            let kelvinTofFarenheitPreDivision = (currentTemperature * (9/5) - 459.67)
//                            let kelvinToFrenheit = Double(round(10 * kelvinTofFarenheitPreDivision/10))
//                            
//                            self._currentTemp = kelvinToFrenheit
//                            print(self._currentTemp)
//                        }
//                    }
//                    
//                }
//                
//                completed()
//            }
        
    }
    
    func alert(){
        // create the alert
        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
//    Login With Google
    func downloadWeatherDelailsGoogle(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        
        let loginURL = URL(string: URL_LOGIN_GOOGLE)!
        
        debugPrint("\(filetoken_login)")
        
        
        
        var postString: [String: Any]
        
        if(VerifyType == 0){
        
            postString = ["FullName" : fullname_login,
                          "FirebaseToken": filetoken_login,
                          "Email":email_login,
                          "UserName":email_login,
                          "UserType":"3",
                          "VerifyType":"2"
                          ]
        }else{
            postString = ["FirebaseToken": filetoken_login,
                          "Email":email_login,
                          "UserName":username_login,
                          "VerifyType":""
            ]
        }
        
        
        Alamofire.request(loginURL, method: HTTPMethod.post, parameters: postString,encoding: JSONEncoding.default, headers: nil).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let error = dict["error"] as? String {
                            self._error = error.capitalized
                            self._errorCheck = true
                            
                            
                            print("debug : error = \(self._error)")
                            
                        }else{
                            
                            if let fullname = dict["FullName"] as? String {
                                self._fullname = fullname.capitalized
                                print("debug : name = \(self._fullname)")
                                
                            }
                            if let email = dict["Email"] as? String {
                                self._email = email.capitalized
                                print("debug : email = \(self._email)")
                                
                            }
                            if let firebasetoken = dict["FirebaseToken"] as? String {
                                self._filebasetoken = firebasetoken.capitalized
                                print("debug : firebase = \(self._filebasetoken)")
                                
                            }
                            if let colume1 = dict["ID"] as? Int {
                                self._id = colume1
                                print("debug: id \(self._id)")
                                
                                
                            }else{
                                print("debug: id nil")
                            }
                            
                            
                            if let colume = dict["UserName"] as? String {
                                self._username = colume.capitalized
                                
                                
                            }
                            if let colume = dict["UserType"] as? Int {
                                self._usertype = colume
                                
                                
                            }
                            if let colume = dict["VerifyType"] as? Int {
                                self._verifytype = colume
                                
                                
                            }
                            
                            if let colume = dict["ProfileImage"] as? String {
                                ProfileImage = colume
                                ProfileImage2 = colume
                                
                            }else{
                                ProfileImage = "default.png"
                                ProfileImage2 = "user.png"
                            }
                            
                            if let colume = dict["TeamID"] as? Int {
                                self._teamId = colume
                                
                            }else{
                                self._teamId = 0
                            }
                        }
                        
                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                self._error = "Network Connected error"
                self._errorCheck = true
                
                completed()
                self.alert()
                break
            }
            
            
        }
        
        
        
        
    }
    
    
}
