//
//  ZorroDynamicTextView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDynamicTextView: ZorroTagBaseView {
    
    private var textField: UITextField!
    private var dynamictextcancelButton: UIButton!
    var isremoved: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubView()
        self.backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroDynamicTextView {
    fileprivate func setsubView() {
        self.layer.borderWidth = 0
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.minimumFontSize = 10.0
        textField.adjustsFontSizeToFitWidth = true
        textField.contentVerticalAlignment = .center
        textField.placeholder = "Dynamic Text"
        addSubview(textField)
        
        let textfieldConstrants = [textField.leftAnchor.constraint(equalTo: leftAnchor),
                                   textField.topAnchor.constraint(equalTo: topAnchor, constant: -5),
                                   textField.rightAnchor.constraint(equalTo: rightAnchor),
                                   textField.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(textfieldConstrants)
        
        textField.addTarget(self, action: #selector(textFielddidChange(_:)), for: .editingChanged)
        
        dynamictextcancelButton = UIButton()
        dynamictextcancelButton.translatesAutoresizingMaskIntoConstraints = false
        dynamictextcancelButton.setImage(UIImage(named: "doccancel"), for: .normal)
        dynamictextcancelButton.backgroundColor = .white
        dynamictextcancelButton.isHidden = true
        addSubview(dynamictextcancelButton)
        
        let dynamictextcancelButtonConstraints = [dynamictextcancelButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 10),
                                       dynamictextcancelButton.topAnchor.constraint(equalTo: topAnchor, constant: -10),
                                       dynamictextcancelButton.widthAnchor.constraint(equalToConstant: 30),
                                       dynamictextcancelButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(dynamictextcancelButtonConstraints)
        
        dynamictextcancelButton.addTarget(self, action: #selector(removeAction(_:)), for: .touchUpInside)
        dynamictextcancelButton.layer.cornerRadius = 15
        dynamictextcancelButton.layer.masksToBounds = true
    }
}

//MARK: Show Buttons for new views
extension ZorroDynamicTextView {
    func showButtons() {
        dynamictextcancelButton.isHidden = false
    }
}

//MARK: Set extra metadata
extension ZorroDynamicTextView {
    
    func setextraMetaData(fluffyextrametadata: FluffyExtraMetaData, tagtext: String) {
        tagText = tagtext
        textField.text = tagtext
    }
}

//MARK: Validate text
extension ZorroDynamicTextView {
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

extension ZorroDynamicTextView {
    @objc fileprivate func removeAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setcommonAlert(title: "Remove Text", message: "Do you want to remove this Text", actiontitleOne: "Cancel", actiontitleTwo: "Confirm", addText: false) { (cancel, upload, text) in

                if cancel {
                    return
                } else {
                    self.isremoved = true
                    self.isHidden = true
                }
            }
        }
    }
}
