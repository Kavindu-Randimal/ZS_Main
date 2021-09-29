//
//  AccountLockController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import WebKit

class AccountLockController: FallbackBaseController {
    
    private var zorrosignLogo: UIImageView!
    private var decriptionLabel: UILabel!
    private var contactUsLabel: UILabel!
    private var supportLabel: UILabel!
    private var loginLabel: UILabel!
    
    var isfromOtp: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setzorrosignLogo()
        setContent()
    }
    
    deinit {
        print("AccountLockController deallocated")
    }
}

//MARK: Setup Zorrosign Logo
extension AccountLockController {
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

//MARK: Set content
extension AccountLockController {
    private func setContent() {
        
        decriptionLabel = UILabel()
        decriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        decriptionLabel.font = UIFont(name: "Helvetica", size: 17)
        decriptionLabel.textAlignment = .center
        decriptionLabel.textColor = ColorTheme.lblBodySpecial2
        decriptionLabel.adjustsFontSizeToFitWidth = true
        decriptionLabel.minimumScaleFactor = 0.2
        decriptionLabel.numberOfLines = 5
        
        if let _isfromOtp = isfromOtp {
            if _isfromOtp {
                decriptionLabel.text = "The verification code entered does not match the verification code that was sent to your email address. Your account has been locked for security. To unlock your account please contact ZorroSign Support."
            } else {
                decriptionLabel.text = "The security question answers you provided do not match the answers you previously provided. Your account has been locked for security. To unlock your account please contact ZorroSign Support."
            }
        } else {
            decriptionLabel.text = "Sorry we couldn't verify your account. Your account has been locked for your security."
        }
        
        let _contentHeight = deviceWidth / 4
        
        self.view.addSubview(decriptionLabel)
        
        let fallbackdescriptionlabelConstraints = [decriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
                                                   decriptionLabel.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor,constant: _contentHeight),
                                                   decriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15)]
        
        NSLayoutConstraint.activate(fallbackdescriptionlabelConstraints)
        
        contactUsLabel = UILabel()
        contactUsLabel.translatesAutoresizingMaskIntoConstraints = false
        contactUsLabel.adjustsFontSizeToFitWidth = true
        contactUsLabel.minimumScaleFactor = 0.2
        contactUsLabel.numberOfLines = 1
        let _contactUsLabel = contactUsLabel.attributedText(withString: "Please contact ZorroSign", boldString: [""],font: UIFont(name: "Helvetica", size: 17)!, underline: false)
        contactUsLabel.attributedText = _contactUsLabel
        contactUsLabel.textColor = ColorTheme.lblBodySpecial2
        
        supportLabel = UILabel()
        supportLabel.translatesAutoresizingMaskIntoConstraints = false
        supportLabel.adjustsFontSizeToFitWidth = true
        supportLabel.minimumScaleFactor = 0.2
        supportLabel.numberOfLines = 1
        supportLabel.isUserInteractionEnabled = true
        let _supportLabel = supportLabel.attributedText(withString: "SUPPORT", boldString: ["SUPPORT"],font: UIFont(name: "Helvetica", size: 17)!, underline: true)
        supportLabel.attributedText = _supportLabel
        supportLabel.textColor = ColorTheme.lblBgSpecial
        
        let typecodetapGesture = UITapGestureRecognizer(target: self, action: #selector(supportbuttonAction(_:)))
        supportLabel.addGestureRecognizer(typecodetapGesture)
        
        let stackview = UIStackView()
        stackview.axis = .horizontal
        stackview.spacing = 2
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.addArrangedSubview(contactUsLabel)
        contactUsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        contactUsLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackview.addArrangedSubview(supportLabel)
        supportLabel.widthAnchor.constraint(equalToConstant: 80).isActive = true
        supportLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.view.addSubview(stackview)
        stackview.topAnchor.constraint(equalTo: decriptionLabel.bottomAnchor, constant: 20).isActive = true
        stackview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        loginLabel = UILabel()
        loginLabel.translatesAutoresizingMaskIntoConstraints = false
        loginLabel.adjustsFontSizeToFitWidth = true
        loginLabel.minimumScaleFactor = 0.2
        loginLabel.numberOfLines = 1
        loginLabel.isUserInteractionEnabled = true
        loginLabel.text = "Go to Login"
        loginLabel.textColor = ColorTheme.lblBodyDefault
        
        self.view.addSubview(loginLabel)
        loginLabel.topAnchor.constraint(equalTo: stackview.bottomAnchor, constant: 50).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let loginTapGesture = UITapGestureRecognizer(target: self, action: #selector(redirectToLoginViewAction(_:)))
          loginLabel.addGestureRecognizer(loginTapGesture)
    }
}

//MARK: - Support button action
extension AccountLockController {
    @objc
    private func supportbuttonAction(_ recognizer: UITapGestureRecognizer) {
        loginLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        loginLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        let webView = WKWebView(frame: CGRect(x: 0, y: 80, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        self.view.addSubview(webView)
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        let url = URL(string: "https://support.zorrosign.com/")
        webView.load(URLRequest(url: url!))
    }
    
    @objc private func redirectToLoginViewAction(_ recognizer: UITapGestureRecognizer) {
        
        let appdelegate = UIApplication.shared.delegate
        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "login_SBID")
        DispatchQueue.main.async {
            appdelegate?.window!?.rootViewController = viewcontroller
        }
    }
}

