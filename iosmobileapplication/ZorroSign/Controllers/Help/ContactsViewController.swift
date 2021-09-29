//
//  ContactsViewController.swift
//  ZorroSign
//
//  Created by Apple on 31/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class ContactsViewController: BaseVC {

    @IBOutlet weak var tableViewContactDetails: UITableView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewCallUs: UIView!
    @IBOutlet weak var navTitle: UINavigationBar!
    
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
    
    @IBOutlet weak var viewFooter: UIView!
    
    var flagback: Bool = false
    
    @IBOutlet weak var btnTree: UIBarButtonItem!
    
    @IBOutlet weak var btnWn: UIBarButtonItem!
    var fromlogin: Bool = false
    
    
    private var helpTableView: UITableView!
    private let helpcellIdentifier1 = "helpcellidentifier1"
    private let helpcellIdentifier2 = "helpcellidentifier2"
    
    
    let arrEmailUS: [[String : String]] = [
        ["1" : "General Question:",
         "2" : "info@zorrosign.com"
        ],
        ["1" : "Help:",
         "2" : "support@zorrosign.com"
        ],
        ["1" : "Accounts & Billing:",
         "2" : "billing@zorrosign.com"
        ],
        ["1" : "Registering & Licensing:",
         "2" : "sales@zorrosign.com"
        ],
        ["1" : "About:",
         "2" : "Version: 1.0"
        ]
    ]
    
//    private let helpDetails = [["+1-855-ZORROSN (967-7676)"], ["General : info@zorrosign.com", "Help : support@zorrosign.com", "Accounts & Billing : billing@zorrosign.com", "Registering & Licensing : sales@zorrosign.com", "Careers : careers@zorrosign.com"], ["Privacy Policy", "Terms and Conditions"]]
    
    private let helpDetails = [["General : info@zorrosign.com", "Help : support@zorrosign.com", "Accounts & Billing : billing@zorrosign.com", "Careers : careers@zorrosign.com"], ["Privacy Policy", "Terms and Conditions"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        if fromlogin {
            notifIcon.image = nil
            notifIcon.badgeNumber = 0
            notifIcon.isEnabled = false
            
            btnTree.image = nil
            btnWn.image = nil
            
            btnTree.isEnabled = false
            btnWn.isEnabled = false
            
            menuBtn.image = UIImage(named: "Back")
            menuBtn.target = self
            menuBtn.action = #selector(ContactsViewController.menuAction(_:))
        }
        
        let _isloggedin = ZorroTempData.sharedInstance.getIsUserLoogged()
        if !_isloggedin {
            updateBadgeCount(count: 0)
        }
        
        setupHelpTableView()
        
        viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite.withAlphaComponent(0.1)
        viewBottomSearch.isUserInteractionEnabled = false
        
        viewEmail.layer.cornerRadius = 3
        viewEmail.clipsToBounds = true
        viewCallUs.layer.cornerRadius = 3
        viewCallUs.clipsToBounds = true
        
        self.navigationController?.isNavigationBarHidden = true
        
        if !fromlogin
        {
            viewFooter.isHidden = false
            navTitle.topItem?.title = "Help"
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            imgHelp.image = UIImage(named: "help_white_icon")
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
        }
        else
        {
            viewFooter.isHidden = true
        }
        
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


        if !fromlogin {
            getUnreadPushCount()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction func menuAction(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
//        performSegue(withIdentifier: "segWelcome", sender: self)
        
    }
    
    @IBAction func btnCallAction(_ sender: Any) {
        let email: String = "+18559677676"
        let url = URL(string: "tel:\(email)")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "footerFlag") == "Dashboard"
        {
            performSegue(withIdentifier: "segDashboard", sender: self)
        }
        else if UserDefaults.standard.string(forKey: "footerFlag") == "MyAccount"
        {
            performSegue(withIdentifier: "segMyAccount", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "segGotoLogin", sender: self)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrEmailUS.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableViewContactDetails.dequeueReusableCell(withIdentifier: "mycell")
//
//        let lblName: UILabel = cell?.viewWithTag(1) as! UILabel
//        let btnMailId: UIButton = cell?.viewWithTag(2) as! UIButton
//
//        lblName.text = arrEmailUS[indexPath.row]["1"]
//
//        if indexPath.row == 4 {
//
//            let version: String = "Version: " + UIApplication.appBuildVersion!
//            btnMailId.setTitle(version, for: .normal)
//
//        } else {
//
//            btnMailId.setTitle(arrEmailUS[indexPath.row]["2"], for: .normal)
//        }
//
//        if indexPath.row != 4 {
//            btnMailId.addTarget(self, action:#selector(buttonPressed(_:)), for:.touchUpInside)
//        }
//        return cell!
//    }
    
    @objc func buttonPressed(_ sender: AnyObject) {
        let button = sender as? UIButton
        let email: String = (button?.titleLabel!.text)!
        let url = URL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url!)
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
            
            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Contact", forKey: "footerFlag")
            performSegue(withIdentifier: "segDashboard", sender: self)
            
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
            
            UserDefaults.standard.set("Contact", forKey: "footerFlag")
            //viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen.withAlphaComponent(0.1)
            
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
            
            UserDefaults.standard.set("Contact", forKey: "footerFlag")
            
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
            
            UserDefaults.standard.set("Contact", forKey: "footerFlag")
            performSegue(withIdentifier: "segMyAccount", sender: self)

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
            
            UserDefaults.standard.set("Contact", forKey: "footerFlag")
            
            break
        default:
            break
        }
    }
}


extension ContactsViewController {
    fileprivate func setupHelpTableView() {
        
        helpTableView = UITableView(frame: .zero, style: .grouped)
        helpTableView.register(HelpCell.self, forCellReuseIdentifier: helpcellIdentifier1)
        helpTableView.register(UITableViewCell.self, forCellReuseIdentifier: helpcellIdentifier2)
        helpTableView.translatesAutoresizingMaskIntoConstraints = false
        helpTableView.dataSource = self
        helpTableView.delegate = self
        helpTableView.separatorStyle = .none
        helpTableView.tableFooterView = UIView()
        view.addSubview(helpTableView)
        
        let helptableviewCosntraints = [helpTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        helpTableView.topAnchor.constraint(equalTo: navTitle.bottomAnchor, constant: 0),
                                        helpTableView.rightAnchor.constraint(equalTo: view.rightAnchor)]
        
        NSLayoutConstraint.activate(helptableviewCosntraints)

        if fromlogin {
            helpTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        } else {
            helpTableView.bottomAnchor.constraint(equalTo: viewBottomDashborad.topAnchor, constant: 0).isActive = true
        }
        
    }
}

extension ContactsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 10:
            return 1
        case 0:
            return 4
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 10:
            let callcell = tableView.dequeueReusableCell(withIdentifier: helpcellIdentifier1) as! HelpCell
            callcell.infolabel.text = helpDetails[indexPath.section][indexPath.row]
            callcell.infolabel.font = UIFont(name: "Helvetica-Bold", size: 15)
            return callcell
        case 0:
            let callcell = tableView.dequeueReusableCell(withIdentifier: helpcellIdentifier1) as! HelpCell
            let attributeString = NSMutableAttributedString(string: helpDetails[indexPath.section][indexPath.row])
            let boldstring = helpDetails[indexPath.section][indexPath.row].components(separatedBy: ":")[1]
            attributeString.setFont(forText: boldstring, fontsize: 14)
            callcell.infolabel.attributedText = attributeString
            return callcell
        case 1:
            let callcell = tableView.dequeueReusableCell(withIdentifier: helpcellIdentifier1) as! HelpCell
            callcell.infolabel.text  = helpDetails[indexPath.section][indexPath.row]
            callcell.infolabel.font = UIFont(name: "Helvetica-Bold", size: 15)
            return callcell
        default:
            return UITableViewCell()
        }
    }
    
}

extension ContactsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 10:
            return 70
        case 0:
            return 70
        case 1:
            return 70
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let imageview = UIImageView(frame: CGRect(x: 20, y: 0, width: 30, height: 30))
        imageview.backgroundColor = .clear
        imageview.contentMode = .center
        headerview.addSubview(imageview)
        let label = UILabel(frame: CGRect(x: 70, y: 0, width: 100, height: 30))
        label.textColor = .darkGray
        headerview.addSubview(label)
        
        switch section {
        case 10:
            imageview.image = UIImage(named: "Phone")
            label.text = "CALL US"
            return headerview
        case 0:
            imageview.image = UIImage(named: "Email")
            label.text = "EMAIL US"
            return headerview
        case 1:
            imageview.image = UIImage(named: "General")
            label.text = "GENERAL"
            return headerview
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 10:
            guard let url = URL(string: "tel://+18559677676") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        case 0:
            let text = helpDetails[indexPath.section][indexPath.row]
            let email = text.components(separatedBy: ":")[1].trimmingCharacters(in: CharacterSet.whitespaces)
            guard let url = URL(string: "mailto:\(email)") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        case 1:
            if indexPath.row == 0 {
                guard let url = URL(string: "https://www.zorrosign.com/privacy-policy") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            } else {
                guard let url = URL(string: "https://www.zorrosign.com/terms-and-conditions/") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return
            }
        default:
            return
        }
    }
}

//MARK: defining contact cell here
class HelpCell: UITableViewCell {
    
    private var containerView: UIView!
    var infolabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HelpCell {
    func setsubViews() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        addSubview(containerView)
        
        let containerviewConstraints = [containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                                        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(containerviewConstraints)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        
        infolabel = UILabel()
        infolabel.translatesAutoresizingMaskIntoConstraints = false
        infolabel.adjustsFontSizeToFitWidth = true
        infolabel.minimumScaleFactor = 0.2
        infolabel.font = UIFont(name: "Helvetica", size: 14)
        infolabel.textColor = .darkGray
        containerView.addSubview(infolabel)
        
        let infolabelconstraints = [infolabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                    infolabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                                    infolabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                    infolabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)]
        
        NSLayoutConstraint.activate(infolabelconstraints)
        
    }
}

