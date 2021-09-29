//
//  RecoveryOptionQuestionView.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RecoveryOptionQuestionView: UIView {
    
    private var containerView: UIView!
    private var questiontextField: UITextField!
    private var questionBtn: UIButton!
    private var questionLabel: UILabel!
    private var downarrowImage: UIImageView!
    private var gapLabel: UILabel!
    
    var questioncallBack:  ((Bool?) -> ())?
    var answerCallBack: ((String) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setContainer()
        setTextView()
        setGapper()
        //setPickerViews()
    }
    
    func setQuestionAnswer(question: String, answer: String? = nil) {
        questionLabel.text = question
        
        if let _answer = answer {
            questiontextField.text = _answer
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Set Container View
extension RecoveryOptionQuestionView {
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

//MARK: - Set Text View
extension RecoveryOptionQuestionView {
    private func setTextView() {
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Down-arrow_tools")
        containerView.addSubview(downarrowImage)
        
        let downarrowimageConstraints = [downarrowImage.topAnchor.constraint(equalTo: containerView.topAnchor,constant: 5),
                                         downarrowImage.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -10),
                                         downarrowImage.heightAnchor.constraint(equalToConstant: 5),
                                         downarrowImage.widthAnchor.constraint(equalToConstant: 5)]
        NSLayoutConstraint.activate(downarrowimageConstraints)
        
        questionLabel = UILabel()
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.font = UIFont(name: "Helvetica", size: 15)
        questionLabel.textColor = ColorTheme.lblBodySpecial2
        questionLabel.minimumScaleFactor = 0.2
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.textAlignment = .left
        questionLabel.numberOfLines = 2
        containerView.addSubview(questionLabel)
        
        let recoveroptionlableConstraints = [questionLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                             questionLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
                                             questionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
        
        questionBtn = UIButton()
        questionBtn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(questionBtn)
        
        let questionbtnConstraints = [questionBtn.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                      questionBtn.topAnchor.constraint(equalTo: containerView.topAnchor),
                                      questionBtn.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                      questionBtn.bottomAnchor.constraint(equalTo: questionLabel.bottomAnchor)]
        NSLayoutConstraint.activate(questionbtnConstraints)
        
        questionBtn.addTarget(self, action: #selector(openquestionPicker(_:)), for: .touchUpInside)
        questionBtn.isUserInteractionEnabled = true
        
        questiontextField = UITextField()
        questiontextField.translatesAutoresizingMaskIntoConstraints = false
        questiontextField.delegate = self
        questiontextField.borderStyle = .roundedRect
        questiontextField.placeholder = "Answer"
        containerView.addSubview(questiontextField)
        
        let textfieldConstraints = [questiontextField.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                    questiontextField.topAnchor.constraint(equalTo: questionBtn.bottomAnchor,constant: 10),
                                    questiontextField.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                    questiontextField.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(textfieldConstraints)
        
        questiontextField.layer.shadowRadius = 1.5
        questiontextField.layer.shadowColor = UIColor.lightGray.cgColor
        questiontextField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        questiontextField.layer.shadowOpacity = 0.9
        questiontextField.layer.masksToBounds = false
        questiontextField.layer.cornerRadius = 8
        
        questiontextField.addTarget(self, action: #selector(textFieldValuechanged(_:)), for: .editingChanged)
        
        
        //containerView.bringSubview(toFront: questionBtn)
    }
}

//MARK: - Set Gap Label
extension RecoveryOptionQuestionView{
    private func setGapper() {
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(gapLabel)
        gapLabel.text = ""
        gapLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            gapLabel.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            gapLabel.topAnchor.constraint(equalTo: questiontextField.bottomAnchor),
            gapLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            gapLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
    }
}

//MARK: - TextField delegte methods
extension RecoveryOptionQuestionView: UITextFieldDelegate {
    @objc fileprivate func textFieldValuechanged(_ textField:UITextField) {
        if let _text = textField.text {
            answerCallBack!((_text.trim()))
        }
    }
}

//MARK: - Open Question Picker
extension RecoveryOptionQuestionView {
    @objc private func openquestionPicker(_ sender: UIButton) {
        print("Chathura picker opens for text feild ")
        questioncallBack!(true)
    }
    
    @objc private func testFunc(_ UIGesture: UIGestureRecognizer) {
        print("working")
    }
}
