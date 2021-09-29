//
//  DocumentInitiateCreateContactCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol DocumentInitiateCreateContactCellDelegate {
    func getText(text: String)
}

class DocumentInitiateCreateContactCell: UITableViewCell {
    
    private var textcontianerView: UIView!
    private var hintText: UILabel!
    private var textField: UITextField!
    private let textHeaders: [String] = ["FIRST NAME *", "MIDDLE NAME", "LAST NAME *", "DISPLAY NAME AS", "E-MAIL *", "COMPANY", "JOB TITLE"]
    private let textPlaceholders = ["First Name", "Middle Name", "Last Name", "Diaplay Name" ,"Email Address", "Company", "Job Title"]
    
    var callBack: ((Int, String) -> ())?
    
    var delegate: DocumentInitiateCreateContactCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textfieleIndex: Int! {
        didSet {
            textField.tag = textfieleIndex
            hintText.text = textHeaders[textfieleIndex]
            textField.placeholder = textPlaceholders[textfieleIndex]
            
            if textfieleIndex == 5 {
                textField.keyboardType = .emailAddress
            }
        }
    }
}

extension DocumentInitiateCreateContactCell {
    fileprivate func setcellUI() {
        
        textcontianerView = UIView()
        textcontianerView.translatesAutoresizingMaskIntoConstraints = false
        textcontianerView.backgroundColor = .white
        addSubview(textcontianerView)
        
        let textcontainerviewConstraints = [textcontianerView.leftAnchor.constraint(equalTo: leftAnchor),
                                            textcontianerView.topAnchor.constraint(equalTo: topAnchor),
                                            textcontianerView.rightAnchor.constraint(equalTo: rightAnchor),
                                            textcontianerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(textcontainerviewConstraints)
        
        hintText = UILabel()
        hintText.translatesAutoresizingMaskIntoConstraints = false
        hintText.text = "Hint Text"
        hintText.textColor = .darkGray
        textcontianerView.addSubview(hintText)
        
        let hinttextConstraints = [hintText.leftAnchor.constraint(equalTo: textcontianerView.leftAnchor, constant: 10),
                                   hintText.topAnchor.constraint(equalTo: textcontianerView.topAnchor, constant: 10),
                                   hintText.rightAnchor.constraint(equalTo: textcontianerView.rightAnchor, constant:  -10),
                                   hintText.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(hinttextConstraints)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.placeholder = "Your Text Here"
        textcontianerView.addSubview(textField)
        
        let textfieldConstraints = [textField.leftAnchor.constraint(equalTo: textcontianerView.leftAnchor, constant: 10),
                                    textField.topAnchor.constraint(equalTo: hintText.bottomAnchor, constant: 5),
                                    textField.rightAnchor.constraint(equalTo: textcontianerView.rightAnchor, constant: -10),
                                    textField.bottomAnchor.constraint(equalTo: textcontianerView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        textField.layer.shadowRadius = 1.5;
        textField.layer.shadowColor   = UIColor.lightGray.cgColor
        textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        textField.layer.shadowOpacity = 0.9;
        textField.layer.masksToBounds = false;
        textField.layer.cornerRadius = 8
        textField.isUserInteractionEnabled = true
        
        textField.addTarget(self, action: #selector(textFiedldDidChange(_:)), for: .editingChanged)
    }
}

//MARK: - Textfield delegate methods
extension DocumentInitiateCreateContactCell: UITextFieldDelegate {
    
    @objc func textFiedldDidChange(_ textField: UITextField) {
        print(textField.tag)
        print(textField.text!)
        callBack!(textField.tag, textField.text!)
        
        delegate?.getText(text: textField.text!)
        
        
        return
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        print(textField.text!)
        callBack!(textField.tag, textField.text!)
        
        delegate?.getText(text: textField.text!)
        return
    }
}
