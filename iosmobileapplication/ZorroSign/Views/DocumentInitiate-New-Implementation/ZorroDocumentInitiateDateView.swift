//
//  ZorroDocumentInitiateDateView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateDateView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var userdateLabel: UILabel!
}

extension ZorroDocumentInitiateDateView {
    override func setsubViews() {
        setuserdateLabel()
        bringviewstoFront()
    }
}

//MARK: - Set username label
extension ZorroDocumentInitiateDateView {
    fileprivate func setuserdateLabel() {
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .clear
        containersubView.addSubview(backView)
        
        let backviewConstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 10),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(backviewConstraints)
        
        userdateLabel = UILabel()
        userdateLabel.translatesAutoresizingMaskIntoConstraints = false
        userdateLabel.backgroundColor = .white
        userdateLabel.numberOfLines = 1
        userdateLabel.textAlignment = .center
        userdateLabel.baselineAdjustment = .alignCenters
        userdateLabel.adjustsFontSizeToFitWidth = true
        userdateLabel.minimumScaleFactor = 0.2
        backView.addSubview(userdateLabel)
        
        let userdateLabelConstraints = [userdateLabel.leftAnchor.constraint(equalTo: backView.leftAnchor, constant: 5),
                                        userdateLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
                                        userdateLabel.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -5),
                                        userdateLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(userdateLabelConstraints)
    }
}

//MARK: - Set contacts
extension ZorroDocumentInitiateDateView {
    func setUserDate(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        var datestring: String?
        var timestamp: Int?
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                
                let today = Date()
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "MM/dd/yyyy"
                datestring = dateformatter.string(from: today)
                timestamp = Int(today.timeIntervalSince1970)
                
                userdateLabel.text = datestring
                userdateLabel.backgroundColor = .clear
            } else {
                if contacts.count == 1 {
                    if let username = contacts.first?.Name {
                        userdateLabel.text = getuserInitials(username: username)
                    }
                } else {
                    userdateLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
            
        } else {
            if contacts.count == 1 {
                if let username = contacts.first?.Name {
                    userdateLabel.text = getuserInitials(username: username)
                }
            } else {
                userdateLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
        
        extrametadata = SaveExtraMetaData(SignatureId: nil, CheckState: nil
            , DateFormat: "MM/dd/yyyy", IsDateAuto: true, IsTimeOnly: false, IsWithTime: false, TagText: datestring, TimeFormat: "hh:mm a", TimeStamp: timestamp, AttachmentCount: nil, AttachmentDiscription: nil, AddedBy: nil, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: nil)
    }
}

//MARK: - Set Initials
extension ZorroDocumentInitiateDateView {
    private func getuserInitials(username: String) -> String {
        var initials = ""
        let splitted = username.split(separator: " ")
        
        let firstnameexist = splitted.indices.contains(0)
        if firstnameexist {
            if let firstcharacter = splitted[0].first {
                initials.append(firstcharacter)
            }
        }
        
        let secondnameexist = splitted.indices.contains(1)
        if secondnameexist {
            if let secondcharacter = splitted[1].first {
                initials.append(secondcharacter)
            }
        }
        
        return initials
    }
}
