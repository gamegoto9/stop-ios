//
//  LogOutVC.swift
//  mcr-team
//
//  Created by LIKIT on 3/12/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftOverlays

class LogOutVC: UIViewController {

    var ID: Int16!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func logOut(){
        debugPrint("Log OUT")
        SwiftOverlays.showBlockingWaitOverlay()
        generateData()
    }
    
    
    
    func generateData(){
        var users = [Users]()
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
        do{
            if #available(iOS 10.0, *) {
                
                users = try context.fetch(fetchRequest)
            } else {
                // Fallback on earlier versions
                
                users = try context9.fetch(fetchRequest)
            }
            
            if users.count > 0 {
                
                for result in users {
                    
                    if let id1 = result.value(forKey: "id") as? Int16!{
                        ID = id1
                    }
                    
                }
                
                getdataFromServer()
            }else{
                 SwiftOverlays.removeAllBlockingOverlays()
                print("debug : No Data")
            }
            
        } catch {
            // handle the error
             SwiftOverlays.removeAllBlockingOverlays()
            print("debug : error")
        }
        
    }
    
    func getdataFromServer(){
        
        
        
        let header = ["From" : String(self.ID)]
        
        let postString = ["FirebaseToken" : ""]
        
        Alamofire.request("http://www.mcr-team.m-society.go.th/api/user/firebasetoken/\(String(self.ID))", method: HTTPMethod.post ,parameters: postString,encoding: JSONEncoding.default,headers: header ).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        self.deleteLogin()
                        
                        
                        
                        
                    }
                    
                }
                
                break
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                
                debugPrint("error")
                
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
    }
    
    func deleteLogin(){
        
        var users = [Users]()
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        
        do{
            if #available(iOS 10.0, *) {
                users = try context.fetch(fetchRequest)
            } else {
                // Fallback on earlier versions
                users = try context9.fetch(fetchRequest)
            }
            
            if users.count > 0 {
                
                for result in users {
                    
                    if #available(iOS 10.0, *) {
                        try context.execute(request)
                    } else {
                        
                        
                        try context9.execute(request)
                    }
                    
                    
                    print("debug : DELETE")
                    
                    ProfileImage =  "default.png"
                    ProfileImage2 = "default.png"
                    
                    SwiftOverlays.removeAllBlockingOverlays()
                    
                    // create viewController code...
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                   
                    
                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                    
                    
                    
                    
                    appDelegate.window?.rootViewController = loginViewController
                    appDelegate.window?.makeKeyAndVisible()
                    
                    
                    
                }
            }else{
                 SwiftOverlays.removeAllBlockingOverlays()
                print("debug : No Data")
            }
            
        } catch {
            // handle the error
             SwiftOverlays.removeAllBlockingOverlays()
            print("debug : error")
        }
        
    }
    

   
}
