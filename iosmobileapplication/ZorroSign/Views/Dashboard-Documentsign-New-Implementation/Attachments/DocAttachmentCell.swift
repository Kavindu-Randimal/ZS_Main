//
//  DocAttachmentCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocAttachmentCell: UITableViewCell {
    
    var attachmentIcon: UIImageView!
    var attachmentName: UILabel!
    var deleteAttachmentButton: UIButton!
    var cellCallback: ((Int) -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
         setdocattachmentcellUI()
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
    
    var buttonIndex: Int! {
        didSet {
            deleteAttachmentButton.tag = buttonIndex
        }
    }
    
    var docattachment: DocAttachments! {
        didSet {
            attachmentName.text = "\(docattachment.Name!)"
            
            if docattachment.IsDeletable! {
                deleteAttachmentButton.isHidden = false
            } else {
                deleteAttachmentButton.isHidden = true
            }
        }
    }
}

extension DocAttachmentCell {
    fileprivate func setdocattachmentcellUI() {
        
        attachmentIcon = UIImageView()
        attachmentIcon.translatesAutoresizingMaskIntoConstraints = false
        attachmentIcon.backgroundColor = .white
        attachmentIcon.image = UIImage.fontAwesomeIcon(name: .file, style: .light, textColor: .black, size: CGSize(width: 30, height: 30))
        addSubview(attachmentIcon)
        
        let attachmenticonConstraints = [attachmentIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
                                         attachmentIcon.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                         attachmentIcon.widthAnchor.constraint(equalToConstant: 30),
                                         attachmentIcon.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(attachmenticonConstraints)
        
        deleteAttachmentButton = UIButton()
        deleteAttachmentButton.translatesAutoresizingMaskIntoConstraints = false
        deleteAttachmentButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 16, style: .solid)
        deleteAttachmentButton.setTitle(String.fontAwesomeIcon(name: .timesCircle), for: .normal)
        deleteAttachmentButton.setTitleColor(.black, for: .normal)
        addSubview(deleteAttachmentButton)
        
        let deletebuttonConstraints = [deleteAttachmentButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                                       deleteAttachmentButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                       deleteAttachmentButton.widthAnchor.constraint(equalToConstant: 20),
                                       deleteAttachmentButton.heightAnchor.constraint(equalToConstant: 20)]
        
        NSLayoutConstraint.activate(deletebuttonConstraints)
        deleteAttachmentButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        
        attachmentName = UILabel()
        attachmentName.translatesAutoresizingMaskIntoConstraints = false
        attachmentName.textAlignment = .left
        attachmentName.text = "Attachment"
        addSubview(attachmentName)
        
        let attachmentnameConstraints = [attachmentName.leftAnchor.constraint(equalTo: attachmentIcon.rightAnchor, constant: 5),
                                         attachmentName.topAnchor.constraint(equalTo: topAnchor),
                                         attachmentName.rightAnchor.constraint(equalTo: deleteAttachmentButton.leftAnchor),
                                         attachmentName.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(attachmentnameConstraints)
    }
}

extension DocAttachmentCell {
    @objc fileprivate func deleteAction(_ sender: UIButton) {
        print("working fine sender : \(sender)")
        cellCallback!(sender.tag)
    }
}
