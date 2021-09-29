//
//  MultifactorBaseController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorBaseController: UIViewController {

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

extension MultifactorBaseController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Multi-factor Authentication"
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTitleDefault
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

extension MultifactorBaseController {
    func showmultifactorAlert(alerttitle: String, alertmessage: String, actiontitle: String) {
        let multifactoralertcontroller = UIAlertController(title: title, message: alertmessage, preferredStyle: .alert)
        multifactoralertcontroller.view.tintColor = greencolor
        let multifactoralertAction = UIAlertAction(title: actiontitle, style: .cancel) { (action) in }
        multifactoralertcontroller.addAction(multifactoralertAction)
        self.present(multifactoralertcontroller, animated: true, completion: nil)
    }
}
