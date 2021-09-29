//
//  DocProcessUIDynamicNoteElement.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import PDFKit

struct DocProcessUIDynamicNoteElement {
    
    var tagType: Int!
    let tagId: Int!
    let tagNo: Int!
    var isDeleted: Bool!
    var isLocked: Bool!
    var isDynamicTag: Bool!
    var signedAt: String!
    var tagText: String?
    var pageNumber: Int!
    var xCoordinate: Double!
    var yCoordinate: Double!
    var yCoordinateDefault: Double!
    let elementHeight: Double!
    let elementWidth: Double!
    var extrametaData: PurpleExtraMetaData?
    var tagName: String!
    var tagElement: UIView!
    
    init(dynamictagdetails: DynamicTagDetail, pdfview: PDFView, notetagnumber: Int) {
        self.tagType = dynamictagdetails.tagValue?.type
        self.tagId = dynamictagdetails.tagValue?.tagID
        self.tagNo = dynamictagdetails.tagValue?.tagNo
        self.isDeleted = dynamictagdetails.isDeleted
        self.isLocked = dynamictagdetails.isLocked
        self.isDynamicTag = dynamictagdetails.isDynamicTag
        self.signedAt = dynamictagdetails.signedAt
        self.tagText = dynamictagdetails.tagText
        self.pageNumber = dynamictagdetails.tagValue?.tagPlaceHolder?.pageNumber
        self.elementHeight = dynamictagdetails.tagValue?.tagPlaceHolder?.height
        self.elementWidth = dynamictagdetails.tagValue?.tagPlaceHolder?.width
        self.extrametaData = dynamictagdetails.tagValue?.extraMetaData
        self.yCoordinateDefault = dynamictagdetails.tagValue?.tagPlaceHolder?.yCoordinate
        let (xvalue, yvalue) = setelementXYCoordinate(pdfview: pdfview, tagplaceholder: (dynamictagdetails.tagValue?.tagPlaceHolder)!)
        self.xCoordinate = xvalue
        self.yCoordinate = yvalue
        self.tagName = DocumentHelper.sharedInstance.returnTagName(tagtype: (dynamictagdetails.tagValue?.type)!)
        self.tagElement = createElementUI(notetagnumber: notetagnumber, tagtext: dynamictagdetails.tagText!)
    }
}

//MARK: Set Element X, Y Coordintes
extension DocProcessUIDynamicNoteElement {
    
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
extension DocProcessUIDynamicNoteElement {
    fileprivate func createElementUI(notetagnumber: Int, tagtext: String) -> UIView {
        let zorronodynamicteview = ZorroDynamicNoteView()
        zorronodynamicteview.frame = setelementRect()
        zorronodynamicteview.showButtons()
        zorronodynamicteview.setextraMetaData(purpleextarmetadata: extrametaData!, tagnumber: tagNo!, tagtext: tagtext)
        return zorronodynamicteview
    }
}

//MARK: Set Element Rect
extension DocProcessUIDynamicNoteElement {
    fileprivate func setelementRect() -> CGRect {
        var viewframe: CGRect!
        viewframe = CGRect(x: xCoordinate, y: yCoordinate, width: elementWidth, height: elementHeight)
        return viewframe
    }
}

