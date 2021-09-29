//
//  OTPTimerView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class OTPTimerView: UIView {
    
    private var greenColor: UIColor = ColorTheme.btnBG
    
    private let deviceName = UIDevice.current.userInterfaceIdiom
    private var containerView: UIView!
    private var headerLabel: UILabel!
    private var fourdigitsView: UIView!
    private var errorMessageLabel: UILabel!
    
    private var digitViews: [UIView] = []
    private var bottomBars: [UIView] = []
    private var digitTextBoxes: [UITextField] = []
    
    private var countdownLabelText: UILabel!
    private var countdownLabel: UILabel!
    
    private var timer: Timer!
    private var countdown = 299
    
    var otpcallBack: ((Int?, Bool) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setContainer()
        setHeaderLabel()
        setfourDigitsView()
        setTextViews()
        setupErrormessageLabel()
        setcountdownLabel()
        startTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup Container View
extension OTPTimerView {
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

//MARK: - Setup Header Text Label
extension OTPTimerView {
    private func setHeaderLabel() {
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont(name: "Helvetica", size: 17)
        headerLabel.textAlignment = .left
        headerLabel.textColor = ColorTheme.lblBodySpecial2
        headerLabel.adjustsFontSizeToFitWidth = true
        headerLabel.minimumScaleFactor = 0.2
        headerLabel.numberOfLines = 2
        headerLabel.text = "We have sent you a SMS with 4-digits verification code to your registered number."
        containerView.addSubview(headerLabel)
        
        let headerlabelConstraints = [headerLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                      headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
                                      headerLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10)]
        
        NSLayoutConstraint.activate(headerlabelConstraints)
    }
}

//MARK: Setup Digits
extension OTPTimerView {
    private func setfourDigitsView() {
        
        fourdigitsView = UIView()
        fourdigitsView.translatesAutoresizingMaskIntoConstraints = false
        fourdigitsView.backgroundColor = .white
        containerView.addSubview(fourdigitsView)
        
        let _height = (UIScreen.main.bounds.width/2)/4
        
        let fourdigitsviewConstraints = [fourdigitsView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                         fourdigitsView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
                                         fourdigitsView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
                                         fourdigitsView.heightAnchor.constraint(equalToConstant: _height)]
        
        NSLayoutConstraint.activate(fourdigitsviewConstraints)
    }
}

//MARK: Setup Digits Text
extension OTPTimerView {
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

//MARK: - Setup Error Message
extension OTPTimerView {
    private func setupErrormessageLabel() {
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textColor = ColorTheme.lblError
        errorMessageLabel.textAlignment = .left
        errorMessageLabel.text = "The code you entered is incorrect, please try again."
        errorMessageLabel.font = UIFont(name: "Helvetica", size: 16)
        errorMessageLabel.adjustsFontSizeToFitWidth = true
        errorMessageLabel.minimumScaleFactor = 0.2
        errorMessageLabel.numberOfLines = 3
        errorMessageLabel.isHidden = true
        
        containerView.addSubview(errorMessageLabel)
        
        let errormessagelabelConstraints = [errorMessageLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                            errorMessageLabel.topAnchor.constraint(equalTo: fourdigitsView.bottomAnchor, constant: 5),
                                            errorMessageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor)]
        NSLayoutConstraint.activate(errormessagelabelConstraints)
    }
}

//MARK: TextField Delegates
extension OTPTimerView: UITextFieldDelegate {
    
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
extension OTPTimerView {
    private func getotpintValue(){
        var _otpstring = ""
        var _otpvalue: Int = 0
        
        for _textfield in digitTextBoxes {
            if let _text = _textfield.text {
                _otpstring += _text
            }
        }
        _otpvalue = Int(_otpstring)!
        otpcallBack!(_otpvalue, false)
        return
    }
}

//MARK: Set Countdown Label
extension OTPTimerView {
    private func setcountdownLabel() {
        countdownLabelText = UILabel()
        countdownLabelText.translatesAutoresizingMaskIntoConstraints = false
        countdownLabelText.font = UIFont(name: "Helvetica", size: 18)
        countdownLabelText.text = "Code expires in "
        countdownLabelText.textColor = ColorTheme.lblBodyDefault
        containerView.addSubview(countdownLabelText)
        
        let countdownlabeltextConstraints = [countdownLabelText.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10),
                                         countdownLabelText.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10)]
        NSLayoutConstraint.activate(countdownlabeltextConstraints)
        
        countdownLabel = UILabel()
        countdownLabel.translatesAutoresizingMaskIntoConstraints = false
        countdownLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        countdownLabel.text = "04:59"
        countdownLabel.textColor = ColorTheme.lblBodyDefault
        containerView.addSubview(countdownLabel)
        
        let countdownlabelConstraitns = [countdownLabel.leftAnchor.constraint(equalTo: countdownLabelText.rightAnchor, constant: 10),
                                         countdownLabel.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 10)]
        NSLayoutConstraint.activate(countdownlabelConstraitns)
    }
}

//MARK: Update the timer
extension OTPTimerView {
    @objc private func updateTimer() {
        if countdown > 0 {
            let minutes = String(countdown/60)
            let _seconds = countdown%60
            var seconds = String(_seconds)
            
            if _seconds < 10 {
                seconds = "0" + String(_seconds)
            }
            
            countdownLabel.text = "0" + minutes + ":" + seconds
            countdown -= 1
            return
        }
        print(timer)
        if timer != nil {
            countdownLabel.text = "00:00"
            timer.invalidate()
            otpcallBack!(nil, true)
        }
        
    }
}

//MARK: Start Timer
extension OTPTimerView {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
}

//MARK: Update UI For Errors
extension OTPTimerView {
    func updatetimerUIForError(message: String) {
        DispatchQueue.main.async {
            self.errorMessageLabel.textColor = .red
            self.errorMessageLabel.text = message
            self.errorMessageLabel.isHidden = false
            for i in 0..<self.digitViews.count {
                self.bottomBars[i].backgroundColor = ColorTheme.imgTint
            }
        }
    }
}

//MARK: Clear Text Fields
extension OTPTimerView {
    func cleartextBoxes() {
        DispatchQueue.main.async {
            self.countdown = 299
            self.timer.invalidate()
            self.startTimer()
            self.errorMessageLabel.isHidden = true
            for i in 0..<self.digitViews.count {
                self.digitTextBoxes[i].text = ""
                self.bottomBars[i].backgroundColor = ColorTheme.imgTint
            }
        }
    }
}

//MARK: Update UI For Infor Messages
extension OTPTimerView {
    func updatetimerUIForInfo(message: String) {
        DispatchQueue.main.async {
            self.errorMessageLabel.textColor = ColorTheme.imgTint
            self.errorMessageLabel.text = message
            self.errorMessageLabel.isHidden = false
            for i in 0..<self.digitViews.count {
                self.bottomBars[i].backgroundColor = ColorTheme.imgTint
            }
        }
    }
}

//MARK: Update Header Text
extension OTPTimerView {
    func updateHeaderText(mobilenumber: String?) {
        if let _mobilenumber = mobilenumber {
            DispatchQueue.main.async {
                self.headerLabel.text = "We have sent you a SMS with 4-digits verification code to \(_mobilenumber)"
            }
        }
    }
}
