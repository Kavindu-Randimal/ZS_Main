//
//  ZorroHttpClientBiometricFallback.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/3/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Alamofire

//MARK: - Request OTP With Email
extension ZorroHttpClient {
    
    func requestuserotpWithSecondaryEmail(requestotpwithemail: FallbackOTPRequest, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.requestuserotpWithSecondaryEmail(requestotpwithemail).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(FallbackOTPResponse.self, from: data)
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
    
    func verifyOtpFallback(verifyotprequest: FallbackVerifyOTPRequest, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.verifyOtpFallback(verifyotprequest).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(FallbackOTPVerifyResponse.self, from: data)
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
    
    func requestFallbackQuestions(completion: @escaping([FallbackQuestions]?) -> ()) {
        
        let urlrequest = ZorroRouter.requestFallbackQuestions.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(RecoveryQuestionResponse.self, from: data)
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
