//
//  LoginAPI.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire

class LoginAPI {
    
    static let sharedInstance = LoginAPI()
    
    private init() {}
}

extension LoginAPI {
    
    //MARK: - Verify OTP for login
    
    func verifyloginOTP(otpverifylogin: OTPVerifyLogin, completion: @escaping(UserLoginData?, Int?) -> ()) {
        
        let urlrequest = CommonRouter.verifyuserloginOTP(otpverifylogin).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(UserLogin.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let responsedata = responseObject.Data {
                            completion(responsedata, responseObject.StatusCode)
                            return
                        }
                        completion(nil, responseObject.StatusCode)
                        return
                    }
                    completion(nil, responseObject.StatusCode)
                    return
                } catch (let err) {
                    print(err.localizedDescription)
                    completion(nil, 500)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 500)
                return
            }
        }
    }
    
    //MARK: - Resend OTP for login
    
    func resendOTPForLogin(otpresendlogin: OTPResendLogin, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = CommonRouter.resendLoginOTP(otpresendlogin).urlRequest

        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
                case .success(let data):
                    do {
                        let responseObject = try JSONDecoder().decode(OTPResendLoginResponse.self, from: data)
                        if responseObject.StatusCode == 1000 {
                            completion(true)
                            return
                        }
                    completion(false)
                    return
                } catch (let jsonerr) {
                    completion(false)
                    print(jsonerr.localizedDescription)
                    return
                }
                case .failure(let err):
                    completion(false)
                    print(err.localizedDescription)
                    return
            }
        }
    }
    
    func passwordlessStatusCheck(username: String, deviceid: String, completion: @escaping(Bool, String) ->()) {
        
        let urlrequest = CommonRouter.passwordlessStatus(username, deviceid).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            print("STATUS")
            print(response.response?.statusCode)
            if response.response?.statusCode == 200 {
                switch response.result {
                case .success(let data):
                    do {
                        let responseobject = try JSONDecoder().decode(CommonPasswordlessStatusResponse.self, from: data)
                        guard let keyid = responseobject.KeyId else {
                            completion(false, "")
                            return
                        }
                        completion(true, keyid)
                        return
                    } catch( _) {
                        completion(false, "")
                        return
                    }
                case .failure( _):
                    completion(false, "")
                    return
                }
            }
            completion(false, "")
            return
        }
    }
    
    //MARK: - Passwordless Authentication
    
    func passwordlessUserAuthentication(passwordlessauth: PasswordlessAuthentication, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = CommonRouter.passwordlessAuthentication(passwordlessauth).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            print(response)
            print(String(data: response.data!, encoding: .utf8) ?? "No Response Found")
            
            if response.response?.statusCode == 200 {
                completion(true)
                return
            }
            completion(false)
            return
        }
    }
}

//MARK: - Request OTP
extension LoginAPI {
    func requestOTPFromApi(completion: @escaping(Bool, Bool) -> ()) {
        
        let urlrequest = CommonRouter.requestOTP.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonOTPRequestResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let responsedata = responseObject.Data {
                            completion(responsedata, false)
                            return
                        }
                        completion(false, false)
                        return
                    }
                    
                    if responseObject.StatusCode == 4212 {
                        completion(true, true)
                        return
                    }
                    completion(false, false)
                    return
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(false, false)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, false)
                return
            }
        }
    }
}

//MARK: - OTP Verification
extension LoginAPI {
    func verifyuserwithOntimePassword(otpverify: OTPVerify, completion: @escaping(Bool) ->()) {
        
        let urlrequest = CommonRouter.otpVerification(otpverify).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonOTPVerifyResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let responsedata = responseObject.Data {
                            completion(responsedata)
                            return
                        }
                        completion(false)
                        return
                    }
                    completion(false)
                    return
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(false)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
                return
            }
        }
    }
}
