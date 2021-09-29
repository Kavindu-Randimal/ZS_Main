//
//  DocumentHelper.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import Alamofire
import PDFKit

public enum DocumentTagType: Int {
    case Signature = 0 // 0  done, UIImageView
    case Intials = 1 //1 done, UIImageView
    case Stamp = 2 //2 done, UIImageView
    case TextInput = 3 //3 done, UITextField
    case Date = 4 //4 done, UITextField
    case Title = 5 //5 not using
    case Token = 6 //6 done, UIImageView
    case Comment = 7 //7 not using
    case Note = 8 //8 done, UITextView
    case Cc = 9 //9
    case Initiate = 10 //10
    case Review = 11 //11
    case Attachment = 12 //12
    case Checkbox = 13 //13
    case DynamicTextInput = 14 //14
    case User = 15 //15
    case userName = 16 //16 done, UITextField
    case userEmail = 17 //17 done, UITextField
    case userCompany = 18 //18 done, UITextField
    case userTitle = 19 //19 done, UITextField
    case userPhone = 20 //20 done, UITextField
}

class DocumentHelper {
    private let queueGroup = DispatchGroup()
    static let sharedInstance = DocumentHelper()
    private init() {}
}

//MARK: Get color
extension DocumentHelper {
    func getstepColor(step: Int) -> UIColor{
        let colors = ["#009812", "#2d0fff", "#ea0000", "#b39ddb", "#fec107", "#827717", "#ef9a9a", "#00c853", "#c6ff00", "#b2ebf2", "#795547", "#304ffe", "#f8bbd0", "#dce775", "#f44336", "#00bcd4", "#ffcc80", "#009688", "#1a237e"]
        let colorString = colors[step]
        let color = UIColor(hex: colorString)
        return color ?? UIColor.darkGray
    }
}

//MARK: Get document saved url
extension DocumentHelper {
    func returnfileDestination(documentname: String) -> DownloadRequest.DownloadFileDestination {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentsUrl.appendingPathComponent(documentname)
            return (fileUrl, [.removePreviousFile])
        }
        return destination
    } 
}

//MARK: Set Tag Name
extension DocumentHelper {
    func returnTagName(tagtype: Int) -> String {
        switch tagtype {
        case 0:
            return "\(DocumentTagType.Signature)"
        case 1:
            return "\(DocumentTagType.Intials)"
        case 2:
            return "\(DocumentTagType.Stamp)"
        case 3:
            return "\(DocumentTagType.TextInput)"
        case 4:
            return "\(DocumentTagType.Date)"
        case 5:
            return "\(DocumentTagType.Title)"
        case 6:
            return "\(DocumentTagType.Token)"
        case 7:
            return "\(DocumentTagType.Comment)"
        case 8:
            return "\(DocumentTagType.Note)"
        case 9:
            return "\(DocumentTagType.Cc)"
        case 10:
            return "\(DocumentTagType.Initiate)"
        case 11:
            return "\(DocumentTagType.Review)"
        case 12:
            return "\(DocumentTagType.Attachment)"
        case 13:
            return "\(DocumentTagType.Checkbox)"
        case 14:
            return "\(DocumentTagType.DynamicTextInput)"
        case 15:
            return "\(DocumentTagType.User)"
        case 16:
            return "\(DocumentTagType.userName)"
        case 17:
            return "\(DocumentTagType.userEmail)"
        case 18:
            return "\(DocumentTagType.userCompany)"
        case 19:
            return "\(DocumentTagType.userTitle)"
        case 20:
            return "\(DocumentTagType.userPhone)"
            
        default:
            return ""
        }
    }
}

extension DocumentHelper {
    func returnTagImage(tagtype: Int) -> UIImage {
        var imagename = ""
        switch tagtype {
        case 0:
            imagename = "Signature_tools"
        case 1:
            imagename = "Initials_tools"
        case 2:
            imagename = "Seal_tools"
        case 3:
            imagename = "Text_tools"
        case 4:
            imagename = "Calendar_tools"
        case 5:
            imagename = ""
        case 6:
            imagename = "Token"
        case 7:
            imagename = ""
        case 8:
            imagename = "Note_tools"
        case 9:
            imagename = "CC_tools"
        case 10:
            imagename = ""
        case 11:
            imagename = ""
        case 12:
            imagename = "Attach"
        case 13:
            imagename = "Checkbox_tools"
        case 14:
            imagename = "Editabletext_tools"
        case 15:
            imagename = "User_tools"
        case 16:
            imagename = "User_tools"
        case 17:
            imagename = "Email_tools"
        case 18:
            imagename = "Company_tools"
        case 19:
            imagename = "Title_tools"
        case 20:
            imagename = "Phone_tools"
        default:
           imagename = ""
        }
        
        let image = UIImage(named: imagename)
        return image!
    }
}

//MARK: Get Pdf page Image Low quality
extension DocumentHelper {
    func getpdfpageImageLawQuality(pdfDocument: PDFDocument, completion: @escaping([UIImageView]?) -> ()) {
        
        var yvalue:CGFloat = 0.0
        var pdfImageViews: [UIImageView] = []
        let numberofpages = pdfDocument.pageCount
        print("NUMBER OF PAGES : \(numberofpages)")
        for i in 0..<numberofpages {
            
            if let page = pdfDocument.page(at: i) {
                
                let pagebounds = page.bounds(for: .mediaBox)
                let pdfpageimage = page.thumbnail(of: CGSize(width: pagebounds.width, height: pagebounds.height), for: .mediaBox)
                let imageview = UIImageView(frame: CGRect(x: 0, y: yvalue, width: pagebounds.width, height: pagebounds.height))
                imageview.image = pdfpageimage
                imageview.layer.borderColor = UIColor.black.cgColor
                imageview.layer.borderWidth = 1
                
                pdfImageViews.append(imageview)
                
                yvalue += pagebounds.height
            }
        }
        completion(pdfImageViews)
    }
}

//MARK: Get PDF image quality with performance -> Latest
extension DocumentHelper {
    
    //MARK: Generate Image Views from pdf pages
    func getpdfPages(pdfurl: URL, completion: @escaping([UIImageView?]) -> ()) {
        
        guard let pdfDocument = CGPDFDocument(pdfurl as CFURL) else {
            return
        }
        
        self.gethighqualityPDFImage(pdfDocument: pdfDocument) {(pdfimages) in
            
            var yvalue:CGFloat = 0.0
            var pdfImageViews: [UIImageView] = []
            
            for pdfimage in pdfimages {
                print("pdf page : \(pdfimage.0) and image is : \(String(describing: pdfimage.1))")
                let pdfpage =  pdfDocument.page(at: pdfimage.0)!
                let mediaboxrect = pdfpage.getBoxRect(.mediaBox)
                
                let imageview = UIImageView(frame: CGRect(x: 0, y: yvalue, width: mediaboxrect.width, height: mediaboxrect.height))
                imageview.tag = pdfimage.0
                imageview.image = pdfimage.1
                imageview.layer.borderColor = UIColor.black.cgColor
                imageview.layer.borderWidth = 1
                
                pdfImageViews.append(imageview)
                
                yvalue += mediaboxrect.height
            }
            completion(pdfImageViews)
        }
    }

    //MARK: Get High Quality image
    fileprivate func gethighqualityPDFImage(pdfDocument: CGPDFDocument, completion: @escaping([(Int, UIImage?)]) -> ()) {
        var pdfimage: [(Int, UIImage?)] = []
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
        
        let dispatchSerial = DispatchQueue(label: "com.zorrosign.pdfimageque", qos: .default)
        
        DispatchQueue.concurrentPerform(iterations: pdfDocument.numberOfPages) { i in
            
            let unlockpassword = ZorroTempData.sharedInstance.getpdfprotectionPassword()
            pdfDocument.unlockWithPassword(unlockpassword)
            
            let pdfpage = pdfDocument.page(at: i + 1)!
            let mediaboxRect  = pdfpage.getBoxRect(.mediaBox)
            let scale = 300/72.0
            let width = mediaboxRect.width * CGFloat(scale)
            let height = mediaboxRect.height * CGFloat(scale)
            
            let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
            context?.interpolationQuality = .high
            context?.setFillColor(UIColor.white.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: width, height: height))
            context?.scaleBy(x: CGFloat(scale), y: CGFloat(scale))
            context?.drawPDFPage(pdfpage)
            
            dispatchSerial.sync {
                let image = context?.makeImage()
                let uiimage = UIImage.init(cgImage: image!)
                pdfimage.append((i+1, uiimage))
            }
        }
        
        let sortedImages = makeascendingtoIndex(defaultvalues: pdfimage)
        completion(sortedImages)
    }
    
    //MARK: Sort image with index
    fileprivate func makeascendingtoIndex(defaultvalues: [(Int, UIImage?)]) -> [(Int, UIImage?)] {
        let sorted = defaultvalues.sorted { (left, right) -> Bool in
            let leftindex = left.0
            let rightindex = right.0
            return leftindex < rightindex
        }
        return sorted
    }
}

//MARK: Return Tag Details -> Received Tags
extension DocumentHelper {
    func setdocumentTagDetails(docprocessUIElements: [DocProcessUIElement], reject: Bool, comment: String, completion:@escaping([TagDetails]?, Bool) -> ()) {
        
        if !reject {
            let allcompleted = checktagCompleted(docprocessUIElements: docprocessUIElements)
            if !allcompleted {
                print("FAIL : all complete validation")
                completion(nil, false)
                return
            }
        }
        
        var tagDetails: [TagDetails] = []
        
        for tagitem in docprocessUIElements {
            var state: Int = 4
            if reject {
                state = 2
            }
            let tagdetails = getTagDetails(docelement: tagitem, state: state, comment: comment)
            tagDetails.append(tagdetails)
        }
        completion(tagDetails, true)
    }
}

//MARK: Return Dynamic note details -> Received Dynamic Notes
extension DocumentHelper {
    func setdynamicNoteDetails(docprocessdynamicNoteElements: [DocProcessUIDynamicNoteElement], completion: @escaping([DynamicTagDetail]?, Bool) -> ()) {
        
        var dynamictagDetails: [DynamicTagDetail] = []
        
        for dynamictag in docprocessdynamicNoteElements {
            
            let dynamictagdetails = getDyanamicTagDetails(docdynamicnoteElement: dynamictag, state: 1)
            dynamictagDetails.append(dynamictagdetails)
        }
        
        completion(dynamictagDetails, true)
        
    }
}

//MARK: Return Dynamic Text details -> Received Dynamic Text
extension DocumentHelper {
    func setdynamicTextDetails(docprocessdynamicTextElement: [DocProcessUIDynamicTextElement], completion: @escaping([DynamicTextDetail]?, Bool) -> ()) {
        
        var dynamictextDetails: [DynamicTextDetail] = []
        
        for dynamictext in docprocessdynamicTextElement {
            
            let dynamictextdetsils = getDynamicTextDetails(docdynamicTextElement: dynamictext, state: 1)
            dynamictextDetails.append(dynamictextdetsils)
        }
        completion(dynamictextDetails, true)
    }
}

extension DocumentHelper {
    func setnewDynamicTags(newtagElements: [DocProcessUINewElement], pdfview: PDFView, pdfpages: [UIImageView], completion: @escaping([(Any, Int)]?, Bool) -> ()) {
        
        var newElements: [(Any, Int)] = []
        
        for newtagelement in newtagElements {
            
            switch newtagelement.tagType {
            case 8:
                
                let newelement = newtagelement.tagElement as! ZorroDynamicNoteView
                
                var dynamictagdetails = DynamicTagDetail()
                dynamictagdetails.stepNo = ZorroTempData.sharedInstance.getStep()
                dynamictagdetails.isDeleted = newelement.isremoved
                dynamictagdetails.isLocked = newelement.islocked
                dynamictagdetails.tagText = newelement.tagText
                dynamictagdetails.comment = ""
                dynamictagdetails.isDynamicTag = true
                
                var dynamictagdetailtagvalues = DynamicTagDetailTagValue()
                dynamictagdetailtagvalues.type = newelement.tagtype
                dynamictagdetailtagvalues.signatories = []
                dynamictagdetailtagvalues.tagNo = newelement.tagNumber
                dynamictagdetailtagvalues.state = 0
                dynamictagdetailtagvalues.timeGap = 0
                
                var holder = Holder()
                let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pdfpages, newelement: newelement)
                holder.pageNumber = pagenumber
                holder.xCoordinate = Double(newelement.frame.origin.x)
                holder.yCoordinate = y
                holder.height = Double(newelement.frame.height)
                holder.width = Double(newelement.frame.width)
                
                var extrametadata = PurpleExtraMetaData()
                extrametadata.lock = ""
                extrametadata.addedBy = ZorroTempData.sharedInstance.getUserName()
            
                
                dynamictagdetailtagvalues.tagPlaceHolder = holder
                dynamictagdetailtagvalues.extraMetaData = extrametadata
                dynamictagdetails.tagValue = dynamictagdetailtagvalues
                
                
                newElements.append((dynamictagdetails, newelement.tagtype))
                print("dynamic note")
            case 14:
                
                let newelement = newtagelement.tagElement as! ZorroDynamicTextView
                
                var dynamictextdetails = DynamicTextDetail()
                dynamictextdetails.textRevisionHistory = []
                dynamictextdetails.isDeleted = newelement.isremoved
                dynamictextdetails.isLocked = false
                dynamictextdetails.tagText = newelement.tagText
                dynamictextdetails.comment = ""
                dynamictextdetails.isDynamicTag = false
                dynamictextdetails.signedAt = ""
                
                var dynamictextdetailsvalues = DynamicTextDetailTagValue()
                dynamictextdetailsvalues.type = newelement.tagtype
                dynamictextdetailsvalues.signatories = []
                dynamictextdetailsvalues.tagNo = 1
                dynamictextdetailsvalues.state = 0
                dynamictextdetailsvalues.timeGap = 0
                
                
                var holder = Holder()
                let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pdfpages, newelement: newelement)
                holder.pageNumber = pagenumber
                holder.xCoordinate = Double(newelement.frame.origin.x)
                holder.yCoordinate = y
                holder.height = Double(newelement.frame.height)
                holder.width = Double(newelement.frame.width)
                
                var extrametadata = FluffyExtraMetaData()
                extrametadata.addedBy = ZorroTempData.sharedInstance.getUserName()
                
                dynamictextdetailsvalues.tagPlaceHolder = holder
                dynamictextdetailsvalues.extraMetaData = extrametadata
                dynamictextdetails.tagValue = dynamictextdetailsvalues
                
                newElements.append((dynamictextdetails, newelement.tagtype))
                print("dynamic text")
            default:
                print("")
            }
        }
        completion(newElements, true)
    }
}

//MARK: Get Tag Details -> Received Tags
extension DocumentHelper {
    fileprivate func getTagDetails(docelement: DocProcessUIElement, state: Int, comment: String) -> TagDetails {
        
        var tagdetails = TagDetails()
        var tagvalue = TagValue()
        var tagplaceholder = Holder()
        var extrametadata = ExtraMetaDataSave()
        
        switch docelement.tagType {
        case 0:
            let element = docelement.tagElement as! ZorroSignatureView
            tagdetails.tagText = element.tagText
            
            extrametadata.tickX = docelement.xCoordinate + docelement.elementWidth * 0.2
            extrametadata.tickY = docelement.yCoordinateDefault + docelement.elementHeight * 0.77
            extrametadata.tickW = docelement.elementWidth * 0.4
            extrametadata.tickH = docelement.elementHeight * 0.18
            
            if let signatureid = element.usersignatureId {
                extrametadata.signatureID = signatureid
            }
            tagvalue.extraMetaData = extrametadata
        case 1:
            let element = docelement.tagElement as! ZorroInitialsView
            tagdetails.tagText = element.tagText
            
            if let signatureid = element.usersignatureId {
                extrametadata.signatureID = signatureid
            }
            tagvalue.extraMetaData = extrametadata
        case 2:
            let element = docelement.tagElement as! ZorroStampView
            tagdetails.tagText = element.tagText
        case 3:
            let element = docelement.tagElement as! ZorroTextInputView
            tagdetails.tagText = element.tagText
            tagvalue.extraMetaData = extrametadata
        case 4:
            let element = docelement.tagElement as! ZorroDateView
            tagdetails.tagText = element.tagText
            tagvalue.extraMetaData = extrametadata
        case 6:
            let element = docelement.tagElement as! ZorroTokenView
            tagdetails.tagText = element.tagText
        case 8:
            let element = docelement.tagElement as! ZorroDynamicNoteView
            tagdetails.tagText = element.tagText
        case 12:
            let element = docelement.tagElement as? ZorroTagBaseView
            tagdetails.tagText = element?.tagText
            
            extrametadata.count = element?.attachmentCount
            
            tagvalue.extraMetaData = extrametadata
        case 13:
            let element = docelement.tagElement as! ZorrocheckboxView
            tagdetails.tagText = element.tagText
            
            extrametadata.textX = docelement.xCoordinate + docelement.elementHeight + 8
            extrametadata.textY = docelement.yCoordinateDefault
            extrametadata.textW = docelement.elementWidth + docelement.elementHeight + 8
            extrametadata.textH = docelement.elementHeight
            if element.ischecked {
               extrametadata.checkState = "Checked"
            } else {
                extrametadata.checkState = ""
            }
            
            tagvalue.extraMetaData = extrametadata
        case 14:
            let element = docelement.tagElement as! ZorroDynamicTextView
            tagdetails.tagText = element.tagText
        case 16, 17, 18, 19, 20:
            let element = docelement.tagElement as! ZorroCommonTextInput
            tagdetails.tagText = element.tagText
        default:
            print("default")
        }
        
        tagvalue.type = docelement.tagType
        tagvalue.signatories = docelement.tagSignatories
        
        tagplaceholder.pageNumber = docelement.pageNumber
        tagplaceholder.xCoordinate = docelement.xCoordinate
        tagplaceholder.yCoordinate = docelement.yCoordinateDefault
        tagplaceholder.height = docelement.elementHeight
        tagplaceholder.width = docelement.elementWidth
        
        tagvalue.tagPlaceHolder = tagplaceholder
        tagvalue.tagNo = docelement.tagNo
        tagvalue.state = state
        tagvalue.objectID = ""
    
        tagdetails.tagValue = tagvalue
        tagdetails.comment = comment
        
        return tagdetails
    }
}

//MARK: Get Dynamic tag details
extension DocumentHelper {
    fileprivate func getDyanamicTagDetails(docdynamicnoteElement: DocProcessUIDynamicNoteElement, state: Int) -> DynamicTagDetail {
        
        var dynamictagDetials = DynamicTagDetail()
        var dynamictagdetailTagValue = DynamicTagDetailTagValue()
        var dynamictagplaceholder = Holder()
        let docelement = docdynamicnoteElement.tagElement as! ZorroDynamicNoteView
        
        dynamictagDetials.stepNo = 0
        dynamictagDetials.isDeleted = docelement.isremoved
        dynamictagDetials.isLocked = docelement.islocked
        dynamictagDetials.isDynamicTag = docdynamicnoteElement.isDynamicTag
        dynamictagDetials.tagText = docelement.tagText
        dynamictagDetials.signedAt = docdynamicnoteElement.signedAt
        
        
        dynamictagdetailTagValue.extraMetaData = docdynamicnoteElement.extrametaData
        dynamictagdetailTagValue.signatories = []
        dynamictagdetailTagValue.state = state
        dynamictagdetailTagValue.tagID = docdynamicnoteElement.tagId
        dynamictagdetailTagValue.tagNo = docelement.tagNumber
        
        dynamictagplaceholder.pageNumber = docdynamicnoteElement.pageNumber
        dynamictagplaceholder.height = docdynamicnoteElement.elementHeight
        dynamictagplaceholder.width = docdynamicnoteElement.elementHeight
        dynamictagplaceholder.xCoordinate = docdynamicnoteElement.xCoordinate
        dynamictagplaceholder.yCoordinate = docdynamicnoteElement.yCoordinateDefault
        
        dynamictagdetailTagValue.tagPlaceHolder = dynamictagplaceholder
        
        dynamictagdetailTagValue.timeGap = 0
        dynamictagdetailTagValue.type = docdynamicnoteElement.tagType
        
        dynamictagDetials.tagValue = dynamictagdetailTagValue
        
        return dynamictagDetials
    }
}

//MARK: Get Dynamic Text Details
extension DocumentHelper {
    fileprivate func getDynamicTextDetails(docdynamicTextElement: DocProcessUIDynamicTextElement, state: Int) -> DynamicTextDetail {
        
        var dynamictextDetails = DynamicTextDetail()
        var dynamictextDetailValues = DynamicTextDetailTagValue()
        var dynamictextplaceholder = Holder()
        let docelement = docdynamicTextElement.tagElement as! ZorroDynamicTextView
        
        
        dynamictextDetails.isDeleted = docelement.isremoved
        dynamictextDetails.isLocked = false
        dynamictextDetails.tagText = docelement.tagText
        dynamictextDetails.isDynamicTag = docdynamicTextElement.isDynamicTag
        dynamictextDetails.signedAt = docdynamicTextElement.signedAt
        
        
        dynamictextDetailValues.type = docdynamicTextElement.tagType
        dynamictextDetailValues.signatories = []
        dynamictextDetailValues.tagNo = 1
        dynamictextDetailValues.state = state
        dynamictextDetailValues.tagID = docdynamicTextElement.tagId
        dynamictextDetailValues.timeGap = 0
        
        
        dynamictextplaceholder.pageNumber = docdynamicTextElement.pageNumber
        dynamictextplaceholder.height = docdynamicTextElement.elementHeight
        dynamictextplaceholder.width = docdynamicTextElement.elementHeight
        dynamictextplaceholder.xCoordinate = docdynamicTextElement.xCoordinate
        dynamictextplaceholder.yCoordinate = docdynamicTextElement.yCordeinateDefault
        
        dynamictextDetailValues.tagPlaceHolder = dynamictextplaceholder
        dynamictextDetailValues.extraMetaData = docdynamicTextElement.extrametaData
        
        dynamictextDetails.tagValue = dynamictextDetailValues
        
        return dynamictextDetails
    }
}


//MARK: Check for Attachments and count
extension DocumentHelper {
    func checkforAttachmentCount(documenttags: [Tag], completion: @escaping(Int, Int?) -> ()) {
        
        for tag in documenttags {
            if tag.type == 12 {
        
                guard let tagid = tag.tagID else {
                    completion(0, nil)
                    return
                }
                
                guard let extrametadata = tag.extraMetaData else {
                    completion(0, nil)
                    return
                }
                
                guard let attachmentcountstring = extrametadata.attachmentCount else {
                    completion(0, nil)
                    return
                }
                
                if let attachmentcount = Int(attachmentcountstring) {
                    if attachmentcount == 0 {
                        completion(0, nil)
                        return
                    }
                    completion(attachmentcount, tagid)
                    return
                }
                completion(0, nil)
                return
            }
        }
        completion(0, nil)
    }
}

//MARK: - Check for validation
extension DocumentHelper {
    fileprivate func checktagCompleted(docprocessUIElements: [DocProcessUIElement]) -> Bool {
        var iscompleted: Bool = false
        for tagitem in docprocessUIElements {
            
            if let tag = tagitem.tagElement as? ZorroTagBaseView {
                if tag.iscompleted {
                    iscompleted = true
                } else {
                    iscompleted = false
                    break
                }
            } else {
                iscompleted = false
                break
            }
        }
        return iscompleted
    }
}

//MARK: - Get Document Scroll Position
extension DocumentHelper {
    func getdocumentScrollPosition(imageview: UIImageView, zoomScale: CGFloat, completion: @escaping(CGFloat, CGFloat) -> ()) {
        
        let frame: CGRect = imageview.frame
        let yposition = frame.origin.y
        let scaledyposition = yposition * zoomScale
        completion(0.0, scaledyposition)
    }
}

//MARK: Get page number and yvalue for new element
extension DocumentHelper {
    fileprivate func getpagenubmerfornewElement(imageviews: [UIImageView], newelement: UIView) -> (Int, Double) {
        
        var pagenumber: Int = 0
        var ycordinate: Double = 0.0
        
        var ystart: CGFloat = 0.0
        var yend: CGFloat = 0.0
        let elementviewframeyvalue = newelement.frame.origin.y
        
        for imageview in imageviews {
            let imageviewfarme = imageview.frame
            ystart = yend
            yend += imageviewfarme.height
            
            if ystart ... yend ~= elementviewframeyvalue {
                let yvalue = Double(elementviewframeyvalue - ystart)
                pagenumber = imageview.tag
                ycordinate = yvalue
                break
            }
        }
        
        return (pagenumber, ycordinate)
    }
}

//MARK: Update dynamic note number
extension DocumentHelper {
    func updatedynamicNoteTagNumber(docprocessuidynamicnoteElements: [DocProcessUIDynamicNoteElement], docprocessnewuiElements: [DocProcessUINewElement], removedtag: Int, completion: @escaping(Bool, Int) -> ()) {
        
        var dynamicNotes: [ZorroDynamicNoteView] = []
        var existingelemetnCount: Int = 0
        
        for element in docprocessuidynamicnoteElements {
            let tagelement = element.tagElement as! ZorroDynamicNoteView
            dynamicNotes.append(tagelement)
        }
        
        for newelement in docprocessnewuiElements {
            if newelement.tagType == 8 {
                let tagelement = newelement.tagElement as! ZorroDynamicNoteView
                dynamicNotes.append(tagelement)
            }
        }
        
        for dynamicnote in dynamicNotes {
            var dynamictagNumber = dynamicnote.tagNumber
            if dynamictagNumber > removedtag {
                dynamictagNumber -= 1
            }
            
            if !dynamicnote.isremoved {
                existingelemetnCount += 1
            }
            
            dynamicnote.tagNumber = dynamictagNumber
            dynamicnote.dynamictagNumber.setTitle("\(dynamictagNumber)", for: .normal)
        }
        
        completion(true, existingelemetnCount)
    }
}

//MARK: - Download a list of files
extension DocumentHelper {
    func downloadFilesQueue(processID: String, objectID: String, docprocessDetails: DocProcess, downloadoption: Int, completion: @escaping(Bool) -> ()) {
        
        switch downloadoption {
        case 0:
            print("As One Document - download the merged document only")
            ZorroHttpClient.sharedInstance.downloadfileWithUrl(processID: processID, objectID: objectID, documentID: "-1") { (filename, err) in
                if err {
                    completion(false)
                    return
                }
                completion(true)
                return
            }
        case 1:
            
            var success: Bool = true
            
            guard let multipledocuments = docprocessDetails.data?.multiUploadDocumentInfo else {
                completion(false)
                return
            }
            
            for multidocument in multipledocuments {
                
                queueGroup.enter()
                
                ZorroHttpClient.sharedInstance.downloadfileWithUrl(processID: processID, objectID: multidocument.objectID!, documentID: "\(multidocument.id!)") { (filename, err) in
                    
                    if err {
                       success = false
                    }
                    self.queueGroup.leave()
                }
            }
            
            self.queueGroup.notify(queue: .global(), execute: {
                print("done")
                completion(success)
                self.queueGroup.suspend()
                return
            })
        case 2:
            
            var success: Bool = true
            
            guard let documents = docprocessDetails.data?.documents else {
                completion(false)
                return
            }
            
            for document in documents {
                
                queueGroup.enter()
                
                if document.docType == 1 {
                    ZorroHttpClient.sharedInstance.downloadfileWithUrl(processID: processID, objectID: document.objectID!, documentID: "\(-1)") { (filename, err) in
                        
                        if err {
                            success = false
                        }
                        self.queueGroup.leave()
                    }
                }
            }
            
            self.queueGroup.notify(queue: .global(), execute: {
                print("done")
                completion(success)
                self.queueGroup.suspend()
                return
            })
        case 3:
            
            var success: Bool = true
            
            guard let documents = docprocessDetails.data?.documents else {
                completion(false)
                return
            }
            
            for document in documents {
                
                queueGroup.enter()
                
                ZorroHttpClient.sharedInstance.downloadfileWithUrl(processID: processID, objectID: document.objectID!, documentID: "\(-1)") { (filename, err) in
                    
                    if err {
                        success = false
                    }
                    self.queueGroup.leave()
                }
            }
            
            self.queueGroup.notify(queue: .global(), execute: {
                print("done")
                completion(success)
                self.queueGroup.suspend()
                return
            })
        default:
            return
        }
    }
}

//MARK: - check if upload or not
extension DocumentHelper {
    func shouldupload(docattachments: [DocAttachments], optionalattachments: [DocAttachments]) -> Bool {
        
        let allattachments: [DocAttachments] = docattachments + optionalattachments
        
        var shouldupload: Bool = false
        for attachment in allattachments {
            if !attachment.isUploaded! {
                shouldupload = true
                break
            }
        }
        return shouldupload
    }
}

// MARK: - ensure the attachment count
extension DocumentHelper {
    func ensureAttachmentCount(docattachments: [DocAttachments]) -> Int {
        
        var count: Int = 0
        
        for attachment in docattachments {
            if attachment.isUploaded! {
                count += 1
            }
        }
        return count
    }
}

// MARK: - add selected documents to array
extension DocumentHelper {
    func addfilestodocinitiateArray(urls: [URL], documentinitiateselectfiles: [DocumentinitiateSelectFile], completion: @escaping([DocumentinitiateSelectFile]) ->()) {
        
        var newdocumentinitiateselect: [DocumentinitiateSelectFile] = []
        newdocumentinitiateselect = documentinitiateselectfiles
        
        for url in urls {
            let documentname = url.lastPathComponent
            
            let newdocumentinitiatefile = DocumentinitiateSelectFile(filename: documentname, fileurl: url, isdeleted: false)
            newdocumentinitiateselect.append(newdocumentinitiatefile)
        }
        completion(newdocumentinitiateselect)
    }
}

// MARK: - Filter Contacts With Contact Type
extension DocumentHelper {
    func filtercontactswithcontactType(contacttype: Int, contacts: [ContactDetailsViewModel], completion: @escaping([ContactDetailsViewModel]) -> ()) {
        var filterredContacts: [ContactDetailsViewModel] = []
        switch contacttype {
        case 0:
            filterredContacts = contacts
        case 1:
            filterredContacts = contacts.filter {
                $0.Type! == 1
            }
        case 2:
            filterredContacts = contacts.filter {
                $0.Type! == 2
            }
        case 3:
            filterredContacts = contacts.filter {
                $0.Type == 1 && $0.userType == 1
            }
        default:
            return
        }
        completion(filterredContacts)
        return
    }
}


//MARK: - Check if all selected
extension DocumentHelper {
    func checkallcontactsSelected(contacts: [ContactDetailsViewModel], completion: @escaping(Bool) -> ()) {
        
        var allselected: Bool = true
        for contact in contacts {
            if !contact.isSelected {
                allselected = false
                break
            }
        }
        completion(allselected)
    }
}

//MARK: - Get selected count
extension DocumentHelper {
    func getselectedContactCount(contacts: [ContactDetailsViewModel], completion: @escaping(Int) ->()) {
        let filterredContacts = contacts.filter {
            $0.isSelected == true
        }
        completion(filterredContacts.count)
    }
}


//MARK: - Filter contacts with Selected or not
extension DocumentHelper {
    func filtercontacswithSelectorNonselect(contacttype: Int, contacts: [ContactDetailsViewModel], completion: @escaping([ContactDetailsViewModel]) -> ()) {
        
        var filterredContacts: [ContactDetailsViewModel] = []
        switch contacttype {
        case 0:
            filterredContacts = contacts
        case 1:
            filterredContacts = contacts.filter {
                $0.isSelected
            }
        default:
            return
        }
        completion(filterredContacts)
        return
    }
}

//MARK: - Select all contacts
extension DocumentHelper {
    func selectallContacts(contacttype: Int, selectall: Bool, contacts: [ContactDetailsViewModel], completion: @escaping([ContactDetailsViewModel], [ContactDetailsViewModel]) -> ()) {
        
        var allcontacts: [ContactDetailsViewModel] = []
        
        var filterredcontacts: [ContactDetailsViewModel] = []

        switch contacttype {
        case 0:
            for i in 0..<contacts.count {
                var contactdetail = contacts[i]
                contactdetail.isSelected = selectall
                allcontacts.append(contactdetail)
            }
            filterredcontacts = allcontacts
        case 1:
            for i in 0..<contacts.count {
                var contactdetail = contacts[i]
                if contactdetail.Type! == 1 {
                    contactdetail.isSelected = selectall
                }
                allcontacts.append(contactdetail)
            }
        
            filterredcontacts = allcontacts.filter {
                $0.Type! == 1
            }
        case 2:
            for i in 0..<contacts.count {
                var contactdetail = contacts[i]
                if contactdetail.Type! == 2 {
                    contactdetail.isSelected = selectall
                }
                allcontacts.append(contactdetail)
            }
            
            filterredcontacts = allcontacts.filter {
                $0.Type! == 2
            }
        case 3:
            for i in 0..<contacts.count {
                var contactdetail = contacts[i]
                if contactdetail.Type! == 1 && contactdetail.userType! == 1 {
                    contactdetail.isSelected = selectall
                }
                allcontacts.append(contactdetail)
            }
            
            filterredcontacts = allcontacts.filter {
                $0.Type! == 1 && $0.userType! == 1
            }
        default:
            return
        }
        completion(allcontacts, filterredcontacts)
        return
    }
}

//MARK - Get initiater details
extension DocumentHelper {
    func getinitiaterDetails(contacts: [ContactDetailsViewModel]) -> ContactDetailsViewModel {
        let useremail = ZorroTempData.sharedInstance.getUserEmail()
        let filterredcontact = contacts.filter {
             $0.Email == useremail
        }
        
        if filterredcontact.first != nil {
            return filterredcontact.first!
        }
        
        var initiatorContactData = ContactData()
        
        let _profileId = ZorroTempData.sharedInstance.getProfileId()
        
        if let _removeencodedProfileid = _profileId.removingPercentEncoding {
            initiatorContactData.ProfileId = _removeencodedProfileid
            initiatorContactData.ContactProfileId = _removeencodedProfileid
        }
    
        initiatorContactData.Email = ZorroTempData.sharedInstance.getUserEmail()
        initiatorContactData.Name = ZorroTempData.sharedInstance.getUserName()
        initiatorContactData.Type = 1
        initiatorContactData.UserType = ZorroTempData.sharedInstance.getUserType()
        initiatorContactData.Thumbnail = "DefaultProfileSmall.jpg"
        initiatorContactData.Company = ZorroTempData.sharedInstance.getCompanyName()
        initiatorContactData.JobTitle = ZorroTempData.sharedInstance.getJobTitle()
        
        let initiatorContact = ContactDetailsViewModel(contactdata: initiatorContactData)
        return initiatorContact
    }
}

extension DocumentHelper {
    func checkisInitiatorPresents(selectedcontacts: [ContactDetailsViewModel]) -> Bool {
        let useremail = ZorroTempData.sharedInstance.getUserEmail()
        let filterredcontacts = selectedcontacts.filter {
            $0.Email == useremail
        }
        
        if filterredcontacts.count == 1 {
            return true
        } else {
            return false
        }
    }
}

//MARK: Add view according to tag type
extension DocumentHelper {
    func initiateNewView(step:Int!, tagtype: Int, users: [ContactDetailsViewModel], xposition: CGFloat, yposition: CGFloat) -> UIView {
        
        switch tagtype {
        case 0:
            let newsignatureView = ZorroDocumentInitiateSignatureView(frame: CGRect(x: xposition, y: yposition, width: 148, height: 56))
            newsignatureView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newsignatureView.setSignature(contacts: users)
            newsignatureView.setSignatories(contacts: users)
            return newsignatureView
        case 1:
            let newinitialView = ZorroDocumentInitiateInitialView(frame: CGRect(x: xposition, y: yposition, width: 61, height: 76))
            newinitialView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newinitialView.setSignature(contacts: users)
            newinitialView.setSignatories(contacts: users)
            return newinitialView
        case 2:
            let newstampView = ZorroDocumentInitiateStampView(frame: CGRect(x: xposition, y: yposition, width: 130, height: 130))
            newstampView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newstampView.setSignatories(contacts: users)
            newstampView.setStamp(contacts: users)
            return newstampView
        case 3:
            let newinitialtextView = ZorroDocumentInitiateTextView(frame: CGRect(x: xposition, y: yposition, width: 136, height: 56))
            newinitialtextView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newinitialtextView.setText(contacts: users)
            newinitialtextView.setSignatories(contacts: users)
            return newinitialtextView
        case 4:
            let newinitiatedateViwe = ZorroDocumentInitiateDateView(frame: CGRect(x: xposition, y: yposition, width: 100, height: 60))
            newinitiatedateViwe.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newinitiatedateViwe.setUserDate(contacts: users)
            newinitiatedateViwe.setSignatories(contacts: users)
            return newinitiatedateViwe
        case 8:
            let newinitiatenoteView = ZorroDocumentinitiateDynamicNoteView(frame: CGRect(x: xposition, y: yposition, width: 163, height: 196))
            newinitiatenoteView.setuserProfileId()
            newinitiatenoteView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            let emptycontacts: [ContactDetailsViewModel] = []
            newinitiatenoteView.setSignatories(contacts: emptycontacts)
            newinitiatenoteView.setstepButton(stepnum: step)
            return newinitiatenoteView
        case 13:
            let newinitiatecheckboxView = ZorroDocumentInitiateCheckboxView(frame: CGRect(x: xposition, y: yposition, width: 59, height: 59))
            newinitiatecheckboxView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newinitiatecheckboxView.setSignatories(contacts: users)
            return newinitiatecheckboxView
        case 14:
            let newinitiatedynamictextView = ZorroDocumentInitiateDynamictextView(frame: CGRect(x: xposition, y: yposition, width: 136, height: 56))
            newinitiatedynamictextView.setuserProfileId()
            let emptycontacts: [ContactDetailsViewModel] = []
            newinitiatedynamictextView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newinitiatedynamictextView.setSignatories(contacts: emptycontacts)
            return newinitiatedynamictextView
        case 16:
            let newusernameView = ZorroDocumentInitiateUsernameView(frame: CGRect(x: xposition, y: yposition, width: 210, height: 56))
            newusernameView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newusernameView.setUserName(contacts: users)
            newusernameView.setSignatories(contacts: users)
            return newusernameView
        case 17:
            let newuseremailView = ZorroDocumentInitiateUseremailView(frame: CGRect(x: xposition, y: yposition, width: 193, height: 56))
            newuseremailView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newuseremailView.setUserEmail(contacts: users)
            newuseremailView.setSignatories(contacts: users)
            return newuseremailView
        case 18:
            let newusercompanyView = ZorroDocumentIntiateCompanynameView(frame: CGRect(x: xposition, y: yposition, width: 136, height: 56))
            newusercompanyView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newusercompanyView.setUserCompany(contacts: users)
            newusercompanyView.setSignatories(contacts: users)
            return newusercompanyView
        case 19:
            let newuserjobtitleyView = ZorroDocumentInitiateJobtitleView(frame: CGRect(x: xposition, y: yposition, width: 136, height: 56))
            newuserjobtitleyView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newuserjobtitleyView.setUserJobtitle(contacts: users)
            newuserjobtitleyView.setSignatories(contacts: users)
            return newuserjobtitleyView
        case 20:
            let newuserphonenubmerView = ZorroDocumentInitiatePhonenumView(frame: CGRect(x: xposition, y: yposition, width: 136, height: 56))
            newuserphonenubmerView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newuserphonenubmerView.setUserPhoneNumbertitle(contacts: users)
            newuserphonenubmerView.setSignatories(contacts: users)
            return newuserphonenubmerView
        default:
            let defaultView = ZorroDocumentInitiateBaseView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return defaultView
        }
    }
}

//MARK: Token Tool
extension DocumentHelper {
    func initiatenewTokenView(step:Int!, tagtype: Int, users: [ContactDetailsViewModel], xposition: CGFloat, yposition: CGFloat, newinitiatedviews: [ZorroDocumentInitiateBaseView]) -> (UIView?, String?)  {
        
        let isvalid = DocumentHelper.sharedInstance.numberofTags(newinitiatedviews: newinitiatedviews)
        
        if step == 1 && !isvalid{
            return (nil, "Cannot publish a template or a document without any user assigned tags")
        } else {
            let checkforexistingcount = checkforexistingCount(newviews: newinitiatedviews, tagtype: 6)
            if checkforexistingcount == 0 {
                let newinitiatetokenView = ZorroDocumentInitiateTokenView(frame: CGRect(x: xposition, y: yposition, width: 91, height: 128))
                newinitiatetokenView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
                let emptycontacts: [ContactDetailsViewModel] = []
                newinitiatetokenView.setSignatories(contacts: emptycontacts)
                return (newinitiatetokenView, nil)
            }
            return (nil, "You aready added Token tag")
        }
    }
}



//MARK: Add cc and attachment tags
extension DocumentHelper {
    func initiatenewattachmentccView(step: Int!, tagtype: Int, users: [ContactDetailsViewModel], newviews: [ZorroDocumentInitiateBaseView]) -> (UIView?, String?) {
        
        let existingcount = checkforexistingCount(newviews: newviews, tagtype: tagtype)
        let numberoftools = checkforccattachmentfullCount(newviews: newviews)
        var xvalue: CGFloat = 0.0
        
        if numberoftools == 0 {
            xvalue = 20
        } else {
            xvalue = CGFloat(numberoftools * 200 + 80)
        }
        
        switch tagtype {
        case 9:
            let newuserccView = ZorroDocumentInitiateCcView(frame: CGRect(x: xvalue, y: 10, width: 200, height: 80))
            newuserccView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
            newuserccView.setUserCc(contacts: users)
            newuserccView.setSignatories(contacts: users)
            return (newuserccView, nil)
        case 12:
            
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: users)
            if isinitiator {
                return(nil, "You cannot assign attachment tag to your self")
            }
            if existingcount == 0 {
                let newuserattachmentView = ZorroDocumentInitiateAttachmentView(frame: CGRect(x: xvalue, y: 10, width: 200, height: 80))
                newuserattachmentView.setstepandtagNumber(stepnumber: step, tagtype: tagtype)
                newuserattachmentView.setUserAttachment(contacts: users)
                newuserattachmentView.setSignatories(contacts: users)
                return (newuserattachmentView, nil)
            }
            return (nil, "")
        default:
            return (nil, "")
        }
    }
}

//MARK: - check for existing count
extension DocumentHelper {
    fileprivate func checkforexistingCount(newviews: [ZorroDocumentInitiateBaseView], tagtype: Int) -> Int {
        var newbaseviews: [ZorroDocumentInitiateBaseView] = []
        newbaseviews = newviews.filter {
            $0.tagType == tagtype
        }
        return newbaseviews.count
    }
}

//MARK: - check for number of cc and attachment count
extension DocumentHelper {
    fileprivate func checkforccattachmentfullCount(newviews: [ZorroDocumentInitiateBaseView]) -> Int {
        var newbaseviews: [ZorroDocumentInitiateBaseView] = []
        newbaseviews = newviews.filter {
            $0.tagType == 9 || $0.tagType == 12
        }
        return newbaseviews.count
    }
}

//MARK: - check if attachment or cc exist
extension DocumentHelper {
    func isccorattachmentExists(newinitiatedViews: [ZorroDocumentInitiateBaseView]) -> Bool {
        
        let filterredccattachments = newinitiatedViews.filter {
            $0.tagType == 9 || $0.tagType == 12
        }
        
        if filterredccattachments.count > 0 {
            return true
        }
        return false
    }
}

//MARK: - update step number new tags
extension DocumentHelper {
    func initiateUpdateSteps(initiatedViews: [ZorroDocumentInitiateBaseView], step: Int, tempid: String) -> [ZorroDocumentInitiateBaseView] {
        
        var newinitiatedViews: [ZorroDocumentInitiateBaseView] = []
        newinitiatedViews = initiatedViews.filter {
            $0.tagtempId != tempid
        }
        
        let istoolwithsamestep = istoolswithSameStep(initiatedViews: initiatedViews, step: step)
        
        for initiateview in newinitiatedViews {
            
            
            if initiateview.step > step && !istoolwithsamestep {
                initiateview.step -= 1
            }
            initiateview.stepnumberCircleLabel.text = "\(initiateview.step!)"
            initiateview.setstepandtagNumber(stepnumber: initiateview.step, tagtype: initiateview.tagType)
        }
        
        return newinitiatedViews
    }
}

//MARK: - Chck for tools with same step number
extension DocumentHelper {
    private func istoolswithSameStep(initiatedViews: [ZorroDocumentInitiateBaseView], step: Int) -> Bool {
        
        let filterredviews = initiatedViews.filter {
            $0.step == step
        }
        
        if filterredviews.count > 1 {
            return true
        }
        return false
    }
}

//MARK: - update step with token
extension DocumentHelper {
    func updateStepwithToken(initiatedView: [ZorroDocumentInitiateBaseView], step: Int) -> [ZorroDocumentInitiateBaseView] {
        
        var newinitiatedViews: [ZorroDocumentInitiateBaseView] = []
        newinitiatedViews = initiatedView
        
        for initiateview in newinitiatedViews {
            if initiateview.tagType == 6 {
                initiateview.step = step + 1
                initiateview.stepnumberCircleLabel.text = "\(initiateview.step!)"
                initiateview.setstepandtagNumber(stepnumber: initiateview.step, tagtype: initiateview.tagType)
                break
            }
        }
        
        return newinitiatedViews
    }
}

//MARK: - update dynamic text views (remove)
extension DocumentHelper {
    func initiateUpdateDynamicText(initiateddynamicViews: [ZorroDocumentInitiateBaseView], tempid: String) -> [ZorroDocumentInitiateBaseView] {
        
        var newinitiateddynamicTextViews: [ZorroDocumentInitiateBaseView] = []
        newinitiateddynamicTextViews = initiateddynamicViews.filter {
            $0.tagtempId != tempid
        }
        return newinitiateddynamicTextViews
    }
}


//MARK: - update dynamic notes
extension DocumentHelper {
    func initiateUpdateDynamicNote(initiatedynamicnoteViews: [ZorroDocumentInitiateBaseView], tempid: String, step: Int) -> [ZorroDocumentInitiateBaseView]{
        
        var newinitiateddynamicNoteViews: [ZorroDocumentInitiateBaseView] = []
        newinitiateddynamicNoteViews = initiatedynamicnoteViews.filter {
            $0.tagtempId != tempid
        }
        
        for noteview in newinitiateddynamicNoteViews {
            if noteview.step > 0 {
                if noteview.step > step {
                    noteview.step -= 1
                }
            }
            noteview.stepnumberCircleLabel.text = "\(noteview.step!)"
        }
        return newinitiateddynamicNoteViews
    }
}

//MARK: - get new tags details
extension DocumentHelper {
    func getnewtagsStepDetails(newinitiatedViews: [ZorroDocumentInitiateBaseView], pages: [UIImageView], duedate: Int) -> [Steps] {
        
        let sorteredViews = sortbyStepNumber(initiatednewviews: newinitiatedViews)
        
        var allSteps: [Steps] = []
        
        var tagnumber: Int!
        
        for newview in sorteredViews {
            let isexists = checkforstepExistency(steps: allSteps, stepnumber: newview.step)
            
            if isexists {
                tagnumber += 1
                
                if newview.tagType == 9 {
                    allSteps[newview.step - 1].CCSignatories = newview.signatories
                    for signature in newview.signatories {
                        let newcc = CCList(Id: signature.id, Type: signature.type, UserName: signature.userName, IsCC: true)
                        allSteps[newview.step - 1].CCList.append(newcc)
                    }
                } else {
                    var newTag = Tags()
                    newTag.Type = newview.tagType
                    newTag.Signatories = newview.signatories
                    newTag.TagNo = tagnumber
                    newTag.TimeGap = nil
                    newTag.dueDate = nil
                    newTag.ExtraMetaData = newview.extrametadata
                    
                    var holder = Holder()
                    let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pages, newelement: newview)
                    holder.pageNumber = pagenumber
                    holder.xCoordinate = calculateNewXValue(xvalue: Double(newview.frame.origin.x), tagtype: newview.tagType)
                    holder.yCoordinate = calculateNewYValue(yvalue: y, tagtype: newview.tagType)
                    
                    let(width, height) = calculateWidhandHeith(width: Double(newview.frame.width), height: Double(newview.frame.height), tagtype: newview.tagType)
                    holder.height = height
                    holder.width = width
                    
                    newTag.TagPlaceHolder = holder
                    allSteps[newview.step - 1].Tags.append(newTag)
                }
            } else {
                tagnumber = 1
                var newStep = Steps()
                newStep.StepNo = String(newview.step)
                
                if newview.tagType == 9 {
                    newStep.CCSignatories = newview.signatories
                    for signature in newview.signatories {
                        let newcc = CCList(Id: signature.id, Type: signature.type, UserName: signature.userName, IsCC: true)
                        newStep.CCList.append(newcc)
                    }
                } else {
                    var newTag = Tags()
                    newTag.Type = newview.tagType
                    newTag.Signatories = newview.signatories
                    newTag.TagNo = tagnumber
                    newTag.TimeGap = nil
                    newTag.dueDate = nil
                    newTag.ExtraMetaData = newview.extrametadata
                    
                    var holder = Holder()
                    let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pages, newelement: newview)
                    holder.pageNumber = pagenumber
                    holder.xCoordinate = calculateNewXValue(xvalue: Double(newview.frame.origin.x), tagtype: newview.tagType)
                    holder.yCoordinate = calculateNewYValue(yvalue: y, tagtype: newview.tagType)
                    
                    let(width, height) = calculateWidhandHeith(width: Double(newview.frame.width), height: Double(newview.frame.height), tagtype: newview.tagType)
                    holder.height = height
                    holder.width = width
                
                    newTag.TagPlaceHolder = holder
                    
                    newStep.Tags.append(newTag)
                }
                allSteps.append(newStep)
            }
        }
        
        
        if duedate == 0 {
            return allSteps
        }

        let updatedStpes = updateduedateforEadhStep(steps: allSteps, duegap: duedate)
        return updatedStpes
    }
}

//MARK: - Setup new duedate for each step
extension DocumentHelper {
    private func updateduedateforEadhStep(steps: [Steps], duegap: Int) -> [Steps] {
        var dueupdatedSteps: [Steps] = steps
        
        for i in 0..<dueupdatedSteps.count {
            for j in 0..<dueupdatedSteps[i].Tags.count {
                let (timegap, duestring) = getduedateandGap(duegap: duegap, steps: dueupdatedSteps.count, stepnumber: Int(dueupdatedSteps[i].StepNo!)!)
                dueupdatedSteps[i].Tags[j].TimeGap = timegap
                dueupdatedSteps[i].Tags[j].dueDate = duestring
            }
        }

        return dueupdatedSteps
    }
}

//MARK - calculate width and height
extension DocumentHelper {
    fileprivate func calculateWidhandHeith(width: Double, height: Double, tagtype: Int) -> (Double, Double) {
        
        switch tagtype {
        case 0, 2, 6, 8:
            let newwidth = width - 30
            let newheight = height - 30
            return (newwidth, newheight)
        case 1:
            let newwidth = width - 35
            let newheight = height - 50
            return (newwidth, newheight)
        case 4:
            let newwidth = width
            let newheight = height - 44
            return (newwidth, newheight)
        case 13:
            let newwidth = width - 46
            let newheight = height - 46
            return (newwidth, newheight)
        case 3, 14, 16, 17, 18, 19, 20:
            let newwidth = width - 30
            let newheight = height - 40
            return(newwidth, newheight)
        default:
            return (width, height)
        }
    }
}

//MARK: - Calculate new y value
extension DocumentHelper {
    fileprivate func calculateNewYValue(yvalue: Double, tagtype: Int) -> Double {
        
        switch tagtype {
        case 0, 2, 6, 8 :
            return yvalue + 15
        case 1:
            return yvalue + 25
        case 4:
            return yvalue + 22
        case 13:
            return yvalue + 23
        case 3, 14, 16, 17, 18, 19, 20:
            return yvalue + 20
        default:
            return yvalue
        }
    }
}

//MARK: - Calculate new x value
extension DocumentHelper {
    fileprivate func calculateNewXValue(xvalue: Double, tagtype: Int) -> Double {
        
        switch tagtype {
        case 4, 16, 17, 18, 19, 20:
            return xvalue + 10
        default:
            return xvalue
        }
    }
}

//MARK: - sort by step number
extension DocumentHelper {
    fileprivate func sortbyStepNumber(initiatednewviews: [ZorroDocumentInitiateBaseView]) -> [ZorroDocumentInitiateBaseView] {
        
        let sortedviews = initiatednewviews.sorted(by: { $0.step! < $1.step! })
        return sortedviews
    }
}

//MARK: - check for step existency
extension DocumentHelper {
    fileprivate func checkforstepExistency(steps: [Steps], stepnumber: Int) -> Bool {
        var isexist = false
        let filterredSteps = steps.filter {
            $0.StepNo == "\(stepnumber)"
        }
        filterredSteps.count > 0 ? (isexist = true) : (isexist = false)
        return isexist
    }
}

//MARK: - set timegapa and duedate
extension DocumentHelper {
    fileprivate func getduedateandGap(duegap: Int, steps: Int, stepnumber: Int) -> (Int?, String?) {
        
        let duecount: Double = Double(duegap)
        let stepcount: Double = Double(steps)
        let stepnum: Double = Double(stepnumber)
        
        let averageLatency: Double = duecount/stepcount
        
        let newduegap: Double = stepnum * averageLatency
        let due: Int = Int(round(newduegap))
        
        var _gap: Int?
        var _dueString: String?
        
        if due == 0 {
            _gap = 1
        } else {
            _gap = due
        }
        
        let _day = Date()
        let _dueDate = Calendar.current.date(byAdding: .day, value: _gap ?? 0, to: _day)
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        _dueString = dateformatter.string(from: _dueDate!)
        return (_gap, _dueString)
    }
}

//MARK: - Validate editted duedates for steps
extension DocumentHelper {
    func checkDifferenceDuedate(steps: [Steps], duedate: Int) -> Bool {
        if let _lastStepDate = steps[steps.count - 1].Tags[0].dueDate, let _firstStepDate = steps[0].Tags[0].dueDate {
            
            let dformatter = DateFormatter()
            dformatter.dateFormat = "MMM dd, yyyy"
            
            if let _date1 = dformatter.date(from: _firstStepDate), let _date2 = dformatter.date(from: _lastStepDate) {
                let diffs = Calendar.current.dateComponents([.year, .month, .day], from: _date1, to: _date2)
                print(diffs)
                if diffs.year! >= 0 {
                    let _actualRange = diffs.year! * 365 + diffs.month! * 30 + diffs.day!
                    if _actualRange <= duedate {
                        return true
                    }
                    return false
                }
                return false
            }
            return false
        } else {
            if duedate == 0 {
                return true
            }
            return false
        }
    }
}

//MARK: - validate workflow steps
extension DocumentHelper {
    func checkWorklfowStepsDuedateOrder(steps: [Steps]) -> Bool {
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MMM dd, yyyy"
        var _inOrder = true
        
        for i in 0..<steps.count {
            for j in (i+1)..<steps.count {
                if let _outerDate = steps[i].Tags[0].dueDate, let _innerDate = steps[j].Tags[0].dueDate {
                    if let _outerDateFormatted = dformatter.date(from: _outerDate), let _innerDateFormatted = dformatter.date(from: _innerDate) {
                        if _outerDateFormatted > _innerDateFormatted {
                            _inOrder = false
                        }
                    }
                }
            }
        }
        
        return _inOrder
    }
}

//MARK: - get new dynamic text detaiLs
extension DocumentHelper {
    func getnewDynamicTextDetails(newinitiatedDynamictextViews: [ZorroDocumentInitiateBaseView], pages: [UIImageView]) -> [DynamicTextDetails] {
        
        var alldynamicTextDetails: [DynamicTextDetails] = []
        
        for (index, newdynamictextview) in newinitiatedDynamictextViews.enumerated() {
            
            let newview = newdynamictextview as! ZorroDocumentInitiateDynamictextView
            
            var newdynamictext = DynamicTextDetails()
            newdynamictext.Comment = ""
            newdynamictext.IsDynamicTag = true
            newdynamictext.ObjectId = ""
            newdynamictext.Signatory = newview.signature
            newdynamictext.TagText = newview.textField.text
            
            var tagvalues = TagValues()
            tagvalues.Type = newview.tagType
            tagvalues.Signatories = newview.signatories
            tagvalues.TagNo = index + 1
            tagvalues.State = 0
            tagvalues.ExtraMetaData = newview.extrametadata
            
            var holder = Holder()
            let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pages, newelement: newview)
            holder.pageNumber = pagenumber
            holder.xCoordinate = calculateNewXValue(xvalue: Double(newview.frame.origin.x), tagtype: newview.tagType)
            holder.yCoordinate = calculateNewYValue(yvalue: y, tagtype: newview.tagType)
            let(width, height) = calculateWidhandHeith(width: Double(newview.frame.width), height: Double(newview.frame.height), tagtype: newview.tagType)
            holder.height = height
            holder.width = width
            
            tagvalues.TagPlaceHolder = holder
            
            newdynamictext.TagValue = tagvalues
            
            alldynamicTextDetails.append(newdynamictext)
        }
        return alldynamicTextDetails
    }
}

//MARK: - get new dynamic note details
extension DocumentHelper {
    func getnewDynamicNoteDetails(newinitiatedDynamicNoteViews: [ZorroDocumentInitiateBaseView], pages: [UIImageView]) -> [NoteDetails] {
        
        var allnoteDetails: [NoteDetails] = []
        
        for (index, dynamicnote) in newinitiatedDynamicNoteViews.enumerated() {
            
            let newview = dynamicnote as! ZorroDocumentinitiateDynamicNoteView
            
            var newdynamiceNote = NoteDetails()
            newdynamiceNote.Comment = ""
            newdynamiceNote.IsDynamicTag = true
            newdynamiceNote.ObjectId = ""
            newdynamiceNote.StepNo = 1
            newdynamiceNote.Signatory = newview.signature
            newdynamiceNote.TagText = newview.textarea.text
            
            var tagvalues = TagValues()
            tagvalues.Type = newview.tagType
            tagvalues.Signatories = newview.signatories
            tagvalues.TagNo = index + 1
            tagvalues.State = 0
            tagvalues.ExtraMetaData = newview.extrametadata
            
            var holder = Holder()
            let(pagenumber, y) = getpagenubmerfornewElement(imageviews: pages, newelement: newview)
            holder.pageNumber = pagenumber
            holder.xCoordinate = calculateNewXValue(xvalue: Double(newview.frame.origin.x), tagtype: newview.tagType)
            holder.yCoordinate = calculateNewYValue(yvalue: y, tagtype: newview.tagType)
            let(width, height) = calculateWidhandHeith(width: Double(newview.frame.width), height: Double(newview.frame.height), tagtype: newview.tagType)
            holder.height = height
            holder.width = width
            
            tagvalues.TagPlaceHolder = holder
            
            newdynamiceNote.TagValue = tagvalues
            
            allnoteDetails.append(newdynamiceNote)
        }
        
        return allnoteDetails
    }
}

//MARK: - check whether to call save all
extension DocumentHelper {
    func shoulldcallSaveallProcess(steps: [Steps]) -> Bool {
        var shouldcall: Bool = false
        
        for step in steps {
            if step.StepNo! == "1" {
                for tag in step.Tags {
                    if tag.Type! != 6 {
                        for signatory in tag.Signatories! {
                            let useremail = ZorroTempData.sharedInstance.getUserEmail()
                            if useremail == signatory.userName! {
                                shouldcall = true
                                break
                            }
                        }
                    }
                }
            }
        }
        return shouldcall
    }
}

//MARK: - get docsave object for save all process
extension DocumentHelper {
    func getdocsaveProcessObject(pwd: String, otpcode: Int, docprocess: DocProcess, pdfPassword: String) -> DocSaveProcess {
        
        var docSaveProcess = DocSaveProcess()
        docSaveProcess.password = pwd
        docSaveProcess.otpcode = otpcode
        
        var processSaveDetailsDto = ProcessSaveDetailsDto()
        processSaveDetailsDto.workflowDefinitionID = docprocess.data?.definitionID
        processSaveDetailsDto.processID = docprocess.data?.processID
        processSaveDetailsDto.IssingleInstance = true
        processSaveDetailsDto.tagDetailString?.kbaResult = ""
        processSaveDetailsDto.tagDetailString?.tagData = docprocess.data?.autoSavedData?.tagDetails?.tagData
        processSaveDetailsDto.pdfPassword = pdfPassword
        
        var alltagDetails: [TagDetails] = []
        
        let step = docprocess.data!.steps![0]
        for tag in step.tags! {
            var tagdetail = TagDetails()
            var tagvalue = TagValue()
            var extrametadata = ExtraMetaDataSave()
            
            switch tag.type {
            case 0:
                tagdetail.comment = ""
                tagdetail.tagText = ""
                
                extrametadata.tickX = tag.tagPlaceHolder!.xCoordinate! + tag.tagPlaceHolder!.width! * 0.2
                extrametadata.tickY = tag.tagPlaceHolder!.yCoordinate! + tag.tagPlaceHolder!.height! * 0.77
                extrametadata.tickW = tag.tagPlaceHolder!.width! * 0.4
                extrametadata.tickH = tag.tagPlaceHolder!.height! * 0.18
                
                if let signatureid = tag.extraMetaData?.signatureID {
                    extrametadata.signatureID = Int(signatureid)
                }
                tagvalue.extraMetaData = extrametadata
            case 1:
                tagdetail.comment = ""
                tagdetail.tagText = ""
                
                if let signatureid = tag.extraMetaData?.signatureID {
                    extrametadata.signatureID = Int(signatureid)
                }
                tagvalue.extraMetaData = extrametadata
            case 2:
                tagdetail.comment = ""
                tagdetail.tagText = ""
            case 3:
                tagdetail.comment = ""
                tagdetail.tagText = tag.extraMetaData?.tagText
            case 4:
                tagdetail.comment = ""
                tagdetail.tagText = tag.extraMetaData?.tagText
            case 6:
                tagdetail.comment = ""
                tagdetail.tagText = ""
            case 8:
                tagdetail.comment = ""
                tagdetail.tagText = tag.extraMetaData?.tagText
            case 12:
                
                if let attachmentcount = tag.extraMetaData?.attachmentCount {
                    extrametadata.count = Int(attachmentcount)
                    tagvalue.extraMetaData = extrametadata
                }
            case 13:

                extrametadata.textX = tag.tagPlaceHolder!.xCoordinate! + tag.tagPlaceHolder!.height! + 8
                extrametadata.textY = tag.tagPlaceHolder!.yCoordinate!+20
                extrametadata.textW = tag.tagPlaceHolder!.width! + tag.tagPlaceHolder!.height! + 8
                extrametadata.textH = tag.tagPlaceHolder!.height!
                extrametadata.checkState = tag.extraMetaData?.checkState
                
                tagvalue.extraMetaData = extrametadata
            case 14:
                tagdetail.comment = ""
                tagdetail.tagText = tag.extraMetaData?.tagText
            case 16, 17, 18, 19, 20:
                tagdetail.comment = ""
                tagdetail.tagText = tag.extraMetaData?.tagText
            default:
                print("default")
            }
            
            tagvalue.type = tag.type
            tagvalue.signatories = tag.signatories
            tagvalue.signatories = tag.signatories
            tagvalue.tagPlaceHolder = tag.tagPlaceHolder
            tagvalue.extraMetaData = extrametadata
            tagvalue.tagNo = tag.tagNo
            tagvalue.state = 4
            tagvalue.objectID = ""
            
            tagdetail.tagValue = tagvalue
            alltagDetails.append(tagdetail)
        }
        
        processSaveDetailsDto.tagDetails = alltagDetails
        docSaveProcess.processSaveDetailsDto.append(processSaveDetailsDto)
        
        return docSaveProcess
    }
}

//MARK: - get all tagcount
extension DocumentHelper {
    func numberofTags(newinitiatedviews: [ZorroDocumentInitiateBaseView]) -> Bool {
        if newinitiatedviews.count > 0 {
            if newinitiatedviews.count == 1 {
                if let _tagtype = newinitiatedviews.first?.tagType {
                    if _tagtype == 6 {
                        return false
                    }
                    return true
                }
                return false
            }
            return true
        }
        return false
    }
}

//MARK: - get document names
extension DocumentHelper {
    func getdocumentNames(documents: [GetWorkflowDocument]) -> (String, Int) {
        var names = ""
        var count = 0
        
        for document in documents {
            count += 1
            names += document.Name! + "\n"
        }
        return (names, count)
    }
}

//MARK: - check for same users
extension DocumentHelper {
    func isSameUsers(previoususer: [ContactDetailsViewModel], currentusers: [ContactDetailsViewModel]) -> Bool {
        
        let previous = previoususer.sorted(by: { $0.Name! > $1.Name! })
        let current = currentusers.sorted(by: { $0.Name! > $1.Name! })
        
        if previous == current {
            return true
        }
        return false
    }
}

//MARK: - update document step
extension DocumentHelper {
    func updateDocumenStepValue(documentstep: Int, newinitiatedViews: [ZorroDocumentInitiateBaseView]) -> Bool {
        var isexist: Bool = false
        let filterredViews = newinitiatedViews.filter {
            $0.step == documentstep
        }
        filterredViews.count > 0 ? (isexist = true) : (isexist = false)
        return isexist
    }
}

//MARK: - remove duplicates from selected contacts
extension DocumentHelper {
    func removeduplicateContats(selectedcontacts: [ContactDetailsViewModel], morecontacts: [ContactDetailsViewModel]) -> [ContactDetailsViewModel] {
        
        var selectedContacts = selectedcontacts
        
        for contact in morecontacts {
            switch contact.Type {
            case 2:
                let filteredcontact = selectedcontacts.filter {
                    $0.GroupContactEmails == contact.GroupContactEmails
                }
                if filteredcontact.count == 0 {
                    selectedContacts.append(contact)
                }
            default:
                let filteredcontact = selectedcontacts.filter {
                    $0.Email == contact.Email
                }
                if filteredcontact.count == 0 {
                    selectedContacts.append(contact)
                }
            }
        }
        return selectedContacts
    }
}

//MARK: - Validate tools are outside
extension DocumentHelper {
    func checktoolcoordinatesareValid(newinitiatedview: ZorroDocumentInitiateBaseView, pages: [UIImageView], zoomscal: CGFloat) {
        
        //fist check with page width:
        
        let draggedviewx = newinitiatedview.frame.origin.x
        let draggedviewwidth = newinitiatedview.frame.width
        let draggedviewendx = draggedviewx + draggedviewwidth
        
//        let draggedviewy = newinitiatedview.frame.origin.y
//        let draggedviewheight = newinitiatedview.frame.height
//        print("y value : \(draggedviewy) ---> height: \(draggedviewheight)")
//        let draggedviewendy = draggedviewy + draggedviewheight
//        print("end y : \(draggedviewendy)")
        var _width = newinitiatedview.frame.width
        
        let (pagenumber, _) = getpagenubmerfornewElement(imageviews: pages, newelement: newinitiatedview)
        
        if pagenumber != 0 {
            
            let superimageview = pages[pagenumber-1]
            let superviewwidth = superimageview.frame.width
            
            if _width >= superviewwidth {
                _width = superviewwidth - 30
                newinitiatedview.frame = CGRect(x: 30.0, y: newinitiatedview.frame.origin.y, width: _width, height: newinitiatedview.frame.height)
                return
            }
            
            if draggedviewx < 0 {
                newinitiatedview.frame = CGRect(x: 30.0, y: newinitiatedview.frame.origin.y, width: _width, height: newinitiatedview.frame.height)
                return
            }
            
            if draggedviewendx >= superviewwidth {
                let xdifference = draggedviewendx - superviewwidth
                let newxvalue = draggedviewx - xdifference
                
                newinitiatedview.frame = CGRect(x: newxvalue, y: newinitiatedview.frame.origin.y, width: _width, height: newinitiatedview.frame.height)
                return
            }
        }
    }
}
