//
//  ShowUserViewController.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Alamofire

class ShowUserViewController2: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   
    
    
    var currentFeed: CurrentShowUsers!
    var currentFeeds = [CurrentShowUsers]()
    var filteredFeed = [CurrentShowUsers]()
    var inSearchMode = false
    var id_feeds = [Int]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        
        downloadFeedsData(){}
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(ShowUserViewController2.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        refresh()
    }
    
    func refresh(){
        downloadFeedsData(){}
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.searchBar.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        var feedURL: URL!
        
        if(USER_TYPE_G == 1){
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/users")!
        }else{
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/users/\(String(TEAM_ID))")!
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
                        
                        self.currentFeeds.removeAll()
                        self.id_feeds.removeAll()
                        
                        for obj in dict {
                            let currentfeeds = CurrentShowUsers(UsersDict:obj)
                            self.currentFeeds.append(currentfeeds)
                            
                            
                            
                            self.id_feeds.append(currentfeeds.id)
                            
                        }
                        
                        debugPrint(self.id_feeds.count)
                        
                        //self.currentFeeds.remove(at: 0)
                        self.tableView.reloadData()
                        self.refresher.endRefreshing()
                        
                        
                        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(USER_TYPE_G == 1){
            if segue.identifier == "getStatusUsers2" {
                if let destination = segue.destination as? ChangUserStatusViewController {
                    if let id_user = sender as? Int {
                        destination.id_user = id_user
                    }
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(USER_TYPE_G == 1){
            
            debugPrint(id_feeds[indexPath.row])
            
            performSegue(withIdentifier: "getStatusUsers2", sender: id_feeds[indexPath.row])
        }else{
            //getDataUsers
            
            debugPrint(id_feeds[indexPath.row])
            ID_USER_DETAIL = id_feeds[indexPath.row]
            edit_profile_staff = 0
            performSegue(withIdentifier: "getDataUsers", sender: nil)
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredFeed.count
        }
        
        return currentFeeds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemShowUsersTableViewCell {
            print("debug: cell not null")
            
            let search: CurrentShowUsers!
            
            if inSearchMode {
                search = filteredFeed[indexPath.row]
                cell.configureCell(currentFeeds: search)
            }else{
                let currentFeed1 = currentFeeds[indexPath.row]
                cell.configureCell(currentFeeds: currentFeed1)
            }
            
            
            return cell
            
        }else{
            print("debug: cell null")
            return ItemFeed()
        }
        
        
        return UITableViewCell()
    }
    
    //    searchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredFeed = currentFeeds.filter({$0.userName.range(of: lower) != nil})
            
            tableView.reloadData()
            
        }
    }
    
    
}
