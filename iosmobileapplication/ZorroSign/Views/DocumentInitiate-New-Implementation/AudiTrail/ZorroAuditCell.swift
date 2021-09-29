//
//  ZorroAuditCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift
import FontAwesome_swift

class ZorroAuditCell: UITableViewCell {
    
    private let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var leftLine: UIView!
    private var rightLine: UIView!
    private var leftverticleLine: UIView!
    private var rightverticleLine: UIView!
    private var userimageView: CachedImageView!
    private var stepnumberView: UIView!
    private var stepnumberLabel: UILabel!
    private var usernameLabel: UILabel!
    private var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Bind Data
    var documentaudittrail: DocumentAuditTrail! {
        didSet {
            stepnumberLabel.text = documentaudittrail.documentStep
            usernameLabel.isHidden = documentaudittrail.shouldhideName
            dateLabel.isHidden = documentaudittrail.shouldhideDate
            usernameLabel.text = documentaudittrail.recepientName
            
            if let _recepientImage = documentaudittrail.recepientImage {
                userimageView.loadImage(urlString: _recepientImage)
            } else {
                userimageView.image = UIImage(named: "read_token")
                userimageView.layer.cornerRadius = 0
                userimageView.backgroundColor = .clear
            }
            
            if let duedate = documentaudittrail.documentdueDate {
                if(duedate != ""){
                    dateLabel.text = duedate + " " + String.fontAwesomeIcon(name: .edit)
                }
            }
            
            
            leftLine.isHidden = documentaudittrail.shouldhideleftLine
            rightLine.isHidden = documentaudittrail.shouldhiderightLine
            leftverticleLine.isHidden = documentaudittrail.shouldhideleftVertical
            rightverticleLine.isHidden = documentaudittrail.shouldhiderighVertical
            print("Tools :\(documentaudittrail.tagtypes ?? [])")
        }
    }
}

//MARK: - Set Up cell ui
extension ZorroAuditCell {
    fileprivate func setcellUI() {
        
        userimageView = CachedImageView()
        userimageView.translatesAutoresizingMaskIntoConstraints = false
        userimageView.backgroundColor = .black
        userimageView.contentMode = .scaleAspectFit
        
        addSubview(userimageView)
        
        var widthheight: CGFloat = 40.0
        
        if deviceName == .pad {
            widthheight = 50.0
        }
        
        let userimageviewConstraints = [userimageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                                        userimageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                                        userimageView.widthAnchor.constraint(equalToConstant: widthheight),
                                        userimageView.heightAnchor.constraint(equalToConstant: widthheight)]
        NSLayoutConstraint.activate(userimageviewConstraints)
        
        
        
        userimageView.layer.cornerRadius = widthheight/2
        userimageView.layer.masksToBounds = true
        
        
        stepnumberView = UIView()
        stepnumberView.translatesAutoresizingMaskIntoConstraints = false
        stepnumberView.backgroundColor = .white
        addSubview(stepnumberView)
        
        let stepnumberviewConstrints = [stepnumberView.centerXAnchor.constraint(equalTo: userimageView.rightAnchor),
                                        stepnumberView.centerYAnchor.constraint(equalTo: userimageView.topAnchor),
                                        stepnumberView.widthAnchor.constraint(equalToConstant: 30),
                                        stepnumberView.heightAnchor.constraint(equalToConstant: 20)]
        
        NSLayoutConstraint.activate(stepnumberviewConstrints)
        stepnumberView.layer.masksToBounds = true
        stepnumberView.layer.cornerRadius = 8
        stepnumberView.layer.borderWidth = 1
        stepnumberView.layer.borderColor = UIColor.lightGray.cgColor
        
        stepnumberLabel = UILabel()
        stepnumberLabel.translatesAutoresizingMaskIntoConstraints = false
        stepnumberLabel.font = UIFont(name: "Helvetica", size: 15)
        stepnumberLabel.textAlignment = .right
        stepnumberLabel.adjustsFontSizeToFitWidth = true
        stepnumberLabel.minimumScaleFactor = 0.2
        stepnumberView.addSubview(stepnumberLabel)
        
        let stepnumberlabelConstrints = [stepnumberLabel.leftAnchor.constraint(equalTo: stepnumberView.leftAnchor),
                                         stepnumberLabel.topAnchor.constraint(equalTo: stepnumberView.topAnchor),
                                         stepnumberLabel.rightAnchor.constraint(equalTo: stepnumberView.centerXAnchor),
                                         stepnumberLabel.bottomAnchor.constraint(equalTo: stepnumberView.bottomAnchor),]
        
        NSLayoutConstraint.activate(stepnumberlabelConstrints)
        
        
        leftLine = UIView()
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        leftLine.backgroundColor = .lightGray
        addSubview(leftLine)
        
        let leftlineConstraints = [leftLine.leftAnchor.constraint(equalTo: leftAnchor),
                                   leftLine.rightAnchor.constraint(equalTo: centerXAnchor),
                                   leftLine.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                   leftLine.heightAnchor.constraint(equalToConstant: 0.5)]
        
        NSLayoutConstraint.activate(leftlineConstraints)
        
        rightLine = UIView()
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        rightLine.backgroundColor = .lightGray
        addSubview(rightLine)
        
        let rightlineConstraints = [rightLine.leftAnchor.constraint(equalTo: centerXAnchor),
                                    rightLine.rightAnchor.constraint(equalTo: rightAnchor),
                                    rightLine.centerYAnchor.constraint(equalTo: userimageView.centerYAnchor),
                                    rightLine.heightAnchor.constraint(equalToConstant: 0.5)]
        
        NSLayoutConstraint.activate(rightlineConstraints)
        
        leftverticleLine = UIView()
        leftverticleLine.translatesAutoresizingMaskIntoConstraints = false
        leftverticleLine.backgroundColor = .lightGray
        addSubview(leftverticleLine)
        
        let leftverticleLineConstraints = [leftverticleLine.leftAnchor.constraint(equalTo: leftAnchor),
                                           leftverticleLine.topAnchor.constraint(equalTo: topAnchor),
                                           leftverticleLine.bottomAnchor.constraint(equalTo: bottomAnchor),
                                           leftverticleLine.widthAnchor.constraint(equalToConstant: 0.5)]
        
        NSLayoutConstraint.activate(leftverticleLineConstraints)
        
        rightverticleLine = UIView()
        rightverticleLine.translatesAutoresizingMaskIntoConstraints = false
        rightverticleLine.backgroundColor = .lightGray
        addSubview(rightverticleLine)
        
        let rightverticleLineLineConstraints = [rightverticleLine.rightAnchor.constraint(equalTo: rightAnchor),
                                                rightverticleLine.topAnchor.constraint(equalTo: topAnchor),
                                                rightverticleLine.bottomAnchor.constraint(equalTo: bottomAnchor),
                                                rightverticleLine.widthAnchor.constraint(equalToConstant: 0.5)]
        
        NSLayoutConstraint.activate(rightverticleLineLineConstraints)
        
        bringSubviewToFront(userimageView)
        bringSubviewToFront(stepnumberView)
        
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.text = "chanaka caldera"
        usernameLabel.font = UIFont(name: "Helvetica", size: 14)
        usernameLabel.numberOfLines = 1
        usernameLabel.textAlignment = .center
        
        addSubview(usernameLabel)
        
        print("content view width : \(contentView.frame.width)")
        
        let usernamelabelConstraints = [usernameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                        usernameLabel.topAnchor.constraint(equalTo: userimageView.bottomAnchor, constant: 10),
                                        usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                                        usernameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)]
        
        NSLayoutConstraint.activate(usernamelabelConstraints)
        
        
        dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.fontAwesome(ofSize: 14, style: .solid)
        dateLabel.textAlignment = .center
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.minimumScaleFactor = 0.2
        dateLabel.textColor = .lightGray
        //dateLabel.text = "MMM dd, yyyy" + String.fontAwesomeIcon(name: .edit)
        dateLabel.text = ""
        dateLabel.isUserInteractionEnabled = true
        
        addSubview(dateLabel)
        
        let datelabelConstraints = [dateLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                                    dateLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor),
                                    dateLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width/2),
                                    dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(datelabelConstraints)
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(settapGestureforDate(_:)))
        tapgesture.numberOfTouchesRequired = 1
        dateLabel.addGestureRecognizer(tapgesture)
    }
}

//MARK: Set Tap Gesture for date label
extension ZorroAuditCell {
    @objc private func settapGestureforDate(_ recognizer: UITapGestureRecognizer) {
        print("----------------\n")
        let touchpoint = recognizer.location(in: self.superview)
        print("TOUCH POINTS : -> \(touchpoint)")
        
        if FeatureMatrix.shared.set_reminders {
            SharingManager.sharedInstance.triggeronDueDateChange(index:Int(self.documentaudittrail.documentStep!)!-1,duedate: "DateChanged")
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}
