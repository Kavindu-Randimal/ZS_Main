//
//  PasswordlessOnboardingController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FirebaseMessaging

class PasswordlessOnboardingController: PasswordlessBaseController {
    
    private var zorrosignImage: UIImageView!
    private var onboardView: UIView!
    private var biometrictypeImage: UIImageView!
    private var biometriconboardText: UILabel!
    private var biometriconboardButton: UIButton!
    private var loginoptinText: UILabel!
    private var changesettingsButton: UIButton!
    private var helperView: UIView!
    private var infoImage: UIImageView!
    private var infoText: UILabel!
    
    private var biometricWrapper: BiometricsWrapper!
    private var notificationCenter: NotificationCenter!
    private var pkiHelper: PKIHelper!
    
    var sourceFrom: Int = 0
    var passwordlessOnboardingSuccess: (() ->())?
    var biometriconboardCallBack: ((Bool) -> ())?
    
    init() {
        self.biometricWrapper = BiometricsWrapper()
        self.notificationCenter = NotificationCenter.default
        self.pkiHelper = PKIHelper()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setLogo()
        setOnboardingView()
        setSettings()
        setHelpView()
        checkBiometricType()
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
}

//MARK: - Zorro image
extension PasswordlessOnboardingController {
    private func setLogo() {
        
        zorrosignImage = UIImageView()
        zorrosignImage.translatesAutoresizingMaskIntoConstraints = false
        zorrosignImage.contentMode = .scaleAspectFit
        zorrosignImage.image = UIImage(named: "zorrosign_highres_logo")
        view.addSubview(zorrosignImage)
        
        let safearea = view.safeAreaLayoutGuide

        var imageheight = (deviceWidth - 20)/1.77
        
        if deviceName == .pad {
            imageheight = (deviceWidth - 20)/2.5
        }
        
        let zorrosignimageConsraints = [zorrosignImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                        zorrosignImage.topAnchor.constraint(equalTo: safearea.topAnchor),
                                        zorrosignImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                        zorrosignImage.heightAnchor.constraint(equalToConstant: imageheight)]
        NSLayoutConstraint.activate(zorrosignimageConsraints)
    }
}

//MARK: - Onboarding View
extension PasswordlessOnboardingController {
    private func setOnboardingView() {
        
        onboardView = UIView()
        onboardView.translatesAutoresizingMaskIntoConstraints = false
        onboardView.backgroundColor = .white
        
        view.addSubview(onboardView)
        
        var _width = deviceWidth - 150
        
        if deviceName == .pad {
            _width = deviceWidth/2.5
        }
        
        let onboardviewConstraints = [onboardView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                      onboardView.topAnchor.constraint(equalTo: zorrosignImage.bottomAnchor, constant: 20),
                                      onboardView.widthAnchor.constraint(equalToConstant: _width),
                                      onboardView.heightAnchor.constraint(equalToConstant: _width)]
        NSLayoutConstraint.activate(onboardviewConstraints)
        
        onboardView.layer.shadowRadius = 1.0
        onboardView.layer.shadowColor  = UIColor.lightGray.cgColor
        onboardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        onboardView.layer.shadowOpacity = 0.5
        onboardView.layer.masksToBounds = false
        onboardView.layer.cornerRadius = 5
        
        biometrictypeImage = UIImageView()
        biometrictypeImage.translatesAutoresizingMaskIntoConstraints = false
        biometrictypeImage.contentMode = .scaleAspectFit
        biometrictypeImage.backgroundColor = .white
        
        onboardView.addSubview(biometrictypeImage)
        
        
        var _biometricimageWidth: CGFloat = 80
        
        if deviceName == .pad {
            _biometricimageWidth = 120
        }
        
        let biometrictypeimageConstraints = [biometrictypeImage.centerXAnchor.constraint(equalTo: onboardView.centerXAnchor),
                                             biometrictypeImage.topAnchor.constraint(equalTo: onboardView.topAnchor, constant: 60),
                                             biometrictypeImage.widthAnchor.constraint(equalToConstant: _biometricimageWidth),
                                             biometrictypeImage.heightAnchor.constraint(equalToConstant: _biometricimageWidth)]
        NSLayoutConstraint.activate(biometrictypeimageConstraints)
        
        biometriconboardText = UILabel()
        biometriconboardText.translatesAutoresizingMaskIntoConstraints = false
        biometriconboardText.font = UIFont(name: "Helvetica", size: 18 * fontScale)
        
        if deviceName == .pad {
            biometriconboardText.font = UIFont(name: "Helvetica", size: 15 * fontScale)
            
        }
        
        biometriconboardText.text = "Tap here to get started"
        biometriconboardText.textAlignment = .center
        biometriconboardText.numberOfLines = 1
        biometriconboardText.adjustsFontSizeToFitWidth = true
        biometriconboardText.minimumScaleFactor = 0.2
        biometriconboardText.textColor = ColorTheme.lblBodyDefault
        
        onboardView.addSubview(biometriconboardText)
        
        let biometriconboardTextConstraints = [biometriconboardText.leftAnchor.constraint(equalTo: onboardView.leftAnchor, constant: 5),
                                               biometriconboardText.topAnchor.constraint(equalTo: biometrictypeImage.bottomAnchor, constant: 10),
                                               biometriconboardText.rightAnchor.constraint(equalTo: onboardView.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(biometriconboardTextConstraints)
        
        biometriconboardButton = UIButton()
        biometriconboardButton.translatesAutoresizingMaskIntoConstraints = false
        onboardView.addSubview(biometriconboardButton)
        
        let biometriconboardCosntraints = [biometriconboardButton.leftAnchor.constraint(equalTo: onboardView.leftAnchor),
                                           biometriconboardButton.topAnchor.constraint(equalTo: onboardView.topAnchor),
                                           biometriconboardButton.rightAnchor.constraint(equalTo: onboardView.rightAnchor),
                                           biometriconboardButton.bottomAnchor.constraint(equalTo: onboardView.bottomAnchor)]
        
        NSLayoutConstraint.activate(biometriconboardCosntraints)
        
        biometriconboardButton.addTarget(self, action: #selector(onboardButtonAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Settings
extension PasswordlessOnboardingController {
    
    private func setSettings() {
        
        loginoptinText = UILabel()
        loginoptinText.translatesAutoresizingMaskIntoConstraints = false
        loginoptinText.font = UIFont(name: "Helvetica", size: 18 * fontScale)
        if deviceName == .pad {
            loginoptinText.font = UIFont(name: "Helvetica", size: 14 * fontScale)
        }
        loginoptinText.textAlignment = .center
        loginoptinText.text = "Looking for other login options?"
        loginoptinText.isHidden = true
        
        view.addSubview(loginoptinText)
        
        let loginoptiontextConstraints = [loginoptinText.leftAnchor.constraint(equalTo: view.leftAnchor),
                                          loginoptinText.topAnchor.constraint(equalTo: onboardView.bottomAnchor, constant: 5),
                                          loginoptinText.rightAnchor.constraint(equalTo: view.rightAnchor)]
        NSLayoutConstraint.activate(loginoptiontextConstraints)
        
        changesettingsButton = UIButton()
        changesettingsButton.translatesAutoresizingMaskIntoConstraints = false
        changesettingsButton.setTitle("CHANGE SETTINGS", for: .normal)
        changesettingsButton.setTitleColor(ColorTheme.lblBgSpecial, for: .normal)
        
         changesettingsButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 17 * fontScale)
        
        if deviceName == .pad {
             changesettingsButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 12 * fontScale)
        }
       
        
        view.addSubview(changesettingsButton)
        
        let changesettingbuttonConstraints = [changesettingsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                              changesettingsButton.topAnchor.constraint(equalTo: loginoptinText.bottomAnchor, constant: 0),
                                              changesettingsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant:  -10),
                                              changesettingsButton.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(changesettingbuttonConstraints)
        
        changesettingsButton.addTarget(self, action: #selector(changeSettings(_:)), for: .touchUpInside)
    }
}

//MARK: - Setup Help Text
extension PasswordlessOnboardingController {
    private func setHelpView() {
        
        helperView = UIView()
        helperView.translatesAutoresizingMaskIntoConstraints = false
        helperView.backgroundColor = .white
        helperView.isHidden = true
        
        view.addSubview(helperView)
        
        let safearea = view.safeAreaLayoutGuide
        
        let helperviewConstraints = [helperView.leftAnchor.constraint(equalTo: safearea.leftAnchor),
                                     helperView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                     helperView.rightAnchor.constraint(equalTo: safearea.rightAnchor),
                                     helperView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(helperviewConstraints)
        
        infoImage = UIImageView()
        infoImage.translatesAutoresizingMaskIntoConstraints = false
        infoImage.contentMode = .scaleAspectFit
        infoImage.backgroundColor = .clear
        infoImage.image = UIImage(named: "info")
        
        helperView.addSubview(infoImage)
        
        let infoimageConstraints = [infoImage.leftAnchor.constraint(equalTo: helperView.leftAnchor, constant: 10),
                                    infoImage.topAnchor.constraint(equalTo: helperView.topAnchor, constant: 5),
                                    infoImage.widthAnchor.constraint(equalToConstant: 30),
                                    infoImage.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(infoimageConstraints)
        
        infoText = UILabel()
        infoText.translatesAutoresizingMaskIntoConstraints = false
        infoText.font = UIFont(name: "Helvetica", size: 18 * fontScale)
        if deviceName == .pad {
            infoText.font = UIFont(name: "Helvetica", size: 12 * fontScale)
        }
        infoText.text = "Please use the 'My Account' page to reset your Biometric Authentication"
        infoText.numberOfLines = 2
        infoText.adjustsFontSizeToFitWidth = true
        infoText.minimumScaleFactor = 0.2
        
        helperView.addSubview(infoText)
        
        let infoTextConstraints = [infoText.leftAnchor.constraint(equalTo: infoImage.rightAnchor, constant: 10),
                                   infoText.topAnchor.constraint(equalTo: infoImage.topAnchor),
                                   infoText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(infoTextConstraints)
    }
}

//MARK: - Check and Setup Biometric Type
extension PasswordlessOnboardingController {
    private func checkBiometricType() {
        let _biometricType = biometricWrapper.getDeviceBiometricType()
        
        switch _biometricType {
        case .none:
            biometrictypeImage.image = UIImage(named: "Passcode")
            return
        case .touch:
            biometrictypeImage.image = UIImage(named: "Fingerprint")
            return
        case .face:
            biometrictypeImage.image = UIImage(named: "Face-ID")
            return
        }
    }
}

//MARK: - Onboard Button Actions
extension PasswordlessOnboardingController {
    
    //MARK: User tap on get started
    @objc private func onboardButtonAction(_ sender: UIButton) {
        
        biometriconboardButton.isEnabled = false
        let isnetworkavailable = Connectivity.isConnectedToInternet()
        if !isnetworkavailable {
            self.showPasswordlessAlert(title: "Connectivity!", message: "Please check you connection and try again.")
            return
        }
        
        let username: String = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid: String = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: username.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (status, keyid) in
            
            self.biometriconboardButton.isEnabled = true
            if status {
                self.showPasswordlessAlert(title: "Already Registered!", message: "You have already registered for passwordless service")
                return
            }
            
            let _isuserEnrolled = self.biometricWrapper.checkBiometricEnrollement()
            if !_isuserEnrolled {
                self.biometricWrapper.navigateToDeviceSettigns()
                return
            }
            
            self.biometricWrapper.authenticateWithBiometric { [weak self] (success, message) in
                
                guard let _success = success else { return }
                    
                if !_success {
                    return
                }
                self!.onboardUserForPasswordLess()
                return
            }
        }
        return
    }
    
    //MARK: - User tap on change settings
    @objc private func changeSettings(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.biometricWrapper.navigateToDeviceSettigns()
        }
        return
    }
}

//MARK: - Check App Cycle Status
extension PasswordlessOnboardingController {
    @objc private func appMovedToBackground() {
        print("moving background")
    }
    
    @objc private func appMovedToForeground() {
        checkBiometricType()
    }
}

//MARK: - CSR genarator
extension PasswordlessOnboardingController{
    func generateCSR(keyid: String, countryName: String, CommonName: String, Organization: String, SerialName: String) -> String {
        
        var csrstring = ""
        //let csr = CertificateSigningRequest(commonName: "test name", organizationName: "ZorroSign", organizationUnitName: "ZorrosignCryptp", countryName: "USA", stateOrProvinceName: "Texas", localityName: "abc", keyAlgorithm: .rsa(signatureType: .sha256))
        let csr = CertificateSigningRequest(keyAlgorithm: .rsa(signatureType: .sha256))
        
        KeyChainWrapper.getFromKeyChain(service: ZorroTempStrings.ZORRO_PUBLIC_KEY + keyid, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (publickkeystring) in
            
            if let publickkeydata = Data(base64Encoded: publickkeystring ?? "") {
                
                KeyChainWrapper.getFromKeyChain(service: ZorroTempStrings.ZORRO_PRIVATE_KEY + keyid, account: ZorroTempStrings.ZORRO_KEYCHAIN_ACCOUNT) { (privatekeystring) in
                    
                    
                    if let privatekeydata = Data(base64Encoded: privatekeystring ?? "") {
                        
                        let keyDictionary: [NSObject: NSObject] = [
                            kSecAttrKeyType: kSecAttrKeyTypeRSA,
                            kSecAttrKeyClass: kSecAttrKeyClassPrivate,
                            kSecAttrKeySizeInBits: 2048 as NSObject,
                            kSecReturnPersistentRef: true as NSObject
                        ]
                        
                        let _privateSecKey: SecKey = SecKeyCreateWithData(privatekeydata as CFData, keyDictionary as CFDictionary, nil)!
                        
                        csrstring = csr.buildCSRAndReturnString(publickkeydata, privateKey: _privateSecKey)!
                        print(csrstring)
                    }
                }
            }
        }
        return csrstring
    }
}

//MARK: - Onboard User Function
extension PasswordlessOnboardingController {
    private func onboardUserForPasswordLess() {
        showPasswordlessLoading()
        let keyID: String = UUID().uuidString
        pkiHelper.generateKeyPair(keyid: keyID) { (_success, _publickey) in
            if _success {
                
                guard let publickey = _publickey else { return }
                let userId: String = ZorroTempData.sharedInstance.getUserEmail()
                let vendorId: String = UIDevice.current.identifierForVendor!.uuidString
                let pushtoken: String? = Messaging.messaging().fcmToken
                let deviceType: String = "iOS"
                var deviceModel: String = "iPhone"
                let deviceid = vendorId
                
                if self.deviceName == .pad {
                    deviceModel = "iPad"
                }
                
                let csr = self.generateCSR(keyid: keyID, countryName: "", CommonName: "", Organization: "", SerialName: "")
                
                let passwordlessOnboarding = PasswordlessOnboarding(ID: userId, Uuid: vendorId, PushToken: pushtoken, DeviceType: deviceType, DeviceModel: deviceModel, PublicKey: publickey, KeyId: keyID, DeviceId: deviceid, Csr: csr)
                
                passwordlessOnboarding.onboardUserForPasswordless(passwordlessonboarding: passwordlessOnboarding) { (_onboardsuccess) in
                    
                    if _onboardsuccess {
                        ZorroTempData.sharedInstance.setPasswordlessUUID(uuid: vendorId)
                        ZorroTempData.sharedInstance.isPasswordlessEnabled(enabled: true)
                        
                        if self.sourceFrom == 2 {
                            self.biometriconboardCallBack!(true)
                            self.dismiss(animated: true, completion: nil)
                            return
                        }
                        
                        self.showPasswordlessAlert(title: "Success", message: "Successfully Registered")
                        return
                    }
                    self.showPasswordlessAlert(title: "Please Try Again!", message: "Registration unsuccessful.")
                    return
                }
                return
            }
            self.showPasswordlessAlert(title: "Please Try Again!", message: "Something went wrong.")
            return
        }
        return
    }
}

//MARK: - Override OK Action
extension PasswordlessOnboardingController {
    
    override func passwordlessOKAction() {
        hidePasswordlessLoading()
        
        if sourceFrom == 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.navigationController?.popToRootViewController(animated: true)
            }
            return
        }
        
        if sourceFrom == 2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.dismiss(animated: true, completion: nil)
            }
            return
        }
        
        passwordlessOnboardingSuccess!()
        return
    }
}
