//
//  MultifactorBaseCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/10/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MultifactorTwoFABaseCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    var baseContainer: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setBaseContainer()
        setCellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension MultifactorTwoFABaseCell {
    @objc
    private func setBaseContainer() {
        
        baseContainer = UIView()
        baseContainer.translatesAutoresizingMaskIntoConstraints = false
        baseContainer.backgroundColor = .white
        
        addSubview(baseContainer)
        
        let basecontainerConstraints = [baseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                        baseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        baseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                        baseContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(basecontainerConstraints)
        baseContainer.setShadow()
    }
}

extension MultifactorTwoFABaseCell {
    @objc
    func setCellUI() { }
}
