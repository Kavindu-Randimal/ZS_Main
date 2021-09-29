//
//  DocumentInitiateSaveProcessController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift
import CoreLocation

class DocumentInitiateSaveWorkflowController: DocumentInitiateBaseController {
    
    var newInitiatedViews: [ZorroDocumentInitiateBaseView]!
    var newInitiatedDynamictextViews: [ZorroDocumentInitiateBaseView]!
    var newInitiatedDynamicnoteViews: [ZorroDocumentInitiateBaseView]!
    var documentPages: [UIImageView]!
    var getWorkFlowData: GetWorkflowData!
    var otpapprovalType: Int = 0
    private var otpCode: Int = 0
    private var userPassword: String = ""
    private var selectedDate:String = ""
    private var selectedCellIndex:Int?
    
    // Geo Loc Variables
    var latitude: String = ""
    var longitude: String = ""
    let locationManager = CLLocationManager()
    
    
    private var passwordView: UIView!
    private var passwordHeader: UILabel!
    private var passwordText: UITextField!
    private var passwordagreeTextView: UIView!
    private var passwordagreementText: UILabel!
    
    private var footerView: UIView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    
    private var duedateandsummaryView: UIView!
    private var duedatelabel: UILabel!
    private var duedateText: UILabel!
    private var dateview: UIView!
    private var dateStepper: UIStepper!
    private var daystextField: UITextField!
    private var dayslabel: UILabel!
    
    private var documentdueImage: UIImageView!
    private var documentdueText: UILabel!
    private var pickerContaierView:UIView!
    
    private var allSteps: [Steps]?
    private var auditrailView: ZorroAuditTrailView!
    private let disposebag = DisposeBag()
    private var zoomScale: CGFloat!
    
    var dueDate: Int = 0
    var errorMessage: String = ""
    
    init(zoomscale: CGFloat) {
        super.init(nibName: nil, bundle: nil)
        self.zoomScale = zoomscale
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        getCurrentLocation()
        fetchmuiltifactorSettings()
        
        //Show Subscription Banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
    }
    
    // MARK: - Location Config
    
    func getCurrentLocation() {
        
        locationManager.delegate = self
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Location Delegate

extension DocumentInitiateSaveWorkflowController: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //handle denied
            break
        case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
           break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = String(locValue.latitude)
        longitude = String(locValue.longitude)
    }
}

//MARK: - Setup footer view ui
extension DocumentInitiateSaveWorkflowController {
    fileprivate func setfooterView() {
        
        let safearea = view.safeAreaLayoutGuide
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(footerView)
        
        let footerviewConstriaints = [footerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                      footerView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor, constant: -5),
                                      footerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                      footerView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(footerviewConstriaints)
        
        let buttonWidth = deviceWidth/2 - 20
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(greencolor, for: .normal)
        footerView.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: footerView.leftAnchor),
                                       cancelButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
                                       cancelButton.topAnchor.constraint(equalTo: footerView.topAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: buttonWidth)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.backgroundColor = greencolor
        footerView.addSubview(confirmButton)
        
        let confirmbuttonConstraints = [confirmButton.rightAnchor.constraint(equalTo: footerView.rightAnchor),
                                        confirmButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
                                        confirmButton.topAnchor.constraint(equalTo: footerView.topAnchor),
                                        confirmButton.widthAnchor.constraint(equalToConstant: buttonWidth)]
        NSLayoutConstraint.activate(confirmbuttonConstraints)
        
        confirmButton.layer.masksToBounds = true
        confirmButton.layer.cornerRadius = 5
        
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
}


//MARK: - setup password view
extension DocumentInitiateSaveWorkflowController {
    fileprivate func setpasswordView() {
        
        passwordView = UIView()
        passwordView.translatesAutoresizingMaskIntoConstraints = false
        passwordView.backgroundColor = .white
        
        view.addSubview(passwordView)
        
        let passwordviewConstraints = [passwordView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       passwordView.bottomAnchor.constraint(equalTo: footerView.topAnchor),
                                       passwordView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                       passwordView.heightAnchor.constraint(equalToConstant: deviceHeight/4)]
        NSLayoutConstraint.activate(passwordviewConstraints)
        
        passwordHeader = UILabel()
        passwordHeader.translatesAutoresizingMaskIntoConstraints = false
        passwordHeader.text = "PASSWORD *"
        passwordHeader.font = UIFont(name: "Helvetica", size: 17)
        passwordHeader.textColor = .black
        passwordView.addSubview(passwordHeader)
        
        let passwordheaderConstraints = [passwordHeader.leftAnchor.constraint(equalTo: passwordView.leftAnchor, constant: 10),
                                         passwordHeader.topAnchor.constraint(equalTo: passwordView.topAnchor, constant: 5),
                                         passwordHeader.rightAnchor.constraint(equalTo: passwordView.rightAnchor),
                                         passwordHeader.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(passwordheaderConstraints)
        
        passwordText = UITextField()
        passwordText.translatesAutoresizingMaskIntoConstraints = false
        passwordText.isSecureTextEntry = true
        passwordText.borderStyle = .roundedRect
        passwordText.placeholder = "* * * * *"
        
        passwordView.addSubview(passwordText)
        
        let passwordtextConstraints = [passwordText.leftAnchor.constraint(equalTo: passwordView.leftAnchor, constant: 10),
                                       passwordText.topAnchor.constraint(equalTo: passwordHeader.bottomAnchor, constant: 5),
                                       passwordText.rightAnchor.constraint(equalTo: passwordView.rightAnchor, constant: -10),
                                       passwordText.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(passwordtextConstraints)
        
        passwordagreeTextView = UIView()
        passwordagreeTextView.translatesAutoresizingMaskIntoConstraints = false
        passwordagreeTextView.backgroundColor = lightgray
        
        passwordView.addSubview(passwordagreeTextView)
        
        let passwordagreeTextViewConstraints = [passwordagreeTextView.leftAnchor.constraint(equalTo: passwordView.leftAnchor, constant: 10),
                                                passwordagreeTextView.topAnchor.constraint(equalTo: passwordText.bottomAnchor, constant: 5),
                                                passwordagreeTextView.rightAnchor.constraint(equalTo: passwordView.rightAnchor, constant: -10),
                                                passwordagreeTextView.bottomAnchor.constraint(equalTo: passwordView.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(passwordagreeTextViewConstraints)
        
        passwordagreeTextView.layer.masksToBounds = true
        passwordagreeTextView.layer.cornerRadius = 5
        
        passwordagreementText = UILabel()
        passwordagreementText.translatesAutoresizingMaskIntoConstraints = false
        passwordagreementText.textColor = .black
        passwordagreementText.numberOfLines = 100
        passwordagreementText.font = UIFont(name: "Helvetica", size: 15)
        passwordagreementText.text =  "By entering my password or biometric, I acknowledge I have electronically signed or entered information whereby making this document legally binding."
        passwordagreementText.adjustsFontSizeToFitWidth = true
        passwordagreementText.minimumScaleFactor = 0.2
        passwordagreeTextView.addSubview(passwordagreementText)
        
        let apsswordagreementtextConstraints = [passwordagreementText.leftAnchor.constraint(equalTo: passwordagreeTextView.leftAnchor, constant: 5),
                                                passwordagreementText.topAnchor.constraint(equalTo: passwordagreeTextView.topAnchor, constant: 5),
                                                passwordagreementText.rightAnchor.constraint(equalTo: passwordagreeTextView.rightAnchor, constant: -5),
                                                passwordagreementText.bottomAnchor.constraint(equalTo: passwordagreeTextView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(apsswordagreementtextConstraints)
        
        switch otpapprovalType {
        case 2,4:
            passwordView.isHidden = true
        default:
            passwordView.isHidden = false
        }
    }
}

//MARK: Setup due date UI
extension DocumentInitiateSaveWorkflowController {
    fileprivate func setduedateandsummaryView() {
        
        let safearea = view.safeAreaLayoutGuide
        
        duedateandsummaryView = UIView()
        duedateandsummaryView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(duedateandsummaryView)
        
        let duedateandsummaryviewConstraints = [duedateandsummaryView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                                duedateandsummaryView.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 5),
                                                duedateandsummaryView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                                duedateandsummaryView.bottomAnchor.constraint(equalTo: passwordView.topAnchor, constant: -5)]
        NSLayoutConstraint.activate(duedateandsummaryviewConstraints)
        
        duedateandsummaryView.layer.masksToBounds = true
        duedateandsummaryView.layer.cornerRadius = 5
        duedateandsummaryView.layer.borderColor = lightgray.cgColor
        duedateandsummaryView.layer.borderWidth = 1
    }
}

//MARK: Setup AudiTrail UI
extension DocumentInitiateSaveWorkflowController {
    fileprivate func setdueDate() {
        duedatelabel = UILabel()
        duedatelabel.translatesAutoresizingMaskIntoConstraints = false
        duedatelabel.text = "DUE DATE"
        duedatelabel.font = UIFont(name: "Helvetica", size: 17)
        duedateandsummaryView.addSubview(duedatelabel)
        
        let duedatelabelConstraints = [duedatelabel.leftAnchor.constraint(equalTo: duedateandsummaryView.leftAnchor, constant: 5),
                                       duedatelabel.topAnchor.constraint(equalTo: duedateandsummaryView.topAnchor, constant: 5),
                                       duedatelabel.rightAnchor.constraint(equalTo: duedateandsummaryView.rightAnchor, constant: -5),
                                       duedatelabel.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(duedatelabelConstraints)
        
        duedateText = UILabel()
        duedateText.translatesAutoresizingMaskIntoConstraints = false
        duedateText.numberOfLines = 100
        duedateText.font = UIFont(name: "Helvetica", size: 15)
        duedateText.text = "Change the due date for this document or you may use the default. You may also adjust due date for individuals in the workflow."
        duedateText.adjustsFontSizeToFitWidth = true
        duedateText.minimumScaleFactor = 0.2
        duedateandsummaryView.addSubview(duedateText)
        
        let duedatetextConstraints = [duedateText.leftAnchor.constraint(equalTo: duedateandsummaryView.leftAnchor, constant: 5),
                                      duedateText.topAnchor.constraint(equalTo: duedatelabel.bottomAnchor, constant: 5),
                                      duedateText.rightAnchor.constraint(equalTo: duedateandsummaryView.rightAnchor, constant: -5),
                                      duedateText.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(duedatetextConstraints)
        
        dateview = UIView()
        dateview.translatesAutoresizingMaskIntoConstraints = false
        duedateandsummaryView.addSubview(dateview)
        
        let dateviewConstraints = [dateview.rightAnchor.constraint(equalTo: duedateandsummaryView.rightAnchor, constant: -5),
                                   dateview.topAnchor.constraint(equalTo: duedateText.bottomAnchor),
                                   dateview.heightAnchor.constraint(equalToConstant: 40),
                                   dateview.widthAnchor.constraint(equalToConstant: deviceWidth/2)]
        NSLayoutConstraint.activate(dateviewConstraints)
        
        dateview.layer.masksToBounds = true
        dateview.layer.cornerRadius = 5
        dateview.layer.borderColor = lightgray.cgColor
        dateview.layer.borderWidth = 1
        
        dateStepper = UIStepper()
        dateStepper.translatesAutoresizingMaskIntoConstraints = false
        dateStepper.tintColor = .darkGray
        dateStepper.minimumValue = 0
        dateStepper.maximumValue = 999
        dateStepper.contentMode = .left
        dateview.addSubview(dateStepper)
        dateStepper.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        
        let datestepperConstraints = [dateStepper.centerYAnchor.constraint(equalTo: dateview.centerYAnchor),
                                      dateStepper.leftAnchor.constraint(equalTo: dateview.leftAnchor, constant: 5)]
        NSLayoutConstraint.activate(datestepperConstraints)
        dateStepper.addTarget(self, action: #selector(duedateStepperAction(_:)), for: .touchUpInside)
        
        dayslabel = UILabel()
        dayslabel.translatesAutoresizingMaskIntoConstraints = false
        dayslabel.font = UIFont(name: "Helvetica", size: 15)
        dayslabel.textAlignment = .right
        dayslabel.text = "" + "   DAY(S)"
        dayslabel.adjustsFontSizeToFitWidth = true
        dayslabel.minimumScaleFactor = 0.2
        dateview.addSubview(dayslabel)
        
        let displaylabelConstraints = [dayslabel.centerYAnchor.constraint(equalTo: dateview.centerYAnchor),
                                       dayslabel.rightAnchor.constraint(equalTo: dateview.rightAnchor, constant: -5),
                                       dayslabel.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(displaylabelConstraints)
        
        daystextField = UITextField()
        daystextField.translatesAutoresizingMaskIntoConstraints = false
        daystextField.backgroundColor = .clear
        daystextField.keyboardType = .numberPad
        daystextField.textAlignment = .center
        daystextField.delegate = self
        dateview.addSubview(daystextField)
        
        let daystextfieldConstrints = [daystextField.leftAnchor.constraint(equalTo: dateStepper.rightAnchor, constant: 0),
                                       daystextField.centerYAnchor.constraint(equalTo: dateview.centerYAnchor),
                                       daystextField.rightAnchor.constraint(equalTo: dayslabel.leftAnchor, constant: 0),
                                       daystextField.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(daystextfieldConstrints)
        daystextField.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        
        
        documentdueImage = UIImageView()
        documentdueImage.translatesAutoresizingMaskIntoConstraints = false
        documentdueImage.contentMode = .center
        documentdueImage.backgroundColor = .clear
        documentdueImage.image = UIImage(named: "Document-expire")
        
        duedateandsummaryView.addSubview(documentdueImage)
        
        let documentdueimageConstraints = [documentdueImage.leftAnchor.constraint(equalTo: duedateandsummaryView.leftAnchor),
                                           documentdueImage.centerYAnchor.constraint(equalTo: dateview.centerYAnchor),
                                           documentdueImage.widthAnchor.constraint(equalToConstant: 40),
                                           documentdueImage.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(documentdueimageConstraints)
        
        documentdueText = UILabel()
        documentdueText.translatesAutoresizingMaskIntoConstraints = false
        documentdueText.text = "Document due in"
        documentdueText.font = UIFont(name: "Helvetica", size: 15)
        documentdueText.adjustsFontSizeToFitWidth = true
        documentdueText.numberOfLines = 2
        documentdueText.minimumScaleFactor = 0.2
        duedateandsummaryView.addSubview(documentdueText)
        
        let docuumentduetextConstrints = [documentdueText.leftAnchor.constraint(equalTo: documentdueImage.rightAnchor, constant: 2),
                                          documentdueText.rightAnchor.constraint(equalTo: dateview.leftAnchor, constant: -2),
                                          documentdueText.centerYAnchor.constraint(equalTo: dateview.centerYAnchor)]
        NSLayoutConstraint.activate(docuumentduetextConstrints)
    }
}

//MARK: - Due Date action
extension DocumentInitiateSaveWorkflowController {
    @objc fileprivate func duedateStepperAction(_ sender: UIStepper) {
        dueDate = Int(sender.value)
        
        if FeatureMatrix.shared.set_reminders {
            dueDate = Int(sender.value)

            if dueDate == 0 {
                daystextField.text = ""
            } else {
                daystextField.text = "\(dueDate)"
            }

            allSteps = DocumentHelper.sharedInstance.getnewtagsStepDetails(newinitiatedViews: newInitiatedViews, pages: documentPages, duedate: dueDate)
            SharingManager.sharedInstance.triggeronDueDateChangeFromView(userSteps: allSteps!)
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}

//MARK: - Set TextField delegates
extension DocumentInitiateSaveWorkflowController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowCharacters.isSuperset(of: characterSet)
    }
    
    @objc private func textfieldDidChange(_ textField: UITextField) {
        
        if FeatureMatrix.shared.set_reminders {
            
        if textField.text!.count <= 6 {
                print(textField.text ?? "")
                guard let duedatestring = textField.text else { return }
                guard let duedate = Int(duedatestring) else { return }
                
                dueDate = duedate
                dateStepper.value = Double(duedate)
                allSteps = DocumentHelper.sharedInstance.getnewtagsStepDetails(newinitiatedViews: newInitiatedViews, pages: documentPages, duedate: dueDate)
                SharingManager.sharedInstance.triggeronDueDateChangeFromView(userSteps: allSteps!)
            } else {
                textField.deleteBackward()
            }
        } else {
            textField.deleteBackward()
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}

//MARK: - Setup Audit Trail
extension DocumentInitiateSaveWorkflowController {
    fileprivate func setupAuditTrail() {
        auditrailView = ZorroAuditTrailView()
        allSteps = DocumentHelper.sharedInstance.getnewtagsStepDetails(newinitiatedViews: newInitiatedViews, pages: documentPages, duedate: dueDate)
        auditrailView.UserSteps = allSteps!
        auditrailView.translatesAutoresizingMaskIntoConstraints = false
        auditrailView.backgroundColor = .lightGray
        duedateandsummaryView.addSubview(auditrailView)
        
        let auditrailviewConstriants = [auditrailView.leftAnchor.constraint(equalTo: duedateandsummaryView.leftAnchor),
                                        auditrailView.topAnchor.constraint(equalTo: dateview.bottomAnchor, constant: 5),
                                        auditrailView.rightAnchor.constraint(equalTo: duedateandsummaryView.rightAnchor),
                                        auditrailView.bottomAnchor.constraint(equalTo: duedateandsummaryView.bottomAnchor)]
        
        NSLayoutConstraint.activate(auditrailviewConstriants)
    }
}

//MARK: - Fetch muiltifactor settings
extension DocumentInitiateSaveWorkflowController {
    private func fetchmuiltifactorSettings() {
        showbackDrop()
        
        let multifactorsettingsresponse = MultifactorSettingsResponse()
        multifactorsettingsresponse.getuserMultifactorSettings {
            (multifactorsettingsdata) in
            
            self.hidebackDrop()
            
            guard let multifactorsettingsData = multifactorsettingsdata else { return }
            
            self.otpapprovalType = multifactorsettingsData.ApprovalVerificationType!
            
            self.setfooterView()
            self.setpasswordView()
            self.setduedateandsummaryView()
            self.setdueDate()
            self.setupAuditTrail()
            self.updatedueDate()
            self.configureUIDatePicker()
            
            self.pickerContaierView.isHidden = true
        }
    }
}

//MARK: - Check duedate difference
extension DocumentInitiateSaveWorkflowController {
    private func checkDuedateDifference(steps: [Steps], duedate: Int, completion: @escaping(Bool) -> ()) {
        let isvalid = DocumentHelper.sharedInstance.checkDifferenceDuedate(steps: steps, duedate: duedate)
        if isvalid {
            completion(true)
            return
        }
        completion(false)
        return
    }
}

//MARK: - Check step duedate validity
extension DocumentInitiateSaveWorkflowController {
    private func checkWorkflowDuedates(steps: [Steps], completion: @escaping(Bool) -> ()) {
        let isvalid = DocumentHelper.sharedInstance.checkWorklfowStepsDuedateOrder(steps: steps)
        if isvalid {
            completion(true)
            return
        }
        completion(false)
        return
    }
}

//MARK: - Check password empty
extension DocumentInitiateSaveWorkflowController {
    private func checkPasswordEmpty(completion: @escaping(Bool) -> ()) {
        let _password = self.passwordText.text ?? ""
        if _password == "" {
            completion(true)
            return
        }
        completion(false)
        return
    }
}

//MARK: - Button actions
extension DocumentInitiateSaveWorkflowController {
    @objc fileprivate func confirmAction(_ sender: UIButton) {
        checkDuedateDifference(steps: allSteps!, duedate: dueDate) { [self] isvalid in
            if isvalid {
                checkWorkflowDuedates(steps: allSteps!) { inOrder in
                    if inOrder {
                        self.createEsign()
                        return
                    }
                    self.showalertMessage(title: "Alert", message: "Invalid due date(s) assigned to step(s).", cancel: false)
                    return
                }
                return
            }
            self.showalertMessage(title: "Alert", message: "Maximum due date exceeds the validity period.", cancel: false)
            return
        }
    }
    
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Create esign
extension DocumentInitiateSaveWorkflowController {
    private func createEsign() {
        
        switch otpapprovalType {
        case 2:
            let _requestOtp = OTPVerify()
            _requestOtp.requestOTP { [weak self] (success, otpissue) in
                if success {
                    
                    if otpissue {
                        self?.showalertMessage(title: "Unable to Save!", message: "You have to verify One Time Password (OTP) to change mobile number. Please contact support@zorrosign.com or submit support ticket to reset OTP settings.", cancel: false)
                        return
                    }
                    
                    self!.showotpView { [weak self] (_otpCode) in
                        self!.otpCode = _otpCode
                        self!._confirmworkflowAction()
                        return
                    }
                }
                return
                //TODO: fallback
            }
            
            return
        case 3:
            checkPasswordEmpty { isempty in
                if !isempty {
                    self.userPassword = self.passwordText.text ?? ""
                    let _requestotpwithpassword = OTPRequestwithPassword(issingleInstance: true, password: self.userPassword)
                    _requestotpwithpassword.requestuserotpWithPassword(otprequestwithpassword: _requestotpwithpassword) { [weak self] (success, otpissue) in
                        
                        if success {
                            
                            if otpissue {
                                self!.showalertMessage(title: "Unable to Save!", message: "You have to verify One Time Password (OTP) to change mobile number. Please contact support@zorrosign.com or submit support ticket to reset OTP settings.", cancel: false)
                                return
                            }
                            
                            self!.showotpView { [weak self] (_otpCode) in
                                self!.otpCode = _otpCode
                                self!._confirmworkflowAction()
                                return
                            }
                        }
                        return
                        //TODO: fallback
                    }
                    return
                }
                self.showalertMessage(title: "Alert", message: "Password cannot be empty", cancel: false)
                return
            }
            return
        case 4:
            self._confirmworkflowAction()
            return
        case 5:
            checkPasswordEmpty { isempty in
                if !isempty {
                    self.userPassword = self.passwordText.text ?? ""
                    let _requestotpwithpassword = OTPRequestwithPassword(issingleInstance: true, password: self.userPassword)
                    _requestotpwithpassword.requestuserotpWithPassword(otprequestwithpassword: _requestotpwithpassword) { [weak self] (success, hasissue) in
                        
                        if success {
                            if hasissue {
                                self!.showalertMessage(title: "Unable to Save!", message: "Check your password again", cancel: false)
                                return
                            }
                            self!._confirmworkflowAction()
                        }
                        return
                        //TODO: fallback
                    }
                    return
                }
                self.showalertMessage(title: "Alert", message: "Password cannot be empty", cancel: false)
                return
            }
            
            return
        default:
            checkPasswordEmpty { isempty in
                if !isempty {
                    self.userPassword = self.passwordText.text ?? ""
                    self._confirmworkflowAction()
                    return
                }
                self.showalertMessage(title: "Alert", message: "Password cannot be empty", cancel: false)
                return
            }
            return
        }
    }
}

//MARK: Button Helpers
extension DocumentInitiateSaveWorkflowController {
    private func _confirmworkflowAction() {
        
        showbackDrop()
        
        if allSteps == nil {
            allSteps = DocumentHelper.sharedInstance.getnewtagsStepDetails(newinitiatedViews: newInitiatedViews, pages: documentPages, duedate: dueDate)
        }
        
        let documentSteps: [Steps] = allSteps!
        
        let documentdynamicTexts: [DynamicTextDetails] = DocumentHelper.sharedInstance.getnewDynamicTextDetails(newinitiatedDynamictextViews: newInitiatedDynamictextViews, pages: documentPages)
        
        let documentdynamicNotes: [NoteDetails] = DocumentHelper.sharedInstance.getnewDynamicNoteDetails(newinitiatedDynamicNoteViews: newInitiatedDynamicnoteViews, pages: documentPages)
        
        var documents: [Documents] = []
        
        for document in getWorkFlowData!.Documents! {
            let newdocument = Documents(ObjectId: document.ObjectId, DocType: document.DocType, Name: document.Name, OriginalName: document.OriginalName)
            documents.append(newdocument)
        }
        
        var _instancevalidPeriod: Int?
        dueDate == 0 ? (_instancevalidPeriod = nil) : (_instancevalidPeriod = dueDate)
        
        let docsaveWorkflow = DocSaveWorkflow(Id: "\(getWorkFlowData!.Id!)", Name: getWorkFlowData?.Name, Description: getWorkFlowData?.Description, Documents: documents, Steps: documentSteps, IsDraft: false, IsSingleInstance: true, NoteDetails: documentdynamicNotes, DynamicTextDetails: documentdynamicTexts, KBAStatus: -1, OTPCode: otpCode, Password: userPassword, CanSendEmail: true, InstanceValidPeriod: _instancevalidPeriod)
        
        var isUserIncluded: Bool = false
        docsaveWorkflow.Steps?.forEach({ (step) in
            step.Tags.forEach { (tag) in
                tag.Signatories?.forEach({ (signatory) in
                    if signatory.userName == ZorroTempData.sharedInstance.getUserEmail() {
                        isUserIncluded = true
                    }
                })
            }
        })
         
        docsaveWorkflow.saveWorkFlowDetails(docsaveworkflow: docsaveWorkflow) { (success, message) in
            print(success)
            self.errorMessage = message ?? ""
            if success {
                let createprocess = CreateProcess(DocumentSetName: self.getWorkFlowData?.Name, IsSingleInstance: true, IsUserPlaceHolderExists: false, Steps: documentSteps, WorkflowDefinitionId: "\(self.getWorkFlowData!.Id!)")
                createprocess.createWorkflowProcess(createprocess: createprocess, completion: { (success, instancid) in
                    
                    let shouldcallsaveall = DocumentHelper.sharedInstance.shoulldcallSaveallProcess(steps: documentSteps)
                    print(shouldcallsaveall)
                    if shouldcallsaveall {
                        ZorroHttpClient.sharedInstance.getDocumentProcess(instanceID: String(instancid!), completion: { (docprocess, err, code) in
                            
                            let pdfPassword = ZorroTempData.sharedInstance.getpdfprotectionPassword()
                            var docsaveprocess = DocumentHelper.sharedInstance.getdocsaveProcessObject(pwd: self.userPassword, otpcode: self.otpCode, docprocess: docprocess!, pdfPassword: pdfPassword)
                            
                            if isUserIncluded {
                                // Add the Location
                                docsaveprocess.processSaveDetailsDto[0].geoLocation = "\(self.latitude),\(self.longitude)"
                            }
                            
                            docsaveprocess.savedocumentProcess(docsaveprocess: docsaveprocess, completion: { (success, err) in
                                
                                print("DOCUMENT SAVE PROCESS : \(success) if err -> \(err ?? "")")
                                if success {
                                    ZorroTempData.sharedInstance.setpdfprotectionPassword(password: "")
                                    self.navigationController?.popToRootViewController(animated: true)
                                    return
                                } else {
                                    self.hidebackDrop()
                                    self.showalertMessage(title: "Alert", message: err ?? "Unable to complete the process", cancel: false)
                                }
                            })
                            
                        })
                        return
                    }
                    ZorroTempData.sharedInstance.setpdfprotectionPassword(password: "")
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                })
                return
            }
            self.hidebackDrop()
            self.showalertMessage(title: "Unable to save workflow", message: self.errorMessage, cancel: false)
        }
    }
}


//MARK: Generic alert functions
extension DocumentInitiateSaveWorkflowController {
    override func genericokAction() {
        print("working")
        return
    }
    
    override func genericcancelAction() {
        print("cancel Works")
        return
    }
}

//MARK: Show OTP
extension DocumentInitiateSaveWorkflowController {
    private func showotpView(completion: @escaping(Int) -> ()) {
        showbackDrop()
        let otpapprovalController = OTPApprovalController()
        otpapprovalController.providesPresentationContextTransitionStyle = true
        otpapprovalController.definesPresentationContext = true
        otpapprovalController.modalPresentationStyle = .overCurrentContext
        otpapprovalController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        otpapprovalController.otpapprovalCallback = { [weak self] otp in
            self?.hidebackDrop()
            if otp != nil {
                completion(otp!)
                return
            }
            return
        }
        
        otpapprovalController.otpverificationCancel = { [weak self] in
            self?.hidebackDrop()
            return
        }
        
        DispatchQueue.main.async {
            self.present(otpapprovalController, animated: true, completion: nil)
        }
    }
}

//MARK: Popover Presentation Delegates
extension DocumentInitiateSaveWorkflowController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: Sharing Manager
extension DocumentInitiateSaveWorkflowController {
    fileprivate func updatedueDate() {
        SharingManager.sharedInstance.onduedateChange?.observeOn(MainScheduler.instance).subscribe(onNext: {
            [weak self] changedduedate in
            let (index,_) = changedduedate
            self!.selectedCellIndex = index
            if(self!.selectedDate == ""){
                self!.setCurrentdateToPicker()
            }
            if(self!.daystextField.text != ""){
                self?.pickerContaierView.isHidden = false
            }
            //self?.pickerContaierView.isHidden = false
        }).disposed(by: disposebag)
    }
}

//MARK: UIDatePicker Configuration
extension DocumentInitiateSaveWorkflowController {
    func configureUIDatePicker(){
        pickerContaierView = UIView()
        pickerContaierView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pickerContaierView)
        let pickerContaierViewConstraints = [pickerContaierView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             pickerContaierView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                             pickerContaierView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             pickerContaierView.heightAnchor.constraint(equalToConstant: 121)]
        NSLayoutConstraint.activate(pickerContaierViewConstraints)
        pickerContaierView.backgroundColor = UIColor.white
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: 1.0)
        topBorder.backgroundColor = UIColor.white.cgColor //UIColor.lightGray.cgColor
        pickerContaierView.layer.addSublayer(topBorder)
        
        let uiDatePicker = UIDatePicker()
        pickerContaierView.addSubview(uiDatePicker)
        uiDatePicker.translatesAutoresizingMaskIntoConstraints = false
        let uiDatePickerconstraints = [uiDatePicker.centerXAnchor.constraint(equalTo: pickerContaierView.centerXAnchor),
                                       uiDatePicker.bottomAnchor.constraint(equalTo: pickerContaierView.bottomAnchor),
                                       uiDatePicker.centerYAnchor.constraint(equalTo: pickerContaierView.centerYAnchor),
                                       uiDatePicker.heightAnchor.constraint(equalToConstant: 90)]
        NSLayoutConstraint.activate(uiDatePickerconstraints)
        
        uiDatePicker.datePickerMode = .date
        uiDatePicker.minimumDate = Date()
        uiDatePicker.timeZone = NSTimeZone.local
        uiDatePicker.tintColor = UIColor.black
        uiDatePicker.backgroundColor = UIColor.white
        uiDatePicker.addTarget(self, action:#selector(DocumentInitiateSaveWorkflowController.onDatePickerValueChange(_:)), for: .valueChanged)
        pickerContaierView.addSubview(uiDatePicker)
        
        
        let pickerDoneButton = UIButton()
        pickerDoneButton.translatesAutoresizingMaskIntoConstraints = false
        pickerContaierView.addSubview(pickerDoneButton)
        let doneBtnConstraints = [
            pickerDoneButton.topAnchor.constraint(equalTo: pickerContaierView.topAnchor,constant: 1.0),
            pickerDoneButton.rightAnchor.constraint(equalTo: pickerContaierView.rightAnchor),
            pickerDoneButton.widthAnchor.constraint(equalToConstant: 60),
            pickerDoneButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(doneBtnConstraints)
        
        pickerDoneButton.backgroundColor = .white
        pickerDoneButton.setTitle("Done", for: .normal)
        pickerDoneButton.setTitleColor(lightblue, for: .normal)
        pickerDoneButton.addTarget(self, action: #selector(setDate), for: .touchUpInside)
        
        let pickerCancelButton = UIButton()
        pickerCancelButton.translatesAutoresizingMaskIntoConstraints = false
        pickerContaierView.addSubview(pickerCancelButton)
        let cancelBtnConstraints = [
            pickerCancelButton.topAnchor.constraint(equalTo: pickerContaierView.topAnchor,constant: 1.0),
            pickerCancelButton.leftAnchor.constraint(equalTo: pickerContaierView.leftAnchor),
            pickerCancelButton.widthAnchor.constraint(equalToConstant: 60),
            pickerCancelButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(cancelBtnConstraints)
        
        pickerCancelButton.backgroundColor = .white
        pickerCancelButton.setTitle("Cancel", for: .normal)
        pickerCancelButton.setTitleColor(lightblue, for: .normal)
        pickerCancelButton.addTarget(self, action: #selector(dismissPicker), for: .touchUpInside)
    }
}

//MARK: Close the Picker
extension DocumentInitiateSaveWorkflowController{
    @objc func dismissPicker() {
        pickerContaierView.isHidden = true
    }
}

//MARK: Picker Done Method
extension DocumentInitiateSaveWorkflowController{
    @objc func setDate(){
        SharingManager.sharedInstance.triggerSelectDate(index: selectedCellIndex!, date: selectedDate)
        SharingManager.sharedInstance.onduedateChangefromView?.observeOn(MainScheduler.instance).subscribe(onNext:{
            [weak self] newusersteps in
            var tempnewusersteps = newusersteps
            if let _selectedCellIndex = self!.selectedCellIndex {
                tempnewusersteps.indices.forEach {_ in
                    if let _cellindex = Int("$\(_selectedCellIndex)") {
                        if tempnewusersteps[_cellindex].Tags.count > 0 {
                            tempnewusersteps[_cellindex].Tags[0].dueDate = self?.selectedDate
                        }
                    }
                }
                self?.allSteps = tempnewusersteps
            }
        }).disposed(by: disposebag)
        pickerContaierView.isHidden = true
    }
}

//MARK: set today as the initial date to Uidatepicker
extension DocumentInitiateSaveWorkflowController{
    fileprivate func setCurrentdateToPicker(){
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMM d, yyyy"
        let formattedDate = format.string(from: date)
        selectedDate = formattedDate
    }
}

//MARK: UIDatePicker date onchange
extension DocumentInitiateSaveWorkflowController{
    @objc fileprivate func onDatePickerValueChange(_ sender:UIDatePicker){
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        selectedDate = dateFormatter.string(from: sender.date)
    }
}

