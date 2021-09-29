//
//  MultifactorActivationCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorActivationCell: MultifactorTwoFABaseCell {
    
    private var biometricactivateLabel: UILabel!
    private var biometricactivateSwitch: UISwitch!
    private var otpctivateLabel: UILabel!
    private var otpactivateSwitch: UISwitch!
    
    var activateSwitchCallBack: ((MultifactorSettingsViewModel?) -> ())?

    
    var multifactorsettingsvm: MultifactorSettingsViewModel? {
        didSet {
            if let biometricswitch = multifactorsettingsvm?.biometricSwitch, let otpswitch = multifactorsettingsvm?.otpSwitch {
                
                biometricactivateSwitch.isOn = biometricswitch
                otpactivateSwitch.isOn = otpswitch
                
                if (!biometricswitch && !otpswitch) {
                    biometricactivateSwitch.isEnabled = true
                    otpactivateSwitch.isEnabled = true
                }
                
                if (biometricswitch && !otpswitch) {
                    biometricactivateSwitch.isEnabled = true
                    otpactivateSwitch.isEnabled = false
                }
                
                if (!biometricswitch && otpswitch) {
                    biometricactivateSwitch.isEnabled = false
                    otpactivateSwitch.isEnabled = true
                }
            }
        }
    }
}

extension MultifactorActivationCell {
    override func setCellUI() {
        
        biometricactivateSwitch = UISwitch()
        biometricactivateSwitch.translatesAutoresizingMaskIntoConstraints = false
        biometricactivateSwitch.thumbTintColor = .white
        biometricactivateSwitch.onTintColor = ColorTheme.switchActive
        biometricactivateSwitch.tag = 0
        baseContainer.addSubview(biometricactivateSwitch)
        
        let biometricactivateSwitchConstraints = [biometricactivateSwitch.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 10),
                                                  biometricactivateSwitch.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10),
                                                  biometricactivateSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(biometricactivateSwitchConstraints)
        
        biometricactivateSwitch.addTarget(self, action: #selector(activateSwitchActions(_:)), for: .valueChanged)
        
        biometricactivateLabel = UILabel()
        biometricactivateLabel.translatesAutoresizingMaskIntoConstraints = false
        biometricactivateLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        biometricactivateLabel.text = "Biometric Authentication"
        biometricactivateLabel.adjustsFontSizeToFitWidth = true
        biometricactivateLabel.minimumScaleFactor = 0.2
        biometricactivateLabel.textColor = ColorTheme.lblBodySpecial2
        
        baseContainer.addSubview(biometricactivateLabel)
        
        let biometricactivatelabelConstraint = [biometricactivateLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
                                                biometricactivateLabel.centerYAnchor.constraint(equalTo: biometricactivateSwitch.centerYAnchor),
                                                biometricactivateLabel.rightAnchor.constraint(equalTo: biometricactivateSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(biometricactivatelabelConstraint)
        
        otpactivateSwitch = UISwitch()
        otpactivateSwitch.translatesAutoresizingMaskIntoConstraints = false
        otpactivateSwitch.thumbTintColor = .white
        otpactivateSwitch.onTintColor = ColorTheme.switchActive
        otpactivateSwitch.tag = 1
        baseContainer.addSubview(otpactivateSwitch)
        
        let otpactivateSwitchConstraints = [otpactivateSwitch.topAnchor.constraint(equalTo: biometricactivateSwitch.bottomAnchor, constant: 10),
                                                  otpactivateSwitch.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10),
                                                  otpactivateSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(otpactivateSwitchConstraints)
        
        otpactivateSwitch.addTarget(self, action: #selector(activateSwitchActions(_:)), for: .valueChanged)
        
        otpctivateLabel = UILabel()
        otpctivateLabel.translatesAutoresizingMaskIntoConstraints = false
        otpctivateLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        otpctivateLabel.numberOfLines = 2
        otpctivateLabel.text = "One Time Password Verification (OTP)"
        otpctivateLabel.adjustsFontSizeToFitWidth = true
        otpctivateLabel.minimumScaleFactor = 0.2
        otpctivateLabel.textColor = ColorTheme.lblBodySpecial2
        baseContainer.addSubview(otpctivateLabel)
        
        let otpctivatelabelConstraint = [otpctivateLabel.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
                                                otpctivateLabel.centerYAnchor.constraint(equalTo: otpactivateSwitch.centerYAnchor),
                                                otpctivateLabel.rightAnchor.constraint(equalTo: otpactivateSwitch.leftAnchor, constant: -5),
                                                otpactivateSwitch.bottomAnchor.constraint(equalTo: baseContainer.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(otpctivatelabelConstraint)
    }
}

extension MultifactorActivationCell {
    @objc
    private func activateSwitchActions(_ sender: UISwitch) {
        
        if let twofatype = multifactorsettingsvm?.twoFAType {
            switch sender.tag {
            case 0:
                multifactorsettingsvm?.biometricSwitch = sender.isOn
            
                sender.isOn ? (multifactorsettingsvm?.twoFATypeLocal = 2) : (multifactorsettingsvm?.twoFATypeLocal = 0)
                if sender.isOn {
                    multifactorsettingsvm?.subStep = 0
                }
            case 1:
                multifactorsettingsvm?.otpSwitch = sender.isOn
                sender.isOn ? (multifactorsettingsvm?.twoFATypeLocal = 1) : (multifactorsettingsvm?.twoFATypeLocal = 0)
                if sender.isOn {
                    if twofatype == 1 {
                        multifactorsettingsvm?.subStep = 0
                    } else {
                        let otpnumber = ZorroTempData.sharedInstance.getOtpNumber()
                        let userphone = ZorroTempData.sharedInstance.getPhoneNumber()
                        
                        if (otpnumber != "" || userphone != "") {
                            (otpnumber != "") ? (multifactorsettingsvm?.mobilenNumber = otpnumber) : (multifactorsettingsvm?.mobilenNumber = userphone)
                            multifactorsettingsvm?.subStep = 2
                        } else {
                            multifactorsettingsvm?.subStep = 3
                        }
                    }
                }
            default:
                return
            }
            
            if let biometriddcstwitch = multifactorsettingsvm?.biometricSwitch, let otpswitch = multifactorsettingsvm?.otpSwitch {
                
                if (!biometriddcstwitch && !otpswitch) {
                    multifactorsettingsvm?.loginSwitch = false
                    multifactorsettingsvm?.approvalSwitch = false
                    multifactorsettingsvm?.loginVerificationType = 1
                    multifactorsettingsvm?.approvalVerificationType = 1
                    multifactorsettingsvm?.approvalOptionIndex = 0
                }
            }
            
            sender.isOn ? ( multifactorsettingsvm?.numberofRows = 2) : (multifactorsettingsvm?.numberofRows = 1)
            activateSwitchCallBack!(multifactorsettingsvm)
        }
        return
    }
}
