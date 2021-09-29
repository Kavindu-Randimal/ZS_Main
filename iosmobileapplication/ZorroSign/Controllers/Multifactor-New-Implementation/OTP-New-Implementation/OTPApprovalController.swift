//
//  OTPApprovalController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/15/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OTPApprovalController: OTPBaseController {
    
    private var containerView: UIView!
    private var otpHeader: UILabel!
    private var topseparatorView: UIView!
    private var otpTimerView: OTPTimerView!
    private var buttonContainer: UIView!
    private var bottomseparatorView: UIView!
    private var cancelButton: UIButton!
    private var verifyproceedButton: UIButton!
    private var otpresendLabel: UILabel!
    private var resendcodeButton: UIButton!
    
    private var otpValue: Int?
    
    var otpverificationCancel: (() -> ())?
    var otpapprovalCallback: ((Int?) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        setcontainerView()
        setotpHeaderLabel()
        settopSeparator()
        setbottomView()
        setotptimerView()
        setapprovalResend()
    }
}

//MARK: Setup Container View
extension OTPApprovalController {
    private func setcontainerView() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        var _contentWidth = deviceWidth - 40
        if deviceName == .pad {
            _contentWidth /= 2
        }
        let _contentHeight: CGFloat = 350
        
        let containerviewConstarints = [containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        containerView.widthAnchor.constraint(equalToConstant: _contentWidth),
                                        containerView.heightAnchor.constraint(equalToConstant: _contentHeight)]
        
        NSLayoutConstraint.activate(containerviewConstarints)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 5
    }
}

//MARK: Set OTP Header
extension OTPApprovalController {
    private func setotpHeaderLabel() {
        otpHeader = UILabel()
        otpHeader.translatesAutoresizingMaskIntoConstraints = false
        otpHeader.textAlignment = .center
        otpHeader.font = UIFont(name: "Helvetica", size: 20)
        otpHeader.adjustsFontSizeToFitWidth = true
        otpHeader.minimumScaleFactor = 0.2
        otpHeader.text = "One Time Password Verification (OTP)"
        containerView.addSubview(otpHeader)
            
        let otpheaderConstraints = [otpHeader.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
                                    otpHeader.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5),
                                    otpHeader.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(otpheaderConstraints)
    }
}

//MARK: Set Separator
extension OTPApprovalController {
    private func settopSeparator() {
        topseparatorView = UIView()
        topseparatorView.translatesAutoresizingMaskIntoConstraints = false
        topseparatorView.backgroundColor = .lightGray
        containerView.addSubview(topseparatorView)
        
        let topseparatorviewCosntraints = [topseparatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                           topseparatorView.topAnchor.constraint(equalTo: otpHeader.bottomAnchor, constant: 10),
                                           topseparatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                           topseparatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(topseparatorviewCosntraints)
    }
}

//MARK: Set bottom View
extension OTPApprovalController {
    private func setbottomView() {
        buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(buttonContainer)
        
        let buttoncontainerviewConstrints = [buttonContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                             buttonContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                             buttonContainer.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                             buttonContainer.heightAnchor.constraint(equalToConstant: 60)]
        
        NSLayoutConstraint.activate(buttoncontainerviewConstrints)
        
        bottomseparatorView = UIView()
        bottomseparatorView.translatesAutoresizingMaskIntoConstraints = false
        bottomseparatorView.backgroundColor = .lightGray
        buttonContainer.addSubview(bottomseparatorView)
        
        let bottomseparatorViewCosntraints = [bottomseparatorView.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor),
                                              bottomseparatorView.topAnchor.constraint(equalTo: buttonContainer.topAnchor, constant: 0),
                                              bottomseparatorView.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor),
                                              bottomseparatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(bottomseparatorViewCosntraints)
        
        
        var _buttonWidth = (deviceWidth - 50)/2 - 10
        
        if deviceName == .pad {
            _buttonWidth = _buttonWidth/2 - 10
        }
        
        var _fontSize: CGFloat = 17.0
        if deviceName == .phone {
            let _fontScale = deviceWidth/414
            _fontSize *= _fontScale
        }
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(greencolor, for: .normal)
        cancelButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1.5, bottom: 0, right: 1.5)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica", size: _fontSize)
        cancelButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cancelButton.titleLabel?.minimumScaleFactor = 0.2
        buttonContainer.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor, constant: 10),
                                       cancelButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       cancelButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.shadowRadius = 1.0
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.shadowColor  = UIColor.lightGray.cgColor
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.masksToBounds = false
        cancelButton.layer.cornerRadius = 5
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
    
        verifyproceedButton = UIButton()
        verifyproceedButton.translatesAutoresizingMaskIntoConstraints = false
        verifyproceedButton.setTitleColor(.white, for: .normal)
        verifyproceedButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 1.5, bottom: 0, right: 1.5)
        verifyproceedButton.setTitle("VERIFY & PROCEED", for: .normal)
        verifyproceedButton.titleLabel?.font = UIFont(name: "Helvetica", size: _fontSize)
        verifyproceedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        verifyproceedButton.titleLabel?.minimumScaleFactor = 0.2
        verifyproceedButton.backgroundColor = greencolor
        
        buttonContainer.addSubview(verifyproceedButton)
        
        let verifyproceedButtonConstraints = [verifyproceedButton.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor, constant: -10),
                                       verifyproceedButton.centerYAnchor.constraint(equalTo: buttonContainer.centerYAnchor),
                                       verifyproceedButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       verifyproceedButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(verifyproceedButtonConstraints)
        
        verifyproceedButton.layer.shadowRadius = 1.0
        verifyproceedButton.layer.shadowColor  = UIColor.lightGray.cgColor
        verifyproceedButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        verifyproceedButton.layer.shadowOpacity = 0.5
        verifyproceedButton.layer.masksToBounds = false
        verifyproceedButton.layer.cornerRadius = 5
        verifyproceedButton.isEnabled = true
        
        verifyproceedButton.addTarget(self, action: #selector(verifyandProcess(_:)), for: .touchUpInside)
    }
}

//MARK: Set OTP Timer View
extension OTPApprovalController {
    private func setotptimerView() {
        
        otpTimerView = OTPTimerView()
        otpTimerView.otpcallBack = { (otp, timedout) in
            self.otpValue = otp
            return
        }
        otpTimerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(otpTimerView)
        
        var _timerviewHeight: CGFloat = 200
        if deviceName == .pad {
            _timerviewHeight = 180
        }
        
        let otptimerviewConstraints = [otpTimerView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                       otpTimerView.topAnchor.constraint(equalTo: topseparatorView.bottomAnchor, constant: 10),
                                       otpTimerView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                       otpTimerView.heightAnchor.constraint(equalToConstant: _timerviewHeight)]
        
        NSLayoutConstraint.activate(otptimerviewConstraints)
        
        let otpnumber = ZorroTempData.sharedInstance.getOtpNumber()
        otpTimerView.updateHeaderText(mobilenumber: otpnumber)
    }
}

//MARK: Set Resend
extension OTPApprovalController {
    private func setapprovalResend() {
        otpresendLabel = UILabel()
        otpresendLabel.translatesAutoresizingMaskIntoConstraints = false
        otpresendLabel.textAlignment = .left
        otpresendLabel.font = UIFont(name: "Helvetica", size: 18)
        otpresendLabel.text = "Didn't receive the code?"
        otpresendLabel.adjustsFontSizeToFitWidth = true
        containerView.addSubview(otpresendLabel)
        
        let otpresendlabelConstraints = [otpresendLabel.leftAnchor.constraint(equalTo: otpTimerView.leftAnchor, constant: 10),
                                         otpresendLabel.topAnchor.constraint(equalTo: otpTimerView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(otpresendlabelConstraints)
        
        resendcodeButton = UIButton()
        resendcodeButton.translatesAutoresizingMaskIntoConstraints = false
        resendcodeButton.setTitleColor(greencolor, for: .normal)
        resendcodeButton.setTitle("Resend Code", for: .normal)
        resendcodeButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        resendcodeButton.titleLabel?.textAlignment = .left
        resendcodeButton.contentHorizontalAlignment = .left
        resendcodeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        resendcodeButton.titleLabel?.minimumScaleFactor = 0.2
        containerView.addSubview(resendcodeButton)
        
        resendcodeButton.addTarget(self, action: #selector(resendCodeAction(_:)), for: .touchUpInside)
        
        let resendcodebuttonConstaints = [resendcodeButton.leftAnchor.constraint(equalTo: otpresendLabel.rightAnchor, constant: 5),
                                          resendcodeButton.topAnchor.constraint(equalTo: otpresendLabel.topAnchor),
                                          resendcodeButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                          resendcodeButton.bottomAnchor.constraint(equalTo: otpresendLabel.bottomAnchor)]
        NSLayoutConstraint.activate(resendcodebuttonConstaints)
    }
}

//MARK: Resend Action
extension OTPApprovalController {
    @objc private func resendCodeAction(_ sender: UIButton) {
        self.view.isUserInteractionEnabled = false
        let _resendOTP = OTPVerify()
        _resendOTP.requestOTP { (success, otpissue) in
            self.view.isUserInteractionEnabled = true
            if success {
                self.otpTimerView.cleartextBoxes()
                self.otpTimerView.updatetimerUIForInfo(message: "One Time Password (OTP) resent successfully.")
                return
            }
            self.otpTimerView.cleartextBoxes()
            self.otpTimerView.updatetimerUIForError(message: "Error resending One Time Password (OTP).")
            return
        }
    }
}

//MARK: Button Actions
extension OTPApprovalController {
    @objc private func cancelAction(_ sender: UIButton) {
        otpverificationCancel!()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func verifyandProcess(_ sender: UIButton) {
        
        guard let _otp = otpValue else {
            self.otpTimerView.updatetimerUIForError(message: "Please enter valid One Time Password (OTP)")
            return
        }
        
        let otplength = String(_otp).count
        if otplength < 4 {
            self.otpTimerView.updatetimerUIForError(message: "Please enter valid One Time Password (OTP)")
            return
        }
        
        self.otpapprovalCallback!(_otp)
        self.dismiss(animated: true, completion: nil)
        return
    }
}
