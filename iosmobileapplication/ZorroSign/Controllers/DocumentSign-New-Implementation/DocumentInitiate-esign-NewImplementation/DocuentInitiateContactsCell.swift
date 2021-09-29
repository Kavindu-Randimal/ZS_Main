//
//  DocuentInitiateContactsCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/1/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocuentInitiateContactsCell: UITableViewCell {
    
    private let greencolor: UIColor = ColorTheme.btnBG
    private let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    
    private var backgroundcontainerView: UIView!
    private var userimage: CachedImageView!
    private var tickLabel: UILabel!
    private var username: UILabel!
    private var useremail: UILabel!

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
        setcontentUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var contactdetail: ContactDetailsViewModel! {
        didSet {
            userimage.loadImage(urlString: contactdetail.profileimage!)
            username.text = contactdetail.Name
            useremail.text = contactdetail.Email
            
            if contactdetail.isSelected {
                tickLabel.textColor = greencolor
                tickLabel.text = String.fontAwesomeIcon(name: .checkCircle)
            } else {
                tickLabel.textColor = .white
                tickLabel.text = ""
            }
        }
    }
}

extension DocuentInitiateContactsCell {
    fileprivate func setcontentUI () {
        
        backgroundcontainerView = UIView()
        backgroundcontainerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundcontainerView.backgroundColor = .white
        addSubview(backgroundcontainerView)
        
        let backgroundcontainerviewConstraints = [backgroundcontainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                                  backgroundcontainerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                                  backgroundcontainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                                  backgroundcontainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(backgroundcontainerviewConstraints)
       
        backgroundcontainerView.layer.shadowRadius = 1.5;
        backgroundcontainerView.layer.shadowColor   = UIColor.lightGray.cgColor
        backgroundcontainerView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        backgroundcontainerView.layer.shadowOpacity = 0.9;
        backgroundcontainerView.layer.masksToBounds = false;
        backgroundcontainerView.layer.cornerRadius = 5
        
        userimage = CachedImageView()
        userimage.translatesAutoresizingMaskIntoConstraints = false
        userimage.backgroundColor = .black
        userimage.contentMode = .scaleAspectFit
        backgroundcontainerView.addSubview(userimage)
        
        let userimageconstrints = [userimage.centerYAnchor.constraint(equalTo: backgroundcontainerView.centerYAnchor),
                                   userimage.leftAnchor.constraint(equalTo: backgroundcontainerView.leftAnchor, constant: 5),
                                   userimage.widthAnchor.constraint(equalToConstant: 40),
                                   userimage.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(userimageconstrints)
        
        userimage.layer.cornerRadius = 20
        userimage.layer.masksToBounds = true
        userimage.layer.borderColor = UIColor.darkGray.cgColor
        userimage.layer.borderWidth = 1
        
        tickLabel = UILabel()
        tickLabel.translatesAutoresizingMaskIntoConstraints = false
        tickLabel.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        backgroundcontainerView.addSubview(tickLabel)
        
        let ticklabelConstraints = [tickLabel.centerYAnchor.constraint(equalTo: backgroundcontainerView.centerYAnchor),
                                     tickLabel.rightAnchor.constraint(equalTo: backgroundcontainerView.rightAnchor, constant: -10),
                                     tickLabel.widthAnchor.constraint(equalToConstant: 30),
                                     tickLabel.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(ticklabelConstraints)
        
        tickLabel.layer.borderColor = UIColor.lightGray.cgColor
        tickLabel.layer.borderWidth = 1
        tickLabel.layer.masksToBounds = true
        tickLabel.layer.cornerRadius = 15
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.text = "chanaka caldera"
        username.font = UIFont(name: "Helvetica", size: 17)
        username.textColor = .darkGray
        backgroundcontainerView.addSubview(username)
        
        let uernameConstraints = [username.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 10),
                                  username.rightAnchor.constraint(equalTo: tickLabel.leftAnchor, constant:  -5),
                                  username.topAnchor.constraint(equalTo: userimage.topAnchor)]
        NSLayoutConstraint.activate(uernameConstraints)
        
        useremail = UILabel()
        useremail.translatesAutoresizingMaskIntoConstraints = false
        useremail.text = "example@gmail.com"
        useremail.font = UIFont(name: "Helvetica", size: 14)
        useremail.textColor = .lightGray
        backgroundcontainerView.addSubview(useremail)
        
        let useremailConstraints = [useremail.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 10),
                                    useremail.rightAnchor.constraint(equalTo: tickLabel.leftAnchor, constant:  -5),
                                    useremail.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 2)]
        NSLayoutConstraint.activate(useremailConstraints)
    }
}
