//
//  ZorroDocumentInitiatePhonenumView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiatePhonenumView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var userphonenumberLabel: UILabel!
}

extension ZorroDocumentInitiatePhonenumView {
    override func setsubViews() {
        setuserphonenumberLabel()
        bringviewstoFront()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiatePhonenumView {
    fileprivate func setuserphonenumberLabel() {
        
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
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 20)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        userphonenumberLabel = UILabel()
        userphonenumberLabel.translatesAutoresizingMaskIntoConstraints = false
        userphonenumberLabel.backgroundColor = .white
        userphonenumberLabel.numberOfLines = 1
        userphonenumberLabel.textAlignment = .center
        userphonenumberLabel.baselineAdjustment = .alignCenters
        userphonenumberLabel.adjustsFontSizeToFitWidth = true
        userphonenumberLabel.minimumScaleFactor = 0.2
        backView.addSubview(userphonenumberLabel)
        
        let userphonenumberLabelConstraints = [userphonenumberLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                            userphonenumberLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                            userphonenumberLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                            userphonenumberLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(userphonenumberLabelConstraints)
    }
}

extension ZorroDocumentInitiatePhonenumView {
    func setUserPhoneNumbertitle(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                let useremail = ZorroTempData.sharedInstance.getPhoneNumber()
                userphonenumberLabel.text = useremail
                userphonenumberLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    userphonenumberLabel.text = contacts.first?.Name
                } else {
                    userphonenumberLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        } else {
            if contacts.count == 1 {
                userphonenumberLabel.text = contacts.first?.Name
            } else {
                userphonenumberLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}



