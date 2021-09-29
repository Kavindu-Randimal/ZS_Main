////
////  OTPSettingsCell.swift
////  ZorroSign
////
////  Created by Anuradh Caldera on 2/12/20.
////  Copyright © 2020 Apple. All rights reserved.
////
//
//import UIKit
//
//class MultifactorOTPSettingsCell: MultifactorTwoFABaseCell {
//    
//    //MARK: OTP Activated header
//    var otpactivateHeaderLabel: UILabel!
//    
//    //MARK: OTP Activated UI
//    var activatedphonenumberLabel: UILabel!
//    var activatedchangemobilenumberButton: UIButton!
//    
//    //MARK: OTP Activate OTP
//    var activatephonenumberLabel: UILabel!
//    var activesendcodeButton: UIButton!
//    var activeorLabel: UILabel!
//    var activechangemobilenumberButton: UIButton!
//    
//    //MARK: OTP Change Mobile number
//    var changemobileNumberView: UIView!
//    var changemobilenumberCountryImage: UIImageView!
//    var changemobilenumberCountryCode: UILabel!
//    var changemobilenumberPhonetextField: UITextField!
//    var changemobilenumberSaveSendButton: UIButton!
//    
//    //MARK: - SENT OTP
//    var otpsentcodeView: UIView!
//    private var otpsenttimerView: OTPTimerView!
//    var otpsentResendLabel: UILabel!
//    private var otpsentVerifyButton: UIButton!
//    
//    //MARK:- OTP Activated Options Common
//    var activateOptionHeaderLabel: UILabel!
//    private var loginSwitch: UISwitch!
//    private var loginswitchText: UILabel!
//    var approvalSwitch: UISwitch!
//    var approvalswitchText: UILabel!
//    
//    //MARK: - OTP option view
//    var otpoptinView: MultifactorOptionsView!
//    
//    //MARK: - SAVE
//    var saveView: UIView!
//    private var saveSeparator: UIView!
//    private var saveButton: UIButton!
//    
//    var gapperLabel: UILabel!
//    
//    //MARK: - Multifactor otp callbacks
//    var multifactorOTPChangePhoneCodeCallBack: (() ->())?
//    var multifactorOTPCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
//    
//    var multifactoresettingsvm: MultifactorSettingsViewModel? {
//        didSet {
//            updateOTPCellUI(multifactorsettings: multifactoresettingsvm!)
//        }
//    }
//}
//
//extension MultifactorOTPSettingsCell {
//    override func setCellUI() {
//        setotpactivateHeader()
//        setotpactivatedUI()
//        setotpActivateUI()
//        setChangeMobileUI()
//        setcodeSentUI()
//        setCommonUI()
//    }
//}
//
//extension MultifactorOTPSettingsCell {
//    
//    private func setotpactivateHeader() {
//        
//        otpactivateHeaderLabel = UILabel()
//        otpactivateHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        otpactivateHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
//        otpactivateHeaderLabel.textColor = .darkGray
//        otpactivateHeaderLabel.numberOfLines = 0
//        otpactivateHeaderLabel.textAlignment = .left
//        otpactivateHeaderLabel.text = "Activate One Time Password Verification (OTP)"
//        
//        baseContainer.addSubview(otpactivateHeaderLabel)
//        
//        let otpactivateheaderlabelConstraints = [otpactivateHeaderLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                                 otpactivateHeaderLabel.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10)]
//        
//        NSLayoutConstraint.activate(otpactivateheaderlabelConstraints)
//    }
//}
//
//extension MultifactorOTPSettingsCell {
//    
//    private func setotpactivatedUI() {
//        
//        activatedphonenumberLabel = UILabel()
//        activatedphonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
//        activatedphonenumberLabel.font = UIFont(name: "Helvetica", size: 18)
//        activatedphonenumberLabel.textColor = .darkGray
//        activatedphonenumberLabel.textAlignment = .left
//        activatedphonenumberLabel.text = "+15738444268"
//        
//        baseContainer.addSubview(activatedphonenumberLabel)
//        
//        let activatedphonenumberlabelconstraints = [activatedphonenumberLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                                    activatedphonenumberLabel.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 25), activatedphonenumberLabel.heightAnchor.constraint(equalToConstant: 40)]
//        
//        NSLayoutConstraint.activate(activatedphonenumberlabelconstraints)
//        
//        activatedchangemobilenumberButton = UIButton()
//        activatedchangemobilenumberButton.translatesAutoresizingMaskIntoConstraints = false
//        activatedchangemobilenumberButton.setTitleColor(.black, for: .normal)
//        activatedchangemobilenumberButton.setTitle("Change mobile number", for: .normal)
//        activatedchangemobilenumberButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
//        activatedchangemobilenumberButton.titleLabel?.textAlignment = .left
//        activatedchangemobilenumberButton.contentHorizontalAlignment = .left
//        activatedchangemobilenumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        activatedchangemobilenumberButton.titleLabel?.minimumScaleFactor = 0.2
//        
//        baseContainer.addSubview(activatedchangemobilenumberButton)
//        
//        let activatedchangemobilenumberButtonConstraints = [activatedchangemobilenumberButton.leftAnchor.constraint(equalTo: activatedphonenumberLabel.rightAnchor, constant: 5),
//                                                            activatedchangemobilenumberButton.centerYAnchor.constraint(equalTo: activatedphonenumberLabel.centerYAnchor),
//                                                            activatedchangemobilenumberButton.rightAnchor.constraint(equalTo: baseContainer.rightAnchor)]
//        NSLayoutConstraint.activate(activatedchangemobilenumberButtonConstraints)
//        
//        let attributes = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
//        let attributedText = NSAttributedString(string: activatedchangemobilenumberButton.currentTitle!, attributes: attributes)
//        activatedchangemobilenumberButton.titleLabel?.attributedText = attributedText
//        
//        activatedchangemobilenumberButton.addTarget(self, action: #selector(changemobileNumberAction(_:)), for: .touchUpInside)
//    }
//}
//
////MARK: - Activate otp ui
//extension MultifactorOTPSettingsCell {
//    
//    private func setotpActivateUI() {
//        
//        activatephonenumberLabel = UILabel()
//        activatephonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
//        activatephonenumberLabel.font = UIFont(name: "Helvetica", size: 18)
//        activatephonenumberLabel.textColor = .darkGray
//        activatephonenumberLabel.textAlignment = .left
//        activatephonenumberLabel.text = "Send verification code to +157384444268"
//        activatephonenumberLabel.backgroundColor = .yellow
//        
//        baseContainer.addSubview(activatephonenumberLabel)
//        
//        let activatedphonenumberlabelconstraints = [
//            activatephonenumberLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//            activatephonenumberLabel.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 20),
//            activatephonenumberLabel.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10)
//        ]
//        
//        NSLayoutConstraint.activate(activatedphonenumberlabelconstraints)
//        
//        activesendcodeButton = UIButton()
//        activesendcodeButton.translatesAutoresizingMaskIntoConstraints = false
//        activesendcodeButton.backgroundColor = greencolor
//        activesendcodeButton.setTitleColor(.white, for: .normal)
//        activesendcodeButton.setTitle("SEND CODE", for: .normal)
//        activesendcodeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
//        activesendcodeButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        activesendcodeButton.titleLabel?.minimumScaleFactor = 0.2
//        
//        baseContainer.addSubview(activesendcodeButton)
//        
//        let activesendcodeButtonConstraints = [activesendcodeButton.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                               activesendcodeButton.topAnchor.constraint(equalTo: activatephonenumberLabel.bottomAnchor, constant: 10),
//                                               activesendcodeButton.widthAnchor.constraint(equalToConstant: 120),
//                                               activesendcodeButton.heightAnchor.constraint(equalToConstant: 40)]
//        NSLayoutConstraint.activate(activesendcodeButtonConstraints)
//        
//        activesendcodeButton.setShadow()
//        activesendcodeButton.addTarget(self, action: #selector(sendotpCodeAction(_:)), for: .touchUpInside)
//        
//        activeorLabel = UILabel()
//        activeorLabel.translatesAutoresizingMaskIntoConstraints = false
//        activeorLabel.font = UIFont(name: "Helvetica", size: 18)
//        activeorLabel.textColor = .darkGray
//        activeorLabel.textAlignment = .left
//        activeorLabel.text = "or"
//        
//        baseContainer.addSubview(activeorLabel)
//        
//        let activeorLabelconstraints = [activeorLabel.leftAnchor.constraint(equalTo: activesendcodeButton.rightAnchor, constant: 10),
//                                        activeorLabel.centerYAnchor.constraint(equalTo: activesendcodeButton.centerYAnchor)]
//        
//        NSLayoutConstraint.activate(activeorLabelconstraints)
//        
//        
//        activechangemobilenumberButton = UIButton()
//        activechangemobilenumberButton.translatesAutoresizingMaskIntoConstraints = false
//        activechangemobilenumberButton.setTitleColor(.black, for: .normal)
//        activechangemobilenumberButton.setTitle("Change mobile number", for: .normal)
//        activechangemobilenumberButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
//        activechangemobilenumberButton.titleLabel?.textAlignment = .left
//        activechangemobilenumberButton.contentHorizontalAlignment = .left
//        activechangemobilenumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        activechangemobilenumberButton.titleLabel?.minimumScaleFactor = 0.2
//        
//        baseContainer.addSubview(activechangemobilenumberButton)
//        
//        let activechangemobilenumberButtonConstraints = [activechangemobilenumberButton.leftAnchor.constraint(equalTo: activeorLabel.rightAnchor, constant: 5),
//                                                         activechangemobilenumberButton.centerYAnchor.constraint(equalTo: activesendcodeButton.centerYAnchor)]
//        NSLayoutConstraint.activate(activechangemobilenumberButtonConstraints)
//        
//        let attributes = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
//        let attributedText = NSAttributedString(string: activechangemobilenumberButton.currentTitle!, attributes: attributes)
//        activechangemobilenumberButton.titleLabel?.attributedText = attributedText
//        
//        activechangemobilenumberButton.addTarget(self, action: #selector(changemobileNumberAction(_:)), for: .touchUpInside)
//    }
//}
//
////MARK: - Change Mobile UI
//extension MultifactorOTPSettingsCell {
//    
//    private func setChangeMobileUI() {
//        
//        changemobileNumberView = UIView()
//        changemobileNumberView.translatesAutoresizingMaskIntoConstraints = false
//        baseContainer.addSubview(changemobileNumberView)
//        
//        let changemobilenumberviewConstraints = [changemobileNumberView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
//                                                 changemobileNumberView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//                                                 changemobileNumberView.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 5),
//                                                 changemobileNumberView.heightAnchor.constraint(equalToConstant: 110)]
//        NSLayoutConstraint.activate(changemobilenumberviewConstraints)
//        
//        
//        changemobilenumberCountryImage = UIImageView()
//        changemobilenumberCountryImage.translatesAutoresizingMaskIntoConstraints = false
//        changemobilenumberCountryImage.backgroundColor = .white
//        changemobilenumberCountryImage.contentMode = .scaleAspectFit
//        changemobilenumberCountryImage.isUserInteractionEnabled = true
//        changemobileNumberView.addSubview(changemobilenumberCountryImage)
//        
//        let changemobilenumberimageConstraints = [changemobilenumberCountryImage.topAnchor.constraint(equalTo: changemobileNumberView.topAnchor, constant: 5),
//                                                  changemobilenumberCountryImage.leftAnchor.constraint(equalTo: changemobileNumberView.leftAnchor, constant: 5),
//                                                  changemobilenumberCountryImage.widthAnchor.constraint(equalToConstant: 60),
//                                                  changemobilenumberCountryImage.heightAnchor.constraint(equalToConstant: 45)]
//        
//        NSLayoutConstraint.activate(changemobilenumberimageConstraints)
//        
//        let changecountrycodetapgesture = UITapGestureRecognizer(target: self, action: #selector(changePhoneCodeAction(_:)))
//        changemobilenumberCountryImage.addGestureRecognizer(changecountrycodetapgesture)
//        
//        changemobilenumberCountryCode = UILabel()
//        changemobilenumberCountryCode.translatesAutoresizingMaskIntoConstraints = false
//        changemobilenumberCountryCode.textAlignment = .left
//        changemobilenumberCountryCode.font = UIFont(name: "Helvetica", size: 18)
//        changemobilenumberCountryCode.text = "+1345"
//        changemobilenumberCountryCode.numberOfLines = 1
//        
//        changemobileNumberView.addSubview(changemobilenumberCountryCode)
//        
//        
//        let changemobilenumbercountrycodeConstraints = [changemobilenumberCountryCode.centerYAnchor.constraint(equalTo: changemobilenumberCountryImage.centerYAnchor),
//                                                        changemobilenumberCountryCode.leftAnchor.constraint(equalTo: changemobilenumberCountryImage.rightAnchor, constant: 5)]
//        NSLayoutConstraint.activate(changemobilenumbercountrycodeConstraints)
//        
//        changemobilenumberPhonetextField = UITextField()
//        changemobilenumberPhonetextField.translatesAutoresizingMaskIntoConstraints = false
//        changemobilenumberPhonetextField.font = UIFont(name: "Helvetica", size: 18)
//        changemobilenumberPhonetextField.textAlignment = .left
//        changemobilenumberPhonetextField.borderStyle = .roundedRect
//        changemobilenumberPhonetextField.keyboardType = .phonePad
//        changemobilenumberPhonetextField.delegate = self
//        
//        changemobileNumberView.addSubview(changemobilenumberPhonetextField)
//        
//        let changemobilenumberphoentextfieldConstraints = [
//            changemobilenumberPhonetextField.topAnchor.constraint(equalTo: changemobilenumberCountryImage.topAnchor),
//            changemobilenumberPhonetextField.rightAnchor.constraint(equalTo: changemobileNumberView.rightAnchor, constant: -5),
//            changemobilenumberPhonetextField.bottomAnchor.constraint(equalTo: changemobilenumberCountryImage.bottomAnchor),
//            changemobilenumberPhonetextField.leftAnchor.constraint(equalTo: changemobilenumberCountryCode.rightAnchor, constant: 5)]
//        NSLayoutConstraint.activate(changemobilenumberphoentextfieldConstraints)
//        
//        changemobilenumberSaveSendButton = UIButton()
//        changemobilenumberSaveSendButton.translatesAutoresizingMaskIntoConstraints = false
//        changemobilenumberSaveSendButton.backgroundColor = greencolor
//        changemobilenumberSaveSendButton.setTitleColor(.white, for: .normal)
//        changemobilenumberSaveSendButton.setTitle("SAVE & SEND CODE", for: .normal)
//        changemobilenumberSaveSendButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
//        changemobilenumberSaveSendButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        changemobilenumberSaveSendButton.titleLabel?.minimumScaleFactor = 0.2
//        changemobilenumberSaveSendButton.titleLabel?.textAlignment = .center
//        changemobilenumberSaveSendButton.isEnabled = false
//
//        changemobileNumberView.addSubview(changemobilenumberSaveSendButton)
//
//        let changemobilenumberSaveSendButtonConstraints = [changemobilenumberSaveSendButton.leftAnchor.constraint(equalTo: changemobileNumberView.leftAnchor, constant: 5),
//                                              changemobilenumberSaveSendButton.topAnchor.constraint(equalTo: changemobilenumberPhonetextField.bottomAnchor, constant: 10),
//                                              changemobilenumberSaveSendButton.rightAnchor.constraint(equalTo: changemobileNumberView.rightAnchor, constant: -5),
//                                              changemobilenumberSaveSendButton.heightAnchor.constraint(equalToConstant: 45)]
//        NSLayoutConstraint.activate(changemobilenumberSaveSendButtonConstraints)
//
//        changemobilenumberSaveSendButton.setShadow()
//        
//        changemobilenumberSaveSendButton.addTarget(self, action: #selector(saveandsendcodeAction(_:)), for: .touchUpInside)
//    }
//}
//
////MARK: - OTP Sent code self
//extension MultifactorOTPSettingsCell {
//    
//    private func setcodeSentUI() {
//        
//        otpsentcodeView = UIView()
//        otpsentcodeView.translatesAutoresizingMaskIntoConstraints = false
//        otpsentcodeView.backgroundColor = .white
//        baseContainer.addSubview(otpsentcodeView)
//        
//        var otpsentcodeviewHeight: CGFloat = 280
//        if deviceName == .pad {
//            otpsentcodeviewHeight = 300
//        }
//        
//        let otpsentcodeViewConstraints = [otpsentcodeView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10), otpsentcodeView.topAnchor.constraint(equalTo: otpactivateHeaderLabel.bottomAnchor, constant: 10),
//                                          otpsentcodeView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//                                          otpsentcodeView.heightAnchor.constraint(equalToConstant: otpsentcodeviewHeight)]
//        NSLayoutConstraint.activate(otpsentcodeViewConstraints)
//        
//        otpsenttimerView = OTPTimerView()
//        otpsenttimerView.translatesAutoresizingMaskIntoConstraints = false
//        otpsentcodeView.addSubview(otpsenttimerView)
//        
//        var otpsentcodetimerviewHeight: CGFloat = 180
//        if deviceName == .pad {
//            otpsentcodetimerviewHeight = 200
//        }
//        
//        let otpsenttimerviewConstraints = [otpsenttimerView.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor),
//                                           otpsenttimerView.topAnchor.constraint(equalTo: otpsentcodeView.topAnchor),
//                                           otpsenttimerView.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor),
//                                           otpsenttimerView.heightAnchor.constraint(equalToConstant: otpsentcodetimerviewHeight)]
//        
//        NSLayoutConstraint.activate(otpsenttimerviewConstraints)
//        
//        otpsenttimerView.otpcallBack = { [weak self] (otp, istimedout) in
//            if istimedout {
//                DispatchQueue.main.async {
//                    self?.otpsenttimerView.updatetimerUIForError(message: "Time exceeded. Please resend.")
//                }
//                return
//            }
//            return
//        }
//        
//        
//        otpsentResendLabel = UILabel()
//        otpsentResendLabel.translatesAutoresizingMaskIntoConstraints = false
//        otpsentResendLabel.font = UIFont(name: "Helvetica", size: 17)
//        otpsentResendLabel.adjustsFontSizeToFitWidth = true
//        otpsentResendLabel.minimumScaleFactor = 0.2
//        otpsentResendLabel.numberOfLines = 2
//        otpsentResendLabel.isUserInteractionEnabled = true
//        let _attributedText = otpsentResendLabel.attributedText(withString: "Didn't receive the code? Resend code or Change mobile number", boldString: ["Resend code","Change mobile number"], font: UIFont(name: "Helvetica", size: 16)!, underline: true)
//        otpsentResendLabel.attributedText = _attributedText
//        otpsentcodeView.addSubview(otpsentResendLabel)
//        
//        let otpsentResendLabelConstraints = [otpsentResendLabel.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 10),
//                                             otpsentResendLabel.topAnchor.constraint(equalTo: otpsenttimerView.bottomAnchor, constant: 10),
//                                             otpsentResendLabel.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor, constant: -10)]
//        NSLayoutConstraint.activate(otpsentResendLabelConstraints)
//        
//        let otpsentresendtapgesture = UITapGestureRecognizer(target: self, action: #selector(resendandchangeAction(_:)))
//        otpsentResendLabel.addGestureRecognizer(otpsentresendtapgesture)
//        
//        otpsentVerifyButton = UIButton()
//        otpsentVerifyButton.translatesAutoresizingMaskIntoConstraints = false
//        otpsentVerifyButton.backgroundColor = greencolor
//        otpsentVerifyButton.setTitleColor(.white, for: .normal)
//        otpsentVerifyButton.setTitle("VERIFY", for: .normal)
//        otpsentVerifyButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
//        otpsentVerifyButton.titleLabel?.adjustsFontSizeToFitWidth = true
//        otpsentVerifyButton.titleLabel?.minimumScaleFactor = 0.2
//        otpsentVerifyButton.titleLabel?.textAlignment = .center
//        
//        otpsentcodeView.addSubview(otpsentVerifyButton)
//        
//        let otpsentVerifyButtonConstraints = [otpsentVerifyButton.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 5),
//                                              otpsentVerifyButton.topAnchor.constraint(equalTo: otpsentResendLabel.bottomAnchor, constant: 10),
//                                              otpsentVerifyButton.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor, constant: -5),
//                                              otpsentVerifyButton.heightAnchor.constraint(equalToConstant: 45)]
//        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
//        
//        otpsentVerifyButton.setShadow()
//        otpsentVerifyButton.addTarget(self, action: #selector(verifyOTPAction(_:)), for: .touchUpInside)
//    }
//}
//
////MARK: - Common Settings
//extension MultifactorOTPSettingsCell {
//    
//    private func setCommonUI() {
//        
//        activateOptionHeaderLabel = UILabel()
//        activateOptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
//        activateOptionHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
//        activateOptionHeaderLabel.textColor = .darkGray
//        activateOptionHeaderLabel.numberOfLines = 0
//        activateOptionHeaderLabel.text = "Activate One Time Password Verificatin (OTP) for Login Process and Approval Process"
//        
//        baseContainer.addSubview(activateOptionHeaderLabel)
//        
//        
//        let activateoptionheaderlabelConstraints = [activateOptionHeaderLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                                    
//                                                    activateOptionHeaderLabel.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10)]
//        
//        NSLayoutConstraint.activate(activateoptionheaderlabelConstraints)
//        
//        loginSwitch = UISwitch()
//        loginSwitch.translatesAutoresizingMaskIntoConstraints = false
//        loginSwitch.thumbTintColor = .white
//        loginSwitch.onTintColor = greencolor
//        baseContainer.addSubview(loginSwitch)
//        
//        let loginSwitchConstraints = [loginSwitch.topAnchor.constraint(equalTo: activateOptionHeaderLabel.bottomAnchor, constant: 20),
//                                      loginSwitch.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10),
//                                      loginSwitch.widthAnchor.constraint(equalToConstant: 50)]
//        
//        NSLayoutConstraint.activate(loginSwitchConstraints)
//        
//        
//        loginswitchText = UILabel()
//        loginswitchText.translatesAutoresizingMaskIntoConstraints = false
//        loginswitchText.font = UIFont(name: "Helvetica", size: 18)
//        loginswitchText.textColor = .darkGray
//        loginswitchText.textAlignment = .left
//        loginswitchText.adjustsFontSizeToFitWidth = true
//        loginswitchText.numberOfLines = 2
//        loginswitchText.minimumScaleFactor = 0.2
//        loginswitchText.text = "OTP Verification for Login Process"
//        baseContainer.addSubview(loginswitchText)
//        
//        let loginswitchtextConstraints = [loginswitchText.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                          loginswitchText.centerYAnchor.constraint(equalTo: loginSwitch.centerYAnchor),
//                                          loginswitchText.rightAnchor.constraint(equalTo: loginSwitch.leftAnchor, constant: -5)]
//        NSLayoutConstraint.activate(loginswitchtextConstraints)
//        
//        
//        approvalSwitch = UISwitch()
//        approvalSwitch.translatesAutoresizingMaskIntoConstraints = false
//        approvalSwitch.thumbTintColor = .white
//        approvalSwitch.onTintColor = greencolor
//        baseContainer.addSubview(approvalSwitch)
//        
//        let approvalSwitchConstraints = [approvalSwitch.topAnchor.constraint(equalTo: loginSwitch.bottomAnchor, constant: 10),
//                                         approvalSwitch.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10),
//                                         approvalSwitch.widthAnchor.constraint(equalToConstant: 50)]
//        
//        NSLayoutConstraint.activate(approvalSwitchConstraints)
//        approvalswitchText = UILabel()
//        approvalswitchText.translatesAutoresizingMaskIntoConstraints = false
//        approvalswitchText.font = UIFont(name: "Helvetica", size: 18)
//        approvalswitchText.textColor = .darkGray
//        approvalswitchText.textAlignment = .left
//        approvalswitchText.adjustsFontSizeToFitWidth = true
//        approvalswitchText.minimumScaleFactor = 0.2
//        approvalswitchText.numberOfLines = 2
//        approvalswitchText.text = "OTP/Password Verification for Approval Process"
//        baseContainer.addSubview(approvalswitchText)
//        
//        let approvalswitchTextConstraints = [approvalswitchText.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
//                                             approvalswitchText.centerYAnchor.constraint(equalTo: approvalSwitch.centerYAnchor),
//                                             approvalswitchText.rightAnchor.constraint(equalTo: approvalSwitch.leftAnchor, constant: -5)]
//        NSLayoutConstraint.activate(approvalswitchTextConstraints)
//        
//        
//        otpoptinView = MultifactorOptionsView(optiontexts: ["aaa", "bbb"])
//        otpoptinView.translatesAutoresizingMaskIntoConstraints = false
//        otpoptinView.backgroundColor = .white
//        baseContainer.addSubview(otpoptinView)
//        
//        let otpoptinViewConstraints = [otpoptinView.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 0),
//                                              otpoptinView.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 20),
//                                              otpoptinView.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -20),
//                                              otpoptinView.heightAnchor.constraint(equalToConstant: 110)]
//        NSLayoutConstraint.activate(otpoptinViewConstraints)
//        
//        otpoptinView.updateDefaultOption(at: 0)
//        
//        otpoptinView.optionviewCallBack = { [weak self] selectedindex in
//            print(selectedindex)
//        }
//        
//        
//        saveView = UIView()
//        saveView.translatesAutoresizingMaskIntoConstraints = false
//        saveView.backgroundColor = .white
//        
//        baseContainer.addSubview(saveView)
//        
//        let saveviewConstraints = [saveView.leftAnchor.constraint(equalTo: baseContainer.leftAnchor),
//                                   saveView.topAnchor.constraint(equalTo: otpoptinView.bottomAnchor, constant: 40),
//                                   saveView.rightAnchor.constraint(equalTo: baseContainer.rightAnchor),
//                                   saveView.heightAnchor.constraint(equalToConstant: 50)]
//        
//        NSLayoutConstraint.activate(saveviewConstraints)
//        
//        saveSeparator = UIView()
//        saveSeparator.translatesAutoresizingMaskIntoConstraints = false
//        saveSeparator.backgroundColor = .lightGray
//        saveView.addSubview(saveSeparator)
//        
//        let saveseparatorConstraints = [saveSeparator.leftAnchor.constraint(equalTo: saveView.leftAnchor),
//                                        saveSeparator.topAnchor.constraint(equalTo: saveView.topAnchor),
//                                        saveSeparator.rightAnchor.constraint(equalTo: saveView.rightAnchor),
//                                        saveSeparator.heightAnchor.constraint(equalToConstant: 1)]
//        NSLayoutConstraint.activate(saveseparatorConstraints)
//        
//        saveButton = UIButton()
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
//        saveButton.backgroundColor = greencolor
//        saveButton.setTitle("SAVE", for: .normal)
//        saveButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
//        saveButton.setTitleColor(.white, for: .normal)
//        
//        saveView.addSubview(saveButton)
//        
//        let savebuttonConstraints = [saveButton.centerYAnchor.constraint(equalTo: saveView.centerYAnchor, constant: 5),
//                                     saveButton.leftAnchor.constraint(equalTo: saveView.leftAnchor, constant: 10),
//                                     saveButton.rightAnchor.constraint(equalTo: saveView.rightAnchor, constant: -10),
//                                     saveButton.heightAnchor.constraint(equalToConstant: 45)]
//        
//        NSLayoutConstraint.activate(savebuttonConstraints)
//        
//        saveButton.layer.cornerRadius = 8
//        saveButton.addTarget(self, action: #selector(otpSettingsSaveButtonAction(_:)), for: .touchUpInside)
//        
//        gapperLabel = UILabel()
//        gapperLabel.translatesAutoresizingMaskIntoConstraints = false
//        gapperLabel.textColor = .white
//        gapperLabel.text = " "
//        
//        baseContainer.addSubview(gapperLabel)
//        
//        let gapperlabelConstraints = [gapperLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor),
//                                      gapperLabel.topAnchor.constraint(equalTo: saveView.bottomAnchor, constant: 0),
//                                      gapperLabel.rightAnchor.constraint(equalTo: baseContainer.rightAnchor),
//                                      gapperLabel.bottomAnchor.constraint(equalTo: baseContainer.bottomAnchor, constant: 10)]
//        NSLayoutConstraint.activate(gapperlabelConstraints)
//    }
//}
//
