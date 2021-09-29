////
////  MultifactorOTPSettingsCellExtension.swift
////  ZorroSign
////
////  Created by Anuradh Caldera on 2/19/20.
////  Copyright © 2020 Apple. All rights reserved.
////
//
//import Foundation
//import ADCountryPicker
//
//extension MultifactorOTPSettingsCell {
//    func updateOTPCellUI(multifactorsettings: MultifactorSettingsViewModel) {
//        
//        switch multifactorsettings.subStep! {
//        case 0:
//            //MARK: - Already activated users
//            activatedphonenumberLabel.isHidden = false
//            activatedchangemobilenumberButton.isHidden = false
//        
//            activatephonenumberLabel.isHidden = true
//            activesendcodeButton.isHidden = true
//            activeorLabel.isHidden = true
//            activechangemobilenumberButton.isHidden = true
//
//            changemobileNumberView.isHidden = true
//            otpsentcodeView.isHidden = true
//            otpoptinView.isHidden = !multifactorsettings.approvalSwitch
//            saveView.isHidden = false
//            
//            otpactivateHeaderLabel.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 20).isActive = true
//            activateOptionHeaderLabel.topAnchor.constraint(equalTo: activatedphonenumberLabel.bottomAnchor, constant: 15).isActive = true
//            if multifactorsettings.approvalSwitch {
//                saveView.topAnchor.constraint(equalTo: otpoptinView.bottomAnchor, constant: 10).isActive = true
//            } else {
//                saveView.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 20).isActive = true
//            }
//            gapperLabel.topAnchor.constraint(equalTo: saveView.bottomAnchor, constant: 10).isActive = true
//        
//            return
//        case 1:
//            //MARK: - New user with phone number
//            activatephonenumberLabel.isHidden = false
//            activesendcodeButton.isHidden = false
//            activeorLabel.isHidden = false
//            activechangemobilenumberButton.isHidden = false
//            
//            activatedphonenumberLabel.isHidden = true
//            activatedchangemobilenumberButton.isHidden = true
//            
//            changemobileNumberView.isHidden = true
//            otpsentcodeView.isHidden = true
//            otpoptinView.isHidden = true
//            saveView.isHidden = true
//            
//            otpactivateHeaderLabel.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 20).isActive = true
//            activatephonenumberLabel.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 10).isActive = true
//            
//            activateOptionHeaderLabel.topAnchor.constraint(equalTo: activesendcodeButton.bottomAnchor, constant: 20).isActive = true
//            
//            gapperLabel.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 10).isActive = true
//            
//            return
//        case 2:
//            //MARK: - New user without phone number, show add phone number field
//            changemobileNumberView.isHidden = false
//            
//            activatedphonenumberLabel.isHidden = true
//            activatedchangemobilenumberButton.isHidden = true
//            
//            activatephonenumberLabel.isHidden = true
//            activesendcodeButton.isHidden = true
//            activeorLabel.isHidden = true
//            activechangemobilenumberButton.isHidden = true
//            
//            otpsentcodeView.isHidden = true
//            otpoptinView.isHidden = true
//            saveView.isHidden = true
//            
//            otpactivateHeaderLabel.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 20).isActive = true
//            changemobileNumberView.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 10).isActive = true
//            changemobileNumberView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//            
//            activateOptionHeaderLabel.topAnchor.constraint(equalTo: changemobileNumberView.bottomAnchor, constant: 20).isActive = true
//            gapperLabel.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 10).isActive = true
//            
//            changemobilenumberCountryImage.image = setcountryImage(countryCode: "US")
//            if let countrycode = multifactorsettings.countryCode {
//                changemobilenumberCountryImage.image = setcountryImage(countryCode: countrycode)
//            }
//            
//            changemobilenumberCountryCode.text = "+1"
//            if let dialcode = multifactorsettings.countryDialcode {
//                changemobilenumberCountryCode.text = dialcode
//            }
//            
//            return
//        case 3:
//            //MARK: - OTP is sent and type otp code
//            otpsentcodeView.isHidden = false
//            
//            activatedphonenumberLabel.isHidden = true
//            activatedchangemobilenumberButton.isHidden = true
//            
//            activatephonenumberLabel.isHidden = true
//            activesendcodeButton.isHidden = true
//            activeorLabel.isHidden = true
//            activechangemobilenumberButton.isHidden = true
//            
//            changemobileNumberView.isHidden = true
//            
//            otpoptinView.isHidden = true
//            saveView.isHidden = true
//           
//            var otpHeight: CGFloat = 280
//            if deviceName == .pad {
//                otpHeight = 300
//            }
//            
//            
//            otpactivateHeaderLabel.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 20).isActive = true
//            otpsentcodeView.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 10).isActive = true
//            otpsentcodeView.heightAnchor.constraint(equalToConstant: 280).isActive = true
//            activateOptionHeaderLabel.topAnchor.constraint(equalTo: otpsentcodeView.bottomAnchor, constant: 20).isActive = true
//            gapperLabel.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 10).isActive = true
//            return
//        default:
//            activatephonenumberLabel.isHidden = true
//            activesendcodeButton.isHidden = true
//            activeorLabel.isHidden = true
//            activechangemobilenumberButton.isHidden = true
//            
//            changemobileNumberView.isHidden = true
//            otpsentcodeView.isHidden = true
//            saveView.isHidden = true
//            
//            activateOptionHeaderLabel.topAnchor.constraint(equalTo: activatedphonenumberLabel.bottomAnchor, constant: 15).isActive = true
//            gapperLabel.topAnchor.constraint(equalTo: otpoptinView.bottomAnchor, constant: 0).isActive = true
//
//            return
//        }
//    }
//}
//
////MARK: - Button Actions
////MARK: - Change mobile number Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func changemobileNumberAction(_ sender: UIButton) {
//        print("change mobile number action")
//        multifactoresettingsvm?.subStep = 2
////        self.updateOTPCellUI(multifactorsettings: multifactoresettingsvm!)
//        multifactorOTPCallBack!(multifactoresettingsvm, false)
//    }
//}
//
////MARK: - Send Code Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func sendotpCodeAction(_ sender: UIButton) {
//        print("send otp code action")
//    }
//}
//
////MARK: - Change phone code Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func changePhoneCodeAction(_ recognizer: UITapGestureRecognizer) {
//        print("change phone code")
//        multifactorOTPChangePhoneCodeCallBack!()  
//    }
//}
//
////MARK: - Save and Send Code Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func saveandsendcodeAction(_ sender: UIButton) {
//        print("save and send code action")
//        if let countrycode = changemobilenumberCountryCode.text, let mobilenumber = changemobilenumberPhonetextField.text {
//            self.multifactoresettingsvm?.subStep = 3
//            self.multifactorOTPCallBack!(self.multifactoresettingsvm, false)
////            let fullnumber = countrycode + mobilenumber
////
////            let otponboard = OTPOnBoard(mobileNumber: fullnumber)
////            otponboard.onboardusertoOTP(otponboard: otponboard) { (success) in
////                if !success {
////                    self.multifactoresettingsvm?.subStep = 3
////                    self.multifactorOTPCallBack!(self.multifactoresettingsvm, false)
////                    return
////                }
////            }
//        }
//    }
//}
//
////MARK: - Resend and Change mobile number action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func resendandchangeAction(_ recognizer: UITapGestureRecognizer) {
//        
//        let _fullText = "Didn't receive the code? Resend code or Change mobile number"
//        let _rangeOneText = "Resend code"
//        let _rangeTwoText = "Change mobile number"
//        
//        let _rangeOne = (_fullText as NSString).range(of: _rangeOneText)
//        let _rangeTwo = (_fullText as NSString).range(of: _rangeTwoText)
//                
//        if recognizer.didTapAttributedTextInLabel(label: otpsentResendLabel, inRange: _rangeOne) {
//            print("tap on resend")
//            return
//        }
//        
//        if recognizer.didTapAttributedTextInLabel(label: otpsentResendLabel, inRange: _rangeTwo) {
//            print("tap on change mobile number")
//            multifactoresettingsvm?.subStep = 2
////            self.updateOTPCellUI(multifactorsettings: self.multifactoresettingsvm!)
//            multifactorOTPCallBack!(multifactoresettingsvm, false)
//            return
//        }
//    }
//}
//
////MARK: - Verify OTP Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func verifyOTPAction(_ sender: UIButton) {
//        print("Verify otp action")
//    }
//}
//
////MARK: - OTP Save Settings Action
//extension MultifactorOTPSettingsCell {
//    @objc
//    func otpSettingsSaveButtonAction(_ sender: UIButton) {
//        print("otp save settings")
////        let multifactorsavesettings = MultifactorSaveSettings(TwoFAType: 2, LoginVerificationType: 4, ApprovalVerificationType: 1, IsBiometricEnabled: true)
////        multifactorsavesettings.postMultifactorSettings(multifactorsettings: multifactorsavesettings) { (success) in
////            print(success)
////        }
//    }
//}
//
////MARK: - Setup Country Image
//extension MultifactorOTPSettingsCell {
//    private func setcountryImage(countryCode: String) -> UIImage? {
//        let bundle = "assets.bundle/"
//        let image = UIImage(named: bundle + countryCode + ".png",
//        in: Bundle(for: ADCountryPicker.self), compatibleWith: nil)
//        
//        return image ?? nil
//    }
//}
//
////MARK: - Text Field Delegate
//extension MultifactorOTPSettingsCell: UITextFieldDelegate {
//    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        if let charactorcount = textField.text?.count {
//            if charactorcount > 1 {
//                changemobilenumberSaveSendButton.isEnabled = true
//            } else {
//                changemobilenumberSaveSendButton.isEnabled = false
//            }
//        }
//        return true
//    }
//}
