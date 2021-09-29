//
//  DocProcessUIDynamicTextElement.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import PDFKit

struct DocProcessUIDynamicTextElement {
    let tagType: Int!
    let tagId: Int!
    var isDeleted: Bool!
    var isLocked: Bool!
    var isDynamicTag: Bool!
    var signedAt: String!
    let tagText: String?
    let pageNumber: Int!
    var xCoordinate: Double!
    var yCoordinate: Double!
    var yCordeinateDefault: Double!
    let elementHeight: Double!
    let elementWidth: Double!
    let extrametaData: FluffyExtraMetaData?
    var tagName: String!
    var tagElement: UIView!
    
    init(dynamictextdetails: DynamicTextDetail, pdfview: PDFView) {
        self.tagType = dynamictextdetails.tagValue?.type
        self.tagId = dynamictextdetails.tagValue?.tagID
        self.isDeleted = dynamictextdetails.isDeleted
        self.isLocked = dynamictextdetails.isLocked
        self.isDynamicTag = dynamictextdetails.isDynamicTag
        self.signedAt = dynamictextdetails.signedAt
        self.tagText = dynamictextdetails.tagText
        self.pageNumber = dynamictextdetails.tagValue?.tagPlaceHolder?.pageNumber
        self.elementHeight = dynamictextdetails.tagValue?.tagPlaceHolder?.height
        self.elementWidth = dynamictextdetails.tagValue?.tagPlaceHolder?.width
        self.extrametaData = dynamictextdetails.tagValue?.extraMetaData
        self.yCordeinateDefault = dynamictextdetails.tagValue?.tagPlaceHolder?.yCoordinate
        let (xvalue, yvalue) = setelementXYCoordinate(pdfview: pdfview, tagplaceholder: (dynamictextdetails.tagValue?.tagPlaceHolder)!)
        self.xCoordinate = xvalue
        self.yCoordinate = yvalue
        self.tagName = DocumentHelper.sharedInstance.returnTagName(tagtype: (dynamictextdetails.tagValue?.type)!)
        self.tagElement = createElementUI(tagtext: dynamictextdetails.tagText!)
    }
}

//MARK: Set Element X, Y Coordintes
extension DocProcessUIDynamicTextElement {
    
    fileprivate func setelementXYCoordinate(pdfview: PDFView, tagplaceholder: Holder) -> (Double, Double) {
        
        let xvalue: Double! = tagplaceholder.xCoordinate
        var yvalue: Double! = tagplaceholder.yCoordinate
        let pagebreakerMargin = pdfview.pageBreakMargins
        
        if tagplaceholder.pageNumber == 1 {
            yvalue += Double(pagebreakerMargin.top)
            print(xvalue)
            print(yvalue)
        } else {
            for i in 1..<tagplaceholder.pageNumber! {
                let pageRect = pdfview.document?.page(at: i)?.bounds(for: .mediaBox)
                let pageHeight = pageRect!.height
                yvalue += Double(pageHeight)
            }
            print(xvalue)
            print(yvalue)
        }
        return (xvalue, yvalue)
    }
}

//MARK: Create Element
extension DocProcessUIDynamicTextElement {
    fileprivate func createElementUI(tagtext: String) -> UIView {
        let dynamictextview = ZorroDynamicTextView()
        dynamictextview.frame = setelementRect()
        dynamictextview.setextraMetaData(fluffyextrametadata: extrametaData!, tagtext: tagtext)
        return dynamictextview
    }
}

//MARK: Set Element Rect
extension DocProcessUIDynamicTextElement {
    fileprivate func setelementRect() -> CGRect {
        var viewframe: CGRect!
        viewframe = CGRect(x: xCoordinate, y: yCoordinate, width: elementWidth, height: elementHeight)
        return viewframe
    }
}


