//
//  LoginVM.swift
//  AuditTrailClip
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire
import SwiftyJSON

enum ValidateError: Error {
    case invalidData(String)
}

typealias actionHandler = (_ status: Bool, _ message: String) -> ()
typealias completionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()

class LoginVM: NSObject {
    
    // MARK: - Variables
    
    var email = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    var userLoginData: UserLoginData?
    
    // MARK: - Field Validator
    
    func validateFields() throws -> Bool {
        
        guard !email.value.trim().isEmpty else {
            throw ValidateError.invalidData("Please enter email")
        }
        
        guard !password.value.isEmpty else {
            throw ValidateError.invalidData("Please enter password")
        }
        
        return true
    }
    
    // MARK: - Validate & Go For Login
    
    func validateAndLogin(completion: @escaping actionHandler) {
        do {
            if try validateFields() {
                completion(true, "Success")
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Unknown Error")
        }
    }
    
    // MARK: - NetReq Login
    
    func netReqLogin(completion: @escaping completionHandler) {
        
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet found. Check your network connection and Try again...")
            return
        }
        
        let param = [
            "UserName" : email.value,
            "Password" : password.value,
            "ClientId": Singletone.shareInstance.clientId,
            "ClientSecret": Singletone.shareInstance.clientSecret,
            "DoNotSendActivationMail": true,
            "FallbackAnswers": []
        ] as [String : Any]
        
        Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "Account/Login")!, method: .post, parameters: param, encoding: JSONEncoding.default, headers: Singletone.shareInstance.headerAPI)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    
                    guard let _value = response.result.value else {
                        completion(false, 500, "Unknown Error")
                        return
                    }
                    
                    var statusCode: Int = 0
                    // Set the JSON with UserLoginData model
                    do {
                        let responseObject = try JSONDecoder().decode(UserLogin.self, from: data)
                        
                        statusCode = responseObject.StatusCode ?? 0
                        if responseObject.StatusCode == 1000 {
                            if let responsedata = responseObject.Data {
                                self.userLoginData = responsedata
                            }
                        }
                    } catch (let err) {
                        completion(false, 500, err.localizedDescription)
                    }
                    
                    // Getting JSON and Proceed with StatusCode
                    let jsonObj: JSON = JSON(_value)
                    let _statuscode = jsonObj["StatusCode"]
                    
                    switch _statuscode {
                    case 1000:
                        UserDefaults.standard.set(jsonObj["Data"]["ServiceToken"].stringValue, forKey: "ServiceToken")
                        completion(true, 200, "Success")
                    case 3599:
                        completion(false, 3599, jsonObj["Message"].stringValue)
                    case 4214:
                        completion(false, 4214, "Check for OTP")
                    case 4009:
                        completion(false, 4009, "You haven't verified One sTime Password (OTP) to Change mobile number. Please contact ZorroSign Support to reset OTP settings.")
                    case 1250:
                        /// FallBack Implementation
                        break
                    case 5006:
                        completion(false, 5006, "Account Locked.")
                    default:
                        completion(false, statusCode, jsonObj["Message"].stringValue)
                    }
                case .failure(let err):
                    completion(false, 500, err.localizedDescription)
                }
            }
    }
}
