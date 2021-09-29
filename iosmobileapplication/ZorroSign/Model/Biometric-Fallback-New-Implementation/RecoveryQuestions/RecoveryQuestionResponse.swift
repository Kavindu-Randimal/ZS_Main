//
//  RecoveryQuestionResponse.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct RecoveryQuestionResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: [FallbackQuestions]?
}

struct FallbackQuestions: Codable {
    var Question: String?
    var QuestionId: String?
}

struct FallbackQuestionsWithSelect: Equatable {
    
    var questionPart: FallbackQuestions?
    var isSelected: Bool = false
    
    static func == (lhs: FallbackQuestionsWithSelect, rhs: FallbackQuestionsWithSelect) -> Bool {
        return lhs.questionPart?.Question == rhs.questionPart?.Question
    }
}

//MARK: Request Fallback Questions
extension RecoveryQuestionResponse {
    func requestFallbackQuestions(completion: @escaping([FallbackQuestions]?) -> ()) {
        ZorroHttpClient.sharedInstance.requestFallbackQuestions { (fallbackquestions) in
            completion(fallbackquestions)
            return
        }
    }
}
