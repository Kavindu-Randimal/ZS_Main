//
//  EnvironmentVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/12/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class EnvironmentVC: UIViewController {
    
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet var colSwitches: [UISwitch]!
    
    @IBOutlet var views: [UIView]!
    
    var selectedswitch: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        Singletone.shareInstance.setEnvironment(id: selectedswitch)
    }
    
    func configUI() {
        views.forEach { (view) in
            view.layer.cornerRadius = 6
            view.addShadowAllSide()
        }
        
        btnProceed.layer.cornerRadius = 10
        btnProceed.addShadowAllSide()
    }
    
    @IBAction func didTapOnSwitch(_ sender: UISwitch) {
        
        colSwitches.forEach { (switchx) in
            if switchx.tag == sender.tag {
                selectedswitch = sender.tag
            } else {
                switchx.setOn(false, animated: true)
            }
        }
        
        Singletone.shareInstance.setEnvironment(id: selectedswitch)
    }
    
    @IBAction func didTapOnProceed(_ sender: UIButton) {
        performSegue(withIdentifier: "segGotoLoginFromEnv", sender: self)
    }
}
