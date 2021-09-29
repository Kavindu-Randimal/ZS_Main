//
//  RecoveryOptionSelectionCell.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/11/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RecoveryOptionSelectionCell: UITableViewCell {
    
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var recoveryOptionBaseContainer: UIView!
    
    private var recoveryoptionBtn: UIButton!
    private var recoveryoptionLabel: UILabel!
    private var downarrowImage: UIImageView!
    private var recoveryOptionsView: RecoveryOptionView!
    private var gapLabel: UILabel!
    
    var multifactortwofasettingsCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setmultifacellUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var recoveryoptionsFallback: MultifactorSettingsViewModel? {
        didSet {
            if let recoveryoptionType = recoveryoptionsFallback?.recoveryOptionType {
                recoveryOptionsView.updateDefaultOption(at: recoveryoptionType)
            }
        }
    }
}

extension RecoveryOptionSelectionCell {
    
    private func setmultifacellUI() {
        setRecoveryOptionBase()
        setHeader()
        setRecoveryOptions()
        setGapper()
    }
}

//MARK: - SetupBasecontainer
extension RecoveryOptionSelectionCell {
    
    private func setRecoveryOptionBase() {
        
        recoveryOptionBaseContainer = UIView()
        recoveryOptionBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        recoveryOptionBaseContainer.backgroundColor = .white
        
        addSubview(recoveryOptionBaseContainer)
        
        let basecontainerConstraints = [recoveryOptionBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                        recoveryOptionBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        recoveryOptionBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                        recoveryOptionBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(basecontainerConstraints)
        recoveryOptionBaseContainer.setShadow()
    }
}

//MARK: - Setup Header UI
extension RecoveryOptionSelectionCell {
    
    private func setHeader() {
        
        recoveryoptionBtn = UIButton()
        recoveryoptionBtn.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionBtn.backgroundColor = .white
        recoveryOptionBaseContainer.addSubview(recoveryoptionBtn)
        
        let recoveryoptionbtnConstraints = [recoveryoptionBtn.leftAnchor.constraint(equalTo: recoveryOptionBaseContainer.leftAnchor, constant: 10),
                                            recoveryoptionBtn.topAnchor.constraint(equalTo: recoveryOptionBaseContainer.topAnchor, constant: 15),
                                            recoveryoptionBtn.rightAnchor.constraint(equalTo: recoveryOptionBaseContainer.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(recoveryoptionbtnConstraints)
        
        recoveryoptionBtn.addTarget(self, action: #selector(selectRecoveryOptions(_:)), for: .touchUpInside)
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Up-Arrow_tools")
        recoveryOptionBaseContainer.addSubview(downarrowImage)
        
        let downarrowimageConstraints = [downarrowImage.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor),
                                         downarrowImage.rightAnchor.constraint(equalTo: recoveryoptionBtn.rightAnchor,constant: -10),
                                         downarrowImage.heightAnchor.constraint(equalToConstant: 10),
                                         downarrowImage.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(downarrowimageConstraints)
        
        recoveryoptionLabel = UILabel()
        recoveryoptionLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        recoveryoptionLabel.textColor = .darkGray
        recoveryoptionLabel.numberOfLines = 0
        recoveryoptionLabel.text = "Recovery Options*"
        recoveryOptionBaseContainer.addSubview(recoveryoptionLabel)
        
        let recoveroptionlableConstraints = [recoveryoptionLabel.leftAnchor.constraint(equalTo: recoveryoptionBtn.leftAnchor),
                                             recoveryoptionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor),
                                             recoveryoptionLabel.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
    }
}

//MARK: - Set recovery options
extension RecoveryOptionSelectionCell {
    private func setRecoveryOptions() {
        recoveryOptionsView = RecoveryOptionView(optiontexts: ["Recovery Email Address", "Security Questions"])
        recoveryOptionsView.translatesAutoresizingMaskIntoConstraints = false
        recoveryOptionsView.backgroundColor = .white
        recoveryOptionBaseContainer.addSubview(recoveryOptionsView)
        
        let recoveryoptionsviewConstraints = [recoveryOptionsView.leftAnchor.constraint(equalTo:recoveryOptionBaseContainer.leftAnchor, constant: 10),
                                              recoveryOptionsView.topAnchor.constraint(equalTo: recoveryoptionBtn.bottomAnchor),
                                              recoveryOptionsView.rightAnchor.constraint(equalTo: recoveryOptionBaseContainer.rightAnchor),
                                              recoveryOptionsView.heightAnchor.constraint(equalToConstant: 80)]
        NSLayoutConstraint.activate(recoveryoptionsviewConstraints)
        
        recoveryOptionsView.optionviewCallBack =  { [weak self] (selectedIndex) in
            switch selectedIndex {
            case 0:
                print("Chathura fallback otp ",selectedIndex)
                self?.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self?.recoveryoptionsFallback?.recoveryOptionType = 1
                self?.recoveryoptionsFallback?.recoveryoptionsubType = 0
                self?.multifactortwofasettingsCallBack!(self!.recoveryoptionsFallback, false)
            default:
                print("Chathura fallback questions ",selectedIndex)
                self?.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self?.recoveryoptionsFallback?.recoveryOptionType = 2
                self?.multifactortwofasettingsCallBack!(self!.recoveryoptionsFallback, false)
            }
        }
    }
}

extension RecoveryOptionSelectionCell {
    private func setGapper() {
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryOptionBaseContainer.addSubview(gapLabel)
        gapLabel.text = "..."
        gapLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            gapLabel.leftAnchor.constraint(equalTo: recoveryOptionBaseContainer.leftAnchor),
            gapLabel.topAnchor.constraint(equalTo: recoveryOptionsView.bottomAnchor),
            gapLabel.rightAnchor.constraint(equalTo: recoveryOptionBaseContainer.rightAnchor),
            gapLabel.bottomAnchor.constraint(equalTo: recoveryOptionBaseContainer.bottomAnchor,constant: 5)
        ])
    }
}

//MARK: - Select recovery options method
extension RecoveryOptionSelectionCell {
    @objc func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options deselect 5")
        if let recoveryoptionSelected = recoveryoptionsFallback?.recoveryOptionSelected {
            if recoveryoptionSelected == 0 {
                recoveryoptionsFallback?.recoveryOptionSelected = 1
            } else {
                recoveryoptionsFallback?.recoveryOptionSelected = 0
            }
        }
        multifactortwofasettingsCallBack!(recoveryoptionsFallback, false)
    }
}
