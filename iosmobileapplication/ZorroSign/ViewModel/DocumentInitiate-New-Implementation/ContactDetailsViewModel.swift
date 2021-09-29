//
//  CreateNewContactViewModel.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct ContactDetailsViewModel:Hashable, Equatable {
    
    var uuId: String?
    let IdNum: Int?
    let Id: String?
    let ContactProfileId: String?
    let Name: String?
    let Email: String?
    let Company: String?
    let JobTitle: String?
    let profileimage: String?
    let `Type`: Int?
    let userType: Int?
    var isSelected: Bool = false
    var GroupContactEmails: String?
  
    init(contactdata: ContactData) {
        self.uuId = UUID().uuidString
        self.IdNum = contactdata.IdNum
        self.Id = contactdata.Id
        self.ContactProfileId = contactdata.ContactProfileId
        self.Company = contactdata.Company
        self.Name = contactdata.Name
        self.Email = contactdata.Email
        self.JobTitle = contactdata.JobTitle
        var thumbnail = contactdata.Thumbnail
        
        if thumbnail == "" {
            thumbnail = "DefaultProfileSmall.jpg"
            if contactdata.Type == 1 {
                thumbnail = "DefaultProfileSmall.jpg"
            }
            if contactdata.Type == 2 {
                thumbnail = "DefaultContactGroupImage.jpg"
            }
        } else {
            thumbnail = "DefaultProfileSmall.jpg"
            if contactdata.Type == 2 {
                thumbnail = "DefaultContactGroupImage.jpg"
            }
        }
        
        self.profileimage = "https://s3.amazonaws.com/zfpi/\(thumbnail!)"
        self.Type = contactdata.Type
        userType = contactdata.UserType
        GroupContactEmails = contactdata.GroupContactEmails
    }
}

//MARK: - Check if initiator exists
extension ContactDetailsViewModel {
    func isInitiatorExists(initiatr: ContactDetailsViewModel, selected: [ContactDetailsViewModel]) -> [ContactDetailsViewModel] {
        
        let filtered = selected.filter {
            $0.uuId != initiatr.uuId
        }
        return filtered
    }
}
