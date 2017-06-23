//
//  ShowUserViewController.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Alamofire

class ShowTeamViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var currentFeed: CurrentShowTeams!
    var currentFeeds = [CurrentShowTeams]()
    var filteredFeed = [CurrentShowTeams]()
    var inSearchMode = false
    var id_feeds = [Int]()
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(ShowTeamViewController.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)

        
        downloadFeedsData(){}
    }
    
    func refresh(){
        downloadFeedsData(){}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        refresh()
    }
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/teams/list")!
        
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
                            let currentfeeds = CurrentShowTeams(TeamDict:obj)
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
        if segue.identifier == "getShowUsers" {
            if let destination = segue.destination as? ShowUserViewController {
                if let id_feed = sender as? Int {
                    destination.id_feed = id_feed
                }
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        performSegue(withIdentifier: "getShowUsers", sender: id_feeds[indexPath.row])

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredFeed.count
        }
        
        return currentFeeds.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemShowTeamTableViewCell {
            print("debug: cell not null")
            
            let search: CurrentShowTeams!
            
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
            
            filteredFeed = currentFeeds.filter({$0.teamName.range(of: lower) != nil})
            
            tableView.reloadData()
            
        }
    }
    
    
}
