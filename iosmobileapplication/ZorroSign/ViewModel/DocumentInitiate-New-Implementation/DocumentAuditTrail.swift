//
//  DocumentAuditTrail.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocumentAuditTrail {
    var trailIndex: Int = 0
    var documentStep: String?
    var recepientName: String?
    var recepientImage: String?
    var documentdueDate: String?
    var sinatories: [Signatory]?
    var tagtypes: [Int]?
    var shouldhideName: Bool = false
    var shouldhideDate: Bool = false
    var shouldhideleftLine: Bool = false
    var shouldhiderightLine: Bool = false
    var shouldhideleftVertical: Bool = false
    var shouldhiderighVertical: Bool = false
    
}

//MARK: - prepare trail
extension DocumentAuditTrail {
    func gettrailDetails(step: Steps) -> [DocumentAuditTrail] {
        var documentauditTrail: [DocumentAuditTrail] = []
        var signatories: [[Signatory]] = []
        //MARK: - CC tools
        if step.CCList.count > 0 {
            let(isidentical, index) = compareSinatories(current: step.CCSignatories!, allsignatures: signatories)
            if isidentical {
                if let index = index {
                    documentauditTrail[index].tagtypes?.append(9)
                }
            } else {
                signatories.append(step.CCSignatories!)
                
                let signatorycount = step.CCSignatories!.count
                var username = step.CCSignatories![0].friendlyName
                var userimage = step.CCSignatories![0].profileImage
                
                //let duedate = "MMM dd, yyyy"
                let duedate = ""
                
                signatorycount > 1 ? (username = "Multiple - \(signatorycount)") : (username = username)
                signatorycount > 1 ? (userimage = "https://s3.amazonaws.com/zfpi/DefaultContactGroupImage.jpg") : (userimage = userimage)
                
                let documentauditrail = DocumentAuditTrail(trailIndex: 0,documentStep: step.StepNo, recepientName: username, recepientImage: userimage, documentdueDate: duedate, sinatories: step.CCSignatories!, tagtypes: [9], shouldhideName: false, shouldhideDate: false, shouldhideleftLine: false, shouldhiderightLine: false, shouldhideleftVertical: false, shouldhiderighVertical: false)
                documentauditTrail.append(documentauditrail)
            }
        }
        
        //MARK: - other tools
        for tag in step.Tags {
            if tag.Type == 6 {
                //var duedate = "MMM dd, yyyy"
                var duedate = ""
                if let duedatevalue = tag.dueDate {
                    duedate = duedatevalue
                }
                let documentauditrail = DocumentAuditTrail(trailIndex: 0,documentStep: step.StepNo, recepientName: nil, recepientImage: nil, documentdueDate: duedate, sinatories: tag.Signatories, tagtypes: [tag.Type!], shouldhideName: true, shouldhideDate: true, shouldhideleftLine: false, shouldhiderightLine: false, shouldhideleftVertical: false, shouldhiderighVertical: false)
                documentauditTrail.append(documentauditrail)
            } else {
                let(isidentical, index) = compareSinatories(current: tag.Signatories!, allsignatures: signatories)
                if isidentical {
                    if let index = index {
                        if let duedatevalue = tag.dueDate {
                            documentauditTrail[index].documentdueDate = duedatevalue
                        }
                        documentauditTrail[index].tagtypes?.append(tag.Type!)
                    }
                } else {
                    signatories.append(tag.Signatories!)
                    
                    let signatorycount = tag.Signatories!.count
                    var username = tag.Signatories![0].friendlyName
                    var userimage = tag.Signatories![0].profileImage
                    
                    //var duedate = "MMM dd, yyyy"
                    var duedate = ""
                    
                    signatorycount > 1 ? (username = "Multiple - \(signatorycount)") : (username = username)
                    signatorycount > 1 ? (userimage = "https://s3.amazonaws.com/zfpi/DefaultContactGroupImage.jpg") : (userimage = userimage)
                    
                    if let duedatevalue = tag.dueDate {
                        duedate = duedatevalue
                    }
                    
                    let documentauditrail = DocumentAuditTrail(trailIndex: 0,documentStep: step.StepNo, recepientName: username, recepientImage: userimage, documentdueDate: duedate, sinatories: tag.Signatories, tagtypes: [tag.Type!], shouldhideName: false, shouldhideDate: false, shouldhideleftLine: false, shouldhiderightLine: false, shouldhideleftVertical: false, shouldhiderighVertical: false)
                    documentauditTrail.append(documentauditrail)
                }
            }
        }
        
        let updateTrail = updateddocumentTrail(docaudittrail: documentauditTrail)
        return updateTrail
    }
}

//MARK: - compare signatories
extension DocumentAuditTrail {
    private func compareSinatories(current: [Signatory], allsignatures: [[Signatory]]) -> (Bool, Int?) {
        
        var isidentical: Bool = false
        var trailIndex: Int?
        
        let currentsig = current.sorted(by: { $0.userName! > $1.userName! })
        for (index, signature) in allsignatures.enumerated() {
            let previous = signature.sorted(by: { $0.userName! > $1.userName! })
            if currentsig == previous {
                isidentical = true
                trailIndex = index
                break
            }
        }
        return (isidentical, trailIndex)
    }
}

//MARK: - make ui updates
extension DocumentAuditTrail {
    private func updateddocumentTrail(docaudittrail: [DocumentAuditTrail]) -> [DocumentAuditTrail] {
        
        var alldocauditTrails: [DocumentAuditTrail] = docaudittrail
        print(alldocauditTrails.count)

        for i in 0..<docaudittrail.count {
            if i == 0 {
                alldocauditTrails[i].shouldhideleftVertical = true
                alldocauditTrails[i].shouldhiderighVertical = true
            }
            
            if let tagtypes = alldocauditTrails[i].tagtypes {
                if tagtypes.count == 1 {
                    if tagtypes.contains(6) || tagtypes.contains(9) {
                        alldocauditTrails[i].shouldhideDate = true
                    }
                }
            }
        }
        
        return alldocauditTrails
    }
}
