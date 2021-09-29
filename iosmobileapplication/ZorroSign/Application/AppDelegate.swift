//
//  AppDelegate.swift
//  ZorroSign
//
//  Created by Apple on 24/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON
import StoreKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import Branch

import ADCountryPicker

let appDelegate = UIApplication.shared.delegate as! AppDelegate
//@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    var window: UIWindow?

    private var timer: Timer?
    var alert: UIAlertController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        UINavigationBar.appearance().tintColor = UIColor(red: 0.00, green: 0.60, blue: 0.07, alpha: 1.00)
        
        let iscrashed = ZorroTempData.sharedInstance.getCrashedLastTime()
        if iscrashed {
            ZorroTempData.sharedInstance.setCrashedLastTime(crashed: false)
            ZorroTempData.sharedInstance.setIsUserLoggedIn(islogged: false)
        } else {
            ZorroTempData.sharedInstance.setCrashedLastTime(crashed: true)
        }
       
        //MARK: - BranchIO Setup
//        Branch.setUseTestBranchKey(true)
//        Branch.getInstance()?.setDebug()
//        Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
//            // do stuff with deep link data (nav to page, display content, etc)
//            print(params as? [String: AnyObject] ?? {})
//        }
        
        
        
        // Override point for customization after application launch.
//        Thread.sleep(forTimeInterval: 3.0)
//        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(DashboardViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(ContactsVC.self)
        
        // register notification for user inactivity
        NotificationCenter.default.addObserver(self, selector: #selector(callLogoutAPI), name: .appTimeout, object: nil)
        
        // register notification for login
        NotificationCenter.default.addObserver(self, selector: #selector(loginDone), name: .userDidLogin, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(logoutDone), name: .userDidLogout, object: nil)
        
        UserDefaults.standard.set("", forKey: "qrcode")
        
        if #available( iOS 10.3,*){
            //SKStoreReviewController.requestReview()
        }
        
        UserDefaults.standard.set(true, forKey: "launch")
        
        //printFonts()
        
        FirebaseApp.configure()
        Fabric.sharedSDK().debug = true
        setupNotification(application: application)
        
//        let pkihelper = PKIHelper()
//        pkihelper.decryptWithPrivateKey(keyid: "8A9E7230-76B1-4460-8261-A990FF976A0F", encryptedText: "abbbbbb") { (hello) in
//
//        }
//        let encrypted = pkihelper.encryptWithPublicKey(textIn: "Chanaka Anuradh")
    
        
//        pkihelper.decryptWithPrivateKey(keyid: "C37A85D4-335D-445E-9818-1BE9C5D4EDF9", encryptedText: "LCJJiELxzK+yU84tJHH9IDw+UB/j6ER7VkfIzTjDOuYPPq4p17HeQt1A9b6IxXc3IHrxhBGAY3jQPu4/kCA1uEgJudGmd8C0x5wz/KJ2MVXDPjY8K+aGdBVe+bHyUBsPggwUcdcnHKH25NkSdKTE2RAXoX0KGR75abjjwF4XwRiPUOoIyk5190vSGg0LEs0cBzuY0JxJxmWn4/Hc44TzvWXKNSQ1ylJ1OZhAL14bnYQfREgX1lpQVbkr3FPT6MIPQWQsraz1j9uEeaKopFkr4/yBtzAaKKbZbfNDFkeSM2ZatYoqXMdRv61HIozCvIR8iN14fIuepq8KYBkfZHiBqA==") { (abc) in
//
//        }
    
//        
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//        let rootviewcontorller = MultifactorSettingsViewController()
//        let navicontroller = UINavigationController(rootViewController: rootviewcontorller)
//        window?.rootViewController = navicontroller

        return true
    }
    
    func setupNotification(application: UIApplication) {
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
             //For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token (FCM_Token): \(fcmToken)")
        
        UserDefaults.standard.set(fcmToken, forKey: "deviceId")
        
        //let dataDict:[String: String] = ["token": fcmToken]
        //NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
        
        
    }
    
    @available(iOS 10, *)
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        
        // Print full message.
        print("willPresent notification: \(userInfo)")
        
        // Change this to your preferred presentation option
        if UIApplication.shared.applicationState == .active {
            let notificationdata = NotificationData(dictionary: userInfo)
            print(notificationdata.Email)
            if let notificationtype = notificationdata.NotificationType {
                if notificationtype == 16 {
                    completionHandler([])
                }
            }
            else {
                completionHandler(UNNotificationPresentationOptions.alert)
            }
        } else {
            completionHandler(UNNotificationPresentationOptions.alert)
        }
    }
   
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
    
        UIApplication.shared.applicationIconBadgeNumber += 1
        
        
        let notificationdata = NotificationData(dictionary: userInfo)
        
        
        if let notificationtype = notificationdata.NotificationType, let metadata = notificationdata.metaData {
            
            if notificationtype == 16 {
                
                if let jsonbody = convertdocprocesstoDictonary(jsonstring: metadata) {
                    
                    let corid = jsonbody["EncCorrelationId"] as! String
                    let username = jsonbody["UserId"] as! String
                    let keyid = jsonbody["KeyId"] as! String


                    let pkihelper = PKIHelper()
                    pkihelper.decryptWithPrivateKey(keyid: keyid, encryptedText: corid) { (decryptedcorid) in
                    
                        self.validateuserWithBiometrics(userid: username, corerelation: decryptedcorid ?? "", keyid: keyid)
                    }
                    return
                }
            }
        }
        
        /*
         [AnyHashable("google.c.a.e"): 1, AnyHashable("processId"): 12065, AnyHashable("workflowId"): 0, AnyHashable("body"): You have a document waiting for you to sign., AnyHashable("title"): Review Esign, AnyHashable("type"): 2, AnyHashable("aps"): {
         alert = "You have a document waiting for you to sign.";
         "content-available" = 1;
         sound = default;
         }, AnyHashable("gcm.message_id"): 0:1549443413664791%e7e4eb6ae7e4eb6a, AnyHashable("Id"): 42]
         */
//        let notifData =  NotificationData(dictionary: userInfo)
//        if notifData.NotificationType == 2 { // if doc sign notification, refresh dashboard
//            NotificationCenter.default.post(name: NSNotification.Name.init("RefreshNotification"), object: nil)
//        }
//        showNotificationAlert(notifData: notifData)
//        handlePush(notifData: notifData, app: application)
    }
    
    
    
    // The callback to handle data message received via FCM for devices running iOS 10 or above.
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
        
        let notifData =  NotificationData(dictionary: remoteMessage.appData)
        
        let ProfileId: String = ZorroTempData.sharedInstance.getProfileId()
        
        if !ProfileId.isEmpty {
            
//            if notifData.NotificationType == 2 {
//
//                if #available(iOS 11.0, *) {
//                    let SBId: String = "docSignVC"
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: SBId)
//                    if let docSignVC = vc as? DocSignVC {
//
//                        docSignVC.instanceID = String(notifData.ProcessId!)
//                        docSignVC.docCat = 90
//
//                        self.window?.rootViewController?.navigationController?.pushViewController(docSignVC, animated: true)
//                    }
//                }
//            }
            
            
        }
        else {
            
            //UserDefaults.standard.setValue(notifData, forKey: "NotifData")
            
        }
        /*
         let notifData = notifArr[indexPath.row] as! NotificationData
         
         if notifData.NotificationType == 2 {
         
         if #available(iOS 11.0, *) {
         let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
         
         docSignVC.instanceID = String(notifData.ProcessId!)
         docSignVC.docCat = 90
         //docSignVC.workflowCatId = Int(detailObj!["WorkflowSourceCategory"] as! NSNumber)
         self.navigationController?.pushViewController(docSignVC, animated: true)
         }
         }
         */
        
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        
        // Print full message.
        print("userNotificationCenter didReceive response: \(userInfo)")
        UIApplication.shared.applicationIconBadgeNumber -= 1
        
        let notifData =  NotificationData(dictionary: userInfo)
        let isuserloggedin = ZorroTempData.sharedInstance.getIsUserLoogged()
        
        
        guard let notififytype = notifData.NotificationType else {
            return
        }
        
        if notififytype == 16 {
            if let jsonbody = convertdocprocesstoDictonary(jsonstring: notifData.metaData ?? "") {
                
                let corid = jsonbody["EncCorrelationId"] as! String
                let username = jsonbody["UserId"] as! String
                let keyid = jsonbody["KeyId"] as! String
                
                
                let pkihelper = PKIHelper()
                pkihelper.decryptWithPrivateKey(keyid: keyid, encryptedText: corid) { (decryptedcorid) in
                    
                    self.validateuserWithBiometrics(userid: username, corerelation: decryptedcorid ?? "", keyid: keyid)
                }
                return
            }
            
            return
        }
        
        
        if isuserloggedin {
            showNotificationAlert(notifData: notifData)
        }
        else {
            if let notificationtype = notifData.NotificationType {
                if notificationtype == 2 || notificationtype == 5 {
                    ZorroTempData.sharedInstance.setisfromDeeplink(fromdeeplink: false)
                    ZorroTempData.sharedInstance.setisfromPush(frompush: true)
                    ZorroTempData.sharedInstance.setpushType(type: notifData.NotificationType!)
                    ZorroTempData.sharedInstance.setdocprocessId(processid: "\(notifData.ProcessId!)")
                    //                    let splittedbody = notifData.MessageBody!.components(separatedBy: "\"")
                    //                    let documentname = splittedbody[1]
                    //                    ZorroTempData.sharedInstance.setdocumentName(docname: documentname)
                }
            }
        }
        completionHandler()
    }
    
    func handlePush(notifData: NotificationData, app: UIApplication) {
        
        if app.applicationState == UIApplication.State.active {
            
            let ProfileId: String = ZorroTempData.sharedInstance.getProfileId()
            
            if !ProfileId.isEmpty {
//                showNotificationAlert(notifData: notifData)
            }
            else {
                //UserDefaults.standard.setValue(notifData, forKey: "NotifData")
            }
        } 
    }
    
    func showNotificationAlert(notifData: NotificationData) {
        
        let title = notifData.MessageLabel
        let msg = notifData.MessageBody
        self.alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if notifData.NotificationType == 2 || notifData.NotificationType == 3 || notifData.NotificationType == 4 || notifData.NotificationType == 5 || notifData.NotificationType == 6 || notifData.NotificationType == 8 || notifData.NotificationType == 11 || notifData.NotificationType == 12 || notifData.NotificationType == 13 {
            self.alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                if notifData.NotificationType == 2 || notifData.NotificationType == 4 || notifData.NotificationType == 5 {
                    self.updateReadStatus(notifData: notifData)
                    
                    switch notifData.NotificationType {
                    case 2:
                        let documentsigningcontroller = DocumentSignController()
                        documentsigningcontroller.documentinstanceId = String(notifData.ProcessId!)
                        let rootviewController = self.window?.rootViewController as? SWRevealViewController
                        let frontviewcontroller = rootviewController?.frontViewController
                        let navigationcontorller = frontviewcontroller as? UINavigationController
                        let visiblecontroller = navigationcontorller?.visibleViewController
                        visiblecontroller?.navigationController?.pushViewController(documentsigningcontroller, animated: false)
                        return
                    case 5:
                        let documentviewcontroller = DocumentViewController()
                        documentviewcontroller.documentinstanceId = String(notifData.ProcessId!)
                        documentviewcontroller.documentName = ""
                        let rootviewController = self.window?.rootViewController as? SWRevealViewController
                        let frontviewcontroller = rootviewController?.frontViewController
                        let navigationcontorller = frontviewcontroller as? UINavigationController
                        let visiblecontroller = navigationcontorller?.visibleViewController
                        visiblecontroller?.navigationController?.pushViewController(documentviewcontroller, animated: false)
                        return
                    default:
                        return
                    }
//                    let SBId: String = "docSignVC"
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: SBId)
//                    if let docSignVC = vc as? DocSignVC {
//
//                        docSignVC.instanceID = String(notifData.ProcessId!)
//                        docSignVC.docCat = 90
//                        if notifData.NotificationType == 5 {
//                            docSignVC.workflowCatId = 3
//                        }
//
//                        let rootVC = self.window?.rootViewController as? SWRevealViewController
//                        let frontVC = rootVC?.frontViewController
//                        let navVC = frontVC as? UINavigationController
//
//                        let visibleVC = navVC?.visibleViewController
//                        visibleVC?.navigationController?.pushViewController(docSignVC, animated: false)
//
//                    }

                }
                else if notifData.NotificationType == 3  {
                    /*
                     https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=uqrnZ8906AmE0kxdaoKBxeV45wCWspWrN394iHRQJltwVScI0vxEqYateRRG4E9ONKRBJYNQxGJaEr5Zc7CatrQbTf4pbD6JInCcLKBuypzC8kp5AvvBU5P27mySwkoY&ctrl=Dashboard&destination=workflow/-1/ndcprocess/11383

                     */
                    let processId: String = String(notifData.ProcessId!)
                    let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
                    let url = Singletone.shareInstance.weburl + "/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/-1/ndcprocess/\(processId)"
                    
                    UIApplication.shared.openURL(URL(string: url)!)
                }
                else if notifData.NotificationType == 6  {
                    /*
                     
                     https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=uqrnZ8906AmE0kxdaoKBxeV45wCWspWrN394iHRQJltwVScI0vxEqYateRRG4E9ONKRBJYNQxGJaEr5Zc7CatrQbTf4pbD6JInCcLKBuypzC8kp5AvvBU5P27mySwkoY&ctrl=Dashboard&destination=view/workflow/15998/1
                     */
                    let processId: String = String(notifData.ProcessId!)
                    let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
                    let url = Singletone.shareInstance.weburl + "/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=view/workflow/\(processId)/1"
                    
                    UIApplication.shared.openURL(URL(string: url)!)
                }
                else if notifData.NotificationType == 8  {
                    /*
                     
                     https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=uqrnZ8906AmE0kxdaoKBxeV45wCWspWrN394iHRQJltwVScI0vxEqYateRRG4E9ONKRBJYNQxGJaEr5Zc7CatrQbTf4pbD6JInCcLKBuypzC8kp5AvvBU5P27mySwkoY&ctrl=Dashboard&destination=workflow/15998/process/-1
                     */
                    let processId: String = String(notifData.ProcessId!)
                    let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
                    let url = Singletone.shareInstance.weburl + "/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/\(processId)/process/-1"
                    
                    UIApplication.shared.openURL(URL(string: url)!)
                }
                    //12 dashboard scanned accept
                    //13 notification screen reject
                else if notifData.NotificationType == 11 || notifData.NotificationType == 12 || notifData.NotificationType == 13 {
                    //PermissionsVC
                    
                    self.updateReadStatus(notifData: notifData)
                    
                    if #available(iOS 11.0, *) {
                        let SBId: String = "PermissionsVC"
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: SBId)
                        if let PermissionsVC = vc as? PermisssionsVC {
                            
                            let rootVC = self.window?.rootViewController as? SWRevealViewController
                            let frontVC = rootVC?.frontViewController
                            let navVC = frontVC as? UINavigationController
                            
                            let visibleVC = navVC?.visibleViewController
                            visibleVC?.navigationController?.pushViewController(PermissionsVC, animated: false)
                            
                        }
                    }
                }
            }))
        }
        
        else if notifData.NotificationType == 16 {
            let a = notifData
            print(a)
        }
            
        else {
            self.alert?.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                self.updateReadStatus(notifData: notifData)
                
            }))
        }
        self.alert?.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        self.alert?.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.window?.rootViewController?.present(self.alert!, animated: true, completion: nil)
    }

    func updateReadStatus(notifData: NotificationData) {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "api/v1/Notification/UpdateMessageStatus"
        
        let apiURL = Singletone.shareInstance.apiNotification + api
        
        let parameters = [["MessageId": notifData.Id!,
                           "IsDeleted": false,
                           "IsRead": true]]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                     let jsonObj: JSON = JSON(response.result.value)
                        
                        if UIApplication.shared.applicationIconBadgeNumber > 0 {
                            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
                        }
                    
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        ZorroTempData.sharedInstance.clearAllTempData()
        ZorroTempData.sharedInstance.clearfromNotification()
        ZorroTempData.sharedInstance.clearfromDeeplink()
        
        ZorroTempData.sharedInstance.setCrashedLastTime(crashed: false)
        
        
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        
        if url.scheme == "zorrosign" {
            print("CAME TO URL URL URL")
            let deepview = url.valueOf("view")
            let upprcode = url.valueOf("upprcode")
            
            guard let viewname = deepview else { return true }
            guard let upprcodestring = upprcode else { return true }
        
            
            let rootviewcontroller = RootController()
            rootviewcontroller.isfromdeeLink = true
            rootviewcontroller.viewName = viewname
            rootviewcontroller.upprCode = upprcodestring
            window = UIWindow()
            window?.makeKeyAndVisible()
            window?.rootViewController = rootviewcontroller
            ZorroTempData.sharedInstance.setisfromPush(frompush: false)
            return false
        }
        
//        Branch.getInstance()?.application(app, open: url, options: options)
        /*
        let message = url.host?.removingPercentEncoding
        let alertController = UIAlertController(title: "Incoming Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alertController.addAction(okAction)
        
        window?.rootViewController?.present(alertController, animated: true, completion: nil)
        */
        
        if url.scheme == "zorosign" {
            let service = OutlookService.shared()
            service.handleOAuthCallback(url: url)
            return true
        }
        if url.scheme == "zor" {
            print(url)
            return false
        }
        return true
       
    }
    
    internal func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // handler for Universal Links
        Branch.getInstance().continue(userActivity)
        return true
    }
    
    
    
    @objc func loginDone() {
        
        let SBId: String = "reveal_SBID"
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: SBId)
        self.window?.rootViewController = vc
    }
    
    @objc func logoutDone() {
        ZorroTempData.sharedInstance.clearAllTempData()
        let SBId: String = "login_SBID"
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: SBId)
        self.window?.rootViewController = vc
    }
    
    @objc func callLogoutAPI() {
        
       
        
        ///Account/LogOut
        let ProfileId = ZorroTempData.sharedInstance.getProfileId()
        
        if !ProfileId.isEmpty {
            if let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken") {
                
                let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
                
                let apiURL = Singletone.shareInstance.apiURL + "Account/LogOut"
                
                let username = UserDefaults.standard.value(forKey: "UserName") as! String
                
                let parameters = ["UserName": username, "Token": strAuth] as [String:Any]
                
                if Connectivity.isConnectedToInternet() == true
                {
                    Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            if response.result.isFailure {
                                return
                            }
                            
                            ZorroTempData.sharedInstance.clearAllTempData()
                            ZorroTempData.sharedInstance.clearfromNotification()
                            ZorroTempData.sharedInstance.clearfromDeeplink()
                            /*
                            UserDefaults.standard.set(false, forKey: "dontshowagain")
                            UserDefaults.standard.set(true, forKey: "launch")
                            UserDefaults.standard.set("", forKey: "ProfileId")
                            */
                            self.resetUserDefaults()
                            FeatureMatrix.shared.clearValues()
                            ZorroTempData.sharedInstance.clearAllTempData()
                            //Singletone.shareInstance
                            let SBId: String = "login_SBID"
                            self.timer = Timer.scheduledTimer(timeInterval: 5,
                                                              target: self,
                                                              selector: #selector(self.hideAlert),
                                                              userInfo: nil,
                                                              repeats: false)
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: SBId)
                            self.window?.rootViewController = vc
                            
                            self.alert = UIAlertController(title: "Security Alert!", message: "Your account has been logged out due to inactivity.", preferredStyle: .alert)
                            //alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.alert?.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                            self.window?.rootViewController?.present(self.alert!, animated: true, completion: nil)
                            
                            //if response != nil {
                            /*
                             guard let jsonObj: JSON = JSON(response.result.value!) else {
                             
                             }*/
                            
                            //if jsonObj["StatusCode"] == 1000
                            //{
                            
                            
                            
                            /*}
                             else
                             {
                             
                             }*/
                            //}
                    }
                }
                else
                {
                    let alert = UIAlertController(title: "", message: "No internet found. Check your network connection and Try again..", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                    self.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
    }
    
    func resetUserDefaults() {
        ZorroTempData.sharedInstance.clearAllTempData()
        UserDefaults.standard.set("", forKey: "ServiceToken")
        UserDefaults.standard.set("", forKey: "UserName")
        UserDefaults.standard.set("", forKey: "ProfileId")
        UserDefaults.standard.set("", forKey: "OrgProfileId")
        UserDefaults.standard.set("", forKey: "FullName")
        UserDefaults.standard.set("", forKey: "ProfileStatus")
        UserDefaults.standard.set("", forKey: "OrganizationId")
        UserDefaults.standard.set("", forKey: "UserSign")
        UserDefaults.standard.set("", forKey: "UserSign1")
        UserDefaults.standard.set("", forKey: "UserSign2")
        UserDefaults.standard.set("", forKey: "UserSign3")
        UserDefaults.standard.set("", forKey: "UserInitial")
        UserDefaults.standard.set("", forKey: "UserInitial1")
        UserDefaults.standard.set("", forKey: "UserInitial2")
        UserDefaults.standard.set("", forKey: "UserInitial3")
        UserDefaults.standard.set(0, forKey: "UserSignId")
        UserDefaults.standard.set("", forKey: "Email")
        UserDefaults.standard.set("", forKey: "UserSign")
        UserDefaults.standard.set("", forKey: "Company")
        UserDefaults.standard.set("", forKey: "JobTitle")
        UserDefaults.standard.set("", forKey: "Email")
        UserDefaults.standard.set("", forKey: "Phone")
        UserDefaults.standard.set("", forKey: "FName")
        UserDefaults.standard.set("", forKey: "LName")
        UserDefaults.standard.set("", forKey: "MName")
        UserDefaults.standard.set(0, forKey: "UserType")
        UserDefaults.standard.set("", forKey: "qrcode")
        
        Singletone.shareInstance.signObjectArray = []
    }
    
    func printFonts() {
        
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            //Check the Font names of the Font Family
            let names = UIFont.fontNames(forFamilyName: familyName )
            // Write out the Font Famaily name and the Font's names of the Font Family
            print("Font == \(familyName) \(names)")
        }
    }
    
    @objc private func hideAlert() {
        
        alert?.dismiss(animated: false, completion: nil)
        
    }
}


extension AppDelegate {
    func validateuserWithBiometrics(userid: String, corerelation: String, keyid: String) {
        DispatchQueue.main.async {
            let biometricwrapper = BiometricsWrapper()
            biometricwrapper.authenticateWithBiometric { (success, err) in
                guard let issuccess = success else {
                    return
                }
                
                let pkihelper = PKIHelper()
                pkihelper.signWithPrivateKey(textIn: corerelation, keyid: keyid) { (success, sign) in
                    if success {
                        let validatebiometric = ValidateBiometric(UserId: userid, CorrelationId: corerelation, IsValidate: issuccess, Signature: sign ?? "", KeyId: keyid)
                        validatebiometric.verifyuserWithBiometrics(validatebiometrics: validatebiometric) { (success) in
                            print("user verified successfully : \(success)")
                        }
                        return
                    }
                    return
                }
                return
            }
        }
        return
    }
}

extension AppDelegate {
    private func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

extension AppDelegate {
    func setAsRoot(_ _controller: UIViewController) {
        
        if window != nil {
            window?.rootViewController = _controller
            
        }
    }
}

