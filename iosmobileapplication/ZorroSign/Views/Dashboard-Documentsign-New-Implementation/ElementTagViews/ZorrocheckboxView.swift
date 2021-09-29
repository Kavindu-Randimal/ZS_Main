//
//  ZorrocheckboxView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorrocheckboxView: ZorroTagBaseView {
    
    private var checkbutton: UIButton!
    var ischecked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorrocheckboxView {
    fileprivate func setsubViews() {
        iscompleted = true
        checkbutton = UIButton()
        checkbutton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(checkbutton)
        
        let checkbuttonconstraints = [checkbutton.leftAnchor.constraint(equalTo: leftAnchor),
                                      checkbutton.topAnchor.constraint(equalTo: topAnchor),
                                      checkbutton.rightAnchor.constraint(equalTo: rightAnchor),
                                      checkbutton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(checkbuttonconstraints)
        checkbutton.addTarget(self, action: #selector(checkboxAction(_:)), for: .touchUpInside)
    }
}

//MARK: Set properties
extension ZorrocheckboxView {
    func setProperties(autosaved: AutoSavedData?) {
        checkbutton.tag = tagID
        
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 13 && tagdetail.tagID == tagID {
                        if let apply = tagdetail.apply {
                            if apply {
                                if tagdetail.checked! {
                                    checkbutton.setImage(UIImage(named: "checkbox_sel_black"), for: .normal)
                                } else {
                                    checkbutton.setImage(UIImage(named: ""), for: .normal)
                                }
                                ischecked = !ischecked
                                iscompleted = true
                                tagText = ""
                            }
                        }
                    }
                }
            }
        }
    }
}

//MARK: valiate checkbox
extension ZorrocheckboxView {
    @objc fileprivate func checkboxAction(_ sender: UIButton) {
        
        ischecked = !ischecked
        if ischecked {
            checkbutton.setImage(UIImage(named: "checkbox_sel_black"), for: .normal)
        } else {
            checkbutton.setImage(UIImage(named: ""), for: .normal)
        }
        
        tagText = ""
    }
}


