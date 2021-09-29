//
//  FallbackQuestionSaveSettingsVC.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 7/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FallbackQuestionSaveSettingsVC: FallbackSaveSettingsBaseVC {
    
    private var zorrosignLogo: UIImageView!
    private var fallbackTitle: UILabel!
    private var fallbackDescription: UILabel!
    private var question1textField: UITextField!
    private var question2textField: UITextField!
    private var question3textField: UITextField!
    private var question1Label: UILabel!
    private var question2Label: UILabel!
    private var question3Label: UILabel!
    private var verifyButton: UIButton!
    
    var question1: String = ""
    var question2: String = ""
    var question3: String = ""
    var answer1: String = ""
    var answer2: String = ""
    var answer3: String = ""
    var param: BiometricSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setzorrosignLogo()
        setHeaderContent()
        setTextFieldView()
        setverifyButtonUi()
    }
}

//MARK: Setup Zorrosign Logo
extension FallbackQuestionSaveSettingsVC {
    private func setzorrosignLogo() {
        
        let safearea = self.view.safeAreaLayoutGuide
        
        zorrosignLogo = UIImageView()
        zorrosignLogo.translatesAutoresizingMaskIntoConstraints = false
        zorrosignLogo.backgroundColor = .white
        zorrosignLogo.contentMode = .scaleAspectFit
        zorrosignLogo.image = UIImage(named: "zorrosign_highres_logo")
        
        self.view.addSubview(zorrosignLogo)
        
        let logoHeight = (deviceWidth - 80)/1.77
        
        let zorrosignlogoConstraints = [zorrosignLogo.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
                                        zorrosignLogo.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 20),
                                        zorrosignLogo.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -20),
                                        zorrosignLogo.heightAnchor.constraint(equalToConstant: logoHeight)]
        NSLayoutConstraint.activate(zorrosignlogoConstraints)
    }
}

//MARK: - Set header content
extension FallbackQuestionSaveSettingsVC {
    private func setHeaderContent() {
        
        fallbackTitle = UILabel()
        fallbackTitle.translatesAutoresizingMaskIntoConstraints = false
        fallbackTitle.text = "Reset Biometric Verification"
        fallbackTitle.font = UIFont(name: "Helvetica-Bold", size: 18)
        fallbackTitle.textColor = .darkGray
        fallbackTitle.numberOfLines = 1
        self.view.addSubview(fallbackTitle)
        
        let fallbacktitleConstraints = [fallbackTitle.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor),
                                        fallbackTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10)]
        NSLayoutConstraint.activate(fallbacktitleConstraints)
        
        fallbackDescription = UILabel()
        fallbackDescription.translatesAutoresizingMaskIntoConstraints = false
        fallbackDescription.font = UIFont(name: "Helvetica", size: 17)
        fallbackDescription.textAlignment = .left
        fallbackDescription.textColor = .darkGray
        fallbackDescription.adjustsFontSizeToFitWidth = true
        fallbackDescription.minimumScaleFactor = 0.2
        fallbackDescription.numberOfLines = 2
        fallbackDescription.text = "Please answer the following security questions."
        
        self.view.addSubview(fallbackDescription)
        
        let fallbackdescriptionlabelConstraints = [fallbackDescription.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                                   fallbackDescription.topAnchor.constraint(equalTo: fallbackTitle.bottomAnchor,constant: 10)]
        
        NSLayoutConstraint.activate(fallbackdescriptionlabelConstraints)
    }
}

//MARK:- Set textfield view
extension FallbackQuestionSaveSettingsVC {
    private func setTextFieldView() {
        
        question1Label = UILabel()
        question1Label.translatesAutoresizingMaskIntoConstraints = false
        question1Label.font = UIFont(name: "Helvetica", size: 16)
        question1Label.numberOfLines = 2
        question1Label.text = self.question1
        question1Label.adjustsFontSizeToFitWidth = true
        question1Label.minimumScaleFactor = 0.2
        question1Label.textColor = .darkGray
        self.view.addSubview(question1Label)
        
        let question1lableConstraint = [question1Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question1Label.topAnchor.constraint(equalTo: fallbackDescription.bottomAnchor, constant: 30),
                                        question1Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question1lableConstraint)
        
        question1textField = UITextField()
        question1textField.translatesAutoresizingMaskIntoConstraints = false
        question1textField.delegate = self
        question1textField.text = self.answer1
        question1textField.borderStyle = .roundedRect
        question1textField.placeholder = "Enter answer here"
        question1textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question1textField)
        
        let question1textfieldConstraints = [question1textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question1textField.topAnchor.constraint(equalTo: question1Label.bottomAnchor, constant: 5),
                                             question1textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question1textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question1textfieldConstraints)
        question1textField.addTarget(self, action: #selector(textfield1DidChange(_:)), for: .editingChanged)
        
        question1textField.layer.shadowRadius = 1.5
        question1textField.layer.shadowColor   = UIColor.lightGray.cgColor
        question1textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question1textField.layer.shadowOpacity = 0.9
        question1textField.layer.masksToBounds = false
        question1textField.layer.cornerRadius = 8
        
        question2Label = UILabel()
        question2Label.translatesAutoresizingMaskIntoConstraints = false
        question2Label.font = UIFont(name: "Helvetica", size: 16)
        question2Label.numberOfLines = 2
        question2Label.text = self.question2
        question2Label.adjustsFontSizeToFitWidth = true
        question2Label.minimumScaleFactor = 0.2
        question2Label.textColor = .darkGray
        self.view.addSubview(question2Label)
        
        let question2lableConstraint = [question2Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question2Label.topAnchor.constraint(equalTo: question1textField.bottomAnchor, constant: 12),
                                        question2Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question2lableConstraint)
        
        question2textField = UITextField()
        question2textField.translatesAutoresizingMaskIntoConstraints = false
        question2textField.delegate = self
        question2textField.text = self.answer2
        question2textField.borderStyle = .roundedRect
        question2textField.placeholder = "Enter answer here"
        question2textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question2textField)
        
        let question2textfieldConstraints = [question2textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question2textField.topAnchor.constraint(equalTo: question2Label.bottomAnchor, constant: 5),
                                             question2textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question2textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question2textfieldConstraints)
        question2textField.addTarget(self, action: #selector(textfield2DidChange(_:)), for: .editingChanged)
        
        question2textField.layer.shadowRadius = 1.5
        question2textField.layer.shadowColor   = UIColor.lightGray.cgColor
        question2textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question2textField.layer.shadowOpacity = 0.9
        question2textField.layer.masksToBounds = false
        question2textField.layer.cornerRadius = 8
        
        question3Label = UILabel()
        question3Label.translatesAutoresizingMaskIntoConstraints = false
        question3Label.font = UIFont(name: "Helvetica", size: 16)
        question3Label.numberOfLines = 2
        question3Label.text = self.question3
        question3Label.adjustsFontSizeToFitWidth = true
        question3Label.minimumScaleFactor = 0.2
        question3Label.textColor = .darkGray
        self.view.addSubview(question3Label)
        
        let question3lableConstraint = [question3Label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        question3Label.topAnchor.constraint(equalTo: question2textField.bottomAnchor, constant: 12),
                                        question3Label.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(question3lableConstraint)
        
        question3textField = UITextField()
        question3textField.translatesAutoresizingMaskIntoConstraints = false
        question3textField.delegate = self
        question3textField.text = self.answer3
        question3textField.borderStyle = .roundedRect
        question3textField.placeholder = "Enter answer here"
        question3textField.font = UIFont(name: "Helvetica", size: 16)
        
        self.view.addSubview(question3textField)
        
        let question3textfieldConstraints = [question3textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                             question3textField.topAnchor.constraint(equalTo: question3Label.bottomAnchor, constant: 5),
                                             question3textField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                             question3textField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(question3textfieldConstraints)
        question3textField.addTarget(self, action: #selector(textfield3DidChange(_:)), for: .editingChanged)
        
        question3textField.layer.shadowRadius = 1.5
        question3textField.layer.shadowColor   = UIColor.lightGray.cgColor
        question3textField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        question3textField.layer.shadowOpacity = 0.9
        question3textField.layer.masksToBounds = false
        question3textField.layer.cornerRadius = 8
        
    }
}

//MARK: Set verify button Ui
extension FallbackQuestionSaveSettingsVC {
    private func setverifyButtonUi() {
        
        let safearea = view.safeAreaLayoutGuide
        
        verifyButton = UIButton()
        verifyButton.translatesAutoresizingMaskIntoConstraints = false
        verifyButton.backgroundColor = ColorTheme.btnBG
        verifyButton.setTitleColor(.white, for: .normal)
        verifyButton.setTitle("VERIFY & PROCEED", for: .normal)
        verifyButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 18)
        verifyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        verifyButton.titleLabel?.minimumScaleFactor = 0.2
        verifyButton.titleLabel?.textAlignment = .center
        
        self.view.addSubview(verifyButton)
        
        let otpsentVerifyButtonConstraints = [verifyButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                              verifyButton.bottomAnchor.constraint(equalTo: safearea.bottomAnchor,constant: -5),
                                              verifyButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                              verifyButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(otpsentVerifyButtonConstraints)
        verifyButton.setShadow()
        verifyButton.addTarget(self, action: #selector(verifyQuestions(_:)), for: .touchUpInside)
    }
}

//MARK: Check for text change field 1
extension FallbackQuestionSaveSettingsVC {
    @objc fileprivate func textfield1DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question1Label.textColor = .red) : (question1Label.textColor = .darkGray)
        self.answer1 = text
    }
}

//MARK: Check for text change field 2
extension FallbackQuestionSaveSettingsVC {
    @objc fileprivate func textfield2DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question2Label.textColor = .red) : (question2Label.textColor = .darkGray)
        self.answer2 = text
    }
}

//MARK: Check for text change field 3
extension FallbackQuestionSaveSettingsVC {
    @objc fileprivate func textfield3DidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (question3Label.textColor = .red) : (question3Label.textColor = .darkGray)
        self.answer3 = text
    }
}

//MARK: - UITextField Delegates to prevent special characters
extension FallbackQuestionSaveSettingsVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterset = NSCharacterSet(charactersIn: ZorroTempStrings.NOT_ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: characterset).joined(separator: "")
        
        if string.isEmpty {
            return true
        }
        return string != filtered
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}

//MARK: - Verify questions action
extension FallbackQuestionSaveSettingsVC {
    @objc
    private func verifyQuestions(_ sender: UIButton) {
        if answer1 != "" && answer2 != "" && answer3 != "" {
            let fallbackAnswer1 = [
                "Answer": self.answer1,
                "Email": "",
                "Question": self.question1,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            let fallbackAnswer2 = [
                "Answer": self.answer2,
                "Email": "",
                "Question": self.question2,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            let fallbackAnswer3 = [
                "Answer": self.answer3,
                "Email": "",
                "Question": self.question3,
                "Type": 2,
                "OTP": ""
                ] as [String : Any]
            
            var fallbackArray:[Any] = []
            fallbackArray.append(fallbackAnswer1)
            fallbackArray.append(fallbackAnswer2)
            fallbackArray.append(fallbackAnswer3)
            
            if let approvalverificationType = self.param.ApprovalVerificationType, let isbiometricEnabled = self.param.IsBiometricEnabled, let loginverificationType = self.param.LoginVerificationType, let twofaType = self.param.TwoFAType {
                
                let fallbackparams: [String: Any] = [
                    "ApprovalVerificationType": approvalverificationType,
                    "BiometricFallbackAnswers": fallbackArray,
                    "IsBiometricEnabled": isbiometricEnabled,
                    "LoginVerificationType": loginverificationType,
                    "TwoFAType": twofaType
                ]
                
                print("Chathura question response Fallback Onboarding", fallbackparams)
                
                if Connectivity.isConnectedToInternet() == true
                {
                    Singletone.shareInstance.showActivityIndicatory(uiView: view, text: "")
                    
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer " + UserDefaults.standard.string(forKey: "ServiceToken")!,
                        "Accept": "application/json"
                    ]
                    
                    Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "TwoFA/SaveTwoFASettings")!, method: .post, parameters: fallbackparams, encoding: JSONEncoding.default, headers: headers).debugLog().responseJSON { response in
                        if response != nil {
                            let jsonObj: JSON = JSON(response.result.value)
                                print("chathura question wrong flow fallback question save settings", jsonObj["StatusCode"], " ", jsonObj["Data"])
                                print("chathura message######Fallback save two fa ",jsonObj["Message"])
                                if jsonObj["StatusCode"] == 1000 {
                                    Singletone.shareInstance.stopActivityIndicator()
                                    
                                    self.dismiss(animated: true, completion: nil)
                                    return
                                } else {
                                    Singletone.shareInstance.stopActivityIndicator()
                                
                                    if jsonObj["StatusCode"] == 5006 {
                                        self.gotoaccountLockView()
                                        return
                                    }
                                    if jsonObj["StatusCode"] == 5012 {
                                        let _errorMsg = jsonObj["Message"].stringValue
                                        self.alertSample(strTitle: "", strMsg: _errorMsg)
                                    }
                                }
                            
                            Singletone.shareInstance.stopActivityIndicator()
                        } else{
                            Singletone.shareInstance.stopActivityIndicator()
                            return
                        }
                        Singletone.shareInstance.stopActivityIndicator()
                    }
                } else{
                    alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
                }
            } else {
                alertSample(strTitle: "", strMsg: "Something went wrong")
                return
            }
        } else {
            if answer1.isEmpty {
                question1Label.textColor = .red
            }
            if answer2.isEmpty {
                question2Label.textColor = .red
            }
            if answer3.isEmpty {
                question3Label.textColor = .red
            }
        }
    }
}

//MARK: - Go back to account lock
extension FallbackQuestionSaveSettingsVC {
    private func gotoaccountLockView() {
        
        let accountlockController = AccountLockController()
        accountlockController.isfromOtp = false
        accountlockController.providesPresentationContextTransitionStyle = true
        accountlockController.definesPresentationContext = true
        accountlockController.modalPresentationStyle = .overCurrentContext
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(accountlockController, animated: false, completion: nil)
        }
    }
}
