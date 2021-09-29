//
//  DocumentinitiateCreateContactController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentinitiateCreateContactController: DocumentInitiateBaseController {
    
    private var footercontentView: UIView!
    private var footercancelButton: UIButton!
    private var footercreateButton: UIButton!
    
    private var textfieldtableView: UITableView!
    private let textfieldcellIdentifier = "textfiledcellidentifier"
    
    private var firstName: String!
    private var middleName: String!
    private var lastName: String!
    private var displayName: String!
    private var email: String!
    private var company: String!
    private var jobtitle: String!
    
    var newcontactcreatedCallBack: ((ContactDetailsViewModel) -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        createfooterContent()
        settextfieldContent()
        
        //Show Subscription Banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
    }
}

extension DocumentinitiateCreateContactController {
    fileprivate func createfooterContent() {
        let safearea = view.safeAreaLayoutGuide
        
        footercontentView = UIView()
        footercontentView.translatesAutoresizingMaskIntoConstraints = false
        footercontentView.backgroundColor = .white
        view.addSubview(footercontentView)
        
        let footerviewConstraints = [footercontentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     footercontentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     footercontentView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                     footercontentView.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(footerviewConstraints)
        
        let buttonwidth = UIScreen.main.bounds.width/2 - 20
        
        footercancelButton = UIButton()
        footercancelButton.translatesAutoresizingMaskIntoConstraints = false
        footercancelButton.setTitle("CANCEL", for: .normal)
        footercancelButton.setTitleColor(greencolor, for: .normal)
        footercancelButton.backgroundColor = .white
        
        footercontentView.addSubview(footercancelButton)
        
        let footercancelbuttonConstraints = [footercancelButton.leftAnchor.constraint(equalTo: footercontentView.leftAnchor, constant: 10),
                                             footercancelButton.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: 5),
                                             footercancelButton.bottomAnchor.constraint(equalTo: footercontentView.bottomAnchor, constant: -5),
                                             footercancelButton.widthAnchor.constraint(equalToConstant: buttonwidth)]
        NSLayoutConstraint.activate(footercancelbuttonConstraints)
        
        footercancelButton.layer.borderColor = greencolor.cgColor
        footercancelButton.layer.borderWidth = 2
        footercancelButton.layer.cornerRadius = 5
        footercancelButton.layer.masksToBounds = true
        
        footercancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        footercreateButton = UIButton()
        footercreateButton.translatesAutoresizingMaskIntoConstraints = false
        footercreateButton.setTitle("CREATE", for: .normal)
        footercreateButton.setTitleColor(.white, for: .normal)
        footercreateButton.backgroundColor = greencolor
        footercreateButton.isEnabled = true
        
        footercontentView.addSubview(footercreateButton)
        
        let footcreatebuttonConstraints = [footercreateButton.rightAnchor.constraint(equalTo: footercontentView.rightAnchor, constant: -10),
                                           footercreateButton.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: 5),
                                           footercreateButton.bottomAnchor.constraint(equalTo: footercontentView.bottomAnchor, constant: -5),
                                           footercreateButton.widthAnchor.constraint(equalToConstant: buttonwidth)]
        NSLayoutConstraint.activate(footcreatebuttonConstraints)
        
        footercreateButton.addTarget(self, action: #selector(createcontactActoin(_:)), for: .touchUpInside)
        
        footercreateButton.layer.cornerRadius = 5
        footercreateButton.layer.masksToBounds = true
    }
}

//MARK: - Setup textfields content
extension DocumentinitiateCreateContactController {
    fileprivate func settextfieldContent() {
        
        let safearea = view.safeAreaLayoutGuide
        
        textfieldtableView = UITableView()
        textfieldtableView.register(DocumentInitiateCreateContactCell.self, forCellReuseIdentifier: textfieldcellIdentifier)
        textfieldtableView.translatesAutoresizingMaskIntoConstraints = false
        textfieldtableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        textfieldtableView.tableFooterView = UIView()
        textfieldtableView.separatorStyle = .none
        textfieldtableView.dataSource = self
        textfieldtableView.delegate = self
        view.addSubview(textfieldtableView)
        
        let textfiledtableviewConstraints = [textfieldtableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             textfieldtableView.topAnchor.constraint(equalTo: safearea.topAnchor),
                                             textfieldtableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             textfieldtableView.bottomAnchor.constraint(equalTo: footercontentView.topAnchor)]
        NSLayoutConstraint.activate(textfiledtableviewConstraints)
    }
}

//MARK: - Tableview datarouce methods
extension DocumentinitiateCreateContactController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textfieldcell = tableView.dequeueReusableCell(withIdentifier: textfieldcellIdentifier) as! DocumentInitiateCreateContactCell
        textfieldcell.delegate = self
        textfieldcell.callBack = { (textindex, textstring) in
            self.settextfieldValues(index: textindex, text: textstring)
            return
        }
        textfieldcell.textfieleIndex = indexPath.row
        return textfieldcell
    }
}

//MARK: - Tableview delegate methods
extension DocumentinitiateCreateContactController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
}

extension DocumentinitiateCreateContactController: DocumentInitiateCreateContactCellDelegate {
    
    func getText(text: String) {
        print("working \(text)")
    }
}

//MARK: - Set textfield values
extension DocumentinitiateCreateContactController {
    fileprivate func settextfieldValues(index: Int, text: String) {
        switch index {
        case 0:
            firstName = text
        case 1:
            middleName = text
        case 2:
            lastName = text
        case 3:
            displayName = text
        case 4:
            email = text
        case 5:
            company = text
        case 6:
            jobtitle = text
        default:
            return
        }
    }
}

//MARK: - Button Actions
extension DocumentinitiateCreateContactController {
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func createcontactActoin(_ sender: UIButton) {
        
        let isconnected = Connectivity.isConnectedToInternet()
        if !isconnected {
            showalertMessage(title: "Connection !", message: "No Internet connection, Please try again later", cancel: false)
            return
        }
        
        showbackDrop()
        
        let createnewcontact = CreateNewContact(Company: company, DisplayName: displayName, Email: email, Firstname: firstName, JobTitle: jobtitle, Lastname: lastName, MiddleName: middleName)
        
        createnewcontact.createNewContact(createcontact: createnewcontact) { (succuess, contactdata) in
            if succuess {
                print(createnewcontact)
                guard let contactData = contactdata else { return }
                let newcontactData = ContactData(IdNum: nil, Id: "", ContactProfileId: contactData.ContactProfileId, Name: contactData.FullName, Description: nil, Email: contactData.Email, DepartmentName: nil, Type: 1, Thumbnail: contactData.Thumbnail, UserCount: nil, IsZorroUser: contactData.IsZorroUser, UserType: contactData.UserType, Company: contactData.Company, JobTitle: contactData.JobTitle, IsLocked: nil, IsSubscribed: nil, GroupContactEmails: nil, FullName: contactData.FullName, ContactId: contactData.ContactId, ProfileId: contactData.ProfileId)
                var newcontactdetails = ContactDetailsViewModel(contactdata: newcontactData)
                newcontactdetails.isSelected = true
                self.newcontactcreatedCallBack!(newcontactdetails)
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.navigationController?.popViewController(animated: true)
            return
        }
    }
}

//MARK: - alert actions
extension DocumentinitiateCreateContactController {
    override func genericokAction() {
        return
    }
}
