//
//  ShowUserViewController.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Alamofire
import FontAwesome_swift

class ShowUserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    
    @IBOutlet weak var btnBack: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var form_id: Int!
    
    var id_feed: Int{
        get {
            return form_id
        } set {
            form_id = newValue
        }
    }
    
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
        
        
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(ShowUserViewController.backVC), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(ShowUserViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
        
        debugPrint(form_id)
        
        downloadFeedsData(){}
    }
    
    
    func refresh(){
        downloadFeedsData(){}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
        refresh()
    }
    
    
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
            debugPrint(self.form_id)
        
        
            let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/users/\(String(self.form_id))")!
            
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
    
    func backVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
//    @IBAction func didPressBack(_ sender: Any) {
//        debugPrint("black")
//    }
    


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        debugPrint(id_feeds[indexPath.row])
        ID_USER_DETAIL = id_feeds[indexPath.row]
        edit_profile_staff = 0
        performSegue(withIdentifier: "getDataUsers", sender: nil)
        
        
        
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
