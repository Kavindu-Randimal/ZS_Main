//
//  HintController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class HintController: DocumentInitiateBaseController {
    
    //MARK: - outlets
    private var backgroundView: UIView!
    var hintLabel: UILabel!
    
    //MARK: - properties
    var hintmessage: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = greencolor
        setBackgroundView()
        sethintLabel()
    }
}

//MARK: - set background view
extension HintController {
    fileprivate func setBackgroundView() {
        backgroundView = UIView()
        backgroundView.backgroundColor = greencolor
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        let backgroundviewConstraints = [backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                         backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
                                         backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                         backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(backgroundviewConstraints)
    }
}

//MARK: - set hint label
extension HintController {
    fileprivate func sethintLabel() {
        hintLabel = UILabel()
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 100
        hintLabel.textColor = .white
        hintLabel.adjustsFontSizeToFitWidth = true
        hintLabel.minimumScaleFactor = 0.3
        hintLabel.font = UIFont(name: "Helvetica", size: 18)
        hintLabel.text = hintmessage
        
        backgroundView.addSubview(hintLabel)
        
        let hintlabelConstraints = [hintLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 5),
                                    hintLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 5),
                                    hintLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -5),
                                    hintLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)]
        NSLayoutConstraint.activate(hintlabelConstraints)
    }
}
