//
//  ZorroDocumentinitiateDynamicNoteView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentinitiateDynamicNoteView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var usernameLabel: UILabel!
    var textarea: UITextView!
    private var stepButton: UIButton!
}

extension ZorroDocumentinitiateDynamicNoteView {
    override func setsubViews() {
        setbackgroundView()
        setusernameView()
        settextView()
        showhiddenButtons()
        overrideStepNuberUI()
        bringviewstoFront()
    }
}

extension ZorroDocumentinitiateDynamicNoteView {
    fileprivate func setbackgroundView() {
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .yellow
        containersubView.addSubview(backView)
        
        let backviewconstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 30),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(backviewconstraints)
    }
}

extension ZorroDocumentinitiateDynamicNoteView {
    func setstepButton(stepnum: Int) {
        containersubView.backgroundColor = .yellow
        stepnumberCircleLabel.isHidden = true
        stepButton = UIButton()
        stepButton.translatesAutoresizingMaskIntoConstraints = false
        stepButton.backgroundColor = .red
        stepButton.setTitle("\(stepnum)", for: .normal)
        stepButton.setTitleColor(.white, for: .normal)
        stepButton.titleLabel?.textAlignment = .center
        self.addSubview(stepButton)
        
        let stepbuttonConstriants = [stepButton.leftAnchor.constraint(equalTo: leftAnchor),
                                     stepButton.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                     stepButton.widthAnchor.constraint(equalToConstant: 30),
                                     stepButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(stepbuttonConstriants)
        stepButton.addTarget(self, action: #selector(stepnumbertapAction(_:)), for: .touchUpInside)
        self.bringSubviewToFront(stepButton)
    }
}

extension ZorroDocumentinitiateDynamicNoteView {
    fileprivate func setusernameView() {
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .right
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.2
        let username = ZorroTempData.sharedInstance.getUserName()
        usernameLabel.text = "Added by : " + username
        backView.addSubview(usernameLabel)
        
        let usernamelabelConstraints = [usernameLabel.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        usernameLabel.rightAnchor.constraint(equalTo: backView.rightAnchor),
                                        usernameLabel.bottomAnchor.constraint(equalTo: backView.bottomAnchor),
                                        usernameLabel.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(usernamelabelConstraints)
    }
}

extension ZorroDocumentinitiateDynamicNoteView {
    fileprivate func settextView() {
        
        textarea = UITextView()
        textarea.translatesAutoresizingMaskIntoConstraints = false
        textarea.backgroundColor = .yellow
        textarea.font = UIFont(name: "Helvetica", size: 15)
        backView.addSubview(textarea)
        
        let textareaConstraints = [textarea.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                   textarea.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor),
                                   textarea.rightAnchor.constraint(equalTo: backView.rightAnchor, constant: -10),
                                   textarea.topAnchor.constraint(equalTo: backView.topAnchor, constant: 10)]
        
        NSLayoutConstraint.activate(textareaConstraints)
        setdynamicnoteExtraMetadata()
    }
}

extension ZorroDocumentinitiateDynamicNoteView {
    fileprivate func overrideStepNuberUI() {
        stepnumberCircleLabel.layer.cornerRadius = 0
    }
}

//MARK: set dymaic tex extra metadata
extension ZorroDocumentinitiateDynamicNoteView {
    fileprivate func setdynamicnoteExtraMetadata() {
        let username = ZorroTempData.sharedInstance.getUserName()
        extrametadata = SaveExtraMetaData(SignatureId: nil, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: nil
            , AttachmentDiscription: nil, AddedBy: username, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: lock)
    }
}

//MARK: - Button Actions
extension ZorroDocumentinitiateDynamicNoteView {
    override func lockAction(_ sender: UIButton) {
        lock = !lock
        lock ? (lockbuttonCircle.setImage(UIImage(named: "doclock"), for: .normal)) : (lockbuttonCircle.setImage(UIImage(named: "docunlock"), for: .normal))
    }
    
    override func minimizeAction(_ sender: UIButton) {
        hide = !hide
        hideshowviewforDynamicnote(hideshow: hide)
    }
}

//MARK: - Tap gesture for stepnumber
extension ZorroDocumentinitiateDynamicNoteView {
    @objc fileprivate func stepnumbertapAction(_ sender: UIButton) {
        hideshowviewforDynamicnote(hideshow: false)
    }
}


