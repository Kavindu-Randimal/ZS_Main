//
//  ZorroHttpClient.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire

class ZorroHttpClient {
    
    static let sharedInstance = ZorroHttpClient()
    
    private init() {}
}

//MARK: - GET user profile details
extension ZorroHttpClient {
    func getuerProfileDetails(profileid: String, completion: @escaping(UserProfile?, Bool) -> ()) {
        
        let urlrequest = ZorroRouter.getuserProfileDetails(profileid).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let profileObject = try JSONDecoder().decode(UserProfile.self, from: data)
                    if profileObject.StatusCode == 1000 && profileObject.Data != nil {
                        completion(profileObject, false)
                        return
                    }
                    completion(nil, true)
                    return
                } catch let jsonerr {
                    print("json passing error : \(jsonerr.localizedDescription)")
                }
            case .failure(let err):
                print("error getting usrer profile : \(err.localizedDescription)")
                completion(nil, true)
                return
            }
        }
    }
}

//MARK: - POST update user profile
extension ZorroHttpClient {
    func updateUserProfileDetails(userprofileupdate: UserProfileUpdate, completion: @escaping(Bool, String?) ->()) {
        
        let urlrequest = ZorroRouter.updateuserProfileDetails(userprofileupdate).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let updateprofileObject = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if updateprofileObject.StatusCode == 1000 && updateprofileObject.Data! {
                        completion(true, nil)
                        return
                    }
                    completion(false, nil)
                    return
                    
                } catch(let jsonerr) {
                    completion(false, jsonerr.localizedDescription)
                    return
                }
            case .failure(let err):
                completion(false, err.localizedDescription)
                return
            }
        }
        
    }
}

// MARK: - POST iap purchase details

extension ZorroHttpClient {
    func postIAPPurchaseDetails(transactionData: IAPTransactionDetail, completion: @escaping (Bool, Int, String?) -> ()) {
        
        let urlrequest = ZorroRouter.postIAPPurchaseDetails(transactionData).urlRequest
        
        Alamofire.request(urlrequest!).responseJSON { (response) in
            if response.response?.statusCode == 200 {
                completion(true, 200, "Success")
            } else {
                completion(false, response.response?.statusCode ?? 400, "Something went wrong")
            }
        }
    }
}

//MARK: - POST update user signature
extension ZorroHttpClient {
    func updateUserSignatureDetails(usersignatureData: UserSignatureUpdate, completion: @escaping(Bool, String?, Int) ->()) {
        
        let urlrequest = ZorroRouter.updateuserSignatureDetails(usersignatureData).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let updatesignatureObject = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if updatesignatureObject.StatusCode == 1000 && updatesignatureObject.Data! {
                        completion(true, nil, updatesignatureObject.StatusCode)
                        return
                    }
                    completion(false, nil, updatesignatureObject.StatusCode)
                    return
                    
                } catch(let jsonerr) {
                    completion(false, jsonerr.localizedDescription, 5000)
                    return
                }
            case .failure(let err):
                completion(false, err.localizedDescription, 5000)
                return
            }
        }
    }
}

//MARK: - GET origanization details
extension ZorroHttpClient {
    func getOrganizationDetails(completion: @escaping(OrganizationDetails?) -> ()) {
        
        let urlrequest = ZorroRouter.getorganizationDetails.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let organizationObject = try JSONDecoder().decode(OrganizationDetails.self, from: data)
                    if organizationObject.StatusCode == 1000 {
                        completion(organizationObject)
                        return
                    }
                    completion(nil)
                    return
                } catch let jsonerr {
                    print(jsonerr)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err)
                completion(nil)
            }
        }
    }
}

//MARK: - GET document summary details for my account
extension ZorroHttpClient {
    func getDocumentSummary(completion: @escaping(MyAccount?) -> ()) {
        
        let urlrequest = ZorroRouter.getdocumentSummaryDetails.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let docsummaryobject = try JSONDecoder().decode(MyAccount.self, from: data)
                    if docsummaryobject.StatusCode == 1000 {
                        completion(docsummaryobject)
                        return
                    }
                    completion(nil)
                    return
                } catch let jsonerr {
                    print(jsonerr)
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

//MARK: - GET Subscription data
extension ZorroHttpClient {
    func getSubscriptionData(completion: @escaping(GetSubscriptionData?) -> ()) {
        
        let urlrequest = ZorroRouter.getSubscriptionData.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let subscriptionObject = try JSONDecoder().decode(GetSubscriptionData.self, from: data)
                    if subscriptionObject.StatusCode == 1000 {
                        if subscriptionObject.Data != nil {
                            if subscriptionObject.Data?.IsSubscriptionActive != nil {
                                completion(subscriptionObject)
                                return
                            }
                            completion(nil)
                            return
                        }
                        completion(nil)
                        return
                    }
                    completion(nil)
                    return
                } catch(let jsonerr) {
                    print(jsonerr)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err)
                completion(nil)
                return
            }
        }
    }
}

// MARK: - GET User Subscription Features
extension ZorroHttpClient {
    func getUserSubscriptionFeatures(completion: @escaping (Bool, GetUserSubscriptionFeatures?) -> ()) {
        
        let urlrequest = ZorroRouter.getUserSubscriptionFeatures.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let userSubscriptionFeaturesDto = try JSONDecoder().decode(GetUserSubscriptionFeatures.self, from: data)
                    if userSubscriptionFeaturesDto.StatusCode == 1000 {
                        if userSubscriptionFeaturesDto.Data != nil {
                            if userSubscriptionFeaturesDto.Data?.PalnFeatures != nil {
                                completion(true, userSubscriptionFeaturesDto)
                            }
                        } else {
                            completion(false, nil)
                        }
                    } else {
                        if userSubscriptionFeaturesDto.Data == nil {
                            completion(false, nil)
                        } else {
                            completion(false, userSubscriptionFeaturesDto)
                        }
                    }
                } catch(let jsonerr) {
                    print(jsonerr)
                    completion(false, nil)
                    return
                }
            case .failure(let err):
                print(err)
                completion(false, nil)
                return
            }
        }
    }
}

//MARK: - GET organization stamp
extension ZorroHttpClient {
    func getOrganizationStamp(completion: @escaping(OrganizationStamp?, Bool) -> ()) {
        
        let urlrequest = ZorroRouter.getoraginzationStamp.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let stampObject = try JSONDecoder().decode(OrganizationStamp.self, from: data)
                    if stampObject.StatusCode == 1000 {
                        completion(stampObject, false)
                        return
                    }
                    completion(nil, true)
                    return
                } catch let err {
                    print("error passing response : \(err.localizedDescription)")
                    completion(nil, true)
                }
            case .failure(let err):
                print("Erro getting stamp ... \(err.localizedDescription)")
                completion(nil, true)
            }
        }
    }
}

//MARK: POST upload organization stamp
extension ZorroHttpClient {
    func uploadorganizationstampImage(uploadorganizationstamp: OrganizationstampUpload, completion: @escaping(Bool, String?) -> ()) {
        
        let urlrequest = ZorroRouter.uploadorganizationStamp(uploadorganizationstamp).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let uploadObject = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if uploadObject.StatusCode == 1000 {
                        completion(true, nil)
                        return
                    }
                    completion(false, "unbale to upload the image")
                    return
                } catch let err {
                    print("error uploading stamp image : \(err.localizedDescription)")
                    completion(false, "error uploading image")
                }
            case .failure(let err):
                print("error while uploading stamp : \(err.localizedDescription)")
                completion(false, "error uploading image")
            }
        }
    }
}

// MARK: - Check Step password is correct

extension ZorroHttpClient {
    func checkStepPassword(stepPassword: StepPassword, completion: @escaping(Bool, String?) -> ()) {
        let urlrequest = ZorroRouter.checkstepPassword(stepPassword).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let uploadObject = try JSONDecoder().decode(CheckStepPassword.self, from: data)
                    if uploadObject.statusCode == 1000 {
                        if uploadObject.data != nil {
                            completion(uploadObject.data!, nil)
                            return
                        }
                        
                        completion(false, "error checking step password")
                        return
                    }
                    completion(false, "unable to check the step password")
                    return
                } catch let err {
                    print("error uploading stamp image : \(err.localizedDescription)")
                    completion(false, "error checking step password")
                }
            case .failure(let err):
                print("error while uploading stamp : \(err.localizedDescription)")
                completion(false, "error checking step password")
            }
        }
    }
}

//MARK: GET document process
extension ZorroHttpClient {
    func getDocumentProcess(instanceID: String, completion: @escaping(DocProcess?, String?, Int?) -> ()) {
        
        let urlrequest = ZorroRouter.getdocumentProcess(instanceID).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                print(data)
                do {
                    let docprocessObject = try JSONDecoder().decode(DocProcess.self, from: data)
                    if docprocessObject.statusCode != 1000 {
                        completion(nil, "Unable to get the doc : \(String(describing: docprocessObject.statusCode))", docprocessObject.statusCode)
                        return
                    }
                    ZorroTempData.sharedInstance.setStep(step: docprocessObject.data?.steps![0].stepNo)
                    completion(docprocessObject, nil, docprocessObject.statusCode)
                    return
                } catch let jsonerro {
                    print("json error : \(jsonerro) : \(jsonerro.localizedDescription)")
                    completion(nil, "json decoding error : \(jsonerro.localizedDescription)",0)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, "Erro getting doc, please try again : \(err.localizedDescription)",0)
            }
        }
    }
}

//MARK: GET document process details
extension ZorroHttpClient {
    func getDocumentProcessDetails(instanceID: String, completion: @escaping(DocProcess?, String?) -> ()) {
        
        let urlrequest = ZorroRouter.getdocumentProcessDetails(instanceID).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                print(data)
                do {
                    let docprocessObject = try JSONDecoder().decode(DocProcess.self, from: data)
                    if docprocessObject.statusCode != 1000 {
                        completion(nil, "Unable to get the doc : \(String(describing: docprocessObject.statusCode))")
                        return
                    }
                    print(docprocessObject)
                    completion(docprocessObject, nil)
                    return
                } catch let jsonerro {
                    print("json error : \(jsonerro) : \(jsonerro.localizedDescription)")
                    completion(nil, "json decoding error : \(jsonerro.localizedDescription)")
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(nil, "Erro getting doc, please try again : \(err.localizedDescription)")
            }
        }
    }
}

//MARK: Download specific pdf
extension ZorroHttpClient {
    func downloadpdfWithUrl(processID: String, objectID: String, docname: String, completion: @escaping(URL?) -> ()) {
        
        let urlrequest = ZorroRouter.downloadPDF(processID, objectID).urlRequest
        
        let destination = DocumentHelper.sharedInstance.returnfileDestination(documentname: docname + ".pdf")
      
        Alamofire.download(urlrequest!, to: destination).responseData { (response) in
            switch response.result {
            case .success( _):
                completion(response.destinationURL)
            case .failure(let err):
                print("error fetching pdf \(err.localizedDescription)")
                completion(response.destinationURL)
            }
        }
    }
}

//MARK: Download files
extension ZorroHttpClient {
    func downloadfileWithUrl(processID: String, objectID: String, documentID: String, completion: @escaping(String?, Bool) -> ()) {
        let urlrequest = ZorroRouter.downloadFile(processID, objectID, documentID).urlRequest
        
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
}

//MARK: - Download files new 
extension ZorroHttpClient {
    func downloadfileWithUrlNew(processid: String, objectId: String, docname: String, completion: @escaping(String? ,Bool) -> ()) {
        let urlrequest = ZorroRouter.downloadFileNew(processid, objectId).urlRequest
        
        let destination = DocumentHelper.sharedInstance.returnfileDestination(documentname: docname)
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

//MARK: - Download the digital certificate
extension ZorroHttpClient {
    func downloadDigitalCertificate(processid: Int, completion: @escaping(String?, Bool) -> ()) {
        let token = UserDefaults.standard.string(forKey: "ServiceToken")!
        let urlrequest = ZorroRouter.downloadDigitalCertificate(processid, token).urlRequest
        
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
}

//MARK: - Download documents new
extension ZorroHttpClient {
    func downloadseperateDocument(processid: String, multidocid: Int, docname: String, completion: @escaping(String?, Bool) -> ()) {
        let token = UserDefaults.standard.string(forKey: "ServiceToken")!
        let urlrequest = ZorroRouter.downloadseperateDocument(processid, multidocid, token).urlRequest
        
        let destination = DocumentHelper.sharedInstance.returnfileDestination(documentname: docname)
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

//MARK: - upload Attachments
extension ZorroHttpClient {
    func uploadFiles(processid: String, docattachment: DocAttachmentsUpload, fileurl: URL, completion: @escaping(Bool) -> ()) {
        
        
        let urlrequest = ZorroRouter.uploadFile(processid).urlRequest
        
        do {
    
            let filedata = try! Data(contentsOf: fileurl)
            let mimetype = docattachment.mimeTypeForPath(path: fileurl.absoluteString)
            let filename = fileurl.lastPathComponent
            
            let jsondata = try JSONEncoder().encode(docattachment)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let docattachdic = docattachment.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            
            
            Alamofire.upload(multipartFormData: { (multipartformData) in
                multipartformData.append(filedata, withName: "file", fileName: filename, mimeType: mimetype)
                
                for (key, value) in docattachdic! {
                    multipartformData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
            }, with: urlrequest!) { (result) in
                switch result {
                case .success(let upload, _ , _):
                    
                    upload.responseData(completionHandler: { (response) in
                        print(response)
                        switch response.result {
                        case .success(let data):
                            print(data)
                            do {
                                let responseobject = try JSONDecoder().decode(CommonUploadResponse.self, from: data)
                                if responseobject.StatusCode == 1000 {
                                    completion(true)
                                    return
                                }
                                completion(false)
                                return
                            } catch (let jsonerr) {
                                print(jsonerr.localizedDescription)
                                completion(false)
                                return
                            }
                        case .failure( _):
                            completion(false)
                        }
                    })
                case .failure(let encodingerr):
                    print(encodingerr.localizedDescription)
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

//MARK: Delete attachments
extension ZorroHttpClient {
    func deleteAttachment(processid: String, objectid: String, tagid: String, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.deleteaFile(processid, objectid, tagid).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobjct = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if responseobjct.StatusCode == 1000 {
                        completion(true)
                        return
                    }
                    completion(false)
                    return
                } catch ( _) {
                    completion(false)
                    return
                }
            case .failure(let err):
                print(err)
                completion(false)
                return
            }
        }
    }
}


//MARK: Save Document Proces
extension ZorroHttpClient {
    func saveDocumentProcess(docsaveprocess: DocSaveProcess, completion: @escaping(DocProcessSaveResponse?, String?) -> ()) {
        
        let urlrequest = ZorroRouter.savedocumentProcess(docsaveprocess).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                print("success block : \(String(describing: String(data: data, encoding: .utf8)))")
                
                do {
                    let responseObject = try JSONDecoder().decode(DocProcessSaveResponse.self, from: data)
                    if responseObject.StatusCode != 1000 {
                        completion(nil, responseObject.Message)
                        return
                    }
                    
                    let responsedataObject = responseObject.Data![0]
                    if responsedataObject.StatusCode != 1000 {
                        completion(nil, responsedataObject.Message)
                        return
                    }
                    completion(responseObject, nil)
                    return
                } catch let jsonerror {
                    completion(nil, "\(jsonerror)")
                }
            case .failure(let err):
                print("error saving process : \(err.localizedDescription)")
            }
        }
        
    }
}

//MARK: Get Document Trail Details
extension ZorroHttpClient {
    func getDocumentTrailDetails(getdocumenttrail: GetDocumentTrail, completion: @escaping(DocumentTrailDetails?, Bool, Int?) -> ()) {
        
        let urlrequest = ZorroRouter.getdocumentTrailDetails(getdocumenttrail).urlRequest
        
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
}

//MARK: Get UTC data from static json file
extension ZorroHttpClient {
    func getUTCTimeZoneData(completion: @escaping([ZorroTimeZone]?) -> ()) {
        
        guard let url = ZorroTempStrings.UTC_TIMEZONE_FILE_URL else {
            print("unable to read")
            completion([])
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let timezones = try JSONDecoder().decode([ZorroTimeZone].self, from: data)
            completion(timezones)
            return
        } catch let err {
            print(err.localizedDescription)
            completion([])
            return
        }

    }
}

//MARK: Request to read permissions
extension ZorroHttpClient {
    func requestPermissionforDocTrail(getdocumentdetails: GetDocumentDetails, completion: @escaping(Bool, String?, Int?) -> ()) {
        
        let urlrequest = ZorroRouter.requestdocumenttrailPermission(getdocumentdetails).urlRequest
        
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
}

//MARK: - Get uppr login details
extension ZorroHttpClient {
    func getuserUpprLoginDetails(upprcode: String, completion: @escaping(UpprLogin?, Bool, Int?) -> ()) {
        
        DispatchQueue.main.async {
            let urlrequest = ZorroRouter.getupprLogin(upprcode).urlRequest
            
            Alamofire.request(urlrequest!).responseData { (response) in
                switch response.result {
                case .success(let data):
                    do {
                        let responseobject = try JSONDecoder().decode(UpprLogin.self, from: data)
                        if responseobject.StatusCode == 1000 {
                            completion(responseobject, false, responseobject.StatusCode)
                            return
                        }
                        if responseobject.StatusCode == 3625 {
                            completion(nil, false, responseobject.StatusCode)
                            return
                        }
                        completion(nil, true, responseobject.StatusCode)
                        return
                    } catch(let jsonerr) {
                        completion(nil, true, 0)
                        print(jsonerr.localizedDescription)
                        return
                    }
                case .failure(let err):
                    completion(nil, true, 0)
                    print(err.localizedDescription)
                    return
                }
            }
        }
    }
}

//MARK: - Get uppr details
extension ZorroHttpClient {
    func getuserUpprDetails(upprcode: String, completion: @escaping(UpprDetails?, Bool) -> ()) {
        
        let urlrequest = ZorroRouter.getupprDetails(upprcode).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(UpprDetails.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        completion(responseobject, false)
                        return
                    }
                    completion(nil, true)
                    return
                } catch(let jsonerr) {
                    completion(nil, true)
                    print(jsonerr.localizedDescription)
                    return
                }
            case .failure(let err):
                completion(nil, true)
                print(err.localizedDescription)
                return
            }
        }
    }
}

//MARK: - Get push notification details
extension ZorroHttpClient {
    func getpushnotificationDetails(deviceide: String, completion:@escaping([NotificationDetails]?) -> ()) {
        
        let urlrequest = ZorroRouter.getNotifications(deviceide).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(ReceiveNotification.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        
                        if let notifications = responseObject.Data {
                            completion(notifications)
                            return
                        }
                        completion(nil)
                        return
                    }
                    completion(nil)
                    return
                } catch (let jsonerr) {
                    print(jsonerr)
                    completion(nil)
                    return
                }
            case .failure(let err):
                print(err)
                completion(nil)
                return
            }
        }
    }
}

//MARK: - Update push notification details
extension ZorroHttpClient {
    func updatepushnotificationStatus(updatepush: [UpdateNotification], completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.updateNotification(updatepush).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(true)
                        return
                    }
                    completion(false)
                    return
                } catch(let jsonerr) {
                    print(jsonerr)
                    completion(false)
                    return
                }
            case .failure(let err):
                print(err)
                completion(false)
                return
            }
        }
        
    }
}

//MARK: - Create Work flow
extension ZorroHttpClient {
    func createdocumentWorkFlow(createworkflow: CreateWorkflow, completion: @escaping(Int?) -> ()) {
        
        let urlrequest = ZorroRouter.createWorkFlow(createworkflow).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonCreateworkflowResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(responseObject.Data!)
                        return
                    }
                    completion(nil)
                    return
                } catch (_) {
                    completion(nil)
                    return
                }
            case .failure(_):
                completion(nil)
                return
            }
        }
    }
}

//MARK: Upload files for create workflow
extension ZorroHttpClient {
    func uploadfiletocreateWorkFlow(workflowid: String, createworkflowupload: CreateWorkflowUpload, fileurl: URL, completion: @escaping(Bool) -> ()) {
        
        let urlrequest = ZorroRouter.uploadworkflowFile(workflowid).urlRequest
        
        do {
            //TODO: - check the issue here
            print("FILE URL : \(fileurl)")
            let filedata = try? Data(contentsOf: fileurl)
            let mimetype = createworkflowupload.mimeTypeForPath(path: fileurl.absoluteString)
            let filename = createworkflowupload.CustomDocumentName
            
            let jsondata = try JSONEncoder().encode(createworkflowupload)
            let jsonstring = String(data: jsondata, encoding: .utf8)
            let workflowfiledic = createworkflowupload.convertdocprocesstoDictonary(jsonstring: jsonstring!)
            
            if filedata == nil {
                completion(false)
                return
            }
            
            Alamofire.upload(multipartFormData: { (multipartformData) in
                multipartformData.append(filedata!, withName: "file", fileName: filename!, mimeType: mimetype)
                
                for (key, value) in workflowfiledic! {
                     multipartformData.append("\(value)".data(using: .utf8)!, withName: key as String)
                }
                
            }, with: urlrequest!) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseData(completionHandler: { (response) in
                        switch response.result {
                        case .success(let data):
                            do {
                                let responseObject = try JSONDecoder().decode(CommonCreateworkflowUploadResponse.self, from: data)
                                if responseObject.StatusCode == 1000 {
                                    completion(true)
                                    return
                                }
                                completion(false)
                                return
                            } catch(_) {
                                completion(false)
                                return
                            }
                        case .failure(_):
                            completion(false)
                            return
                        }
                    })
                case .failure(_):
                    completion(false)
                    return
                }
            }
        } catch (_) {
            completion(false)
            return
        }
    }
}

//MARK: - Get contact list summary details
extension ZorroHttpClient {
    func getcontactlistforCreateWorkflow(completion: @escaping([ContactData]?) -> ()) {
        
        let urlrequest = ZorroRouter.getcontactList.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(CreateworkflowContactList.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        completion(responseobject.Data)
                        return
                    }
                    completion(nil)
                    return
                } catch let jsonerr {
                    print(jsonerr)
                    completion(nil)
                    return
                }
            case .failure(_):
                completion(nil)
                return
            }
        }
        
    }
}

//MARK: - Create a new contact
extension ZorroHttpClient {
    func createnewcontactforCreateWorkflow(createcontact: CreateNewContact, completion: @escaping(Bool, ContactData?) -> ()) {
        
        print(createcontact)
        
        let urlrequest = ZorroRouter.createnewContact(createcontact).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(CommonCreateContactResponse.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        completion(true, responseobject.Data)
                        return
                    }
                    completion(false, nil)
                    return
                } catch let jsonerr {
                    print(jsonerr)
                    completion(false, nil)
                    return
                }
            case .failure(let err):
                print(err)
                completion(false, nil)
                return
            }
        }
    }
}

//MARK: Get Workflow
extension ZorroHttpClient {
    func getworkflowDetails(workflowid: String, completion: @escaping(GetWorkflow?) -> ()) {
        
        let urlrequest = ZorroRouter.getWorkflow(workflowid).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            
            switch response.result {
            case .success(let data):
                do {
                    let responseobject = try JSONDecoder().decode(GetWorkflow.self, from: data)
                    if responseobject.StatusCode == 1000 {
                        completion(responseobject)
                        return
                    }
                    completion(nil)
                    return
                } catch let jsonerr {
                    print(jsonerr)
                    return
                }
            case .failure(let err):
                print(err)
                return
            }
        }
    }
}

//MARK: Download wofkflow initiate pdf
extension ZorroHttpClient {
    func downlaodworkflowPDF(workflowid: String, objectid: String, documentname: String, completion: @escaping(URL?) -> ()) {
        
        let urlrequest = ZorroRouter.downloadworkflowPDF(workflowid, objectid).urlRequest
        let destination = DocumentHelper.sharedInstance.returnfileDestination(documentname: documentname + ".pdf")
        
        Alamofire.download(urlrequest!, to: destination).responseData { (response) in
            switch response.result {
            case .success( _):
                completion(response.destinationURL)
            case .failure(let err):
                print("error fetching pdf \(err.localizedDescription)")
                completion(nil)
            }
        }
    }
}

//MARK: Save Workflow - eSign
extension ZorroHttpClient {
    func saveinitiatedWorkFlow(docsaveworkflow: DocSaveWorkflow, completion: @escaping(Bool, String?) -> ()) {
        
        let urlrequest = ZorroRouter.saveworkflow(docsaveworkflow).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let resposnseObject = try JSONDecoder().decode(CommonSaveWorkFlowResponse.self, from: data)
                    if resposnseObject.StatusCode == 1000 {
                        completion(true, resposnseObject.Message)
                        return
                    }
                    completion(false, resposnseObject.Message)
                    return
                } catch (let jsonerr) {
                    print(jsonerr)
                    completion(false, jsonerr.localizedDescription)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, err.localizedDescription)
                return
            }
        }
    }
}

//MARK: Create Process
extension ZorroHttpClient {
    func createinitiatedProcesse(createprocess: CreateProcess, completion: @escaping(Bool, Int?) -> ()) {
        
        let urlrequest = ZorroRouter.createProces(createprocess).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonCreateProcessResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(true, responseObject.Data)
                        return
                    }
                    completion(false, nil)
                    return
                } catch ( _) {
                    completion(false, nil)
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil)
                return
            }
        }
    }
}

//MARK: Get KBA Questions
extension ZorroHttpClient {
    
    func getKBAQuestionsFromApi(kbarequest: KBAQuestionRequest, completion: @escaping(KBAQuestionResponseData?, Bool, String?) -> ()) {
        
        let urlrequest = ZorroRouter.getKBAQuestions(kbarequest).urlRequest

        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(KBAQuestionResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        if let _questions = responseObject.Data {
                            completion(_questions, false, nil)
                            return
                        }
                        completion(nil, true, "Unable to access KBA Questions")
                        return
                    }
                    
                    if responseObject.StatusCode == 3976 {
                        completion(nil, true, "First Name, Last Name or SSN was entered incorrectly, please try again.")
                        return
                    }
                    
                    if responseObject.StatusCode == 3990 {
                        completion(nil, true, "First Name, Last Name or SSN was entered incorrectly, as a result, this document has been canceled.")
                        return
                    }
                    
                    if responseObject.StatusCode == 3989 {
                        completion(nil, true, "You have failed to answer the KBA questions within two attempts, as a result, this document has been canceled.")
                        return
                    }
                    
                    completion(nil, true, "An error occurred with Knowledge Based Authentication, please try again later.")
                    return
                } catch (let err) {
                    print(err.localizedDescription)
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
    
}
//MARK: Send KBA Answers

extension ZorroHttpClient {
    
    func sendKBAAnswers(kbaanswerrequest: KBAAnswerRequest, completion: @escaping(Bool, [KBAQuestions]?, String?, String?) -> ()) {
        
        let urlrequest = ZorroRouter.sendKBAAnswerRequest(kbaanswerrequest).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(KBAQuestionResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        
                        if let _status = responseObject.Data?.Status {
                            if _status == 1 {
                                completion(true, nil, nil, nil)
                                return
                            }
                            
                            if _status == 2 {
                                completion(false, responseObject.Data?.Questions, responseObject.Data?.QuestionSetId ,nil)
                                return
                            }
                            
                            if _status == 3 {
                                completion(false, nil, nil, responseObject.Message ?? "")
                                return
                            }
                            
                            completion(false, nil, nil, responseObject.Message ?? "")
                            return
                        }
                        completion(false, nil, nil, responseObject.Message ?? "")
                        return
                    }
                    completion(false, nil, nil,"Knowledge Based Authentication questions were answered incorrectly, as a result, this document has been canceled.")
                    return
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(false, nil, nil, nil)
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, nil, nil, nil)
                return
            }
        }
    }
}

//MARK: - Get Organization Settings
extension ZorroHttpClient {
    func getOrganizationSettings(completion: @escaping(GetOrganizationSettings?) -> ()) {
        
        let urlrequest = ZorroRouter.getOraganizationSettings.urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(GetOrganizationSettings.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(responseObject)
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

//MARK: Post Organization Settings
extension ZorroHttpClient {
    func saveOrganizationSettings(postorgSettings: PostOrganizationSettings, completion: @escaping(Bool, String?) ->()) {
        
        let urlrequest = ZorroRouter.postOrganizationSettings(postorgSettings).urlRequest
        
        Alamofire.request(urlrequest!).responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonOrganizationSettingsResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(responseObject.Data ?? false, nil)
                        return
                    }
                    completion(false, responseObject.Message ?? "Unable to save")
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(false, "Unable to save")
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, "Unable to save")
                return
            }
        }
    }
}

extension Request {
    public func debugLogsHttp() -> Self {
        #if DEBUG
        debugPrint("=======================================")
        debugPrint(self)
        debugPrint("=======================================")
        #endif
        return self
    }
}

// MARK: - POST Security Questions & Answers
extension ZorroHttpClient {
    func saveSecurityQuestions(securityQuestion: FallbackQuestionRequest, completion: @escaping(Bool, String?) ->()) {
        
        let urlrequest = ZorroRouter.sendSecurityQuestion(securityQuestion).urlRequest
        
        Alamofire.request(urlrequest!).debugLogsHttp().responseData { (response) in
            switch response.result {
            case .success(let data):
                do {
                    let responseObject = try JSONDecoder().decode(CommonUpdateResponse.self, from: data)
                    if responseObject.StatusCode == 1000 {
                        completion(responseObject.Data ?? false, nil)
                        return
                    }
                    completion(false, responseObject.Message ?? "Unable to save")
                } catch(let jsonerr) {
                    print(jsonerr.localizedDescription)
                    completion(false, "Unable to save")
                    return
                }
            case .failure(let err):
                print(err.localizedDescription)
                completion(false, "Unable to save")
                return
            }
        }
    }
}
