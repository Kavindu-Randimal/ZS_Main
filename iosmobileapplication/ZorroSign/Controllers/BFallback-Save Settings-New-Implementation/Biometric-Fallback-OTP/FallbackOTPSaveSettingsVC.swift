//
//  FallbackOTPSaveSettingsVC.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 7/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SwiftyJSON

class FallbackOTPSaveSettingsVC: FallbackSaveSettingsBaseVC {
    
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
    var param: BiometricSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setzorrosignLogo()
        setotpView()
        setverifyButtonUi()
    }
}

//MARK: Setup Zorrosign Logo
extension FallbackOTPSaveSettingsVC {
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
extension FallbackOTPSaveSettingsVC {
    private func setotpView() {
        
        fallbackTitle = UILabel()
        fallbackTitle.translatesAutoresizingMaskIntoConstraints = false
        fallbackTitle.text = "Reset Biometric Verification"
        fallbackTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        fallbackTitle.textColor = ColorTheme.lblBodySpecial2
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
        fallbackDescription.textColor = ColorTheme.lblBodyDefault
        fallbackDescription.adjustsFontSizeToFitWidth = true
        fallbackDescription.minimumScaleFactor = 0.2
        fallbackDescription.numberOfLines = 2
        
        let _attributedText = fallbackDescription.attributedText(withString: "We have sent you a 4-digit verification code to the following " + self.otpreceiverEmail, boldString: [""], font: UIFont(name: "Helvetica", size: 17)!, underline: false)
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
        errorMessageLabel.textColor = .darkGray
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
        didntreceiveLabel.textColor = .darkGray
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
        resendOtpLabel.textColor = ColorTheme.lblBody
        self.view.addSubview(resendOtpLabel)
        
        let typecodetapGesture = UITapGestureRecognizer(target: self, action: #selector(resendandchangeAction(_:)))
        resendOtpLabel.addGestureRecognizer(typecodetapGesture)
        
        let resendOtpConstraints = [resendOtpLabel.leftAnchor.constraint(equalTo: didntreceiveLabel.rightAnchor),
                                    resendOtpLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(resendOtpConstraints)
    }
}

//MARK: Set verify button Ui
extension FallbackOTPSaveSettingsVC {
    private func setverifyButtonUi() {
        
        //let safearea = view.safeAreaLayoutGuide
        var verifybuttontopAnchor: CGFloat = 80
        if deviceName == .pad {
            verifybuttontopAnchor = 100
        }
        
        verifyButton = UIButton()
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.backgroundColor = ColorTheme.btnBG
        verifyButton.setTitleColor(.white, for: .normal)
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
extension FallbackOTPSaveSettingsVC {
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

extension Request {
    public func debugLogs() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}

//MARK: - Verify the OTP Action
extension FallbackOTPSaveSettingsVC {
    @objc
    private func verifyOTP(_ sender: UIButton) {
        print("Chathura texfield otp value ", self.otpValue);
        
        if let approvalverificationType = self.param.ApprovalVerificationType, let isbiometricEnabled = self.param.IsBiometricEnabled, let loginverificationType = self.param.LoginVerificationType, let twofaType = self.param.TwoFAType {
            
            let fallbackoption = [
                "Answer":"",
                "Email": self.otpreceiverEmail,
                "Question": "",
                "Type":1,
                "OTP": self.otpValue
                ] as [String : Any]
            
            var fallbackArray:[Any] = []
            fallbackArray.append(fallbackoption)
            
            let fallbackparams: [String: Any] = [
                "ApprovalVerificationType": approvalverificationType,
                "BiometricFallbackAnswers": fallbackArray,
                "IsBiometricEnabled": isbiometricEnabled,
                "LoginVerificationType": loginverificationType,
                "TwoFAType": twofaType
            ]
            
            print("Chathura fallback otp request ", fallbackparams)
            
            if Connectivity.isConnectedToInternet() == true
            {
                Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "")
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "ServiceToken")!,
                    "Accept": "application/json"
                ]
                
                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "TwoFA/SaveTwoFASettings")!, method: .post, parameters: fallbackparams, encoding: JSONEncoding.default, headers: headers).debugLogs().responseJSON { response in
                    if response != nil {
                        let jsonObj: JSON = JSON(response.result.value) 
                            
                            print("Chathura fallback response for otp ", jsonObj["StatusCode"], " ", jsonObj["Data"])
                            
                            if jsonObj["StatusCode"] == 1000 {
                                print("Chathura fallback success response ", jsonObj["Data"])
                                
                                Singletone.shareInstance.stopActivityIndicator()
                                self.dismiss(animated: true, completion: nil)
                                
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
                            }
                            Singletone.shareInstance.stopActivityIndicator()
                        
                    }
                    Singletone.shareInstance.stopActivityIndicator()
                }
            } else{
                alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
        } else {
            alertSample(strTitle: "", strMsg: "Something went wrong")
            return
        }
    }
}

//MARK: - Go back to account lock
extension FallbackOTPSaveSettingsVC {
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
