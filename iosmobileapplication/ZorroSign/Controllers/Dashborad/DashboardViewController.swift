//
//  DashboardViewController.swift
//  ZorroSign
//
//  Created by Apple on 02/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

//MARK: TODO : This controller has to be refacor. this is very bad coding. 16/10/2019

import UIKit
import Alamofire
import SwiftyJSON
import ImageSlideshow
import Speech
import TagListView
import IHKeyboardAvoiding

@available(iOS 10.0, *)
class DashboardViewController: BaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, SFSpeechRecognizerDelegate, labelCellDelegate, UIAdaptivePresentationControllerDelegate {
    

    @IBOutlet weak var viewActionWidth: NSLayoutConstraint!
    @IBOutlet weak var viewReview: UIView!
    @IBOutlet weak var viewComplete: UIView!
    @IBOutlet weak var viewInProcess: UIView!
    @IBOutlet weak var viewReject: UIView!
    
    @IBOutlet weak var viewBottomDashborad: UIView!
    //@IBOutlet weak var viewBottomStart: UIView!
    @IBOutlet weak var viewBottomSearch: UIView!
    @IBOutlet weak var viewBottomMyAccount: UIView!
    @IBOutlet weak var btnBottomHelp: UIView!

    @IBOutlet weak var lblDashboard: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblMyAccount: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    
    @IBOutlet weak var imgDashboard: UIImageView!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgMyAccount: UIImageView!
    @IBOutlet weak var imgHelp: UIImageView!
    
    @IBOutlet weak var tableViewDashboard: UITableView!
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var viewSearchBarSubView: UIView!
    @IBOutlet weak var txtSearchText: UITextField!
    @IBOutlet weak var viewSelectAll: UIView!
    @IBOutlet weak var btnSelectAll: UIButton!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblEsign: UILabel!
    @IBOutlet weak var lblComplete: UILabel!
    @IBOutlet weak var lblInProcess: UILabel!
    @IBOutlet weak var lblRejected: UILabel!
    
    @IBOutlet weak var txtComplete: UILabel!
    @IBOutlet weak var txtRejected: UILabel!
    
    @IBOutlet weak var viewRI: UIView!
    @IBOutlet weak var viewCI: UIView!
    @IBOutlet weak var viewIPI: UIView!
    @IBOutlet weak var viewREI: UIView!
    
    @IBOutlet weak var lblRT: UILabel!
    @IBOutlet weak var lblCT: UILabel!
    @IBOutlet weak var lblIPT: UILabel!
    @IBOutlet weak var lblRET: UILabel!
    
    @IBOutlet weak var viewWhatsNew: ImageSlideshow!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var viewWhatsNewSub: UIView!
    @IBOutlet weak var btnX: UIButton!
    @IBOutlet weak var viewSearchAction: UIView!
    
    //MARK:  New
    @IBOutlet weak var startsignButton: UIButton!
    
    //MARK: - image template color
    @IBOutlet weak var imgInProcess: UIImageView!
    @IBOutlet weak var imgReject: UIImageView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US")) // 1
    
    private var recognizationRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognizationTask: SFSpeechRecognitionTask?
    private var audioEngin = AVAudioEngine()
    
    let container: UIView = UIView()
    let loadingView: UIView = UIView()
    let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let datepicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 300, height: 200))

    @IBOutlet weak var imgSearchMic: UIImageView!
    
    @IBOutlet weak var chkDontShow: UIButton!
    
    @IBOutlet weak var btnDDComplete: UIButton!
    @IBOutlet weak var btnDDReject: UIButton!
    
    var esCount = Int()
    
    var selectAllFlag = String()
    
    var ks = [KingfisherSource]()
    
    var jsonEsign: JSON?
    var jsonCompleted: JSON?
    var jsonInProcess: JSON?
    var jsonRejected: JSON?
    
    var jsonShared: JSON?
    var jsonScanned: JSON?
    
    var jsonExpired: JSON?
    var jsonCancelled: JSON?
    
    var jsonReload: JSON?
    var jsonSearch: JSON?
    var jsonSearchNil: JSON?
    var strSearch: String = ""
    
    var arrSelectedItem = [Int]()
    
    var arrAlertIndexRow = [Int]()
    
    var startDate: Date?
    var endDate: Date?
    
    var startDate1: Date?
    var endDate1: Date?
    
    var cntjsonObj: JSON?
    
    var filterAlertView: SwiftAlertView!
    var filterDatesAlertView: SwiftAlertView!
    var labelAlertView: SwiftAlertView!
    var sendEmailAlert: SwiftAlertView!
    
    var bucketAlert: SwiftAlertView!
    var recipientAlert: SwiftAlertView!
    
    var completeAlert: UIAlertController!
    var rejectAlert: UIAlertController!
    
    var selCategory: Int = 90
    var selectedSegmentIndex: Int = 0
    
    @IBOutlet weak var lblSelectAll: UILabel!
    
    @IBOutlet weak var btnClear: UIButton!
    
    var labelArr: [LabelData] = []
    var sellabelArr: [LabelData] = []
    var orgSellabelArr: [LabelData] = []
    var totSellabelArr: [LabelData] = []
    
    var filtertedArray: [LabelData] = []
    var labelDic: NSMutableDictionary = NSMutableDictionary.init()
    
    @IBOutlet weak var menubtn: UIBarButtonItem!
    
    var treeDataArr: [[String:Any]] = []
    var searchTxt: String = ""
    
    var IsSubscriptionActive: Bool = true
    
    @IBOutlet weak var lblDntShow: UILabel!
    
    var userList: [[String:Any]] = []
    
    var completeArr: [String] = ["Completed","Shared To Me","Scanned Token"]
    var rejectArr: [String] = ["Rejected","Expired","Cancelled"]
    
    var selComplete: String = "Completed"
    var selReject: String = "Rejected"
    
    var cntCompleteDic: [String:Int] = [:]
    var cntRejectDic: [String:Int] = [:]
    
    //private let autocompleteView = LUAutocompleteView()
    
    var recipientArr: [String] = []
    
    var recipientFlag: Bool = false
    
    var isChanged: Bool = false
    
    var isnoramal: Bool = true
    var docname: String!
    var processid: String!
    
    var selectedColorBG = ColorTheme.btnBG
    var selectedColorCOntent = ColorTheme.btnTextWithBG
    
    var unselectedColorBG = ColorTheme.btnBGDefault
    var unSelectedColorContent = ColorTheme.btnTextWithoutBG
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        chechFromPush()
        checkforDeepLinke()
        changeColor()
        
        startsignButton.addTarget(self, action: #selector(startsignatureAction(_:)), for: .touchUpInside)
        UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        ////START RECORDING
        //btnRecord.isEnabled = false //2   error
        viewSearchAction.isUserInteractionEnabled = false
        speechRecognizer?.delegate = self   //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in   //4
            
            var isButtonEnable = false
            
            switch authStatus   //5
            {
            case .authorized:
                isButtonEnable = true
            case .denied:
                isButtonEnable = false
                print("User denied access to speech recognition")
            case .notDetermined:
                isButtonEnable = false
                print("Speech recognition not yet authorized")
            case .restricted:
                isButtonEnable = false
                print("Speech recognition restricted on this device")
            }
            
            OperationQueue.main.addOperation {
                //self.btnRecord.isEnabled = isButtonEnable
                self.viewSearchAction.isUserInteractionEnabled = isButtonEnable
            }
        }
        
        ////END RECORDING
        
        // check for scanned doc
        if UserDefaults.standard.value(forKey: "scannedqrcode") != nil &&  !((UserDefaults.standard.value(forKey: "scannedqrcode") as? String)?.isEmpty)! {
            self.performSegue(withIdentifier: "segDocument", sender: self)
        }
        
        
        selectAllFlag = "Deselected"
        
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
//        lblWait.text = "Loading"
//        lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
//        lblWait.font = lblWait.font.withSize(13)
//        lblWait.textAlignment = .center
//        lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        self.loadingView.addSubview(lblWait)
        
        self.loadingView.addSubview(self.actInd)
        container.addSubview(self.loadingView)
        view.addSubview(container)
        
        self.actInd.startAnimating()
        //Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        viewReview.layer.cornerRadius = 3
        viewReview.clipsToBounds = true
        viewComplete.layer.cornerRadius = 3
        viewComplete.clipsToBounds = true
        viewInProcess.layer.cornerRadius = 3
        viewInProcess.clipsToBounds = true
        viewReject.layer.cornerRadius = 3
        viewReject.clipsToBounds = true
        
        viewSelectAll.layer.cornerRadius = 3
        viewSelectAll.clipsToBounds = true
        tableViewDashboard.layer.cornerRadius = 3
        tableViewDashboard.clipsToBounds = true
        
        viewSearchBarSubView.layer.cornerRadius = 3
        viewSearchBarSubView.clipsToBounds = true
        
        viewSearchBar.isHidden = true
        txtSearchText.delegate = self
        
        let gestureDashboardSearch = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionSearch))
        viewSearchAction.addGestureRecognizer(gestureDashboardSearch)
        
        
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
        
        
        
        tableViewDashboard.dataSource = self
        tableViewDashboard.delegate = self
        self.navigationController?.isNavigationBarHidden = false
        
        
        //1.
        //https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetCountForCategory?labelId=-1
        
        //getSubscriptionData()
        
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        if adminflag {
            getOrgDetails()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDashboard), name: NSNotification.Name(rawValue: "RefreshNotification"), object: nil)
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
        
        
    }
    
    //MARK: - Set template image color
    func changeColor() {
        self.imgInProcess.tintColor = ColorTheme.btnBGDefault
        self.imgReject.tintColor = ColorTheme.btnBGDefault
    }
    
    @objc func refreshDashboard() {
        
        print("refreshDashboard called")
        
        callAPI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getUnreadPushCount()
        self.navigationController?.navigationBar.topItem?.title = "Dashboard"
    }
    
    func addTopGestures(){
        
        //Gesture Top
        let gestureEsign = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionTop))
        let gestureCompleted = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionTop))
        let gestureInProcess = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionTop))
        let gestureRejected = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionTop))
        
        viewReview.addGestureRecognizer(gestureEsign)
        viewComplete.addGestureRecognizer(gestureCompleted)
        viewInProcess.addGestureRecognizer(gestureInProcess)
        viewReject.addGestureRecognizer(gestureRejected)
    }
    
    func disableDashboard() {
        
        viewReview.backgroundColor = UIColor.lightGray
        viewComplete.backgroundColor = UIColor.lightGray
        viewInProcess.backgroundColor = UIColor.lightGray
        viewReject.backgroundColor = UIColor.lightGray
        
        tableViewDashboard.isHidden = true
        viewSelectAll.isHidden = true
        
        viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
        lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
        lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
    }
    
    func getOrgDetails() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            let api = "Organization/GetOrganizationDetails"
            let apiURL = Singletone.shareInstance.apiURL + api
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    // print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        let company = jsonObj["Data"]["Organization"]["LegalName"].stringValue
                        UserDefaults.standard.set(company, forKey: "Company")
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
    
    func callAPI() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            self.btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            
            self.sellabelArr.removeAll()
            self.ks = []
            self.arrSelectedItem = []
            let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
            let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
            //        DispatchQueue.main.async {
            //            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            //        }
            
            /////START WHATS NEW
            self.viewWhatsNew.isHidden = true
            self.btnX.isHidden = true
            self.chkDontShow.isHidden = true
            self.lblDntShow.isHidden = true
            
            self.viewWhatsNewSub.addBottomBorderWithColor(color: Singletone.shareInstance.footerviewBackgroundGreen, width: 0.5)
            self.viewWhatsNew.layer.cornerRadius = 3
            self.viewWhatsNew.clipsToBounds = true
            
            if Connectivity.isConnectedToInternet() == false
            {
                self.alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
            else
            {
                //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                self.actInd.startAnimating()
                
                var api = "api/v1/Notification/Features?count=7"
                var apiURL = Singletone.shareInstance.apiNotification + api
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            if response.result.isFailure {
                                self.actInd.stopAnimating()
                                self.actInd.hidesWhenStopped = true
                                self.container.isHidden = true
                                //return
                            }
                            guard let response = response as? DataResponse<Any> else {
                                return
                            }
                            let jsonObj: JSON = JSON(response.result.value as Any)
                                if jsonObj["StatusCode"] == 1000
                                {
                                    self.viewWhatsNew.backgroundColor = UIColor.white
                                    self.viewWhatsNew.circular = false
                                    self.viewWhatsNew.pageIndicatorPosition = PageIndicatorPosition(horizontal: PageIndicatorPosition.Horizontal.center, vertical: PageIndicatorPosition.Vertical.customBottom(padding: 50))
                                    //PageControlPosition.insideScrollView
                                    self.viewWhatsNew.pageControl.currentPageIndicatorTintColor = Singletone.shareInstance.footerviewBackgroundGreen
                                    self.viewWhatsNew.pageControl.pageIndicatorTintColor = UIColor.lightGray
                                    self.viewWhatsNew.contentScaleMode = UIView.ContentMode.scaleAspectFit//scaleAspectFill
                                    
                                    for i in 0...jsonObj["Data"].arrayValue.count - 1
                                    {
                                        self.ks.append(KingfisherSource(urlString: "whtnw.png")!)
                                        //self.ks.append(KingfisherSource(urlString: jsonObj["Data"][i]["ImageUrl"].stringValue)!)
                                    }
                                    print("slide imgs data: \(jsonObj["Data"])")
                                    self.lblTitle.text = jsonObj["Data"][0]["Description"].stringValue//String(page)
                                    self.lblSubTitle.text = jsonObj["Data"][0]["Header"].stringValue
                                    let url = URL(string: jsonObj["Data"][0]["ImageUrl"].stringValue)
                                    self.imgView.kf.setImage(with: url)
                                    
                                    self.viewWhatsNew.slideshowInterval = 4.0
                                    self.viewWhatsNew.setImageInputs(self.ks)
                                    
                                    self.viewWhatsNew.activityIndicator = DefaultActivityIndicator()
                                    self.viewWhatsNew.currentPageChanged = { page in
                                        print("current page:", page)
                                        self.lblTitle.text = jsonObj["Data"][page]["Header"].stringValue//String(page)
                                        self.lblSubTitle.text = jsonObj["Data"][page]["Description"].stringValue
                                        let url = URL(string: jsonObj["Data"][page]["ImageUrl"].stringValue)
                                        if page != 6 {
                                            print("url: \(url)")
                                            self.lblSubTitle.isHidden = false
                                            self.imgView.kf.setImage(with: url)
                                        } else {
                                            self.lblTitle.text = "Get Work Done with Four Easy Steps"
                                            self.lblSubTitle.isHidden = true
                                            self.imgView.image = UIImage(named: "whtnw.png")
                                        }
                                    }
                                    
                                    let dontshowagain = UserDefaults.standard.bool(forKey: "dontshowagain")
                                    self.chkDontShow.isSelected = dontshowagain
                                    
//                                    let launchFlag = UserDefaults.standard.bool(forKey: "launch")
//                                    UserDefaults.standard.set(false, forKey: "launch")
                                    
                                    if dontshowagain {
                                        self.viewWhatsNew.isHidden = true
                                        self.btnX.isHidden = true
                                        self.chkDontShow.isHidden = true
                                        self.lblDntShow.isHidden = true
                                        
                                    } else {
                                        self.viewWhatsNew.isHidden = false
                                        self.btnX.isHidden = false
                                        self.chkDontShow.isHidden = false
                                        self.lblDntShow.isHidden = false
                                    }
                                    
                                    
                                    //Singletone.shareInstance.stopActivityIndicator()
                                }
                                else
                                {
                                    //Singletone.shareInstance.stopActivityIndicator()
                                    self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                                }
                            
                            
                    }
                })
                
                // -------------------------------------------------------------------------------------//
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                    let strPid = ZorroTempData.sharedInstance.getProfileId()
                    
                    Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetProfile?profileId=\(strPid)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            
                            if response.result.isFailure {
                                self.actInd.stopAnimating()
                                self.actInd.hidesWhenStopped = true
                                self.container.isHidden = true
                                //return
                            }
                        let jsonObj: JSON = JSON(response.result.value as Any)
                            //                    print("getProfile: \(jsonObj)")
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                let myAttribute = [ NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18) ]
                                let myString = NSMutableAttributedString(string: "Welcome", attributes: myAttribute )
                                
                                let attrString1 = NSAttributedString(string: " | ")
                                myString.append(attrString1)
                                
                                let myAttribute1 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]
                                
                                let attrString2 = NSMutableAttributedString(string: jsonObj["Data"]["FirstName"].stringValue, attributes: myAttribute1 )
                                myString.append(attrString2)
                                
                                self.lblUserName.text = jsonObj["Data"]["FirstName"].stringValue//myString //"Welcome | " + jsonObj["Data"]["FirstName"].stringValue
                                
                                let data = jsonObj["Data"].dictionaryObject
                                if let signature = data!["Signature"] as? String, !signature.isEmpty {
                                    
                                    let arr = signature.components(separatedBy: ",")
                                    let sign = arr[1]
                                    UserDefaults.standard.set(sign, forKey: "UserSign")
                                    ZorroTempData.sharedInstance.setSignature(signature: sign) // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                }
                                if let initials = data!["Initials"] as? String, !initials.isEmpty {
                                    
                                    let arr = initials.components(separatedBy: ",")
                                    let sign = arr[1]
                                    UserDefaults.standard.set(sign, forKey: "UserInitial")
                                    ZorroTempData.sharedInstance.setInitials(initials: sign) // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                }
                                
                                if let signatues = data!["UserSignatures"] as? [[String:Any]], !signatues.isEmpty {
                                    
                                }
                                let userSignId = jsonObj["Data"]["UserSignatureId"].intValue
                                let email = jsonObj["Data"]["Email"].stringValue
                                let fname = jsonObj["Data"]["FirstName"].stringValue
                                let middle = jsonObj["Data"]["MiddleName"].stringValue
                                let lname = jsonObj["Data"]["LastName"].stringValue
                                let subscriptionPlan = jsonObj["Data"]["SubscriptionPlan"].intValue
                                let phone = jsonObj["Data"]["PhoneNumber"].stringValue
                                let jobTitle = jsonObj["Data"]["JobTitle"].stringValue
                                let UserType = jsonObj["Data"]["UserType"].intValue
                                ZorroTempData.sharedInstance.setUserType(usertype: UserType)// REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                
                                let fullName = fname + " " + lname
                                
                                UserDefaults.standard.set(fname, forKey: "FName")
                                UserDefaults.standard.set(middle, forKey: "MName")
                                UserDefaults.standard.set(lname, forKey: "LName")
                                ZorroTempData.sharedInstance.setUserName(username: "\(fname) \(middle) \(lname)") // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                UserDefaults.standard.set(userSignId, forKey: "UserSignId")
                                UserDefaults.standard.set(fullName, forKey: "FullName")
                                UserDefaults.standard.set(email, forKey: "Email")
                                ZorroTempData.sharedInstance.setUserEmail(email: email) // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                UserDefaults.standard.set(phone, forKey: "Phone")
                                ZorroTempData.sharedInstance.setPhoneNumber(phonenumber: phone) // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                UserDefaults.standard.set(jobTitle, forKey: "JobTitle")
                                ZorroTempData.sharedInstance.setJobTitle(jobtitle: jobTitle) // REMOVE THIS, NOTHING TO DO WITH THIS BAD CODING
                                UserDefaults.standard.set(subscriptionPlan, forKey: "SubscriptionPlan")
                                UserDefaults.standard.set(UserType, forKey: "UserType")
                                var userSign = data!["UserSignatures"] as? NSArray
                                
                                if userSign != nil {
                                    var cnt = 0
                                    
                                    for sign in userSign! {
                                        let dic = sign as! [AnyHashable : Any]
                                        cnt = cnt + 1
                                        if let signature = dic["Signature"] as? String {
                                            
                                            let arr = signature.components(separatedBy: ",")
                                            if arr.count > 1 {
                                                let sign = arr[1]
                                                let key: String = "UserSign\(cnt)"
                                                UserDefaults.standard.set(sign, forKey: key)
                                            }
                                        }
                                        
                                        if let initialstr = dic["Initials"] as? String {
                                            let arr1 = initialstr.components(separatedBy: ",")
                                            if arr1.count > 1 {
                                                let initial = arr1[1]
                                                let key1: String = "UserInitial\(cnt)"
                                                UserDefaults.standard.set(initial, forKey: key1)
                                            }
                                        }
                                    }
                                }
                                
                            }
                            else
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                        
                    }
                })
                
                // -------------------------------------------------------------------------------------//
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                    api = "v1/dashboard/GetCountForCategory?labelId=-1&dashboardCategory=0"
                    apiURL = Singletone.shareInstance.apiUserService + api
                    
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            if response.result.isFailure {
                                self.actInd.stopAnimating()
                                self.actInd.hidesWhenStopped = true
                                self.container.isHidden = true
                            }
                            
                            
                            let jsonObj: JSON = JSON(response.result.value as Any)
                            self.cntjsonObj = jsonObj
                            //                    print("1. Get Count")
                            //                    print(jsonObj)
                            if jsonObj["StatusCode"] == 1000
                            {
                                /*
                                 "TotalCounts" : {
                                 "Pending" : 7,
                                 "Rejected" : 1,
                                 "Expired" : 0,
                                 "Esign" : 7,
                                 "ScannedToken" : 1,
                                 "Completed" : 13,
                                 "Canceled" : 9,
                                 "SharedToMe" : 6
                                 }
                                 */
                                //
                                //Singletone.shareInstance.stopActivityIndicator()
                                //let TotalCounts = jsonObj["Data"] // for demo env
                                let TotalCounts = jsonObj["Data"]["TotalCounts"] // for demo v2 env
                                
                                self.lblInProcess.text = String(TotalCounts["Pending"].intValue)
                                self.lblComplete.text = String(TotalCounts["Completed"].intValue)
                                self.lblRejected.text = String(TotalCounts["Rejected"].intValue)
                                self.lblEsign.text  = String(TotalCounts["Esign"].intValue)
                                
                                self.esCount = jsonObj["Data"]["Esign"].intValue
                                
                                self.cntCompleteDic["Completed"] = TotalCounts["Completed"].intValue
                                self.cntCompleteDic["Shared To Me"] = TotalCounts["SharedToMe"].intValue
                                self.cntCompleteDic["Scanned Token"] = TotalCounts["ScannedToken"].intValue
                                
                                self.cntRejectDic["Rejected"] = TotalCounts["Rejected"].intValue
                                self.cntRejectDic["Expired"] = TotalCounts["Expired"].intValue
                                self.cntRejectDic["Cancelled"] = TotalCounts["Canceled"].intValue
                                
                                
                                self.lblComplete.text = String(self.cntCompleteDic[self.selComplete]!)
                                self.lblRejected.text = String(self.cntRejectDic[self.selReject]!)
                                
                                /////dyanamic start
                                //2.
                                //https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=10&orderBy=9&isAscending=true&labelId=-1
                                
                                //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                                
                                if self.IsSubscriptionActive {
                                    
                                    
                                    var api = "v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=\(jsonObj["Data"]["Esign"].intValue)&orderBy=9&isAscending=true&labelId=-1"
                                    var apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            if response.result.isFailure {
                                                self.actInd.stopAnimating()
                                                self.actInd.hidesWhenStopped = true
                                                self.container.isHidden = true
                                                //return
                                            }
                                            
                                             let jsonObj: JSON = JSON(response.result.value as Any)
                                                
                                                //                                        print("2. EList")
                                                //                                        print(jsonObj)
                                                if self.selCategory == 90 {
                                                    self.jsonReload = jsonObj
                                                }
                                                
                                                self.jsonSearchNil = jsonObj
                                                DispatchQueue.main.async {
                                                    self.tableViewDashboard.isHidden = false
                                                    self.tableViewDashboard.reloadData()
                                                }
                                                self.jsonEsign = jsonObj
                                                if jsonObj["StatusCode"] == 1000
                                                {
                                                    //Singletone.shareInstance.stopActivityIndicator()
                                                    if let labelList = jsonObj["Data"]["LabelList"].arrayObject {
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    //Singletone.shareInstance.stopActivityIndicator()
                                                    //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                                                }
                                            
                                    }
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=1&startIndex=0&pageSize=\(jsonObj["Data"]["Pending"].intValue)&orderBy=5&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    
                                    //3.
                                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            if !response.result.isFailure {
                                                //return
                                                
                                                let jsonObj: JSON = JSON(response.result.value as Any)
                                                    //                                            print("3. In Process")
                                                    //                                            print(jsonObj)
                                                    self.jsonInProcess = jsonObj
                                                    
                                                    if self.selCategory == 92 {
                                                        self.jsonReload = jsonObj
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.tableViewDashboard.isHidden = false
                                                        self.tableViewDashboard.reloadData()
                                                    }
                                                    if jsonObj["StatusCode"] == 1000
                                                    {
                                                        //Singletone.shareInstance.stopActivityIndicator()
                                                        if let labelList = jsonObj["Data"]["LabelList"].arrayObject {
                                                            
                                                        }
                                                    }
                                                    else
                                                    {
                                                        //Singletone.shareInstance.stopActivityIndicator()
                                                        //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                                                    }
                                                
                                            }
                                    }
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=\(jsonObj["Data"]["Completed"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    //4.
                                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            if !response.result.isFailure {
                                                
                                                let jsonObj: JSON = JSON(response.result.value as Any)
                                                //                                        print("4. Completed")
                                                //                                        print(jsonObj)
                                                self.jsonCompleted = jsonObj
                                                if self.selCategory == 91 {
                                                    self.jsonReload = jsonObj
                                                }
                                                DispatchQueue.main.async {
                                                    self.tableViewDashboard.isHidden = false
                                                    self.resetPlaceholder()
                                                    //self.tableViewDashboard.reloadData()
                                                }
                                                if jsonObj["StatusCode"] == 1000
                                                {
                                                    //Singletone.shareInstance.stopActivityIndicator()
                                                    if let labelList = jsonObj["Data"]["LabelList"].arrayObject {
                                                        
                                                    }
                                                }
                                                else
                                                {
                                                    //Singletone.shareInstance.stopActivityIndicator()
                                                    //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                                                }
                                            }
                                    }
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=3&startIndex=0&pageSize=\(jsonObj["Data"]["Rejected"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    //5.
                                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            let jsonObj: JSON = JSON(response.result.value as Any)
                                            //                                    print("5. Rejected")
                                            //                                    print(jsonObj)
                                            self.jsonRejected = jsonObj
                                            if self.selCategory == 93 {
                                                self.jsonReload = jsonObj
                                            }
                                            DispatchQueue.main.async {
                                                self.tableViewDashboard.isHidden = false
                                                self.resetPlaceholder()
                                                //self.tableViewDashboard.reloadData()
                                            }
                                            if jsonObj["StatusCode"] == 1000
                                            {
                                                //Singletone.shareInstance.stopActivityIndicator()
                                            }
                                            else
                                            {
                                                Singletone.shareInstance.stopActivityIndicator()
                                                //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                                            }
                                    }
                                    
                                    // shared docs
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=7&startIndex=0&pageSize=\(jsonObj["Data"]["Completed"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            let jsonObj: JSON = JSON(response.result.value as Any)
                                            //                                    print("6. Shared")
                                            //                                    print(jsonObj)
                                            self.jsonShared = jsonObj
                                            
                                            if  self.selCategory == 91 && self.selComplete == "Shared To Me" {
                                                self.jsonReload = jsonObj
                                            }
                                            DispatchQueue.main.async {
                                                self.tableViewDashboard.isHidden = false
                                                self.resetPlaceholder()
                                                //self.tableViewDashboard.reloadData()
                                            }
                                            if jsonObj["StatusCode"] == 1000
                                            {
                                                //Singletone.shareInstance.stopActivityIndicator()
                                            }
                                            else
                                            {
                                                Singletone.shareInstance.stopActivityIndicator()
                                            }
                                    }
                                    
                                    // scanned docs
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=8&startIndex=0&pageSize=\(jsonObj["Data"]["Completed"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            let jsonObj: JSON = JSON(response.result.value as Any)
                                            //                                    print("7. Scanned")
                                            //                                    print(jsonObj)
                                            self.jsonScanned = jsonObj
                                            if self.selCategory == 91 && self.selComplete == "Scanned Token" {
                                                self.jsonReload = jsonObj
                                            }
                                            DispatchQueue.main.async {
                                                self.tableViewDashboard.isHidden = false
                                                self.resetPlaceholder()
                                                //self.tableViewDashboard.reloadData()
                                            }
                                            if jsonObj["StatusCode"] == 1000
                                            {
                                                //Singletone.shareInstance.stopActivityIndicator()
                                            }
                                            else
                                            {
                                                Singletone.shareInstance.stopActivityIndicator()
                                            }
                                    }
                                    
                                    // expired docs
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=5&startIndex=0&pageSize=\(jsonObj["Data"]["Rejected"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            let jsonObj: JSON = JSON(response.result.value as Any)
                                            //                                    print("7. Expired")
                                            //                                    print(jsonObj)
                                            self.jsonExpired = jsonObj
                                            if self.selCategory == 93 && self.selReject == "Expired" {
                                                self.jsonReload = jsonObj
                                            }
                                            DispatchQueue.main.async {
                                                self.tableViewDashboard.isHidden = false
                                                self.resetPlaceholder()
                                                //self.tableViewDashboard.reloadData()
                                            }
                                            if jsonObj["StatusCode"] == 1000
                                            {
                                                //Singletone.shareInstance.stopActivityIndicator()
                                            }
                                            else
                                            {
                                                Singletone.shareInstance.stopActivityIndicator()
                                            }
                                    }
                                    
                                    // Cancelled docs
                                    
                                    api = "v1/dashboard/GetDetailsForCategory?type=6&startIndex=0&pageSize=\(jsonObj["Data"]["Rejected"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                                    apiURL = Singletone.shareInstance.apiUserService + api
                                    
                                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                                        .responseJSON { response in
                                            
                                            let jsonObj: JSON = JSON(response.result.value as Any)
                                            //                                    print("7. Cancelled")
                                            //                                    print(jsonObj)
                                            self.jsonCancelled = jsonObj
                                            if self.selCategory == 93 && self.selReject == "Cancelled" {
                                                self.jsonReload = jsonObj
                                            }
                                            DispatchQueue.main.async {
                                                self.tableViewDashboard.isHidden = false
                                                self.resetPlaceholder()
                                                //self.tableViewDashboard.reloadData()
                                            }
                                            if jsonObj["StatusCode"] == 1000
                                            {
                                                //Singletone.shareInstance.stopActivityIndicator()
                                            }
                                            else
                                            {
                                                Singletone.shareInstance.stopActivityIndicator()
                                            }
                                    }
                                }
                                /////dyanamic end
                                DispatchQueue.main.async {
                                    self.actInd.stopAnimating()
                                    self.actInd.hidesWhenStopped = true
                                    self.container.isHidden = true
                                    self.tableViewDashboard.reloadData()
                                }
                                
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                    }
                })
            }
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        KeyboardAvoiding.avoidingView = viewSearchBar
        
        /////START WHATS NEW
        viewWhatsNew.isHidden = true
        btnX.isHidden = true
        chkDontShow.isHidden = true
        lblDntShow.isHidden = true
        
        if self.revealViewController() != nil {
            self.revealViewController().panGestureRecognizer().isEnabled = false
        }
        // check user profile status
        let userProfile = UserProfile()
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        userProfile.getuserprofileData { (profiledata, err) in
            Singletone.shareInstance.stopActivityIndicator()
            if let _profileData = profiledata {
                
                if let firstName = profiledata?.Data?.FirstName, let lastName = profiledata?.Data?.LastName, let phoneNumber = profiledata?.Data?.PhoneNumber {
                    
                    if firstName.isEmpty && lastName.isEmpty && phoneNumber.isEmpty {
                        AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please complete your profile", action: AlertAction(title: "Continue")) { (action) in
                            UserDefaults.standard.setValue(1, forKey: "ProfileStatus")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "userprofile_SBID")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    else if let signature = _profileData.Data?.Signature {
                        if signature.isEmpty {
                            AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please complete your profile by adding a signature", action: AlertAction(title: "Continue")) { (action) in
                                UserDefaults.standard.setValue(7, forKey: "ProfileStatus")
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
                                let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
                                self.navigationController?.pushViewController(signatureVC, animated: true)
                            }
                        }
                    } else {
                        UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
                    }
                }
                else {
                    AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please complete your profile", action: AlertAction(title: "Continue")) { (action) in
                        UserDefaults.standard.setValue(1, forKey: "ProfileStatus")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "userprofile_SBID")
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
//                if _profileData.Data?.FirstName == nil && _profileData.Data?.LastName == nil && _profileData.Data?.PhoneNumber == nil {
//
//                    AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please complete your profile", action: AlertAction(title: "Continue")) { (action) in
//                        UserDefaults.standard.setValue(1, forKey: "ProfileStatus")
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "userprofile_SBID")
//                        self.navigationController?.pushViewController(vc, animated: true)
//                    }
//                } else if (_profileData.Data?.Signature) == nil {
//
//                    AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please complete your profile by adding a signature", action: AlertAction(title: "Continue")) { (action) in
//                        UserDefaults.standard.setValue(7, forKey: "ProfileStatus")
//                        let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
//                        let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
//                        self.navigationController?.pushViewController(signatureVC, animated: true)
//                    }
//                } else {
//                    UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
//                }
            }
        }
        
//        if let profstat = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int {
//
//            // for NEW user
//            if profstat == 1 {
//
//                let alert = UIAlertController(title: "", message: "Please complete your profile", preferredStyle: .alert)
//
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
//
////                    self.performSegue(withIdentifier: "segMyAccount", sender: self)
//                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "userprofile_SBID")
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }))
//                self.present(alert, animated: true, completion: nil)
//            }
//        }
        tableViewDashboard.dataSource = self
        tableViewDashboard.delegate = self
        
        //tableViewDashboard.isHidden = true
        
        selectAllFlag = "Deselected"
        btnSelectAll.isSelected = false
        print("Deselected")
        btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
        
        arrSelectedItem.removeAll()
        self.lblSelectAll.text = "Select All"
        
        addTopGestures()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.callAPI()
        }
        
        //getSubscriptionData()
        initLabelAlert()
        callLabelAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.viewWhatsNew != nil {
            self.viewWhatsNew.isHidden = true
            self.viewWhatsNew.slideshowInterval = 0.0
        }
        if chkDontShow != nil {
            chkDontShow.isHidden = true
        }
        lblDntShow.isHidden = true
        
        btnX.isHidden = true
    }
    
    ///START RECORDING
    func startRecording()
    {
        if recognizationTask != nil
        {
            recognizationTask?.cancel()
            recognizationTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognizationRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //        guard let iNode = audioEngin.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        
        let iNode = audioEngin.inputNode
        
        guard let recognitionRequest = recognizationRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognizationTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil
            {
                self.txtSearchText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
                self.imgSearchMic.image = UIImage(named: "white_arw")
                self.audioEngin.stop()
                self.recognizationRequest?.endAudio()
                UserDefaults.standard.set("arrow", forKey: "MicORArrow")
            }
            
            if error != nil || isFinal
            {
                self.audioEngin.stop()
                iNode.removeTap(onBus: 0)
                
                self.recognizationRequest = nil
                self.recognizationTask = nil
                
                //self.btnRecord.isEnabled = true
                self.viewSearchAction.isUserInteractionEnabled = true
            }
        })
        
        let recordingFormat = iNode.outputFormat(forBus: 0)
        iNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognizationRequest?.append(buffer)
        }
        
        audioEngin.prepare()
        
        do {
            try audioEngin.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        txtSearchText.placeholder = "Say something, I'm listening!"
        //lblText.text = "Say something, I'm listening!"
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //btnRecord.isEnabled = true
            viewSearchAction.isUserInteractionEnabled = true
            print("availabilityDidChange = true")
        }
        else {
            //btnRecord.isEnabled = false
            viewSearchAction.isUserInteractionEnabled = false
            print("availabilityDidChange = false")
        }
    }
    
    ///END RECORDING
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnWhatsNewAction(_ sender: Any) {
        viewWhatsNew.isHidden = false
        chkDontShow.isHidden = false
        lblDntShow.isHidden = false
        self.viewWhatsNew.slideshowInterval = 4.0
        btnX.isHidden = false
    }
    @IBAction func btnXAction(_ sender: Any) {
        viewWhatsNew.isHidden = true
        chkDontShow.isHidden = true
        lblDntShow.isHidden = true
        self.viewWhatsNew.slideshowInterval = 0.0
        btnX.isHidden = true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("loc:\(range.location), length:\(range.length)")
        if range.location == 0 {
            resetPlaceholder()
        }
        
        if textField.tag == 2 {
            
            var srchstr: String = ""
            if range.length == 0 {
                srchstr = "\((textField.text!))" + "\(string)"
                
            } else if range.location > 0 {
                srchstr = (textField.text?.substring(to: range.location-1))!
            }
            
            searchTxt = srchstr
            /*
             if !srchstr.isEmpty {
             filtertedArray.removeAll()
             filtertedArray = []
             let arr = labelArr.filter{ ($0.Name?.contains(srchstr))! }
             filtertedArray.append(contentsOf: arr)
             } else {
             filtertedArray = labelArr
             }
             */
            let tablevw = labelAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
            //tablevw.reloadData()
            
        } else {
            
            viewSearchAction.isUserInteractionEnabled = true
            if txtSearchText.text?.count == 0// == ""
            {
                imgSearchMic.image = UIImage(named: "mic_white_icon")
                UserDefaults.standard.set("mic", forKey: "MicORArrow")
            }
            else
            {
                imgSearchMic.image = UIImage(named: "white_arw")
                UserDefaults.standard.set("arrow", forKey: "MicORArrow")
                audioEngin.stop()
                recognizationRequest?.endAudio()
            }
        }
        
        
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.tag == 10 || textField.tag == 11 || textField.tag == 12 || textField.tag == 13 {
            
            
            let datepickerAlert = SwiftAlertView(contentView: datepicker, delegate: self, cancelButtonTitle: "Close")
            datepicker.datePickerMode = UIDatePicker.Mode.date
            if #available(iOS 13.4, *) {
                datepicker.preferredDatePickerStyle = .wheels
            } else {
                // Fallback on earlier versions
            }
            datepickerAlert.tag = textField.tag
            
            let btnclose = datepickerAlert.buttonAtIndex(index: 0)
            btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
            
            datepickerAlert.show()
            return false
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        resetPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    
    func resetPlaceholder() {
        
        switch selCategory {
        case 90:
            
            txtSearchText.placeholder = "Search in Inbox"
            break
            
        case 91:
            txtSearchText.placeholder = "Search in Completed"
            if self.selComplete == "Shared To Me" {
                self.jsonReload = jsonShared
                txtSearchText.placeholder = "Search in Shared To Me"
            }
            else if self.selComplete == "Scanned Token" {
                self.jsonReload = self.jsonScanned
                txtSearchText.placeholder = "Search in Scanned Token"
            }
            else {
                self.jsonReload = self.jsonCompleted
            }
            break
            
        case 92:
            txtSearchText.placeholder = "Search in In Process"
            break
            
        case 93:
            txtSearchText.placeholder = "Search in Rejected"
            if self.selReject == "Expired" {
                self.jsonReload = self.jsonExpired
                txtSearchText.placeholder = "Search in Expired"
            }
            else if self.selReject == "Cancelled" {
                self.jsonReload = self.jsonCancelled
                txtSearchText.placeholder = "Search in Cancelled"
            }
            else {
                self.jsonReload = self.jsonRejected
            }
            break
        default: break
            //txtSearchText.placeholder = "Search in Inbox"
        }
        
        tableViewDashboard.reloadData()
        
        
    }
    
    @IBAction func btnSelectAllAction(_ sender: Any) {
        let button = sender as! UIButton
        
        if button.isSelected == true
        {
            
            selectAllFlag = "Deselected"
            button.isSelected = false
            print("Deselected")
            btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            
            arrSelectedItem.removeAll()
            self.lblSelectAll.text = "Select All"
            tableViewDashboard.reloadData()
        }
        else
        {
            
            
            selectAllFlag = "Selected"
            button.isSelected = true
            print("Selected")
            btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: .normal)
            
            for i in 0..<jsonReload!["Data"].arrayValue.count {
                arrSelectedItem.append(i)
            }
            
            self.lblSelectAll.text = "Selected \(jsonReload!["Data"].arrayValue.count)"
            tableViewDashboard.reloadData()
        }
        for i in 0..<jsonReload!["Data"].arrayValue.count {
            if let labelList = jsonReload!["Data"][i]["LabelList"].array {
                for dic in labelList {
                    let dict = dic.dictionaryObject
                    if let lblid = dict!["LabelId"] as? Int {
                        
                        for labeldata in self.filtertedArray {
                            if lblid == labeldata.Id {
                                if arrSelectedItem.contains(i)
                                {
                                    labeldata.selected = true
                                    sellabelArr.append(labeldata)
                                    orgSellabelArr.append(labeldata)
                                    totSellabelArr.append(labeldata)
                                }
                                else {
                                    labeldata.selected = false
                                    if let index = sellabelArr.index(of: labeldata) {
                                        sellabelArr.remove(at: index)
                                        if let index1 = orgSellabelArr.index(of: labeldata) {
                                            orgSellabelArr.remove(at: index1)
                                        }
                                        if let index1 = totSellabelArr.index(of: labeldata) {
                                            totSellabelArr.remove(at: index1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    @IBAction func btnLogOutAction(_ sender: Any) {
        alertSampleWithLogin(strTitle: "", strMsg: "Do you want to logout?")
    }
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "segLanding", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if jsonReload == nil {
            let view: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
            view.textColor = UIColor.gray
            view.text = ""//"0 Document(s)"
            tableView.backgroundView = view
            
            return 0
        }
        tableView.backgroundView = nil
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return jsonReload!["Data"].arrayValue.count// == 0 ? 0 : jsonReload!["Data"].arrayValue
        if tableView == tableViewDashboard
        {
            if jsonReload == nil//"!["Data"].arrayValue.count == 0"
            {
                return 0
            }
            
            return jsonReload!["Data"].arrayValue.count//taskMgr.tasks.count
        }
        else if let alert = recipientAlert, let tblvw = alert.viewWithTag(4) as? UITableView, tblvw == tableView {
            
            return recipientArr.count
        }
        else {
            
            return filtertedArray.count
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let detailObj = jsonReload!["Data"][indexPath.row]
        let catType = detailObj["DashboardCategoryType"].intValue
        
        cell.backgroundColor = UIColor.clear
        
        if catType == 9 {
            //cell.backgroundColor = UIColor.lightGray
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableViewDashboard.dequeueReusableCell(withIdentifier: "mycell")
        
        if (cell == nil) {
            cell = UITableViewCell(style:UITableViewCell.CellStyle.default, reuseIdentifier:"mycell")
        }
        
        if tableView == tableViewDashboard
        {
            //cell = tableViewDashboard.dequeueReusableCell(withIdentifier: "mycell")
            
            
            
            let btnCheck: UIButton = cell?.viewWithTag(1) as! UIButton
            let lblName: UILabel = cell?.viewWithTag(2) as! UILabel
            let imgDoc: UIImageView = cell?.viewWithTag(3) as! UIImageView
            
            let btnArrow: UIButton = cell?.viewWithTag(5) as! UIButton
            btnArrow.accessibilityHint = "\(indexPath.row)"
            btnArrow.addTarget(self, action: #selector(detailAction), for: UIControl.Event.touchUpInside)
            
            // document specific
            if jsonReload!["Data"][indexPath.row]["IsBulkSend"] == false && jsonReload!["Data"][indexPath.row]["MainDocumentType"].intValue == 0
            {
                if jsonReload!["Data"][indexPath.row]["IsSendBack"] == true {
                    imgDoc.image = UIImage(named: "Document-Specific-Send-Back.png")
                } else {
                    imgDoc.image = UIImage(named: "doc_green.png")

                }
            }
            
            // dwf
            else if jsonReload!["Data"][indexPath.row]["IsBulkSend"] == false &&  jsonReload!["Data"][indexPath.row]["MainDocumentType"].intValue == 1
            {
                if jsonReload!["Data"][indexPath.row]["IsSendBack"] == true {
                    imgDoc.image = UIImage(named: "doc_green_bldg.png")
                } else {
                    imgDoc.image = UIImage(named: "doc_green_bldg.png")
                }
                
            }
                
            // document specific
            else if jsonReload!["Data"][indexPath.row]["IsBulkSend"] == true && jsonReload!["Data"][indexPath.row]["MainDocumentType"].intValue == 0
            {
                if jsonReload!["Data"][indexPath.row]["IsSendBack"] == true {
                    imgDoc.image = UIImage(named: "Bulk-send-Send-Back.png")
                } else {
                    imgDoc.image = UIImage(named: "bulk_send.png")
                }
            }
            
            // user specific
            else if jsonReload!["Data"][indexPath.row]["IsBulkSend"] == false &&  jsonReload!["Data"][indexPath.row]["MainDocumentType"].intValue == 2
            {
                if jsonReload!["Data"][indexPath.row]["IsSendBack"] == true {
                    imgDoc.image = UIImage(named: "User-Specific-Send-Back.png")
                } else {
                    imgDoc.image = UIImage(named: "doc_green_ppl.png")
                }
            }
                
            // dynamic templates
            else if jsonReload!["Data"][indexPath.row]["IsBulkSend"] == false && jsonReload!["Data"][indexPath.row]["MainDocumentType"].intValue == 4{
                if jsonReload!["Data"][indexPath.row]["IsSendBack"] == true {
                    imgDoc.image = UIImage(named: "Dyanmic-Template-Send-back.png")
                } else {
                    imgDoc.image = UIImage(named: "dynamic_template.png")
                }
            }
            
            let detailObj = jsonReload!["Data"][indexPath.row]
            let catType = detailObj["DashboardCategoryType"].intValue
            
            btnCheck.isEnabled = true
            lblName.textColor = UIColor.black
            
            if catType == 9 || catType == 10 {
                btnCheck.isEnabled = false
                lblName.textColor = UIColor.gray
            }
            
            var orgname: String = jsonReload!["Data"][indexPath.row]["Originator"].stringValue
            
            if jsonReload!["Data"][indexPath.row]["DashboardCategoryType"].intValue == 1 {
                orgname = jsonReload!["Data"][indexPath.row]["Originator"].stringValue
            }
            let strName: String = jsonReload!["Data"][indexPath.row]["InstanceId"].stringValue + "  " + jsonReload!["Data"][indexPath.row]["DocumentSet"].stringValue + " - " +  orgname
            
            lblName.text = strName
            btnCheck.accessibilityHint = String(indexPath.row)
            btnCheck.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
            
            
            
            ///
            if selectAllFlag == "Selected"
            {
                //btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: .normal)
                btnCheck.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: .normal)
                
            }
            else
            {
                //btnCheck.isSelected = false
                btnCheck.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
                //btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            }
            if arrSelectedItem.contains(indexPath.row)
            {
                btnCheck.isSelected = true
                btnCheck.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: .normal)
            }
            else
            {
                btnCheck.isSelected = false
                btnCheck.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            }
            
            
            
            if let labelList = jsonReload!["Data"][indexPath.row]["LabelList"].array {
                
                var labelArr:[String] = []
                var borderClrArr:[String] = []
                
                
                for dic in labelList {
                    
                    let dict = dic.dictionaryObject
                    
                    if let name = dict!["LabelName"] as? String, !name.isEmpty {
                        labelArr.append(name)
                    }
                    if let clr = dict!["LabelColor"] as? String {
                        borderClrArr.append(clr)
                    }
                    
                    
                }
                if labelArr.count > 0 {
                    let tagview = cell?.contentView.viewWithTag(10) as? TagListView
                    tagview?.removeAllTags()
                    if tagview?.tagViews.count == 0 {
                        tagview?.addTags(labelArr)
                    }
                    
                    var cnt = 0
                    for tagView in (tagview?.tagViews)! {
                        if cnt < borderClrArr.count {
                            tagView.borderColor = UIColor(hex: borderClrArr[cnt])
                            
                            let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.openDMSView))
                            
                            tagView.addGestureRecognizer(gesture)
                            
                        }
                        cnt = cnt + 1
                    }
                }
                else {
                    if let tagview = cell?.contentView.viewWithTag(10) as? TagListView {
                        if tagview.tagViews.count > 0 {
                            tagview.removeAllTags()
                        }
                    }
                }
            } else {
                if let tagview = cell?.contentView.viewWithTag(10) as? TagListView {
                    if tagview.tagViews.count > 0 {
                        tagview.removeAllTags()
                    }
                }
            }
            
            return cell!
        }
        else if recipientFlag, let tblvw = recipientAlert.viewWithTag(4) as? UITableView, tblvw == tableView {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
                cell = arr?[4] as? UITableViewCell
                
            }
            
            let name = recipientArr[indexPath.row]
            
            let title = cell?.viewWithTag(1) as! UILabel
            title.text = name
            
            
            let btn = cell?.viewWithTag(2) as! UIButton
            btn.accessibilityHint = String(indexPath.row)
            btn.addTarget(self, action: #selector(deleteRecipient(_:)), for: UIControl.Event.touchUpInside)
            
            if recipientArr.count == 1 {
                btn.isHidden = true
            }
            
            
            return cell!
            
        }
        else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
            
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[0] as? UITableViewCell)! as? LabelCell
                cell?.delegate = self
                
            }
            if indexPath.row < filtertedArray.count {
                
                let lbl = cell?.lblName//cell?.viewWithTag(2) as! UILabel
                
                let data = filtertedArray[indexPath.row]
                cell?.btnchk.tag = indexPath.row
                cell?.btnchk.isSelected = data.selected!
                
                if sellabelArr.contains(data) {
                    cell?.btnchk.isSelected = true
                } else {
                    cell?.btnchk.isSelected = false
                }
                lbl?.text = data.Name
                
            } else if indexPath.row == filtertedArray.count {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[1] as? UITableViewCell)! as? LabelCell
                
                
            } else if indexPath.row == filtertedArray.count + 1 {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[1] as? UITableViewCell)! as? LabelCell
                
                
            } else if indexPath.row == filtertedArray.count + 2 {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[1] as? UITableViewCell)! as? LabelCell
                
            }
            
            if indexPath.row < filtertedArray.count {
                
            } else if indexPath.row == filtertedArray.count {
                
                let btnSub = cell?.contentView.viewWithTag(10) as! UIButton
                btnSub.setTitle("Apply Changes", for: UIControl.State.normal)
                
            } else if indexPath.row == filtertedArray.count + 1 {
                
                let btnSub = cell?.contentView.viewWithTag(10) as! UIButton
                btnSub.setTitle("Create New", for: UIControl.State.normal)
                
            } else if indexPath.row == filtertedArray.count + 2 {
                
                let btnSub = cell?.contentView.viewWithTag(10) as! UIButton
                btnSub.setTitle("Manage Labels", for: UIControl.State.normal)
                
            }
            return cell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tableViewDashboard {
            
            if FeatureMatrix.shared.sign_reject {
                
                let data = jsonReload!["Data"].arrayObject
                
                let detailObj = data?[(tableViewDashboard.indexPathForSelectedRow?.row)!] as? [String : Any]
                let workflowsourceCategory = Int(truncating: detailObj!["WorkflowSourceCategory"] as! NSNumber)
                let dashboardcategoryType = Int(truncating: detailObj!["DashboardCategoryType"] as! NSNumber)
                let maindocuentType = Int(truncating: detailObj!["MainDocumentType"] as! NSNumber)
                let issendback = detailObj!["IsSendBack"] as! Bool
                
                if selCategory == 90 {
                    
                    switch workflowsourceCategory {
                    case 2:
                        print("self signed")
                        return
                    case 3:
                        switch dashboardcategoryType {
                        case 9,10:
                            return
                        default:
                            let documentviewController = DocumentViewController()
                            documentviewController.documentName = detailObj!["DocumentSet"] as? String
                            documentviewController.documentinstanceId = String(detailObj!["InstanceId"] as! Int)
                            self.navigationController?.pushViewController(documentviewController, animated: true)
                            return
                        }
                    default:
                        switch maindocuentType {
                        case 1:
                            print("dwf")
                            alertSample(strTitle: "Unable to View DWF Documents!", strMsg: "Unabele to view DWF documents, please use IE Browser")
                            return
                        case 2:
                            print("user specific")
                            alertSample(strTitle: "User Specific Workflow!", strMsg: "Documents that use the user specific workflow are currently not supported the mobile app. Please sign them by logging into your account using your desktop / laptop. Please always use the latest version of the app as this feature will be added soon.")
                            return
                        default:
                            if issendback {
                                alertSample(strTitle: "Send Back!", strMsg: "Attention:  Send Back feature is not currently supported on mobile app.  Please login to ZorroSign via a browser and sign your document set.")
                                return
                            }
                            self.showActivityIndicatory(uiView: self.view)
                            updateSignatures { (success) in
                                self.updateStamp(completion: { (success) in
                                    self.stopActivityIndicator()
                                    if success {
                                        let documentsignController = DocumentSignController()
                                        documentsignController.documentinstanceId = String(detailObj!["InstanceId"] as! Int)
                                        documentsignController.documentName = detailObj!["DocumentSet"] as? String
                                        self.navigationController?.pushViewController(documentsignController, animated: true)
                                        return
                                    }
                                    return
                                    
                                })
                            }
                            return
                        }
                    }
                }
                
                if selCategory == 91 || selCategory == 92 || selCategory == 93 {
                    
                    switch maindocuentType {
                    case 1:
                        alertSample(strTitle: "Unable to View DWF Documents !", strMsg: "Unabele to view DWF documents, please use IE Browser")
                        return
                    default:
                        switch dashboardcategoryType {
                        case 9,10:
                            return
                        default:
                            let detailObj = data?[(tableViewDashboard.indexPathForSelectedRow?.row)!] as? [String : Any]
                            let documentviewController = DocumentViewController()
                            documentviewController.documentName = detailObj!["DocumentSet"] as? String
                            documentviewController.documentinstanceId = String(detailObj!["InstanceId"] as! Int)
                            self.navigationController?.pushViewController(documentviewController, animated: true)
                            return
                        }
                    }
                }
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let tablevw = labelAlertView.viewWithTag(4) as! UITableView
        if tableView == tablevw {
            let data = filtertedArray[indexPath.row]
            let name = data.Name!
            let docId:String = String(data.Id!)
            searchTxt = searchTxt.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
            if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) && !docId.lowercased().contains(searchTxt.lowercased()) {
                return 0
            }
            else if name == "Archive" {
                return 0
            }
        }
        
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detailsVC" {
            let navc = segue.destination as! UINavigationController
            if #available(iOS 11.0, *) {
                let detailsVC = navc.viewControllers[0] as! DetailsVC
                
                let data = jsonReload!["Data"].arrayObject
                detailsVC.detailObject = data?[(tableViewDashboard.indexPathForSelectedRow?.row)!] as? [String : Any]
                detailsVC.selOption = selComplete
                detailsVC.selReject = selReject
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    @objc func detailAction(sender: UIButton) {
        
        let tag = Int(sender.accessibilityHint!)
        //self.selCategory
        //esign - 90
        //in process - 92
        //completed - 91
        //rejected - 93
        if #available(iOS 11.0, *) {
            let detailsVC = self.getVC(sbId: "detailsVC") as! DetailsVC
            
            let data = jsonReload!["Data"].arrayObject
            
            let detailObj = data?[tag!] as? [String : Any]
            
            let catType = detailObj!["DashboardCategoryType"] as! NSNumber
            if catType != 9 && catType != 10 {
                detailsVC.detailObject = data?[tag!] as? [String : Any]
                detailsVC.selCategory = self.selCategory
                detailsVC.selOption = selComplete
                detailsVC.selReject = selReject
                self.navigationController?.pushViewController(detailsVC, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func buttonClicked(sender: UIButton) {
        
        let ip: Int = Int(sender.accessibilityHint!)!
        
        sender.isSelected = !sender.isSelected
        
        let o = sender.convert(sender.bounds.origin, to: tableViewDashboard)
        //let ip: Int = (tableViewDashboard.indexPathForRow(at: o)?.row)!
        let btnCheckBox: UIButton = (tableViewDashboard.cellForRow(at: IndexPath(row: (ip), section: 0))?.viewWithTag(1) as? UIButton)!
        
        //btnCheckBox.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: .normal)
        
        if arrSelectedItem.contains(ip)
        {
            print("Yes")
            if let index = arrSelectedItem.index(of: ip) {
                arrSelectedItem.remove(at: index)
                btnCheckBox.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: UIControl.State.normal)
                
                selectAllFlag = "Deselected"
                btnSelectAll.isSelected = false
                print("Deselected")
                btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
                
                self.lblSelectAll.text = "Select All"
            }
        }
        else
        {
            print("No")
            arrSelectedItem.append(ip)
            btnCheckBox.setImage(Singletone.shareInstance.dashboardCheckboxSelect, for: UIControl.State.normal)
        }
        
        if arrSelectedItem.count > 0 {
            self.lblSelectAll.text = "Selected \(arrSelectedItem.count)"
        } else {
            self.lblSelectAll.text = "Select All"
        }
        
        //sellabelArr.removeAll()
        
        let hint:Int = Int(sender.accessibilityHint!)!
        
        //for i in 0..<jsonReload!["Data"].arrayValue.count {
        //if i == ip {
        if let labelList = jsonReload!["Data"][ip]["LabelList"].array {
            for dic in labelList {
                let dict = dic.dictionaryObject
                if let lblid = dict!["LabelId"] as? Int {
                    
                    for labeldata in self.filtertedArray {
                        if lblid == labeldata.Id {
                            if arrSelectedItem.contains(ip)
                            {
                                if sender.isSelected {
                                    labeldata.selected = true
                                    sellabelArr.append(labeldata)
                                    orgSellabelArr.append(labeldata)
                                    totSellabelArr.append(labeldata)
                                }
                            }
                            else {
                                if !sender.isSelected {
                                    labeldata.selected = false
                                    if let index = sellabelArr.index(of: labeldata) {
                                        sellabelArr.remove(at: index)
                                        if let index1 = orgSellabelArr.index(of: labeldata) {
                                            orgSellabelArr.remove(at: index1)
                                        }
                                        if let index1 = totSellabelArr.index(of: labeldata) {
                                            totSellabelArr.remove(at: index1)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        //}
        //}
        tableViewDashboard.reloadData()
        
    }
    
    @objc func checkActionSearch(sender : UITapGestureRecognizer)
    {
        //UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        if UserDefaults.standard.string(forKey: "MicORArrow") == "mic"
        {
            ///START RECORDING
            if audioEngin.isRunning {
                audioEngin.stop()
                recognizationRequest?.endAudio()
                //btnRecord.isEnabled = false
                //btnRecord.setTitle("Start Recording", for: .normal)
                viewSearchAction.isUserInteractionEnabled = false
            }
            else {
                startRecording()
                //btnRecord.setTitle("Stop Recording", for: .normal)
            }
            
            ///END RECORDING
        }
        else
        {
            print("tap on search")
            if txtSearchText.text != ""
            {
                //imgSearchMic.image = UIImage(named: "white_arw")
                Singletone.shareInstance.showActivityIndicatory(uiView: view)
                let str: String = txtSearchText.text!.stringByAddingPercentEncodingForRFC3986()!
                
                
                let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
                let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
                
                var api = "v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=\(esCount)&orderBy=9&isAscending=true&labelId=-1&searchText=\(str)"
                var url = Singletone.shareInstance.apiUserService + api
                //"https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=\(esCount)&orderBy=9&isAscending=true&labelId=-1&searchText=\(str)"
                //url = url.stringByAddingPercentEncodingForRFC3986()!
                print("url: \(url)")
                if Connectivity.isConnectedToInternet() == true
                {
                    Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("2. EList")
                            print(jsonObj)
                            self.jsonReload = jsonObj
                            self.tableViewDashboard.reloadData()
                            self.jsonEsign = jsonObj
                            if jsonObj["StatusCode"] == 1000
                            {
                                self.view.endEditing(true)
                                Singletone.shareInstance.stopActivityIndicator()
                                self.imgSearchMic.image = UIImage(named: "mic_white_icon")
                                self.resetPlaceholder()
                                //self.txtSearchText.placeholder = "Search in Inbox"
                                //self.txtSearchText.text = ""
                                UserDefaults.standard.set("mic", forKey: "MicORArrow")
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                    }
                    //3.
                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                    var api = "v1/dashboard/GetDetailsForCategory?type=1&startIndex=0&pageSize=\(esCount)&orderBy=5&isAscending=false&labelId=-1&searchText=\(str)"
                    
                    url = Singletone.shareInstance.apiUserService + api
                    //"https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=1&startIndex=0&pageSize=\(esCount)&orderBy=5&isAscending=false&labelId=-1&searchText=\(str)"
                    //url = url.stringByAddingPercentEncodingForRFC3986()!
                    
                    Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("3. In Process")
                            print(jsonObj)
                            self.jsonInProcess = jsonObj
                            
                            if self.selCategory == 92 {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                if let labelList = jsonObj["Data"]["LabelList"].arrayObject {
                                    
                                }
                            }
                            else
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                    }
                    //4.
                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                    
                    api = "v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=\(esCount)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    
                    url = Singletone.shareInstance.apiUserService + api
                    
                    //"https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=\(esCount)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //url = url.stringByAddingPercentEncodingForRFC3986()!
                    
                    Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("4. Completed")
                            print(jsonObj)
                            self.jsonCompleted = jsonObj
                            if self.selCategory == 91 {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                if let labelList = jsonObj["Data"]["LabelList"].arrayObject {
                                    
                                }
                            }
                            else
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                    }
                    //5.
                    //Singletone.shareInstance.showActivityIndicatory(uiView: view)
                    
                    api = "v1/dashboard/GetDetailsForCategory?type=3&startIndex=0&pageSize=\(esCount)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    
                    url = Singletone.shareInstance.apiUserService + api
                    //url = "https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=3&startIndex=0&pageSize=\(esCount)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //url = url.stringByAddingPercentEncodingForRFC3986()!
                    
                    Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("5. Rejected")
                            print(jsonObj)
                            self.jsonRejected = jsonObj
                            if self.selCategory == 93 {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            }
                    }
                    
                    let sharedCnt: Int = self.cntCompleteDic["Shared To Me"]!
                    // shared docs
                    api = "v1/dashboard/GetDetailsForCategory?type=7&startIndex=0&pageSize=\(sharedCnt)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //api = "v1/dashboard/GetDetailsForCategory?type=7&startIndex=0&pageSize=\(jsonObj["Data"]["Completed"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                    var apiURL = Singletone.shareInstance.apiUserService + api
                    
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("6. Shared")
                            print(jsonObj)
                            self.jsonShared = jsonObj
                            if self.selComplete == "Shared To Me" {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.isHidden = false
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                            }
                    }
                    
                    // scanned docs
                    let scanned: Int = self.cntCompleteDic["Scanned Token"]!
                    api = "v1/dashboard/GetDetailsForCategory?type=8&startIndex=0&pageSize=\(scanned)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //api = "v1/dashboard/GetDetailsForCategory?type=8&startIndex=0&pageSize=\(self.cntCompleteDic["Scanned Token"])&orderBy=6&isAscending=false&labelId=-1"
                    apiURL = Singletone.shareInstance.apiUserService + api
                    
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("7. Scanned")
                            print(jsonObj)
                            self.jsonScanned = jsonObj
                            if self.selComplete == "Scanned Token" {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.isHidden = false
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                            }
                    }
                    
                    // expired docs
                    let expired: Int = self.cntRejectDic["Expired"]!
                    api = "v1/dashboard/GetDetailsForCategory?type=5&startIndex=0&pageSize=\(expired)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //api = "v1/dashboard/GetDetailsForCategory?type=5&startIndex=0&pageSize=\(self.cntCompleteDic["Rejected"])&orderBy=6&isAscending=false&labelId=-1"
                    apiURL = Singletone.shareInstance.apiUserService + api
                    
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("7. Expired")
                            print(jsonObj)
                            self.jsonExpired = jsonObj
                            if self.selReject == "Expired" {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.isHidden = false
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                            }
                    }
                    
                    // Cancelled docs
                    let cancelled: Int = self.cntRejectDic["Cancelled"]!
                    api = "v1/dashboard/GetDetailsForCategory?type=6&startIndex=0&pageSize=\(cancelled)&orderBy=6&isAscending=false&labelId=-1&searchText=\(str)"
                    //api = "v1/dashboard/GetDetailsForCategory?type=6&startIndex=0&pageSize=\(jsonObj["Data"]["Rejected"].intValue)&orderBy=6&isAscending=false&labelId=-1"
                    apiURL = Singletone.shareInstance.apiUserService + api
                    
                    Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                        .responseJSON { response in
                            
                            let jsonObj: JSON = JSON(response.result.value!)
                            print("7. Cancelled")
                            print(jsonObj)
                            self.jsonCancelled = jsonObj
                            if self.selReject == "Cancelled" {
                                self.jsonReload = jsonObj
                            }
                            DispatchQueue.main.async {
                                self.tableViewDashboard.isHidden = false
                                self.tableViewDashboard.reloadData()
                            }
                            if jsonObj["StatusCode"] == 1000
                            {
                                //Singletone.shareInstance.stopActivityIndicator()
                            }
                            else
                            {
                                Singletone.shareInstance.stopActivityIndicator()
                            }
                    }
                    
                    
                }
                else
                {
                    alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
                }
                
            }
            else
            {
                view.endEditing(true)
                self.imgSearchMic.image = UIImage(named: "mic_white_icon")
                jsonReload = jsonSearchNil
                self.tableViewDashboard.reloadData()
            }
        }
    }
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        print(s!)
        
        switch s! {
        case 100:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
//            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")  //dashboard_white_bottom_bar_icon
//            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")  //launch_white_bottom_bar_icon
//            imgSearch.image = UIImage(named: "search_green_icon")  //search_white_icon
//            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")  //landing_screen_signup_icon
//            imgHelp.image = UIImage(named: "help_green_icon")  //help_white_icon
            
            imgDashboard.tintColor = selectedColorCOntent
            imgSearch.tintColor = unSelectedColorContent
            imgMyAccount.tintColor = unSelectedColorContent
            imgHelp.tintColor = unSelectedColorContent
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            viewBottomSearch.isUserInteractionEnabled = true
            viewBottomSearch.backgroundColor = UIColor.white//Singletone.shareInstance.footerviewBackgroundGreen.withAlphaComponent(0.1)
            
            
            
            break
        case 101:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
//            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
//            //imgStart.image = UIImage(named: "launch_white_bottom_bar_icon")
//            imgSearch.image = UIImage(named: "search_green_icon")
//            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
//            imgHelp.image = UIImage(named: "help_green_icon")
            
            imgDashboard.tintColor = unSelectedColorContent
            imgSearch.tintColor = unSelectedColorContent
            imgMyAccount.tintColor = unSelectedColorContent
            imgHelp.tintColor = unSelectedColorContent
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen.withAlphaComponent(0.1)
            viewBottomSearch.isUserInteractionEnabled = false
            
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            
            break
        case 102:
            if FeatureMatrix.shared.search_doc {
                viewSearchBar.isHidden = false
                
                viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
                //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
                viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
                viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
                btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
                
                //            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
                //            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
                //            imgSearch.image = UIImage(named: "search_white_icon")
                //            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
                //            imgHelp.image = UIImage(named: "help_green_icon")
                
                imgDashboard.tintColor = unSelectedColorContent
                imgSearch.tintColor = selectedColorCOntent
                imgMyAccount.tintColor = unSelectedColorContent
                imgHelp.tintColor = unSelectedColorContent
                
                lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
                //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
                lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundWhite
                lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
                lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
                
                UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
                
                //            let strImageName: String = (imgSearchMic.image?.accessibilityIdentifier)!
                //            print(strImageName)
                //            print("**")
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
            
            
            break
        case 103:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
//            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
//            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
//            imgSearch.image = UIImage(named: "search_green_icon")
//            imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
//            imgHelp.image = UIImage(named: "help_green_icon")
            
            imgDashboard.tintColor = unSelectedColorContent
            imgSearch.tintColor = unSelectedColorContent
            imgMyAccount.tintColor = selectedColorCOntent
            imgHelp.tintColor = unSelectedColorContent
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            performSegue(withIdentifier: "segMyAccount", sender: self)
            
            break
        case 104:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
//            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
//            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
//            imgSearch.image = UIImage(named: "search_green_icon")
//            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
//            imgHelp.image = UIImage(named: "help_white_icon")
            
            imgDashboard.tintColor = unSelectedColorContent
            imgSearch.tintColor = selectedColorCOntent
            imgMyAccount.tintColor = unSelectedColorContent
            imgHelp.tintColor = selectedColorCOntent
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            performSegue(withIdentifier: "segContactUs", sender: self)
            break
        default:
            break
        }
    }
    
    @objc func checkActionTop(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        selCategory = s!
        print(s!)
        //viewRI viewCI  viewIPI  viewREI
        
        selectAllFlag = "Deselected"
        btnSelectAll.isSelected = false
        print("Deselected")
        btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
        
        arrSelectedItem.removeAll()
        sellabelArr.removeAll()
        
        self.lblSelectAll.text = "Select All"
        
        switch s! {
        case 90:
            viewActionWidth.constant = 0
            viewRI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewCI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewIPI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewREI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            
            //lblRT lblCT lblIPT lblRET
            //lblEsign lblComplete lblInProcess lblInProcess
            
            lblRT.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblCT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblIPT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRET.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            lblEsign.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblComplete.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblInProcess.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRejected.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            
            if startDate != nil && endDate != nil {
                callAPI()
            }
            else {
                jsonReload = jsonEsign
                tableViewDashboard.reloadData()
            }
            txtSearchText.placeholder = "Search in Inbox"
            
            break
        case 91:
            viewActionWidth.constant = 0
            viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewCI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewIPI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewREI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            
            lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblCT.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblIPT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRET.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblComplete.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblInProcess.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRejected.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            txtSearchText.placeholder = "Search in Completed"
            
            if startDate != nil && endDate != nil {
                callAPI()
            }
            else if self.selComplete == "Shared To Me" {
                jsonReload = jsonShared
                txtSearchText.placeholder = "Search in Shared To Me"
            }
            else if self.selComplete == "Scanned Token" {
                jsonReload = jsonScanned
                txtSearchText.placeholder = "Search in Scanned Token"
            }
            else {
                jsonReload = jsonCompleted
            }
            
            tableViewDashboard.reloadData()
            
            
            break
        case 92:
            viewActionWidth.constant = 0
            viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewCI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewIPI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewREI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            
            lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblCT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblIPT.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblRET.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblComplete.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblInProcess.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblRejected.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            if startDate != nil && endDate != nil {
                callAPI()
            }
            else {
                jsonReload = jsonInProcess
                tableViewDashboard.reloadData()
            }
            
            txtSearchText.placeholder = "Search in In Process"
            
            break
        case 93:
            viewActionWidth.constant = 0
            viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewCI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewIPI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            viewREI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblCT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblIPT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRET.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblComplete.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblInProcess.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            lblRejected.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            txtSearchText.placeholder = "Search in Rejected"
            
            if startDate != nil && endDate != nil {
                callAPI()
            }
            else if self.selReject == "Expired" {
                jsonReload = jsonExpired
                txtSearchText.placeholder = "Search in Expired"
            }
            else if self.selReject == "Cancelled" {
                jsonReload = jsonCancelled
                txtSearchText.placeholder = "Search in Cancelled"
            }
            else {
                jsonReload = jsonRejected
            }
            
            tableViewDashboard.reloadData()
            
            
            break
        default:
            break
        }
    }
    
    func callFilterAPI() {
        
        //type=2&startIndex=0&pageSize=10&orderBy=6&isAscending=false&labelId=-1&startDateFrom=11/01/2018&startDateTo=12/31/2018&endDateFrom=11/01/2018&endDateTo=12/31/2018
        
        self.showActivityIndicatory(uiView: self.view)
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        var stdt = ""
        if startDate != nil {
            stdt = dateToString(date: startDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "yyyy-MM-dd'T'HH:mm:ss")
        }
        var enddt = ""
        if endDate != nil {
            enddt = dateToString(date: endDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "yyyy-MM-dd'T'HH:mm:ss")
        }
        
        var stdt1 = ""
        if startDate1 != nil {
            stdt1 = dateToString(date: startDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "yyyy-MM-dd'T'HH:mm:ss")
        }
        var enddt1 = ""
        if endDate1 != nil {
            enddt1 = dateToString(date: endDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "yyyy-MM-dd'T'HH:mm:ss")
        }
        var pagesize = self.cntjsonObj!["Data"]["Completed"].intValue
        
        var dateStr = ""
        
        if !stdt.isEmpty && !enddt.isEmpty {
            dateStr = "&startDateFrom=\(stdt)&startDateTo=\(enddt)"
        }
        if !stdt1.isEmpty && !enddt1.isEmpty {
            dateStr.append("&endDateFrom=\(stdt1)&endDateTo=\(enddt1)")
        }
        
        if self.selCategory == 90 {
            pagesize = self.cntjsonObj!["Data"]["Esign"].intValue
            
            let api = "v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=\(pagesize)&orderBy=9&isAscending=true&labelId=-1\(dateStr)"
            let apiURL = Singletone.shareInstance.apiUserService + api
            
            print("filter API: \(apiURL)")
            //"https://zsdemowebworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=0&startIndex=0&pageSize=\(pagesize)&orderBy=9&isAscending=true&labelId=-1\(dateStr)"
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    print("2. EList")
                    print(jsonObj)
                    
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        
                        self.jsonEsign = jsonObj
                        self.jsonReload = jsonObj
                        self.jsonSearchNil = jsonObj
                        self.tableViewDashboard.reloadData()
                        
                    }
                    else
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        //3.
        //Singletone.shareInstance.showActivityIndicatory(uiView: view)
        if self.selCategory == 92 {
            pagesize = self.cntjsonObj!["Data"]["Pending"].intValue
            
            let api = "v1/dashboard/GetDetailsForCategory?type=1&startIndex=0&pageSize=\(pagesize)&orderBy=5&isAscending=false&labelId=-1\(dateStr)"
            let apiURL = Singletone.shareInstance.apiUserService + api
            
            print("filter API: \(apiURL)")
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    print("3. In Process")
                    print(jsonObj)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        
                        self.jsonInProcess = jsonObj
                        self.jsonReload = jsonObj
                        self.jsonSearchNil = jsonObj
                        self.tableViewDashboard.reloadData()
                        
                    }
                    else
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        //4.
        //Singletone.shareInstance.showActivityIndicatory(uiView: view)
        if self.selCategory == 91 {
            
            //https://webworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=10&orderBy=6&isAscending=false&labelId=-1&startDateFrom=02/05/2019&startDateTo=02/10/2019&endDateFrom=02/10/2019&endDateTo=02/20/2019
            
            //https://webworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=0&orderBy=6&isAscending=false&labelId=-1&startDateFrom=2019-02-05T14:15:51&startDateTo=2019-02-10T14:15:51&endDateFrom=2019-02-10T14:15:51&endDateTo=2019-02-20T14:15:51
            
            pagesize = self.cntjsonObj!["Data"]["Completed"].intValue
            var type = 2
            if self.selComplete == "Shared To Me" {
                type = 7
            } else if self.selComplete == "Scanned Token" {
                type = 8
            }
            
            let api = "v1/dashboard/GetDetailsForCategory?type=\(type)&startIndex=0&pageSize=\(pagesize)&orderBy=6&isAscending=false&labelId=-1\(dateStr)"
            let apiURL = Singletone.shareInstance.apiUserService + api
            
            print("filter API: \(apiURL)")
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    print("4. Completed")
                    print(jsonObj)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        
                        self.jsonCompleted = jsonObj
                        self.jsonReload = jsonObj
                        self.jsonSearchNil = jsonObj
                        self.tableViewDashboard.reloadData()
                        
                        
                    }
                    else
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        //5.
        //Singletone.shareInstance.showActivityIndicatory(uiView: view)
        if self.selCategory == 93 {
            
            pagesize = self.cntjsonObj!["Data"]["Rejected"].intValue
            
            var type = 3
            if self.selReject == "Expired" {
                type = 5
            } else if self.selReject == "Cancelled" {
                type = 6
            }
            
            let api = "v1/dashboard/GetDetailsForCategory?type=\(type)&startIndex=0&pageSize=\(pagesize)&orderBy=6&isAscending=false&labelId=-1\(dateStr)"
            let apiURL = Singletone.shareInstance.apiUserService + api
            
            print("filter API: \(apiURL)")
            
            //https://webworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=10&orderBy=6&isAscending=false&labelId=-1&endDateFrom=02/05/2019&endDateTo=02/10/2019
            //https://webworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=2&startIndex=0&pageSize=0&orderBy=6&isAscending=false&labelId=-1&startDateFrom=2019-02-05T13:45:16&startDateTo=2019-02-10T13:45:16
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    print("5. Rejected")
                    print(jsonObj)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        
                        self.jsonRejected = jsonObj
                        self.jsonReload = jsonObj
                        self.jsonSearchNil = jsonObj
                        self.tableViewDashboard.reloadData()
                        
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        
        if FeatureMatrix.shared.filtering {
            
            // Initialize with a custom view
            if selCategory == 91 {
                
                filterDatesAlertView = SwiftAlertView(nibName: "FilterDatesAlert", delegate: self, cancelButtonTitle: "CLEAR", otherButtonTitles: ["APPLY"])
                
                let btnclose = filterDatesAlertView.buttonAtIndex(index: 0)
                let btnsend = filterDatesAlertView.buttonAtIndex(index: 1)
                
                btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
                
                btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
                btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
                
                let view1 = filterDatesAlertView.viewWithTag(3)
                let view2 = filterDatesAlertView.viewWithTag(4)
                let lbl1 = filterDatesAlertView.viewWithTag(5) as! UILabel
                let lbl2 = filterDatesAlertView.viewWithTag(6) as! UILabel
                
                view1?.isHidden = true
                view2?.isHidden = true
                lbl2.isHidden = true
                
                let segBtn = filterDatesAlertView.viewWithTag(14) as? UISegmentedControl
                //segBtn?.addTarget(self, action: #selector(segBtnAction), for: UIControlEvents.touchUpInside)
                segBtn?.addTarget(self, action: #selector(segBtnAction), for: UIControl.Event.valueChanged)
                
                let fromdt = filterDatesAlertView.viewWithTag(10) as? UITextField
                fromdt?.delegate = self
                
                let todt = filterDatesAlertView.viewWithTag(11) as? UITextField
                todt?.delegate = self
                
                let fromdt1 = filterDatesAlertView.viewWithTag(12) as? UITextField
                fromdt1?.delegate = self
                
                let todt1 = filterDatesAlertView.viewWithTag(13) as? UITextField
                todt1?.delegate = self
                
                filterDatesAlertView.tag = 16
                filterDatesAlertView.show()
                
            } else {
                filterAlertView = SwiftAlertView(nibName: "FilterAlert", delegate: self, cancelButtonTitle: "CLEAR", otherButtonTitles: ["APPLY"])
                
                let fromdt = filterAlertView.viewWithTag(10) as? UITextField
                fromdt?.delegate = self
                
                let todt = filterAlertView.viewWithTag(11) as? UITextField
                todt?.delegate = self
                
                
                let btnclose = filterAlertView.buttonAtIndex(index: 0)
                let btnsend = filterAlertView.buttonAtIndex(index: 1)
                
                btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
                
                btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
                btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
                
                filterAlertView.tag = 17
                filterAlertView.show()
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    @IBAction func segBtnAction(segment: UISegmentedControl) {
        
        let lblArr = ["START DATE","COMPLETED DATE"]
        
        selectedSegmentIndex = segment.selectedSegmentIndex
        
        let view1 = filterDatesAlertView.viewWithTag(3)
        let view2 = filterDatesAlertView.viewWithTag(4)
        let lbl1 = filterDatesAlertView.viewWithTag(5) as! UILabel
        let lbl2 = filterDatesAlertView.viewWithTag(6) as! UILabel
        
        if segment.selectedSegmentIndex == 0 || segment.selectedSegmentIndex == 1 {
            view1?.isHidden = true
            view2?.isHidden = true
            lbl2.isHidden = true
            
            lbl1.text = lblArr[segment.selectedSegmentIndex]
            
        } else {
            view1?.isHidden = false
            view2?.isHidden = false
            lbl2.isHidden = false
            
            lbl1.text = lblArr[0]
            lbl2.text = lblArr[1]
        }
        
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        
        if selCategory == 91 {
            if alertView.tag == 10 {
                if selectedSegmentIndex == 1 {
                    startDate1 = datepicker.date
                    let fromdt = filterDatesAlertView.viewWithTag(10) as? UITextField
                    fromdt?.text = dateToString(date: startDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                } else {
                    startDate = datepicker.date
                    let fromdt = filterDatesAlertView.viewWithTag(10) as? UITextField
                    fromdt?.text = dateToString(date: startDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                }
                
            }
            if alertView.tag == 11 {
                if selectedSegmentIndex == 1 {
                    endDate1 = datepicker.date
                    let todt = filterDatesAlertView.viewWithTag(11) as? UITextField
                    todt?.text = dateToString(date: endDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                } else {
                    endDate = datepicker.date
                    let todt = filterDatesAlertView.viewWithTag(11) as? UITextField
                    todt?.text = dateToString(date: endDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                }
                
            }
            if alertView.tag == 12 {
                startDate1 = datepicker.date
                let fromdt = filterDatesAlertView.viewWithTag(12) as? UITextField
                fromdt?.text = dateToString(date: startDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
            }
            if alertView.tag == 13 {
                endDate1 = datepicker.date
                let todt = filterDatesAlertView.viewWithTag(13) as? UITextField
                todt?.text = dateToString(date: endDate1!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
            }
            
            alertView.dismiss()
            
        } else {
            if alertView.tag == 10 {
                startDate = datepicker.date
                let fromdt = filterAlertView.viewWithTag(10) as? UITextField
                fromdt?.text = dateToString(date: startDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                
                alertView.dismiss()
            }
            if alertView.tag == 11 {
                endDate = datepicker.date
                let todt = filterAlertView.viewWithTag(11) as? UITextField
                todt?.text = dateToString(date: endDate!, dtFormat: "yyyy-MM-dd HH:mm:ss", strFormat: "MM/dd/yyyy")
                
                alertView.dismiss()
            }
            
            
        }
        print("start:\(startDate)")
        print("end:\(endDate)")
        
        if alertView.tag == 17 {
            
            if buttonIndex == 0 {
                startDate = nil
                endDate = nil
            }
            callFilterAPI()
            
            alertView.dismiss()
        }
        
        if alertView.tag == 16 {
            
            if buttonIndex == 0 {
                startDate = nil
                endDate = nil
                startDate1 = nil
                endDate1 = nil
            }
            callFilterAPI()
            
            alertView.dismiss()
        }
        
        if alertView.tag == 14 {
            
            if sellabelArr.count > 0 && arrSelectedItem.count == 0 {
                //alertSample(strTitle: "", strMsg: "Please select documents to add to label")
            } else {
                //addLabelsToDocs()
            }
            alertView.dismiss()
        }
        
        if alertView.tag == 44 {
            
            if buttonIndex == 0 {
                arrSelectedItem.removeAll()
                self.lblSelectAll.text = "Select All"
                self.tableViewDashboard.reloadData()
            }
            if buttonIndex == 1 {
                
                let txtsubject =  sendEmailAlert.viewWithTag(2) as! UITextField
                let txtmsg =  sendEmailAlert.viewWithTag(3) as! UITextView
                
                let errsub = sendEmailAlert.viewWithTag(5) as! UILabel
                let errmsg = sendEmailAlert.viewWithTag(6) as! UILabel
                
                if (txtsubject.text?.isEmpty)! {
                    let err = "Please enter subject"
                    errsub.text = err
                    
                } else if txtmsg.text.isEmpty {
                    let err = "Please enter message"
                    errmsg.text = err
                    
                } else {
                    let errsub = sendEmailAlert.viewWithTag(5) as! UILabel
                    let errmsg = sendEmailAlert.viewWithTag(6) as! UILabel
                    
                    errsub.text = ""
                    errmsg.text = ""
                    
                    alertView.dismiss()
                    sendDashboardEmail()
                    
                }
            }
        }
        
        //alertView.dismiss()
    }
    override func didDismissAlertView(alertView: SwiftAlertView) {
        
    }
    
    @IBAction func actionClear(_ sender: Any) {
        
        viewSearchBar.isHidden = true
        txtSearchText.text = ""
        
        imgSearchMic.image = UIImage(named: "mic_white_icon")
        UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        callAPI()
    }
    
    func initLabelAlert() {
        
        labelAlertView = SwiftAlertView(nibName: "LabelPopup", delegate: self, cancelButtonTitle: "CLOSE", otherButtonTitles: nil)
        //"Apply Changes"
        labelAlertView.tag = 14
        let tablevw = labelAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        
        tablevw.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tablevw.frame.size.width, height: 1))
        
        let txtfld = labelAlertView.viewWithTag(2) as! UITextField
        txtfld.delegate = self
        
        var btnapply = labelAlertView.viewWithTag(10) as? UIButton
        
        btnapply?.addTarget(self, action: #selector(addLabelsToDocs), for: UIControl.Event.touchUpInside)
        
        let btnmanage = labelAlertView.viewWithTag(11) as? UIButton
        btnmanage?.addTarget(self, action: #selector(manageLabelsAction), for: UIControl.Event.touchUpInside)
        
        
        
        let btnclose = labelAlertView.buttonAtIndex(index: 0)
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
    }
    @IBAction func labelAction(_ sender: Any) {
        
        if arrSelectedItem.count == 0 {
            sellabelArr.removeAll()
            
        }
        initLabelAlert()
        labelAlertView.show()
        //callLabelAPI()
        //tablevw.reloadData()
    }
    
    @IBAction func multiSignAction() {
        
        if arrSelectedItem.count > 0 {
            var arrIds: [Int] = []
            for id in arrSelectedItem {
                arrIds.append(jsonReload!["Data"][id]["InstanceId"].intValue)
            }
            if #available(iOS 11.0, *) {
                let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
                docSignVC.docIdArr = arrIds
                docSignVC.multiSign = true
                self.navigationController?.pushViewController(docSignVC, animated: true)
            }
            
        } else {
            
        }
    }
    
    func callLabelAPI() {
        
        self.filtertedArray = []
        self.labelArr = []
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/label/getlabels?labelCategory=1"
        let apiURL = Singletone.shareInstance.apiUserService + api
        //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/getlabels?labelCategory=1"
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            let data = jsonObj["Data"].array
                            var parentIdArr:[Int] = []
                            
                            for dic in data! {
                                
                                let labeldata = LabelData(dictionary: dic.dictionaryObject!)
                                self.labelArr.append(labeldata)
                                self.filtertedArray.append(labeldata)
                                //parentIdArr.append(labeldata.Id!)
                                //print("getParentNodes: \(self.getParentNodes(id: labeldata.Id!, name: ""))")
                            }
                            //parentIdArr = self.filtertedArray.filter{ ($0.ParentId == 0) }
                            //parentIdArr.sorted(by: {$0 < $1})
                            
                            
                            
                            let arr = self.filtertedArray.filter{ ($0.ParentId == 0) }
                            //self.createTreeData(id: 0, arr: arr)
                            
                            
                            let tablevw = self.labelAlertView.viewWithTag(4) as! UITableView
                            tablevw.reloadData()
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
    
    @objc func manageLabelsAction() {
        //segDMS
        labelAlertView.dismiss()
        performSegue(withIdentifier: "segDMS", sender: self)
    }
    
    @objc func addLabelsToDocs() {
        
        labelAlertView.dismiss()
        
        //let btn = labelAlertView.viewWithTag(10) as! UIButton
        //if btn.title(for: UIControlState.normal) != "APPLY CHANGES" {
        if sellabelArr.count == 0 && orgSellabelArr.count == 0 {
            let addFolderVC = getVC(sbId: "addFolderVC") as! AddFolderVC
            //addFolderVC.parentId = Int(selLabelId)!
            //addFolderVC.selLabel = selLabelData
            self.present(addFolderVC, animated: true, completion: nil)
            //segAddFolder
            //self.performSegue(withIdentifier: "segAddFolder", sender: self)
        } else {
            
            
            
            if sellabelArr.count > 0 && arrSelectedItem.count == 0 {
                
                alertSample(strTitle: "", strMsg: "Please select documents to add to label")
                
            } else {
                
                self.showActivityIndicatory(uiView: self.view)
                
                
                let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
                let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
                
                let api = "v1/label/AddUserWorkflows"
                let apiURL: String = Singletone.shareInstance.apiUserService + api
                //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/AddUserWorkflows"
                
                /*
                 [
                 {"ItemId":3178,"LabelId":13385},
                 {"ItemId":3265,"LabelId":13385}
                 ]
                 */
                var docLabelArr = [[String:Any]]()
                
                for i in arrSelectedItem {
                    
                    let docId = jsonReload!["Data"][i]["InstanceId"].intValue
                    
                    if sellabelArr.count > 0 {
                        for labelData in sellabelArr {
                            
                            let labelId = labelData.Id
                            
                            let dataDic = ["ItemId":docId,"LabelId":labelId]
                            docLabelArr.append(dataDic as! [String : Int])
                        }
                    } else {
                        let dataDic = ["ItemId":docId,"LabelId":-1]
                        docLabelArr.append(dataDic as! [String : Int])
                    }
                    
                }
                
                if Connectivity.isConnectedToInternet() == true
                {
                    
                    //creates the request
                    
                    var request = URLRequest(url: URL(string: apiURL)!)
                    
                    request.httpMethod = "POST"
                    request.setValue("Bearer \(strAuth)",
                        forHTTPHeaderField: "Authorization")
                    
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    //parameter array
                    
                    request.httpBody = try! JSONSerialization.data(withJSONObject: docLabelArr)
                    
                    Alamofire.request(request).responseJSON { response in
                        
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                        }
                        
                        if response.result.isFailure {
                            return
                        }
                        
                        let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            //self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            DispatchQueue.main.async {
                                self.lblSelectAll.text = "Select All"
                                self.callAPI()
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
        }
    }
    
    func onChecked(id: Int, flag: Bool) {
        
        let labeldata = filtertedArray[id]
        labeldata.selected = flag
        
        
        if flag {
            //isChanged = !isChanged
            sellabelArr.append(labeldata)
            
            if let index = totSellabelArr.index(of: labeldata) {
                print("yes false")
                isChanged = false
            }
            
            
        } else {
            let index = sellabelArr.index(of: labeldata)
            sellabelArr.remove(at: index!)
            
            if let index = totSellabelArr.index(of: labeldata) {
                print("yes true")
                isChanged = true
            }
        }
        
        
        
        //if sellabelArr.count > 0 || orgSellabelArr.count > 0 {
        if (totSellabelArr.count != sellabelArr.count) || isChanged {
            
            let btn1 = self.labelAlertView.viewWithTag(10) as! UIButton
            btn1.setTitle("APPLY CHANGES", for: UIControl.State.normal)
            
            let btn2 = self.labelAlertView.viewWithTag(11) as! UIButton
            btn2.isHidden = true
            
        } else {
            
            let btn1 = self.labelAlertView.viewWithTag(10) as! UIButton
            btn1.setTitle("CREATE NEW", for: UIControl.State.normal)
            
            let btn2 = self.labelAlertView.viewWithTag(11) as! UIButton
            btn2.isHidden = false
        }
        let tablevw = self.labelAlertView.viewWithTag(4) as! UITableView
        tablevw.reloadData()
    }
    
    //Logout API
    
    @objc func callLogoutAPI() {
        
        ///Account/LogOut
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let apiURL = Singletone.shareInstance.apiURL + "/Account/LogOut"
        
        let username = UserDefaults.standard.value(forKey: "UserName") as! String
        
        let parameters = ["UserName": username, "Token": strAuth] as [String:Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        
                        self.performSegue(withIdentifier: "segWelcome", sender: self)
                        self.alertSample(strTitle: "", strMsg: "You have logout for security reasons.")
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
    
    
    func createTreeData(id: Int, arr: [LabelData]) {
        
        
        if arr.count > 0 {
            //labelDic.setObject(arr, forKey: id as NSCopying)
            
            for data in arr {
                data.Labels = self.filtertedArray.filter{ ($0.ParentId == data.Id) }
                
                createTreeData(id: data.Id!, arr: data.Labels)
            }
        }
        
        //return labelDic
    }
    
    func getParentNodes(id: Int, name: String) -> String {
        
        let data = self.filtertedArray.filter{ ($0.Id == id) }
        if data != nil && data.count > 0 {
            let str1 = data[0].Name!
            let str = "\(str1)\\\(name)"
            getParentNodes(id: data[0].ParentId!, name: str)
        }
        print(name)
        return name
    }
    
    @IBAction override func saveTree() {
        self.performSegue(withIdentifier: "SaveTreeSegue", sender: self)
    }
    
    @objc func openDMSView(sender : UITapGestureRecognizer) {
        
        print("sender tag: \(sender.view?.tag)")
    }
    
    func getSubscriptionData() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v3/subscription/GetSubscriptionData"
        
        let apiURL = Singletone.shareInstance.apiSubscription + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value)
                        
                        if !jsonObj["Data"].isEmpty  {
                            print("response: \(jsonObj)")
                            let data = jsonObj["Data"].dictionaryObject
                            if let activeUserLicenses = data!["ActiveUserLicenses"] as? Int {
                                self.IsSubscriptionActive = data!["IsSubscriptionActive"] as! Bool
                            }
                            /*
                             let plan = data!["SubscriptionPlan"] as! Int
                             if plan == 1 {
                             self.IsSubscriptionActive = true
                             }
                             else if activeUserLicenses == 0 {
                             self.IsSubscriptionActive = false
                             } else {
                             self.IsSubscriptionActive = true
                             }*/
                            
                            //if self.IsSubscriptionActive {
                            self.addTopGestures()
                            /*} else {
                             self.disableDashboard()
                             }*/
                            self.callAPI()
                        } else {
                            let msg = jsonObj["Message"].stringValue
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                        
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @IBAction func sendEmailAction(_ sender: UIButton) {
        
        //getUsersForProcess()
        openMenu(sender: sender)
        
    }
    
    func getUsersForProcess() {
        //{"StatusCode":1000,"Message":"Success. ","Data":[{"processId":11251,"profileIds":[11429],"profileList":[{"ProfileId":"t9ROJMvvhEvygBWRmhmz%2FQ%3D%3D","UserId":"bmuVlYo4aNI%2BAjgzZxPfvg%3D%3D","OrganizationId":"4hjWMmUuAA16gzlFnKnLgQ%3D%3D","Email":"anil.hoh@gmail.com","FirstName":"Anil","MiddleName":"abccc","MiddleInitials":"","LastName":"Saindane","Rating":0.0,"Link":null,"Locale":null,"Picture":null,"Thumbnail":null,"ThumbnailURL":null,"IsActive":false,"IsDeleted":false,"IsWelcomeVisible":false,"IsVideoHelpVisible":false,"IsDefault":false,"AddressLine1":"nashik12","AddressLine2":"Nashik23","ZipCode":"12345678","StateCode":"pqrsttyyyy","City":"Abcxyzzz","County":"","Country":"American Samoa","CountryCode":"AT","Address":"nashik12,Nashik23","OfficialName":null,"Suffix":null,"Title":null,"JobTitle":null,"PhoneNumber":"1234567890","UserSignatureId":0,"Signature":null,"Initials":null,"SignatureDescription":null,"UserSignatures":null,"ProfileStatus":0,"Settings":null,"CreatedBy":null,"ModifiedBy":null,"UserType":0,"IsMerged":false}]}]}
        
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/process/GetUsersForProcessList"
        
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        var processIds: [Int] = []
        userList = []
        recipientArr = []
        
        for i in arrSelectedItem {
            
            let docId = jsonReload!["Data"][i]["InstanceId"].intValue
            processIds.append(docId)
        }
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: processIds.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value)
                        
                        if !jsonObj["Data"].isEmpty  {
                            print("response: \(jsonObj)")
                            if let data = jsonObj["Data"].arrayObject {
                                for dict in data {
                                    
                                    let procDict = dict as! [String:Any]
                                    if let profileList = procDict["profileList"] as? [[String:Any]] {
                                        
                                        for dic in profileList {
                                            
                                            self.userList.append(["FirstName": dic["FirstName"], "Email": dic["Email"]])
                                        }
                                    }
                                }
                                
                                self.showSendEmailAlert()
                            }
                            
                        } else {
                            let msg = jsonObj["Message"].stringValue
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
    }
    
    @objc public func openMenu(sender:UIButton) {
        let titles = ["Send Email"]
        let descriptions = [""]
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.set(descriptions: descriptions)
        
        // option parameteres
        // popOverViewController.setSelectRow(1)
        // popOverViewController.setShowsVerticalScrollIndicator(true)
        // popOverViewController.setSeparatorStyle(UITableViewCellSeparatorStyle.singleLine)
        
        //popOverViewController.popoverPresentationController?.barButtonItem = sender
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.preferredContentSize = CGSize(width: 200, height:40)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                if FeatureMatrix.shared.send_email {
                    if self.arrSelectedItem.count == 0 {
                        
                        self.alertSample(strTitle: "", strMsg: "Please select document(s) to send mail.")
                        
                    } else {
                        self.getUsersForProcess()
                    }
                } else {
                    FeatureMatrix.shared.showRestrictedMessage()
                }
                break
            case 1:
                break
            case 2:
                break
            default:
                break
            }
            
        };
        present(popOverViewController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func showSendEmailAlert() {
        
        sendEmailAlert = SwiftAlertView(nibName: "SendEmail", delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["SEND"])
        //"Apply Changes"
        sendEmailAlert.tag = 44
        sendEmailAlert.dismissOnOtherButtonClicked = false
        sendEmailAlert.highlightOnButtonClicked = false
        
        let txtreason = sendEmailAlert.viewWithTag(3) as! UITextView
        txtreason.layer.borderColor = UIColor.lightGray.cgColor
        txtreason.layer.borderWidth = 1.0
        //UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1).cgColor
        
        
        if userList.count > 0 {
            
            //var arr: [String] = []
            for dic in userList {
                let fname: String = dic["FirstName"] as! String
                let email: String = dic["Email"] as! String
                let str = "\(fname) (\(email))"
                if !recipientArr.contains(str) {
                    recipientArr.append(str)
                }
            }
            
            let listEmail = recipientArr.joined(separator: ", ")
            
            let recipientsTxt = sendEmailAlert.viewWithTag(1) as! UITextField
            
            
            let moreTxt = sendEmailAlert.viewWithTag(8) as! UILabel
            let btnarrow = sendEmailAlert.viewWithTag(7) as! UIButton
            
            if recipientArr.count > 1 {
                moreTxt.text = "\(recipientArr.count - 1) more"
                btnarrow.isHidden = false
                recipientsTxt.text = listEmail.substring(to: 10)
            } else {
                moreTxt.text = ""
                btnarrow.isHidden = true
                recipientsTxt.text = listEmail
            }
        }
        
        let btnchk = sendEmailAlert.viewWithTag(4) as! UIButton
        btnchk.addTarget(self, action: #selector(sendCopyClicked), for: UIControl.Event.touchUpInside)
        
        let btndwn = sendEmailAlert.viewWithTag(7) as! UIButton
        btndwn.addTarget(self, action: #selector(recipientsPop), for: UIControl.Event.touchUpInside)
        
        let btnclose = sendEmailAlert.buttonAtIndex(index: 0)
        let btnadd = sendEmailAlert.buttonAtIndex(index: 1)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        sendEmailAlert.show()
        
    }
    
    @IBAction func sendCopyClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
    }
    
    func sendDashboardEmail() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/process/SendDashboardEmail"
        
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        let txtsubject =  sendEmailAlert.viewWithTag(2) as! UITextField
        let txtmsg =  sendEmailAlert.viewWithTag(3) as! UITextView
        
        let subject = txtsubject.text ?? ""
        let msg = txtmsg.text ?? ""
        
        let btnchk = sendEmailAlert.viewWithTag(4) as! UIButton
        let sendCopy = btnchk.isSelected
        
        var processUser: [[String:Any]] = []
        
        for i in arrSelectedItem {
            
            let docId = jsonReload!["Data"][i]["InstanceId"].intValue
            //processIds.append(docId)
            processUser.append(["processId":docId,"profileList":userList])
            
        }
        
        let parameters = ["Subject":subject,"Message":msg,"IsSenderIncluded":sendCopy,"processUser":processUser] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                            self.sendEmailAlert.dismiss()
                            self.alertSample(strTitle: "", strMsg: "Cannot send Email(s)")
                        }
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                        let statusCode = jsonObj["StatusCode"]
                        if statusCode == 1000 {
                            //let msg = jsonObj["Message"].stringValue
                            DispatchQueue.main.async {
                                self.stopActivityIndicator()
                                
                                self.selectAllFlag = "Deselected"
                                self.btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
                                self.btnSelectAll.isSelected = false
                                
                                self.arrSelectedItem.removeAll()
                                self.tableViewDashboard.reloadData()
                                self.recipientFlag = false
                                self.lblSelectAll.text = "Select All"
                                
                                self.sendEmailAlert.dismiss()
                                self.alertSample(strTitle: "", strMsg: "Email(s) sent successfully")
                            }
                        }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    
    @IBAction func completeAction(_ sender: Any) {
        
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        
        showCompleteAlert(sender as! UIButton)
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
        
        showRejectAlert(sender as! UIButton)
    }
    
    
    
    func showRejectAlert(_ sender: UIButton) {
        
        
        let filterArr = rejectArr.filter{ ($0 != selReject) }
        
        let popOverViewController = PopOverViewController.instantiate()
        
        var dispArr: [String] = []
        for option in filterArr {
            let str: String = "\(option) (\(self.cntRejectDic[option]!))"
            dispArr.append(str)
        }
        popOverViewController.set(titles: dispArr)
        //popOverViewController.set(descriptions: filterArr)
        
        popOverViewController.popoverPresentationController?.sourceView = sender
        //popOverViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popOverViewController.preferredContentSize = CGSize(width: 200, height:80)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            
            let option = filterArr[selectRow]
            self.selReject = option
            self.lblRET.text = option
            self.lblRejected.text = String(self.cntRejectDic[option]!)
            
            if option == "Rejected" {
                self.jsonReload = self.jsonRejected
            }
            if option == "Expired" {
                self.jsonReload = self.jsonExpired
            }
            if option == "Cancelled" {
                self.jsonReload = self.jsonCancelled
            }
            
            self.selectAllFlag = "Deselected"
            self.btnSelectAll.isSelected = false
            print("Deselected")
            self.btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            
            self.arrSelectedItem.removeAll()
            self.lblSelectAll.text = "Select All"
            
            self.lblRejected.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            self.lblRET.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            self.lblComplete.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblCT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblIPT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblInProcess.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            self.viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            self.viewCI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            self.viewIPI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            self.viewREI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            self.selCategory = 93
            self.resetPlaceholder()
            
            self.btnDDReject.isSelected = false
            
            self.tableViewDashboard.reloadData()
            
        };
        
        present(popOverViewController, animated: true, completion: nil)
    }
    
    @objc func dismissAlert(sender : UITapGestureRecognizer) {
        if completeAlert != nil {
            btnDDComplete.isSelected = false
            completeAlert.dismiss(animated: false, completion: nil)
        }
        if rejectAlert != nil {
            btnDDReject.isSelected = false
            rejectAlert.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func recipientsPop() {
        
        //recipientAlert = SwiftAlertView(nibName: "DMSOptions", delegate: self, cancelButtonTitle: "", otherButtonTitles: [])
        recipientFlag = true
        
        let dmsviewarr = Bundle.main.loadNibNamed("DMSOptions", owner: self, options: nil)
        let dmsview = dmsviewarr![1] as! UIView
        
        recipientAlert = SwiftAlertView(contentView: dmsview, delegate: self, cancelButtonTitle: "OK")
        //SwiftAlertView(nibName: "DMSOptions", delegate: self, cancelButtonTitle: "Ok")
        recipientAlert.dismissOnOutsideClicked = true
        
        let btnok = recipientAlert.buttonAtIndex(index: 0)
        btnok?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnok?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let tblvw = recipientAlert.viewWithTag(4) as! UITableView
        tblvw.dataSource = self
        
        tblvw.reloadData()
        
        recipientAlert.show()
        
        //recipientAlert.refreshElementBeforeShowing(view: self.view, tag: 1, flag: 1)
    }
    
    @objc func deleteRecipient(_ sender: UIButton) {
        
        if recipientArr.count > 1 {
            let tag: Int = Int(sender.accessibilityHint!)!
            
            recipientArr.remove(at: tag)
            userList.remove(at: tag)
            
            let recipient = recipientArr[0]
            
            let txtrec = sendEmailAlert.viewWithTag(1) as! UITextField
            txtrec.text = recipient
            
            let tblvw = recipientAlert.viewWithTag(4) as! UITableView
            tblvw.reloadData()
        }
    }
    
    func showCompleteAlert(_ sender: UIButton) {
        
        
        let filterArr = completeArr.filter{ ($0 != selComplete) }
        
        let popOverViewController = PopOverViewController.instantiate()
        
        var dispArr: [String] = []
        for option in filterArr {
            let str: String = "\(option) (\(self.cntCompleteDic[option]!))"
            dispArr.append(str)
        }
        popOverViewController.set(titles: dispArr)
        //popOverViewController.set(descriptions: filterArr)
        
        popOverViewController.popoverPresentationController?.sourceView = sender
        //popOverViewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        popOverViewController.preferredContentSize = CGSize(width: 200, height:80)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            
            let option = filterArr[selectRow]
            //for option in filterArr {
            
            self.selComplete = option
            self.lblCT.text = option
            self.lblComplete.text = String(self.cntCompleteDic[option]!)
            
            if option == "Completed" {
                self.jsonReload = self.jsonCompleted
            }
            if option == "Shared To Me" {
                self.jsonReload = self.jsonShared
            }
            if option == "Scanned Token" {
                self.jsonReload = self.jsonScanned
            }
            
            self.selectAllFlag = "Deselected"
            self.btnSelectAll.isSelected = false
            print("Deselected")
            self.btnSelectAll.setImage(Singletone.shareInstance.dashboardCheckboxDeselect, for: .normal)
            
            self.arrSelectedItem.removeAll()
            self.lblSelectAll.text = "Select All"
            
            self.lblComplete.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            self.lblCT.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            self.lblEsign.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblRT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblIPT.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblRET.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblInProcess.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            self.lblRejected.textColor = UIColor.black//Singletone.shareInstance.topViewBackgroundGray
            
            self.viewRI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            self.viewCI.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            self.viewIPI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            self.viewREI.backgroundColor = Singletone.shareInstance.topViewBackgroundGray
            
            self.selCategory = 91
            self.resetPlaceholder()
            
            self.btnDDComplete.isSelected = false
            self.tableViewDashboard.reloadData()
            //}
            
        };
        
        present(popOverViewController, animated: true, completion: nil)
    }
    //SendDashboardEmail
    //{"Subject":"testing","Message":"testing","IsSenderIncluded":true,"processUser":[{"processId":11251,"profileList":[{"FirstName":"Anil","Email":"anil.hoh@gmail.com"}]}]}
}


//MARK: - New Implementation
//MARK: - Check for push
extension DashboardViewController {
    fileprivate func chechFromPush() {
        let frompush = ZorroTempData.sharedInstance.getisfromPush()
        if frompush {
            
            updateSignatures { (completed) in
                if completed {
                    self.updateStamp(completion: { (completed) in
                        if completed {
                            let pushnotificationtype = ZorroTempData.sharedInstance.getnotificationType()
                            let documentname = ZorroTempData.sharedInstance.getdocumentName()
                            let documentprocessid = ZorroTempData.sharedInstance.getdocprocessId()
                            switch pushnotificationtype {
                            case 2:
                                let documentsignController = DocumentSignController()
                                documentsignController.documentinstanceId = documentprocessid
                                documentsignController.documentName = documentname
                                self.navigationController?.pushViewController(documentsignController, animated: true)
                            case 3:
                                self.alertSample(strTitle: "User Specific Workflow !", strMsg: "Documents that use the user specific workflow are currently not supported the mobile app. Please sign them by logging into your account using your desktop / laptop. Please always use the latest version of the app as this feature will be added soon.")
                            case 4:
                                self.alertSample(strTitle: "Unable to View DWF Documents !", strMsg: "Unabele to view DWF documents, please use IE Browser")
                            case 5:
                                let documentviewController = DocumentViewController()
                                documentviewController.documentName = documentname
                                documentviewController.documentinstanceId = documentprocessid
                                self.navigationController?.pushViewController(documentviewController, animated: true)
                            default:
                                print("default")
                            }
                            ZorroTempData.sharedInstance.clearfromNotification()
                        }
                        return
                    })
                }
                return
            }
        }
        return
    }
}

//MARK: - Check for deep link
extension DashboardViewController {
    fileprivate func checkforDeepLinke() {
        let fromdeeplink = ZorroTempData.sharedInstance.getisfromDeeplink()
        if fromdeeplink {
//            let usermail = ZorroTempData.sharedInstance.getUserEmail()
//            let receivermail = ZorroTempData.sharedInstance.getreceiverEmail()
            
            let isregistered = ZorroTempData.sharedInstance.getiszorrosignRegistered()
            
            if !isregistered {
//                if usermail != receivermail {
//                    return
//                }
                ZorroTempData.sharedInstance.setallSignatures(signatures: [])
            }
//            else {
//                ZorroTempData.sharedInstance.setallSignatures(signatures: [])
//            }
            
            let documentprocessid = ZorroTempData.sharedInstance.getdocprocessId()
            let upprview = ZorroTempData.sharedInstance.getdeeplinkView()
            
            print(upprview)
            
            
            switch upprview {
            case "DCProcessSign":
                let documentsignController = DocumentSignController()
                documentsignController.documentinstanceId = documentprocessid
                documentsignController.documentName = ""
                
                if isregistered {
                    documentsignController.isregisterd = true
                } else {
                    documentsignController.isregisterd = false
                }
                
                self.navigationController?.pushViewController(documentsignController, animated: true)
            case "ProcessView":
                let documentviewController = DocumentViewController()
                documentviewController.documentName = ""
                documentviewController.documentinstanceId = documentprocessid
                
//                if isregistered {
//                    documentviewController.isregisterd = true
//                } else {
//                    documentviewController.isregisterd = false
//                }
                
                self.navigationController?.pushViewController(documentviewController, animated: true)
            default:
                return
            }
            ZorroTempData.sharedInstance.clearfromDeeplink()
            ZorroTempData.sharedInstance.clearfromNotification()
        }
    }
}

//MARK: - update Signature
extension DashboardViewController {
    fileprivate func updateSignatures(completion: @escaping(Bool) -> ()) {
        
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (userprofiledata, err) in
            if err {
                self.alertSample(strTitle: "Something Went Wrong ", strMsg: "Unable to get user details, please try again")
                completion(false)
                return
            }
            
            var signatures: [UserSignature] = []
            
            if let signatureid = userprofiledata?.Data?.UserSignatureId, let signature = userprofiledata?.Data?.Signature, let intial = userprofiledata?.Data?.Initials {
                if signature != "" {
                    var newSignature = UserSignature()
                    newSignature.UserSignatureId = signatureid
                    newSignature.Signature = signature
                    newSignature.Initials = intial
                    signatures.append(newSignature)
                }
            }
            
            if let signatories = userprofiledata?.Data?.UserSignatures {
                if signatories.count > 0 {
                    for signature in signatories {
                        signatures.append(signature)
                    }
                }
            }
            
            ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
            
            if let isssnavailable = userprofiledata?.Data?.IsSsnAvailable {
                ZorroTempData.sharedInstance.setisSSNAvailable(isavailable: isssnavailable)
            }
            
            if let usertype = userprofiledata?.Data?.UserType {
                if usertype == 1 {
                    let organizationdetails = OrganizationDetails()
                    organizationdetails.geturerorganizationDetails { (orgdetails) in
                        
                        if let orglegalname = orgdetails?.Data?.Organization?.LegalName {
                            ZorroTempData.sharedInstance.setOrganizationLegalname(legalname: orglegalname)
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
            }
            return
        }
    }
}

//MARK: Update stamp
extension DashboardViewController {
    fileprivate func updateStamp(completion: @escaping(Bool) -> ()) {
        ZorroHttpClient.sharedInstance.getOrganizationStamp { (stamp, err) in
            if let stampstring = stamp?.Data?.StampImage {
                ZorroTempData.sharedInstance.setStamp(stamp: stampstring)
            }
            completion(true)
        }
    }
}

//MARK: Check availble doc count
extension DashboardViewController {
    private func checkavailabledocCount(completion: @escaping(Bool) -> ()) {
        
        let myaccount = MyAccount()
        myaccount.getmyaccountDocumentSummary { (myaccount) in
            guard let accounddata = myaccount?.Data else { return }
            guard let availabeldoccount = accounddata.AvailableDocSetCount else { return }
            
            if availabeldoccount > 0 || availabeldoccount == -1 {
                completion(true)
                return
            }
            completion(false)
            return
        }
    }
}

//MARK: Check Subscription
extension DashboardViewController {
    private func checkSubscription(completion: @escaping(Bool) -> ()) {
        
        let getsubscription = GetSubscriptionData()
        getsubscription.getUserSubscriptionData { (subscriptionactive, subsctionData)  in
            completion(subscriptionactive)
            return
        }
        return
    }
}


extension DashboardViewController {
    
    @objc fileprivate func startsignatureAction(_ sender: UIButton) {
        
        if FeatureMatrix.shared.create_esign {
            
            let connectivity = Connectivity.isConnectedToInternet()
            if !connectivity {
                alertSample(strTitle: "Connection!", strMsg: "Your connection appears to be offline, please try again!")
                return
            }
            
            self.showActivityIndicatory(uiView: self.view)
            
            checkSubscription { [weak self](issubscribed) in
                if issubscribed {
                    self!.checkavailabledocCount { [weak self] availabel in
                        if availabel {
                            self!.updateSignatures { [weak self] completed in
                                if completed {
                                    self!.updateStamp(completion: { [weak self] completed in
                                        let documentintiateController = DocumentInitiateSelectController()
                                        self!.navigationController?.pushViewController(documentintiateController, animated: true)
                                        self!.stopActivityIndicator()
                                        return
                                    })
                                }
                                return
                            }
                            return
                        }
                        DispatchQueue.main.async {
                            self!.stopActivityIndicator()
//                            self!.alertSample(strTitle: "No Available Document Set(s)", strMsg: "Please update your license")
                        }
                        return
                    }
                    return
                }
                DispatchQueue.main.async {
                    self!.stopActivityIndicator()
//                    self!.alertSample(strTitle: "Your subscription Expired", strMsg: "Your ZorroSign account does not have a valid license assigned to it yet. Please contact your Admin.")
                }
                return
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}


