//
//  VcardPhonePickerCell.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2/14/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VcardPhonePickerCell: UITableViewCell {
    
    private var textcontainerView: UIView!
    private var textpickercontainerView: UIView!
    private var hintText: UILabel!
    private var textField: UITextField!
    private var countryImage: UIImageView!
    private var pickerImageButton: UIButton!
    private var countrycodeLabel: UILabel!
    
    private let textHeaders: [String] = ["FIRST NAME *:","LAST NAME *:","MOBILE PHONE *:","BUSINESS PHONE *:","E-MAIL ADDRESS:","COMPANY NAME:","JOB TITLE:","ADDRESS LINE 1:","ADDRESS LINE 2:","CITY:","STATE/PROVINCE:","ZIP CODE:","COUNTRY:","WEBSITE:"]
    private let placeholders: [String]  = ["First Name","Last Name","Mobile Phone","Business Phone","E-mail Address","Company Name","Job Title","Address Line 1","Address Line 2","City","State/Province","Zip Code","Country","Website URL"]
    
    
    var callBack: ((Int, String) -> ())?
    var callBackPicker: (() -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style:UITableViewCell.CellStyle ,reuseIdentifier:String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        countrycodeLabel = UILabel()
        
        createPickerCellUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var countryImageValue: UIImage? {
        didSet {
            if countryImageValue != nil {
                countryImage.image = countryImageValue!
            }
        }
    }
    
    var countryCodeLabel: String? {
        didSet {
            if countryCodeLabel != nil {
                countrycodeLabel.text = countryCodeLabel!
            }
        }
    }
    
    var numberwithoutCode: String? {
        didSet {
            if numberwithoutCode != nil {
                textField.text = numberwithoutCode!
            }
        }
    }
    
    var textfieleIndex: Int! {
        didSet {
            if textfieleIndex != nil {
                textField.tag = textfieleIndex
                hintText.text = textHeaders[textfieleIndex]
                textField.placeholder = placeholders[textfieleIndex]
                textField.keyboardType = .numberPad
            }
        }
    }
    
}

//MARK: - Create subviews for phone picker
extension VcardPhonePickerCell {
    fileprivate func createPickerCellUI(){
        
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
        
        textpickercontainerView = UIView()
        textpickercontainerView.translatesAutoresizingMaskIntoConstraints = false
        textpickercontainerView.backgroundColor = .white
        textcontainerView.addSubview(textpickercontainerView)
        
        let textpickercontainerViewconstarints = [textpickercontainerView.leftAnchor.constraint(equalTo: leftAnchor,constant: 10),
                                                  textpickercontainerView.topAnchor.constraint(equalTo: hintText.bottomAnchor,constant: 5),
                                                  textpickercontainerView.rightAnchor.constraint(equalTo: rightAnchor,constant: -10),
                                                  textpickercontainerView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5)]
        NSLayoutConstraint.activate(textpickercontainerViewconstarints)
        
        textpickercontainerView.layer.shadowRadius = 1.5;
        textpickercontainerView.layer.shadowColor = UIColor.black.cgColor
        textpickercontainerView.layer.shadowOffset = .zero
        textpickercontainerView.layer.shadowOpacity = 0.7
        textpickercontainerView.layer.masksToBounds = false
        textpickercontainerView.layer.cornerRadius = 5
        
        countryImage = UIImageView()
        countryImage.translatesAutoresizingMaskIntoConstraints = false
        textcontainerView.addSubview(countryImage)
        
        let imageviewConstraints = [countryImage.leftAnchor.constraint(equalTo: textpickercontainerView.leftAnchor,constant: 10),
                                    countryImage.topAnchor.constraint(equalTo: hintText.bottomAnchor,constant: 5),
                                    countryImage.bottomAnchor.constraint(equalTo: textpickercontainerView.bottomAnchor, constant: -5),
                                    countryImage.widthAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(imageviewConstraints)
        countryImage.contentMode = .scaleAspectFit
        
        countrycodeLabel.translatesAutoresizingMaskIntoConstraints = false
        textcontainerView.addSubview(countrycodeLabel)
        
        let countrylabelConstraints = [
            countrycodeLabel.leftAnchor.constraint(equalTo: countryImage.rightAnchor, constant: 10),
            countrycodeLabel.topAnchor.constraint(equalTo: hintText.bottomAnchor, constant: 5),
            countrycodeLabel.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor, constant: -5),
            countrycodeLabel.widthAnchor.constraint(equalToConstant: 60)
        ]
        NSLayoutConstraint.activate(countrylabelConstraints)
        
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.borderStyle = .none
        textField.placeholder = "Your Text Here"
        textField.layer.masksToBounds = false
        textcontainerView.addSubview(textField)
        
        let textfieldConstraints = [
            textField.leftAnchor.constraint(equalTo: countrycodeLabel.rightAnchor),
            textField.topAnchor.constraint(equalTo: hintText.bottomAnchor, constant: 5),
            textField.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor, constant: -10),
            textField.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        textField.addTarget(self, action: #selector(textFieldValuechanged(_:)), for: .editingChanged)
        
        pickerImageButton = UIButton()
        pickerImageButton.translatesAutoresizingMaskIntoConstraints = false
        textcontainerView.addSubview(pickerImageButton)
        
        let pickerbuttonConstraints = [
            pickerImageButton.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor),
            pickerImageButton.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor),
            pickerImageButton.topAnchor.constraint(equalTo: hintText.bottomAnchor),
            pickerImageButton.rightAnchor.constraint(equalTo: textField.leftAnchor)
        ]
        NSLayoutConstraint.activate(pickerbuttonConstraints)
        
        pickerImageButton.addTarget(self, action: #selector(triggerADcountryPicker(_:)), for: .touchUpInside)
        
        //        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        //        arrowImage.contentMode = .scaleAspectFit
        //        arrowImage.image = UIImage(named: "down_black")
        //        arrowImage.backgroundColor = .red
        //        textcontainerView.addSubview(arrowImage)
        //
        //        let arrowImageConstraints = [
        //            arrowImage!.leftAnchor.constraint(equalTo: countrycodeLabel!.rightAnchor),
        //            arrowImage!.centerYAnchor.constraint(equalTo: textcontainerView.centerYAnchor,constant: 5),
        //            arrowImage.widthAnchor.constraint(equalToConstant: 20),
        //            arrowImage.heightAnchor.constraint(equalToConstant: 20)
        //        ]
        //        NSLayoutConstraint.activate(arrowImageConstraints)
        
    }
}

//MARK: - TextField delegte methods
extension VcardPhonePickerCell: UITextFieldDelegate {
    @objc fileprivate func textFieldValuechanged(_ textField:UITextField){
        callBack!(textField.tag,textField.text!)
        return
    }
}

//MARK: - Trigger ADCountryPicker in the VcardController
extension VcardPhonePickerCell {
    @objc fileprivate func triggerADcountryPicker(_ sender: UIButton){
        callBackPicker!()
    }
}
