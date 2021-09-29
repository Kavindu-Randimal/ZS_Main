//
//  ZorroDocumentInitiateTextView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateTextView: ZorroDocumentInitiateBaseView {
    private var usertextView: UITextView!
    private var usernameLabel: UILabel!
}

extension ZorroDocumentInitiateTextView {
    override func setsubViews() {
        setusertextView()
        setusernameLabel()
        bringviewstoFront()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiateTextView {
    fileprivate func setusertextView() {
        usertextView = UITextView()
        usertextView.translatesAutoresizingMaskIntoConstraints = false
        usertextView.backgroundColor = .clear
        usertextView.font = UIFont(name: "Helvetica", size: 17)
        containersubView.addSubview(usertextView)
        
        let usertextViewConstraints = [usertextView.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                       usertextView.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                       usertextView.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                       usertextView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(usertextViewConstraints)
    }
}

extension ZorroDocumentInitiateTextView {
    fileprivate func setusernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .left
        usernameLabel.backgroundColor = .white
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.isHidden = true
        usernameLabel.minimumScaleFactor = 0.2
        containersubView.addSubview(usernameLabel)
        
        let usernamelabelConstraints = [usernameLabel.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 5),
                                        usernameLabel.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                        usernameLabel.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: 0),
                                        usernameLabel.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(usernamelabelConstraints)
    }
}

extension ZorroDocumentInitiateTextView {
    func setText(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                usernameLabel.isHidden = true
                usertextView.isEditable = true
            } else {
                usernameLabel.isHidden = false
                usertextView.isEditable = false
                if contacts.count == 1 {
                    usernameLabel.text = contacts.first?.Name
                } else {
                    usernameLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
            
        } else {
            usernameLabel.isHidden = false
            usertextView.isEditable = false
            if contacts.count == 1 {
                usernameLabel.text = contacts.first?.Name
            } else {
                usernameLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}



