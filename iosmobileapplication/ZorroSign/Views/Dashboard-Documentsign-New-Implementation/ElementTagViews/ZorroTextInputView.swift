//
//  ZorroTextInputView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroTextInputView: ZorroTagBaseView {
    
    private var textField: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroTextInputView {
    fileprivate func setsubView() {
        self.layer.borderWidth = 0
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.minimumFontSize = 10.0
        textField.adjustsFontSizeToFitWidth = true
        textField.placeholder = "Your Text Here"
        addSubview(textField)
        
        let textfieldConstrants = [textField.leftAnchor.constraint(equalTo: leftAnchor),
                                   textField.topAnchor.constraint(equalTo: topAnchor, constant: -5),
                                   textField.rightAnchor.constraint(equalTo: rightAnchor),
                                   textField.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(textfieldConstrants)
        textField.addTarget(self, action: #selector(textFielddidChange(_:)), for: .editingChanged)
    }
}

//MARK: Set properties
extension ZorroTextInputView {
    func setProperties(extrametadta: ExtraMetaData?, autosaved: AutoSavedData?) {
        textField.tag = tagID
        
        guard let exdata = extrametadta else { return }
        
        guard let fontsizeString = exdata.fontSize else { return }
        
        if let fontsize = NumberFormatter().number(from: fontsizeString) {
            textField.font = UIFont(name: "Helvetica", size: CGFloat(truncating: fontsize))
        }
        
        // setup auto saved data here
        
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 3 && tagdetail.tagID == tagID {
                        if let apply = tagdetail.apply {
                            if apply {
                                if let data = tagdetail.data {
                                    textField.text = data
                                    iscompleted = true
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}

//MARK: Validate text
extension ZorroTextInputView {
    @objc fileprivate func textFielddidChange(_ textfield: UITextField) {
        let inputtext = textfield.text
        if inputtext == "" {
            iscompleted = false
        } else {
            iscompleted = true
        }
        tagText = inputtext
    }
}

