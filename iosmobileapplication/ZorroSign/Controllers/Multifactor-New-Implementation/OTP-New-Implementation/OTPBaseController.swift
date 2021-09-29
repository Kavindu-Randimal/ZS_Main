//
//  OTPBaseController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OTPBaseController: UIViewController {
    
    let greencolor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setnavbar()
    }
}

//MARK: Setup Navbar
extension OTPBaseController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "OTP Authentication"
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
