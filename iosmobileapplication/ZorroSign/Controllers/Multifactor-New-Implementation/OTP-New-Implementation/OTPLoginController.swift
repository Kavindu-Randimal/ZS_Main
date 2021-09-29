//
//  OTPLoginController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/14/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OTPLoginController: OTPBaseController {
    
    var username: String!
    
    private var zorrosignLogo: UIImageView!
    private var otpHeader: UILabel!
    private var otpTimerView: OTPTimerView!
    private var otpresendLabel: UILabel!
    private var resendcodeButton: UIButton!
    private var verifyandproceedButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var _otpValue: Int?
    
    var otploginCallBack: ((UserLoginData?, Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        setzorrosignLogo()
        setotpHeaderLabel()
        setverifyandproceedButton()
        setotptimerView()
        setResend()
        
    }
}

//MARK: Setup Zorrosign Logo
extension OTPLoginController {
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
                                        zorrosignLogo.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 0),
                                        zorrosignLogo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -20),
                                        zorrosignLogo.heightAnchor.constraint(equalToConstant: logoHeight)]
        NSLayoutConstraint.activate(zorrosignlogoConstraints)
    }
}

//MARK: Setup OTP Header
extension OTPLoginController {
    private func setotpHeaderLabel() {
        otpHeader = UILabel()
        otpHeader.translatesAutoresizingMaskIntoConstraints = false
        otpHeader.textAlignment = .center
        otpHeader.font = UIFont(name: "Helvetica", size: 22)
        otpHeader.adjustsFontSizeToFitWidth = true
        otpHeader.minimumScaleFactor = 0.2
        otpHeader.text = "One Time Password Verification (OTP)"
        
        self.view.addSubview(otpHeader)
        
        let otpheaderConstraints = [otpHeader.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
                                    otpHeader.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor, constant: 50),
                                    otpHeader.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(otpheaderConstraints)
        
    }
}

//MARK: Set Verification & Proceed button
extension OTPLoginController {
    private func setverifyandproceedButton() {
        
        let safearea = self.view.safeAreaLayoutGuide
        
        verifyandproceedButton = UIButton()
        verifyandproceedButton.translatesAutoresizingMaskIntoConstraints = false
        verifyandproceedButton.backgroundColor = greencolor
        verifyandproceedButton.setTitleColor(.white, for: .normal)
        verifyandproceedButton.setTitle("VERIFY & PROCEED", for: .normal)
        verifyandproceedButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        verifyandproceedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        verifyandproceedButton.titleLabel?.minimumScaleFactor = 0.2
        verifyandproceedButton.isEnabled = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        activityIndicator.color = ColorTheme.activityindicatorSpecial
        verifyandproceedButton.addSubview(activityIndicator)
        
        self.view.addSubview(verifyandproceedButton)
        
        let verifyandproceedButtonConstraints = [verifyandproceedButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
                                                 verifyandproceedButton.bottomAnchor.constraint(equalTo: safearea.bottomAnchor, constant: -10),
                                                 verifyandproceedButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
                                                 verifyandproceedButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(verifyandproceedButtonConstraints)
        
        verifyandproceedButton.layer.shadowRadius = 1.0
        verifyandproceedButton.layer.shadowColor  = UIColor.lightGray.cgColor
        verifyandproceedButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        verifyandproceedButton.layer.shadowOpacity = 0.5
        verifyandproceedButton.layer.masksToBounds = false
        verifyandproceedButton.layer.cornerRadius = 5
        
        verifyandproceedButton.addTarget(self, action: #selector(verifyandproceedAction(_:)), for: .touchUpInside)
    }
}

//MARK: Set OTP Timer View
extension OTPLoginController {
    private func setotptimerView() {
        otpTimerView = OTPTimerView()
        otpTimerView.otpcallBack = { [weak self] (_otp, _expires) in
            if _expires {
                self?.otpTimerView.updatetimerUIForError(message: "Time exceeded. Please resend.")
                return
            }
            
            self?._otpValue = _otp
            return
        }
        otpTimerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(otpTimerView)
        
        let otptimerviewConstraints = [otpTimerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
                                       otpTimerView.topAnchor.constraint(equalTo: otpHeader.bottomAnchor, constant: 10),
                                       otpTimerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
                                       otpTimerView.heightAnchor.constraint(equalToConstant: 200)]
        
        NSLayoutConstraint.activate(otptimerviewConstraints)
    }
}

//MARK: Setup Resend
extension OTPLoginController {
    private func setResend() {
        otpresendLabel = UILabel()
        otpresendLabel.translatesAutoresizingMaskIntoConstraints = false
        otpresendLabel.textAlignment = .left
        otpresendLabel.font = UIFont(name: "Helvetica", size: 18)
        otpresendLabel.text = "Didn't receive the code?"
        self.view.addSubview(otpresendLabel)
        
        let otpresendlabelConstraints = [otpresendLabel.leftAnchor.constraint(equalTo: otpTimerView.leftAnchor, constant: 10),
                                         otpresendLabel.topAnchor.constraint(equalTo: otpTimerView.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(otpresendlabelConstraints)
        
        resendcodeButton = UIButton()
        resendcodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendcodeButton.setTitleColor(greencolor, for: .normal)
        resendcodeButton.setTitle("Resend Code", for: .normal)
        resendcodeButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        resendcodeButton.titleLabel?.textAlignment = .left
        resendcodeButton.contentHorizontalAlignment = .left
        self.view.addSubview(resendcodeButton)
        
        let resendcodebuttonConstaints = [resendcodeButton.leftAnchor.constraint(equalTo: otpresendLabel.rightAnchor, constant: 5),
                                          resendcodeButton.topAnchor.constraint(equalTo: otpresendLabel.topAnchor),
                                          resendcodeButton.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                          resendcodeButton.bottomAnchor.constraint(equalTo: otpresendLabel.bottomAnchor)]
        NSLayoutConstraint.activate(resendcodebuttonConstaints)
        
        resendcodeButton.addTarget(self, action: #selector(resendOTPCode(_:)), for: .touchUpInside)
    }
}

//MARK: Verify and proceed Action
extension OTPLoginController {
    @objc private func verifyandproceedAction(_ sender: UIButton) {
        activityIndicator.startAnimating()
        guard let otp = _otpValue else {
            activityIndicator.stopAnimating()
            self.otpTimerView.updatetimerUIForError(message: "Please enter valid One Time Password (OTP)")
            return
        }
        
        let otplength = String(otp).count
        if otplength < 4 {
            activityIndicator.stopAnimating()
            self.otpTimerView.updatetimerUIForError(message: "Please enter valid One Time Password (OTP)")
            return
        }
                
        let otpverifyLogin = OTPVerifyLogin(Username: username, Otp: otp, ClientId: Singletone.shareInstance.clientId, ClientSecret: Singletone.shareInstance.clientSecret)
        
        otpverifyLogin.verifyuserloginwithOTP(otpverifylogin: otpverifyLogin) { (logindata, statusCode) in
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            if logindata != nil {
                self.otploginCallBack!(logindata, statusCode ?? 1000)
                self.dismiss(animated: true, completion: nil)
                return
            }
            if let _statusCode = statusCode {
                if _statusCode == 9201 || _statusCode == 9202 {
                    self.otploginCallBack!(logindata, _statusCode)
                    self.dismiss(animated: true, completion: nil)
                    return
                }
            }
            self.otpTimerView.updatetimerUIForError(message: "The code you entered is incorrect, please try again")
            return
        }
        
    }
}

//MARK: Resend OTP
extension OTPLoginController {
    @objc private func resendOTPCode(_ sender: UIButton) {
        
        self.view.isUserInteractionEnabled = false
        
        var _resendLoginOTP = OTPResendLogin()
        _resendLoginOTP.UserId = username
        _resendLoginOTP.OtpType = 1

        _resendLoginOTP.resendUserOTPLogin(otpresendlogin: _resendLoginOTP) { (success) in
            self.view.isUserInteractionEnabled = true
            if success {
                self.otpTimerView.cleartextBoxes()
                self.otpTimerView.updatetimerUIForInfo(message: "One Time Password (OTP) resent successfully.")
                return
            }
            self.otpTimerView.cleartextBoxes()
            self.otpTimerView.updatetimerUIForError(message: "Unable to resending One Time Password (OTP)")
            return
        }
    }
}

