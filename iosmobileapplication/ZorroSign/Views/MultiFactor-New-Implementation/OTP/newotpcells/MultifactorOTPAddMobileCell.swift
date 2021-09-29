//
//  MultifactorOTPAddMobileCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ADCountryPicker

class MultifactorOTPAddMobileCell: MultifactorOTPBaseCell {
    
    var changemobileNumberView: UIView!
    var changemobilenumberCountryImage: UIImageView!
    var changemobilenumberCountryCode: UILabel!
    var changemobilenumberPhonetextField: UITextField!
    var changemobilenumberSaveSendButton: UIButton!
    var changemobilenumberActivitiInticator: UIActivityIndicatorView!
    
    var multifactorotpaddmobilecellCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    var multifactorotpaddmobileChangeCountry: (() -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var multifactorotpaddmobileSettingsViewModel: MultifactorSettingsViewModel? {
        didSet {
            //MARK: - Bind Data
            changemobilenumberCountryImage.image = setcountryImage(countryCode: "US")
            if let countrycode = multifactorotpaddmobileSettingsViewModel?.countryCode {
                changemobilenumberCountryImage.image = setcountryImage(countryCode: countrycode)
            }
            
            changemobilenumberCountryCode.text = "+1"
            if let dialcode = multifactorotpaddmobileSettingsViewModel?.countryDialcode {
                changemobilenumberCountryCode.text = dialcode
            }
            
            //MARK: - Update UI
            loginSwitch.isEnabled = false
            approvalSwitch.isEnabled = false
        }
    }
}

extension MultifactorOTPAddMobileCell {
    override func setupSubviewUI() {
        
        changemobileNumberView = UIView()
        changemobileNumberView.translatesAutoresizingMaskIntoConstraints = false
        multiotpBaseContainer.addSubview(changemobileNumberView)
        
        let changemobilenumberviewConstraints = [changemobileNumberView.leftAnchor.constraint(equalTo: multiotpBaseContainer.leftAnchor, constant: 5),
                                                 changemobileNumberView.rightAnchor.constraint(equalTo: multiotpBaseContainer.rightAnchor, constant: -5),
                                                 changemobileNumberView.topAnchor.constraint(equalTo: otpaHeaderLabel.bottomAnchor, constant: 5),
                                                 changemobileNumberView.heightAnchor.constraint(equalToConstant: 110)]
        NSLayoutConstraint.activate(changemobilenumberviewConstraints)
        
        
        changemobilenumberCountryImage = UIImageView()
        changemobilenumberCountryImage.translatesAutoresizingMaskIntoConstraints = false
        changemobilenumberCountryImage.backgroundColor = .white
        changemobilenumberCountryImage.contentMode = .scaleAspectFit
        changemobilenumberCountryImage.isUserInteractionEnabled = true
        changemobileNumberView.addSubview(changemobilenumberCountryImage)
        
        let changemobilenumberimageConstraints = [changemobilenumberCountryImage.topAnchor.constraint(equalTo: changemobileNumberView.topAnchor, constant: 5),
                                                  changemobilenumberCountryImage.leftAnchor.constraint(equalTo: changemobileNumberView.leftAnchor, constant: 5),
                                                  changemobilenumberCountryImage.widthAnchor.constraint(equalToConstant: 60),
                                                  changemobilenumberCountryImage.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(changemobilenumberimageConstraints)
        let changecountrycodetapgesture = UITapGestureRecognizer(target: self, action: #selector(changeCountryCode(_:)))
        changemobilenumberCountryImage.addGestureRecognizer(changecountrycodetapgesture)
        
        changemobilenumberCountryCode = UILabel()
        changemobilenumberCountryCode.translatesAutoresizingMaskIntoConstraints = false
        changemobilenumberCountryCode.textAlignment = .left
        changemobilenumberCountryCode.font = UIFont(name: "Helvetica", size: 18)
        changemobilenumberCountryCode.text = "+1345"
        changemobilenumberCountryCode.numberOfLines = 1
        
        changemobileNumberView.addSubview(changemobilenumberCountryCode)
        
        
        let changemobilenumbercountrycodeConstraints = [changemobilenumberCountryCode.centerYAnchor.constraint(equalTo: changemobilenumberCountryImage.centerYAnchor),
                                                        changemobilenumberCountryCode.leftAnchor.constraint(equalTo: changemobilenumberCountryImage.rightAnchor, constant: 5)]
        NSLayoutConstraint.activate(changemobilenumbercountrycodeConstraints)
        
        changemobilenumberPhonetextField = UITextField()
        changemobilenumberPhonetextField.translatesAutoresizingMaskIntoConstraints = false
        changemobilenumberPhonetextField.font = UIFont(name: "Helvetica", size: 18)
        changemobilenumberPhonetextField.textAlignment = .left
        changemobilenumberPhonetextField.borderStyle = .roundedRect
        changemobilenumberPhonetextField.keyboardType = .phonePad
        
        changemobileNumberView.addSubview(changemobilenumberPhonetextField)
        
        let changemobilenumberphoentextfieldConstraints = [
            changemobilenumberPhonetextField.topAnchor.constraint(equalTo: changemobilenumberCountryImage.topAnchor),
            changemobilenumberPhonetextField.rightAnchor.constraint(equalTo: changemobileNumberView.rightAnchor, constant: -5),
            changemobilenumberPhonetextField.bottomAnchor.constraint(equalTo: changemobilenumberCountryImage.bottomAnchor),
            changemobilenumberPhonetextField.leftAnchor.constraint(equalTo: changemobilenumberCountryCode.rightAnchor, constant: 5)]
        NSLayoutConstraint.activate(changemobilenumberphoentextfieldConstraints)
        
        changemobilenumberSaveSendButton = UIButton()
        changemobilenumberSaveSendButton.translatesAutoresizingMaskIntoConstraints = false
        changemobilenumberSaveSendButton.backgroundColor = ColorTheme.btnBG
        changemobilenumberSaveSendButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        changemobilenumberSaveSendButton.setTitle("SAVE & SEND CODE", for: .normal)
        changemobilenumberSaveSendButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        changemobilenumberSaveSendButton.titleLabel?.adjustsFontSizeToFitWidth = true
        changemobilenumberSaveSendButton.titleLabel?.minimumScaleFactor = 0.2
        changemobilenumberSaveSendButton.titleLabel?.textAlignment = .center

        changemobileNumberView.addSubview(changemobilenumberSaveSendButton)

        let changemobilenumberSaveSendButtonConstraints = [changemobilenumberSaveSendButton.leftAnchor.constraint(equalTo: changemobileNumberView.leftAnchor, constant: 5),
                                              changemobilenumberSaveSendButton.topAnchor.constraint(equalTo: changemobilenumberPhonetextField.bottomAnchor, constant: 10),
                                              changemobilenumberSaveSendButton.rightAnchor.constraint(equalTo: changemobileNumberView.rightAnchor, constant: -5),
                                              changemobilenumberSaveSendButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(changemobilenumberSaveSendButtonConstraints)

        changemobilenumberSaveSendButton.setShadow()
        changemobilenumberSaveSendButton.addTarget(self, action: #selector(saveandsendcodeAction(_:)), for: .touchUpInside)
        
        changemobilenumberActivitiInticator = UIActivityIndicatorView(style: .white)
        changemobilenumberActivitiInticator.color = ColorTheme.activityindicatorSpecial
        changemobilenumberActivitiInticator.translatesAutoresizingMaskIntoConstraints = false
        changemobilenumberSaveSendButton.addSubview(changemobilenumberActivitiInticator)
        
        let changemobilenumberActivityindicatorConstraints = [changemobilenumberActivitiInticator.centerYAnchor.constraint(equalTo: changemobilenumberSaveSendButton.centerYAnchor),
                                                      changemobilenumberActivitiInticator.rightAnchor.constraint(equalTo: changemobilenumberSaveSendButton.rightAnchor, constant: -10),
                                                      changemobilenumberActivitiInticator.widthAnchor.constraint(equalToConstant: 25),
                                                      changemobilenumberActivitiInticator.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(changemobilenumberActivityindicatorConstraints)
        
        
        otpOptionHeaderTopConstraint = otpOptionHeaderLabel.topAnchor.constraint(equalTo: changemobileNumberView.bottomAnchor, constant: 10)
        otpOptionHeaderTopConstraint.isActive = true
        updateotpgapperTopConstraints()
    }
}

//MARK: - Button Actions
extension MultifactorOTPAddMobileCell {
    @objc
    private func saveandsendcodeAction(_ sender: UIButton) {
        
        guard let countrycode = changemobilenumberCountryCode.text else { return }
        guard let mobilenumber = changemobilenumberPhonetextField.text else { return }
        
        changemobilenumberActivitiInticator.startAnimating()
        
        let fullmobile = countrycode + mobilenumber
        
        let otponboard = OTPOnBoard(mobileNumber: fullmobile)
        otponboard.onboardusertoOTP(otponboard: otponboard) { (onboared) in
            
            self.changemobilenumberActivitiInticator.stopAnimating()
            if onboared {
                self.multifactorotpaddmobileSettingsViewModel?.mobilenNumber = fullmobile
                self.multifactorotpaddmobileSettingsViewModel?.subStep = 4
                self.multifactorotpaddmobilecellCallBack!(self.multifactorotpaddmobileSettingsViewModel, false)
            }
            return
        }
        return
    }
}

//MARK: - Country Image Gesture Action
extension MultifactorOTPAddMobileCell {
    @objc
    private func changeCountryCode(_ recognizer: UIGestureRecognizer) {
        multifactorotpaddmobileChangeCountry!()
        return
    }
}

//MARK: - Setup Country Image
extension MultifactorOTPAddMobileCell {
    private func setcountryImage(countryCode: String) -> UIImage? {
        let bundle = "assets.bundle/"
        let image = UIImage(named: bundle + countryCode + ".png",
        in: Bundle(for: ADCountryPicker.self), compatibleWith: nil)
        
        return image ?? nil
    }
}


