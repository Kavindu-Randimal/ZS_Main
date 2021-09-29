//
//  UserProfileViewController.swift
//  ZorroSign
//
//  Created by Apple on 25/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ADCountryPicker
import CropViewController
import LUAutocompleteView

class UserProfileViewController: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, CropViewControllerDelegate {

    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imgCamaraView: UIImageView!
    @IBOutlet weak var imgProfileView: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtMiddleName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtAddress1: UITextField!
    @IBOutlet weak var txtAddress2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCountry: SearchTextField!//UITextField!
    @IBOutlet weak var txtZipCode: UITextField!
    @IBOutlet weak var txtPhonenumber: UITextField!
    @IBOutlet weak var btnUpdate: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var viewBottomDashborad: UIView!
    @IBOutlet weak var viewBottomStart: UIView!
    @IBOutlet weak var viewBottomSearch: UIView!
    @IBOutlet weak var viewBottomMyAccount: UIView!
    @IBOutlet weak var btnBottomHelp: UIView!
    
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
    
    @IBOutlet weak var lblUpload: UILabel!
    
    @IBOutlet weak var viewFN: UIView!
    @IBOutlet weak var viewMN: UIView!
    @IBOutlet weak var viewLN: UIView!
    @IBOutlet weak var viewE: UIView!
    @IBOutlet weak var viewA1: UIView!
    @IBOutlet weak var viewA2: UIView!
    @IBOutlet weak var viewC: UIView!
    @IBOutlet weak var viewS: UIView!
    @IBOutlet weak var viewCo: UIView!
    @IBOutlet weak var viewZC: UIView!
    @IBOutlet weak var viewPN: UIView!
    @IBOutlet weak var viewJ: UIView!
    @IBOutlet weak var StackViewTF: UIStackView!
    
    @IBOutlet weak var pickerContainer: UIView!
    @IBOutlet weak var countryPicker: UIPickerView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var txtJobTitle: UITextField!
    @IBOutlet weak var countrypickerImage: UIImageView!
    @IBOutlet weak var countrycodePickerButton: UIButton!
    @IBOutlet weak var countrycodeLabel: UILabel!
    
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var _dialCode: String = ""
    var __countryCode: String = ""
  
    
    //viewBottomDashborad viewBottomStart viewBottomSearch viewBottomMyAccount btnBottomHelp
    //imgDashboard imgStart imgSearch imgMyAccount imgHelp
    //lblDashboard lblStart lblSearch lblMyAccount lblHelp

    var headerAPIDashboard = [String : String]()
    var strPid = String()
    var strUid = String()
    var strOid = String()
    var jsonCountry = JSON()
    var filterCountry = JSON()
    
    var countryArr: [String] = []
    var countryCodeArr: [String] = []
    var filterCountryArr: NSMutableArray = NSMutableArray.init()
    
    var userSignArray:[UserSignatures] = []
    var signature: String = ""
    var initials: String = ""
    var settings: [String:Any] = [:]
    var userSignatureId: String = ""
    var signatureDescription: [String:Any] = [:]
    var userSignatures: [[String:Any]] = []
    
    var userType: Int?
    
    var strCountryCode = String()
    var strCountry = String()
    
    var srchCountryStr = ""
    var strJobTitle = ""
    
    var strImage = String()
    
    var profileStatus: Int?
    var strAbc = String()
    let picker = UIImagePickerController()
    
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 350))
    
    private let autocompleteView = LUAutocompleteView()
    
    private let elements = (1...100).map { "\($0)" }
    
    var docSignFlag: Bool = false
    
    private var croppingStyle = CropViewCroppingStyle.default
    
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    //temp
    var BaseUtcOffset: String?
    var DisplayName: String?
    var StandardName: String?
    var SupportsDaylightSavingTime: Bool?
    
    var updatedFlag: Bool = false
    
    private var website: String!
    private var officephoneCode: String!
    private var officephoneNumber: String!
    private var timezoneDetails: String?
    
    private var profileCompletionStatus: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        setStyles()
//        let phonecountrycode = ZorroTempData.sharedInstance.getPhoneCountryCode()
//        if phonecountrycode != "" {
//            _dialCode = "+" + phonecountrycode
//        }
//        _dialCode = "+" + getCountryCallingCode(countryRegionCode:"US")
        
        
//        let countrycode = NSLocale.current.regionCode
//        countrypickerImage.image = setcountryImage(countryCode: "US")
//        let _phonecode = getCountryCallingCode(countryRegionCode: countrycode ?? "US")
//        _dialCode = _phonecode
        
//        countrycodeLabel.text = _dialCode
        countrycodePickerButton.addTarget(self, action: #selector(selectCountryCode(_:)), for: .touchUpInside)
        
        let imgDem = UIImage(named: "dashboard_green_bottom_bar_icon")
        let imageData:NSData = imgDem!.pngData()! as NSData  //  add this
        let strBase64: String = imageData.base64EncodedString(options: .endLineWithLineFeed)
        //let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)//(options: .Encoding64CharacterLineLength)
        
        /*
        view.addSubview(autocompleteView)
        
        autocompleteView.textField = txtCountry
        autocompleteView.dataSource = self
        autocompleteView.delegate = self
        
        // Customisation
        
        autocompleteView.rowHeight = 45
        */
        let escapedString: String = strBase64.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        strAbc = escapedString
        
        viewFN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewMN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewLN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewE.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewA1.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewA2.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewC.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewS.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewCo.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewZC.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        viewPN.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
        
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
        self.actInd.color = ColorTheme.activityindicator
        self.actInd.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)
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
        
        self.actInd.startAnimating()

        btnUpdate.layer.cornerRadius = 3
        btnUpdate.clipsToBounds = true
        btnCancel.layer.cornerRadius = 3
        btnCancel.clipsToBounds = true
        
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
        imgProfileView.addGestureRecognizer(tap)
        imgProfileView.isUserInteractionEnabled = true

        pickerView.delegate = self
        txtCountry.delegate = self
        //txtCountry.inputView = pickerView
        //txtCountry.startVisibleWithoutInteraction = true
//        Singletone.shareInstance.showActivityIndicatory(uiView: self.view)

        profileStatus = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int
        
        if self.profileStatus == 1 {
//            btnCancel.isHidden = true
            btnCancel.isEnabled = false
        }
        let gestureTap = UITapGestureRecognizer(target: self, action:  #selector(self.tapAction))
        
        view.addGestureRecognizer(gestureTap)
        
        getUser()


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func getCountryCallingCode(countryRegionCode:String)->String{

            let prefixCodes = ["AF": "93", "AE": "971", "AL": "355", "AN": "599", "AS":"1", "AD": "376", "AO": "244", "AI": "1", "AG":"1", "AR": "54","AM": "374", "AW": "297", "AU":"61", "AT": "43","AZ": "994", "BS": "1", "BH":"973", "BF": "226","BI": "257", "BD": "880", "BB": "1", "BY": "375", "BE":"32","BZ": "501", "BJ": "229", "BM": "1", "BT":"975", "BA": "387", "BW": "267", "BR": "55", "BG": "359", "BO": "591", "BL": "590", "BN": "673", "CC": "61", "CD":"243","CI": "225", "KH":"855", "CM": "237", "CA": "1", "CV": "238", "KY":"345", "CF":"236", "CH": "41", "CL": "56", "CN":"86","CX": "61", "CO": "57", "KM": "269", "CG":"242", "CK": "682", "CR": "506", "CU":"53", "CY":"537","CZ": "420", "DE": "49", "DK": "45", "DJ":"253", "DM": "1", "DO": "1", "DZ": "213", "EC": "593", "EG":"20", "ER": "291", "EE":"372","ES": "34", "ET": "251", "FM": "691", "FK": "500", "FO": "298", "FJ": "679", "FI":"358", "FR": "33", "GB":"44", "GF": "594", "GA":"241", "GS": "500", "GM":"220", "GE":"995","GH":"233", "GI": "350", "GQ": "240", "GR": "30", "GG": "44", "GL": "299", "GD":"1", "GP": "590", "GU": "1", "GT": "502", "GN":"224","GW": "245", "GY": "595", "HT": "509", "HR": "385", "HN":"504", "HU": "36", "HK": "852", "IR": "98", "IM": "44", "IL": "972", "IO":"246", "IS": "354", "IN": "91", "ID":"62", "IQ":"964", "IE": "353","IT":"39", "JM":"1", "JP": "81", "JO": "962", "JE":"44", "KP": "850", "KR": "82","KZ":"77", "KE": "254", "KI": "686", "KW": "965", "KG":"996","KN":"1", "LC": "1", "LV": "371", "LB": "961", "LK":"94", "LS": "266", "LR":"231", "LI": "423", "LT": "370", "LU": "352", "LA": "856", "LY":"218", "MO": "853", "MK": "389", "MG":"261", "MW": "265", "MY": "60","MV": "960", "ML":"223", "MT": "356", "MH": "692", "MQ": "596", "MR":"222", "MU": "230", "MX": "52","MC": "377", "MN": "976", "ME": "382", "MP": "1", "MS": "1", "MA":"212", "MM": "95", "MF": "590", "MD":"373", "MZ": "258", "NA":"264", "NR":"674", "NP":"977", "NL": "31","NC": "687", "NZ":"64", "NI": "505", "NE": "227", "NG": "234", "NU":"683", "NF": "672", "NO": "47","OM": "968", "PK": "92", "PM": "508", "PW": "680", "PF": "689", "PA": "507", "PG":"675", "PY": "595", "PE": "51", "PH": "63", "PL":"48", "PN": "872","PT": "351", "PR": "1","PS": "970", "QA": "974", "RO":"40", "RE":"262", "RS": "381", "RU": "7", "RW": "250", "SM": "378", "SA":"966", "SN": "221", "SC": "248", "SL":"232","SG": "65", "SK": "421", "SI": "386", "SB":"677", "SH": "290", "SD": "249", "SR": "597","SZ": "268", "SE":"46", "SV": "503", "ST": "239","SO": "252", "SJ": "47", "SY":"963", "TW": "886", "TZ": "255", "TL": "670", "TD": "235", "TJ": "992", "TH": "66", "TG":"228", "TK": "690", "TO": "676", "TT": "1", "TN":"216","TR": "90", "TM": "993", "TC": "1", "TV":"688", "UG": "256", "UA": "380", "US": "1", "UY": "598","UZ": "998", "VA":"379", "VE":"58", "VN": "84", "VG": "1", "VI": "1","VC":"1", "VU":"678", "WS": "685", "WF": "681", "YE": "967", "YT": "262","ZA": "27" , "ZM": "260", "ZW":"263"]
            let countryDialingCode = prefixCodes[countryRegionCode]
            return countryDialingCode!

    }

    @objc func tapAction() {
        
        scrollView.scrollsToTop = true
        pickerContainer.isHidden = true
        countryPicker.isHidden = true
        
    }
    
    func showCountryPopup() {
        
        let rect = txtCountry.frame
        
        ///scrollView.scrollRectToVisible(rect, animated: false)
        scrollView.setContentOffset(rect.origin, animated: false)
        
        pickerContainer.isHidden = false
        countryPicker.isHidden = false
        countryPicker.reloadAllComponents()
    }
    
    func getUser() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            strPid = ZorroTempData.sharedInstance.getProfileId()
            //UserDefaults.standard.string(forKey: "OrgProfileId")!
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetProfile?profileId=\(strPid)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        
                        self.txtFirstName.text = jsonObj["Data"]["FirstName"].stringValue
                        self.txtMiddleName.text = jsonObj["Data"]["MiddleName"].stringValue
                        self.txtLastName.text = jsonObj["Data"]["LastName"].stringValue
                        self.txtEmail.text = jsonObj["Data"]["Email"].stringValue
                        self.txtAddress1.text = jsonObj["Data"]["AddressLine1"].stringValue
                        self.txtAddress2.text = jsonObj["Data"]["AddressLine2"].stringValue
                        self.txtCity.text = jsonObj["Data"]["City"].stringValue
                        self.txtState.text = jsonObj["Data"]["StateCode"].stringValue
                        self.txtCountry.text = jsonObj["Data"]["Country"].stringValue
                        self.txtZipCode.text = jsonObj["Data"]["ZipCode"].stringValue
                        self.strUid = jsonObj["Data"]["UserId"].stringValue
                        self.strOid = jsonObj["Data"]["OrganizationId"].stringValue
                        //Country
                        self.strCountry = jsonObj["Data"]["Country"].stringValue
                        self.strCountryCode = jsonObj["Data"]["CountryCode"].stringValue
                        self.txtJobTitle.text = jsonObj["Data"]["JobTitle"].stringValue
                        
                        self.website = jsonObj["Data"]["WebSite"].stringValue
                        self.officephoneCode = jsonObj["Data"]["OfficePhoneContryCode"].stringValue
                        self.officephoneNumber = jsonObj["Data"]["OfficePhoneNumber"].stringValue
                        
                        self.BaseUtcOffset = jsonObj["Data"]["TimeZoneDetails"]["BaseUtcOffset"].stringValue
                        self.DisplayName = jsonObj["Data"]["TimeZoneDetails"]["DisplayName"].stringValue
                        self.StandardName = jsonObj["Data"]["TimeZoneDetails"]["StandardName"].stringValue
                        self.SupportsDaylightSavingTime = jsonObj["Data"]["TimeZoneDetails"]["SupportsDaylightSavingTime"].boolValue
                       
//                        let countrycode = jsonObj["Data"]["CountryCode"].stringValue
//                        if countrycode != "" {
//                             self.countrypickerImage.image = self.setcountryImage(countryCode: countrycode)
//                        } else {
//                            self.countrypickerImage.image = self.setcountryImage(countryCode: "US")
//                        }
                    
                        let phonecountrycode = jsonObj["Data"]["PhoneContryCode"].stringValue
                        if phonecountrycode != "" {
                            let splitedcode = phonecountrycode.components(separatedBy: "|")
                            if splitedcode.indices.contains(0) && splitedcode.indices.contains(1) {
                                let countrycode = splitedcode[0]
                                let phonecode = splitedcode[1]
                                self._dialCode = "+" + phonecode
                                self.__countryCode = splitedcode[0]
                                self.countrycodeLabel.text = self._dialCode
                                self.countrypickerImage.image = self.setcountryImage(countryCode: countrycode.uppercased())
                            } else {
                                self._dialCode = "+1"
                                self.__countryCode = "US"
                                self.countrycodeLabel.text = self._dialCode
                                self.countrypickerImage.image = self.setcountryImage(countryCode: "US")
                            }
                        } else {
                            self._dialCode = "+1"
                            self.__countryCode = "US"
                            self.countrycodeLabel.text = self._dialCode
                            self.countrypickerImage.image = self.setcountryImage(countryCode: "US")
                        }
                        
                        let phoneNumber = jsonObj["Data"]["PhoneNumber"].stringValue
                        if phoneNumber != "" && self._dialCode != "" {
                            let countrycodecount = self._dialCode.count
                            let newphonenumber = phoneNumber.dropFirst(countrycodecount)
                            self.txtPhonenumber.text = String(newphonenumber)
                        } else {
                            self.txtPhonenumber.text = phoneNumber
                        }
                       
                        
                        
                        //strJobTitle
                        //self.profileStatus = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int
                        
                        //UserDefaults.standard.set(self.profileStatus, forKey: "ProfileStatus")
                        
                        let userSignId = jsonObj["Data"]["UserSignatureId"].intValue
                        let email = jsonObj["Data"]["Email"].stringValue
                        let fname = jsonObj["Data"]["FirstName"].stringValue
                        let middle = jsonObj["Data"]["MiddleName"].stringValue
                        let lname = jsonObj["Data"]["LastName"].stringValue
                        let subscriptionPlan = jsonObj["Data"]["SubscriptionPlan"].intValue
                        let phone = jsonObj["Data"]["PhoneNumber"].stringValue
                        
                        let jobtitle = jsonObj["Data"]["JobTitle"].stringValue
                        UserDefaults.standard.set(jobtitle, forKey: "JobTitle")
                        
                        let fullName = fname + " " + lname
                        
                        UserDefaults.standard.set(fname, forKey: "FName")
                        UserDefaults.standard.set(middle, forKey: "MName")
                        UserDefaults.standard.set(lname, forKey: "LName")
                        
                        UserDefaults.standard.set(userSignId, forKey: "UserSignId")
                        UserDefaults.standard.set(fullName, forKey: "FullName")
                        UserDefaults.standard.set(email, forKey: "Email")
                        UserDefaults.standard.set(phone, forKey: "Phone")
                        UserDefaults.standard.set(subscriptionPlan, forKey: "SubscriptionPlan")
                        
                        if jsonObj["Data"]["Picture"].stringValue != ""
                        {
                            let strImg: String = jsonObj["Data"]["Picture"].stringValue
                            let strImgArr = strImg.split(separator: ",")
                            if strImgArr.count > 1 {
                                self.strImage = String(strImgArr[1])
                                //print(String(strImgArr[1]))
                                let dataDecoded : Data = Data(base64Encoded: String(strImgArr[1]), options: .ignoreUnknownCharacters)!
                                let decodedimage = UIImage(data: dataDecoded)
                                self.imgProfileView.image = decodedimage
                                
                                self.lblUpload.isHidden = true
                            }
                        }
                        let settings = jsonObj["Data"]["Settings"].dictionaryObject
                        let userSign = jsonObj["Data"]["UserSignatures"].arrayObject //as? NSArray
                        if let userSignArr = jsonObj["Data"]["UserSignatures"].arrayObject {
                            //self.userSignatures = userSignArr as! [[String : Any]]
                        }
                        
                        
                        let userSignObj = UserSignatures()
                        if let settingsDic = settings {
                            //userSignObj.settings = Settings(dictionary: settingsDic)
                            self.settings = settingsDic as! [String : Any]
                        }
                        if let sign = jsonObj["Data"]["Signature"].stringValue as? String {
                            //userSignObj.Signature
                              self.signature  = sign
                            
                            UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
                        } else {
                            self.profileStatus = 7
                            UserDefaults.standard.setValue(7, forKey: "ProfileStatus")
                        }
                        if let initials = jsonObj["Data"]["Initials"].stringValue as? String {
                            //userSignObj.Initials
                              self.initials  = initials
                        }
                        if let signDesc = jsonObj["Data"]["SignatureDescription"].dictionaryObject {
                            //userSignObj.SignatureDescription = SignatureDescription(dictionary: signDesc )
                            self.signatureDescription = signDesc
                        }
                        
                        if let ProfileStatus = jsonObj["Data"]["ProfileStatus"].int {
                            //self.profileStatus = ProfileStatus
//                            UserDefaults.standard.set(ProfileStatus, forKey: "ProfileStatus")
                            self.profileCompletionStatus = ProfileStatus
                        }
                        if let UserType = jsonObj["Data"]["UserType"].int {
                            self.userType = UserType
                        }
                        self.userSignatureId = jsonObj["Data"]["UserSignatureId"].stringValue
                        userSignObj.IsDefault = true//jsonData["IsDefault"] as? Bool
                        
                        //self.userSignArray.append(userSignObj)
                        
                        if userSign != nil {
                            
                            for sign in userSign! {
                                
                                let dic = sign as! [AnyHashable : Any]
                                let usrSignObj = UserSignatures(dictionary:dic)
                                
                                if let signDesc = dic["SignatureDescription"] as? [AnyHashable : Any] {
                                    usrSignObj.SignatureDescription = SignatureDescription(dictionary: signDesc )
                                }
                                
                                self.userSignatures.append(dic as! [String : Any])
                                
                                self.userSignArray.append(usrSignObj)
                            }
                        } else {
                            
                        }
                        if let index = self.countryCodeArr.index(of: self.strCountryCode) {
                            self.txtCountry.text = self.countryArr[index]
                        }
                        DispatchQueue.main.async {
                            self.actInd.stopAnimating()
                            self.actInd.hidesWhenStopped = true
                            self.container.isHidden = true
                            if self.profileStatus == 1 {
                                self.btnCancel.isHidden = true
                            }
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
                    DispatchQueue.main.async {
                        if self.updatedFlag {
                            self.perform(#selector(self.gotoMyAccount), with: self, afterDelay: 0.5)
                        }
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
        
        /////
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
        self.actInd.color = UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
        let lblWait: UILabel = UILabel()
        lblWait.text = ""
        lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
        lblWait.font = lblWait.font.withSize(13)
        lblWait.textAlignment = .center
        lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.loadingView.addSubview(lblWait)
        
        self.loadingView.addSubview(self.actInd)
        container.addSubview(self.loadingView)
        view.addSubview(container)
        
        
        
        self.actInd.startAnimating()
        let image: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage

        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.modalPresentationStyle = .fullScreen
        cropController.delegate = self
        picker.dismiss(animated: true, completion: {
            self.present(cropController, animated: true, completion: nil)
            //self.navigationController!.pushViewController(cropController, animated: true)
        })
        

        
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
        let newimage = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        imgProfileView.image = newimage
        //layoutImageView()
        
        //var strBase64: String = imageData.base64EncodedString(options: .endLineWithLineFeed)
        let strBase64: String = newimage.base64(format: ImageFormat.PNG)
        let _: String = strBase64.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
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
            imgProfileView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: newimage,
                                                   toView: imgProfileView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imgProfileView.isHidden = false })
            
            
        }
        else {
            self.imgProfileView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        guard imgProfileView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imgProfileView.image!.size;
        
    }
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countryArr.count + 1//jsonCountry["Data"].array!.count + 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //var dic:[String:Any] = [:]
        var country: String = ""
        if row > 0 {
            country = countryArr[row - 1] //as! [String:Any]
        }
        return row == 0 ? "Select country" : country //dic["Name"] as! String
         //return row == 0 ? "Select country" : jsonCountry["Data"][row - 1]["Name"].stringValue//jsonCountry["Data"]["Name"].array?[row - 1].string
    }
    
    
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
           
            pickerLabel?.textAlignment = .center
        }
        /*
        if (jsonCountry["Data"].array?.count)!+1 > row {
            
            let strCountry = (row == 0 ? "Select country" : jsonCountry["Data"][row - 1]["Name"].stringValue)
            pickerLabel?.text = strCountry as! String
        }*/
        if (countryArr.count)+1 > row {
            
            //var dic:[String:Any] = [:]
            var country: String = ""
            if row > 0 {
                country = countryArr[row - 1] //as! [String:Any]
            }
            let strCountry = (row == 0 ? "Select country" : country)
            pickerLabel?.text = strCountry as! String
        }
        pickerLabel?.textColor = UIColor.black
        pickerLabel?.font = UIFont.systemFont(ofSize: 20)
        
        return pickerLabel!
    }
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*
        txtCountry.text =  row == 0 ? "" : jsonCountry["Data"][row - 1]["Name"].stringValue
        strCountryCode = jsonCountry["Data"][row - 1]["Code"].stringValue
        strCountry = jsonCountry["Data"][row - 1]["Name"].stringValue
 */
        //var dic:[String:Any] = [:]
        var country: String = ""
        var code: String = ""
        
        if row > 0 {
            //dic = countryArr[row - 1] as! [String:Any]
            country = countryArr[row - 1]
            code = countryCodeArr[row - 1]
        }
        txtCountry.text =  row == 0 ? "" : country //dic["Name"] as! String
        strCountryCode = row == 0 ? "" : code //dic["Code"] as! String
        strCountry = row == 0 ? "" : country //dic["Name"] as! String
        btnUpdate.isEnabled = true
    }
    
    /////

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.showActivityIndicatory(uiView: self.view)
        
        Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetCountry")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                
                
                let jsonObj: JSON = JSON(response.result.value!)
                if jsonObj["StatusCode"] == 1000
                {
                    self.jsonCountry = jsonObj
                    
                    if let ctryArr = jsonObj["Data"].array {
                        for dic in ctryArr {
                            //self.countryArr.add(dic.dictionaryObject)
                            self.filterCountryArr.add(dic.dictionaryObject)
                            let dataDic = dic.dictionaryObject
                            self.countryArr.append(dataDic!["Name"] as! String)
                            self.countryCodeArr.append(dataDic!["Code"] as! String)
                        }
                        
                        if let index = self.countryCodeArr.index(of: self.strCountryCode) {
                            self.txtCountry.text = self.countryArr[index]
                        }
                    }
                    DispatchQueue.main.async {
                        
                        self.stopActivityIndicator()
                        //self.configureSimpleSearchTextField()
                    }
                    
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
            viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")  //dashboard_white_bottom_bar_icon
            imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")  //launch_white_bottom_bar_icon
            imgSearch.image = UIImage(named: "search_green_icon")  //search_white_icon
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")  //landing_screen_signup_icon
            imgHelp.image = UIImage(named: "help_green_icon")  //help_white_icon
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            performSegue(withIdentifier: "segBackDashboard", sender: self)
            
            break
        case 101:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            imgStart.image = UIImage(named: "launch_white_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblStart.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 102:
            //viewSearchBar.isHidden = false
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_white_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 103:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            //performSegue(withIdentifier: "segCancel", sender: self)
            self.navigationController?.popViewController(animated: false)
            
            break
        case 104:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_white_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
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

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == txtCountry {
            /*
            pickerContainer.isHidden = false
            countryPicker.isHidden = false
            countryPicker.reloadAllComponents()
            */
            
            showCountryPopup()
            
            return false
            
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print(textField.text)
        btnUpdate.isEnabled = true
        
//        if textField == txtFirstName {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtMiddleName {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtLastName {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtCity {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtState {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtZipCode {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.numset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
//        if textField == txtPhonenumber {
//            let charset = CharacterSet(charactersIn: Singletone.shareInstance.numCharset).inverted
//            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
//            return (string == filtered)
//        }
        return true
    }
    
    func validateFields() -> Bool {
        /*
        if strImage.isEmpty {
            alertSample(strTitle: "", strMsg: "Please upload profile picture.")
            return false
        }*/
        if (txtFirstName.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "First name should not be blank.")
            return false
        }
        if (txtLastName.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Last name should not be blank.")
            return false
        }
        
        if (txtPhonenumber.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Phone number should not be blank.")
            return false
        }
        return true
    }

    @IBAction func btnUpdateAction(_ sender: Any) {
        //Singletone.shareInstance.showActivityIndicatory(uiView: self.view)
        
        let fname: String = txtFirstName.text ?? ""
        let lname: String = txtLastName.text ?? ""
        
        let fullName = "\(fname) \(lname)"
        let jobTitle: String = txtJobTitle.text ?? ""
        
        UserDefaults.standard.set(fname, forKey: "FName")
        UserDefaults.standard.set(lname, forKey: "LName")
        UserDefaults.standard.set(fullName, forKey: "FullName")
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let ProfId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        
        let strCity: String = txtCity.text ?? ""
        let strState: String = txtState.text ?? ""
        
        //print("***")
        //print("data:image/png;base64,\(strAbc)")
        //print("***")
        var picture: String = "data:image/png;base64,\(strImage)"
        
        if strImage.isEmpty {
            picture = ""
        }
        
        if validateFields() {
            
            var signatures:[[String:Any]] = []
            for sign in self.userSignatures {
                
                let strsign = sign["Signature"] ?? ""
                let strinit = sign["Initials"] ?? ""
                
                signatures.append([
                    "Signature": strsign,
                    "Initials": strinit,
                    "SignatureDescription":sign["SignatureDescription"] ?? "",
                    "Settings": sign["Settings"] ?? "",
                    "UserSignatureId":sign["UserSignatureId"] ?? ""] as [String : Any])
            }
            
            
            /////
            let _phoneNumber = _dialCode + (txtPhonenumber.text ?? "")
            let newdialcode = _dialCode.replacingOccurrences(of: "+", with: "")
            let phonecountrycode = __countryCode + "|" + newdialcode
            
            let timezone = [
                "BaseUtcOffset": BaseUtcOffset ?? "",
                "DisplayName": DisplayName ?? "",
                "StandardName": StandardName ?? "",
                "SupportsDaylightSavingTime": SupportsDaylightSavingTime ?? false
                ] as [String : Any]
            
            let parameter = [
                "ProfileId": ProfId,
                "UserId": strUid,
                "OrganizationId": strOid,
                "Email": txtEmail.text ?? "",
                "FirstName": txtFirstName.text ?? "",
                "MiddleName": txtMiddleName.text ?? "",
                "MiddleInitials": "",
                "LastName": txtLastName.text ?? "",
                "Rating": NSNull(),
                "Link": "",
                "Locale": "en-US",
                "Picture": picture,//"data:image/png;base64,\(strAbc)",
                "Thumbnail": "",
                "ThumbnailURL": NSNull(),
                "IsActive": "1",
                "IsDeleted": NSNull(),
                "IsWelcomeVisible": NSNull(),
                "IsDefault": NSNull(),
                "AddressLine1": txtAddress1.text ?? "",
                "AddressLine2": txtAddress2.text ?? "",
                "ZipCode": txtZipCode.text ?? "",
                "StateCode": strState,
                "City": strCity,
                "County": "",
                "Country": strCountry,
                "CountryCode": strCountryCode,
                "Address": "",
                "OfficialName": "",
                "Suffix": "",
                "Title": "",
                "JobTitle": jobTitle,
                "PhoneNumber": _phoneNumber,
                "PhoneContryCode": phonecountrycode,
                "WebSite": self.website,
                "OfficePhoneContryCode": self.officephoneCode,
                "OfficePhoneNumber": self.officephoneNumber,
                "UserSignatureId": 0,//self.userSignatureId,
                "Signature": "",//self.signature,
                "Initials": "",//self.initials,
                "SignatureDescription": NSNull(),//self.signatureDescription,
                "UserSignatures": NSNull(),//signatures,
                "ProfileStatus": self.profileCompletionStatus,
                "Settings": NSNull(),//self.settings,
                "CreatedBy": "null",
                "ModifiedBy": "null",
                "UserType": self.userType!,
                "TimeZoneDetails": timezone
                ] as [String : Any]
            
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            
            
            if Connectivity.isConnectedToInternet() == true
            {
                self.showActivityIndicatory(uiView: self.view)
                Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/UpdateProfile")!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                    .responseJSON { response in
                        
    
                        
                        self.stopActivityIndicator()
                        if response.result.isFailure {
                            return 
                        }
                        
                        let jsonObj: JSON = JSON(response.result.value!)
                        
                        //print(jsonObj)
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.updatedFlag = true
                            self.getUser()
                            //self.performSegue(withIdentifier: "segCancel", sender: self)
                            self.alertSample(strTitle: "", strMsg: "Profile updated successfully.")
                            ZorroTempData.sharedInstance.setPhoneNumber(phonenumber: _phoneNumber)
                            
                            var userdata = UserData()
                            userdata.Email = (parameter["Email"] as! String)
                            userdata.FirstName = (parameter["FirstName"] as! String)
                            userdata.LastName =  (parameter["LastName"] as! String)
                            userdata.AddressLine1 = (parameter["AddressLine1"] as! String)
                            userdata.AddressLine2 = (parameter["AddressLine2"] as! String)
                            userdata.ZipCode = (parameter["ZipCode"] as! String)
                            userdata.StateCode =  (parameter["StateCode"] as! String)
                            userdata.City = (parameter["City"] as! String)
                            userdata.Country = (parameter["Country"] as! String)
                            userdata.JobTitle = (parameter["JobTitle"] as! String)
                            userdata.PhoneNumber =  (parameter["PhoneNumber"] as! String)
                            userdata.WebSite =  (parameter["WebSite"] as! String)
                            userdata.OfficePhoneNumber = (parameter["OfficePhoneNumber"] as! String)
                            userdata.UserType = (parameter["UserType"] as! Int)
                            
                            if userdata.UserType == 2 {
                                userdata.BusinessName = ""
                            }
                            
                            var userprofile = UserProfile()
                            userprofile.Data = userdata
                            
                            ZorroTempData.sharedInstance.setUserprofile(userprofile: userprofile)
                            
                            //self.navigationController?.popViewController(animated: false)
                            //self.perform(#selector(self.gotoMyAccount), with: self, afterDelay: 0.5)
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
    }
    
    @objc func gotoMyAccount() {
        
        if docSignFlag {
            UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
            self.navigationController?.popViewController(animated: false)
            
        } else {
            let userProfile = UserProfile()
            
            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            userProfile.getuserprofileData { (profiledata, err) in
                Singletone.shareInstance.stopActivityIndicator()
                if let _profileData = profiledata {
                    if let signature = (_profileData.Data?.Signature) {
                        
                        if signature.isEmpty {
                            UserDefaults.standard.setValue(7, forKey: "ProfileStatus")
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
                            let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
                            self.navigationController?.pushViewController(signatureVC, animated: true)
                        } else {
                            UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
            
            
//            let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
//
//            // for NEW user
//            if self.profileStatus == 1 {
//                if adminflag {
////                    performSegue(withIdentifier: "segCompany", sender: self)
//                    UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
//                    self.navigationController?.popViewController(animated: false)
//                } else {
//                    UserDefaults.standard.setValue(7, forKey: "ProfileStatus")
//                    let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
//                    let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
//                    self.navigationController?.pushViewController(signatureVC, animated: true)
//                }
//            } else if self.profileStatus == 7 {
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
//                let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
//                self.navigationController?.pushViewController(signatureVC, animated: true)
//            } else {
//                self.navigationController?.popViewController(animated: false)
//            }
        }
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        //performSegue(withIdentifier: "segCancel", sender: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnCancelAction(_ sender: Any) {
        //performSegue(withIdentifier: "segCancel", sender: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func pickerDoneAction(_ sender: Any) {
        
        scrollView.scrollsToTop = true
        pickerContainer.isHidden = true
        countryPicker.isHidden = true
        self.view.endEditing(true)
    }
    
    // 1 - Configure a simple search text view
    fileprivate func configureSimpleSearchTextField() {
        // Start visible even without user's interaction as soon as created - Default: false
        //txtCountry.startVisibleWithoutInteraction = true
        
        txtCountry.theme.font = UIFont.systemFont(ofSize: 16)
        txtCountry.theme.bgColor = UIColor.white.withAlphaComponent(0.2)
        txtCountry.theme.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
        txtCountry.theme.separatorColor = UIColor.lightGray.withAlphaComponent(0.5)
        txtCountry.theme.cellHeight = 50
        txtCountry.theme.placeholderColor = UIColor.lightGray
        // Set data source
        
        txtCountry.filterStrings(countryArr)
    }
    
}
// MARK: - LUAutocompleteViewDataSource

extension UserProfileViewController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = countryArr.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate

extension UserProfileViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        print(text + " was selected from autocomplete view")
        
    }
}

extension UserProfileViewController {
    @objc
    private func selectCountryCode(_ sender: UIButton) {
        let countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            DispatchQueue.main.async {
                self?._dialCode = dialcode
                self?.__countryCode = code
                self?.countrycodeLabel.text = dialcode
                self?.countrypickerImage.image = self?.setcountryImage(countryCode: code)
                
                self?.navigationController?.popViewController(animated: true)
            }
            return
        }
        
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(countryPicker, animated: true)
        }
    }
}

//MARK: New Implementation
extension UserProfileViewController {
    fileprivate func setStyles() {
        
        btnUpdate.isEnabled = true
        
        imageContainerView.clipsToBounds = false
        imageContainerView.backgroundColor = .white
        imageContainerView.layer.shadowColor = UIColor.black.cgColor
        imageContainerView.layer.shadowOpacity = 1
        imageContainerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        imageContainerView.layer.shadowRadius = 2
        imageContainerView.layer.cornerRadius = imageContainerView.frame.width/2
        
        
        imgProfileView.clipsToBounds = true
        imgProfileView.layer.cornerRadius = imgProfileView.frame.size.width / 2;
                
        imgCamaraView.layer.cornerRadius = imgCamaraView.frame.size.width / 2;
        imgCamaraView.clipsToBounds = true
        imgCamaraView.layer.masksToBounds = false
        imgCamaraView.layer.borderColor = UIColor.black.cgColor
        imgCamaraView.backgroundColor = .white
        imgCamaraView.layer.shadowRadius  = 1.5;
        imgCamaraView.layer.shadowColor   = UIColor.lightGray.cgColor
        imgCamaraView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        imgCamaraView.layer.shadowOpacity = 0.9;
        
        btnCancel.backgroundColor = .white
        btnCancel.layer.borderColor = UIColor(named: "BtnBorder")?.cgColor
        btnCancel.layer.borderWidth = 1
        btnCancel.setTitleColor(UIColor(named: "BtnTextWithoutBG"), for: .normal)
        btnCancel.setTitle("CANCEL", for: .normal)
        
        var allviews: [UIView] = []
        
        allviews += [viewFN, viewMN, viewLN, viewE, viewJ, viewPN, viewA1, viewA2, viewC, viewS, viewZC, viewCo]
        
        for view in allviews {
            view.backgroundColor = .white
            view.layer.shadowRadius  = 1.5;
            view.layer.shadowColor   = UIColor.lightGray.cgColor
            view.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
            view.layer.shadowOpacity = 0.9;
            view.layer.masksToBounds = false;
            view.layer.cornerRadius = 8
            
            StackViewTF.setCustomSpacing(2, after: view)
        }
        
        StackViewTF.setCustomSpacing(40, after: viewCo)
    }
}

//MARK: - Set Country Image
extension UserProfileViewController {
    private func setcountryImage(countryCode: String) -> UIImage? {
        let bundle = "assets.bundle/"
        let image = UIImage(named: bundle + countryCode + ".png",
        in: Bundle(for: ADCountryPicker.self), compatibleWith: nil)
        
        return image ?? nil
    }
}


