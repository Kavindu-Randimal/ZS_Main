//
//  DocumentInitiateContactsController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/30/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocumentInitiateContactsController: DocumentInitiateBaseController {
    
    var frominitiatePage: Bool = false
    var workflowID: Int!
    
    private var footercontentView: UIView!
    private var footercancelButton: UIButton!
    private var footernextButton: UIButton!
    
    private var headercontenView: UIView!
    private var headercontentTitle: UILabel!
    private var headerleftView: UIView!
    private var headerleftselectallButton: UIButton!
    private var headerleftselectionLabel: UILabel!
    private var headerleftdropdownArrow: UIImageView!
    private var headerleftselectionButton: UIButton!
    private var contacttypeController: UIViewController!
    private var changecontacttypePickerView: UIPickerView!
    private var pickerviewValues: [String] = []
    private var headerrightView: UIView!
    private var headerrightrighselectionLabel: UILabel!
    private var headerrightselectionButton: UIButton!
    
    private var moreactionView: UIView!
    private var addnewcontactView: UIView!
    private var addnewcontactIcon: UIImageView!
    private var addnewcontactLabel: UILabel!
    private var addnewcontactButton: UIButton!
    
    private var contactSearchBar: UISearchBar!
    private var contactlistTableView: UITableView!
    private let contactcellIdentifier = "contactcellidentifier"
    
    var selectedselectionType: Int = 0
    var isallselected: Bool = false
    
    var contactType: Int = 0
    
    var contactdetailsDefault: [ContactDetailsViewModel] = []
    var contactdetailsViewModel: [ContactDetailsViewModel] = []
    var contactdetailsFilterred: [ContactDetailsViewModel] = []
    
    var selectedcontactCount: Int = 0
    
    var addMoreCallBack:(([ContactDetailsViewModel]) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = lightgray
        setnavBar()
        setfooterContent()
        setheaderContent()
        setmoreactionsContent()
        setPickerViewContent()
        setsearchbarContent()
        setupcontactlistTableView()
        fetchcontactDetils()
        
        //Show Subscription Banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
    }
}

//MARK: - Set navbar properties
extension DocumentInitiateContactsController {
    fileprivate func setnavBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.title = "Address Book"
    }
}

//MARK: - Fetch contact details
extension DocumentInitiateContactsController {
    fileprivate func fetchcontactDetils() {
        
        let isconnection = Connectivity.isConnectedToInternet()
        if !isconnection {
            showalertMessage(title: "Connection !", message: "No Internet connection, Please try again later", cancel: false)
            return
        }
        
        showbackDrop()
        let createworkflowcontactlist = CreateworkflowContactList()
        createworkflowcontactlist.getContactList { [weak self] (contacts) in
            self!.contactdetailsDefault = contacts?.map({ return ContactDetailsViewModel(contactdata: $0)}) ?? []
            self!.contactdetailsViewModel = self!.contactdetailsDefault
            self!.contactdetailsFilterred = self!.contactdetailsDefault
            self!.setcontactCounts(index: 0)
            self!.contactlistTableView.reloadData()
            self!.hidebackDrop()
        }
    }
}

//MARK: - Set All Contacts Count
extension DocumentInitiateContactsController {
    fileprivate func setcontactCounts(index: Int) {
        DocumentHelper.sharedInstance.getselectedContactCount(contacts: contactdetailsViewModel) { (count) in
            self.selectedcontactCount = count
            self.headerrightrighselectionLabel.text = "SELECTED : \(count)"
        }
    }
}

//MARK: - Setup footer content
extension DocumentInitiateContactsController {
    fileprivate func setfooterContent() {
        
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
        
        footercancelButton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        footercancelButton.layer.borderColor = greencolor.cgColor
        footercancelButton.layer.borderWidth = 2
        footercancelButton.layer.cornerRadius = 5
        footercancelButton.layer.masksToBounds = true
        
        
        footernextButton = UIButton()
        footernextButton.translatesAutoresizingMaskIntoConstraints = false
        footernextButton.setTitle("NEXT", for: .normal)
        if frominitiatePage {
            footernextButton.setTitle("SAVE", for: .normal)
        }
        footernextButton.setTitleColor(.white, for: .normal)
        footernextButton.backgroundColor = greencolor
        footernextButton.isEnabled = true
        
        footercontentView.addSubview(footernextButton)
        
        let footernextbuttonConstraints = [footernextButton.rightAnchor.constraint(equalTo: footercontentView.rightAnchor, constant: -10),
                                               footernextButton.topAnchor.constraint(equalTo: footercontentView.topAnchor, constant: 5),
                                               footernextButton.bottomAnchor.constraint(equalTo: footercontentView.bottomAnchor, constant: -5),
                                               footernextButton.widthAnchor.constraint(equalToConstant: buttonwidth)]
        NSLayoutConstraint.activate(footernextbuttonConstraints)
        
        footernextButton.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        
        footernextButton.layer.cornerRadius = 5
        footernextButton.layer.masksToBounds = true
    }
}

//MARK: - Set up header content
extension DocumentInitiateContactsController {
    fileprivate func setheaderContent() {
        
        let safeare = view.safeAreaLayoutGuide
        
        headercontenView = UIView()
        headercontenView.translatesAutoresizingMaskIntoConstraints = false
        headercontenView.backgroundColor = .white
        view.addSubview(headercontenView)
        
        let headercontentviewConstraints = [headercontenView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                            headercontenView.topAnchor.constraint(equalTo: safeare.topAnchor),
                                            headercontenView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                            headercontenView.heightAnchor.constraint(equalToConstant: 80)]
        NSLayoutConstraint.activate(headercontentviewConstraints)
        
        headercontentTitle = UILabel()
        headercontentTitle.translatesAutoresizingMaskIntoConstraints = false
        headercontentTitle.font = UIFont(name: "Helvetica", size: 20)
        headercontentTitle.adjustsFontSizeToFitWidth = true
        headercontentTitle.minimumScaleFactor = 0.2
        headercontentTitle.textColor = .darkGray
        headercontentTitle.text = "Select all Recipient(s) in the document"
        headercontenView.addSubview(headercontentTitle)
        
        let headercontenttitleConstraints = [headercontentTitle.leftAnchor.constraint(equalTo: headercontenView.leftAnchor, constant: 5),
                                             headercontentTitle.topAnchor.constraint(equalTo: headercontenView.topAnchor, constant: 10),
                                             headercontentTitle.rightAnchor.constraint(equalTo: headercontenView.rightAnchor)]
        
        NSLayoutConstraint.activate(headercontenttitleConstraints)
        
        headerleftView = UIView()
        headerleftView.translatesAutoresizingMaskIntoConstraints = false
        headerleftView.backgroundColor = .clear
        headercontenView.addSubview(headerleftView)
        
        let viewwidth = UIScreen.main.bounds.width
        
        let headerleftviewConstraints = [headerleftView.leftAnchor.constraint(equalTo: headercontenView.leftAnchor),
                                         headerleftView.topAnchor.constraint(equalTo: headercontentTitle.bottomAnchor, constant: 5),
                                         headerleftView.bottomAnchor.constraint(equalTo: headercontenView.bottomAnchor),
        headerleftView.widthAnchor.constraint(equalToConstant: viewwidth/2)]
        
        NSLayoutConstraint.activate(headerleftviewConstraints)
        
        
        headerleftselectallButton = UIButton()
        headerleftselectallButton.translatesAutoresizingMaskIntoConstraints = false
        headerleftselectallButton.backgroundColor = .clear
        headerleftselectallButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 30, style: .solid)
        headerleftView.addSubview(headerleftselectallButton)
        
        let headerleftselectallbuttonConstraints = [headerleftselectallButton.centerYAnchor.constraint(equalTo: headerleftView.centerYAnchor),
                                                    headerleftselectallButton.leftAnchor.constraint(equalTo: headerleftView.leftAnchor, constant: 10),
                                                    headerleftselectallButton.widthAnchor.constraint(equalToConstant: 25),
                                                    headerleftselectallButton.heightAnchor.constraint(equalToConstant: 25)]
        
        headerleftselectallButton.layer.borderColor = UIColor.black.cgColor
        headerleftselectallButton.layer.borderWidth = 1
        
        NSLayoutConstraint.activate(headerleftselectallbuttonConstraints)
        headerleftselectallButton.addTarget(self, action: #selector(selectallContacts(_:)), for: .touchUpInside)
        
        headerleftdropdownArrow = UIImageView()
        headerleftdropdownArrow.translatesAutoresizingMaskIntoConstraints = false
        headerleftdropdownArrow.backgroundColor = .clear
        headerleftdropdownArrow.image = UIImage(named: "Down-arrow_tools")
        headerleftdropdownArrow.contentMode = .center
        headerleftView.addSubview(headerleftdropdownArrow)
        
        let headerdropdownarrowConstraints = [headerleftdropdownArrow.centerYAnchor.constraint(equalTo: headerleftView.centerYAnchor, constant: 0),
                                              headerleftdropdownArrow.rightAnchor.constraint(equalTo: headerleftView.rightAnchor),
                                              headerleftdropdownArrow.widthAnchor.constraint(equalToConstant: 40),
                                              headerleftdropdownArrow.heightAnchor.constraint(equalToConstant: 40)]
        
        NSLayoutConstraint.activate(headerdropdownarrowConstraints)
        
        headerleftselectionLabel = UILabel()
        headerleftselectionLabel.translatesAutoresizingMaskIntoConstraints = false
        headerleftselectionLabel.font = UIFont(name: "Helvetica", size: 15)
        headerleftselectionLabel.text = "ALL"
        headerleftselectionLabel.adjustsFontSizeToFitWidth = true
        headerleftselectionLabel.minimumScaleFactor = 0.2
        headerleftView.addSubview(headerleftselectionLabel)
        
        let headerleftselectionlabelConstraints  = [headerleftselectionLabel.centerYAnchor.constraint(equalTo: headerleftView.centerYAnchor),
                                                    headerleftselectionLabel.leftAnchor.constraint(equalTo: headerleftselectallButton.rightAnchor, constant: 10),
                                                    headerleftselectionLabel.rightAnchor.constraint(equalTo: headerleftdropdownArrow.leftAnchor)]
        
        NSLayoutConstraint.activate(headerleftselectionlabelConstraints)
        
        
        
        headerleftselectionButton = UIButton()
        headerleftselectionButton.translatesAutoresizingMaskIntoConstraints = false
        headerleftselectionButton.tag = 0
        headerleftView.addSubview(headerleftselectionButton)
        
        let headerleftselectionbuttonConstraints = [headerleftselectionButton.leftAnchor.constraint(equalTo: headerleftView.leftAnchor),
                                                    headerleftselectionButton.topAnchor.constraint(equalTo: headerleftView.topAnchor),
                                                    headerleftselectionButton.rightAnchor.constraint(equalTo: headerleftView.rightAnchor),
                                                    headerleftselectionButton.bottomAnchor.constraint(equalTo: headerleftView.bottomAnchor)]
        NSLayoutConstraint.activate(headerleftselectionbuttonConstraints)
        headerleftselectionButton.addTarget(self, action: #selector(changeTypes(_:)), for: .touchUpInside)
        
        
        headerrightView = UIView()
        headerrightView.translatesAutoresizingMaskIntoConstraints = false
        headerrightView.backgroundColor = .clear
        headercontenView.addSubview(headerrightView)
        
        let headerrightviewConstraints = [headerrightView.rightAnchor.constraint(equalTo: headercontenView.rightAnchor),
                                         headerrightView.topAnchor.constraint(equalTo: headercontentTitle.bottomAnchor, constant: 5),
                                         headerrightView.bottomAnchor.constraint(equalTo: headercontenView.bottomAnchor),
                                         headerrightView.widthAnchor.constraint(equalToConstant: viewwidth/2)]
        
        NSLayoutConstraint.activate(headerrightviewConstraints)
        
        headerrightrighselectionLabel = UILabel()
        headerrightrighselectionLabel.translatesAutoresizingMaskIntoConstraints = false
        headerrightrighselectionLabel.font = UIFont(name: "Helvetica", size: 15)
        headerrightrighselectionLabel.text = "SELECTED :"
        headerrightrighselectionLabel.isUserInteractionEnabled = true
        headerrightrighselectionLabel.adjustsFontSizeToFitWidth = true
        headerrightrighselectionLabel.minimumScaleFactor = 0.2
        headerrightView.addSubview(headerrightrighselectionLabel)
        
        let headerrightselectionlabelConstraints = [headerrightrighselectionLabel.centerYAnchor.constraint(equalTo: headerrightView.centerYAnchor),
                                                    headerrightrighselectionLabel.leftAnchor.constraint(equalTo: headerrightView.leftAnchor, constant: 10),
                                                    headerrightrighselectionLabel.rightAnchor.constraint(equalTo: headerrightView.rightAnchor)]
        NSLayoutConstraint.activate(headerrightselectionlabelConstraints)
        
        headerrightselectionButton = UIButton()
        headerrightselectionButton.translatesAutoresizingMaskIntoConstraints = false
        headerrightselectionButton.tag = 1
        headerrightView.addSubview(headerrightselectionButton)
        
        let headerrightselectionbuttonConstraints = [headerrightselectionButton.leftAnchor.constraint(equalTo: headerrightrighselectionLabel.leftAnchor),
                                                    headerrightselectionButton.topAnchor.constraint(equalTo: headerrightrighselectionLabel.topAnchor),
                                                    headerrightselectionButton.rightAnchor.constraint(equalTo: headerrightrighselectionLabel.rightAnchor),
                                                    headerrightselectionButton.bottomAnchor.constraint(equalTo: headerrightrighselectionLabel.bottomAnchor)]
        NSLayoutConstraint.activate(headerrightselectionbuttonConstraints)
        headerrightselectionButton.addTarget(self, action: #selector(changeTypes(_:)), for: .touchUpInside)
    }
}

extension DocumentInitiateContactsController {
    fileprivate func setPickerViewContent() {
        
        contacttypeController = UIViewController()
        contacttypeController.preferredContentSize = CGSize(width: 3 * UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/4)
        
        changecontacttypePickerView = UIPickerView()
        changecontacttypePickerView.translatesAutoresizingMaskIntoConstraints = false
        changecontacttypePickerView.tag = 0
        changecontacttypePickerView.delegate = self
        changecontacttypePickerView.dataSource = self
        contacttypeController.view.addSubview(changecontacttypePickerView)
        
        let changecontacttypepickerviewConstraints = [changecontacttypePickerView.leftAnchor.constraint(equalTo: contacttypeController.view.leftAnchor),
                                                      changecontacttypePickerView.topAnchor.constraint(equalTo: contacttypeController.view.topAnchor),
                                                      changecontacttypePickerView.rightAnchor.constraint(equalTo: contacttypeController.view.rightAnchor),
                                                      changecontacttypePickerView.bottomAnchor.constraint(equalTo: contacttypeController.view.bottomAnchor)]
        NSLayoutConstraint.activate(changecontacttypepickerviewConstraints)
    }
}

//MARK: - Set up more action content
extension DocumentInitiateContactsController {
    fileprivate func setmoreactionsContent() {
        
        moreactionView = UIView()
        moreactionView.translatesAutoresizingMaskIntoConstraints = false
        moreactionView.backgroundColor = lightgray
        view.addSubview(moreactionView)
        
        let moreactionviewConstraints = [moreactionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        moreactionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                        moreactionView.bottomAnchor.constraint(equalTo: footercontentView.topAnchor),
                                        moreactionView.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(moreactionviewConstraints)
        
        addnewcontactView = UIView()
        addnewcontactView.translatesAutoresizingMaskIntoConstraints = false
        addnewcontactView.backgroundColor = .clear
        moreactionView.addSubview(addnewcontactView)
        
        let viewwidth = UIScreen.main.bounds.width
        
        let addnewcontactviewConstraints = [addnewcontactView.leftAnchor.constraint(equalTo: moreactionView.leftAnchor),
                                         addnewcontactView.topAnchor.constraint(equalTo: moreactionView.topAnchor),
                                         addnewcontactView.bottomAnchor.constraint(equalTo: moreactionView.bottomAnchor),
                                         addnewcontactView.widthAnchor.constraint(equalToConstant: viewwidth/2)]
        NSLayoutConstraint.activate(addnewcontactviewConstraints)
        
        addnewcontactIcon = UIImageView()
        addnewcontactIcon.translatesAutoresizingMaskIntoConstraints = false
        addnewcontactIcon.backgroundColor = .clear
        addnewcontactIcon.image = UIImage(named: "Add-contact")
        addnewcontactView.addSubview(addnewcontactIcon)
        
        let addnewcontacticonConstraints = [addnewcontactIcon.centerYAnchor.constraint(equalTo: addnewcontactView.centerYAnchor),
                                            addnewcontactIcon.leftAnchor.constraint(equalTo: addnewcontactView.leftAnchor, constant: 15),
                                            addnewcontactIcon.widthAnchor.constraint(equalToConstant: 40),
                                            addnewcontactIcon.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(addnewcontacticonConstraints)
        
        addnewcontactIcon.layer.cornerRadius = 40/2
        addnewcontactIcon.layer.masksToBounds = true
        
        addnewcontactLabel = UILabel()
        addnewcontactLabel.translatesAutoresizingMaskIntoConstraints = false
        addnewcontactLabel.text = "ADD CONTACT"
        addnewcontactView.addSubview(addnewcontactLabel)
        
        let addnewcontactlabelConstraints = [addnewcontactLabel.centerYAnchor.constraint(equalTo: addnewcontactView.centerYAnchor),
                                             addnewcontactLabel.leftAnchor.constraint(equalTo: addnewcontactIcon.rightAnchor, constant: 5),
                                             addnewcontactLabel.rightAnchor.constraint(equalTo: addnewcontactView.rightAnchor)]
        NSLayoutConstraint.activate(addnewcontactlabelConstraints)
        
        addnewcontactButton = UIButton()
        addnewcontactButton.translatesAutoresizingMaskIntoConstraints = false
        addnewcontactView.addSubview(addnewcontactButton)
        
        let addnewcontactbuttonConstraints = [addnewcontactButton.leftAnchor.constraint(equalTo: addnewcontactView.leftAnchor),
                                              addnewcontactButton.topAnchor.constraint(equalTo: addnewcontactView.topAnchor),
                                              addnewcontactButton.rightAnchor.constraint(equalTo: addnewcontactView.rightAnchor),
                                              addnewcontactButton.bottomAnchor.constraint(equalTo: addnewcontactView.bottomAnchor)]
        
        NSLayoutConstraint.activate(addnewcontactbuttonConstraints)
        addnewcontactButton.addTarget(self, action: #selector(addnewcontactAction(_:)), for: .touchUpInside)
    }
}

//MARK: - setup search bar
extension DocumentInitiateContactsController {
    fileprivate func setsearchbarContent() {
        contactSearchBar = UISearchBar()
        contactSearchBar.translatesAutoresizingMaskIntoConstraints = false
        contactSearchBar.barTintColor = lightgray
        contactSearchBar.placeholder = "Search Contact"
        contactSearchBar.returnKeyType = .done
        contactSearchBar.delegate = self
        contactSearchBar.enablesReturnKeyAutomatically = false
        contactSearchBar.backgroundImage = UIImage()
        view.addSubview(contactSearchBar)
        
        let contactsearchbarConstraints = [contactSearchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                                           contactSearchBar.topAnchor.constraint(equalTo: headercontenView.bottomAnchor, constant: 5),
                                           contactSearchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
                                           contactSearchBar.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(contactsearchbarConstraints)
    }
}

//MARK: - Set Contact List Table View
extension DocumentInitiateContactsController {
    fileprivate func setupcontactlistTableView() {
        contactlistTableView = UITableView(frame: .zero, style: .grouped)
        contactlistTableView.register(DocuentInitiateContactsCell.self, forCellReuseIdentifier: contactcellIdentifier)
        contactlistTableView.translatesAutoresizingMaskIntoConstraints = false
        contactlistTableView.dataSource = self
        contactlistTableView.delegate = self
        contactlistTableView.tableFooterView = UIView()
        contactlistTableView.separatorStyle = .none
        contactlistTableView.allowsMultipleSelection = true
        view.addSubview(contactlistTableView)
        
        let contactlisttableviewConstraints = [contactlistTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                               contactlistTableView.topAnchor.constraint(equalTo: contactSearchBar.bottomAnchor),
                                               contactlistTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                               contactlistTableView.bottomAnchor.constraint(equalTo: moreactionView.topAnchor, constant: 0)]
        NSLayoutConstraint.activate(contactlisttableviewConstraints)
    }
}

//MARK: - picker view datasource methods
extension DocumentInitiateContactsController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return pickerviewValues.count
    }
    
}

//MARK: - picker view delegate methods
extension DocumentInitiateContactsController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return pickerviewValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        filterwithChangeType(selectedindex: row)
    }
}

// MARK: - filter with changetype
extension DocumentInitiateContactsController {
    fileprivate func filterwithChangeType(selectedindex: Int) {
        let selectedtypeString = pickerviewValues[selectedindex]
        contactType = selectedindex
        switch selectedselectionType {
        case 0:
            headerleftselectionLabel.text = selectedtypeString
        case 1:
            setcontactCounts(index: selectedindex)
        default:
            return
        }
    }
}


//MARK: - Tableview Datasource methods
extension DocumentInitiateContactsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactdetailsFilterred.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let contactcell = tableView.dequeueReusableCell(withIdentifier: contactcellIdentifier) as! DocuentInitiateContactsCell
        let contact = contactdetailsFilterred[indexPath.row]
        contactcell.contactdetail = contact
        return contactcell
    }
}

//MARK: - Tableview delegaet methods
extension DocumentInitiateContactsController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          selectContacts(indexPath: indexPath)
    }
}

//MARK: - did select action
extension DocumentInitiateContactsController {
    fileprivate func selectContacts(indexPath: IndexPath) {
        self.contactSearchBar.endEditing(true)
        var selectedContact = contactdetailsFilterred[indexPath.row]
        
        selectedContact.isSelected = !selectedContact.isSelected
        
        var selectedIndex: Int!
        if selectedContact.Id! != "" {
            selectedIndex = contactdetailsViewModel.firstIndex{ $0.Id! == selectedContact.Id! }
        } else {
            selectedIndex = contactdetailsViewModel.firstIndex{ $0.ContactProfileId! == selectedContact.ContactProfileId! }
        }
        
        if let Index = selectedIndex {
            contactdetailsFilterred[indexPath.row] = selectedContact
            contactdetailsViewModel[Index] = selectedContact
            self.contactlistTableView.reloadRows(at: [indexPath], with: .fade)
        }
        
        setcontactCounts(index: contactType)
    }
}

//MARK: - Button Actions
extension DocumentInitiateContactsController {
    
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        if frominitiatePage {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.navigationController?.popToRootViewController(animated: true)
        return
    }
    
    @objc fileprivate func nextAction(_ sender: UIButton) {
    
        showbackDrop()
        
        DocumentHelper.sharedInstance.filtercontacswithSelectorNonselect(contacttype: 1, contacts: contactdetailsViewModel) { (selectedcontact) in
            
            if self.frominitiatePage {
                self.addMoreCallBack!(selectedcontact)
                self.navigationController?.popViewController(animated: true)
                return
            } else {
                let initiaterDetails = DocumentHelper.sharedInstance.getinitiaterDetails(contacts: self.contactdetailsViewModel)
                
                if selectedcontact.count > 0 {
                    self.getworkflowDetails { (workflowdata) in
                        DispatchQueue.main.async {
                            let documentinitiatecontroller = DocumentInitiateController()
                            documentinitiatecontroller.selectedContacts = selectedcontact
                            documentinitiatecontroller.initiatorContact = initiaterDetails
                            documentinitiatecontroller.createworkflowData = workflowdata
                            self.hidebackDrop()
                            self.navigationController?.pushViewController(documentinitiatecontroller, animated: true)
                        }
                    }
                    return
                }
                self.hidebackDrop()
                print("please select at least one contact to to continue")
                return
            }
        }
    }
    
    @objc fileprivate func selectallContacts(_ sender: UIButton) {
        
        DocumentHelper.sharedInstance.checkallcontactsSelected(contacts: contactdetailsFilterred) { (selected) in
            self.allContacts(selectall: !selected)
        }
    }
    
    @objc fileprivate func changeTypes(_ sender: UIButton) {
        selectedselectionType = sender.tag
        switch sender.tag {
        case 0:
            pickerviewValues = ["ALL", "CONTACTS", "GROUPS", "MY COMPANY"]
            let changecontactypePickerAlert = UIAlertController(title: "Contact Type", message: "Please select a contact type", preferredStyle: .alert)
            changecontactypePickerAlert.view.tintColor = greencolor
            let selectAction = UIAlertAction(title: "SELECT", style: .default) { (alert) in
                self.filterwithContactType()
                self.dismiss(animated: true, completion: nil)
                return
            }
            changecontactypePickerAlert.addAction(selectAction)
            changecontactypePickerAlert.setValue(contacttypeController, forKey: "contentViewController")
            self.present(changecontactypePickerAlert, animated: true, completion: nil)
            return
        case 1:
            print("right button working")
            setcontactCounts(index: 1)
            filterwithContactType()
            return
        default:
            return
        }
    }
    
    @objc fileprivate func addnewcontactAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            let documentinitiatecreatecontactController = DocumentinitiateCreateContactController()
            documentinitiatecreatecontactController.newcontactcreatedCallBack = { newcontactviewmodel in
                self.contactdetailsDefault.append(newcontactviewmodel)
                self.contactdetailsViewModel.append(newcontactviewmodel)
                self.contactdetailsFilterred.append(newcontactviewmodel)
                self.contactlistTableView.reloadData()
            }
            self.navigationController?.pushViewController(documentinitiatecreatecontactController, animated: true)
        }
    }
}

//MARK: - Search bar delegates
extension DocumentInitiateContactsController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        contactSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        contactSearchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filterredContacts = filteredContacts(contactDetails: contactdetailsFilterred, searchString: searchBar.text!)
        contactdetailsFilterred = filterredContacts
        self.contactlistTableView.reloadData()
    }
}

//MARK: - Filter contact with search
extension DocumentInitiateContactsController {
    fileprivate func filteredContacts(contactDetails: [ContactDetailsViewModel], searchString: String) -> [ContactDetailsViewModel] {
        
        if searchString != "" {
            let filterredarray = contactDetails.filter {
                $0.Name!.contains(searchString) || $0.Email!.contains(searchString)
            }
            return filterredarray
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.contactSearchBar.endEditing(true)
            }
            var filterredarrsy: [ContactDetailsViewModel] = []
            DocumentHelper.sharedInstance.filtercontactswithcontactType(contacttype: contactType, contacts: contactdetailsViewModel) { (filteredcontacts) in
                filterredarrsy = filteredcontacts
            }
            return filterredarrsy
        }
    }
}

//MARK: - Filter contacts with contact type
extension DocumentInitiateContactsController {
    fileprivate func filterwithContactType() {
        switch selectedselectionType {
        case 0:
            contactdetailsFilterred = []
            DocumentHelper.sharedInstance.filtercontactswithcontactType(contacttype: contactType, contacts: contactdetailsViewModel) { (filterredcontacts) in
                
                DocumentHelper.sharedInstance.checkallcontactsSelected(contacts: filterredcontacts, completion: { (selected) in
                    self.changebuttonAppearance(allselected: selected)
                    self.contactdetailsFilterred = filterredcontacts
                    self.contactlistTableView.reloadData()
                })
            }
            return
        case 1:
            contactdetailsFilterred = []
            DocumentHelper.sharedInstance.filtercontacswithSelectorNonselect(contacttype: 1, contacts: contactdetailsViewModel) { (filterredcontacts) in
                self.contactdetailsFilterred = filterredcontacts
                self.contactlistTableView.reloadData()
            }
            return
        default:
            return
        }
    }
}

extension DocumentInitiateContactsController {
    fileprivate func allContacts(selectall: Bool) {
        if selectedselectionType == 0 {
            DocumentHelper.sharedInstance.selectallContacts(contacttype: contactType, selectall: selectall, contacts: contactdetailsViewModel) { (contacts, filterredcontacts) in
                
                DocumentHelper.sharedInstance.checkallcontactsSelected(contacts: filterredcontacts, completion: { (selected) in
                    self.changebuttonAppearance(allselected: selected)
                    self.contactdetailsViewModel = contacts
                    self.contactdetailsFilterred = filterredcontacts
                    DispatchQueue.main.async {
                        self.contactlistTableView.reloadData()
                    }
                })
            }
        }
    }
}

extension DocumentInitiateContactsController {
    fileprivate func changebuttonAppearance(allselected: Bool) {
        if allselected {
            self.headerleftselectallButton.setTitleColor(.black, for: .normal)
            self.headerleftselectallButton.setTitle(String.fontAwesomeIcon(name: .checkSquare ), for: .normal)
        } else {
            self.headerleftselectallButton.setTitleColor(.white, for: .normal)
            self.headerleftselectallButton.setTitle("", for: .normal)
        }
    }
}

extension DocumentInitiateContactsController {
    fileprivate func getworkflowDetails(completion:@escaping(GetWorkflowData) -> ()) {
        let getworkflow = GetWorkflow()
        getworkflow.getworkflowdatawidhWorkflowID(workflowid: workflowID) { (workflowdata) in
            
            if workflowdata != nil {
                completion(workflowdata!)
                return
            }
            return
        }
    }
}

//MARK: - alert actions
extension DocumentInitiateContactsController {
    override func genericokAction() {
        return
    }
}
