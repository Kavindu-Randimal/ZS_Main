//
//  ZorroNoteView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDynamicNoteView: ZorroTagBaseView {
    
    private var textcontainerView: UIView!
    private var dynamicnotecancelButton: UIButton!
    private var minimizeButton: UIButton!
    private var lockButton: UIButton!
    var dynamictagNumber: UIButton!
    
    private var noteTextview: UITextView!
    private var usernameLabel: UILabel!
    
    var isremoved: Bool = false
    var isminimized: Bool = false
    var islocked: Bool = false
    var tagNumber: Int = 1
    var temptagID: Int = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor =  .clear//UIColor.init(red: 254/255, green: 238/255, blue: 100/255, alpha: 1)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroDynamicNoteView {
    fileprivate func setsubViews() {
        
        self.layer.borderWidth = 0
    
        textcontainerView = UIView()
        textcontainerView.translatesAutoresizingMaskIntoConstraints = false
        textcontainerView.backgroundColor = UIColor.init(red: 254/255, green: 238/255, blue: 100/255, alpha: 1)
        addSubview(textcontainerView)
        
        let textcontainerConstraints = [textcontainerView.leftAnchor.constraint(equalTo: leftAnchor),
                                        textcontainerView.topAnchor.constraint(equalTo: topAnchor),
                                        textcontainerView.rightAnchor.constraint(equalTo: rightAnchor),
                                        textcontainerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(textcontainerConstraints)
        textcontainerView.layer.borderWidth = 0.5
        textcontainerView.layer.borderColor = UIColor.black.cgColor
        
        
        dynamicnotecancelButton = UIButton()
        dynamicnotecancelButton.translatesAutoresizingMaskIntoConstraints = false
        dynamicnotecancelButton.isHidden = true
        dynamicnotecancelButton.setImage(UIImage(named: "doccancel"), for: .normal)
        dynamicnotecancelButton.backgroundColor = .white
        textcontainerView.addSubview(dynamicnotecancelButton)
        
        let dynamicnotecancelbuttonConstraints = [dynamicnotecancelButton.topAnchor.constraint(equalTo: textcontainerView.topAnchor, constant: 2),
                                                  dynamicnotecancelButton.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor, constant: -2),
                                                  dynamicnotecancelButton.widthAnchor.constraint(equalToConstant: 30),
                                                  dynamicnotecancelButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(dynamicnotecancelbuttonConstraints)
        dynamicnotecancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        dynamicnotecancelButton.layer.cornerRadius = 15
        dynamicnotecancelButton.layer.masksToBounds = true
        
        
        minimizeButton = UIButton()
        minimizeButton.translatesAutoresizingMaskIntoConstraints = false
        minimizeButton.isHidden = true
        minimizeButton.backgroundColor = .white
        minimizeButton.setImage(UIImage(named: "docminus"), for: .normal)
        textcontainerView.addSubview(minimizeButton)

        let minimizebuttonConstraints = [minimizeButton.topAnchor.constraint(equalTo: textcontainerView.topAnchor, constant: 2),
                                         minimizeButton.rightAnchor.constraint(equalTo: dynamicnotecancelButton.leftAnchor, constant: -2),
                                         minimizeButton.widthAnchor.constraint(equalToConstant: 30),
                                         minimizeButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(minimizebuttonConstraints)
        minimizeButton.addTarget(self, action: #selector(minimizeAction(_:)), for: .touchUpInside)
        minimizeButton.layer.cornerRadius = 15
        minimizeButton.layer.masksToBounds = true
        
        lockButton = UIButton()
        lockButton.translatesAutoresizingMaskIntoConstraints = false
        lockButton.isHidden = true
        lockButton.backgroundColor = .white
        lockButton.setImage(UIImage(named: "docunlock"), for: .normal)
        textcontainerView.addSubview(lockButton)
        
        let lockbuttonConstraints = [lockButton.topAnchor.constraint(equalTo: textcontainerView.topAnchor, constant: 2),
                                         lockButton.rightAnchor.constraint(equalTo: minimizeButton.leftAnchor, constant: -2),
                                         lockButton.widthAnchor.constraint(equalToConstant: 30),
                                         lockButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(lockbuttonConstraints)
        lockButton.addTarget(self, action: #selector(lockAction(_:)), for: .touchUpInside)
        
        lockButton.layer.cornerRadius = 15
        lockButton.layer.masksToBounds = true
        
        dynamictagNumber = UIButton()
        dynamictagNumber.translatesAutoresizingMaskIntoConstraints = false
        dynamictagNumber.backgroundColor = .red
        dynamictagNumber.setTitleColor(.white, for: .normal)
        addSubview(dynamictagNumber)
        
        let dynamictagNumberConstraints = [dynamictagNumber.leftAnchor.constraint(equalTo: leftAnchor),
                                           dynamictagNumber.topAnchor.constraint(equalTo: topAnchor),
                                           lockButton.widthAnchor.constraint(equalToConstant: 30),
                                           lockButton.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(dynamictagNumberConstraints)
        dynamictagNumber.addTarget(self, action: #selector(tagnumberAction(_:)), for: .touchUpInside)

        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = ""
        usernameLabel.font = UIFont(name: "Helvetica", size: 12)
        usernameLabel.textAlignment = .right
        textcontainerView.addSubview(usernameLabel)

        let usernamelabelconstraints = [usernameLabel.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor),
                                        usernameLabel.bottomAnchor.constraint(equalTo: textcontainerView.bottomAnchor),
                                        usernameLabel.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor, constant: -5)]
        NSLayoutConstraint.activate(usernamelabelconstraints)

        noteTextview = UITextView()
        noteTextview.backgroundColor = .clear
        noteTextview.translatesAutoresizingMaskIntoConstraints = false
        noteTextview.delegate = self
        textcontainerView.addSubview(noteTextview)

        let commenttextviewconstraints = [noteTextview.leftAnchor.constraint(equalTo: textcontainerView.leftAnchor),
                                          noteTextview.topAnchor.constraint(equalTo: textcontainerView.topAnchor, constant: 30),
                                          noteTextview.rightAnchor.constraint(equalTo: textcontainerView.rightAnchor),
                                          noteTextview.bottomAnchor.constraint(equalTo: usernameLabel.topAnchor)]
        NSLayoutConstraint.activate(commenttextviewconstraints)
    }
}

//MARK: Show buttons for new views
extension ZorroDynamicNoteView {
    func showButtons() {
        dynamicnotecancelButton.isHidden = false
        minimizeButton.isHidden = false
        lockButton.isHidden = false
    }
}

//MARK: Set extra data for existing tags
extension ZorroDynamicNoteView {
    func setextraMetaData(purpleextarmetadata: PurpleExtraMetaData, tagnumber: Int, tagtext: String) {
        usernameLabel.text = purpleextarmetadata.addedBy
        dynamictagNumber.setTitle("\(tagnumber)", for: .normal)
        tagNumber = tagnumber
        tagText = tagtext
        noteTextview.text = tagtext
        noteTextview.isSelectable = false
        noteTextview.isEditable = false
    }
}

//MARK: Set addedby for new tags
extension ZorroDynamicNoteView {
    func setdynamicnoteAddedBy(tagnumber: Int) {
        let username = ZorroTempData.sharedInstance.getUserName()
        usernameLabel.text = username
        dynamictagNumber.setTitle("\(tagnumber)", for: .normal)
        tagNumber = tagnumber
        temptagID = tagnumber
    }
}

//MARK: Validate text with TextView delegates
extension ZorroDynamicNoteView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let inputtext = textView.text
        if inputtext == "" {
            iscompleted = false
        } else {
            iscompleted = true
        }
        tagText = inputtext
    }
}

//MARK: cancel Action
extension ZorroDynamicNoteView {
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.setcommonAlert(title: "Remove Note", message: "Do you want to remove this Note", actiontitleOne: "Cancel", actiontitleTwo: "Confirm", addText: false) { (cancel, upload, text) in
                
                if cancel {
                    return
                } else {
                    self.isremoved = true
                    self.isHidden = true
                    SharingManager.sharedInstance.triggernoteRemove(removedItem: self.tagNumber)
                }
            }
        }
    }
}

//MARK: minimize Action
extension ZorroDynamicNoteView {
    @objc fileprivate func minimizeAction(_ sender: UIButton) {
        isminimized = !isminimized
        textcontainerView.isHidden = isminimized
    }
}

//MARK: lock Action
extension ZorroDynamicNoteView {
    @objc fileprivate func lockAction(_ sender: UIButton) {
        islocked = !islocked
        if islocked {
            lockButton.setImage(UIImage(named: "doclock"), for: .normal)
        } else {
            lockButton.setImage(UIImage(named: "docunlock"), for: .normal)
        }
    }
}

//MARK: tag number action
extension ZorroDynamicNoteView {
    @objc fileprivate func tagnumberAction(_ sender: UIButton) {
        if isminimized {
            textcontainerView.isHidden = !isminimized
            isminimized = !isminimized
        }
    }
}
