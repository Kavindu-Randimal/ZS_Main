//
//  KBAQuestionsController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 10/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class KBAQuestionsController: KBABaseController {
    
    private var mainTitle: UILabel!
    private var subTitle: UILabel!
    private var timerLabel: UILabel!
    
    private var bottomView: UIView!
    private var separatorView: UIView!
    private var continueButon: UIButton!
    
    private var questionTableView: UITableView!
    private var questiondefaultcellIdentifier: String = "questiondefaultcellIdentifier"
    
    private var KBAquestions: [KBAQuestions] = []
    private var _KBAAnswerRequest: KBAAnswerRequest?
    private var _KBAAnswers: KBAAnswers?
    
    private var _instanceId: Int?
    private var _ssn: Int?
    private var _stepId: Int?
    private var _secondAttempt: Bool = false
    
    private var timer: Timer!
    private var countDown: Int = 270
    private var secondAttempt: Bool = false
    
    var questionCallBack: ((Bool, String?) -> ())?
    
    
    init(instanceid: Int, ssn: Int, stepid: Int) {
        super.init(nibName: nil, bundle: nil)
        
        self._instanceId = instanceid
        self._ssn = ssn
        self._stepId = stepid
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setMainTitle()
        setSubTitle()
        setBottomView()
        setQuestionTableView()
        fetchQuestion()
    }
}

extension KBAQuestionsController {
    private func setMainTitle() {
        
        let safearea = view.safeAreaLayoutGuide
        
        mainTitle = UILabel()
        mainTitle.translatesAutoresizingMaskIntoConstraints = false
        mainTitle.textAlignment = .left
        mainTitle.numberOfLines = 0
        mainTitle.font = UIFont(name: "Helvetica", size: 22)
        mainTitle.text = "Please enter your information below"
        mainTitle.adjustsFontSizeToFitWidth = true
        mainTitle.minimumScaleFactor = 0.2
        
        view.addSubview(mainTitle)
        
        let maintitleConstraints = [mainTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                    mainTitle.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 10),
                                    mainTitle.rightAnchor.constraint(equalTo: view.rightAnchor)]
        NSLayoutConstraint.activate(maintitleConstraints)
    }
}

//MARK: - Setu Sub Title
extension KBAQuestionsController {
    private func setSubTitle() {
        
        subTitle = UILabel()
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        subTitle.textAlignment = .left
        subTitle.textColor = darkgray
        subTitle.numberOfLines = 1
        subTitle.font = UIFont(name: "Helvetica", size: 18)
        subTitle.text = "Session Expires in"
        subTitle.adjustsFontSizeToFitWidth = true
        subTitle.minimumScaleFactor = 0.2
        
        view.addSubview(subTitle)
        
        let subtitleConstraints = [subTitle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                    subTitle.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(subtitleConstraints)
        
        
        timerLabel = UILabel()
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        timerLabel.textAlignment = .left
        timerLabel.textColor = .black
        timerLabel.numberOfLines = 1
        timerLabel.font = UIFont(name: "Helvetica-Bold", size: 18)
        timerLabel.text = "04:30"
        timerLabel.adjustsFontSizeToFitWidth = true
        timerLabel.minimumScaleFactor = 0.2
        
        view.addSubview(timerLabel)
        
        let timerLabelConstraints = [timerLabel.leftAnchor.constraint(equalTo: subTitle.rightAnchor, constant: 5),
                                    timerLabel.topAnchor.constraint(equalTo: mainTitle.bottomAnchor, constant: 5)]
        NSLayoutConstraint.activate(timerLabelConstraints)
    }
}

//MARK: - Setup bottom view and content
extension KBAQuestionsController {
    private func setBottomView() {
        
        let safearea = view.safeAreaLayoutGuide
        
        bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .white
        
        view.addSubview(bottomView)
        
        let bottomviewConstrainsts = [bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                      bottomView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                      bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                      bottomView.heightAnchor.constraint(equalToConstant: 60)]
        
        NSLayoutConstraint.activate(bottomviewConstrainsts)
        
        separatorView = UIView()
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .lightGray
        
        bottomView.addSubview(separatorView)
        
        let separatorConstraints = [separatorView.leftAnchor.constraint(equalTo: bottomView.leftAnchor),
                                    separatorView.topAnchor.constraint(equalTo: bottomView.topAnchor),
                                    separatorView.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
                                    separatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(separatorConstraints)
        
        
        continueButon = UIButton()
        continueButon.translatesAutoresizingMaskIntoConstraints = false
        continueButon.backgroundColor = greencolor
        continueButon.setTitleColor(.white, for: .normal)
        continueButon.setTitle("CONTINUE", for: .normal)
        continueButon.titleLabel?.font = UIFont(name: "Helvetica", size: 20)
        continueButon.isEnabled = true
        
        bottomView.addSubview(continueButon)
        
        let continuebuttonConstraints = [continueButon.centerXAnchor.constraint(equalTo: bottomView.centerXAnchor),
                                         continueButon.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
                                         continueButon.widthAnchor.constraint(equalToConstant: deviceWidth - 20),
                                         continueButon.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(continuebuttonConstraints)
        
        continueButon.layer.masksToBounds = false
        continueButon.layer.cornerRadius = 8
        
        continueButon.addTarget(self, action: #selector(continueAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Setup Question Table View
extension KBAQuestionsController {
    private func setQuestionTableView() {
        
        questionTableView = UITableView(frame: .zero, style: .plain)
        questionTableView.register(KBAQuestionCell.self, forCellReuseIdentifier: questiondefaultcellIdentifier)
        questionTableView.translatesAutoresizingMaskIntoConstraints = false
        questionTableView.dataSource = self
        questionTableView.tableFooterView = UIView()
        
        view.addSubview(questionTableView)
        
        let questiontableviewConstraints = [questionTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                            questionTableView.topAnchor.constraint(equalTo: subTitle.bottomAnchor, constant: 10),
                                            questionTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                            questionTableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)]
        NSLayoutConstraint.activate(questiontableviewConstraints)
    }
}

//MARK: - Setup TableView Datasource
extension KBAQuestionsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return KBAquestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _kbaquestion = KBAquestions[indexPath.row]
        let questionCell = tableView.dequeueReusableCell(withIdentifier: questiondefaultcellIdentifier) as! KBAQuestionCell
        questionCell.kbaQuestion = _kbaquestion
        
        questionCell.choiceCallBack = { [weak self] (_kbaanserquestionchoice) in
            guard let kbaquestionchoice = _kbaanserquestionchoice else { return }
            self?.updateQuestion(with: kbaquestionchoice)
            return
        }
        return questionCell
    }
}

//MARK: - Setup TableView Delegates
extension KBAQuestionsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Fetch Data From Api
extension KBAQuestionsController {
    private func fetchQuestion() {
        
        self.view.isUserInteractionEnabled = false
        showKBALoading()
    
        let kbaRequest = KBAQuestionRequest(InstanceId: _instanceId, SSN: _ssn, StepId: _stepId)
        
        kbaRequest.getKBAQuestions(kbarequest: kbaRequest) { (_kbaQuestiondata, _err, _message) in
            
            self.view.isUserInteractionEnabled = true
            self.hideKBALoading()
            self.startTimer()
            
            if _err {
                if let _message = _message {
                    self.showKBAAlert(title: "Error!", message: _message, actiontitle: "OK", secondattempt: false)
                    return
                }
                self.showKBAAlert(title: "Error!", message: "An error occurred with Knowledge Based Authentication, please try again later.", actiontitle: "OK", secondattempt: false)
                return
            }
            
            guard let kbaquestiondata = _kbaQuestiondata else {
                self.showKBAAlert(title: "Error!", message: "An error occurred with Knowledge Based Authentication, please try again later.", actiontitle: "OK", secondattempt: false)
                return
            }
            
            self.KBAquestions = kbaquestiondata.Questions ?? []
            
            self._KBAAnswerRequest = KBAAnswerRequest()
            
            self._KBAAnswerRequest?.ConversationId = kbaquestiondata.ConversationId
            self._KBAAnswerRequest?.InstanceId = self._instanceId
            self._KBAAnswerRequest?.StepId = self._stepId
            
            self._KBAAnswers = KBAAnswers()
            self._KBAAnswerRequest?.Answers = self._KBAAnswers
            self._KBAAnswerRequest?.Answers?.QuestionSetId = kbaquestiondata.QuestionSetId
            
            DispatchQueue.main.async {
                self.questionTableView.reloadData()
            }
        }
    }
}

//MARK: - Continue Button Action
extension KBAQuestionsController {
    @objc private func continueAction(_ sender: UIButton) {

        if let _kbaAnswers = _KBAAnswerRequest?.Answers?.Questions {

            if _secondAttempt {
                if _kbaAnswers.count != 2 {
                    return
                }
                submitQuestion()
                return
            }

            if _kbaAnswers.count != 3 {
                return
            }
            submitQuestion()
            return
        }
    }
}

//MARK: - Continue Function
extension KBAQuestionsController {
    private func submitQuestion() {
        
        self.continueButon.isEnabled = false
        showKBALoading()
        
        _KBAAnswerRequest?.sendUserKBAAnswers(kbaAnswers: _KBAAnswerRequest!, completion: { (status, kbaquestions, kbaquestionsetId, errormessage) in
            
            self.hideKBALoading()
            
            if status {
                self.questionCallBack!(true, nil)
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            if let _questions = kbaquestions {
                self._KBAAnswerRequest?.Answers?.Questions = []
                self.KBAquestions = _questions
                self._KBAAnswerRequest?.Answers?.QuestionSetId = kbaquestionsetId
                self._secondAttempt = true
                DispatchQueue.main.async {
                    self.questionTableView.reloadData {
                        self.continueButon.isEnabled = true
                    }
                }
                return
            }
            
            self.showKBAAlert(title: "Error!", message: errormessage ?? "Knowledge Based Authentication questions were answered incorrectly, as a result, this document has been canceled.", actiontitle: "OK", secondattempt: false)
            return
        })
        return
    }
}

//MARK: - Insert/Update Questions of Answer
extension KBAQuestionsController {
    private func updateQuestion(with question: KBAAnswerQuestions) {
        
        guard let _questionid = question.QuestionId else { return }
        if let _index = _KBAAnswerRequest?.Answers?.Questions.firstIndex(where: { $0.QuestionId == _questionid }) {
            _KBAAnswerRequest?.Answers?.Questions[_index] = question
        } else {
            _KBAAnswerRequest?.Answers?.Questions.append(question)
        }
        print(_KBAAnswerRequest?.Answers?.Questions ?? {})
    }
}

//MARK: - Setup Timer
extension KBAQuestionsController {
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
}

//MARK: - Setup Timer
extension KBAQuestionsController {
    @objc private func updateTime() {
        
        DispatchQueue.main.async {
            if self.countDown > 0 {
                let minutes = String(self.countDown/60)
                let _seconds = self.countDown%60
                var seconds = String(_seconds)
                
                if _seconds < 10 {
                    seconds = "0" + String(_seconds)
                }
                
                self.timerLabel.text = "0" + minutes + ":" + seconds
                self.countDown -= 1
                return
            }
            print(self.timer)
            if self.timer != nil {
                self.timerLabel.text = "00:00"
                self.timer.invalidate()
                self.validateTimer()
                return
            }
        }
    }
}

//MARK: Timer validation alert
extension KBAQuestionsController {
    private func validateTimer() {
        if !secondAttempt {
            showKBAAlert(title: "Time Exceeded!", message: "Need to validate your identity with another question set? By selecting 'Continue' you will be given one more attempt to correctly answer the validation questions.", actiontitle: "CANCEL", secondattempt: true)
            return
        }
        
        showKBAAlert(title: "Error!", message: "You have failed to answer the KBA questions within two attempts, as a result, this document has been canceled.", actiontitle: "OK", secondattempt: false)
        return
    }
}

//MARK: - Override KBA Alert Okay Action
extension KBAQuestionsController {
    override func kbaAlertOkAction() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func kbaContinueAction() {
        self.countDown = 270
        secondAttempt = true
        fetchQuestion()
        return
    }
}
