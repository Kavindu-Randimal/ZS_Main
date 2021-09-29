//
//  DetailsCell.swift
//  ZorroSign
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var btnPrint: UIButton!
    @IBOutlet weak var con_workW: NSLayoutConstraint!
    
    @IBOutlet weak var con_dotbtnW: NSLayoutConstraint!
    
    @IBOutlet weak var btnReminder: UIButton!
    
    
    @IBOutlet weak var btnOption: UIButton!
    
    @IBOutlet weak var barbtnOption: UIBarButtonItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
