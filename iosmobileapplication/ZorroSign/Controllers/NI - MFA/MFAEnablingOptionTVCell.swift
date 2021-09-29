//
//  MFAEnablingOptionTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MFAEnablingOptionTVCell: UITableViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var lblHeader2: UILabel!
    @IBOutlet weak var switchLoginProcess: UISwitch!
    @IBOutlet weak var switchApprovalProcess: UISwitch!
    
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
