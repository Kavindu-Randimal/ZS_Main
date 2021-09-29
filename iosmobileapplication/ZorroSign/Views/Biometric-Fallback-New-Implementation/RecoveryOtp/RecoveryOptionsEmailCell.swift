//
//  RecoveryEmailCell.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RecoveryOptionsEmailCell: UITableViewCell {
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var recoveryoptionEmailBaseContainer: UIView!
    private var recoeveryemailOption: RecoveryEmailOptionRadioBtnView!
    private var recoeveryquestionoption: RecoveryQuestionOptionRadioBtnView!
    private var recoveryoptionBtn: UIButton!
    private var downarrowImage: UIImageView!
    private var recoveryoptionLabel: UILabel!
    private var textField: UITextField!
    private var sendcodeBtn: UIButton!
    private var gapLabel: UILabel!
    
    private var secondaryEmail: String!
    var multifactortwofasettingsCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var showAlert: ((String) -> ())?
    
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
        setenteremailcellUI()
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

//MARK: - Recovery Email Cell Ui
extension RecoveryOptionsEmailCell {
    private func setenteremailcellUI() {
        
        setEmailOptionBaseContainer()
        setHeader()
        setRecoveryEmailOption()
        setTextField()
        setButton()
        setSecurityQuestionOption()
        setGapper()
    }
}

//MARK: - Set email base container
extension RecoveryOptionsEmailCell {
    private func setEmailOptionBaseContainer() {
        
        recoveryoptionEmailBaseContainer = UIView()
        recoveryoptionEmailBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionEmailBaseContainer.backgroundColor = .white
        
        addSubview(recoveryoptionEmailBaseContainer)
        
        let basecontainerConstraints = [recoveryoptionEmailBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                        recoveryoptionEmailBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        recoveryoptionEmailBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                        recoveryoptionEmailBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(basecontainerConstraints)
        recoveryoptionEmailBaseContainer.setShadow()
    }
}

//MARK: - Setup Header UI
extension RecoveryOptionsEmailCell {
    
    private func setHeader() {
        
        recoveryoptionBtn = UIButton()
        recoveryoptionBtn.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionBtn.backgroundColor = .white
        recoveryoptionEmailBaseContainer.addSubview(recoveryoptionBtn)
        
        let recoveryoptionbtnConstraints = [recoveryoptionBtn.leftAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.leftAnchor, constant: 10),
                                            recoveryoptionBtn.topAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.topAnchor, constant: 15),
                                            recoveryoptionBtn.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(recoveryoptionbtnConstraints)
        
        recoveryoptionBtn.addTarget(self, action: #selector(selectRecoveryOptions(_:)), for: .touchUpInside)
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Up-Arrow_tools")
        recoveryoptionEmailBaseContainer.addSubview(downarrowImage)
        
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
        recoveryoptionEmailBaseContainer.addSubview(recoveryoptionLabel)
        
        let recoveroptionlableConstraints = [recoveryoptionLabel.leftAnchor.constraint(equalTo: recoveryoptionBtn.leftAnchor),
                                             recoveryoptionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor),
                                             recoveryoptionLabel.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
    }
}

//MARK: - Set recoevry email option
extension RecoveryOptionsEmailCell {
    private func setRecoveryEmailOption() {
        
        recoeveryemailOption = RecoveryEmailOptionRadioBtnView(optiontexts: ["Recovery Email Address"])
        recoeveryemailOption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryemailOption.backgroundColor = .white
        recoveryoptionEmailBaseContainer.addSubview(recoeveryemailOption)
        
        let recoveryoptionsviewConstraints = [recoeveryemailOption.leftAnchor.constraint(equalTo:recoveryoptionEmailBaseContainer.leftAnchor,constant: 15),
                                              recoeveryemailOption.topAnchor.constraint(equalTo: recoveryoptionBtn.bottomAnchor,constant: 5),
                                              recoeveryemailOption.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor,constant: -5),
                                              recoeveryemailOption.heightAnchor.constraint(equalToConstant: 40 )]
        NSLayoutConstraint.activate(recoveryoptionsviewConstraints)
        
    }
}

//MARK: - Set text field
extension RecoveryOptionsEmailCell {
    private func setTextField() {
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter email here"
        recoveryoptionEmailBaseContainer.addSubview(textField)
        
        let textfieldConstraints = [textField.leftAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.leftAnchor, constant: 50),
                                    textField.topAnchor.constraint(equalTo: recoeveryemailOption.bottomAnchor, constant: 5),
                                    textField.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor, constant: -15),
                                    textField.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        textField.layer.shadowRadius = 1.5;
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        textField.layer.shadowOpacity = 0.9
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8
        
        textField.addTarget(self, action: #selector(textFieldValuechanged(_:)), for: .editingChanged)
    }
}

//MARK: - Set button
extension RecoveryOptionsEmailCell {
    private func setButton() {
        
        sendcodeBtn = UIButton()
        sendcodeBtn.translatesAutoresizingMaskIntoConstraints = false
        sendcodeBtn.backgroundColor = ColorTheme.btnBG
        sendcodeBtn.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        sendcodeBtn.setTitle("SEND CODE", for: .normal)
        sendcodeBtn.titleLabel?.font = UIFont(name: "Helvetica", size: 17)
        sendcodeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        sendcodeBtn.titleLabel?.minimumScaleFactor = 0.2
        
        
        recoveryoptionEmailBaseContainer.addSubview(sendcodeBtn)
        
        let activesendcodeButtonConstraints = [sendcodeBtn.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor, constant: -15),
                                               sendcodeBtn.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
                                               sendcodeBtn.widthAnchor.constraint(equalToConstant: 120),
                                               sendcodeBtn.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(activesendcodeButtonConstraints)
        
        sendcodeBtn.setShadow()
        sendcodeBtn.addTarget(self, action: #selector(sendCodeAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Set security question
extension RecoveryOptionsEmailCell {
    private func setSecurityQuestionOption() {
        
        recoeveryquestionoption = RecoveryQuestionOptionRadioBtnView(optiontexts: ["Security Questions"])
        recoeveryquestionoption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryquestionoption.backgroundColor = .white
        recoveryoptionEmailBaseContainer.addSubview(recoeveryquestionoption)
        
        let recoveryquestionsviewConstraints = [recoeveryquestionoption.leftAnchor.constraint(equalTo:recoveryoptionEmailBaseContainer.leftAnchor,constant: 15),
                                                recoeveryquestionoption.topAnchor.constraint(equalTo: sendcodeBtn.bottomAnchor,constant: 10),
                                                recoeveryquestionoption.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor,constant: -5),
                                                recoeveryquestionoption.heightAnchor.constraint(equalToConstant: 40 )]
        NSLayoutConstraint.activate(recoveryquestionsviewConstraints)
        
        recoeveryquestionoption.optionviewCallBack =  { [weak self] (questionSelected) in
            if questionSelected {
                print("Chathura fallback questions email cell")
                self?.textField.text = ""
                self?.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self?.recoveryoptionsFallback?.recoveryOptionType = 2
                self?.multifactortwofasettingsCallBack!(self!.recoveryoptionsFallback, false)
            }
            return
        }
    }
}

//MARK: - Set gapper label
extension RecoveryOptionsEmailCell {
    private func setGapper() {
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionEmailBaseContainer.addSubview(gapLabel)
        gapLabel.text = "..."
        gapLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            gapLabel.leftAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.leftAnchor),
            gapLabel.topAnchor.constraint(equalTo: recoeveryquestionoption.bottomAnchor),
            gapLabel.rightAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.rightAnchor),
            gapLabel.bottomAnchor.constraint(equalTo: recoveryoptionEmailBaseContainer.bottomAnchor)
        ])
        
    }
}

//MARK: - TextField delegte methods
extension RecoveryOptionsEmailCell: UITextFieldDelegate {
    @objc fileprivate func textFieldValuechanged(_ textField:UITextField){
        print("Chathura fall back email value ",textField.text)
        secondaryEmail = textField.text
        return
    }
}

//MARK: - Send Code Button Actions
extension RecoveryOptionsEmailCell {
    @objc
    private func sendCodeAction(_ sender: UIButton) {
        let userid = ZorroTempData.sharedInstance.getUserEmail()
        
        guard secondaryEmail != nil else {
            showAlert!("Please enter a email address")
            return
        }
        
        let fallbackotpRequest = FallbackOTPRequest(SecondaryEmail: self.secondaryEmail, UserId: userid)
        fallbackotpRequest.requestuserotpWithSecondaryEmail(otprequestwithemail: fallbackotpRequest) { (requested) in
            if requested {
                ZorroTempData.sharedInstance.setSecondaryEmail(secondaryemail: self.secondaryEmail)
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

//MARK: - Select recovery options method
extension RecoveryOptionsEmailCell {
    @objc func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options deselect 2")
        if let recoveryoptionSelected = recoveryoptionsFallback?.recoveryOptionSelected {
            if recoveryoptionSelected == 0 {
                recoveryoptionsFallback?.recoveryOptionSelected = 1
//                recoveryoptionsFallback?.recoveryOptionType = 0
            } else {
                recoveryoptionsFallback?.recoveryOptionSelected = 0
//                recoveryoptionsFallback?.recoveryOptionType = 0
            }
        }
        multifactortwofasettingsCallBack!(recoveryoptionsFallback, false)
    }
}
