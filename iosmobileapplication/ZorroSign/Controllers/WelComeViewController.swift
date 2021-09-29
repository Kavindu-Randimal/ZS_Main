//
//  WelComeViewController.swift
//  ZorroSign
//
//  Created by Apple on 24/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader
import Crashlytics

class WelComeViewController: BaseVC, QRCodeReaderViewControllerDelegate {

    @IBOutlet weak var btnReadToken: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var btnContact: UIButton!
    @IBOutlet weak var txtTerms: UITextView!
    
    @IBOutlet weak var contentview: UIView!
    
    @IBOutlet weak var con_viewW: NSLayoutConstraint!
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Device.IS_IPAD {
            con_viewW.constant = 700
        } else {
            con_viewW.constant = 350
        }
        
        btnReadToken.layer.cornerRadius = 3
        btnReadToken.clipsToBounds = true
        btnLogin.layer.cornerRadius = 3
        btnLogin.clipsToBounds = true
        btnSignUp.layer.cornerRadius = 3
        btnSignUp.clipsToBounds = true
        btnContact.layer.cornerRadius = 3
        btnContact.clipsToBounds = true
        
        setBottomText()
        self.navigationController?.isNavigationBarHidden = true
        UserDefaults.standard.removeObject(forKey: "footerFlag")
        
        btnReadToken.addTarget(self, action: #selector(readToken), for: UIControl.Event.touchUpInside)
        
        resetUserDefaults()
        
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)*/
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }
    
    func resetUserDefaults() {
    
        UserDefaults.standard.set("", forKey: "ServiceToken")
        UserDefaults.standard.set("", forKey: "UserName")
        UserDefaults.standard.set("", forKey: "ProfileId")
        UserDefaults.standard.set("", forKey: "OrgProfileId")
        UserDefaults.standard.set("", forKey: "FullName")
        UserDefaults.standard.set("", forKey: "ProfileStatus")
        UserDefaults.standard.set("", forKey: "OrganizationId")
        UserDefaults.standard.set("", forKey: "UserSign")
        UserDefaults.standard.set("", forKey: "UserSign1")
        UserDefaults.standard.set("", forKey: "UserSign2")
        UserDefaults.standard.set("", forKey: "UserSign3")
        UserDefaults.standard.set("", forKey: "UserInitial")
        UserDefaults.standard.set("", forKey: "UserInitial1")
        UserDefaults.standard.set("", forKey: "UserInitial2")
        UserDefaults.standard.set("", forKey: "UserInitial3")
        UserDefaults.standard.set(0, forKey: "UserSignId")
        UserDefaults.standard.set("", forKey: "Email")
        UserDefaults.standard.set("", forKey: "UserSign")
        UserDefaults.standard.set("", forKey: "Company")
        UserDefaults.standard.set("", forKey: "JobTitle")
        UserDefaults.standard.set("", forKey: "Email")
        UserDefaults.standard.set("", forKey: "Phone")
        UserDefaults.standard.set("", forKey: "FName")
        UserDefaults.standard.set("", forKey: "LName")
        UserDefaults.standard.set("", forKey: "MName")
        UserDefaults.standard.set(0, forKey: "UserType")
        UserDefaults.standard.set("", forKey: "qrcode")
        
        Singletone.shareInstance.signObjectArray = []
    }
    
    func setBottomText() {
        let attributedString = NSMutableAttributedString(string: "www.ZorroSign.com")
        
        attributedString.addAttribute(.link, value: "https://www.ZorroSign.com", range: NSRange(location: 0, length: 17))
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 17))
        attributedString.addAttribute(.underlineColor, value: UIColor.black, range: NSRange(location: 0, length: 17))
        
        
        let sep1 = NSAttributedString(string: " | ")
        
        attributedString.append(sep1)
        
        let attributedString1 = NSMutableAttributedString(string: "Info@ZorroSign.com")
        attributedString1.addAttribute(.link, value: "mailto:Info@ZorroSign.com", range: NSRange(location: 0, length: 18))
        attributedString1.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 18))
        attributedString1.addAttribute(.underlineColor, value: UIColor.black, range: NSRange(location: 0, length: 18))
        
        attributedString.append(attributedString1)
        
        let sep2 = NSAttributedString(string: " | ")
        
        attributedString.append(sep2)
        
        let attributedString2 = NSMutableAttributedString(string: "1-855-ZORROSN (967-7676)")
        attributedString2.addAttribute(.link, value: "tel:18559677676", range: NSRange(location: 0, length: 24))
        attributedString2.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 24))
        attributedString.append(attributedString2)
        
        let sep3 = NSAttributedString(string: "\n")
        
        attributedString.append(sep3)
        
        let attributedString3 = NSMutableAttributedString(string: "Privacy Policy")
        attributedString3.addAttribute(.link, value: "https://www.zorrosign.com/privacy-policy", range: NSRange(location: 0, length: 14))
        attributedString3.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 14))
         attributedString3.addAttribute(.underlineColor, value: UIColor.black, range: NSRange(location: 0, length: 14))
        
        attributedString.append(attributedString3)
        
        let sep4 = NSAttributedString(string: " | ")
        
        attributedString.append(sep4)
        
        let attributedString4 = NSMutableAttributedString(string: "Terms and Conditions")
        attributedString4.addAttribute(.link, value: "https://www.zorrosign.com/terms-and-conditions/", range: NSRange(location: 0, length: 20))
        attributedString4.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 20))
         attributedString4.addAttribute(.underlineColor, value: UIColor.black, range: NSRange(location: 0, length: 20))
        
        
        attributedString.append(attributedString4)
        
        txtTerms.attributedText = attributedString
        txtTerms.textAlignment = NSTextAlignment.center
    }
    
    
    
    func callAction() {
        let email: String = "+18559677676"
        let url = URL(string: "tel:\(email)")
        UIApplication.shared.openURL(url!)
    }
    
    func mailAction(url:String) {
        let email: String = url
        let url = URL(string: "mailto:\(email)")
        UIApplication.shared.openURL(url!)
    }
    
    @IBAction func readToken(_ sender: UIButton) {
        
        // Retrieve the QRCode content
        // By using the delegate pattern
        readerVC.delegate = self
        
        // Or by using the closure pattern
        readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print(result)
        }
        
        // Presents the readerVC as modal form sheet
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - QRCodeReaderViewController Delegate Methods
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        
        UserDefaults.standard.set(result.value, forKey: "qrcode")
        
        UserDefaults.standard.set(result.value, forKey: "scannedqrcode")
        
        dismiss(animated: true, completion: {
            // check login
            /*if let ProfileId = UserDefaults.standard.value(forKey: "ProfileId") as? String {
                self.performSegue(withIdentifier: "document", sender: self)
            } else {*/
                self.showLoginPopup()
            //}
        })
        
        
        
        
    }
    
    //This is an optional delegate method, that allows you to be notified when the user switches the cameraName
    //By pressing on the switch camera button
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName as? String {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func showLoginPopup() {
        
        let alert = UIAlertController(title: "Authenticate", message: "Login to continue", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Authenticate", style: .default, handler: {
            action in
            self.performSegue(withIdentifier: "gotoLogin", sender: self)
        }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showContactsVC() {
        //Help_SBID
        let helpvc = self.getVC(sbId: "Help_SBID") as! ContactsViewController
        helpvc.flagback = true
        self.navigationController?.pushViewController(helpvc, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
