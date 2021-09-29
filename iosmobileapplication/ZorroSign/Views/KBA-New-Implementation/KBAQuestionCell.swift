//
//  KBAQuestionCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class KBAQuestionCell: UITableViewCell {
    
    private let greencolor: UIColor = ColorTheme.btnBG
    
    private var questionText: UILabel!
    private var questionHelpText: UILabel!
    
    private var optionLabels: [UILabel] = []
    private var optionButtons: [UIButton] = []
    
    private var finalLabel: UILabel!
    
    var choiceCallBack: ((KBAAnswerQuestions?) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setquestionText()
        setquestionHelpText()
        setupAnswerOptions()
        setFinalLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var kbaQuestion: KBAQuestions! {
        didSet {
            if let _questionText = kbaQuestion.Text?.Statement {
                questionText.text = _questionText
            }
            
            if let _questionHelpText = kbaQuestion.HelpText?.Statement {
                questionHelpText.text = _questionHelpText
            }
            
            if let _choices = kbaQuestion.Choices {
                for i in 0..<_choices.count {
                    if let _choice = _choices[i].Text?.Statement {
                        optionLabels[i].text = _choice
                        optionButtons[i].setTitle(nil, for: .normal)
                    }
                }
            }
        }
    }
}

//MARK: - Setup Cell UI

//MARK: - Setup Question Text
extension KBAQuestionCell {
    
    private func setquestionText() {
        
        questionText = UILabel()
        questionText.translatesAutoresizingMaskIntoConstraints = false
        questionText.textAlignment = .left
        questionText.font = UIFont(name: "Helvetica-Bold", size: 18)
        questionText.adjustsFontSizeToFitWidth = true
        questionText.minimumScaleFactor = 0.2
        questionText.numberOfLines = 0
        questionText.text = "From whom did you purchase the property. the address listed may be partilal mispelled or contain miner numbering variations from your actual address"
        
        addSubview(questionText)
        
        let questionTextConstraints = [questionText.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
                                       questionText.topAnchor.constraint(equalTo: topAnchor, constant: 10),
                                       questionText.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(questionTextConstraints)
    }
}

//MARK: Setup Question Help Text
extension KBAQuestionCell {
    private func setquestionHelpText() {
        
        questionHelpText = UILabel()
        questionHelpText.translatesAutoresizingMaskIntoConstraints = false
        questionHelpText.textAlignment = .left
        questionHelpText.font = UIFont(name: "Helvetica", size: 18)
        questionHelpText.adjustsFontSizeToFitWidth = true
        questionHelpText.minimumScaleFactor = 0.2
        questionHelpText.numberOfLines = 0
        questionHelpText.text = "From whom did you purchase the property. the address listed may be partilal mispelled or contain miner numbering variations from your actual address"
        
        addSubview(questionHelpText)
        
        let questionHelpTextConstraints = [questionHelpText.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
                                           questionHelpText.topAnchor.constraint(equalTo: questionText.bottomAnchor, constant: 10),
                                           questionHelpText.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(questionHelpTextConstraints)
    }
}

//MARK: Setup Answer Options
extension KBAQuestionCell {
    private func setupAnswerOptions() {
        
        for i in 0..<5 {
            
            let _optionTextLabel = UILabel()
            _optionTextLabel.translatesAutoresizingMaskIntoConstraints = false
            _optionTextLabel.text = "Option 1"
            _optionTextLabel.numberOfLines = 0
            _optionTextLabel.font = UIFont(name: "Helvetica", size: 18)
            addSubview(_optionTextLabel)
            
            let _optionTextLabelCommonConstraints = [_optionTextLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
                                                _optionTextLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)]
            NSLayoutConstraint.activate(_optionTextLabelCommonConstraints)
            
            switch i {
            case 0:
                _optionTextLabel.topAnchor.constraint(equalTo: questionHelpText.bottomAnchor, constant: 10).isActive = true
            default:
                _optionTextLabel.topAnchor.constraint(equalTo: optionLabels[i-1].bottomAnchor, constant: 10).isActive = true
            }
            
            let _radioButton = UIButton()
            _radioButton.translatesAutoresizingMaskIntoConstraints = false
            _radioButton.backgroundColor = .white
            _radioButton.tag = i
            _radioButton.setTitleColor(greencolor, for: .normal)
            _radioButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
            addSubview(_radioButton)
            
            let radiobuttonConstraints = [_radioButton.centerYAnchor.constraint(equalTo: _optionTextLabel.centerYAnchor),
                                          _radioButton.rightAnchor.constraint(equalTo: _optionTextLabel.leftAnchor, constant: -5),
                                          _radioButton.widthAnchor.constraint(equalToConstant: 25),
                                          _radioButton.heightAnchor.constraint(equalToConstant: 25)]
            NSLayoutConstraint.activate(radiobuttonConstraints)
            
            _radioButton.layer.masksToBounds = false
            _radioButton.layer.cornerRadius = 25/2
            _radioButton.layer.borderColor = UIColor.lightGray.cgColor
            _radioButton.layer.borderWidth = 1
            
            _radioButton.addTarget(self, action: #selector(radioButtonAction(_:)), for: .touchUpInside)
            
            optionLabels.append(_optionTextLabel)
            optionButtons.append(_radioButton)
        }
    }
}

//MARK: Set final Label
extension KBAQuestionCell {
    private func setFinalLabel() {
        
        finalLabel = UILabel()
        finalLabel.translatesAutoresizingMaskIntoConstraints = false
        finalLabel.textColor = .white
        finalLabel.text = "........"
        
        addSubview(finalLabel)
        
        let finallabelConstraints = [finalLabel.leftAnchor.constraint(equalTo: leftAnchor),
                                     finalLabel.topAnchor.constraint(equalTo: optionLabels.last!.bottomAnchor, constant: 10),
                                     finalLabel.rightAnchor.constraint(equalTo: rightAnchor),
                                     finalLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)]
        NSLayoutConstraint.activate(finallabelConstraints)
    }
}

//MARK: - Radio Button Action
extension KBAQuestionCell {
    @objc private func radioButtonAction(_ sender: UIButton) {
        updateRadiobuttonUI(at: sender.tag)
    }
}

//MARK: - Update Radio Button UI
extension KBAQuestionCell {
    private func updateRadiobuttonUI(at index: Int) {
        DispatchQueue.main.async {
            for (_index, button) in self.optionButtons.enumerated() {
                if _index == index {
                    
                    button.setTitle(String.fontAwesomeIcon(name: .dotCircle), for: .normal)
                    
                    if let _questionid = self.kbaQuestion.QuestionId, let _choices = self.kbaQuestion.Choices {
                        
                        let kbaAnswerQuestion = KBAAnswerQuestions(Choices: [KBAAnswerQuestionChoices(Choice: _choices[_index].ChoiceId)], QuestionId: _questionid)
                        self.choiceCallBack!(kbaAnswerQuestion)
                    }
                } else {
                    button.setTitle(nil, for: .normal)
                }
            }
        }
    }
}
