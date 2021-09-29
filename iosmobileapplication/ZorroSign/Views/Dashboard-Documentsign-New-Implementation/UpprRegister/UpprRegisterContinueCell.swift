//
//  UpprRegisterContinueCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpprRegisterContinueCell: UpprRegisterBaseCell {
    
    private var continueButton: UIButton!
    var continueCallBack: ((Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

extension UpprRegisterContinueCell {
    @objc override func setcellUI() {
        
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = greencolor
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        
        addSubview(continueButton)
        
        let continuebuttonConstraints = [continueButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                         continueButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                                         continueButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                         continueButton.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(continuebuttonConstraints)
        
        continueButton.layer.cornerRadius = 8
        continueButton.addTarget(self, action: #selector(continueAction(_:)), for: .touchUpInside)
        
    }
}

extension UpprRegisterContinueCell {
    @objc
    private func continueAction(_ sender: UIButton) {
        continueCallBack!(true)
    }
}
