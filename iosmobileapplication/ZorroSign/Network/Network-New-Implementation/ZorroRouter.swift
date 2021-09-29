//
//  ZorroRouter.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire

enum ZorroRouter: URLRequestConvertible {
    
    case getuserProfileDetails(String)
    case updateuserProfileDetails(UserProfileUpdate)
    case updateuserSignatureDetails(UserSignatureUpdate)
    case getorganizationDetails
    case getdocumentSummaryDetails
    case getSubscriptionData
    case getUserSubscriptionFeatures
    case postIAPPurchaseDetails(IAPTransactionDetail)
    case getoraginzationStamp
    case uploadorganizationStamp(OrganizationstampUpload)
    case getdocumentProcess(String)
    case getdocumentProcessDetails(String)
    case checkstepPassword(StepPassword)
    case downloadPDF(String, String)
    case downloadFile(String, String, String)
    case downloadFileNew(String, String)
    case downloadseperateDocument(String, Int, String)
    case downloadDigitalCertificate(Int, String)
    case uploadFile(String)
    case deleteaFile(String, String, String)
    case savedocumentProcess(DocSaveProcess)
    case getdocumentTrailDetails(GetDocumentTrail)
    case requestdocumenttrailPermission(GetDocumentDetails)
    case getupprLogin(String)
    case getupprDetails(String)
    case getNotifications(String)
    case updateNotification([UpdateNotification])
    case createWorkFlow(CreateWorkflow)
    case uploadworkflowFile(String)
    case getcontactList
    case createnewContact(CreateNewContact)
    case getWorkflow(String)
    case downloadworkflowPDF(String, String)
    case saveworkflow(DocSaveWorkflow)
    case createProces(CreateProcess)
    case getotpSettings
    case getmultifactorSettings
    case savemultifactorSettings(MultifactorSaveSettings)
    case otponBoard(OTPOnBoard)
    case otpVerification(OTPVerify)
    case saveotpSettings(OTPSaveSettings)
    case requestOTP
    case requestOTPWithPasswort(OTPRequestwithPassword)
    case requestuserotpWithSecondaryEmail(FallbackOTPRequest)
    case verifyOtpFallback(FallbackVerifyOTPRequest)
    case requestFallbackQuestions
    case verifyuserloginOTP(OTPVerifyLogin)
    case resendLoginOTP(OTPResendLogin)
    case getKBAQuestions(KBAQuestionRequest)
    case sendKBAAnswerRequest(KBAAnswerRequest)
    case getOraganizationSettings
    case postOrganizationSettings(PostOrganizationSettings)
    case passwordlessOnboarding(PasswordlessOnboarding)
    case passwordlessAuthentication(PasswordlessAuthentication)
    case passwordlessStatus(String, String)
    case getdashbordCategoryCount
    case getdetailsForCategory(Int)
    case registerupprProfile(RegisterUPPRProfile)
    case validateWithBiometric(ValidateBiometric)
    case sendSecurityQuestion(FallbackQuestionRequest)
    
    var baseUrl: String {
        switch self {
        case .getuserProfileDetails:
            return Singletone.shareInstance.apiURL
        case .updateuserProfileDetails:
            return Singletone.shareInstance.apiURL
        case .updateuserSignatureDetails:
            return Singletone.shareInstance.apiSign
        case .getorganizationDetails:
            return Singletone.shareInstance.apiURL
        case .getdocumentSummaryDetails:
            return Singletone.shareInstance.apiUserService
        case .getoraginzationStamp:
            return Singletone.shareInstance.apiURL
        case .postIAPPurchaseDetails:
            return Singletone.shareInstance.apiIAPTransaction
        case .getSubscriptionData:
            return Singletone.shareInstance.apiSubscription
        case .getUserSubscriptionFeatures:
            return Singletone.shareInstance.apiSubscription
        case .uploadorganizationStamp:
            return Singletone.shareInstance.apiURL
        case .getdocumentProcess:
            return Singletone.shareInstance.apiUserService
        case .getdocumentProcessDetails:
            return Singletone.shareInstance.apiUserService
        case .checkstepPassword:
            return Singletone.shareInstance.apiUserService
        case .downloadPDF:
            return Singletone.shareInstance.apiUserService
        case .downloadFile:
            return Singletone.shareInstance.apiUserService
        case .downloadFileNew:
            return Singletone.shareInstance.apiUserService
        case .downloadseperateDocument:
            return Singletone.shareInstance.apiUserService
        case .downloadDigitalCertificate:
            return Singletone.shareInstance.audittrailDoc
//            return Singletone.shareInstance.apiUserService
        case .uploadFile:
            return Singletone.shareInstance.apiUserService
        case .deleteaFile:
            return Singletone.shareInstance.apiUserService
        case .savedocumentProcess:
            return Singletone.shareInstance.apiUserService
        case .getdocumentTrailDetails:
            return Singletone.shareInstance.apiUserService
        case .requestdocumenttrailPermission:
            return Singletone.shareInstance.apiDoc
        case .getupprLogin:
            return Singletone.shareInstance.apiSign
        case .getupprDetails:
            return Singletone.shareInstance.apiSign
        case .getNotifications:
            return Singletone.shareInstance.apiNotification
        case .updateNotification:
            return Singletone.shareInstance.apiNotification
        case .createWorkFlow:
            return Singletone.shareInstance.apiUserService
        case .uploadworkflowFile:
            return Singletone.shareInstance.apiUserService
        case .getcontactList:
            return Singletone.shareInstance.apiSign
        case .createnewContact:
            return Singletone.shareInstance.apiURL
        case .getWorkflow:
            return Singletone.shareInstance.apiUserService
        case .downloadworkflowPDF:
            return Singletone.shareInstance.apiUserService
        case .saveworkflow:
            return Singletone.shareInstance.apiUserService
        case .createProces:
            return Singletone.shareInstance.apiUserService
        case .getotpSettings:
            return Singletone.shareInstance.apiSign
        case .getmultifactorSettings:
            return Singletone.shareInstance.apiSign
        case .savemultifactorSettings:
            return Singletone.shareInstance.apiSign
        case .otponBoard:
            return Singletone.shareInstance.apiSign
        case .otpVerification:
            return Singletone.shareInstance.apiSign
        case .saveotpSettings:
            return Singletone.shareInstance.apiSign
        case .requestOTP:
            return Singletone.shareInstance.apiSign
        case .requestOTPWithPasswort:
            return Singletone.shareInstance.apiSign
        case .requestuserotpWithSecondaryEmail:
            return Singletone.shareInstance.apiSign
        case .verifyOtpFallback:
            return Singletone.shareInstance.apiSign
        case .requestFallbackQuestions:
            return Singletone.shareInstance.apiSign
        case .verifyuserloginOTP:
            return Singletone.shareInstance.apiSign
        case .resendLoginOTP:
            return Singletone.shareInstance.apiAccount
        case .getKBAQuestions:
            return Singletone.shareInstance.apiSign
        case .sendKBAAnswerRequest:
            return Singletone.shareInstance.apiSign
        case .getOraganizationSettings:
            return Singletone.shareInstance.apiSign
        case .postOrganizationSettings:
            return Singletone.shareInstance.apiSign
        case .passwordlessOnboarding:
            return Singletone.shareInstance.apiSign
        case .passwordlessAuthentication:
            return Singletone.shareInstance.apiAccount
        case .passwordlessStatus:
            return Singletone.shareInstance.apiAccount
        case .getdashbordCategoryCount:
            return Singletone.shareInstance.apiUserService
        case .getdetailsForCategory:
            return Singletone.shareInstance.apiUserService
        case .registerupprProfile:
            return Singletone.shareInstance.apiURL
        case .validateWithBiometric:
            return Singletone.shareInstance.apiAccount
        case .sendSecurityQuestion:
            return Singletone.shareInstance.apiSign
        }
    }
    
    var path: String {
        switch self {
        case .getuserProfileDetails(let profileid):
            return "UserManagement/GetProfile?profileId=\(profileid)"
        case .updateuserProfileDetails:
            return "UserManagement/UpdateProfile"
        case .updateuserSignatureDetails:
            return "api/UserManagement/UpdateSignatures"
        case .getorganizationDetails:
            return "Organization/GetOrganizationDetails"
        case .getdocumentSummaryDetails:
            return "v1/process/GetUsageSummary?isProfileSummary=true"
        case .getoraginzationStamp:
            return "Organization/GetStamp"
        case .postIAPPurchaseDetails:
            return "mobile/receive"
        case .getSubscriptionData:
            return "v3/Subscription/GetSubscriptionData"
        case .getUserSubscriptionFeatures:
            return "v3/Subscription/GetUserSubscriptionFeatures"
        case .uploadorganizationStamp:
            return "Organization/UploadStamp"
        case .getdocumentProcess(let instanceid):
            return "v1/process/GetProcess?processId=\(instanceid)"
        case .getdocumentProcessDetails(let instanceid):
            return "v1/process/GetProcessDetails?processId=\(instanceid)"
        case .checkstepPassword:
            return "v1/process/ValidateStepPassword"
        case .downloadPDF(let processid, let objectid):
            return "v1/process/\(processid)/document?objectId=\(objectid)"
        case .downloadFile(let processid, let objectid, let documentid):
            return "v1/process/\(processid)/document?objectId=\(objectid)&multiDocId=\(documentid)"
        case .downloadFileNew(let processid, let objectid):
            return "v1/process/\(processid)/document?objectId=\(objectid)"
        case .downloadseperateDocument(let processid, let multidocid, let token):
            return "v1/process/\(processid)/document?multiDocId=\(multidocid)&token=\(token)"
        case .downloadDigitalCertificate(let processid, let token):
            return "v1/processDocument/GetAuditTrailDocument?processId=\(processid)&token=\(token)&&isDetailed=true"
//            return "v1/processDocument/GetAuditTrailDocument?processId=\(processid)&token=\(token)"
        case .uploadFile(let processid):
            return "v1/process/\(processid)/document"
        case .deleteaFile(let processid, let objectid, let tagid):
            if tagid == "" {
                return "v1/process/\(processid)/document?objectId=\(objectid)"
            } else {
                return "v1/process/\(processid)/document?objectId=\(objectid)&tagId=\(tagid)"
            }
        case .savedocumentProcess:
            return "v1/process/SaveAllProcess"
        case .getdocumentTrailDetails:
            return "v1/process/GetDocumentTrailFromBlockChainWithToken"
        case .requestdocumenttrailPermission:
            return "api/v1/tokenReader/GetDocumentDetails"
        case .getupprLogin(let upprcode):
            return "api/Account/UPPRLogin?code=\(upprcode)"
        case .getupprDetails(let upprcode):
            return "api/UserManagement/GetUPPRDetail?code=\(upprcode)"
        case .getNotifications(let deviceid):
            return "api/v1/Notification/GetUserPushNotifications?deviceId=\(deviceid)"
        case .updateNotification:
            return "api/v1/Notification/UpdateMessageStatus"
        case .createWorkFlow:
            return "v1/workflow/CreateWorkflow"
        case .uploadworkflowFile(let workflowid):
            return "v1/workflow/\(workflowid)/document"
        case .getcontactList:
            return "api/UserManagement/GetContactSummary"
        case .createnewContact:
            return "/UserManagement/CreateContact"
        case .getWorkflow(let workflowid):
            return "v1/workflow/GetWorkflow/\(workflowid)"
        case .downloadworkflowPDF(let workflowid, let objectid):
            return "v1/workflow/\(workflowid)/document?objectId=\(objectid)"
        case .saveworkflow:
            return "v1/workflow/SaveWorkflow"
        case .createProces:
            return "v1/process/CreateProcess"
        case .getotpSettings:
            return "api/OTP/GetOTPSettings"
        case .getmultifactorSettings:
            return "api/TwoFA/GetTwoFASettings"
        case .savemultifactorSettings:
            return "api/TwoFA/SaveTwoFASettings"
        case .otponBoard:
            return "api/OTP/OnBoardOTP"
        case .otpVerification:
            return "api/OTP/ValidateOTP"
        case .saveotpSettings:
            return "api/OTP/SaveOTPSettings"
        case .requestOTP:
            return "api/OTP/RequestOTP"
        case .requestOTPWithPasswort:
            return "api/TwoFA/RequestPasswordWithTwoFA"
        case .requestuserotpWithSecondaryEmail:
            return "api/TwoFA/OnboardBiometricFallBackUsingOtp"
        case .verifyOtpFallback:
            return "api/TwoFA/ValidateBiometricFallBackOtp"
        case .requestFallbackQuestions:
            return "api/TwoFa/GetBiometricFallBackQuestions"
        case .verifyuserloginOTP:
            return "api/Account/VerifyLoginOTPExternalAppUser"
        case .resendLoginOTP:
            return "Account/ResendOTPRequest"
        case .getKBAQuestions:
            return "api/UserManagement/KBAQuestionsRequest"
        case .sendKBAAnswerRequest:
            return "api/UserManagement/KBAAnswerRequest"
        case .getOraganizationSettings:
            return "api/Organization/GetOrganizationSettings"
        case .postOrganizationSettings:
            return "api/Organization/SaveOrganizationSettings"
        case .passwordlessOnboarding:
            return "api/PwdLess/Onboard"
        case .passwordlessAuthentication:
            return "PwdLess/Login"
        case .passwordlessStatus(let username, let deviceid):
            return "PwdLess/Status?userName=\(username)&deviceId=\(deviceid)"
        case .getdashbordCategoryCount:
            return "v1/dashboard/GetCountForCategory?labelId=-1&dashboardCategory=0"
        case .getdetailsForCategory(let category):
            return "v1/dashboard/GetDetailsForCategory?type=\(category)&startIndex=0&pageSize=10&orderBy=5&isAscending=false&labelId=-1"
        case .registerupprProfile:
            return "UserManagement/RegisterUPPRProfile"
        case .validateWithBiometric:
            return "Account/ValidateBiometric"
        case .sendSecurityQuestion:
            return "api/TwoFA/OnboardBiometricFallBackUsingKbaWrapper"
        }
    }
    
    var httpmethod: Alamofire.HTTPMethod {
        switch self {
        case .getuserProfileDetails:
            return .get
        case .updateuserProfileDetails:
            return .post
        case .updateuserSignatureDetails:
            return .post
        case .getorganizationDetails:
            return .get
        case .getdocumentSummaryDetails:
            return .get
        case .getoraginzationStamp:
            return .get
        case .postIAPPurchaseDetails:
            return.post
        case .getSubscriptionData:
            return .get
        case .getUserSubscriptionFeatures:
            return .get
        case .uploadorganizationStamp:
            return .post
        case .getdocumentProcess:
            return .get
        case .getdocumentProcessDetails:
            return .get
        case .checkstepPassword:
            return .post
        case .downloadPDF:
            return .get
        case .downloadFile:
            return .get
        case .downloadFileNew:
            return .get
        case .downloadseperateDocument:
            return .get
        case .downloadDigitalCertificate:
            return .get
        case .uploadFile:
            return .post
        case .deleteaFile:
            return .delete
        case .savedocumentProcess:
            return .put
        case .getdocumentTrailDetails:
            return .post
        case .requestdocumenttrailPermission:
            return .post
        case .getupprLogin:
            return .get
        case .getupprDetails:
            return .get
        case .getNotifications:
            return .get
        case .updateNotification:
            return .post
        case .createWorkFlow:
            return .post
        case .uploadworkflowFile:
            return .post
        case .getcontactList:
            return .get
        case .createnewContact:
            return .post
        case .getWorkflow:
            return .get
        case .downloadworkflowPDF:
            return .get
        case .saveworkflow:
            return .put
        case .createProces:
            return .post
        case .getotpSettings:
            return .get
        case .getmultifactorSettings:
            return .get
        case .savemultifactorSettings:
            return .post
        case .otponBoard:
            return .post
        case .otpVerification:
            return .post
        case .saveotpSettings:
            return .post
        case .requestOTP:
            return .get
        case .requestOTPWithPasswort:
            return .post
        case .requestuserotpWithSecondaryEmail:
            return .post
        case .verifyOtpFallback:
            return .post
        case .requestFallbackQuestions:
            return .get
        case .verifyuserloginOTP:
            return .post
        case .resendLoginOTP:
            return .post
        case .getKBAQuestions:
            return .post
        case .sendKBAAnswerRequest:
            return .post
        case .getOraganizationSettings:
            return .get
        case .postOrganizationSettings:
            return .post
        case .passwordlessOnboarding:
            return .post
        case .passwordlessAuthentication:
            return .post
        case .passwordlessStatus:
            return .get
        case .getdashbordCategoryCount:
            return .get
        case .getdetailsForCategory:
            return .get
        case .registerupprProfile:
            return .post
        case .validateWithBiometric:
            return .post
        case .sendSecurityQuestion:
            return.post
        }
    }
    
    var setcontenttype: Bool {
        switch self {
        case .getuserProfileDetails:
            return true
        case .updateuserProfileDetails:
            return true
        case .updateuserSignatureDetails:
            return true
        case .getorganizationDetails:
            return true
        case .getdocumentSummaryDetails:
            return true
        case .getoraginzationStamp:
            return false
        case .postIAPPurchaseDetails:
            return false
        case .getSubscriptionData:
            return false
        case .getUserSubscriptionFeatures:
            return false
        case .uploadorganizationStamp:
            return true
        case .getdocumentProcess:
            return true
        case .getdocumentProcessDetails:
            return true
        case .checkstepPassword:
            return false
        case .downloadPDF:
            return false
        case .downloadFile:
            return false
        case .downloadFileNew:
            return false
        case .downloadseperateDocument:
            return false
        case .downloadDigitalCertificate:
            return false
        case .uploadFile:
            return false
        case .deleteaFile:
            return false
        case .savedocumentProcess:
            return true
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .getupprLogin:
            return true
        case .getupprDetails:
            return true
        case .getNotifications:
            return true
        case .updateNotification:
            return true
        case .createWorkFlow:
            return true
        case .uploadworkflowFile:
            return true
        case .getcontactList:
            return true
        case .createnewContact:
            return true
        case .getWorkflow:
            return true
        case .downloadworkflowPDF:
            return false
        case .saveworkflow:
            return false
        case .createProces:
            return false
        case .getotpSettings:
            return false
        case .getmultifactorSettings:
            return false
        case .savemultifactorSettings:
            return true
        case .otponBoard:
            return true
        case .otpVerification:
            return true
        case .saveotpSettings:
            return true
        case .requestOTP:
            return true
        case .requestOTPWithPasswort:
            return true
        case .requestuserotpWithSecondaryEmail:
            return true
        case .verifyOtpFallback:
            return true
        case .requestFallbackQuestions:
            return true
        case .verifyuserloginOTP:
            return true
        case .resendLoginOTP:
            return true
        case .getKBAQuestions:
            return true
        case .sendKBAAnswerRequest:
            return true
        case .getOraganizationSettings:
            return false
        case .postOrganizationSettings:
            return true
        case .passwordlessOnboarding:
            return true
        case .passwordlessAuthentication:
            return true
        case .passwordlessStatus:
            return false
        case .getdashbordCategoryCount:
            return false
        case .getdetailsForCategory:
            return false
        case .registerupprProfile:
            return true
        case .validateWithBiometric:
            return true
        case .sendSecurityQuestion:
            return true
        }
    }
    
    var setaccepttype: Bool {
        switch self {
        case .getuserProfileDetails:
            return false
        case .updateuserProfileDetails:
            return true
        case .updateuserSignatureDetails:
            return true
        case .getorganizationDetails:
            return true
        case .getdocumentSummaryDetails:
            return true
        case .getoraginzationStamp:
            return false
        case .postIAPPurchaseDetails:
            return false
        case .getSubscriptionData:
            return false
        case .getUserSubscriptionFeatures:
            return false
        case .uploadorganizationStamp:
            return true
        case .getdocumentProcess:
            return false
        case .getdocumentProcessDetails:
            return false
        case .checkstepPassword:
            return false
        case .downloadPDF:
            return false
        case .downloadFile:
            return false
        case .downloadFileNew:
            return false
        case .downloadseperateDocument:
            return false
        case .downloadDigitalCertificate:
            return false
        case .uploadFile:
            return false
        case .deleteaFile:
            return false
        case .savedocumentProcess:
            return true
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .getupprLogin:
            return false
        case .getupprDetails:
            return false
        case .getNotifications:
            return false
        case .updateNotification:
            return true
        case .createWorkFlow:
            return true
        case .uploadworkflowFile:
            return true
        case .getcontactList:
            return true
        case .createnewContact:
            return true
        case .getWorkflow:
            return false
        case .downloadworkflowPDF:
            return false
        case .saveworkflow:
            return true
        case .createProces:
            return true
        case .getotpSettings:
            return true
        case .getmultifactorSettings:
            return true
        case .savemultifactorSettings:
            return true
        case .otponBoard:
            return true
        case .otpVerification:
            return true
        case .saveotpSettings:
            return true
        case .requestOTP:
            return true
        case .requestOTPWithPasswort:
            return true
        case .requestuserotpWithSecondaryEmail:
            return true
        case .verifyOtpFallback:
            return true
        case .requestFallbackQuestions:
            return true
        case .verifyuserloginOTP:
            return true
        case .resendLoginOTP:
            return true
        case .getKBAQuestions:
            return true
        case .sendKBAAnswerRequest:
            return true
        case .getOraganizationSettings:
            return true
        case .postOrganizationSettings:
            return true
        case .passwordlessOnboarding:
            return true
        case .passwordlessAuthentication:
            return true
        case .passwordlessStatus:
            return true
        case .getdashbordCategoryCount:
            return true
        case .getdetailsForCategory:
            return true
        case .registerupprProfile:
            return true
        case .validateWithBiometric:
            return true
        case .sendSecurityQuestion:
            return true
        }
    }
    
    var setheader: Bool {
        switch self {
        case .getuserProfileDetails:
            return true
        case .updateuserProfileDetails:
            return true
        case .updateuserSignatureDetails:
            return true
        case .getorganizationDetails:
            return true
        case .getdocumentSummaryDetails:
            return true
        case .getoraginzationStamp:
            return true
        case .postIAPPurchaseDetails:
            return true
        case .getSubscriptionData:
            return true
        case .getUserSubscriptionFeatures:
            return true
        case .uploadorganizationStamp:
            return true
        case .getdocumentProcess:
            return true
        case .getdocumentProcessDetails:
            return true
        case .checkstepPassword:
            return true
        case .downloadPDF:
            return true
        case .downloadFile:
            return true
        case .downloadFileNew:
            return true
        case .downloadseperateDocument:
            return true
        case .downloadDigitalCertificate:
            return true
        case .uploadFile:
            return true
        case .deleteaFile:
            return true
        case .savedocumentProcess:
            return true
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .getupprLogin:
            return false
        case .getupprDetails:
            return true
        case .getNotifications:
            return true
        case .updateNotification:
            return true
        case .createWorkFlow:
            return true
        case .uploadworkflowFile:
            return true
        case .getcontactList:
            return true
        case .createnewContact:
            return true
        case .getWorkflow:
            return true
        case .downloadworkflowPDF:
            return true
        case .saveworkflow:
            return true
        case .createProces:
            return true
        case .getotpSettings:
            return true
        case .getmultifactorSettings:
            return true
        case .savemultifactorSettings:
            return true
        case .otponBoard:
            return true
        case .otpVerification:
            return true
        case .saveotpSettings:
            return true
        case .requestOTP:
            return true
        case .requestOTPWithPasswort:
            return true
        case .requestuserotpWithSecondaryEmail:
            return true
        case .verifyOtpFallback:
            return true
        case .requestFallbackQuestions:
            return true
        case .verifyuserloginOTP:
            return false
        case .resendLoginOTP:
            return false
        case .getKBAQuestions:
            return true
        case .sendKBAAnswerRequest:
            return true
        case .getOraganizationSettings:
            return true
        case .postOrganizationSettings:
            return true
        case .passwordlessOnboarding:
            return true
        case .passwordlessAuthentication:
            return false
        case .passwordlessStatus:
            return false
        case .getdashbordCategoryCount:
            return true
        case .getdetailsForCategory:
            return true
        case .registerupprProfile:
            return true
        case .validateWithBiometric:
            return false
        case .sendSecurityQuestion:
            return true
        }
    }
    
    private func setHttpBody<T: Codable>(_ object: T) -> String {
        do {
            let jsondata = try JSONEncoder().encode(object)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            return jsonstring ?? ""
        } catch( _) {
            return ""
        }
    }
    
    private func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
    
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: baseUrl + path)
        print("NEW URL IS : \(url!)")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = httpmethod.rawValue
        
        if setheader {
            let token = "Bearer " + UserDefaults.standard.string(forKey: "ServiceToken")!
            urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .getuserProfileDetails:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .updateuserProfileDetails(let userprofileupdate):
            let jsondata = try JSONEncoder().encode(userprofileupdate)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let userprofiledic = userprofileupdate.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: userprofiledic)
        case .updateuserSignatureDetails(let usersignatureDetails):
            let jsondata = try JSONEncoder().encode(usersignatureDetails)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let usersignaturedic = usersignatureDetails.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: usersignaturedic)
        case .postIAPPurchaseDetails(let iapTransactionData):
            let jsondata = try JSONEncoder().encode(iapTransactionData)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let iapTransactiondic = iapTransactionData.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: iapTransactiondic)
        case .getorganizationDetails:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getdocumentSummaryDetails:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getoraginzationStamp:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getSubscriptionData:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getUserSubscriptionFeatures:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .uploadorganizationStamp(let oraganizationstamp):
            let jsondata = try JSONEncoder().encode(oraganizationstamp)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let organizationstampdic = oraganizationstamp.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: organizationstampdic)
        case .getdocumentProcess:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getdocumentProcessDetails:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .checkstepPassword(let stepPassword):
            let jsondata = try JSONEncoder().encode(stepPassword)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let stepPassworddic = stepPassword.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: stepPassworddic)
        case .downloadPDF:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadFile:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadFileNew:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadseperateDocument:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadDigitalCertificate:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .uploadFile(_):
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .deleteaFile(_, _, _):
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .savedocumentProcess(let docsaveproces):
            //MARK: change this place once the testing done
            let jsondata = try JSONEncoder().encode(docsaveproces)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let docsavedic = docsaveproces.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: docsavedic)
        case .getdocumentTrailDetails(let getdocumentrail):
            let jsondata = try JSONEncoder().encode(getdocumentrail)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let doctraildic = getdocumentrail.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: doctraildic)
        case .requestdocumenttrailPermission(let getdocumentdetails):
            let jsondata = try JSONEncoder().encode(getdocumentdetails)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let getdocumentdetailsdic = getdocumentdetails.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: getdocumentdetailsdic)
        case .getupprLogin:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getupprDetails:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getNotifications:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .updateNotification(let notifications):
            let updatenotificatoin = UpdateNotification()
            let jsondata = try JSONEncoder().encode(notifications)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let decodenoti = updatenotificatoin.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, withJSONObject: decodenoti)
        case .createWorkFlow(let createworkflow):
            let jsondata = try JSONEncoder().encode(createworkflow)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let getcreateworkflowdic = createworkflow.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: getcreateworkflowdic)
        case .uploadworkflowFile(_):
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getcontactList:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .createnewContact(let createcontact):
            let jsondata = try JSONEncoder().encode(createcontact)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let getcreatecontactdic = createcontact.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: getcreatecontactdic)
        case .getWorkflow:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadworkflowPDF:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .saveworkflow(let docsaveworkflow):
            let jsondata = try JSONEncoder().encode(docsaveworkflow)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let docsaveworkflowdic = docsaveworkflow.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: docsaveworkflowdic)
        case .createProces(let createprocess):
            let jsonstring = setHttpBody(createprocess)
            let createprocessdic = createprocess.convertdocprocesstoDictonary(jsonstring: jsonstring)
            return try JSONEncoding.default.encode(urlRequest, with: createprocessdic)
        case .getotpSettings:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getmultifactorSettings:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .savemultifactorSettings(let multifactorsavesetting):
            let jsonstring = setHttpBody(multifactorsavesetting)
            let multifactorsavesettings = multifactorsavesetting.convertdocprocesstoDictonary(jsonstring: jsonstring)
            return try JSONEncoding.default.encode(urlRequest, with: multifactorsavesettings)
        case .otponBoard(let otponboard):
            let jsondata = try JSONEncoder().encode(otponboard)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let otponboarddic = otponboard.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: otponboarddic)
        case .otpVerification(let otpverify):
            let jsondata = try JSONEncoder().encode(otpverify)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let otpverifydic = otpverify.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: otpverifydic)
        case .saveotpSettings(let saveotpsettings):
            let jsondata = try JSONEncoder().encode(saveotpsettings)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let saveotpsettingsdic = saveotpsettings.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: saveotpsettingsdic)
        case .requestOTP:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .requestOTPWithPasswort(let requestotpwithpassword):
            let jsondata = try JSONEncoder().encode(requestotpwithpassword)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let requestotpwithpassworddic = requestotpwithpassword.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: requestotpwithpassworddic)
        case .requestuserotpWithSecondaryEmail(let fallbackotprequest):
            let jsondata = try JSONEncoder().encode(fallbackotprequest)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let requestotpwithpassworddic = fallbackotprequest.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: requestotpwithpassworddic)
        case .verifyOtpFallback(let verifyotprequest):
            let jsondata = try JSONEncoder().encode(verifyotprequest)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let verifyotplogindic = verifyotprequest.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: verifyotplogindic)
        case .requestFallbackQuestions:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .verifyuserloginOTP(let verifyotologin):
            let jsondata = try JSONEncoder().encode(verifyotologin)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let verifyotplogindic = verifyotologin.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: verifyotplogindic)
        case .resendLoginOTP(let resendloginotp):
            let jsondata = try JSONEncoder().encode(resendloginotp)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let resendloginotpdic = resendloginotp.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: resendloginotpdic)
        case .getKBAQuestions(let kbaquestion):
            let jsondata = try JSONEncoder().encode(kbaquestion)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let kbaquestiondic = kbaquestion.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: kbaquestiondic)
        case .sendKBAAnswerRequest(let kbaanswerrequest):
            let jsondata = try JSONEncoder().encode(kbaanswerrequest)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let kbaanswerdic = kbaanswerrequest.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: kbaanswerdic)
        case .getOraganizationSettings:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .postOrganizationSettings(let postorgasettings):
            let jsondata = try JSONEncoder().encode(postorgasettings)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let postorgdic = postorgasettings.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: postorgdic)
        case .passwordlessOnboarding(let passwordlessonboard):
            let jsondata = try JSONEncoder().encode(passwordlessonboard)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let passwordonboarddic = passwordlessonboard.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: passwordonboarddic)
        case .passwordlessAuthentication(let passwordlessauthentication):
            let jsondata = try JSONEncoder().encode(passwordlessauthentication)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let passwordlessauthenticationddic = passwordlessauthentication.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: passwordlessauthenticationddic)
        case .passwordlessStatus:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getdashbordCategoryCount:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .getdetailsForCategory:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .registerupprProfile(let registerupprprofile):
            let jsonstring = setHttpBody(registerupprprofile)
            let registerupprdic = registerupprprofile.convertdocprocesstoDictonary(jsonstring: jsonstring)
            return try JSONEncoding.default.encode(urlRequest, with: registerupprdic)
        case .validateWithBiometric(let validatebiometric):
            let jsonstring = setHttpBody(validatebiometric)
            let validatebiometricdic = validatebiometric.convertdocprocesstoDictonary(jsonstring: jsonstring)
            print(validatebiometricdic ?? "")
            return try JSONEncoding.default.encode(urlRequest, with: validatebiometricdic)
        case .sendSecurityQuestion(let securityQuestionsAnswersUpdate):
            let jsondata = try JSONEncoder().encode(securityQuestionsAnswersUpdate)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let questionsAnswersDic = securityQuestionsAnswersUpdate.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: questionsAnswersDic)
        }
    }
}
