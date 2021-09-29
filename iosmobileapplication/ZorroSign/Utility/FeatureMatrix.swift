//
//  FeatureMatrix.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-05-19.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

enum Features: String {
    case sign_reject = "Sign_Reject"
    case create_esign = "Create_ESign"
    case create_pwd_doc = "Create_Pwd_Doc"
    case set_reminders = "Set_Reminders"
    case multiple_doc_upload = "Multiple_Doc_Upload"
    
    case basic_tools = "Basic_Tools"
    case colloborative_tools = "Colloborative_Tools"
    case token_4n6 = "4N6_Token"
    case post_it_notes = "Post_It_Notes"
    case mandatory_attachments = "Mandatory_Attachements"
    
    case send_remminders = "Send_Reminders"
    case archive_doc = "Archive_Doc"
    case cancel_doc = "Cancel_Doc"
    case view_doc_wf = "View_Doc_WF"
    
    case send_email = "Send_Email"
    case share_doc = "Share_Doc"
    case audit_trail = "Audit_Trail"
    case digital_certificate = "Digital_Certificate"
    case search_doc = "Search_Doc"
    case download_doc = "Download_Doc"
    
    case dms = "Dms"
    case address_book = "Address_Book"
    case business_card = "Business_Card"
    
    case import_contatcs = "Import_Contacts"
    
    case multiple_signature_capture = "Multiple_Signatue Capture"
    case authentication_2fa = "2FA_Authentication"
    case pwd_less_login = "Pwd_less_Login"
    case add_KBA = "Add_KBA"
    
    case org_settings = "Org_Settings"
    case org_user_settings = "Org_User_Settings"
    case org_mfa_settings = "Org_MFA_Settings"
    case subscription_reassigning = "Subscription_Reassigning"
    
    case save_a_tree = "Save_A_Tree"
    case filtering = "Filtering"
    case manage_seals = "Manage_Seals"
}

struct FeatureMatrix {
    
    public static var shared = FeatureMatrix()
    
    var sign_reject = false
    var create_esign = false
    var create_pwd_doc = false
    var set_reminders = false
    var multiple_doc_upload = false
    
    var basic_tools = false
    var colloborative_tools = false
    var token_4n6 = false
    var post_it_notes = false
    var mandatory_attachments = false
    
    var send_remminders = false
    var archive_doc = false
    var cancel_doc = false
    var view_doc_wf = false
    
    var send_email = false
    var share_doc = false
    var audit_trail = false
    var digital_certificate = false
    var search_doc = false
    var download_doc = false
    
    var dms = false
    var address_book = false
    var business_card = false
    
    var import_contatcs = false
    
    var multiple_signature_capture = false
    var authentication_2fa = false
    var pwd_less_login = false
    var add_KBA = false
    
    var org_settings = false
    var org_user_settings = false
    var org_mfa_settings = false
    var subscription_reassigning = false
    
    var save_a_tree = false
    var filtering = false
    var manage_seals = false

    var featuresAllowed = [String]()
    
    private init() {
        
    }
    
    public mutating func setupFeatures(featuresAllowed: [String]) {
        self.featuresAllowed = featuresAllowed
        setFeatures()
        setPwd_less_login()
    }
    
    public func setPwd_less_login() {
        UserDefaults.standard.setValue(pwd_less_login, forKey: "pwd_less_login")
    }
    
    public func getPwd_less_login() -> Bool {
        if let value = UserDefaults.standard.value(forKey: "pwd_less_login") as? Bool {
            return value
        }
        return false
    }
    
    public mutating func setFeatures() {
        featuresAllowed.forEach { (feature) in 
            switch feature {
            
            case Features.sign_reject.rawValue:
                sign_reject = true
            case Features.create_esign.rawValue:
                create_esign = true
            case Features.create_pwd_doc.rawValue:
                create_pwd_doc = true
            case Features.set_reminders.rawValue:
                set_reminders = true
            case Features.multiple_doc_upload.rawValue:
                multiple_doc_upload = true
                
            case Features.basic_tools.rawValue:
                basic_tools = true
            case Features.colloborative_tools.rawValue:
                colloborative_tools = true
            case Features.token_4n6.rawValue:
                token_4n6 = true
            case Features.post_it_notes.rawValue:
                post_it_notes = true
            case Features.mandatory_attachments.rawValue:
                mandatory_attachments = true
                
            case Features.send_remminders.rawValue:
                send_remminders = true
            case Features.archive_doc.rawValue:
                archive_doc = true
            case Features.cancel_doc.rawValue:
                cancel_doc = true
            case Features.view_doc_wf.rawValue:
                view_doc_wf = true
                
            case Features.send_email.rawValue:
                send_email = true
            case Features.share_doc.rawValue:
                share_doc = true
            case Features.audit_trail.rawValue:
                audit_trail = true
            case Features.digital_certificate.rawValue:
                digital_certificate = true
            case Features.search_doc.rawValue:
                search_doc = true
            case Features.download_doc.rawValue:
                download_doc = true
                
            case Features.dms.rawValue:
                dms = true
            case Features.address_book.rawValue:
                address_book = true
            case Features.business_card.rawValue:
                business_card = true
            case Features.import_contatcs.rawValue:
                import_contatcs = true
                
            case Features.multiple_signature_capture.rawValue:
                multiple_signature_capture = true
            case Features.authentication_2fa.rawValue:
                authentication_2fa = true
            case Features.pwd_less_login.rawValue:
                pwd_less_login = true
            case Features.add_KBA.rawValue:
                add_KBA = true
                
            case Features.org_settings.rawValue:
                org_settings = true
            case Features.org_user_settings.rawValue:
                org_user_settings = true
            case Features.org_mfa_settings.rawValue:
                org_mfa_settings = true
            case Features.subscription_reassigning.rawValue:
                subscription_reassigning = true
                
            case Features.save_a_tree.rawValue:
                save_a_tree = true
            case Features.filtering.rawValue:
                filtering = true
            case Features.manage_seals.rawValue:
                manage_seals = true
            default:
                break
            }
        }
    }
    
    public func showRestrictedMessage() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        let toastLbl = UILabel()
        toastLbl.text = "Please upgrade your subscription to enable this feature"
        toastLbl.textAlignment = .center
        toastLbl.font = UIFont(name: "Helvetica-Bold", size: 14.0)
        toastLbl.textColor = UIColor.white
        toastLbl.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLbl.backgroundColor = UIColor.init(displayP3Red: 0.153, green: 0.671, blue: 0.067, alpha: 1.000)
        toastLbl.numberOfLines = 3
        
        let textSize = toastLbl.intrinsicContentSize
        let labelHeight = (textSize.width / window.frame.width ) * 30
        let labelWidth = min(textSize.width, window.frame.width - 40)
        let adjustedHeight = max(labelHeight, textSize.height + 40)
        
        toastLbl.frame = CGRect(x: 20, y: (window.frame.height - 50 ) - adjustedHeight, width: labelWidth + 20, height: adjustedHeight)
        toastLbl.center.x = window.center.x
        toastLbl.layer.cornerRadius = 10
        toastLbl.layer.masksToBounds = true
        
        window.addSubview(toastLbl)
        
        UIView.animate(withDuration: 5.0, delay: 0.01, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            toastLbl.alpha = 0
        }) { (_) in
            toastLbl.removeFromSuperview()
        }
    }
    
    public mutating func clearValues() {
        sign_reject = false
        create_esign = false
        create_pwd_doc = false
        set_reminders = false
        multiple_doc_upload = false
        
        basic_tools = false
        colloborative_tools = false
        token_4n6 = false
        post_it_notes = false
        mandatory_attachments = false
        
        send_remminders = false
        archive_doc = false
        cancel_doc = false
        view_doc_wf = false
        
        send_email = false
        share_doc = false
        audit_trail = false
        digital_certificate = false
        search_doc = false
        download_doc = false
        
        dms = false
        address_book = false
        business_card = false
        
        import_contatcs = false
        
        multiple_signature_capture = false
        authentication_2fa = false
        pwd_less_login = false
        add_KBA = false
        
        org_settings = false
        org_user_settings = false
        org_mfa_settings = false
        subscription_reassigning = false
        
        save_a_tree = false
        filtering = false
        manage_seals = false
    }
}
