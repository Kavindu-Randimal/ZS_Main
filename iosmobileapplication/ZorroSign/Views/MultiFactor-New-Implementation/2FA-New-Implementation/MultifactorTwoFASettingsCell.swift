//
//  MultifactorTwoFASettingsCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol nameMultifactorTwoFASettingsCellDelegate {
    func onSaveBiometricSettings(multisettings: MultifactorSettingsViewModel)
}

class MultifactorTwoFASettingsCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    var multitwofaBaseContainer: UIView!
    
    var recoveryoptionBtn: UIButton!
    var recoveryoptionLabel: UILabel!
    var downarrowImage: UIImageView!
    //var recoveryOptionsView: ReviewOptionView!
    
    var biometricloginLabel: UILabel!
    var biometricloginSwitch: UISwitch!
    var biometricapprovalLabel: UILabel!
    var biometricapprovalSwitch: UISwitch!
    
    var optionSeparatorView: UIView!
    
    var saveviewTopConstraint: NSLayoutConstraint!
    var saveView: UIView!
    var saveSeparator: UIView!
    var saveButton: UIButton!
    var savebuttonActivityIndicator: UIActivityIndicatorView!
    
    var gapperLabel: UILabel!
    var gapperTopConstraints: NSLayoutConstraint!
    var gapperBottomConstraints: NSLayoutConstraint!
    
    var delegate : nameMultifactorTwoFASettingsCellDelegate?
    
    var multifactortwofasettingsCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifactortwofaSaveCallBack: ((Bool) -> ())?
    var multifactortwofausreIntreaction: ((Bool) -> ())?
    
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
        setmultifacellUI()
    }
    
    override func layoutSubviews() {
        removeObservers()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Notification Observers
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.startAnimating(notification:)), name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimating(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        
        //StopAnimatingBeforeFallbackPathNotificationMultifactorSettingsOptionCell
         NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimatingBeforeFallbackPathNotificationMultifactorSettingsCell(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotificationMultifactorSettingsCell"), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotificationMultifactorSettingsCell"), object: nil)
    }
    
    // MARK: - Animating Funtions
    
    @objc func startAnimating(notification: Notification) {
        savebuttonActivityIndicator.startAnimating()
    }
    
    @objc func stopAnimating(notification: Notification) {
        print("Chathura notfication biometric login/approva success ", notification.object as! Bool)
        savebuttonActivityIndicator.stopAnimating()
        self.multifactortwofausreIntreaction!(true)
        
        if let isSuccess = notification.object {
            showAlertNotification(isSuccess: isSuccess as! Bool)
        }
    }
    
    @objc func stopAnimatingBeforeFallbackPathNotificationMultifactorSettingsCell(notification: Bool) {
        savebuttonActivityIndicator.stopAnimating()
        multifactortwofausreIntreaction!(true)
    }
    
    func showAlertNotification(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowAlert"), object: isSuccess, userInfo: nil)
    }
    
    var multifactorsettings: MultifactorSettingsViewModel? {
        didSet {
            if let _isfallbackEnable = multifactorsettings?.isfallbackEnable {
                if _isfallbackEnable {
                    biometricloginSwitch.isUserInteractionEnabled = true
                    biometricapprovalSwitch.isUserInteractionEnabled = true
                } else {
                    biometricloginSwitch.isUserInteractionEnabled = false
                    biometricapprovalSwitch.isUserInteractionEnabled = false
                }
            }
            
            if let loginswitch = multifactorsettings?.loginSwitch {
                biometricloginSwitch.isOn = loginswitch
            }
            
            if let approvalswitch = multifactorsettings?.approvalSwitch {
                biometricapprovalSwitch.isOn = approvalswitch
            }
        }
    }
}

extension MultifactorTwoFASettingsCell {
    
    private func setmultifacellUI() {
        setmultiTwofaBase()
        setHeader()
        setSwitches()
        setOptionSeparator()
        setSaveView()
        setgapperLabel()
    }
}

//MARK: - SetupBasecontainer
extension MultifactorTwoFASettingsCell {
    
    private func setmultiTwofaBase() {
        
        multitwofaBaseContainer = UIView()
        multitwofaBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        multitwofaBaseContainer.backgroundColor = .white
        
        addSubview(multitwofaBaseContainer)
        
        let basecontainerConstraints = [multitwofaBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                        multitwofaBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        multitwofaBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                        multitwofaBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(basecontainerConstraints)
        multitwofaBaseContainer.setShadow()
    }
}

//MARK: - Setup Header UI
extension MultifactorTwoFASettingsCell {
    
    private func setHeader() {
        
        recoveryoptionBtn = UIButton()
        recoveryoptionBtn.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionBtn.backgroundColor = .white
        multitwofaBaseContainer.addSubview(recoveryoptionBtn)
        
        let recoveryoptionbtnConstraints = [recoveryoptionBtn.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor, constant: 10),
                                            recoveryoptionBtn.topAnchor.constraint(equalTo: multitwofaBaseContainer.topAnchor, constant: 25),
                                            recoveryoptionBtn.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(recoveryoptionbtnConstraints)
        
        recoveryoptionBtn.addTarget(self, action: #selector(selectRecoveryOptions(_:)), for: .touchUpInside)
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Down-arrow_tools")
        multitwofaBaseContainer.addSubview(downarrowImage)
        
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
        multitwofaBaseContainer.addSubview(recoveryoptionLabel)
        
        let recoveroptionlableConstraints = [recoveryoptionLabel.leftAnchor.constraint(equalTo: recoveryoptionBtn.leftAnchor),
                                             recoveryoptionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor),
                                             recoveryoptionLabel.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
    }
}

//MARK: - Setup Switch UI
extension MultifactorTwoFASettingsCell {
    
    private func setSwitches() {
        
        biometricloginSwitch = UISwitch()
        biometricloginSwitch.translatesAutoresizingMaskIntoConstraints = false
        biometricloginSwitch.thumbTintColor = .white
        //biometricloginSwitch.isUserInteractionEnabled = false
        biometricloginSwitch.tag = 0
        biometricloginSwitch.onTintColor = ColorTheme.switchActive
        multitwofaBaseContainer.addSubview(biometricloginSwitch)
        
        let biometricloginSwitchConstraints = [biometricloginSwitch.topAnchor.constraint(equalTo: recoveryoptionBtn.bottomAnchor, constant: 15),
                                               biometricloginSwitch.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor, constant: -10),
                                               biometricloginSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(biometricloginSwitchConstraints)
        biometricloginSwitch.addTarget(self, action: #selector(twofaSwitchAction(_:)), for: .valueChanged)
        
        
        biometricloginLabel = UILabel()
        biometricloginLabel.translatesAutoresizingMaskIntoConstraints = false
        biometricloginLabel.font = UIFont(name: "Helvetica", size: 18)
        biometricloginLabel.text = "Biometric Authentication for Login Process"
        biometricloginLabel.numberOfLines = 2
        biometricloginLabel.textColor = ColorTheme.lblBodySpecial2
        
        multitwofaBaseContainer.addSubview(biometricloginLabel)
        
        let biometricloginLabelConstraint = [biometricloginLabel.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor, constant: 10),
                                             biometricloginLabel.centerYAnchor.constraint(equalTo: biometricloginSwitch.centerYAnchor),
                                             biometricloginLabel.rightAnchor.constraint(equalTo: biometricloginSwitch.leftAnchor, constant: -5),]
        NSLayoutConstraint.activate(biometricloginLabelConstraint)
        
        biometricapprovalSwitch = UISwitch()
        biometricapprovalSwitch.translatesAutoresizingMaskIntoConstraints = false
        biometricapprovalSwitch.thumbTintColor = .white
        //biometricapprovalSwitch.isUserInteractionEnabled = false
        //biometricapprovalSwitch.isHidden = true
        biometricapprovalSwitch.tag = 1
        biometricapprovalSwitch.onTintColor = ColorTheme.switchActive
        multitwofaBaseContainer.addSubview(biometricapprovalSwitch)
        
        let biometricapprovalSwitchConstraints = [biometricapprovalSwitch.topAnchor.constraint(equalTo: biometricloginSwitch.bottomAnchor, constant: 15),
                                                  biometricapprovalSwitch.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor, constant: -10),
                                                  biometricapprovalSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(biometricapprovalSwitchConstraints)
        biometricapprovalSwitch.addTarget(self, action: #selector(twofaSwitchAction(_:)), for: .valueChanged)
        
        biometricapprovalLabel = UILabel()
        biometricapprovalLabel.translatesAutoresizingMaskIntoConstraints = false
        biometricapprovalLabel.font = UIFont(name: "Helvetica", size: 18)
        //biometricapprovalLabel.isHidden = true
        biometricapprovalLabel.numberOfLines = 2
        biometricapprovalLabel.text = "Biometric Authentication for Approval Process"
        biometricapprovalLabel.textColor = ColorTheme.lblBodySpecial2
        multitwofaBaseContainer.addSubview(biometricapprovalLabel)
        
        let biometricapprovalLabelConstraint = [biometricapprovalLabel.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor, constant: 10),
                                                biometricapprovalLabel.centerYAnchor.constraint(equalTo: biometricapprovalSwitch.centerYAnchor),
                                                biometricapprovalLabel.rightAnchor.constraint(equalTo: biometricapprovalSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(biometricapprovalLabelConstraint)
    }
}

//MARK: - Setup option separator
extension MultifactorTwoFASettingsCell {
    
    private func setOptionSeparator() {
        
        optionSeparatorView = UIView()
        optionSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        optionSeparatorView.backgroundColor = .clear
        
        multitwofaBaseContainer.addSubview(optionSeparatorView)
        
        let optionseparatorviewConstriants = [optionSeparatorView.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor),
                                              optionSeparatorView.topAnchor.constraint(equalTo: biometricapprovalSwitch.bottomAnchor, constant: 10),
                                              optionSeparatorView.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor),
                                              optionSeparatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(optionseparatorviewConstriants)
    }
}

//MARK: - Setup Save UI
extension MultifactorTwoFASettingsCell {
    
    private func setSaveView() {
        
        saveView = UIView()
        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveView.backgroundColor = .white
        
        multitwofaBaseContainer.addSubview(saveView)
        
        let saveviewConstraints = [saveView.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor),
                                   saveView.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor),
                                   saveView.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(saveviewConstraints)
        saveviewTopConstraint = saveView.topAnchor.constraint(equalTo: optionSeparatorView.bottomAnchor, constant: 5)
        saveviewTopConstraint.isActive = true
        
        saveSeparator = UIView()
        saveSeparator.translatesAutoresizingMaskIntoConstraints = false
        saveSeparator.backgroundColor = .lightGray
        saveView.addSubview(saveSeparator)
        
        let saveseparatorConstraints = [saveSeparator.leftAnchor.constraint(equalTo: saveView.leftAnchor),
                                        saveSeparator.topAnchor.constraint(equalTo: saveView.topAnchor),
                                        saveSeparator.rightAnchor.constraint(equalTo: saveView.rightAnchor),
                                        saveSeparator.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(saveseparatorConstraints)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = ColorTheme.btnBG
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        saveButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        
        saveView.addSubview(saveButton)
        
        let savebuttonConstraints = [saveButton.centerYAnchor.constraint(equalTo: saveView.centerYAnchor, constant: 5),
                                     saveButton.leftAnchor.constraint(equalTo: saveView.leftAnchor, constant: 10),
                                     saveButton.rightAnchor.constraint(equalTo: saveView.rightAnchor, constant: -10),
                                     saveButton.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(savebuttonConstraints)
        
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(twofasettingsSaveAction(_:)), for: .touchUpInside)
        
        savebuttonActivityIndicator = UIActivityIndicatorView(style: .white)
        savebuttonActivityIndicator.color = ColorTheme.activityindicatorSpecial
        savebuttonActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addSubview(savebuttonActivityIndicator)
        
        let savebuttonactivityindicatorConstraints = [savebuttonActivityIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
                                                      savebuttonActivityIndicator.rightAnchor.constraint(equalTo: saveButton.rightAnchor, constant: -10),
                                                      savebuttonActivityIndicator.widthAnchor.constraint(equalToConstant: 25),
                                                      savebuttonActivityIndicator.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(savebuttonactivityindicatorConstraints)
    }
}

//MARK: - Setup Gapper UI
extension MultifactorTwoFASettingsCell {
    private func setgapperLabel() {
        
        gapperLabel = UILabel()
        gapperLabel.translatesAutoresizingMaskIntoConstraints = false
        gapperLabel.textColor = .white
        gapperLabel.text = "..."
        
        multitwofaBaseContainer.addSubview(gapperLabel)
        
        let gapperlabelConstraints = [gapperLabel.leftAnchor.constraint(equalTo: multitwofaBaseContainer.leftAnchor),
                                      gapperLabel.rightAnchor.constraint(equalTo: multitwofaBaseContainer.rightAnchor)]
        NSLayoutConstraint.activate(gapperlabelConstraints)
        
        gapperTopConstraints = gapperLabel.topAnchor.constraint(equalTo: saveView.bottomAnchor, constant: 0)
        gapperTopConstraints.isActive = true
        
        gapperBottomConstraints = gapperLabel.bottomAnchor.constraint(equalTo: multitwofaBaseContainer.bottomAnchor, constant: 10)
        gapperBottomConstraints.isActive = true
    }
}

extension MultifactorTwoFASettingsCell {
    func removeunwantedConstraints() {
        saveviewTopConstraint.isActive = false
    }
}

//MARK: - Switch Actions
extension MultifactorTwoFASettingsCell {
    @objc
    func twofaSwitchAction(_ sender: UISwitch) {
        if sender.tag == 0 {
            multifactorsettings?.loginSwitch = sender.isOn
            multifactorsettings?.subStep = 0
            (sender.isOn) ? (multifactorsettings?.loginVerificationType = 3) : (multifactorsettings?.loginVerificationType = 1)
        } else {
            multifactorsettings?.approvalSwitch = sender.isOn
            (sender.isOn) ? (multifactorsettings?.subStep = 1) : (multifactorsettings?.subStep = 0)
        }
        multifactortwofasettingsCallBack!(multifactorsettings, false)
        return
    }
}

//MARK: - Save multi settings
extension MultifactorTwoFASettingsCell {
    @objc
    func twofasettingsSaveAction(_ sender: UIButton) {
        
        multifactortwofausreIntreaction!(false)
        savebuttonActivityIndicator.startAnimating()
        
        guard let multisettings = multifactorsettings else {
            multifactortwofausreIntreaction!(true)
            savebuttonActivityIndicator.stopAnimating()
            return
        }
        
        delegate?.onSaveBiometricSettings(multisettings: multisettings)
    }
}

//MARK: - Select recovery options method
extension MultifactorTwoFASettingsCell {
    @objc func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options selected")
        multifactorsettings?.recoveryOptionSelected = 1
        //        multifactorsettings?.recoveryOptionType = 0
        
        multifactortwofasettingsCallBack?(multifactorsettings, false)
    }
}

