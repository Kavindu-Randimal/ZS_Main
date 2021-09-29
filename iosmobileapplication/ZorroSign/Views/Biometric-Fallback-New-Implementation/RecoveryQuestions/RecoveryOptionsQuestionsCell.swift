//
//  RecoveryOptionsQuestionsCell.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/1/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol RecoveryOptionsQuestionsCellDelegate {
    func getAnswer(questionNo: Int, answer: String)
    func didTapOnSaveButton()
    func openQuestionsVC(selectedQuestion index: Int, isAvailable: Bool)
}

class RecoveryOptionsQuestionsCell: UITableViewCell {
    let greencolor: UIColor = ColorTheme.btnBG
    let lightgray: UIColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
    let deviceWidth: CGFloat = UIScreen.main.bounds.width
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    private var recoveryquestionsBaseContainer: UIView!
    private var recoeveryemailOption: RecoveryEmailOptionRadioBtnViewNotSelected!
    private var recoeveryquestionoption: RecoveryQuestionOptionRadioBtnViewSelected!
    private var recoveryoptionquestionView1: RecoveryOptionQuestionView!
    private var recoveryoptionquestionView2: RecoveryOptionQuestionView!
    private var recoveryoptionquestionView3: RecoveryOptionQuestionView!
    private var recoveryoptionBtn: UIButton!
    private var downarrowImage: UIImageView!
    private var recoveryoptionLabel: UILabel!
    private var selectionarrowImage: UIImageView!
    
    private var saveView: UIView!
    private var optionSeparatorView: UIView!
    private var saveSeparator: UIView!
    private var saveButton: UIButton!
    private var savebuttonActivityIndicator: UIActivityIndicatorView!
    
    private var question1textField: UITextField!
    private var question1Btn: UIButton!
    private var question1Label: UILabel!
    
    private var question2textField: UITextField!
    private var question2Btn: UIButton!
    private var question2Label: UILabel!
    
    private var question3textField: UITextField!
    private var question3Btn: UIButton!
    private var question3Label: UILabel!
    
    private var gapLabel: UILabel!
    
    var delegate : RecoveryOptionsQuestionsCellDelegate?
    var arrSecurityQuestionsAndAnswers: [SecurityQuestion]?
    
    var multifactortwofasettingsCallBack: ((MultifactorSettingsViewModel?, Bool) -> ())?
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.isUserInteractionEnabled = true
        backgroundColor = lightgray
        selectionStyle = .none
        setenteremailcellUI()
    }
    
    override func layoutSubviews() {
        setValues()
        removeObservers()
        addObservers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    var recoveryoptionsFallback: MultifactorSettingsViewModel? {
        didSet {
            if let recoveryoptionsubType = recoveryoptionsFallback?.recoveryoptionsubType {
                
            }
        }
    }
    
    deinit {
        removeObservers()
    }
    
    // MARK: - Notification Observers
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.startAnimating(notification:)), name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimating(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        
        //StopAnimatingBeforeFallbackPathNotification
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopAnimatingbeforeFallbackPath(notification:)), name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotification"), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StartAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "StopAnimatingBeforeFallbackPathNotification"), object: nil)
    }
    
    // MARK: - Animating Funtions
    
    @objc func startAnimating(notification: Notification) {
        savebuttonActivityIndicator.startAnimating()
    }
    
    @objc func stopAnimating(notification: Notification) {
        print("Chathura notfication question stop ", notification.object as! Bool)
        savebuttonActivityIndicator.stopAnimating()
        showAlertNotification(isSuccess: (notification.object != nil))
        
        if (notification.object != nil) {
            self.recoveryoptionsFallback?.recoveryOptionSelected = 0
            self.multifactortwofasettingsCallBack!(self.recoveryoptionsFallback, false)
        }
    }
    
    @objc func stopAnimatingbeforeFallbackPath(notification: Notification) {
        savebuttonActivityIndicator.stopAnimating()
    }
      
    func showAlertNotification(isSuccess: Bool) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ShowAlert"), object: isSuccess, userInfo: nil)
    }
}

//MARK: - Recovery Email Cell Ui
extension RecoveryOptionsQuestionsCell {
    private func setenteremailcellUI() {
        
        setEmailOptionBaseContainer()
        setHeader()
        setRecoveryEmailOption()
        setSecurityQuestionOption()
        setQuestionView()
        setOptionSeparator()
        setSaveView()
        setGapper()
    }
}

//MARK: - Set email base container
extension RecoveryOptionsQuestionsCell {
    private func setEmailOptionBaseContainer() {
        
        recoveryquestionsBaseContainer = UIView()
        recoveryquestionsBaseContainer.translatesAutoresizingMaskIntoConstraints = false
        recoveryquestionsBaseContainer.backgroundColor = .white
        
        addSubview(recoveryquestionsBaseContainer)
        
        let basecontainerConstraints = [recoveryquestionsBaseContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5),
                                        recoveryquestionsBaseContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
                                        recoveryquestionsBaseContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5),
                                        recoveryquestionsBaseContainer.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(basecontainerConstraints)
        recoveryquestionsBaseContainer.setShadow()
    }
}

//MARK: - Setup Header UI
extension RecoveryOptionsQuestionsCell {
    private func setHeader() {
        
        recoveryoptionBtn = UIButton()
        recoveryoptionBtn.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionBtn.backgroundColor = .white
        recoveryquestionsBaseContainer.addSubview(recoveryoptionBtn)
        
        let recoveryoptionbtnConstraints = [recoveryoptionBtn.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor, constant: 10),
                                            recoveryoptionBtn.topAnchor.constraint(equalTo: recoveryquestionsBaseContainer.topAnchor, constant: 15),
                                            recoveryoptionBtn.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(recoveryoptionbtnConstraints)
        
        recoveryoptionBtn.addTarget(self, action: #selector(selectRecoveryOptions(_:)), for: .touchUpInside)
        
        downarrowImage = UIImageView()
        downarrowImage.translatesAutoresizingMaskIntoConstraints = false
        downarrowImage.backgroundColor = .clear
        downarrowImage.contentMode = .center
        downarrowImage.image = UIImage(named: "Up-Arrow_tools")
        recoveryquestionsBaseContainer.addSubview(downarrowImage)
        
        let downarrowimageConstraints = [downarrowImage.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor),
                                         downarrowImage.rightAnchor.constraint(equalTo: recoveryoptionBtn.rightAnchor,constant: -10),
                                         downarrowImage.heightAnchor.constraint(equalToConstant: 10),
                                         downarrowImage.widthAnchor.constraint(equalToConstant: 10)]
        NSLayoutConstraint.activate(downarrowimageConstraints)
        
        recoveryoptionLabel = UILabel()
        recoveryoptionLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryoptionLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        recoveryoptionLabel.textColor = ColorTheme.lblBodySpecial2
        recoveryoptionLabel.numberOfLines = 0
        recoveryoptionLabel.text = "Recovery Options*"
        recoveryquestionsBaseContainer.addSubview(recoveryoptionLabel)
        
        let recoveroptionlableConstraints = [recoveryoptionLabel.leftAnchor.constraint(equalTo: recoveryoptionBtn.leftAnchor),
                                             recoveryoptionLabel.rightAnchor.constraint(equalTo: downarrowImage.leftAnchor),
                                             recoveryoptionLabel.topAnchor.constraint(equalTo: recoveryoptionBtn.topAnchor)]
        NSLayoutConstraint.activate(recoveroptionlableConstraints)
    }
}

//MARK: - Set recoevry email option
extension RecoveryOptionsQuestionsCell {
    private func setRecoveryEmailOption() {
        
        recoeveryemailOption = RecoveryEmailOptionRadioBtnViewNotSelected(optiontexts: ["Recovery Email Address"])
        recoeveryemailOption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryemailOption.backgroundColor = .white
        recoveryquestionsBaseContainer.addSubview(recoeveryemailOption)
        
        let recoveryoptionsviewConstraints = [
            recoeveryemailOption.leftAnchor.constraint(equalTo:recoveryquestionsBaseContainer.leftAnchor,constant: 15),
            recoeveryemailOption.topAnchor.constraint(equalTo: recoveryoptionBtn.bottomAnchor,constant: 5),
            recoeveryemailOption.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor,constant: -5),
            recoeveryemailOption.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(recoveryoptionsviewConstraints)
        
        recoeveryemailOption.optionviewCallBack =  { [weak self] (recoveryemailSelected) in
            if recoveryemailSelected {
                print("Chathura fallback otp")
                self?.recoveryoptionsFallback?.recoveryOptionType = 1
                self?.recoveryoptionsFallback?.recoveryoptionsubType = 0
                self?.recoveryoptionsFallback?.recoveryOptionSelected = 1
                self?.multifactortwofasettingsCallBack!(self!.recoveryoptionsFallback, false)
            }
            return
        }
    }
}

//MARK: - Set security question
extension RecoveryOptionsQuestionsCell {
    private func setSecurityQuestionOption() {
        
        recoeveryquestionoption = RecoveryQuestionOptionRadioBtnViewSelected(optiontexts: ["Security Questions"])
        recoeveryquestionoption.translatesAutoresizingMaskIntoConstraints = false
        recoeveryquestionoption.backgroundColor = .white
        recoveryquestionsBaseContainer.addSubview(recoeveryquestionoption)
        
        let recoveryquestionsviewConstraints = [recoeveryquestionoption.leftAnchor.constraint(equalTo:recoveryquestionsBaseContainer.leftAnchor,constant: 15),
                                                recoeveryquestionoption.topAnchor.constraint(equalTo: recoeveryemailOption.bottomAnchor,constant: 10),
                                                recoeveryquestionoption.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor,constant: -5),
                                                recoeveryquestionoption.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(recoveryquestionsviewConstraints)
        
        recoeveryquestionoption.optionviewCallBack =  { [weak self] (recoveryemailSelected) in
            if recoveryemailSelected {
                print("Chathura fallback question pressed")
            }
            return
        }
    }
}

//MARK: - Questions View
extension RecoveryOptionsQuestionsCell {
    
    private func setQuestionView() {
        
        recoveryoptionquestionView1 = RecoveryOptionQuestionView()
        
        recoveryoptionquestionView1.translatesAutoresizingMaskIntoConstraints = false
        recoveryquestionsBaseContainer.addSubview(recoveryoptionquestionView1)
        
        let recoveryquestion1viewConstraints = [
            recoveryoptionquestionView1.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor,constant: 10),
            recoveryoptionquestionView1.topAnchor.constraint(equalTo: recoeveryquestionoption.bottomAnchor,constant: 10),
            recoveryoptionquestionView1.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(recoveryquestion1viewConstraints)
        
        recoveryoptionquestionView2 = RecoveryOptionQuestionView()
        
        recoveryoptionquestionView2.translatesAutoresizingMaskIntoConstraints = false
        recoveryquestionsBaseContainer.addSubview(recoveryoptionquestionView2)
        
        let recoveryquestion2viewConstraints = [
            recoveryoptionquestionView2.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor,constant: 10),
            recoveryoptionquestionView2.topAnchor.constraint(equalTo: recoveryoptionquestionView1.bottomAnchor,constant: 10),
            recoveryoptionquestionView2.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(recoveryquestion2viewConstraints)
        
        recoveryoptionquestionView3 = RecoveryOptionQuestionView()
        
        recoveryoptionquestionView3.translatesAutoresizingMaskIntoConstraints = false
        recoveryquestionsBaseContainer.addSubview(recoveryoptionquestionView3)
        
        let recoveryquestion3viewConstraints = [
            recoveryoptionquestionView3.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor,constant: 10),
            recoveryoptionquestionView3.topAnchor.constraint(equalTo: recoveryoptionquestionView2.bottomAnchor,constant: 10),
            recoveryoptionquestionView3.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor,constant: -10)]
        NSLayoutConstraint.activate(recoveryquestion3viewConstraints)
        
        // MARK: - Open Questions
        
        
        
        recoveryoptionquestionView1.questioncallBack = { [weak self] (trigger) in
            print("Chathura text Feild one selected",trigger as Any)
            if trigger! {
                self?.delegate?.openQuestionsVC(selectedQuestion: 1, isAvailable: (self?.arrSecurityQuestionsAndAnswers?.getElement(at: 0)?.questionModel == nil) ? false : true)
            }
        }
        
        recoveryoptionquestionView2.questioncallBack = { [weak self] (trigger) in
            print("Chathura text Feild two selected",trigger as Any)
            if trigger! {
                self?.delegate?.openQuestionsVC(selectedQuestion: 2, isAvailable: (self?.arrSecurityQuestionsAndAnswers?.getElement(at: 1)?.questionModel == nil) ? false : true)
            }
        }
        
        recoveryoptionquestionView3.questioncallBack = { [weak self] (trigger) in
            print("Chathura text Feild three selected",trigger as Any)
            if trigger! {
                self?.delegate?.openQuestionsVC(selectedQuestion: 3, isAvailable: (self?.arrSecurityQuestionsAndAnswers?.getElement(at: 2)?.questionModel == nil) ? false : true)
            }
        }
        
        // MARK: - Send back the ANSWERS
        
        recoveryoptionquestionView1.answerCallBack = { [weak self] (answer) in
            self?.delegate?.getAnswer(questionNo: 1, answer: answer)
        }
        recoveryoptionquestionView2.answerCallBack = { [weak self] (answer) in
            self?.delegate?.getAnswer(questionNo: 2, answer: answer)
        }
        recoveryoptionquestionView3.answerCallBack = { [weak self] (answer) in
            self?.delegate?.getAnswer(questionNo: 3, answer: answer)
        }
    }
    
    // MARK: - Set Values
    
    func setValues() {
        setValues(to: recoveryoptionquestionView1, array: arrSecurityQuestionsAndAnswers, questionNo: 1)
        setValues(to: recoveryoptionquestionView2, array: arrSecurityQuestionsAndAnswers, questionNo: 2)
        setValues(to: recoveryoptionquestionView3, array: arrSecurityQuestionsAndAnswers, questionNo: 3)
    }
    
    func setValues(to view: RecoveryOptionQuestionView, array: [SecurityQuestion]?, questionNo: Int) {
        
        if let _questionPart = array?.getElement(at: questionNo - 1), let _question = _questionPart.questionModel?.questionPart?.Question {
            if let _answer = _questionPart.answer {
                view.setQuestionAnswer(question: _question, answer: _answer)
            } else {
                view.setQuestionAnswer(question: _question)
            }
        } else {
            view.setQuestionAnswer(question: "Select \(questionNo.toString().lowercased()) question")
        }
    }
}

//MARK: - Setup option separator
extension RecoveryOptionsQuestionsCell {
    
    private func setOptionSeparator() {
        
        optionSeparatorView = UIView()
        optionSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        optionSeparatorView.backgroundColor = .clear
        
        recoveryquestionsBaseContainer.addSubview(optionSeparatorView)
        
        let optionseparatorviewConstriants = [optionSeparatorView.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor),
                                              optionSeparatorView.topAnchor.constraint(equalTo: recoveryoptionquestionView3.bottomAnchor, constant: 15),
                                              optionSeparatorView.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor),
                                              optionSeparatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(optionseparatorviewConstriants)
    }
    
    private func setGapper() {
        
        gapLabel = UILabel()
        gapLabel.translatesAutoresizingMaskIntoConstraints = false
        recoveryquestionsBaseContainer.addSubview(gapLabel)
        gapLabel.text = "..."
        gapLabel.textColor = .white
        
        NSLayoutConstraint.activate([
            gapLabel.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor),
            gapLabel.topAnchor.constraint(equalTo: saveView.bottomAnchor),
            gapLabel.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor),
            gapLabel.bottomAnchor.constraint(equalTo: recoveryquestionsBaseContainer.bottomAnchor,constant: 15)
        ])
        
    }
}

//MARK: - Setup Save UI
extension RecoveryOptionsQuestionsCell {
    private func setSaveView() {
        
        saveView = UIView()
        saveView.translatesAutoresizingMaskIntoConstraints = false
        saveView.backgroundColor = .white
        
        recoveryquestionsBaseContainer.addSubview(saveView)
        
        let saveviewConstraints = [saveView.leftAnchor.constraint(equalTo: recoveryquestionsBaseContainer.leftAnchor),
                                   saveView.topAnchor.constraint(equalTo: optionSeparatorView.bottomAnchor),
                                   saveView.rightAnchor.constraint(equalTo: recoveryquestionsBaseContainer.rightAnchor),
                                   saveView.heightAnchor.constraint(equalToConstant: 55)]
        
        NSLayoutConstraint.activate(saveviewConstraints)
        
        saveSeparator = UIView()
        saveSeparator.translatesAutoresizingMaskIntoConstraints = false
        saveSeparator.backgroundColor = .lightGray
        saveView.addSubview(saveSeparator)
        
        let saveseparatorConstraints = [saveSeparator.leftAnchor.constraint(equalTo: saveView.leftAnchor),
                                        saveSeparator.topAnchor.constraint(equalTo: saveView.topAnchor),
                                        saveSeparator.rightAnchor.constraint(equalTo: saveView.rightAnchor),
                                        saveSeparator.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(saveseparatorConstraints)
        
        saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = ColorTheme.btnBG
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        saveButton.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        
        saveView.addSubview(saveButton)
        
        let savebuttonConstraints = [saveButton.centerYAnchor.constraint(equalTo: saveView.centerYAnchor),
                                     saveButton.leftAnchor.constraint(equalTo: saveView.leftAnchor, constant: 10),
                                     saveButton.rightAnchor.constraint(equalTo: saveView.rightAnchor, constant: -10),
                                     saveButton.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(savebuttonConstraints)
        
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(fallbackquestionsSaveAction(_:)), for: .touchUpInside)
        
        savebuttonActivityIndicator = UIActivityIndicatorView(style: .white)
        savebuttonActivityIndicator.color = ColorTheme.activityindicatorSpecial
        savebuttonActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addSubview(savebuttonActivityIndicator)
        
        let savebuttonactivityindicatorConstraints = [savebuttonActivityIndicator.centerYAnchor.constraint(equalTo: saveButton.centerYAnchor),
                                                      savebuttonActivityIndicator.rightAnchor.constraint(equalTo: saveButton.rightAnchor, constant: -10),
                                                      savebuttonActivityIndicator.widthAnchor.constraint(equalToConstant: 25),
                                                      savebuttonActivityIndicator.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(savebuttonactivityindicatorConstraints)
    }
}

//MARK: - Save multi settings
extension RecoveryOptionsQuestionsCell {
    @objc
    func fallbackquestionsSaveAction(_ sender: UIButton) {
        print("Chathura save fallback questions")
        delegate?.didTapOnSaveButton()
    }
}

//MARK: - Select recovery options method
extension RecoveryOptionsQuestionsCell {
    @objc func selectRecoveryOptions(_ sender: UIButton) {
        print("Chathura print recovery options deselect 1")
        if let recoveryoptionSelected = recoveryoptionsFallback?.recoveryOptionSelected {
            if recoveryoptionSelected == 0 {
                recoveryoptionsFallback?.recoveryOptionSelected = 1
                recoveryoptionsFallback?.recoveryOptionType = 2
            } else {
                recoveryoptionsFallback?.recoveryOptionSelected = 0
                recoveryoptionsFallback?.recoveryOptionType = 2
            }
            if recoveryoptionsFallback?.approvalSwitch ?? false {
                recoveryoptionsFallback?.subStep = 1
            }
        }
        multifactortwofasettingsCallBack!(recoveryoptionsFallback, false)
    }
}
