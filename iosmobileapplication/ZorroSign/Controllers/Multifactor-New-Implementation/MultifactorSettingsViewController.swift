//
//  MultifactorSettingsViewController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ADCountryPicker
import RxSwift
import SwiftyJSON
import SwiftyXMLParser
import Alamofire

class MultifactorSettingsViewController: MultifactorBaseController, BannerDelegate {
    
    private var multifactorSettingsTableView: UITableView!
    private let multifactordefaultcellIdentifier = "multifactordefaultcellIdentifier"
    
    private let multifactorbasecellIdentifier = "multifactorbasecellIdentifier"
    
    private let multifactoractivationcellIdentifier = "multifactoractivationcellIdentifier"
    
    private let multifactortwofainfocellIdentifier = "multifactortwofainfocellIdentifier"
    private let multifactortwofasettingscellIdentifier = "multifactortwofasettingscellIdentifier"
    private let multifactortwofasettingsoptioncellIdentifier = "multifactortwofasettingsoptioncellIdentifier"
    
    private let recoveryoptionselectioncellIdentifier = "recoveryoptionselectioncellIdentifier"
    private let recoveryoptionemailcellIdentifier = "recoveryoptionemailcellIdentifier"
    private let recoveryoptionotpcellidentifier = "recoveryoptionotpcellidentifier"
    private let recoveryoptionotperrorcellidentifier = "recoveryoptionotperrorcellidentifier"
    private let recoveryoptionotpverifycellIdentifier = "recoveryoptionotpverifycellIdentifier"
    private let recoveryoptionquestioncellIdentifier = "recoveryoptionquestioncellIdentifier"
    
    private let multifactorotpsettingscellIdentifier = "multifactorotpsettingscellIdentifier"
    private let multifactorotpsettingsactivatedcellIdentifier = "multifactorotpsettingsactivatedcellIdentifier"
    private let multifactorotpsettingsactivatedoptionscellIdentifier = "multifactorotpsettingsactivatedoptionscellIdentifier"
    private let multifactorotpsendcodecellIdentifier = "multifactorotpsendcodecellIdentifier"
    private let multifactorotpaddmobilecellIdentifier = "multifactorotpaddmobilecellIdentifier"
    private let multifactorotptypecodecellIdentifier = "multifactorotptypecodecellIdentifier"
    
    private var multifactorSettingsViewModelData: MultifactorSettingsViewModel!
    private var bannerView: BannerView = BannerView()
    
    private var arrFallbackQuestions: [FallbackQuestionsWithSelect] = []
    private var arrSecurityQuestionsAndAnswers = [SecurityQuestion]()
    
    private let disposebag = DisposeBag()
    
    var isBackButtonDisabled: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupSettingsTableView()
        
        //check subscription Data
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
//        openQuestionPicker()
        fetchMultifactorSettings()
        
        // Get Questions
        getFallbackQuestions()
        addEmptyAnswerToArray()
        
        //Notifaction center observers
        removeObservers()
        addObservers()
        
        if let fromForceMFA = UserDefaults.standard.value(forKey: "FromForceMFA") as? String {
            if fromForceMFA == "YES" && isBackButtonDisabled {
                addCustomBackButton()
            } else if fromForceMFA == "YES" {
                addDasboardButton()
            }
        }
    }
    
    func addCustomBackButton() {
        // Custom Back Button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: "Back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // MARK: - Custom Back Function
    
    @objc func back(sender: UIBarButtonItem) {
        checkForceMFA()
    }
    
    func addDasboardButton() {
        let dasboardBarButtonItem = UIBarButtonItem(title: "DashBoard", style: .done, target: self, action: #selector(checkForceMFA))
        dasboardBarButtonItem.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        self.navigationItem.rightBarButtonItem  = dasboardBarButtonItem
    }
    
    @objc func checkForceMFA() {
        
        guard Connectivity.isConnectedToInternet() else {
            AlertProvider.init(vc: self).showAlert(title: "No Internet Connection", message: "No internet found. Check your network connection and Try again...", action: AlertAction(title: "Dismiss"))
            return
        }
        
        var IsMFAForcedToEnable = false
        var IsOrganizationMFAEnabledForUsers = false
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let strPid = ZorroTempData.sharedInstance.getProfileId()
        //UserDefaults.standard.string(forKey: "OrgProfileId")!
        Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Organization/GetOrganizationMFAStatus")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                
                let jsonObj: JSON = JSON(response.result.value!)
                
                
                if jsonObj["StatusCode"] == 1000
                {
                    let isMFAEnabled = jsonObj["Data"]["IsMFAForcedToEnable"].boolValue
                    let isOrgForceMFAEnabled = jsonObj["Data"]["IsOrganizationMFAEnabledForUsers"].boolValue
                    
                    IsMFAForcedToEnable = jsonObj["Data"]["IsMFAForcedToEnable"].boolValue
                    IsOrganizationMFAEnabledForUsers = jsonObj["Data"]["IsOrganizationMFAEnabledForUsers"].boolValue
                    
                    
                    
                    var tfType, lvType, avType: Int?
                    let multifactorSettingsResponse = MultifactorSettingsResponse()
                    
                    //        if let fromForceMFA = UserDefaults.standard.value(forKey: "FromForceMFA") as? String {
                    //            if fromForceMFA == "YES" {
                    if IsOrganizationMFAEnabledForUsers {
                            multifactorSettingsResponse.getuserMultifactorSettings { (data) in
                                tfType = data?.TwoFAType
                                lvType = data?.LoginVerificationType
                                avType = data?.ApprovalVerificationType
                                
                                if tfType == 0 {
                                    self.alertSample(strTitle: "", strMsg: "Please enable one authentication method to go to DashBoard")
                                } else if lvType == 1 && avType == 1 {
                                    self.alertSample(strTitle: "", strMsg: "Please enable multi-factor authentication for login & approval process to go to DashBoard")
                                } else if lvType == 1 {
                                    self.alertSample(strTitle: "", strMsg: "Please enable multi-factor authentication for login to go to DashBoard")
                                } else if avType == 1 {
                                    self.alertSample(strTitle: "", strMsg: "Please enable multi-factor authentication for approval process to go to DashBoard")
                                } else  if self.isBackButtonDisabled {
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    let appdelegate = UIApplication.shared.delegate
                                    let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                                    let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                                    DispatchQueue.main.async {
                                        appdelegate?.window!?.rootViewController = viewcontroller
                                    }
                                }
                            }
                        
                        //            }
                        //        }
                    } else {
                        let appdelegate = UIApplication.shared.delegate
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                        DispatchQueue.main.async {
                            appdelegate?.window!?.rootViewController = viewcontroller
                        }
                    }
                }
            }
        
        
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Notification Observers
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.showAlertSaveFallbackOptions(notification:)), name: NSNotification.Name(rawValue: "ShowAlert"), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ShowAlert"), object: nil)
    }
    
    // MARK: - Show Alert Fucntions
    @objc func showAlertSaveFallbackOptions(notification: Notification) {
        print("Chathura notfication question stop ", notification.object as! Bool)
        if let isSuccess = notification.object {
            saveSettings(success: isSuccess as! Bool)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Get Questions
    
    private func getFallbackQuestions() {
        let recoveryqusetionResponse = RecoveryQuestionResponse()
        recoveryqusetionResponse.requestFallbackQuestions { (arrFallbackQuestions) in
            guard let arrFallbackQuestions = arrFallbackQuestions else { return }
            
            arrFallbackQuestions.forEach { (question) in
                self.arrFallbackQuestions.append(FallbackQuestionsWithSelect(questionPart: question, isSelected: false))
            }
        }
    }
    
    func addEmptyAnswerToArray() {
        for _ in 0...2 {
            arrSecurityQuestionsAndAnswers.append(SecurityQuestion(questionModel: nil, answerId: nil, answer: nil, userId: nil))
        }
    }
}

//MARK: - Set subscription banner
extension MultifactorSettingsViewController {
    func setTitleForSubscriptionBanner() {
        SubscriptionBanners.shared.getTitleForSubscriptionBanner { (message, upgrade) in
            if message != "" {
                self.setUpBanner(title: message, upgrade: upgrade)
            }
        }
    }

    func setUpBanner(title: String, upgrade: Bool) {
        let safearea = view.safeAreaLayoutGuide
        bannerView = (Bundle.main.loadNibNamed("BannerView", owner: self, options: nil)?.first as? BannerView)!
        bannerView.delegate = self
        bannerView.title = title
        bannerView.cangotoSubscription = upgrade
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.backgroundColor = ColorTheme.lblBody
        self.view.addSubview(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: safearea.topAnchor),
            bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }

    func dismissBanner() {
        bannerView.removeFromSuperview()
        ZorroTempData.sharedInstance.setBannerClose(isClosed: true)
    }
    
    func navigatetoSubscription() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Subscription", bundle:nil)
        let signatureVC = storyBoard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        self.navigationController?.pushViewController(signatureVC, animated: true)
    }
}

//MARK: - Biometric Fallback otp flow
extension MultifactorSettingsViewController {
    private func biometricFallbackOtp(biometricsettings: BiometricSettings, email: String) {
        
        let fallbackotpsavesettingsVC = FallbackOTPSaveSettingsVC()
        fallbackotpsavesettingsVC.param = biometricsettings
        fallbackotpsavesettingsVC.otpreceiverEmail = email
        fallbackotpsavesettingsVC.providesPresentationContextTransitionStyle = true
        fallbackotpsavesettingsVC.definesPresentationContext = true
        fallbackotpsavesettingsVC.modalPresentationStyle = .overCurrentContext
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(fallbackotpsavesettingsVC, animated: false, completion: nil)
        }
    }
}

//MARK: - Biometric Fallback question flow
extension MultifactorSettingsViewController {
    private func biometricFallbackQuestion(biometricsettings: BiometricSettings, q1: String, q2: String, q3: String) {
        
        let fallbackquestionsavesettingVC = FallbackQuestionSaveSettingsVC()
        fallbackquestionsavesettingVC.providesPresentationContextTransitionStyle = true
        fallbackquestionsavesettingVC.definesPresentationContext = true
        fallbackquestionsavesettingVC.modalPresentationStyle = .overCurrentContext
        
        fallbackquestionsavesettingVC.param = biometricsettings
        fallbackquestionsavesettingVC.question1 = q1
        fallbackquestionsavesettingVC.question2 = q2
        fallbackquestionsavesettingVC.question3 = q3
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.async {
            self.present(fallbackquestionsavesettingVC, animated: true, completion: nil)
        }
    }
}

//MARK: Present QuestionVC
extension MultifactorSettingsViewController {
    
    func presentQuestionVC(number: Int, questionIs isAvailable: Bool = false) {
        
        let fallbackquestionController = FallbackQuestionController()
        fallbackquestionController.delegate = self
        fallbackquestionController.selectedQuestionNo = number
        
        if isAvailable {
            if let _quetionModel = self.arrSecurityQuestionsAndAnswers[number - 1].questionModel {
                fallbackquestionController.fallbackQuestions.append(_quetionModel)
            }
        }
        fallbackquestionController.fallbackQuestions.append(contentsOf: self.arrFallbackQuestions)
        
        self.present(fallbackquestionController, animated: false, completion: nil)
    }
}

//MARK: - Fetch Multifactor Settings data
extension MultifactorSettingsViewController {
    private func fetchMultifactorSettings() {
        
        //        let multifactorsettings = MultifactorSettingsResponseData(TwoFAType: 1, LoginVerificationType: 1, ApprovalVerificationType: 1, IsBiometricEnabled: true)
        //
        //        let multifactorsettingsViewModel = MultifactorSettingsViewModel(multifactorsettingsresponsedata: multifactorsettings)
        //        self.multifactorSettingsViewModelData = multifactorsettingsViewModel
        //
        //        self.multifactorSettingsTableView.reloadData()
        
        let multifacotrsettingsresponse = MultifactorSettingsResponse()
        multifacotrsettingsresponse.getuserMultifactorSettings { (multifactorsettingsdata) in
            
            guard let multifactorsettingsData = multifactorsettingsdata else { return }
            
            let multifactorsettingsViewModel = MultifactorSettingsViewModel(multifactorsettingsresponsedata: multifactorsettingsData)
            self.multifactorSettingsViewModelData = multifactorsettingsViewModel
            
            DispatchQueue.main.async {
                self.multifactorSettingsTableView.reloadData()
            }
        }
    }
}

//MARK: - Implement UI
extension MultifactorSettingsViewController {
    private func setupSettingsTableView() {
        multifactorSettingsTableView = UITableView(frame: .zero, style: .plain )
        multifactorSettingsTableView.backgroundColor = lightgray
        
        // MARK: Multifactor
        multifactorSettingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: multifactordefaultcellIdentifier)
        multifactorSettingsTableView.register(MultifactorTwoFABaseCell.self, forCellReuseIdentifier: multifactorbasecellIdentifier)
        multifactorSettingsTableView.register(MultifactorActivationCell.self, forCellReuseIdentifier: multifactoractivationcellIdentifier)
        
        // MARK: 2FA related
        multifactorSettingsTableView.register(MultifactorTwoFAInforCell.self, forCellReuseIdentifier: multifactortwofainfocellIdentifier)
        multifactorSettingsTableView.register(MultifactorTwoFASettingsCell.self, forCellReuseIdentifier: multifactortwofasettingscellIdentifier)
        multifactorSettingsTableView.register(MultifactorTwoFASettingsOptionCell.self, forCellReuseIdentifier: multifactortwofasettingsoptioncellIdentifier)
        
        // MARK: OTP related
        multifactorSettingsTableView.register(MultifactorOTPBaseCell.self, forCellReuseIdentifier: multifactorotpsettingscellIdentifier)
        multifactorSettingsTableView.register(MultifactorOTPActivatedCell.self, forCellReuseIdentifier: multifactorotpsettingsactivatedcellIdentifier)
        multifactorSettingsTableView.register(MultifactorOTPActivatedOptionCell.self, forCellReuseIdentifier: multifactorotpsettingsactivatedoptionscellIdentifier)
        multifactorSettingsTableView.register(MultifactorOTPSendCodeCell.self, forCellReuseIdentifier: multifactorotpsendcodecellIdentifier)
        multifactorSettingsTableView.register(MultifactorOTPAddMobileCell.self, forCellReuseIdentifier: multifactorotpaddmobilecellIdentifier)
        multifactorSettingsTableView.register(MultifactorOTPTypeCodeCell.self, forCellReuseIdentifier: multifactorotptypecodecellIdentifier)
        
        //MARK: Recovery Options selection related
        multifactorSettingsTableView.register(RecoveryOptionSelectionCell.self, forCellReuseIdentifier: recoveryoptionselectioncellIdentifier)
        multifactorSettingsTableView.register(RecoveryOptionsEmailCell.self, forCellReuseIdentifier: recoveryoptionemailcellIdentifier)
        multifactorSettingsTableView.register(RecoveryOptionOtpCell.self, forCellReuseIdentifier: recoveryoptionotpcellidentifier)
        multifactorSettingsTableView.register(RecoveryOtpErrorCell.self, forCellReuseIdentifier: recoveryoptionotperrorcellidentifier)
        multifactorSettingsTableView.register(RecoveryOptionsQuestionsCell.self, forCellReuseIdentifier: recoveryoptionquestioncellIdentifier)
        
        multifactorSettingsTableView.translatesAutoresizingMaskIntoConstraints = false
        multifactorSettingsTableView.dataSource = self
        multifactorSettingsTableView.delegate = self
        multifactorSettingsTableView.tableFooterView = UIView()
        multifactorSettingsTableView.separatorStyle = .none
        multifactorSettingsTableView.showsVerticalScrollIndicator = false
        self.view.addSubview(multifactorSettingsTableView)
        
        let multifactorSettingsTableViewConstraints = [multifactorSettingsTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                                       multifactorSettingsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                                                       multifactorSettingsTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                                       multifactorSettingsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(multifactorSettingsTableViewConstraints)
    }
}

//MARK: - Implement UITableView Datasource
extension MultifactorSettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (multifactorSettingsViewModelData?.numberofRows) != nil {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = multifactorSettingsViewModelData?.numberofRows {
            return rows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let multifactoractivationcell = tableView.dequeueReusableCell(withIdentifier: multifactoractivationcellIdentifier) as! MultifactorActivationCell
            multifactoractivationcell.multifactorsettingsvm = multifactorSettingsViewModelData
            
            multifactoractivationcell.activateSwitchCallBack = { [weak self] multisettings in
                self?.updateCellUIForMultifactor(cellIndex: indexPath.row, multifactorsettingsvm: multisettings)
                return
            }
            return multifactoractivationcell
        case 1:
            switch multifactorSettingsViewModelData.twoFATypeLocal! {
            case 1:
                //OTP
                switch multifactorSettingsViewModelData.subStep! {
                case 0:
                    let multifactorotpsettingsActivatedCell = tableView.dequeueReusableCell(withIdentifier: multifactorotpsettingsactivatedcellIdentifier) as! MultifactorOTPActivatedCell
                    multifactorotpsettingsActivatedCell.multifactorotpactivatedsettingViewModel = multifactorSettingsViewModelData
                    
                    
                    multifactorotpsettingsActivatedCell.multifactorotpactivatedCallBack = { [weak self] (multisettings, reloadall) in
                        self?.updateCellUIForOtp(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                        return
                    }
                    
                    multifactorotpsettingsActivatedCell.multifactorotpactivatedCallBackIntreaction = {
                        [weak self] enable in
                        self?.enabeldisableUserInteraction(userinteraction: enable)
                        return
                    }
                    
                    multifactorotpsettingsActivatedCell.multifactorotpactivatedCallBackSaveCallBack = {
                        [weak self] success in
                        self?.saveSettings(success: success)
                        return
                    }
                    return multifactorotpsettingsActivatedCell
                case 1:
                    let multifactorotpsettingActivateOptionCell = tableView.dequeueReusableCell(withIdentifier: multifactorotpsettingsactivatedoptionscellIdentifier) as! MultifactorOTPActivatedOptionCell
                    multifactorotpsettingActivateOptionCell.multifactorotpoptionsactivatedsettingViewModel = multifactorSettingsViewModelData
                    
                    multifactorotpsettingActivateOptionCell.multifactorotpsettingsoptionCallBack = { [weak self] (multisettings, reloadall) in
                        self?.updateCellUIForOtp(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                        return
                    }
                    
                    multifactorotpsettingActivateOptionCell.multifactorotpoptionsSaveCallBack = {
                        [weak self] enable in
                        self?.enabeldisableUserInteraction(userinteraction: enable)
                        return
                    }
                    
                    multifactorotpsettingActivateOptionCell.multifactootpoptionsusreIntreaction = {
                        [weak self] success in
                        if success {
                            self?.saveSettings(success: success)
                        }
                        return
                    }
                    
                    return multifactorotpsettingActivateOptionCell
                case 2:
                    let multifactorotpsendcodeCell = tableView.dequeueReusableCell(withIdentifier: multifactorotpsendcodecellIdentifier) as! MultifactorOTPSendCodeCell
                    multifactorotpsendcodeCell.multifactorsendcodeSettingsViewModel = multifactorSettingsViewModelData
                    multifactorotpsendcodeCell.multifactorotpsendcodecellCallBack = { [weak self] (multisettings, reloadall) in
                        
                        self?.updateCellUIForOtp(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                        return
                    }
                    
                    multifactorotpsendcodeCell.multifaintaractionCallBack = { [weak self] enable in
                        self?.enabeldisableUserInteraction(userinteraction: enable)
                    }
                    return multifactorotpsendcodeCell
                case 3:
                    let multifactorotpaddmobileCell = tableView.dequeueReusableCell(withIdentifier: multifactorotpaddmobilecellIdentifier) as! MultifactorOTPAddMobileCell
                    multifactorotpaddmobileCell.multifactorotpaddmobileSettingsViewModel = multifactorSettingsViewModelData
                    multifactorotpaddmobileCell.multifactorotpaddmobilecellCallBack = { [weak self] (multisettings, reloadall) in
                        self?.updateCellUIForOtp(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                        return
                    }
                    
                    multifactorotpaddmobileCell.multifactorotpaddmobileChangeCountry = {
                        self.showcountryPickerforOTP()
                        return
                    }
                    return multifactorotpaddmobileCell
                case 4:
                    let multifactorotptypecodeCell = tableView.dequeueReusableCell(withIdentifier: multifactorotptypecodecellIdentifier) as! MultifactorOTPTypeCodeCell
                    multifactorotptypecodeCell.multifactortypcodeSettingsViewModel = multifactorSettingsViewModelData
                    
                    multifactorotptypecodeCell.multifactortypcodecellCallBack = { [weak self] (multisettings, reloadall) in
                        
                        self?.updateCellUIForOtp(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                        return
                    }
                    
                    multifactorotptypecodeCell.multifatypcodeuserIntaraction = { [weak self] enable in
                        self?.enabeldisableUserInteraction(userinteraction: enable)
                        return
                    }
                    
                    return multifactorotptypecodeCell
                default:
                    let multifactorotpsettingscell = tableView.dequeueReusableCell(withIdentifier: multifactorotpsettingscellIdentifier) as! MultifactorOTPBaseCell
                    return multifactorotpsettingscell
                }
            case 2:
                //2FA
                switch multifactorSettingsViewModelData.isBiometricEnabled! {
                case true:
                    
                    switch multifactorSettingsViewModelData.subStep! {
                    case 0:
                        switch  multifactorSettingsViewModelData.recoveryOptionSelected {
                        case 0:
                            //Recovery options not clicked
                            let multifactortwofasettingscell = tableView.dequeueReusableCell(withIdentifier: multifactortwofasettingscellIdentifier) as! MultifactorTwoFASettingsCell
                            
                            multifactortwofasettingscell.delegate = self
                            
                            multifactortwofasettingscell.multifactorsettings = multifactorSettingsViewModelData
                            
                            multifactortwofasettingscell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                return
                            }
                            
                            multifactortwofasettingscell.multifactortwofausreIntreaction = { [weak self] enable in
                                self?.enabeldisableUserInteraction(userinteraction: enable)
                                return
                            }
                            
                            multifactortwofasettingscell.multifactortwofaSaveCallBack = { [weak self] success in
                                self?.saveSettings(success: success)
                                return
                            }
                            
                            return multifactortwofasettingscell
                        default:
                            print("Chathura cell for raw at recovery option cell")
                            //Recovery options clicked
                            switch multifactorSettingsViewModelData.recoveryOptionType {
                            case 1:
                                //Recovery email
                                print("Chathura cell for raw at recovery option cell email")
                                switch multifactorSettingsViewModelData.recoveryoptionsubType {
                                case 0:
                                    //Enter email Cell
                                    let recoveryoptionemailcell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionemailcellIdentifier) as! RecoveryOptionsEmailCell
                                    
                                    recoveryoptionemailcell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                    
                                    recoveryoptionemailcell.showAlert = { [weak self] (message) in
                                        self?.alertSample(strTitle: "Alert", strMsg: message)
                                    }
                                    
                                    recoveryoptionemailcell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                        self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                        return
                                    }
                                    return recoveryoptionemailcell
                                case 1:
                                    //Enter otp cell
                                    let recoveryoptionotpcell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionotpcellidentifier) as! RecoveryOptionOtpCell
                                    
                                    recoveryoptionotpcell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                    
                                    recoveryoptionotpcell.showAlertMessageCallBack = { [weak self] (msg) in
                                        self?.alertSample(strTitle: "Alert", strMsg: msg)
                                    }
                                    
                                    recoveryoptionotpcell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                        self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                        return
                                    }
                                    return recoveryoptionotpcell
                                default:
                                    //Otp Error cell
                                    let recoveryoptionotperrorcell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionotperrorcellidentifier) as! RecoveryOtpErrorCell
                                    
                                    recoveryoptionotperrorcell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                    
                                    recoveryoptionotperrorcell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                        self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                        return
                                    }
                                    return recoveryoptionotperrorcell
                                }
                            case 2:
                                print("Chathura cell for raw at recovery option cell questions")
                                
                                //Recovery questions todo
                                let recoveryoptionquestioncell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionquestioncellIdentifier) as! RecoveryOptionsQuestionsCell
                                
                                recoveryoptionquestioncell.delegate = self
                                recoveryoptionquestioncell.arrSecurityQuestionsAndAnswers = arrSecurityQuestionsAndAnswers
                                
                                recoveryoptionquestioncell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                
                                recoveryoptionquestioncell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                    self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                    return
                                }
                                return recoveryoptionquestioncell
                            default:
                                print("Chathura no recoevry option selected")
                                //No recovery option selected
                                let recoveryoptionselectioncell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionselectioncellIdentifier) as! RecoveryOptionSelectionCell
                                
                                recoveryoptionselectioncell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                
                                recoveryoptionselectioncell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                    self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                    return
                                }
                                return recoveryoptionselectioncell
                                
                                //MARK: - Need to Remove this Code this
                                
                                //                                let recoveryoptionquestioncell = tableView.dequeueReusableCell(withIdentifier: recoveryoptionquestioncellIdentifier) as! RecoveryOptionsQuestionsCell
                                //
                                //                                recoveryoptionquestioncell.recoveryoptionsFallback = multifactorSettingsViewModelData
                                //
                                //                                recoveryoptionquestioncell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                                //                                    self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                                //                                    return
                                //                                }
                                //                                return recoveryoptionquestioncell
                            }
                        }
                    default:
                        let multifactortwofasettingsoptioncell = tableView.dequeueReusableCell(withIdentifier: multifactortwofasettingsoptioncellIdentifier) as! MultifactorTwoFASettingsOptionCell
                        
                        multifactortwofasettingsoptioncell.delegatemultifactorsettingsOptionCell = self
                        
                        multifactortwofasettingsoptioncell.multifactorsettingsoptions = multifactorSettingsViewModelData
                        
                        multifactortwofasettingsoptioncell.setBiometricOnly()
                        
                        multifactortwofasettingsoptioncell.multifactortwofasettingsoptionCallBack = { [weak self] (multisettings, reloadall) in
                            
                            if reloadall != nil {
                                self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: false)
                            } else {
                                self?.multifactorSettingsViewModelData = multisettings
                            }
                            
                            return
                        }
                        
                        multifactortwofasettingsoptioncell.multifactortwofaoptionsusreIntreaction = { [weak self] enable in
                            self?.enabeldisableUserInteraction(userinteraction: enable)
                            return
                        }
                        
                        multifactortwofasettingsoptioncell.multifactortwofaoptionsSaveCallBack = { [weak self] success in
                            self?.saveSettings(success: success)
                            return
                        }
                        
                        multifactortwofasettingsoptioncell.multifactortwofasettingsCallBack = { [weak self] (multisettings, reloadall) in
                            self?.updateCellUIForBiometrics(cellIndex: 1, multifactorsettingsvm: multisettings, reloadall: reloadall)
                            return
                        }
                        
                        return multifactortwofasettingsoptioncell
                    }
                    
                default:
                    let multifactortwofainforcell = tableView.dequeueReusableCell(withIdentifier: multifactortwofainfocellIdentifier) as! MultifactorTwoFAInforCell
                    
                    multifactortwofainforcell.multifactortwofaInfoCallBack = {
                        self.enableBioMetrics()
                    }
                    return multifactortwofainforcell
                }
            default:
                let multifactorbasecell = tableView.dequeueReusableCell(withIdentifier: multifactorbasecellIdentifier) as! MultifactorTwoFABaseCell
                return multifactorbasecell
            }
        default:
            let multifactorbasecell = tableView.dequeueReusableCell(withIdentifier: multifactorbasecellIdentifier) as! MultifactorTwoFABaseCell
            return multifactorbasecell
        }
    }
}

//MARK: - Implement UITableView Delegates
extension MultifactorSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 60))
        headerview.backgroundColor = lightgray
        let headertitle = UILabel(frame: CGRect(x: 10, y: 5, width: deviceWidth - 20, height: 50))
        headertitle.font = UIFont(name: "Helvetica", size: 18)
        headertitle.numberOfLines = 0
        headertitle.adjustsFontSizeToFitWidth = true
        headertitle.minimumScaleFactor = 0.2
        headertitle.text = "You can enable one multi-factor authentication security feature below"
        headertitle.textColor = ColorTheme.lblBodyDefault
        headerview.addSubview(headertitle)
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1:
            return UITableView.automaticDimension
        default:
            return 80
        }
    }
}

//MARK: - Implement Callback function - multifactor
extension MultifactorSettingsViewController {
    
    //MARK: - UI Update for multifactor
    private func updateCellUIForMultifactor(cellIndex: Int, multifactorsettingsvm: MultifactorSettingsViewModel?) {
        self.multifactorSettingsViewModelData = multifactorsettingsvm
        DispatchQueue.main.async {
            self.multifactorSettingsTableView.reloadData()
            self.enabeldisableUserInteraction(userinteraction: true)
            return
        }
    }
}

//MARK: - Implement Callback functions - OTP
extension MultifactorSettingsViewController {
    
    //MARK: - UI Update for OTP
    private func updateCellUIForOtp(cellIndex: Int, multifactorsettingsvm: MultifactorSettingsViewModel?, reloadall: Bool) {
        
        guard let multifactorsettings = multifactorsettingsvm else { return }
        self.multifactorSettingsViewModelData = multifactorsettings
        
        DispatchQueue.main.async {
            if reloadall {
                self.multifactorSettingsTableView.reloadData()
                return
            }
            let indexpath = IndexPath(row: cellIndex, section: 0)
            self.multifactorSettingsTableView.reloadRows(at: [indexpath], with: .none)
            self.enabeldisableUserInteraction(userinteraction: true)
            return
        }
    }
}

//MARK: - Implement CallBack Function Biometric
extension MultifactorSettingsViewController {
    
    //MARK: - Update UI for biometrics
    private func updateCellUIForBiometrics(cellIndex: Int, multifactorsettingsvm: MultifactorSettingsViewModel?, reloadall: Bool) {
        
        guard let multifactorsettings = multifactorsettingsvm else { return }
        self.multifactorSettingsViewModelData = multifactorsettings
        
        DispatchQueue.main.async {
            if reloadall {
                self.multifactorSettingsTableView.reloadData()
                return
            }
            let indexpath = IndexPath(row: cellIndex, section: 0)
            self.multifactorSettingsTableView.reloadRows(at: [indexpath], with: .none)
            self.enabeldisableUserInteraction(userinteraction: true)
            return
        }
    }
    
    //MARK: - Enable Biometrics
    private func enableBioMetrics() {
        let passwordlessvc = PasswordlessOnboardingController()
        passwordlessvc.modalPresentationStyle = .fullScreen
        passwordlessvc.sourceFrom = 2
        passwordlessvc.biometriconboardCallBack = { [weak self] onboard in
            self!.multifactorSettingsViewModelData.isBiometricEnabled = onboard
            DispatchQueue.main.async {
                self?.multifactorSettingsTableView.reloadData()
            }
        }
        self.present(passwordlessvc, animated: true, completion: nil)
    }
}

//MARK: - CallBack Functions
extension MultifactorSettingsViewController {
    
    //MARK: - Country Picker CallBack
    private func showcountryPickerforOTP() {
        let countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            self?.multifactorSettingsViewModelData.countryDialcode = dialcode
            self?.multifactorSettingsViewModelData.countryCode = code
            DispatchQueue.main.async {
                let indexpath = IndexPath(row: 1, section: 0)
                self?.multifactorSettingsTableView.reloadRows(at: [indexpath], with: .none)
                self?.navigationController?.popViewController(animated: true)
            }
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(countryPicker, animated: true)
        }
    }
    
    //MARK: - Disable User Interaction
    private func enabeldisableUserInteraction(userinteraction: Bool) {
        self.multifactorSettingsTableView.isUserInteractionEnabled = userinteraction
    }
    
    //MARK: - Save Settings
    private func saveSettings(success: Bool) {
        success ? showmultifactorAlert(alerttitle: "Success!", alertmessage: "Successfully Saved", actiontitle: "Ok") : showmultifactorAlert(alerttitle: "Failure!", alertmessage: "Unable to Save!", actiontitle: "OK")
    }
}

extension MultifactorSettingsViewController: FallBackQuestionDelegate {
    
    func getSelectedQuestion(questionNumber: Int, question: FallbackQuestionsWithSelect, index: Int) {
        
        arrFallbackQuestions.removeElement(element: question)
        
        if arrSecurityQuestionsAndAnswers[questionNumber - 1].questionModel != nil {
            arrSecurityQuestionsAndAnswers[questionNumber - 1].questionModel?.isSelected = false
            arrFallbackQuestions.append(arrSecurityQuestionsAndAnswers[questionNumber - 1].questionModel!)
        }
        arrSecurityQuestionsAndAnswers[questionNumber - 1] = SecurityQuestion(questionModel: question, answerId: nil, answer: nil, userId: nil)
        
        multifactorSettingsTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .fade)
    }
}

// MARK: - RecoveryOptionsQuestionsCell Delegate

extension MultifactorSettingsViewController: RecoveryOptionsQuestionsCellDelegate {
    
    func openQuestionsVC(selectedQuestion index: Int, isAvailable: Bool) {
        self.presentQuestionVC(number: index, questionIs: isAvailable)
    }
    
    func getAnswer(questionNo: Int, answer: String) {
        arrSecurityQuestionsAndAnswers[questionNo - 1].answer = answer
        arrSecurityQuestionsAndAnswers[questionNo - 1].answerId = String(questionNo)
    }
    
    func didTapOnSaveButton() {
        var isValid: Bool = true
        
        // Validate Questions
        arrSecurityQuestionsAndAnswers.forEach { (securityQuestion) in
            if let _question = securityQuestion.questionModel?.questionPart?.Question {
                if _question.isEmpty {
                    isValid = false
                    alertSample(strTitle: "Alert", strMsg: "Please select question")
                    return
                }
            } else {
                isValid = false
                alertSample(strTitle: "Alert", strMsg: "Please select question")
                return
            }
        }
        
        // Validate Answers
        arrSecurityQuestionsAndAnswers.forEach { (securityQuestion) in
            if let _answer = securityQuestion.answer {
                if _answer.isEmpty {
                    isValid = false
                    alertSample(strTitle: "Alert", strMsg: "Please enter answer")
                    return
                }
            } else {
                isValid = false
                alertSample(strTitle: "Alert", strMsg: "Please enter answer")
                return
            }
        }
        
        guard isValid else {
            return
        }
        
        // Save all Answers
        let arrQuestionsAnswers: [SecurityQuestionAnswer] = [
            SecurityQuestionAnswer(securityQuestion: arrSecurityQuestionsAndAnswers[0]),
            SecurityQuestionAnswer(securityQuestion: arrSecurityQuestionsAndAnswers[1]),
            SecurityQuestionAnswer(securityQuestion: arrSecurityQuestionsAndAnswers[2])
            ]
        
        // Net Req to sent Selected Q&As
        startAnimatingNotification()
        
        var fallbackquestionRequest = FallbackQuestionRequest()
        let securityquestionAnswers: [SecurityQuestionAnswer] = arrQuestionsAnswers
        fallbackquestionRequest.FallbackQuestions = securityquestionAnswers
            
        fallbackquestionRequest.updateSecurityQuestionAnswerData(securityQuestionAnswerUpdate: fallbackquestionRequest) { [unowned self] (success, message) in
            self.stopAnimatingNotification(isSuccess: success)
            if success {
                self.multifactorSettingsViewModelData.isfallbackEnable = true
                self.multifactorSettingsViewModelData.recoveryOptionType = 2
            } else {

            }
        }
    }
    
    func startAnimatingNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil, userInfo: nil)
    }
    
    func stopAnimatingNotification(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: isSuccess, userInfo: nil)
    }
    
    func beforeFallbackpathsuccessNotification(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotification"), object: isSuccess, userInfo: nil)
    }
}

// MARK: - MultifactorTwoFASettingsCell Delegate
extension MultifactorSettingsViewController: nameMultifactorTwoFASettingsCellDelegate {
    
    func onSaveBiometricSettings(multisettings: MultifactorSettingsViewModel) {
        print("Chathura save biometric settings ",multisettings)
        
        startAnimatingNotificationMultifactorSettingsOptionCell()
        
        let savesetting = MultifactorSaveSettings(multifactorsettingsviewmodel: multisettings)
        savesetting.postBiometricSettings(multifactorsettings: savesetting) { (biometricsettings, statuscode, message) in
            
            if let biometricsettings = biometricsettings {
                
                if statuscode == 1000 {
                    self.stopAnimatingNotificationMultifactorSettingsOptionCell(isSuccess: true)
                    
                   
                    return
                } else {
                    if statuscode == 5005 {
                        self.beforeFallbackpathsuccessNotificationMultifactorSettingsCell(isSuccess: true)
                        
                        if let biometricFallbackOptions = biometricsettings.BiometricFallbackOptions {
                            if let biometricfallbackType = biometricFallbackOptions.Type {
                                
                                let bioemticsSettings = BiometricSettings(TwoFAType: savesetting.TwoFAType, LoginVerificationType: savesetting.LoginVerificationType, ApprovalVerificationType: savesetting.ApprovalVerificationType, IsBiometricEnabled: savesetting.IsBiometricEnabled)
                                
                                if biometricfallbackType == 1 {
                                    if let fallbackOprtions = biometricFallbackOptions.FallbackOptions {
                                        self.biometricFallbackOtp(biometricsettings: bioemticsSettings, email: fallbackOprtions[0])
                                        return
                                    }
                                    return
                                }
                                if biometricfallbackType == 2 {
                                    if let fallbackoptions = biometricFallbackOptions.FallbackOptions {
                                        let question1 = fallbackoptions[0]
                                        let question2 = fallbackoptions[1]
                                        let question3 = fallbackoptions[2]
                                        self.biometricFallbackQuestion(biometricsettings: bioemticsSettings, q1: question1, q2: question2, q3: question3)
                                        return
                                    }
                                }
                            }
                            return
                        }
                    }
                    
                    self.stopAnimatingNotificationMultifactorSettingsOptionCell(isSuccess: false)
                    return
                }
            }
            
            self.stopAnimatingNotificationMultifactorSettingsOptionCell(isSuccess: false)
            return
        }
    }
    
    func startAnimatingNotificationMultifactorSettingsOptionCell() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil, userInfo: nil)
    }
    
    func stopAnimatingNotificationMultifactorSettingsOptionCell(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: isSuccess, userInfo: nil)
    }
    
    func beforeFallbackpathsuccessNotificationMultifactorSettingsCell(isSuccess: Bool) {
          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotificationMultifactorSettingsCell"), object: isSuccess, userInfo: nil)
    }
}

// MARK: - MultifactorTwoFASettingsCell Delegate
extension MultifactorSettingsViewController: MultifactorTwoFASettingsOptionCellDelegate {
    
    func onSaveBiometricSettingsMutifactorSettingsOptionCell(multisettings: MultifactorSettingsViewModel) {
        print("Chathura save biometric settings Option cell 123",multisettings)
        
        startAnimatingNotification()
        
        let savesetting = MultifactorSaveSettings(multifactorsettingsviewmodel: multisettings)
        savesetting.postBiometricSettings(multifactorsettings: savesetting) { (biometricsettings, statuscode, message) in
            
            if let biometricsettings = biometricsettings {
                
                if statuscode == 1000 {
                    self.stopAnimatingNotification(isSuccess: true)
                    
                    return
                } else {
                    if statuscode == 5005 {
                        self.beforeFallbackpathsuccessNotificationMultifactorSettingsOptionCell(isSuccess: true)
                        
                        if let biometricFallbackOptions = biometricsettings.BiometricFallbackOptions {
                            if let biometricfallbackType = biometricFallbackOptions.Type {
                                
                                let bioemticsSettings = BiometricSettings(TwoFAType: savesetting.TwoFAType, LoginVerificationType: savesetting.LoginVerificationType, ApprovalVerificationType: savesetting.ApprovalVerificationType, IsBiometricEnabled: savesetting.IsBiometricEnabled)
                                
                                if biometricfallbackType == 1 {
                                    if let fallbackOprtions = biometricFallbackOptions.FallbackOptions {
                                        self.biometricFallbackOtp(biometricsettings: bioemticsSettings, email: fallbackOprtions[0])
                                        return
                                    }
                                    return
                                }
                                if biometricfallbackType == 2 {
                                    if let fallbackoptions = biometricFallbackOptions.FallbackOptions {
                                        let question1 = fallbackoptions[0]
                                        let question2 = fallbackoptions[1]
                                        let question3 = fallbackoptions[2]
                                        self.biometricFallbackQuestion(biometricsettings: bioemticsSettings, q1: question1, q2: question2, q3: question3)
                                        return
                                    }
                                }
                            }
                            return
                        }
                    }
                    
                    self.stopAnimatingNotification(isSuccess: false)
                    return
                }
            }
            
            self.stopAnimatingNotification(isSuccess: false)
            return
        }
    }
    
    func beforeFallbackpathsuccessNotificationMultifactorSettingsOptionCell(isSuccess: Bool) {
           NotificationCenter.default.post(name: NSNotification.Name(rawValue: "StopAnimatingNotificationFallbackSuccessMultifactorSettingsOptionCell"), object: isSuccess, userInfo: nil)
     }
}
