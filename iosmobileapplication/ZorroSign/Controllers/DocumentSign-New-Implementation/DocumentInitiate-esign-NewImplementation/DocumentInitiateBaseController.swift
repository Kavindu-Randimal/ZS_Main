//
//  DocumentInitiateBaseController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentInitiateBaseController: UIViewController, BannerDelegate {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    let lightblue:UIColor = UIColor.init(red:0.20, green:0.45, blue:0.87, alpha:1.0)
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var backdropView: UIView!
    private var backdropIndicator: UIActivityIndicatorView!
    private var alertController: UIAlertController!
    var bannerView: BannerView = BannerView()
    var cancelDocument = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLoading()
    }
}

//MARK - Subscription banner methods
extension DocumentInitiateBaseController {
    func setTitleForSubscriptionBanner() {
        SubscriptionBanners.shared.getTitleForSubscriptionBanner { (message, upgrade) in
            if message != "" {
                self.setUpBanner(title: message, upgrade: upgrade)
            }
        }
    }
    
    func setUpBanner(title: String, upgrade: Bool) {
        let safearea = self.view.safeAreaLayoutGuide
        bannerView = (Bundle.main.loadNibNamed("BannerView", owner: self, options: nil)?.first as? BannerView)!
        bannerView.delegate = self
        bannerView.title = title
        bannerView.cangotoSubscription = upgrade
        
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        bannerView.backgroundColor = ColorTheme.lblBody
        self.view.addSubview(bannerView)
        self.view.bringSubviewToFront(bannerView)
        
        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: safearea.topAnchor),
            bannerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            bannerView.rightAnchor.constraint(equalTo: self.view.rightAnchor)
        ])
    }
    
    func dismissBanner() {
        bannerView.removeFromSuperview()
        ZorroTempData.sharedInstance.setBannerClose(isClosed: true)
    }
    
    func navigatetoSubscription() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Subscription", bundle:nil)
        let signatureVC = storyBoard.instantiateViewController(withIdentifier: "SubscriptionVC") as! SubscriptionVC
        self.navigationController?.pushViewController(signatureVC, animated: true)
    }
}

extension DocumentInitiateBaseController {
    fileprivate func setupLoading() {
        
        backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.backgroundColor = .white
        view.addSubview(backdropView)
        
        let backdropviewConstraints = [backdropView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       backdropView.topAnchor.constraint(equalTo: view.topAnchor),
                                       backdropView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                       backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(backdropviewConstraints)
        
        backdropIndicator = UIActivityIndicatorView(style: .whiteLarge)
        backdropIndicator.translatesAutoresizingMaskIntoConstraints = false
        backdropView.addSubview(backdropIndicator)
        backdropIndicator.color = ColorTheme.activityindicator
        
        let backdropindicatorConstraints = [backdropIndicator.centerXAnchor.constraint(equalTo: backdropView.centerXAnchor),
                                            backdropIndicator.centerYAnchor.constraint(equalTo: backdropView.centerYAnchor),
                                            backdropIndicator.widthAnchor.constraint(equalToConstant: 50),
                                            backdropIndicator.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(backdropindicatorConstraints)
    }
}

extension DocumentInitiateBaseController {
    func showbackDrop() {
        backdropIndicator.startAnimating()
        backdropView.isHidden = false
        view.bringSubviewToFront(backdropView)
    }
}

//MARK - Hide BackDrop
extension DocumentInitiateBaseController {
    func hidebackDrop() {
        backdropIndicator.stopAnimating()
        backdropView.isHidden = true
        view.sendSubviewToBack(backdropView)
    }
}

//MARK: - show message alert
extension DocumentInitiateBaseController {
    func showalertMessage(title: String, message: String, cancel: Bool) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = greencolor
        
        let okaction = UIAlertAction(title: "OK", style: .default) { (alert) in
            self.genericokAction()
        }
        alertController.addAction(okaction)
        
        if cancel {
            let cancelaction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
                self.genericcancelAction()
            }
            alertController.addAction(cancelaction)
        }
        
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true, completion: nil)
        }
    }
}

//MARK: - Alert Actions
extension DocumentInitiateBaseController {
    @objc func genericokAction() {
        if(self.cancelDocument){
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    @objc func genericcancelAction() { }
}
