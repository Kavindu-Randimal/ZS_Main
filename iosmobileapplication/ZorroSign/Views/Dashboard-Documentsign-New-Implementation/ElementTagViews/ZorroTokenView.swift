//
//  ZorroTokenView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroTokenView: ZorroTagBaseView {

    private var imageView: UIImageView!
    private var setTokenButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ZorroTokenView {
    fileprivate func setsubViews() {
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.6)
        addSubview(imageView)
        
        let imageviewConstraints = [imageView.leftAnchor.constraint(equalTo: leftAnchor),
                                    imageView.topAnchor.constraint(equalTo: topAnchor),
                                    imageView.rightAnchor.constraint(equalTo: rightAnchor),
                                    imageView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(imageviewConstraints)
        
        setTokenButton = UIButton()
        setTokenButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(setTokenButton)
        
        let buttonConstraints = [setTokenButton.leftAnchor.constraint(equalTo: leftAnchor),
                                 setTokenButton.topAnchor.constraint(equalTo: topAnchor),
                                 setTokenButton.rightAnchor.constraint(equalTo: rightAnchor),
                                 setTokenButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(buttonConstraints)
        setTokenButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 2
    }
}

extension ZorroTokenView {
    func setelementTag() {
        imageView.tag = tagID
        setTokenButton.tag = tagID
        setTokenButton.setTitle("\(tagName!)", for: .normal)
        setTokenButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        setTokenButton.setTitleColor(.white, for: .normal)
    }
}

extension ZorroTokenView {
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        print("Button Tag : \(sender.tag)")
        iscompleted = true
        tagText = "Token token"
    }
}

