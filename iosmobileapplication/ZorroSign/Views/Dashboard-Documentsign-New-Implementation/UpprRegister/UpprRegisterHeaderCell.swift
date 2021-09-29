//
//  UpprRegisterHeaderCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UpprRegisterHeaderCell: UpprRegisterBaseCell {
    
    private var greenView: UIView!
    private var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}


extension UpprRegisterHeaderCell {
    override func setcellUI() {
        
        greenView = UIView()
        greenView.translatesAutoresizingMaskIntoConstraints = false
        greenView.backgroundColor = greencolor
        addSubview(greenView)
        
        let greenviewConstraitns = [greenView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                    greenView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                    greenView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                    greenView.heightAnchor.constraint(equalToConstant: 2)]
        NSLayoutConstraint.activate(greenviewConstraitns)
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .justified
        headerLabel.text = "Please provide details below to complete the document"
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        addSubview(headerLabel)
        
        let headerlabelConstraints = [headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                      headerLabel.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 20),
                                      headerLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                      headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)]
        NSLayoutConstraint.activate(headerlabelConstraints)
    }
}
