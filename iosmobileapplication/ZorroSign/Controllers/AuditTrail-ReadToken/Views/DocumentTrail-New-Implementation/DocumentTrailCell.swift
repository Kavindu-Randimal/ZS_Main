//
//  DocumentTrailCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/25/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentTrailCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// ---------------------------------- MARK: Document Trails Start Cell ---------------------------------- //
class DocumentTrailStartCell: UITableViewCell {
    
    private var topstroke: UIView!
    private var bottomstroke: UIView!
    private var userimageView: CachedImageView!
    private var username: UILabel!
    private var email: UILabel!
    private var stepNo: UILabel!
    private var received: UILabel!
    private var lefttext: UILabel!
    private var righttext: UILabel!
    private var circle: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setstartcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = ""
        email.text = ""
        email.isHidden = false
        righttext.text = ""
    }
    
    var chainofsub: ChainofCustodySub! {
        didSet {
            userimageView.layer.borderColor = chainofsub.assignedColor?.cgColor
            let istoken = chainofsub.token
            if !istoken! {
                if chainofsub.isfirstStep {
                    topstroke.backgroundColor = UIColor(hexString: "#ffffff")
                    bottomstroke.backgroundColor = chainofsub.assignedColor
                } else {
                    topstroke.backgroundColor = chainofsub.assignedColor
                    bottomstroke.backgroundColor = chainofsub.assignedColor
                }
                
                username.text = chainofsub.userName
                if let _email = chainofsub.userEmail {
                    email.text = _email
                    email.isHidden = false
                } else {
                    email.isHidden = true
                }
                
                if chainofsub.isfinalStep {
                    stepNo.text = chainofsub.leftData + " (End)"
                } else {
                    stepNo.text = chainofsub.leftData
                }
                
                if chainofsub.userImage != "https://s3.amazonaws.com/zfpi/" {
                    userimageView.loadImage(urlString: chainofsub.userImage!)
                } else {
                    userimageView.loadImage(urlString: "https://s3.amazonaws.com/zfpi/DefaultProfileSmall.jpg")
                }
                
                userimageView.contentMode = .scaleAspectFit
                circle.isHidden = true
                                
            } else {
                if chainofsub.isfinalStep && chainofsub.contractversion == "0" {
                    topstroke.backgroundColor = chainofsub.assignedColor
                    bottomstroke.backgroundColor = UIColor(hexString: "#ffffff")
                } else {
                    topstroke.backgroundColor = chainofsub.assignedColor
                    bottomstroke.backgroundColor = chainofsub.assignedColor
                }
                
                if chainofsub.isfinalStep {
                    username.text = "End"
                    email.isHidden = true
                } else {
                    username.text = ""
                }
                
                stepNo.text = "4n6 Token"
                
                userimageView.image = UIImage(named: "Token")
                userimageView.contentMode = .center
                circle.isHidden = true
                
                if chainofsub.leftData == "Transaction Timestamp" || chainofsub.leftData == "Transaction ID"  {
                    lefttext.text = chainofsub.leftData
                    righttext.text = chainofsub.rightData
                }
            }
        }
    }
}

//MARK: - Setup styles
extension DocumentTrailStartCell {
    fileprivate func setstartcellUI() {
        
        topstroke = UIView()
        topstroke.translatesAutoresizingMaskIntoConstraints = false
        topstroke.backgroundColor = .purple
        addSubview(topstroke)
        
        let topstrokeConstraints = [topstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                    topstroke.topAnchor.constraint(equalTo: topAnchor),
                                    topstroke.bottomAnchor.constraint(equalTo: centerYAnchor),
                                    topstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(topstrokeConstraints)
        
        bottomstroke = UIView()
        bottomstroke.translatesAutoresizingMaskIntoConstraints = false
        bottomstroke.backgroundColor = .green
        addSubview(bottomstroke)
        
        let bottomstrokeConstraints = [bottomstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                       bottomstroke.topAnchor.constraint(equalTo: centerYAnchor),
                                       bottomstroke.bottomAnchor.constraint(equalTo: bottomAnchor),
                                       bottomstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(bottomstrokeConstraints)
        
        userimageView = CachedImageView()
        userimageView.translatesAutoresizingMaskIntoConstraints = false
        userimageView.contentMode = .scaleAspectFit
        userimageView.backgroundColor = .white
        addSubview(userimageView)
        
        let userimageviewConstraints = [userimageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                        userimageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                        userimageView.widthAnchor.constraint(equalToConstant: 50),
                                        userimageView.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(userimageviewConstraints)
        
        userimageView.layer.masksToBounds = true
        userimageView.layer.cornerRadius = 25
        userimageView.layer.borderWidth = 1
        
        stepNo = UILabel()
        stepNo.translatesAutoresizingMaskIntoConstraints = false
        stepNo.textColor = .darkGray
        stepNo.font = UIFont(name: "Helvetica-Bold", size: 16)
        stepNo.textAlignment = .right
        stepNo.text = ""
        addSubview(stepNo)
        
        let stepNoConstraints = [stepNo.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                 stepNo.leftAnchor.constraint(equalTo: leftAnchor),
                                 stepNo.rightAnchor.constraint(equalTo: userimageView.leftAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(stepNoConstraints)
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .darkGray
        username.font = UIFont(name: "Helvetica-Bold", size: 16)
        username.textAlignment = .left
        username.numberOfLines = 2
        username.text = ""
        
        email = UILabel()
        email.translatesAutoresizingMaskIntoConstraints = false
        email.textColor = .darkGray
        email.font = UIFont(name: "Helvetica-Bold", size: 12)
        email.textAlignment = .left
        email.numberOfLines = 2
        email.text = ""
        
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing   = 5.0
        
        stackView.addArrangedSubview(username)
        stackView.addArrangedSubview(email)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        let stackViewConstraints = [stackView.leftAnchor.constraint(equalTo: userimageView.rightAnchor, constant: 5),
                                   stackView.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                   stackView.rightAnchor.constraint(equalTo: rightAnchor)]

        NSLayoutConstraint.activate(stackViewConstraints)
        
        circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .green
        addSubview(circle)
        
        let circleConstraints = [circle.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 circle.centerYAnchor.constraint(equalTo: centerYAnchor),
                                 circle.heightAnchor.constraint(equalToConstant: 10),
                                 circle.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(circleConstraints)
        
        circle.layer.borderColor = UIColor.red.cgColor
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = 5
        
        lefttext = UILabel()
        lefttext.translatesAutoresizingMaskIntoConstraints = false
        lefttext.textColor = .darkGray
        lefttext.font = UIFont(name: "Helvetica-Bold", size: 15)
        lefttext.textAlignment = .right
        lefttext.numberOfLines = 2
        lefttext.text = ""
        addSubview(lefttext)
        
        let lefttextConstraints = [lefttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                   lefttext.rightAnchor.constraint(equalTo: circle.leftAnchor, constant: -5),
                                   lefttext.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)]
        NSLayoutConstraint.activate(lefttextConstraints)
        
        righttext = UILabel()
        righttext.translatesAutoresizingMaskIntoConstraints = false
        righttext.textColor = .darkGray
        righttext.font = UIFont(name: "Helvetica", size: 15)
        righttext.textAlignment = .left
        righttext.text = ""
        righttext.numberOfLines = 2
        addSubview(righttext)
        
        let righttextConstraints = [righttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    righttext.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 5),
                                    righttext.rightAnchor.constraint(equalTo: rightAnchor)]
        NSLayoutConstraint.activate(righttextConstraints)
    }
}

// ---------------------------------- MARK: Document Trails Start Cell KBA ---------------------------------- //
class DocumentTrailStartCellKBA: UITableViewCell {
    
    private var topstroke: UIView!
    private var bottomstroke: UIView!
    private var userimageView: CachedImageView!
    private var username: UILabel!
    private var stepNo: UILabel!
    private var kbaImageView: UIImageView!
    private var kbaHistory: UILabel!
    private var received: UILabel!
    private var lefttext: UILabel!
    private var righttext: UILabel!
    private var circle: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setstartcellUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        username.text = ""
        righttext.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var chainofsub: ChainofCustodySub! {
        didSet {
            userimageView.layer.borderColor = chainofsub.assignedColor?.cgColor
            let istoken = chainofsub.token
            if !istoken! {
                if chainofsub.isfirstStep {
                    topstroke.backgroundColor = UIColor(hexString: "#ffffff")
                    bottomstroke.backgroundColor = chainofsub.assignedColor
                } else {
                    topstroke.backgroundColor = chainofsub.assignedColor
                    bottomstroke.backgroundColor = chainofsub.assignedColor
                }
                
                username.text = chainofsub.userName
                
                if chainofsub.isfinalStep {
                    stepNo.text = chainofsub.leftData + " (End)"
                } else {
                    stepNo.text = chainofsub.leftData
                }
                
                if chainofsub.userImage != "https://s3.amazonaws.com/zfpi/" {
                    userimageView.loadImage(urlString: chainofsub.userImage!)
                } else {
                    userimageView.loadImage(urlString: "https://s3.amazonaws.com/zfpi/DefaultProfileSmall.jpg")
                }
                
                userimageView.contentMode = .scaleAspectFit
                circle.isHidden = true
                kbaHistory.text = chainofsub.kbaHistory
            }
        }
    }
}

//MARK: - Setup styles
extension DocumentTrailStartCellKBA {
    fileprivate func setstartcellUI() {
        
        topstroke = UIView()
        topstroke.translatesAutoresizingMaskIntoConstraints = false
        topstroke.backgroundColor = .purple
        addSubview(topstroke)
        
        let topstrokeConstraints = [topstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                    topstroke.topAnchor.constraint(equalTo: topAnchor),
                                    topstroke.bottomAnchor.constraint(equalTo: centerYAnchor),
                                    topstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(topstrokeConstraints)
        
        bottomstroke = UIView()
        bottomstroke.translatesAutoresizingMaskIntoConstraints = false
        bottomstroke.backgroundColor = .green
        addSubview(bottomstroke)
        
        let bottomstrokeConstraints = [bottomstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                       bottomstroke.topAnchor.constraint(equalTo: centerYAnchor),
                                       bottomstroke.bottomAnchor.constraint(equalTo: bottomAnchor),
                                       bottomstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(bottomstrokeConstraints)
        
        userimageView = CachedImageView()
        userimageView.translatesAutoresizingMaskIntoConstraints = false
        userimageView.contentMode = .scaleAspectFit
        userimageView.backgroundColor = .white
        addSubview(userimageView)
        
        let userimageviewConstraints = [userimageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                        userimageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                        userimageView.widthAnchor.constraint(equalToConstant: 50),
                                        userimageView.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(userimageviewConstraints)
        
        userimageView.layer.masksToBounds = true
        userimageView.layer.cornerRadius = 25
        userimageView.layer.borderWidth = 1
        
        kbaHistory = UILabel()
        kbaHistory.translatesAutoresizingMaskIntoConstraints = false
        kbaHistory.textColor = .darkGray
        kbaHistory.font = UIFont(name: "Helvetica-Bold", size: 16)
        kbaHistory.textAlignment = .right
        kbaHistory.numberOfLines = 1
        kbaHistory.text = ""
        addSubview(kbaHistory)
        
        let kbaHistoryConstarints = [kbaHistory.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     kbaHistory.rightAnchor.constraint(equalTo: userimageView.leftAnchor, constant: -5),
                                     kbaHistory.widthAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(kbaHistoryConstarints)
        
        
        kbaImageView = UIImageView()
        kbaImageView.translatesAutoresizingMaskIntoConstraints = false
        kbaImageView.contentMode = .center
        kbaImageView.image = UIImage(named: "KBA")
        addSubview(kbaImageView)
        
        let kbaimageviewContraints = [kbaImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      kbaImageView.rightAnchor.constraint(equalTo: kbaHistory.leftAnchor),
                                      kbaImageView.widthAnchor.constraint(equalToConstant: 25),
                                      kbaImageView.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(kbaimageviewContraints)
        
        stepNo = UILabel()
        stepNo.translatesAutoresizingMaskIntoConstraints = false
        stepNo.textColor = .darkGray
        stepNo.font = UIFont(name: "Helvetica-Bold", size: 16)
        stepNo.textAlignment = .right
        stepNo.text = ""
        addSubview(stepNo)
        
        let stepNoConstraints = [stepNo.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                 stepNo.leftAnchor.constraint(equalTo: leftAnchor),
                                 stepNo.rightAnchor.constraint(equalTo: kbaImageView.leftAnchor)]
        
        NSLayoutConstraint.activate(stepNoConstraints)
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .darkGray
        username.font = UIFont(name: "Helvetica-Bold", size: 16)
        username.textAlignment = .left
        username.numberOfLines = 2
        username.text = ""
        addSubview(username)
        
        let usernameConstraints = [username.leftAnchor.constraint(equalTo: userimageView.rightAnchor, constant: 5),
                                   username.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                   username.rightAnchor.constraint(equalTo: rightAnchor)]
        
        NSLayoutConstraint.activate(usernameConstraints)
        
        circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .green
        addSubview(circle)
        
        let circleConstraints = [circle.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 circle.centerYAnchor.constraint(equalTo: centerYAnchor),
                                 circle.heightAnchor.constraint(equalToConstant: 10),
                                 circle.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(circleConstraints)
        
        circle.layer.borderColor = UIColor.red.cgColor
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = 5
        
        lefttext = UILabel()
        lefttext.translatesAutoresizingMaskIntoConstraints = false
        lefttext.textColor = .darkGray
        lefttext.font = UIFont(name: "Helvetica-Bold", size: 15)
        lefttext.textAlignment = .right
        lefttext.numberOfLines = 2
        lefttext.text = ""
        addSubview(lefttext)
        
        let lefttextConstraints = [lefttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                   lefttext.rightAnchor.constraint(equalTo: circle.leftAnchor, constant: -5),
                                   lefttext.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)]
        NSLayoutConstraint.activate(lefttextConstraints)
        
        righttext = UILabel()
        righttext.translatesAutoresizingMaskIntoConstraints = false
        righttext.textColor = .darkGray
        righttext.font = UIFont(name: "Helvetica", size: 15)
        righttext.textAlignment = .left
        righttext.text = ""
        righttext.numberOfLines = 2
        addSubview(righttext)
        
        let righttextConstraints = [righttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    righttext.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 5),
                                    righttext.rightAnchor.constraint(equalTo: rightAnchor)]
        NSLayoutConstraint.activate(righttextConstraints)
    }
}

// ---------------------------------- MARK: Document Trails Details Cell---------------------------------- //
class DocumentTrailDetailCell: UITableViewCell {
    
    private var topstroke: UIView!
    private var bottomstroke: UIView!
    private var circle: UIView!
    private var lefttext: UILabel!
    private var righttext: UILabel!
    private var rightimage: UIImageView!
    private var leftactionimage: UIImageView!
    private var rightactionText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setdetailcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        righttext.text = ""
    }
    
    var chainofsub: ChainofCustodySub! {
        didSet {
            
            if chainofsub.isfinalStep {
                if chainofsub.tokenid == -1 {
                    if chainofsub.contractversion != "0" {
                        if chainofsub.leftData == "Digital Signature" {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = UIColor(hexString: "#ffffff")
                        } else {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = chainofsub.assignedColor
                        }
                    }
                } else {
                    if chainofsub.contractversion == "0" {
                        if chainofsub.leftData == "Completed" || chainofsub.leftData == "Send Back" {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = UIColor(hexString: "#ffffff")
                        } else {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = chainofsub.assignedColor
                        }
                    } else {
                        if chainofsub.leftData == "Transaction Timestamp" {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = UIColor(hexString: "#ffffff")
                        } else {
                            topstroke.backgroundColor = chainofsub.assignedColor
                            bottomstroke.backgroundColor = chainofsub.assignedColor
                        }
                    }
                }
            } else {
                topstroke.backgroundColor = chainofsub.assignedColor
                bottomstroke.backgroundColor = chainofsub.assignedColor
            }
            
            circle.layer.borderColor = chainofsub.assignedColor?.cgColor
            lefttext.text = chainofsub.leftData
            
            let isfill = chainofsub.isFill
            if isfill! {
                circle.backgroundColor = chainofsub.assignedColor
            } else {
                circle.backgroundColor = .white
            }
            
            let isaction = chainofsub.isAction
            if isaction! {
                righttext.isHidden = true
                rightimage.isHidden = false
                leftactionimage.isHidden = false
                rightactionText.isHidden = false
                let isinitialaction = chainofsub.intialAction
                let isactionhidden = chainofsub.isactionHidden
                if isinitialaction! {
                    if isactionhidden! {
                        rightimage.image = UIImage(named: "Down-arrow_tools")
                        leftactionimage.isHidden = true
                        rightactionText.isHidden = true
                    } else {
                        rightimage.image = UIImage(named: "Up-Arrow_tools")
                        leftactionimage.isHidden = true
                        rightactionText.isHidden = true
                    }
                } else {
                    leftactionimage.image = chainofsub.tagimage
                    leftactionimage.tintColor = ColorTheme.BtnTintDisabled
                    rightactionText.text = chainofsub.rightData
                    rightimage.isHidden = true
                    
                    if isactionhidden! {
                        isHidden = true
                    } else {
                        isHidden = false
                    }
                }
            } else {
                isHidden = false
                if lefttext.text == "Geolocation" {
                    setUnderLine(rightData: chainofsub.rightData)
                } else {
                    righttext.text = chainofsub.rightData
                }
                righttext.isHidden = false
                rightimage.isHidden = true
                leftactionimage.isHidden = true
                rightactionText.isHidden = true
            }
        }
    }
}

//MARK; - Setup styles
extension DocumentTrailDetailCell {
    fileprivate  func setdetailcellUI() {
        topstroke = UIView()
        topstroke.translatesAutoresizingMaskIntoConstraints = false
        topstroke.backgroundColor = .purple
        addSubview(topstroke)
        
        let topstrokeConstraints = [topstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                    topstroke.topAnchor.constraint(equalTo: topAnchor),
                                    topstroke.bottomAnchor.constraint(equalTo: centerYAnchor),
                                    topstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(topstrokeConstraints)
        
        bottomstroke = UIView()
        bottomstroke.translatesAutoresizingMaskIntoConstraints = false
        bottomstroke.backgroundColor = .green
        addSubview(bottomstroke)
        
        let bottomstrokeConstraints = [bottomstroke.centerXAnchor.constraint(equalTo: centerXAnchor),
                                       bottomstroke.topAnchor.constraint(equalTo: centerYAnchor),
                                       bottomstroke.bottomAnchor.constraint(equalTo: bottomAnchor),
                                       bottomstroke.widthAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(bottomstrokeConstraints)
        
        circle = UIView()
        circle.translatesAutoresizingMaskIntoConstraints = false
        circle.backgroundColor = .green
        addSubview(circle)
        
        let circleConstraints = [circle.centerXAnchor.constraint(equalTo: centerXAnchor),
                                 circle.centerYAnchor.constraint(equalTo: centerYAnchor),
                                 circle.heightAnchor.constraint(equalToConstant: 10),
                                 circle.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(circleConstraints)
        
        circle.layer.borderColor = UIColor.red.cgColor
        circle.layer.borderWidth = 1
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = 5
        
        lefttext = UILabel()
        lefttext.translatesAutoresizingMaskIntoConstraints = false
        lefttext.textColor = .darkGray
        lefttext.font = UIFont(name: "Helvetica-Bold", size: 15)
        lefttext.textAlignment = .right
        lefttext.numberOfLines = 2
        lefttext.text = ""
        addSubview(lefttext)
        
        let lefttextConstraints = [lefttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                   lefttext.rightAnchor.constraint(equalTo: circle.leftAnchor, constant: -5),
                                   lefttext.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)]
        NSLayoutConstraint.activate(lefttextConstraints)
        
        righttext = UILabel()
        righttext.translatesAutoresizingMaskIntoConstraints = false
        righttext.textColor = .darkGray
        righttext.font = UIFont(name: "Helvetica", size: 14)
        righttext.textAlignment = .left
//        righttext.text = ""
        righttext.numberOfLines = 2
        addSubview(righttext)
        
        let righttextConstraints = [righttext.centerYAnchor.constraint(equalTo: centerYAnchor),
                                    righttext.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 5),
                                    righttext.rightAnchor.constraint(equalTo: rightAnchor)]
        NSLayoutConstraint.activate(righttextConstraints)
        
        rightactionText = UILabel()
        rightactionText.translatesAutoresizingMaskIntoConstraints = false
        rightactionText.textColor = .darkGray
        rightactionText.font = UIFont(name: "Helvetica", size: 14)
        rightactionText.numberOfLines = 2
        rightactionText.textAlignment = .left
        rightactionText.text = ""
        addSubview(rightactionText)
        
        let rightactiontextConstraints = [rightactionText.centerYAnchor.constraint(equalTo: centerYAnchor),
                                          rightactionText.rightAnchor.constraint(equalTo: rightAnchor),
                                          rightactionText.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 5)]
        NSLayoutConstraint.activate(rightactiontextConstraints)
        
        rightimage = UIImageView()
        rightimage.translatesAutoresizingMaskIntoConstraints = false
        rightimage.backgroundColor = .clear
        rightimage.contentMode = .center
        addSubview(rightimage)
        
        let rightimageConstraints = [rightimage.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     rightimage.leftAnchor.constraint(equalTo: circle.rightAnchor, constant: 5),
                                     rightimage.widthAnchor.constraint(equalToConstant: 30),
                                     rightimage.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(rightimageConstraints)
        
        leftactionimage = UIImageView()
        leftactionimage.translatesAutoresizingMaskIntoConstraints = false
        leftactionimage.backgroundColor = .clear
        leftactionimage.contentMode = .center
        addSubview(leftactionimage)
        
        let leftactionimageConstraints = [leftactionimage.centerYAnchor.constraint(equalTo: centerYAnchor),
                                          leftactionimage.rightAnchor.constraint(equalTo: circle.leftAnchor, constant: -5),
                                          leftactionimage.widthAnchor.constraint(equalToConstant: 30),
                                          leftactionimage.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(leftactionimageConstraints)
    }
    
    func setUnderLine(rightData: String) {
        let attributedString = NSMutableAttributedString.init(string: rightData)
        
        // Add Underline Style Attribute.
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range:
                                        NSRange.init(location: 0, length: attributedString.length));
        righttext.attributedText = attributedString
    }
}

// MARK: Document Signature Cell
class DocumentTrailSignatureCell: UITableViewCell {
    
    private var userimage: CachedImageView!
    private var username: UILabel!
    
    private var signatureLabel: UILabel!
    private var timeDateLabel: UILabel!
    private var signaturetick: UILabel!
    private var signaturedatetime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setsignaturecellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var chainofsignaturesub: ChainofSignatureSub! {
        didSet {
            userimage.loadImage(urlString: chainofsignaturesub.userimage, completion: nil)
            username.text = chainofsignaturesub.username
            signaturetick.text = chainofsignaturesub.signaturetrick
            signaturedatetime.text = chainofsignaturesub.signaturetime
        }
    }
    
}

extension DocumentTrailSignatureCell {
    fileprivate func setsignaturecellUI() {
        
        userimage = CachedImageView()
        userimage.translatesAutoresizingMaskIntoConstraints = false
        userimage.backgroundColor = .black
        userimage.contentMode = .scaleAspectFit
        addSubview(userimage)
        
        let userimageconstraints = [userimage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                    userimage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                    userimage.widthAnchor.constraint(equalToConstant: 50),
                                    userimage.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(userimageconstraints)
        
        userimage.layer.masksToBounds = true
        userimage.layer.cornerRadius = 25
        userimage.layer.borderWidth = 1
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .darkGray
        username.font = UIFont(name: "Helvetica-Bold", size: 18)
        username.numberOfLines = 2
        username.textAlignment = .left
        username.text = ""
        addSubview(username)
        
        let usernameconstraints = [username.leftAnchor.constraint(equalTo: userimage.rightAnchor, constant: 5),
                                   username.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                   username.centerYAnchor.constraint(equalTo: userimage.centerYAnchor)]
        NSLayoutConstraint.activate(usernameconstraints)
        
        signatureLabel = UILabel()
        signatureLabel.translatesAutoresizingMaskIntoConstraints = false
        signatureLabel.translatesAutoresizingMaskIntoConstraints = false
        signatureLabel.textColor = .darkGray
        signatureLabel.font = UIFont(name: "Helvetica-Bold", size: 13)
        signatureLabel.textAlignment = .left
        signatureLabel.text = "Signature Block ID"
        addSubview(signatureLabel)
        
        let signatureimageviewconstraints = [signatureLabel.leftAnchor.constraint(equalTo: username.leftAnchor, constant: 0),
                                             signatureLabel.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 10),
                                             signatureLabel.widthAnchor.constraint(equalToConstant: 120),
                                             signatureLabel.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(signatureimageviewconstraints)
        
        timeDateLabel = UILabel()
        timeDateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeDateLabel.translatesAutoresizingMaskIntoConstraints = false
        timeDateLabel.textColor = .darkGray
        timeDateLabel.font = UIFont(name: "Helvetica-Bold", size: 13)
        timeDateLabel.textAlignment = .left
        timeDateLabel.text = "Timestamp"
        addSubview(timeDateLabel)
        
        let timeDateviewconstraints = [timeDateLabel.leftAnchor.constraint(equalTo: username.leftAnchor, constant: 0),
                                             timeDateLabel.topAnchor.constraint(equalTo: signatureLabel.bottomAnchor, constant: 5),
                                             timeDateLabel.widthAnchor.constraint(equalToConstant: 120),
                                             timeDateLabel.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(timeDateviewconstraints)
        
        signaturetick = UILabel()
        signaturetick.translatesAutoresizingMaskIntoConstraints = false
        signaturetick.textColor = .darkGray
        signaturetick.font = UIFont(name: "Helvetica", size: 13)
        signaturetick.textAlignment = .left
        signaturetick.numberOfLines = 2
        signaturetick.text = ""
        addSubview(signaturetick)
        
        let signaturetickconstraints = [signaturetick.leftAnchor.constraint(equalTo: signatureLabel.rightAnchor, constant: 5),
                                        signaturetick.rightAnchor.constraint(equalTo: rightAnchor),
                                        signaturetick.centerYAnchor.constraint(equalTo: signatureLabel.centerYAnchor),
                                        signatureLabel.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(signaturetickconstraints)
        
        
        signaturedatetime = UILabel()
        signaturedatetime.translatesAutoresizingMaskIntoConstraints = false
        signaturedatetime.textColor = .darkGray
        signaturedatetime.font = UIFont(name: "Helvetica-Light", size: 13)
        signaturedatetime.textAlignment = .left
        signaturedatetime.numberOfLines = 2
        signaturedatetime.text = ""
        addSubview(signaturedatetime)
        
        let signaturedatetimeconstraints = [signaturedatetime.leftAnchor.constraint(equalTo: signaturetick.leftAnchor, constant: 0),
                                            signaturedatetime.topAnchor.constraint(equalTo: signaturetick.bottomAnchor, constant: 10),
                                            signaturedatetime.rightAnchor.constraint(equalTo: rightAnchor),
                                            signaturedatetime.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(signaturedatetimeconstraints)
    }
}

// ---------------------------------- MARK: Document Download Cell ---------------------------------- //
class DocumentTrailDownloadCell: UITableViewCell {
    
    var documentname: UILabel!
    var username: UILabel!
    var downloadicon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setdownloadcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var chainofdocument: ChainofDocumentSub! {
        didSet {
            documentname.text = chainofdocument.documentname
            username.text = chainofdocument.username
        }
    }
}

//MARK: - Set download cell ui
extension DocumentTrailDownloadCell {
    fileprivate func setdownloadcellUI() {
        
        downloadicon = UIImageView()
        downloadicon.translatesAutoresizingMaskIntoConstraints = false
        downloadicon.backgroundColor = .white
        downloadicon.image = UIImage(named: "Download")
        downloadicon.contentMode = .center
        addSubview(downloadicon)
        
        let downloadiconconstraints = [downloadicon.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                       downloadicon.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                       downloadicon.widthAnchor.constraint(equalToConstant: 40),
                                       downloadicon.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(downloadiconconstraints)
        
        documentname = UILabel()
        documentname.translatesAutoresizingMaskIntoConstraints = false
        documentname.textColor = .darkGray
        documentname.font = UIFont(name: "Helvetica", size: 18)
        documentname.numberOfLines = 2
        documentname.text = "Document name abc.docx"
        addSubview(documentname)
        
        let documentnameconstraints = [documentname.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                       documentname.rightAnchor.constraint(equalTo: downloadicon.leftAnchor, constant: -5),
                                       documentname.topAnchor.constraint(equalTo: topAnchor, constant: 10)]
        NSLayoutConstraint.activate(documentnameconstraints)
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .darkGray
        username.font = UIFont(name: "Helvetica-Bold", size: 18)
        username.numberOfLines = 2
        username.text = "Chanaka Caldera"
        addSubview(username)
        
        let usernameconstraints = [username.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                   username.rightAnchor.constraint(equalTo: downloadicon.leftAnchor, constant: -5),
                                   username.topAnchor.constraint(equalTo: documentname.bottomAnchor, constant: 5),
                                   username.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)]
        NSLayoutConstraint.activate(usernameconstraints)
    }
}

// ---------------------------------- MARK: Attachment Download Cell ---------------------------------- //

class DocumentTrailAttachmentDownloadCell: UITableViewCell {
    
    var filename: UILabel!
    var username: UILabel!
    var downloadicon: UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setdownloadattachmentcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var chainofattchment: ChainofAttachmentSub! {
        didSet {
            username.text = chainofattchment.username
            filename.text = chainofattchment.attachmentname
        }
    }
}

//MARK: - Set download attachment cell ui
extension DocumentTrailAttachmentDownloadCell {
    fileprivate func setdownloadattachmentcellUI() {
        
        downloadicon = UIImageView()
        downloadicon.translatesAutoresizingMaskIntoConstraints = false
        downloadicon.backgroundColor = .white
        downloadicon.image = UIImage(named: "Download")
        downloadicon.contentMode = .center
        addSubview(downloadicon)
        
        let downloadiconconstraints = [downloadicon.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                       downloadicon.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                       downloadicon.widthAnchor.constraint(equalToConstant: 40),
                                       downloadicon.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(downloadiconconstraints)
        
        filename = UILabel()
        filename.translatesAutoresizingMaskIntoConstraints = false
        filename.textColor = .darkGray
        filename.font = UIFont(name: "Helvetica", size: 18)
        filename.numberOfLines = 2
        filename.text = "Website optimization.pdf"
        addSubview(filename)
        
        let filenameconstraints = [filename.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                   filename.rightAnchor.constraint(equalTo: downloadicon.leftAnchor, constant: -5),
                                   filename.topAnchor.constraint(equalTo: topAnchor, constant: 10)]
        NSLayoutConstraint.activate(filenameconstraints)
        
        username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.textColor = .darkGray
        username.font = UIFont(name: "Helvetica-Bold", size: 18)
        username.numberOfLines = 2
        username.text = "Chanaka Caldera"
        addSubview(username)
        
        let usernameconstraints = [username.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                   username.rightAnchor.constraint(equalTo: downloadicon.leftAnchor, constant: -5),
                                   username.topAnchor.constraint(equalTo: filename.bottomAnchor, constant: 5),
                                   username.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)]
        NSLayoutConstraint.activate(usernameconstraints)
    }
}
