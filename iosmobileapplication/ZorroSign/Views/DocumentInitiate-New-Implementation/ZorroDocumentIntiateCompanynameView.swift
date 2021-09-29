//
//  ZorroDocumentIntiateCompanynameView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentIntiateCompanynameView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var userecompanyLabel: UILabel!
}

extension ZorroDocumentIntiateCompanynameView {
    override func setsubViews() {
        setuserecompanyLabel()
        bringviewstoFront()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentIntiateCompanynameView {
    fileprivate func setuserecompanyLabel() {
        
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
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 18)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        userecompanyLabel = UILabel()
        userecompanyLabel.translatesAutoresizingMaskIntoConstraints = false
        userecompanyLabel.backgroundColor = .white
        userecompanyLabel.numberOfLines = 1
        userecompanyLabel.textAlignment = .center
        userecompanyLabel.baselineAdjustment = .alignCenters
        userecompanyLabel.adjustsFontSizeToFitWidth = true
        userecompanyLabel.minimumScaleFactor = 0.2
        backView.addSubview(userecompanyLabel)
        
        let userecompanyLabelConstraints = [userecompanyLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                         userecompanyLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                         userecompanyLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                         userecompanyLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(userecompanyLabelConstraints)
    }
}

extension ZorroDocumentIntiateCompanynameView {
    func setUserCompany(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                var usercompany = ""
                let usertyep = ZorroTempData.sharedInstance.getUserType()
                
                if usertyep == 1 {
                    usercompany = ZorroTempData.sharedInstance.getOrganizationLegalName()
                } else {
                    usercompany = ZorroTempData.sharedInstance.getCompanyName()
                }
                userecompanyLabel.text = usercompany
                userecompanyLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    userecompanyLabel.text = contacts.first?.Name
                } else {
                    userecompanyLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        } else {
            if contacts.count == 1 {
                userecompanyLabel.text = contacts.first?.Name
            } else {
                userecompanyLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}


