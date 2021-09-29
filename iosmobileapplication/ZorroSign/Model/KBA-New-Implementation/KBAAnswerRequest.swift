//
//  KBAAnswerRequest.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct KBAAnswerRequest: Codable {
    var Answers: KBAAnswers?
    var ConversationId: String?
    var InstanceId: Int?
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

struct KBAAnswers: Codable {
    var QuestionSetId: String?
    var Questions: [KBAAnswerQuestions] = []
}

struct KBAAnswerQuestions: Codable {
    var Choices: [KBAAnswerQuestionChoices]?
    var QuestionId: String?
}

struct KBAAnswerQuestionChoices: Codable {
    var Choice: String?
}

extension KBAAnswerRequest {
    func sendUserKBAAnswers(kbaAnswers: KBAAnswerRequest, completion: @escaping(Bool, [KBAQuestions]?, String?, String?) -> ()) {
        
        ZorroHttpClient.sharedInstance.sendKBAAnswers(kbaanswerrequest: kbaAnswers) { (status, kbaquestions, kbaquestionsetId, errormessage) in
            completion(status, kbaquestions, kbaquestionsetId, errormessage)
            return
        }
    }
}
