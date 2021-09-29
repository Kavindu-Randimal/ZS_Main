//
//  CollapsibleCell.swift
//  ZorroSign
//
//  Created by Apple on 31/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class CollapsibleCell: UITableViewCell {

    
    @IBOutlet weak var btnToggle: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var btnArrow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
