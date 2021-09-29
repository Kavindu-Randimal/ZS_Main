//
//  CompanyProfileViewController.swift
//  ZorroSign
//
//  Created by Apple on 26/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CropViewController
import LUAutocompleteView

class CompanyProfileViewController: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, CropViewControllerDelegate {

    @IBOutlet weak var viewBottomDashborad: UIView!
    //@IBOutlet weak var viewBottomStart: UIView!
    @IBOutlet weak var viewBottomSearch: UIView!
    @IBOutlet weak var viewBottomMyAccount: UIView!
    @IBOutlet weak var btnBottomHelp: UIView!
    
    @IBOutlet weak var imgcompanyContainerView: UIView!
    @IBOutlet weak var imgCompanyView: UIImageView!
    @IBOutlet weak var imgStampView: UIImageView!
    @IBOutlet weak var imgDashboard: UIImageView!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgMyAccount: UIImageView!
    @IBOutlet weak var imgHelp: UIImageView!
    
    @IBOutlet weak var lblDashboard: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblMyAccount: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet weak var legalName: UILabel!
    @IBOutlet weak var txtTradeLicNumber: UITextField!
    @IBOutlet weak var txtTradeLicExpDate: UITextField!
    @IBOutlet weak var txtDoingBusinessAs: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtRegisterCountry: UITextField!
    @IBOutlet weak var txtIndustry: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    
    @IBOutlet weak var viewTLN: UIView!
    @IBOutlet weak var viewTLED: UIView!
    @IBOutlet weak var viewDBA: UIView!
    @IBOutlet weak var viewRC: UIView!
    @IBOutlet weak var viewI: UIView!
    @IBOutlet weak var viewE: UIView!
    @IBOutlet weak var viewA1: UIView!
    @IBOutlet weak var viewA2: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var viewS: UIView!
    @IBOutlet weak var viewCo: UIView!
    @IBOutlet weak var viewZC: UIView!
    @IBOutlet weak var viewPN: UIView!
    @IBOutlet weak var lblUpload: UILabel!
    
    
    @IBOutlet weak var stackViewBusiness: UIStackView!
    @IBOutlet var viewSubs: [UIView]!
    
    // constraints outlets
    
    @IBOutlet  var labelHeights: [NSLayoutConstraint]!
    
    @IBOutlet weak var buttonstackviewTop: NSLayoutConstraint!
    @IBOutlet weak var buttonstackviewHeight: NSLayoutConstraint!
    @IBOutlet weak var cameraImage: UIImageView!

    
    
    
    var strOid = String()
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()

    var strPid = String()
    var strBase64 = String()
    var strCountryCode = String()
    
    var strImage = String()
    var strStampImage: String = ""
    let picker = UIImagePickerController()
    
    let pickerView = UIPickerView()
    var headerAPIDashboard = [String : String]()
    var jsonCountry = JSON()
    
    var txtTagId = Int()
    
    var arrIndustry: [IndustryData] = []
    
    var industryPicker: UIPickerView!
    var selIndustry: Int?
    var selCountryCode: String?
    var countryArr: [CountryData] = []
    var countryNameArr: [String] = []
    
    let datepicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
    
    var startDate: Date?
    
    private let autocompleteCountryView = LUAutocompleteView()
    private let autocompleteRegCountryView = LUAutocompleteView()
    
    private var croppingStyle = CropViewCroppingStyle.default
    var stmpimage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        setStyles()
        
//        viewTLN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewTLED.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewDBA.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewRC.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewE.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewI.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewA1.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewA2.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewC.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewS.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewCo.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewZC.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
//        viewPN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        
        container.frame = view.frame
        container.center = view.center
        container.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
        
        self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.loadingView.center = view.center
        self.loadingView.backgroundColor = .clear//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)//UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
        self.loadingView.clipsToBounds = true
        self.loadingView.layer.cornerRadius = 10
        
        self.actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.actInd.style = UIActivityIndicatorView.Style.whiteLarge
        self.actInd.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)
        self.actInd.color = ColorTheme.activityindicator
//        let lblWait: UILabel = UILabel()
//        lblWait.text = ""
//        lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
//        lblWait.font = lblWait.font.withSize(13)
//        lblWait.textAlignment = .center
//        lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        self.loadingView.addSubview(lblWait)
        
        self.loadingView.addSubview(self.actInd)
        container.addSubview(self.loadingView)
        view.addSubview(container)
        
        //create industry picker
        industryPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        industryPicker.dataSource = self
        industryPicker.delegate = self
        txtIndustry.inputView = industryPicker
        
        self.actInd.startAnimating()

        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]

//        imgCompanyView.layer.cornerRadius = imgCompanyView.frame.size.width / 2;
//        imgCompanyView.clipsToBounds = true
        
        btnUpdate.layer.cornerRadius = 3
        btnUpdate.clipsToBounds = true
        btnCancel.layer.cornerRadius = 3
        btnCancel.clipsToBounds = true

        pickerView.delegate = self
        txtCountry.delegate = self
        txtRegisterCountry.delegate = self
        txtCountry.inputView = pickerView
        txtRegisterCountry.inputView = pickerView
        
        //setAutocompleteView()
        
        viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
        lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
        lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
        viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite

        
        //Gesture bottom
        let gestureDashboard = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureStart = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureSearch = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureMyAccount = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureHelp = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        
        viewBottomDashborad.addGestureRecognizer(gestureDashboard)
        //viewBottomStart.addGestureRecognizer(gestureStart)
        viewBottomSearch.addGestureRecognizer(gestureSearch)
        viewBottomMyAccount.addGestureRecognizer(gestureMyAccount)
        btnBottomHelp.addGestureRecognizer(gestureHelp)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.touchHappen(_:)))
        tap.delegate = self
        imgCompanyView.addGestureRecognizer(tap)
        imgCompanyView.isUserInteractionEnabled = true
    
        if Connectivity.isConnectedToInternet() == true
        {
            print(headerAPIDashboard)
            //"https://zsdemowebuser.zorrosign.com/api/"
            //https://zsdemowebuser.zorrosign.com/api/Organization/GetOrganizationDetails
            //Singletone.shareInstance.apiURL + "Organization/GetOrganizationDetails"
            
            let api = "Organization/GetOrganizationDetails"
            let apiURL = Singletone.shareInstance.apiURL + api
                
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                   // print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        let legalname = "LEGAL NAME : \(jsonObj["Data"]["Organization"]["LegalName"].stringValue)"
                        let attributedstring = NSMutableAttributedString(string: legalname)
                        let boldstring = "\(jsonObj["Data"]["Organization"]["LegalName"].stringValue)"
                        attributedstring.setFont(forText: boldstring, fontsize: 16)
                        self.legalName.attributedText = attributedstring
                        self.txtTradeLicNumber.text = jsonObj["Data"]["Organization"]["TradeLicenseNumber"].stringValue
                        self.txtTradeLicExpDate.text = String(jsonObj["Data"]["Organization"]["TradeLicenseExpiryDate"].stringValue.split(separator: "T")[0])
                        self.txtDoingBusinessAs.text = jsonObj["Data"]["Organization"]["DBA"].stringValue
                        self.txtEmail.text = jsonObj["Data"]["OrganizationContact"]["Email"].stringValue
                        self.txtRegisterCountry.text = jsonObj["Data"]["Organization"]["Country"].stringValue
                        self.txtAddress1.text = jsonObj["Data"]["OrganizationContact"]["AddressLine1"].stringValue
                        self.txtAddress2.text = jsonObj["Data"]["OrganizationContact"]["AddressLine2"].stringValue
                        self.txtCity.text = jsonObj["Data"]["OrganizationContact"]["City"].stringValue
                        self.txtState.text = jsonObj["Data"]["OrganizationContact"]["StateCode"].stringValue
                        self.txtCountry.text = jsonObj["Data"]["OrganizationContact"]["Country"].stringValue
                        self.txtZipcode.text = jsonObj["Data"]["OrganizationContact"]["ZipCode"].stringValue
                        self.txtPhoneNumber.text = jsonObj["Data"]["OrganizationContact"]["PhoneNumber"].stringValue
                        self.strCountryCode = jsonObj["Data"]["OrganizationContact"]["CountryCode"].stringValue//jsonObj["Data"]["CountryCode"].stringValue
//                        self.strUid = jsonObj["Data"]["OrganizationContact"]["UserId"].stringValue
                        self.strOid = jsonObj["Data"]["OrganizationContact"]["OrganizationId"].stringValue

                        self.selCountryCode = jsonObj["Data"]["Organization"]["CountryCode"].stringValue
                        
                        if let i = self.countryArr.index(where: { $0.Code == self.selCountryCode?.uppercased() })
                        {
                            self.txtRegisterCountry.text = self.countryArr[i].Name
                        }
                        
                        if jsonObj["Data"]["Organization"]["Logo"].stringValue != ""
                        {
                            let strImg: String = jsonObj["Data"]["Organization"]["Logo"].stringValue
                            let strImgArr = strImg.split(separator: ",")
                            if strImgArr.count > 1 {
                                self.strImage = String(strImgArr[1])
                                
                                let dataDecoded : Data = Data(base64Encoded: String(strImgArr[1]), options: .ignoreUnknownCharacters)!
                                let decodedimage = UIImage(data: dataDecoded)
                                
                                self.imgCompanyView.image = decodedimage
                                
                                self.lblUpload.isHidden = true
                            }
                        }
                        let strImg: String = jsonObj["Data"]["Organization"]["Stamp"].stringValue
                        if !strImg.isEmpty {
                            
                            ZorroHttpClient.sharedInstance.getOrganizationStamp(completion: { (orgstapm, err) in
                                if err {
                                    let strImgArr = strImg.split(separator: ",")
                                    if strImgArr.count > 1 {
                                        self.strStampImage = String(strImgArr[1])
                                        
                                        let decodedimage = self.strStampImage.base64ToImage()
                                        self.imgStampView.image = decodedimage
                                        
                                    }
                                }
                                
                                guard let stampimage = orgstapm?.Data?.StampImage else { return }
                                self.strStampImage = stampimage.components(separatedBy: ",")[1]
                                let decodedimage = self.strStampImage.base64ToImage()
                                self.imgStampView.image = decodedimage
                            })
                            
                            
                        }
                        let businessCatId = jsonObj["Data"]["Organization"]["BusinessCategoryId"].stringValue
                        
                        self.selIndustry = Int(businessCatId)! + 1
                        self.getIndustryList(catId: businessCatId)
                        
                        DispatchQueue.main.async {
                            self.actInd.stopAnimating()
                            self.actInd.hidesWhenStopped = true
                            self.container.isHidden = true
                            
                        }
                        
                        //Singletone.shareInstance.stopActivityIndicator()
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.actInd.stopAnimating()
                            self.actInd.hidesWhenStopped = true
                            self.container.isHidden = true
                        }
                        
                        //Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
        getStamp()

        
//        DispatchQueue.main.async {
//            self.actInd.stopAnimating()
//            self.actInd.hidesWhenStopped = true
//            self.container.isHidden = true
//        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func setAutocompleteView() {
        
        view.addSubview(autocompleteCountryView)
        view.addSubview(autocompleteRegCountryView)
        
        autocompleteCountryView.textField = txtCountry
        autocompleteCountryView.dataSource = self
        autocompleteCountryView.delegate = self
        
        autocompleteRegCountryView.textField = txtRegisterCountry
        autocompleteRegCountryView.dataSource = self
        autocompleteRegCountryView.delegate = self
        
        // Customisation
        
        autocompleteCountryView.rowHeight = 45
        autocompleteRegCountryView.rowHeight = 45
    }
    
    func getStamp() {
        
        if Connectivity.isConnectedToInternet() == true
        {
            print(headerAPIDashboard)
            //"https://zsdemowebuser.zorrosign.com/api/"
            //https://zsdemowebuser.zorrosign.com/api/Organization/GetOrganizationDetails
            //Singletone.shareInstance.apiURL + "Organization/GetOrganizationDetails"
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Organization/GetStamp")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    //print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        if let data = jsonObj["Data"].dictionaryObject {
                            if let strImg: String = data["StampImage"] as? String, !strImg.isEmpty {
                                let strImgArr = strImg.split(separator: ",")
                                if strImgArr.count > 1 {
                                    self.strStampImage = String(strImgArr[1])
                                    
                                    let decodedimage = self.strStampImage.base64ToImage()
                                    self.imgStampView.image = decodedimage
                                    
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.actInd.stopAnimating()
                            self.actInd.hidesWhenStopped = true
                            self.container.isHidden = true
                        }
                        
                        //Singletone.shareInstance.stopActivityIndicator()
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.actInd.stopAnimating()
                            self.actInd.hidesWhenStopped = true
                            self.container.isHidden = true
                        }
                        
                        //Singletone.shareInstance.stopActivityIndicator()
                        //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtIndustry {
            
        }
        if textField == txtTradeLicExpDate {
            let datepickerAlert = SwiftAlertView(contentView: datepicker, delegate: self, cancelButtonTitle: "Close")
            datepicker.datePickerMode = UIDatePicker.Mode.date
            //datepickerAlert.tag = textField.tag
            
            let btnclose = datepickerAlert.buttonAtIndex(index: 0)
            btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
            
            datepickerAlert.show()
            
            return false
        }
        pickerView.delegate = self//reloadAllComponents()
        txtTagId = textField.tag
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField == txtCity {
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        if textField == txtState {
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        if textField == txtZipcode {
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.numset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        if textField == txtPhoneNumber {
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.numCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    @objc func gotoMyAccount() {
        
        
        if let profstat = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int {
            
            // for NEW user
            if profstat == 1 {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
                let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
                self.navigationController?.pushViewController(signatureVC, animated: true)
            } else {
                self.navigationController?.popViewController(animated: false)
            }
        }
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnUpdateAction(_ sender: Any) {
        
        // call upload stamp
        //uploadStamp()
        
        callUpdateAPI()
        
//        if validateFields() {
//
//        }
    }
    
    func validateFields() -> Bool {
        
        /*
        if strImage.isEmpty {
            alertSample(strTitle: "", strMsg: "Please upload profile picture.")
            return false
        }
        if (txtTradeLicNumber.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Trade license number should not be blank.")
            return false
        }
        if (txtTradeLicExpDate.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "License expiry date should not be blank.")
            return false
        }
        if (txtDoingBusinessAs.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Doing business as should not be blank.")
            return false
        }
        if selIndustry == nil || selIndustry == 0 {
            alertSample(strTitle: "", strMsg: "Industry should not be blank.")
            return false
        }
        
        if (txtPhoneNumber.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Phone number should not be blank.")
            return false
        }*/
        if let email = txtEmail.text, Singletone.shareInstance.isValidEmail(testStr: "\(email)") == false {
            alertSample(strTitle: "", strMsg: "Please enter email id in valid format")
            return false
        }
        
        return true
    }
    
    func callUpdateAPI() {
        
        //Singletone.shareInstance.showActivityIndicatory(uiView: self.view)
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let strCity: String = txtCity.text ?? ""
        let strState: String = txtState.text ?? ""
        let strZipCode: String = txtZipcode.text ?? ""
        let strPhNo: String = txtPhoneNumber.text ?? ""
        let strCountry: String = txtCountry.text ?? ""
        let logo: String = "data:image/jpg;base64,\(strImage)"
        let stamp: String = "data:image/png;base64,\(strStampImage)"
        
        let regCountry: String = selCountryCode!
        
        let industry = selIndustry!//-1
        //https://zsdemowebuser.zorrosign.com/api/Organization/UpdateOrganizationDetails
        
        let parameter = [
            "OrganizationContact" : [
                "AddressLine1" : txtAddress1.text ?? "",
                "Email" : txtEmail.text ?? "",
                "UserId" : "",
                "Area" : "",
                "WebSite" : "",
                "PhoneNumber" : strPhNo,
                "ModifiedBy" : "null",
                "Country" : strCountry,
                "ZipCode" : strZipCode,
                "OrganizationId" : strOid, //"HEqLwsV29nRHwIchtbh5PQ%3D%3D",
                "County" : strCountry, //"null",
                "StateCode" : strState,
                "City" : strCity,
                "Address" : "",
                "MobileNumber" : "",
                "CountryCode" : strCountryCode,
                "CreatedBy" : "null",
                "AddressLine2" : txtAddress2.text ?? ""
            ],
            "Organization" : [
                "Stamp" : stamp, //"data:image/jpg;base64,\(strImage)",
                "ModifiedBy" : "null",
                "UserId" : "",
                "LegalName" : "Test Legal Name",
                "DBA" : txtDoingBusinessAs.text ?? "",
                "OrganizationId" : strOid, //"HEqLwsV29nRHwIchtbh5PQ%3D%3D",
                "TradeLicenseNumber" : txtTradeLicNumber.text ?? "", //"Trade Licence No",
                "Logo" : logo,//"data:image/jpg;base64,\(strImage)",
                "LogoURL" : "",
                "BusinessCategoryId" : industry,
                "Size" : "",
                "CountryCode" : regCountry,//"TR",
                "Country": txtRegisterCountry.text ?? "",
                "CreatedBy" : "null",
                "TradeLicenseExpiryDate" : txtTradeLicExpDate.text ?? "" //"2018-06-30T00:00:00"
            ]
        ]
        
        print("company profile parameter: \(parameter)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Organization/UpdateOrganizationDetails")!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        self.alertSample(strTitle: "", strMsg: "Business Profile update failed.")
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    //print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        self.alertSample(strTitle: "", strMsg: "Business Profile updated successfully.")
                        //self.performSegue(withIdentifier: "segCancel", sender: self)
                        self.perform(#selector(self.gotoMyAccount), with: self, afterDelay: 0.5)
                        Singletone.shareInstance.stopActivityIndicator()
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        print("Tap On Image")
        picker.delegate = self
        let alert = UIAlertController(title: "Add Photo!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .camera
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //lblUploadImage.isHidden = true
        if picker.accessibilityHint == "10" {
            
            let image: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
            
           
            let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
            cropController.delegate = self
            cropController.modalPresentationStyle = .fullScreen
            cropController.accessibilityHint = "10"
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
            
        } else {
            
            print("camera done")
            
            let image: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
            
            
            
        //lblUploadImage.text = ""
            
            let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
            cropController.delegate = self
            cropController.modalPresentationStyle = .fullScreen
            cropController.accessibilityHint = "11"
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
        }
        //dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //self.croppedRect = cropRect
        //self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        //self.croppedRect = cropRect
        //self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        btnUpdate.isEnabled = true
        var newimage = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        
        if picker.accessibilityHint == "10" {
//            imgStampView.image = newimage
        } else {
            imgCompanyView.image = newimage
        }
        //layoutImageView()
        
        //var strBase64: String = imageData.base64EncodedString(options: .endLineWithLineFeed)
        let strBase64: String = newimage.base64(format: ImageFormat.PNG)
        let escapedString: String = strBase64.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        strImage = strBase64//escapedString
        
        
        self.lblUpload.isHidden = true
        
        ////
        DispatchQueue.main.async {
            self.actInd.stopAnimating()
            self.actInd.hidesWhenStopped = true
            self.container.isHidden = true
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imgStampView.isHidden = false
            imgCompanyView.isHidden = true
            
            if picker.accessibilityHint == "10" {
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: newimage,
                                                   toView: imgStampView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imgStampView.isHidden = false })
            
            } else {
                cropViewController.dismissAnimatedFrom(self, withCroppedImage: newimage,
                                                       toView: imgCompanyView,
                                                       toFrame: CGRect.zero,
                                                       setup: { self.layoutImageView() },
                                                       completion: { self.imgCompanyView.isHidden = false })
            }
        }
        else {
            self.imgStampView.isHidden = false
            self.imgCompanyView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        
    }

    
    @IBAction func btnBackAction(_ sender: Any) {
        //performSegue(withIdentifier: "segCancel", sender: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        //performSegue(withIdentifier: "segCancel", sender: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == industryPicker {
            return arrIndustry.count
        }
        if jsonCountry["Data"].array != nil {
            return jsonCountry["Data"].array!.count + 1
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == industryPicker {
                return arrIndustry[row].Value
        }
        if txtTagId == 100
        {
            if selCountryCode == jsonCountry["Data"][row - 1]["Code"].stringValue
            {
                txtRegisterCountry.text = jsonCountry["Data"][row - 1]["Name"].stringValue
            }
            return row == 0 ? "Select registered country" : jsonCountry["Data"][row - 1]["Name"].stringValue//jsonCountry["Data"]["Name"].array?[row - 1].string
        }
        else
        {
            return row == 0 ? "Select country" : jsonCountry["Data"][row - 1]["Name"].stringValue//jsonCountry["Data"]["Name"].array?[row - 1].string
        }
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.textAlignment = .center
        }
        
        var strCountry: String = ""
        
        if pickerView == industryPicker {
            strCountry = row == 0 ? "Select industry" : arrIndustry[row].Value!
        }
        
        else if txtTagId == 100
        {
            if selCountryCode == jsonCountry["Data"][row - 1]["Code"].stringValue
            {
                txtRegisterCountry.text = jsonCountry["Data"][row - 1]["Name"].stringValue
            }
            strCountry = (row == 0 ? "Select registered country" : jsonCountry["Data"][row - 1]["Name"].stringValue)//jsonCountry["Data"]["Name"].array?[row - 1].string
        }
        else
        {
            strCountry = (row == 0 ? "Select country" : jsonCountry["Data"][row - 1]["Name"].stringValue)//jsonCountry["Data"]["Name"].array?[row - 1].string
        }
        
        pickerLabel?.text = strCountry
        pickerLabel?.font = UIFont.systemFont(ofSize: 20)
        pickerLabel?.textColor = UIColor.black
        
        return pickerLabel!
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == industryPicker {
            
            selIndustry = row
            if row < arrIndustry.count {
                txtIndustry.text = arrIndustry[row].Value
            }
            
        } else {
            if txtTagId == 100
            {
                txtRegisterCountry.text =  row == 0 ? "" : jsonCountry["Data"][row - 1]["Name"].stringValue
                self.selCountryCode = jsonCountry["Data"][row - 1]["Code"].stringValue
            }
            else
            {
                txtCountry.text =  row == 0 ? "" : jsonCountry["Data"][row - 1]["Name"].stringValue
                strCountryCode = jsonCountry["Data"][row - 1]["Code"].stringValue
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetCountry")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                
                let jsonObj: JSON = JSON(response.result.value!)
                if jsonObj["StatusCode"] == 1000
                {
                    self.jsonCountry = jsonObj
                    
                    for dic in jsonObj["Data"].array! {
                        let ccdata = CountryData(dictionary: dic.dictionaryObject!)
                        self.countryArr.append(ccdata)
                        self.countryNameArr.append(ccdata.Name!)
                    }
                    if let i = self.countryArr.index(where: { $0.Code == self.selCountryCode?.uppercased() }) {
                        self.txtRegisterCountry.text = self.countryArr[i].Name
                    }
                    Singletone.shareInstance.stopActivityIndicator()
                }
                else
                {
                    Singletone.shareInstance.stopActivityIndicator()
                    self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                }
        }
        
    }

    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        print(s!)
        
        switch s! {
        case 100:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")  //dashboard_white_bottom_bar_icon
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")  //launch_white_bottom_bar_icon
            imgSearch.image = UIImage(named: "search_green_icon")  //search_white_icon
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")  //landing_screen_signup_icon
            imgHelp.image = UIImage(named: "help_green_icon")  //help_white_icon
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            performSegue(withIdentifier: "segBackDashboard", sender: self)
            
            break
        case 101:
            ///viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_white_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 102:
            //viewSearchBar.isHidden = false
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_white_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            //performSegue(withIdentifier: "segCancel", sender: self)
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            self.navigationController?.popViewController(animated: false)
            
            //            let strImageName: String = (imgSearchMic.image?.accessibilityIdentifier)!
            //            print(strImageName)
            //            print("**")
            
            
            
            break
        case 103:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            self.navigationController?.popViewController(animated: false)
            //performSegue(withIdentifier: "segCancel", sender: self)
            
            break
        case 104:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_white_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            performSegue(withIdentifier: "segContactUs", sender: self)
            break
        default:
            break
        }
    }
    
    func getIndustryList(catId: String) {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let apiURL = "Organization/BusinessCategories"
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + apiURL + "/\(catId)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        let data = jsonObj["Data"].array
                        
                        for dic in data! {
                            
                            let industryData = IndustryData(dictionary: dic.dictionaryObject!)
                            self.arrIndustry.append(industryData)
                        }
                        
                        if Int(catId)! < self.arrIndustry.count {
                            self.txtIndustry.text = self.arrIndustry[Int(catId)!].Value
                        }
                    }
                    else
                    {
                        
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @IBAction func selectStampAction(_ sender: Any) {
        
        picker.accessibilityHint = "10"
        picker.delegate = self
        let alert = UIAlertController(title: "Add Photo!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .camera
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func uploadStamp() {
        
        Singletone.shareInstance.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let strCity: String = txtCity.text ?? ""
        let strState: String = txtState.text ?? ""
        let strZipCode: String = txtZipcode.text ?? ""
        let strPhNo: String = txtPhoneNumber.text ?? ""
        let strCountry: String = txtCountry.text ?? ""
        let userId: String = ZorroTempData.sharedInstance.getProfileId()
        
        //https://zsdemowebuser.zorrosign.com/api/Organization/UpdateOrganizationDetails
        let stamp: String = "data:image/png;base64,\(strStampImage)"
        let parameter = [
            "Stamp" : stamp, //"data:image/jpg;base64,\(strImage)",
            "ModifiedBy" : "null",
            "UserId" : userId,
            "LegalName" : "Test Legal Name",
            "DBA" : txtDoingBusinessAs.text ?? "",
            "OrganizationId" : strOid, //"HEqLwsV29nRHwIchtbh5PQ%3D%3D",
            "TradeLicenseNumber" : txtTradeLicNumber.text ?? "", //"Trade Licence No",
            "Logo" : "",//"data:image/jpg;base64,\(strImage)",
            "LogoURL" : "",
            "BusinessCategoryId" : selIndustry ?? 0,
            "Size" : "",
            "CountryCode" : selCountryCode!,//"TR",
            "CreatedBy" : "null",
            "TradeLicenseExpiryDate" : txtTradeLicExpDate.text ?? ""
            ] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Organization/UploadStamp")!, method: .post, parameters: parameter, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        self.performSegue(withIdentifier: "segCancel", sender: self)
                        Singletone.shareInstance.stopActivityIndicator()
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        //if alertView.tag == 10 {
            startDate = datepicker.date
        
            txtTradeLicExpDate.text = dateToString(date: startDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "yyyy-MM-dd")
        //}
    }
}

// MARK: - LUAutocompleteViewDataSource

extension CompanyProfileViewController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = countryNameArr.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate

extension CompanyProfileViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        print(text + " was selected from autocomplete view")
        
    }
}

// MARK: new implementation
extension CompanyProfileViewController {
    fileprivate func setStyles() {
        
        //btnUpdate.isEnabled = false
        
        imgcompanyContainerView.clipsToBounds = false
        imgcompanyContainerView.backgroundColor = .white
        imgcompanyContainerView.layer.shadowColor = UIColor.black.cgColor
        imgcompanyContainerView.layer.shadowOpacity = 1
        imgcompanyContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imgcompanyContainerView.layer.shadowRadius = 2
        imgcompanyContainerView.layer.cornerRadius = imgcompanyContainerView.frame.width/2
        
        imgCompanyView.clipsToBounds = true
        imgCompanyView.layer.cornerRadius = imgCompanyView.frame.size.width / 2;
        
        
        
        cameraImage.layer.cornerRadius = cameraImage.frame.size.width / 2;
        cameraImage.clipsToBounds = true
        cameraImage.layer.masksToBounds = false
        cameraImage.layer.borderColor = UIColor.black.cgColor
        cameraImage.backgroundColor = .white
        cameraImage.layer.shadowRadius  = 1.5;
        cameraImage.layer.shadowColor   = UIColor.lightGray.cgColor
        cameraImage.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        cameraImage.layer.shadowOpacity = 0.9;
        
        
        
        btnCancel.backgroundColor = .white
        btnCancel.layer.borderColor = UIColor(named: "BtnBorder")?.cgColor
        btnCancel.layer.borderWidth = 1
        btnCancel.setTitleColor(UIColor(named: "BtnTextWithoutBG"), for: .normal)
        btnCancel.setTitle("CANCEL", for: .normal)
        
        stackViewBusiness.spacing = 5
        
        for height in labelHeights {
            height.constant = 45
        }
        
        buttonstackviewTop.constant = 0
        buttonstackviewHeight.constant = 50
        
        
        for view in viewSubs {
            view.backgroundColor = .white
            view.layer.shadowRadius  = 1.5;
            view.layer.shadowColor   = UIColor.lightGray.cgColor
            view.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
            view.layer.shadowOpacity = 0.9;
            view.layer.masksToBounds = false;
            view.layer.cornerRadius = 8
            
        }
    }
}

extension CompanyProfileViewController {
    func textFieldDidEndEditing(_ textField: UITextField) {
        btnUpdate.isEnabled = true
    }
}
