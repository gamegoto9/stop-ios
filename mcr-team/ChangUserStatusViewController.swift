//
//  MessageViewController.swift
//  mcr-team
//
//  Created by LIKIT on 2/13/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import CoreData
import FontAwesome_swift
import Alamofire
import Kingfisher
import SwiftOverlays

class ChangUserStatusViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    //
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var title_name: UILabel!
    
    @IBOutlet weak var title_tel: UILabel!
    
    @IBOutlet weak var title_email: UILabel!
    
    
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var txtTel: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var textStatus: UITextField!

    @IBOutlet weak var status_lb: UILabel!
    
    @IBOutlet weak var team_lb: UILabel!
    
    
    @IBOutlet weak var group_team: UIStackView!
    
    
    @IBOutlet weak var txtTeamName: UITextField!
    
    
    
    var teams :[Dictionary<String, AnyObject>]? = nil
    
    var status: Int = 0
    var picker = UIPickerView()
    var activeValue = ""
    var fullName_full: String = ""
    var tel: String = ""
    var eMail: String = ""
    var focus: Int = 0
    
    var ID: Int = 0
    
    var teamID: Int = 0
    
    var complate_full: String = ""
    
    var id_user: Int{
        get {
            return ID
        } set {
            ID = newValue
        }
    }
    
    var images: [UIImage] = []
    var activeTF : UITextField!
    
    let nameType = ["Admin", "Staff" , "User"]
    
    var entityFiledLanguage: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        debugPrint(ID)
        
        textStatus.delegate = self
        txtTeamName.delegate = self
        getdataFromServer()
        checkLanguage()
        
        
        if(USER_TYPE_G == 1){
            txtName.isEnabled = false
            txtTel.isEnabled = false
            txtEmail.isEnabled = false
            
        }
        
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

        
        downloadTeamsData(){}
        
        group_team.isHidden = true
    }
    
    
   
    @IBAction func didPressSave(_ sender: Any) {
        updateProfileNotImage(){
            self.alert(message: self.complate_full)
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        //self.setNavigationBarItem()
        
        //getdataFromServer()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backVC(){
        self.navigationController?.popViewController(animated: true)
    }
    

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
            
            self.pickUpValue(textField: textField)
            
            switch textField {
            case textStatus:
                focus = 1
               
            case txtTeamName:
                focus = 2
              
            default:
                focus = 0
            }
            
            activeTF = textField
            
            
            debugPrint(focus)
        }else{
        
            moveTextField(textField: textField, moveDistance: -150, up: true)
        }
    }
    
    //    keyboard hidden
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if(USER_TYPE_G != 1){
            moveTextField(textField: textField, moveDistance: -150, up: false)
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    func checkLanguage(){
        if LANGUAGE == 0 {
            title_name.text = "Name"
            title_tel.text = "Tel"
            title_email.text = "E-mail"
            complate_full = "Success"
            status_lb.text = "Type User"
            team_lb.text = "Team"
            entityFiledLanguage = "NameEN"
        }else{
            title_name.text = "ชื่อจริง"
            title_tel.text = "เบอร์โทรศัพท์"
            title_email.text = "อีเมลล์"
            complate_full = "สำเร็จ"
            status_lb.text = "ประเภทผู้ใช้"
            team_lb.text = "ทีม"
            entityFiledLanguage = "NameTH"
            
        }
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
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageProfile.image = selectedImage
        images = [selectedImage]
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    

   
  
    func getdataFromServer(){
        
        SwiftOverlays.showBlockingWaitOverlay()
        
        Alamofire.request("http://www.mcr-team.m-society.go.th/api/user/\(ID)", method: HTTPMethod.get ,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let name1 = dict["FullName"] as? String {
                            
                            debugPrint(name1)
                            self.txtName.text = name1
                            
                        }
                        
                        
                        if let tel1 = dict["Mobile1"] as? String {
                            
                            self.tel = tel1
                            self.txtTel.text = self.tel
                            
                        }
                        if let tel1 = dict["Email"] as? String {
                            
                            self.eMail = tel1
                            self.txtEmail.text = self.eMail
                            
                        }
                        
                        if let type = dict["UserType"] as? Int {
                            
                            if(type == 2){
                                self.textStatus.text = "Staff"
                            }else if(type == 1){
                                self.textStatus.text = "Admin"
                            }else{
                                self.textStatus.text = "User"
                            }
                            
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
                    
                }
                
                break
            case .failure(_):
                SwiftOverlays.removeAllBlockingOverlays()
                
                
                self.alert(message: "network connection error")
                debugPrint("error")
                
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
    }
    
    func updateProfileNotImage(completed: @escaping DownloadComplete){
        
        let path = "http://www.mcr-team.m-society.go.th/api/user/type/"
        
        
        let url = "\(path)\(ID)"
        
        debugPrint(url)
        
        var postString2: [String: Any]
        
        if(status == 2){
            postString2 = [
                "UserType": String(status),
                "TeamID": String(teamID)
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
                
                self.alert(message: "Network Connection Error")
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
        
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
    
    
    func alert(message: String){
        // create the alert
        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
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
        
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        //appDelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }


    

    
    //-------  Pickerview Entity
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        
        debugPrint(teams?.count)
        
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
            
            teamID = x?["ID"] as! Int
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
            
            debugPrint(x?["NameEN"])
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
        
        if(focus == 1){
            if status == 2 {
                group_team.isHidden = false
            }else{
                group_team.isHidden = true
            }
        }
        
        
        
        
    }
    
    // cancel
    func cancelClick() {
        activeTF.resignFirstResponder()
    }
    
    //  End show picker View


    
}
