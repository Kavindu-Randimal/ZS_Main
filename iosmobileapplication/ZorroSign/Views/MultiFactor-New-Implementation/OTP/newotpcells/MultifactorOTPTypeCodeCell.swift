//
//  MultifactorOTPTypeCodeCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 3/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorOTPTypeCodeCell: MultifactorOTPBaseCell {
    
    var otpsentcodeView: UIView!
    var otpsenttimerView: OTPTimerView!
    var otpsentResendLabel: UILabel!
    var otpsentVerifyButton: UIButton!
    
    var otpValue: Int?

    var multifactortypcodecellCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifatypcodeuserIntaraction: ((Bool) ->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var multifactortypcodeSettingsViewModel: MultifactorSettingsViewModel? {
           didSet {
               //MARK: - Bind Data
               
               //MARK: - Update UI
               loginSwitch.isEnabled = false
               approvalSwitch.isEnabled = false
           }
       }
}

extension MultifactorOTPTypeCodeCell {
    
    override func setupSubviewUI() {
        
        otpsentcodeView = UIView()
        otpsentcodeView.translatesAutoresizingMaskIntoConstraints = false
        otpsentcodeView.backgroundColor = .white
        multiotpBaseContainer.addSubview(otpsentcodeView)
        
        var otpsentcodeviewHeight: CGFloat = 280
        if deviceName == .pad {
            otpsentcodeviewHeight = 300
        }
        
        let otpsentcodeViewConstraints = [otpsentcodeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10), otpsentcodeView.topAnchor.constraint(equalTo: otpaHeaderLabel.bottomAnchor, constant: 10),
                                          otpsentcodeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                          otpsentcodeView.heightAnchor.constraint(equalToConstant: otpsentcodeviewHeight)]
        NSLayoutConstraint.activate(otpsentcodeViewConstraints)
        
        otpsenttimerView = OTPTimerView()
        otpsenttimerView.translatesAutoresizingMaskIntoConstraints = false
        otpsentcodeView.addSubview(otpsenttimerView)
        
        var otpsentcodetimerviewHeight: CGFloat = 180
        if deviceName == .pad {
            otpsentcodetimerviewHeight = 200
        }
        
        let otpsenttimerviewConstraints = [otpsenttimerView.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor),
                                           otpsenttimerView.topAnchor.constraint(equalTo: otpsentcodeView.topAnchor),
                                           otpsenttimerView.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor),
                                           otpsenttimerView.heightAnchor.constraint(equalToConstant: otpsentcodetimerviewHeight)]
        
        NSLayoutConstraint.activate(otpsenttimerviewConstraints)
        
        otpsenttimerView.otpcallBack = { [weak self] (otp, istimedout) in
            if istimedout {
                DispatchQueue.main.async {
                    self?.otpsenttimerView.updatetimerUIForError(message: "Time exceeded. Please resend.")
                }
                return
            }
            self?.otpValue = otp
            return
        }
        
        
        otpsentResendLabel = UILabel()
        otpsentResendLabel.translatesAutoresizingMaskIntoConstraints = false
        otpsentResendLabel.adjustsFontSizeToFitWidth = true
        otpsentResendLabel.minimumScaleFactor = 0.2
        otpsentResendLabel.numberOfLines = 0
        otpsentResendLabel.isUserInteractionEnabled = true
        otpsentResendLabel.textColor = ColorTheme.lblBodyDefault
        let _attributedText = otpsentResendLabel.attributedText(withString: "Didn't receive the code? Resend code or Change mobile number", boldString: ["Resend code","Change mobile number"], font: UIFont(name: "Helvetica", size: 18)!, underline: true)
        otpsentResendLabel.attributedText = _attributedText
        otpsentcodeView.addSubview(otpsentResendLabel)
        
        let otpsentResendLabelConstraints = [otpsentResendLabel.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 10),
                                             otpsentResendLabel.topAnchor.constraint(equalTo: otpsenttimerView.bottomAnchor, constant: 10),
                                             otpsentResendLabel.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(otpsentResendLabelConstraints)
        
        let typecodetapGesture = UITapGestureRecognizer(target: self, action: #selector(resendandchangeAction(_:)))
        otpsentResendLabel.addGestureRecognizer(typecodetapGesture)
        
        otpsentVerifyButton = UIButton()
        otpsentVerifyButton.translatesAutoresizingMaskIntoConstraints = false
        otpsentVerifyButton.backgroundColor = ColorTheme.btnBG
        otpsentVerifyButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        otpsentVerifyButton.setTitle("VERIFY", for: .normal)
        otpsentVerifyButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        otpsentVerifyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        otpsentVerifyButton.titleLabel?.minimumScaleFactor = 0.2
        otpsentVerifyButton.titleLabel?.textAlignment = .center
        
        otpsentcodeView.addSubview(otpsentVerifyButton)
        
        let otpsentVerifyButtonConstraints = [otpsentVerifyButton.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 5),
                                              otpsentVerifyButton.topAnchor.constraint(equalTo: otpsentResendLabel.bottomAnchor, constant: 10),
                                              otpsentVerifyButton.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor, constant: -5),
                                              otpsentVerifyButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
        otpsentVerifyButton.setShadow()
        otpsentVerifyButton.addTarget(self, action: #selector(verifyOTP(_:)), for: .touchUpInside)
        
        otpOptionHeaderTopConstraint = otpOptionHeaderLabel.topAnchor.constraint(equalTo: otpsentcodeView.bottomAnchor, constant: 10)
        otpOptionHeaderTopConstraint.isActive = true
        updateotpgapperTopConstraints()
    }
}

//MARK: - Resend and change mobile number
extension MultifactorOTPTypeCodeCell {
    @objc
    private func resendandchangeAction(_ recognizer: UITapGestureRecognizer) {
        
        let _fullText = "Didn't receive the code? Resend code or Change mobile number"
        let _rangeOneText = "Resend code"
        let _rangeTwoText = "Change mobile number"
        
        let _rangeOne = (_fullText as NSString).range(of: _rangeOneText)
        let _rangeTwo = (_fullText as NSString).range(of: _rangeTwoText)
        
        if recognizer.didTapAttributedTextInLabel(label: otpsentResendLabel, inRange: _rangeOne) {
            resendOTP()
            return
        }
        
        if recognizer.didTapAttributedTextInLabel(label: otpsentResendLabel, inRange: _rangeTwo) {
            print("tap on change mobile number")
            multifactortypcodeSettingsViewModel?.subStep = 2
            multifactortypcodecellCallBack!(multifactortypcodeSettingsViewModel, false)
            return
        }
    }
}

//MARK: - Resend OTP
extension MultifactorOTPTypeCodeCell {
    @objc
    private func resendOTP() {
        multifatypcodeuserIntaraction!(false)
        
        guard let mobilenumber = multifactortypcodeSettingsViewModel?.mobilenNumber else {
            multifatypcodeuserIntaraction!(true)
            return
        }
        let onboard = OTPOnBoard(mobileNumber: mobilenumber)
        onboard.onboardusertoOTP(otponboard: onboard) { (onboared) in
            if onboared {
                self.otpsenttimerView.cleartextBoxes()
                self.multifatypcodeuserIntaraction!(true)
            }
            return
        }
    }
}

//MARK: - Verify the OTP Action
extension MultifactorOTPTypeCodeCell {
    @objc
    private func verifyOTP(_ sender: UIButton) {
        
        multifatypcodeuserIntaraction!(false)
        guard let otp = otpValue else {
            multifatypcodeuserIntaraction!(true)
            return
        }
        
        guard let mobilenumber = multifactortypcodeSettingsViewModel?.mobilenNumber else {
            multifatypcodeuserIntaraction!(true)
            return
        }
        
        let userid = ZorroTempData.sharedInstance.getUserEmail()
        
        let otpverify = OTPVerify(userid: userid, otpvalue: otp, mobilenumber: mobilenumber)
        otpverify.verifyuserOTP(otpverify: otpverify) { (verified) in
            if verified {
                self.multifactortypcodeSettingsViewModel?.twoFAType = 1
                self.multifactortypcodeSettingsViewModel?.twoFATypeLocal = 1
                self.multifactortypcodeSettingsViewModel?.subStep = 0
                ZorroTempData.sharedInstance.setOtpNumber(mobilenumber: mobilenumber)
                self.multifactortypcodecellCallBack!(self.multifactortypcodeSettingsViewModel, false)
                return
            }
            
            self.multifatypcodeuserIntaraction!(true)
            self.otpsenttimerView.updatetimerUIForError(message: "Please enter valid One Time Password(OTP)")
            return
        }
    }
}
