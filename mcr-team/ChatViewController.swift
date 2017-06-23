import UIKit
import JSQMessagesViewController
import FirebaseDatabase
import FirebaseStorage
import Photos
import GoogleSignIn
import FirebaseAuth
import Alamofire

final class ChatViewController: JSQMessagesViewController {
 
    var myArray = Array<AnyObject>()
    var oldMessages = Array<AnyObject>()
    var page: Int = 0
    var new_message: String!
    var send_scuess = false
    // MARK: Properties
    private var messages = [JSQMessage]()
    private var photoMessageMap = [String: JSQPhotoMediaItem]()
    private var avatars = [String: JSQMessagesAvatarImage]()
    var avatarString: String!
    
    private lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    
    private lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    // TODO: - Declare messageRef as FIRDatabaseReference
    var messageQuery: [Dictionary<String, AnyObject>]? = nil
    
    let notificationChatTeam = Notification.Name("ChatTeam")
    let notificationChatUser = Notification.Name("ChatUser")
    
    //private lazy var messageRef: [Dictionary<String, AnyObject>]? = nil
    
    // TODO: - Declare storageRef as FIRStorageReference
    
    // TODO: - Declare event listener
    
    
    
    @IBAction func btnBack(_ sender: Any) {
    }
    
   
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupLogOutButton()
        observeMessages()
        
        loadPullToRefresh()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotificationTeam), name: notificationChatTeam, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.catchNotificationUser), name: notificationChatUser, object: nil)
        
        let button2 = UIButton.init(type: .custom)
        //set image for button
        button2.setImage(UIImage.fontAwesomeIcon(name: .home, textColor: UIColor.white, size: CGSize(width: 30, height: 30)), for: UIControlState.normal)
        //add function for button
        button2.addTarget(self, action: #selector(ChatViewController.backVC), for: UIControlEvents.touchUpInside)
        //set frame
        button2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        let barButton2 = UIBarButtonItem(customView: button2)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton2
        
        
        self.setNeedsStatusBarAppearanceUpdate()
        
    
    }
    
//    override var perferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
//        self.navigationController?.navigationBar.barStyle = .default
//        return .default
        get { return .default }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
 
    func backVC(){
        loadHome()
    }
    
    func loadHome() {
        
        // create viewController code...
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "Home") as! Home
        
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftViewController") as! LeftViewController
        let rightViewController = storyboard.instantiateViewController(withIdentifier: "RightViewController") as! RightViewController
        
        
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        UINavigationBar.appearance().tintColor = UIColor(red: 104, green: 159, blue: 56)
        
        UINavigationBar.appearance().tintColor = UIColor(hex: "FFFFFF")
        UINavigationBar.appearance().backgroundColor = UIColor(hex: "ff4da6")
        
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
        
        appDelegate.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        
        appDelegate.window?.rootViewController = slideMenuController
        appDelegate.window?.makeKeyAndVisible()
    }


    
    // notification update
    
    func catchNotificationTeam(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let FullName = userInfo["FullName"] as? String,
            let Text = userInfo["Text"] as? String,
            let id_user_post = userInfo["id_user_post"] as? Int,
            let avatar = userInfo["ProfileImage"] as? String,
            let updateby = userInfo["UpdateBy"] as? Int
        else {
                print("No userInfo found in notification")
                return
        }
        
        
        if(Int(updateby) != Int(Form_ID)){
            debugPrint("\(FullName) + + \(Text)")
            
            self.AddChatNotification(fullname:FullName,id:id_user_post,text: Text,image: avatar)

            
        }
        
        
        
    }
    
    func catchNotificationUser(notification:Notification) -> Void {
        print("Catch notification")
        
        guard let userInfo = notification.userInfo,
            let FullName = userInfo["FullName"] as? String,
            let Text = userInfo["Text"] as? String,
            let id_user_post = userInfo["id_user_post"] as? Int,
            let avatar = userInfo["ProfileImage"] as? String,
            let updateby = userInfo["UpdateBy"] as? Int
            else {
                print("No userInfo found in notification")
                return
        }
        
        
        if(Int(updateby) != Int(Form_ID)){
            debugPrint("\(FullName) + + \(Text)")
            
            self.AddChatNotification(fullname:FullName,id:updateby,text: Text,image: avatar)
            
            
        }
        
        
        
    }
    
    // Add Chat in Notification Team
    func AddChatNotification(fullname: String!,id: Int?,text: String!,image: String!){
        
        if  let id1 = id,
            let displayName = fullname,
            let avatar = image,
            let text1 = text {
            
            self.addMessage(withId: String(id1), name: displayName, text: text1)
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(avatar)", avatarImage: self.prepareAvatarImage(with: String(id1)))
            self.finishSendingMessage()
            
            debugPrint("add messages")
            
        }
        
    }
    
    
    // TODO: - Scrolling in jsqmessages
    func loadPullToRefresh(){
        collectionView.addInfiniteScrolling( actionHandler: { () -> Void in
            self.loadMore()
        }, direction: UInt(SVInfiniteScrollingDirectionTop) )
    }
    
    func loadMore() {
        debugPrint("Load earlier messages triggered by scroll!")
        
        self.page += 1
        
        
        if(ID_CHART == 0 ){
            downloadChatPage2Data(){
                
                self.collectionView.infiniteScrollingView.startAnimating()
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                
                if self.oldMessages.count > 0 {
                    
                    let oldBottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y
                    self.collectionView.performBatchUpdates({
                        
                        let lastIndex = self.oldMessages.count - 1
                        var indexPaths: [IndexPath] = []
                        for i in 0...lastIndex {
                            indexPaths.append(IndexPath(item: i, section: 0))
                        }
                        
                        for message in self.oldMessages {
                            
                            let messageData = message as? Dictionary<String, AnyObject>
                            
                            if  let id = messageData?["UpdateBy"] as? Int,
                                let displayName = messageData?["FullName"] as? String,
                                
                                let text = messageData?["Message"] as? String{
                                
                                let msg = JSQMessage(senderId: String(id), senderDisplayName: displayName, date: Date(), text: text)
                                
                                
                                
                                self.messages.insert(msg!, at: 0)
                                
                                if let avatar = messageData?["ProfileImage"] as? String{
                                
                                    self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(avatar)", avatarImage: self.prepareAvatarImage(with: String(describing: id)))
                                }else{
                                    self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/user.png", avatarImage: self.prepareAvatarImage(with: String(describing: id)))
                                }
                            }
                            
                            self.oldMessages.removeAll()
                            
                            
                            
                            
                            //
                        }
                        self.collectionView.insertItems(at: indexPaths)
                        
                        // invalidate layout
                        self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext())
                        
                    }, completion: { finished in
                        self.collectionView.layoutIfNeeded()
                        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - oldBottomOffset)
                        CATransaction.commit()
                        
                        self.collectionView.infiniteScrollingView.stopAnimating()
                    })
                    
                }else{
                    CATransaction.commit()
                    self.collectionView.infiniteScrollingView.stopAnimating()
                }
                
            }
        }else{
            downloadChatUserPage2Data(){
                
                self.collectionView.infiniteScrollingView.startAnimating()
                
                CATransaction.begin()
                CATransaction.setDisableActions(true)
                
                if self.oldMessages.count > 0 {
                    
                    let oldBottomOffset = self.collectionView.contentSize.height - self.collectionView.contentOffset.y
                    self.collectionView.performBatchUpdates({
                        
                        let lastIndex = self.oldMessages.count - 1
                        var indexPaths: [IndexPath] = []
                        for i in 0...lastIndex {
                            indexPaths.append(IndexPath(item: i, section: 0))
                        }
                        
                        for message in self.oldMessages {
                            
                            let messageData = message as? Dictionary<String, AnyObject>
                            
                            if  let id = messageData?["UpdateBy"] as? Int,
                                let displayName = messageData?["FullName"] as? String,
                                
                                let text = messageData?["Message"] as? String{
                                
                                let msg = JSQMessage(senderId: String(id), senderDisplayName: displayName, date: Date(), text: text)
                                
                                
                                
                                self.messages.insert(msg!, at: 0)
                                
                                if let avatar = messageData?["ProfileImage"] as? String{
                                    self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(avatar)", avatarImage: self.prepareAvatarImage(with: String(describing: id)))
                                }else{
                                    self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/user.png", avatarImage: self.prepareAvatarImage(with: String(describing: id)))
                                }
                            }
                            
                            self.oldMessages.removeAll()
                            
                            
                            
                            
                            //
                        }
                        self.collectionView.insertItems(at: indexPaths)
                        
                        // invalidate layout
                        self.collectionView.collectionViewLayout.invalidateLayout(with: JSQMessagesCollectionViewFlowLayoutInvalidationContext())
                        
                    }, completion: { finished in
                        self.collectionView.layoutIfNeeded()
                        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - oldBottomOffset)
                        CATransaction.commit()
                        
                        self.collectionView.infiniteScrollingView.stopAnimating()
                    })
                    
                }else{
                    CATransaction.commit()
                    self.collectionView.infiniteScrollingView.stopAnimating()
                }
                
            }
            
        }
    }
    
    
    // TODO: - Unregister Firebase listeners.
    
    // MARK: -
    private func setupLogOutButton() {
        let logOutButton = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        self.navigationItem.leftBarButtonItem = logOutButton
    }
    
    func signOut() {
        // TODO: - Firebase Sign out
        
        // TODO: Google Sign out
        
        let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
    }
    
    // MARK: - Collection view data source (and related) methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item]
        return self.avatars[message.senderId]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == self.senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    // MARK: - Firebase related methods
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        // TODO: - Sent text message to Firebase
        
        debugPrint("btn Press")
        
        
        let messageItem = [
            "avatar": avatarString,
            "data": text,
            "type": "text",
            "username": senderDisplayName,
            "senderId": senderId
        ]
        
        //itemRef.setValue(messageItem)
        
        let msg = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: Date(), text: text)
        
        self.new_message = text
        
        if(ID_CHART == 0){
        
        downloadChatSend(){
            //if self.send_scuess == true {
                
                            //}
        }
        }else{
            downloadChatSendUsers(){
            }
        }
        
        //self.messages.insert(msg!, at: 1)
        self.addMessage(withId: senderId, name: senderDisplayName, text: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        self.finishSendingMessage()
        
        debugPrint("add messages")

        
        
 
        

    }
    
    private func observeMessages() {
        // TODO: - Create messageQuery with query limit (25) ดึงข้อมูลมาก่อน ที่ข้อความ
        
        
        
        if(ID_CHART == 0){
            downloadChatPage1Data(){
                
                // TODO: - observe childAdded
                
                
                // TODO: - handle receive text
                
                
                for obj in self.myArray {
                    
                    let messageData = obj as? Dictionary<String, AnyObject>
                    
                    if  let id = messageData?["UpdateBy"] as? Int,
                        let displayName = messageData?["FullName"] as? String,
                        
                        let text = messageData?["Message"] as? String{
                        
                        self.addMessage(withId: String(id), name: displayName, text: text)
                        
                        
                        if let avatar = messageData?["ProfileImage"] as? String{
                        
                            self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(avatar)", avatarImage: self.prepareAvatarImage(with: String(id)))
                        }else{
                            
                             self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/user.png", avatarImage: self.prepareAvatarImage(with: String(id)))
                        }
                        
                        
                        self.finishReceivingMessage()
                        
                        debugPrint("true")
                    }else {
                        debugPrint("Error! Could not decode message data")
                    }
                    
                    
                }
                
            }
        }else{
            downloadChatUserPage1Data(){
                
                // TODO: - observe childAdded
                
                
                // TODO: - handle receive text
                
                
                for obj in self.myArray {
                    
                    let messageData = obj as? Dictionary<String, AnyObject>
                    
                    if  let id = messageData?["UpdateBy"] as? Int,
                        let displayName = messageData?["FullName"] as? String,
                        
                        let text = messageData?["Message"] as? String{
                        
                        self.addMessage(withId: String(id), name: displayName, text: text)
                        
                        if let avatar = messageData?["ProfileImage"] as? String {
                            self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/\(avatar)", avatarImage: self.prepareAvatarImage(with: String(id)))
                            
                        }else{
                            self.downloadCircleAvatar(with: "http://www.mcr-team.m-society.go.th/api/upload/profile/user.png", avatarImage: self.prepareAvatarImage(with: String(id)))
                        }
                        self.finishReceivingMessage()
                        
                        debugPrint("true")
                    }else {
                        debugPrint("Error! Could not decode message data")
                    }
                    
                    
                }
                
            }
        }
        

        
        // TODO: - observe childChanged
    }
    
    private func fetchImageDataAtURL(_ photoURL: String, forMediaItem mediaItem: JSQPhotoMediaItem, clearsPhotoMessageMapOnSuccessForKey key: String?) {
        
        ImageDownloadManager.shared.fetchImage(with: photoURL) { (image: UIImage?) in
            if let image = image {
                mediaItem.image = image
            }
            
            self.finishReceivingMessage()
            guard let key = key else { return }
            self.photoMessageMap.removeValue(forKey: key)
        }
    }
    
    // MARK: - UI and User Interaction
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.orange.withAlphaComponent(0.8))
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    public func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    private func addPhotoMessage(with id: String, displayName: String, key: String, mediaItem: JSQPhotoMediaItem) {
        if let message = JSQMessage(senderId: id, displayName: displayName, media: mediaItem) {
            messages.append(message)
            
            if (mediaItem.image == nil) {
                photoMessageMap[key] = mediaItem
            }
            
            collectionView.reloadData()
        }
    }
    
    fileprivate func sendPhotoMessage() -> String? {
        // TODO: - Sent photo message to Firebase.
        return nil
    }
    
    fileprivate func setImageURL(_ url: String, forPhotoMessageWithKey key: String) {
        // TODO: - Update existing image when generate image url successfully.
    }
    
    public func downloadCircleAvatar(with imageUrl: String, avatarImage: JSQMessagesAvatarImage) {
        ImageDownloadManager.shared.fetchImage(with: imageUrl, completion: { (image: UIImage?) in
            if let image = image {
                avatarImage.avatarImage = JSQMessagesAvatarImageFactory.circularAvatarImage(image, withDiameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            }
        })
    }
    
    public func prepareAvatarImage(with id: String) -> JSQMessagesAvatarImage! {
        if (self.avatars[id] == nil) {
            let avartarImage = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: "F", backgroundColor: UIColor.groupTableViewBackground, textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 17), diameter: UInt(kJSQMessagesCollectionViewAvatarSizeDefault))
            self.avatars[id] = avartarImage
        }
        
        return self.avatars[id]
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
/*
         // เลือกรูปภาพในการส่ง
        // physical device
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let alert = UIAlertController.init(title: "Select Image Source", message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction.init(title: "Camera", style: .default, handler: { action in
                picker.sourceType = .camera
                self.present(picker, animated: true, completion:nil)
            })
            let photoLibraryAction = UIAlertAction.init(title: "Photo Library", style: .default, handler: { action in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion:nil)
            })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cameraAction)
            alert.addAction(photoLibraryAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
            
            // simulator
        else {
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion:nil)
        }
 */
    }
    
}

// MARK: Image Picker Delegate
extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        guard let photoReferenceUrl = info[UIImagePickerControllerReferenceURL] as? URL else {
            // Handle taking a Photo from the Camera (physical device)
            guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
            
            if let key = sendPhotoMessage() {
                guard let imageData = UIImageJPEGRepresentation(image, 1.0) else { return }
                
                let imagePath = "\(key).jpg"
                
                // TODO: - Upload image to storage (camera).
            }
            
            return
        }
        
        // Handle picking a Photo from the Photo Library
        let assets = PHAsset.fetchAssets(withALAssetURLs: [photoReferenceUrl], options: nil)
        guard let asset = assets.firstObject else { return }
        guard let key = sendPhotoMessage() else { return }
        
        if TARGET_OS_SIMULATOR != 0 {
            asset.requestContentEditingInput(with: nil, completionHandler: { (contentEditingInput, info) in
                guard let imageFileURL = contentEditingInput?.fullSizeImageURL else { return }
                
                let path = "\(key).jpg"
                
                // TODO: - Upload image to storage (simulator photo library).
            })
        }
        else {
            let manager = PHImageManager.default()
            manager.requestImage(for: asset, targetSize: CGSize(width: 640.0, height: 960.0), contentMode: .aspectFit, options: nil, resultHandler: { (result, info) -> Void in
                
                guard let result = result else { return }
                
                let path = "\(key).jpg"
                guard let data = UIImageJPEGRepresentation(result, 1.0) else { return }
                
                // TODO: - Upload image to storage (physical photo library)
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion:nil)
    }
    
    private func handleImageResult(with metadata: FIRStorageMetadata?, error: Error?, key: String) {
        if let error = error {
            print("Error uploading photo: \(error.localizedDescription)")
            return
        }
        guard let downloadUrl = metadata?.downloadURL()?.absoluteString else { return }
        
        self.setImageURL(downloadUrl, forPhotoMessageWithKey: key)
    }
    
    
    func downloadChatPage1Data(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/team/\(String(TEAM_ID))/0")!
        
        let headerPost = ["From": "\(String(Form_ID))"]
        
        
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default,headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug_chat : \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                        // TODO: - observe childAdded
                        
            
                        // TODO: - handle receive text
                        

                        
                        for obj in dict {
                            
                            let messageData = obj as? Dictionary<String, AnyObject>
  
                            self.myArray.append(messageData as AnyObject)
                            
                        }
                        
                    
                        self.myArray.sort{
                            (($0 as! Dictionary<String, AnyObject>)["ID"] as? Int)! < (($1 as! Dictionary<String, AnyObject>)["ID"] as? Int)!
                        }
                        
                        debugPrint(self.myArray)
                        
     
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
    
    func downloadChatPage2Data(completed: @escaping DownloadComplete){
        
        //Alamofire download
       
        debugPrint(self.page)
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/team/\(String(TEAM_ID))/\(String(self.page))")!
        
        let headerPost = ["From": "\(String(Form_ID))"]
        
        
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default,headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug_chat : \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                        // TODO: - observe childAdded
                        
                        
                        // TODO: - handle receive text
                        
                        
                        
                        for obj in dict {
                            
                            let messageData = obj as? Dictionary<String, AnyObject>
                            
                            //self.myArray.append(messageData as AnyObject)
                            self.oldMessages.append(messageData as AnyObject)
                            
                        }
                        
                        
                        
                        
                        debugPrint(self.oldMessages)
                        
                        
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
    
    
    func downloadChatUserPage2Data(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        debugPrint(self.page)
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/user/\(String(ID_CHART))/\(String(self.page))")!
        
        let headerPost = ["From": "\(String(Form_ID))"]
        
        
        
        
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default,headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug_chat : \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                        // TODO: - observe childAdded
                        
                        
                        // TODO: - handle receive text
                        
                        
                        
                        for obj in dict {
                            
                            let messageData = obj as? Dictionary<String, AnyObject>
                            
                            //self.myArray.append(messageData as AnyObject)
                            self.oldMessages.append(messageData as AnyObject)
                            
                        }
                        
                        
                        
                        
                        debugPrint(self.oldMessages)
                        
                        
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
    
    func downloadChatSend(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        debugPrint(new_message)
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/team")!
        
        let headerPost = ["From": String(Form_ID)]
        
        let postString2 = [
            "TeamID": "\(String(TEAM_ID))",
            "Message": new_message
            ]
        
        
        Alamofire.request(feedURL, method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let postID1 = dict["ID"] as? Int {
                            self.send_scuess = true
                        }
                        
                    }
                    
                }
                
                break
            case .failure(_):
                
                
                debugPrint("error")
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
        
    }
    
    
    func downloadChatSendUsers(completed: @escaping DownloadComplete){
        
        //Alamofire download
        
        debugPrint(new_message)
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/user")!
        
        let headerPost = ["From": String(Form_ID)]
        
        let postString2 = [
            "ToUserID": "\(String(ID_CHART))",
            "Message": new_message
        ]
        
        
        Alamofire.request(feedURL, method: HTTPMethod.post, parameters: postString2,encoding: JSONEncoding.default, headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    print("debug : response3 \(response.result.value)")
                    if let dict = response.result.value as? Dictionary<String, AnyObject> {
                        
                        if let postID1 = dict["ID"] as? Int {
                            self.send_scuess = true
                        }
                        
                    }
                    
                }
                
                break
            case .failure(_):
                
                
                debugPrint("error")
                
                
                print("debug : failure \(response.result.error)")
                break
            }
            
        }
        
    }

    
    
    func downloadChatUserPage1Data(completed: @escaping DownloadComplete){
        
        //Alamofire download
        debugPrint(ID_CHART)
        
        let feedURL = URL(string: "http://www.mcr-team.m-society.go.th/api/chat/user/\(String(ID_CHART))/0")!
        
        let headerPost = ["From": String(Form_ID)]
        
       
      
        
        Alamofire.request(feedURL, method: HTTPMethod.get,encoding: JSONEncoding.default,headers: headerPost).responseJSON { (response: DataResponse<Any>) in
            
             print("debug_chat : \(response.result.value)")
            
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                    
                    print("debug_chat : \(response.result.value)")
                    
                    if let dict = response.result.value as? [Dictionary<String, AnyObject>] {
                        
                        
                        // TODO: - observe childAdded
                        
                        
                        // TODO: - handle receive text
                        
                        self.myArray.removeAll()
                        
                        for obj in dict {
                            
                            let messageData = obj as? Dictionary<String, AnyObject>
                            
                            self.myArray.append(messageData as AnyObject)
                            
                        }
                        
                        
                        self.myArray.sort{
                            (($0 as! Dictionary<String, AnyObject>)["ID"] as? Int)! < (($1 as! Dictionary<String, AnyObject>)["ID"] as? Int)!
                        }
                        
                        debugPrint(self.myArray)
                        
                        
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
    
    
    

    
}

extension UINavigationController {
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        if let lastVC = self.viewControllers.last
        {
            return lastVC.preferredStatusBarStyle
        }
        
        return .default
    }
}



