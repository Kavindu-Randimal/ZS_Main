//
//  VcardCountryPickerCell.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2/22/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VcardCountryPickerCell: UITableViewCell {
    
    private var textcontainerView: UIView!
    private var textpickercontainerView: UIView!
    private var hintText: UILabel!
    private var textField: UITextField!
    private var pickerButton : UIButton!
    
    private let textHeaders: [String] = ["FIRST NAME *:","LAST NAME *:","MOBILE PHONE *:","BUSINESS PHONE *:","E-MAIL ADDRESS:","COMPANY NAME:","JOB TITLE:","ADDRESS LINE 1:","ADDRESS LINE 2:","CITY:","STATE/PROVINCE:","ZIP CODE:","COUNTRY:","WEBSITE:"]
    private let placeholders: [String]  = ["First Name","Last Name","Mobile Phone","Business Phone","E-mail Address","Company Name","Job Title","Address Line 1","Address Line 2","City","State/Province","Zip Code","Country","Website URL"]
    
    var callbackcountryPicker: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style:UITableViewCell.CellStyle ,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        textField = UITextField()
        createCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textfieleIndex: Int! {
        didSet {
            textField.tag = textfieleIndex
            hintText.text = textHeaders[textfieleIndex]
            textField.placeholder = placeholders[textfieleIndex]
        }
    }
    
    var textfieldinitialValue: String! {
        didSet {
            if textfieldinitialValue != nil {
                textField.text = textfieldinitialValue
            }
        }
    }
}

//MARK: - Vcard generic text cell implementation
extension VcardCountryPickerCell {
    private func createCellUI(){
        
        textcontainerView = UIView()
        textcontainerView.translatesAutoresizingMaskIntoConstraints  = false
        textcontainerView.backgroundColor = .white
        addSubview(textcontainerView)
        
        let textcontainerviewConstraints = [textcontainerView.leftAnchor.constraint(equalTo: leftAnchor),
                                            textcontainerView.topAnchor.constraint(equalTo: topAnchor),
                                            textcontainerView.rightAnchor.constraint(equalTo: rightAnchor),
                                            textcontainerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(textcontainerviewConstraints)
        
        hintText = UILabel()
        hintText.translatesAutoresizingMaskIntoConstraints = false
        hintText.text = "Hint Text"
        hintText.textColor = .darkGray
        textcontainerView.addSubview(hintText)
        
        let hinttextConstraints = [hintText.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor, constant: 10),
                                   hintText.topAnchor.constraint(equalTo: textcontainerView.topAnchor, constant: 10),
                                   hintText.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor, constant:  -10),
                                   hintText.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(hinttextConstraints)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Your Text Here"
        textcontainerView.addSubview(textField)
        
        let textfieldConstraints = [textField.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor, constant: 10),
                                    textField.topAnchor.constraint(equalTo: hintText.bottomAnchor, constant: 5),
                                    textField.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor, constant: -10),
                                    textField.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        textField.layer.shadowRadius = 1.5;
        textField.layer.shadowColor = UIColor.lightGray.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        textField.layer.shadowOpacity = 0.9
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 8
        textField.isUserInteractionEnabled = false
        
        pickerButton = UIButton()
        pickerButton.translatesAutoresizingMaskIntoConstraints = false
        textcontainerView.addSubview(pickerButton)
        
        let pickerbuttonConstraints = [
            pickerButton.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor),
            pickerButton.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor),
            pickerButton.topAnchor.constraint(equalTo: textcontainerView.topAnchor),
            pickerButton.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor)
        ]
        NSLayoutConstraint.activate(pickerbuttonConstraints)
        
        pickerButton.addTarget(self, action: #selector(openPicker), for: .touchUpInside)
        
    }
}

//MARK: - Picker open action
extension VcardCountryPickerCell {
    @objc fileprivate func openPicker() {
        callbackcountryPicker!()
    }
}

