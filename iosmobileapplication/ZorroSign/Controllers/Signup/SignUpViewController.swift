//
//  SignUpViewController.swift
//  ZorroSign
//
//  Created by Apple on 24/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ReCaptcha
import RxCocoa
import RxSwift
import AVFoundation
import QRCodeReader
import WebKit

class SignUpViewController: BaseVC, ValidatorDelegate {

    @IBOutlet weak var signupScrollView: UIScrollView!
    @IBOutlet weak var sinuplogoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usernameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    
//    @IBOutlet weak var containerviewWidthConstraints: NSLayoutConstraint!
//    @IBOutlet weak var containerviewHeightConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var viewRefCode: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPAssword: UIView!
    @IBOutlet weak var viewConfirmPassword: UIView!
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtReferralCode: UITextField!
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var btnTC: UIButton!
    @IBOutlet weak var btnPP: UIButton!
    @IBOutlet weak var txtTerms: UITextView!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var contactImage: UIImageView!
    @IBOutlet weak var tokenreaderButton: UIButton!
    @IBOutlet weak var contactusButton: UIButton!
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    
    var recaptcha = try? ReCaptcha()
    
    var flag: String = "false"
    private var locale: Locale?
    private var endpoint = ReCaptcha.Endpoint.default
    
    private var disposeBag = DisposeBag()
    
    private struct Constants {
        static let webViewTag = 123
        static let testLabelTag = 321
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyles()
        
        let a = Singletone.shareInstance.userInfo.id
        print(a)
        
        btnLogin.layer.cornerRadius = 3
        btnLogin.clipsToBounds = true
        btnSignUp.layer.cornerRadius = 5
        btnSignUp.clipsToBounds = true
        setUnderLineForBtnLogin()
        
        setBottomText()
    }
    
    func setUnderLineForBtnLogin() {
        let attributedString = NSMutableAttributedString.init(string: btnLogin.titleLabel?.text ?? "LOGIN")
        
        // Add Underline Style Attribute.
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length))
        btnLogin.setAttributedTitle(attributedString, for: .normal)
    }
    
    func setBottomText() {
        
        let attributedString = NSMutableAttributedString(string: "I agree to the ")
        
        let attributedString1 = NSMutableAttributedString(string: "Terms & Conditions")
        attributedString1.addAttribute(.link, value: "https://www.zorrosign.com/terms-and-conditions/", range: NSRange(location: 0, length: 18))
        
        attributedString.append(attributedString1)
        
        let attributedString2 = NSMutableAttributedString(string: " and ")
        
        attributedString.append(attributedString2)
        
        let attributedString3 = NSMutableAttributedString(string: "Privacy Policy")
        attributedString3.addAttribute(.link, value: "https://www.zorrosign.com/privacy-policy", range: NSRange(location: 0, length: 14))
        attributedString.append(attributedString3)
        
        let color = UIColor(named: "BtnTextWithoutBG") ?? UIColor.gray
        txtTerms.linkTextAttributes = [NSAttributedString.Key.foregroundColor: color]
        
        txtTerms.attributedText = attributedString
        txtTerms.textAlignment = NSTextAlignment.left
    }
    
  private func setupReCaptcha() {
        
        // swiftlint:disable:next force_try
        //recaptcha = try! ReCaptcha(locale: locale, endpoint: endpoint)
        recaptcha = try! ReCaptcha()
        validate()
//        recaptcha?.validate(on: self, completion: nil)
        
        recaptcha?.configureWebView { [weak self] (webview: WKWebView) in
            webview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)//self?.view.bounds ?? CGRect.zero
            // CGRect(x: 0, y: 0, width: 200, height: 150)
            webview.tag = Constants.webViewTag
            
            // For testing purposes
            // If the webview requires presentation, this should work as a way of detecting the webview in UI tests
            //self?.view.viewWithTag(Constants.testLabelTag)?.removeFromSuperview()
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
            label.tag = Constants.testLabelTag
            label.accessibilityLabel = "webview"
            self?.view.addSubview(label)
        }
        
    }
    
    func validateCaptcha() {
        
        
        //6LcU92gUAAAAANdlKB31LnFbYuQhlm9JDN_qdysd
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
//        recaptcha?.rx.validate(on: view)
//            .subscribe(onNext: { (token: String) in
//                // Do something
//                //self.view.viewWithTag(Constants.testLabelTag)?.removeFromSuperview()
//
//                self.callValidateCaptchaAPI(token: token)
//                Singletone.shareInstance.stopActivityIndicator()
//            })
        
        recaptcha?.validate(on: view) { [weak self] (result: ReCaptchaResult) in
            self?.callValidateCaptchaAPI(token: try! result.dematerialize())
            Singletone.shareInstance.stopActivityIndicator()
        }
    }
    
    func callValidateCaptchaAPI(token: String) {
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        let encodedtoken = token.utf8EncodedString()
        let apistr = "Account/ValidateCaptcha?encodedResponse=\(encodedtoken)&type=0"
        Alamofire.request(URL(string: Singletone.shareInstance.apiURL + apistr)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Singletone.shareInstance.headerAPI)
            .responseJSON { response in
                
                let jsonObj: JSON = JSON(response.result.value!)
                print(jsonObj)
                
                self.view.viewWithTag(Constants.webViewTag)?.removeFromSuperview()
                
                if jsonObj["StatusCode"] == 1000
                {
                    
                    self.callSignupAPI()
                    
                } else {
                    self.alertSample(strTitle: "", strMsg: "ReCaptcha validation failed, please try again.")
                }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAgreeAction(_ sender: Any) {
        if let button = sender as? UIButton {
            if button.isSelected {
                flag = "false"
                button.isSelected = false
                btnAgree.setImage(UIImage(named:""), for:UIControl.State.normal)
                btnAgree.tintColor = .white
                btnAgree.backgroundColor = .white
            } else {
                let originalimage = UIImage(named: "Check-mark")
                let titntedimage = originalimage?.withRenderingMode(.alwaysTemplate)
                flag = "true"
                button.isSelected = true
                btnAgree.setImage(titntedimage, for:UIControl.State.normal)
                btnAgree.tintColor = .white
                btnAgree.backgroundColor = .darkGray
            }
        }
    }
    

    
    @available(iOS 10.0, *)
    @IBAction func btnTermsAndConditionAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/terms-and-conditions/")! as URL)
    }
    
    @available(iOS 10.0, *)
    @IBAction func btnPrivacyPolicyAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/privacy-policy")! as URL)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        let email: String = (txtEmail.text!).trim()
        let pass: String = (txtPassword.text!).trim()
        let refCode: String = (txtReferralCode.text!).trim()
        
        if txtEmail.text == "" || Singletone.shareInstance.isValidEmail(testStr: "\(email)") == false
        {
            alertSample(strTitle: "", strMsg: "Please enter email")
            return
        }
        if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            return
        }
            
        if pass == ""
        {
            alertSample(strTitle: "", strMsg: "Please enter password")
            return
        }
        if !isValidPassword(password: txtPassword.text!)
        {
            alertSample(strTitle: "", strMsg: "Please enter a valid password")
            return
        }
        
        if Singletone.shareInstance.isValidPassword(testStr: pass) == false
        {
            alertSample(strTitle: "", strMsg: "Please enter valid password")
            return
        }
        if pass != txtConfirmPassword.text
        {
            alertSample(strTitle: "", strMsg: "Passwords do not match")
            return
        }
        if flag != "true"
        {
            alertSample(strTitle: "", strMsg: "Please accept terms and conditions")
            return
        }
        self.callSignupAPI()
//        setupReCaptcha()
//        validateCaptcha()
        
 
        //amit.hoh@gmail.com
        //Baviskar@123
        
        
//        {
//    "StatusCode": 3558,
//    "Message": "You have successfully completed the registration.",
//    "Data": true
//}
        
        
    }
    
    func callSignupAPI() {
        
        if Connectivity.isConnectedToInternet() == true {
            
            
            let email: String = txtEmail.text!
            let pass: String = txtPassword.text!
            
            let refCode: String = txtReferralCode.text!
            let loadtxt = "Please wait while your account is being created."
            
            Singletone.shareInstance.showActivityIndicatory(uiView: view, text:loadtxt)
            
            let param = ["UserName" : email,
                         "Password" : pass,
                         "Source": "ZS",
                         "AgreeToTC": flag,
                         "ReferralCode": refCode
            ]
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/RegisterUser")!, method: .post, parameters: param, encoding: URLEncoding.default, headers: Singletone.shareInstance.headerAPI)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    print(jsonObj)
                    if jsonObj["StatusCode"] == 3558
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        
                        self.resetUserDefaults()
                        
                        let msg = "Sign up Successful! An activation email has been sent. Click on the link in the email to activate your account."
                        //"Registration has been successfully completed. Please check your email for account activation."
                        //let msg = jsonObj["Message"]
                        let alert = UIAlertController(title: "Sign up", message: msg, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            action in
                            self.performSegue(withIdentifier: "segGotoLogin", sender: self)
                        }))
                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if jsonObj["StatusCode"] == 3510
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        let alert = UIAlertController(title: "Sign up", message: jsonObj["Message"].stringValue, preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Forgot password", style: .default, handler: {
                            action in
                            self.performSegue(withIdentifier: "segForgot", sender: self)
                        }))
                        
                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else if jsonObj["StatusCode"] == 3617
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        let alert = UIAlertController(title: "Sign up", message: jsonObj["Message"].stringValue, preferredStyle: .alert)
                        //                        alert.addAction(UIAlertAction(title: "Forgot password", style: .default, handler: {
                        //                            action in
                        //                            self.performSegue(withIdentifier: "segForgot", sender: self)
                        //                        }))
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                        self.present(alert, animated: true, completion: nil)
                    }
                        
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSignupWithFailed(strTitle: "Sign up", strMsg: jsonObj["Message"].stringValue)
                        /*{
                         Data = 0;
                         Message = "User already exists in the system.";
                         StatusCode = 3510;
                         }*/
                    }
            }
        } else {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
    }
    
//    func alertSample(strMsg: String)
//    {
//        let alert = UIAlertController(title: "", message: strMsg, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }

    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "segGotoLogin", sender: self)
    }
    @IBAction func btnLoginActionSegue(_ sender: Any) {
        
        performSegue(withIdentifier: "segGotoLogin", sender: self)
    }
    
    func validate() {
        recaptcha?.validate(on: view) { [weak self] (result: ReCaptchaResult) in
            print(try? result.dematerialize())
        }
    }
    
    func resetUserDefaults() {
        
        UserDefaults.standard.removeObject(forKey: "remindUserName")
        UserDefaults.standard.removeObject(forKey: "remindPassword")
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
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        print("H - \(self.frame.size.height)")
        print("W - \(self.frame.size.width)")
        print("w - \(width)")
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: width, height: 0.5)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

extension SignUpViewController {
    fileprivate func setupStyles() {
        
        btnAgree.layer.borderColor = UIColor.darkGray.cgColor
        btnAgree.layer.cornerRadius = 5
        btnAgree.layer.borderWidth = 1
        btnAgree.imageEdgeInsets = UIEdgeInsets(top: 4,left:  4,bottom:  4,right:  4)
        
        
//        containerviewWidthConstraints.constant = UIScreen.main.bounds.width
//        containerviewHeightConstraints.constant = UIScreen.main.bounds.height
        signupScrollView.isScrollEnabled = false
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.height == 568 {
//                sinuplogoTopConstraint.constant = 40
//                usernameTopConstraint.constant = 20
//                containerviewHeightConstraints.constant = 650
                signupScrollView.isScrollEnabled = true
            }
            
            if UIScreen.main.bounds.height == 667 {
//                sinuplogoTopConstraint.constant = 50
//                usernameTopConstraint.constant = 30
//                containerviewHeightConstraints.constant = UIScreen.main.bounds.height
            }
            
            if UIScreen.main.bounds.height == 736 {
//                sinuplogoTopConstraint.constant = 100
                usernameTopConstraint.constant = 50
//                containerviewHeightConstraints.constant = UIScreen.main.bounds.height
            }
            
            if UIScreen.main.bounds.height == 812  {
//                sinuplogoTopConstraint.constant = 100
                usernameTopConstraint.constant = 50
//                containerviewHeightConstraints.constant = UIScreen.main.bounds.height - 50
            }
            
            if UIScreen.main.bounds.height >= 896 {
//                sinuplogoTopConstraint.constant = 120
                usernameTopConstraint.constant = 60
//                containerviewHeightConstraints.constant = UIScreen.main.bounds.height - 50
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            usernameTopConstraint.constant = 100
            
            let newConstraint = logoWidthConstraint.constraintWithMultiplier(0.45)
            view.removeConstraint(logoWidthConstraint)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            logoWidthConstraint = newConstraint
//            usernameTopConstraint.constant = 100
//            containerviewHeightConstraints.constant = UIScreen.main.bounds.height
        }
        
        viewEmail.layer.shadowRadius  = 1.5
        viewEmail.layer.shadowColor   = UIColor.lightGray.cgColor
        viewEmail.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        viewEmail.layer.shadowOpacity = 0.9
        viewEmail.layer.masksToBounds = false
        viewEmail.layer.cornerRadius = 8
        
        viewPAssword.layer.shadowRadius  = 1.5
        viewPAssword.layer.shadowColor   = UIColor.lightGray.cgColor
        viewPAssword.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        viewPAssword.layer.shadowOpacity = 0.9
        viewPAssword.layer.masksToBounds = false
        viewPAssword.layer.cornerRadius = 8
        
        viewConfirmPassword.layer.shadowRadius  = 1.5;
        viewConfirmPassword.layer.shadowColor   = UIColor.lightGray.cgColor
        viewConfirmPassword.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        viewConfirmPassword.layer.shadowOpacity = 0.9
        viewConfirmPassword.layer.masksToBounds = false
        viewConfirmPassword.layer.cornerRadius = 8
        
        viewRefCode.layer.shadowRadius  = 1.5
        viewRefCode.layer.shadowColor   = UIColor.lightGray.cgColor
        viewRefCode.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        viewRefCode.layer.shadowOpacity = 0.9
        viewRefCode.layer.masksToBounds = false
        viewRefCode.layer.cornerRadius = 8
        
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


extension SignUpViewController: QRCodeReaderViewControllerDelegate {
    
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
        present(readerVC, animated: true, completion: nil)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
    
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        UserDefaults.standard.set(result.value, forKey: "qrcode")
        UserDefaults.standard.set(result.value, forKey: "scannedqrcode")
        ZorroTempData.sharedInstance.set4n6Token(tokenstring: result.value)
        dismiss(animated: true, completion: {
            self.showLoginPopup()
        })
    }
    
    func showLoginPopup() {
        let alert = UIAlertController(title: "Authenticate", message: "Login to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController {
    @objc fileprivate func contactUs(_ sender: UIButton) {
        print("working")
        
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let contactv = sb.instantiateViewController(withIdentifier: "Help_SBID") as! ContactsViewController
        contactv.flagback = true
        contactv.fromlogin = true
        self.present(contactv, animated: true, completion: nil)
    }
}

extension NSMutableAttributedString {
    func setFont(forText stringValue: String, fontsize: CGFloat) {
        let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica-Bold", size: fontsize)!, range: range)
    }
}
