//
//  SignObject.swift
//  ZorroSign
//
//  Created by Apple on 16/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

class SignObject: NSObject {
    
    var signOpt: String?
    var signDisp: String?
    var signFont: String?
    var signDrawLines: [Line] = []
    var signImg: UIImage!
    var initialOpt: String?
    var initialDisp: String?
    var initialFont: String?
    var initialDrawLines: [Line] = []
    var initialImg: UIImage!
    var signColor: UIColor?
    var signFontSize: CGFloat = 1.0
    var saveOpt: String?
    var saveOptVal1: String?
    var saveOptVal2: String?
    var saveOptVal3: String?
    var isDefault:Bool = false
    var signPathArr:[SignaturePath] = []
    var initialPathArr:[SignaturePath] = []
    var userSignId: String?
    var signature: String?
    var initials: String?
    var colorUpdate: Bool = false
    
    
    override init() {
        super.init()
    }
}
