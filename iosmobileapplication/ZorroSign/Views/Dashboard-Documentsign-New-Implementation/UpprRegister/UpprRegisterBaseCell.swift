//
//  UpprRegisterBaseCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpprRegisterBaseCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setcellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension UpprRegisterBaseCell {
    @objc func setcellUI() { }
}
