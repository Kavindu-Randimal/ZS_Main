//
//  OTPVerifyTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class OTPVerifyTVCell: UITableViewCell {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var digitalTF1: UITextField!
    @IBOutlet weak var digitalTF2: UITextField!
    @IBOutlet weak var digitalTF3: UITextField!
    @IBOutlet weak var digitalTF4: UITextField!
    
    @IBOutlet weak var lblErrorMsg: UILabel!
    @IBOutlet weak var lblTimer: UILabel!
    
    @IBOutlet weak var lblResendChange: UILabel!
    @IBOutlet weak var btnVerify: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        baseView.layer.cornerRadius = 10
        baseView.addShadowAllSide()
    }
}
