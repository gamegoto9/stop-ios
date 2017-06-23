
//
//  RegisterViewController.swift
//  mcr-team
//
//  Created by LIKIT on 2/13/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import SwiftValidator
import Alamofire
import SwiftOverlays


class RegisterViewController: UIViewController,UITextFieldDelegate,ValidationDelegate {

    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    
    @IBOutlet weak var password: UITextField!
    
    
    @IBOutlet weak var confPassword: UITextField!
    
    
    @IBOutlet weak var phoneNum: UITextField!
    
    
//    massger Error
    
    @IBOutlet weak var txtErrUsername: UILabel!
    @IBOutlet weak var txtErrEmail: UILabel!
    
    @IBOutlet weak var txtErrPassword: UILabel!
    
    @IBOutlet weak var txtErrCofPassword: UILabel!
    
    @IBOutlet weak var txtErrPhone: UILabel!
    
    let validator = Validator()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.hideKeyboardWhenTappedAround()
         self.navigationController?.isNavigationBarHidden = false

         varidation()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.hideKeyboardWhenTappedAround()
        
        
        varidation()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
        }
    
    
    @IBAction func btnPass(_ sender: Any) {
       
        print("Validating...")
        validator.validate(self)
        
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
        
        validator.registerField(username, errorLabel: txtErrUsername , rules: [RequiredRule()])
        
        
    
        validator.registerField(email, errorLabel: txtErrEmail, rules: [RequiredRule(), EmailRule()])
        
        validator.registerField(password, errorLabel: txtErrPassword, rules: [RequiredRule(), ConfirmationRule(confirmField: confPassword)])
        
    
        validator.registerField(confPassword, errorLabel: txtErrCofPassword, rules: [RequiredRule(), ConfirmationRule(confirmField: password)])
        
        
        validator.registerField(phoneNum, errorLabel: txtErrPhone, rules: [RequiredRule(), MinLengthRule(length: 10)])
    }
    
    // MARK: ValidationDelegate Methods
    
    func validationSuccessful() {
        
        
        SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")
        
        
        //Alamofire download
        
        
        let feedURL = URL(string: URL_LOGIN_GOOGLE)!
        
        let postString = ["FullName" : username.text!,
                          "FirebaseToken": UserDefaults.standard.string(forKey: "firebaseToken"),
                          "Email":email.text!,
                          "UserName":username.text!,
                          "UserType":"3",
                          "VerifyType":"1",
                          "TelephoneNumber":phoneNum.text!,
                          "Password":confPassword.text!]
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.post,parameters: postString,encoding: JSONEncoding.default).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    
                    self.dismiss(animated: false, completion: {
                        print("Validation Success!")
                        
                        SwiftOverlays.removeAllBlockingOverlays()
                        
                        let alert = UIAlertController(title: "Success", message: "Register Successful", preferredStyle: UIAlertControllerStyle.alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { action in self.goToLogin() })
                        alert.addAction(defaultAction)
                        self.present(alert, animated: true, completion: nil)
                    })
                    
                }
                
                
                
                break
            case .failure(_):
                print("debug : failure \(response.result.error)")
                SwiftOverlays.removeAllBlockingOverlays()
                
                let alert = UIAlertController(title: "Error", message: "Connection error", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(defaultAction)
                self.present(alert, animated: true, completion: nil)
                
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
    
    
    func goToLogin() {
    
        debugPrint("goToLogin")
        
        
          _ = navigationController?.popToRootViewController(animated: true)
    }


}


// Put this piece of code anywhere you like
extension RegisterViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmergencyViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

