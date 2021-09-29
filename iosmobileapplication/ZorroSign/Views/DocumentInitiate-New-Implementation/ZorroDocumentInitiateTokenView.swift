//
//  ZorroDocumentInitiateTokenView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateTokenView: ZorroDocumentInitiateBaseView {
    private var tokenimagView: UIImageView!

}

extension ZorroDocumentInitiateTokenView {
    override func setsubViews() {
        setTokenView()
        bringviewstoFront()
        removeResizer()
    }
}

extension ZorroDocumentInitiateTokenView {
    fileprivate func setTokenView() {
        tokenimagView = UIImageView()
        tokenimagView.translatesAutoresizingMaskIntoConstraints = false
        tokenimagView.contentMode = .scaleAspectFit
        tokenimagView.image = UIImage(named: "token_black")
        
        containersubView.addSubview(tokenimagView)
        
        let tokenimageviewConstraints = [tokenimagView.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                         tokenimagView.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                         tokenimagView.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                         tokenimagView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(tokenimageviewConstraints)
    }
}

