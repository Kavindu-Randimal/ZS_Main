//
//  SecurityQuestionAnswer.swift
//  ZorroSign
//
//  Created by Mathivathanan on 7/13/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct FallbackQuestionRequest: Codable {
    var FallbackQuestions: [SecurityQuestionAnswer]?
}

struct SecurityQuestionAnswer: Codable {
    
    var Answer: String?
    var AnswerId: String?
    var Question: String?
    var QuestionId: String?
    var UserId: String?
    
    init(securityQuestion: SecurityQuestion) {
        self.Answer = securityQuestion.answer
        self.AnswerId = securityQuestion.answerId
        self.Question = securityQuestion.questionModel?.questionPart?.Question
        self.QuestionId = securityQuestion.questionModel?.questionPart?.QuestionId
        self.UserId =  ZorroTempData.sharedInstance.getUserEmail()
    }
}

extension FallbackQuestionRequest {
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

extension FallbackQuestionRequest {
    func updateSecurityQuestionAnswerData(securityQuestionAnswerUpdate: FallbackQuestionRequest, completion:@escaping(Bool, String?) -> ()){
        ZorroHttpClient.sharedInstance.saveSecurityQuestions(securityQuestion: securityQuestionAnswerUpdate) { (success, errmsg) in
            
            if !success {
                completion(false, errmsg)
                return
            }
            completion(true, nil)
            return
        }
    }
}
