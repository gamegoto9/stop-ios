//
//  ChengPassWordVC.swift
//  mcr-team
//
//  Created by LIKIT on 3/25/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import SwiftValidator
import Alamofire
import SwiftOverlays

class ChengPassWordVC: UIViewController,UITextFieldDelegate,ValidationDelegate {

    let validator = Validator()
    
    
    @IBOutlet weak var lbErrPassOld: UILabel!
    
    @IBOutlet weak var lbErrPassNew: UILabel!
    
    @IBOutlet weak var lbErrConPass: UILabel!
    
    
    @IBOutlet weak var txtPassOld: UITextField!
    

    @IBOutlet weak var txtPassNew: UITextField!
    
    @IBOutlet weak var txtConPass: UITextField!
    
    
    @IBOutlet weak var lbConpass: UILabel!
    
    @IBOutlet weak var lbpass: UILabel!
    
    @IBOutlet weak var lboldpass: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        self.navigationController?.isNavigationBarHidden = false
        varidation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    @IBAction func btnPreeSend(_ sender: Any) {
        validator.validate(self)
    }
    
    func alert(message: String){
        // create the alert
        let alert = UIAlertController(title: "แจ้งเตือน", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        present(alert, animated: true, completion: nil)
    }

    
    func varidation() {
        validator.styleTransformers(success:{ (validationRule) -> Void in
            print("here")
            // clear error label
            validationRule.errorLabel?.isHidden = true
            validationRule.errorLabel?.text = ""
            if let textField = validationRule.field as? UITextField {
                textField.layer.borderColor = UIColor.green.cgColor
                textField.layer.borderWidth = 0.5
                
            }
        }, error:{ (validationError) -> Void in
            print("error")
            validationError.errorLabel?.isHidden = false
            validationError.errorLabel?.text = validationError.errorMessage
            if let textField = validationError.field as? UITextField {
                textField.layer.borderColor = UIColor.red.cgColor
                textField.layer.borderWidth = 1.0
            }
        })
        
        validator.registerField(txtPassOld, errorLabel: lbErrPassOld , rules: [RequiredRule()])
        
        validator.registerField(txtPassNew, errorLabel: lbErrPassNew, rules: [RequiredRule(), ConfirmationRule(confirmField: txtConPass)])
        
        
        validator.registerField(txtConPass, errorLabel: lbErrConPass, rules: [RequiredRule(), ConfirmationRule(confirmField: txtPassNew)])
        

    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
                
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/user/changepassword")!
        
        let HeaderPost = ["Form" : "\(String(Form_ID))"]
        
        let postString = ["OldPassword" : txtPassOld.text!,
                          "Password": txtConPass.text!,
                          "UserName": USER_NAME,
                          "Email": EMAIL_]
        

        
        Alamofire.request(feedURL, method: HTTPMethod.post,parameters: postString,encoding: JSONEncoding.default, headers: HeaderPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    
                    
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let error = dict["error"] as? String {
                            
                            self.dismiss(animated: false, completion: {
                                print("Validation Success!")
                                
                                SwiftOverlays.removeAllBlockingOverlays()
                                
                                let alert = UIAlertController(title: "Error", message: "\(error.capitalized)", preferredStyle: UIAlertControllerStyle.alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default)
                                alert.addAction(defaultAction)
                                self.present(alert, animated: true, completion: nil)
                            })
                            
                        }else{
                            self.dismiss(animated: false, completion: {
                                print("Validation Success!")
                                
                                
                                SwiftOverlays.removeAllBlockingOverlays()
                                let alert = UIAlertController(title: "SUCCESS", message: "Complate!", preferredStyle: UIAlertControllerStyle.alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in self.goToHome() })
                                alert.addAction(defaultAction)
                                self.present(alert, animated: true, completion: nil)
                            })
                            
                        }
                    }
                    
                    
                    
                    
                    
                }
                
                
                
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                //                self.alert()
                SwiftOverlays.removeAllBlockingOverlays()
                
                break
            }
            
            
        }
 
        
    }
    
    func validationFailed(_ errors:[(Validatable, ValidationError)]) {
        print("Validation FAILED!")
    }
    
    // MARK: Validate single field
    // Don't forget to use UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validator.validateField(textField){ error in
            if error == nil {
                // Field validation was successful
            } else {
                // Validation error occurred
            }
        }
        return true
    }
    
    
    func goToHome() {
        
        debugPrint("goToLogin")
        
        
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    func checkLanguage(){
        if LANGUAGE == 0 {
            lboldpass.text = "Old Password"
            lbpass.text = "New Password"
            lbConpass.text = "Confirem New Password"
           
        }else{
            lboldpass.text = "รหัสผ่านเก่า"
            lbpass.text = "รหัสผ่านใหม่"
            lbConpass.text = "ยืนยัน รหัสผ่านใหม่"
            
        }
    }

    

}


// Put this piece of code anywhere you like
extension ChengPassWordVC {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmergencyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
