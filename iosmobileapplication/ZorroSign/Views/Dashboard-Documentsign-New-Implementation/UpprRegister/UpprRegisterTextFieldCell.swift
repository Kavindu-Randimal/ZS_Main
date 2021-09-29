//
//  UpprRegisterTextFieldCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpprRegisterTextFieldCell: UpprRegisterBaseCell {
    
    private var textfieldlabel: UILabel!
    private var textfieldtext: UITextField!
    private var gapLabel: UILabel!
    var textfieldCallBack: ((Int, String) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var textfieldIndex: Int! {
        didSet {
            textfieldtext.tag = textfieldIndex
            
            switch textfieldIndex {
            case 1:
                textfieldlabel.text = "First Name*."
                textfieldtext.placeholder = "Enter first name here"
                gapLabel.text = ""
            case 2:
                textfieldlabel.text = "Last Name*."
                textfieldtext.placeholder = "Enter last name here"
                gapLabel.text = ""
            case 3:
                textfieldlabel.text = "Password*."
                textfieldtext.isSecureTextEntry = true
                textfieldtext.placeholder = "Enter password here"
                gapLabel.text = ""
            case 4:
                textfieldlabel.text = "Confirm Password*."
                textfieldtext.isSecureTextEntry = true
                textfieldtext.placeholder = "Enter password again"
                gapLabel.text = "*Password must be at least 7 characters long and contain at least 1 special character and 1 upper case character."
            default:
                gapLabel.text = ""
            }
        }
    }
}

extension UpprRegisterTextFieldCell {
    @objc override func setcellUI() {
        
        textfieldlabel = UILabel()
        textfieldlabel.translatesAutoresizingMaskIntoConstraints = false
        textfieldlabel.textAlignment = .left
        textfieldlabel.text = "FirstName *"
        textfieldlabel.numberOfLines = 0
        textfieldlabel.font = UIFont(name: "Helvetica", size: 20)
        addSubview(textfieldlabel)
        
        let textfieldlabelConstraints = [textfieldlabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                      textfieldlabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                      textfieldlabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(textfieldlabelConstraints)
        
        textfieldtext = UITextField()
        textfieldtext.translatesAutoresizingMaskIntoConstraints = false
        textfieldtext.borderStyle = .roundedRect
        textfieldtext.delegate = self
        addSubview(textfieldtext)
        
        let textfieldtextConstraints = [textfieldtext.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                        textfieldtext.topAnchor.constraint(equalTo: textfieldlabel.bottomAnchor, constant: 5),
                                        textfieldtext.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                        textfieldtext.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(textfieldtextConstraints)
        textfieldtext.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        gapLabel.textAlignment = .left
        gapLabel.text = ""
        gapLabel.numberOfLines = 0
        gapLabel.font = UIFont(name: "Helvetica", size: 16)
        addSubview(gapLabel)
        
        let gapLabelConstraints = [gapLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                   gapLabel.topAnchor.constraint(equalTo: textfieldtext.bottomAnchor, constant: 5),
                                      gapLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                      gapLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(gapLabelConstraints)
    }
}

extension UpprRegisterTextFieldCell: UITextFieldDelegate {
    @objc
    private func textFieldDidChanged(_ textfield: UITextField) {
        let tag = textfield.tag
        let text = textfield.text
        textfieldCallBack!(tag, text ?? "")
    }
}


