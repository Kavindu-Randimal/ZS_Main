//
//  BannerCell.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 4/29/21.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

protocol BannerDelegate {
    func dismissBanner()
    func navigatetoSubscription()
}

class BannerView: UIView {
    
    var delegate: BannerDelegate?
    var title: String!
    var cangotoSubscription: Bool!
    
    @IBAction func bannerCloseBtn(_ sender: UIButton) {
        print("banner is closing")
        delegate?.dismissBanner()
    }
    
    @IBAction func bannergotoSubscription(_ sender: Any) {
        print("navigate to subscription")
        if cangotoSubscription {
            delegate?.navigatetoSubscription()
        }
    }
    
    
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var colseBtn: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        initSubViews()
    }
    
    private func initSubViews() {
        let origImage = UIImage(named: "close")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        colseBtn.setImage(tintedImage, for: .normal)
        colseBtn.tintColor = .white
        bannerLabel.text = title
    }
    
}
