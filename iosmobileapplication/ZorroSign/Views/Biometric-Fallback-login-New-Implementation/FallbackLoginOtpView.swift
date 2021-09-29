//
//  FallbackLoginOtpView.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 6/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class FallbackLoginOtpView: UIView {
    
    private var greenColor: UIColor = ColorTheme.btnBG
    private let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var containerView: UIView!
    private var fourdigitsView: UIView!
    private var digitViews: [UIView] = []
    private var bottomBars: [UIView] = []
    private var digitTextBoxes: [UITextField] = []
    
    var otpcallBack: ((Int?) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setContainer()
        setfourDigitsView()
        setTextViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Container View
extension FallbackLoginOtpView {
    private func setContainer() {
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        addSubview(containerView)
        
        let containerviewConstraints = [containerView.leftAnchor.constraint(equalTo: leftAnchor),
                                        containerView.topAnchor.constraint(equalTo: topAnchor),
                                        containerView.rightAnchor.constraint(equalTo: rightAnchor),
                                        containerView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(containerviewConstraints)
        
    }
}

//MARK: Setup Digits
extension FallbackLoginOtpView {
    private func setfourDigitsView() {
        
        fourdigitsView = UIView()
        fourdigitsView.translatesAutoresizingMaskIntoConstraints = false
        fourdigitsView.backgroundColor = .white
        containerView.addSubview(fourdigitsView)
        
        let _height = (UIScreen.main.bounds.width/2)/4
        
        let fourdigitsviewConstraints = [fourdigitsView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                         fourdigitsView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                         fourdigitsView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                         fourdigitsView.heightAnchor.constraint(equalToConstant: _height)]
        
        NSLayoutConstraint.activate(fourdigitsviewConstraints)
    }
}

//MARK: Setup Digits Text
extension FallbackLoginOtpView {
    private func setTextViews() {
        
        let _startPoint: CGFloat = 10.0
        var  _width = (UIScreen.main.bounds.width/2)/4
        
        if deviceName == .pad  {
            _width = (UIScreen.main.bounds.width/3)/4
        }
        
        for i in 0..<4 {
            let _gap = _startPoint * CGFloat(i) + (_width * CGFloat(i))
            let _digittextView = UIView(frame: CGRect(x: _gap, y: 0, width: _width, height: _width))
            _digittextView.backgroundColor = .white
            _digittextView.tag = i
            
            let _inidicatorHeight: CGFloat = 3.0
            let _inidicatorY: CGFloat = _width - _inidicatorHeight
            let _bottomIndicatorView = UIView(frame: CGRect(x: 0, y: _inidicatorY, width: _width, height: _inidicatorHeight))
            _bottomIndicatorView.backgroundColor = ColorTheme.imgTint
            _digittextView.addSubview(_bottomIndicatorView)
            
            let _textboxHeight: CGFloat = _width - 3.0
            let _textBox = UITextField(frame: CGRect(x: 0, y: 0, width: _width, height: _textboxHeight))
            _textBox.borderStyle = .none
            _textBox.textAlignment = .center
            _textBox.keyboardType = .numberPad
            _textBox.placeholder = "●"
            _textBox.font = UIFont(name: "Helvetica", size: 18)
            _textBox.delegate = self
            _textBox.tag = i
            _textBox.addTarget(self, action: #selector(changedTextField(_:)), for: .editingChanged)
            _digittextView.addSubview(_textBox)
            
            bottomBars.append(_bottomIndicatorView)
            digitTextBoxes.append(_textBox)
            digitViews.append(_digittextView)
            fourdigitsView.addSubview(_digittextView)
            
        }
    }
}

//MARK: TextField Delegates
extension FallbackLoginOtpView: UITextFieldDelegate {
    
    @objc private func changedTextField(_ textField: UITextField) {
        
        let tag = textField.tag
        
        if let _text = textField.text {
            if _text.count == 1 {
                if tag <= 2 {
                    digitTextBoxes[tag+1].becomeFirstResponder()
                }
                getotpintValue()
                return
            }
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

//MARK: Get OTP Int Value
extension FallbackLoginOtpView {
    private func getotpintValue(){
        var _otpstring = ""
        var _otpvalue: Int = 0
        
        for _textfield in digitTextBoxes {
            if let _text = _textfield.text {
                _otpstring += _text
            }
        }
        _otpvalue = Int(_otpstring)!
        otpcallBack!(_otpvalue)
        return
    }
}
