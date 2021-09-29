//
//  ExInt.swift
//  ZorroSign
//
//  Created by Mathivathanan on 7/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

extension Int {
    
    func toString() -> String {
        switch self {
        case 1: return "FIRST"
        case 2: return "SECOND"
        case 3: return "THIRD"
        default: return String()
        }
    }
}
