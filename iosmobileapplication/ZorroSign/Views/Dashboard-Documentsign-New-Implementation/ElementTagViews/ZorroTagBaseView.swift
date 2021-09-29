//
//  ZorroTagBaseView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroTagBaseView: UIView {
    
    var tagtype: Int!
    var tagID: Int!
    var tagName: String!
    var tagText: String!
    var iscompleted: Bool = false
    var commonalertController: UIAlertController!
    var commonkeyboardType: UIKeyboardType = .default
    var attachmentCount: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBorder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroTagBaseView {
    fileprivate func setBorder() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
    }
}

extension ZorroTagBaseView {
    func setcommonAlert(title: String, message: String, actiontitleOne: String?, actiontitleTwo: String, addText: Bool, completion: @escaping(Bool, Bool, String?) -> ()) {
        
        commonalertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        commonalertController.view.tintColor = ColorTheme.alertTint
        
        if addText {
            commonalertController.addTextField { (textfield) in
                textfield.borderStyle = .roundedRect
                textfield.keyboardType = self.commonkeyboardType
            }
        }
        
        if actiontitleOne != nil {
            let actionone = UIAlertAction(title: actiontitleOne, style: .destructive) { (alert) in
                completion(true, false, nil)
            }
            commonalertController.addAction(actionone)
        }
        
        let actiontwo = UIAlertAction(title: actiontitleTwo, style: .cancel) { (alert) in
            if addText {
                guard let commontextField = self.commonalertController.textFields?[0] else { return }
                completion(false, true, commontextField.text)
            } else {
                completion(false, true, nil)
            }
        }
        commonalertController.addAction(actiontwo)
        self.window?.rootViewController?.present(commonalertController, animated: true, completion: nil)
    }
}

