//
//  ZorroTempData.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroTempData {
    let userdedefault = UserDefaults.standard
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()
    static let sharedInstance = ZorroTempData()
    private init() { }
}

//MARK:- SET Temp Data
extension ZorroTempData {
    
    func set4n6Token(tokenstring: String) {
        userdedefault.set(tokenstring, forKey: ZorroTempStrings.ZORRO_QR_STRING)
    }
    
    #if !AuditTrailClip
    func setCrashedLastTime(crashed: Bool) {
        userdedefault.set(crashed, forKey: "Crash")
    }
    
    func setIsUserLoggedIn(islogged: Bool) {
        userdedefault.set(islogged, forKey: ZorroTempStrings.ZORRO_IS_LOGGED_IN)
    }
    
    func setStep(step: Int?) {
        if let step = step {
            userdedefault.set(step, forKey: ZorroTempStrings.ZORRO_STEP)
        }
    }
    
    func setProfileId(profileid: String) {
        userdedefault.set(profileid, forKey: ZorroTempStrings.ZORRO_PROFILE_ID)
    }
    
    func setOraganizationId(organizationid: String) {
        userdedefault.set(organizationid, forKey: ZorroTempStrings.ZORRO_ORGANIZATION_ID)
    }
    
    func setOrganizationLegalname(legalname: String) {
        userdedefault.set((legalname), forKey: ZorroTempStrings.ZORRO_ORGANIZATION_LEGAL_NAME)
    }
    
    func setUserType(usertype: Int) {
        userdedefault.set(usertype, forKey: ZorroTempStrings.ZORRO_USER_TYPE)
    }
    
    func setJobTitle(jobtitle: String) {
        userdedefault.set(jobtitle, forKey: ZorroTempStrings.ZORRO_JOB_TITLE)
    }
    
    func setUserName(username: String) {
        userdedefault.set(username, forKey: ZorroTempStrings.ZORRO_USERNAME)
    }
    
    func setUserEmail(email: String) {
        userdedefault.set(email, forKey: ZorroTempStrings.ZORRO_EMAIL)
    }
    
    func setUserSubscribedOrNot(subscribed: Bool) {
        userdedefault.set(subscribed, forKey: ZorroTempStrings.ZORRO_IS_SUBSCRIBED_USER)
    }
    
    func setBannerClose(isClosed: Bool) {
        userdedefault.set(isClosed, forKey: ZorroTempStrings.ZORRO_BANNER_CLOSED)
    }
    
    //secondary user email for biometric fallback
    func setSecondaryEmail(secondaryemail: String) {
        userdedefault.set(secondaryemail, forKey: ZorroTempStrings.ZORRO_SECONDARY_EMAIL_BIOMETRIC_FALLBACK)
    }
    
    func setInitials(initials: String) {
        userdedefault.set(initials, forKey: ZorroTempStrings.ZORRO_INITIALS)
    }
    
    func setSignature(signature: String) {
        userdedefault.set(signature, forKey: ZorroTempStrings.ZORRO_SIGNATURE)
    }
    
    func setStamp(stamp: String) {
        userdedefault.set(stamp, forKey: ZorroTempStrings.ZORRO_ORGANIZTION_STAMP)
    }
    
    func setPhoneCountryCode(countrycode: String) {
        userdedefault.set(countrycode, forKey: ZorroTempStrings.ZORRO_PHONE_COUNTRY_CODE)
    }
    
    func setPhoneNumber(phonenumber: String) {
        userdedefault.set(phonenumber, forKey: ZorroTempStrings.ZORRO_PHONE_NUMBER)
    }
    
    func setOtpNumber(mobilenumber: String) {
        userdedefault.set(mobilenumber, forKey: ZorroTempStrings.ZORRO_OTP_NUMBER)
    }
    
    func setCompanyName(companyname: String) {
        userdedefault.set(companyname, forKey: ZorroTempStrings.ZORRO_COMPAY_NAME)
    }
    
    func setUserprofile(userprofile: UserProfile) {
        if let encoded = try? encoder.encode(userprofile) {
            userdedefault.set(encoded, forKey: ZorroTempStrings.ZORRO_STORE_USER_PROFILE)
        }
    }
    
    //MARK: - push notification and deeplink related data
    func setisfromPush(frompush: Bool) {
        userdedefault.set(frompush, forKey: ZorroTempStrings.ZORRO_IS_NOTIFICATION)
    }
    
    func setpushType(type: Int) {
        userdedefault.set(type, forKey: ZorroTempStrings.ZORRO_NOTIFICATION_TYPE)
    }
    
    func setdocumentName(docname: String) {
        userdedefault.set(docname, forKey: ZorroTempStrings.ZORRO_NOTIFICATION_DOCUMENT_NAME)
    }
    
    func setdocprocessId(processid: String) {
        userdedefault.set(processid, forKey: ZorroTempStrings.ZORRO_NOTIFICATION_PROCESS_ID)
    }
    
    func setisfromDeeplink(fromdeeplink: Bool) {
        userdedefault.set(fromdeeplink, forKey: ZorroTempStrings.ZORRO_IS_DEEPLINK)
    }
    
    func setiszorrosignRegistered(isregistered: Bool) {
        userdedefault.set(isregistered, forKey: ZorroTempStrings.ZORRO_IS_ZORROSIGN_REGISTERED)
    }
    
    func setupprCode(upprcode: String) {
        userdedefault.set(upprcode, forKey: ZorroTempStrings.ZORRO_UPPR_CODE)
    }
    
    func setdeeplinkView(viewname: String) {
        userdedefault.set(viewname, forKey: ZorroTempStrings.ZORRO_DEEPLINK_VIEW)
    }
    
    func setupprStatus(upprstatus: Int?) {
        userdedefault.set(upprstatus, forKey: ZorroTempStrings.ZORRO_UPPR_STATUSCODE)
    }
    
    func setupprDetails(upprdata: UpprData) {
        userdedefault.set(try? PropertyListEncoder().encode(upprdata), forKey: ZorroTempStrings.ZORRO_UPPR_DATA)
    }
    
    func setreceiverEmail(receiveremail: String) {
        userdedefault.set(receiveremail, forKey: ZorroTempStrings.ZORRO_UPPR_RECEIVERMAIL)
    }
    
    func setsignatuerOne(signatureone: String) {
        userdedefault.set(signatureone, forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_ONE)
    }
    
    func setsignatuerTwo(signaturetwo: String) {
        userdedefault.set(signaturetwo, forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_TWO)
    }
    
    func setsignatuerThree(signaturethree: String) {
        userdedefault.set(signaturethree, forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_THREE)
    }
    
    func setallSignatures(signatures: [UserSignature]) {
        userdedefault.set(try? PropertyListEncoder().encode(signatures), forKey: ZorroTempStrings.ZORRO_USER_ALL_SIGNATURES)
    }
    
    func setisSSNAvailable(isavailable: Bool) {
        userdedefault.set(isavailable, forKey: ZorroTempStrings.ZORRO_IS_SSN_AVAILABLE)
    }
    
    func setpdfprotectionPassword(password: String) {
        userdedefault.set(password, forKey: ZorroTempStrings.ZORRO_STORE_PDF_PASSWORD)
    }
    
    //MARK: Passwordless
    func setPasswordlessUUID(uuid: String) {
        userdedefault.set(uuid, forKey: ZorroTempStrings.ZORRO_PASSWORDLESS_UUID)
    }
    
    func setPasswordlessUser(email: String) {
        userdedefault.set(email, forKey: ZorroTempStrings.ZORRO_PASSWORDLESS_USER)
    }
    
    func isPasswordlessEnabled(enabled: Bool) {
        userdedefault.set(enabled, forKey: ZorroTempStrings.ZORRO_IS_PASSWORDLESS_ENABLED)
    }
    #endif
}

//MARK:- GET Temp Data ------------------------------------------------------------------------------
extension ZorroTempData {
    
    func get4n6Token() -> String {
        if let token = userdedefault.value(forKey: ZorroTempStrings.ZORRO_QR_STRING) as? String {
            return token
        }
        return ""
    }
    
    func getpasswordlessUUID() -> String {
        if let uuid = userdedefault.value(forKey: ZorroTempStrings.ZORRO_PASSWORDLESS_UUID) as? String {
            return uuid
        }
        return ""
    }
    
    func getpasswordlessUser() -> String {
        if let user = userdedefault.value(forKey: ZorroTempStrings.ZORRO_PASSWORDLESS_USER) as? String {
            return user
        }
        return ""
    }
    
    #if !AuditTrailClip
    func getCrashedLastTime() -> Bool {
        if let iscrashed = userdedefault.value(forKey: "Crash") as? Bool {
            return iscrashed
        }
        return true
    }
    
    func getIsUserLoogged() -> Bool {
        if let islogged = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_LOGGED_IN) as? Bool {
            return islogged
        }
        return false
    }
    
    func getStep() -> Int {
        if let step = userdedefault.value(forKey: ZorroTempStrings.ZORRO_STEP) as? Int {
            return step
        }
        return 0
    }
    
    func getProfileId() -> String {
        if let profileid = userdedefault.value(forKey: ZorroTempStrings.ZORRO_PROFILE_ID) as? String {
            return profileid
        }
        return ""
    }
    
    func getOrganizationId() -> String {
        if let organizationid = userdedefault.value(forKey: ZorroTempStrings.ZORRO_ORGANIZATION_ID) as? String {
            return organizationid
        }
        return ""
    }
    
    func getOrganizationLegalName() -> String {
        if let legalname = userdedefault.value(forKey: ZorroTempStrings.ZORRO_ORGANIZATION_LEGAL_NAME) as? String {
            return legalname
        }
        return ""
    }
    
    func getUserType() -> Int {
        if let usertype = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USER_TYPE) as? Int {
            return usertype
        }
        return 0
    }
    
    func getUserName() -> String {
        if let username = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USERNAME) as? String {
            return username
        }
        return ""
    }
    
    func getUserEmail() -> String {
        if let email = userdedefault.value(forKey: ZorroTempStrings.ZORRO_EMAIL) as? String {
            return email
        }
        return ""
    }
    
    func getUserSubscribedOrNot() -> Bool {
        if let isSubscribed = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_SUBSCRIBED_USER) as? Bool {
            return isSubscribed
        }
        return false
    }
    
    func isBannerClosd() -> Bool {
        if let bannerClosed = userdedefault.value(forKey: ZorroTempStrings.ZORRO_BANNER_CLOSED) as? Bool {
            return bannerClosed
        }
        return false
    }
    
    //Get secondary user email for biometric fallback
    func getSecondaryEmail() -> String {
        if let secondaryEmail = userdedefault.value(forKey: ZorroTempStrings.ZORRO_SECONDARY_EMAIL_BIOMETRIC_FALLBACK) as? String {
            return secondaryEmail
        }
        return ""
    }
    
    func getJobTitle() -> String {
        if let jobtitle = userdedefault.value(forKey: ZorroTempStrings.ZORRO_JOB_TITLE) as? String {
            return jobtitle
        }
        return ""
    }
    
    func getInitials() -> String {
        if let initials = userdedefault.value(forKey: ZorroTempStrings.ZORRO_INITIALS) as? String {
            return initials
        }
        return ""
    }
    
    func getSignature() -> String {
        if let signature = userdedefault.value(forKey: ZorroTempStrings.ZORRO_SIGNATURE) as? String {
            return signature
        }
        return ""
    }
    
    func getStamp() -> String {
        if let stamp = userdedefault.value(forKey: ZorroTempStrings.ZORRO_ORGANIZTION_STAMP) as? String {
            return stamp
        }
        return ""
    }
    
    func getPhoneCountryCode() -> String {
        if let phonenumber = userdedefault.value(forKey: ZorroTempStrings.ZORRO_PHONE_COUNTRY_CODE) as? String {
            return phonenumber
        }
        return ""
    }
    
    func getPhoneNumber() -> String {
        if let phonenumber = userdedefault.value(forKey: ZorroTempStrings.ZORRO_PHONE_NUMBER) as? String {
            return phonenumber
        }
        return ""
    }
    
    func getOtpNumber() -> String {
        if let otpnumber = userdedefault.value(forKey: ZorroTempStrings.ZORRO_OTP_NUMBER) as? String {
            return otpnumber
        }
        return ""
    }
    
    func getCompanyName() -> String {
        if let companyname = userdedefault.value(forKey: ZorroTempStrings.ZORRO_COMPAY_NAME) as? String {
            return companyname
        }
        return ""
    }
    
    func getUserprofile() -> UserProfile? {
        if let userProfile = userdedefault.object(forKey: ZorroTempStrings.ZORRO_STORE_USER_PROFILE) as? Data {
            if let userprofile = try? decoder.decode(UserProfile.self, from: userProfile) {
                return userprofile
            }
        }
        return nil
    }
    
    //MARK: - push notification and deeplink related data
    func getisfromPush() -> Bool {
        if let isfrompush = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_NOTIFICATION) as? Bool {
            return isfrompush
        }
        return false
    }
    
    func getnotificationType() -> Int {
        if let pushnotificationtype = userdedefault.value(forKey: ZorroTempStrings.ZORRO_NOTIFICATION_TYPE) as? Int {
            return pushnotificationtype
        }
        return 0
    }
    
    func getdocumentName() -> String {
        if let documentname = userdedefault.value(forKey: ZorroTempStrings.ZORRO_NOTIFICATION_DOCUMENT_NAME) as? String {
            return documentname
        }
        return ""
    }
    
    func getdocprocessId() -> String {
        if let processid = userdedefault.value(forKey: ZorroTempStrings.ZORRO_NOTIFICATION_PROCESS_ID) as? String {
            return processid
        }
        return ""
    }
    
    func getisfromDeeplink() -> Bool {
        if let isfromdeeplinke = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_DEEPLINK) as? Bool {
            return isfromdeeplinke
        }
        return false
    }
    
    func getiszorrosignRegistered() -> Bool {
        if let isregistered = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_ZORROSIGN_REGISTERED) as? Bool {
            return isregistered
        }
        return false
    }
    
    func getupprCode(upprcode: String) -> String {
        if let upprcode = userdedefault.value(forKey: ZorroTempStrings.ZORRO_UPPR_CODE) as? String {
            return upprcode
        }
        return ""
    }
    
    func getupprData() -> UpprData? {
        
        if let data = userdedefault.value(forKey: ZorroTempStrings.ZORRO_UPPR_DATA) as? Data {
            let upprdata = try? PropertyListDecoder().decode(UpprData.self, from: data)
            return upprdata!
        }
        return nil
    }
    
    func getdeeplinkView() -> String {
        if let viewname = userdedefault.value(forKey: ZorroTempStrings.ZORRO_DEEPLINK_VIEW) as? String {
            return viewname
        }
        return ""
    }
    
    func getupprStatus() -> Int? {
        if let upprstatus = userdedefault.value(forKey: ZorroTempStrings.ZORRO_UPPR_STATUSCODE) as? Int {
            return upprstatus
        }
        return nil
    }
    
    func getreceiverEmail() -> String {
        if let receiveremail = userdedefault.value(forKey: ZorroTempStrings.ZORRO_UPPR_RECEIVERMAIL) as? String {
            return receiveremail
        }
        return ""
    }
    
    func getsignatureOne() -> UIImage? {
        if let signatureone = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_ONE) as? String {
            return getImage(signature: signatureone) ?? nil
        }
        return nil
    }
    
    func getsignatureTwo() -> UIImage? {
        if let signaturetwo = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_TWO) as? String {
            return getImage(signature: signaturetwo) ?? nil
        }
        return nil
    }
    
    func getsignatureThree() -> UIImage? {
        if let signaturethree = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USER_SIGNATURE_THREE) as? String {
            return getImage(signature: signaturethree) ?? nil
        }
        return nil
    }
    
    func getallSignatures() -> [UserSignature]? {
        
        if let data = userdedefault.value(forKey: ZorroTempStrings.ZORRO_USER_ALL_SIGNATURES) as? Data {
            let signatures = try? PropertyListDecoder().decode([UserSignature].self, from: data)
            return signatures!
        }
        return nil
    }
    
    func getisSSNAvailabel() -> Bool {
        
        if let isssnavailable = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_SSN_AVAILABLE) as? Bool {
            
            return isssnavailable
        }
        return false
    }
    
    func getisPasswordlessEnabled() -> Bool {
        if let ispasswordless = userdedefault.value(forKey: ZorroTempStrings.ZORRO_IS_PASSWORDLESS_ENABLED) as? Bool {
            return ispasswordless
        }
        return false
    }
    
    func getpdfprotectionPassword() -> String {
        if let password = userdedefault.value(forKey: ZorroTempStrings.ZORRO_STORE_PDF_PASSWORD) as? String {
            return password
        }
        return ""
    }
    #endif
}

//MARK: CLEAR All Temp Data
extension ZorroTempData {
    
    #if !AuditTrailClip
    func clearAllTempData() {
        setIsUserLoggedIn(islogged: false)
        setStep(step: 0)
        setProfileId(profileid: "")
        setOraganizationId(organizationid: "")
        //setOrganizationLegalname(legalname: "")
        setUserType(usertype: 0)
        setJobTitle(jobtitle: "")
        setUserName(username: "")
        setUserEmail(email: "")
        setInitials(initials: "")
        setSignature(signature: "")
        setStamp(stamp: "")
        setCompanyName(companyname: "")
        setPhoneNumber(phonenumber: "")
    }
    
    func clearfromNotification() {
        setisfromPush(frompush: false)
    }
    
    func clearfromDeeplink() {
        setisfromDeeplink(fromdeeplink: false)
        setiszorrosignRegistered(isregistered: true)
        setupprCode(upprcode: "")
        setupprStatus(upprstatus: nil)
        setreceiverEmail(receiveremail: "")
    }
    #endif
}

extension ZorroTempData {
    fileprivate func getImage(signature: String) -> UIImage? {
        if signature.contains(",") {
            let splitsignature = signature.components(separatedBy: ",")
            let base64string = splitsignature[1]
            guard let decodedata = Data(base64Encoded: base64string) else { return UIImage()}
            let signatureimage = UIImage(data: decodedata)
            return signatureimage!
        } else {
            return UIImage()
        }
    }
}
