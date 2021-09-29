//
//  UpprRegisterAgreementCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpprRegisterAgreementCell: UpprRegisterBaseCell {
    
    private var checkboxButon: UIButton!
    private var agreementTextView: UITextView!
    var agreeementCallBack: ((Bool) -> ())?
    var ischecked: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension UpprRegisterAgreementCell {
    
    @objc override func setcellUI() {
        
        checkboxButon = UIButton()
        checkboxButon.translatesAutoresizingMaskIntoConstraints = false
        checkboxButon.imageView?.contentMode = .center
        addSubview(checkboxButon)
        
        let checkboxbuttonConstraints = [checkboxButon.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                         checkboxButon.centerYAnchor.constraint(equalTo: centerYAnchor),
                                         checkboxButon.widthAnchor.constraint(equalToConstant: 25),
                                         checkboxButon.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(checkboxbuttonConstraints)
        
        checkboxButon.layer.cornerRadius = 5
        checkboxButon.layer.borderColor = UIColor.lightGray.cgColor
        checkboxButon.layer.borderWidth = 1
        
        checkboxButon.addTarget(self, action: #selector(agreementAction(_:)), for: .touchUpInside)
        
        agreementTextView = UITextView()
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
        agreementTextView.text = "I agree to the Terms & Conditions and Privacy Policy"
        agreementTextView.font = UIFont(name: "Helvetica", size: 16)
        agreementTextView.textAlignment = .left
        agreementTextView.isEditable = false
        agreementTextView.bounces = false
        addSubview(agreementTextView)
        
        let agreementtextviewConstraints = [agreementTextView.leftAnchor.constraint(equalTo: checkboxButon.rightAnchor, constant: 10),
                                            agreementTextView.topAnchor.constraint(equalTo: checkboxButon.topAnchor, constant: -10),
                                            agreementTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                            agreementTextView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(agreementtextviewConstraints)
    }
}

extension UpprRegisterAgreementCell {
    @objc
    private func agreementAction(_ sender: UIButton) {
        
        ischecked = !ischecked
        
        if ischecked {
            checkboxButon.setImage(UIImage(named: "checkbox_sel_black"), for: .normal)
        } else {
           checkboxButon.setImage(UIImage(named: ""), for: .normal)
        }
        agreeementCallBack!(ischecked)
    }
}
