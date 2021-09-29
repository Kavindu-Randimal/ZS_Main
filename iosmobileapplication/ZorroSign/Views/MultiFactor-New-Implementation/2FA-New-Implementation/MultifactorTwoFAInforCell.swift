//
//  2FAInforCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorTwoFAInforCell: MultifactorTwoFABaseCell {
    
    private var inforiconImage: UIImageView!
    private var inforLabel: UILabel!
    
    var multifactortwofaInfoCallBack: (() -> ())?
}

extension MultifactorTwoFAInforCell {
    
    override func setCellUI() {
        
        inforiconImage = UIImageView()
        inforiconImage.translatesAutoresizingMaskIntoConstraints = false
        inforiconImage.image = UIImage(named: "info")
        inforiconImage.contentMode = .center
        baseContainer.addSubview(inforiconImage)
        
        let inforiconimageConstraints = [inforiconImage.leftAnchor.constraint(equalTo: baseContainer.leftAnchor, constant: 10),
                                         inforiconImage.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 10), inforiconImage.widthAnchor.constraint(equalToConstant: 30),
                                         inforiconImage.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(inforiconimageConstraints)
        
        inforLabel = UILabel()
        inforLabel.translatesAutoresizingMaskIntoConstraints = false
        inforLabel.font = UIFont(name: "Helvetica", size: 18)
        inforLabel.textColor = ColorTheme.lblBodySpecial2
        inforLabel.numberOfLines = 0
        inforLabel.isUserInteractionEnabled = true
        let _attributedText = inforLabel.attributedText(withString: "Please active Biometric Authentication from Manage Biometric. Once Completed, you will be able to select other options.", boldString: ["Manage Biometric"], font: UIFont(name: "Helvetica", size: 16)!, underline: true)
        inforLabel.attributedText = _attributedText
        baseContainer.addSubview(inforLabel)
        
        let infotapgesture = UITapGestureRecognizer(target: self, action: #selector(manageBiometrics(_:)))
        inforLabel.addGestureRecognizer(infotapgesture)
        
        let inforlabelConstraints = [inforLabel.leftAnchor.constraint(equalTo: inforiconImage.rightAnchor, constant: 10),
                                     inforLabel.topAnchor.constraint(equalTo: baseContainer.topAnchor, constant: 15),
                                     inforLabel.rightAnchor.constraint(equalTo: baseContainer.rightAnchor, constant: -10),
                                     inforLabel.bottomAnchor.constraint(equalTo: baseContainer.bottomAnchor, constant: -15)]
        NSLayoutConstraint.activate(inforlabelConstraints)
    }
}

//MARK: - Manage biometric
extension MultifactorTwoFAInforCell {
    @objc func manageBiometrics(_ recognizer: UITapGestureRecognizer) {
        
        let _fullText = "Please active Biometric Authentication from Manage Biometric. Once Completed, you will be able to select other options."
        let _rangeOneText = "Manage Biometric"
        
        let _rangeOne = (_fullText as NSString).range(of: _rangeOneText)
        
        if recognizer.didTapAttributedTextInLabel(label: inforLabel, inRange: _rangeOne) {
            multifactortwofaInfoCallBack!()
            return
        }
    }
}

