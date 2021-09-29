//
//  MultifactorOTPSendCodeCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorOTPSendCodeCell: MultifactorOTPBaseCell {
    
    var activatephonenumberLabel: UILabel!
    var activesendcodeButton: UIButton!
    var activeorLabel: UILabel!
    var activechangemobilenumberButton: UIButton!

    var multifactorotpsendcodecellCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifaintaractionCallBack: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var multifactorsendcodeSettingsViewModel: MultifactorSettingsViewModel? {
        didSet {
            //MARK: Bind Data
            if let mobilenumber = multifactorsendcodeSettingsViewModel?.mobilenNumber {
                activatephonenumberLabel.text = "Send verification code to \(mobilenumber)"
            }
            //MARK: Update UI
            loginSwitch.isEnabled = false
            approvalSwitch.isEnabled = false
        }
    }
}

extension MultifactorOTPSendCodeCell {
    override func setupSubviewUI() {
        
        activatephonenumberLabel = UILabel()
        activatephonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
        activatephonenumberLabel.font = UIFont(name: "Helvetica", size: 18)
        activatephonenumberLabel.textColor = .darkGray
        activatephonenumberLabel.textAlignment = .left
        activatephonenumberLabel.text = "Send verification code to +157384444268"
        
        multiotpBaseContainer.addSubview(activatephonenumberLabel)
        
        let activatedphonenumberlabelconstraints = [
            activatephonenumberLabel.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
            activatephonenumberLabel.topAnchor.constraint(equalTo: otpaHeaderLabel.bottomAnchor, constant: 20),
            activatephonenumberLabel.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(activatedphonenumberlabelconstraints)
        
        activesendcodeButton = UIButton()
        activesendcodeButton.translatesAutoresizingMaskIntoConstraints = false
        activesendcodeButton.backgroundColor = ColorTheme.btnBG
        activesendcodeButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        activesendcodeButton.setTitle("SEND CODE", for: .normal)
        activesendcodeButton.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        activesendcodeButton.titleLabel?.adjustsFontSizeToFitWidth = true
        activesendcodeButton.titleLabel?.minimumScaleFactor = 0.2
        
        
        multiotpBaseContainer.addSubview(activesendcodeButton)
        
        let activesendcodeButtonConstraints = [activesendcodeButton.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
                                               activesendcodeButton.topAnchor.constraint(equalTo: activatephonenumberLabel.bottomAnchor, constant: 10),
                                               activesendcodeButton.widthAnchor.constraint(equalToConstant: 120),
                                               activesendcodeButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(activesendcodeButtonConstraints)
        
        activesendcodeButton.setShadow()
        activesendcodeButton.addTarget(self, action: #selector(sendCodeAction(_:)), for: .touchUpInside)
        
        activeorLabel = UILabel()
        activeorLabel.translatesAutoresizingMaskIntoConstraints = false
        activeorLabel.font = UIFont(name: "Helvetica", size: 18)
        activeorLabel.textColor = ColorTheme.lblBodySpecial2
        activeorLabel.textAlignment = .left
        activeorLabel.text = "or"
        
        multiotpBaseContainer.addSubview(activeorLabel)
        
        let activeorLabelconstraints = [activeorLabel.leftAnchor.constraint(equalTo: activesendcodeButton.rightAnchor, constant: 10),
                                        activeorLabel.centerYAnchor.constraint(equalTo: activesendcodeButton.centerYAnchor)]
        
        NSLayoutConstraint.activate(activeorLabelconstraints)
        
        
        activechangemobilenumberButton = UIButton()
        activechangemobilenumberButton.translatesAutoresizingMaskIntoConstraints = false
        activechangemobilenumberButton.setTitleColor(ColorTheme.lblBodyDefault, for: .normal)
        activechangemobilenumberButton.setTitle("Change mobile number", for: .normal)
        activechangemobilenumberButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        activechangemobilenumberButton.titleLabel?.textAlignment = .left
        activechangemobilenumberButton.contentHorizontalAlignment = .left
        activechangemobilenumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        activechangemobilenumberButton.titleLabel?.minimumScaleFactor = 0.2
        
        multiotpBaseContainer.addSubview(activechangemobilenumberButton)
        
        let activechangemobilenumberButtonConstraints = [activechangemobilenumberButton.leftAnchor.constraint(equalTo: activeorLabel.rightAnchor, constant: 5),
                                                         activechangemobilenumberButton.centerYAnchor.constraint(equalTo: activesendcodeButton.centerYAnchor)]
        NSLayoutConstraint.activate(activechangemobilenumberButtonConstraints)
        
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: activechangemobilenumberButton.currentTitle!, attributes: attributes)
        activechangemobilenumberButton.titleLabel?.attributedText = attributedText
        activechangemobilenumberButton.addTarget(self, action: #selector(changeMobileNumberAction(_:)), for: .touchUpInside)
        
        otpOptionHeaderTopConstraint = otpOptionHeaderLabel.topAnchor.constraint(equalTo: activechangemobilenumberButton.bottomAnchor, constant: 10)
        otpOptionHeaderTopConstraint.isActive = true
        
        updateotpgapperTopConstraints()
    }
}

//MARK: - Send Code Button Actions
extension MultifactorOTPSendCodeCell {
    @objc
    private func sendCodeAction(_ sender: UIButton) {
        
        if let mobilenumber = multifactorsendcodeSettingsViewModel?.mobilenNumber {
            let onboard = OTPOnBoard(mobileNumber: mobilenumber)
            onboard.onboardusertoOTP(otponboard: onboard) { (onboared) in
                if onboared {
                    self.multifactorsendcodeSettingsViewModel?.mobilenNumber = mobilenumber
                    self.multifactorsendcodeSettingsViewModel?.subStep = 4
                    self.multifactorotpsendcodecellCallBack!(self.multifactorsendcodeSettingsViewModel, false)
                    return
                }
            }
        }
        return
    }
}

extension MultifactorOTPSendCodeCell {
    @objc
    private func changeMobileNumberAction(_ sendr: UIButton) {
        multifactorsendcodeSettingsViewModel?.subStep = 3
        multifactorotpsendcodecellCallBack!(multifactorsendcodeSettingsViewModel, false)
        return
    }
}
