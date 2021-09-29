//
//  ExViewController.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    func alertCompletion(strTitle: String, strMsg: String, vc: UIViewController) {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        
        let okaction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            vc.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okaction)
        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
    }
    
    func alertSample(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
    }
    func alertSampleError(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            self.dismiss(animated: false, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
    }
    func alertSampleWithFailed(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        /*
        alert.addAction(UIAlertAction(title: "Sign up", style: .default, handler: {
            action in
            self.performSegue(withIdentifier: "gotoSignUp", sender: self)
        }))*/
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
    func alertSignupWithFailed(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        
         alert.addAction(UIAlertAction(title: "Sign up", style: .default, handler: {
         action in
//         self.performSegue(withIdentifier: "gotoSignUp", sender: self)
         }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
    
    #if !AuditTrailClip
    func alertSampleWithLogin(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: {
            action in
            ZorroTempData.sharedInstance.clearAllTempData()
            FeatureMatrix.shared.clearValues()
            UserDefaults.standard.set("", forKey: "UserName")
            UserDefaults.standard.set("", forKey: "footerFlag")
            self.performSegue(withIdentifier: "gotoLoginView", sender: self)
        }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
    }
    #endif

}
