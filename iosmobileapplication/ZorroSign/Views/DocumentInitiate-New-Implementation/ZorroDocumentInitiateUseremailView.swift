//
//  ZorroDocumentInitiateUseremailView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateUseremailView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var useremailLabel: UILabel!
}

extension ZorroDocumentInitiateUseremailView {
    override func setsubViews() {
        setuseremailLabel()
        bringviewstoFront()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiateUseremailView {
    fileprivate func setuseremailLabel() {
        
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
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 17)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        useremailLabel = UILabel()
        useremailLabel.translatesAutoresizingMaskIntoConstraints = false
        useremailLabel.backgroundColor = .white
        useremailLabel.numberOfLines = 1
        useremailLabel.textAlignment = .center
        useremailLabel.baselineAdjustment = .alignCenters
        useremailLabel.adjustsFontSizeToFitWidth = true
        useremailLabel.minimumScaleFactor = 0.2
        backView.addSubview(useremailLabel)
        
        let useremailLabelConstraints = [useremailLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                        useremailLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                        useremailLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                        useremailLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(useremailLabelConstraints)
    }
}

extension ZorroDocumentInitiateUseremailView {
    func setUserEmail(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                let useremail = ZorroTempData.sharedInstance.getUserEmail()
                useremailLabel.text = useremail
                useremailLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    useremailLabel.text = contacts.first?.Name
                } else {
                    useremailLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        } else {
            if contacts.count == 1 {
                useremailLabel.text = contacts.first?.Name
            } else {
                useremailLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}


