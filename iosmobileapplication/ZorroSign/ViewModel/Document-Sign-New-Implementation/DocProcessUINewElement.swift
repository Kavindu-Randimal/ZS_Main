//
//  DocProcessUINewElement.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct DocProcessUINewElement {
    
    let tagType: Int!
    var elementdynamicId: Int!
    var tagId: Int!
    var pageNumber: Int!
    var xCoordinate: Double!
    var yCoordinate: Double!
    var elementHeight: Double!
    var elementWidth: Double!
    var tagName: String!
    var tagElement: UIView!
    
    init(tagtype: Int, yposition: CGFloat, notetagnumber: Int) {
        self.tagType = tagtype
        self.tagElement = createElementUI(tagtype: tagtype, yposition: yposition, notetagnumber: notetagnumber)
    }
}

// MARK: Create Element
extension DocProcessUINewElement {
    
    fileprivate func createElementUI(tagtype: Int, yposition: CGFloat, notetagnumber: Int) -> UIView {
        switch tagtype {
        case 0:
            let zorrosignatureview = ZorroSignatureView()
            zorrosignatureview.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            return zorrosignatureview
        case 1:
            let zorroinitialsview = ZorroInitialsView()
            zorroinitialsview.frame = CGRect(x: 20, y: 100, width: 50, height: 50)
            return zorroinitialsview
        case 2:
            let zorrostampview = ZorroStampView()
            zorrostampview.frame = CGRect(x: 20, y: 100, width: 180, height: 180)
            return zorrostampview
        case 3:
            let zorrotextintputview = ZorroTextInputView()
            zorrotextintputview.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            return zorrotextintputview
        case 4:
            let zorrodateview = ZorroDateView()
            zorrodateview.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            return zorrodateview
        case 6:
            let zorrotokenview = ZorroTokenView()
            zorrotokenview.frame = CGRect(x: 20, y: 100, width: 80, height: 180)
            return zorrotokenview
        case 8:
            let zorronoteview = ZorroDynamicNoteView()
            zorronoteview.frame = CGRect(x: 20, y: yposition, width: 133.33, height: 166.67)
            zorronoteview.showButtons()
            zorronoteview.setdynamicnoteAddedBy(tagnumber: notetagnumber)
            zorronoteview.tagtype = tagtype
            return zorronoteview
        case 13:
            let zorrocheckboxview = ZorrocheckboxView()
            zorrocheckboxview.frame = CGRect(x: 20, y: 100, width: 30, height: 30)
            return zorrocheckboxview
        case 14:
            let zorrodynamicinputtext = ZorroDynamicTextView()
            zorrodynamicinputtext.frame = CGRect(x: 20, y: yposition, width: 120, height: 30)
            zorrodynamicinputtext.showButtons()
            zorrodynamicinputtext.tagtype = tagtype
            return zorrodynamicinputtext
        case 16, 17, 18, 19, 20:
            let zorrocommontextinputviwe = ZorroCommonTextInput()
            zorrocommontextinputviwe.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            return zorrocommontextinputviwe
        default:
            let zorrotextintputview = ZorroTextInputView()
            zorrotextintputview.frame = CGRect(x: 20, y: 100, width: 100, height: 40)
            return zorrotextintputview
        }
    }
}

