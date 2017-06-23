//
//  LeftViewController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 12/3/14.
//

import UIKit
import SlideMenuControllerSwift


enum LeftMenu: Int {
    case Home = 0
    case Profile
    case Team_info
    case Team_other
    case Cheng_password
    case General
    case LogOut
}

protocol LeftMenuProtocol : class {
    func changeViewController(_ menu: LeftMenu)
}

class LeftViewController : UIViewController, LeftMenuProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var menus = ["Home", "Profile","Log Out"]
    var menus2 = [String]()
    
    
    var Home: UIViewController!
    var ProfileViewController: UIViewController!
    var logOutVC: LogOutVC!
    
    var ChengPassVC: UIViewController!
    
    var ShowTeamVC: UIViewController!
    
    var ShowUserVC: UIViewController!
   
    var DetailUserStaff: UIViewController!
    
    
    var imageHeaderView: ImageHeaderView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func check_menu(){
        
        debugPrint(USER_TYPE_G)
        
        if(LANGUAGE == 0){
            
            if(USER_TYPE_G == 3){
                
                menus2.removeAll()
                menus2 += ["Home"]
                menus2 += ["Profile"]
                menus2 += ["Change Password"]
                menus2 += ["Log Out"]
            } else if (USER_TYPE_G == 2){
                menus2.removeAll()
                menus2 += ["Home"]
                menus2 += ["Profile"]
                menus2 += ["User in Team"]
                menus2 += ["Other Team"]
                menus2 += ["Change Password"]
                menus2 += ["Log Out"]
            } else if (USER_TYPE_G == 1){
                menus2.removeAll()
                menus2 += ["Home"]
                menus2 += ["Profile"]
                menus2 += ["User in Team"]
                menus2 += ["General User"]
                menus2 += ["Change Password"]
                menus2 += ["Log Out"]
            }
        }else{
            if(USER_TYPE_G == 3){
                
                menus2.removeAll()
                menus2 += ["หน้าหลัก"]
                menus2 += ["โปรไฟล์"]
                menus2 += ["เปลี่ยนรหัสผ่าน"]
                menus2 += ["ออกระบบ"]
            } else if (USER_TYPE_G == 2){
                menus2.removeAll()
                menus2 += ["หน้าหลัก"]
                menus2 += ["โปรไฟล์"]
                menus2 += ["ข้อมูลทีมสหวิชาชีพ"]
                menus2 += ["ข้อมูลทีมสหวิชาชีพอื่นๆ"]
                menus2 += ["เปลี่ยนรหัสผ่าน"]
                menus2 += ["ออกระบบ"]
            } else if (USER_TYPE_G == 1){
                menus2.removeAll()
                menus2 += ["หน้าหลัก"]
                menus2 += ["โปรไฟล์"]
                menus2 += ["ข้อมูลทีมสหวิชาชีพ"]
                menus2 += ["ผู้ใช้งานลงทะเบียน"]
                menus2 += ["เปลี่ยนรหัสผ่าน"]
                menus2 += ["ออกระบบ"]
            }
            
        }
    }
   
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        check_menu()
        
        
        
        self.tableView.separatorColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let Home = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        self.Home = UINavigationController(rootViewController: Home)
        
        let ProfileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        self.ProfileViewController = UINavigationController(rootViewController: ProfileViewController)
        
        let ChengPassViewVC = storyboard.instantiateViewController(withIdentifier: "ChengPasswordVC") as! ChengPassWordVC
        self.ChengPassVC = UINavigationController(rootViewController: ChengPassViewVC)
        
        
        let ShowTeamViewVC = storyboard.instantiateViewController(withIdentifier: "ShowTeamVC") as! ShowTeamViewController
        self.ShowTeamVC = UINavigationController(rootViewController: ShowTeamViewVC)
        
        
        let ShowUserViewVC = storyboard.instantiateViewController(withIdentifier: "ShowUserVC") as! ShowUserViewController2
        self.ShowUserVC = UINavigationController(rootViewController: ShowUserViewVC)
        
//        let detailUserStaff = storyboard.instantiateViewController(withIdentifier: "edit_data_staff") as! DetailUsersViewController
//        
//        self.DetailUserStaff = UINavigationController(rootViewController: detailUserStaff)
        
        
        
        
        //self.tableView.registerCellClass(BaseTableViewCell.self)
        self.tableView.register(BaseTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        
        self.imageHeaderView = ImageHeaderView.loadNib()
        self.view.addSubview(self.imageHeaderView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        check_menu()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageHeaderView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 160)
        self.view.layoutIfNeeded()
    }
    
    func changeViewController(_ menu: LeftMenu) {
        switch menu {
        case .Home:
            self.slideMenuController()?.changeMainViewController(self.Home, close: true)
        case .Profile:
            
            if(USER_TYPE_G != 3){
                
                edit_profile_staff = 1
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let nav = storyboard.instantiateViewController(withIdentifier: "edit_data_staff") as! UITabBarController
                
                
                let navigationController = UINavigationController(rootViewController: nav)
                
                //self.present(navigationController, animated: true, completion: nil)
                
                
                appDelegate.window?.rootViewController = navigationController
                
                
                
                
            }else{
                self.slideMenuController()?.changeMainViewController(self.ProfileViewController, close: true)
            }
        case .LogOut:
            funcLogOut()
            
        case .Cheng_password:
            self.slideMenuController()?.changeMainViewController(self.ChengPassVC, close: true)
        case .Team_info:
            /*
            performSegue(withIdentifier: "getShowUsers", sender: Int(TEAM_ID))
            debugPrint("User in Team")
             */
            
            if(USER_TYPE_G == 1){
                self.slideMenuController()?.changeMainViewController(self.ShowTeamVC, close: true)
            }else{
                self.slideMenuController()?.changeMainViewController(self.ShowUserVC, close: true)
            }
        case .Team_other:
            self.slideMenuController()?.changeMainViewController(self.ShowTeamVC, close: true)
            debugPrint("Other Team")
        case .General:
            debugPrint("Generial")
            self.slideMenuController()?.changeMainViewController(self.ShowUserVC, close: true)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "getShowUsers" {
            if let destination = segue.destination as? ShowUserViewController {
                if let id_feed = sender as? Int {
                    destination.id_feed = id_feed
                }
            }
        }
        
    }
    
    func funcLogOut(){
       
        
        logOutVC = LogOutVC()
        
        logOutVC.logOut()
    }
}

extension LeftViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
           
            
            
            case .Home, .Profile, .Team_info, .Team_other, .Cheng_password, .General, .LogOut  :
                return BaseTableViewCell.height()
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        if let menu = LeftMenu(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
         */
        
        
        if(USER_TYPE_G == 3) {
            switch indexPath.row {
            case 0:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 1:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 2:
                let menu = LeftMenu(rawValue: 4)
                self.changeViewController(menu!)
            case 3:
                let menu = LeftMenu(rawValue: 6)
                self.changeViewController(menu!)
            default:
                debugPrint("not value select menu")
            }
        }else if(USER_TYPE_G == 2){
            switch indexPath.row {
            case 0:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 1:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 2:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 3:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 4:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 5:
                let menu = LeftMenu(rawValue: 6)
                self.changeViewController(menu!)
            default:
                debugPrint("not value select menu")
            }
            
        }else if(USER_TYPE_G == 1){
            switch indexPath.row {
            case 0:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 1:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 2:
                let menu = LeftMenu(rawValue: indexPath.row)
                self.changeViewController(menu!)
            case 3:
                let menu = LeftMenu(rawValue: 5)
                self.changeViewController(menu!)
            case 4:
                let menu = LeftMenu(rawValue: 4)
                self.changeViewController(menu!)
            case 5:
                let menu = LeftMenu(rawValue: 6)
                self.changeViewController(menu!)
            default:
                debugPrint("not value select menu")
            }
            
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.tableView == scrollView {
            
        }
    }
}

extension LeftViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus2.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let menu = LeftMenu(rawValue: indexPath.row) {
            switch menu {
            
            case .Home, .Profile, .Team_info, .Team_other, .Cheng_password, .General, .LogOut :
                let cell = BaseTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: BaseTableViewCell.identifier)
                cell.setData(menus2[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
