//
//  ChainofCustody.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

struct ChainofCustody {
    
    var isExpand: Bool!
    var chainSteps: [DocTrailSteps]?
    var chainofcustodySub: [ChainofCustodySub] = []
    var tempRightData = "N/A"
    
    init(isexpanded: Bool, documenttrailDetails: DocumentTrailDetails?, contractversion: String?) {
        self.isExpand = isexpanded
        self.chainSteps = documenttrailDetails?.Data?.Steps
        
        if let chainsteps = documenttrailDetails?.Data?.Steps {
            print(chainsteps.count)
            for (index, step) in chainsteps.enumerated() {
                
                var stepColor = getColor(instanceStep: step.InstanceStepId ?? 0)
                if step.IsGrayBySendback! {
                    stepColor = UIColor.lightGray
                }
                
                let instancestepLable = step.InstanceStepLabel
                var modifiedstepLable = ""
                if instancestepLable!.count < 2 {
                    modifiedstepLable = "Step 0\(step.InstanceStepLabel!)"
                } else {
                    modifiedstepLable = "Step \(step.InstanceStepLabel!)"
                }
                
                if index != chainsteps.count-1 {
                    
                    if index == 0 {
                        
                        let chainofcustodyuser = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: modifiedstepLable, rightData: step.ExecutedUserName, isImage: true, userName: step.ExecutedUserName, userEmail: step.ExecutedUserEmail, userImage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", isAction: false, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil, isKBA: step.IsKBA, kbaHistory: step.KBAResult)
                        chainofcustodySub.append(chainofcustodyuser)
                        
                        let chainofreceiver = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Received", rightData: setdateFormat(datestring: step.ReceivedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true, originaltime: step.ReceivedTime, changedtime: setdateFormat(datestring: step.ReceivedTime))
                        chainofcustodySub.append(chainofreceiver)
                        
                        // MARK: - New Audit Trail  Updates
                        
                        if let _IPAddress = step.IPAddress {
                            tempRightData = (!_IPAddress.isEmpty) ? _IPAddress : "N/A"
                        } else {
                            tempRightData = "N/A"
                        }
                        
                        if tempRightData != "N/A" {
                            let chainofIPAddress = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "IP Address", rightData: tempRightData, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofIPAddress)
                        }
                        
                        if let _GeoLocation = step.Geolocation {
                            tempRightData = (!_GeoLocation.isEmpty) ? _GeoLocation : "N/A"
                        } else {
                            tempRightData = "N/A"
                        }

                        if tempRightData != "N/A" {
                        let chainofGeoLocation = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Geolocation", rightData: tempRightData, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                        chainofcustodySub.append(chainofGeoLocation)
                        }

                        
                        var completionStatus: String = "Completed"
                        if let stepStatus = step.StepStatus {
                            if stepStatus == "SendBack" {
                                completionStatus = "Send Back"
                            }
                        }
                        
                        if completionStatus == "Completed" {
                            
                            let chainofinitialaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Action(s)", rightData: "", isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: true, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofinitialaction)
                            
                            if let actions = step.History?.ChangeSets {
                                let sortedactions = mergeSort(list: actions)
                                for action in sortedactions {
                                    if action.TagType != 9 {
                                        let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "", rightData: setdateFormat(datestring: action.ActionedTime), isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: true,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                        chainofcustodySub.append(chainofaction)
                                    }
                                }
                                for action in sortedactions {
                                    if action.TagType == 9 {
                                        let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: action.ExecutedUserName, instanceStep: step.InstanceStepId!, leftData: "", rightData: action.ExecutedUserName, isImage: false, userName: nil, userEmail: action.ExecutedByEmail, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: false,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                        chainofcustodySub.append(chainofaction)
                                    }
                                }
                            }
                        }
                        
                        // MARK: - New Audit Trail  Updates
                        
                        let chainofApprovalMethod = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Approved using", rightData: getApprovalMethod(number: step.ApprovalMethod ?? 0), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                        chainofcustodySub.append(chainofApprovalMethod)
                        
                        
                        let chainofcomplete = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Action Completed", rightData: setdateFormat(datestring: step.FinishedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                        chainofcustodySub.append(chainofcomplete)
                        
                        if contractversion != "0" {
                            let chainoftransactionId = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: step.TransactionId, ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction ID", rightData: step.TransactionId, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                            chainofcustodySub.append(chainoftransactionId)
                            
                            let chainoftransactionTimeStamp = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: setdateFormat(datestring: step.TransactionTimeStamp), ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction Timestamp", rightData: setdateFormat(datestring: step.TransactionTimeStamp), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.TransactionTimeStamp, changedtime: setdateFormat(datestring: step.FinishedTime))
                            chainofcustodySub.append(chainoftransactionTimeStamp)
                        }
                    } else {
                        
                        if step.TokenId == -1 {
                            let chainofcustodyuser = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: step.ExecutedUserName, rightData: modifiedstepLable, isImage: true, userName: step.ExecutedUserName, userImage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", isAction: false, isFill: false, assignedColor: stepColor, token: true, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: nil, changedtime: nil, isKBA: step.IsKBA, kbaHistory: step.KBAResult)
                            chainofcustodySub.append(chainofcustodyuser)
                            
                            if contractversion != "0" {
                                let chainoftransactionId = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: step.TransactionId, ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction ID", rightData: step.TransactionId, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                                chainofcustodySub.append(chainoftransactionId)
                                
                                let chainoftransactionTimeStamp = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: setdateFormat(datestring: step.TransactionTimeStamp), ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction Timestamp", rightData: setdateFormat(datestring: step.TransactionTimeStamp), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.TransactionTimeStamp, changedtime: setdateFormat(datestring: step.FinishedTime))
                                chainofcustodySub.append(chainoftransactionTimeStamp)
                            }
                        } else {
                            
                            let chainofcustodyuser = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: modifiedstepLable, rightData: step.ExecutedUserName, isImage: true, userName: step.ExecutedUserName, userEmail: step.ExecutedUserEmail, userImage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", isAction: false, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil, isKBA: step.IsKBA, kbaHistory: step.KBAResult)
                            chainofcustodySub.append(chainofcustodyuser)
                            
                            let chainofreceiver = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Received", rightData: setdateFormat(datestring: step.ReceivedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true, originaltime: step.ReceivedTime, changedtime: setdateFormat(datestring: step.ReceivedTime))
                            chainofcustodySub.append(chainofreceiver)
                            
                            // MARK: - New Audit Trail  Updates
                            
                            if let _IPAddress = step.IPAddress {
                                tempRightData = (!_IPAddress.isEmpty) ? _IPAddress : "N/A"
                            } else {
                                tempRightData = "N/A"
                            }
                            
                            if tempRightData != "N/A" {
                            let chainofIPAddress = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "IP Address", rightData: tempRightData, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofIPAddress)
                            }
                            
                            if let _GeoLocation = step.Geolocation {
                                tempRightData = (!_GeoLocation.isEmpty) ? _GeoLocation : "N/A"
                            } else {
                                tempRightData = "N/A"
                            }
                            
                            if tempRightData != "N/A" {
                            let chainofGeoLocation = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Geolocation", rightData: tempRightData, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofGeoLocation)
                            }
                    
                            
                            var completionStatus: String = "Completed"
                            if let stepStatus = step.StepStatus {
                                if stepStatus == "SendBack" {
                                    completionStatus = "Send Back"
                                }
                            }
                            
                            if completionStatus == "Completed" {
                                
                                let chainofinitialaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Action(s)", rightData: "", isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: true, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                                chainofcustodySub.append(chainofinitialaction)
                                
                                if let actions = step.History?.ChangeSets {
                                    let sortedactions = mergeSort(list: actions)
                                    for action in sortedactions {
                                        if action.TagType != 9 {
                                            let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "", rightData: setdateFormat(datestring: action.ActionedTime), isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: true,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                            chainofcustodySub.append(chainofaction)
                                        }
                                    }
                                    for action in sortedactions {
                                        if action.TagType == 9 {
                                            let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: action.ExecutedUserName, instanceStep: step.InstanceStepId!, leftData: "", rightData: action.ExecutedUserName, isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: false,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                            chainofcustodySub.append(chainofaction)
                                        }
                                    }
                                }
                            }
                            
                            // MARK: - New Audit Trail  Updates
                            
                            let chainofApprovalMethod = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Approved using", rightData: getApprovalMethod(number: step.ApprovalMethod ?? 0), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofApprovalMethod)
                            
                            
                            let chainofcomplete = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Action Completed", rightData: setdateFormat(datestring: step.FinishedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                            chainofcustodySub.append(chainofcomplete)
                            
                            if contractversion != "0" {
                                let chainoftransactionId = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: step.TransactionId, ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction ID", rightData: step.TransactionId, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                                chainofcustodySub.append(chainoftransactionId)
                                
                                let chainoftransactionTimeStamp = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: false, transactionID: setdateFormat(datestring: step.TransactionTimeStamp), ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction Timestamp", rightData: setdateFormat(datestring: step.TransactionTimeStamp), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.TransactionTimeStamp, changedtime: setdateFormat(datestring: step.FinishedTime))
                                chainofcustodySub.append(chainoftransactionTimeStamp)
                            }
                        }
                    }
                } else {
                    if step.TokenId == -1 {
                        let chainofcustodyuser = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: step.ExecutedUserName, rightData: modifiedstepLable, isImage: true, userName: step.ExecutedUserName, userEmail: step.ExecutedUserEmail, userImage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", isAction: false, isFill: false, assignedColor: stepColor, token: true, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: nil, changedtime: nil, isKBA: step.IsKBA, kbaHistory: step.KBAResult)
                        chainofcustodySub.append(chainofcustodyuser)
                        
                        // MARK: - For Token No need to show these
                        if contractversion != "0" {
//                            let chainoftransactionId = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: step.TransactionId, ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction ID", rightData: step.TransactionId, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
//                            chainofcustodySub.append(chainoftransactionId)
                            
//                            let chainoftransactionTimeStamp = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: setdateFormat(datestring: step.TransactionTimeStamp), ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction Timestamp", rightData: setdateFormat(datestring: step.TransactionTimeStamp), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.TransactionTimeStamp, changedtime: setdateFormat(datestring: step.FinishedTime))
//                            chainofcustodySub.append(chainoftransactionTimeStamp)
                        }
                        
                        // MARK: - New Audit Trail  Updates
                        
                        let chainofApprovalMethod = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Digital Signature", rightData: documenttrailDetails?.Data?.DocumentSignature ?? "N/A", isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                        chainofcustodySub.append(chainofApprovalMethod)
                        
                    } else {
                        let chainofcustodyuser = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: modifiedstepLable, rightData: step.ExecutedUserName, isImage: true, userName: step.ExecutedUserName, userEmail: step.ExecutedUserEmail, userImage: "https://s3.amazonaws.com/zfpi/\(step.ExecutedUserImage!)", isAction: false, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil, isKBA: step.IsKBA, kbaHistory: step.KBAResult)
                        chainofcustodySub.append(chainofcustodyuser)
                        
                        let chainofreceiver = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Received", rightData: setdateFormat(datestring: step.ReceivedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true, originaltime: step.ReceivedTime, changedtime: setdateFormat(datestring: step.ReceivedTime))
                        chainofcustodySub.append(chainofreceiver)
                        
                        var completionStatus: String = "Completed"
                        if let stepStatus = step.StepStatus {
                            if stepStatus == "SendBack" {
                                completionStatus = "Send Back"
                            }
                        }
                        
                        if completionStatus == "Completed" {
                            
                            let chainofinitialaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "Action(s)", rightData: "", isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: true, isactionHidden: false, tagimage: nil, istimeuse: false, originaltime: nil, changedtime: nil)
                            chainofcustodySub.append(chainofinitialaction)
                            
                            if let actions = step.History?.ChangeSets {
                                let sortedactions = mergeSort(list: actions)
                                for action in sortedactions {
                                    if action.TagType != 9 {
                                        let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId!, leftData: "", rightData: setdateFormat(datestring: action.ActionedTime), isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: true,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                        chainofcustodySub.append(chainofaction)
                                    }
                                }
                                for action in sortedactions {
                                    if action.TagType == 9 {
                                        let chainofaction = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: true, isfinalStep: false, transactionID: "", ccuserName: action.ExecutedUserName, instanceStep: step.InstanceStepId!, leftData: "", rightData: action.ExecutedUserName, isImage: false, userName: nil, userImage: nil, isAction: true, isFill: false, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: AuditTrailHelper.sharedInstance.returnTagImage(tagtype: action.TagType!), istimeuse: false,  originaltime: action.ActionedTime, changedtime: setdateFormat(datestring: action.ActionedTime))
                                        chainofcustodySub.append(chainofaction)
                                    }
                                }
                            }
                        }
                        
                        let chainofcomplete = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: "", ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Action Completed", rightData: setdateFormat(datestring: step.FinishedTime), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                        chainofcustodySub.append(chainofcomplete)
                        
                        if contractversion != "0" {
                            let chainoftransactionId = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: step.TransactionId, ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction ID", rightData: step.TransactionId, isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: false,  originaltime: step.FinishedTime, changedtime: setdateFormat(datestring: step.FinishedTime))
                            chainofcustodySub.append(chainoftransactionId)
                            
                            let chainoftransactionTimeStamp = ChainofCustodySub(tokenid: step.TokenId, contractversion: contractversion, isfirstStep: false, isfinalStep: true, transactionID: setdateFormat(datestring: step.TransactionTimeStamp), ccuserName: "", instanceStep: step.InstanceStepId, leftData: "Blockchain Transaction Timestamp", rightData: setdateFormat(datestring: step.TransactionTimeStamp), isImage: false, userName: nil, userImage: nil, isAction: false, isFill: true, assignedColor: stepColor, token: false, intialAction: false, isactionHidden: false, tagimage: nil, istimeuse: true,  originaltime: step.TransactionTimeStamp, changedtime: setdateFormat(datestring: step.FinishedTime))
                            chainofcustodySub.append(chainoftransactionTimeStamp)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Get APproval Methods
    
    func getApprovalMethod(number: Int) -> String {
        switch number {
        case 0:
            return "None. This is for auto save"
        case 1:
            return "Password"
        case 2:
            return "OTP"
        case 3:
            return "Password & OTP"
        case 4:
            return "Biometric"
        case 5:
            return "Password & Biometric"
        case 6:
            return "Verified Email"
        case 7:
            return "Not Verified Email"
        default:
            return "N/A"
        }
    }
}

//MARK: - Sort actions
extension ChainofCustody {
    fileprivate func merge(left:[DocTrailStepsHistoryChangeSets],right:[DocTrailStepsHistoryChangeSets]) -> [DocTrailStepsHistoryChangeSets] {
        var mergedList = [DocTrailStepsHistoryChangeSets]()
        var left = left
        var right = right
        
        while left.count > 0 && right.count > 0 {
            let dateformatterleft = DateFormatter()
            dateformatterleft.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateformatterleft.locale = Locale(identifier: "en_US_POSIX")
            let dateleft = dateformatterleft.date(from: (left.first?.ActionedTime)!)
            dateformatterleft.dateFormat = "HH"
            let hleft = Int(dateformatterleft.string(from: dateleft!))
            dateformatterleft.dateFormat = "mm"
            let mleft = Int(dateformatterleft.string(from: dateleft!))
            dateformatterleft.dateFormat = "ss"
            let sleft = Int(dateformatterleft.string(from: dateleft!))
            
            let dateformatterright = DateFormatter()
            dateformatterright.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            dateformatterright.locale = Locale(identifier: "en_US_POSIX")
            let dateright = dateformatterright.date(from: (right.first?.ActionedTime)!)
            dateformatterright.dateFormat = "HH"
            let hright = Int(dateformatterright.string(from: dateright!))
            dateformatterright.dateFormat = "mm"
            let mright = Int(dateformatterright.string(from: dateright!))
            dateformatterright.dateFormat = "ss"
            let sright = Int(dateformatterright.string(from: dateright!))
            
            if hleft! < hright! {
                mergedList.append(left.removeFirst())
            } else {
                if mleft! < mright! {
                    mergedList.append(left.removeFirst())
                } else {
                    if sleft! < sright! {
                        mergedList.append(left.removeFirst())
                    } else {
                         mergedList.append(right.removeFirst())
                    }
                }
            }
            
//            if left.first! < right.first! {
//                mergedList.append(left.removeFirst())
//            } else {
//                mergedList.append(right.removeFirst())
//            }
        }
     
        return mergedList + left + right
    }
     
    fileprivate func mergeSort(list:[DocTrailStepsHistoryChangeSets]) -> [DocTrailStepsHistoryChangeSets] {
        guard list.count > 1 else {
            return list
        }
        
        let leftList = Array(list[0..<list.count/2])
        let rightList = Array(list[list.count/2..<list.count])
        
        return merge(left: mergeSort(list:leftList), right: mergeSort(list:rightList))
    }
}

//MARK: - Set color
extension ChainofCustody {
    fileprivate func getColor(instanceStep: Int) -> UIColor {
        let colors = ["#009812", "#2d0fff", "#ea0000", "#b39ddb", "#fec107", "#827717", "#ef9a9a", "#00c853", "#c6ff00", "#b2ebf2", "#795547", "#304ffe", "#f8bbd0", "#dce775", "#f44336", "#00bcd4", "#ffcc80", "#009688", "#1a237e"]
        let colorString = colors[instanceStep-1]
        let color = UIColor(hexString: colorString)
        return color ?? UIColor.black
    }
}

//MARK: - Get month
extension ChainofCustody {
    fileprivate func getMonth(index: String) -> String {
        let month = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let monthstring = month[Int(index)! - 1]
        return monthstring
    }
}

//MARK: - Set month,day,year and time
extension ChainofCustody {
    fileprivate func setdateFormat(datestring: String?) -> String {
        
        let dateformatter = DateFormatter()
        
        guard let _date = datestring else {
            return String()
        }
        
        if _date.contains("Z") {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        } else {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        }
        
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        var date = dateformatter.date(from: _date)
        
        if date == nil {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            date = dateformatter.date(from: datestring!)
        }
        
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

extension ChainofCustody {
    func updateChainofCustody(chainofcustody: ChainofCustody, selectedtimezone: ZorroTimeZone) -> ChainofCustody {
        
        var newchainofcustody = chainofcustody
        newchainofcustody.chainofcustodySub = []
        
        for var chainofcustodysub in chainofcustody.chainofcustodySub {
            if chainofcustodysub.istimeuse {
                let dateformatter = DateFormatter()
                dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateformatter.locale = Locale(identifier: "en_US_POSIX")
                var date = dateformatter.date(from: chainofcustodysub.originaltime!)
                
                
                if date == nil {
                    dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    dateformatter.locale = Locale(identifier: "en_US_POSIX")
                    date = dateformatter.date(from: chainofcustodysub.originaltime!)
                }
                
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
                
                if !chainofcustodysub.isAction! {
                    chainofcustodysub.rightData = newdate
                } else {
                    if !chainofcustodysub.intialAction {
                        chainofcustodysub.rightData = newdate
                    }
                }
                newchainofcustody.chainofcustodySub.append(chainofcustodysub)
            } else {
                newchainofcustody.chainofcustodySub.append(chainofcustodysub)
            }
        }
        return newchainofcustody
    }
}

extension ChainofCustody {
    func updateChainofCustodywithAction(chainofcustody: ChainofCustody, selectedactionIndex: Int) -> ChainofCustody {
        
        var newchainofcustody = chainofcustody
        newchainofcustody.chainofcustodySub = []
        
        for var chainofcustodysub in chainofcustody.chainofcustodySub {
            if chainofcustodysub.instanceStep == selectedactionIndex {
                if chainofcustodysub.isAction {
                    
                    let hiddenaction = chainofcustodysub.isactionHidden
                    if hiddenaction! {
                        chainofcustodysub.isactionHidden = false
                    } else {
                        chainofcustodysub.isactionHidden = true
                    }
                    newchainofcustody.chainofcustodySub.append(chainofcustodysub)
                } else {
                    newchainofcustody.chainofcustodySub.append(chainofcustodysub)
                }
            } else {
                newchainofcustody.chainofcustodySub.append(chainofcustodysub)
            }
        }
        
        return newchainofcustody
    }
}


struct ChainofCustodySub {
    var tokenid: Int!
    var contractversion: String!
    var isfirstStep: Bool!
    var isfinalStep: Bool!
    var transactionID: String!
    var ccuserName: String!
    var instanceStep: Int!
    var leftData: String!
    var rightData: String!
    var isImage: Bool!
    var userName: String?
    var userEmail: String?
    var userImage: String?
    var isAction: Bool!
    var isFill: Bool!
    var assignedColor: UIColor?
    var token: Bool!
    var intialAction: Bool!
    var isactionHidden: Bool!
    var tagimage: UIImage?
    var istimeuse: Bool!
    var originaltime: String?
    var changedtime: String?
    var isKBA: Bool?
    var kbaHistory: String?
}


