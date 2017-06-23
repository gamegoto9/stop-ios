//
//  DetailUsersViewController.swift
//  mcr-team
//
//  Created by LIKIT on 4/1/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import FontAwesome_swift
import Alamofire
import Kingfisher
import SwiftOverlays


class DetailUsersViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    
    @IBOutlet weak var name_lb: UILabel!
    
    @IBOutlet weak var name_txt: UITextField!
    
    @IBOutlet weak var position_lb: UILabel!
    
    @IBOutlet weak var position_txt: UITextField!
    
    @IBOutlet weak var nameOffice_lb: UILabel!
    
    @IBOutlet weak var nameOffice_txt: UITextField!
    
    @IBOutlet weak var addressOffice_lb: UILabel!
    
    
    @IBOutlet weak var addressOffice_txt: UITextField!
    
    
    @IBOutlet weak var tel_lb: UILabel!
    
    @IBOutlet weak var tel_txt: UITextField!
    
    @IBOutlet weak var tel1_lb: UILabel!
    
    @IBOutlet weak var tel1_txt: UITextField!
    
    @IBOutlet weak var tel2_lb: UILabel!
    
    @IBOutlet weak var tel2_txt: UITextField!
    
    @IBOutlet weak var telPaple_lb: UILabel!
    
    @IBOutlet weak var telPaple_txt: UITextField!
    
    @IBOutlet weak var email_lb: UILabel!
    
    @IBOutlet weak var email_txt: UITextField!
    
    @IBOutlet weak var web_lb: UILabel!
    
    
    @IBOutlet weak var web_txt: UITextField!
    
    @IBOutlet weak var status_lb: UILabel!
    
    @IBOutlet weak var status_txt: UITextField!
  
    
    @IBOutlet weak var team_lb: UILabel!
    
    
    @IBOutlet weak var team_txt: UITextField!
    
    @IBOutlet weak var btnSave: UIButton!
    
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    
    @IBOutlet weak var group_team: UIStackView!
    
    @IBOutlet weak var group_status: UIStackView!
    
    
    @IBOutlet weak var camera: UIButton!
    
    
    var teamID: Int = 0
    
    var entityFiledLanguage: String!
    var complate: String!
    
    
    var teams :[Dictionary<String, AnyObject>]? = nil
    
    var status: Int = 0
    var picker = UIPickerView()
    var activeValue = ""
    var fullName_full: String = ""
    var focus: Int = 0
    var teamID_post: Int = 0
    var activeTF : UITextField!
     let nameType = ["Admin", "Staff" , "User"]
    
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        status_txt.delegate = self
        team_txt.delegate = self
        
        checkLanguage()
        
        
        
        if(edit_profile_staff == 0){
            
            name_txt.isEnabled = false
            position_txt.isEnabled = false
            nameOffice_txt.isEnabled = false
            addressOffice_txt.isEnabled = false
            tel_txt.isEnabled = false
            tel1_txt.isEnabled = false
            tel2_txt.isEnabled = false
            telPaple_txt.isEnabled = false
            email_txt.isEnabled = false
            web_txt.isEnabled = false
            status_txt.isEnabled = false
            team_txt.isEnabled = false
            
            btnSave.isHidden = true
            
            if(USER_TYPE_G == 1){
                btnSave.isHidden = false
                status_txt.isEnabled = true
                team_txt.isEnabled = true
            }
            
            camera.isHidden = true
            
        }else{
            
            group_team.isHidden = true
            group_status.isHidden = true
            btnSave.isHidden = false
            camera.isHidden = false
        }
        getdataFromServer(){
            self.getdataTeamName()
        }
        
        
    

        
        downloadTeamsData(){}
        
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressPhoto(_ sender: Any) {
        
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true,completion: nil)
    }
  
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarItem = UITabBarItem(title: "ข้อมูลส่วนตัว", image: UIImage.fontAwesomeIcon(name: .creditCard, textColor: UIColor.gray, size: CGSize(width: 30, height: 30)), selectedImage: UIImage.fontAwesomeIcon(name: .creditCard, textColor: UIColor.white, size: CGSize(width: 30, height: 30)))
        
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        self.tabBarController?.navigationItem.title = "Profile"
        //self.tabBarController?.navigationItem.leftBarButtonItem = settingsButton
        
        setNavigationButton()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
//    func setNavigationBarColor(navigationController : UINavigationController?,
//                               color : UIColor) {
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.navigationBar .setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.view.backgroundColor = color
//        navigationController?.navigationBar.backgroundColor =  color
//    }
//    
    
    
    func setNavigationButton(){
//        //create a new button
//        let button = UIButton.init(type: .custom)
//        //set image for button
//        button.setImage(UIImage.fontAwesomeIcon(name: .mailForward, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
//        //add function for button
//        button.addTarget(self, action: #selector(DataFeedsVC.sendButtonPressed), for: UIControlEvents.touchUpInside)
//        //set frame
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        
//        let barButton = UIBarButtonItem(customView: button)
//        //assign button to navigationbar
//        //self.navigationItem.rightBarButtonItem = barButton
//        self.tabBarController?.navigationItem.rightBarButtonItem = barButton
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
        //self.navigationItem.leftBarButtonItem = barButton2
        self.tabBarController?.navigationItem.leftBarButtonItem = barButton2
    }
    
    func backVC(){
        
        if edit_profile_staff == 1{
            loadHome()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadHome() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        

        leftViewController.Home = nvc
        
        var slideMenuController: ExSlideMenuController
        
        if(USER_TYPE_G == 3){
            slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController)
        }else{
            slideMenuController = ExSlideMenuController(mainViewController:nvc, leftMenuViewController: leftViewController, rightMenuViewController: rightViewController)
        }
        
        
        
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
      
        
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func didPressSave(_ sender: Any) {
        
        if(USER_TYPE_G == 1){
            
            if(edit_profile_staff == 0){
                updateStatusUser(){
                    self.alert(message: self.complate)
                }
            }else{
                if images.count > 0 {
                    SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
                    updateProfileNotImage(status: 1)
                    
                    
                }else{
                    SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
                    updateProfileNotImage(status: 0)
                    
                }
            }
        }else{
            if edit_profile_staff == 1 {
                if images.count > 0 {
                    SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
                    updateProfileNotImage(status: 1)
                    
                    
                }else{
                    SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
                    updateProfileNotImage(status: 0)
                    
                }
            }
        }
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageProfile.image = selectedImage
        images = [selectedImage]
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    func checkLanguage(){
        if LANGUAGE == 0 {
            name_lb.text = "Name"
            position_lb.text = "Position"
            nameOffice_lb.text = "Organization"
            addressOffice_lb.text = "Organization Address"
            tel_lb.text = "Office Tel"
            tel1_lb.text = "Mobile 1"
            tel2_lb.text = "Mobile 2"
            telPaple_lb.text = "Fax"
            email_lb.text = "Email"
            web_lb.text = "Website"
            status_lb.text = "User Status"
            team_lb.text = "Team"
            entityFiledLanguage = "NameEN"
            complate = "Sucess"
        }else{
            name_lb.text = "ชื่อจริง"
            position_lb.text = "ตำแหน่ง"
            nameOffice_lb.text = "ชื่อหน่วยงาน"
            addressOffice_lb.text = "ที่อยู่หน่วยงาน"
            tel_lb.text = "เบอร์โทรศัพท์หน่วยงาน"
            tel1_lb.text = "เบอร์โทรศัพท์มือถือ 1"
            tel2_lb.text = "เบอร์โทรศัพท์มือถือ 2"
            telPaple_lb.text = "Fax"
            email_lb.text = "Email"
            web_lb.text = "Website"
            status_lb.text = "สถานะผู้ใช้"
            team_lb.text = "ทีม"
            entityFiledLanguage = "NameTN"
            complate = "สำเร็จ"
            
        }
    }
    
    //upload
    func updateProfileNotImage(status: Int){
        
        let path = "http://www.mcr-team.m-society.go.th/api/user/"
        
        
        let url = "\(path)\(String(Form_ID))"
        
        debugPrint(url)
        
        let postString2 = [
            "FullName": name_txt.text!,
            "Position": position_txt.text!,
            "Organization": nameOffice_txt.text!,
            "OrganizationAddress": addressOffice_txt.text!,
            "OfficeTel": tel_txt.text!,
            "Mobile1": tel1_txt.text!,
            "Mobile2": tel2_txt.text!,
            "Fax": telPaple_txt.text!,
            "Email": email_txt.text!,
            "WebSite": web_txt.text!
            ] as [String : Any]
        
        let header_post = [
            "From" : String(Form_ID)]
        
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: header_post).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let postID1 = dict["ID"] as? Int {
                            if status == 1 {
                                self.uploadImages()
                            }else{
                                SwiftOverlays.removeAllBlockingOverlays()
                                self.alert(message: self.complate)
                                
                                //self.loadHome()
                            }
                            
                            
                        }
                        
                    }
                    
                }
                
                break
            case .failure(_):
                
                SwiftOverlays.removeAllBlockingOverlays()
                self.alert(message: "Network Connection Error")
                debugPrint("error")
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
        
    }
    
    func uploadImages(){
        
        
        for item in self.images {
            
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(item, 0)!, withName: "ProfileImage", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
                
                
            }, usingThreshold: UInt64.init(), to: "http://www.mcr-team.m-society.go.th/api/user/profileImage/\(String(Form_ID))", method: .post, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        
                        debugPrint(response.result)
                        
                        
                        
                        if let dict = response.result.value as? Dictionary<String, AnyObject> {
                            
                            
                            if let colume = dict["ProfileImage"] as? String {
                                ProfileImage2 = colume
                                
                            }else{
                                ProfileImage2 = "default.png"
                            }
                            
                            debugPrint(ProfileImage2)
                            
                            SwiftOverlays.removeAllBlockingOverlays()
                            self.alert(message: self.complate)
                            
                            //self.loadHome()
                            
                        }
                        
                        
                        
                        
                    }
                case .failure(let encodingError):
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.alert(message: "Network Connection Error")
                    debugPrint("error")
                    
                    
                    print(encodingError)
                }
            })
            
        }
    }
    
    //
    func getdataFromServer(completed: @escaping DownloadComplete){
        
        SwiftOverlays.showBlockingWaitOverlay()
        var URL_DATA: URL!
        
        if(edit_profile_staff == 1){
            URL_DATA = URL(string: "http://www.mcr-team.m-society.go.th/api/user/\(String(Form_ID))")!
        }else{
            URL_DATA = URL(string: "http://www.mcr-team.m-society.go.th/api/user/\(ID_USER_DETAIL)")!
        }
        
        
        Alamofire.request(URL_DATA, method: HTTPMethod.get ,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let name1 = dict["FullName"] as? String {
                            
                            
                            self.name_txt.text = name1.capitalized
                            
                        }
                        
                        
                        if let tel1 = dict["Position"] as? String {
                            
                            
                            self.position_txt.text = tel1.capitalized
                            
                        }
                        if let tel1 = dict["Organization"] as? String {
                            
                        
                            self.nameOffice_txt.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["OrganizationAddress"] as? String {
                            
                            
                            self.addressOffice_txt.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["OfficeTel"] as? String {
                            
                            
                            self.tel_txt.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["Mobile1"] as? String {
                            
                            
                            self.tel1_txt.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["Mobile2"] as? String {
                            
                            
                            self.tel2_txt.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["Fax"] as? String {
                            
                            
                            self.telPaple_txt.text = tel1.capitalized
                            
                        }
                        if let tel1 = dict["Email"] as? String {
                            
                            
                            self.email_txt.text = tel1.capitalized
                            
                        }
                        if let tel1 = dict["WebSite"] as? String {
                            
                            
                            self.web_txt.text = tel1.capitalized
                            
                        }
                        
                        
                        if let type = dict["UserType"] as? Int {
                            
                            if(type == 2){
                                self.status_txt.text = "Staff"
                            }else if(type == 1){
                                self.status_txt.text = "Admin"
                            }else{
                                self.status_txt.text = "User"
                            }
                            
                        }
                        
                        if let type = dict["TeamID"] as? Int {
                            
                            self.teamID = type
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
                        
                        self.imageProfile.kf.setImage(with: url)
                        
                        
                        SwiftOverlays.removeAllBlockingOverlays()
                        
                        self.dismiss(animated: false, completion: {})
                    }
                    
                    completed()
                    
                }
                
                break
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                self.alert(message: "Network Connection Error")
                debugPrint("error")
                
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
    }
    
    
    func getdataTeamName(){
        
        
        debugPrint(teamID)
        //SwiftOverlays.showBlockingWaitOverlay()
        
        
        let HeaderPost = ["From" : "0"]
        
        Alamofire.request("http://www.mcr-team.m-society.go.th/api/users/\(String(teamID))", method: HTTPMethod.get ,encoding: JSONEncoding.default, headers: HeaderPost).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                            if let name1 = dict[0][self.entityFiledLanguage] as? String {
                                
                                
                                self.team_txt.text = name1.capitalized
                                
                            }
                        
                        
                        //SwiftOverlays.removeAllBlockingOverlays()
                        
                        
                    }
                    
                    
                }
                
                break
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                self.alert(message: "Network Connection Error")
                debugPrint("error")
                
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
    }

    ///
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //    keyboard shows
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if(USER_TYPE_G == 1){
            
            if(edit_profile_staff == 0){
                
                switch textField {
                case status_txt:
                    focus = 1
                    
                case team_txt:
                    focus = 2
                    
                default:
                    moveTextField(textField: textField, moveDistance: -150, up: true)
                }
                
                activeTF = textField
                
                debugPrint(focus)
                self.pickUpValue(textField: textField)
            }else{
                moveTextField(textField: textField, moveDistance: -150, up: true)
            }
        }else{
            
            if(edit_profile_staff == 0){
                
                switch textField {
                case tel_txt:
                    if let phoneCallURL = URL(string: "tel://\(self.tel_txt.text)") {
                        
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            if #available(iOS 10.0, *) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            } else {
                                
                                application.openURL(phoneCallURL)
                                // Fallback on earlier versions
                            }
                        }
                    }
                case tel1_txt:
                    if let phoneCallURL = URL(string: "tel://\(self.tel1_txt.text)") {
                        
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            if #available(iOS 10.0, *) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            } else {
                                
                                application.openURL(phoneCallURL)
                                // Fallback on earlier versions
                            }
                        }
                    }
                case tel2_txt:
                    if let phoneCallURL = URL(string: "tel://\(self.tel2_txt.text)") {
                        
                        let application:UIApplication = UIApplication.shared
                        if (application.canOpenURL(phoneCallURL)) {
                            if #available(iOS 10.0, *) {
                                application.open(phoneCallURL, options: [:], completionHandler: nil)
                            } else {
                                
                                application.openURL(phoneCallURL)
                                // Fallback on earlier versions
                            }
                        }
                    }
                default:
                    moveTextField(textField: textField, moveDistance: -150, up: true)
                }
                
            }
        }
    }
    
    //    keyboard hidden
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        
        if(USER_TYPE_G == 1){
            
            if(edit_profile_staff != 0){
                
                 moveTextField(textField: textField, moveDistance: -150, up: false)
            }
        }else{
            
            if(edit_profile_staff != 0){
                moveTextField(textField: textField, moveDistance: -150, up: false)
            }
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(TimeInterval(moveDuration))
        
        self.view.frame = self.view.frame.offsetBy(dx: 0,dy: movement)
        
        UIView.commitAnimations()
    }
    
    
    
    
    func downloadTeamsData(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/master/teams")!
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                        self.teams = dict
                        debugPrint("debug team :  \(self.teams)")
                        
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
    
    func updateStatusUser(completed: @escaping DownloadComplete){
        
        let path = "http://www.mcr-team.m-society.go.th/api/user/type/"
        
        
        let url = "\(path)\(ID_USER_DETAIL)"
        
        debugPrint(url)
        
        var postString2: [String: Any]
        
        if(status == 2){
            postString2 = [
                "UserType": String(status),
                "TeamID": String(teamID_post)
                ] as [String : Any]
            
        }else{
            postString2 = [
                "UserType": String(status)
                ] as [String : Any]
            
        }
        let header_post = [
            "From" : String(Form_ID)]
        
        
        Alamofire.request(url, method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: header_post).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    completed()
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
    
    
    func alert(message: String){
        // create the alert
        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    //-------  Pickerview Entity
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        
        
        switch focus {
        case 1:
            return self.nameType.count
        case 2:
            return self.teams!.count
            
            
        default:
            return 0
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch focus {
        case 1:
            if row == 0 {
                status = 1
            }else if row == 1 {
                status = 2
            }else if row == 2 {
                status = 3
            }
            
            activeValue = nameType[row]
        case 2:
            let key = teams?.startIndex.advanced(by: row)
            
            let x = teams?[key!]
            
            activeValue = (x?[entityFiledLanguage] as! String?)!
            
            teamID_post = x?["ID"] as! Int
        default:
            activeValue = ""
        }
        
        
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        
        //        let key = nameType.startIndex.advanced(by: row)
        //        let x = entrype?[key!]
        
        switch focus {
        case 1:
            return nameType[row]
        case 2:
            let key = teams?.startIndex.advanced(by: row)
            
            let x = teams?[key!]
            
          
            return x?[entityFiledLanguage] as! String?
        //return nameType[row]
        default:
            return ""
        }
        
        
        
    }
    
    //------  End Pickerview Entity
    
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
        
        
        self.activeTF.text = self.activeValue
        self.activeTF.resignFirstResponder()
        
        
        
        
        
        
    }
    
    // cancel
    func cancelClick() {
        activeTF.resignFirstResponder()
    }
    
    //  End show picker View




}
