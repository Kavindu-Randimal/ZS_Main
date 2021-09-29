//
//  ZorroDocumentInitiateDynamictextView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateDynamictextView: ZorroDocumentInitiateBaseView {
    
    var textField: UITextField!
}

extension ZorroDocumentInitiateDynamictextView {
    override func setsubViews() {
        setdynamicTextView()
        removeStepnumber()
        bringviewstoFront()
    }
}

extension ZorroDocumentInitiateDynamictextView {
    fileprivate func setdynamicTextView() {
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Text Here"
        textField.font = UIFont(name: "Helvetica", size: 15)
        containersubView.addSubview(textField)
        
        let textfieldConstraints = [textField.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                    textField.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                    textField.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                    textField.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        setdynamictextExtraMetadata()
    }
}

//MARK: set dymaic tex extra metadata
extension ZorroDocumentInitiateDynamictextView {
    fileprivate func setdynamictextExtraMetadata() {
        let username = ZorroTempData.sharedInstance.getUserName()
        extrametadata = SaveExtraMetaData(SignatureId: nil, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: nil
            , AttachmentDiscription: nil, AddedBy: username, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: lock)
    }
}
