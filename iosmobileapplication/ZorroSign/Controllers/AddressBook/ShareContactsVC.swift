//
//  ShareContactsVC.swift
//  ZorroSign
//
//  Created by Apple on 29/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ShareContactsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate, labelCellDelegate, UITextFieldDelegate {

    @IBOutlet weak var tblContacts: UITableView!
    @IBOutlet weak var txtsrch: UITextField!
    
    var contactsArr: [ContactsData] = []
    var filteredContArr: [ContactsData] = []
    var selContactsArr: [ContactsData] = []
    var addMeFlag: Bool = false
    
    var searchTxt: String = ""
    var selectAllFlag: Bool = false
    var instanceID: Int = 0
    var templateID: Int = 0
    
    var contactAlertView: SwiftAlertView!
    var contactObj: ContactsData?
    
    var refIds:[[String:Any]] = []
    
    @IBOutlet weak var btnSelectAll: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblContacts.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblContacts.frame.size.width, height: 1))
        
        txtsrch.layer.borderColor = UIColor.lightGray.cgColor
        txtsrch.layer.borderWidth = 1.0
        
        getContacts()
    }

    @objc func getContacts() {
        //GetContactSummary?ProfileId=hYQHxbH7tM4WH0aogzF3ow%3D%3D
        
        /*
         
         {
         "IdNum": 23580,
         "Id": "PNmwHbHL3793xqDC4T77ew%3D%3D",
         "ContactProfileId": "t9ROJMvvhEvygBWRmhmz%2FQ%3D%3D",
         "Name": "Anil Saindane",
         "Description": "",
         "Email": "anil.hoh@gmail.com",
         "DepartmentName": null,
         "Type": 1,
         "Thumbnail": "TMKaeyprukidlfgNuPab8g.png",
         "UserCount": 1,
         "IsZorroUser": true,
         "UserType": 2,
         "Company": "HOH",
         "JobTitle": "Android Developer"
         }
         
         */
        
        contactsArr = []
        filteredContArr = []
        selContactsArr = []
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let orgId: String = UserDefaults.standard.string(forKey: "OrganizationId")!
        let api = "UserManagement/GetContactSummary?ProfileId==\(orgId)"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            if let data = jsonObj["Data"].array {
                                
                                for contact in data {
                                    
                                    let contactData = contact.dictionaryObject
                                    self.contactsArr.append(ContactsData(dictionary: contactData!))
                                }
                                
                                self.filteredContArr = self.contactsArr
                            }
                        }
                        else
                        {
                        }
                    
                    
                    
                    self.tblContacts.reloadData()
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredContArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
        
        if cell == nil {
            
            let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
            cell = (arr?[5] as? UITableViewCell)! as? LabelCell
        }
        cell?.delegate = self
        let lbl = cell?.lblName as! UILabel
        var data: ContactsData!
        
        data = filteredContArr[indexPath.row]
        lbl.text = data.Name!
        
        //let profIcon = cell?.viewWithTag(10) as! UIImageView
        
//        if let thumbURL = data.Thumbnail {
//            cell?.imgProf.kf.setImage(with: URL(string: thumbURL))
//        } else {
//            cell?.imgProf.image = UIImage(named:"sign_up-gray")
//        }
        if data.ContactType == 2 {
            cell?.imgProf.image = UIImage(named:"grp_icon")
        } else {
            if let thumbURL = data.Thumbnail {
                cell?.imgProf.kf.setImage(with: URL(string: thumbURL))
            } else {
                cell?.imgProf.image = UIImage(named:"contact_icon")
            }
        }
        
        cell?.imgProf.layer.cornerRadius = (cell?.imgProf.frame.size.width)! / 2;
        cell?.imgProf.clipsToBounds = true
        
        cell?.btnchk.tag = indexPath.row
        cell?.btnchk.isSelected = data.selected
        
        return cell!
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = filteredContArr[indexPath.row]
        let name: String = data.Name ?? ""//data.FullName!
        let email: String = data.Email ?? ""
        
        if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) && !email.lowercased().contains(searchTxt.lowercased()) {
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.selectionStyle = UITableViewCell.SelectionStyle.none
//        
//        
//    }

    func onChecked(id: Int, flag: Bool)
    {
        if selectAllFlag {
            selectAllFlag = false
            
        }
        
        let data = filteredContArr[id]
        if flag {
            data.selected = true
        } else {
            data.selected = false
        }
        if !selContactsArr.contains(data){
            selContactsArr.append(data)
        } else {
            let index = selContactsArr.index(of: data)
            selContactsArr.remove(at: index!)
        }
        let selArr = filteredContArr.filter{ ( $0.selected == true) }
        if selArr.count == filteredContArr.count {
            btnSelectAll.isSelected = true
        } else {
            btnSelectAll.isSelected = false
        }
        
        tblContacts.reloadData()
        
    }
    
    @IBAction func selectAllInvite(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        
        
        for i in 0..<contactsArr.count {
            
            let data = contactsArr[i]
            if sender.isSelected {
                data.selected = true
            } else {
                data.selected = false
            }
        }
        
        tblContacts.reloadData()
        
    }
    
    @IBAction func searchInvite(_ sender: UIButton) {
        
        searchTxt = txtsrch.text ?? ""
        tblContacts.beginUpdates()
        tblContacts.endUpdates()
        
//        self.filteredContArr = self.contactsArr.filter { ($0.Email?.contains(searchTxt))! || (($0.Name?.contains(searchTxt)) != nil)}
        
//        DispatchQueue.main.async {
//            self.tblContacts.reloadData()
//        }
    }
    
    @IBAction func addMeAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        addMeFlag = !addMeFlag
        
        
    }
    
    @IBAction func shareAction(_ sender: UIButton) {
        
        if selContactsArr.count == 0 && !addMeFlag {
            
            alertSample(strTitle: "", strMsg: "Please select contact")
            
        } else {
            shareToContacts()
            
        }
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
     
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addContactAction(_ sender: UIButton) {
        
        initAlert(closeTitle: "", type: 0)
    }
    
    func initAlert(closeTitle: String, type: Int) {
        
        contactAlertView = SwiftAlertView(nibName: "AddContactAlert", delegate: self, cancelButtonTitle: closeTitle, otherButtonTitles: [""])
        //"Apply Changes"
        contactAlertView.tag = 17
        contactAlertView.highlightOnButtonClicked = false
        contactAlertView.dismissOnOtherButtonClicked = false
        
        let txtFName = contactAlertView.viewWithTag(7) as! UITextField
        let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
        let txtLName = contactAlertView.viewWithTag(39) as! UITextField
        
        let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
        let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
        
        txtFName.delegate = self
        txtMidName.delegate = self
        txtLName.delegate = self
        
        txtDispName.delegate = self
        txtEmail.delegate = self
        txtCompName.delegate = self
        txtJobTitle.delegate = self
        
        let closeBtn = contactAlertView.viewWithTag(5) as! UIButton
        //closeBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        
        closeBtn.isHidden = true
        
        
        let headlbl = contactAlertView.viewWithTag(10) as! UILabel
        let addBtn = contactAlertView.viewWithTag(6) as! UIButton
        
        addBtn.isHidden = true
        
        let btnclose = contactAlertView.buttonAtIndex(index: 0)
        let btnadd = contactAlertView.buttonAtIndex(index: 1)
        
        //btnclose?.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        btnclose?.setTitle("CLOSE", for: UIControl.State.normal)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        if type == 0 {
            //addBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
            btnadd?.addTarget(self, action: #selector(alertButtonClicked), for: UIControl.Event.touchUpInside)
            btnadd?.setTitle("ADD TO ADDRESSBOOK", for: UIControl.State.normal)
        }
        
        contactAlertView.show()
    }
    
    @IBAction func alertButtonClicked (_ sender: Any) {
        
        let btn = (sender as! UIButton)
        let tag = btn.tag
        
        if tag == 5 {
            contactAlertView.dismiss()
        }
        if tag == 6 {
            
            let txtFName = contactAlertView.viewWithTag(7) as! UITextField
            let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
            let txtLName = contactAlertView.viewWithTag(39) as! UITextField
            
            let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
            let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
            let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
            let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
            
            contactObj = ContactsData()
            //let fullName = txtFName.text + " " + txtMidName.text + " " + txtLName.text
            
            //contactObj?.Name = fullName //txtFullName.text
            contactObj?.FirstName = txtFName.text
            contactObj?.MiddleName = txtMidName.text
            contactObj?.LastName = txtLName.text
            contactObj?.DisplayName = txtDispName.text
            contactObj?.Email = txtEmail.text
            contactObj?.Company = txtCompName.text
            contactObj?.JobTitle = txtJobTitle.text
            
            let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
            contactObj?.ProfileId = profileId
            contactObj?.UserType = 2
            
            if validateFields() {
                contactAlertView.dismiss()
                addContactAPI()
            }
        }
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
        }
        if buttonIndex == 1 {
            if alertView.tag == 17 {
                let txtFName = contactAlertView.viewWithTag(7) as! UITextField
                let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
                let txtLName = contactAlertView.viewWithTag(39) as! UITextField
                
                let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
                let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
                let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
                let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
                
                contactObj = ContactsData()
                contactObj?.FirstName = txtFName.text
                contactObj?.MiddleName = txtMidName.text
                contactObj?.LastName = txtLName.text
                contactObj?.DisplayName = txtDispName.text
                contactObj?.Email = txtEmail.text
                contactObj?.Company = txtCompName.text
                contactObj?.JobTitle = txtJobTitle.text
                
                let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
                contactObj?.ProfileId = profileId
                contactObj?.UserType = 2
                
                if validateFields() {
                    contactAlertView.dismiss()
                    addContactAPI()
                }
            }
            
        }
    }
    func validateFields() -> Bool {
        
        let txtFName = contactAlertView.viewWithTag(7) as! UITextField
        let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
        let txtLName = contactAlertView.viewWithTag(39) as! UITextField
        
        let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
        //let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
        
        let errFName = contactAlertView.viewWithTag(31) as! UILabel
        //let errDispName = contactAlertView.viewWithTag(11) as! UILabel
        let errEmail = contactAlertView.viewWithTag(32) as! UILabel
        
        let email: String = txtEmail.text!
        
        errFName.text = ""
        errEmail.text = ""
        
        if (txtFName.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "First name should not be empty")
            errFName.text = "First name should not be empty"
            return false
        }
        else if (txtLName.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "Last name should not be empty")
            errFName.text = "Last name should not be empty"
            return false
        }
        else if (txtEmail.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "Email should not be empty")
            errEmail.text = "Email should not be empty"
            return false
        }
        else if Singletone.shareInstance.isValidEmail(testStr: email) == false {
            //alertSample(strTitle: "", strMsg: "Email should be in valid format")
            errEmail.text = "Email should be in valid format"
            return false
        }
        /*
         else if (txtCompName.text?.isEmpty)! {
         alertSample(strTitle: "", strMsg: "Company should not be empty")
         return false
         }*/
        return true
    }
    
    
    func addContactAPI() {
        
        /* {"Firstname":"A","MiddleName":"B","Lastname":"C","DisplayName":"ABC","Email":"abc@abc.com","Company":"HOH","JobTitle":"Tester"}
         
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/CreateContact"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let fname: String = (contactObj?.FirstName)!
        let midname: String  = (contactObj?.MiddleName)!
        let lname: String = (contactObj?.LastName)!
        let dispname: String = (contactObj?.DisplayName)!
        let email: String = (contactObj?.Email)!
        let company: String = (contactObj?.Company)!
        let jobtitle: String = (contactObj?.JobTitle)!
        
        let parameters = ["Firstname": fname,"MiddleName": midname,"Lastname": lname,"DisplayName": dispname,"Email": email,"Company": company,"JobTitle": jobtitle] as! [String:Any]//contactObj!.toDictionary()
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contact added successfully")
                            self.getContacts()
                            self.contactAlertView.dismiss()
                            
                        } else if statusCode == 3561 {
                            
                           
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func shareToContacts() {
        
        //https://sandboxworkflow.zorrosign.com/api/v1/process/ShareProcess
        //PUT
        //{"TemplateId":15941,"ProcessId":11308,"ReferenceIds":[{"Type":2,"ReferenceId":"t9ROJMvvhEvygBWRmhmz%2FQ%3D%3D","add":false},{"Type":2,"ReferenceId":"xyTqTzovWjPm98Q03wxxjg%3D%3D","add":false},{"Type":1,"ReferenceId":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","add":false}]}
        //["TemplateId": 15946, "ProcessId": 11310, "ReferenceIds": [["Type": 2, "add": false, "ReferenceId": "xyTqTzovWjPm98Q03wxxjg%3D%3D"], ["Type": 1, "add": false, "ReferenceId": "Eb35X5bxE3jJa2PKCrtA2g%3D%3D"]]]
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/process/ShareProcess"
        let apiURL: String = Singletone.shareInstance.apiUserService + api
        
        //let instanceID = detailObject!["InstanceId"] ?? 0
        //let templateID = detailObject!["TemplateId"] ?? 0
        
        
        for data in selContactsArr {
            
            if let utype: Int = data.UserType {
                let refId: String = data.ContactProfileId!
                
                let dic = ["Type":utype,"ReferenceId":refId,"add":false] as [String : Any]
                refIds.append(dic)
                
            } else { // for group
                
                let refId: String = data.Id!
                
                let dic = ["Type":3,"ReferenceId":refId,"add":false] as [String : Any]
                refIds.append(dic)
            }
        }
        
        if addMeFlag {
            
            let utype = UserDefaults.standard.integer(forKey: "UserType")
            let refId: String = UserDefaults.standard.string(forKey: "OrgProfileId")!
            
            let dic = ["Type":utype,"ReferenceId":refId,"add":false] as [String : Any]
            refIds.append(dic)
        }
        
        let parameters: [String:Any] = ["TemplateId":templateID,"ProcessId":instanceID,"ReferenceIds": refIds]
        
        print("ShareProcess API:")
        print("parameters :\(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            //self.alertSample(strTitle: "", strMsg: "Document shared successfully.")
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "", message: "Document shared successfully.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {
                                    action in
                                    
                                    self.dismiss(animated: false, completion: nil)
                                }))
                                self.present(alert, animated: false, completion: nil)
                            }
                            
                        }
                        else
                        {
                        }
                    
                    
                    
                    //
            }
 
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getGrpContact(GrpIds:[Int]) {
        
        let api = "UserManagement/GetContactsGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let parameters = ["GroupIds":GrpIds,"RetriveSecondaryContacts":true] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        if let jsonData = jsonDic["Data"] as? NSArray {
                            for dicData in jsonData {
                                let dicData = dicData as? [String:Any]
                                if let jsonData = dicData!["Contacts"] as? NSArray {
                                    print(jsonData)
                                    for dic in jsonData {
                                        if let dict = dic as? [String:Any] {
                                            if let pricont = dict["PrimaryContact"] as? NSDictionary {
                                                let contact = ContactsData(dictionary: pricont as! [AnyHashable : Any])
                                                
                                                let refId: String = contact.ContactProfileId!
                                                
                                                let dic = ["Type":1,"ReferenceId":refId,"add":false] as [String : Any]
                                                self.refIds.append(dic)
                                                
                                                if let SecContacts = dict["SecondaryContact"] as? [[String:Any]] {
                                                    
                                                    for dicsec in SecContacts {
                                                        
                                                        let contact = ContactsData(dictionary: dicsec as! [AnyHashable : Any])
                                                        
                                                        let refId: String = contact.ContactProfileId!
                                                        
                                                        let dic = ["Type":1,"ReferenceId":refId,"add":false] as [String : Any]
                                                        self.refIds.append(dic)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.shareToContacts()
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @IBAction func sortContacts(_ sender: UIButton) {
        
        let titles = ["ALL","CONTACTS","GROUPS","MY COMPANY"]
        let descriptions = ["","","",""]
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.set(descriptions: descriptions)
        
        popOverViewController.popoverPresentationController?.sourceRect = sender.frame
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.preferredContentSize = CGSize(width: 200, height:200)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                
                self.filteredContArr = self.contactsArr
                break
                
            case 1:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 1) }
                break
                
            case 2:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.ContactType! == 2 && $0.UserCount! > 0) }
                break
                
            case 3:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.UserType == 1) }
                break
                
            default:
                break
            }
            
            sender.setTitle(titles[selectRow], for: UIControl.State.normal)
            
            for data in self.filteredContArr {
                data.selected = false
            }
            
            self.btnSelectAll.isSelected = false
            self.tblContacts.reloadData()
        };
        
        present(popOverViewController, animated: true, completion: nil)
        
        self.view.bringSubviewToFront(popOverViewController.view)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.popover
    }
    
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.popover
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
