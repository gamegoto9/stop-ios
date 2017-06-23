
//
//  ViewController.swift
//  mcr-team
//
//  Created by LIKIT on 1/23/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import Google

class Login: UIViewController,UITextFieldDelegate,GIDSignInUIDelegate,GIDSignInDelegate {
   
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLanguage: UIButton!
    var firebaseToken: String!
    var username_main: String!
    var password_main: String!

    var userID: Int16 = 0
    
    var verityType: Int?
    var userType: Int?
    
    var currentUser: CurrentUsers!
    
    var timer = Timer()
    
    var statusUser: Int16 = 0
    
    var fullName: String!
    var eMail: String!
    var username: String!
    
    weak var delegate: LeftMenuProtocol?
    
    @IBAction func btnLogin(_ sender: Any) {
        
//        print("debug : click = \(firebaseToken)")
        
        self.wite_dialog(check: true)
        
        username_main = txtUsername.text!
        password_main = txtPassword.text!
        
        
        if username_main != nil && password_main != nil && UserDefaults.standard.string(forKey: "firebaseToken") != nil && password_main != "" && username_main != "" {
            
            print("debug : full data")
            
            currentUser = CurrentUsers()
            
            currentUser.setUsername = username_main
            currentUser.setPassword = password_main
            currentUser.setFirebaseToken = UserDefaults.standard.string(forKey: "firebaseToken")
            
            
            currentUser.downloadWeatherDelails {
                //Setup UI to load downloaded data
                
                let checkError = self.currentUser._errorCheck
                
                
                if checkError {
                    
                    //self.wite_dialog(check: false)
                    //let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                   // DispatchQueue.main.asyncAfter(deadline: when) {
                        // Your code with delay
                    self.dismiss(animated: false, completion: {
                        self.alert(message: self.currentUser.error)
                    })
                   // }
                    
                    
                }else{
                    
                    self.deleteLogin()
                    self.save_login()
                    
                    

                    self.dismiss(animated: false, completion: {
                        //self.performSegue(withIdentifier: "Home", sender: nil)
                    
                        self.loadHome()
                    })

                    
                    
                }
                
            }
        }else{
            
            print("debug : failde data")
            
            self.wite_dialog(check: false)
            let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.alert(message: "กรุณา ป้อนข้อมุลให้ครบ")
            }
            
        }
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func loadHome() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
       // UINavigationBar.appearance().tintColor = UIColor(red: 228, green: 0, blue: 79)
        
        //UINavigationBar.appearance().tintColor = UIColor(hex: "FFFFFF")
        //UINavigationBar.appearance().backgroundColor = UIColor(colorLiteralRed: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        
        
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Google login
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        // Define identifier
        let notificationName = Notification.Name("tokenRecieved")
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.recievedFirebaseToken), name: notificationName, object: nil)
        
       
         self.navigationController?.isNavigationBarHidden = true
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        
        
        if(UserDefaults.standard.string(forKey: "firebaseToken") == nil) {
            wite_dialog(check: true)
        }
        
//        if(PUSH_NOTIFICATION == 1){
//            
//            if Chat_status == 1 {
//                
//                let nav = self.storyboard?.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
//                
//                let chatVC = nav.viewControllers[0] as! ChatViewController
//                chatVC.senderId = "\(String(Form_ID))"
//                chatVC.senderDisplayName = USER_NAME
//                chatVC.avatarString = "Chat Team"
//                
//                appDelegate.window?.rootViewController = nav
//            }
//            
//        }else{
        
            generateData()
            
            
            
            
            //userID = 1
            
            if userID != 0 {
                
                print("debug : is value ")
                
                // self.performSegue(withIdentifier: "Home", sender: nil)
                VerifyType = 1
                loaginGoogle(fullname: fullName, email: eMail)
                //deleteLogin()
                
                
            }
            
            
//        }
        
        print("commmmmmm : \(firebaseToken)")
        
        
        self.navigationController?.isNavigationBarHidden = true

        
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
    
    
    func moveTextField(textField: UITextField, moveDistance: Int, up: Bool){
        
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        
        self.view.frame = self.view.frame.offsetBy(dx: 0,dy: movement)
        
        UIView.commitAnimations()
    }
    
    func recievedFirebaseToken() {
        wite_dialog(check: false)
    }

    func processTimer(){
        if firebaseToken == nil {
            firebaseToken = FIRInstanceID.instanceID().token()
            print("loop")
        }else{
            timer.invalidate()
            print("stop")
            wite_dialog(check: false)
        }
    }
    
    
    func generateData(){
        
        
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
/*
        if let result = try? context9.fetch(fetchRequest) {
            for object in result {
                context9.delete(object)
            }
        }
 */
        
        var users = [Users]()
        
        //let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
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
                        self.userID = uid
                    }else{
                        self.userID = 0;
                    }

                    if let statusUser1 = result.value(forKey: "usertype") as? Int16!{
                        self.statusUser = statusUser1
                    }else{
                        self.statusUser = 0;
                    }
                    
                    if let fullname1 = result.value(forKey: "fullname") as? String!{
                        
                        self.fullName = fullname1
                    }
                    
                    if let email1 = result.value(forKey: "email") as? String!{
                        self.eMail = email1
                        
                    }
                    
                    if let verifytype = result.value(forKey: "verifytype") as? Int16!{
                        self.verityType = Int(verifytype)
                        
                    }
                    
                    if let usertype = result.value(forKey: "usertype") as? Int16!{
                        self.userType = Int(usertype)
                        
                    }
                    
                    if let username = result.value(forKey: "username") as? String!{
                        self.username = username
                        
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
    
    func save_login() {
        
        print("debug: save_ \(currentUser.id)")
        
        if #available(iOS 10.0, *) {
            let users  = Users(context: context)
            
            
            debugPrint("id = \(currentUser.id) / email = \(currentUser.email) / fullname = \(currentUser.fullname) / teamID = \(currentUser.teamId) / userType = \(currentUser.userType) / verifytype = \(currentUser.verifytype)")
            
            
            users.id = Int16(currentUser.id)
//            users.username = currentUser.username
            users.email = currentUser.email
//            users.firebasetoken = currentUser.filebaseToken
            users.fullname = currentUser.fullname
//            users.profileimage = currentUser.profileImg
            users.teamid = Int16(currentUser.teamId)
//            users.telephonenumber = currentUser.tel
            users.usertype = Int16(currentUser.userType)
            users.verifytype = Int16(currentUser.verifytype)
            users.username = currentUser.username
            

            
            

        } else {
            // Fallback on earlier versions
            let users2 = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context9)
            
            debugPrint("id = \(currentUser.id) / email = \(currentUser.email) / fullname = \(currentUser.fullname) / teamID = \(currentUser.teamId) / userType = \(currentUser.userType) / verifytype = \(currentUser.verifytype)")
            
            
            users2.setValue(Int16(currentUser.id), forKey: "id")
            users2.setValue(currentUser.fullname, forKey: "fullname")
            users2.setValue(Int16(currentUser.userType), forKey: "usertype")
            users2.setValue(currentUser.email, forKey: "email")
            users2.setValue(Int16(currentUser.verifytype), forKey: "verifytype")
            users2.setValue(Int16(currentUser.teamId), forKey: "teamid")
            users2.setValue(currentUser.username, forKey: "username")

        }
        
        
        USER_TYPE_G = Int16(currentUser.userType)
        TEAM_ID = Int16(currentUser.teamId)
        Form_ID = Int16(currentUser.id)
        USER_NAME = currentUser.fullname
        EMAIL_ = currentUser.email
        
        
        do {
            appDelegate.saveContext()
            try context9.save()
            
            print("save")
        } catch {
            print("dont save")
        }
        
        
        
    }
    
    func deleteLogin(){
        
        var users = [Users]()
        let fetchRequest: NSFetchRequest<Users> = Users.fetchRequest()
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do{
            if #available(iOS 10.0, *) {
                users = try context.fetch(fetchRequest)
            } else {
                // Fallback on earlier versions
                users = try context9.fetch(fetchRequest)
            }
            
            debugPrint(users.count)
            
            
            if users.count > 0 {
                
                for result in users {
                    
                    if #available(iOS 10.0, *) {
                        try context.execute(request)
                        try context.delete(result)
                    } else {
                        // Fallback on earlier versions
                        try context9.execute(request)
                        try context9.delete(result)
                    }
                    
                    
                    print("debug : DELETE")
                    
                }
            }else{
                print("debug : No Data")
            }
            
        } catch {
            // handle the error
            print("debug : error")
        }

    }
    
    
    func loaginGoogle(fullname: String!,email: String!){
        
        debugPrint("\(fullname) = = = \(email)")
        
        self.wite_dialog(check: true)
        
        
        
        if fullname != nil && email != nil && UserDefaults.standard.string(forKey: "firebaseToken") != nil  {
            
            print("debug : full data")
            
            currentUser = CurrentUsers()
            
            currentUser.setFullname = fullname
            currentUser.setEmail = email
            currentUser.setFirebaseToken = UserDefaults.standard.string(forKey: "firebaseToken")
            currentUser.setUsername = self.username
            //currentUser.setVerifyType = self.verityType
            //currentUser.setUerType = self.userType
            
            
            
            currentUser.downloadWeatherDelailsGoogle {
                //Setup UI to load downloaded data
                
                let checkError = self.currentUser._errorCheck
                
                
                if checkError {
                    
                    self.wite_dialog(check: false)
                    let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
                    // DispatchQueue.main.asyncAfter(deadline: when) {
                    // Your code with delay
                    self.alert(message: self.currentUser.error)
                    // }
                    
                    
                }else{
                    
                    self.deleteLogin()
                    
                    self.save_login()
                    
                    
                    
                    self.dismiss(animated: false, completion: {
                       // self.performSegue(withIdentifier: "Home", sender: nil)
                        
                        if PUSH_NOTIFICATION == 1 {
                            
                            PUSH_NOTIFICATION = 0
                            
                            if(Chat_status == 1){
                                
                                let nav = self.storyboard?.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                                
                                let chatVC = nav.viewControllers[0] as! ChatViewController
                                chatVC.senderId = "\(String(Form_ID))"
                                chatVC.senderDisplayName = USER_NAME
                                chatVC.avatarString = "Chat Team"
                                
                                appDelegate.window?.rootViewController = nav
                            }else if(Chat_status == 2){
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let nav = storyboard.instantiateViewController(withIdentifier: "pushData") as! UINavigationController
                                
                            
                                appDelegate.window?.rootViewController = nav

                            }
                        }else{
                            self.loadHome()
                        }
                        
                        
/*
                        let nav = self.storyboard?.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                        
                        let chatVC = nav.viewControllers[0] as! ChatViewController
                        chatVC.senderId = "\(String(Form_ID))"
                        chatVC.senderDisplayName = "iOS"
                        chatVC.avatarString = "Chat Team"
                        
                        appDelegate.window?.rootViewController = nav
*/
                    })
                    
//                    self.delegate?.changeViewController(LeftMenu.Home)
                    
                }
                
            }
        }else{
            
            print("debug : failde data")
            
            self.wite_dialog(check: false)
            let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.alert(message: "เกิดข้อผิดพลาด")
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
    
    
    
    @IBAction func signInGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
        /*
         // Register to receive notification รับ cell ที่มาจากการส่งจาก appdelegate ให้ไปทำงาน func catchNotification

        let notificationName = Notification.Name("tokenGoogle")
        
                NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotification(notification:)), name: notificationName, object: nil)
        */
        
    }
    /*  ////   ทำงาน ดึงค่าที่มาจาก appdelegate 
     
    func catchNotification(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let FullName  = userInfo["FullName"] as? String,
            let Email     = userInfo["Email"]    as? String else {
                print("No userInfo found in notification")
                return
        }
        

        debugPrint("\(FullName) + + \(Email)")
        
        self.loaginGoogle(fullname:FullName,email:Email)
        
        
    }
    */
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if (error == nil) {
            // Perform any operations on signed in user here.
            
            VerifyType = 0
            self.loaginGoogle(fullname:user.profile.name,email:user.profile.email)
            
            /*
            // send token ส่ง cell ไปยัง VC ที่ต้องการ
            let notificationName = Notification.Name("tokenGoogle")
            NotificationCenter.default.post(name: notificationName, object: nil,
                                            userInfo: ["FullName":fullName,
                                                    "Email":email])
            */
        
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        //
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func btnRegister(_ sender: Any) {
    }
    
    
    func wite_dialog(check: Bool , gotoHome : Bool = false){
        
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
            dismiss(animated: false, completion: {
               // self.performSegue(withIdentifier: "Home", sender: nil)
                })
        }

    }
    
    
    
    @IBAction func cheng_language(_ sender: Any) {
        if LANGUAGE == 0 {
            
            LANGUAGE = 1
            
            btnLanguage.setImage(UIImage(named: "1280px-Flag_of_the_United_Kingdom.svg.png"), for: UIControlState.normal)
            
        }else{
            
            LANGUAGE = 0
            btnLanguage.setImage(UIImage(named: "Flag_of_Thailand.svg.png"), for: UIControlState.normal)
        }
    }
    
    
    
}

