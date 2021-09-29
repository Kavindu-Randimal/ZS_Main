//
//  VcardController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import ADCountryPicker

class VcardController: BaseVC {
    
    private var footerViewContent: UIView!
    private var footerCancelBtn: UIButton!
    private var footerSaveBtn: UIButton!
    private var tableViewvcard: UITableView!
    private var alertController: UIAlertController!
    private var backdropView: UIView!
    private var backdropIndicator: UIActivityIndicatorView!
    private var countryImagePhone: UIImage!
    private var countryImageOfficePhone : UIImage!
    
    private var firstName: String!
    private var lastName: String!
    private var phone: String!
    private var officephone: String!
    private var phoneFlag: String!
    private var officephoneFlag: String!
    private var email: String!
    private var companyName: String!
    private var jobtitle: String!
    private var addressLine1: String!
    private var addressLine2: String!
    private var city: String!
    private var state: String!
    private var zipcode: String!
    private var country: String!
    private var countryCode: String!
    private var website: String!
    private var dialcodelabelOfficePhone: String!
    private var dialcodelabelPhone: String!
    
    private var userProfile: UserProfile!
    private var companynameisEditable: Bool! = true
    private var countryPicker: ADCountryPicker!
    
    private let vcardTextCellIdentifier = "vcardTextCellIdentifier"
    private let vcardPickerCellIdentifier = "vacrdPickerCellIdentifier"
    private let vcardcountrycellIdentifier = "vcardcountrycellIdentifier"
    private let vcardemailIdentifier = "vcardemailIdentifier"
    
    let greencolor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLoading()
        setnavbar()
        createFooterView()
        createTextFieldView()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        getprofileDetails()
    }
    
}

//MARK: - Add Activity Indicator constarints
extension VcardController {
    fileprivate func setupLoading() {
        
        backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.backgroundColor = .white
        view.addSubview(backdropView)
        
        let backdropviewConstraints = [backdropView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       backdropView.topAnchor.constraint(equalTo: view.topAnchor),
                                       backdropView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                       backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(backdropviewConstraints)
        
        backdropIndicator = UIActivityIndicatorView(style: .whiteLarge)
        backdropIndicator.translatesAutoresizingMaskIntoConstraints = false
        backdropView.addSubview(backdropIndicator)
        backdropIndicator.color = ColorTheme.activityindicator
        
        let backdropindicatorConstraints = [backdropIndicator.centerXAnchor.constraint(equalTo: backdropView.centerXAnchor),
                                            backdropIndicator.centerYAnchor.constraint(equalTo: backdropView.centerYAnchor),
                                            backdropIndicator.widthAnchor.constraint(equalToConstant: 50),
                                            backdropIndicator.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(backdropindicatorConstraints)
    }
}

//MARK: Show Alert message
extension VcardController {
    private func showalertMessage(title: String, message: String, canecl: Bool) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = ColorTheme.lblBgSpecial
        
        let okaction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            if title == "Successful !"  {
                self.onclickOkay()
            }
        }
        alertController.addAction(okaction)
        
        if canecl {
            let cancelaction = UIAlertAction(title: "cancel", style: .cancel){
                (alert) in
                self.onclickCancel()
            }
            alertController.addAction(cancelaction)
        }
        
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true, completion: nil)
        }
    }
}

//MARK: Alert Actions
extension VcardController {
    @objc func onclickOkay(){
        ZorroTempData.sharedInstance.setUserprofile(userprofile: self.userProfile)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func onclickCancel(){}
}

//MARK: Show Backdrop
extension VcardController {
    private func showbackdrop(){
        backdropIndicator.startAnimating()
        backdropView.isHidden = false
        view.bringSubviewToFront(backdropView)
    }
}

//MARK: Hide Backdrop
extension VcardController {
    private func hidebackdop(){
        backdropIndicator.stopAnimating()
        backdropView.isHidden = true
        view.sendSubviewToBack(backdropView)
    }
}

//MARK: Setup Navbar
extension VcardController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Business Card Details"
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTitleDefault
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

//MARK: - Footer content implementation
extension VcardController{
    fileprivate func createFooterView(){
        let safearea = view.safeAreaLayoutGuide
        
        footerViewContent = UIView()
        footerViewContent.translatesAutoresizingMaskIntoConstraints = false
        footerViewContent.backgroundColor = .white
        view.addSubview(footerViewContent)
        
        let footerviewConstraints = [footerViewContent.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     footerViewContent.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     footerViewContent.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                     footerViewContent.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(footerviewConstraints)
        
        let buttonWidth = UIScreen.main.bounds.width/2 - 20
        
        footerCancelBtn = UIButton()
        footerCancelBtn.translatesAutoresizingMaskIntoConstraints = false
        footerCancelBtn.setTitle("CANCEL", for: .normal)
        footerCancelBtn.setTitleColor(ColorTheme.btnTextWithoutBG, for: .normal)
        footerCancelBtn.backgroundColor = .white
        
        footerViewContent.addSubview(footerCancelBtn)
        
        let footercancelbuttonConstraints = [footerCancelBtn.leftAnchor.constraint(equalTo: footerViewContent.leftAnchor, constant: 10),
                                             footerCancelBtn.topAnchor.constraint(equalTo: footerViewContent.topAnchor, constant: 5),
                                             footerCancelBtn.bottomAnchor.constraint(equalTo: footerViewContent.bottomAnchor, constant: -5),
                                             footerCancelBtn.widthAnchor.constraint(equalToConstant: buttonWidth)]
        NSLayoutConstraint.activate(footercancelbuttonConstraints)
        
        footerCancelBtn.layer.borderColor = ColorTheme.btnBorder.cgColor
        footerCancelBtn.layer.borderWidth = 2
        footerCancelBtn.layer.cornerRadius = 5
        footerCancelBtn.layer.masksToBounds = true
        
        footerCancelBtn.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        footerSaveBtn = UIButton()
        footerSaveBtn.translatesAutoresizingMaskIntoConstraints = false
        footerSaveBtn.setTitle("SAVE", for: .normal)
        footerSaveBtn.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        footerSaveBtn.backgroundColor = ColorTheme.btnBG
        
        footerViewContent.addSubview(footerSaveBtn)
        
        let footersavebuttonConstraints = [footerSaveBtn.rightAnchor.constraint(equalTo: footerViewContent.rightAnchor, constant: -10),
                                           footerSaveBtn.topAnchor.constraint(equalTo: footerViewContent.topAnchor, constant: 5),
                                           footerSaveBtn.bottomAnchor.constraint(equalTo: footerViewContent.bottomAnchor, constant: -5),
                                           footerSaveBtn.widthAnchor.constraint(equalToConstant: buttonWidth)]
        NSLayoutConstraint.activate(footersavebuttonConstraints)
        
        footerSaveBtn.layer.cornerRadius = 5
        footerSaveBtn.layer.masksToBounds = true
        
        footerSaveBtn.addTarget(self, action: #selector(saveData(_:)), for: .touchUpInside)
        
    }
}

//MARK: - Setup textfields content
extension VcardController{
    fileprivate func createTextFieldView(){
        
        let safearea = view.safeAreaLayoutGuide
        
        tableViewvcard = UITableView()
        tableViewvcard.register(VcardTextCell.self, forCellReuseIdentifier: vcardTextCellIdentifier)
        tableViewvcard.register(VcardPhonePickerCell.self, forCellReuseIdentifier: vcardPickerCellIdentifier)
        tableViewvcard.register(VcardCountryPickerCell.self, forCellReuseIdentifier: vcardcountrycellIdentifier)
        tableViewvcard.register(VcardEmailCell.self, forCellReuseIdentifier: vcardemailIdentifier)
        tableViewvcard.translatesAutoresizingMaskIntoConstraints = false
        tableViewvcard.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        tableViewvcard.tableFooterView = UIView()
        tableViewvcard.separatorStyle = .none
        tableViewvcard.dataSource = self
        tableViewvcard.delegate = self
        view.addSubview(tableViewvcard)
        
        let textfiledtableviewConstraints = [tableViewvcard.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             tableViewvcard.topAnchor.constraint(equalTo: safearea.topAnchor),
                                             tableViewvcard.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             tableViewvcard.bottomAnchor.constraint(equalTo: footerViewContent.topAnchor)]
        NSLayoutConstraint.activate(textfiledtableviewConstraints)
        
    }
}

//MARK: - TableView datasource methods
extension VcardController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 2:
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: vcardPickerCellIdentifier) as! VcardPhonePickerCell
            textFieldCell.callBackPicker = {
                self.selectCountryCodePhone(row: indexPath.row)
                return
            }
            textFieldCell.callBack = {[weak self](textIndex, textString) in
                self?.setgenerictextfieldValues(index: textIndex, text: textString)
                return
            }
            textFieldCell.numberwithoutCode = phone
            textFieldCell.countryImageValue = countryImagePhone
            textFieldCell.countryCodeLabel = dialcodelabelPhone
            textFieldCell.textfieleIndex = indexPath.row
            
            return textFieldCell
        case 3:
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: vcardPickerCellIdentifier) as! VcardPhonePickerCell
            textFieldCell.callBackPicker = {
                self.selectCountryCodeOfficePhone(row: indexPath.row)
                return
            }
            textFieldCell.callBack = {[weak self](textIndex, textString) in
                self?.setgenerictextfieldValues(index: textIndex, text: textString)
                return
            }
            textFieldCell.numberwithoutCode = officephone
            textFieldCell.countryImageValue = countryImageOfficePhone
            textFieldCell.countryCodeLabel = dialcodelabelOfficePhone
            textFieldCell.textfieleIndex = indexPath.row
            
            return textFieldCell
        case 4:
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: vcardemailIdentifier) as! VcardEmailCell
            textFieldCell.textfieleIndex = indexPath.row
            textFieldCell.textfieldinitialValue = email
            
            return textFieldCell
        case 12:
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: vcardcountrycellIdentifier) as! VcardCountryPickerCell
            textFieldCell.callbackcountryPicker = {
                self.selectcountry(row: indexPath.row)
                return
            }
            textFieldCell.textfieleIndex = indexPath.row
            textFieldCell.textfieldinitialValue = country
            
            return textFieldCell
        default:
            let textFieldCell = tableView.dequeueReusableCell(withIdentifier: vcardTextCellIdentifier) as! VcardTextCell
            textFieldCell.callBack = {[weak self](textIndex, textString) in
                self?.setgenerictextfieldValues(index: textIndex, text: textString)
                return
            }
            textFieldCell.textfieleIndex = indexPath.row
            
            if indexPath.row == 0 {
                textFieldCell.textfieldinitialValue = firstName
            }
            if indexPath.row == 1 {
                textFieldCell.textfieldinitialValue = lastName
            }
            if indexPath.row == 5{
                textFieldCell.textfieldinitialValue = companyName
                textFieldCell.editablecompanyName = companynameisEditable
            }
            if indexPath.row == 6 {
                textFieldCell.textfieldinitialValue = jobtitle
            }
            if indexPath.row == 7 {
                textFieldCell.textfieldinitialValue = addressLine1
            }
            if indexPath.row == 8 {
                textFieldCell.textfieldinitialValue = addressLine2
            }
            if indexPath.row == 9 {
                textFieldCell.textfieldinitialValue = city
            }
            if indexPath.row == 10 {
                textFieldCell.textfieldinitialValue = state
            }
            if indexPath.row == 11 {
                textFieldCell.textfieldinitialValue = zipcode
            }
            if indexPath.row == 13 {
                textFieldCell.textfieldinitialValue = website
            }
            
            return textFieldCell
        }
    }
    
}

//MARK: - TableView delegate methods
extension VcardController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

//MARK: - Set textfield values
extension VcardController{
    fileprivate func setgenerictextfieldValues(index:Int, text:String){
        switch index{
        case 0:
            firstName = text
        case 1:
            lastName = text
        case 2:
            phone = text
        case 3:
            officephone = text
        case 4:
            email = text
        case 5:
            companyName = text
        case 6:
            jobtitle = text
        case 7:
            addressLine1 = text
        case 8:
            addressLine2 = text
        case 9:
            city = text
        case 10:
            state = text
        case 11:
            zipcode = text
        case 12:
            country = text
        case 13:
            website = text
        default:
            return
        }
    }
}

//MARK: - Country picker select method
extension VcardController {
    fileprivate func selectcountry(row: Int){
        countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            DispatchQueue.main.async {
                self?.country = name
                self?.countryCode = code
                let indexpath = IndexPath(row: row, section: 0)
                DispatchQueue.main.async {
                    self?.tableViewvcard.reloadRows(at: [indexpath], with: .fade)
                }
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(self.countryPicker, animated: true)
        }
    }
}

//MARK: - Picker select method for phone
extension VcardController {
    fileprivate func selectCountryCodePhone(row: Int) {
        countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            DispatchQueue.main.async {
                let countryImage = self?.setcountryImage(countryCode: code)
                self?.countryImagePhone = countryImage
                self?.dialcodelabelPhone = dialcode
                self?.phoneFlag = code
                let indexpath = IndexPath(row: row, section: 0)
                DispatchQueue.main.async {
                    self?.tableViewvcard.reloadRows(at: [indexpath], with: .fade)
                }
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(self.countryPicker, animated: true)
        }
    }
}

//MARK: - Picker select method for office phone
extension VcardController {
    private func selectCountryCodeOfficePhone(row: Int){
        countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            DispatchQueue.main.async {
                let countryImage = self?.setcountryImage(countryCode: code)
                self?.countryImageOfficePhone = countryImage
                self?.dialcodelabelOfficePhone = dialcode
                self?.officephoneFlag = code
                let indexpath = IndexPath(row: row, section: 0)
                DispatchQueue.main.async {
                    self?.tableViewvcard.reloadRows(at: [indexpath], with: .fade)
                }
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(self.countryPicker, animated: true)
        }
    }
}

//MARK: - Set Country Image
extension VcardController {
    private func setcountryImage(countryCode: String) -> UIImage? {
        let bundle = "assets.bundle/"
        let image = UIImage(named: bundle + countryCode + ".png",
                            in: Bundle(for: ADCountryPicker.self), compatibleWith: nil)
        
        return image ?? nil
    }
}

//MARK: - Format the phone code
extension VcardController {
    private func getdialCode(code: String) -> String{
        let splitcode = code.components(separatedBy: "+")
        return splitcode[1]
    }
}

//MARK: - Get dial code and flag
extension VcardController {
    private func getflaganddialcode(code: String) -> [String]{
        let splitedcode = code.components(separatedBy: "|")
        if splitedcode.indices.contains(0) && splitedcode.indices.contains(1) {
            let countrycode = splitedcode[0]
            let phonecode = "+" + splitedcode[1]
            return [countrycode,phonecode]
        }
        else{
            return ["",code]
        }
    }
}

//MARK:- Api call to get profile details
extension VcardController {
    private func getprofileDetails(){
        
        let isconnected = Connectivity.isConnectedToInternet()
        if(!isconnected){
            showalertMessage(title: "Connection !", message: "No Internet connection, Please try again later", canecl: false)
            return
        }
        
        showbackdrop()
        
        userProfile = UserProfile()
        userProfile.getuserprofileData { (userprofile, err) in
            if(!err){
                
                self.hidebackdop()
                
                self.userProfile = userprofile!
                guard let userprofile = userprofile else { return }
                
                self.firstName = userprofile.Data?.FirstName
                self.lastName = userprofile.Data?.LastName
                self.email = userprofile.Data?.Email
                self.jobtitle = userprofile.Data?.JobTitle
                self.addressLine1 = userprofile.Data?.AddressLine1
                self.addressLine2 = userprofile.Data?.AddressLine2
                self.city = userprofile.Data?.City
                self.state = userprofile.Data?.StateCode
                self.zipcode = userprofile.Data?.ZipCode
                self.country = userprofile.Data?.Country
                self.website = userprofile.Data?.WebSite
                
                if userprofile.Data?.PhoneContryCode != "" {
                    let temp1 = self.getflaganddialcode(code: (userprofile.Data?.PhoneContryCode)!)
                    self.dialcodelabelPhone = temp1[1]
                    self.countryImagePhone = self.setcountryImage(countryCode: temp1[0].uppercased())
                    
                    let formattedPhone = userprofile.Data?.PhoneNumber
                    let dialcodelablephoneCount = self.dialcodelabelPhone.count
                    self.phone = String((formattedPhone?.dropFirst(dialcodelablephoneCount))!)
                }
                else {
                    self.dialcodelabelPhone = "+1"
                    self.phoneFlag = "US"
                    self.countryImagePhone = self.setcountryImage(countryCode: "US")
                    self.phone = userprofile.Data?.PhoneNumber
                }
                
                if userprofile.Data?.OfficePhoneContryCode != "" {
                    let temp2 = self.getflaganddialcode(code: (userprofile.Data?.OfficePhoneContryCode)!)
                    self.dialcodelabelOfficePhone = temp2[1]
                    self.countryImageOfficePhone = self.setcountryImage(countryCode: temp2[0].uppercased())
                    
                    let formattedofficePhone = userprofile.Data?.OfficePhoneNumber
                    let dialcodeofficephonelabelCount = self.dialcodelabelOfficePhone.count
                    self.officephone = String(((formattedofficePhone?.dropFirst(dialcodeofficephonelabelCount))!))
                }
                else {
                    self.dialcodelabelOfficePhone = "+1"
                    self.officephoneFlag = "US"
                    self.countryImageOfficePhone = self.setcountryImage(countryCode: "US")
                    self.officephone = userprofile.Data?.OfficePhoneNumber
                }
                
                if userprofile.Data?.UserType == 1 {
                    let organizationdetails = OrganizationDetails()
                    organizationdetails.geturerorganizationDetails { (orgdetails) in
                        
                        if let orglegalname = orgdetails?.Data?.Organization?.LegalName {
                            ZorroTempData.sharedInstance.setOrganizationLegalname(legalname: orglegalname)
                            self.companyName = orglegalname
                            self.companynameisEditable = false
                            
                            DispatchQueue.main.async {
                                self.tableViewvcard.reloadData()
                            }
                        }
                        return
                    }
                    
                }
                
                if userprofile.Data?.UserType == 2 {
                    self.companynameisEditable = true
                    self.companyName = userprofile.Data?.BusinessName
                    
                    DispatchQueue.main.async {
                        self.tableViewvcard.reloadData()
                    }
                }
                
                ZorroTempData.sharedInstance.setUserprofile(userprofile: userprofile)
                
            }
            return
        }
    }
}

//MARK: - Footer save button action
extension VcardController {
    @objc fileprivate func saveData(_ sender:UIButton){
        
        if(self.firstName != "" && self.lastName != "" && self.phone != "" && self.officephone != ""){
            
            let isconnected = Connectivity.isConnectedToInternet()
            if(!isconnected){
                showalertMessage(title: "Connection !", message: "No Internet connection, Please try again later", canecl: false)
                return
            }
            
            showbackdrop()
            
            userProfile.Data?.FirstName = firstName
            userProfile.Data?.LastName = lastName
            userProfile.Data?.PhoneNumber = dialcodelabelPhone + phone
            userProfile.Data?.OfficePhoneNumber = dialcodelabelOfficePhone + officephone
            userProfile.Data?.JobTitle = jobtitle
            userProfile.Data?.AddressLine1 = addressLine1
            userProfile.Data?.AddressLine2 = addressLine2
            userProfile.Data?.City = city
            userProfile.Data?.StateCode = state
            userProfile.Data?.ZipCode = zipcode
            userProfile.Data?.Country = country
            userProfile.Data?.CountryCode = countryCode
            userProfile.Data?.WebSite = website
            
            if phoneFlag != nil {
                userProfile.Data?.PhoneContryCode = phoneFlag + "|" + getdialCode(code: dialcodelabelPhone)
            }
            
            if officephoneFlag != nil {
                userProfile.Data?.OfficePhoneContryCode =  officephoneFlag + "|" + getdialCode(code: dialcodelabelOfficePhone)
            }
            
            if userProfile.Data?.UserType == 2 {
                userProfile.Data?.BusinessName = companyName
            }
            
            let userprofileUpdate = UserProfileUpdate(userprofile: userProfile)
            
            userprofileUpdate.updateuserprofileData(userprofileupdate: userprofileUpdate){
                (success, errmsg) in
                if(success){
                    self.hidebackdop()
                    self.showalertMessage(title: "Successful !", message: "Business card updated successfully", canecl: false)
                }else{
                    self.hidebackdop()
                    self.showalertMessage(title: "Error !", message: errmsg!, canecl: false)
                }
                return
            }
        }else{
            if self.firstName == "" {
                showalertMessage(title: "", message: "First name should not be blank", canecl: false)
                return
            }
            if self.lastName == "" {
                showalertMessage(title: "", message: "Last name should not be blank", canecl: false)
                return
            }
            if self.phone == "" {
                showalertMessage(title: "", message: "Phone number should not be blank", canecl: false)
                return
            }
            if self.officephone == "" {
                showalertMessage(title: "", message: "Office phone number should not be blank", canecl: false)
                return
            }
        }
        
    }
}

//MARK: - Footer cancel button action
extension VcardController {
    @objc fileprivate func cancelAction(_ sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}
