//
//  ToolPanelCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ToolPanelCell: UICollectionViewCell {
    
    private var imageview: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var tool: ToolPanel! {
        didSet {
            imageview.image = UIImage(named: tool.noramlImag!)
        }
    }
}

extension ToolPanelCell {
    fileprivate func setcellUI() {
        imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.contentMode = .center
        addSubview(imageview)
        let imageviewconstraints = [imageview.leftAnchor.constraint(equalTo: leftAnchor),
                                    imageview.topAnchor.constraint(equalTo: topAnchor),
                                    imageview.rightAnchor.constraint(equalTo: rightAnchor),
                                    imageview.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(imageviewconstraints)
    }
}
