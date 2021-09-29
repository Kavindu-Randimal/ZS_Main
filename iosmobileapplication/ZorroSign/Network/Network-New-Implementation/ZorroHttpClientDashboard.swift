//
//  ZorroHttpClientDashboard.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 1/21/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Alamofire

//MARK: - Get Category Counts
extension ZorroHttpClient {
    func getDashboardCategoryCount() {
        
        let urlrequest = ZorroRouter.getdashbordCategoryCount.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do  {
                    let dashboardcountObject = try JSONDecoder().decode(DashbordCategoryCountRespone.self, from: data)
                    if let statusCode = dashboardcountObject.StatusCode {
                        if statusCode == 1000 {
                            
                        }
                    }
                } catch (let jsonerr) {
                    print(jsonerr.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

//MARK: - Get Each Category Data
extension ZorroHttpClient {
    func getDashboardCategoryDetails(category: Int) {
        
        let urlrequest = ZorroRouter.getdetailsForCategory(category).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
        
            switch response.result {
            case .success(let data):
                do {
                    let dashboardcategorydetailsObject = try JSONDecoder().decode(DashbordCategoryRespone.self, from: data)
                    if let statusCode = dashboardcategorydetailsObject.StatusCode {
                        if statusCode == 1000 {
                            
                        }
                    }
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

//MARK: - UPPR Register User
extension ZorroHttpClient {
    func registerUpprUserDetails(registeruuprprofile: RegisterUPPRProfile, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.registerupprProfile(registeruuprprofile).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            
            switch response.result {
            case .success(let data):
                do {
                    let upprregisterrespone = try JSONDecoder().decode(CommontUpprUserRegisterResponse.self, from: data)
                    if let statusCode = upprregisterrespone.StatusCode {
                        if statusCode == 1000 {
                            completion(upprregisterrespone.Data ?? false)
                            return
                        }
                        completion(false)
                        return
                    }
                    completion(false)
                    return
                
                } catch (let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(false)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false)
            }
        }
    }
}


