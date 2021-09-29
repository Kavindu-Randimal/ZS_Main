//
//  ZorroUTCTimeZoneCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroUTCTimeZoneCell: UITableViewCell {
    
    private var imageview: UIImageView!
    private var utctime: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setutccellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var zorrotimezone: ZorroTimeZone! {
        didSet {
            utctime.text = zorrotimezone.DisplayName
        }
    }
}

extension ZorroUTCTimeZoneCell {
    fileprivate func setutccellUI() {
        
        imageview = UIImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        imageview.image = UIImage(named: "Time-zone")
        imageview.setImageColor(color: .darkGray)
        imageview.backgroundColor = .clear
        imageview.contentMode = .center
        
        addSubview(imageview)
        
        let imageviewconstraints = [imageview.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    imageview.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                    imageview.widthAnchor.constraint(equalToConstant: 0),
                                    imageview.heightAnchor.constraint(equalToConstant: 0)]
        NSLayoutConstraint.activate(imageviewconstraints)
        
        imageview.isHidden = true
        
        utctime = UILabel()
        utctime.translatesAutoresizingMaskIntoConstraints = false
        utctime.textAlignment = .left
        utctime.font = UIFont(name: "helvetica", size: 15)
        utctime.text = "(UTC-09:00) Alaska"
        utctime.textColor = .darkGray
        addSubview(utctime)
        
        let utctimeConstraints = [utctime.leftAnchor.constraint(equalTo: imageview.rightAnchor, constant: 5),
                                  utctime.topAnchor.constraint(equalTo: topAnchor),
                                  utctime.rightAnchor.constraint(equalTo: rightAnchor),
                                  utctime.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(utctimeConstraints)
        
    }
}

