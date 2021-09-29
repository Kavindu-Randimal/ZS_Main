//
//  FallbackOtpLoginController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/24/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FallbackOtpLoginController: FallbackBaseController {
    
    private var zorrosignLogo: UIImageView!
    private var fallbackloginotpView: FallbackLoginOtpView!
    private var fallbackTitle: UILabel!
    private var fallbackDescription: UILabel!
    private var didntreceiveLabel: UILabel!
    private var resendOtpLabel: UILabel!
    private var verifyButton: UIButton!
    private var errorMessageLabel: UILabel!
    
    var otpreceiverEmail: String = ""
    var otpcallBack: ((Int?) -> ())?
    var otpValue: Int!
    var param: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setzorrosignLogo()
        setotpView()
        setverifyButtonUi()
    }
}

//MARK: Setup Zorrosign Logo
extension FallbackOtpLoginController {
    private func setzorrosignLogo() {
        
        let safearea = self.view.safeAreaLayoutGuide
        
        zorrosignLogo = UIImageView()
        zorrosignLogo.translatesAutoresizingMaskIntoConstraints = false
        zorrosignLogo.backgroundColor = .white
        zorrosignLogo.contentMode = .scaleAspectFit
        zorrosignLogo.image = UIImage(named: "zorrosign_highres_logo")
        
        self.view.addSubview(zorrosignLogo)
        
        let logoHeight = (deviceWidth - 80)/1.77
        
        let zorrosignlogoConstraints = [zorrosignLogo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
                                        zorrosignLogo.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 20),
                                        zorrosignLogo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -20),
                                        zorrosignLogo.heightAnchor.constraint(equalToConstant: logoHeight)]
        NSLayoutConstraint.activate(zorrosignlogoConstraints)
    }
}

//MARK: Set otp view
extension FallbackOtpLoginController {
    
    fileprivate func getHiddenEmail(for email: String) -> String {
        
        // Adding 2 letters from name
        var astrixs: String = String(email.prefix(2))
        
        let name = email.split(separator: "@")[0]
        let domain = email.split(separator: "@")[1].split(separator: ".")[0]
        
        // Add Astrix for name
        for _ in 0..<name.count - 2 {
            astrixs.append("*")
        }
        astrixs.append("@")
        
        // Add Astrix for domain
        for _ in 0..<domain.count {
            astrixs.append("*")
        }
        astrixs.append(".")
        astrixs.append(contentsOf: email.split(separator: "@")[1].split(separator: ".")[1])
        
        return astrixs
    }
    
    private func setotpView() {
        
        fallbackTitle = UILabel()
        fallbackTitle.translatesAutoresizingMaskIntoConstraints = false
        fallbackTitle.text = "Reset Biometric Verification"
        fallbackTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        fallbackTitle.textColor =  ColorTheme.lblBodySpecial2
        fallbackTitle.numberOfLines = 1
        self.view.addSubview(fallbackTitle)
        
        let fallbacktitleConstraints = [fallbackTitle.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor, constant: 40),
                                        fallbackTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        fallbackTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(fallbacktitleConstraints)
        
        fallbackDescription = UILabel()
        fallbackDescription.translatesAutoresizingMaskIntoConstraints = false
        fallbackDescription.font = UIFont(name: "Helvetica", size: 17)
        fallbackDescription.textAlignment = .left
        fallbackDescription.textColor =  ColorTheme.lblBodySpecial2
        fallbackDescription.adjustsFontSizeToFitWidth = true
        fallbackDescription.minimumScaleFactor = 0.2
        fallbackDescription.numberOfLines = 2
        
        let _attributedText = fallbackDescription.attributedText(withString: "We have sent you a 4-digit verification code to the following " + getHiddenEmail(for: otpreceiverEmail), boldString: [""], font: UIFont(name: "Helvetica", size: 17)!, underline: false)
        fallbackDescription.attributedText = _attributedText
        
        self.view.addSubview(fallbackDescription)
        
        let fallbackdescriptionlabelConstraints = [fallbackDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                                   fallbackDescription.topAnchor.constraint(equalTo: fallbackTitle.bottomAnchor,constant: 25),
                                                   fallbackDescription.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(fallbackdescriptionlabelConstraints)
        
        fallbackloginotpView = FallbackLoginOtpView()
        
        fallbackloginotpView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fallbackloginotpView)
        
        var otpsentcodetimerviewHeight: CGFloat = 80
        if deviceName == .pad {
            otpsentcodetimerviewHeight = 100
        }
        
        let otpsenttimerviewConstraints = [fallbackloginotpView.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
                                           fallbackloginotpView.topAnchor.constraint(equalTo: fallbackDescription.bottomAnchor,constant: 20),
                                           fallbackloginotpView.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10),
                                           fallbackloginotpView.heightAnchor.constraint(equalToConstant: otpsentcodetimerviewHeight)]
        
        NSLayoutConstraint.activate(otpsenttimerviewConstraints)
        
        fallbackloginotpView.otpcallBack = { [weak self] (otp) in
            self?.otpValue = otp
            self?.errorMessageLabel.isHidden = true
            return
        }
        
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = ColorTheme.lblBodySpecial2
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.text = "The code you entered is incorrect, please try again."
        errorMessageLabel.font = UIFont(name: "Helvetica", size: 16)
        errorMessageLabel.adjustsFontSizeToFitWidth = true
        errorMessageLabel.minimumScaleFactor = 0.2
        errorMessageLabel.numberOfLines = 3
        errorMessageLabel.isHidden = true
        
        self.view.addSubview(errorMessageLabel)
        
        let errormessagelabelConstraints = [errorMessageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                            errorMessageLabel.topAnchor.constraint(equalTo: fallbackloginotpView.bottomAnchor)]
        NSLayoutConstraint.activate(errormessagelabelConstraints)
        
        didntreceiveLabel = UILabel()
        didntreceiveLabel.translatesAutoresizingMaskIntoConstraints = false
        didntreceiveLabel.textColor = ColorTheme.lblBodySpecial2
        didntreceiveLabel.textAlignment = .left
        didntreceiveLabel.text = "Didn't receive the code?  "
        didntreceiveLabel.font = UIFont(name: "Helvetica", size: 16)
        self.view.addSubview(didntreceiveLabel)
        
        let didntreceivelabelCoonstraints = [didntreceiveLabel.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 10),
                                             didntreceiveLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(didntreceivelabelCoonstraints)
        
        resendOtpLabel = UILabel()
        resendOtpLabel.translatesAutoresizingMaskIntoConstraints = false
        resendOtpLabel.textAlignment = .left
        resendOtpLabel.numberOfLines = 0
        resendOtpLabel.isUserInteractionEnabled = true
        resendOtpLabel.font = UIFont(name: "Helvetica", size: 16)
        let _attributedTextResendOtpLabel = resendOtpLabel.attributedText(withString: "RESEND CODE", boldString: ["RESEND CODE"], font: UIFont(name: "Helvetica", size: 16)!, underline: true)
        resendOtpLabel.attributedText = _attributedTextResendOtpLabel
        resendOtpLabel.textColor = ColorTheme.lblBgSpecial
        self.view.addSubview(resendOtpLabel)
        
        let typecodetapGesture = UITapGestureRecognizer(target: self, action: #selector(resendandchangeAction(_:)))
        resendOtpLabel.addGestureRecognizer(typecodetapGesture)
        
        let resendOtpConstraints = [resendOtpLabel.leftAnchor.constraint(equalTo: didntreceiveLabel.rightAnchor),
                                    resendOtpLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(resendOtpConstraints)
    }
}

//MARK: Set verify button Ui
extension FallbackOtpLoginController {
    private func setverifyButtonUi() {
        
        //let safearea = view.safeAreaLayoutGuide
        var verifybuttontopAnchor: CGFloat = 80
        if deviceName == .pad {
            verifybuttontopAnchor = 100
        }
        
        verifyButton = UIButton()
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.backgroundColor = ColorTheme.btnBG
        verifyButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        verifyButton.setTitle("VERIFY & PROCEED", for: .normal)
        verifyButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        verifyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        verifyButton.titleLabel?.minimumScaleFactor = 0.2
        verifyButton.titleLabel?.textAlignment = .center
        
        self.view.addSubview(verifyButton)
        
        let otpsentVerifyButtonConstraints = [verifyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                              verifyButton.topAnchor.constraint(equalTo: resendOtpLabel.bottomAnchor,constant: verifybuttontopAnchor),
                                              verifyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                              verifyButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
        verifyButton.setShadow()
        verifyButton.addTarget(self, action: #selector(verifyOTP(_:)), for: .touchUpInside)
    }
}

//MARK: - Resend OTP code
extension FallbackOtpLoginController {
    @objc
    private func resendandchangeAction(_ recognizer: UITapGestureRecognizer) {
        let secondaryemail = ZorroTempData.sharedInstance.getSecondaryEmail()
        let userid = ZorroTempData.sharedInstance.getUserEmail()
        
        let fallbackotpRequest = FallbackOTPRequest(SecondaryEmail: secondaryemail, UserId: userid)
        fallbackotpRequest.requestuserotpWithSecondaryEmail(otprequestwithemail: fallbackotpRequest) { (requested) in
            if requested {
                self.errorMessageLabel.isHidden = true
                return
            }
            return
        }
    }
}

//MARK: - Verify the OTP Action
extension FallbackOtpLoginController {
    @objc
    private func verifyOTP(_ sender: UIButton) {
        print("Chathura texfield otp value ", self.otpValue);
        
        if Connectivity.isConnectedToInternet() == true
        {
            Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "Please wait while you are logged in.")
            
            let fallbackoption = [
                "Answer":"",
                "Email": self.otpreceiverEmail,
                "Question": "",
                "Type":1,
                "OTP": self.otpValue
                ] as [String : Any]
            
            var fallbackArray:[Any] = []
            fallbackArray.append(fallbackoption)
            
            let fallbackparams = ["UserName" : self.param["UserName"] as Any,
                                  "Password" : self.param["Password"] as Any,
                                  "ClientId": Singletone.shareInstance.clientId,
                                  "ClientSecret": Singletone.shareInstance.clientSecret,
                                  "DoNotSendActivationMail": true,
                                  "FallbackAnswers":fallbackArray
                ] as [String : Any]
            
            print("Chathura fallback otp request ", fallbackparams)
            
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/Login")!, method: .post, parameters: fallbackparams, encoding: JSONEncoding.default, headers: Singletone.shareInstance.headerAPI).responseJSON { response in
                if response != nil {
                    let jsonObj: JSON = JSON(response.result.value) 
                        
                        print("Chathura fallback response for otp ", jsonObj["StatusCode"], " ", jsonObj["Data"])
                        
                        if jsonObj["StatusCode"] == 1000 {
                            print("Chathura fallback success response ", jsonObj["Data"])
                            
                            Singletone.shareInstance.stopActivityIndicator()
                            
                            UserDefaults.standard.set(jsonObj["Data"]["ServiceToken"].stringValue, forKey: "ServiceToken")
                            UserDefaults.standard.set(jsonObj["Data"]["UserName"].stringValue, forKey: "UserName")
                            let profId = jsonObj["Data"]["ProfileId"].stringValue.stringByAddingPercentEncodingForRFC3986()
                            let _userEmail = ZorroTempData.sharedInstance.getpasswordlessUser()
                            ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
                            let usertype = jsonObj["Data"]["UserType"].intValue
                            ZorroTempData.sharedInstance.setIsUserLoggedIn(islogged: true)
                            ZorroTempData.sharedInstance.setUserType(usertype: usertype)
                            ZorroTempData.sharedInstance.setProfileId(profileid: profId!)
                            ZorroTempData.sharedInstance.setUserEmail(email: _userEmail)
                            ZorroTempData.sharedInstance.setPasswordlessUser(email: _userEmail)
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
                                    
                                    if passwordExpiryWarning {
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
                                    
//                                    let passwordExpiryWarning = jsonObj["Data"]["PasswordExpiryWarning"].boolValue
//
//                                    if passwordExpiryWarning {
//                                        let passwordExpiryDate = jsonObj["Data"]["PasswordExpiryDate"].stringValue
//
//                                        let pendingDays = self.getDate(dateString: passwordExpiryDate) - Date()
//
//                                        if let _pendingDays = pendingDays.day {
//                                            if _pendingDays >= 0 {
//                                                if _pendingDays == 0 {
//                                                    self.showPasswordChangeAlert(message: "Your password expires today. Select here to change your password.")
//                                                } else {
//                                                    self.showPasswordChangeAlert(message: "Your password will expire in \(_pendingDays) days. Select here to change your password")
//                                                }
//                                            }
//                                        }
//                                    }
//                                    else {
//                                        let isOrgForceMFAEnabled = jsonObj["Data"]["IsOrganizationMFAEnabledForUsers"].boolValue
//
//                                        let isMFAEnabled = jsonObj["Data"]["IsMFAForcedToEnable"].boolValue
//
//                                        // Navigate to MFA Screen
//                                        if isOrgForceMFAEnabled {
//                                            UserDefaults.standard.set("YES", forKey: "FromForceMFA")
//
//                                            let multifactorSettingsResponse = MultifactorSettingsResponse()
//
//                                            multifactorSettingsResponse.getuserMultifactorSettings { (data) in
//
//                                                if data?.TwoFAType == 0 {
//                                                    let appdelegate = UIApplication.shared.delegate
//                                                    let multifactorsettingsController = MultifactorSettingsViewController()
//                                                    let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
//
//                                                    DispatchQueue.main.async {
//                                                        appdelegate?.window!?.rootViewController = aObjNavi
//                                                    }
//                                                } else {
//                                                    self.biometricsOnboarding()
//                                                }
//                                            }
//                                        } else {
//                                            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                            self.biometricsOnboarding()
//                                        }
//                                    }
                                    return
                                }
                            })
                            
                            return
                        } else {
                            Singletone.shareInstance.stopActivityIndicator()
                            
                            if jsonObj["StatusCode"] == 5006 {
                                self.gotoaccountLockView()
                                return
                            }
                            if jsonObj["StatusCode"] == 5011 {
                                let _errorMsg = jsonObj["Message"].stringValue
                                self.alertSample(strTitle: "", strMsg: _errorMsg)
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
                        }
                        Singletone.shareInstance.stopActivityIndicator()
                    
                }
                Singletone.shareInstance.stopActivityIndicator()
            }
        } else{
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
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
//                    self.biometricsOnboarding()
                    self.getTheUserSubscriptionFeatures(toMFA: false)
                }
            }
        } else {
            UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//            self.biometricsOnboarding()
            self.getTheUserSubscriptionFeatures(toMFA: false)
        }
    }
    
    private func openSubscriptionScreens() {
        
        let subscriptionData = GetSubscriptionData()
        
        subscriptionData.getUserSubscriptionData { (isActive, subscriptionData) in
            if let _subscriptionData = subscriptionData {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(_subscriptionData) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: "subscriptionData")
                }
            }
            
            if subscriptionData?.SubscriptionPlan == 5 {
                ZorroTempData.sharedInstance.setUserSubscribedOrNot(subscribed: false)
            } else {
                ZorroTempData.sharedInstance.setUserSubscribedOrNot(subscribed: true)
            }
            
            if ZorroTempData.sharedInstance.getUserSubscribedOrNot() {
                self.biometricsOnboarding()
            } else {
                let appdelegate = UIApplication.shared.delegate
                let storyboad = UIStoryboard.init(name: "Subscription", bundle: nil)
                let viewcontroller = storyboad.instantiateViewController(withIdentifier: "SubscriptionNC")
                DispatchQueue.main.async {
                    appdelegate?.window!?.rootViewController = viewcontroller
                }
            }
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
    
    private func showPasswordChangeAlert(message: String, skipOrCancel: String, completion: @escaping (Bool)->()) {
        
        AlertProvider.init(vc: self).showAlertWithActions(title: "Alert", message: message, actions: [AlertAction(title: skipOrCancel), AlertAction(title: "Confirm")]) { (action) in
            if action.title == "Confirm" {
                
                let str: String  = (UserDefaults.standard.string(forKey: "UserEmailAdd")?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B"))!
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
}

//MARK: - Add device Token
extension FallbackOtpLoginController {
    private func addDeviceToken() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        let deviceId: String = UserDefaults.standard.string(forKey: "deviceId") ?? ""
        
        let param = [ "DeviceId": deviceId,
                      "DeveiceType": 0 ] as [String : Any]
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "")
        
        Alamofire.request(URL(string: Singletone.shareInstance.apiNotification + "api/v1/Notification/AddUserDevice")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                if response != nil {
                    let jsonObj: JSON = JSON(response.result.value)
                        print(jsonObj["StatusCode"])
                        if jsonObj["StatusCode"] == 1000
                        {
                            Singletone.shareInstance.stopActivityIndicator()
                        }
                    
                }
        }
    }
}

//MARK: - Bimetrics Onboarding
extension FallbackOtpLoginController {
    private func biometricsOnboarding() {
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "")
        
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

extension FallbackOtpLoginController {
    fileprivate func updateSignatures(completion: @escaping(Bool) -> ()) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connection!", strMsg: "Your connection appears to be offline, please try again!")
            completion(false)
            return
        }
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "")
        
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (userprofiledata, err) in
            if err {
                Singletone.shareInstance.stopActivityIndicator()
                self.alertSample(strTitle: "Something Went Wrong ", strMsg: "Unable to get user details, please try again")
                completion(false)
                return
            }
            
            Singletone.shareInstance.stopActivityIndicator()
            
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
            
            ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
            completion(true)
        }
    }
}

//MARK: - Go back to account lock
extension FallbackOtpLoginController {
    private func gotoaccountLockView() {
        
        let accountlockController = AccountLockController()
        accountlockController.isfromOtp = true
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
}
