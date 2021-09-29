//
//  ChainofSignature.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/26/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

struct ChainofSignature {
    
    var isExpand: Bool!
    var chainofsignatureSub: [ChainofSignatureSub] = []
    
    init(isexpand: Bool, documenttrailDetails: DocumentTrailDetails?) {
        self.isExpand = isexpand
        
        if let chainsteps = documenttrailDetails?.Data?.Steps {
            
            for step in chainsteps {
                if let actions = step.History?.ChangeSets {
                    for action in actions {
                        if action.TagType == 0 {
                            
                            var signaturetick = "Signature Tick not available"
                            if let certificatenumbercount = action.CertificateNumber {
                                if certificatenumbercount.count > 0 {
                                    signaturetick = action.CertificateNumber![0].SignatureTick!
                                }
                            }
                            
                            let chainofsignaturesub = ChainofSignatureSub(userimage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", username: step.ExecutedUserName, signaturetrick: signaturetick, signaturetime: setdateFormat(datestring: action.ExecutedTime), signatureimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), actualdate: action.ExecutedTime)
                            chainofsignatureSub.append(chainofsignaturesub)
                        }
                    }
                }
            }
            
        }
    }
}

//MARK: - Get month
extension ChainofSignature {
    fileprivate func getMonth(index: String) -> String {
        let month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let monthstring = month[Int(index)! - 1]
        return monthstring
    }
}

//MARK: - Set Date
extension ChainofSignature {
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
        dateformatter.dateFormat = "HH:mm:ssa"
        dateformatter.amSymbol = "AM"
        dateformatter.pmSymbol = "PM"
        let timeonly = dateformatter.string(from: date!)
        
        let changeddatetime = dateonly + " at " + timeonly
        return changeddatetime
    }
}

//MARK: - Updated data
extension ChainofSignature {
    func updatedChainofSignature(chainofsignature: ChainofSignature, selectedtimezone: ZorroTimeZone) -> ChainofSignature {
        
        
        var newchainofsignature = chainofsignature
        newchainofsignature.chainofsignatureSub = []
        
        for var signaturesub in chainofsignature.chainofsignatureSub {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            var date = dateformatter.date(from: signaturesub.actualdate!)
            
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
            
            signaturesub.signaturetime = newdate
            newchainofsignature.chainofsignatureSub.append(signaturesub)
        }
        
        return newchainofsignature
    }
}

struct ChainofSignatureSub {
    var userimage: String!
    var username: String?
    var signaturetrick: String!
    var signaturetime: String!
    var signatureimage: UIImage?
    var actualdate: String?
}

