//
//  DocumentSignElementCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentSignElementCell: UITableViewCell {
    
    private var elementIcon: UIImageView!
    private var elementName: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    var elementIndex: Int! {
        didSet {
            switch elementIndex {
            case 0:
                elementName.text = "\(DocumentTagType.Signature)"
                isUserInteractionEnabled = false
                isHidden = true
            case 1:
                elementName.text = "\(DocumentTagType.Intials)"
                isUserInteractionEnabled = false
                isHidden = true
            case 2:
                elementName.text = "\(DocumentTagType.Stamp)"
                isUserInteractionEnabled = false
                isHidden = true
            case 3:
                elementName.text = "\(DocumentTagType.TextInput)"
                isUserInteractionEnabled = false
                isHidden = true
            case 4:
                elementName.text = "\(DocumentTagType.Date)"
                isUserInteractionEnabled = false
                isHidden = true
            case 5:
                elementName.text = "\(DocumentTagType.Title)"
                isUserInteractionEnabled = false
                isHidden = true
            case 6:
                elementName.text = "\(DocumentTagType.Token)"
                isUserInteractionEnabled = false
                isHidden = true
            case 7:
                elementName.text = "\(DocumentTagType.Comment)"
                isUserInteractionEnabled = false
                isHidden = true
            case 8:
                elementName.text = "Note"
                isUserInteractionEnabled = true
                elementIcon.image = UIImage(named: "noteicon")
            case 9:
                elementName.text = "\(DocumentTagType.Cc)"
                isUserInteractionEnabled = false
                isHidden = true
            case 10:
                elementName.text = "\(DocumentTagType.Initiate)"
                isUserInteractionEnabled = false
                isHidden = true
            case 11:
                elementName.text = "\(DocumentTagType.Review)"
                isUserInteractionEnabled = false
                isHidden = true
            case 12:
                elementName.text = "\(DocumentTagType.Attachment)"
                isUserInteractionEnabled = false
                isHidden = true
            case 13:
                elementName.text = "\(DocumentTagType.Checkbox)"
                isUserInteractionEnabled = false
                isHidden = true
            case 14:
                elementName.text = "Editable Text Box"
                isUserInteractionEnabled = true
                elementIcon.image = UIImage(named: "texticon")
            case 15:
                elementName.text = "\(DocumentTagType.User)"
                isUserInteractionEnabled = false
                isHidden = true
            case 16:
                elementName.text = "\(DocumentTagType.userName)"
                isUserInteractionEnabled = false
                isHidden = true
            case 17:
                elementName.text = "\(DocumentTagType.userEmail)"
                isUserInteractionEnabled = false
                isHidden = true
            case 18:
                elementName.text = "\(DocumentTagType.userCompany)"
                isUserInteractionEnabled = false
                isHidden = true
            case 19:
                elementName.text = "\(DocumentTagType.userTitle)"
                isUserInteractionEnabled = false
                isHidden = true
            case 20:
                elementName.text = "\(DocumentTagType.userPhone)"
                isUserInteractionEnabled = false
                isHidden = true
            default:
                elementName.text = ""
            }
        }
    }
}

extension DocumentSignElementCell {
    
    fileprivate func setsubViews() {
        elementIcon = UIImageView()
        elementIcon.translatesAutoresizingMaskIntoConstraints = false
        elementIcon.contentMode = .scaleAspectFit
        elementIcon.backgroundColor = .clear
        addSubview(elementIcon)
        
        let elementiconConstraints = [elementIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      elementIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                      elementIcon.widthAnchor.constraint(equalToConstant: 40),
                                      elementIcon.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(elementiconConstraints)
        
        elementName = UILabel()
        elementName.translatesAutoresizingMaskIntoConstraints = false
        elementName.textAlignment = .left
        elementName.textColor = ColorTheme.lblBody
        addSubview(elementName)
        
        let elementnameConstraints = [elementName.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      elementName.leftAnchor.constraint(equalTo: elementIcon.rightAnchor, constant: 20)]
        NSLayoutConstraint.activate(elementnameConstraints)
    }
    
}
