//
//  UserPanelController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class UserPanelController: UIViewController {
    
    var initiatorContact: ContactDetailsViewModel?
    var previousContacts: [ContactDetailsViewModel]?
    var selectedContacts: [ContactDetailsViewModel]?
    var documentStep: Int!
    private var localStep: Int!
    
    private let greencolor: UIColor = ColorTheme.btnBG
    private let cellselectedcolor: UIColor = UIColor.init(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    private var selectedColor: UIColor!
    
    private var userpanelContainer: UIView!
    
    private var footerview: UIView!
    private var closeButton: UIButton!
    
    private var additionaView: UIView!
    private var leftallButton: UIButton!
    private var leftallLabel: UILabel!
    
    private var rightLabel: UILabel!
    private var rightButton: UIButton!
    
    private var usersTableView: UITableView!
    private var usercellIdentifier = "usercellidentifier"

    private var allselected: Bool = false
    
    private var selectedUser: [Int] = []
    private var assignedUsers: [ContactDetailsViewModel] = []
    
    var userpanelCallBack:(([ContactDetailsViewModel], Int) -> ())?
    var addmoreContacts: ((Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addInitiator()
        setIntialColor()
        setInitialHeight()
        setuserpanelContainerView()
        setfooterContainer()
        setaddtionalView()
        setuserTable()
    }
}

extension UserPanelController {
    fileprivate func addInitiator() {
        localStep = documentStep
        
        selectedContacts = initiatorContact!.isInitiatorExists(initiatr: initiatorContact!, selected: selectedContacts!)
        selectedContacts?.append(initiatorContact!)
    }
}

extension UserPanelController {
    fileprivate func setInitialHeight() {
        let maxheight: CGFloat = UIScreen.main.bounds.height/2
        var defaultheight: CGFloat = 100
        
        if let selectedcontact = selectedContacts {
             defaultheight += CGFloat(50 * selectedcontact.count)
        }
        
        if defaultheight > maxheight {
            defaultheight = maxheight
        }
        self.preferredContentSize.height = defaultheight
    }
}

extension UserPanelController {
    fileprivate func setIntialColor() {
        selectedColor = DocumentHelper.sharedInstance.getstepColor(step: documentStep)
    }
}

extension UserPanelController {
    fileprivate func setuserpanelContainerView() {
        
        userpanelContainer = UIView()
        userpanelContainer.translatesAutoresizingMaskIntoConstraints = false
        userpanelContainer.backgroundColor = .lightGray
        view.addSubview(userpanelContainer)
        
        let userpanelcontainerConstraints = [userpanelContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             userpanelContainer.topAnchor.constraint(equalTo: view.topAnchor),
                                             userpanelContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             userpanelContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(userpanelcontainerConstraints)
    }
}

extension UserPanelController {
    fileprivate func setfooterContainer() {
        footerview = UIView()
        footerview.translatesAutoresizingMaskIntoConstraints = false
        footerview.backgroundColor = .white
        userpanelContainer.addSubview(footerview)
        
        let footerviewConstraints = [footerview.leftAnchor.constraint(equalTo: userpanelContainer.leftAnchor),
                                     footerview.rightAnchor.constraint(equalTo: userpanelContainer.rightAnchor),
                                     footerview.bottomAnchor.constraint(equalTo: userpanelContainer.bottomAnchor),
                                     footerview.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(footerviewConstraints)
        
        closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.backgroundColor = greencolor
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.setTitle("CLOSE", for: .normal)
        footerview.addSubview(closeButton)
        
        let colsebuttonConstraints = [closeButton.leftAnchor.constraint(equalTo: footerview.leftAnchor, constant: 5),
                                      closeButton.topAnchor.constraint(equalTo: footerview.topAnchor, constant: 5),
                                      closeButton.rightAnchor.constraint(equalTo: footerview.rightAnchor, constant: -5),
                                      closeButton.bottomAnchor.constraint(equalTo: footerview.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(colsebuttonConstraints)
        closeButton.addTarget(self, action: #selector(closeuserPanel(_:)), for: .touchUpInside)
        
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = 8
    }
}

extension UserPanelController {
    fileprivate func setaddtionalView() {
        additionaView = UIView()
        additionaView.translatesAutoresizingMaskIntoConstraints = false
        additionaView.backgroundColor = .white
        userpanelContainer.addSubview(additionaView)
        
        let additionalviewConstraints = [additionaView.leftAnchor.constraint(equalTo: userpanelContainer.leftAnchor),
                                         additionaView.rightAnchor.constraint(equalTo: userpanelContainer.rightAnchor),
                                         additionaView.bottomAnchor.constraint(equalTo: footerview.topAnchor),
                                         additionaView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(additionalviewConstraints)
        
        leftallButton = UIButton()
        leftallButton.translatesAutoresizingMaskIntoConstraints = false
        leftallButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        leftallButton.setTitleColor(.black, for: .normal)
        additionaView.addSubview(leftallButton)
        
        let leftbuttonConstraints = [leftallButton.centerYAnchor.constraint(equalTo: additionaView.centerYAnchor),
                                     leftallButton.leftAnchor.constraint(equalTo: additionaView.leftAnchor, constant: 15),
                                     leftallButton.widthAnchor.constraint(equalToConstant: 25),
                                     leftallButton.heightAnchor.constraint(equalToConstant: 25)]
        NSLayoutConstraint.activate(leftbuttonConstraints)
        leftallButton.addTarget(self, action: #selector(selecAll(_:)), for: .touchUpInside)
        
        leftallButton.layer.borderColor = UIColor.black.cgColor
        leftallButton.layer.borderWidth = 1
        
        leftallLabel = UILabel()
        leftallLabel.translatesAutoresizingMaskIntoConstraints = false
        leftallLabel.text = "ALL"
        additionaView.addSubview(leftallLabel)
        
        let leftlabelConstraints = [leftallLabel.centerYAnchor.constraint(equalTo: additionaView.centerYAnchor),
                                    leftallLabel.leftAnchor.constraint(equalTo: leftallButton.rightAnchor, constant: 10)]
        NSLayoutConstraint.activate(leftlabelConstraints)
        
        rightLabel = UILabel()
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        let addmore = "ADD MORE"
        rightLabel.text = addmore
        rightLabel.attributedText = NSAttributedString(string: addmore, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        additionaView.addSubview(rightLabel)
        
        let rightlabelConstraints = [rightLabel.centerYAnchor.constraint(equalTo: additionaView.centerYAnchor),
                                     rightLabel.rightAnchor.constraint(equalTo: additionaView.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(rightlabelConstraints)
        
        rightLabel.isUserInteractionEnabled = true
        let addmoretap = UITapGestureRecognizer(target: self, action: #selector(addmoreTapGesture(_:)))
        rightLabel.addGestureRecognizer(addmoretap)
    }
}

//MARk: - setup user table
extension UserPanelController {
    fileprivate func setuserTable() {
        usersTableView = UITableView(frame: .zero, style: .plain)
        usersTableView.translatesAutoresizingMaskIntoConstraints = false
        usersTableView.register(UserPanelCell.self, forCellReuseIdentifier: usercellIdentifier)
        usersTableView.dataSource = self
        usersTableView.delegate = self
        usersTableView.allowsMultipleSelection = true
        usersTableView.tableFooterView = UIView()
        view.addSubview(usersTableView)
        
        let usertableviewConstraints = [usersTableView.leftAnchor.constraint(equalTo: userpanelContainer.leftAnchor),
                                        usersTableView.topAnchor.constraint(equalTo: userpanelContainer.topAnchor),
                                        usersTableView.rightAnchor.constraint(equalTo: userpanelContainer.rightAnchor),
                                        usersTableView.bottomAnchor.constraint(equalTo: additionaView.topAnchor)]
        NSLayoutConstraint.activate(usertableviewConstraints)
    }
}

//MARK: - Tableview datasource methods
extension UserPanelController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedContacts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let usercell = tableView.dequeueReusableCell(withIdentifier: usercellIdentifier) as! UserPanelCell
        let contact = selectedContacts![indexPath.row]
        usercell.documentStep = documentStep
        usercell.contactdetail = contact
        selectedUser.contains(indexPath.row) ? (usercell.userselected = true) : (usercell.userselected = false)
        return usercell
    }
}

extension UserPanelController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedUser.contains(indexPath.row) {
            selectedUser = selectedUser.filter {
                $0 != indexPath.row
            }
        } else {
            selectedUser.append(indexPath.row)
        }
        checkforSameStep()
        usersTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//MARK: - button functions
extension UserPanelController {
    
    @objc fileprivate func selecAll(_ sender: UIButton) {
        allselected = !allselected
        allselected ? leftallButton.setTitle(String.fontAwesomeIcon(name: .check), for: .normal) : leftallButton.setTitle( "", for: .normal)
        allselected ? selectallContacts() : deselectallContacts()
     }
  
    @objc fileprivate func closeuserPanel(_ sender: UIButton) {
        assignedUsers = assignContacts()
        userpanelCallBack!(assignedUsers, documentStep)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - user panel ui funtions
extension UserPanelController {
    fileprivate func selectallContacts() {
        for i in 0..<selectedContacts!.count {
            selectedUser.append(i)
            let indexpath = IndexPath(item: i, section: 0)
            self.usersTableView.reloadRows(at: [indexpath], with: .none)
        }
    }
    
    fileprivate func deselectallContacts() {
        selectedUser.removeAll()
        self.usersTableView.reloadData()
    }
}

//MARK: - Add more action
extension UserPanelController {
    @objc fileprivate func addmoreTapGesture(_ sender: UITapGestureRecognizer) {
        addmoreContacts!(true)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - Check for same step
extension UserPanelController {
    fileprivate func checkforSameStep() {
        let currentcontact = assignContacts()
        let issaemusers = DocumentHelper.sharedInstance.isSameUsers(previoususer: previousContacts!, currentusers: currentcontact)
        
        if issaemusers {
            if documentStep > 0 {
                documentStep -= 1
            }
        } else {
            documentStep = localStep
        }
        
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
}

extension UserPanelController {
    fileprivate func assignContacts() -> [ContactDetailsViewModel] {
        var users: [ContactDetailsViewModel] = []
        for userindex in selectedUser {
            let user = selectedContacts![userindex]
            users.append(user)
        }
        return users
    }
}
