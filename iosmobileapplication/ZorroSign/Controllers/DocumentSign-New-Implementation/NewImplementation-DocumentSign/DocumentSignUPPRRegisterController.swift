//
//  DocumentSignUPPRRegisterController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 2/5/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class DocumentSignUPPRRegisterController: UIViewController {
    
    private var backgroundContainer: UIView!
    private var formtableView: UITableView!
    private var defaultcellIdentifier: String = "defaultcellIdentifier"
    private var headercellIdentifier: String = "headercellIdentifier"
    private var textfieldcellIdentifier: String = "textfieldcellIdentifier"
    private var agreementcellIdentifier: String = "agreementcellIdentifier"
    private var continuebuttoncellIdentifier: String = "continuebuttoncellIdentifier"
    
    let deviceName = UIDevice.current.userInterfaceIdiom
    
    var firstName: String = ""
    var lastName: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var istextfieldsvalid: Bool = false
    var isagreed: Bool = false
    
    var registrationCompletion: ((Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundContainer()
        setformTableView()
    }
}

//MARK: - Setup Background Container View
extension DocumentSignUPPRRegisterController {
    private func setBackgroundContainer() {
        
        backgroundContainer = UIView()
        backgroundContainer.translatesAutoresizingMaskIntoConstraints = false
        backgroundContainer.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(backgroundContainer)
        
        let safearea = view.safeAreaLayoutGuide
        let backgroundcontainerConstraints = [backgroundContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                                              backgroundContainer.topAnchor.constraint(equalTo: safearea.topAnchor),
                                              backgroundContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                                              backgroundContainer.bottomAnchor.constraint(equalTo: safearea.bottomAnchor)]
        NSLayoutConstraint.activate(backgroundcontainerConstraints)
    }
}

//MARK: - Setup Form Table View
extension DocumentSignUPPRRegisterController {
    
    private func setformTableView() {
        
        formtableView = UITableView(frame: .zero, style: .plain)
        formtableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultcellIdentifier)
        formtableView.register(UpprRegisterHeaderCell.self, forCellReuseIdentifier: headercellIdentifier)
        formtableView.register(UpprRegisterTextFieldCell.self, forCellReuseIdentifier: textfieldcellIdentifier)
        formtableView.register(UpprRegisterAgreementCell.self, forCellReuseIdentifier: agreementcellIdentifier)
        formtableView.register(UpprRegisterContinueCell.self, forCellReuseIdentifier: continuebuttoncellIdentifier)
        formtableView.translatesAutoresizingMaskIntoConstraints = false
        formtableView.tableFooterView = UIView()
        formtableView.separatorStyle = .none
        formtableView.dataSource = self
        formtableView.delegate = self
        formtableView.bounces = false
        
        backgroundContainer.addSubview(formtableView)
        
        var leftpaddingrightpa: CGFloat = 10
        if deviceName == .pad {
            leftpaddingrightpa = 50
        }
        
        let formtableviewConstraints = [formtableView.leftAnchor.constraint(equalTo: backgroundContainer.leftAnchor, constant: leftpaddingrightpa),
                                        formtableView.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: 50),
                                        formtableView.rightAnchor.constraint(equalTo: backgroundContainer.rightAnchor, constant: -leftpaddingrightpa),
                                        formtableView.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -80)]
        
        NSLayoutConstraint.activate(formtableviewConstraints)
        
        formtableView.layer.cornerRadius = 8
    }
}

//MARK: - TableView data source methods
extension DocumentSignUPPRRegisterController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let headercell = tableView.dequeueReusableCell(withIdentifier: headercellIdentifier) as! UpprRegisterHeaderCell
            return headercell
        case 1,2,3,4:
            let textfieldcell = tableView.dequeueReusableCell(withIdentifier: textfieldcellIdentifier) as! UpprRegisterTextFieldCell
            textfieldcell.textfieldIndex = indexPath.row
            textfieldcell.textfieldCallBack = { [weak self] (tagindex, text) in
                self?.settextFieldValue(index: tagindex, text: text)
                return
            }
            return textfieldcell
        case 5:
            let agreementcell = tableView.dequeueReusableCell(withIdentifier: agreementcellIdentifier) as! UpprRegisterAgreementCell
            agreementcell.agreeementCallBack = { [weak self] (agreed) in
                self?.isagreed = agreed
                return
            }
            return agreementcell
        case 6:
            let continuecell = tableView.dequeueReusableCell(withIdentifier: continuebuttoncellIdentifier) as! UpprRegisterContinueCell
            continuecell.continueCallBack = { [weak self] (done) in
                self?.validateTextFields()
                self?.registerupprUser()
                return
            }
            return continuecell
        default:
            let defaultcell = tableView.dequeueReusableCell(withIdentifier: defaultcellIdentifier)
            defaultcell?.textLabel?.text = ""
            return defaultcell!
        }
    }
}

//MARK: - Tableview Delegate methods
extension DocumentSignUPPRRegisterController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 5:
            return 60
        case 6:
            return 60
        default:
            return UITableView.automaticDimension
        }
    }
}

//MARK: - Set Values
extension DocumentSignUPPRRegisterController {
    private func settextFieldValue(index: Int, text: String) {
        switch index {
        case 1:
            firstName = text
        case 2:
            lastName = text
        case 3:
            password = text
        case 4:
            confirmPassword = text
        default:
            return
        }
    }
}

//MARK: - Validate Text Fields
extension DocumentSignUPPRRegisterController {
    private func validateTextFields() {
        if firstName != "" || lastName != "" || password != "" || confirmPassword != "" {
            if password == confirmPassword {
                istextfieldsvalid = true
                return
            }
            istextfieldsvalid = false
            return
        }
        istextfieldsvalid = false
        return
    }
}

extension DocumentSignUPPRRegisterController {
    private func registerupprUser() {
        
        view.isUserInteractionEnabled = false
        
        if !istextfieldsvalid || !isagreed {
            return
        }
        
        guard let userprofiledata = ZorroTempData.sharedInstance.getUserprofile() else {
            return
        }
        
        var registerupprprofile = RegisterUPPRProfile()
        
        registerupprprofile.UserProfile = userprofiledata.Data
        registerupprprofile.UserProfile?.FirstName = firstName
        registerupprprofile.UserProfile?.LastName = lastName
        registerupprprofile.Password = password
        
        let fname = firstName
        let lname = lastName
        let fullname = "\(fname) \(lname)"
        UserDefaults.standard.set(fullname, forKey: "FullName")
        UserDefaults.standard.set(fname, forKey: "FName")
        UserDefaults.standard.set(lname, forKey: "LName")
    
        registerupprprofile.registerupprUserProfile(registerupprprofile: registerupprprofile) { (success) in
            self.view.isUserInteractionEnabled = true
            if success {
                self.dismiss(animated: true, completion: nil)
                self.registrationCompletion!(true)
                return
            }
            return
        }
        return
    }
}
