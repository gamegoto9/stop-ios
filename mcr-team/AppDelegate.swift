//
//  AppDelegate.swift
//  mcr-team
//
//  Created by LIKIT on 1/23/2560 BE.
//  Copyright © 2560 LIKIT. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import UserNotifications
import SlideMenuControllerSwift
import Google




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url,
            sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    
  

    var window: UIWindow?
    var _firebaseToken: String!
    let gcmMessageIDKey = "gcm.message_id"

    
    fileprivate func createMenuView() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        
/*
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: loginViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(red: 104, green: 159, blue: 56)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "FFFFFF")
        UINavigationBar.appearance().backgroundColor = UIColor(hex: "ff4da6")
        
        
        
        let slideMenuController = ExSlideMenuController(leftViewController)
        
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = mainViewController
        
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
*/
        self.window?.rootViewController = loginViewController
        self.window?.makeKeyAndVisible()
//        let nav = storyboard.instantiateViewController(withIdentifier: "pushData") as! UINavigationController
//        appDelegate.window?.rootViewController = nav

        

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let content = UNMutableNotificationContent()
            let sound1 = content.sound = UNNotificationSound.default()
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
           
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        FIRApp.configure()
        
        
        // [START add_token_refresh_observer]
        // Add observer for InstanceID token refresh callback.
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        // [END add_token_refresh_observer]
        
        // Initialize sign-in
        /*
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(configureError)")
        
        GIDSignIn.sharedInstance().delegate = self
        */
        
        // create viewController code...
         createMenuView()
  
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.tintColor = UIColor(colorLiteralRed: 228/255, green: 0/255, blue: 79/255, alpha: 100.0/100.0)
        navigationBarAppearace.barTintColor = UIColor(colorLiteralRed: 228/255, green: 0/255, blue: 79/255, alpha: 100.0/100.0)
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        navigationBarAppearace.tintColor = UIColor.white
        
        UITabBar.appearance().barTintColor = UIColor(colorLiteralRed: 228/255, green: 0/255, blue: 79/255, alpha: 100.0/100.0)
        UITabBar.appearance().tintColor = UIColor.white
        
        UIApplication.shared.statusBarStyle = .default
        
    
        
        return true
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFBM()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack


    //static let sharedInstance = CoreDataManager()
    
    private lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "mcr_team", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SignleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            // Configure automatic migration.
            let options = [ NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true ]
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        
        var managedObjectContext: NSManagedObjectContext?
        if #available(iOS 10.0, *){
            
            managedObjectContext = self.persistentContainer.viewContext
        }
        else{
            // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
            let coordinator = self.persistentStoreCoordinator
            managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            managedObjectContext?.persistentStoreCoordinator = coordinator
            
        }
        return managedObjectContext!
    }()
    // iOS-10
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "mcr_team")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        print("\(self.applicationDocumentsDirectory)")
        return container
    }()
    
    
    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [String: AnyObject]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [String: AnyObject],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        
        //if let message = (userInfo["aps"] as? [String: Any])?["alert"] as? String {
        
        
        
        var FullName: String!
        var Text: String!
        var id2: Int?
        var profileimg: String!
        var updateby: Int?
        var chatTeam: Int = 0
        
        var id_post_emergency: String!
        
        if let aps = userInfo["TeamChatMessage"]  {

            
            let dict = convertToDictionary(text: aps as! String)
            
            
            
            debugPrint(dict?["FullName"])
        
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["UpdateBy"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            
            
            
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatTeam = Notification.Name("ChatTeam")
            
            
            NotificationCenter.default.post(name: notificationChatTeam, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy":id2!
                ])
            
            chatTeam = 1
            Chat_status = 1
            
           

        }else if let aps = userInfo["UserChatMessage"] {
            
            let dict = convertToDictionary(text: aps as! String)
            
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["ToUserID"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            updateby = dict?["UpdateBy"] as? Int
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatUser = Notification.Name("ChatUser")
            
            
            NotificationCenter.default.post(name: notificationChatUser, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy": updateby!
                ])
            
            chatTeam = 0
            Chat_status = 1
            
        }else if let aps = userInfo["ID"] {
            let dict = convertToDictionary(text: aps as! String)
            //id_post_emergency = dict?["ID"] as! Int?
            
            id_post_emergency = userInfo["ID"] as! String!
            
            Chat_status = 2
            Feed_data_post = Int(id_post_emergency)!
            debugPrint(id_post_emergency)
            
        }else{
            debugPrint("NO DATA")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here
            debugPrint("active")
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            debugPrint("inactive")
            
            PUSH_NOTIFICATION = 1
            /*
            if userInfo["TeamChatMessage"] != nil || userInfo["UserChatMessage"] != nil {
            */
            
            if(Form_ID != nil){
                
                if Chat_status == 1 {
                    
                    PUSH_NOTIFICATION = 0
                    
                    if(chatTeam == 1){
                        ID_CHART = 0
                    }else{
                        ID_CHART = updateby
                    }
                        
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! ChatViewController
                    chatVC.senderId = "\(String(Form_ID))"
                    chatVC.senderDisplayName = USER_NAME
                    chatVC.avatarString = "Chat Team"
                    
                    appDelegate.window?.rootViewController = nav
                }else{
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "pushData") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! DataFeedsViewController2
                    
                    
                    appDelegate.window?.rootViewController = nav
                    
                    
                    
                }
                
            }else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                
                
                
                appDelegate.window?.rootViewController = loginViewController
                
            }
            //}
            
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            debugPrint("background")
            break
        default:
            break
        }
    }
    // [END receive_message]
    
    
    
    // Firebse 
    
    func tokenRefreshNotification(notification: NSNotification){
        let refreshedToken = FIRInstanceID.instanceID().token()
        
        print("InstanceId token: \(refreshedToken)")
        
        self._firebaseToken = refreshedToken
       
        
        connectToFBM()
        
        // Define identifier
        if(UserDefaults.standard.string(forKey: "firebaseToken") == nil) {
            
        let notificationName = Notification.Name("tokenRecieved")
            
            UserDefaults.standard.setValue(refreshedToken, forKey: "firebaseToken")
            
        NotificationCenter.default.post(name: notificationName, object: nil)
        }
        
    }
    
    func connectToFBM() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil){
                print("Unble to connect \(error)")
            }else{
                print("Connected to FCM")
            }
        }
    }
    
    

}



let appDelegate = UIApplication.shared.delegate as! AppDelegate

@available(iOS 10.0, *)
let context = appDelegate.persistentContainer.viewContext

let context9 = appDelegate.managedObjectContext


// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
        
        
       
        
        var FullName: String!
        var Text: String!
        var id2: Int?
        var profileimg: String!
        var updateby: Int?
        var id_post_emergency: String!
        var chatTeam: Int = 0
        
        if let aps = userInfo["TeamChatMessage"]  {
            
            
            let dict = convertToDictionary(text: aps as! String)
            
            
            
            debugPrint(dict?["FullName"])
            
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["UpdateBy"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            
            
            
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatTeam = Notification.Name("ChatTeam")
            
            
            NotificationCenter.default.post(name: notificationChatTeam, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy":id2!
                ])
            
            chatTeam = 1
            Chat_status = 1
            
            
            
        }else if let aps = userInfo["UserChatMessage"] {
            
            let dict = convertToDictionary(text: aps as! String)
            
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["ToUserID"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            updateby = dict?["UpdateBy"] as? Int
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatUser = Notification.Name("ChatUser")
            
            
            NotificationCenter.default.post(name: notificationChatUser, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy":updateby!
                ])
            
            chatTeam = 0
            Chat_status = 1
            
        }else if let aps = userInfo["ID"] {
            let dict = convertToDictionary(text: aps as! String)
            //id_post_emergency = dict?["ID"] as! Int?
            
            id_post_emergency = userInfo["ID"] as! String!
            
            Chat_status = 2
            Feed_data_post = Int(id_post_emergency)!
            debugPrint(id_post_emergency)
            
        }else{
            debugPrint("NO DATA")
        }
        
        // Print full message.
        print(userInfo)
        
        
        let state = UIApplication.shared.applicationState
        

        switch state {
        case .active:
            //app is currently active, can update badges count here
            debugPrint("active")
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            debugPrint("inactive")
            
            PUSH_NOTIFICATION = 1
            /*
             if userInfo["TeamChatMessage"] != nil || userInfo["UserChatMessage"] != nil {
             */
            
            if(Form_ID != nil){
                
                if Chat_status == 1 {
                    
                    PUSH_NOTIFICATION = 0
                    
                    if(chatTeam == 1){
                        ID_CHART = 0
                    }else{
                        ID_CHART = updateby
                    }
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! ChatViewController
                    chatVC.senderId = "\(String(Form_ID))"
                    chatVC.senderDisplayName = USER_NAME
                    chatVC.avatarString = "Chat Team"
                    
                    appDelegate.window?.rootViewController = nav
                }else{
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "pushData") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! DataFeedsViewController2
                    
                    
                    appDelegate.window?.rootViewController = nav
                    
                    
                    
                }
                
            }else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                
                
                
                appDelegate.window?.rootViewController = loginViewController
                
            }
            //}
            
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            debugPrint("background")
            break
        default:
            break
        }

        
        
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
//        if let messageID = userInfo[gcmMessageIDKey] {
//            print("Message ID: \(messageID)")
//        }
//        
//        // Print full message.
//        print(userInfo)
        
       
        
        var FullName: String!
        var Text: String!
        var id2: Int?
        var profileimg: String!
        var updateby: Int?
        var id_post_emergency: String!
        var chatTeam: Int = 0
        
        if let aps = userInfo["TeamChatMessage"]  {
            
            
            let dict = convertToDictionary(text: aps as! String)
            
            
            
            debugPrint(dict?["FullName"])
            
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["UpdateBy"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            
            
            
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatTeam = Notification.Name("ChatTeam")
            
            
            NotificationCenter.default.post(name: notificationChatTeam, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy":id2!
                ])
            
            chatTeam = 1
            Chat_status = 1
            
            
            
        }else if let aps = userInfo["UserChatMessage"] {
            
            let dict = convertToDictionary(text: aps as! String)
            
            FullName = dict?["FullName"] as! String!
            Text = dict?["Message"] as! String!
            id2 = dict?["ToUserID"] as? Int
            profileimg = dict?["ProfileImage"] as! String!
            updateby = dict?["UpdateBy"] as? Int
            
            debugPrint("\(FullName!) == \(Text!) == \(id2) == \(profileimg!)")
            
            let notificationChatTeam = Notification.Name("ChatTeam")
            
            
            NotificationCenter.default.post(name: notificationChatTeam, object: nil,userInfo: [
                "FullName":FullName,
                "Text":Text,
                "id_user_post":id2!,
                "ProfileImage":profileimg,
                "UpdateBy":updateby!
                ])
            
            chatTeam = 0
            Chat_status = 1
            
        }else if let aps = userInfo["ID"] {
            let dict = convertToDictionary(text: aps as! String)
            //id_post_emergency = dict?["ID"] as! Int?
            
            id_post_emergency = userInfo["ID"] as! String!
            
            Chat_status = 2
            Feed_data_post = Int(id_post_emergency)!
            debugPrint(id_post_emergency)
            
        }else{
            debugPrint("NO DATA")
        }
        
        // Print full message.
        print(userInfo)
        
 
        
        let state = UIApplication.shared.applicationState
        switch state {
        case .active:
            //app is currently active, can update badges count here
            debugPrint("active")
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            debugPrint("inactive")
            
            PUSH_NOTIFICATION = 1
            /*
             if userInfo["TeamChatMessage"] != nil || userInfo["UserChatMessage"] != nil {
             */
            
            if(Form_ID != nil){
                
                if Chat_status == 1 {
                    
                    PUSH_NOTIFICATION = 0
                    if(chatTeam == 1){
                        ID_CHART = 0
                    }else{
                        ID_CHART = updateby
                    }
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "NavChatViewController") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! ChatViewController
                    chatVC.senderId = "\(String(Form_ID))"
                    chatVC.senderDisplayName = USER_NAME
                    chatVC.avatarString = "Chat Team"
                    
                    appDelegate.window?.rootViewController = nav
                }else{
                    
                    
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let nav = storyboard.instantiateViewController(withIdentifier: "pushData") as! UINavigationController
                    
                    let chatVC = nav.viewControllers[0] as! DataFeedsViewController2
                    
                    
                    appDelegate.window?.rootViewController = nav
                    
                    
                    
                }
                
            }else{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "Login") as! Login
                
                
                
                appDelegate.window?.rootViewController = loginViewController
                
            }
            //}
            
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            debugPrint("background")
            break
        default:
            break
        }

        
        completionHandler()
    }
    
    //  START : google sign in
    
    /*
    func application(application: UIApplication,
                     openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        var options: [String: AnyObject] = [UIApplicationOpenURLOptionsKey.sourceApplication.rawValue: sourceApplication as AnyObject,
                                            UIApplicationOpenURLOptionsKey.annotation.rawValue: annotation!]
        return GIDSignIn.sharedInstance().handle(url as URL!,
                                                    sourceApplication: sourceApplication,
                                                    annotation: annotation)
    }
    

    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let givenName = user.profile.givenName
            let familyName = user.profile.familyName
            let email = user.profile.email
            
            debugPrint(userId)
            
            let notificationName = Notification.Name("tokenGoogle")
            
//            UserDefaults.standard.setValue(Any?, forKey: "googleToken")
            
            NotificationCenter.default.post(name: notificationName, object: nil,
                                            userInfo: ["FullName":fullName,
                                                       "Email":email])
            
            // ...
        } else {
            print("\(error.localizedDescription)")
        }
    }

    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
    */
//    End google sign in
    

    
    
}



// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
// [END ios_10_data_message_handling]
