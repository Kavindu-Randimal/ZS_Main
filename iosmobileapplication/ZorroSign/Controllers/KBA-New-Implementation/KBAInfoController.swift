//
//  KBAInfoController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class KBAInfoController: KBABaseController {
    
    private var isSSN: Bool = false
    
    private var backgroundContainer: UIView!
    private var headingLabel: UILabel!
    private var infoLable: UILabel!
    private var footerView: UIView!
    private var separatorView: UIView!
    private var cancelButton: UIButton!
    private var continueButton: UIButton!
    
    var infoCallBack: ((Bool) -> ())?
    
    init(isssn: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.isSSN = isssn
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setBackgroundView()
        setHeadingLabel()
        setFooterView()
        setInfoLabel()
    }
}

//MARK: - Setup Backgrond View

extension KBAInfoController {
    private func setBackgroundView() {
        
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = .white
        view.addSubview(backgroundContainer)
        
        var _containerWidth: CGFloat = deviceWidth - 40
        var _containerHeight: CGFloat = deviceHeight/2
        
        if isSSN {
            _containerHeight = deviceHeight/2 - 60
        }
        
        if deviceName == .pad {
            _containerWidth = deviceWidth/2 + 100
            _containerHeight = deviceHeight/2 - 200
            
            if isSSN {
                _containerHeight = deviceHeight/2 - 300
            }
        }
        
        let backgroundcontainerConstraints = [backgroundContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                                              backgroundContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                                              backgroundContainer.widthAnchor.constraint(equalToConstant: _containerWidth),
                                              backgroundContainer.heightAnchor.constraint(equalToConstant: _containerHeight)]
        NSLayoutConstraint.activate(backgroundcontainerConstraints)
        
        backgroundContainer.layer.masksToBounds = false
        backgroundContainer.layer.cornerRadius = 8
    }
}

//MARK: - Setup Footer View
extension KBAInfoController {
    private func setFooterView() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        backgroundContainer.addSubview(footerView)
        
        let footerViewConstraints = [footerView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 1),
                                              footerView.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -1),
                                              footerView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -1),
                                              footerView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(footerViewConstraints)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = lightgray
        footerView.addSubview(separatorView)
        
        let separatorviewConstraints = [separatorView.leftAnchor.constraint(equalTo: footerView.leftAnchor),
                                        separatorView.topAnchor.constraint(equalTo: footerView.topAnchor),
                                        separatorView.rightAnchor.constraint(equalTo: footerView.rightAnchor),
                                        separatorView.heightAnchor.constraint(equalToConstant: 1)]
        
        NSLayoutConstraint.activate(separatorviewConstraints)
        
        
        var _buttonwidth = (deviceWidth - 80)/2
        
        if deviceName == .pad {
            _buttonwidth = (deviceWidth/2 + 60)/2
        }
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .white
        cancelButton.setTitleColor(greencolor, for: .normal)
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.tag = 0
        
        footerView.addSubview(cancelButton)
        
        let cancelbuttonConstraints = [cancelButton.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 10),
                                       cancelButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       cancelButton.widthAnchor.constraint(equalToConstant: _buttonwidth),
                                       cancelButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 8
        
        cancelButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        
        continueButton = UIButton()
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.backgroundColor = greencolor
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.setTitle("CONTINUE", for: .normal)
        continueButton.tag = 1
        
        footerView.addSubview(continueButton)
        
        let continueButtonConstraints = [continueButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
                                       continueButton.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
                                       continueButton.widthAnchor.constraint(equalToConstant: _buttonwidth),
                                       continueButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(continueButtonConstraints)
        
        continueButton.layer.masksToBounds = true
        continueButton.layer.cornerRadius = 8
        
        continueButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Setup Heading Label
extension KBAInfoController {
    private func setHeadingLabel() {
        
        headingLabel = UILabel()
        headingLabel.translatesAutoresizingMaskIntoConstraints = false
        headingLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        headingLabel.textAlignment = .left
        headingLabel.numberOfLines = 2
        headingLabel.adjustsFontSizeToFitWidth = true
        headingLabel.minimumScaleFactor = 0.2
        headingLabel.text = "Knowledge Based Authentication for User Verification"
    
        backgroundContainer.addSubview(headingLabel)
        
        let headinglabelConstraints = [headingLabel.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                       headingLabel.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 10),
                                       headingLabel.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(headinglabelConstraints)
    }
}

//MARK: - Setup Info Label
extension KBAInfoController {
    private func setInfoLabel() {
        
        infoLable = UILabel()
        infoLable.translatesAutoresizingMaskIntoConstraints = false
        infoLable.font = UIFont(name: "Helvetica", size: 18)
        infoLable.textAlignment = .left
        infoLable.numberOfLines = 0
        
        var _infoText = "KBA verification has been activated. Your SSN is required to complete this secure workflow. Please ensure you enter your SSN correctly, as you cannot update it once submitted.\n\nYou have 4 minutes and 30 seconds to correctly answer all KBA questions. If you fail to answer the KBA questions correctly, the document will be canceled."
        
        if isSSN {
            _infoText = "KBA verification has been activated.\n\nYou have 4 minutes and 30 seconds to correctly answer all KBA questions. If you fail to answer the KBA questions correctly, the document will be canceled."
        }
        
        infoLable.text = _infoText
        
        backgroundContainer.addSubview(infoLable)
        
        let infoLableConstraints = [infoLable.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: 10),
                                       infoLable.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 10),
                                       infoLable.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(infoLableConstraints)
    }
}

extension KBAInfoController {
    @objc private func buttonAction(_ sender: UIButton) {
        let tag = sender.tag
        
        switch tag {
        case 1:
            infoCallBack!(true)
            self.dismiss(animated: true, completion: nil)
            return
        default:
            infoCallBack!(false)
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
}
