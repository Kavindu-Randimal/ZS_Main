//
//  AttachmentSettingsController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/23/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AttachmentSettingsController: UIViewController {
    
    private let greencolor: UIColor = ColorTheme.btnBG
    
    private var footerview: UIView!
    private var okbutton: UIButton!
    private var cancelButton: UIButton!
    
    private var defaultdocumentCount: Int = 1
    
    private var backgroundContainer: UIView!
    private var headerTitle: UILabel!
    private var numberofAttachment: UIView!
    private var numberofAttachmentDivider: UIView!
    private var numberofattachmenttitleLabel: UILabel!
    private var numberofattachmentLabel: UILabel!
    private var numberStepper: UIStepper!
    private var requiredAttachment: UIView!
    private var requiredattachmentTitleLabel: UILabel!
    private var requiredattachmentText: UITextView!
    
    var attachmentokCallBack: ((Int, String) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setbackgroundContainer()
        setFooter()
        setheaderTitle()
        setnumberofAttachment()
        setrequiredAttachment()
    }
}

extension AttachmentSettingsController {
    fileprivate func setbackgroundContainer() {
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = .white
        view.addSubview(backgroundContainer)
        
        let backgroundcontainerConstraints = [backgroundContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                                              backgroundContainer.topAnchor.constraint(equalTo: view.topAnchor),
                                              backgroundContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                                              backgroundContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(backgroundcontainerConstraints)
    }
}

extension AttachmentSettingsController {
    fileprivate func setFooter() {
        footerview = UIView()
        footerview.translatesAutoresizingMaskIntoConstraints = false
        footerview.backgroundColor = .white
        
        backgroundContainer.addSubview(footerview)
        
        let footerviewConstraints = [footerview.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor),
                                     footerview.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor),
                                     footerview.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -10),
                                     footerview.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(footerviewConstraints)
        
        okbutton = UIButton()
        okbutton.translatesAutoresizingMaskIntoConstraints = false
        okbutton.setTitle("OK", for: .normal)
        okbutton.setTitleColor(.white, for: .normal)
        okbutton.backgroundColor = greencolor
        footerview.addSubview(okbutton)
        
        let okbuttonconstraints = [okbutton.centerYAnchor.constraint(equalTo: footerview.centerYAnchor),
                                   okbutton.rightAnchor.constraint(equalTo: footerview.rightAnchor, constant: -5),
                                   okbutton.heightAnchor.constraint(equalToConstant: 35),
                                   okbutton.widthAnchor.constraint(equalToConstant: 80)]
        NSLayoutConstraint.activate(okbuttonconstraints)

        okbutton.layer.masksToBounds = true
        okbutton.layer.cornerRadius = 5
        okbutton.addTarget(self, action: #selector(okAction(_:)), for: .touchUpInside)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(greencolor, for: .normal)
        footerview.addSubview(cancelButton)
        
        let cancelButtonconstraints = [cancelButton.centerYAnchor.constraint(equalTo: footerview.centerYAnchor),
                                   cancelButton.rightAnchor.constraint(equalTo: okbutton.leftAnchor, constant: -5),
                                   cancelButton.heightAnchor.constraint(equalToConstant: 35),
                                   cancelButton.widthAnchor.constraint(equalToConstant:100)]
        NSLayoutConstraint.activate(cancelButtonconstraints)
        
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 5
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
}

extension AttachmentSettingsController {
    @objc fileprivate func okAction(_ sender: UIButton) {
        attachmentokCallBack!(defaultdocumentCount, requiredattachmentText.text)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension AttachmentSettingsController {
    fileprivate func setheaderTitle() {
        headerTitle = UILabel()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.font = UIFont(name: "Helvetica", size: 20)
        headerTitle.textColor = .darkGray
        headerTitle.text = "Attachment Setting(s)"
        backgroundContainer.addSubview(headerTitle)
        
        let headertitleConstraints = [headerTitle.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 5),
                                      headerTitle.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 5),
                                      headerTitle.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -5),
                                      headerTitle.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(headertitleConstraints)
    }
}

extension AttachmentSettingsController {
    fileprivate func setnumberofAttachment() {
        numberofAttachment = UIView()
        numberofAttachment.translatesAutoresizingMaskIntoConstraints = false
        numberofAttachment.backgroundColor = .white
        backgroundContainer.addSubview(numberofAttachment)
        
        let numberofattachmentConstraints = [numberofAttachment.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 5),
                                             numberofAttachment.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 10),
                                             numberofAttachment.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -5),
                                             numberofAttachment.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(numberofattachmentConstraints)
        
        numberofAttachmentDivider = UIView()
        numberofAttachmentDivider.translatesAutoresizingMaskIntoConstraints = false
        numberofAttachmentDivider.backgroundColor = .darkGray
        
        numberofAttachment.addSubview(numberofAttachmentDivider)
        
        let numberofattachmentdividerConstraints = [numberofAttachmentDivider.leftAnchor.constraint(equalTo: numberofAttachment.leftAnchor),
                                                    numberofAttachmentDivider.topAnchor.constraint(equalTo: numberofAttachment.topAnchor),
                                                    numberofAttachmentDivider.rightAnchor.constraint(equalTo: numberofAttachment.rightAnchor),
                                                    numberofAttachmentDivider.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(numberofattachmentdividerConstraints)
        
        numberStepper = UIStepper()
        numberStepper.translatesAutoresizingMaskIntoConstraints = false
        numberStepper.tintColor = greencolor
        numberStepper.minimumValue = 1
        numberStepper.maximumValue = 5
        numberStepper.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        numberofAttachment.addSubview(numberStepper)
        
        let numberstepperConstraints = [numberStepper.centerYAnchor.constraint(equalTo: numberofAttachment.centerYAnchor),
                                        numberStepper.rightAnchor.constraint(equalTo: numberofAttachment.rightAnchor, constant: -5),
                                        numberStepper.heightAnchor.constraint(equalToConstant: 30),
                                        numberStepper.widthAnchor.constraint(equalToConstant: 80)]
        
        NSLayoutConstraint.activate(numberstepperConstraints)
        numberStepper.addTarget(self, action: #selector(stepperChange(_:)), for: .touchUpInside)
        
        numberofattachmentLabel = UILabel()
        numberofattachmentLabel.translatesAutoresizingMaskIntoConstraints = false
        numberofattachmentLabel.text = "\(defaultdocumentCount)"
        numberofAttachment.addSubview(numberofattachmentLabel)
        
        let numberofattachmetnlabelConstraints = [numberofattachmentLabel.centerYAnchor.constraint(equalTo: numberofAttachment.centerYAnchor),
                                                  numberofattachmentLabel.rightAnchor.constraint(equalTo: numberStepper.leftAnchor, constant: -5),
                                                  numberofattachmentLabel.widthAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(numberofattachmetnlabelConstraints)
        
        
        numberofattachmenttitleLabel = UILabel()
        numberofattachmenttitleLabel.translatesAutoresizingMaskIntoConstraints = false
        numberofattachmenttitleLabel.textColor = .darkGray
        numberofattachmenttitleLabel.text = "Document Count"
        
        numberofAttachment.addSubview(numberofattachmenttitleLabel)
        
        let numberofattachmenttitlelabelConstraints = [numberofattachmenttitleLabel.centerYAnchor.constraint(equalTo: numberofAttachment.centerYAnchor),
                                                       numberofattachmenttitleLabel.leftAnchor.constraint(equalTo: numberofAttachment.leftAnchor, constant: 5),
                                                       numberofattachmenttitleLabel.rightAnchor.constraint(equalTo: numberofattachmentLabel.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(numberofattachmenttitlelabelConstraints)
    }
}

extension AttachmentSettingsController {
    @objc fileprivate func stepperChange(_ sender: UIStepper) {
        defaultdocumentCount = Int(sender.value)
        numberofattachmentLabel.text = "\(defaultdocumentCount)"
    }
}

extension AttachmentSettingsController {
    fileprivate func setrequiredAttachment() {
        requiredAttachment = UIView()
        requiredAttachment.translatesAutoresizingMaskIntoConstraints = false
        requiredAttachment.backgroundColor = .white
        backgroundContainer.addSubview(requiredAttachment)
        
        let requiredAttachmentConstraints = [requiredAttachment.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 5),
                                             requiredAttachment.topAnchor.constraint(equalTo: numberofAttachment.bottomAnchor, constant: 10),
                                             requiredAttachment.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -5),
                                             requiredAttachment.bottomAnchor.constraint(equalTo: footerview.topAnchor)]
        NSLayoutConstraint.activate(requiredAttachmentConstraints)
        
        requiredattachmentTitleLabel = UILabel()
        requiredattachmentTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        requiredattachmentTitleLabel.textColor = .darkGray
        requiredattachmentTitleLabel.text = "Required Document(s)"
        
        requiredAttachment.addSubview(requiredattachmentTitleLabel)
        
        let requiredattachmentTitleLabelConstraints = [requiredattachmentTitleLabel.topAnchor.constraint(equalTo: requiredAttachment.topAnchor),
                                                       requiredattachmentTitleLabel.leftAnchor.constraint(equalTo: requiredAttachment.leftAnchor, constant: 5)]
        NSLayoutConstraint.activate(requiredattachmentTitleLabelConstraints)
        
        requiredattachmentText = UITextView()
        requiredattachmentText.translatesAutoresizingMaskIntoConstraints = false
        requiredattachmentText.backgroundColor = .white
        
        requiredAttachment.addSubview(requiredattachmentText)
        
        let requiredattachmenttextConstraints = [requiredattachmentText.leftAnchor.constraint(equalTo: requiredattachmentTitleLabel.rightAnchor, constant: 5),
                                                 requiredattachmentText.rightAnchor.constraint(equalTo: requiredAttachment.rightAnchor),
                                                 requiredattachmentText.topAnchor.constraint(equalTo: requiredAttachment.topAnchor),
                                                 requiredattachmentText.bottomAnchor.constraint(equalTo: requiredAttachment.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(requiredattachmenttextConstraints)
        
        requiredattachmentText.layer.borderColor = UIColor.darkGray.cgColor
        requiredattachmentText.layer.borderWidth = 1
        requiredattachmentText.layer.cornerRadius = 5
    }
}
