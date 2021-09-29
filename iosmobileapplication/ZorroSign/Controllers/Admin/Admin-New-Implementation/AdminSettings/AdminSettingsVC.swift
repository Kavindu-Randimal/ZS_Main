//
//  AdminSettingsVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/4/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AdminSettingsVC: BaseVC {
    
    // MARK: - Variables
    
    let vm = AdminSettingsVM()

    // MARK: - Outlets
    
    @IBOutlet weak var switchMFA: UISwitch!
    @IBOutlet weak var switchKBA: UISwitch!
    @IBOutlet weak var lblContact: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewStandard: UIView!
    @IBOutlet weak var viewPremium: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        setupUI()
        getOrgSettings()
    }
    
    // MARK: - SetupUI
    
    func setupUI() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        
        viewStandard.layer.cornerRadius = 10
        viewStandard.addShadowAllSide()
        viewPremium.layer.cornerRadius = 10
        viewPremium.addShadowAllSide()
        
        btnSave.layer.cornerRadius = 10
        btnSave.addShadowAllSide()
//        btnSave.isHidden = true
        
        setactivityIndicator()
        
        // KBA Only can enable by contacting ZorroSign
        switchKBA.isEnabled = false
    }
    
    func setSwitchesAndValues() {
        
        if let kbastatus = vm.getOrganizationSettings.Data?.KBAStatus {
            vm.valueKBA = kbastatus
            switchKBA.isOn = (kbastatus == 1) ? true: false
        }
        
        if let mfastatus = vm.getOrganizationSettings.Data?.IsOrganizationMFAForced {
            vm.valueMFA = mfastatus
            switchMFA.isOn = (mfastatus) ? true: false
        }
    }
    
    func showhideSaveButton() {
        if vm.valueKBA != vm.getOrganizationSettings.Data?.KBAStatus || vm.valueMFA != vm.getOrganizationSettings.Data?.IsOrganizationMFAForced {
            btnSave.fadeIn()
            btnSave.isHidden = false
        } else {
            btnSave.fadeOut()
            btnSave.isHidden = true
        }
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func didTapOnSwitchMFA(_ sender: UISwitch) {
        if FeatureMatrix.shared.org_mfa_settings {
            if sender.isOn {
                vm.valueMFA = true
            } else {
                vm.valueMFA = false
            }
        } else {
            sender.isOn = !sender.isOn
            FeatureMatrix.shared.showRestrictedMessage()
        }
        //        showhideSaveButton()
    }
    
    @IBAction func didTapOnSwitchKBA(_ sender: UISwitch) {
        if FeatureMatrix.shared.add_KBA {
            if sender.isOn {
                vm.valueKBA = 1
            } else {
                vm.valueKBA = 0
            }
        }else {
            sender.isOn = !sender.isOn
            FeatureMatrix.shared.showRestrictedMessage()
        }
        //        showhideSaveButton()
    }
    
    @IBAction func didTapOnSave(_ sender: Any) {
        postOrgSettings()
    }
}

// MARK: NetReq

extension AdminSettingsVC {
    
    // MARK: - Get Organization Settings
    
    func getOrgSettings() {
        view.isUserInteractionEnabled = false
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        vm.netReqGetOrganizationSettings { (success, message) in
            self.view.isUserInteractionEnabled = true
            Singletone.shareInstance.stopActivityIndicator()
            
            if success {
                self.setSwitchesAndValues()
            } else {
                AlertProvider.init(vc: self).showAlertWithAction(title: "Failed!", message: "Unable to get Settings", action: AlertAction(title: "Dismiss")) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - Post Organization Setiings
    
    func postOrgSettings() {
        startAnimating()
        
        vm.netReqPostOrganizationSettings { (success, message) in
            self.stopAnimating()
            
            if success {
                if self.vm.valueMFA {
                    UserDefaults.standard.set("YES", forKey: "FromForceMFA")
                    self.checkForceMFA()
                } else if self.vm.getOrganizationSettings.Data?.KBAStatus == 1 {
                    if self.vm.valueKBA == 0 {
                        self.checkForceMFA()
                    } else {
                        AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: "Settings Updated Successfully", action: AlertAction(title: "Dismiss")) { (action) in
//                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                } else {
                    UserDefaults.standard.set("No", forKey: "FromForceMFA")
                    AlertProvider.init(vc: self).showAlert(title: "Success", message: "Settings Updated Successfully", action: AlertAction(title: "Okay"))
                }
            } else {
                AlertProvider.init(vc: self).showAlert(title: "Failed!", message: "Unable to update Settings", action: AlertAction(title: "Okay"))
            }
        }
    }
    
    @objc func checkForceMFA() {
        
        var tfType, lvType, avType: Int?
        let multifactorSettingsResponse = MultifactorSettingsResponse()
        
        if let fromForceMFA = UserDefaults.standard.value(forKey: "FromForceMFA") as? String {
            if fromForceMFA == "YES" {
                multifactorSettingsResponse.getuserMultifactorSettings { (data) in
                    tfType = data?.TwoFAType
                    lvType = data?.LoginVerificationType
                    avType = data?.ApprovalVerificationType
                    
                    if tfType == 0 || lvType == 1 || avType == 1 {
                        self.showAlert(msg: "Please enable multi-factor authentication for login & approval process")
                    } else {
                       
                        AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: "Settings Updated Successfully", action: AlertAction(title: "Dismiss")) { (action) in
//                            self.navigationController?.popViewController(animated: true)
                        }
//                        AlertProvider.init(vc: self).showAlertWithAction(title: "Success", message: "Settings Updated Successfully", action: AlertAction(title: "Proceed")) { (action) in
//                            let appdelegate = UIApplication.shared.delegate
//                            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
//                            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
//                            DispatchQueue.main.async {
//                                appdelegate?.window!?.rootViewController = viewcontroller
//                            }
//                        }
                    }
                }
            }
        }
    }
    
    func showAlert(msg: String) {
        AlertProvider.init(vc: self).showAlertWithAction(title: "Settings Updated Successfully", message: msg, action: AlertAction(title: "Proceed")) { (action) in
            self.openMFAScreen()
        }
    }
    
    func openMFAScreen() {
        let appdelegate = UIApplication.shared.delegate
        let multifactorsettingsController = MultifactorSettingsViewController()
        
        let aObjNavi = UINavigationController(rootViewController: multifactorsettingsController)
        
        DispatchQueue.main.async {
            appdelegate?.window!?.rootViewController = aObjNavi
        }
    }
}

// MARK: - Activity Indicator

extension AdminSettingsVC {
    
    private func setactivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        btnSave.addSubview(activityIndicator)
        
        let activityindicatorConstraints = [activityIndicator.centerYAnchor.constraint(equalTo: btnSave.centerYAnchor),
                                            activityIndicator.centerXAnchor.constraint(equalTo: btnSave.centerXAnchor)]
        
        NSLayoutConstraint.activate(activityindicatorConstraints)
    }
    
    private func startAnimating() {
        btnSave.isEnabled = false
        btnSave.setTitle("", for: .normal)
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    private func stopAnimating() {
        btnSave.isEnabled = true
        btnSave.setTitle("Save", for: .normal)
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
}
