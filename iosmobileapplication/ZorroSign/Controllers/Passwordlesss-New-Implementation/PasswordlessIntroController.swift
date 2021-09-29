//
//  PasswordlessIntroController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PasswordlessIntroController: PasswordlessBaseController {
    
    private var introImage: UIImageView!
    
    private var footerView: UIView!
    private var skipButton: UIButton!
    private var nextButton: UIButton!
    
    private var headingText: UILabel!
    private var subheadingText: UILabel!
    
    var sourceFrom: Int = 0
    var skipCallBack: ((Bool) -> ())?
    var onBoardStatus: (() ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setIntroImage()
        setFooterView()
        setTitle()
    }
}

//MARK: - Setup intro image
extension PasswordlessIntroController {
    
    private func setIntroImage() {
        
        introImage = UIImageView()
        introImage.translatesAutoresizingMaskIntoConstraints = false
        introImage.contentMode = .scaleAspectFit
        introImage.image = UIImage(named: "Biometric page")
        introImage.backgroundColor = .white
        
        view.addSubview(introImage)
        
        let safearea = view.safeAreaLayoutGuide
        
        var _width = deviceWidth - 100
        
        if deviceName == .pad {
            _width = deviceWidth/2 - 100
        }
        
        let introimageviewConstrints = [introImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        introImage.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 50),
                                        introImage.widthAnchor.constraint(equalToConstant: _width),
                                        introImage.heightAnchor.constraint(equalToConstant: _width)]
        NSLayoutConstraint.activate(introimageviewConstrints)
    }
}

//MARK: - Setup footer view
extension PasswordlessIntroController {
    private func setFooterView() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        view.addSubview(footerView)
        
        let safearea = view.safeAreaLayoutGuide
        
        let footerviewConstraints = [footerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     footerView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                     footerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     footerView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(footerviewConstraints)
        
        
        skipButton = UIButton()
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.backgroundColor = .white
        skipButton.setTitleColor(ColorTheme.btnTextWithoutBG, for: .normal)
        skipButton.setTitle("SKIP", for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "Helvetica", size: 17 * fontScale)
        
        if deviceName == .pad {
            skipButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16 * fontScale)
        }
        footerView.addSubview(skipButton)
        
        let _buttonWidth = (deviceWidth - 40)/2
        
        let skipbuttonConstraints = [skipButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                     skipButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                     skipButton.heightAnchor.constraint(equalToConstant: 45),
                                     skipButton.widthAnchor.constraint(equalToConstant: _buttonWidth)]
        NSLayoutConstraint.activate(skipbuttonConstraints)
        
        skipButton.addTarget(self, action: #selector(skipAction(_:)), for: .touchUpInside)
        
        skipButton.layer.borderColor = ColorTheme.btnBorder.cgColor
        skipButton.layer.borderWidth = 1
        skipButton.layer.cornerRadius = 8
        skipButton.layer.masksToBounds = false
        
        nextButton = UIButton()
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.backgroundColor = ColorTheme.btnBG
        nextButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        nextButton.setTitle("NEXT", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Helvetica", size: 17 * fontScale)
        if deviceName == .pad {
            nextButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16 * fontScale)
        }
        footerView.addSubview(nextButton)
        
        let nextbuttonConstraints = [nextButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                     nextButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                     nextButton.heightAnchor.constraint(equalToConstant: 45),
                                     nextButton.widthAnchor.constraint(equalToConstant: _buttonWidth)]
        NSLayoutConstraint.activate(nextbuttonConstraints)
        
        nextButton.layer.cornerRadius = 8
        nextButton.layer.masksToBounds = false
        
        nextButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Set Texts
extension PasswordlessIntroController {
    private func setTitle() {
        
        headingText = UILabel()
        headingText.translatesAutoresizingMaskIntoConstraints = false
        headingText.textAlignment = .center
        headingText.font = UIFont(name: "Helvetica", size: 25 * fontScale)
        
        if deviceName == .pad {
             headingText.font = UIFont(name: "Helvetica", size: 17 * fontScale)
        }
        headingText.text = "Biometric Authentication for Fast and Secure Login."
        headingText.numberOfLines = 2
        headingText.adjustsFontSizeToFitWidth = true
        headingText.minimumScaleFactor = 0.2
        headingText.textColor = ColorTheme.lblBodyDefault
        
        view.addSubview(headingText)
        
        let headingtextConstraints = [headingText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                      headingText.topAnchor.constraint(equalTo: introImage.bottomAnchor, constant: 40),
                                      headingText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(headingtextConstraints)
        
        subheadingText = UILabel()
        subheadingText.translatesAutoresizingMaskIntoConstraints = false
        subheadingText.textAlignment = .center
        subheadingText.font = UIFont(name: "Helvetica-Light", size: 20 * fontScale)
        
        if deviceName == .pad {
             subheadingText.font = UIFont(name: "Helvetica-Light", size: 14 * fontScale)
        }
        
        subheadingText.text = "Upgrade to the next generation of passwordless authentication. Ultimate user privacy and data in document security. Logon to ZorroSign using Biometric and create a passwordless environment."
        subheadingText.numberOfLines = 0
        subheadingText.adjustsFontSizeToFitWidth = true
        subheadingText.minimumScaleFactor = 0.2
        subheadingText.textColor = ColorTheme.lblBodyDefault
        
        view.addSubview(subheadingText)
        
        let subheadingtextConstraints = [subheadingText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                         subheadingText.topAnchor.constraint(equalTo: headingText.bottomAnchor, constant: 20),
                                         subheadingText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(subheadingtextConstraints)
    }
}

//MARK: - Button Actions
extension PasswordlessIntroController {
    @objc private func skipAction(_ sender: UIButton) {
        
        if sourceFrom == 1 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        skipCallBack!(true)
        self.dismiss(animated: true, completion: nil)
        return
    }
    
    @objc private func nextAction(_ sender: UIButton) {
        let passwordlessonboardingController = PasswordlessOnboardingController()
        passwordlessonboardingController.sourceFrom = sourceFrom
        passwordlessonboardingController.providesPresentationContextTransitionStyle = true
        passwordlessonboardingController.definesPresentationContext = true
        passwordlessonboardingController.modalPresentationStyle = .overCurrentContext
        
        passwordlessonboardingController.passwordlessOnboardingSuccess = {
            self.onBoardStatus!()
            return
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        if sourceFrom == 1 {
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(passwordlessonboardingController, animated: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.present(passwordlessonboardingController, animated: false, completion: nil)
        }
    }
}
