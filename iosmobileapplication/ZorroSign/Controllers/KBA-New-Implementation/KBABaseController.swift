//
//  KBABaseController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class KBABaseController: UIViewController {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var loadingView: UIView!
    private var loadingInticator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .white
        setnavbar()
        setLoadingView()
    }
}

//MARK: Setup Navbar
extension KBABaseController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "User Validation"
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

//MARK: Setup Loading View
extension KBABaseController {
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
        loadingInticator.color = ColorTheme.activityindicator
        loadingInticator.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(loadingInticator)
        
        let loadingindicatorConstraints = [loadingInticator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                                           loadingInticator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)]
        NSLayoutConstraint.activate(loadingindicatorConstraints)
    }
}

//MARK: Show Loading View
extension KBABaseController {
    func showKBALoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
            self.loadingInticator.startAnimating()
            self.view.bringSubviewToFront(self.loadingView)
        }
    }
}

//MARK: Hide Loading View
extension KBABaseController {
    func hideKBALoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
            self.loadingInticator.stopAnimating()
            self.view.sendSubviewToBack(self.loadingView)
        }
    }
}

//MARK: Setup Alert
extension KBABaseController {
    func showKBAAlert(title: String, message: String, actiontitle: String, secondattempt: Bool) {
        let kbaalertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        kbaalertController.view.tintColor = greencolor
        let kbaalertAction = UIAlertAction(title: actiontitle, style: .default) { [weak self](action) in
            self?.kbaAlertOkAction()
        }
        kbaalertController.addAction(kbaalertAction)
        
        if secondattempt {
            let kbacontinueAction = UIAlertAction(title: "CONTINUE", style: .default) { [weak self] (action) in
                self?.kbaContinueAction()
            }
            kbaalertController.addAction(kbacontinueAction)
        }
        
        DispatchQueue.main.async {
            self.present(kbaalertController, animated: true, completion: nil)
        }
    }
}

//MARK: Alert Actions
extension KBABaseController {
    @objc func kbaAlertOkAction() { }
    
    @objc func kbaContinueAction() { }
}


