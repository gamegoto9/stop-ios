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

class ProfileViewController: UIViewController,UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    
    @IBOutlet weak var btnMenuButton: UIBarButtonItem!
    
    @IBOutlet weak var title_name: UILabel!
    
    @IBOutlet weak var title_tel: UILabel!
    
    @IBOutlet weak var title_email: UILabel!
    
    
    @IBOutlet weak var txtName: UITextField!
    
    
    @IBOutlet weak var txtTel: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var btnSave: UIButton!
    
    @IBOutlet weak var imageProfile: UIImageView!
    
    @IBOutlet weak var btnCamera: UIButton!
    
    
    var fullName_full: String = ""
    var tel: String = ""
    var eMail: String = ""
    var ID: Int16 = 0
    
    var complate_full: String = ""
    
    
    
    var images: [UIImage] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        

        generateData()
        getdataFromServer()
        checkLanguage()
        
        btnCamera.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        btnCamera.setTitle(String.fontAwesomeIcon(name: .camera), for: .normal)
        
        
       

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationBarItem()
        
        //getdataFromServer()
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        moveTextField(textField: textField, moveDistance: -150, up: true)
    }
    
//    keyboard hidden
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        moveTextField(textField: textField, moveDistance: -150, up: false)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        //images.count
        
        if images.count > 0 {
            SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
            updateProfileNotImage(status: 1)

            
        }else{
            SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
            updateProfileNotImage(status: 0)
            
        }
        debugPrint("\(images.count)")
    }
    
    
    func checkLanguage(){
        if LANGUAGE == 0 {
            title_name.text = "Name"
            title_tel.text = "Tel"
            title_email.text = "E-mail"
            complate_full = "Success"
        }else{
            title_name.text = "ชื่อจริง"
            title_tel.text = "เบอร์โทรศัพท์"
            title_email.text = "อีเมลล์"
            complate_full = "สำเร็จ"
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageProfile.image = selectedImage
        images = [selectedImage]
        
        dismiss(animated: true, completion: nil)
        
    }
    

    

    @IBAction func a(_ sender: UIButton) {
        let controller = UIImagePickerController()
        controller.delegate = self
        controller.sourceType = .photoLibrary
        
        present(controller, animated: true,completion: nil)
    }
    
    func savecoredata(){
        
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
                
                debugPrint("error")
                    
            
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
    }
    
    func updateProfileNotImage(status: Int){
        
        let path = "http://www.mcr-team.m-society.go.th/api/user/"
        
        
        let url = "\(path)\(ID)"
        
        debugPrint(url)
        
        let postString2 = [
            "FullName": txtName.text!,
            "Email": txtEmail.text!,
            "Mobile1": txtTel.text!
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
                                self.alert(message: self.complate_full)
                                
                                self.loadHome()
                            }
                           
                          
                        }
        
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
    
    func uploadImages(){
        

        for item in self.images {
            
          
      
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(item, 0)!, withName: "ProfileImage", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpeg")
                
               
            }, usingThreshold: UInt64.init()
            , to: "http://www.mcr-team.m-society.go.th/api/user/profileImage/\(ID)"
                , method: .post
                , encodingCompletion: { encodingResult in
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
                            self.alert(message: self.complate_full)
 
                           self.loadHome()
                           
                        }
                        
                        
                    
                       
                    }
                case .failure(let encodingError):
                    SwiftOverlays.removeAllBlockingOverlays()
                    debugPrint("error")
                        
                    
                   // print(encodingError)
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
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//// Put this piece of code anywhere you like
//extension ProfileViewController {
//    func hideKeyboardWhenTappedAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmergencyViewController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
//    }
//    
//    func dismissKeyboard() {
//        view.endEditing(true)
//    }
//}


