//
//  FallbackBaseController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FallbackBaseController: UIViewController {
    
    let greenColor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
