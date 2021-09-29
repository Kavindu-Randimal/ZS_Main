//
//  MultifactorOTPBaseCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorOTPBaseCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    var multiotpBaseContainer: UIView!
    var otpaHeaderLabel: UILabel!
    
    //MARK: - Common Option Base
    var otpOptionHeaderLabel: UILabel!
    
    //MARK: - Common Option Header
    var otpOptionHeaderTopConstraint: NSLayoutConstraint!
    
    //MARK: - Option Switches
    var loginSwitch: UISwitch!
    var loginswitchText: UILabel!
    var approvalSwitch: UISwitch!
    var approvalswitchText: UILabel!
    
    //MARK: - Option Separator
    var optionSwitchSepratorView: UIView!
        
    //MARK: - Gapper Label
    var gapperLabel: UILabel!
    var gapperLabelTopConstraints: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("THIS IS FROM MAIN VIEW : CHANAKA")
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setcellCommonUI()
        
        setupCommonOptionHeader()
        setupCommonOptionSwitches()
        setupCommonOptionSwitchSeparator()
        setupCommonGapperLabel()
        setupSubviewUI()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

//MARK: Setup Common Header
extension MultifactorOTPBaseCell {
    private func setcellCommonUI() {
        
        multiotpBaseContainer = UIView()
        multiotpBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        multiotpBaseContainer.backgroundColor = .white
        
        addSubview(multiotpBaseContainer)
        
        let multiotpBaseContainerConstraints = [multiotpBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                                multiotpBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                                multiotpBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                                multiotpBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(multiotpBaseContainerConstraints)
        multiotpBaseContainer.setShadow()
        
        otpaHeaderLabel = UILabel()
        otpaHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        otpaHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        otpaHeaderLabel.textColor = ColorTheme.lblBodySpecial2
        otpaHeaderLabel.numberOfLines = 0
        otpaHeaderLabel.textAlignment = .left
        otpaHeaderLabel.text = "Activate One Time Password Verification (OTP)"
        
        multiotpBaseContainer.addSubview(otpaHeaderLabel)
        
        let otpaHeaderLabelConstraints = [otpaHeaderLabel.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
                                          otpaHeaderLabel.topAnchor.constraint(equalTo: multiotpBaseContainer.topAnchor, constant: 20),
                                          otpaHeaderLabel.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(otpaHeaderLabelConstraints)
    }
}

//MARK: - Setup SubViews UI
extension MultifactorOTPBaseCell {
    @objc
    func setupSubviewUI() { }
}

//MARK: - Setup Common option Header
extension MultifactorOTPBaseCell {
    private func setupCommonOptionHeader() {
        
        otpOptionHeaderLabel = UILabel()
        otpOptionHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        otpOptionHeaderLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        otpOptionHeaderLabel.textColor = ColorTheme.lblBodySpecial2
        otpOptionHeaderLabel.numberOfLines = 0
        otpOptionHeaderLabel.text = "Activate One Time Password Verificatin (OTP) for Login Process and Approval Process"
        
        multiotpBaseContainer.addSubview(otpOptionHeaderLabel)
        
       
        let otpOptionHeaderLabelConstraints = [otpOptionHeaderLabel.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
                                                    
                                                    otpOptionHeaderLabel.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -10)]
        
        
        NSLayoutConstraint.activate(otpOptionHeaderLabelConstraints)
    }
}

//MARK: - Setup otp Option Switches
extension MultifactorOTPBaseCell {
    private func setupCommonOptionSwitches() {
        
        loginSwitch = UISwitch()
        loginSwitch.translatesAutoresizingMaskIntoConstraints = false
        loginSwitch.thumbTintColor = .white
        loginSwitch.tag = 0
        loginSwitch.onTintColor = ColorTheme.switchActive
        multiotpBaseContainer.addSubview(loginSwitch)
        
        let loginSwitchConstraints = [loginSwitch.topAnchor.constraint(equalTo: otpOptionHeaderLabel.bottomAnchor, constant: 20),
                                      loginSwitch.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -10),
                                      loginSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(loginSwitchConstraints)
        
        loginswitchText = UILabel()
        loginswitchText.translatesAutoresizingMaskIntoConstraints = false
        loginswitchText.font = UIFont(name: "Helvetica", size: 18)
        loginswitchText.textColor = ColorTheme.lblBodySpecial2
        loginswitchText.textAlignment = .left
        loginswitchText.adjustsFontSizeToFitWidth = true
        loginswitchText.numberOfLines = 2
        loginswitchText.minimumScaleFactor = 0.2
        loginswitchText.text = "OTP Verification for Login Process"
        multiotpBaseContainer.addSubview(loginswitchText)
        
        let loginswitchtextConstraints = [loginswitchText.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
                                          loginswitchText.centerYAnchor.constraint(equalTo: loginSwitch.centerYAnchor),
                                          loginswitchText.rightAnchor.constraint(equalTo: loginSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(loginswitchtextConstraints)
        
        approvalSwitch = UISwitch()
        approvalSwitch.translatesAutoresizingMaskIntoConstraints = false
        approvalSwitch.thumbTintColor = .white
        approvalSwitch.tag = 1
        approvalSwitch.onTintColor = ColorTheme.switchActive
        multiotpBaseContainer.addSubview(approvalSwitch)
        
        let approvalSwitchConstraints = [approvalSwitch.topAnchor.constraint(equalTo: loginSwitch.bottomAnchor, constant: 10),
                                         approvalSwitch.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -10),
                                         approvalSwitch.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(approvalSwitchConstraints)
        
        approvalswitchText = UILabel()
        approvalswitchText.translatesAutoresizingMaskIntoConstraints = false
        approvalswitchText.font = UIFont(name: "Helvetica", size: 18)
        approvalswitchText.textColor = ColorTheme.lblBodySpecial2
        approvalswitchText.textAlignment = .left
        approvalswitchText.adjustsFontSizeToFitWidth = true
        approvalswitchText.minimumScaleFactor = 0.2
        approvalswitchText.numberOfLines = 2
        approvalswitchText.text = "OTP/Password Verification for Approval Process"
        multiotpBaseContainer.addSubview(approvalswitchText)
        
        let approvalswitchTextConstraints = [approvalswitchText.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 10),
                                             approvalswitchText.centerYAnchor.constraint(equalTo: approvalSwitch.centerYAnchor),
                                             approvalswitchText.rightAnchor.constraint(equalTo: approvalSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(approvalswitchTextConstraints)
    }
}

//MARK: - Setup Option Switch Separtor
extension MultifactorOTPBaseCell {
    private func setupCommonOptionSwitchSeparator() {
        
        optionSwitchSepratorView = UIView()
        optionSwitchSepratorView.translatesAutoresizingMaskIntoConstraints = false
        optionSwitchSepratorView.backgroundColor = .clear

        
        multiotpBaseContainer.addSubview(optionSwitchSepratorView)
        
        let optionSwitchSepratorViewConstraints = [optionSwitchSepratorView.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor),
                                                   optionSwitchSepratorView.topAnchor.constraint(equalTo: approvalSwitch.bottomAnchor, constant: 10),
                                                   optionSwitchSepratorView.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor),
                                                   optionSwitchSepratorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(optionSwitchSepratorViewConstraints)
    }
}

//MARK: - Setup Common Gapper Label
extension MultifactorOTPBaseCell {
    private func setupCommonGapperLabel() {
        
        gapperLabel = UILabel()
        gapperLabel.translatesAutoresizingMaskIntoConstraints = false
        gapperLabel.textColor = .white
        gapperLabel.text = " "
        
        multiotpBaseContainer.addSubview(gapperLabel)
        
        let gapperlabelConstraints = [gapperLabel.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor),
                                      gapperLabel.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor),
                                      gapperLabel.bottomAnchor.constraint(equalTo: multiotpBaseContainer.bottomAnchor, constant: 10)]
        NSLayoutConstraint.activate(gapperlabelConstraints)
        
        gapperLabelTopConstraints = gapperLabel.topAnchor.constraint(equalTo: optionSwitchSepratorView.bottomAnchor, constant: 0)
        gapperLabelTopConstraints.isActive = true
    }
}

//MARK: - Update Gapper Top Constraints
extension MultifactorOTPBaseCell {
    func updateotpgapperTopConstraints() {
//        gapperLabelTopConstraints = gapperLabel.topAnchor.constraint(equalTo: optionSwitchSepratorView.bottomAnchor, constant: -5)
//        gapperLabelTopConstraints.isActive = true
    }
}


