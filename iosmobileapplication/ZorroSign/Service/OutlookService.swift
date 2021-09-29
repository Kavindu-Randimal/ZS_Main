//
//  OutlookService.swift
//  ZorroSign
//
//  Created by Apple on 20/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import Foundation
import p2_OAuth2
import Alamofire
import SwiftyJSON

class OutlookService {
    // Configure the OAuth2 framework for Azure
    //53cc3edc-fcbf-45f3-a8ab-a58b7ce7af75
    //efadcc2a-7918-4c77-a1cc-c0d33870a0a9
    private static let oauth2Settings = [
        "client_id" : "efadcc2a-7918-4c77-a1cc-c0d33870a0a9",
        "authorize_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/authorize",
        "token_uri": "https://login.microsoftonline.com/common/oauth2/v2.0/token",
        "scope": "openid profile offline_access User.Read Contacts.Read",
        "redirect_uris": ["zorosign://oauth2/callback"],
        "verbose": true,
        ] as OAuth2JSON
    
    private static var sharedService: OutlookService = {
        let service = OutlookService()
        return service
    }()
    
    private let oauth2: OAuth2CodeGrant
    
    private init() {
        oauth2 = OAuth2CodeGrant(settings: OutlookService.oauth2Settings)
        oauth2.authConfig.authorizeEmbedded = true
    }
    
    class func shared() -> OutlookService {
        return sharedService
    }
    
    var isLoggedIn: Bool {
        get {
            return oauth2.hasUnexpiredAccessToken() || oauth2.refreshToken != nil
        }
    }
    
    func handleOAuthCallback(url: URL) -> Void {
        oauth2.handleRedirectURL(url)
    }
    
    func login(from: AnyObject, callback: @escaping (String? ) -> Void) -> Void {
        oauth2.authorizeEmbedded(from: from) {
            result, error in
            if let unwrappedError = error {
                callback(unwrappedError.description)
            } else {
                if let unwrappedResult = result, let token = unwrappedResult["access_token"] as? String {
                    // Print the access token to debug log
                    NSLog("Access token: \(token)")
                    callback(nil)
                }
            }
        }
    }
    
    func logout() -> Void {
        oauth2.forgetTokens()
    }
    
    func getContacts(callback: @escaping (JSON?) -> Void) -> Void {
        let apiParams = [
            "$select": "givenName,surname,emailAddresses",
            "$orderby": "givenName ASC",
            "$top": "10"
        ]
        
        let headers = ["Access-token" : oauth2.accessToken]
        
        let apiURL = "https://graph.microsoft.com/v1.0/me/contacts"
        
        
        if Connectivity.isConnectedToInternet() == true
        {
           
            makeApiCall(api: "/v1.0/me/contacts", params: apiParams) {
                result in
                callback(result)
            }
            
        }
        else
        {
            
        }
        /*
        if Connectivity.isConnectedToInternet() == true
        {
            let url = NSURL(string: apiURL)
            let data = try? JSONSerialization.data(withJSONObject:apiParams)
            
            do {
                
                let request = NSMutableURLRequest(url: url! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headers as! [String : String]
                request.httpBody = data
                
                let session = URLSession.shared
                
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    //if HTTPStatusCode == 200 && error == nil {
                    //var resultsDictionary: JSON = JSON(data!)
                    let json: JSON = JSON(data!)
                    callback(json)
                })
                
                dataTask.resume()
            } catch {}
        } else {
            
        }*/
    }
    
    func makeApiCall(api: String, params: [String: String]? = nil, callback: @escaping (JSON?) -> Void) -> Void {
        // Build the request URL
        var urlBuilder = URLComponents(string: "https://graph.microsoft.com")!
        urlBuilder.path = api
        
        if let unwrappedParams = params {
            // Add query parameters to URL
            urlBuilder.queryItems = [URLQueryItem]()
            for (paramName, paramValue) in unwrappedParams {
                urlBuilder.queryItems?.append(
                    URLQueryItem(name: paramName, value: paramValue))
            }
        }
        
        let apiUrl = urlBuilder.url!
        NSLog("Making request to \(apiUrl)")
        
        var req = oauth2.request(forURL: apiUrl)
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loader = OAuth2DataLoader(oauth2: oauth2)
        
        // Uncomment this line to get verbose request/response info in
        // Xcode output window
        //loader.logger = OAuth2DebugLogger(.trace)
        
        loader.perform(request: req) {
            response in
            do {
                let dict = try response.responseJSON()
                DispatchQueue.main.async {
                    let result = JSON(dict)
                    callback(result)
                }
            }
            catch let error {
                DispatchQueue.main.async {
                    let result = JSON(error)
                    callback(result)
                }
            }
        }
    }
}
