//
//  Home.swift
//  mcr-team
//
//  Created by LIKIT on 1/24/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import Alamofire
import ImagePicker
import CoreData
import SlideMenuControllerSwift
import SwiftOverlays

class Home: UIViewController , UITableViewDelegate, UITableViewDataSource , UISearchBarDelegate, KCFloatingActionButtonDelegate {

    
    var userID: Int16 = 0
    var userType: Int16!
    var teamID: Int16!
    
    @IBOutlet weak var btnMenuBoutton: UIBarButtonItem!
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var btnAdd: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var currentFeed: CurrentFeeds!
    var currentFeeds = [CurrentFeeds]()
    var filteredFeed = [CurrentFeeds]()
    var inSearchMode = false
    
    let fab = KCFloatingActionButton()
    
    var refresher: UIRefreshControl!
    
    
    var id_feeds = [Int]()
    
    var imageProfile2: ImageHeaderView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        
        generateData()
        
        
        debugPrint(userID)
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
        
        self.downloadFeedsData {
            //
            //print("error: viewdidload")
            SwiftOverlays.removeAllBlockingOverlays()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        
        
//        btnMenuBoutton.target = revealViewController()
//        btnMenuBoutton.action = #selector(SWRevealViewController.revealToggle(_:))
//        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(Home.refresh), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
        
        fab.buttonColor = UIColor(red: 233/30, green: 30/255.0, blue: 99/255.0, alpha: 1)
        fab.plusColor = UIColor(white: 1, alpha: 1)
        fab.buttonImage = UIImage(named: "custom-add")

        fab.fabDelegate = self

        self.view.addSubview(fab)
        
        
    }

    func refresh() {
        self.downloadFeedsData {
            //
            print("error: viewdidload")
            
        }
    }
    
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            // ...
            debugPrint("kcf: touch")
            
//
//            
//            let aa: String = imageProfile.chengImageProfile3
          
 //           imageProfile2.downloadWeatherDelails(){
 //               debugPrint("yess")
 //           }
 
 //           self.imageProfile2 = ImageHeaderView.loadNib()
  //          self.view.addSubview(self.imageProfile2)
            
//            let secondViewController = storyboard?.instantiateViewController(withIdentifier: "Home")
            
//            self.imageProfile2.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
//            self.view.layoutIfNeeded()
            
           // present(secondViewController!, animated: false, completion: nil)
            
             self.performSegue(withIdentifier: "add_emergency", sender: nil)
        }
        super.touchesBegan(touches, with: event)
    }
    
//    @IBAction func endEditing() {
//        view.endEditing(true)
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//    }
    
    
    func KCFABOpened(_ fab: KCFloatingActionButton) {
        debugPrint("FAB Opened")
    }
    
    func KCFABClosed(_ fab: KCFloatingActionButton) {
        debugPrint("FAB Closed")
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
                    
                    
                    if let uid = result.value(forKey: "id") as? Int16!{
                        userID = uid
                    }else{
                        userID = 0;
                    }
                    
                    if let utype = result.value(forKey: "usertype") as? Int16!{
                        userType = utype
                    }
                    
                    if let teamId = result.value(forKey: "teamid") as? Int16!{
                        teamID = teamId
                    }

                    
                    print("debug : \(userID)")
                    
                }
            }else{
                print("debug : No Data")
            }
            
        } catch {
            // handle the error
            print("debug : error")
        }
        
    }
    
    func downloadFeedsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        
        if(self.userType == 3){
            
            
            let feedURL = URL(string: URL_FEEDS)!
            
            let postString = [
                "From" : String(userID)]
            
            
            
            Alamofire.request(feedURL, method: HTTPMethod.post,encoding: JSONEncoding.default, headers: postString).responseJSON { (response: DataResponse<Any>) in
                
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("debug : response3 \(response.result.value)")
                        
                        if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                            print("error ::::::::::")
                            
                            self.currentFeeds.removeAll()
                            self.id_feeds.removeAll()
                            
                            for obj in dict {
                                let currentfeeds = CurrentFeeds(FeedsDict:obj)
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
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")
                    break
                }
                
                
            }
        }else if userType == 2 {
            
            let teamID: String = String(TEAM_ID)
            
            debugPrint(teamID)
            
            let URL_FEEDS_TEAM = "\(BASE_URL)emergency/team/\(teamID)"

            let feedURL = URL(string: URL_FEEDS_TEAM)!
            
            
            
            
            
            Alamofire.request(feedURL, method: HTTPMethod.post,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
                
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("debug : response3 \(response.result.value)")
                        
                        if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                            print("error ::::::::::")
                            
                            self.currentFeeds.removeAll()
                            self.id_feeds.removeAll()
                            
                            for obj in dict {
                                let currentfeeds = CurrentFeeds(FeedsDict:obj)
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
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาเริ่มใหม่")
                    break
                }
                
                
            }
            
        }else if userType == 1 {
            
            debugPrint(userID)
            
            let URL_FEEDS_ADMIN = "\(BASE_URL)emergency/admin"
            
            let feedURL = URL(string: URL_FEEDS_ADMIN)!
            
            let postString = [
                "From" : String(userID)]
            
            Alamofire.request(feedURL, method: HTTPMethod.post,encoding: JSONEncoding.default, headers: postString).responseJSON { (response: DataResponse<Any>) in
                
                
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        print("debug : response3 \(response.result.value)")
                        
                        if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                            print("error ::::::::::")
                            
                            self.currentFeeds.removeAll()
                            self.id_feeds.removeAll()
                            
                            for obj in dict {
                                let currentfeeds = CurrentFeeds(FeedsDict:obj)
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
                    
                     SwiftOverlays.removeAllBlockingOverlays()
                    
                    self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ กรุณาเริ่มใหม่")
                    break
                }
                
                
            }
            
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredFeed.count
        }
        
        return currentFeeds.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? ItemFeed {
            print("debug: cell not null")
            
            let search: CurrentFeeds!
            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        debugPrint(indexPath.row)
        
        
        performSegue(withIdentifier: "feedsData", sender: id_feeds[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "feedsData" {
            if let destination = segue.destination as? DataFeedsVC {
                if let id_feed = sender as? Int {
                    destination.id_feed = id_feed
                }
            }
        }
        
    }

    
    
    
    func wite_dialog(check: Bool){
        
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.view.tintColor = UIColor.black
        
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        loadingIndicator.frame = CGRect(x: 10, y: 5, width: 50, height: 50)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        
        
        
        
        if check {
            alert.view.addSubview(loadingIndicator)
            present(alert, animated: true, completion: nil)
            loadingIndicator.startAnimating();
            
        }else{
            dismiss(animated: false, completion: nil)
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

   
  
    
    
    
//    searchBar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            tableView.reloadData()
        }else{
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            filteredFeed = currentFeeds.filter({$0.title1.range(of: lower) != nil})
            
            tableView.reloadData()
            
        }
    }
    
    private var lastContentOffset: CGFloat = 0

}

extension Home : SlideMenuControllerDelegate {
    
    func leftWillOpen() {
        print("SlideMenuControllerDelegate: leftWillOpen")
    }
    
    func leftDidOpen() {
        print("SlideMenuControllerDelegate: leftDidOpen")
    }
    
    func leftWillClose() {
        print("SlideMenuControllerDelegate: leftWillClose")
    }
    
    func leftDidClose() {
        print("SlideMenuControllerDelegate: leftDidClose")
    }
    
    func rightWillOpen() {
        print("SlideMenuControllerDelegate: rightWillOpen")
    }
    
    func rightDidOpen() {
        print("SlideMenuControllerDelegate: rightDidOpen")
    }
    
    func rightWillClose() {
        print("SlideMenuControllerDelegate: rightWillClose")
    }
    
    func rightDidClose() {
        print("SlideMenuControllerDelegate: rightDidClose")
    }
}


