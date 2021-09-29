//
//  IconButton.swift
//  ZorroSign
//
//  Created by Apple on 09/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

@IBDesignable
class IconButton: AppButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBInspectable var leftIcon: UIImage? {
        didSet {
            setAttributedTitle()
        }
    }
    
    @IBInspectable var rightIcon: UIImage? {
        didSet {
            setAttributedTitle()
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setAttributedTitle()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributedTitle()
    }
    
    private func setAttributedTitle() {
        var attributedTitle = NSMutableAttributedString()
        
        /* Attaching first image */
        if let leftImg = leftIcon {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = leftImg
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            
            if let title = self.currentTitle {
                mutableAttributedString.append(NSAttributedString(string: title))
            }
            attributedTitle = mutableAttributedString
        }
        
        /* Attaching second image */
        if let rightImg = rightIcon {
            let leftAttachment = NSTextAttachment(data: nil, ofType: nil)
            leftAttachment.image = rightImg
            let attributedString = NSAttributedString(attachment: leftAttachment)
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
            attributedTitle.append(mutableAttributedString)
        }
        
        /* Finally, lets have that two-imaged button! */
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}
