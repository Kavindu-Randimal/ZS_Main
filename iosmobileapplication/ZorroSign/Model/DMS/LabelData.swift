//
//  LabelData.swift
//  ZorroSign
//
//  Created by Apple on 03/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class LabelData: WSBaseData {

    /*
     "Id": 13385,
     "Name": "AAAAAA",
     "LabelCategory": 0,
     "IsDeleted": false,
     "ParentId": 0,
     "CreatedDateTime": "0001-01-01T00:00:00",
     "LastUpdatedDateTime": "0001-01-01T00:00:00",
     "Color": "#64dd17"
     */
    var Id: Int?
    var Name: String?
    var LabelCategory: Int?
    var IsDeleted: Bool?
    var ParentId: Int?
    var CreatedDateTime: String?
    var LastUpdatedDateTime: String?
    var Color: String?
    var selected: Bool?
    var Labels:[LabelData] = []
    var type: Int = 0
    var expanded: Bool = false
    var isArchive: Int = 0
    var DashboardCategoryType: String = ""
    var dispCatArr:[String] = []
    var MainDocumentType: Int = 0
    var IsBulkSend: Bool = false
    
    override func populate(fromDictionary dict: NSDictionary) {
        super.populate(fromDictionary: dict)
        
        if let id = dict.object(forKey: "Id") as? Int {
            self.Id = id
        }
        if let name = dict.object(forKey: "Name") as? String {
            self.Name = name
        }
        if let labelCat = dict.object(forKey: "LabelCategory") as? Int {
            self.LabelCategory = labelCat
        }
        if let deleted = dict.object(forKey: "IsDeleted") as? Bool {
            self.IsDeleted = deleted
        }
        if let parentId = dict.object(forKey: "ParentId") as? Int {
            self.ParentId = parentId
        }
        if let created = dict.object(forKey: "CreatedDateTime") as? String {
            self.CreatedDateTime = created
        }
        if let lastupdated = dict.object(forKey: "LastUpdatedDateTime") as? String {
            self.LastUpdatedDateTime = lastupdated
        }
        if let color = dict.object(forKey: "Color") as? String {
            self.Color = color
        }
        if let type = dict.object(forKey: "type") as? Int {
            self.type = type
        }
        if let catType = dict.object(forKey: "DashboardCategoryType") as? String {
            self.DashboardCategoryType = catType
        }
        if let MainDocumentType = dict.object(forKey: "MainDocumentType") as? Int {
            self.MainDocumentType = MainDocumentType
        }
        if let IsBulkSend = dict.object(forKey: "IsBulkSend") as? Bool {
            self.IsBulkSend = IsBulkSend
        }
        
        self.selected = false
    }
    
    func toDictionary()-> NSMutableDictionary {
        let dic: NSMutableDictionary = NSMutableDictionary.init()
        
        dic["Id"] = self.Id
        dic["ParentId"] = self.ParentId
        let id: Int = self.Id!
        let pid: Int = self.ParentId!
        dic["Name"] = self.Name! + "#\(id)" + "#\(pid)"
        dic["Labels"] = []
        dic["Color"] = self.Color
        dic["type"] = self.type
        dic["expanded"] = self.expanded
        dic["LabelCategory"] = self.LabelCategory
        dic["CreatedDateTime"] = self.CreatedDateTime ?? ""
        dic["IsDeleted"] = self.IsDeleted
        dic["LastUpdatedDateTime"] = self.LastUpdatedDateTime
        dic["DashboardCategoryType"] = self.DashboardCategoryType
        dic["isArchive"] = self.isArchive
        dic["MainDocumentType"] = self.MainDocumentType
        dic["IsBulkSend"] = self.IsBulkSend
        
        return dic
    }
}
