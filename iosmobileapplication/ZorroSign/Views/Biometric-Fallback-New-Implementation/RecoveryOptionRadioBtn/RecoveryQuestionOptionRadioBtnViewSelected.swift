//
//  RecoveryQuestionOptionRadioBtnViewSelected.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class RecoveryQuestionOptionRadioBtnViewSelected: UIView {
    
    var optionTexts: [String] = []
    private var greenColor: UIColor = ColorTheme.btnBG
    private let deviceWidth: CGFloat = UIScreen.main.bounds.width
    
    private var backContainer: UIView!
    private var radiobuttonImages: [UIImageView] = []
    
    var optionviewCallBack: ((Bool) -> ())?
    
    convenience init(optiontexts: [String]) {
        self.init(frame: .zero)
        self.optionTexts = optiontexts
        setbackContainer()
        setRadioButtons()
    }
}

//MARK: - Set Background View
extension RecoveryQuestionOptionRadioBtnViewSelected {
    private func setbackContainer() {
        backContainer = UIView()
        backContainer.translatesAutoresizingMaskIntoConstraints = false
        backContainer.backgroundColor = .white
        addSubview(backContainer)
        
        let backcontainerConstraints = [backContainer.leftAnchor.constraint(equalTo: leftAnchor),
                                        backContainer.topAnchor.constraint(equalTo: topAnchor),
                                        backContainer.rightAnchor.constraint(equalTo: rightAnchor),
                                        backContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(backcontainerConstraints)
    }
}

//MARK: - Set Radio Buttons
extension RecoveryQuestionOptionRadioBtnViewSelected {
    private func setRadioButtons() {
        
        let _optionviewWidth: CGFloat = deviceWidth - 80
        let _optionviewGap: CGFloat = 5.0
        let _optionviewHeight: CGFloat = 35.0
        
        
        for i in 0..<optionTexts.count {
            
            let _gap = _optionviewHeight * CGFloat(i) + _optionviewGap * CGFloat(i)
            
            let optionview = UIView(frame: CGRect(x: 5, y: _gap, width: _optionviewWidth, height: _optionviewHeight))
            optionview.backgroundColor = .white
            
            let _imageviewWidthHeight: CGFloat = 25
            let imageview = UIImageView(frame: CGRect(x: 0, y: 5, width: _imageviewWidthHeight, height: _imageviewWidthHeight))
            imageview.backgroundColor = .white
            imageview.image = UIImage.fontAwesomeIcon(name: .dotCircle, style: .solid, textColor: greenColor, size: CGSize(width: 30, height: 30))
            
            imageview.layer.masksToBounds = true
            imageview.layer.cornerRadius = _imageviewWidthHeight/CGFloat(2)
            imageview.layer.borderColor = ColorTheme.radioBtnBorder.cgColor
            imageview.layer.borderWidth = 1
            optionview.addSubview(imageview)
            radiobuttonImages.append(imageview)
            
            let radioText = UILabel()
            radioText.translatesAutoresizingMaskIntoConstraints = false
            radioText.text = optionTexts[i]
            radioText.font = UIFont(name: "Helvetica", size: 17)
            radioText.textColor = ColorTheme.lblBodySpecial2
            optionview.addSubview(radioText)
            
            let radiotextConstraints = [radioText.leftAnchor.constraint(equalTo: imageview.rightAnchor, constant: 20),
                                        radioText.centerYAnchor.constraint(equalTo: imageview.centerYAnchor),
                                        radioText.rightAnchor.constraint(equalTo: optionview.rightAnchor)]
            NSLayoutConstraint.activate(radiotextConstraints)
            
            
            let radioButton = UIButton()
            radioButton.translatesAutoresizingMaskIntoConstraints = false
            radioButton.tag = i
            optionview.addSubview(radioButton)
            
            let radiobuttonConstraints = [radioButton.leftAnchor.constraint(equalTo: imageview.leftAnchor),
                                          radioButton.topAnchor.constraint(equalTo: optionview.topAnchor),
                                          radioButton.rightAnchor.constraint(equalTo: radioText.rightAnchor),
                                          radioButton.bottomAnchor.constraint(equalTo: optionview.bottomAnchor)]
            
            NSLayoutConstraint.activate(radiobuttonConstraints)
            radioButton.addTarget(self, action: #selector(selectOptoin(_:)), for: .touchUpInside)
            backContainer.addSubview(optionview)
        }
    }
}

//MARK: - Radio Button Action
extension RecoveryQuestionOptionRadioBtnViewSelected {
    @objc private func selectOptoin(_ sender: UIButton) {

        print("Chathura option index question cell callback")
        optionviewCallBack!(true)
        return
    }
}

//MARK: - Set Option
extension RecoveryQuestionOptionRadioBtnViewSelected {
    func updateDefaultOption(at selectedOption: Int) {
        switch selectedOption {
        case 1, 2, 3:
            let _index = selectedOption - 1
            radiobuttonImages[_index].image = UIImage.fontAwesomeIcon(name: .dotCircle, style: .solid, textColor: greenColor, size: CGSize(width: 30, height: 30))
        default:
            for radios in radiobuttonImages {
                radios.image = nil
            }
            return
        }
    }
}

