//
//  ForwartViewController.swift
//  mcr-team
//
//  Created by LIKIT on 3/30/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Alamofire
import SwiftOverlays

class ForwartViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var teamName = [String]()
    var teamId = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        

        self.tableView.layer.cornerRadius = 40
        self.tableView.layer.masksToBounds = true
       
        
        
        self.showAnimate()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        
        downloadFeedsData(){}
    }
    
    
    @IBAction func btnClose(_ sender: Any) {
        removeAnimate()
    }
    
    
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(ForWort_ID != 0){
            SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
            forWartPost(idTeam: teamId[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ForwartTableViewCell {
            print("debug: cell not null")
            
            
            
            let name = teamName[indexPath.row]
            cell.txtName.text = name
            
            
            
            return cell
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamId.count
    }
    
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        var Name_lang: String!
        
        
        if LANGUAGE == 0{
            Name_lang = "NameEN"
            
            
        }else{
            Name_lang = "NameTH"
            
        }
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/teams/post/206")!
        
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
                            
                            let data_team = obj as? Dictionary<String, AnyObject>
                            
                            
                            
                            self.teamId.append(data_team?["ID"] as! Int)
                            self.teamName.append(data_team?[Name_lang] as! String)
                            
                        }
                        
                        
                        
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

    
    func forWartPost(idTeam:Int!){
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/emergency/post")!
        
        let headerPost = [
            "From" : String(Form_ID)]
        
        let body = ["EmergencyID": String(ForWort_ID),
                    "TeamID": String(idTeam)]
        
        Alamofire.request(feedURL, method: HTTPMethod.post, parameters: body, encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.alert(message: "ส่งต่อเรียบร้อย")
                    self.removeAnimate()
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                //                self.alert()
                SwiftOverlays.removeAllBlockingOverlays()
                self.alert(message: "เกิดข้อผิดพลาด!")
                break
            }
            
            
        }
    }
   
    func alert(message: String){
        // create the alert
        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }

    

}
