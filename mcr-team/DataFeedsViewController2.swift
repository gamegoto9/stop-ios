//
//  DataFeedsVC.swift
//  mcr-team
//
//  Created by LIKIT on 3/9/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift
import Alamofire
import Kingfisher
import SwiftOverlays
import MapKit

class DataFeedsViewController2: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    @IBOutlet weak var title_type: UILabel!
    
    
    @IBOutlet weak var data_type: UILabel!
    
    @IBOutlet weak var title_subject: UILabel!
    
    @IBOutlet weak var data_subject: UILabel!
    
    @IBOutlet weak var title_detial: UILabel!
    
    @IBOutlet weak var data_detial: UILabel!
    
    
    @IBOutlet weak var title_country: UILabel!
    
    @IBOutlet weak var data_country: UILabel!
    
    
    @IBOutlet weak var title_place: UILabel!
    
    @IBOutlet weak var data_place: UILabel!
    
    
    @IBOutlet weak var title_user: UILabel!
    
    @IBOutlet weak var data_user: UILabel!
    
    @IBOutlet weak var title_time: UILabel!
    
    @IBOutlet weak var data_time: UILabel!
    
    @IBOutlet weak var title_placeUser: UILabel!
    
    @IBOutlet weak var data_placeUser: UILabel!
    
    
    @IBOutlet weak var btn_send_post: UIBarButtonItem!
    
    private var _id_feed: Int = 0
    
    
    var id_feed: Int{
        get {
            return _id_feed
        } set {
            _id_feed = newValue
        }
    }
    
    
    
    var TyptMap: Int = 0
    
    
    
    var ID: Int16!
    
    var Country: String!
    var Team: String!
    var Type1: String!
    
    var images : [UIImage] = []
    //var images2 = ["Oval-1","Oval-1","Oval-1"]
    var images2 = [String]()
    
    var lat: String!
    var lon: String!
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
      
//        UINavigationBar.appearance().tintColor = UIColor(red: 104, green: 159, blue: 56)
//        
//        UINavigationBar.appearance().tintColor = UIColor(hex: "ff4da6")
//        UINavigationBar.appearance().backgroundColor = UIColor(hex: "ff4da6")
        
        self.navigationController?.isNavigationBarHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if(PUSH_NOTIFICATION == 1){
            _id_feed = Feed_data_post
            PUSH_NOTIFICATION = 0
        }
        
        
        data_placeUser.isHidden = true
        title_placeUser.isHidden = true

        
        
        ForWort_ID = _id_feed
        
        // Do any additional setup after loading the view.
        setNavigationButton()
        
        checkLanguage()
        
        debugPrint(_id_feed)
        
        //        SwiftOverlays.showBlockingWaitOverlay()
        
        generateData()
        
        
        getdataFromServer()
        
        
        //        images2.append("http://www.mcr-team.m-society.go.th/api/upload/images/168/B00AFD00-B244-EF86-031B-9FF963481E99.jpg")
        //
        //        images2.append("http://www.mcr-team.m-society.go.th/api/upload/images/168/B00AFD00-B244-EF86-031B-9FF963481E99.jpg")
        //
        //        images2.append("http://www.mcr-team.m-society.go.th/api/upload/images/168/B00AFD00-B244-EF86-031B-9FF963481E99.jpg")
        //
        //        collectionView.reloadData()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // self.setNavigationBarItem()
        self.navigationController?.isNavigationBarHidden = false
//        
 //       self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().backgroundColor = UIColor(colorLiteralRed: 228/255, green: 0/255, blue: 79/255, alpha: 100.0/100.0)
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blue]
 */
 /*
        navigationController?.navigationBar .setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.blue
        navigationController?.navigationBar.backgroundColor =  UIColor.blue
        navigationController?.navigationBar.barTintColor = UIColor.blue
*/
        
        
        
        
    }
    
    func sendButtonPressed(){
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID2") as! ForwartViewController
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
    }
    
    
    func setNavigationBarColor(navigationController : UINavigationController?,
                                     color : UIColor) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar .setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = color
        navigationController?.navigationBar.backgroundColor =  color
    }
    
    
    
    func setNavigationButton(){
        
        if(USER_TYPE_G != 3){
            //create a new button
            let button = UIButton.init(type: .custom)
            //set image for button
            button.setImage(UIImage.fontAwesomeIcon(name: .mailForward, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
            //add function for button
            button.addTarget(self, action: #selector(DataFeedsVC.sendButtonPressed), for: UIControlEvents.touchUpInside)
            //set frame
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            let barButton = UIBarButtonItem(customView: button)
            //assign button to navigationbar
            self.navigationItem.rightBarButtonItem = barButton
        }
        
        //create a new button
        let button2 = UIButton.init(type: .custom)
        //set image for button
        button2.setImage(UIImage.fontAwesomeIcon(name: .chevronLeft, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(DataFeedsVC.backVC), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton2
    }
    
    func backVC(){
        loadHome()
    }
    
    func loadHome() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        //UINavigationBar.appearance().tintColor = UIColor(red: 104, green: 159, blue: 56)
        
        //UINavigationBar.appearance().tintColor = UIColor(hex: "FFFFFF")
        //UINavigationBar.appearance().backgroundColor = UIColor(hex: "ff4da6")
        
        leftViewController.Home = nvc
        
        var slideMenuController: ExSlideMenuController
        
        if(USER_TYPE_G == 3){
            slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        }else{
            slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        }
        
        
        //let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        
        //let slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        //appDelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    func setPikerMap(){
        
        debugPrint("Lat: \(self.lat) Lon: \(self.lon)")
        
        
        
        let latitude = Double(self.lat)!
        let longitude = Double(self.lon)!
        
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        var placemark: MKPlacemark
        
        if #available(iOS 10.0, *) {
            placemark = MKPlacemark(coordinate: coordinate)
        } else {
            // Fallback on earlier versions
            
            placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        }
        
        
        
        self.dropPinZoomIn(placemark: placemark)
        
        
        
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
            }else{
                print("debug : No Data")
            }
            
        } catch {
            // handle the error
            print("debug : error")
        }
        
    }
    
    
    
    func getdataFromServer(){
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        let header = [
            "From" : String(ID)]
        
        Alamofire.request("http://www.mcr-team.m-society.go.th/api/emergency/view/\(String(_id_feed))", method: HTTPMethod.get ,encoding: JSONEncoding.default, headers: header).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let name1 = dict["Title"] as? String {
                            
                            debugPrint(name1)
                            self.data_subject.text = name1
                            self.title = name1.capitalized
                        }
                        
                        
                        if let tel1 = dict["Desc"] as? String {
                            
                            
                            self.title_detial.text = tel1
                            self.data_detial.text = "."
                            
                        }
                        if let tel1 = dict[self.Country] as? String {
                            
                            
                            self.data_country.text = tel1
                        }
                        
                        if let tel1 = dict["FullName"] as? String {
                            
                            
                            self.data_user.text = tel1
                        }
                        
                        if let tel1 = dict["UpdateTime"] as? String {
                            
                            
                            self.data_time.text = tel1
                        }
                        
                        if let tel1 = dict[self.Team] as? String {
                            
                            
                            self.data_place.text = tel1
                        }
                        
                        if let tel1 = dict[self.Type1] as? String {
                            
                            
                            self.data_type.text = tel1
                        }
                        
                        if let tel1 = dict["Latitude"] as? String {
                            
                            
                            self.lat = tel1
                        }
                        if let tel1 = dict["Longitude"] as? String {
                            
                            
                            self.lon = tel1
                        }
                        
                        var loadprofileImg: String = ""
                        
                        if let tel1 = dict["ProfileImage"] as? String {
                            
                            
                            loadprofileImg = tel1
                            debugPrint(loadprofileImg)
                            
                            
                        }
                        
                        let path = "http://www.mcr-team.m-society.go.th/api/upload/profile/"
                        
                        var url: URL
                        
                        if loadprofileImg != "" || loadprofileImg != nil {
                            
                            url = URL(string: "\(path)\(loadprofileImg)")!
                            debugPrint(url)
                            
                        }else{
                            url = URL(string: "\(path)defalut.png")!
                            debugPrint(url)
                        }
                        
                        self.profileImage.layoutIfNeeded()
                        self.profileImage.layer.cornerRadius = self.profileImage.bounds.size.height / 2
                        self.profileImage.clipsToBounds = true
                        self.profileImage.layer.borderWidth = 1
                        self.profileImage.layer.borderColor = UIColor.white.cgColor
                        
                        self.profileImage.kf.setImage(with: url)
                        
                        let pathImage = "http://www.mcr-team.m-society.go.th/api/upload/images/\(self._id_feed)/"
                        
                        
                        if let temp = dict["Attachments"] as? [Dictionary<String,AnyObject>] {
                            
                            if temp.count > 0 {
                                
                                for i in 0..<temp.count {
                                    
                                    if let image1 = temp[i]["FileName"] as? String {
                                        var url2:String!
                                        
                                        url2 = "\(pathImage)\(image1)"
                                        
                                        self.images2.append(url2)
                                        
                                    }
                                    
                                }
                                
                                self.collectionView.reloadData()
                                
                                
                            }
                            
                        }
                        
                        self.setPikerMap()
                        
                        
                        
                        SwiftOverlays.removeAllBlockingOverlays()
                        
                        
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images2.count
        
        print("array image2: \(images2.count)")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_2", for: indexPath) as! ImagePostCollectionViewCell
        
        //cell.image = images2[indexPath.row]
        
        debugPrint(images2.count)
        
        cell.image = images2[indexPath.row]
        
        //        cell.imagePost_1.image = UIImage(named: images2[indexPath.row])
        
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding =  10.0
        let collectionViewSize : Double = Double(collectionView.frame.size.width) - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
        
    }
    
    
    func checkLanguage(){
        if LANGUAGE == 0 {
            title_type.text = "Notify the : "
            title_subject.text = "Topic :"
            //title_detial.text = "Description : "
            
            title_user.text = "Notify By : "
            title_time.text = "Time :"
            title_placeUser.text = "Local Notify : "
            
            title_country.text = "Country : "
            title_place.text = "Place : "
            
            Country = "CounrtyNameEN"
            Team = "TeamNameEN"
            Type1 = "TypeNameEN"
            
            
            
            
        }else{
            title_type.text = "แจ้งเหตุ : "
            title_subject.text = "เรื่อง/เหตุ : "
            //title_detial.text = "รายละเอียด : "
            
            title_user.text = "ผู้แจ้งเหตุ : "
            title_time.text = "เวลา : "
            title_placeUser.text = "ตำแหน่งที่แจ้ง : "
            title_country.text = "ประเทศ : "
            title_place.text = "พื้นที่ : "
            
            
            Country = "CounrtyNameTH"
            Team = "TeamNameTH"
            Type1 = "TypeNameTH"
            
        }
    }

    
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    @IBAction func PressMyLocation(_ sender: Any) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
    }
    
    
    
    @IBAction func pressTypeMap(_ sender: Any) {
        if(self.TyptMap == 0){
            self.mapView.mapType = .hybrid
            self.TyptMap = 1
        }else{
            self.mapView.mapType = .standard
            self.TyptMap = 0
        }
    }
    
    
    
    
}


extension DataFeedsViewController2: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        
        
        if let name = data_subject.text {
            annotation.title = name
        }else{
            annotation.title = "จุดเกิดเหตุ"
        }
        
        if let city = data_place.text,
            let state = data_country.text {
            annotation.subtitle = "\(city) \(state)"
        }else{
            annotation.subtitle = "พื้นที่เกิดเหตุ"
        }
        
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        
        
    }
}

extension DataFeedsViewController2 : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            
        }
        
    }
    
}


extension DataFeedsViewController2 : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        
        
        let button = UIButton()
        
        button.frame = CGRect(origin: CGPoint(x: 0,y: 0), size: smallSquare)
        
        
        
        button.setBackgroundImage(UIImage.fontAwesomeIcon(name: .car, textColor: UIColor.black, size: CGSize(width: 30, height: 30)), for: .normal)
        button.addTarget(self, action: #selector(DataFeedsVC.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}
