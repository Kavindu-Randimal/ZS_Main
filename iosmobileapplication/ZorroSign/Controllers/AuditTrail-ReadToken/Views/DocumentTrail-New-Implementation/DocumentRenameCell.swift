//
//  DocumentRenameCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 1/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class DocumentRenameCell: UITableViewCell {
    
    private var renameContainer: UIView!
    private var renameLabel: UILabel!
    private var previousnameLabel: UILabel!
    private var relevantstepLabel: UILabel!
    private var changedateLabel: UILabel!

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
        setrenamecellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var renamehistorydetails: RenameDocumentSub? {
        didSet {
            
            if let _ = renamehistorydetails?.documentsetName {
                renameLabel.text = "Document Rename"
            }
            
            if let previousname = renamehistorydetails?.documentsetPreviouseName {
                previousnameLabel.text = "Previous Name: " + previousname
            }
            
            if let releventstep = renamehistorydetails?.renameatStepNo {
                relevantstepLabel.text = "Relevant Step: " + String(releventstep)
            }
            
            if let changedTime = renamehistorydetails?.changedTime {
                changedateLabel.text = "Changed Date: " + changedTime
            }
        }
    }
}

extension DocumentRenameCell {
    private func setrenamecellUI() {
        
        renameContainer = UIView()
        renameContainer.translatesAutoresizingMaskIntoConstraints = false
        renameContainer.backgroundColor = .white
        addSubview(renameContainer)
        
        let renamecontainerConstraints = [renameContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                          renameContainer.topAnchor.constraint(equalTo: topAnchor),
                                          renameContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                          renameContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(renamecontainerConstraints)
        
        renameLabel = UILabel()
        renameLabel.translatesAutoresizingMaskIntoConstraints = false
        renameLabel.textAlignment = .left
        renameLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        renameLabel.text = "Document Rename: "
        
        renameContainer.addSubview(renameLabel)
        
        let renamelabelConstraints = [renameLabel.leftAnchor.constraint(equalTo: renameContainer.leftAnchor),
                                      renameLabel.topAnchor.constraint(equalTo: renameContainer.topAnchor, constant: 10),
                                      renameLabel.rightAnchor.constraint(equalTo: renameContainer.rightAnchor, constant: -2)]
        
        NSLayoutConstraint.activate(renamelabelConstraints)
        
        previousnameLabel = UILabel()
        previousnameLabel.translatesAutoresizingMaskIntoConstraints = false
        previousnameLabel.textAlignment = .left
        previousnameLabel.font = UIFont(name: "Helvetica", size: 16)
        previousnameLabel.text = "Previous Name: "
        
        renameContainer.addSubview(previousnameLabel)
        
        let previousnameLabelConstraints = [previousnameLabel.leftAnchor.constraint(equalTo: renameContainer.leftAnchor),
                                      previousnameLabel.topAnchor.constraint(equalTo: renameLabel.bottomAnchor, constant: 15),
                                      previousnameLabel.rightAnchor.constraint(equalTo: renameContainer.rightAnchor, constant: -2)]
        
        NSLayoutConstraint.activate(previousnameLabelConstraints)
        
        relevantstepLabel = UILabel()
        relevantstepLabel.translatesAutoresizingMaskIntoConstraints = false
        relevantstepLabel.textAlignment = .left
        relevantstepLabel.font = UIFont(name: "Helvetica", size: 16)
        relevantstepLabel.text = "Relevant Step: "
        
        renameContainer.addSubview(relevantstepLabel)
        
        let relevantstepLabelConstraints = [relevantstepLabel.leftAnchor.constraint(equalTo: renameContainer.leftAnchor),
                                      relevantstepLabel.topAnchor.constraint(equalTo: previousnameLabel.bottomAnchor, constant: 10),
                                      relevantstepLabel.rightAnchor.constraint(equalTo: renameContainer.rightAnchor, constant: -2)]
        
        NSLayoutConstraint.activate(relevantstepLabelConstraints)
        
        changedateLabel = UILabel()
        changedateLabel.translatesAutoresizingMaskIntoConstraints = false
        changedateLabel.textAlignment = .left
        changedateLabel.font = UIFont(name: "Helvetica", size: 16)
        changedateLabel.text = "Changed Date: "
        
        renameContainer.addSubview(changedateLabel)
        
        let changedateLabelConstraints = [changedateLabel.leftAnchor.constraint(equalTo: renameContainer.leftAnchor),
                                      changedateLabel.topAnchor.constraint(equalTo: relevantstepLabel.bottomAnchor, constant: 10),
                                      changedateLabel.rightAnchor.constraint(equalTo: renameContainer.rightAnchor),
                                      changedateLabel.bottomAnchor.constraint(equalTo: renameContainer.bottomAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(changedateLabelConstraints)
    }
}
