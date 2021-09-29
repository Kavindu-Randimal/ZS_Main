//
//  DocProcessSaveResponse.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocProcessSaveResponse: Codable {
    
    let StatusCode: Int?
    let Message: String?
    let `Data`: [DataHighLevel]?
}

struct DataHighLevel: Codable {
    
    let StatusCode: Int?
    let Message: String?
    let `Data`: DataLowLevel?
}

struct DataLowLevel: Codable {
    let ProcessId: Int?
    let DefinitionId: Int?
    let Documents: [SavedDocuments]?
}

struct SavedDocuments: Codable {
    let Id: Int?
    let ObjectId: String?
    let DocType: Int?
}
