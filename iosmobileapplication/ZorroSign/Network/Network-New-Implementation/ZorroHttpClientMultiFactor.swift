//
//  ZorroHttpClientMultiFactor.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Alamofire

//MARK: - Get Multifactor Settings Details
extension ZorroHttpClient {
    
    func getmultifactorSettingsDetails(completion: @escaping(MultifactorSettingsResponseData?) -> ()) {
        
        let urlrequest = ZorroRouter.getmultifactorSettings.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(MultifactorSettingsResponse.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        if let multisettings = responseobject.Data {
                            completion(multisettings)
                            return
                        }
                        completion(nil)
                        return
                    }
                    completion(nil)
                    return
                } catch (let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
                return
            }
        }
    }
}

extension ZorroHttpClient {
    
    func savemltifactorSettingsDetails(multifactorsettings: MultifactorSaveSettings, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.savemultifactorSettings(multifactorsettings).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(CommonMultifactorSaveSettingsResponse.self, from: data)
                    if responseobject.StatusCode == 1000 {
//                        guard let data = responseobject.Data else {
//                            completion(false)
//                            return
//                        }
                        completion(true)
                    }
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
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

//MARK: - Post biometric settings response object was changed. Because of that handling it seperately
extension ZorroHttpClient {
    
    func postBiometricSettingsDetails(multifactorsettings: MultifactorSaveSettings,completion: @escaping(BiometricSettings?, Int, String) -> ()) {
        
        let urlrequest = ZorroRouter.savemultifactorSettings(multifactorsettings).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(BiometricSaveSettingsResponse.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        guard let data = responseobject.Data else {
                            completion(nil, 1, "")
                            return
                        }
                        completion(data, responseobject.StatusCode!, responseobject.Message!)
                        return
                    }
                    if responseobject.StatusCode == 5005 {
                        guard let data = responseobject.Data else {
                            completion(nil, 1, "")
                            return
                        }
                        completion(data, responseobject.StatusCode!, responseobject.Message!)
                        return
                    }
                    
                    completion(nil, responseobject.StatusCode!, responseobject.Message!)
                    return
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(nil, 1, "")
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, 1, "")
                return
            }
        }
    }
}

//MARK: - Get OTP Settings
extension ZorroHttpClient {
    
    func getotpSettingsDetails(completion: @escaping(OTPSettingsResponseData?) -> ()) {
        
        let urlrequest = ZorroRouter.getotpSettings.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(OTPSettingsResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let optsettingsresponedata = responseObject.Data {
                            completion(optsettingsresponedata)
                            return
                        }
                        completion(nil)
                        return
                    }
                    completion(nil)
                    return
                } catch(let err) {
                    print(err.localizedDescription)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
                return
            }
        }
    }
}


//MARK: - Onboard User for OTP
extension ZorroHttpClient {
    func onboarduserforOntimePassword(otponboard: OTPOnBoard, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.otponBoard(otponboard).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonOTPOnboardResponse.self, from: data)
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

//MARK: - OTP Verification
extension ZorroHttpClient {
    func verifyuserwithOntimePassword(otpverify: OTPVerify, completion: @escaping(Bool) ->()) {
        
        let urlrequest = ZorroRouter.otpVerification(otpverify).urlRequest
        
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

//MARK: - Save OTP Settings
extension ZorroHttpClient {
    func saveuserOnetimePasswordSettings(otpsavesettings: OTPSaveSettings, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.saveotpSettings(otpsavesettings).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommmonOTPSaveSettingsResponse.self, from: data)
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
                } catch (let err) {
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

//MARK: - Request OTP
extension ZorroHttpClient {
    func requestOTPFromApi(completion: @escaping(Bool, Bool) -> ()) {
        
        let urlrequest = ZorroRouter.requestOTP.urlRequest
        
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

//MARK: - Request OTP With Password
extension ZorroHttpClient {
    func requestOTPWithPassword(requestotpwithpassword: OTPRequestwithPassword, completion: @escaping(Bool, Bool) -> ()) {
        
        let urlrequest = ZorroRouter.requestOTPWithPasswort(requestotpwithpassword).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonOTPRequestwithPasswordResponse.self, from: data)
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

//MARK: - Verify OTP for login
extension ZorroHttpClient {
    
    func verifyloginOTP(otpverifylogin: OTPVerifyLogin, completion: @escaping(UserLoginData?) -> ()) {
        
        let urlrequest = ZorroRouter.verifyuserloginOTP(otpverifylogin).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(UserLogin.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let responsedata = responseObject.Data {
                            completion(responsedata)
                            return
                        }
                        completion(nil)
                        return
                    }
                    completion(nil)
                    return
                } catch (let err) {
                    print(err.localizedDescription)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil)
                return
            }
        }
    }
}

//MARK: - Resend OTP for login
extension ZorroHttpClient {
    
    func resendOTPForLogin(otpresendlogin: OTPResendLogin, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.resendLoginOTP(otpresendlogin).urlRequest

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
}

//MARK: - Passwordless Status
extension ZorroHttpClient {
    func passwordlessStatusCheck(username: String, deviceid: String, completion: @escaping(Bool, String) ->()) {
        
        let urlrequest = ZorroRouter.passwordlessStatus(username, deviceid).urlRequest
        
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
}

//MARK: - Passwordless Onboarding
extension ZorroHttpClient {
    func passwordlessUserOnboard(pwdlessOnbarding: PasswordlessOnboarding, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.passwordlessOnboarding(pwdlessOnbarding).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            print(response.response?.statusCode ?? 10000)
            if response.response?.statusCode == 200 {
                completion(true)
                return
            }
            completion(false)
            return
        }
    }
}

//MARK: - Passwordless Authentication
extension ZorroHttpClient {
    func passwordlessUserAuthentication(passwordlessauth: PasswordlessAuthentication, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.passwordlessAuthentication(passwordlessauth).urlRequest
        
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

//MARK: - Validate User With Biometrics for 2FA
extension ZorroHttpClient {
    
    func validateUserWithBiometricVerification(validatebiometric: ValidateBiometric, completion: @escaping() -> ()) {
        
        let urlrequest = ZorroRouter.validateWithBiometric(validatebiometric).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            print(response.response?.statusCode)
            print(String(data: response.data!, encoding: .utf8) ?? "No Response Found")
            
            switch response.result {
            case .success(let data):
                return
            case .failure(let err):
                return
            }
        }
    }
}
