//
//  KBASSNView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class KBASSNView: UIView {
    
    private var title: String!
    private var ssnWidth: CGFloat!
    
    private var ssnContainerView: UIView!
    private var ssnTitle: UILabel!
    private var ssnBoxContainer: UIView!
    
    private var ssnBoxes: [UITextField] = []
    var ssnCallBack: ((Int) -> ())?
    
    init(title: String, ssnWidth: CGFloat) {
        super.init(frame: .zero)
        
        self.title = title
        self.ssnWidth = ssnWidth
        
        setupSSNContainer()
        setssnTitle()
        setssnBoxContainer()
        setssnTextBoxes()
        setssnTextboxSeparator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup SSN Container
extension KBASSNView {
    private func setupSSNContainer() {
        
        ssnContainerView = UIView()
        ssnContainerView.translatesAutoresizingMaskIntoConstraints = false
        ssnContainerView.backgroundColor = .white
        
        addSubview(ssnContainerView)
        
        let ssncontainerviewConstraints = [ssnContainerView.leftAnchor.constraint(equalTo: leftAnchor),
                                           ssnContainerView.topAnchor.constraint(equalTo: topAnchor),
                                           ssnContainerView.rightAnchor.constraint(equalTo: rightAnchor),
                                           ssnContainerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(ssncontainerviewConstraints)
    }
}

//MARK: - Setup SSN Title
extension KBASSNView {
    private func setssnTitle() {
        
        ssnTitle = UILabel()
        ssnTitle.translatesAutoresizingMaskIntoConstraints = false
        ssnTitle.font = UIFont(name: "Helvetica", size: 18)
        ssnTitle.text = title
        ssnTitle.textAlignment = .left
        
        ssnContainerView.addSubview(ssnTitle)
        
        let ssntitleConstraints = [ssnTitle.leftAnchor.constraint(equalTo: ssnContainerView.leftAnchor),
                                   ssnTitle.topAnchor.constraint(equalTo: ssnContainerView.topAnchor),
                                   ssnTitle.rightAnchor.constraint(equalTo: ssnContainerView.rightAnchor)]
        NSLayoutConstraint.activate(ssntitleConstraints)
    }
}

//MARK: - Setup SSN Text Container
extension KBASSNView {
    private func setssnBoxContainer() {
        
        ssnBoxContainer = UIView()
        ssnBoxContainer.translatesAutoresizingMaskIntoConstraints = false
        ssnBoxContainer.backgroundColor = .white
        
        ssnContainerView.addSubview(ssnBoxContainer)
        
        let ssnboxContainerConstraints = [ssnBoxContainer.leftAnchor.constraint(equalTo: ssnContainerView.leftAnchor),
                                          ssnBoxContainer.topAnchor.constraint(equalTo: ssnTitle.bottomAnchor, constant: 10),
                                          ssnBoxContainer.rightAnchor.constraint(equalTo: ssnContainerView.rightAnchor),
                                          ssnBoxContainer.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(ssnboxContainerConstraints)
    }
}

//MARK: - Setup SSN Text Boxes
extension KBASSNView {
    private func setssnTextBoxes() {
        
        let _betweenGap: CGFloat = 5.0
        let _widthHeight = (ssnWidth - 55)/9
        
        for i in 0..<9 {
            var _textboxGap = CGFloat(i) * (_widthHeight + _betweenGap)
            
            switch i {
            case 3, 4:
                _textboxGap += 5
            case 5, 6, 7, 8:
                _textboxGap += 10
            default:
                _textboxGap += 0
            }
            
            let _textBox = UITextField(frame: CGRect(x: _textboxGap, y: 0, width: _widthHeight, height: _widthHeight))
            _textBox.borderStyle = .roundedRect
            _textBox.textAlignment = .center
            _textBox.font = UIFont(name: "Helvetica", size: 18)
            _textBox.keyboardType = .numberPad
            _textBox.tag = i
            _textBox.delegate = self
            _textBox.addTarget(self, action: #selector(textfieldDidChanged(_:)), for: .editingChanged)
            
            ssnBoxContainer.addSubview(_textBox)
            ssnBoxes.append(_textBox)
        }
    }
}

//MARK: - Setup Text Box Separator
extension KBASSNView {
    private func setssnTextboxSeparator() {
        
        var _separatorx: CGFloat
        var _separatorWidth: CGFloat
        let _separatorHieght: CGFloat = 2.0
        var _separatory: CGFloat
        
        for i in 0..<2 {
            switch i {
            case 0:
                
                _separatorx = ssnBoxes[2].frame.maxX + 1
                _separatorWidth = (ssnBoxes[3].frame.minX - ssnBoxes[2].frame.maxX) - 2
                _separatory = ssnBoxes[2].frame.height/2
                
                let separatorView = UIView(frame: CGRect(x: _separatorx, y: _separatory, width: _separatorWidth, height: _separatorHieght))
                separatorView.backgroundColor = .lightGray
                
                ssnBoxContainer.addSubview(separatorView)
            case 1:
                
                _separatorx = ssnBoxes[4].frame.maxX + 1
                _separatorWidth = (ssnBoxes[5].frame.minX - ssnBoxes[4].frame.maxX) - 2
                _separatory = ssnBoxes[4].frame.height/2
                
                let separatorView = UIView(frame: CGRect(x: _separatorx, y: _separatory, width: _separatorWidth, height: _separatorHieght))
                separatorView.backgroundColor = .lightGray
                
                ssnBoxContainer.addSubview(separatorView)
            default:
                return
            }
        }
    }
}

//MARK: - Text Field Delegate Methods
extension KBASSNView: UITextFieldDelegate {
    
    @objc private func textfieldDidChanged(_ textField: UITextField) {
        
        let tag = textField.tag
        
        if let _text = textField.text {
            if _text.count == 1 {
                
                if tag <= 7 {
                   ssnBoxes[tag+1].becomeFirstResponder()
                }
                getfullSSN()
                return
            }
            return
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let _text = textField.text, let _textRange = Range(range, in: _text){
            let _updatedText = _text.replacingCharacters(in: _textRange, with: string)
            
            if _updatedText.count > 1 {
                return false
            }
        }
        return true
    }
}

//MARK: - Get Full SSN
extension KBASSNView {
    private func getfullSSN() {
        var _ssn = ""
        
        for _textfield in ssnBoxes {
            if let _text = _textfield.text {
                _ssn += _text
            }
        }
        
        let _intValue = Int(_ssn) ?? 0
        ssnCallBack!(_intValue)
        return
    }
}


