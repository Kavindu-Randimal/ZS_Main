//
//  ChangePassViewController.swift
//  ZorroSign
//
//  Created by Apple on 20/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChangePassViewController: BaseVC, ValidatorDelegate {

    @IBOutlet  var views: [UIView]!
    @IBOutlet weak var viewTC: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtnewpass: UITextField!
    
    @IBOutlet weak var txtcnfpass: UITextField!
    
    @IBOutlet weak var btnSubmit: UIButton!
    
    @IBOutlet weak var logoTop: NSLayoutConstraint!
    @IBOutlet weak var currentpasswordTop: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }

        // Do any additional setup after loading the view.
        setStyles()
        addFooterView()
        btnSubmit.layer.cornerRadius = 3
        btnSubmit.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }

    @IBAction func btnBackAction(_ sender: Any) {
        //self.performSegue(withIdentifier: "segCancel", sender: self)
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnSubmitAction(_ sender: Any) {
        let email: String = txtEmail.text!
        if txtEmail.text == ""
        {
            alertSample(strTitle: "", strMsg: "Please enter current password")
        }
        else if txtnewpass.text == ""
        {
            alertSample(strTitle: "", strMsg: "Please enter new password")
        }
        else if !isValidPassword(password: txtnewpass.text!) {
            alertSample(strTitle: "", strMsg: "Please enter a valid password")
        }
        else if txtcnfpass.text == ""
        {
            alertSample(strTitle: "", strMsg: "Please enter password again")
        }
        else if txtcnfpass.text != txtnewpass.text
        {
            alertSample(strTitle: "", strMsg: "Passwords do not match")
        }
        else if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            /*{
             "UserName": "ruwan+bis1@entrusttitle.com",
             "Password": "11111111!A",
             "ClientId": "123456",
             "ClientSecret": "abcdef",
             "DoNotSendActivationMail": true
             }*/
//            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            
            //let str: String = email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let str: String  = (email.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B"))!
            
            //email.data(using: .utf8)//email.addingPercentEncoding(withAllowedCharacters: .)!
            let username:String = UserDefaults.standard.value(forKey: "UserName") as! String
            let olpass:String = txtEmail.text!
            let newpass:String = txtnewpass.text!
            let cnfpass:String = txtcnfpass.text!
            
            let parameters = ["UserName": username,
                              "OldPassword": olpass,
                              "NewPassword": newpass,
                              "ConfirmNewPassword": cnfpass] as [String : Any]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            
            print(jsonString)
            
           self.showActivityIndicatory(uiView: self.view)
            
            let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
            let headerAPIDashboard = ["Content-Type": "application/json", "Authorization" : "Bearer \(strAuth)"]
            
            print(str)
            /*
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/ChangePassword")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    print(jsonObj)
                    if jsonObj["StatusCode"] == 3000
                    {
                        self.stopActivityIndicator()
                    }
                    else
                    {
                        self.stopActivityIndicator()
                        self.alertSample(strTitle: "Change Password", strMsg: jsonObj["Message"].stringValue)
                       
                    }
            }
             */
            
            do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: URL(string: Singletone.shareInstance.apiURL + "Account/ChangePassword")!,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerAPIDashboard
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                self.stopActivityIndicator()
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        
                        print(jsonObj)
                        if jsonObj["StatusCode"] as! Int == 1000
                        {
                            DispatchQueue.main.async {
//                                self.stopActivityIndicator()
                                
                                //self.alertSample(strTitle: "Change Password", strMsg: (jsonObj["Message"])! as! String)
                                self.gotoLogin(msg: jsonObj["Message"]! as! String)
                            }
                        }
                        else
                        {
//                            self.alertSample(strTitle: "Change Password", strMsg: (jsonObj["Message"])! as! String)
                            DispatchQueue.main.async {
                                
                                self.showalert(msg: (jsonObj["Message"])! as! String)
                            }
                            
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                }
            })
                dataTask.resume()
            } catch {}
            
        }
    }
    
    @objc func showalert(msg: String) {
        AlertProvider.init(vc: self).showAlert(title: "Change Password", message: msg, action: AlertAction(title: "Dismiss"))
    }
    
    @objc func gotoLogin(msg: String) {
       
        let alert = UIAlertController(title: "Change Password", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            NotificationCenter.default.post(name: .userDidLogout, object: nil)
        }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @available(iOS 10.0, *)
    @IBAction func btnTermsAndConditionAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/terms-and-conditions/")! as URL)
    }
    
    @available(iOS 10.0, *)
    @IBAction func btnPrivacyPolicyAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/privacy-policy")! as URL)
    }
}

extension ChangePassViewController {
    fileprivate func setStyles() {
        
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIScreen.main.bounds.height == 568 {
                logoTop.constant = 50
                currentpasswordTop.constant = 40
            }
            
            if UIScreen.main.bounds.height == 667 {
                logoTop.constant = 80
                currentpasswordTop.constant = 60
            }
            
            if UIScreen.main.bounds.height == 736 {
                logoTop.constant = 80
                currentpasswordTop.constant = 100
            }
            
            if UIScreen.main.bounds.height == 812  {
                logoTop.constant = 110
                currentpasswordTop.constant = 80
            }
            
            if UIScreen.main.bounds.height == 896 {
                logoTop.constant = 110
                currentpasswordTop.constant = 100
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            logoTop.constant = 200
            currentpasswordTop.constant = 150
        }
        
        
        
        
        for view in views {
            view.layer.shadowRadius  = 1.5;
            view.layer.shadowColor   = UIColor.lightGray.cgColor
            view.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
            view.layer.shadowOpacity = 0.9;
            view.layer.masksToBounds = false;
            view.layer.cornerRadius = 8

        }
    }
}
