//
//  FallbackQuestionLoginController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FallbackQuestionLoginController: FallbackBaseController {
    
    private var zorrosignLogo: UIImageView!
    private var fallbackTitle: UILabel!
    private var fallbackDescription: UILabel!
    private var question1textField: UITextField!
    private var question2textField: UITextField!
    private var question3textField: UITextField!
    private var question1Label: UILabel!
    private var question2Label: UILabel!
    private var question3Label: UILabel!
    private var verifyButton: UIButton!
    
    var question1: String = ""
    var question2: String = ""
    var question3: String = ""
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var param: [String: Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setzorrosignLogo()
        setHeaderContent()
        setTextFieldView()
        setverifyButtonUi()
    }
}

//MARK: Setup Zorrosign Logo
extension FallbackQuestionLoginController {
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

//MARK: - Set header content
extension FallbackQuestionLoginController {
    private func setHeaderContent() {
        
        fallbackTitle = UILabel()
        fallbackTitle.translatesAutoresizingMaskIntoConstraints = false
        fallbackTitle.text = "Reset Biometric Verification"
        fallbackTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        fallbackTitle.textColor = ColorTheme.lblBodySpecial2
        fallbackTitle.numberOfLines = 1
        self.view.addSubview(fallbackTitle)
        
        let fallbacktitleConstraints = [fallbackTitle.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor),
                                        fallbackTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)]
        NSLayoutConstraint.activate(fallbacktitleConstraints)
        
        fallbackDescription = UILabel()
        fallbackDescription.translatesAutoresizingMaskIntoConstraints = false
        fallbackDescription.font = UIFont(name: "Helvetica", size: 17)
        fallbackDescription.textAlignment = .left
        fallbackDescription.textColor = ColorTheme.lblBodySpecial2
        fallbackDescription.adjustsFontSizeToFitWidth = true
        fallbackDescription.minimumScaleFactor = 0.2
        fallbackDescription.numberOfLines = 2
        fallbackDescription.text = "Please answer the following security questions."
        
        self.view.addSubview(fallbackDescription)
        
        let fallbackdescriptionlabelConstraints = [fallbackDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                                   fallbackDescription.topAnchor.constraint(equalTo: fallbackTitle.bottomAnchor,constant: 10)]
        
        NSLayoutConstraint.activate(fallbackdescriptionlabelConstraints)
    }
}

//MARK:- Set textfield view
extension FallbackQuestionLoginController {
    private func setTextFieldView() {
        
        question1Label = UILabel()
        question1Label.translatesAutoresizingMaskIntoConstraints = false
        question1Label.font = UIFont(name: "Helvetica", size: 16)
        question1Label.numberOfLines = 2
        question1Label.text = self.question1
        question1Label.adjustsFontSizeToFitWidth = true
        question1Label.minimumScaleFactor = 0.2
        question1Label.textColor = ColorTheme.lblBodySpecial2
        self.view.addSubview(question1Label)
        
        let question1lableConstraint = [question1Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question1Label.topAnchor.constraint(equalTo: fallbackDescription.bottomAnchor, constant: 30),
                                        question1Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question1lableConstraint)
        
        question1textField = UITextField()
        question1textField.translatesAutoresizingMaskIntoConstraints = false
        question1textField.delegate = self
        question1textField.text = self.answer1
        question1textField.borderStyle = .roundedRect
        question1textField.placeholder = "Enter answer here"
        question1textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question1textField)
        
        let question1textfieldConstraints = [question1textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question1textField.topAnchor.constraint(equalTo: question1Label.bottomAnchor, constant: 5),
                                             question1textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question1textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question1textfieldConstraints)
        question1textField.addTarget(self, action: #selector(textfield1DidChange(_:)), for: .editingChanged)
        
        question1textField.layer.shadowRadius = 1.5
        question1textField.layer.shadowColor   = UIColor.lightGray.cgColor
        question1textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question1textField.layer.shadowOpacity = 0.9
        question1textField.layer.masksToBounds = false
        question1textField.layer.cornerRadius = 8
        
        question2Label = UILabel()
        question2Label.translatesAutoresizingMaskIntoConstraints = false
        question2Label.font = UIFont(name: "Helvetica", size: 16)
        question2Label.numberOfLines = 2
        question2Label.text = self.question2
        question2Label.adjustsFontSizeToFitWidth = true
        question2Label.minimumScaleFactor = 0.2
        question2Label.textColor = ColorTheme.lblBodySpecial2
        self.view.addSubview(question2Label)
        
        let question2lableConstraint = [question2Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question2Label.topAnchor.constraint(equalTo: question1textField.bottomAnchor, constant: 12),
                                        question2Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question2lableConstraint)
        
        question2textField = UITextField()
        question2textField.translatesAutoresizingMaskIntoConstraints = false
        question2textField.delegate = self
        question2textField.text = self.answer2
        question2textField.borderStyle = .roundedRect
        question2textField.placeholder = "Enter answer here"
        question2textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question2textField)
        
        let question2textfieldConstraints = [question2textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question2textField.topAnchor.constraint(equalTo: question2Label.bottomAnchor, constant: 5),
                                             question2textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question2textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question2textfieldConstraints)
        question2textField.addTarget(self, action: #selector(textfield2DidChange(_:)), for: .editingChanged)
        
        question2textField.layer.shadowRadius = 1.5
        question2textField.layer.shadowColor   = ColorTheme.lblBodySpecial2.cgColor
        question2textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question2textField.layer.shadowOpacity = 0.9
        question2textField.layer.masksToBounds = false
        question2textField.layer.cornerRadius = 8
        
        question3Label = UILabel()
        question3Label.translatesAutoresizingMaskIntoConstraints = false
        question3Label.font = UIFont(name: "Helvetica", size: 16)
        question3Label.numberOfLines = 2
        question3Label.text = self.question3
        question3Label.adjustsFontSizeToFitWidth = true
        question3Label.minimumScaleFactor = 0.2
        question3Label.textColor = ColorTheme.lblBodySpecial2
        self.view.addSubview(question3Label)
        
        let question3lableConstraint = [question3Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question3Label.topAnchor.constraint(equalTo: question2textField.bottomAnchor, constant: 12),
                                        question3Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question3lableConstraint)
        
        question3textField = UITextField()
        question3textField.translatesAutoresizingMaskIntoConstraints = false
        question3textField.delegate = self
        question3textField.text = self.answer3
        question3textField.borderStyle = .roundedRect
        question3textField.placeholder = "Enter answer here"
        question3textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question3textField)
        
        let question3textfieldConstraints = [question3textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question3textField.topAnchor.constraint(equalTo: question3Label.bottomAnchor, constant: 5),
                                             question3textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question3textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question3textfieldConstraints)
        question3textField.addTarget(self, action: #selector(textfield3DidChange(_:)), for: .editingChanged)
        
        question3textField.layer.shadowRadius = 1.5
        question3textField.layer.shadowColor   = ColorTheme.lblBodySpecial2.cgColor
        question3textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question3textField.layer.shadowOpacity = 0.9
        question3textField.layer.masksToBounds = false
        question3textField.layer.cornerRadius = 8
        
    }
}

//MARK: Set verify button Ui
extension FallbackQuestionLoginController {
    private func setverifyButtonUi() {
        
        let safearea = view.safeAreaLayoutGuide
        
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
                                              verifyButton.bottomAnchor.constraint(equalTo: safearea.bottomAnchor,constant: -5),
                                              verifyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                              verifyButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
        verifyButton.setShadow()
        verifyButton.addTarget(self, action: #selector(verifyQuestions(_:)), for: .touchUpInside)
    }
}

//MARK: Check for text change field 1
extension FallbackQuestionLoginController {
    @objc fileprivate func textfield1DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question1Label.textColor = ColorTheme.lblError) : (question1Label.textColor = ColorTheme.lblBodySpecial2)
        self.answer1 = text
    }
}

//MARK: Check for text change field 2
extension FallbackQuestionLoginController {
    @objc fileprivate func textfield2DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question2Label.textColor = ColorTheme.lblError) : (question2Label.textColor = ColorTheme.lblBodySpecial2)
        self.answer2 = text
    }
}

//MARK: Check for text change field 3
extension FallbackQuestionLoginController {
    @objc fileprivate func textfield3DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question3Label.textColor = ColorTheme.lblError) : (question3Label.textColor = ColorTheme.lblBodySpecial2)
        self.answer3 = text
    }
}

//MARK: - UITextField Delegates to prevent special characters
extension FallbackQuestionLoginController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterset = NSCharacterSet(charactersIn: ZorroTempStrings.NOT_ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: characterset).joined(separator: "")
        
        if string.isEmpty {
            return true
        }
        return string != filtered
    }
}

//MARK: - Verify questions action
extension FallbackQuestionLoginController {
    @objc
    private func verifyQuestions(_ sender: UIButton) {
        if answer1 != "" && answer2 != "" && answer3 != "" {
            let fallbackAnswer1 = [
                "Answer": self.answer1,
                "Email": "",
                "Question": self.question1,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            let fallbackAnswer2 = [
                "Answer": self.answer2,
                "Email": "",
                "Question": self.question2,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            let fallbackAnswer3 = [
                "Answer": self.answer3,
                "Email": "",
                "Question": self.question3,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            var fallbackArray:[Any] = []
            fallbackArray.append(fallbackAnswer1)
            fallbackArray.append(fallbackAnswer2)
            fallbackArray.append(fallbackAnswer3)
            
            let fallbackparams = ["UserName" : self.param["UserName"] as Any,
                                  "Password" : self.param["Password"] as Any,
                                  "ClientId": Singletone.shareInstance.clientId,
                                  "ClientSecret": Singletone.shareInstance.clientSecret,
                                  "DoNotSendActivationMail": true,
                                  "FallbackAnswers": fallbackArray
                ] as [String : Any]
            
            print("Chathura question response ", fallbackparams)
            
            if Connectivity.isConnectedToInternet() == true
            {
                Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "Please wait while you are logged in.")
                
                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/Login")!, method: .post, parameters: fallbackparams, encoding: JSONEncoding.default, headers: Singletone.shareInstance.headerAPI).responseJSON { response in
                    if response != nil {
                        let jsonObj: JSON = JSON(response.result.value)
                            if jsonObj["StatusCode"] == 1000 {
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
                                        
//                                        let passwordExpiryWarning = jsonObj["Data"]["PasswordExpiryWarning"].boolValue
//
//                                        if passwordExpiryWarning {
//                                            let passwordExpiryDate = jsonObj["Data"]["PasswordExpiryDate"].stringValue
//
//                                            let pendingDays = self.getDate(dateString: passwordExpiryDate) - Date()
//
//                                            if let _pendingDays = pendingDays.day {
//                                                if _pendingDays >= 0 {
//                                                    if _pendingDays == 0 {
//                                                        self.showPasswordChangeAlert(message: "Your password expires today. Select here to change your password.")
//                                                    } else {
//                                                        self.showPasswordChangeAlert(message: "Your password will expire in \(_pendingDays) days. Select here to change your password")
//                                                    }
//                                                }
//                                            }
//                                        }
//                                        else {
//                                            let isOrgForceMFAEnabled = jsonObj["Data"]["IsOrganizationMFAEnabledForUsers"].boolValue
//
//                                            let isMFAEnabled = jsonObj["Data"]["IsMFAForcedToEnable"].boolValue
//
//                                            // Navigate to MFA Screen
//                                            if isOrgForceMFAEnabled {
//                                                UserDefaults.standard.set("YES", forKey: "FromForceMFA")
//
//                                                let multifactorSettingsResponse = MultifactorSettingsResponse()
//
//                                                multifactorSettingsResponse.getuserMultifactorSettings { (data) in
//
//                                                    if data?.TwoFAType == 0 {
//                                                        let appdelegate = UIApplication.shared.delegate
//                                                        let multifactorsettingsController = MultifactorSettingsViewController()
//                                                        let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
//
//                                                        DispatchQueue.main.async {
//                                                            appdelegate?.window!?.rootViewController = aObjNavi
//                                                        }
//                                                    } else {
//                                                        self.biometricsOnboarding()
//                                                    }
//                                                }
//                                            } else {
//                                                UserDefaults.standard.set("NO", forKey: "FromForceMFA")
//                                                self.biometricsOnboarding()
//                                            }
//                                        }
                                        return
                                    }
                                })
                                
                                return
                            } else {
                                Singletone.shareInstance.stopActivityIndicator()
                                print("chathura question wrong flow ", jsonObj["StatusCode"], " ", jsonObj["Data"])
                                
                                if jsonObj["StatusCode"] == 5006 {
                                    self.gotoaccountLockView()
                                    return
                                }
                                if jsonObj["StatusCode"] == 5012 {
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
        } else{
            if answer1.isEmpty {
                question1Label.textColor = ColorTheme.lblError
            }
            if answer2.isEmpty {
                question2Label.textColor =  ColorTheme.lblError
            }
            if answer3.isEmpty {
                question3Label.textColor =  ColorTheme.lblError
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
extension FallbackQuestionLoginController {
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
extension FallbackQuestionLoginController {
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

extension FallbackQuestionLoginController {
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
extension FallbackQuestionLoginController {
    private func gotoaccountLockView() {
        
        let accountlockController = AccountLockController()
        accountlockController.isfromOtp = false
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



