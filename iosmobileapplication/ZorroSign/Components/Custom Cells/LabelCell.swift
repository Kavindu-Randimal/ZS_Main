//
//  LabelCell.swift
//  ZorroSign
//
//  Created by Apple on 03/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@objc protocol labelCellDelegate {
    
    func onChecked(id: Int, flag: Bool)
    
    @objc optional
    func onEditClicked(id: Int, type: Int)
    
    @objc optional
    func onSortClicked(_ sender: UIButton)
    
}

class LabelCell: UITableViewCell {

    var delegate: labelCellDelegate?
    
    @IBOutlet weak var btnchk: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnlink: UIButton!
    
    @IBOutlet weak var btnchkW: NSLayoutConstraint!
    @IBOutlet weak var btnedit: UIButton!
    @IBOutlet weak var btnview: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var btndel: UIButton!
    @IBOutlet weak var imgProf: UIImageView!
    
    @IBOutlet weak var catIcon: UIImageView!
    
    @IBOutlet weak var con_collvwHgt: NSLayoutConstraint!
    @IBOutlet weak var iconW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if collView != nil {
            
            
            collView.register(UINib(nibName: "LinkCollectionView", bundle: nil), forCellWithReuseIdentifier: "tagCell")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func checkedAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        delegate?.onChecked(id: sender.tag, flag: sender.isSelected)
    }
    
    
    
    @IBAction func editAction(_ sender: UIButton) {
        
        let type = Int(sender.accessibilityHint!)
        delegate?.onEditClicked!(id: sender.tag, type: type!)
    }
    
    @IBAction func sortAction(_ sender: UIButton){
        
        self.catIcon.isHighlighted = !self.catIcon.isHighlighted
        delegate?.onSortClicked!(sender)
    }
}
