//
//  NetworkConnectivity.swift
//  ZorroSign
//
//  Created by Apple on 19/06/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() -> Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}

