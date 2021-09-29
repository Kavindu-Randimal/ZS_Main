//
//  DocumentThumnailCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PDFKit

class DocumentThumbnailCell: UICollectionViewCell {
    
    private var containerView: UIView!
    private var thumbnailimageView: UIImageView!
    private var pageNumber: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setcellSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DocumentThumbnailCell {
    func setThumbnail(pdfdoc: PDFDocument, index: Int) {
        if let page = pdfdoc.page(at: index) {
            thumbnailimageView.image = page.thumbnail(of: CGSize(width: contentView.frame.size.width, height: contentView.frame.size.height), for: .artBox)
        }
        pageNumber.text = "\(index+1)"
    }
}

extension DocumentThumbnailCell {
    fileprivate func setcellSubViews() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        addSubview(containerView)
        let containerviewConstrints = [containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 2),
                                       containerView.topAnchor.constraint(equalTo: topAnchor, constant: 2),
                                       containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -4),
                                       containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2)]
        NSLayoutConstraint.activate(containerviewConstrints)
        
        containerView.layer.borderColor = UIColor.black.cgColor
        containerView.layer.borderWidth = 0.5
        
        pageNumber = UILabel()
        pageNumber.translatesAutoresizingMaskIntoConstraints = false
        pageNumber.backgroundColor = .white
        pageNumber.font = UIFont(name: "Helvetica", size: 12)
        pageNumber.textAlignment = .center
        pageNumber.textColor = ColorTheme.lblBody
        containerView.addSubview(pageNumber)
        
        let pagenumberConstraints = [pageNumber.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                                     pageNumber.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2),
                                     pageNumber.widthAnchor.constraint(equalToConstant: 20),
                                     pageNumber.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(pagenumberConstraints)
        
        pageNumber.layer.cornerRadius = 10
        pageNumber.layer.masksToBounds = true
        pageNumber.layer.borderWidth = 0.5
        pageNumber.layer.borderColor = ColorTheme.lblBody.cgColor
        
        thumbnailimageView = UIImageView()
        thumbnailimageView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailimageView.backgroundColor = .white
        thumbnailimageView.contentMode = .scaleAspectFit
        containerView.addSubview(thumbnailimageView)
        
        let thumbnailimageviewConstraints = [thumbnailimageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                             thumbnailimageView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                             thumbnailimageView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                             thumbnailimageView.bottomAnchor.constraint(equalTo: pageNumber.topAnchor)]
        NSLayoutConstraint.activate(thumbnailimageviewConstraints)
    }
}
