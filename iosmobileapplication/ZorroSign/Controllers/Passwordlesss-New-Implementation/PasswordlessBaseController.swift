//
//  PasswordlessBaseController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/19/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class PasswordlessBaseController: UIViewController {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    let fontScale = UIScreen.main.bounds.width/414
    
    private var loadingView: UIView!
    private var loadingInticator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLoadingView()
        setnavbar()
    }
}

//MARK: Setup Navbar
extension PasswordlessBaseController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Manage Biometrics"
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

//MARK: - Passwordless Alert
extension PasswordlessBaseController {
    func showPasswordlessAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = greencolor
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.passwordlessOKAction()
            return
        }
        alertController.addAction(okAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: Setup Loading View
extension PasswordlessBaseController {
    private func setLoadingView() {
        
        loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        loadingView.isHidden = true
        
        view.addSubview(loadingView)
        
        let safearea = view.safeAreaLayoutGuide
        
        let loadingviewConstraints = [loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                      loadingView.topAnchor.constraint(equalTo: safearea.topAnchor),
                                      loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(loadingviewConstraints)
        
        loadingInticator = UIActivityIndicatorView(style: .whiteLarge)
        loadingInticator.translatesAutoresizingMaskIntoConstraints = false
        loadingInticator.color = ColorTheme.activityindicator
        loadingView.addSubview(loadingInticator)
        
        let loadingindicatorConstraints = [loadingInticator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                                           loadingInticator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)]
        NSLayoutConstraint.activate(loadingindicatorConstraints)
    }
}

//MARK: Show Loading View
extension PasswordlessBaseController {
    func showPasswordlessLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingInticator.startAnimating()
            self.view.bringSubviewToFront(self.loadingView)
        }
    }
}

//MARK: Hide Loading View
extension PasswordlessBaseController {
    func hidePasswordlessLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.loadingInticator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
        }
    }
}

//MARK: - Alert Action
extension PasswordlessBaseController {
    @objc func passwordlessOKAction() { }
}
