//
//  ZorroDocumentInitiateCcView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/22/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateCcView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var usercctitleLabel: UILabel!
}

extension ZorroDocumentInitiateCcView {
    override func setsubViews() {
        setusercctitleLabel()
        bringviewstoFront()
        removeResizer()
        removepanGesture()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiateCcView {
    fileprivate func setusercctitleLabel() {
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .clear
        containersubView.addSubview(backView)
        
        let backviewConstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 10),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 5),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(backviewConstraints)
        
        hintimageView = UIImageView()
        hintimageView.translatesAutoresizingMaskIntoConstraints = false
        hintimageView.backgroundColor = .clear
        hintimageView.contentMode = .center
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 9)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        usercctitleLabel = UILabel()
        usercctitleLabel.translatesAutoresizingMaskIntoConstraints = false
        usercctitleLabel.backgroundColor = .white
        usercctitleLabel.adjustsFontSizeToFitWidth = true
        usercctitleLabel.minimumScaleFactor = 0.2
        backView.addSubview(usercctitleLabel)
        
        let usercctitleLabelConstraints = [usercctitleLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                            usercctitleLabel.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                            usercctitleLabel.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                            usercctitleLabel.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(usercctitleLabelConstraints)
    }
}

extension ZorroDocumentInitiateCcView {
    func setUserCc(contacts: [ContactDetailsViewModel]) {
        
        if contacts.count == 1 {
            usercctitleLabel.text = contacts.first?.Name
        } else {
            usercctitleLabel.text = "[Multiple - \(contacts.count)]"
        }
    }
}
