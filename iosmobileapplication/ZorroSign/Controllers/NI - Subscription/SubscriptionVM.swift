//
//  SubscriptionVM.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-04-19.
//  Copyright © 2021 Apple. All rights reserved.
//

import Foundation
import Alamofire

class SubscriptionVM {
    
    var receiptData: ReceiptData?
    var iapTransactionDetail = IAPTransactionDetail()
    var isSandbox = false
    
    func getReceipt() -> String {
        var receiptString: String = ""
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
            FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

            do {
                let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                print(receiptData)

                receiptString = receiptData.base64EncodedString(options: [])
            }
            catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
        }
        
        return receiptString
    }
    
    func netReqReceiptValidation(url: String, completion: @escaping (Bool, Int, String) -> ()) {
        
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet found. Check your network connection and Try again...")
            return
        }
        
        let params = [
            "receipt-data": getReceipt(),
            "password": "94731fcd207c429ab30403d7ab0cf138",
            "exclude-old-transactions":false
        ] as [String: Any]
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: Singletone.shareInstance.headerAPI)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let responseObject = try JSONDecoder().decode(ReceiptData.self, from: data)
                        
                        guard let status = responseObject.status, status == 0 else {
                            if responseObject.status == 21007 {
                                self.isSandbox = true
                                completion(false, 21007, "need_sandbox_url")
                            } else {
                                completion(false, 500, "something went wrong")
                            }
                            return
                        }
                        
                        self.receiptData = responseObject
                        completion(true, status, "success")
                    } catch (let err) {
                        completion(false, 500, err.localizedDescription)
                    }
                case .failure(let err):
                    completion(false, 500, err.localizedDescription)
                }
            }
    }
    
    func netReqPostTransactionData(completion: @escaping (Bool, Int, String) -> ()) {
        
        guard Connectivity.isConnectedToInternet() else {
            completion(false, 503, "No internet found. Check your network connection and Try again...")
            return
        }
        
        iapTransactionDetail.originalTransactionId = receiptData?.latest_receipt_info?[0].original_transaction_id
        iapTransactionDetail.transactionId = receiptData?.latest_receipt_info?[0].transaction_id
        iapTransactionDetail.userEmail = ZorroTempData.sharedInstance.getUserEmail()
        iapTransactionDetail.newProductId = receiptData?.latest_receipt_info?[0].product_id
        
        iapTransactionDetail.receiptData = getReceipt()
        iapTransactionDetail.password = Singletone.shareInstance.app_specific_shared_secret
        iapTransactionDetail.isSandbox = isSandbox
        
        iapTransactionDetail.postIAPTransactionData(transactionData: iapTransactionDetail) { (success, statusCode, message) in
            if let _message = message {
                completion(success, statusCode, _message)
            }
        }
    }
}
