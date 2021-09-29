//
//  FallbackSaveSettingsBaseVC.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 7/16/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation

class FallbackSaveSettingsBaseVC: UIViewController {
    
    let greenColor: UIColor = ColorTheme.btnBG
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
