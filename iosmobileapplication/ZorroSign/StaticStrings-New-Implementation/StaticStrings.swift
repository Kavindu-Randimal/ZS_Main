//
//  StaticStrings.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

extension String {
    
    func incorrectEmail() -> String {
        return "invalid email"
    }
}

struct ZorroTempStrings {
    // MARK: - Temp Data
    static let ZORRO_IS_LOGGED_IN = "zorro_is_logged_in"
    static let ZORRO_STEP = "zorro_step"
    static let ZORRO_PROFILE_ID = "zorro_profile_id"
    static let ZORRO_ORGANIZATION_ID = "zorro_organization_id"
    static let ZORRO_ORGANIZATION_LEGAL_NAME = "zorro_organization_legal_name"
    static let ZORRO_USER_TYPE = "zorro_user_type"
    static let ZORRO_JOB_TITLE = "zorro_job_title"
    static let ZORRO_EMAIL = "zorro_email"
    static let ZORRO_SECONDARY_EMAIL_BIOMETRIC_FALLBACK = "zorro_secondary_email_fallback"
    static let ZORRO_USERNAME = "zorro_username"
    static let ZORRO_INITIALS = "zorro_initials"
    static let ZORRO_SIGNATURE = "zorro_signature"
    static let ZORRO_ORGANIZTION_STAMP = "zorro_stamp"
    static let ZORRO_PHONE_COUNTRY_CODE = "zorro_phone_country_code"
    static let ZORRO_PHONE_NUMBER = "zorro_phone_number"
    static let ZORRO_OTP_NUMBER = "zorro_otp_number"
    static let ZORRO_COMPAY_NAME = "zorro_company_name"
    static let ZORRO_USER_SIGNATURE_ONE = "zorro_user_signature_one"
    static let ZORRO_USER_SIGNATURE_TWO = "zorro_user_signature_two"
    static let ZORRO_USER_SIGNATURE_THREE = "zorro_user_signature_three"
    static let ZORRO_USER_ALL_SIGNATURES = "zorro_user_all_signatures"
    static let ZORRO_IS_SSN_AVAILABLE = "zorro_is_ssn_available"
    static let ZORRO_PASSWORDLESS_UUID = "zorro_passwordless_uuid"
    static let ZORRO_PASSWORDLESS_USER = "zorro_passwordless_user"
    static let ZORRO_IS_PASSWORDLESS_ENABLED = "zorro_is_passwordless_enabled"
    static let ZORRO_STORE_USER_PROFILE = "zorro_store_user_profile"
    static let ZORRO_STORE_PDF_PASSWORD = "zorro_store_pdf_password"
    static let ZORRO_IS_SUBSCRIBED_USER = "zorro_is_subscribed_user"
    static let ZORRO_BANNER_CLOSED = "zorro_subscription_banner_closed"
    
    
    //MARK: - Static Files
    static let UTC_TIMEZONE_FILE_NAME = "timeZoneDetails"
    static let UTC_TIMEZONE_FILE_TYPE = "json"
    static let UTC_TIMEZONE_FILE_URL = Bundle.main.url(forResource: ZorroTempStrings.UTC_TIMEZONE_FILE_NAME, withExtension: ZorroTempStrings.UTC_TIMEZONE_FILE_TYPE)
    
    //MARK: - Notification and deeplinks
    static let ZORRO_IS_NOTIFICATION = "zorro_is_notification"
    static let ZORRO_NOTIFICATION_TYPE = "zorro_notification_type"
    static let ZORRO_NOTIFICATION_DOCUMENT_NAME = "zorro_notification_document_name"
    static let ZORRO_NOTIFICATION_PROCESS_ID = "zorro_notification_process_id"
    static let ZORRO_IS_DEEPLINK = "zorro_is_deeplink"
    static let ZORRO_UPPR_STATUSCODE = "zorro_uppr_statuscode"
    static let ZORRO_UPPR_DATA = "zorro_uppr_data"
    static let ZORRO_UPPR_RECEIVERMAIL = "zorro_uppr_receivermail"
    static let ZORRO_IS_ZORROSIGN_REGISTERED = "zorro_is_zorrosign_registered"
    static let ZORRO_UPPR_CODE = "zorro_uppr_code"
    static let ZORRO_DEEPLINK_VIEW = "zorro_deeplink_view"
    static let ZORRO_QR_STRING = "zorro_qr_string"
    
    //MARK: - Keychain
    static let ZORRO_KEYCHAIN_ACCOUNT = "com.zorrosign.account"
    static let ZORRO_ACCESS_TOKEN = "com.zorrosign.service.accesstoken"
    static let ZORRO_PRIVATE_KEY = "com.zorrosign.service.privatekey"
    static let ZORRO_PUBLIC_KEY = "com.zorrosign.service.publickey"
    
    //MARK: - PKI Infrastructure
    static let ZORRO_PKI_PUBLICK_KEY = "com.zorrosign.app.pki.publickey"
    static let ZORRO_PKI_PRIVATE_KEY = "com.zorrosign.app.pki.privatekey"
    
    //MARK: - Not Acceptable Characters
    static let NOT_ACCEPTABLE_CHARACTERS = "!=;<>"
}
