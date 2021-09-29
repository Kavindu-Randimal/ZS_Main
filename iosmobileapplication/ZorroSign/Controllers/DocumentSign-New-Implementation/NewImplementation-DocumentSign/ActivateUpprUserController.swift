//
//  ActivateUpprUserController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 8/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI

class ActivateUpprUserController: UIViewController {
    
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeith = UIScreen.main.bounds.height
    private let greencolor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    private let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    
    private var containerView: UIView!
    private var footerView: UIView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    private var zorrosignLogo: UIImageView!
    private var modaltextLabel: UILabel!
    var uppruserEmail: String!
    
    var registeruserpopupCallBack: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setbackgroundContainer()
        setcontent()
        setfooterViewUI()
        
    }
}

//MARK: Setup Container View
extension ActivateUpprUserController {
    
    private func setbackgroundContainer() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let _width = deviceWidth - 40
        let _height: CGFloat = 280
        
        let backcontainerConstraints = [containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        containerView.widthAnchor.constraint(equalToConstant: _width),
                                        containerView.heightAnchor.constraint(equalToConstant: _height)]
        NSLayoutConstraint.activate(backcontainerConstraints)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        
    }
}

//MARK:- Set Modal Content
extension ActivateUpprUserController {
    private func setcontent() {
        
        zorrosignLogo = UIImageView()
        zorrosignLogo.translatesAutoresizingMaskIntoConstraints = false
        zorrosignLogo.backgroundColor = .white
        zorrosignLogo.contentMode = .scaleAspectFit
        zorrosignLogo.image = UIImage(named: "zorrosign_highres_logo")
        
        containerView.addSubview(zorrosignLogo)
        
        let logoHeight = (deviceWidth - 80)/2.77
        
        let zorrosignlogoConstraints = [zorrosignLogo.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
                                        zorrosignLogo.topAnchor.constraint(equalTo: containerView.topAnchor),
                                        zorrosignLogo.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant:  -20),
                                        zorrosignLogo.heightAnchor.constraint(equalToConstant: logoHeight)]
        NSLayoutConstraint.activate(zorrosignlogoConstraints)
        
        modaltextLabel = UILabel()
        modaltextLabel.translatesAutoresizingMaskIntoConstraints = false
        modaltextLabel.text = "Please register " + uppruserEmail  + " account to view the document"
        modaltextLabel.textAlignment = .center
        modaltextLabel.numberOfLines = 3
        modaltextLabel.font = UIFont(name: "Helvetica", size: 17)
        modaltextLabel.textColor = .darkGray
        containerView.addSubview(modaltextLabel)
        
        let modalLabelConstraints = [modaltextLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 5),
                                     modaltextLabel.topAnchor.constraint(equalTo: zorrosignLogo.bottomAnchor),
                                     modaltextLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5)]
        NSLayoutConstraint.activate(modalLabelConstraints)
    }
}

//MARK: Set Footer View
extension ActivateUpprUserController {
    private func setfooterViewUI() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(footerView)
        
        let footerviewConstrints = [footerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                    footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                    footerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                    footerView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(footerviewConstrints)
        
        
        let _buttonWidth = (deviceWidth - 40)/2 - 20
        
        confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitle("REGISTER ACCOUNT", for: .normal)
        confirmButton.backgroundColor = greencolor
        
        footerView.addSubview(confirmButton)
        
        let confirmbuttonConstraints = [
            confirmButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 10),
            confirmButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
            confirmButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
            confirmButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant:  -5)]
        NSLayoutConstraint.activate(confirmbuttonConstraints)
        
        confirmButton.layer.shadowRadius = 1.0
        confirmButton.layer.borderColor = greencolor.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.shadowColor  = UIColor.lightGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        confirmButton.layer.shadowOpacity = 0.5
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 5
        
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
}

//MARK: Button Actions
extension ActivateUpprUserController {
    @objc private func confirmAction(_ sender: UIButton) {
        registeruserpopupCallBack!()
        self.dismiss(animated: true, completion: nil)
    }
}



