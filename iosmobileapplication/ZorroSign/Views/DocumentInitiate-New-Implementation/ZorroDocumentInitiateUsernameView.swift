//
//  ZorroDocumentInitiateUsernameView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateUsernameView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var usernameLabel: UILabel!
}

extension ZorroDocumentInitiateUsernameView {
    override func setsubViews() {
        setuserNameLabel()
        bringviewstoFront()
    }
}

//MARK: - Set username label
extension ZorroDocumentInitiateUsernameView {
    fileprivate func setuserNameLabel() {
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .clear
        containersubView.addSubview(backView)
        
        let backviewConstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 10),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(backviewConstraints)
        
        hintimageView = UIImageView()
        hintimageView.translatesAutoresizingMaskIntoConstraints = false
        hintimageView.backgroundColor = .clear
        hintimageView.contentMode = .center
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 15)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.backgroundColor = .white
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .center
        usernameLabel.baselineAdjustment = .alignCenters
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.2
        backView.addSubview(usernameLabel)
        
        let usernamelabelConstraints = [usernameLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                        usernameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                        usernameLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                        usernameLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(usernamelabelConstraints)
        usernameLabel.sizeToFit()
    }
}

extension ZorroDocumentInitiateUsernameView {
    func setUserName(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                let username = ZorroTempData.sharedInstance.getUserName()
                usernameLabel.text = username
                usernameLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    usernameLabel.text = contacts.first?.Name
                } else {
                    usernameLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
            
        } else {
            if contacts.count == 1 {
                usernameLabel.text = contacts.first?.Name
            } else {
                usernameLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}


