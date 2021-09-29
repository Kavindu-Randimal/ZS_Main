//
//  DocumentInitiateSelectFileCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocumentInitiateSelectFileCell: UITableViewCell {
    
    private var filecontainer: UIView!
    private var fileimage: UIImageView!
    private var filename: UILabel!
    private var cancelbutton: UIButton!
    var removeindexat: ((Int) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setcellContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var documentinitiateselectfile: DocumentinitiateSelectFile! {
        didSet {
            filename.text = documentinitiateselectfile.filename
        }
    }
    
    var buttonindex: Int! {
        didSet {
            cancelbutton.tag = buttonindex
        }
    }
}

extension DocumentInitiateSelectFileCell {
    fileprivate func setcellContent() {
        filecontainer = UIView()
        filecontainer.translatesAutoresizingMaskIntoConstraints = false
        filecontainer.backgroundColor = .white
        addSubview(filecontainer)
        
        let filecontainerConstraints = [filecontainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                        filecontainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        filecontainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                        filecontainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant:  -5)]
        
        NSLayoutConstraint.activate(filecontainerConstraints)
        
        filecontainer.layer.shadowRadius = 1.5;
        filecontainer.layer.shadowColor   = UIColor.lightGray.cgColor
        filecontainer.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        filecontainer.layer.shadowOpacity = 0.9;
        filecontainer.layer.masksToBounds = false;
        filecontainer.layer.cornerRadius = 8
        
        fileimage = UIImageView()
        fileimage.translatesAutoresizingMaskIntoConstraints = false
        fileimage.backgroundColor = .white
        fileimage.image = UIImage.fontAwesomeIcon(name: .file, style: .light, textColor: .black, size: CGSize(width: 30, height: 35))
        fileimage.contentMode = .scaleAspectFit
        filecontainer.addSubview(fileimage)
        
        let fileimageConstraints = [fileimage.leftAnchor.constraint(equalTo: filecontainer.leftAnchor, constant: 5),
                                    fileimage.centerYAnchor.constraint(equalTo: filecontainer.centerYAnchor),
                                    fileimage.heightAnchor.constraint(equalToConstant: 35),
                                    fileimage.widthAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(fileimageConstraints)
        
        cancelbutton = UIButton()
        cancelbutton.translatesAutoresizingMaskIntoConstraints = false
        cancelbutton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        cancelbutton.setTitle(String.fontAwesomeIcon(name: .times), for: .normal)
        cancelbutton.setTitleColor(.lightGray, for: .normal)
        filecontainer.addSubview(cancelbutton)
        
        let filecancelConstraints = [cancelbutton.rightAnchor.constraint(equalTo: filecontainer.rightAnchor, constant: -5),
                                    cancelbutton.centerYAnchor.constraint(equalTo: filecontainer.centerYAnchor),
                                    cancelbutton.heightAnchor.constraint(equalToConstant: 20),
                                    cancelbutton.widthAnchor.constraint(equalToConstant: 20)]
        
        NSLayoutConstraint.activate(filecancelConstraints)
        cancelbutton.addTarget(self, action: #selector(removeFile(_:)), for: .touchUpInside)
        
        filename = UILabel()
        filename.translatesAutoresizingMaskIntoConstraints = false
        filename.text = "example.pdf"
        filename.textColor = .lightGray
        filecontainer.addSubview(filename)
        
        let filenameConstraints = [filename.leftAnchor.constraint(equalTo: fileimage.rightAnchor, constant: 10),
                                   filename.centerYAnchor.constraint(equalTo: filecontainer.centerYAnchor),
                                   filename.rightAnchor.constraint(equalTo: cancelbutton.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(filenameConstraints)
        
    }
}

extension DocumentInitiateSelectFileCell {
    @objc fileprivate func removeFile(_ sender: UIButton) {
        removeindexat!(sender.tag)
    }
}
