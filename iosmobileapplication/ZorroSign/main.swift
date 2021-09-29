//
//  main.swift
//  ZorroSign
//
//  Created by Apple on 04/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

UIApplicationMain(CommandLine.argc, UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)), NSStringFromClass(ZorroSignApp.self), NSStringFromClass(AppDelegate.self))
