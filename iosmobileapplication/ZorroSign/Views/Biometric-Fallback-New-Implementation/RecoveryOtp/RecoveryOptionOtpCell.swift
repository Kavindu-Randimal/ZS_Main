//
//  RecoveryOptionOtpCell.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RecoveryOptionOtpCell: UITableViewCell {
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var recoveryOtpBaseConatianer: UIView!
    private var recoveryoptionBtn: UIButton!
    private var downarrowImage: UIImageView!
    private var recoveryoptionLabel: UILabel!
    private var recoeveryemailOption: RecoveryEmailOptionRadioBtnView!
    private var recoeveryquestionoption: RecoveryQuestionOptionRadioBtnView!
    private var otptextView: RecoveryOtpTextView!
    private var otpsentcodeView: UIView!
    private var didntreceiveLabel: UILabel!
    private var resendOtpLabel: UILabel!
    private var changeemailLabel: UILabel!
    private var orLabel:UILabel!
    private var otpsentVerifyButton: UIButton!
    private var otpsendLabel: UILabel!
    private var gapLabel: UILabel!
    
    var multifactortwofasettingsCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var showAlertMessageCallBack: ((String) -> ())?
    var otpValue: String?
    var otpreceiverEmail = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        otpValue = ""
        otptextView.removeValues()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setenterotpcellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var recoveryoptionsFallback: MultifactorSettingsViewModel? {
        didSet {
            if let recoveryoptionsubType = recoveryoptionsFallback?.recoveryoptionsubType {
                
            }
        }
    }
}

//MARK: - Set Otp Cell UI
extension RecoveryOptionOtpCell {
    private func setenterotpcellUI() {
        
        setOtpBaseContainer()
        setHeader()
        setRecoveryEmailOption()
        setOtpSentLabel()
        setOtpTextView()
        setSecurityQuestionOption()
        setGapper()
    }
}

//MARK: - Set email base container
extension RecoveryOptionOtpCell {
    private func setOtpBaseContainer() {
        
        recoveryOtpBaseConatianer = UIView()
        recoveryOtpBaseConatianer.translatesAutoresizingMaskIntoConstraints = false
        recoveryOtpBaseConatianer.backgroundColor = .white
        
        addSubview(recoveryOtpBaseConatianer)
        
        let otpbasecontainerConstraints = [recoveryOtpBaseConatianer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                           recoveryOtpBaseConatianer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                           recoveryOtpBaseConatianer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                           recoveryOtpBaseConatianer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(otpbasecontainerConstraints)
        recoveryOtpBaseConatianer.setShadow()
    }
}

//MARK: - Setup Header UI
extension RecoveryOptionOtpCell {
    private func setHeader() {
        
        recoveryoptionBtn = UIButton()
        recoveryoptionBtn.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionBtn.backgroundColor = .white
        recoveryOtpBaseConatianer.addSubview(recoveryoptionBtn)
        
        let recoveryoptionbtnConstraints = [recoveryoptionBtn.leftAnchor.constraint(equalTo: recoveryOtpBaseConatianer.leftAnchor, constant: 10),
                                            recoveryoptionBtn.topAnchor.constraint(equalTo: recoveryOtpBaseConatianer.topAnchor, constant: 25),
                                            recoveryoptionBtn.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor, constant: -10),
                                            recoveryoptionBtn.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(recoveryoptionbtnConstraints)
        
        recoveryoptionBtn.addTarget(self, action: #selector(selectRecoveryOptions(_:)), for: .touchUpInside)
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Up-Arrow_tools")
        recoveryOtpBaseConatianer.addSubview(downarrowImage)
        
        let downarrowimageConstraints = [downarrowImage.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor),
                                         downarrowImage.rightAnchor.constraint(equalTo: recoveryoptionBtn.rightAnchor,constant: -10),
                                         downarrowImage.heightAnchor.constraint(equalToConstant: 10),
                                         downarrowImage.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(downarrowimageConstraints)
        
        recoveryoptionLabel = UILabel()
        recoveryoptionLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        recoveryoptionLabel.textColor = ColorTheme.lblBodySpecial2
        recoveryoptionLabel.numberOfLines = 0
        recoveryoptionLabel.text = "Recovery Options*"
        recoveryOtpBaseConatianer.addSubview(recoveryoptionLabel)
        
        let recoveroptionlableConstraints = [recoveryoptionLabel.leftAnchor.constraint(equalTo: recoveryoptionBtn.leftAnchor),
                                             recoveryoptionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor),
                                             recoveryoptionLabel.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
    }
}

//MARK: - Set recoevry email option
extension RecoveryOptionOtpCell {
    private func setRecoveryEmailOption() {
        
        recoeveryemailOption = RecoveryEmailOptionRadioBtnView(optiontexts: ["Recovery Email Address"])
        recoeveryemailOption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryemailOption.backgroundColor = .white
        recoveryOtpBaseConatianer.addSubview(recoeveryemailOption)
        
        let recoveryoptionsviewConstraints = [recoeveryemailOption.topAnchor.constraint(equalTo: recoveryoptionBtn.bottomAnchor,constant: 5),
                                              recoeveryemailOption.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor,constant: -5),
                                              recoeveryemailOption.leftAnchor.constraint(equalTo:recoveryOtpBaseConatianer.leftAnchor,constant: 15),
                                              recoeveryemailOption.heightAnchor.constraint(equalToConstant: 40 )]
        NSLayoutConstraint.activate(recoveryoptionsviewConstraints)
    }
}

//MARK: - Set otp resend
extension RecoveryOptionOtpCell {
    private func setOtpSentLabel() {
        
        otpsendLabel = UILabel()
        otpsendLabel.translatesAutoresizingMaskIntoConstraints = false
        otpsendLabel.font = UIFont(name: "Helvetica", size: 17)
        otpsendLabel.textAlignment = .left
        otpsendLabel.textColor = ColorTheme.lblBodySpecial2
        otpsendLabel.adjustsFontSizeToFitWidth = true
        otpsendLabel.minimumScaleFactor = 0.2
        otpsendLabel.numberOfLines = 2
        
        let _attributedText = otpsendLabel.attributedText(withString: "OTP verification code sent to ", boldString: [otpreceiverEmail], font: UIFont(name: "Helvetica", size: 17)!, underline: false)
        otpsendLabel.attributedText = _attributedText
        
        recoveryOtpBaseConatianer.addSubview(otpsendLabel)
        
        let otpsendlabelConstraints = [otpsendLabel.leftAnchor.constraint(equalTo: recoveryOtpBaseConatianer.leftAnchor, constant: 25),
                                       otpsendLabel.topAnchor.constraint(equalTo: recoeveryemailOption.bottomAnchor,constant: 5),
                                       otpsendLabel.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor, constant: -15)]
        
        NSLayoutConstraint.activate(otpsendlabelConstraints)
    }
}

//MARK: - Set otp view
extension RecoveryOptionOtpCell {
    private func setOtpTextView() {
        
        otpsentcodeView = UIView()
        otpsentcodeView.translatesAutoresizingMaskIntoConstraints = false
        otpsentcodeView.backgroundColor = .white
        recoveryOtpBaseConatianer.addSubview(otpsentcodeView)
        
        var otpsentcodeviewHeight: CGFloat = (UIScreen.main.bounds.width/2)/4 + 60
        if deviceName == .pad {
            otpsentcodeviewHeight = otpsentcodeviewHeight + 20
        }
        
        let otpsentcodeViewConstraints = [otpsentcodeView.leftAnchor.constraint(equalTo: recoveryOtpBaseConatianer.leftAnchor, constant: 15), otpsentcodeView.topAnchor.constraint(equalTo: otpsendLabel.bottomAnchor, constant: 10),
                                          otpsentcodeView.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor, constant: -15),
                                          otpsentcodeView.heightAnchor.constraint(equalToConstant: otpsentcodeviewHeight)]
        NSLayoutConstraint.activate(otpsentcodeViewConstraints)
        
        otptextView = RecoveryOtpTextView()
        otptextView.translatesAutoresizingMaskIntoConstraints = false
        recoveryOtpBaseConatianer.addSubview(otptextView)
        
        let otptextviewHeight: CGFloat = (UIScreen.main.bounds.width/2)/4
        var _width = (UIScreen.main.bounds.width/2)/5 * 4 + 30
        
        if deviceName == .pad  {
            _width = (UIScreen.main.bounds.width/3)/5 * 4 + 30
        }
        
        let otptextviewConstraints = [otptextView.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor),
                                      otptextView.topAnchor.constraint(equalTo: otpsentcodeView.topAnchor),
                                      otptextView.widthAnchor.constraint(equalToConstant: _width),
                                      otptextView.heightAnchor.constraint(equalToConstant: otptextviewHeight)]
        
        NSLayoutConstraint.activate(otptextviewConstraints)
        
        otptextView.otpcallBack = { [weak self] (otp) in
            self?.otpValue = otp
            return
        }
        
        didntreceiveLabel = UILabel()
        didntreceiveLabel.translatesAutoresizingMaskIntoConstraints = false
        didntreceiveLabel.adjustsFontSizeToFitWidth = true
        didntreceiveLabel.minimumScaleFactor = 0.2
        didntreceiveLabel.numberOfLines = 0
        didntreceiveLabel.isUserInteractionEnabled = true
        didntreceiveLabel.text = "Didn't receive the code?"
        didntreceiveLabel.textColor = ColorTheme.lblBodyDefault
        otpsentcodeView.addSubview(didntreceiveLabel)
        
        let otpsentResendLabelConstraints = [didntreceiveLabel.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 10),
                                             didntreceiveLabel.topAnchor.constraint(equalTo: otptextView.bottomAnchor, constant: 10),
                                             didntreceiveLabel.rightAnchor.constraint(equalTo: otpsentcodeView.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(otpsentResendLabelConstraints)
        
        resendOtpLabel = UILabel()
        resendOtpLabel.translatesAutoresizingMaskIntoConstraints = false
        resendOtpLabel.adjustsFontSizeToFitWidth = true
        resendOtpLabel.minimumScaleFactor = 0.2
        resendOtpLabel.numberOfLines = 1
        resendOtpLabel.isUserInteractionEnabled = true
        resendOtpLabel.text = "Resend OTP"
        resendOtpLabel.textColor = ColorTheme.lblBgSpecial
        otpsentcodeView.addSubview(resendOtpLabel)
        
        let resendOtpConstraints = [resendOtpLabel.leftAnchor.constraint(equalTo: otpsentcodeView.leftAnchor, constant: 10),
                                    resendOtpLabel.topAnchor.constraint(equalTo: didntreceiveLabel.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(resendOtpConstraints)
        
        let typecodetapGesture = UITapGestureRecognizer(target: self, action: #selector(resendandchangeAction(_:)))
        resendOtpLabel.addGestureRecognizer(typecodetapGesture)
        
        orLabel = UILabel()
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        orLabel.adjustsFontSizeToFitWidth = true
        orLabel.minimumScaleFactor = 0.2
        orLabel.numberOfLines = 1
        orLabel.text = " or"
        otpsentcodeView.addSubview(orLabel)
        
        let orlabelConstraints = [orLabel.leftAnchor.constraint(equalTo: resendOtpLabel.rightAnchor),
                                  orLabel.topAnchor.constraint(equalTo: didntreceiveLabel.bottomAnchor,constant: 5)]
        NSLayoutConstraint.activate(orlabelConstraints)
        
        changeemailLabel = UILabel()
        changeemailLabel.translatesAutoresizingMaskIntoConstraints = false
        changeemailLabel.adjustsFontSizeToFitWidth = true
        changeemailLabel.minimumScaleFactor = 0.2
        changeemailLabel.numberOfLines = 1
        changeemailLabel.isUserInteractionEnabled = true
        changeemailLabel.text = " change email address"
        changeemailLabel.textColor = ColorTheme.lblBgSpecial
        otpsentcodeView.addSubview(changeemailLabel)
        
        let changeemailConstraints = [changeemailLabel.leftAnchor.constraint(equalTo: orLabel.rightAnchor),changeemailLabel.topAnchor.constraint(equalTo: didntreceiveLabel.bottomAnchor,constant: 5)]
        
        NSLayoutConstraint.activate(changeemailConstraints)
        
        let changeemailtapGesture = UITapGestureRecognizer(target: self, action: #selector(emailchangeAction(_:)))
        changeemailLabel.addGestureRecognizer(changeemailtapGesture)
        
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
        
        let _verifyButtonWidth = (UIScreen.main.bounds.width/2)/2
        
        let otpsentVerifyButtonConstraints = [otpsentVerifyButton.leftAnchor.constraint(equalTo: otptextView.rightAnchor, constant: 40),
                                              otpsentVerifyButton.centerYAnchor.constraint(equalTo: otptextView.centerYAnchor),
                                              otpsentVerifyButton.widthAnchor.constraint(equalToConstant: _verifyButtonWidth),
                                              otpsentVerifyButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
        otpsentVerifyButton.setShadow()
        otpsentVerifyButton.addTarget(self, action: #selector(verifyOTP(_:)), for: .touchUpInside)
        
    }
}

//MARK: - Resend OTP code
extension RecoveryOptionOtpCell {
    @objc
    private func resendandchangeAction(_ recognizer: UITapGestureRecognizer) {
        let secondaryemail = ZorroTempData.sharedInstance.getSecondaryEmail()
        let userid = ZorroTempData.sharedInstance.getUserEmail()
        
        let fallbackotpRequest = FallbackOTPRequest(SecondaryEmail: secondaryemail, UserId: userid)
        fallbackotpRequest.requestuserotpWithSecondaryEmail(otprequestwithemail: fallbackotpRequest) { (requested) in
            if requested {
                self.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self.recoveryoptionsFallback?.recoveryOptionType = 1
                self.recoveryoptionsFallback?.recoveryoptionsubType = 1
                self.multifactortwofasettingsCallBack!(self.recoveryoptionsFallback, false)
                return
            }
            return
        }
    }
}

//MARK: - Verify the OTP Action
extension RecoveryOptionOtpCell {
    @objc
    private func verifyOTP(_ sender: UIButton) {
        let userId = ZorroTempData.sharedInstance.getUserEmail()
        
        guard let _otpValue = otpValue, _otpValue.count == 4 else {
            showAlertMessageCallBack!("Please enter the OTP")
            return
        }
        
        let fallbackverifyotpRequest = FallbackVerifyOTPRequest(Otp: _otpValue, UserId: userId)
        fallbackverifyotpRequest.verifyOtpFallback(verifyotprequest: fallbackverifyotpRequest){ (requested) in
            if requested {
                self.recoveryoptionsFallback?.recoveryOptionSelected = 0
                
                self.recoveryoptionsFallback?.isfallbackEnable = true
                self.recoveryoptionsFallback?.recoveryOptionType = 1
                
                self.multifactortwofasettingsCallBack!(self.recoveryoptionsFallback, false)
            } else {
                self.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self.recoveryoptionsFallback?.recoveryOptionType = 1
                self.recoveryoptionsFallback?.recoveryoptionsubType = 2
                self.multifactortwofasettingsCallBack!(self.recoveryoptionsFallback, false)
            }
            return
        }
    }
}

//MARK: - Change email address
extension RecoveryOptionOtpCell {
    @objc private func emailchangeAction(_ recognizer: UITapGestureRecognizer) {
        print("Chathura email change for otp ")
        recoveryoptionsFallback?.recoveryOptionSelected = 1
        recoveryoptionsFallback?.recoveryOptionType = 1
        recoveryoptionsFallback?.recoveryoptionsubType = 0
        multifactortwofasettingsCallBack!(recoveryoptionsFallback, false)
        return
    }
}

//MARK: - Set security question
extension RecoveryOptionOtpCell {
    private func setSecurityQuestionOption() {
        
        recoeveryquestionoption = RecoveryQuestionOptionRadioBtnView(optiontexts: ["Security Questions"])
        recoeveryquestionoption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryquestionoption.backgroundColor = .white
        recoveryOtpBaseConatianer.addSubview(recoeveryquestionoption)
        
        let recoveryquestionsviewConstraints = [
            recoeveryquestionoption.leftAnchor.constraint(equalTo:recoveryOtpBaseConatianer.leftAnchor,constant: 15),
            recoeveryquestionoption.topAnchor.constraint(equalTo: resendOtpLabel.bottomAnchor,constant: 10),
            recoeveryquestionoption.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor,constant: -5),
            recoeveryquestionoption.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(recoveryquestionsviewConstraints)
        
        recoeveryquestionoption.optionviewCallBack =  { [weak self] (emailSelected) in
            if emailSelected {
                print("Chathura fallback otp ")
                self?.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self?.recoveryoptionsFallback?.recoveryOptionType = 2
                self?.multifactortwofasettingsCallBack!(self!.recoveryoptionsFallback, false)
            }
            return
        }
    }
}

//MARK: - Set gapper label
extension RecoveryOptionOtpCell {
    private func setGapper() {
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryOtpBaseConatianer.addSubview(gapLabel)
        gapLabel.text = "..."
        gapLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            gapLabel.leftAnchor.constraint(equalTo: recoveryOtpBaseConatianer.leftAnchor),
            gapLabel.topAnchor.constraint(equalTo: recoeveryquestionoption.bottomAnchor),
            gapLabel.rightAnchor.constraint(equalTo: recoveryOtpBaseConatianer.rightAnchor),
            gapLabel.bottomAnchor.constraint(equalTo: recoveryOtpBaseConatianer.bottomAnchor)
        ])
        
    }
}

//MARK: - Select recovery options method
extension RecoveryOptionOtpCell {
    @objc func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options deselect 3")
        if let recoveryoptionSelected = recoveryoptionsFallback?.recoveryOptionSelected {
            if recoveryoptionSelected == 0 {
                recoveryoptionsFallback?.recoveryOptionSelected = 1
                recoveryoptionsFallback?.recoveryOptionType = 2
            } else {
                recoveryoptionsFallback?.recoveryOptionSelected = 0
                recoveryoptionsFallback?.recoveryOptionType = 2
            }
        }
        multifactortwofasettingsCallBack!(recoveryoptionsFallback, false)
    }
}
