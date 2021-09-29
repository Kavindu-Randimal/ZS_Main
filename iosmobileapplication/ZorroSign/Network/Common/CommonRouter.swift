//
//  CommonRouter.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire

enum CommonRouter: URLRequestConvertible {
    
    case getdocumentTrailDetails(GetDocumentTrail)
    case requestdocumenttrailPermission(GetDocumentDetails)
    case downloadFile(String, String, String)
    case downloadFileNew(String, String)
    case downloadseperateDocument(String, Int, String)
    case downloadDigitalCertificate(Int, String)
    case verifyuserloginOTP(OTPVerifyLogin)
    case otpVerification(OTPVerify)
    case requestOTP
    case resendLoginOTP(OTPResendLogin)
    case passwordlessStatus(String, String)
    case passwordlessAuthentication(PasswordlessAuthentication)
    
    var baseUrl: String {
        switch self {
        case .getdocumentTrailDetails:
            return Singletone.shareInstance.apiUserService
        case .requestdocumenttrailPermission:
            return Singletone.shareInstance.apiDoc
        case .downloadFile:
            return Singletone.shareInstance.apiUserService
        case .downloadFileNew:
            return Singletone.shareInstance.apiUserService
        case .downloadseperateDocument:
            return Singletone.shareInstance.apiUserService
        case .downloadDigitalCertificate:
            return Singletone.shareInstance.audittrailDoc
        case .verifyuserloginOTP:
            return Singletone.shareInstance.apiSign
        case .otpVerification:
            return Singletone.shareInstance.apiSign
        case .requestOTP:
            return Singletone.shareInstance.apiSign
        case .resendLoginOTP:
            return Singletone.shareInstance.apiAccount
        case .passwordlessStatus:
            return Singletone.shareInstance.apiAccount
        case .passwordlessAuthentication:
            return Singletone.shareInstance.apiAccount
        }
    }
    
    var path: String {
        switch self {
        case .getdocumentTrailDetails:
            return "v1/process/GetDocumentTrailFromBlockChainWithToken"
        case .requestdocumenttrailPermission:
            return "api/v1/tokenReader/GetDocumentDetails"
        case .downloadFile(let processid, let objectid, let documentid):
            return "v1/process/\(processid)/document?objectId=\(objectid)&multiDocId=\(documentid)"
        case .downloadFileNew(let processid, let objectid):
            return "v1/process/\(processid)/document?objectId=\(objectid)"
        case .downloadseperateDocument(let processid, let multidocid, let token):
            return "v1/process/\(processid)/document?multiDocId=\(multidocid)&token=\(token)"
        case .downloadDigitalCertificate(let processid, let token):
            return "v1/processDocument/GetAuditTrailDocument?processId=\(processid)&token=\(token)&&isDetailed=true"
//            return "v1/processDocument/GetAuditTrailDocument?processId=\(processid)&token=\(token)"
        case .verifyuserloginOTP:
            return "api/Account/VerifyLoginOTPExternalAppUser"
        case .otpVerification:
            return "api/OTP/ValidateOTP"
        case .requestOTP:
            return "api/OTP/RequestOTP"
        case .resendLoginOTP:
            return "Account/ResendOTPRequest"
        case .passwordlessStatus(let username, let deviceid):
            return "PwdLess/Status?userName=\(username)&deviceId=\(deviceid)"
        case .passwordlessAuthentication:
            return "PwdLess/Login"
        }
    }
    
    var httpmethod: Alamofire.HTTPMethod {
        switch self {
        case .getdocumentTrailDetails:
            return .post
        case .requestdocumenttrailPermission:
            return .post
        case .downloadFile:
            return .get
        case .downloadFileNew:
            return .get
        case .downloadseperateDocument:
            return .get
        case .downloadDigitalCertificate:
            return .get
        case .verifyuserloginOTP:
            return .post
        case .otpVerification:
            return .post
        case .requestOTP:
            return .get
        case .resendLoginOTP:
            return .post
        case .passwordlessStatus:
            return .get
        case .passwordlessAuthentication:
            return .post
        }
    }
    
    var setcontenttype: Bool {
        switch self {
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .downloadFile:
            return false
        case .downloadFileNew:
            return false
        case .downloadseperateDocument:
            return false
        case .downloadDigitalCertificate:
            return false
        case .verifyuserloginOTP:
            return true
        case .otpVerification:
            return true
        case .resendLoginOTP:
            return true
        case .requestOTP:
            return true
        case .passwordlessStatus:
            return false
        case .passwordlessAuthentication:
            return true
        }
    }
    
    var setaccepttype: Bool {
        switch self {
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .downloadFile:
            return false
        case .downloadFileNew:
            return false
        case .downloadseperateDocument:
            return false
        case .downloadDigitalCertificate:
            return false
        case .verifyuserloginOTP:
            return true
        case .otpVerification:
            return true
        case .resendLoginOTP:
            return true
        case .requestOTP:
            return true
        case .passwordlessStatus:
            return true
        case .passwordlessAuthentication:
            return true
        }
    }
    
    var setheader: Bool {
        switch self {
        case .getdocumentTrailDetails:
            return true
        case .requestdocumenttrailPermission:
            return true
        case .downloadFile:
            return true
        case .downloadFileNew:
            return true
        case .downloadseperateDocument:
            return true
        case .downloadDigitalCertificate:
            return true
        case .verifyuserloginOTP:
            return false
        case .otpVerification:
            return true
        case .resendLoginOTP:
            return false
        case .requestOTP:
            return true
        case .passwordlessStatus:
            return false
        case .passwordlessAuthentication:
            return false
        }
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
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadFile:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadFileNew:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadseperateDocument:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .downloadDigitalCertificate:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .otpVerification(let otpverify):
            let jsondata = try JSONEncoder().encode(otpverify)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let otpverifydic = otpverify.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: otpverifydic)
        case .verifyuserloginOTP(let verifyotologin):
            let jsondata = try JSONEncoder().encode(verifyotologin)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let verifyotplogindic = verifyotologin.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: verifyotplogindic)
        case .requestOTP:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .resendLoginOTP(let resendloginotp):
            let jsondata = try JSONEncoder().encode(resendloginotp)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let resendloginotpdic = resendloginotp.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: resendloginotpdic)
        case .passwordlessStatus:
            return try JSONEncoding.default.encode(urlRequest, with: nil)
        case .passwordlessAuthentication(let passwordlessauthentication):
            let jsondata = try JSONEncoder().encode(passwordlessauthentication)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let passwordlessauthenticationddic = passwordlessauthentication.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            return try JSONEncoding.default.encode(urlRequest, with: passwordlessauthenticationddic)
        }
    }
}
