//
//  BaseVC.swift
//  ZorroSign
//
//  Created by Apple on 13/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

protocol DropDownDelegate {
    func onSelectOption(selOpt: Int, type: String)
   
}
class BaseVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, SwiftAlertViewDelegate, BannerDelegate {
    
    var delegate: DropDownDelegate?
    var pickerDataArray:[String] = []
    var selType: String = ""
    var selPickerRow: Int = 0
    let container1: UIView = UIView()
    let loadingView1: UIView = UIView()
    let actInd1: UIActivityIndicatorView = UIActivityIndicatorView()
    var bannerView: BannerView = BannerView()

    @IBOutlet weak var menuBtn: UIBarButtonItem!
    @IBOutlet weak var notifIcon: BadgeBarButtonItem!

    var whtsFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            menuBtn?.target = self.revealViewController()
            menuBtn?.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            NotificationCenter.default.addObserver(self, selector: #selector(appcameforground), name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.notifIcon != nil {
            notifIcon.badgeNumber = UIApplication.shared.applicationIconBadgeNumber
            print("WWORKING FINE")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func appcameforground() {
        if self.notifIcon != nil {
            notifIcon.badgeNumber = UIApplication.shared.applicationIconBadgeNumber
            print("WWORKING FINE")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func showDropDown(optArr: [String], type: String) {
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if optArr.count > 0 {
            for option in optArr {
                alert.addAction(UIAlertAction(title: option, style: .default, handler: { (action) -> Void in
                    self.onSelectOption(selOpt: option, type: type)
                }))
                
            }
        }
        alert.addAction(UIAlertAction(title: "Close", style: .destructive, handler: nil))
        self.present(alert, animated: true)
    }
    
    func customDropDown(optArr: [String]) {
        
    }
    func onSelectOption(selOpt: String, type: String) {
        
    }
    func onSelectFontOption(selOpt: Int, type: String) {
        
    }
    
    func onCancelOption() {
        
    }
    
    func setPickerData(dataArr: [String], type: String) {
        pickerDataArray = dataArr
        selType = type
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            if selType == "fontOpt" || selType == "initialFontOpt" {
                
                pickerLabel?.font = UIFont(name: Singletone.shareInstance.fontArray[row], size: 20)
            } else {
                pickerLabel?.font = UIFont.systemFont(ofSize: 20)
            }
            pickerLabel?.textAlignment = .center
        }
        if pickerDataArray.count > row {
        
            pickerLabel?.text = pickerDataArray[row] as! String
        }
            pickerLabel?.textColor = UIColor.black
        
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selPickerRow = row
        self.onSelectFontOption(selOpt: row, type: selType)
    }
    
    func addDoneButton() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker))
        
        let btndone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: Selector(("donePicker")))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.backgroundColor = UIColor.blue
        

        return toolBar
    }
    
    @objc func donePicker (sender: UIBarButtonItem) {
        self.onSelectFontOption(selOpt: selPickerRow, type: selType)
    }
    
    @objc func cancelPicker (sender: UIBarButtonItem) {
        self.onCancelOption()
    }
    
    func showActivityIndicatory(uiView: UIView) {
        
        
        self.container1.isHidden = false
        container1.frame = uiView.frame
        container1.center = uiView.center
        container1.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
        
        self.loadingView1.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.loadingView1.center = uiView.center
        self.loadingView1.backgroundColor = .clear//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)//UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
        self.loadingView1.clipsToBounds = true
        self.loadingView1.layer.cornerRadius = 10
        
        self.actInd1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.actInd1.style = UIActivityIndicatorView.Style.whiteLarge
        self.actInd1.color = ColorTheme.activityindicator
        self.actInd1.center = CGPoint(x: self.loadingView1.frame.size.width / 2, y: self.loadingView1.frame.size.height / 2)
//        let lblWait: UILabel = UILabel()
//        lblWait.text = "Loading"
//        lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
//        lblWait.font = lblWait.font.withSize(13)
//        lblWait.textAlignment = .center
//        lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
//        self.loadingView1.addSubview(lblWait)
        
        self.loadingView1.addSubview(self.actInd1)
        container1.addSubview(self.loadingView1)
        uiView.addSubview(container1)
        
        self.actInd1.startAnimating()
    }
    
    func stopActivityIndicator()
    {
        DispatchQueue.main.async {
            self.actInd1.stopAnimating()
            self.actInd1.hidesWhenStopped = true
            self.container1.isHidden = true
        }
    }
    
    func showCustomAlert() {
        
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let myAlert = storyboard.instantiateViewController(withIdentifier: "alert") as! AlertViewContoller
         myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
         myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        
        if self.notifIcon != nil {
            notifIcon.badgeNumber = UIApplication.shared.applicationIconBadgeNumber
            print("WWORKING FINE")
        }
        
         self.present(myAlert, animated: true, completion: nil)
 
    }
    
    //MARK: - Set subscription banner title
    func setTitleForSubscriptionBanner() {
        SubscriptionBanners.shared.getTitleForSubscriptionBanner { (message, upgrade) in
            if message != "" {
                self.setUpBanner(title: message, upgrade: upgrade)
            }
        }
    }
    
    //MARK: - Add the banner
    func setUpBanner(title: String, upgrade: Bool) {
        let safearea = self.view.safeAreaLayoutGuide
        bannerView = (Bundle.main.loadNibNamed("BannerView", owner: self, options: nil)?.first as? BannerView)!
        bannerView.delegate = self
        bannerView.title = title
        bannerView.cangotoSubscription = upgrade
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.backgroundColor = ColorTheme.lblBody
        self.view.addSubview(bannerView)
        self.view.bringSubviewToFront(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: safearea.topAnchor),
            bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    //MARK: - BannerView Delegate
    func dismissBanner() {
        bannerView.removeFromSuperview()
        ZorroTempData.sharedInstance.setBannerClose(isClosed: true)
    }
    
    //MARK: - BannerView Delegate Navigate to Subscription Page
    func navigatetoSubscription() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Subscription", bundle:nil)
        let subscriptionVC = storyBoard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        subscriptionVC.isFromMyAccountOrBanner = true
        self.navigationController?.pushViewController(subscriptionVC, animated: true)
    }
    
    func getVC(sbId: String) -> UIViewController{
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: sbId)
        return vc
    }
    
    func navigateToVc(sbId: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: sbId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func dateToString(date:Date, dtFormat:String, strFormat:String) -> String {
        
        if date != nil {
            
        
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = dtFormat //2018-01-02T05:53:06
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = strFormat
        
            let formattedDate = dateFormatterPrint.string(from: date)
        
            print(formattedDate)
            return formattedDate
            
        }
        return ""
    }

    @available(iOS 10.0, *)
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        UIApplication.shared.open(URL, options: [:])
        
        return false
    }
    
    @IBAction func dontShowAgainAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            UserDefaults.standard.set(true, forKey: "dontshowagain")
        } else {
            UserDefaults.standard.set(false, forKey: "dontshowagain")
        }
        callDontShowAPI()
    }
    
    func updateBadgeCount(count: Int) {
        UIApplication.shared.applicationIconBadgeNumber = count
    }
    
    func getUnreadPushCount() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        guard let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken") else {
            self.stopActivityIndicator()
            return
            
        }
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let deviceId: String = UserDefaults.standard.string(forKey: "deviceId") ?? ""
        let api = "api/v1/Notification/GetUserUnreadPushNotificationsCount?deviceId=\(deviceId)"
        
        let apiURL = Singletone.shareInstance.apiNotification + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    DispatchQueue.main.async {
                        
                        self.stopActivityIndicator()
                        
                        let jsonObj: JSON = JSON(response.result.value)
                            print("notification response: \(jsonObj)")
                            let data = jsonObj["Data"].intValue
                            self.updateBadgeCount(count: data)
                            if self.notifIcon != nil  && data > 0 {
                                //self.notifIcon.addBadge(number: data, withOffset: CGPoint(x: 10, y: 10), andColor: UIColor.red, andFilled: true)
                                self.notifIcon.badgeNumber = data
                            }
                        
                    }
                    
                    
                   
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func callDontShowAPI(){
    
        //https://zsdemowebuser.zorrosign.com/api/UserManagement/ToggleWelcomeVisible?isVisible=false
    
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
       
        let visible = UserDefaults.standard.bool(forKey: "dontshowagain")
        let visibleStr = String(!visible)
        
        let apiBase = Singletone.shareInstance.apiURL
        let api = "UserManagement/ToggleWelcomeVisible?isVisible=\(visibleStr)"
        
        if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            //Singletone.shareInstance.showActivityIndicatory(uiView: view)
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiBase+api)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    guard let response = response as? DataResponse<Any> else {
                        return
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                        }
                        else
                        {
                            //Singletone.shareInstance.stopActivityIndicator()
                            //self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                        }
                    
//                    else
//                    {
                        //Singletone.shareInstance.stopActivityIndicator()
                        //self.alertSample(strTitle: "", strMsg: "Error from server")
//                    }
                    
            }
        }
    }
    
    func updateReadStatus(notifData: NotificationData) {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "api/v1/Notification/UpdateMessageStatus"
        
        let apiURL = Singletone.shareInstance.apiNotification + api
        
        let parameters = [["MessageId": notifData.Id!,
                           "IsDeleted": false,
                           "IsRead": notifData.IsRead]]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        if UIApplication.shared.applicationIconBadgeNumber > 0 {
                            if notifData.IsRead {
                                UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
                            }
                        }
                        if !notifData.IsRead {
                            UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
                        }
                    
            }
        }
    }
    
    @IBAction func WhatsNewAction() {
        
        whtsFlag = true
        let whtsvc = getVC(sbId: "WhatsNew_SBID")
        self.present(whtsvc, animated: false, completion: nil)
        
    }
    
    @IBAction func saveTree() {
        self.performSegue(withIdentifier: "saveTreeSegue", sender: self)
    }
    
    func addFooterView() {
        
        let arr = Bundle.main.loadNibNamed("FooterView", owner: self, options: nil)
        let footerView = arr?[0] as? UIView
        
        let viewBottomDashborad = footerView?.viewWithTag(100)
        let viewBottomSearch = footerView?.viewWithTag(102)
        let viewBottomMyAccount = footerView?.viewWithTag(103)
        let viewBottomHelp = footerView?.viewWithTag(104)
        
        //viewBottomSearch?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        //Singletone.shareInstance.topViewBackgroundGray.withAlphaComponent(0.1)
        viewBottomSearch?.isUserInteractionEnabled = false
        
        //viewBottomMyAccount?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        //imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
        //lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
        //lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
        //imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
        //viewBottomDashborad?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        //viewBottomHelp?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        
        let gestureDashboard = UITapGestureRecognizer(target: self, action:  #selector(self.footerAction))
        let gestureSearch = UITapGestureRecognizer(target: self, action:  #selector(self.footerAction))
        let gestureMyAccount = UITapGestureRecognizer(target: self, action:  #selector(self.footerAction))
        let gestureHelp = UITapGestureRecognizer(target: self, action:  #selector(self.footerAction))
        
        viewBottomDashborad?.addGestureRecognizer(gestureDashboard)
        //viewBottomStart.addGestureRecognizer(gestureStart)
        viewBottomSearch?.addGestureRecognizer(gestureSearch)
        viewBottomMyAccount?.addGestureRecognizer(gestureMyAccount)
        viewBottomHelp?.addGestureRecognizer(gestureHelp)
        
        
        self.view.addSubview(footerView!)
        /*
        footerView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        footerView?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        footerView?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        */
        let leadingConstraint = NSLayoutConstraint(item: footerView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute:NSLayoutConstraint.Attribute.leading, multiplier: 1, constant: 0)
        
        let trailingConstraint = NSLayoutConstraint(item: footerView, attribute: NSLayoutConstraint.Attribute.trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute:NSLayoutConstraint.Attribute.trailing, multiplier: 1, constant: 0)
        
        var verticalConstraint:NSLayoutConstraint!
        
        if #available(iOS 11.0, *) {
            verticalConstraint = NSLayoutConstraint(item: footerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view.safeAreaLayoutGuide, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        } else {
            // Fallback on earlier versions
            verticalConstraint = NSLayoutConstraint(item: footerView, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: 0)
        }
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, verticalConstraint])
        
    }
    
    @objc func footerAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        
        switch s! {
        case 100:
            
            performSegue(withIdentifier: "segDashboard", sender: self)
            
            break
        
        case 102:
           
            
            break
        case 103:
            
            performSegue(withIdentifier: "segMyAccount", sender: self)
            
            break
        case 104:
            
            performSegue(withIdentifier: "segContactUs", sender: self)
            
            break
        default:
            break
        }
    }
    
    func didDismissAlertView(alertView: SwiftAlertView) {
        
    }
    
    @IBAction func showNotifications() {
        
        performSegue(withIdentifier: "segNotif", sender: self)
        
    }
    
    override var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return [.portrait, .landscapeLeft]
            
        }
    }
}

extension UITextView {
    
    func setBorder() {
        self.layer.borderColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1).cgColor
        self.layer.borderWidth = 1.0
    }
}

extension CharacterSet {
    static let rfc3986Unreserved = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~")
    
}

// Declare `-` operator overload function
func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
    return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

func divide(val1: CGPoint, divider: Int) -> CGPoint {
   
    let s = CGFloat(divider)
    return CGPoint(x: val1.x/s, y: val1.y/s)
}

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}


