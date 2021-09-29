//
//  DocumentSignSaveAllProcessController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentSignSaveAllProcessController: UIViewController {
    
    private let greencolor: UIColor = ColorTheme.btnBG
    private let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    
    var shouldrejectDocument: Bool?
    var isotpOnly: Bool = false
    var isbiometricsOnly: Bool = false
    private var _reject: Bool = false
    
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeith = UIScreen.main.bounds.height
    private var containerView: UIView!
    private var headerLabel: UILabel!
    private var separatorView: UIView!
    private var footerView: UIView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    
    private var commenttextView: UITextView!
    private var passwordView: UITextField!
    private var termsLabel: UILabel!
    
    var saveallCallBack: ((String?, String?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkStatus()
    }
}

//MARK: Check status
extension DocumentSignSaveAllProcessController {
    private func checkStatus() {
        guard let _shouldReject = shouldrejectDocument else {
            return
        }
        
        _reject = _shouldReject
        setbackgroundContainer()
        setContentUI()
        setfooterViewUI()
        settextViewUI()
        
    }
}

//MARK: Setup Container View
extension DocumentSignSaveAllProcessController {
    
    private func setbackgroundContainer() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let _width = deviceWidth - 40
        var _height: CGFloat = 300
        
        if _reject {
            _height = 370
        }
        
        if isotpOnly || isbiometricsOnly {
            _height = 250
        }
        
        let backcontainerConstraints = [containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        containerView.widthAnchor.constraint(equalToConstant: _width),
                                        containerView.heightAnchor.constraint(equalToConstant: _height)]
        NSLayoutConstraint.activate(backcontainerConstraints)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        
    }
}

//MARK: Setup Content
extension DocumentSignSaveAllProcessController {
    private func setContentUI() {
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.minimumScaleFactor = 0.2
        headerLabel.text = "Please enter your password"
        if _reject {
            headerLabel.text = "Please Add Comment to Reject"
        }
        
        containerView.addSubview(headerLabel)
        
        let headerlabelConstraints = [headerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                      headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                                      headerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)]
        NSLayoutConstraint.activate(headerlabelConstraints)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        containerView.addSubview(separatorView)
        
        let separatorviewConstrints = [separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                       separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
                                       separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                       separatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(separatorviewConstrints)
    }
}

//MARK: Set Footer View
extension DocumentSignSaveAllProcessController {
    private func setfooterViewUI() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(footerView)
        
        let footerviewConstrints = [footerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                    footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                    footerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                    footerView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(footerviewConstrints)
        
        
        let _buttonWidth = (deviceWidth - 40)/2 - 20
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(greencolor, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        
        footerView.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 10),
                                       cancelButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       cancelButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.shadowRadius = 1.0
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.shadowColor  = UIColor.lightGray.cgColor
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.masksToBounds = false
        cancelButton.layer.cornerRadius = 5
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.backgroundColor = greencolor
        
        footerView.addSubview(confirmButton)
        
        let confirmbuttonConstraints = [confirmButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
                                       confirmButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       confirmButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       confirmButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(confirmbuttonConstraints)
        
        confirmButton.layer.shadowRadius = 1.0
        confirmButton.layer.borderColor = greencolor.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.shadowColor  = UIColor.lightGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        confirmButton.layer.shadowOpacity = 0.5
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 5
        
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
}

//MARK: Set text Views
extension DocumentSignSaveAllProcessController {
    private func settextViewUI() {
        commenttextView = UITextView()
        commenttextView.translatesAutoresizingMaskIntoConstraints = false
        commenttextView.font = UIFont(name: "Helvetica", size: 16)
        
        let commenttextviewConstrints = [commenttextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                         commenttextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
                                         commenttextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                         commenttextView.heightAnchor.constraint(equalToConstant: 100)]
        commenttextView.layer.masksToBounds = true
        commenttextView.layer.cornerRadius = 8
        commenttextView.layer.borderColor = lightgray.cgColor
        commenttextView.layer.borderWidth = 1
        
        passwordView = UITextField()
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        passwordView.isSecureTextEntry = true
        passwordView.placeholder = "Password"
        passwordView.borderStyle = .roundedRect
        
        let passwordviewConstriants = [passwordView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                       passwordView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                       passwordView.heightAnchor.constraint(equalToConstant: 40)]
        var passwordviewTopConstraints: NSLayoutConstraint?
        
        termsLabel = UILabel()
        termsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsLabel.textAlignment = .justified
        termsLabel.numberOfLines = 0
        termsLabel.font = UIFont(name: "Helvetica", size: 16)
        termsLabel.text = "By entering my password or biometric, I acknowledge I have electronically signed or entered information whereby making this document legally binding."
        termsLabel.backgroundColor = lightgray
        
        termsLabel.layer.masksToBounds = true
        termsLabel.layer.cornerRadius = 8

        
        let termslabelConstraints = [termsLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                     termsLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)]
        let termslabeltopConstraints: NSLayoutConstraint?
        
        
        if !_reject {
            containerView.addSubview(passwordView)
            passwordviewTopConstraints = passwordView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20)
            NSLayoutConstraint.activate(passwordviewConstriants)
            passwordviewTopConstraints?.isActive = true
        } else {
            containerView.addSubview(commenttextView)
            NSLayoutConstraint.activate(commenttextviewConstrints)
            containerView.addSubview(passwordView)
            passwordviewTopConstraints = passwordView.topAnchor.constraint(equalTo: commenttextView.bottomAnchor, constant: 5)
            NSLayoutConstraint.activate(passwordviewConstriants)
            passwordviewTopConstraints?.isActive = true
            
        }
        
        containerView.addSubview(termsLabel)
        NSLayoutConstraint.activate(termslabelConstraints)
        termslabeltopConstraints = termsLabel.topAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: 20)
        termslabeltopConstraints?.isActive = true
        
        if isotpOnly || isbiometricsOnly {
            passwordView.isHidden = true
            termsLabel.isHidden = true
        }

    }
}

//MARK: Button Actions
extension DocumentSignSaveAllProcessController {
    @objc private func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmAction(_ sender: UIButton) {
        let _commentText = commenttextView.text
        let _passwordText = passwordView.text
        saveallCallBack!(_passwordText, _commentText)
        self.dismiss(animated: true, completion: nil)
    }
}
