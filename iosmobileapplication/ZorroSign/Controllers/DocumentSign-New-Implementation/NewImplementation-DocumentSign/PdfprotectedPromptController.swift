//
//  PdfprotectedPromptController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 3/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class PdfprotectedPromptController: UIViewController {
    
    //MARK: - Variables
    
    private var backgroundContainer: UIView!
    private var headingLable: UILabel!
    private var modalTitle: UILabel!
    private var txtFieldHeadingLabel: UILabel!
    private var footerView: UIView!
    private var separatorView: UIView!
    private var topseperatorView: UIView!
    private var continueButton: UIButton!
    private var cancelButton: UIButton!
    private var textfield: UITextField!
    private var gapLable: UILabel!
    private var passwordagreeTextView: UIView!
    private var eyeView: UIImageView!
    private var eyeBtn: UIButton!
    private var eyeviewWrapper: UIView!
    
    private var textValue: String! = ""
    var documentName: String = ""
    var documentSender: String = ""
    var callBack: ((String,Int) -> ())?
    
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let greencolor: UIColor = ColorTheme.btnBG
    let deviceWidth = UIScreen.main.bounds.width
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eyeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))
        textfield = UITextField()
        eyeviewWrapper = UIView(frame: CGRect(x: 0, y: 0, width: 50.0, height: 45.0))
        
        setBackgroundView()
        setContentView()
        setFooterView()
        setGapLabel()
        
        textfield.isSecureTextEntry = true
        eyeBtn.setImage(UIImage(named: "ic_view_pass"), for: .normal)      
    }
    
    var ispasswordCorrect: Bool! {
        didSet {
            if !ispasswordCorrect {
                txtFieldHeadingLabel.textColor = UIColor.red
                textfield.layer.borderWidth = 1
                textfield.layer.borderColor = UIColor.red.cgColor
            } else {
                txtFieldHeadingLabel.textColor = UIColor.black
                textfield.layer.borderWidth = 0.3
                textfield.layer.borderColor = UIColor.lightGray.cgColor
            }
        }
    }
    
    var isviewablePassword: Bool! {
        didSet {
            if isviewablePassword {
                textfield.isSecureTextEntry = false
                eyeBtn.setImage(UIImage(named: "ic_hide_pass"), for: .normal)
                eyeviewWrapper.addSubview(eyeBtn)
                textfield.rightView = eyeviewWrapper
                textfield.rightViewMode = .always
            } else {
                textfield.isSecureTextEntry = true
                eyeBtn.setImage(UIImage(named: "ic_view_pass"), for: .normal)
                eyeviewWrapper.addSubview(eyeBtn)
                textfield.rightView = eyeviewWrapper
                textfield.rightViewMode = .always
            }
        }
    }
}

//MARK: - setup background view

extension PdfprotectedPromptController {
    private func setBackgroundView() {
        
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = .white
        view.addSubview(backgroundContainer)
        
        let backgroundConstraints = [backgroundContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                     backgroundContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                     backgroundContainer.widthAnchor.constraint(equalToConstant: deviceWidth - 32)]
        NSLayoutConstraint.activate(backgroundConstraints)
        
        backgroundContainer.layer.masksToBounds = false
        backgroundContainer.layer.cornerRadius = 8
        
    }
}

//MARK: - Setup Content View

extension PdfprotectedPromptController {
    private func setContentView() {
        
        modalTitle = UILabel()
        modalTitle.translatesAutoresizingMaskIntoConstraints = false
        modalTitle.font = UIFont(name: "Helvetica", size: 17)
        modalTitle.textAlignment = .left
        modalTitle.text = "Enter Document Password"
        backgroundContainer.addSubview(modalTitle)
        
        let modalTitleConstraints = [
            modalTitle.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 15),
            modalTitle.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(modalTitleConstraints)
        
        topseperatorView = UIView()
        topseperatorView.translatesAutoresizingMaskIntoConstraints = false
        topseperatorView.backgroundColor = UIColor.lightGray
        backgroundContainer.addSubview(topseperatorView)
        
        let topseparatorviewConstraints = [topseperatorView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor),
                                           topseperatorView.topAnchor.constraint(equalTo: modalTitle.bottomAnchor, constant: 8),
                                           topseperatorView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                           topseperatorView.heightAnchor.constraint(equalToConstant: 1)]
        
        NSLayoutConstraint.activate(topseparatorviewConstraints)
        
        txtFieldHeadingLabel = UILabel()
        txtFieldHeadingLabel.translatesAutoresizingMaskIntoConstraints = false
        txtFieldHeadingLabel.font = UIFont(name: "Helvetica", size: 16)
        txtFieldHeadingLabel.textAlignment = .left
        txtFieldHeadingLabel.adjustsFontSizeToFitWidth = true
        txtFieldHeadingLabel.minimumScaleFactor = 0.2
        txtFieldHeadingLabel.text = "PASSWORD *"
        
        backgroundContainer.addSubview(txtFieldHeadingLabel)
        
        let txtheadinglabelConstraints = [txtFieldHeadingLabel.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 15),
                                          txtFieldHeadingLabel.topAnchor.constraint(equalTo: topseperatorView.bottomAnchor, constant: 10)]
        
        NSLayoutConstraint.activate(txtheadinglabelConstraints)
        
        eyeBtn.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
        eyeviewWrapper.addSubview(eyeBtn)
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.delegate = self
        textfield.rightView = eyeviewWrapper
        textfield.rightViewMode = .always
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 45))
        // left
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
        
        backgroundContainer.addSubview(textfield)
        
        let textfieldConstraints = [
            textfield.topAnchor.constraint(equalTo: txtFieldHeadingLabel.bottomAnchor, constant: 10),
            textfield.centerXAnchor.constraint(equalTo: backgroundContainer.centerXAnchor),
            textfield.widthAnchor.constraint(equalToConstant: deviceWidth - 60),
            textfield.heightAnchor.constraint(equalToConstant: 45)
        ]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        textfield.layer.cornerRadius = 12.0
        textfield.layer.borderWidth = 0.3
        textfield.layer.borderColor = UIColor.lightGray.cgColor
        textfield.layer.shadowRadius = 1.5
        textfield.layer.shadowColor = UIColor.lightGray.cgColor
        textfield.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        textfield.layer.shadowOpacity = 0.9
        textfield.layer.masksToBounds = false
        
        textfield.addTarget(self, action: #selector(textFieldValuechanged(_:)), for: .editingChanged)
        
        passwordagreeTextView = UIView()
        passwordagreeTextView.translatesAutoresizingMaskIntoConstraints = false
        passwordagreeTextView.backgroundColor = lightgray
        
        backgroundContainer.addSubview(passwordagreeTextView)
        
        let passwordagreeTextViewConstraints = [passwordagreeTextView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 15),
                                                passwordagreeTextView.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 25),
                                                passwordagreeTextView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -15)]
        NSLayoutConstraint.activate(passwordagreeTextViewConstraints)
        
        passwordagreeTextView.layer.masksToBounds = true
        passwordagreeTextView.roundCorners(cornerRadius: 18)
        
        headingLable = UILabel()
        headingLable.translatesAutoresizingMaskIntoConstraints = false
        headingLable.font = UIFont(name: "Helvetica", size: 15)
        headingLable.textAlignment = .center
        headingLable.numberOfLines = 5
        headingLable.adjustsFontSizeToFitWidth = true
        headingLable.minimumScaleFactor = 0.2
        headingLable.text = "'\(documentName)' is password protected. Please enter the password \(documentSender) provided. If you did not receive the document password please contact \(documentSender)."
        
        backgroundContainer.addSubview(headingLable)
        
        let headinglabelConstraints = [headingLable.leftAnchor.constraint(equalTo: passwordagreeTextView.leftAnchor, constant: 5),
                                       headingLable.topAnchor.constraint(equalTo: passwordagreeTextView.topAnchor, constant: 12),
                                       headingLable.rightAnchor.constraint(equalTo: passwordagreeTextView.rightAnchor, constant: -5),
                                       headingLable.bottomAnchor.constraint(equalTo: passwordagreeTextView.bottomAnchor, constant: -12)]
        
        NSLayoutConstraint.activate(headinglabelConstraints)
    }
}

//MARK: - Setup footer view

extension PdfprotectedPromptController {
    private func setFooterView() {
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = UIColor.lightGray
        backgroundContainer.addSubview(separatorView)
        
        let separatorviewConstraints = [separatorView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor),
                                        separatorView.topAnchor.constraint(equalTo: passwordagreeTextView.bottomAnchor, constant: 10),
                                        separatorView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                        separatorView.heightAnchor.constraint(equalToConstant: 1)]
        
        NSLayoutConstraint.activate(separatorviewConstraints)
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        backgroundContainer.addSubview(footerView)
        
        let footerViewConstraints = [footerView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 1),
                                     footerView.topAnchor.constraint(equalTo: separatorView.bottomAnchor),
                                     footerView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -1),
                                     footerView.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(footerViewConstraints)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .white
        cancelButton.setTitleColor(greencolor, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.tag = 0
        
        footerView.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 10),
                                       cancelButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: (deviceWidth - 60) / 2),
                                       cancelButton.heightAnchor.constraint(equalToConstant: 35)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 12
        
        cancelButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = greencolor
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitle("UNLOCK", for: .normal)
        continueButton.tag = 1
        
        footerView.addSubview(continueButton)
        
        let continueButtonConstraints = [continueButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
                                         continueButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                         continueButton.widthAnchor.constraint(equalToConstant: (deviceWidth - 60) / 2),
                                         continueButton.heightAnchor.constraint(equalToConstant: 35)]
        NSLayoutConstraint.activate(continueButtonConstraints)
        
        continueButton.layer.masksToBounds = true
        continueButton.layer.cornerRadius = 12
        
        continueButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

// MARK:- Set gap lable to handle the height

extension PdfprotectedPromptController {
    private func setGapLabel() {
        
        gapLable = UILabel()
        gapLable.translatesAutoresizingMaskIntoConstraints = false
        gapLable.textColor = .white
        gapLable.text = " "
        backgroundContainer.addSubview(gapLable)
        
        let gapLabelConstraints = [
            gapLable.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
            gapLable.topAnchor.constraint(equalTo: footerView.bottomAnchor),
            gapLable.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: 10),
            gapLable.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: 10)
        ]
        NSLayoutConstraint.activate(gapLabelConstraints)
        
    }
}

//MARK: - Button actions

extension PdfprotectedPromptController {
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 1:
            callBack!(textValue, tag)
            return
        default:
            callBack!("", tag)
            return
        }
    }
}

//MARK:- Textfield delegate method

extension PdfprotectedPromptController: UITextFieldDelegate {
    @objc fileprivate func textFieldValuechanged(_ textField: UITextField) {
        textValue = textField.text!
        if textValue.count > 0 {
            textfield.layer.borderColor = UIColor.lightGray.cgColor
            txtFieldHeadingLabel.textColor = UIColor.black
            textfield.layer.borderWidth = 0.3
        }
    }
}

// MARK:- Show hide password

extension PdfprotectedPromptController {
    @objc fileprivate func showHidePassword(_ sender: UIButton) {
        switch isviewablePassword {
        case true:
            isviewablePassword = false
            return
        default:
            isviewablePassword = true
            return
        }
    }
}


