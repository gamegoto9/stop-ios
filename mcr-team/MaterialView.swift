//
//  MaterialView.swift
//  core_data_full
//
//  Created by LIKIT on 1/27/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {
    
    @IBInspectable var materialDesign: Bool {
        get {
            return materialKey
        }
        set {
            materialKey = newValue
            
            if materialKey {
                self.layer.masksToBounds = false
                
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/225, green: 157/225, blue: 157/225, alpha: 1.0).cgColor
                
            }else{
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil
            }
        }
        
    }
    

}
