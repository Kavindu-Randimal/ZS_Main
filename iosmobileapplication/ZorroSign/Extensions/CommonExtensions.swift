//
//  CommonExtensions.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

//MARK: - Change image color

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

//MARK: -  Change the color of barbutton images

extension UIImage {
    func tabBarImageWithCustomTint(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(CGBlendMode(rawValue: 1)!)
        let rect: CGRect = CGRect(x: 0, y: 0, width:  self.size.width, height: self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        context.fill(rect)
        var newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        newImage = newImage.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        return newImage
    }
}

//MARK: - UILabel

extension UILabel {

    func attributedText(withString string: String, boldString: [String], font: UIFont, underline: Bool) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                     attributes: [NSAttributedString.Key.font: font])
        
        var  boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize), NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        if !underline {
            boldFontAttribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)]
        }
        
        for _text in boldString {
            let range = (string as NSString).range(of: _text)
            attributedString.addAttributes(boldFontAttribute, range: range)
        }
    
        return attributedString
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

//extension UIView {
//    func addShadowAllSide(radius: CGFloat = 2.0, color: UIColor = .lightGray) {
//        self.layer.shadowColor = color.cgColor
//        self.layer.shadowOffset = .zero
//        self.layer.shadowRadius = radius
//        self.layer.shadowOpacity = 1
//        self.layer.shouldRasterize = false
//        self.layer.masksToBounds = false
//    }
//}
