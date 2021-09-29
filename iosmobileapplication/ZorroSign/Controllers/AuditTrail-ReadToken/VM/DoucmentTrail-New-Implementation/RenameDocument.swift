//
//  RenameDocument.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 5/15/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

struct RenameDocument {
    
    var renamedocumentSub: [RenameDocumentSub] = []
    
    init(documenttrailDetails: DocumentTrailDetails?) {
        
        if let renameDocuments = documenttrailDetails?.Data?.DocumentRenameHistory {
            
            for renamedDocument in renameDocuments {
                let renamedocumentsub = RenameDocumentSub(documentsetName: renamedDocument.DocumentSetName, modifieddateTime: setUtc(datestring: renamedDocument.ModifiedDateTime), modifiedbyProfileId: renamedDocument.ModifiedByProfileId, renameatStepNo: renamedDocument.RenamedAtStepNo, documentsetPreviouseName: renamedDocument.DocumentSetPreviousName, changedTime: setdateFormat(datestring: setUtc(datestring: renamedDocument.ModifiedDateTime)))
                renamedocumentSub.append(renamedocumentsub)
            }
        }
    }
}

//MARK: - Reformat
extension RenameDocument {
    func updatedRenameHistory(renameHistory: RenameDocument, selectedtimezone: ZorroTimeZone) -> RenameDocument {
        
        var newrenameHistory = renameHistory
        newrenameHistory.renamedocumentSub = []
        
        for var renamedoc in renameHistory.renamedocumentSub {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            var date = dateformatter.date(from: renamedoc.modifieddateTime!)
            
            let utcoffset = selectedtimezone.BaseUtcOffset!
            let splittedutcoffset = utcoffset.components(separatedBy: ":")
            let hours = Int(splittedutcoffset[0])
            let minutes = Int(splittedutcoffset[1])
            let seconds = Int(splittedutcoffset[2])
            
            date = Calendar.current.date(byAdding: .hour, value: hours!, to: date!)
            date = Calendar.current.date(byAdding: .minute, value: minutes!, to: date!)
            date = Calendar.current.date(byAdding: .second, value: seconds!, to: date!)
            
            let datestring = dateformatter.string(from: date!)
            let newdate = setdateFormat(datestring: datestring)
            
            renamedoc.changedTime = newdate
            newrenameHistory.renamedocumentSub.append(renamedoc)
        }
        
        return newrenameHistory
    }
}

//2020-05-04T06:39:09
//MM/dd/yyyy HH:mm:ss a
//MARK: - Format to utc  change MM/dd/yyyy HH:mm:ss a(5/4/2020 6:39:09 AM) to 2020-05-04T06:39:09 fromat
extension RenameDocument {
    fileprivate func setUtc(datestring: String?) -> String {
        let modifiedString = datestring!.components(separatedBy: " ")
        var yearmonthdayportion = modifiedString[0]
        let hourminutesecondportion = modifiedString[1]
        
        let modifiedString2 = hourminutesecondportion.components(separatedBy: ":")
        var hourportion = modifiedString2[0]
        var minportion = modifiedString2[1]
        var secondsportion = modifiedString2[2]
        if hourportion.count < 2 {
            hourportion = "0" + hourportion
        }
        if minportion.count < 2 {
            minportion = "0" + minportion
        }
        if secondsportion.count < 2 {
            secondsportion = "0" + secondsportion
        }
        
        let hourminutesecondportionModified = hourportion + ":" + minportion + ":" + secondsportion
        
        let modifiedString3 = yearmonthdayportion.components(separatedBy: "/")
        let yearportion = modifiedString3[2]
        var monthportion = modifiedString3[0]
        var dayportion = modifiedString3[1]
        if monthportion.count < 2 {
            monthportion = "0" + monthportion
        }
        if dayportion.count < 2 {
            dayportion = "0" + dayportion
        }
        
        yearmonthdayportion = yearportion + "-" + monthportion + "-" + dayportion
        
        let modifiedDatestring = yearmonthdayportion + "T" + hourminutesecondportionModified
        
        return modifiedDatestring
    }
}

//MARK: - Set to UI date format after initail format
extension RenameDocument {
    fileprivate func setdateFormat(datestring: String?) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateformatter.date(from: datestring!)
        
        //reformat the month,date and year
        dateformatter.dateFormat = "MM"
        let month = getMonth(index: dateformatter.string(from: date!))
        
        dateformatter.dateFormat = "dd"
        let day = dateformatter.string(from: date!)
        
        dateformatter.dateFormat = "yyyy"
        let year = dateformatter.string(from: date!)
        
        let dateonly = month + " " + day + "," + year
        
        //get the time
        dateformatter.dateFormat = "HH:mm:ss a"
        dateformatter.amSymbol = "AM"
        dateformatter.pmSymbol = "PM"
        let timeonly = dateformatter.string(from: date!)
        
        let changeddatetime = dateonly + " at " + timeonly
        return changeddatetime
    }
}

//MARK: - Get month
extension RenameDocument {
    fileprivate func getMonth(index: String) -> String {
        let month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let monthstring = month[Int(index)! - 1]
        return monthstring
    }
}

struct RenameDocumentSub {
    var documentsetName: String?
    var modifieddateTime: String?
    var modifiedbyProfileId: String?
    var renameatStepNo: Int?
    var documentsetPreviouseName: String?
    var changedTime: String?
}
