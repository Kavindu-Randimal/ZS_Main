//
//  FallbackQuestionController.swift
//  ZorroSign
//
//  Created by Chathura Ellawala on 7/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

protocol FallBackQuestionDelegate {
    func getSelectedQuestion(questionNumber: Int, question: FallbackQuestionsWithSelect, index: Int)
}

class FallbackQuestionController: UIViewController {
    private let deviceWidth: CGFloat = UIScreen.main.bounds.width
    
    private var titleLabel: UILabel!
    private var questionTableView: UITableView!
    
    var fallbackQuestions: [FallbackQuestionsWithSelect] = []
    
    var selectedQuestionNo: Int = 0
    private let fallbackquestioncellIdentifier = "fallbackquestioncellIdentifier"
    
    var delegate: FallBackQuestionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupQuestionTableView()
    }
}

extension FallbackQuestionController {
    private func setupQuestionTableView () {
        
        // Adding NavBar
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        view.addSubview(navBar)
        let navItem = UINavigationItem(title: "SELECT " + selectedQuestionNo.toString() + " QUESTION")
        navBar.setItems([navItem], animated: false)
        
        // Adding TableView
        questionTableView = UITableView(frame: .zero, style: .plain )
        questionTableView.backgroundColor = .white
        questionTableView.register(FallbackQuestionCell.self, forCellReuseIdentifier: fallbackquestioncellIdentifier)
        
        questionTableView.translatesAutoresizingMaskIntoConstraints = false
        questionTableView.dataSource = self
        questionTableView.delegate = self
        questionTableView.tableFooterView = UIView()
        questionTableView.separatorStyle = .none
        questionTableView.showsVerticalScrollIndicator = false
        self.view.addSubview(questionTableView)
        
        let fallbackquestionTableViewConstraints = [questionTableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                                                    questionTableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50),
                                                    questionTableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                                                    questionTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(fallbackquestionTableViewConstraints)
        questionTableView.reloadData()
    }
}

//MARK: - Implement UITableView Datasource
extension FallbackQuestionController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fallbackQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fallbackquestioncell = tableView.dequeueReusableCell(withIdentifier: fallbackquestioncellIdentifier) as! FallbackQuestionCell
        fallbackquestioncell.questionModel = self.fallbackQuestions[indexPath.row]
        fallbackquestioncell.imageViewImage = self.fallbackQuestions[indexPath.row].isSelected
        
        fallbackquestioncell.callBackQuestionCell = { [unowned self] (questionPart) in
            fallbackquestioncell.imageViewImage = true
            print("Chathura fallback question id ", questionPart.questionPart?.QuestionId as Any)
            print("Chathura fallback question name ",questionPart.questionPart?.Question as Any)
            
            questionPart.isSelected = true
            self.delegate?.getSelectedQuestion(questionNumber: self.selectedQuestionNo, question: questionPart, index: indexPath.row)
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        questionTableView.isScrollEnabled = (questionTableView.contentSize.height > UIScreen.main.bounds.size.height) ? true : false
        
        return fallbackquestioncell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.questionTableView.reloadData()
            return
        }
    }
}

//MARK: - TableView delegate methods
extension FallbackQuestionController: UITableViewDelegate{
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: deviceWidth, height: 150))
//        headerview.backgroundColor = .white
//        headerview.addBottomBorderWithColor(color: .darkGray, width: 1)
//        let headertitle = UILabel(frame: CGRect(x: 10, y: 5, width: deviceWidth - 20, height: 50))
//        headertitle.font = UIFont(name: "Helvetica", size: 18)
//        headertitle.numberOfLines = 0
//        headertitle.adjustsFontSizeToFitWidth = true
//        headertitle.minimumScaleFactor = 0.2
//        headertitle.text = "SELECT " + selectedQuestionNo.toString() + " QUESTION"
//        headerview.addSubview(headertitle)
//        return headerview
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
}
