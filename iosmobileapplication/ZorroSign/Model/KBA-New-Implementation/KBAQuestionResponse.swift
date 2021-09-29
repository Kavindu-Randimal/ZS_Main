//
//  KBAQuestionResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct KBAQuestionResponse: Codable {
    var StatusCode: Int?
    var Message: String?
    var `Data`: KBAQuestionResponseData?
}

struct KBAQuestionResponseData: Codable {
    var Status: Int?
    var ConversationId: String?
    var QuestionSetId: String?
    var Questions: [KBAQuestions]?
}

struct KBAQuestions: Codable {
    var QuestionId: String?
    var Key: String?
    var `Type`: String?
    var Text: KBAText?
    var HelpText: KBAHelpText?
    var Choices: [KBAChoices]?
}

struct KBAText: Codable {
    var Statement: String?
}

struct KBAHelpText: Codable {
    var Statement: String?
}

struct KBAChoices: Codable {
    var ChoiceId: String?
    var Text: KBAText?
}
