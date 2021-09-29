//
//  DocumentSignSaveAllProcessUPPRController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 7/31/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class DocumentSignSaveAllProcessUPPRController: UIViewController {
    
    private let greencolor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    private let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    private let darkgray: UIColor = UIColor.init(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
    
    var shouldrejectDocument: Bool?
    private var _reject: Bool = false
    
    private let deviceWidth = UIScreen.main.bounds.width
    private let deviceHeith = UIScreen.main.bounds.height
    private var containerView: UIView!
    private var headerLabel: UILabel!
    private var separatorView: UIView!
    private var footerView: UIView!
    private var cancelButton: UIButton!
    private var confirmButton: UIButton!
    
    private var commenttextView: UITextView!
    
    var saveallCallBack: ((String?, String?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkStatus()
    }
}

//MARK: Check status
extension DocumentSignSaveAllProcessUPPRController {
    private func checkStatus() {
        guard let _shouldReject = shouldrejectDocument else {
            return
        }
        
        _reject = _shouldReject
        setbackgroundContainer()
        setContentUI()
        setfooterViewUI()
        settextViewUI()
        
    }
}

//MARK: Setup Container View
extension DocumentSignSaveAllProcessUPPRController {
    
    private func setbackgroundContainer() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        let _width = deviceWidth - 40
        let _height: CGFloat = 240
        
        let backcontainerConstraints = [containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                        containerView.widthAnchor.constraint(equalToConstant: _width),
                                        containerView.heightAnchor.constraint(equalToConstant: _height)]
        NSLayoutConstraint.activate(backcontainerConstraints)
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 8
        
    }
}

//MARK: Setup Content
extension DocumentSignSaveAllProcessUPPRController {
    private func setContentUI() {
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.minimumScaleFactor = 0.2
        headerLabel.text = "Please Add Comment to Reject"
        
        containerView.addSubview(headerLabel)
        
        let headerlabelConstraints = [headerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                      headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                                      headerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)]
        NSLayoutConstraint.activate(headerlabelConstraints)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        containerView.addSubview(separatorView)
        
        let separatorviewConstrints = [separatorView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                       separatorView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
                                       separatorView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                       separatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(separatorviewConstrints)
    }
}

//MARK: Set text Views
extension DocumentSignSaveAllProcessUPPRController {
    private func settextViewUI() {
        commenttextView = UITextView()
        commenttextView.translatesAutoresizingMaskIntoConstraints = false
        commenttextView.font = UIFont(name: "Helvetica", size: 16)
        
        let commenttextviewConstrints = [commenttextView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                         commenttextView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 20),
                                         commenttextView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                         commenttextView.heightAnchor.constraint(equalToConstant: 100)]
        commenttextView.layer.masksToBounds = true
        commenttextView.layer.cornerRadius = 8
        commenttextView.layer.borderColor = lightgray.cgColor
        commenttextView.layer.borderWidth = 1
        containerView.addSubview(commenttextView)
        NSLayoutConstraint.activate(commenttextviewConstrints)
        
    }
}

//MARK: Set Footer View
extension DocumentSignSaveAllProcessUPPRController {
    private func setfooterViewUI() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(footerView)
        
        let footerviewConstrints = [footerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                    footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                                    footerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                    footerView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(footerviewConstrints)
        
        
        let _buttonWidth = (deviceWidth - 40)/2 - 20
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(greencolor, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        
        footerView.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 10),
                                       cancelButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       cancelButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.shadowRadius = 1.0
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.shadowColor  = UIColor.lightGray.cgColor
        cancelButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.masksToBounds = false
        cancelButton.layer.cornerRadius = 5
        
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        confirmButton = UIButton()
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.backgroundColor = greencolor
        
        footerView.addSubview(confirmButton)
        
        let confirmbuttonConstraints = [confirmButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
                                       confirmButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       confirmButton.widthAnchor.constraint(equalToConstant: _buttonWidth),
                                       confirmButton.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(confirmbuttonConstraints)
        
        confirmButton.layer.shadowRadius = 1.0
        confirmButton.layer.borderColor = greencolor.cgColor
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.shadowColor  = UIColor.lightGray.cgColor
        confirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        confirmButton.layer.shadowOpacity = 0.5
        confirmButton.layer.masksToBounds = false
        confirmButton.layer.cornerRadius = 5
        
        confirmButton.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
}

//MARK: Button Actions
extension DocumentSignSaveAllProcessUPPRController {
    @objc private func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirmAction(_ sender: UIButton) {
        let _commentText = commenttextView.text
        let _passwordText = ""
        saveallCallBack!(_passwordText, _commentText)
        self.dismiss(animated: true, completion: nil)
    }
}
