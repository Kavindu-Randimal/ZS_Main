//
//  Handlers.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

typealias actionHandler = (_ status: Bool, _ message: String) -> ()
typealias completionHandler = (_ status: Bool, _ code: Int, _ message: String) -> ()
typealias completionHandlerWithDate = (_ status: Bool, _ code: Int, _ message: String, _ date: Any?) -> ()
