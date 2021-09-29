//
//  LoginVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit
import Alamofire

class LoginVC: Loader {
    
    // MARK: - Variables
    
    let vm = LoginVM()
    let bag = DisposeBag()
    var isEnabledShowPassword = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewPassword: UIView!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var btnShowHidePassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var viewBanner: UIView!
    @IBOutlet weak var btnGet: UIButton!
    
    @IBOutlet weak var viewsample: UIView!
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addObservers()
        
        SKOverlay.AppClipConfiguration(position: .bottom)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - SetupUI
    
    func setupUI() {
        textFieldPassword.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        btnShowHidePassword.contentMode = .center
        
        btnLogin.layer.cornerRadius = 10
        viewEmail.layer.cornerRadius = 10
        viewPassword.layer.cornerRadius = 10
        btnGet.layer.cornerRadius = btnGet.frame.height / 2
        viewBanner.layer.cornerRadius = 15
        
        viewEmail.addShadowAllSide()
        viewPassword.addShadowAllSide()
        viewBanner.addShadowAllSide(radius: 5)
    }
    
    // MARK: - Observers
    
    func addObservers() {
        
        textFieldEmail.rx.text
            .orEmpty
            .bind(to: vm.email)
            .disposed(by: bag)

        textFieldPassword.rx.text
            .orEmpty
            .bind(to: vm.password)
            .disposed(by: bag)
        
        btnLogin.rx.tap
            .subscribe() { [unowned self] event in
                self.loginRequest()
            }.disposed(by: bag)
        
        btnShowHidePassword.rx.tap
            .subscribe() { [unowned self] event in
                self.pressedShowAndHidePassword()
            }.disposed(by: bag)
        
        btnGet.rx.tap
            .subscribe() { event in
                if let url = URL(string: "itms-apps://apple.com/app/id1445151801") {
                    UIApplication.shared.open(url)
                }
            }.disposed(by: bag)
    }
    
    func pressedShowAndHidePassword() {
        if isEnabledShowPassword {
            btnShowHidePassword.setImage(#imageLiteral(resourceName: "ic_view_pass"), for: .normal)
            textFieldPassword.isSecureTextEntry = true
            isEnabledShowPassword = false
            
        } else {
            btnShowHidePassword.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
            textFieldPassword.isSecureTextEntry = false
            isEnabledShowPassword = true
        }
    }
    
    // MARK: - Login Request
    
    func loginRequest() {
        view.endEditing(true)
        
        vm.validateAndLogin { (success, message) in
            if success {
                self.showActivityIndicatory(uiView: self.view)
                self.vm.netReqLogin { (success, statusCode, message) in
                    self.stopActivityIndicator()
                    
                    if success {
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "DocumentVCAudit")
                        self.navigationController?.pushViewController(viewcontroller, animated: true)
                    } else {
                        switch statusCode {
                        case 3599:
                            self.alertSample(strTitle: "Activate your account!", strMsg: message)
                        case 4214:
                            self.checkForOTP()
                        case 4009:
                            self.alertSample(strTitle: "Unable to login!", strMsg: message)
                        case 1250:
                            // Fallback Options
                            break
                        case 5006:
                            self.gotoAccountLockView()
                        default:
                            self.alertSample(strTitle: "Login Failed", strMsg: message)
                        }
                    }
                }
            } else {
                self.alertSample(strTitle: "Alert", strMsg: message)
            }
        }
    }
    
    // MARK: - Check For OTP
    
    private func checkForOTP() {
        
        let otplogincontroller = OTPLoginController()
        otplogincontroller.username = vm.email.value
        otplogincontroller.modalPresentationStyle = .fullScreen
        otplogincontroller.otploginCallBack = { (_logindata, statusCode) in
            if _logindata == nil {
                if statusCode == 9201 {
//                    self.showPasswordChangeAlert(message: "Your password has expired. Please reset your password to continue")
                    return
                }
                
                if statusCode == 9202 {
//                    self.showPasswordChangeAlert(message: "Due to account inactivity your password must be reset to continue")
                    return
                }
            } else {
//                self.tempData(logindata: _logindata!)
            }
            return
        }
//        otplogincontroller.otploginCallBack = { (_logindata) in
////            self.tempData(logindata: _logindata!)
//            UserDefaults.standard.set(_logindata?.ServiceToken, forKey: "ServiceToken")
//            return
//        }
        
        present(otplogincontroller, animated: true, completion: nil)
        return
    }
    
    // MARK: - Goto AccountLockView
    
    private func gotoAccountLockView() {
        
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
        
        present(accountlockController, animated: false, completion: nil)
    }
    
//    private func showPasswordChangeAlert(message: String) {
//        AlertProvider.init(vc: self).showAlertWithActions(title: "Alert", message: message, actions: [AlertAction(title: "Cancel"), AlertAction(title: "Confirm")]) { (action) in
//            if action.title == "Confirm" {
//                let str: String  = (self.email.trim().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B"))!
//
//                    //email.data(using: .utf8)//email.addingPercentEncoding(withAllowedCharacters: .)!
//
//                print(str)
//                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/ResetPassword?userName=\(str)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Singletone.shareInstance.headerAPIForgot)
//                    .responseJSON { response in
//
//                        let jsonObj: JSON = JSON(response.result.value!)
//                        print(jsonObj)
//                        if jsonObj["StatusCode"] == 3549
//                        {
//                            Singletone.shareInstance.stopActivityIndicator()
//
//                            AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: "You have successfully made a request to reset the password. To complete the request, please check your Email.", action: AlertAction(title: "Dismiss")) { (action) in
//
//                            }
//                        }
//                        else
//                        {
//                            Singletone.shareInstance.stopActivityIndicator()
//                            AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: jsonObj["Message"].stringValue, action: AlertAction(title: "Dismiss")) { (action) in
//
//                            }
//
//                            /*{
//                             Data = 0;
//                             Message = "User already exists in the system.";
//                             StatusCode = 3510;
//                             }*/
//                        }
//                }
//            } else {
//
//            }
//        }
//    }
//
//    fileprivate func getDate(dateString: String) -> Date {
//        let dateformatter = DateFormatter()
//        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
//        dateformatter.locale = Locale(identifier: "en_US_POSIX")
//        var date = dateformatter.date(from: dateString)
//
//        if date == nil {
//            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
//            dateformatter.locale = Locale(identifier: "en_US_POSIX")
//            date = dateformatter.date(from: dateString)
//        }
//
//        if date == nil {
//            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//            dateformatter.locale = Locale(identifier: "en_US_POSIX")
//            date = dateformatter.date(from: dateString)
//        }
//
//        return date!
//    }
}
