//
//  KBAQuestionRequest.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct KBAQuestionRequest: Codable {
    var InstanceId: Int?
    var SSN: Int?
    var StepId: Int?
    
    func convertdocprocesstoDictonary(jsonstring: String) -> [String: Any]? {
        if let data = jsonstring.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch let jsonerr {
                print("\(jsonerr.localizedDescription)")
            }
        }
        return nil
    }
}

extension KBAQuestionRequest {
    func getKBAQuestions(kbarequest: KBAQuestionRequest, completion: @escaping(KBAQuestionResponseData?, Bool, String?) -> ()) {
        ZorroHttpClient.sharedInstance.getKBAQuestionsFromApi(kbarequest: kbarequest) { (_response, _err, _message) in
            completion(_response, _err, _message)
            return
        }
    }
}
