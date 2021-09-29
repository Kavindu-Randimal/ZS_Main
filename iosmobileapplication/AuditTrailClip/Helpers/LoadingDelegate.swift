//
//  LoadingDelegate.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class Loader: UIViewController {
    
    let container1: UIView = UIView()
    let loadingView1: UIView = UIView()
    let actInd1: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func showActivityIndicatory(uiView: UIView) {
        
        
        self.container1.isHidden = false
        container1.frame = uiView.frame
        container1.center = uiView.center 
        container1.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
        
        self.loadingView1.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        self.loadingView1.center = uiView.center
        self.loadingView1.backgroundColor = .clear//UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)//UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1.0)
        self.loadingView1.clipsToBounds = true
        self.loadingView1.layer.cornerRadius = 10
        
        self.actInd1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.actInd1.style = UIActivityIndicatorView.Style.whiteLarge
        self.actInd1.color = UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
        self.actInd1.center = CGPoint(x: self.loadingView1.frame.size.width / 2, y: self.loadingView1.frame.size.height / 2)
        
        self.loadingView1.addSubview(self.actInd1)
        container1.addSubview(self.loadingView1)
        uiView.addSubview(container1)
        
        self.actInd1.startAnimating()
    }
    
    func stopActivityIndicator()
    {
        DispatchQueue.main.async {
            self.actInd1.stopAnimating()
            self.actInd1.hidesWhenStopped = true
            self.container1.isHidden = true
        }
    }
}
