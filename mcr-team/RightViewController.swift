//
//  RightViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import Alamofire

class RightViewController : UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentFeed: CurrentRightMenu!
    var currentFeeds = [CurrentRightMenu]()
    var id_feeds = [Int]()
    var inSearchMode = false
    var myteam: Int?
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        //self.tableView.registerCellClass(BaseTableViewCell.self)
        //self.tableView.register(BaseTableRightViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        downloadFeedsData(){self.downloadMyTeamData{}}
        
        
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
    }
    
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        if(USER_TYPE_G != 1){
            
            let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/user")!
            
            let headerPost = [
                "From" : String(Form_ID)]
            
            
            
            Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
                
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("debug : response3 \(response.result.value)")
                        
                        if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                            print("error ::::::::::")
                            
                            
                            self.currentFeeds.removeAll()
                            self.id_feeds.removeAll()
                            
                            let emptyDictionary : Dictionary<String, AnyObject> = ["ProfileImage" : "chat_group.png" as AnyObject, "FullName" : "Chat Grop" as AnyObject, "NameEN" : "chat group team" as AnyObject, "ToUserID" : 0 as AnyObject]
                            
                            
                            let currentfeeds0 = CurrentRightMenu(UsersDict:emptyDictionary)
                            
                            self.currentFeeds.append(currentfeeds0)
                            
                            self.id_feeds.append(currentfeeds0.id)
                            
                            for obj in dict {
                                let currentfeeds = CurrentRightMenu(UsersDict:obj)
                                self.currentFeeds.append(currentfeeds)
                                
                                
                                
                                self.id_feeds.append(currentfeeds.id_last)
                                
                            }
                            
                            
                            let emptyDictionary2 : Dictionary<String, AnyObject> = ["ProfileImage" : "" as AnyObject, "FullName" : "- - MY TEAM - -" as AnyObject, "NameEN" : "" as AnyObject, "ToUserID" : 0 as AnyObject]
                            
                            
                            
                            let currentfeeds2 = CurrentRightMenu(UsersDict:emptyDictionary2)
                            
                            self.currentFeeds.append(currentfeeds2)
                            self.id_feeds.append(currentfeeds2.id)
                            
                            self.myteam = self.currentFeeds.count - 1
                            
                            debugPrint(self.id_feeds.count)
                            
                            //self.currentFeeds.remove(at: 0)
                            self.tableView.reloadData()
                            //self.refresher.endRefreshing()
                            
                            
                            
                        }
                        completed()
                        
                    }
                    break
                case .failure(_):
                    print("debug : failure \(response.result.error)")
                    //                self.alert()
                    break
                }
                
                
            }
        } else if(USER_TYPE_G == 1){
            
            let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/user")!
            
            let headerPost = [
                "From" : String(Form_ID)]
            
            
            
            Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
                
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("debug : response3 \(response.result.value)")
                        
                        if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                            print(dict)
                            
                            
                            self.currentFeeds.removeAll()
                            self.id_feeds.removeAll()
                            
                            
                            
                            for obj in dict {
                                let currentfeeds = CurrentRightMenu(UsersDict:obj)
                                self.currentFeeds.append(currentfeeds)
                                
                                
                                
                                self.id_feeds.append(currentfeeds.id_last)
                                
                            }
                            
                            
                            let emptyDictionary2 : Dictionary<String, AnyObject> = ["ProfileImage" : "" as AnyObject, "FullName" : "- - Staff - -" as AnyObject, "NameEN" : "" as AnyObject, "ToUserID" : 0 as AnyObject]
                            
                            
                            
                            let currentfeeds2 = CurrentRightMenu(UsersDict:emptyDictionary2)
                            
                            self.currentFeeds.append(currentfeeds2)
                            self.id_feeds.append(currentfeeds2.id)
                            
                            self.myteam = self.currentFeeds.count - 1
                            
                            debugPrint(self.id_feeds.count)
                            
                            //self.currentFeeds.remove(at: 0)
                            self.tableView.reloadData()
                            //self.refresher.endRefreshing()
                            
                            
                            
                        }
                        completed()
                        
                    }
                    break
                case .failure(_):
                    print("debug : failure \(response.result.error)")
                    //                self.alert()
                    break
                }
                
                
            }
        }

        
        
    }
    
    
    
    func downloadMyTeamData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        var feedURL: URL!
        
        if(USER_TYPE_G == 2){
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/users/\(String(TEAM_ID))")!
        }else if(USER_TYPE_G == 1){
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/allstaff")!
        }
        
        
        let headerPost = [
            "From" : String(Form_ID)]
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        print("error ::::::::::")
                        
                        
                        
                        for obj in dict {
                            let currentfeeds = CurrentRightMenu(UsersDict:obj)
                            self.currentFeeds.append(currentfeeds)
                            
                            
                            
                            self.id_feeds.append(currentfeeds.id)
                            
                        }
                        
                        
                        
                        
                        debugPrint(self.id_feeds.count)
                        
                        //self.currentFeeds.remove(at: 0)
                        self.tableView.reloadData()
                        //self.refresher.endRefreshing()
                        
                        
                        
                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                //                self.alert()
                break
            }
            
            
        }
        
        
    }
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getChatUser" {
            if let destination = segue.destination as? ChatViewController {
                if let id_feed = sender as? Int {
                    destination.ToUserID = id_feed
                }
            }
        }
        
    }
*/    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row == myteam {
            debugPrint("MY TEEM")
        }else{
            /*
            performSegue(withIdentifier: "getChatUser", sender: id_feeds[indexPath.row])
             */
            debugPrint("\(indexPath.row) = \(self.id_feeds[indexPath.row])")
            
            ID_CHART = self.id_feeds[indexPath.row]
            
            debugPrint(ID_CHART)
            
            
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
            
            let chatVC = nav.viewControllers[0] as! ChatViewController
            chatVC.senderId = "\(String(Form_ID))"
            chatVC.senderDisplayName = USER_NAME
            chatVC.avatarString = ProfileImage
            
            appDelegate.window?.rootViewController = nav
 
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentFeeds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemRightMenuTableViewCell {
            print("debug: cell not null")
            
            
            
            let currentFeed1 = currentFeeds[indexPath.row]
            cell.configureCell(currentFeeds: currentFeed1)
            
            
            
            return cell
            
        }
        
        return UITableViewCell()

    }
}


