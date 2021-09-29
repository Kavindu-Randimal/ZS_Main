//
//  MultifactorOTPActivatedOptionCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 3/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorOTPActivatedOptionCell: MultifactorOTPActivatedCell {
    
    var otpoptionsViewTopConstraints: NSLayoutConstraint!
    var otpoptionsView: MultifactorOptionsView!

    
    var multifactorotpsettingsoptionCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifactorotpoptionsSaveCallBack: ((Bool) -> ())?
    var multifactootpoptionsusreIntreaction: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setotpoptioncellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var multifactorotpoptionsactivatedsettingViewModel: MultifactorSettingsViewModel? {
        didSet {
            
            if let loginswitch = multifactorotpoptionsactivatedsettingViewModel?.loginSwitch, let approvalswitch = multifactorotpoptionsactivatedsettingViewModel?.approvalSwitch {
                
                loginSwitch.isOn = loginswitch
                approvalSwitch.isOn = approvalswitch
            }
            
            if let approvalindex = multifactorotpoptionsactivatedsettingViewModel?.approvalOptionIndex {
                otpoptionsView.updateDefaultOption(at: approvalindex)
            }
            
            if let mobilenumber = multifactorotpoptionsactivatedsettingViewModel?.mobilenNumber {
                activatedphonenumberLabel.text = mobilenumber
            }
        }
    }
}

extension MultifactorOTPActivatedOptionCell {
    
    private func setotpoptioncellUI() {
        removeunwantedotpConstraints()
        setotpOptionsUI()
        updatetwofaotherConstraints()
    }
}

//MARK: - Setup Options ui
extension MultifactorOTPActivatedOptionCell {
    
    private func setotpOptionsUI() {
        otpoptionsView = MultifactorOptionsView(optiontexts: ["OTP Only", "OTP and Password"])
        otpoptionsView.translatesAutoresizingMaskIntoConstraints = false
        otpoptionsView.backgroundColor = .white
        otpoptionBaseContainer.addSubview(otpoptionsView)
        
        let otpoptionsViewConstraints = [otpoptionsView.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor),
                                               otpoptionsView.topAnchor.constraint(equalTo: optionSwitchSepratorView.bottomAnchor, constant: 10),
                                               otpoptionsView.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor),
                                               otpoptionsView.heightAnchor.constraint(equalToConstant: 100)]
        NSLayoutConstraint.activate(otpoptionsViewConstraints)
        
        otpoptionsView.optionviewCallBack = { [weak self] selectedindex in
           switch selectedindex {
           case 1:
               self?.multifactorotpoptionsactivatedsettingViewModel?.approvalOptionIndex = 1
               self?.multifactorotpoptionsactivatedsettingViewModel?.approvalVerificationType = 2
           case 2:
               self?.multifactorotpoptionsactivatedsettingViewModel?.approvalOptionIndex = 2
               self?.multifactorotpoptionsactivatedsettingViewModel?.approvalVerificationType = 3
           default:
               return
           }
        }
    }
    
}

//MARK: - Update OTP other constraints
extension MultifactorOTPActivatedOptionCell {
    private func updatetwofaotherConstraints() {
        saveView.topAnchor.constraint(equalTo: otpoptionsView.bottomAnchor, constant: 10).isActive = true
    }
}

//MARK: - Change mobile number Action
extension MultifactorOTPActivatedOptionCell {
    override func otpactivateChangeMobilAction(_ sender: UIButton) {
        multifactorotpoptionsactivatedsettingViewModel?.subStep = 3
        multifactorotpsettingsoptionCallBack!(multifactorotpoptionsactivatedsettingViewModel, false)
    }
}

//MARK: Update OTP Options
extension MultifactorOTPActivatedOptionCell {
    override func otpoptionSwitchAction(_ sender: UISwitch) {
        
        switch sender.tag {
        case 0:
            multifactorotpoptionsactivatedsettingViewModel?.loginSwitch = sender.isOn
            multifactorotpoptionsactivatedsettingViewModel?.loginVerificationType = (sender.isOn) ? 2 : 1
        case 1:
            multifactorotpoptionsactivatedsettingViewModel?.approvalSwitch = sender.isOn
            multifactorotpoptionsactivatedsettingViewModel?.subStep = (sender.isOn) ? 1 : 0
        default:
            return
        }
        multifactorotpsettingsoptionCallBack!(multifactorotpoptionsactivatedsettingViewModel, false)
    }
}

//MARK: - Multifactor save settings
extension MultifactorOTPActivatedOptionCell {
    
    override func saveMultifactorOTPSettings(_ sender: UIButton) {
        
        multifactootpoptionsusreIntreaction!(false)
        saveotpbuttonActivityIndicator.startAnimating()
        let multifactorsavesettings = MultifactorSaveSettings(multifactorsettingsviewmodel: multifactorotpoptionsactivatedsettingViewModel!)
     
        multifactorsavesettings.postMultifactorSettings(multifactorsettings: multifactorsavesettings) { (success) in
            self.saveotpbuttonActivityIndicator.stopAnimating()
            self.multifactootpoptionsusreIntreaction!(true)
            self.multifactorotpoptionsSaveCallBack!(success)
            return
        }
    }
}
