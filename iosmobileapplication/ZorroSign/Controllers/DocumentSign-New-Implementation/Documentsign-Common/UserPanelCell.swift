//
//  UserPanelCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class UserPanelCell: UITableViewCell {

    private let greencolor: UIColor = ColorTheme.btnBG
    private let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private let cellselectedcolor: UIColor = UIColor.init(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    private var selectedColor: UIColor!
    
    private var backgroundcontainerView: UIView!
    private var userimage: CachedImageView!
    private var username: UILabel!
    private var useremail: UILabel!
    private var melabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        selectionStyle = .gray
        setcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var documentStep: Int! {
        didSet {
            selectedColor = DocumentHelper.sharedInstance.getstepColor(step: documentStep)
        }
    }
    
    var contactdetail: ContactDetailsViewModel! {
        didSet {
            
            let email = ZorroTempData.sharedInstance.getUserEmail()
            if email == contactdetail.Email {
                username.isHidden = true
                useremail.isHidden = true
                melabel.isHidden = false
            } else {
                username.isHidden = false
                useremail.isHidden = false
                melabel.isHidden = true
                username.text = contactdetail.Name
                useremail.text = contactdetail.Email
            }
            userimage.loadImage(urlString: contactdetail.profileimage!)
        }
    }
    
    var userselected: Bool! {
        didSet {
            userselected ? selected() : deselected()
        }
    }
}

extension UserPanelCell {
    fileprivate func setcellUI() {
        backgroundcontainerView = UIView()
        backgroundcontainerView.translatesAutoresizingMaskIntoConstraints = false
        backgroundcontainerView.backgroundColor = .white
        addSubview(backgroundcontainerView)
        
        let backgroundcontainerviewConstraints = [backgroundcontainerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
                                                  backgroundcontainerView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
                                                  backgroundcontainerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
                                                  backgroundcontainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(backgroundcontainerviewConstraints)
        
        userimage = CachedImageView()
        userimage.translatesAutoresizingMaskIntoConstraints = false
        userimage.backgroundColor = .black
        userimage.contentMode = .scaleAspectFit
        backgroundcontainerView.addSubview(userimage)

        let userimageconstrints = [userimage.centerYAnchor.constraint(equalTo: backgroundcontainerView.centerYAnchor),
                                   userimage.leftAnchor.constraint(equalTo: backgroundcontainerView.leftAnchor, constant: 15),
                                   userimage.widthAnchor.constraint(equalToConstant: 40),
                                   userimage.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(userimageconstrints)

        userimage.layer.cornerRadius = 20
        userimage.layer.masksToBounds = true
        userimage.layer.borderWidth = 1
        userimage.layer.borderColor = UIColor.darkGray.cgColor

        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.text = "chanaka caldera"
        username.font = UIFont(name: "Helvetica", size: 17)
        username.textColor = .darkGray
        backgroundcontainerView.addSubview(username)

        let uernameConstraints = [username.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 15),
                                  username.topAnchor.constraint(equalTo: userimage.topAnchor)]
        NSLayoutConstraint.activate(uernameConstraints)

        useremail = UILabel()
        useremail.translatesAutoresizingMaskIntoConstraints = false
        useremail.text = "example@gmail.com"
        useremail.font = UIFont(name: "Helvetica", size: 14)
        useremail.textColor = .black
        backgroundcontainerView.addSubview(useremail)

        let useremailConstraints = [useremail.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 15),
                                    useremail.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 2)]
        NSLayoutConstraint.activate(useremailConstraints)
        
        melabel = UILabel()
        melabel.translatesAutoresizingMaskIntoConstraints = false
        melabel.text = "Me"
        melabel.isHidden = true
        melabel.font = UIFont(name: "Helvetica", size: 18)
        melabel.textColor = .black
        backgroundcontainerView.addSubview(melabel)
        
        let meConstraints = [melabel.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 15),
                                    melabel.centerYAnchor.constraint(equalTo: backgroundcontainerView.centerYAnchor)]
        NSLayoutConstraint.activate(meConstraints)
    }
}

extension UserPanelCell {
    fileprivate func selected() {
        backgroundcontainerView.backgroundColor = cellselectedcolor
        userimage.layer.borderColor = selectedColor.cgColor
    }
    
    fileprivate func deselected() {
        backgroundcontainerView.backgroundColor = .white
        userimage.layer.borderColor = UIColor.darkGray.cgColor
    }
}
