//
//  NotificationVC.swift
//  ZorroSign
//
//  Created by Apple on 09/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var lbltime: UILabel!
    @IBOutlet weak var lblhead: UILabel!
    @IBOutlet weak var lblcontent: UILabel!
    
    @IBOutlet weak var btnDel: UIButton!
    
    @IBOutlet weak var btnChk: UIButton!
    
    @IBOutlet weak var icon_tick: UIImageView!
    @IBOutlet weak var bgview: UIView!
}

class NotificationVC: BaseVC, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tblNotif: UITableView!
    var notifArr: [NotificationData] = []
    var receivednotifications: [NotificationDetails] = []
        //NSMutableArray = NSMutableArray.init()
    
//notifCell
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }

        // Do any additional setup after loading the view.
        tblNotif.dataSource = self
        tblNotif.delegate = self
        addFooterView()
        getpushNotificatoins()
//        getNotifications()
//        getUnreadPushCount()
        
    }

    func getNotifications() {
        
        notifArr = []
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        //let deviceId: String = "fxhWDEXqpA4:APA91bG9sseZZ20AE8rV9XMP2ZfI_sz6DCLh1EClh0eAnhk-i8G5nul4gr4bfgZq4P_7kHLH5Y_9dTzy-fHTn0RG8ve4miY7d_vpE8Hm4RdQo9Xy0Z97vQTScQ2TWkTP_S1LEk_t-y4F"
        //let deviceId: String = "fapqzV0omU4:APA91bFNn0yKRpWQtw207m-vcy9oYOMq9_mNMTBisC6_ecww0dleVP6u1mzP6ucIzkLgyw12LSVcKUmz5IiImpuoBkOBluS0zSSwlAUr0NAFSQCmiD_uijK5ixbqEWEzy7Gpm3T_Ptj9"
        let deviceId: String = UserDefaults.standard.string(forKey: "deviceId") ?? ""
        let api = "api/v1/Notification/GetUserPushNotifications?deviceId=\(deviceId)"
        
        let apiURL = Singletone.shareInstance.apiNotification + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                   
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        print("notification response: \(jsonObj)")
                        if let data = jsonObj["Data"].array {
                            for dic in data {
                                
                                let dict = dic.dictionaryObject
                                //self.notifArr.add(NotificationData(dictionary: dict!))
                                self.notifArr.append(NotificationData(dictionary: dict!))
                            }
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.notifArr = self.notifArr.sorted(by: { $0.notifDate! > $1.notifDate! })
                        self.tblNotif.reloadData()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return receivednotifications.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifCellId") as! NotificationCell
        
        let notifData = receivednotifications[indexPath.row]
        
        let date = notifData.SentDate?.stringToDate()
        cell.lbltime.text = date?.timeAgoDisplay() //notifData.SentDate
        cell.lblhead.text = notifData.MessageTitle
        cell.lblcontent.text = notifData.MessageBody
        
        cell.icon_tick.tag = indexPath.row
        cell.btnChk.tag = indexPath.row
            
        //UIImage(named: "tick_gray_icon")
        if notifData.IsRead! {
            cell.icon_tick.image = UIImage(named: "chk_green_round")
        } else {
            cell.icon_tick.image = UIImage(named: "chk_gray_round")
        }
        
        //let gestureTap = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction))
        //cell.icon_tick.addGestureRecognizer(gestureTap)
        cell.btnChk.addTarget(self, action: #selector(tapAction(sender:)), for: UIControl.Event.touchUpInside)
        
        cell.btnDel.tag = indexPath.row
        cell.btnDel.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        (cell as! NotificationCell).bgview.layer.cornerRadius = 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notifData = receivednotifications[indexPath.row]
        tblNotif.allowsSelection = false
        self.showActivityIndicatory(uiView: self.view)
        updatedNotificationStatus(messageid: notifData.Id!, isread: true, isdelete: false) { (completed) in
            if notifData.NotificationType == 2 || notifData.NotificationType == 5 {
                self.checkStatus(processid: String(notifData.ProcessId!)) { (type) in
                    switch type {
                    case 2:
                        let documentsignController = DocumentSignController()
                        documentsignController.documentinstanceId = String(notifData.ProcessId!)
                        documentsignController.documentName = ""
                        self.navigationController?.pushViewController(documentsignController, animated: true)
                        return
                    case 5:
                        let documentviewController = DocumentViewController()
                        documentviewController.documentName = ""
                        documentviewController.documentinstanceId = String(notifData.ProcessId!)
                        self.navigationController?.pushViewController(documentviewController, animated: true)
                        return
                    default:
                        return
                    }
                }
            }
            
            if (notifData.NotificationType == 11) {
               
                if #available(iOS 11.0, *) {
                    
                    if let PermissionsVC = self.getVC(sbId: "PermissionsVC") as? PermisssionsVC {
                        
                        self.navigationController?.pushViewController(PermissionsVC, animated: true)
                        return
                    }
                }
            }
            
            return
        }
    }
    
    @objc func tapAction(sender : UIButton) {
        self.showActivityIndicatory(uiView: self.view)
        let tag: Int = sender.tag
        let notifData = receivednotifications[tag]
        updatedNotificationStatus(messageid: notifData.Id!, isread: !notifData.IsRead!, isdelete: false) { (completed) in
            if completed! {
                if notifData.IsRead! {
                    let noticnt = self.notifIcon.badgeNumber - 1
                    
                    if noticnt > 0 {
                        self.notifIcon.badgeNumber = noticnt
                    } else {
                        self.notifIcon.badgeNumber = 0
                    }
                } else {
                    let noticnt = self.notifIcon.badgeNumber + 1
                    self.notifIcon.badgeNumber = noticnt
                }
            }
        }
    }
    
    @IBAction func deleteAction(_ sender: UIButton) {
       
        let tag = sender.tag
        self.showActivityIndicatory(uiView: self.view)
//        deleteAPI(tag: tag)
        
        let selectedmesssage = receivednotifications[tag]
        updatedNotificationStatus(messageid: selectedmesssage.Id!, isread: selectedmesssage.IsRead!, isdelete: true) { (completed) in
            if completed! {
                let noticnt = self.notifIcon.badgeNumber - 1
                if noticnt > 0 {
                    self.notifIcon.badgeNumber = noticnt
                } else {
                    self.notifIcon.badgeNumber = 0
                }
                self.getpushNotificatoins()
            }
        }
    }
    
    func deleteAPI(tag: Int) {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "api/v1/Notification/UpdateMessageStatus"
        
        let apiURL = Singletone.shareInstance.apiNotification + api
        
        let notifData = receivednotifications[tag]
        
        let parameters = [["MessageId": notifData.Id!,
                           "IsDeleted": true,
                           "IsRead": true]]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                    
                    
                    DispatchQueue.main.async {
                        self.getUnreadPushCount()
                        self.getNotifications()
                        self.tblNotif.reloadData()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func refreshNotifications() {
     
//        getNotifications()
//        getUnreadPushCount()
        getpushNotificatoins()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NotificationVC {
    fileprivate func getpushNotificatoins() {
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            self.alertSample(strTitle: "Connection!", strMsg: "Internet connection appears to be offline. Please check your connection")
            return
        }
        receivednotifications = []
        let recivenotifications = ReceiveNotification()
        guard let deviceId: String = UserDefaults.standard.string(forKey: "deviceId") else { return }
        recivenotifications.getPushNotificationDetails(deviceid: deviceId) { (notifications) in
            guard let notify = notifications else {
                self.tblNotif.reloadData()
                self.stopActivityIndicator()
                return
            }
            self.undeletedNotifications(notifications: notify, completion: { (undeletednotifications) in
                self.receivednotifications = undeletednotifications
                self.unreadPushCount(notifications: self.receivednotifications, completion: { (unreadcount) in
                    self.notifIcon.badgeNumber = unreadcount
                    UIApplication.shared.applicationIconBadgeNumber = unreadcount
                    self.tblNotif.reloadData()
                    self.tblNotif.allowsSelection = true
                    self.stopActivityIndicator()
                })
            })
        }
    }
}

extension NotificationVC {
    fileprivate func updatedNotificationStatus(messageid:Int, isread:Bool, isdelete: Bool, completion:@escaping(Bool?) -> ()) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            self.alertSample(strTitle: "Connection!", strMsg: "Internet connection appears to be offline. Please check your connection")
            return
        }
        
        let updatenotification = UpdateNotification(MessageId: messageid, IsDeleted: isdelete, IsRead: isread)
        var updatenotifications: [UpdateNotification] = []
        updatenotifications.append(updatenotification)
        updatenotification.updatePushnotificationStatus(updatenoti: updatenotifications) { (completed) in
            if completed {
                let noticnt = self.notifIcon.badgeNumber - 1
                if noticnt > 0 {
                    self.notifIcon.badgeNumber = noticnt
                } else {
                    self.notifIcon.badgeNumber = 0
                }
            }
            self.getpushNotificatoins()
            completion(true)
            return
        }
    }
}

//MARK: - check status code
extension NotificationVC {
    fileprivate func checkStatus(processid: String, completion: @escaping(Int) -> ()) {
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            self.alertSample(strTitle: "Connection!", strMsg: "Internet connection appears to be offline. Please check your connection")
            return
        }
        
        updateSignatures { (completed) in
            if completed {
                ZorroHttpClient.sharedInstance.getDocumentProcess(instanceID: processid) { (_, _, statuscode) in
                    if statuscode == 1000 {
                        completion(2)
                        return
                    }
                    if statuscode == 3421 {
                        completion(5)
                        return
                    }
                    return
                }
            }
            return
        }
        
    }
}
//MARK: - get undeleted push
extension NotificationVC {
    fileprivate func undeletedNotifications(notifications: [NotificationDetails], completion: @escaping([NotificationDetails]) -> ()) {
        
        var notificationsdetails: [NotificationDetails] = []
        for notification in notifications {
            if !notification.IsDeleted! {
                notificationsdetails.append(notification)
            }
        }
        completion(notificationsdetails)
    }
}

//MARK: get unreaded push count
extension NotificationVC {
    fileprivate func unreadPushCount(notifications: [NotificationDetails], completion: @escaping(Int) -> ()) {
        var unreadcount: Int = 0
        for notification in notifications {
            if !notification.IsRead! {
                unreadcount += 1
            }
        }
        completion(unreadcount)
    }
}

extension NotificationVC {
    fileprivate func updateSignatures(completion: @escaping(Bool) -> ()) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connection!", strMsg: "Your connection appears to be offline, please try again!")
            completion(false)
            return
        }
        
        self.showActivityIndicatory(uiView: self.view)
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (userprofiledata, err) in
            if err {
                self.alertSample(strTitle: "Something Went Wrong ", strMsg: "Unable to get user details, please try again")
                completion(false)
                return
            }
            
            var signatures: [UserSignature] = []
            
            if let signatureid = userprofiledata?.Data?.UserSignatureId, let signature = userprofiledata?.Data?.Signature, let intial = userprofiledata?.Data?.Initials {
                var newSignature = UserSignature()
                newSignature.UserSignatureId = signatureid
                newSignature.Signature = signature
                newSignature.Initials = intial
                signatures.append(newSignature)
            }
            
            if let signatories = userprofiledata?.Data?.UserSignatures {
                if signatories.count > 0 {
                    for signature in signatories {
                        signatures.append(signature)
                    }
                }
            }
            
            ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
            completion(true)
        }
    }
}
