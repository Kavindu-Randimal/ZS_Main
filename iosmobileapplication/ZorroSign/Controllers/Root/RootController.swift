//
//  RootController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class RootController: BaseVC {
    
    var viewName: String!
    var upprCode: String!
    var isfromdeeLink: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.showActivityIndicatory(uiView: self.view)
        checkforDeeplink()
    }
}


extension RootController {
    func checkforDeeplink() {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            self.alertSample(strTitle: "Connection", strMsg: "Internet connection appears to be offline, Please check your internet connection and try again!")
            self.handleErr(has: true)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if self.viewName != "" && self.upprCode != "" {
                let upprlogin = UpprLogin()
                upprlogin.getupprloginDetails(upprcode: self.upprCode) { (upprlogindetails, err, status) in
                    if err {
                        self.handleErr(has: true)
                        return
                    }
                    
                    let isuserlogged = ZorroTempData.sharedInstance.getIsUserLoogged()
                    
//                    if let upprdata = upprlogindetails?.Data {
//                        ZorroTempData.sharedInstance.setupprDetails(upprdata: upprdata)
//                    }
                    
//                    if let profileid = upprlogindetails?.Data?.ProfileId {
//                        ZorroTempData.sharedInstance.setProfileId(profileid: profileid)
//                    }
//
//                    if let useremail = upprlogindetails?.Data?.UserName {
//                        ZorroTempData.sharedInstance.setUserEmail(email: useremail)
//                    }
                    
                    print("USER LOGGED IN : \(isuserlogged)")
                    if isuserlogged {
                        
                        self.validatestatuscodeforLoggedusers(statuscode: status, upprcode: self.upprCode)
                        return
                    } else {
                        self.validatestatuscodeforLoggedOutusers(statuscode: status, upprcode: self.upprCode, upprlogin: upprlogindetails)
                        return
                    }
                }
                return
            } else {
                self.handleErr(has: true)
                return
            }
        }
        
    }
}

extension RootController {
    fileprivate func validatestatuscodeforLoggedusers(statuscode: Int, upprcode: String) {
        let upprdetails = UpprDetails()
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            self.alertSample(strTitle: "Connection", strMsg: "Internet connection appears to be offline, Please check your internet connection and try again!")
            self.handleErr(has: true)
            return
        }
        
        upprdetails.getuserUpprDetails(upprcode: upprcode) { (upprdetails, err) in
            if err {
                self.rootAlert(title: "Something Went Wrong", message: "Unable to get link details!", err: true)
                return
            }
            
            guard let processid = upprdetails?.Data?.ProcessId else {
                self.handleErr(has: true)
                return
            }
            
            guard let receivermail = upprdetails?.Data?.ReceiverEmail else {
                self.handleErr(has: true)
                return
            }
            
            guard let upprstatus = upprdetails?.Data?.UPPRStatus else {
                self.handleErr(has: true)
                return
            }
            
            let useremail = ZorroTempData.sharedInstance.getUserEmail()
            if useremail != upprdetails?.Data?.ReceiverEmail {
                self.rootAlert(title: "Unauthorized", message: "You don't have permission to access this!", err: true)
                return
            }
            
            if self.viewName == "DCProcessSign" && statuscode != 1000 {
                ZorroTempData.sharedInstance.setdeeplinkView(viewname: "ProcessView")
            } else {
                ZorroTempData.sharedInstance.setdeeplinkView(viewname: self.viewName)
            }
            
            ZorroTempData.sharedInstance.setisfromDeeplink(fromdeeplink: true)
            ZorroTempData.sharedInstance.setdocprocessId(processid: "\(processid)")
            ZorroTempData.sharedInstance.setreceiverEmail(receiveremail: receivermail)
            ZorroTempData.sharedInstance.setupprStatus(upprstatus: upprstatus)
            
            self.updateSignatures(completion: { (completed) in
                if completed {
                    let appdelegate = UIApplication.shared.delegate
                    let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                    
                    if completed {
                        switch statuscode {
                        case 1000:
                            appdelegate?.window!?.rootViewController = viewcontroller
                            return
                        case 3625:
                            self.alertSample(strTitle: "Completed", strMsg: "This Document Set has already been signed!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                                appdelegate?.window!?.rootViewController = viewcontroller
                                return
                            })
                        default:
                            return
                        }
                    }
                }
            })
        }
    }
}

extension RootController {
    fileprivate func validatestatuscodeforLoggedOutusers(statuscode: Int, upprcode: String, upprlogin: UpprLogin?) {
        
        switch statuscode {
        case 1000:
            
            guard let isregisterd = upprlogin?.Data?.IsRegistered else {
                handleErr(has: true)
                return
            }
            
            let upprdetails = UpprDetails()
            let connectivity = Connectivity.isConnectedToInternet()
            if !connectivity {
                self.alertSample(strTitle: "Connection", strMsg: "Internet connection appears to be offline, Please check your internet connection and try again!")
                self.handleErr(has: true)
                return
            }
            
            guard let servicetoken = upprlogin?.Data?.ServiceToken else{
                handleErr(has: true)
                return
            }
            
            UserDefaults.standard.set(servicetoken, forKey: "ServiceToken")
            
            upprdetails.getuserUpprDetails(upprcode: upprcode) { (upprdetails, err) in
                if err {
                    self.rootAlert(title: "Something Went Wrong", message: "Unable to get link details!", err: true)
                    return
                }
                
                guard let processid = upprdetails?.Data?.ProcessId else {
                    self.handleErr(has: true)
                    return
                }
                
                guard let receivermail = upprdetails?.Data?.ReceiverEmail else {
                    self.handleErr(has: true)
                    return
                }
                
                guard let upprstatus = upprdetails?.Data?.UPPRStatus else {
                    self.handleErr(has: true)
                    return
                }
                
                guard let ProfileId = upprlogin?.Data?.ProfileId else {
                    self.handleErr(has: true)
                    return
                }
                
                guard let UserEmail = upprlogin?.Data?.UserName else {
                    self.handleErr(has: true)
                    return
                }
                
                if self.viewName == "DCProcessSign" && statuscode != 1000 {
                    ZorroTempData.sharedInstance.setdeeplinkView(viewname: "ProcessView")
                } else {
                    ZorroTempData.sharedInstance.setdeeplinkView(viewname: self.viewName)
                }
                
                ZorroTempData.sharedInstance.setisfromDeeplink(fromdeeplink: true)
                ZorroTempData.sharedInstance.setdocprocessId(processid: "\(processid)")
                
                if !isregisterd {
                    ZorroTempData.sharedInstance.setupprStatus(upprstatus: upprstatus)
                    ZorroTempData.sharedInstance.setiszorrosignRegistered(isregistered: isregisterd)
                    ZorroTempData.sharedInstance.setProfileId(profileid: ProfileId.stringByAddingPercentEncodingForRFC3986()!)
                    ZorroTempData.sharedInstance.setUserEmail(email: UserEmail)
                    ZorroTempData.sharedInstance.setIsUserLoggedIn(islogged: true)
                    ZorroTempData.sharedInstance.setPasswordlessUser(email: UserEmail)
                    ZorroTempData.sharedInstance.setreceiverEmail(receiveremail: receivermail)
                    UserDefaults.standard.set(UserEmail, forKey: "UserName")
                    UserDefaults.standard.set(ProfileId, forKey: "OrgProfileId")
                } else {
                    self.rootAlert(title: "Login", message: "Please login to continue!", err: true)
                    return
                }

                
                let userprofile = UserProfile()
                userprofile.getuserprofileData {(userprofiledata, err) in
                    if err {
                        self.rootAlert(title: "Something Went Wrong", message: "Unable to get user details, redirecting to login page!", err: false)
                        return
                    }
                    
                    if let userprofiledata = userprofiledata {
                        ZorroTempData.sharedInstance.setUserprofile(userprofile: userprofiledata)
                        
                        if let userType = userprofiledata.Data?.UserType {
                            ZorroTempData.sharedInstance.setUserType(usertype: userType)
                        }
                        if let organizationId = userprofiledata.Data?.OrganizationId {
                            UserDefaults.standard.set(organizationId, forKey: "OrganizationId")
                        }
                        
                        let appdelegate = UIApplication.shared.delegate
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                        appdelegate?.window!?.rootViewController = viewcontroller
                        return
                        
                    }
                    return
                }
                
                return
            }
            return
        case 3625:
            self.rootAlert(title: "Completed", message: "This process is already completed. Please login to view the document!", err: true)
            return
        default:
            return
        }
    }
}

extension RootController {
    fileprivate func updateSignatures(completion: @escaping(Bool) -> ()) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connection", strMsg: "Your connection appears to be offline, please try again!")
            completion(false)
            return
        }
        
        self.showActivityIndicatory(uiView: self.view)
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (userprofiledata, err) in
            if err {
                self.alertSample(strTitle: "Something Went Wrong", strMsg: "Unable to get user details, please try again!")
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

extension RootController {
    fileprivate func handleErr(has err: Bool) {
        self.stopActivityIndicator()
        if err  {
            ZorroTempData.sharedInstance.clearfromDeeplink()
        }
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let homeViewController = mainStoryboard.instantiateViewController(withIdentifier: "login_SBID") as! LoginViewController
        appdelegate.window!.rootViewController = homeViewController
    }
}

extension RootController {
    fileprivate func rootAlert(title: String, message: String, err: Bool) {
        let rootalertcontroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        rootalertcontroller.view.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        
        let okacton = UIAlertAction(title: "OK", style: .default) { (alert) in
            let isuserloggedin = ZorroTempData.sharedInstance.getIsUserLoogged()
            if isuserloggedin {
                if err {
                    ZorroTempData.sharedInstance.clearfromDeeplink()
                }
                let appdelegate = UIApplication.shared.delegate
                let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                appdelegate?.window!?.rootViewController = viewcontroller
                return
                
            } else {
                self.handleErr(has: false)
                return
            }
        }
        rootalertcontroller.addAction(okacton)
//        let cancelaction = UIAlertAction(title: "CANCEL", style: .default) { (alert) in
//            
//            ZorroTempData.sharedInstance.clearfromDeeplink()
//            let isuserloggedin = ZorroTempData.sharedInstance.getIsUserLoogged()
//            if isuserloggedin {
//                let appdelegate = UIApplication.shared.delegate
//                let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
//                let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
//                appdelegate?.window!?.rootViewController = viewcontroller
//                return
//            } else {
//                self.handleErr(has: true)
//                return
//            }
//        }
//        rootalertcontroller.addAction(cancelaction)
        self.present(rootalertcontroller, animated: true, completion: nil)
    }
}


