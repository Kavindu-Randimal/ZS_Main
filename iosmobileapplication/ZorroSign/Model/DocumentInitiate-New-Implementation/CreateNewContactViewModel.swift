//
//  CreateNewContactViewModel.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ContactDetailsViewModel: Codable {
    
    let Company: String?
    let DisplayName: String?
    let Email: String?
    let Firstname: String?
    let JobTitle: String?
    let Lastname: String?
    let MiddleName: String?
    var isSelected: Bool = false
    
    init(createcontact: CreateNewContact) {
        self.Company = createcontact.Company
        self.DisplayName = createcontact.DisplayName
        self.Email = createcontact.Email
        self.Firstname = createcontact.Firstname
        self.JobTitle = createcontact.JobTitle
        self.Lastname = createcontact.Lastname
        self.MiddleName = createcontact.MiddleName
    }
}
