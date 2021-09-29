//
//  AuditTrailAPI.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/18/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import Alamofire

class AuditTrailAPI {
    
    static let sharedInstance = AuditTrailAPI()
    
    private init() {}
}

extension AuditTrailAPI {
    
    //MARK: Get Document Trail Details
    
    func getDocumentTrailDetails(getdocumenttrail: GetDocumentTrail, completion: @escaping(DocumentTrailDetails?, Bool, Int?) -> ()) {
        
        let urlrequest = CommonRouter.getdocumentTrailDetails(getdocumenttrail).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let doctrailObject = try JSONDecoder().decode(DocumentTrailDetails.self, from: data)
                    if doctrailObject.StatusCode != 1000 {
                        completion(nil, true, doctrailObject.StatusCode)
                        return
                    }
                    completion(doctrailObject, false, doctrailObject.StatusCode)
                    return
                } catch let jsonerr {
                    print(jsonerr.localizedDescription)
                    completion(nil, true, nil)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, true, nil)
                return
            }
        }
    }
    
    //MARK: Request to read permissions
    
    func requestPermissionforDocTrail(getdocumentdetails: GetDocumentDetails, completion: @escaping(Bool, String?, Int?) -> ()) {
        
        let urlrequest = CommonRouter.requestdocumenttrailPermission(getdocumentdetails).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        completion(true, responseobject.Message, responseobject.StatusCode)
                        return
                    }
                    completion(false, responseobject.Message, responseobject.StatusCode)
                    return
                } catch let jsonerr {
                    completion(false, jsonerr.localizedDescription, 0)
                    return
                }
            case .failure(let err):
                completion(false, err.localizedDescription, 0)
                return
            }
        }
    }
    
    //MARK: Download files
    
    func downloadfileWithUrl(processID: String, objectID: String, documentID: String, completion: @escaping(String?, Bool) -> ()) {
        let urlrequest = CommonRouter.downloadFile(processID, objectID, documentID).urlRequest
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
        Alamofire.download(urlrequest!, to: destination).downloadProgress (closure :{ (progress) in
            print("progressing")
        }).response { (defaultresponse) in
            
            guard let statuscode = defaultresponse.response?.statusCode else {
                completion(nil, true)
                return
            }
            
            if statuscode == 200 {
                guard let filename = defaultresponse.response?.suggestedFilename else {
                    completion(nil, true)
                    return
                }
                completion(filename, false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
    
    //MARK: - Download files new
    
    func downloadfileWithUrlNew(processid: String, objectId: String, docname: String, completion: @escaping(String? ,Bool) -> ()) {
        let urlrequest = CommonRouter.downloadFileNew(processid, objectId).urlRequest
        
        let destination = AuditTrailHelper.sharedInstance.returnfileDestination(documentname: docname)
        Alamofire.download(urlrequest!, to: destination).downloadProgress (closure :{ (progress) in
            print("progressing")
        }).response { (defaultresponse) in
            
            guard let statuscode = defaultresponse.response?.statusCode else {
                completion(nil, true)
                return
            }
            
            if statuscode == 200 {
                guard let filename = defaultresponse.response?.suggestedFilename else {
                    completion(nil, true)
                    return
                }
                completion(filename, false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
    
    //MARK: - Download the digital certificate
    
    func downloadDigitalCertificate(processid: Int, completion: @escaping(String?, Bool) -> ()) {
        let token = UserDefaults.standard.string(forKey: "ServiceToken")!
        let urlrequest = CommonRouter.downloadDigitalCertificate(processid, token).urlRequest
        
        let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
       Alamofire.download(urlrequest!, to: destination).downloadProgress (closure :{ (progress) in
            print("progressing")
        }).response { (defaultresponse) in
            
            guard let statuscode = defaultresponse.response?.statusCode else {
                completion(nil, true)
                return
            }
            
            if statuscode == 200 {
                guard let filename = defaultresponse.response?.suggestedFilename else {
                    completion(nil, true)
                    return
                }
                completion(filename, false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
    
    //MARK: - Download documents new
    
    func downloadseperateDocument(processid: String, multidocid: Int, docname: String, completion: @escaping(String?, Bool) -> ()) {
        let token = UserDefaults.standard.string(forKey: "ServiceToken")!
        let urlrequest = CommonRouter.downloadseperateDocument(processid, multidocid, token).urlRequest
        
        let destination = AuditTrailHelper.sharedInstance.returnfileDestination(documentname: docname)
        Alamofire.download(urlrequest!, to: destination).downloadProgress (closure :{ (progress) in
            print("progressing")
        }).response { (defaultresponse) in
            
            guard let statuscode = defaultresponse.response?.statusCode else {
                completion(nil, true)
                return
            }
            
            if statuscode == 200 {
                guard let filename = defaultresponse.response?.suggestedFilename else {
                    completion(nil, true)
                    return
                }
                completion(filename, false)
                return
            } else {
                completion(nil, true)
            }
        }
    }
}
