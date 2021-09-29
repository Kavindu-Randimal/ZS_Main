//
//  MultifactorOTPActivateCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorOTPActivatedCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    var otpoptionBaseContainer: UIView!
    var otpHeaderLabel: UILabel!
    
    var activatedphonenumberLabel: UILabel!
    var activatedchangemobilenumberButton: UIButton!
    
    var otpOptionHeaderLabel: UILabel!
    
    //MARK: - Option Switches
    var loginSwitch: UISwitch!
    var loginswitchText: UILabel!
    var approvalSwitch: UISwitch!
    var approvalswitchText: UILabel!
    
    //MARK: - Option Separator
    var optionSwitchSepratorView: UIView!
    
    //MARK: - Options
    var otpoptionView: MultifactorOptionsView!
    var otpoptionviewHeightConstraint: NSLayoutConstraint!
    
    //MARK: - Common Options Save
    var saveView: UIView!
    var saveViewTopConstraints: NSLayoutConstraint!
    var saveSeparator: UIView!
    var saveButton: UIButton!
    var saveotpbuttonActivityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Gapper Label
    var gapperLabel: UILabel!
    var gapperLabelTopConstraints: NSLayoutConstraint!
    
    var multifactorotpactivatedCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifactorotpactivatedCallBackSaveCallBack: ((Bool) -> ())?
    var multifactorotpactivatedCallBackIntreaction: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        backgroundColor = lightgray
        setcellContainer()
        setoptioncellSubviewUI()
        setSwitchOptionHeaders()
        setSwitches()
        saveotpSettingsUI()
        setgappeLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var multifactorotpactivatedsettingViewModel: MultifactorSettingsViewModel? {
        didSet {
            if let loginswitch = multifactorotpactivatedsettingViewModel?.loginSwitch, let approvalswitch = multifactorotpactivatedsettingViewModel?.approvalSwitch {
                
                loginSwitch.isOn = loginswitch
                approvalSwitch.isOn = approvalswitch
            }
            
            if let mobilenumber = multifactorotpactivatedsettingViewModel?.mobilenNumber {
                activatedphonenumberLabel.text = mobilenumber
            }
        }
    }
}

//MARK: - Set Base Container
extension MultifactorOTPActivatedCell {
    
    private func setcellContainer() {
        
        otpoptionBaseContainer = UIView()
        otpoptionBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        otpoptionBaseContainer.backgroundColor = .white
        
        addSubview(otpoptionBaseContainer)
        
        let otpoptionBaseContainerConstraints = [otpoptionBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                                otpoptionBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                                otpoptionBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                                otpoptionBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(otpoptionBaseContainerConstraints)
        otpoptionBaseContainer.setShadow()
        
        otpHeaderLabel = UILabel()
        otpHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        otpHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        otpHeaderLabel.textColor = ColorTheme.lblBodySpecial2
        otpHeaderLabel.numberOfLines = 0
        otpHeaderLabel.textAlignment = .left
        otpHeaderLabel.text = "Activate One Time Password Verification (OTP)"
        
        otpoptionBaseContainer.addSubview(otpHeaderLabel)
        
        let otpHeaderLabelConstraints = [otpHeaderLabel.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor, constant: 10),
                                          otpHeaderLabel.topAnchor.constraint(equalTo: otpoptionBaseContainer.topAnchor, constant: 20),
                                          otpHeaderLabel.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(otpHeaderLabelConstraints)
    }
}

//MARK: - Setup sub cell ui
extension MultifactorOTPActivatedCell {
    
     private func setoptioncellSubviewUI() {
        
        activatedphonenumberLabel = UILabel()
        activatedphonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
        activatedphonenumberLabel.font = UIFont(name: "Helvetica", size: 18)
        activatedphonenumberLabel.textColor = ColorTheme.lblBodySpecial2
        activatedphonenumberLabel.textAlignment = .left
        activatedphonenumberLabel.text = "+15738444268"
        
        otpoptionBaseContainer.addSubview(activatedphonenumberLabel)
        
        let activatedphonenumberlabelconstraints = [activatedphonenumberLabel.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor, constant: 10),
                                                    activatedphonenumberLabel.topAnchor.constraint(equalTo: otpHeaderLabel.bottomAnchor, constant: 25)]
        
        NSLayoutConstraint.activate(activatedphonenumberlabelconstraints)
        
        activatedchangemobilenumberButton = UIButton()
        activatedchangemobilenumberButton.translatesAutoresizingMaskIntoConstraints = false
        activatedchangemobilenumberButton.setTitleColor(ColorTheme.lblBodyDefault, for: .normal)
        activatedchangemobilenumberButton.setTitle("Change mobile number", for: .normal)
        activatedchangemobilenumberButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17)
        activatedchangemobilenumberButton.titleLabel?.textAlignment = .left
        activatedchangemobilenumberButton.contentHorizontalAlignment = .left
        activatedchangemobilenumberButton.titleLabel?.adjustsFontSizeToFitWidth = true
        activatedchangemobilenumberButton.titleLabel?.minimumScaleFactor = 0.2
        
        otpoptionBaseContainer.addSubview(activatedchangemobilenumberButton)
        
        let activatedchangemobilenumberButtonConstraints = [activatedchangemobilenumberButton.leftAnchor.constraint(equalTo: activatedphonenumberLabel.rightAnchor, constant: 5),
                                                            activatedchangemobilenumberButton.centerYAnchor.constraint(equalTo: activatedphonenumberLabel.centerYAnchor),
                                                            activatedchangemobilenumberButton.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor)]
        NSLayoutConstraint.activate(activatedchangemobilenumberButtonConstraints)
        
        activatedchangemobilenumberButton.addTarget(self, action: #selector(otpactivateChangeMobilAction(_:)), for: .touchUpInside)
        
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedText = NSAttributedString(string: activatedchangemobilenumberButton.currentTitle!, attributes: attributes)
        activatedchangemobilenumberButton.titleLabel?.attributedText = attributedText
    }
}

extension MultifactorOTPActivatedCell {
    private func setSwitchOptionHeaders() {
        
         otpOptionHeaderLabel = UILabel()
         otpOptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
         otpOptionHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        otpOptionHeaderLabel.textColor = ColorTheme.lblBodySpecial2
         otpOptionHeaderLabel.numberOfLines = 0
         otpOptionHeaderLabel.text = "Activate One Time Password Verificatin (OTP) for Login Process and Approval Process"
         
         otpoptionBaseContainer.addSubview(otpOptionHeaderLabel)
         
        
        let otpOptionHeaderLabelConstraints = [otpOptionHeaderLabel.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor, constant: 10),
                                               
                                               otpOptionHeaderLabel.topAnchor.constraint(equalTo: activatedphonenumberLabel.bottomAnchor, constant: 10), otpOptionHeaderLabel.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor, constant: -10)]
        
         NSLayoutConstraint.activate(otpOptionHeaderLabelConstraints)
    }
}

extension MultifactorOTPActivatedCell {
    private func setSwitches() {
        
        loginSwitch = UISwitch()
        loginSwitch.translatesAutoresizingMaskIntoConstraints = false
        loginSwitch.thumbTintColor = .white
        loginSwitch.tag = 0
        loginSwitch.onTintColor = ColorTheme.switchActive
        otpoptionBaseContainer.addSubview(loginSwitch)
        
        let loginSwitchConstraints = [loginSwitch.topAnchor.constraint(equalTo: otpOptionHeaderLabel.bottomAnchor, constant: 20),
                                      loginSwitch.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor, constant: -10),
                                      loginSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(loginSwitchConstraints)
        loginSwitch.addTarget(self, action: #selector(otpoptionSwitchAction(_:)), for: .valueChanged)
        
        loginswitchText = UILabel()
        loginswitchText.translatesAutoresizingMaskIntoConstraints = false
        loginswitchText.font = UIFont(name: "Helvetica", size: 18)
        loginswitchText.textColor = ColorTheme.lblBodySpecial2
        loginswitchText.textAlignment = .left
        loginswitchText.adjustsFontSizeToFitWidth = true
        loginswitchText.numberOfLines = 2
        loginswitchText.minimumScaleFactor = 0.2
        loginswitchText.text = "OTP Verification for Login Process"
        otpoptionBaseContainer.addSubview(loginswitchText)
        
        let loginswitchtextConstraints = [loginswitchText.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor, constant: 10),
                                          loginswitchText.centerYAnchor.constraint(equalTo: loginSwitch.centerYAnchor),
                                          loginswitchText.rightAnchor.constraint(equalTo: loginSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(loginswitchtextConstraints)
        
        approvalSwitch = UISwitch()
        approvalSwitch.translatesAutoresizingMaskIntoConstraints = false
        approvalSwitch.thumbTintColor = .white
        approvalSwitch.tag = 1
        approvalSwitch.onTintColor = ColorTheme.switchActive
        otpoptionBaseContainer.addSubview(approvalSwitch)
        
        let approvalSwitchConstraints = [approvalSwitch.topAnchor.constraint(equalTo: loginSwitch.bottomAnchor, constant: 10),
                                         approvalSwitch.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor, constant: -10),
                                         approvalSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(approvalSwitchConstraints)
        approvalSwitch.addTarget(self, action: #selector(otpoptionSwitchAction(_:)), for: .valueChanged)
        
        approvalswitchText = UILabel()
        approvalswitchText.translatesAutoresizingMaskIntoConstraints = false
        approvalswitchText.font = UIFont(name: "Helvetica", size: 18)
        approvalswitchText.textColor = ColorTheme.lblBodySpecial2
        approvalswitchText.textAlignment = .left
        approvalswitchText.adjustsFontSizeToFitWidth = true
        approvalswitchText.minimumScaleFactor = 0.2
        approvalswitchText.numberOfLines = 2
        approvalswitchText.text = "OTP/Password Verification for Approval Process"
        otpoptionBaseContainer.addSubview(approvalswitchText)
        
        let approvalswitchTextConstraints = [approvalswitchText.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor, constant: 10),
                                             approvalswitchText.centerYAnchor.constraint(equalTo: approvalSwitch.centerYAnchor),
                                             approvalswitchText.rightAnchor.constraint(equalTo: approvalSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(approvalswitchTextConstraints)
        
        optionSwitchSepratorView = UIView()
        optionSwitchSepratorView.translatesAutoresizingMaskIntoConstraints = false
        optionSwitchSepratorView.backgroundColor = .clear

        
        otpoptionBaseContainer.addSubview(optionSwitchSepratorView)
        
        let optionSwitchSepratorViewConstraints = [optionSwitchSepratorView.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor),
                                                   optionSwitchSepratorView.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 10),
                                                   optionSwitchSepratorView.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor),
                                                   optionSwitchSepratorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(optionSwitchSepratorViewConstraints)
    }
}

extension MultifactorOTPActivatedCell {
    
    private func saveotpSettingsUI() {
        
        saveView = UIView()
        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveView.backgroundColor = .white
        
        otpoptionBaseContainer.addSubview(saveView)
        
        let saveviewConstraints = [saveView.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor),
                                   saveView.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor),
                                   saveView.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(saveviewConstraints)
        
        saveViewTopConstraints = saveView.topAnchor.constraint(equalTo: optionSwitchSepratorView.bottomAnchor, constant: 0)
        saveViewTopConstraints.isActive = true
        
        saveSeparator = UIView()
        saveSeparator.translatesAutoresizingMaskIntoConstraints = false
        saveSeparator.backgroundColor = lightgray
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

        saveButton.addTarget(self, action: #selector(saveMultifactorOTPSettings(_:)), for: .touchUpInside)

        saveotpbuttonActivityIndicator = UIActivityIndicatorView(style: .white)
        saveotpbuttonActivityIndicator.color = ColorTheme.activityindicatorSpecial
        saveotpbuttonActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addSubview(saveotpbuttonActivityIndicator)
        
        let saveotpbuttonActivityIndicatoractivityindicatorConstraints = [saveotpbuttonActivityIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
                                                      saveotpbuttonActivityIndicator.rightAnchor.constraint(equalTo: saveButton.rightAnchor, constant: -10),
                                                      saveotpbuttonActivityIndicator.widthAnchor.constraint(equalToConstant: 25),
                                                      saveotpbuttonActivityIndicator.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(saveotpbuttonActivityIndicatoractivityindicatorConstraints)
    }
}

extension MultifactorOTPActivatedCell {
    private func setgappeLabel() {
        
        gapperLabel = UILabel()
        gapperLabel.translatesAutoresizingMaskIntoConstraints = false
        gapperLabel.textColor = .white
        gapperLabel.text = " "
        
        otpoptionBaseContainer.addSubview(gapperLabel)
        
        let gapperlabelConstraints = [gapperLabel.leftAnchor.constraint(equalTo: otpoptionBaseContainer.leftAnchor),
                                      gapperLabel.rightAnchor.constraint(equalTo: otpoptionBaseContainer.rightAnchor),
                                      gapperLabel.bottomAnchor.constraint(equalTo: otpoptionBaseContainer.bottomAnchor, constant: 10)]
        NSLayoutConstraint.activate(gapperlabelConstraints)
        
        gapperLabelTopConstraints = gapperLabel.topAnchor.constraint(equalTo: saveView.bottomAnchor, constant: 0)
        gapperLabelTopConstraints.isActive = true
    }
}

extension MultifactorOTPActivatedCell {
    func removeunwantedotpConstraints() {
        saveViewTopConstraints.isActive = false
    }
}

//MARK: - Change mobile number Action
extension MultifactorOTPActivatedCell {
    @objc
    func otpactivateChangeMobilAction(_ sender: UIButton) {
        multifactorotpactivatedsettingViewModel?.subStep = 3
        multifactorotpactivatedCallBack!(multifactorotpactivatedsettingViewModel, false)
    }
}

//MARK: Update OTP Options
extension MultifactorOTPActivatedCell {
  
    @objc
    func otpoptionSwitchAction(_ sender: UISwitch) {
        
        switch sender.tag {
        case 0:
            multifactorotpactivatedsettingViewModel?.loginSwitch = sender.isOn
            multifactorotpactivatedsettingViewModel?.loginVerificationType = (sender.isOn) ? 2 : 1
        case 1:
            multifactorotpactivatedsettingViewModel?.approvalSwitch = sender.isOn
            multifactorotpactivatedsettingViewModel?.subStep = (sender.isOn) ? 1 : 0
            
            if !sender.isOn {
                multifactorotpactivatedsettingViewModel?.approvalVerificationType = 1
            }
        default:
            return
        }
        multifactorotpactivatedCallBack!(multifactorotpactivatedsettingViewModel, false)
    }
}

//MARK: - Multifactor save settings
extension MultifactorOTPActivatedCell {
    @objc
    func saveMultifactorOTPSettings(_ sender: UIButton) {
        multifactorotpactivatedCallBackIntreaction!(false)
        saveotpbuttonActivityIndicator.startAnimating()
        let multifactorsavesettings = MultifactorSaveSettings(multifactorsettingsviewmodel: multifactorotpactivatedsettingViewModel!)
     
        multifactorsavesettings.postMultifactorSettings(multifactorsettings: multifactorsavesettings) { (success) in
            
            self.saveotpbuttonActivityIndicator.stopAnimating()
            self.multifactorotpactivatedCallBackIntreaction!(true)
            self.multifactorotpactivatedCallBackSaveCallBack!(success)
            return
        }
    }
}

