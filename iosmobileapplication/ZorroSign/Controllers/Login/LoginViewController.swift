//
//  LoginViewController.swift
//  ZorroSign
//
//  Created by Apple on 29/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftyXMLParser
import AVFoundation
import QRCodeReader

class LoginViewController: BaseVC, LoadingIndicatorDelegate {
    
    // test
    
    @IBOutlet weak var loginscrollView: UIScrollView!
    @IBOutlet weak var loginlogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    //    @IBOutlet weak var usernametextTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var containerviewWidth: NSLayoutConstraint!
//    @IBOutlet weak var containerviewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var viewUserName: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var tokenreaderButton: UIButton!
    @IBOutlet weak var contactusButton: UIButton!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    
    let greencolor: UIColor = ColorTheme.btnBG
    
    var email: String = ""
    var pass: String = ""
    var isEnabledShowPassword = false
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    var flag: String = "false"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStyles()
        btnLogin.layer.cornerRadius = 3
        btnLogin.clipsToBounds = true
        btnSignUp.layer.cornerRadius = 3
        btnSignUp.clipsToBounds = true
        btnShowHidePassword.contentMode = .center
        txtPassword.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        setUnderLineForBtnSignUp()
        
        let originalimage = UIImage(named: "Check-mark")
        let titntedimage = originalimage?.withRenderingMode(.alwaysTemplate)
        
        if let userName: String = UserDefaults.standard.string(forKey: "remindUserName")
        {
            txtUserName.text = userName
            btnAgree.setImage(titntedimage, for: UIControl.State.normal)
            btnAgree.tintColor = .white
            btnAgree.backgroundColor = .lightGray
            flag = "true"
        }
        if let userPassword: String = UserDefaults.standard.string(forKey: "remindPassword")
        {
            txtPassword.text = userPassword
            btnAgree.setImage(titntedimage, for: UIControl.State.normal)
            btnAgree.tintColor = .white
            btnAgree.backgroundColor = .darkGray
            flag = "true"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUnderLineForBtnSignUp() {
           let attributedString = NSMutableAttributedString.init(string: btnSignUp.titleLabel?.text ?? "SIGN UP FOR FREE")
           
           // Add Underline Style Attribute.
           attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                           NSRange.init(location: 0, length: attributedString.length))
           btnSignUp.setAttributedTitle(attributedString, for: .normal)
       }
    
    @IBAction func pressedShowAndHidePassword(_ sender: Any) {
        if isEnabledShowPassword {
            btnShowHidePassword.setImage(#imageLiteral(resourceName: "ic_view_pass"), for: .normal)
            txtPassword.isSecureTextEntry = true
            isEnabledShowPassword = false
            
        } else {
            btnShowHidePassword.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
            txtPassword.isSecureTextEntry = false
            isEnabledShowPassword = true
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segLanding", sender: self)
    }
    
    @IBAction func btnAgreeAction(_ sender: Any) {
        
        
        let originalimage = UIImage(named: "Check-mark")
        let titntedimage = originalimage?.withRenderingMode(.alwaysTemplate)
        
        if let button = sender as? UIButton {
            if button.isSelected {
                flag = "false"
                button.isSelected = false
                
                btnAgree.setImage(UIImage(named:""), for: UIControl.State.normal)
                btnAgree.backgroundColor = .white
                
                UserDefaults.standard.removeObject(forKey: "remindUserName")
                UserDefaults.standard.removeObject(forKey: "remindPassword")
                
            } else {
                flag = "true"
                button.isSelected = true
                btnAgree.setImage(titntedimage, for: .normal)
                btnAgree.tintColor = .white
                btnAgree.backgroundColor = .darkGray
                
                UserDefaults.standard.set(txtUserName.text!, forKey: "remindUserName")
                UserDefaults.standard.set(txtPassword.text!, forKey: "remindPassword")
            }
        }
    }
    
    @IBAction func btnSignupAction(_ sender: Any) {
        self.performSegue(withIdentifier: "gotoSignUp", sender: self)
        
    }
    
    @IBAction func btnLoginAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if flag == "true" {
            UserDefaults.standard.set(txtUserName.text!, forKey: "remindUserName")
            UserDefaults.standard.set(txtPassword.text!, forKey: "remindPassword")
        }
        
        email = txtUserName.text!
        pass = txtPassword.text!
        ZorroTempData.sharedInstance.setBannerClose(isClosed: false)
        
        if txtUserName.text == "" || Singletone.shareInstance.isValidEmail(testStr: "\(email.trim())") == false
        {
            alertSample(strTitle: "", strMsg: "Please enter email")
        }
        else if txtPassword.text == ""
        {
            alertSample(strTitle: "", strMsg: "Please enter password")
        }
        else
        {
            if Connectivity.isConnectedToInternet() == true
            {
                Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "Please wait while you are logged in.")
                
                UserDefaults.standard.set(pass, forKey: "Pass")
                
                let param = ["UserName" : email,
                             "Password" : pass,
                             "ClientId": Singletone.shareInstance.clientId,
                             "ClientSecret": Singletone.shareInstance.clientSecret,
                             "DoNotSendActivationMail": true,
                             "FallbackAnswers": []
                    ] as [String : Any]
                
                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/Login")!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Singletone.shareInstance.headerAPI)
                    .responseJSON { response in
                        Singletone.shareInstance.stopActivityIndicator()
                        if response != nil {
                            let jsonObj: JSON = JSON(response.result.value) 
                                let _statuscode = jsonObj["StatusCode"]
                                print(_statuscode)
                                if jsonObj["StatusCode"] == 1000
                                {
                                    
                                    UserDefaults.standard.set(jsonObj["Data"]["ServiceToken"].stringValue, forKey: "ServiceToken")
                                    UserDefaults.standard.set(jsonObj["Data"]["UserName"].stringValue, forKey: "UserName")
                                    let profId = jsonObj["Data"]["ProfileId"].stringValue.stringByAddingPercentEncodingForRFC3986()
                                    //UserDefaults.standard.set(profId, forKey: "ProfileId")
                                    ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
                                    let usertype = jsonObj["Data"]["UserType"].intValue
                                    ZorroTempData.sharedInstance.setIsUserLoggedIn(islogged: true)
                                    ZorroTempData.sharedInstance.setUserType(usertype: usertype)
                                    ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
                                    ZorroTempData.sharedInstance.setUserEmail(email: self.email)
                                    ZorroTempData.sharedInstance.setPasswordlessUser(email: self.email)
                                    let phonenumber = jsonObj["Data"]["PhoneNumber"].stringValue
                                    ZorroTempData.sharedInstance.setPhoneNumber(phonenumber: phonenumber)
                                    // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                    
                                    UserDefaults.standard.set(jsonObj["Data"]["ProfileId"].stringValue, forKey: "OrgProfileId")
                                    
                                    let fname: String = jsonObj["Data"]["FirstName"].stringValue
                                    let lname: String = jsonObj["Data"]["LastName"].stringValue
                                    let fullname = "\(fname) \(lname)"
                                    UserDefaults.standard.set(fullname, forKey: "FullName")
                                    UserDefaults.standard.set(fname, forKey: "FName")
                                    UserDefaults.standard.set(lname, forKey: "LName")
                                    
//                                    UserDefaults.standard.set(jsonObj["Data"]["ProfileCompletionStatus"].intValue, forKey: "ProfileStatus")
//
//                                    UserDefaults.standard.set(jsonObj["Data"]["ProfileCompletionStatus"].intValue, forKey: "ProfComplStatus")
                                    
                                    UserDefaults.standard.set(jsonObj["Data"]["OrganizationId"].stringValue, forKey: "OrganizationId")
                                    
                                    if jsonObj["Data"]["Subscription"].dictionary != nil {
                                        if !jsonObj["Data"]["Subscription"].isEmpty {
                                            UserDefaults.standard.set(true, forKey: "hasSubscriptionData")
                                        }
                                    } else {
                                        UserDefaults.standard.set(false, forKey: "hasSubscriptionData")
                                    }
                                    
                                    if let permissions = jsonObj["Data"]["Permissions"].arrayObject as? [String] {
                                        if permissions.contains("AccessAdminPage") || permissions.contains("ManageDepartments") || permissions.contains("ManageUsers") || permissions.contains("ManagerRoles") {
                                            UserDefaults.standard.set(true, forKey: "AdminFlag")
                                        } else {
                                            UserDefaults.standard.set(false, forKey: "AdminFlag")
                                        }
                                    } else {
                                        UserDefaults.standard.set(false, forKey: "AdminFlag")
                                    }
                                    
                                    self.addDeviceToken()
                                    
                                    
                                    self.updateSignatures(completion: { (completed) in
                                        if completed {
                                            
                                            
                                            
                                            let isMFAEnabled = jsonObj["Data"]["IsMFAForcedToEnable"].boolValue
                                            let isOrgForceMFAEnabled = jsonObj["Data"]["IsOrganizationMFAEnabledForUsers"].boolValue
                                            
                                            let passwordExpiryWarning = jsonObj["Data"]["PasswordExpiryWarning"].boolValue
                                            let passwordExpiryDate = jsonObj["Data"]["PasswordExpiryDate"].stringValue
                                            
//                                            self.showPasswordChangeAlert(message: "Your password expires today. Select here to change your password.") { (success) in
//                                                self.gotoNextScreen(isOrgForceMFAEnabled: isOrgForceMFAEnabled, isMFAEnabled: isMFAEnabled)
//                                            }
                                            
                                            if passwordExpiryWarning {
                                                UserDefaults.standard.setValue(self.email.trim(), forKey: "UserEmailAdd")

                                                let pendingDays = self.getDate(dateString: passwordExpiryDate) - Date()

                                                if let _pendingDays = pendingDays.day {
                                                    if _pendingDays == 0 {
                                                        self.showPasswordChangeAlert(message: "Your password expires today. Select here to change your password.", skipOrCancel: "Skip") { (success) in
                                                            self.gotoNextScreen(isOrgForceMFAEnabled: isOrgForceMFAEnabled, isMFAEnabled: isMFAEnabled)
                                                        }
                                                    } else if _pendingDays > 0 {
                                                        self.showPasswordChangeAlert(message: "Your password will expire in \(_pendingDays) days. Select here to change your password", skipOrCancel: "Skip") { (success) in
                                                            self.gotoNextScreen(isOrgForceMFAEnabled: isOrgForceMFAEnabled, isMFAEnabled: isMFAEnabled)
                                                        }
                                                    }
                                                }
                                            } else {
                                                self.gotoNextScreen(isOrgForceMFAEnabled: isOrgForceMFAEnabled, isMFAEnabled: isMFAEnabled)
                                            }
                                            
                                            return
                                        }
                                    })
                                    
                                    return
                                }
                                else
                                {
                                    if jsonObj["StatusCode"] == 3599 {
    
                                        
                                        let message: String = jsonObj["Message"].stringValue
                                        self.showActivateAcountAlert(title: "Activate your account!", message: message)
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 4214 {
                                        self.checkforOTP()
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 4009 {
                                        
                                        self.alertSample(strTitle: "Unable to login!", strMsg: "You haven't verified One Time Password (OTP) to Change mobile number. Please contact ZorroSign Support to reset OTP settings.")
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 1250 {
                                        if jsonObj["Data"]["FallbackDetails"]["IsFallbackEnable"] == true {
                                            //Save the user email to be used in passwordlessStatusCheck endpoint
                                            ZorroTempData.sharedInstance.setPasswordlessUser(email: self.email)
                                            if jsonObj["Data"]["FallbackDetails"]["Type"] == 1 {
                                                let email: String = jsonObj["Data"]["FallbackDetails"]["FallbackOptions"][0].stringValue
                                                self.biometricFallbackOtp(param: param, email: email)
                                            } else {
                                                let question1: String = jsonObj["Data"]["FallbackDetails"]["FallbackOptions"][0].string!
                                                let question2: String = jsonObj["Data"]["FallbackDetails"]["FallbackOptions"][1].string!
                                                let question3: String = jsonObj["Data"]["FallbackDetails"]["FallbackOptions"][2].string!
                                                self.biometricFallbackQuestion(param: param, q1: question1, q2: question2, q3: question3)
                                            }
                                        }
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 5006 {
                                        self.gotoaccountLockView()
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 9201 {
                                        self.showPasswordChangeAlert(message: "Your password has expired. Please reset your password to continue", skipOrCancel: "Cancel") { (success) in
                                            
                                        }
                                        return
                                    }
                                    
                                    if jsonObj["StatusCode"] == 9202 {
                                        self.showPasswordChangeAlert(message: "Due to account inactivity your password must be reset to continue", skipOrCancel: "Cancel") { (success) in
                                            
                                        }
                                        return
                                    }
                                    
                                    
                                    self.alertSampleWithFailed(strTitle: "Login Failed", strMsg: jsonObj["Message"].stringValue)
                                }
                            
                            
                        }
                        
                }
            } else {
                alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
        }
    }
    
    private func gotoNextScreen(isOrgForceMFAEnabled: Bool, isMFAEnabled: Bool) {
        
        // Navigate to MFA Screen
        if isOrgForceMFAEnabled {
            UserDefaults.standard.set("YES", forKey: "FromForceMFA")
            
            let multifactorSettingsResponse = MultifactorSettingsResponse()

            multifactorSettingsResponse.getuserMultifactorSettings { (data) in
                
                if data?.TwoFAType == 0 || data?.ApprovalVerificationType == 1 || data?.LoginVerificationType == 1 {
                    self.getTheUserSubscriptionFeatures(toMFA: true)
                } else {
                    self.getTheUserSubscriptionFeatures(toMFA: false)
                }
            }
        } else {
            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
            self.getTheUserSubscriptionFeatures(toMFA: false)
        }
    }
    
    func getTheUserSubscriptionFeatures(toMFA: Bool) {
        
        guard Connectivity.isConnectedToInternet() else {
            AlertProvider.init(vc: self).showAlert(title: "No Internet Connection!", message: "No internet found. Check your network connection and Try again...", action: AlertAction(title: "Dismiss"))
            return
        }
        
        let userSubscriptionFeatures = GetUserSubscriptionFeatures()
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        userSubscriptionFeatures.getUserSubscriptionFeatures { (success, planFeatures) in
            Singletone.shareInstance.stopActivityIndicator()
            
            if success {
                if let _planFeatures = planFeatures, let features = _planFeatures.PalnFeatures {
                    FeatureMatrix.shared.setupFeatures(featuresAllowed: features)
                }
            } else {
                FeatureMatrix.shared.clearValues()
            }
            self.gotoNextScreen(toMFA: toMFA)
        }
    }
    
    func gotoNextScreen(toMFA: Bool) {
        if toMFA {
            gotoMFAPage()
        } else {
            openSubscriptionScreens()
        }
    }
    
    func gotoMFAPage() {
        let appdelegate = UIApplication.shared.delegate
        let multifactorsettingsController = MultifactorSettingsViewController()
        let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
        
        DispatchQueue.main.async {
            appdelegate?.window!?.rootViewController = aObjNavi
        }
    }
    
    private func openSubscriptionScreens() {
        
        let subscriptionData = GetSubscriptionData()
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        subscriptionData.getUserSubscriptionData { (isActive, subscriptionData) in
            
            if let _subscriptionData = subscriptionData {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(_subscriptionData) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "subscriptionData")
                }
            }
            
            if let _IsSubscriptionActive = subscriptionData?.IsSubscriptionActive {
                if _IsSubscriptionActive {
                    
                    if subscriptionData?.SubscriptionPlan == 5 {
                        ZorroTempData.sharedInstance.setUserSubscribedOrNot(subscribed: false)
                    } else {
                        ZorroTempData.sharedInstance.setUserSubscribedOrNot(subscribed: true)
                    }
                    
                    if ZorroTempData.sharedInstance.getUserSubscribedOrNot() {
                        self.biometricsOnboarding()
                    } else {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.gotoSubscriptionPage()
                    }
                } else {
                    self.biometricsOnboarding()
                }
            } else {
                self.gotoSubscriptionPage()
            }
        }
    }
        
    func gotoSubscriptionPage() {
        let appdelegate = UIApplication.shared.delegate
        let storyboad = UIStoryboard.init(name: "Subscription", bundle: nil)
        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "SubscriptionNC")
        DispatchQueue.main.async {
            appdelegate?.window!?.rootViewController = viewcontroller
        }
    }
    
    private func showPasswordChangeAlert(message: String, skipOrCancel: String, completion: @escaping (Bool)->()) {
        
        AlertProvider.init(vc: self).showAlertWithActions(title: "Alert", message: message, actions: [AlertAction(title: skipOrCancel), AlertAction(title: "Confirm")]) { (action) in
            if action.title == "Confirm" {
                
                
                
                let str: String  = (self.email.trim().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B"))!
                print(str)
                
                guard Connectivity.isConnectedToInternet() else {
                    AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "No internet connection found. Check your network connection and Try again...", action: AlertAction(title: "Dismiss")) { (action) in
                    }
                    return
                }
                
                Singletone.shareInstance.showActivityIndicatory(uiView: self.view, text: "Please wait while you are logged in.")
                
                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/ResetPassword?userName=\(str)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Singletone.shareInstance.headerAPIForgot)
                    .responseJSON { response in
                        
                        Singletone.shareInstance.stopActivityIndicator()
                        
                        let jsonObj: JSON = JSON(response.result.value!)
                        print(jsonObj)
                        if jsonObj["StatusCode"] == 3549 {
                            AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: "You have successfully made a request to reset the password. To complete the request, please check your Email.", action: AlertAction(title: "Dismiss")) { (action) in
                                completion(true)
                            }
                        } else {
                            AlertProvider.init(vc: self).showAlertWithActions(title: "Alert", message: jsonObj["Message"].stringValue, actions: [AlertAction(title: "Go to Dashboard"), AlertAction(title: "Cancel")]) { (action) in
                                if action.title == "Go to Dashboard" {
                                    completion(true)
                                } else {
                                    
                                }
                            }
                        }
                    }
            } else {
                completion(true)
            }
        }
    }
    
    fileprivate func getDate(dateString: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        var date = dateformatter.date(from: dateString)
        
        if date == nil {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            date = dateformatter.date(from: dateString)
        }
        
        if date == nil {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            date = dateformatter.date(from: dateString)
        }
        
        return date!
    }
    
    private func gotoaccountLockView() {
        
        let accountlockController = AccountLockController()
        accountlockController.isfromOtp = nil
        accountlockController.providesPresentationContextTransitionStyle = true
        accountlockController.definesPresentationContext = true
        accountlockController.modalPresentationStyle = .overCurrentContext
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(accountlockController, animated: false, completion: nil)
        }
    }
    
    func addDeviceToken() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let deviceId: String = UserDefaults.standard.string(forKey: "deviceId") ?? ""
        //        let ProfileId: String = UserDefaults.standard.string(forKey: "ProfileId")!
        //        let email: String = txtUserName.text!
        
        let param = [ "DeviceId": deviceId,
                      "DeveiceType": 0 ] as [String : Any]
        
        Alamofire.request(URL(string: Singletone.shareInstance.apiNotification + "api/v1/Notification/AddUserDevice")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                if response != nil {
                    let jsonObj: JSON = JSON(response.result.value)
                        //                        print(jsonObj)
                        print(jsonObj["StatusCode"])
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                        }
                    
                }
        }
    }
    
    // xml parsing
    
    func parseXML() {
        
        if let path = Bundle.main.path(forResource: "test", ofType: "xml") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let xml = try! XML.parse(data)
                print("xml: \(xml)")
                for entry in xml["feed","entry"] {
                    print("email: \(entry["gd:email"].attributes["address"])")
                }
            }catch{}
        }
    }
}

extension LoginViewController {
    fileprivate func setStyles() {
        
        
        btnAgree.layer.borderColor = UIColor.darkGray.cgColor
        btnAgree.layer.cornerRadius = 5
        btnAgree.layer.borderWidth = 1
        btnAgree.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        print("Screen Height : \(UIScreen.main.bounds.height)")
        
//        containerviewWidth.constant = UIScreen.main.bounds.width
//        containerviewHeight.constant = UIScreen.main.bounds.height
        loginscrollView.isScrollEnabled = false
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.height == 568 {
                loginlogoTopConstraint.constant = 50
//                usernametextTopConstraint.constant = 60
//                containerviewHeight.constant = UIScreen.main.bounds.height
            }
            
            if UIScreen.main.bounds.height == 667 {
                loginlogoTopConstraint.constant = 80
//                usernametextTopConstraint.constant = 100
//                containerviewHeight.constant = UIScreen.main.bounds.height
            }
            
            if UIScreen.main.bounds.height == 736 {
                loginlogoTopConstraint.constant = 100
//                usernametextTopConstraint.constant = 100
//                containerviewHeight.constant = UIScreen.main.bounds.height
            }
            
            if UIScreen.main.bounds.height == 812  {
                loginlogoTopConstraint.constant = 100
//                usernametextTopConstraint.constant = 120
//                containerviewHeight.constant = UIScreen.main.bounds.height - 50
            }
            
            if UIScreen.main.bounds.height == 896 {
                loginlogoTopConstraint.constant = 120
//                usernametextTopConstraint.constant = 140
//                containerviewHeight.constant = UIScreen.main.bounds.height - 50
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            loginlogoTopConstraint.constant = 200
            let newConstraint = logoWidthConstraint.constraintWithMultiplier(0.45)
            view.removeConstraint(logoWidthConstraint)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            logoWidthConstraint = newConstraint
//            usernametextTopConstraint.constant = 100
//            containerviewHeight.constant = UIScreen.main.bounds.height
        }
        
        viewUserName.layer.shadowRadius  = 1.5;
        viewUserName.layer.shadowColor   = UIColor.lightGray.cgColor
        viewUserName.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        viewUserName.layer.shadowOpacity = 0.9;
        viewUserName.layer.masksToBounds = false;
        viewUserName.layer.cornerRadius = 8
        
        viewPassword.layer.shadowRadius  = 1.5;
        viewPassword.layer.shadowColor   = UIColor.lightGray.cgColor
        viewPassword.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        viewPassword.layer.shadowOpacity = 0.9;
        viewPassword.layer.masksToBounds = false;
        viewPassword.layer.cornerRadius = 8
        
        tokenImage.layer.shadowRadius  = 1.5;
        tokenImage.layer.shadowColor   = UIColor.lightGray.cgColor
        tokenImage.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        tokenImage.layer.shadowOpacity = 0.9;
        tokenImage.layer.masksToBounds = false;
        tokenImage.layer.cornerRadius = 30
        tokenreaderButton.addTarget(self, action: #selector(tokenRead(_:)), for: .touchUpInside)
        
        contactImage.layer.shadowRadius  = 1.5;
        contactImage.layer.shadowColor   = UIColor.lightGray.cgColor
        contactImage.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        contactImage.layer.shadowOpacity = 0.9;
        contactImage.layer.masksToBounds = false;
        contactImage.layer.cornerRadius = 30
        contactusButton.addTarget(self, action: #selector(contactUs(_:)), for: .touchUpInside)
    }
}


extension LoginViewController: QRCodeReaderViewControllerDelegate {
    
    @objc fileprivate func tokenRead(_ sender: UIButton) {
        
        if let serviceToken = UserDefaults.standard.string(forKey: "ServiceToken") {
            if !serviceToken.isEmpty {
                if FeatureMatrix.shared.getPwd_less_login() {
                    showQRReader()
                } else {
                    FeatureMatrix.shared.showRestrictedMessage()
                }
            } else {
                showQRReader()
            }
        } else {
            showQRReader()
        }
    }
    
    func showQRReader() {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .fullScreen
        
        readerVC.codeReader.startScanning()
        present(readerVC, animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        let isloginqr = differentiateQR(qrstring: result.value)
        if isloginqr {
            passwordlessAuthentication(qrstring: result.value)
            return
        } else {
            UserDefaults.standard.set(result.value, forKey: "qrcode")
            UserDefaults.standard.set(result.value, forKey: "scannedqrcode")
            ZorroTempData.sharedInstance.set4n6Token(tokenstring: result.value)
            dismiss(animated: true, completion: {
                self.showLoginPopup()
            })
            return
        }
    }
    
    func showLoginPopup() {
        let alert = UIAlertController(title: "Authenticate", message: "Login to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: nil))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController {
    @objc fileprivate func contactUs(_ sender: UIButton) {
        print("working")
        
        
        let arvc = VcardqrgeneratorController()
        arvc.modalPresentationStyle = .fullScreen
        arvc.isFromLogin = true
        self.present(arvc, animated: true, completion: nil)
        
        //        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        //        let contactv = sb.instantiateViewController(withIdentifier: "Help_SBID") as! ContactsViewController
        //
        //
        //        contactv.flagback = true
        //        contactv.fromlogin = true
        //        self.present(contactv, animated: true, completion: nil)
    }
}

extension LoginViewController {
    private func checkforOTP() {
        
        let otplogincontroller = OTPLoginController()
        otplogincontroller.username = email
        otplogincontroller.modalPresentationStyle = .fullScreen
        otplogincontroller.otploginCallBack = { (_logindata, statusCode) in
            if _logindata == nil {
                if statusCode == 9201 {
                    self.showPasswordChangeAlert(message: "Your password has expired. Please reset your password to continue", skipOrCancel: "Cancel") { (success) in
                        
                    }
                    return
                }
                
                if statusCode == 9202 {
                    self.showPasswordChangeAlert(message: "Due to account inactivity your password must be reset to continue", skipOrCancel: "Cancel") { (success) in
                        
                    }
                    return
                }
            } else {
                self.tempData(logindata: _logindata!)
            }
            return
        }
        DispatchQueue.main.async {
            self.present(otplogincontroller, animated: true, completion: nil)
        }
        return
    }
}

extension LoginViewController {
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
            self.stopActivityIndicator()
            if err {
                self.alertSample(strTitle: "Something Went Wrong ", strMsg: "Unable to get user details, please try again")
                completion(false)
                return
            }
            
            // Set Profile Status
            
            if let firstName = userprofiledata?.Data?.FirstName, let lastName = userprofiledata?.Data?.LastName, let phoneNumber = userprofiledata?.Data?.PhoneNumber {
                if !firstName.isEmpty && !lastName.isEmpty && !phoneNumber.isEmpty {
                    UserDefaults.standard.set(0, forKey: "ProfileStatus")
                } else {
                    UserDefaults.standard.set(1, forKey: "ProfileStatus")
                }
            } else {
                UserDefaults.standard.set(1, forKey: "ProfileStatus")
            }
            
            if let otpmobilenumber = userprofiledata?.Data?.OTPMobileNumber {
                print(otpmobilenumber)
                ZorroTempData.sharedInstance.setOtpNumber(mobilenumber: otpmobilenumber)
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
            
//            if signatures.isEmpty || signatures[0].Signature == "" {
//                UserDefaults.standard.setValue(true, forKey: "isNewUser")
//
//                let appdelegate = UIApplication.shared.delegate
//                let storyboad = UIStoryboard.init(name: "Signature", bundle: nil)
//                let signatureNC = storyboad.instantiateViewController(withIdentifier: "AddSignatureNC") as! UINavigationController
//                DispatchQueue.main.async {
//                    appdelegate?.window!?.rootViewController = signatureNC
//                }
//
//                // let signatureVC = signatureNC.topViewController as! SignatureVC
//
//                // if let _userprofiledata = userprofiledata {
//                    // signatureVC.vm.userProfile = _userprofiledata
//                    // signatureVC.vm.defaultSignature = nil
//                    // signatureVC.vm.arrOptionalSignatures = nil
//                // }
//            } else {
//                ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
//                completion(true)
//            }
            
            ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
            completion(true)
        }
    }
}

//MARK: Setup otp login data -> This should remove when refactoring the code. nothing to do with bad coding
extension LoginViewController {
    func tempData(logindata: UserLoginData) {
        Singletone.shareInstance.stopActivityIndicator()
        UserDefaults.standard.set(logindata.ServiceToken, forKey: "ServiceToken")
        UserDefaults.standard.set(logindata.UserName, forKey: "UserName")
        let profId = logindata.ProfileId!.stringByAddingPercentEncodingForRFC3986()
        //UserDefaults.standard.set(profId, forKey: "ProfileId")
        ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
        let usertype = logindata.UserType
        ZorroTempData.sharedInstance.setIsUserLoggedIn(islogged: true)
        ZorroTempData.sharedInstance.setUserType(usertype: usertype!)
        ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
        ZorroTempData.sharedInstance.setUserEmail(email: self.email)
        
        // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
        
        UserDefaults.standard.set(logindata.OrganizationId, forKey: "OrgProfileId")
        UserDefaults.standard.set(logindata.ProfileCompletionStatus ?? 0, forKey: "ProfileStatus")
        UserDefaults.standard.set(logindata.ProfileCompletionStatus ?? 0, forKey: "ProfComplStatus")
        
        UserDefaults.standard.set(logindata.OrganizationId, forKey: "OrganizationId")
        
        //Set subscription data to userdefaults
        if logindata.Subscription != nil {
            UserDefaults.standard.set(true, forKey: "hasSubscriptionData")
        } else {
            UserDefaults.standard.set(false, forKey: "hasSubscriptionData")
        }
        
        if let permissions = logindata.Permissions {
            if permissions.contains("AccessAdminPage") || permissions.contains("ManageDepartments") || permissions.contains("ManageUsers") || permissions.contains("ManagerRoles") {
                UserDefaults.standard.set(true, forKey: "AdminFlag")
            } else {
                UserDefaults.standard.set(false, forKey: "AdminFlag")
            }
        } else {
            UserDefaults.standard.set(false, forKey: "AdminFlag")
        }
        
        self.addDeviceToken()
        self.updateSignatures(completion: { (completed) in
            if completed {
                let passwordExpiryWarning = logindata.PasswordExpiryWarning
                let PasswordExpiryDate = logindata.PasswordExpiryDate
                
                if let _passwordExpiryWarning = passwordExpiryWarning, let _PasswordExpiryDate = PasswordExpiryDate, _passwordExpiryWarning {
                    let pendingDays = self.getDate(dateString: _PasswordExpiryDate) - Date()
                    
                    if let _pendingDays = pendingDays.day {
                        if _pendingDays >= 0 {
                            if _pendingDays == 0 {
                                self.showPasswordChangeAlert(message: "Your password expires today. Select here to change your password.", skipOrCancel: "Skip") { (success) in
                                    let isOrgForceMFAEnabled = logindata.IsOrganizationMFAEnabledForUsers
                                    let isMFAEnabled = logindata.IsMFAForcedToEnable
                                    
                                    // Navigate to MFA Screen
                                    
                                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled, let _isMFAEnabled = isMFAEnabled {
                                        self.gotoNextScreen(isOrgForceMFAEnabled: _isOrgForceMFAEnabled, isMFAEnabled: _isMFAEnabled)
                                    }
                                    
//                                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled {
//                                        if _isOrgForceMFAEnabled {
//                                            UserDefaults.standard.set("YES", forKey: "FromForceMFA")
//                                            if isMFAEnabled == false {
//                                                let appdelegate = UIApplication.shared.delegate
//                                                let multifactorsettingsController = MultifactorSettingsViewController()
//                                                let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
//
//                                                DispatchQueue.main.async {
//                                                    appdelegate?.window!?.rootViewController = aObjNavi
//                                                }
//                                            } else {
//                                                self.biometricsOnboarding()
//                                            }
//                                        } else {
//                                            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                            self.biometricsOnboarding()
//                                        }
//                                    } else {
//                                        UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                        self.biometricsOnboarding()
//                                    }
                                    return
                                }
                            } else {
                                self.showPasswordChangeAlert(message: "Your password will expire in \(_pendingDays) days. Select here to change your password", skipOrCancel: "Skip") { (success) in
                                    let isOrgForceMFAEnabled = logindata.IsOrganizationMFAEnabledForUsers
                                    let isMFAEnabled = logindata.IsMFAForcedToEnable
                                    
                                    
                                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled, let _isMFAEnabled = isMFAEnabled {
                                        self.gotoNextScreen(isOrgForceMFAEnabled: _isOrgForceMFAEnabled, isMFAEnabled: _isMFAEnabled)
                                    }
                                    
                                    // Navigate to MFA Screen
//                                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled {
//                                        if _isOrgForceMFAEnabled {
//                                            UserDefaults.standard.set("YES", forKey: "FromForceMFA")
//                                            if isMFAEnabled == false {
//                                                let appdelegate = UIApplication.shared.delegate
//                                                let multifactorsettingsController = MultifactorSettingsViewController()
//                                                let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
//
//                                                DispatchQueue.main.async {
//                                                    appdelegate?.window!?.rootViewController = aObjNavi
//                                                }
//                                            } else {
//                                                self.biometricsOnboarding()
//                                            }
//                                        } else {
//                                            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                            self.biometricsOnboarding()
//                                        }
//                                    } else {
//                                        UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                        self.biometricsOnboarding()
//                                    }
                                    return
                                }
                            }
                        }
                    }
                } else {
                    
                    
                    
                    let isOrgForceMFAEnabled = logindata.IsOrganizationMFAEnabledForUsers
                    let isMFAEnabled = logindata.IsMFAForcedToEnable
                    
                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled, let _isMFAEnabled = isMFAEnabled {
                        self.gotoNextScreen(isOrgForceMFAEnabled: _isOrgForceMFAEnabled, isMFAEnabled: _isMFAEnabled)
                    }
                    
                    // Navigate to MFA Screen
//                    if let _isOrgForceMFAEnabled = isOrgForceMFAEnabled {
//                        if _isOrgForceMFAEnabled {
//                            UserDefaults.standard.set("YES", forKey: "FromForceMFA")
//                            if isMFAEnabled == false {
//                                let appdelegate = UIApplication.shared.delegate
//                                let multifactorsettingsController = MultifactorSettingsViewController()
//                                let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
//
//                                DispatchQueue.main.async {
//                                    appdelegate?.window!?.rootViewController = aObjNavi
//                                }
//                            } else {
//                                self.biometricsOnboarding()
//                            }
//                        } else {
//                            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                            self.biometricsOnboarding()
//                        }
//                    } else {
//                        UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                        self.biometricsOnboarding()
//                    }
                    return
                }
            }
        })
        return
    }
}

//MARK: - Differentiate QR
extension LoginViewController {
    private func differentiateQR(qrstring: String) -> Bool {
        if qrstring.contains("SessionID") {
            return true
        }
        return false
    }
}

//MARK: - Biometric Fallback otp flow
extension LoginViewController {
    private func biometricFallbackOtp(param: [String: Any], email: String) {
        
        let fallbackotploginController = FallbackOtpLoginController()
        fallbackotploginController.param = param
        fallbackotploginController.otpreceiverEmail = email
        fallbackotploginController.providesPresentationContextTransitionStyle = true
        fallbackotploginController.definesPresentationContext = true
        fallbackotploginController.modalPresentationStyle = .overCurrentContext
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(fallbackotploginController, animated: false, completion: nil)
        }
    }
}

//MARK: - Biometric Fallback question flow
extension LoginViewController {
    private func biometricFallbackQuestion(param: [String: Any], q1: String, q2: String, q3: String) {
        
        let fallbackquestionloginController = FallbackQuestionLoginController()
        fallbackquestionloginController.param = param
        fallbackquestionloginController.question1 = q1
        fallbackquestionloginController.question2 = q2
        fallbackquestionloginController.question3 = q3
        fallbackquestionloginController.providesPresentationContextTransitionStyle = true
        fallbackquestionloginController.definesPresentationContext = true
        fallbackquestionloginController.modalPresentationStyle = .overCurrentContext
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(fallbackquestionloginController, animated: false, completion: nil)
        }
    }
}

//MARK: - Bimetrics Onboarding
extension LoginViewController {
    private func biometricsOnboarding() {
        
        let username: String = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid: String = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: username.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (onboarded, keyid) in
            
            Singletone.shareInstance.stopActivityIndicator()
            
            if !onboarded {
                let passwordlessIntroController = PasswordlessIntroController()
                passwordlessIntroController.providesPresentationContextTransitionStyle = true
                passwordlessIntroController.definesPresentationContext = true
                passwordlessIntroController.modalPresentationStyle = .overCurrentContext
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                self.view.window?.layer.add(transition, forKey: kCATransition)
                
                DispatchQueue.main.async {
                    self.present(passwordlessIntroController, animated: false, completion: nil)
                }
                
                passwordlessIntroController.skipCallBack = { skip in
                    if skip {
                        
                        let appdelegate = UIApplication.shared.delegate
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                        DispatchQueue.main.async {
                            appdelegate?.window!?.rootViewController = viewcontroller
                        }
                    }
                    return
                }
                
                passwordlessIntroController.onBoardStatus = {
                    let appdelegate = UIApplication.shared.delegate
                    let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                    DispatchQueue.main.async {
                        appdelegate?.window!?.rootViewController = viewcontroller
                    }
                    return
                }
                return
            }
            
            let appdelegate = UIApplication.shared.delegate
            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
            DispatchQueue.main.async {
                appdelegate?.window!?.rootViewController = viewcontroller
            }
            return
        }
        return
    }
}

//MARK: - Passwordless Authentication
extension LoginViewController {
    private func passwordlessAuthentication(qrstring: String) {
        
        let userid = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: userid.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (success, keyid) in
            
            if success {
                
                let sessionidSplit = qrstring.components(separatedBy: " ")
                let isIndexValid = sessionidSplit.indices.contains(1)
                
                if isIndexValid && userid != "" {
                    
                    let sessionid = sessionidSplit[1]
                    let biometricWrapper = BiometricsWrapper()
                    
                    biometricWrapper.authenticateWithBiometric { (_success, _errmsg) in
                        guard let _issuccess = _success else { return }
                        
                        if _issuccess {
                            
                            let pkiHelper = PKIHelper()
                            pkiHelper.signWithPrivateKey(textIn: sessionid, keyid: keyid) { (signsuccess, signedmessage) in
                                
                                if signsuccess {
                                    
                                    let passwordlesAuth = PasswordlessAuthentication(UserId: userid, SessionId: sessionid, DeviceId: deviceid, Signature: signedmessage)
                                    passwordlesAuth.userAuthenticateWithQR(passwordlessauthentication: passwordlesAuth) { (success) in
                                        
                                        if success {
                                            DispatchQueue.main.async {
                                                self.dismiss(animated: true) {
                                                    self.alertSample(strTitle: "Success!", strMsg: "Successfully Authenticated")
                                                }
                                            }
                                            return
                                        }
                                        DispatchQueue.main.async {
                                            self.dismiss(animated: true) {
                                                self.alertSample(strTitle: "Error!", strMsg: "Unable to Authenticated!")
                                            }
                                        }
                                    }
                                    return
                                    
                                }
                                DispatchQueue.main.async {
                                    self.dismiss(animated: true) {
                                        self.alertSample(strTitle: "Error!", strMsg: "Unable to Authenticated!")
                                    }
                                }
                                return
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self.dismiss(animated: true) {
                                self.alertSample(strTitle: "Error!", strMsg: _errmsg ?? "Unable to Authenticate")
                            }
                        }
                        return
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.alertSample(strTitle: "Invalid QR!", strMsg: "Please scan a valid QR to login")
                    }
                }
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true) {
                    self.alertSample(strTitle: "Not Enrolled!", strMsg: "Please enroll for the passwordless feature in order to use it")
                }
            }
            return
        }
        return
    }
}

//MARK: - Passwordless Alert
extension LoginViewController {
    func showActivateAcountAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = greencolor
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            return
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
