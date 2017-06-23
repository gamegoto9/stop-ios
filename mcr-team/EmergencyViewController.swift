//
//  EmergencyViewController.swift
//  mcr-team
//
//  Created by LIKIT on 2/5/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import MapKit
import ImagePicker
import Alamofire
import CoreData
import SwiftOverlays

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class EmergencyViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource , ImagePickerDelegate, UITextViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate{
    
    let locationManager = CLLocationManager()
    var resultSearchController:UISearchController? = nil
    var selectedPin:MKPlacemark? = nil
    var country :[Dictionary<String, AnyObject>]? = nil
    var teams :[Dictionary<String, AnyObject>]? = nil
    var entity :[Dictionary<String, AnyObject>]? = nil
    var filteredTeams :[Dictionary<String, AnyObject>]? = nil
    var selectedCountryID : Int = 0
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var viewSearch: UIView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var images : [UIImage] = []
    
    var TyptMap: Int = 0
    
    @IBOutlet weak var txtDesc: UITextView!
    
    
    @IBOutlet weak var txtTitle: UITextView!
    
    

    @IBOutlet weak var txtSubject: UITextView!
    
    @IBOutlet weak var txtEntity: UITextField!
    
    var data = [String]()
    
    var picker = UIPickerView()
    var pickerTeam = UIPickerView()
    
    @IBOutlet weak var txtTeams: UITextField!
    
    @IBOutlet weak var txtCountry: UITextField!
    
    @IBOutlet weak var type_lb: UILabel!
    
    @IBOutlet weak var title_ln: UILabel!
    
    
    @IBOutlet weak var desc_lb: UILabel!
    
    @IBOutlet weak var country_lb: UILabel!
    
    @IBOutlet weak var team_lb: UILabel!
    
    @IBOutlet weak var lbImage: UILabel!
    
    
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    // nameTH,EN
    var nameFiledLangauage = ""
    var entityFiledLanguage = ""
    
    var TypeID = 0
    var TeamID = 0
    var CountryID = 0
    
    var emergencyID = 0
    
    var send_lat : Double = 0.0
    var send_long : Double = 0.0
    
    var my_lat : Double = 0.0
    var my_long : Double = 0.0
    
    var userID: Int16 = 0
    
    weak var delegate: LeftMenuProtocol?
    
    var complate_full: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        txtEntity.delegate = self
        txtTeams.delegate = self
        txtCountry.delegate = self
        checkLanguage2()
        generateData()
        
        
        checkLanguage()
//        picker.delegate = self
//        picker.dataSource = self
//        txtEntity.inputView = picker
        
        
        downloadEntityData {
            self.downloadCountryData(){
                self.downloadTeamsData {
                    //
                }
            }
        }
        
        
        
        
        
     
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.showsScopeBar = true
        searchBar.searchBarStyle = UISearchBarStyle.minimal
        searchBar.placeholder = "Search for places"
        //navigationItem.titleView = resultSearchController?.searchBar
        //self.viewSearch = resultSearchController?.searchBar
//        
//        var viewTemp = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 40))
//        
//        viewTemp.addSubview((resultSearchController?.searchBar)!)
        self.viewSearch.addSubview((resultSearchController?.searchBar)!)
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self

        /// add marker goog map /////////////
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(EmergencyViewController.longpress(gesture:)))
        
        uilpgr.minimumPressDuration = 1
        
        mapView.addGestureRecognizer(uilpgr)
        
        /////////////////////////////////////////////////
        
        self.hideKeyboardWhenTappedAround()
        
        let button2 = UIButton.init(type: .custom)
        //set image for button
        button2.setImage(UIImage.fontAwesomeIcon(name: .arrowLeft, textColor: UIColor.purple, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(DataFeedsVC.backVC), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton2
      
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.removeNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    func checkLanguage2(){
        if LANGUAGE == 0 {
            type_lb.text = "Notify the"
            title_ln.text = "Topic"
            desc_lb.text = "Description"
            country_lb.text = "Country"
            team_lb.text = "Team"
            lbImage.text = "Image"
        }else{
            type_lb.text = "แจ้งเหตุ/ปัญหา"
            title_ln.text = "เรื่อง/เหตุ"
            desc_lb.text = "รายละเอียด"
            country_lb.text = "เหตุ/ปัญหา/เกิดที่ประเทศ"
            team_lb.text = "พื้นที่เกืดเหตุ"
            lbImage.text = "รูปภาพ"
        }
    }
    
    func backVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
//-------  Pickerview Entity
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch activeTextField {
        case 1:
            return entity!.count
        case 2:
            return country!.count
        case 3:
            if ((filteredTeams?.count) != nil) {
                return (filteredTeams?.count)!
            }else{
                return 0
            }
            
        default:
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        
//        selectedCountryID = x?["ID"] as! Int
//        filteredTeams = [Dictionary<String,AnyObject>]()
//        
//        for t in teams!
//        {
//            if(t["CountryID"] as! Int == selectedCountryID ){
//                filteredTeams?.append(t)
//            }
//        }
//        txtEntity.text = x?["NameTH"] as! String?
//        pickerTeam.reloadAllComponents()
        
        
        
        
        switch activeTextField {
        case 1:
            let key = entity?.startIndex.advanced(by: row)
            
            let x = entity?[key!]
            activeValue = (x?[entityFiledLanguage] as! String?)!
            
            TypeID = x?["ID"] as! Int
            debugPrint(TypeID)

        case 2:
            let key = country?.startIndex.advanced(by: row)
            
            let x = country?[key!]
            
            selectedCountryID = x?["ID"] as! Int
            
            CountryID = x?["ID"] as! Int
            
            debugPrint(CountryID)
            
            filteredTeams = [Dictionary<String,AnyObject>]()
            
            for t in teams!
            {
                if(t["CountryID"] as! Int == selectedCountryID ){
                    filteredTeams?.append(t)
                }
            }
            
            activeValue = (x?[nameFiledLangauage] as! String?)!
            
        case 3:
    
            let key2 = filteredTeams?.startIndex.advanced(by: row)
            let x2 = filteredTeams?[key2!]
            
            if (x2 != nil) {
                activeValue = (x2?[nameFiledLangauage] as! String?)!
                TeamID = x2?["ID"] as! Int
                
                debugPrint(TeamID)
                
            }else{
                activeValue = ""
            }
            
        default:
            activeValue = ""
        }
        
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
    
        
        switch activeTextField {
        case 1:
            let key = entity?.startIndex.advanced(by: row)
            
            let x = entity?[key!]
            
            return x?[entityFiledLanguage] as! String?
        case 2:
            let key = country?.startIndex.advanced(by: row)
            
            let x = country?[key!]
            selectedCountryID = x?["ID"] as! Int
            
            filteredTeams = [Dictionary<String,AnyObject>]()
            
            for t in teams!
            {
                if(t["CountryID"] as! Int == selectedCountryID ){
                    filteredTeams?.append(t)
                }
            }
            
            return x?[nameFiledLangauage] as! String?
        case 3:
            
          
            
            
            let key2 = filteredTeams?.startIndex.advanced(by: row)
            let x2 = filteredTeams?[key2!]

            return x2?[nameFiledLangauage] as! String?
            
            //            txtEntity.text = x?["NameTH"] as! String?
            //            pickerTeam.reloadAllComponents()
            
        default:
            return ""
        }

//        return  x?["NameTH"] as! String?
    }
    
//------  End Pickerview Entity
    
    
//------  TextFiled Click
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField {
        case txtEntity:
            activeTextField = 1
        case txtCountry:
            activeTextField = 2
        case txtTeams:
            activeTextField = 3
        default:
            activeTextField = 0
        }
        
        // set active text field
        
        activeTF = textField
        
        self.pickUpValue(textField: textField)
        
        
    }
    
//------  End TextFiled Click
    
//------  touch country ---------
    
    func countryClick() {
        
    }
    
    
//-------------------------------
    
//------  Show picker View
    
   
    func pickUpValue(textField: UITextField) {
        
        // create frame and size of picker view
        picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        
        // deletates
        picker.delegate = self
        picker.dataSource = self
        
        // if there is a value in current text field, try to find it existing list
        if textField.text != nil {
            
            var row : Int?
            
            // look in correct array
//            switch activeTextField {
//            case 1:
//                row = country?.startIndex.description(currentValue)
//            case 2:
//                row = optionsB.index(of: currentValue)
//            default:
//                row = nil
//            }
            
            row = nil
            
            // we got it, let's set select it
            if row != nil {
                picker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        
        picker.backgroundColor = UIColor.white
        textField.inputView = self.picker
        
        // toolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.lightGray
        toolBar.sizeToFit()
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    // done
    func doneClick() {
        activeTF.text = activeValue
        activeTF.resignFirstResponder()
        
    }
    
    // cancel
    func cancelClick() {
        activeTF.resignFirstResponder()
    }
    
//  End show picker View
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        debugPrint("test")
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

   
    func getDirections(){
        if let selectedPin = selectedPin {
            let mapItem = MKMapItem(placemark: selectedPin)
            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
            mapItem.openInMaps(launchOptions: launchOptions)
        }
    }
    
    
    func longpress(gesture: UIGestureRecognizer){
        
        if gesture.state == UIGestureRecognizerState.began {
            //            mapView.removeAnnotations(mapView.annotations)
            
            let touchPoint = gesture.location(in: self.mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
//            _ = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            var placemark: MKPlacemark
            
            if #available(iOS 10.0, *) {
                placemark = MKPlacemark(coordinate: coordinate)
            } else {
                // Fallback on earlier versions
            
                placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            }
            
            
            
                self.dropPinZoomIn(placemark: placemark)

            
            
        
            
            
            send_lat = coordinate.latitude
            send_long = coordinate.longitude
            
            debugPrint(send_lat)
            
        }

    }
    

    @IBAction func myLocation(_ sender: Any) {
        self.mapView.setCenter(self.mapView.userLocation.coordinate, animated: true)
        
        my_lat = self.mapView.userLocation.coordinate.latitude
        my_long = self.mapView.userLocation.coordinate.longitude
        
        debugPrint(my_lat)
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
    
    
    
    
//    func buttonTapped() {
//        let pickerData = [
//            ["value": "mile", "display": "Miles (mi)"],
//            ["value": "kilometer", "display": "Kilometers (km)"]
//        ]
//        
//        PickerDialog().show(title: "Distance units", options: pickerData, selected: "kilometer") {
//            (value) -> Void in
//            
//            print("Unit selected: \(value)")
//        }
//    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
        for: indexPath) as! ImageCollectionViewCell
        
        cell.image = images[indexPath.row]
        
        return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding =  10.0
        let collectionViewSize : Double = Double(collectionView.frame.size.width) - padding
        
        return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
        
    }
    

    
    
    @IBAction func btnPassSennd(_ sender: Any) {
    
        let entry = txtEntity.text!
        let title = txtTitle.text!
        let desc = txtDesc.text!
        let country = txtCountry.text!
        let team = txtTeams.text!
        
        
        if send_lat != 0.0 {
            if my_lat != 0.0 {
                if(TypeID != 0){
                    if(title != ""){
                        if(desc != ""){
                            if(CountryID != 0){
                                if(TeamID != 0){
                                    uploadData(title: title,desc: desc)
                                }else{
                                    alert(message: "เลือกทีม")
                                }
                            }else{
                                alert(message: "เลือกประเทศ")
                            }
                        }else{
                            alert(message: "ป้อนรายละเอียด")
                        }
                    }else{
                        alert(message: "ป้อนชื่อเรื่อง")
                    }
                }else{
                    alert(message: "เลือกประเภทเหตุ")
                }
            }else{
                alert(message: "เลือกตำแหน่งที่แจ้ง")
            }
        }else{
            alert(message: "เลือกจุดเกิดเหตุ")
        }
        
//        if (send_lat != 0.0 && my_lat != 0.0 && self.txtTitle.text != nil ){
//            uploadData(title: title,desc: desc)
//        }else{
//            debugPrint("not lat")
//        }
        
        
        
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
    
    
    
    func uploadData(title : String,desc : String){
        
        
         SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
        
        //Alamofire download
        
        
        let feedURL = URL(string: URL_CREATE_EMERGENCY)!
        
        let header_post = [
            "From" : String(userID)]
        
        let postString = ["Desc" : desc,
                          "Latitude": send_lat,
                          "Longitude": send_long,
                          "UserLatitude": my_lat,
                          "UserLongitude": my_long,
                          "TeamID": TeamID,
                          "CountryID": CountryID,
                          "TypeID": TypeID,
                          "Title": title
        ] as [String : Any]
        
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.post, parameters: postString,encoding: JSONEncoding.default, headers: header_post).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let postID1 = dict["ID"] as? Int {
                            
                            self.uploadPost(postID: postID1)
                            
        
                        }
                        
                        
                    }
                    //completed()
                
                }
                
                
              
                break
            case .failure(_):
                self.dismiss(animated: false, completion: {
                    debugPrint("error")
                    
                })
                print("debug : failure \(response.result.error)")
                //                self.alert()
                break
            }
            
            
        }
        
        
        
    }
    
    func uploadPost(postID: Int){
        
        let url = "http://www.mcr-team.m-society.go.th/api/emergency/post"
        
        let postString2 = [
            "TeamID": TeamID,
            "EmergencyID": postID
        ] as [String : Any]
        
        let header_post = [
            "From" : String(userID)]

        
        Alamofire.request(url, method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: header_post).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response4 \(response.result.value)")
                    
                    
                    if self.images.count > 0 {
                        self.uploadImages(postID: postID)
                    }else{
                        SwiftOverlays.removeAllBlockingOverlays()
                        self.alert(message: self.complate_full)
                        self.delegate?.changeViewController(LeftMenu.Home)
                    }
                    
                    
                }
                
                break
            case .failure(_):
                self.dismiss(animated: false, completion: {
                    debugPrint("error")
                    
                })
                print("debug : failure \(response.result.error)")
                SwiftOverlays.removeAllBlockingOverlays()
                self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")
                break
            }

        }
       
    }

    
    func uploadImages(postID: Int){
        
        debugPrint(postID)
        
        let postString = [
            "From" : String(userID)]
        
        for item in self.images {
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(item, 0)!, withName: "Image", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
            }, usingThreshold: UInt64.init(), to: "http://www.mcr-team.m-society.go.th/api/emergency/upload/\(String(postID))", method: .post, headers: postString , encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        SwiftOverlays.removeAllBlockingOverlays()
                            
                        
                        debugPrint("complate ++ YEs")
                        self.alert(message: self.complate_full)
                            
                        self.delegate?.changeViewController(LeftMenu.Home)
                        
                        debugPrint(response)
                    }
                case .failure(let encodingError):
                    self.dismiss(animated: false, completion: {
                        debugPrint("error")
                        
                    })
                    
                    debugPrint(encodingError)
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")

                }
            })
            
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
    
    
    @IBAction func btnUpload1(_ sender: Any) {
        let imagePicker = ImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        debugPrint("test")
    }
    
    
  
    
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        
        self.images = images
        
        collectionView.reloadData()
        
        
        
    }
    
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    }
    
    
    func downloadCountryData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/countries")!
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        self.country = dict
                        
                       self.picker.reloadAllComponents()

                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
               
                self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")
                break
            }
            
            
        }
        
    }
    
    
    func downloadTeamsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        var feedURL: URL!
        
        if(USER_TYPE_G == 3){
        
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/teams")!
        }else{
            feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/teams/post")!
        }
        
        let headerPost = ["From": String(Form_ID)]
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default,headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        self.teams = dict
                        
                      
                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")
                break
            }
            
            
        }
        
        
        
    }
    
    
    func downloadEntityData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/types")!
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        self.entity = dict
                        
                        
                        
                    }
                    completed()
                    
                }
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                self.alert(message: "เกิดข้อผิดพลาดในการเชื่อมต่อ")
                break
            }
            
            
        }
        
        
        
    }
    
    func checkLanguage() {
        let langauage = LANGUAGE
        if langauage == 0 {
            nameFiledLangauage = "NameTH"
            entityFiledLanguage = "TypeNameTH"
            complate_full = "Complate"
        }else{
            nameFiledLangauage = "NameEN"
            entityFiledLanguage = "TypeNameEN"
            complate_full = "บันทึกเรียบร้อยแล้ว"
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
            
        }
        
    }
    
    
    @IBAction func btnback(_ sender: Any) {
        
        delegate?.changeViewController(LeftMenu.Home)
    }
    
}


extension EmergencyViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        
        
        if let name = placemark.name {
            annotation.title = name
        }else{
            annotation.title = "จุดเกิดเหตุ"
        }
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }else{
            annotation.subtitle = "พื้นที่เกิดเหตุ"
        }
        
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView.setRegion(region, animated: true)
        
        send_lat = placemark.coordinate.latitude
        send_long = placemark.coordinate.longitude
        
    }
}


extension EmergencyViewController : CLLocationManagerDelegate {
    
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
            
            my_lat = location.coordinate.latitude
            my_long = location.coordinate.longitude
        }
        
    }

}


extension EmergencyViewController : MKMapViewDelegate {
    
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
        button.addTarget(self, action: #selector(EmergencyViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        return pinView
    }
}

extension EmergencyViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalwidth = collectionView.bounds.size.width;
        let numberOfCellsPerRow = 2
        let oddEven = indexPath.row / numberOfCellsPerRow % 2
        let dimensions = CGFloat(Int(totalwidth) / numberOfCellsPerRow)
        if (oddEven == 0) {
            return CGSize(width : dimensions, height : dimensions)
        } else {
            return CGSize(width : dimensions, height : dimensions / 2)
        }
    }
}


// Put this piece of code anywhere you like
extension EmergencyViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmergencyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}




