
//
//  MyAccountViewController.swift
//  ZorroSign
//
//  Created by Apple on 12/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyAccountViewController: BaseVC, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var _viewFooter: UIView!
    @IBOutlet weak var lblUsed: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblAvaliable: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var viewAvaliable: UIView!
    @IBOutlet weak var viewDocument: UIView!
    @IBOutlet weak var viewExpires: UIView!
    
    @IBOutlet weak var viewBottomDashborad: UIView!
    //@IBOutlet weak var viewBottomStart: UIView!
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
    @IBOutlet weak var btnLogout: UIButton!
    
    @IBOutlet weak var con_tblHgt: NSLayoutConstraint!
    
    private var myaccountTableView: UITableView!
    private var defaultcellIdentifier = "defaultcellidentifier"
    private var myaccountdocumentcell = "myaccountdocumentcell"
    private var myaccountuserlicensecell = "myaccountuserlicensecell"
    private var myaccountdefaultcell = "myaccountdefaultcell"
    private var myaccountlogoutcell = "myaccountlogoutcell"
    
    var _footerView: UIView!
    var myAccount: MyAccount!
    var isSubscribedUser = false
    
    let arrImg = ["edit_profile_green_icon","editing_green_icon","zs_ini_green_icon","stamp","change_pw_green_icon"]
    let arrName = ["Edit User Profile","Edit Company Profile","Manage Signatures","Seal","Change Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFooterView()
        
        //        let myaccount = MyAccount()
        //        myaccount.getmyaccountDocumentSummary { (myaccount) in
        //            print(myaccount)
        //        }
        
        getDocSummary()
        
        let UserType = ZorroTempData.sharedInstance.getUserType()
        
//        let UserType: Int = UserDefaults.standard.value(forKey: "UserType") as! Int
        
        if UserType != 1 {
            if let profstat = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int {
                
                // for NEW user
                if profstat == 1 {
                    //performSegue(withIdentifier: "segUserProfile", sender: self)
                    let userprof = getVC(sbId: "userprofile_SBID")
                    self.navigationController?.pushViewController(userprof, animated: true)
                }
            }
        }
        
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        if !adminflag {
            self.con_tblHgt.constant = 186//136
        } else {
            self.con_tblHgt.constant = 230//180
        }
        
        viewAvaliable.layer.cornerRadius = 3
        viewAvaliable.clipsToBounds = true
        viewDocument.layer.cornerRadius = 3
        viewDocument.clipsToBounds = true
        viewExpires.layer.cornerRadius = 3
        viewExpires.clipsToBounds = true
        tableViewList.layer.cornerRadius = 3
        tableViewList.clipsToBounds = true
        
        btnLogout.layer.cornerRadius = 3
        btnLogout.clipsToBounds = true
        
        
        //        tableViewList.delegate = self
        //        tableViewList.dataSource = self
        
        tableViewList.isScrollEnabled = false
        
        tableViewList.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableViewList.frame.size.width, height: 1))
        
        viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
        //Singletone.shareInstance.topViewBackgroundGray.withAlphaComponent(0.1)
        viewBottomSearch.isUserInteractionEnabled = false
        
        viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
        lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
        lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
        viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
        
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
        
        getAvailableUsers()
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            let api = "v3/Subscription/GetSubscriptionData"
            let apiURL = Singletone.shareInstance.apiSubscription + api
            
            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        
                        self.lblDate.text = "Starter Account- No Expiration"
                        self.viewAvaliable.isHidden = true
                        
                        return
                    }
                    
                    guard let response = response.result.value else {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.lblTotal.text = ""
                        self.lblUsed.text = ""
                        self.lblDate.text = ""
                        self.viewAvaliable.isHidden = true
                        
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.lblTotal.text = jsonObj["Data"]["TotalDocuments"].stringValue
                        self.lblUsed.text = jsonObj["Data"]["UsedDocuments"].stringValue
                        
                        let strFullDate = jsonObj["Data"]["ExpireDateTime"].stringValue
                        let subscriptionPlan = jsonObj["Data"]["SubscriptionPlan"].intValue
                        if !strFullDate.isEmpty {
                            let strDate = strFullDate.split(separator: "T")
                            let strS = strDate[0].description.split(separator: "-")
                            
                            if subscriptionPlan == 1 {
                                self.lblDate.text = "Starter Account- No Expiration"
                                //self.lblAvaliable.text = "1"
                                self.viewAvaliable.isHidden = true
                                self.isSubscribedUser = false
                            } else {
                                self.lblDate.text = strS[1].description + "/" + strS[2].description + "/" +  strS[0].description
                                self.isSubscribedUser = true
                                //self.lblAvaliable.text = jsonObj["Data"]["ActiveUserLicenses"].stringValue
                            }
                        }
                        if subscriptionPlan == 1 {
                            self.lblDate.text = "Starter Account- No Expiration"
                            //self.lblAvaliable.text = "1"
                            self.viewAvaliable.isHidden = true
                            self.isSubscribedUser = false
                        } else {
                            self.isSubscribedUser = true
                        }
                        
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDocSummary()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    func getAvailableUsers() {
        
        //https://zsdemowebsubscription.zorrosign.com/api/v2/Subscription/GetOrgAvailableLicenseCount
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            
            let api = "v3/Subscription/GetOrgAvailableLicenseCount"
            let apiURL = Singletone.shareInstance.apiSubscription + api
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    guard let result = response.result.value else {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.lblAvaliable.text = ""
                        
                        return
                    }
                    
                    let jsonObj: JSON = JSON(result)
                    self.lblAvaliable.text = ""
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        
                        self.lblAvaliable.text = String(jsonObj["Data"].intValue)
                        
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
            }
        }
    }
    
    @IBAction func btnLogoutAction(_ sender: Any) {
        alertSampleWithLogin(strTitle: "", strMsg: "Do you want to logout?")
    }
    
    @IBAction func btnBottomLogoutAction(_ sender: Any) {
        alertSampleWithLogin(strTitle: "", strMsg: "Do you want to logout?")
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "footerFlag") == "Dashboard"
        {
            performSegue(withIdentifier: "segBackDashboard", sender: self)
        }
        else if UserDefaults.standard.string(forKey: "footerFlag") == "Contact"
        {
            
        }
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        
        switch s! {
        case 100:
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
            
            //viewBottomSearch.backgroundColor = Singletone.shareInstance.topViewBackgroundGray.withAlphaComponent(0.1)
            viewBottomSearch.isUserInteractionEnabled = false
            
            
            break
        case 102:
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
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 103:
            
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
            
            break
        case 104:
            
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    
    @IBAction override func WhatsNewAction() {
        
        let whtsvc = getVC(sbId: "WhatsNew_SBID")
        self.present(whtsvc, animated: false, completion: nil)
        
    }
    
    @IBAction override func saveTree() {
        self.performSegue(withIdentifier: "saveTreeSegue", sender: self)
    }
}

//MARK: Setup footer
extension MyAccountViewController {
    private func setFooterView() {
        _footerView = UIView()
        _footerView.translatesAutoresizingMaskIntoConstraints = false
        _footerView.backgroundColor = .yellow
        _footerView.isHidden = true
        self.view.addSubview(_footerView)
        
        let safearea = self.view.safeAreaLayoutGuide
        
        let footerviewContraints = [_footerView.leftAnchor.constraint(equalTo: safearea.leftAnchor),
                                    _footerView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor, constant: 0),
                                    _footerView.rightAnchor.constraint(equalTo: safearea.rightAnchor),
                                    _footerView.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(footerviewContraints)
        
        
        let _buttonwidth = UIScreen.main.bounds.width/4
        for i in 0..<4 {
            let _xvalue = CGFloat(i) * _buttonwidth
            let _view = UIView(frame: CGRect(x: _xvalue, y: 0, width: _buttonwidth, height: 45))
            _view.backgroundColor = .green
            
//            let _lable = UILabel(frame: CGRect(x: 8, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>))
            
            _footerView.addSubview(_view)
        }
        
    }
}


//MARK: New Implementation
extension MyAccountViewController {
    fileprivate func getDocSummary() {
        showActivityIndicatory(uiView: view)
        let myaccount = MyAccount()
        
        if !Connectivity.isConnectedToInternet() {
            stopActivityIndicator()
            alertSample(strTitle: "No Connection ", strMsg: "Please check you internet connection and Try Again!")
            return
        }
    
        myaccount.getmyaccountDocumentSummary { (docdetails) in
            guard let docsummarydetails = docdetails else { return }
            self.myAccount = docsummarydetails
            self.setMyAccountTableview()
            self.myaccountTableView.reloadData()
            self.stopActivityIndicator()
            self._viewFooter.layer.zPosition = 1
            self.view.bringSubviewToFront(self._viewFooter)
            
            //Show Subscription banner
            let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
            if !isBannerClosed {
                self.setTitleForSubscriptionBanner()
            }
        }
    }
}


//MARK: Setup Table View
extension MyAccountViewController {
    
    fileprivate func setMyAccountTableview() {
        myaccountTableView = UITableView(frame: .zero, style: .grouped)
        myaccountTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        myaccountTableView.translatesAutoresizingMaskIntoConstraints = false
        myaccountTableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultcellIdentifier)
        myaccountTableView.register(DocumentCell.self, forCellReuseIdentifier: myaccountdocumentcell)
        myaccountTableView.register(LicensesCell.self, forCellReuseIdentifier: myaccountuserlicensecell)
        myaccountTableView.register(MyAccountCommonCell.self, forCellReuseIdentifier: myaccountdefaultcell)
        myaccountTableView.register(MyAccountLogoutCell.self, forCellReuseIdentifier: myaccountlogoutcell)
        myaccountTableView.estimatedRowHeight = UITableView.automaticDimension
        myaccountTableView.rowHeight = UITableView.automaticDimension
        myaccountTableView.separatorStyle = .none
        myaccountTableView.tableFooterView = UIView()
        myaccountTableView.backgroundColor = .white
        myaccountTableView.dataSource = self
        myaccountTableView.delegate = self
        view.addSubview(myaccountTableView)
        
        let myaccounttableviewConstraints = [myaccountTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             myaccountTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64),
                                             myaccountTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             myaccountTableView.bottomAnchor.constraint(equalTo: _footerView.topAnchor, constant: 0)]
        
        NSLayoutConstraint.activate(myaccounttableviewConstraints)
        
    }
}

//MARK: DataSource
extension MyAccountViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 8
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 1:
            let documentcell = tableView.dequeueReusableCell(withIdentifier: myaccountdocumentcell) as! DocumentCell
            documentcell.totalcount = myAccount.Data?.TotalDocSetCount
            documentcell.sentcount = myAccount.Data?.StartedCount
            documentcell.inboxcount = myAccount.Data?.InboxCount
            documentcell.availablecount = myAccount.Data?.AvailableDocSetCount
            return documentcell
        case 2:
            let licensecell = tableView.dequeueReusableCell(withIdentifier: myaccountuserlicensecell) as! LicensesCell
            licensecell.availabellicense = myAccount.Data?.AvailableLicenseCount
            licensecell.expires = myAccount.Data?.LicenseExpiryDateTime
            return licensecell
        case 3:
            let defaultcell = tableView.dequeueReusableCell(withIdentifier: myaccountdefaultcell) as! MyAccountCommonCell
            defaultcell.settitleForIndex = indexPath.row
            return defaultcell
        case 4:
            let logoutcell = tableView.dequeueReusableCell(withIdentifier: myaccountlogoutcell) as! MyAccountLogoutCell
            return logoutcell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: defaultcellIdentifier)
            cell?.textLabel?.text = "Working fine >"
            return cell!
        }
        
    }
}

//MARK: Delegate

extension MyAccountViewController {
    
    @objc private func didTapOnUpdateButton(_ sender: UIButton) {
        let storyboad = UIStoryboard.init(name: "Subscription", bundle: nil)
        let subscriptionVC = storyboad.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        subscriptionVC.isFromMyAccountOrBanner = true
        
        self.navigationController?.pushViewController(subscriptionVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return (ZorroTempData.sharedInstance.getUserSubscribedOrNot()) ? 30 : 90
        case 2:
            let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
            if adminflag {
                return 30
            } else {
                return CGFloat.leastNormalMagnitude
            }
        case 3:
            return 10
        case 4:
            return 10
        default:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        
        switch section {
        case 0:
            let updateView = UIView(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 20, height: 90))
            
            let updateButton = UIButton()
            updateButton.translatesAutoresizingMaskIntoConstraints = false
            updateButton.backgroundColor = ColorTheme.btnBG
            updateButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
            updateButton.setTitle("Upgrade", for: .normal)
            updateButton.titleLabel?.font = UIFont(name: "Helvetica-Bold", size: 24)
            updateButton.titleLabel?.adjustsFontSizeToFitWidth = true
            updateButton.titleLabel?.minimumScaleFactor = 0.2
            updateButton.layer.cornerRadius = 4
            updateButton.titleLabel?.textAlignment = .center
            
            updateView.addSubview(updateButton)
            
            let updateButtonConstraints = [
                updateButton.leftAnchor.constraint(equalTo: updateView.leftAnchor, constant: 20),
                updateButton.topAnchor.constraint(equalTo: updateView.topAnchor,constant: 0),
                updateButton.rightAnchor.constraint(equalTo: updateView.rightAnchor, constant: -20),
                updateButton.heightAnchor.constraint(equalToConstant: 50)
            ]
            NSLayoutConstraint.activate(updateButtonConstraints)
            
            updateButton.setShadow()
            updateButton.addTarget(self, action: #selector(didTapOnUpdateButton(_:)), for: .touchUpInside)
            
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Helvetica-Bold", size: 16)
            label.text = "Subscription Plan Summary"
            label.textColor = .darkGray
            
            updateView.addSubview(label)
            
            let labelConstraints = [
                label.leftAnchor.constraint(equalTo: updateView.leftAnchor, constant: 20),
                label.topAnchor.constraint(equalTo: updateView.topAnchor,constant: 60),
                label.rightAnchor.constraint(equalTo: updateView.rightAnchor, constant: 20),
                label.heightAnchor.constraint(equalToConstant: 30)
            ]
            NSLayoutConstraint.activate(labelConstraints)
            
//            return updateView
            
            let nonsubscribedlabel = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 10, height: 30))
            nonsubscribedlabel.font = UIFont(name: "Helvetica-Bold", size: 16)
            nonsubscribedlabel.text = "Subscription Plan Summary"
            nonsubscribedlabel.textColor = .darkGray
            headerview.addSubview(nonsubscribedlabel)
            
            return (ZorroTempData.sharedInstance.getUserSubscribedOrNot()) ? headerview : updateView
        case 1:
            let imageview = UIImageView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
            imageview.backgroundColor = .clear
            imageview.contentMode = .center
            imageview.image = UIImage(named: "Documents")
            headerview.addSubview(imageview)
            
            let label = UILabel(frame: CGRect(x: 60, y: 0, width: UIScreen.main.bounds.width - 70, height: 30))
            label.font = UIFont(name: "Helvetica-Bold", size: 16)
            label.text = "Documents"
            label.textColor = .darkGray
            headerview.addSubview(label)
            
            return headerview
        case 2:
            
            let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
            if adminflag {
                let imageview = UIImageView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
                imageview.backgroundColor = .clear
                imageview.contentMode = .center
                imageview.image = UIImage(named: "User-Licenses")
                headerview.addSubview(imageview)
                
                let label = UILabel(frame: CGRect(x: 60, y: 0, width: UIScreen.main.bounds.width - 70, height: 30))
                label.font = UIFont(name: "Helvetica-Bold", size: 16)
                label.text = "User License"
                label.textColor = .darkGray
                headerview.addSubview(label)
            } else {
                headerview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
                headerview.backgroundColor = .red
            }
            return headerview
        case 3:
            let footerview = UIView(frame: CGRect(x: 10, y: 8, width: UIScreen.main.bounds.width - 20, height: 1))
            footerview.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            headerview.addSubview(footerview)
            return headerview
        case 4:
            let footerview = UIView(frame: CGRect(x: 10, y: 3, width: UIScreen.main.bounds.width - 20, height: 1))
            footerview.backgroundColor = UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
            headerview.addSubview(footerview)
            return headerview
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return UITableView.automaticDimension
        case 2:
            let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
            if adminflag {
                return UITableView.automaticDimension
            } else {
                return 0.0
            }
            
        case 3:
            var rowHeight: CGFloat = 0.0
            switch indexPath.row {
            case 1:
                let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
                if adminflag {
                    rowHeight = 50.0
                } else {
                    rowHeight = 0.0
                }
                return rowHeight
            case 5:
                return 50.0
            default:
                return 50
            }
        case 4:
            return 50
        default:
            return 0
        }
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            switch indexPath.row {
            case 0:
                let userprof = getVC(sbId: "userprofile_SBID")
                self.navigationController?.pushViewController(userprof, animated: true)
                return
            case 1:
                let userprof = getVC(sbId: "compprofile_SBID")
                self.navigationController?.pushViewController(userprof, animated: true)
                return
            case 2:
                let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
                let signatureVC = storyBoard.instantiateViewController(withIdentifier: "AddSignatureVC") as! AddSignatureVC
                self.navigationController?.pushViewController(signatureVC, animated: true)
                return
            case 3:
                let seal = getVC(sbId: "Seal_SBID")
                self.navigationController?.pushViewController(seal, animated: true)
                return
            case 4:
                let vCard = VcardController()
                self.navigationController?.pushViewController(vCard, animated: true)
            case 5:
                let userprof = getVC(sbId: "changepass_SBID")
                self.navigationController?.pushViewController(userprof, animated: true)
                return
            case 6:
                passwordLessCheck()
                return
            case 7:
                if FeatureMatrix.shared.authentication_2fa {
                    if let fromForceMFA = UserDefaults.standard.value(forKey: "FromForceMFA") as? String {
                        if fromForceMFA == "YES" {
                            
                            let multifactorsettingsController = MultifactorSettingsViewController()
                            multifactorsettingsController.isBackButtonDisabled = true
                            self.navigationController?.pushViewController(multifactorsettingsController, animated: true)
                            
                        } else {
                            let multifactorsettingsController = MultifactorSettingsViewController()
                            self.navigationController?.pushViewController(multifactorsettingsController, animated: true)
                        }
                    } else {
                        let multifactorsettingsController = MultifactorSettingsViewController()
                        self.navigationController?.pushViewController(multifactorsettingsController, animated: true)
                    }
                } else {
                    FeatureMatrix.shared.showRestrictedMessage()
                }
                
                return
            case 8:
                self.performSegue(withIdentifier: "saveTreeSegue", sender: self)
                return
            default:
                print("")
            }
        case 4:
            DispatchQueue.main.async {
                self.alertSampleWithLogin(strTitle: "", strMsg: "Do you want to logout?")
            }
            return
        default:
            return
        }
    }
}

//MARK: Passwordless, Biometrics
extension MyAccountViewController {
    private func passwordLessCheck() {
        self.showActivityIndicatory(uiView: self.view)
        
        let username: String = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid: String = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: username.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (onboarded, keyid) in
            self.stopActivityIndicator()
            
            if onboarded {
                // TO DO : just display the settings page
                let passwordlessonboardingController = PasswordlessOnboardingController()
                passwordlessonboardingController.sourceFrom = 1
                
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(passwordlessonboardingController, animated: true)
                }
                
                return
            }
            //TO DO: navigate user for onboard
            let passwordlessIntroController = PasswordlessIntroController()
            passwordlessIntroController.sourceFrom = 1
            
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(passwordlessIntroController, animated: true)
            }
            
            passwordlessIntroController.onBoardStatus = {
                return
            }
            
            return
        }
        return
    }
}


//MARK: Custom table viwe cells

//MARK:- Document Cell
class DocumentCell: UITableViewCell {
    
    private var total: UILabel!
    var sent: UILabel!
    var inbox: UILabel!
    var available: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 2)
        setdocumentCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setdocumentCell() {
        total = UILabel()
        total.translatesAutoresizingMaskIntoConstraints = false
        total.textColor = .darkGray
        
        addSubview(total)
        total.text = "Total : Unlimited"
        
        let totalConstraints = [total.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                                total.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                total.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(totalConstraints)
        
        sent = UILabel()
        sent.translatesAutoresizingMaskIntoConstraints = false
        sent.textColor = .darkGray
        addSubview(sent)
        sent.text = "Sent : 6002"
        
        let sendConstraints = [sent.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                               sent.topAnchor.constraint(equalTo: total.bottomAnchor, constant: 10),
                               sent.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(sendConstraints)
        
        inbox = UILabel()
        inbox.translatesAutoresizingMaskIntoConstraints = false
        inbox.textColor = .darkGray
        addSubview(inbox)
        inbox.text = "Inbox : 4250"
        
        let inboxConstraints = [inbox.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                                inbox.topAnchor.constraint(equalTo: sent.bottomAnchor, constant: 10),
                                inbox.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(inboxConstraints)
        
        available = UILabel()
        available.translatesAutoresizingMaskIntoConstraints = false
        available.textColor = .darkGray
        addSubview(available)
        available.text = "Available : 4250"
        
        let availableConstraints = [available.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                                    available.topAnchor.constraint(equalTo: inbox.bottomAnchor, constant: 10),
                                    available.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                    available.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(availableConstraints)
    }
    
    var totalcount: Int! {
        didSet {
            var count = "Total : \(totalcount ?? 0)"
            let boldstring = "\(totalcount ?? 0)"
            if totalcount < 0 {
                count = "Total : Unlimited"
            }
        
            let attributedstring = NSMutableAttributedString(string: count)
            attributedstring.setFont(forText: boldstring, fontsize: 16)
            total.attributedText = attributedstring
        }
    }
    
    
    var sentcount: Int! {
        didSet {
            let count = "Sent : \(sentcount ?? 0)"
            let boldstring = "\(sentcount ?? 0)"
            let attributedstring = NSMutableAttributedString(string: count)
            attributedstring.setFont(forText: boldstring, fontsize: 16)
            sent.attributedText = attributedstring
        }
    }
    
    
    var inboxcount: Int! {
        didSet {
            let count = "Inbox(Includes CC docs) : \(inboxcount ?? 0)"
            let boldstring = "\(inboxcount ?? 0)"
            let attributedstring = NSMutableAttributedString(string: count)
            attributedstring.setFont(forText: boldstring, fontsize: 16)
            inbox.attributedText = attributedstring
        }
    }
    
    var availablecount: Int! {
        didSet {
            var count = "Available : \(availablecount ?? 0)"
            let boldstring = "\(availablecount ?? 0)"
            if availablecount < 0 {
                count = "Available : Unlimited"
            }
            
            let attributedstring = NSMutableAttributedString(string: count)
            attributedstring.setFont(forText: boldstring, fontsize: 16)
            available.attributedText = attributedstring
        }
    }
    
    
    
}

//MARK:- License Cell
class LicensesCell: UITableViewCell {
    
    var availabelLicense: UILabel!
    var expire: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 2)
        setLicenseCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLicenseCell() {
        
        availabelLicense = UILabel()
        availabelLicense.translatesAutoresizingMaskIntoConstraints = false
        availabelLicense.textColor = .darkGray
        
        addSubview(availabelLicense)
        availabelLicense.text = "Availabel User Licenses : Unlimited"
        
        let availabelLicenseConstraints = [availabelLicense.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                                           availabelLicense.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                           availabelLicense.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(availabelLicenseConstraints)
        
        expire = UILabel()
        expire.translatesAutoresizingMaskIntoConstraints = false
        expire.textColor = .darkGray
        addSubview(expire)
        expire.text = "License Expires on : N/A"
        
        let expireConstraints = [expire.leftAnchor.constraint(equalTo: leftAnchor, constant: 70),
                                 expire.topAnchor.constraint(equalTo: availabelLicense.bottomAnchor, constant: 10),
                                 expire.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                 expire.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(expireConstraints)
    }
    
    var availabellicense: Int! {
        didSet {
            
            let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
            if adminflag {
                isHidden = false
            } else {
                isHidden = true
            }
            
            let count = "Available User Licenses : \(availabellicense ?? 0)"
            let boldstring = "\(availabellicense ?? 0)"
            let attributedstring = NSMutableAttributedString(string: count)
            attributedstring.setFont(forText: boldstring, fontsize: 16)
            availabelLicense.attributedText = attributedstring
        }
    }
    
    var expires: String! {
        didSet {
        
            if let expiredate = expires {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateformatter.locale = Locale(identifier: "en_US_POSIX")
                let date = dateformatter.date(from: expiredate)
                if date != nil {
                    dateformatter.dateFormat = "MMM d, yyyy"
                    let newdatestring = dateformatter.string(from: date!)
                    let exdate = "License Expires on : \(newdatestring)"
                    let boldstring = "\(newdatestring)"
                    let attributedstring = NSMutableAttributedString(string: exdate)
                    attributedstring.setFont(forText: boldstring, fontsize: 16)
                    expire.attributedText = attributedstring
                }
            }
        }
    }
    
}

//MARK: Common Cell
class MyAccountCommonCell: UITableViewCell {
    
    var imageview: UIImageView!
    var title: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 2)
        accessoryType = .disclosureIndicator
        setCommonCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCommonCell() {
        imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.backgroundColor = .clear
        imageview.contentMode = .center
        addSubview(imageview)
        let imageveiwConstriants  = [imageview.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                     imageview.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     imageview.widthAnchor.constraint(equalToConstant: 30),
                                     imageview.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(imageveiwConstriants)
        
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Helvetica-Bold", size: 16)
        title.textColor = .darkGray
        title.text = "Title"
        addSubview(title)
        let titleConstraints = [title.leftAnchor.constraint(equalTo: imageview.rightAnchor, constant: 10),
                                title.centerYAnchor.constraint(equalTo: centerYAnchor),
                                title.heightAnchor.constraint(equalToConstant: 45),
                                title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)]
        
        NSLayoutConstraint.activate(titleConstraints)
    }
    
    var settitleForIndex: Int! {
        didSet {
            var titleText = ""
            var imagename = ""
            switch settitleForIndex {
            case 0:
                imagename = "Edit-user-profile"
                titleText = "Edit User Profile"
            case 1:
                imagename = "Edit-business-profile"
                titleText = "Edit Business Profile"
                
                let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
                if adminflag {
                    isHidden = false
                } else {
                   isHidden = true
                }
            case 2:
                imagename = "Signature"
                titleText = "Manage Signature"
            case 3:
                imagename = "Seal"
                titleText = "Manage Seal"
                
                let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
                if adminflag {
                    isHidden = false
                } else {
                    isHidden = false
                }
            case 4:
                imagename = "vcard"
                titleText = "Manage Business Card"
            case 5:
                imagename = "Password"
                titleText = "Change Password"
            case 6:
                imagename = "Manage-Biometric"
                titleText = "Manage Biometrics"
            case 7:
                imagename = "OTP"
                titleText = "Multi-factor Authentiction"
            case 8:
                imagename = "Save-tree"
                titleText = "Save a Tree - Plant a Tree"
            case 9:
                imagename = ""
                titleText = "Support"
            default:
                imagename = ""
                titleText = ""
            }
            
            imageview.image = UIImage(named: imagename)
            title.text = titleText
        }
    }
}

//MARK: Logout cell
class MyAccountLogoutCell: UITableViewCell {
    
    private var logoutLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 2)
        setLogionCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setLogionCell() {
        logoutLabel = UILabel()
        logoutLabel.translatesAutoresizingMaskIntoConstraints = false
        logoutLabel.backgroundColor = ColorTheme.btnBG
        logoutLabel.textColor = .white
        logoutLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        logoutLabel.textAlignment = .center
        logoutLabel.text = "LOG OUT"
        logoutLabel.adjustsFontSizeToFitWidth = true
        logoutLabel.minimumScaleFactor = 0.2
        addSubview(logoutLabel)
        
        let logoutlabelConstraints = [logoutLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                      logoutLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      logoutLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/2),
                                      logoutLabel.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(logoutlabelConstraints)
        
        logoutLabel.layer.cornerRadius = 5
        logoutLabel.layer.masksToBounds = true
    }
    
}


