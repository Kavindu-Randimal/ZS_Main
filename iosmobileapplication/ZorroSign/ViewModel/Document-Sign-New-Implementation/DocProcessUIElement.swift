//
//  DocProcessUIElement.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import PDFKit

struct DocProcessUIElement {
    
    let tagType: Int!
    let tagId: Int!
    let tagNo: Int!
    let tagState: Int!
    var tagSignatories: [Signatory]
    let pageNumber: Int!
    var xCoordinate: Double!
    let yCoordinateDefault: Double!
    var yCoordinate: Double!
    let elementHeight: Double!
    let elementWidth: Double!
    let extrametaData: ExtraMetaData!
    let autosavedData: AutoSavedData?
    var tagName: String!
    var tagElement: UIView!
    
    init(tagtype:Int, tagid: Int, tagno: Int, tagstate: Int, signatories: [Signatory], tagplaceholder: Holder, extrametadata: ExtraMetaData, autosaveddata: AutoSavedData?, pdfview: PDFView) {
        self.tagType = tagtype
        self.tagId = tagid
        self.tagNo = tagno
        self.tagState = tagstate
        self.tagSignatories = signatories
        self.pageNumber = tagplaceholder.pageNumber
        self.elementHeight = tagplaceholder.height!
        self.elementWidth = tagplaceholder.width!
        self.extrametaData = extrametadata
        self.autosavedData = autosaveddata
        self.tagName = DocumentHelper.sharedInstance.returnTagName(tagtype: tagtype)
        self.yCoordinateDefault = tagplaceholder.yCoordinate
        let (xvalue, yvalue) = setelementXYCoordinate(pdfview: pdfview, tagplaceholder: tagplaceholder)
        self.xCoordinate = xvalue
        self.yCoordinate = yvalue
        self.tagElement = createElementUI(tagtype: tagtype)
    }
}

// MARK: Set Element X, Y Coordinate
extension DocProcessUIElement {
    
    fileprivate func setelementXYCoordinate(pdfview: PDFView, tagplaceholder: Holder) -> (Double, Double) {
        
        let xvalue: Double! = tagplaceholder.xCoordinate
        var yvalue: Double! = tagplaceholder.yCoordinate
      
        if tagplaceholder.pageNumber == 1 {
            print(xvalue)
            print(yvalue)
        } else {
            for i in 1..<tagplaceholder.pageNumber! {
                let pageRect = pdfview.document?.page(at: i-1)?.bounds(for: .mediaBox)
                let pageHeight = pageRect!.height
                yvalue += Double(pageHeight)
            }
            print(xvalue)
            print(yvalue)
        }
        return (xvalue, yvalue)
    }
}

// MARK: Create Element
extension DocProcessUIElement {
    
    fileprivate func createElementUI(tagtype: Int) -> UIView {
        
        switch tagtype {
        case 0:
            let zorrosignatureview = ZorroSignatureView()
            zorrosignatureview.frame = setelementRect()
            zorrosignatureview.tagtype = tagtype
            zorrosignatureview.tagID = tagId
            zorrosignatureview.tagName = tagName
            zorrosignatureview.setelementTag()
            zorrosignatureview.setProperties(autosaved: autosavedData)
            return zorrosignatureview
        case 1:
            let zorroinitialsview = ZorroInitialsView()
            zorroinitialsview.frame = setelementRect()
            zorroinitialsview.tagtype = tagtype
            zorroinitialsview.tagID = tagId
            zorroinitialsview.tagName = tagName
            zorroinitialsview.setelementTag()
            zorroinitialsview.setProperties(autosaved: autosavedData)
            return zorroinitialsview
        case 2:
            let zorrostampview = ZorroStampView()
            zorrostampview.frame = setelementRect()
            zorrostampview.tagtype = tagtype
            zorrostampview.tagID = tagId
            zorrostampview.tagName = tagName
            zorrostampview.setelementTag()
            zorrostampview.setProperties(autosaved: autosavedData)
            return zorrostampview
        case 3:
            let zorrotextintputview = ZorroTextInputView()
            zorrotextintputview.frame = setelementRect()
            zorrotextintputview.tagtype = tagtype
            zorrotextintputview.tagID = tagId
            zorrotextintputview.tagName = tagName
            zorrotextintputview.setProperties(extrametadta: extrametaData, autosaved: autosavedData)
            return zorrotextintputview
        case 4:
            let zorrodateview = ZorroDateView()
            zorrodateview.frame = setelementRect()
            zorrodateview.tagtype = tagtype
            zorrodateview.tagID = tagId
            zorrodateview.tagName = tagName
            zorrodateview.setProperties(extrametadta: extrametaData, autosaved: autosavedData)
            return zorrodateview
        case 6:
            let zorrotokenview = ZorroTokenView()
            zorrotokenview.frame = setelementRect()
            zorrotokenview.tagtype = tagtype
            zorrotokenview.tagID = tagId
            zorrotokenview.tagName = tagName
            zorrotokenview.setelementTag()
            return zorrotokenview
        case 8:
            let zorronoteview = ZorroDynamicNoteView()
            zorronoteview.frame = setelementRect()
            zorronoteview.tagtype = tagtype
            zorronoteview.tagID = tagId
            zorronoteview.tagName = tagName
            return zorronoteview
        case 12:
            let zorrodefaultview = ZorroTagBaseView()
            zorrodefaultview.frame = setelementRect()
            zorrodefaultview.backgroundColor = .clear
            zorrodefaultview.isHidden = true
            zorrodefaultview.iscompleted = true
            zorrodefaultview.tagText = "AT"
            if let count = Int(extrametaData.attachmentCount!) {
                zorrodefaultview.attachmentCount = count
            }
            return zorrodefaultview
        case 13:
            let zorrocheckboxview = ZorrocheckboxView()
            zorrocheckboxview.frame = setelementRect()
            zorrocheckboxview.tagtype = tagtype
            zorrocheckboxview.tagID = tagId
            zorrocheckboxview.tagName = tagName
            zorrocheckboxview.setProperties(autosaved: autosavedData)
            return zorrocheckboxview
        case 14:
            let zorrodynamicinputtext = ZorroDynamicTextView()
            zorrodynamicinputtext.frame = setelementRect()
            zorrodynamicinputtext.tagtype = tagtype
            zorrodynamicinputtext.tagID = tagId
            zorrodynamicinputtext.tagName = tagName
            return zorrodynamicinputtext
        case 16, 17, 18, 19, 20:
            let zorrocommontextinputview = ZorroCommonTextInput()
            zorrocommontextinputview.frame = setelementRect()
            zorrocommontextinputview.tagtype = tagtype
            zorrocommontextinputview.tagID = tagId
            zorrocommontextinputview.tagName = tagName
            zorrocommontextinputview.setProperties(extrametadta: extrametaData, autosaved: autosavedData)
            return zorrocommontextinputview
        default:
            let zorrodefaultview = UIView()
            zorrodefaultview.frame = setelementRect()
            zorrodefaultview.backgroundColor = .clear
            return zorrodefaultview
        }
    }
}

//MARK: Set Element Rect
extension DocProcessUIElement {
    fileprivate func setelementRect() -> CGRect {
        var viewframe: CGRect!
        viewframe = CGRect(x: xCoordinate, y: yCoordinate, width: elementWidth, height: elementHeight)
        return viewframe
    }
}

