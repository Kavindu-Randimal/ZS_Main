//
//  ZorroDocumentInitiateAttachmentView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift

class ZorroDocumentInitiateAttachmentView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var hintimageView: UIImageView!
    private var userattachmenttitleLabel: UILabel!
    private var settingsButton: UIButton!
    
    private let disposebag = DisposeBag()
}

extension ZorroDocumentInitiateAttachmentView {
    override func setsubViews() {
        setuserattachmenttitleLabel()
        bringviewstoFront()
        removeResizer()
        removepanGesture()
    }
}

//MARK: - Set useremail label
extension ZorroDocumentInitiateAttachmentView {
    fileprivate func setuserattachmenttitleLabel() {
        
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        backView.backgroundColor = .clear
        containersubView.addSubview(backView)
        
        let backviewConstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 10),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 5),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(backviewConstraints)
        
        hintimageView = UIImageView()
        hintimageView.translatesAutoresizingMaskIntoConstraints = false
        hintimageView.backgroundColor = .clear
        hintimageView.contentMode = .center
        hintimageView.image = DocumentHelper.sharedInstance.returnTagImage(tagtype: 12)
        backView.addSubview(hintimageView)
        
        let hintimageviewConstraints = [hintimageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                        hintimageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                        hintimageView.widthAnchor.constraint(equalToConstant: 30),
                                        hintimageView.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(hintimageviewConstraints)
        
        
        userattachmenttitleLabel = UILabel()
        userattachmenttitleLabel.translatesAutoresizingMaskIntoConstraints = false
        userattachmenttitleLabel.backgroundColor = .white
        backView.addSubview(userattachmenttitleLabel)
        
        let userattachmenttitleLabelConstraints = [userattachmenttitleLabel.leftAnchor.constraint(equalTo: hintimageView.rightAnchor, constant: 5),
                                           userattachmenttitleLabel.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                           userattachmenttitleLabel.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: -5),
                                           userattachmenttitleLabel.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(userattachmenttitleLabelConstraints)
        
        settingsButton = UIButton()
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.backgroundColor = .clear
        
        backView.addSubview(settingsButton)
        let settingsbuttonConstraints = [settingsButton.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                         settingsButton.topAnchor.constraint(equalTo: backView.topAnchor),
                                         settingsButton.rightAnchor.constraint(equalTo: backView.rightAnchor),
                                         settingsButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor)]
        NSLayoutConstraint.activate(settingsbuttonConstraints)
        
        settingsButton.addTarget(self, action: #selector(attachmentSettings(_:)), for: .touchUpInside)
        
        extrametadata = SaveExtraMetaData(SignatureId: nil, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: attachmentCount, AttachmentDiscription: attachmentDescription,AddedBy: nil, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: nil)
        
        attachmentCreated()
    }
}

extension ZorroDocumentInitiateAttachmentView {
    func setUserAttachment(contacts: [ContactDetailsViewModel]) {
        
        if contacts.count == 1 {
            userattachmenttitleLabel.text = contacts.first?.Name
        } else {
            userattachmenttitleLabel.text = "[Multiple - \(contacts.count)]"
        }
    }
}

extension ZorroDocumentInitiateAttachmentView {
    @objc fileprivate func attachmentSettings(_ sender: UIButton) {
        settingsCallBack?(self, step)
    }
}

extension ZorroDocumentInitiateAttachmentView {
    fileprivate func attachmentCreated() {
        SharingManager.sharedInstance.onattachmentCreate?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
            created in
            self!.settingsCallBack!(self!, self!.step)
        }).disposed(by: self.disposebag)
    }
}
