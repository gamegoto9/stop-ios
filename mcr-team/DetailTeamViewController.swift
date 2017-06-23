//
//  DetailTeamViewController.swift
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



class DetailTeamViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var name_lb: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    
    @IBOutlet weak var position_lb: UILabel!
    
    @IBOutlet weak var txtPosition: UITextField!
    
    @IBOutlet weak var tel_lb: UILabel!
    
    @IBOutlet weak var txtTel: UITextField!
    
    @IBOutlet weak var tel2_lb: UILabel!
    
    @IBOutlet weak var txtTel2: UITextField!
    
    
    @IBOutlet weak var btnPressSave: UIButton!
    
    var complate: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
      
        //txtName.isEnabled = false
        //txtTel.isEnabled = false
        //txtPosition.isEnabled = false
        //txtTel2.isEnabled = false
        
     
        if edit_profile_staff == 0 {
            txtName.isEnabled = false
            txtPosition.isEnabled = false
            txtTel.isEnabled = false
            txtTel2.isEnabled = false
            
            btnPressSave.isHidden = true
            
            txtTel.addTarget(self, action: #selector(DetailTeamViewController.didPressTel), for: .touchDown)
            
        }else{
            btnPressSave.isHidden = false
        }
        
        
        checkLanguage()
        getdataFromServer(){}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarItem = UITabBarItem(title: "บุลลที่สามารถติดต่อได้กรณีฉุกเฉิน", image: UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.gray, size: CGSize(width: 30, height: 30)), selectedImage: UIImage.fontAwesomeIcon(name: .user, textColor: UIColor.white, size: CGSize(width: 30, height: 30)))
    }
    
    
    @IBAction func didPressSave(_ sender: Any) {
        updateProfileNotImage(){
            self.alert(message: self.complate)
        }
    }
    
    func didPressTel(){
        
        debugPrint("Prss")
        if let url = NSURL(string: "tel://\(self.txtTel.text)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
            

        }
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
        
        if edit_profile_staff == 0{
            
            if textField == txtTel {
                didPressTel()
            }
        }
//            moveTextField(textField: textField, moveDistance: -150, up: true)
        
    }
    
    //    keyboard hidden
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        moveTextField(textField: textField, moveDistance: -150, up: false)
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
    

    func checkLanguage(){
        if LANGUAGE == 0 {
            name_lb.text = "Name"
            position_lb.text = "Position"
            
            tel_lb.text = "Office Tel"
          
            tel2_lb.text = "Email"
            
            
            complate = "Sucess"
        }else{
            name_lb.text = "ชื่อจริง"
            position_lb.text = "ตำแหน่ง"
          
            tel_lb.text = "เบอร์โทรศัพท์"
           
            tel2_lb.text = "อีเมลล์"
            
            complate = "สำเร็จ"
            
        }
    }

    
    func getdataFromServer(completed: @escaping DownloadComplete){
        
        SwiftOverlays.showBlockingWaitOverlay()
        var URL_DATA: URL!
        
        if(edit_profile_staff == 1){
            URL_DATA = URL(string: "http://www.mcr-team.m-society.go.th/api/relateperson/\(String(Form_ID))")!
        }else{
            URL_DATA = URL(string: "http://www.mcr-team.m-society.go.th/api/relateperson/\(ID_USER_DETAIL)")!
        }
        
        
        Alamofire.request(URL_DATA, method: HTTPMethod.get ,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug : response3 \(response.result.value)")
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let name1 = dict["FullName"] as? String {
                            
                            
                            self.txtName.text = name1.capitalized
                            
                        }
                        
                        
                        if let tel1 = dict["Position"] as? String {
                            
                            
                            self.txtPosition.text = tel1.capitalized
                            
                        }
                        if let tel1 = dict["Mobile"] as? String {
                            
                            
                            self.txtTel.text = tel1.capitalized
                            
                        }
                        
                        if let tel1 = dict["Email"] as? String {
                            
                            
                            self.txtTel2.text = tel1.capitalized
                            
                        }
                        
                        
                     
                        
                        
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
    
    //upload
    func updateProfileNotImage(completed: @escaping DownloadComplete){
        
        SwiftOverlays.showBlockingWaitOverlay()

        
        let postString2 = [
            "FullName": txtName.text!,
            "Position": txtPosition.text!,
            "Mobile": txtTel.text!,
            "Email": txtTel2.text!,
            "UserID": String(Form_ID)
           
            ] as [String : Any]
        
        let header_post = [
            "From" : String(Form_ID)]
        
        
        Alamofire.request("http://www.mcr-team.m-society.go.th/api/relateperson", method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: header_post).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    

                        SwiftOverlays.removeAllBlockingOverlays()
                            
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
    
    func alert(message: String){
        // create the alert
        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }

    
    

}
