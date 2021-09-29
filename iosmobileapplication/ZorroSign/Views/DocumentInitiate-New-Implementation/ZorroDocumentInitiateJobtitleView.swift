//
//  ZorroDocumentInitiateJobtitleView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateJobtitleView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var userjobtitleLabel: UILabel!
}

extension ZorroDocumentInitiateJobtitleView {
    override func setsubViews() {
        setuserjobtitleLabel()
        bringviewstoFront()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiateJobtitleView {
    fileprivate func setuserjobtitleLabel() {
        
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
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 19)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        userjobtitleLabel = UILabel()
        userjobtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userjobtitleLabel.backgroundColor = .white
        userjobtitleLabel.numberOfLines = 1
        userjobtitleLabel.textAlignment = .center
        userjobtitleLabel.baselineAdjustment = .alignCenters
        userjobtitleLabel.adjustsFontSizeToFitWidth = true
        userjobtitleLabel.minimumScaleFactor = 0.2
        backView.addSubview(userjobtitleLabel)
        
        let userjobtitleLabelConstraints = [userjobtitleLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                         userjobtitleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                         userjobtitleLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                         userjobtitleLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(userjobtitleLabelConstraints)
    }
}

extension ZorroDocumentInitiateJobtitleView {
    func setUserJobtitle(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                let useremail = ZorroTempData.sharedInstance.getJobTitle()
                userjobtitleLabel.text = useremail
                userjobtitleLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    userjobtitleLabel.text = contacts.first?.Name
                } else {
                    userjobtitleLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        } else {
            if contacts.count == 1 {
                userjobtitleLabel.text = contacts.first?.Name
            } else {
                userjobtitleLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}



