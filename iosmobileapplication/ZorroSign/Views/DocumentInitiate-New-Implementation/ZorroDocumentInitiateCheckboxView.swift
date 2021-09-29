//
//  ZorroDocumentInitiateCheckboxView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

class ZorroDocumentInitiateCheckboxView: ZorroDocumentInitiateBaseView {
    
    private var checkboxButton: UIButton!
    private var ischecked: Bool = false
    
}

extension ZorroDocumentInitiateCheckboxView {
    override func setsubViews() {
        setcheckboxButton()
        bringviewstoFront()
    }
}

extension ZorroDocumentInitiateCheckboxView {
    fileprivate func setcheckboxButton() {
        checkboxButton = UIButton()
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 18, style: .solid)
        checkboxButton.titleLabel?.adjustsFontSizeToFitWidth = true
        checkboxButton.titleLabel?.minimumScaleFactor = 0.2
        checkboxButton.setTitle("", for: .normal)
        checkboxButton.setTitleColor(.black, for: .normal)
        checkboxButton.isEnabled = true
        containersubView.addSubview(checkboxButton)
        
        let checkboxbuttonConstriants = [checkboxButton.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 0),
                                         checkboxButton.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0 ),
                                         checkboxButton.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: 0),
                                         checkboxButton.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(checkboxbuttonConstriants)
        checkboxButton.addTarget(self, action: #selector(checkboxAction(_:)), for: .touchUpInside)
    }
}

extension ZorroDocumentInitiateCheckboxView {
    @objc fileprivate func checkboxAction(_ sender: UIButton) {
        
        ischecked = !ischecked
        ischecked ? checkboxButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal) : checkboxButton.setTitle("", for: .normal)
        
        extrametadata = SaveExtraMetaData()
        ischecked ? (extrametadata?.CheckState = "Checked") : (extrametadata?.CheckState = "")
    }
}
