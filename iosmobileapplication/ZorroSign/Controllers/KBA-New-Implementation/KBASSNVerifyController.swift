//
//  KBASSNVerifyController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class KBASSNVerifyController: KBABaseController {
    
    private var _ssnWidth: CGFloat!
    
    private var backgroundContainer: UIView!
    private var mainTitle: UILabel!
    private var subTitle: UILabel!
    private var ssnNumberView: KBASSNView!
    private var ssnVerifyView: KBASSNView!
    private var separatorView: UIView!
    private var errorMessageLabel: UILabel!
    private var continueButton: UIButton!
    
    private var _errorMessage: String = ""
    private var _ssnNumber: Int?
    private var _ssnVerifyNumber: Int?
    
    var continueCallBack: ((Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setbackgroundContainer()
        setHeaderSubHeader()
        setupSSNView()
        setupSSNVerify()
        setErrorLabel()
        setSeparator()
        setContinueButton()
    }
}

//MARK: - Setup Background Container
extension KBASSNVerifyController {
    private func setbackgroundContainer() {
        
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = .white
        view.addSubview(backgroundContainer)
        
        var _ssnHeight: CGFloat = 370
        _ssnWidth = deviceWidth - 20
        if deviceName == .pad {
            _ssnHeight = 400
            _ssnWidth = ((deviceWidth/4) * 3) - 40
        }
        
        let backgroundcontainerConstraints = [backgroundContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                              backgroundContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                              backgroundContainer.widthAnchor.constraint(equalToConstant: _ssnWidth),
                                              backgroundContainer.heightAnchor.constraint(equalToConstant: _ssnHeight)]
        NSLayoutConstraint.activate(backgroundcontainerConstraints)
        
        backgroundContainer.layer.masksToBounds = false
        backgroundContainer.layer.cornerRadius = 8
        backgroundContainer.clipsToBounds = true
    }
}

//MARK: - Setup Header and Sub Header
extension KBASSNVerifyController {
    private func setHeaderSubHeader() {
        
        mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.textAlignment = .left
        mainTitle.text = "User Validation"
        mainTitle.font = UIFont(name: "Helvetica-Bold", size: 24)
        mainTitle.adjustsFontSizeToFitWidth = true
        mainTitle.minimumScaleFactor = 0.2
        
        backgroundContainer.addSubview(mainTitle)
        
        let maintitleConstraints = [mainTitle.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                    mainTitle.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 10),
                                    mainTitle.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(maintitleConstraints)
        
        subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.textAlignment = .left
        subTitle.text = "Please enter your information below"
        subTitle.font = UIFont(name: "Helvetica", size: 20)
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.2
        
        backgroundContainer.addSubview(subTitle)
        
        let subTitleConstraints = [subTitle.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                    subTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 10),
                                    subTitle.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(subTitleConstraints)
    }
}

//MARK: - Setup SSN View
extension KBASSNVerifyController {
    private func setupSSNView() {
        
        ssnNumberView = KBASSNView(title: "SOCIAL SECURITY NUMBER (SSN) *", ssnWidth: _ssnWidth - 40)
        ssnNumberView.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.addSubview(ssnNumberView)
        
        let ssnNumberViewconstraints = [ssnNumberView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 20),
                                        ssnNumberView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 30),
                                        ssnNumberView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                        ssnNumberView.heightAnchor.constraint(equalToConstant: 100)]
        
        NSLayoutConstraint.activate(ssnNumberViewconstraints)
        
        ssnNumberView.ssnCallBack = { [weak self] _ssnValue in
            print(_ssnValue)
            self?._ssnNumber = _ssnValue
        }
    }
}

//MARK: - Setup SSN Verify View
extension KBASSNVerifyController {
    private func setupSSNVerify() {
        
        ssnVerifyView = KBASSNView(title: "CONFIRM SSN *", ssnWidth: _ssnWidth - 40)
        ssnVerifyView.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.addSubview(ssnVerifyView)
        
        let ssnVerifyViewViewconstraints = [ssnVerifyView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 20),
                                        ssnVerifyView.topAnchor.constraint(equalTo: ssnNumberView.bottomAnchor, constant: 0),
                                        ssnVerifyView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                        ssnVerifyView.heightAnchor.constraint(equalToConstant: 100)]
        
        NSLayoutConstraint.activate(ssnVerifyViewViewconstraints)
        
        ssnVerifyView.ssnCallBack = { [weak self] _ssnValue in
            print(_ssnValue)
            self?._ssnVerifyNumber = _ssnValue
        }
    }
}

//MARK: - Setup Erro Message Label
extension KBASSNVerifyController {
    private func setErrorLabel() {
        
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = .red
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.numberOfLines = 2
        errorMessageLabel.font = UIFont(name: "Helvetica", size: 18)
        
        backgroundContainer.addSubview(errorMessageLabel)
        
        let errormessagelabelConstraints = [errorMessageLabel.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                            errorMessageLabel.topAnchor.constraint(equalTo: ssnVerifyView.bottomAnchor, constant: -20),
                                            errorMessageLabel.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10)
                                            
        ]
        
        NSLayoutConstraint.activate(errormessagelabelConstraints)
    }
}

//MARK: - Setup Separator
extension KBASSNVerifyController {
    private func setSeparator() {
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = lightgray
        
        backgroundContainer.addSubview(separatorView)
        
        var _separatorTop: CGFloat = 0
        if deviceName == .pad {
            _separatorTop = 30
        }
        
        let separatoriviewConstraitns = [separatorView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor),
                                         separatorView.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: _separatorTop),
                                         separatorView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                         separatorView.heightAnchor.constraint(equalToConstant: 2)]
        
        NSLayoutConstraint.activate(separatoriviewConstraitns)
    }
}

//MARK: Setup Continue Button
extension KBASSNVerifyController {
    private func setContinueButton() {
        
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = greencolor
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 20)
        continueButton.setTitleColor(.white, for: .normal)
        
        backgroundContainer.addSubview(continueButton)
        
        let continuebuttonConstraints = [continueButton.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                         continueButton.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 10),
                                         continueButton.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10),
                                         continueButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(continuebuttonConstraints)
        
        continueButton.layer.masksToBounds = false
        continueButton.layer.cornerRadius = 8
        
        continueButton.addTarget(self, action: #selector(continueAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Continue Button Action
extension KBASSNVerifyController {
    @objc private func continueAction(_ sender: UIButton) {
        
        guard let _ssn = _ssnNumber, let _ssnverify = _ssnVerifyNumber else {
            _errorMessage = "SSN and Confirm SSN are required field"
            updateErrorMessage()
            return
        }
        
        if String(_ssn).count < 9 || String(_ssnverify).count < 9 {
            _errorMessage = "Please enter valid SSN"
            updateErrorMessage()
            return
        }
        
        if _ssn != _ssnverify {
            _errorMessage = "SSN and Confirm SSN does not match"
            updateErrorMessage()
            return
        }
        
        DispatchQueue.main.async {
            self.continueCallBack!(_ssn)
            self.dismiss(animated: true, completion: nil)
        }
        return
    }
}

//MARK: - Error Message
extension KBASSNVerifyController {
    private func updateErrorMessage() {
        DispatchQueue.main.async {
            self.errorMessageLabel.text = self._errorMessage
        }
    }
}

