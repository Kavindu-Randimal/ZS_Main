//
//  ForgotPasswordViewController.swift
//  ZorroSign
//
//  Created by Apple on 31/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPasswordViewController: BaseVC {

    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSubmit.layer.cornerRadius = 3
        btnSubmit.clipsToBounds = true
        
        setBottomText()
        setStyles()
    }

    func setBottomText() {
        
        
        let attributedString1 = NSMutableAttributedString(string: "Terms and Conditions")
        attributedString1.addAttribute(.link, value: "https://www.zorrosign.com/terms-and-conditions/", range: NSRange(location: 0, length: 20))
        
        let attributedString2 = NSMutableAttributedString(string: " | ")
        
        attributedString1.append(attributedString2)
        
        let attributedString3 = NSMutableAttributedString(string: "Privacy Policy")
        attributedString3.addAttribute(.link, value: "https://www.zorrosign.com/privacy-policy", range: NSRange(location: 0, length: 14))
        
        
        attributedString1.append(attributedString3)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.performSegue(withIdentifier: "segGotoLogin", sender: self)
    }
    @IBAction func btnSubmitAction(_ sender: Any) {
        let email: String = txtEmail.text!
        if txtEmail.text == "" || Singletone.shareInstance.isValidEmail(testStr: "\(email.trim())") == false
        {
            alertSample(strTitle: "", strMsg: "Please enter email")
        }
        else if Connectivity.isConnectedToInternet() == false
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        else
        {
            
            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            
            //let str: String = email.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let str: String  = (email.trim().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: "&", with: "%26").replacingOccurrences(of: "+", with: "%2B"))!
                
                //email.data(using: .utf8)//email.addingPercentEncoding(withAllowedCharacters: .)!
            
            print(str)
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/ResetPassword?userName=\(str)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: Singletone.shareInstance.headerAPIForgot)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    print(jsonObj)
                    if jsonObj["StatusCode"] == 3549
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        let alert = UIAlertController(title: "Forgot Password", message: "You have successfully made a request to reset the password. To complete the request, please check your Email.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                            action in
                            self.performSegue(withIdentifier: "segGotoLogin", sender: self)
                        }))
                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    {
                        Singletone.shareInstance.stopActivityIndicator()
                        self.alertSample(strTitle: "Forgot Password", strMsg: jsonObj["Message"].stringValue)
                        /*{
                         Data = 0;
                         Message = "User already exists in the system.";
                         StatusCode = 3510;
                         }*/
                    }
            }
        }
    }
    
    @available(iOS 10.0, *)
    @IBAction func btnTermsAndConditionAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/terms-and-conditions/")! as URL)
    }
    
    @available(iOS 10.0, *)
    @IBAction func btnPrivacyPolicyAction(_ sender: Any) {
        UIApplication.shared.open(NSURL(string:"https://www.zorrosign.com/privacy-policy")! as URL)
    }


}

extension ForgotPasswordViewController {
    private func setStyles() {
        viewEmail.layer.shadowRadius  = 1.5;
        viewEmail.layer.shadowColor   = UIColor.lightGray.cgColor
        viewEmail.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        viewEmail.layer.shadowOpacity = 0.9;
        viewEmail.layer.masksToBounds = false;
        viewEmail.layer.cornerRadius = 8
    }
}
