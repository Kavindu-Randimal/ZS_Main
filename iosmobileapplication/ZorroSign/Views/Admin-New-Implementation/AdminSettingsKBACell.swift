//
//  AdminSettingsKBACell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AdminSettingsKBACell: UITableViewCell {
    
    private var cellBackground: UIView!
    private var kbaIcon: UIImageView!
    private var kbaHeading: UILabel!
    private var kbaSwitch: UISwitch!
    private var kbasubHeading: UILabel!
    
    var kbaStatusCallBack: ((Int?) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setBackground()
        setContent()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var setkbaStatus: Int! {
        didSet {
            if setkbaStatus == 1 {
                DispatchQueue.main.async {
                    self.kbaSwitch.isOn = true
                }
                return
            }
            DispatchQueue.main.async {
                self.kbaSwitch.isOn = false
            }
            return
        }
    }
}

//MARK: - Setup Cell UI : Bakcground
extension AdminSettingsKBACell {
    
    private func setBackground() {
        cellBackground = UIView()
        cellBackground.translatesAutoresizingMaskIntoConstraints = false
        cellBackground.backgroundColor = .white
        
        addSubview(cellBackground)
        
        let cellbackgroundConstraints = [cellBackground.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                         cellBackground.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                         cellBackground.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                         cellBackground.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 5)]
        
        NSLayoutConstraint.activate(cellbackgroundConstraints)
        
        cellBackground.layer.shadowRadius  = 1.5;
        cellBackground.layer.shadowColor   = UIColor.lightGray.cgColor
        cellBackground.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        cellBackground.layer.shadowOpacity = 0.9;
        cellBackground.layer.masksToBounds = false;
        cellBackground.layer.cornerRadius = 8
    }
}

//MARK: - Set Cell Content
extension AdminSettingsKBACell {
    private func setContent() {
        
        kbaIcon = UIImageView()
        kbaIcon.translatesAutoresizingMaskIntoConstraints = false
        kbaIcon.contentMode = .redraw
        kbaIcon.image = UIImage(named: "KBA")
        cellBackground.addSubview(kbaIcon)
        
        let kbaiconConstraints = [kbaIcon.leftAnchor.constraint(equalTo: cellBackground.leftAnchor, constant: 10),
                                  kbaIcon.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 5),
                                  kbaIcon.widthAnchor.constraint(equalToConstant: 30),
                                  kbaIcon.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(kbaiconConstraints)
        
        kbaSwitch = UISwitch()
        kbaSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        kbaSwitch.onTintColor = ColorTheme.switchActive
        cellBackground.addSubview(kbaSwitch)
        
        let kbaswitchConstraints = [kbaSwitch.centerYAnchor.constraint(equalTo: kbaIcon.centerYAnchor),
                                    kbaSwitch.rightAnchor.constraint(equalTo: cellBackground.rightAnchor, constant: -5),
                                    kbaSwitch.widthAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(kbaswitchConstraints)
        kbaSwitch.addTarget(self, action: #selector(changekbaStatusAction(_:)), for: .valueChanged)
        
    
        kbaHeading = UILabel()
        kbaHeading.translatesAutoresizingMaskIntoConstraints = false
        kbaHeading.font = UIFont(name: "Helvetica-Bold", size: 18)
        kbaHeading.adjustsFontSizeToFitWidth = true
        kbaHeading.minimumScaleFactor = 0.2
        kbaHeading.text = "Knowledge Based Authentication"
        kbaHeading.textAlignment = .left
        cellBackground.addSubview(kbaHeading)
        
        let kbaheadingConstraints = [kbaHeading.centerYAnchor.constraint(equalTo: kbaIcon.centerYAnchor),
                                     kbaHeading.leftAnchor.constraint(equalTo: kbaIcon.rightAnchor, constant: 5),
                                     kbaHeading.rightAnchor.constraint(equalTo: kbaSwitch.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(kbaheadingConstraints)
        
        kbasubHeading = UILabel()
        kbasubHeading.translatesAutoresizingMaskIntoConstraints = false
        kbasubHeading.numberOfLines = 0
        let _text: String = "ZorroSign has partnered with LexisNexis for an optional (payable) advanced user verification feature. Please contact your ZorroSign Sales Rep or sales@zorrosign.com for more information and to enable this feature."
        let _attributedText = kbasubHeading.attributedText(withString: _text, boldString: ["sales@zorrosign.com"], font: UIFont(name: "Helvetica", size: 17)!, underline: false)
        kbasubHeading.textAlignment = .left
        kbasubHeading.attributedText = _attributedText
        
        cellBackground.addSubview(kbasubHeading)
        
        let kbasubheadingConstraints = [kbasubHeading.leftAnchor.constraint(equalTo: kbaIcon.leftAnchor),
                                        kbasubHeading.topAnchor.constraint(equalTo: kbaHeading.bottomAnchor, constant: 10),
                                        kbasubHeading.rightAnchor.constraint(equalTo: kbaSwitch.rightAnchor),
                                        kbasubHeading.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(kbasubheadingConstraints)
    }
}

extension AdminSettingsKBACell {
    @objc private func changekbaStatusAction(_ sender: UISwitch) {
        
        var kbastatus = setkbaStatus
        
        if sender.isOn {
            kbastatus = 1
        } else {
            kbastatus = 0
        }
        
        kbaStatusCallBack!(kbastatus)
        return
    }
}
