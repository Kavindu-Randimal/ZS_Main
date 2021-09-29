//
//  MultifactorTwoFASettingsOptionCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 3/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol MultifactorTwoFASettingsOptionCellDelegate {
    func onSaveBiometricSettingsMutifactorSettingsOptionCell(multisettings: MultifactorSettingsViewModel)
}

class MultifactorTwoFASettingsOptionCell: MultifactorTwoFASettingsCell {

    var biometricoptionsViewTopConstraints: NSLayoutConstraint!
    var biometricoptionsView: MultifactorOptionsView!
    
    var delegatemultifactorsettingsOptionCell : MultifactorTwoFASettingsOptionCellDelegate?
    
    var multifactortwofasettingsoptionCallBack: ((MultifactorSettingsViewModel?, Bool?) -> ())?
    var multifactortwofaoptionsSaveCallBack: ((Bool) -> ())?
    var multifactortwofaoptionsusreIntreaction: ((Bool) -> ())?
    
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
        settwofasettingsoptioncellUI()
    }
    
    override func layoutSubviews() {
        removeObserversMultifactorSettingsOptionCell()
        addObserversMultifactorSettingsOptionCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        removeObserversMultifactorSettingsOptionCell()
    }
    
    // MARK: - Notification Observers
    
    func addObserversMultifactorSettingsOptionCell() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.startAnimatingMultifactorSettingsOptionCell(notification:)), name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimatingMultifactorSettingsOptionCell(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        
        //Fallbackpath success stops activity indicator
         NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimatingMultifactorSettingsOptionCellFallbackSuccess(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingNotificationFallbackSuccessMultifactorSettingsOptionCell"), object: nil)
    }
    
    func removeObserversMultifactorSettingsOptionCell() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingNotificationFallbackSuccessMultifactorSettingsOptionCell"), object: nil)
    }
    
    // MARK: - Animating Funtions
    
    @objc func startAnimatingMultifactorSettingsOptionCell(notification: Notification) {
        savebuttonActivityIndicator.startAnimating()
    }
    
    @objc func stopAnimatingMultifactorSettingsOptionCell(notification: Notification) {
        print("Chathura notfication biometric login/approva optioncell success ", notification.object as! Bool)
        savebuttonActivityIndicator.stopAnimating()
        self.multifactortwofaoptionsusreIntreaction!(true)
        
        if let isSuccess = notification.object {
            showAlertNotification(isSuccess: isSuccess as! Bool)
        }
    }
    
    @objc func stopAnimatingMultifactorSettingsOptionCellFallbackSuccess(notification: Bool) {
        savebuttonActivityIndicator.stopAnimating()
        self.multifactortwofaoptionsusreIntreaction!(true)
    }
    
    func showAlertNotificationMultifactorSettingsOptionCell(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowAlert"), object: isSuccess, userInfo: nil)
    }
    
    var multifactorsettingsoptions: MultifactorSettingsViewModel? {
        didSet {
            if let loginswitch = multifactorsettingsoptions?.loginSwitch {
                biometricloginSwitch.isOn = loginswitch
            }
            
            if let approvalswitch = multifactorsettingsoptions?.approvalSwitch {
                biometricapprovalSwitch.isOn = approvalswitch
            }
            
            if let approvalindex = multifactorsettingsoptions?.approvalOptionIndex {
                biometricoptionsView.updateDefaultOption(at: approvalindex)
            }
        }
    }
}

extension MultifactorTwoFASettingsOptionCell {
    
    private func settwofasettingsoptioncellUI() {
        removeunwantedConstraints()
        settwofaOptions()
        updatetwofaotherConstraints()
    }
}

//MARK: - Setup Option View
extension MultifactorTwoFASettingsOptionCell {
    private func settwofaOptions() {
        biometricoptionsView = MultifactorOptionsView(optiontexts: ["Biometric Only", "Biometric and Password"])
        biometricoptionsView.translatesAutoresizingMaskIntoConstraints = false
        biometricoptionsView.backgroundColor = .white
        multitwofaBaseContainer.addSubview(biometricoptionsView)
        
        let biometricoptionsViewConstraints = [biometricoptionsView.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor),
                                               biometricoptionsView.topAnchor.constraint(equalTo: optionSeparatorView.bottomAnchor, constant: 10),
                                               biometricoptionsView.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor),
                                               biometricoptionsView.heightAnchor.constraint(equalToConstant: 100)]
        NSLayoutConstraint.activate(biometricoptionsViewConstraints)
        
        // CallBack Settings
        biometricoptionsView.optionviewCallBack = { [weak self] selectedindex in
            switch selectedindex {
            case 1:
                self?.multifactorsettingsoptions?.approvalOptionIndex = 1
                self?.multifactorsettingsoptions?.approvalVerificationType = 4
            case 2:
                self?.multifactorsettingsoptions?.approvalOptionIndex = 2
                self?.multifactorsettingsoptions?.approvalVerificationType = 5
            default:
                return
            }
            self?.multifactortwofasettingsoptionCallBack!(self?.multifactorsettingsoptions, nil)
        }
    }
    
    func setBiometricOnly() {
        // Defalut Settings to select Biometric Only
        if biometricoptionsView.optionTexts[0] == "Biometric Only" {
            if let _approvalType = multifactorsettingsoptions?.approvalVerificationType {
                if _approvalType != 5 {
                    biometricoptionsView.radiobuttonImages[1].image = nil
                    biometricoptionsView.radiobuttonImages[0].image = UIImage.fontAwesomeIcon(name: .dotCircle, style: .solid, textColor: biometricoptionsView.greenColor, size: CGSize(width: 30, height: 30))
                    
                    // Set the values in Settings
                    multifactorsettingsoptions?.approvalOptionIndex = 1
                    multifactorsettingsoptions?.approvalVerificationType = 4
                } else {
                    biometricoptionsView.radiobuttonImages[0].image = nil
                }
            }
        }
    }
}

//MARK: - Update TWO FA other constraints
extension MultifactorTwoFASettingsOptionCell {
    private func updatetwofaotherConstraints() {
        saveView.topAnchor.constraint(equalTo: biometricoptionsView.bottomAnchor, constant: 10).isActive = true
    }
}

//MARK: - Switch Actions
extension MultifactorTwoFASettingsOptionCell {
    override func twofaSwitchAction(_ sender: UISwitch) {
        if sender.tag == 0 {
            multifactorsettingsoptions?.loginSwitch = sender.isOn
            if let approvalswitch = multifactorsettingsoptions?.loginSwitch {
                if approvalswitch {
//                    multifactorsettingsoptions?.subStep = 1
                    multifactorsettingsoptions?.loginVerificationType = 3
                } else {
//                    multifactorsettingsoptions?.subStep = 0
                    multifactorsettingsoptions?.loginVerificationType = 1
                }
            }
            print(sender.isOn)
            
        } else {
            multifactorsettingsoptions?.approvalSwitch = sender.isOn
            multifactorsettingsoptions?.subStep = 0
            if (!sender.isOn) {
                multifactorsettingsoptions?.approvalVerificationType = 1
            }
        }
        multifactortwofasettingsoptionCallBack!(multifactorsettingsoptions, false)
        return
    }
    
    @objc override func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options selected")
        multifactorsettingsoptions?.recoveryOptionSelected = 1
//        multifactorsettings?.recoveryOptionType = 0
        multifactorsettingsoptions?.subStep = 0
        multifactortwofasettingsCallBack?(multifactorsettingsoptions, true)
    }
}

//MARK: - Save Biometric Settings
extension MultifactorTwoFASettingsOptionCell {
    
    override func twofasettingsSaveAction(_ sender: UIButton) {
        multifactortwofaoptionsusreIntreaction!(false)
        savebuttonActivityIndicator.startAnimating()
        
        guard let multisettings = multifactorsettingsoptions else {
            multifactortwofaoptionsusreIntreaction!(true)
            savebuttonActivityIndicator.stopAnimating()
            return
        }
        
        delegatemultifactorsettingsOptionCell?.onSaveBiometricSettingsMutifactorSettingsOptionCell(multisettings: multisettings)
        
//        let savesetting = MultifactorSaveSettings(multifactorsettingsviewmodel: multisettings)
//        savesetting.postBiometricSettings(multifactorsettings: savesetting) { (biometricsettings, statuscode, message) in
//            if biometricsettings != nil {
//                if statuscode == 1000 {
//                    self.multifactortwofaoptionsusreIntreaction!(true)
//                    self.savebuttonActivityIndicator.stopAnimating()
//                    self.multifactortwofaoptionsSaveCallBack!(true)
//                    return
//                }
//                self.multifactortwofaoptionsusreIntreaction!(true)
//                self.savebuttonActivityIndicator.stopAnimating()
//                self.multifactortwofaoptionsSaveCallBack!(false)
//                return
//            } else {
//                self.multifactortwofaoptionsusreIntreaction!(true)
//                self.savebuttonActivityIndicator.stopAnimating()
//                self.multifactortwofaoptionsSaveCallBack!(false)
//                return
//            }
//        }
    }
}
