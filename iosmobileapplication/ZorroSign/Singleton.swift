//
//  Singleton.swift
//  ZorroSign
//
//  Created by Apple on 28/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

class Singletone
{
    static let shareInstance = Singletone()
    
    let thumbBaseURL = "https://s3.amazonaws.com/zfpi/"
    let deviceType = "iOS"
    let app_specific_shared_secret = "94731fcd207c429ab30403d7ab0cf138"
    
    // Prod APIS
    
    var clientId = "kLKTCwa_oGLULzPqvyhW"
    var clientSecret = "xGLGRdF_WREZSp1IKt_W5f51p5CFURpJqJpoxe6_"
    
    var apiURL = "https://webuser.zorrosign.com/api/"
    var headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
    var headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
    
    var apiSign = "https://webuser.zorrosign.net/"
    var apiDoc = "https://web4n6token.zorrosign.net/"
    var apiUserService = "https://webworkflow.zorrosign.net/api/"
    var apiSubscription = "https://websubscription.zorrosign.net/api/"
    var apiNotification = "https://webnotification.zorrosign.net/"
    var weburl = "https://app.zorrosign.net"
    var apiAccount = "https://accounts.zorrosign.net/"
    var audittrailDoc = "https://zsprocessdocdownload.zorrosign.net/api/"
    var apiIAPTransaction = "https://applenotification.zorrosign.net/"
    var verifyReceiptProd = "https://buy.itunes.apple.net/verifyReceipt"
    var verifyReceiptSandbox = "https://sandbox.itunes.apple.net/verifyReceipt"
    
    
    // MARK: - Set Environment
    
    func setEnvironment(id: Int) {
        
        switch id {
        case 1:
            // Prod APIs
            
            clientId = "kLKTCwa_oGLULzPqvyhW"
            clientSecret = "xGLGRdF_WREZSp1IKt_W5f51p5CFURpJqJpoxe6_"
            
            apiURL = "https://webuser.zorrosign.net/api/"
            headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
            headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
            
            apiSign = "https://webuser.zorrosign.net/"
            apiDoc = "https://web4n6token.zorrosign.net/"
            apiUserService = "https://webworkflow.zorrosign.net/api/"
            apiSubscription = "https://websubscription.zorrosign.net/api/"
            apiNotification = "https://webnotification.zorrosign.net/"
            weburl = "https://app.zorrosign.net"
            apiAccount = "https://accounts.zorrosign.net/"
            audittrailDoc = "https://zsprocessdocdownload.zorrosign.net/api/"
            break
        case 2:
            // QA
            
            clientId = "123456"
            clientSecret = "abcdef"
            
            apiURL = "https://zswebuserqa.entrusttitle.net/api/"
            headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
            headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
            
            apiSign = "https://zswebuserqa.entrusttitle.net/"
            apiDoc = "https://zswebtokenqa.entrusttitle.net/"
            apiUserService = "https://zswebworkflowqa.entrusttitle.net/api/"
            apiSubscription = "https://zswebsubscriptionqa.entrusttitle.net/api/"
            apiNotification = "https://zswebnotificationqa.entrusttitle.net/"
            weburl = "https://app.zorrosign.com"
            apiAccount = "https://zsaccountsqa.entrusttitle.net/"
            audittrailDoc = "https://zsqaprocessdocdownload.entrusttitle.net/api/"
            break
        case 3:
            // Dev APIs
            
            clientId = "123456"
            clientSecret = "abcdef"
            
            apiURL = "http://zswebuserlocal.entrusttitle.net/api/"
            headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
            headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
            
            apiSign = "http://zswebuserlocal.entrusttitle.net/"
            apiDoc = "http://zswebtokenlocal.entrusttitle.net/"
            apiUserService = "http://zswebworkflowlocal.entrusttitle.net/api/"
            apiSubscription = "http://zswebsubscriptionlocal.entrusttitle.net/api/"
            apiNotification = "http://zswebnotificationlocal.entrusttitle.net/"
            weburl = "http://app.entrusttitle.net"
            apiAccount = "http://zsaccountslocal.entrusttitle.net/"
            audittrailDoc = "http://zsprocessdocdownloadlocal.entrusttitle.net/api/"
            break
        case 4:
            // Sandbox APIs
            
            clientId = "nZODnH8ypIf_el51jlkd"
            clientSecret = "HSsAylqi_wYy1rXwx_77Eg7TzDUxBY2kyek6q9Ns"
            
            apiURL = "https://sandboxuser.zorrosign.com/api/"
            headerAPI = ["API_Key_UserRegistration": "oyuJ56Cw48glGfYjsNI3JlvJxLBjkwAs"]
            headerAPIForgot = ["API_Key_PasswordReset": "zQHyDbqqAvSE9wvzxF4PbLcYKVonFCvo"]
            
            apiSign = "https://sandboxuser.zorrosign.com/"
            apiDoc = "https://sandboxtoken.zorrosign.com/"
            apiUserService = "https://sandboxworkflow.zorrosign.com/api/"
            apiSubscription = "https://sandboxsubscription.zorrosign.com/api/"
            apiNotification = "https://sandboxnotification.zorrosign.com/"
            weburl = "https://app.entrusttitle.net"
            apiAccount = "https://sandboxaccounts.zorrosign.com/"
            audittrailDoc = "https://sandboxprocessdocdownload.zorrosign.com/api/"
            break
        case 5:
            // Pre Prod APIs
            
            clientId = "KJc9dfMJh4FI2Y6W"
            clientSecret = "HrfXHbUytwDCTLHTqPDUtqCYK3T2NxI8"
            
            apiURL = "https://zsppwebuser.entrusttitle.net/api/"
            headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
            headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
            
            apiSign = "https://zsppwebuser.entrusttitle.net/"
            apiDoc = "https://zsppweb4n6token.entrusttitle.net/"
            apiUserService = "https://zsppwebworkflow.entrusttitle.net/api/"
            apiSubscription = "https://zsppwebsubscription.entrusttitle.net/api/"
            apiNotification = "https://zsppwebnotification.entrusttitle.net/"
            weburl = "https://zsppapp.entrusttitle.net"
            apiAccount = "https://zsppaccounts.entrusttitle.net/"
            audittrailDoc = "https://zsppprocessdocdownload.entrusttitle.net/api/"
            break
        default:
            break
        }
    }
    
    
    
    // Prod APIs
    
    
    
    // QA APIS
    
    // Demo v2 APIs
    
    /*
     let clientId = "123456"
     let clientSecret = "abcdef"
     
     let apiURL = "https:zsdemov2webuser.zorrosign.com/api/"
     let headerAPI = ["API_Key_UserRegistration": "Vl21fnencNI8ZBkjeu92JSuWcMCG6JNO"]
     let headerAPIForgot = ["API_Key_PasswordReset": "GUnZSSsb9gXT43fIlk81qBSiIhQ8ptY8"]
     
     let apiSign = "https:zsdemov2webuser.zorrosign.com/"
     
     let apiDoc = "https:zsdemov2webtoken.zorrosign.com/"
     
     let apiUserService = "https:zsdemov2webworkflow.zorrosign.com/api/"
     
     let apiSubscription = "https:zsdemov2websubscription.zorrosign.com/api/"
     
     let apiNotification = "https:zsdemov2webnotification.zorrosign.com/"
     
     */
    
    
    
    
    // Dev APIs
    
    
    
    let dashboardCheckboxSelect = UIImage(named: "checkbox_sel_black")
    let dashboardCheckboxDeselect = UIImage(named: "checkbox_black")
    
    var userInfo = (id : 1, password : 000)
    
    let footerviewBackgroundGreen = UIColor(named: "BtnBG") ?? UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1.0)
    let footerviewBackgroundWhite = UIColor.white ?? UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
    
    let topViewBackgroundGray = UIColor(red: 123/255, green: 123/255, blue: 123/255, alpha: 1.0)
    
    var container: UIView!
    var loadingView: UIView!
    var actInd: UIActivityIndicatorView!
    
    // ManageSign VC arrays
    let signArray = ["Signature 01","Signature 02","Signature 03"]
    let signOptArray = ["Computer Generated","Handwritten"]
    let signOptDict = ["cg","hr"]
    let fontOptArray = ["Pacifico","Satisfy-Regular","HomemadeApple-Regular","OvertheRainbow","Tangerine-Regular","BadScript-Regular","SignericaMedium","Scotosaurus","MySillyWillyGirl","NellaSueDemo"]
    //BadScript-Regular
    //["Signerica Medium","Scotosaurus","NellaSueDemo","MySillyWillyGirl"]
    let fontArray = ["Pacifico","Satisfy-Regular","HomemadeApple-Regular","OvertheRainbow","Tangerine-Regular","BadScript-Regular","SignericaMedium","Scotosaurus","MySillyWillyGirl","NellaSueDemo"]
    let saveOptArray = ["As Trustee Of","Alternative Signature","On Behalf Of","Other"]
    
    #if !AuditTrailClip
    var signObjectArray: [SignObject] = []
    #endif
    
    let acceptableCharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz. "
    let stringCharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    let stringSpaceCharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    let alphaNumCharset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let numCharset = "0123456789-"
    let numset = "0123456789"
    
    // Tags arr
    let tagsNameByType = [0:"Signature",1:"Initials",2:"Seal",3:"Text",4:"Date",5:"Title",6:"Token",7:"Comment",8:"Note",9:"Cc",10:"Initiate",11:"Review",12:"Attachment",13:"Checkbox",14:"Editable Text",15:"User",16:"Name",17:"Email",18:"Company",19:"Title",20:"Phone",21:"CompositeStamp",22:"RadioButton"]
    
    func showActivityIndicatory(uiView: UIView) {
        
        DispatchQueue.main.async {
            self.container = UIView()
            self.container.frame = uiView.frame
            self.container.center = uiView.center
            self.container.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
            
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.loadingView.center = uiView.center
            self.loadingView.backgroundColor = .clear//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)//UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.actInd = UIActivityIndicatorView()
            self.actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.actInd.style = UIActivityIndicatorView.Style.whiteLarge
            self.actInd.color = ColorTheme.activityindicator
            self.actInd.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)
            //            let lblWait: UILabel = UILabel()
            //            lblWait.text = "Loading"
            //            lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
            //            lblWait.font = lblWait.font.withSize(13)
            //            lblWait.textAlignment = .center
            //            lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            //            self.loadingView.addSubview(lblWait)
            
            self.loadingView.addSubview(self.actInd)
            self.container.addSubview(self.loadingView)
            uiView.addSubview(self.container)
            
            self.actInd.startAnimating()
        }
    }
    
    func showActivityIndicatory(uiView: UIView, text: String) {
        
        DispatchQueue.main.async {
            self.container = UIView()
            self.container.frame = uiView.frame
            self.container.center = uiView.center
            self.container.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
            
            self.loadingView = UIView()
            self.loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            self.loadingView.center = uiView.center
            self.loadingView.backgroundColor = .clear//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)//UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
            self.loadingView.clipsToBounds = true
            self.loadingView.layer.cornerRadius = 10
            
            self.actInd = UIActivityIndicatorView()
            self.actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            self.actInd.style = UIActivityIndicatorView.Style.whiteLarge
            self.actInd.color = ColorTheme.activityindicator
            self.actInd.center = CGPoint(x: self.loadingView.frame.size.width / 2, y: self.loadingView.frame.size.height / 2)
            //            let lblWait: UILabel = UILabel()
            //            lblWait.text = text//"Loading"
            //            lblWait.frame = CGRect(x: 0, y: 55, width: 80, height: 20)
            //            lblWait.font = lblWait.font.withSize(13)
            //            lblWait.textAlignment = .center
            //            lblWait.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
            //            self.loadingView.addSubview(lblWait)
            
            self.loadingView.addSubview(self.actInd)
            self.container.addSubview(self.loadingView)
            uiView.addSubview(self.container)
            
            self.actInd.startAnimating()
        }
    }
    
    func stopActivityIndicator()
    {
        if let acttivityindicator = actInd, let container = container {
            DispatchQueue.main.async {
                acttivityindicator.stopAnimating()
                acttivityindicator.hidesWhenStopped = true
                container.isHidden = true
            }
        }
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func isValidPassword(testStr:String) -> Bool {
        let emailRegEx = "^(?=.*?[A-Z])(?=.*?[#?!@$%^&*-]).{7,}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
