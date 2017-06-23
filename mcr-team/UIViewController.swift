//
//  UIViewControllerExtension.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 1/19/15.
//  Copyright (c) 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import FontAwesome_swift


extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
        
        if(USER_TYPE_G != 3){
            //self.addRightBarButtonWithImage(UIImage(named: "ic_menu_black_24dp")!)
            
            self.addRightBarButtonWithImage(UIImage.fontAwesomeIcon(name: .wechat, textColor: UIColor.white, size: CGSize(width: 30, height: 30)))
            self.slideMenuController()?.removeRightGestures()
            self.slideMenuController()?.addRightGestures()
        }
        
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
        
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.removeRightGestures()
    }
}
