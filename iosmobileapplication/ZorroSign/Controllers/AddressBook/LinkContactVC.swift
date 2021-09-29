//
//  LinkContactVC.swift
//  ZorroSign
//
//  Created by Apple on 31/01/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LinkContactCell: UICollectionViewCell {
    
    @IBOutlet weak var btndel: UIButton!
}

protocol PopoverDismissDelegate {
    
    func onDismiss()
}

class LinkContactVC: BaseVC, UITableViewDataSource, UITableViewDelegate, labelCellDelegate {
    

    @IBOutlet weak var contactsTbl: UITableView!
    @IBOutlet weak var txtsrch: UITextField!
    @IBOutlet weak var btnCreate: UIButton!
    
    @IBOutlet weak var btnSelectAll: UIButton!
    
    var linkAlertView: SwiftAlertView!
    
    var selectAllFlag: Bool = false
    var grpContactsArr: [ContactsData] = []
    var linkContactsArr: [ContactsData] = []
    var selGrpArr: [ContactsData] = []
    var delGrpArr: [ContactsData] = []
    var searchTxt: String = ""
    
    var grpName: String = ""
    var grpDesc: String = ""
    
    var grpFlag: Bool = true
    var linkFlag: Bool = false
    
    var groupId: Int = 0
    
    
    var selLinkContact: ContactsData!
    
    var popdelegate: PopoverDismissDelegate!
    
    @IBOutlet weak var lblSelect: UILabel!
    
    @IBOutlet weak var lblGrpName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        showSelectedCount()
        
        if groupId > 0 {
            btnCreate.setTitle("UPDATE", for: UIControl.State.normal)
            
            lblGrpName.text = grpName
            getGrpContact()
        }
        contactsTbl.reloadData()
        
        
    }
    
    func showSelectedCount() {
        
        var selCnt: Int = 0
        var totCnt: Int = 0
        
        if grpFlag {
            
            let filterArr = grpContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = grpContactsArr.count
            
        }
        else if linkFlag {
            
            let filterArr = linkContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = linkContactsArr.count
        }
        
        if selCnt > 0 {
            if grpFlag {
                lblSelect.text = "Selected: \(selCnt)/\(totCnt)"
            }
            else if linkFlag {
                let lblSelectAll = linkAlertView.viewWithTag(22) as? UILabel
                lblSelectAll?.text = "Selected: \(selCnt)/\(totCnt)"
            }
            
        } else {
            if grpFlag {
                lblSelect.text = "Select All"
            }
            else if linkFlag {
                //let lblSelectAll = linkAlertView.viewWithTag(22) as? UILabel
                //lblSelectAll?.text = "Select All"
            }
        }
        
        if selCnt == totCnt {
            if grpFlag {
                btnSelectAll.isSelected = true
            }
            else if linkFlag {
                let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
                btnSelectAll?.isSelected = true
            }
        } else {
            if grpFlag {
                btnSelectAll.isSelected = false
            }
            else if linkFlag {
                let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
                btnSelectAll?.isSelected = false
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return grpContactsArr.count
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
        if linkFlag {
        
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[5] as? UITableViewCell)! as? LabelCell
            }
            
            //let btnlink = cell?.btnlink
            //btnlink?.accessibilityHint = String(indexPath.row)
            //btnlink?.addTarget(self, action: #selector(linkAction), for: UIControlEvents.touchUpInside)
            
            //cell?.btnlink.isHidden = true
            
            cell?.delegate = self
            let lbl = cell?.lblName
            var data: ContactsData!
            
            data = linkContactsArr[indexPath.row]
            lbl?.text = data.Name! //+ " " + data.LastName!
            
            cell?.lblEmail.text = data.Email
            if let thumbURL = data.Thumbnail {
                cell?.imgProf.kf.setImage(with: URL(string: thumbURL))
            } else {
                cell?.imgProf.image = UIImage(named:"sign_up-gray")
            }
            
            cell?.btnchk.tag = indexPath.row
            cell?.btnchk.isSelected = data.selected
            
            //cell?.con_collvwHgt.constant = 0
            
        } else {
            
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[5] as? UITableViewCell)! as? LabelCell
            }
            
            let btnlink = cell?.btnlink
            btnlink?.accessibilityHint = String(indexPath.row)
            btnlink?.addTarget(self, action: #selector(linkAction), for: UIControl.Event.touchUpInside)
            
            cell?.btnlink.isHidden = false
            
            cell?.delegate = self
            let lbl = cell?.lblName
            var data: ContactsData!
            
            data = grpContactsArr[indexPath.row]
            lbl?.text = data.Name! //+ " " + data.LastName!
            
            
            cell?.btnchk.tag = indexPath.row
            if selGrpArr.contains(data) {
                cell?.btnchk.isSelected = true
            } else {
                cell?.btnchk.isSelected = data.selected
            }
            cell?.con_collvwHgt.constant = 31.5
            
            //let img = cell?.viewWithTag(5) as! UIImageView
            
            
            cell?.lblEmail.text = data.Email
            if let thumbURL = data.Thumbnail {
                 cell?.imgProf.kf.setImage(with: URL(string: thumbURL))
            } else {
                cell?.imgProf.image = UIImage(named:"sign_up-gray")
            }
            
            
            if let collvw = cell?.collView { //viewWithTag(6) as? UICollectionView {
                
                collvw.accessibilityHint = String(indexPath.row)
                collvw.delegate = self
                collvw.dataSource = self
                
                collvw.reloadData()
            }
        }
        return cell!
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let data = grpContactsArr[indexPath.row]
        let name: String = data.Name ?? ""//data.FullName!
        
        if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) {
            return 0
        }
        
        if linkFlag {
            
            let profileId = selLinkContact.ContactProfileId
            let linkdata = linkContactsArr[indexPath.row]
            
            if linkdata.ContactProfileId == profileId {
                return 0
            }
        }
        return UITableView.automaticDimension
        
    }
    
    func onChecked(id: Int, flag: Bool)
    {
        var selCnt: Int = 0
        var totCnt: Int = 0
        
        if selectAllFlag {
            selectAllFlag = false
            
        }
        
        
        if grpFlag {
            
            let data = grpContactsArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
            let filterarr = selGrpArr.filter{ ($0.ContactProfileId == data.ContactProfileId) }
            //if selGrpArr.contains(data) {
            if filterarr.count > 0 {
                data.selected = false
                
                delGrpArr.append(data)
            }
            
            let filterArr = grpContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = grpContactsArr.count
            
            
            contactsTbl.reloadData()
            
        }
        else if linkFlag {
            
            let filterarr = linkContactsArr.filter{ ($0.selected == true) }
            
            let data = linkContactsArr[id]
            if flag {
                if filterarr.count < 3 {
                    data.selected = true
                }
            } else {
                data.selected = false
            }
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
            
            let filterArr = linkContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = linkContactsArr.count
        }
        
        if selCnt > 0 {
            if grpFlag {
                lblSelect.text = "Selected: \(selCnt)/\(totCnt)"
            }
            else if linkFlag {
                let lblSelectAll = linkAlertView.viewWithTag(22) as? UILabel
                lblSelectAll?.text = "Selected: \(selCnt)/\(totCnt)"
            }
            
        } else {
            if grpFlag {
                lblSelect.text = "Select All"
            }
            else if linkFlag {
                //let lblSelectAll = linkAlertView.viewWithTag(22) as? UILabel
                //lblSelectAll?.text = "Select All"
            }
        }
        
        if selCnt == totCnt {
            if grpFlag {
                btnSelectAll.isSelected = true
            }
            else if linkFlag {
                let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
                btnSelectAll?.isSelected = true
            }
        } else {
            if grpFlag {
                btnSelectAll.isSelected = false
            }
            else if linkFlag {
                let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
                btnSelectAll?.isSelected = false
            }
        }
        
        
    }
    
    @IBAction func linkAction(_ sender: UIButton) {
        
        let tag: Int = Int(sender.accessibilityHint!)!
        selLinkContact = grpContactsArr[tag]
        
        grpFlag = false
        linkFlag = true
        //linkContactsArr = []
        //linkContactsArr.append(contentsOf: grpContactsArr)
        
        for contact in linkContactsArr {
            contact.selected = false
        }
        
        if selLinkContact.linkedContacts.count > 0 {
            
            for contact in linkContactsArr {
                for lnkcontact in selLinkContact.linkedContacts {
                    if contact.ContactProfileId == lnkcontact.ContactProfileId {
                        contact.selected = true
                    }
                }
            }
        }
        
        linkAlertView = SwiftAlertView(nibName: "InviteAlert", delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["CREATE"])
        //"Apply Changes"
        linkAlertView.tag = 24
        linkAlertView.delegate = self
        let tablevw = linkAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        
        let txtfld = linkAlertView.viewWithTag(2) as! UITextField
        txtfld.isHidden = true
        
        
        let lblTitle = linkAlertView.viewWithTag(12) as? UILabel
        lblTitle?.text = "Select Contacts to Link"
        
        let btnclose = linkAlertView.buttonAtIndex(index: 100)
        let btnsend = linkAlertView.buttonAtIndex(index: 101)
        
        btnclose?.setTitleColor(.red, for: UIControl.State.normal)
        
        btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
        let btnSearch = linkAlertView.viewWithTag(24) as? UIButton
        
        //btnSelectAll?.addTarget(self, action: #selector(selectAllInvite), for: UIControlEvents.touchUpInside)
        btnSelectAll?.isHidden = true
        
        let lblSelectAll = linkAlertView.viewWithTag(22) as? UILabel
        lblSelectAll?.text = ""
        
        btnSearch?.addTarget(self, action: #selector(searchInvite), for: UIControl.Event.touchUpInside)
        
        linkAlertView.show()
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            
            if alertView.tag == 24 {
                grpFlag = true
                linkFlag = false
                
                //showGrpContactAlert()
                contactsTbl.reloadData()
            }
        }
        if buttonIndex == 1 {
            
            if alertView.tag == 24 {
                
                let arr = linkContactsArr.filter{ ($0.selected == true) }
                
                if arr.count > 0 {
                    //if groupId == 0 {
                        selLinkContact.linkedContacts = []
                    //}
                    selLinkContact.linkedContacts.append(contentsOf: arr)
                }
                
                grpFlag = true
                linkFlag = false
                
                contactsTbl.reloadData()
            }
        }
        
    }
    
    @IBAction func selectAllInvite(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        var selCnt: Int = 0
        var totCnt: Int = 0
        
        selectAllFlag = !selectAllFlag
        
        if grpFlag {
            
            for i in 0..<grpContactsArr.count {
                
                let data = grpContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            
            let filterArr = grpContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = grpContactsArr.count
            
            contactsTbl.reloadData()
        }
        else if linkFlag {
            
            for i in 0..<linkContactsArr.count {
                
                let data = linkContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            
            let filterArr = linkContactsArr.filter{ ($0.selected == true) }
            selCnt = filterArr.count
            totCnt = linkContactsArr.count
            
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        }
       
        if selCnt > 0 {
            lblSelect.text = "Selected: \(selCnt)/\(totCnt)"
        } else {
            lblSelect.text = "Select All"
        }
        
    }
    
    @IBAction func searchInvite(_ sender: UIButton) {
        
        if grpFlag {
            
            
            searchTxt = txtsrch.text ?? ""
            
            contactsTbl.reloadData()
            
        }
        else if linkFlag {
            
            
            searchTxt = txtsrch.text ?? ""
            
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
            
        }
    }
    
    override func didDismissAlertView(alertView: SwiftAlertView) {
        
     
    }
    
    @objc func removeLink(_ sender: UIButton) {
        
        let tag = Int(sender.accessibilityHint!)
        let index = sender.tag
        let data = grpContactsArr[tag!]
        data.linkedContacts.remove(at: index)
        
        let indexpath = IndexPath(row: tag!, section: 0)
        contactsTbl.reloadRows(at: [indexpath], with: UITableView.RowAnimation.none)
    }
    
    @IBAction func createGroupAction() {
        
        let arr = grpContactsArr.filter{ ($0.selected == true) }
        
        if arr.count > 0 {
            if groupId > 0 {
                
                updateGroupAPI()
                
            } else {
                
                addGroupAPI()
            }
        } else {
            self.alertSample(strTitle: "", strMsg: "Please select contacts.")
        }
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func addGroupAPI() {
        
        /*
         ["Thumbnail": "DefaultProfileSmall.jpg", "Contacts": [["PrimaryContact": ["ContactId": 23602, "ContactProfileId": "xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"], "SecondaryContact": [["ContactId": 273, "ContactProfileId": ""]]]], "Name": "hoh", "Description": ""]
         ["Thumbnail": "DefaultProfileSmall.jpg", "Contacts": [["PrimaryContact": ["ContactId": 23602, "ContactProfileId": "xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"], "SecondaryContact": [["ContactId": 273, "ContactProfileId": ""]]]], "Name": "hoh", "Description": ""]
         ["Data": 276, "StatusCode": 1000, "Message": User group created successfully. But no contacts provided for the group.]
         */
        /*
         {"Name":"iOS","Description":"","Thumbnail":"DefaultProfileSmall.jpg","Contacts":[{"PrimaryContact":{"ContactId":23602,"ContactProfileId":"xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"},"SecondaryContact":[]},{"PrimaryContact":{"ContactId":23571,"ContactProfileId":"xyTqTzovWjPm98Q03wxxjg%3D%3D"},"SecondaryContact":[]}]}
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/CreateContactGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let selGrpContacts = grpContactsArr.filter{ ($0.selected == true) }
        
        var pricont: [[String:Any]] = []
        
        for contactdata in selGrpContacts {
            var secgrp: [[String:Any]] = []
            
            for sec in contactdata.linkedContacts {
                let secId: Int = sec.IdNum!
                let profId: String = sec.ContactProfileId!
                secgrp.append(["ContactId":secId,"ContactProfileId":profId])
            }
            let priId: Int = contactdata.IdNum!
            let profId: String = contactdata.ContactProfileId!
            
            pricont.append(["PrimaryContact":["ContactId":priId,"ContactProfileId":profId],"SecondaryContact":secgrp])
        }
        
        let parameters = ["Name":grpName,"Description":grpDesc,"Thumbnail":"DefaultProfileSmall.jpg","Contacts":pricont] as [String : Any] //contactObj!.toDictionary()
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            
                            DispatchQueue.main.async {
                                //self.alertSample(strTitle: "", strMsg: "Group created successfully")
                                let alert = UIAlertController(title: "", message: "Group created successfully", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    action in
                                    
                                    self.dismiss(animated: false, completion: {
                                        
                                        if self.popdelegate != nil {
                                            self.popdelegate.onDismiss()
                                        }
                                        
                                    })
                                }))
                                self.present(alert, animated: true, completion: nil)
                                alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                                
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
    
    @objc func dismissAction(){
        
        self.dismiss(animated: false, completion: {
            
            if self.popdelegate != nil {
                self.popdelegate.onDismiss()
            }
            
        })
    }
    
    func updateGroupAPI() {
        
        /*
         {"Id":287,"Name":"sddasa","Description":"","OrganizationId":538,"Thumbnail":"android.graphics.drawable.BitmapDrawable@a17cbe","DepartmentId":0,"AddedContacts":[{"PrimaryContact":{"ContactId":23576,"ContactProfileId":"OD2IsYEp1g9SKeFJu3xe8g%3D%3D"},"SecondaryContact":[]}],"DeletedContacts":["xyTqTzovWjPm98Q03wxxjg%3D%3D"]}
         */
       
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/UpdateContactGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let selGrpContacts = grpContactsArr.filter{ ($0.selected == true) }
        
        var pricont: [[String:Any]] = []
        
        for contactdata in selGrpContacts {
            var secgrp: [[String:Any]] = []
            
            for sec in contactdata.linkedContacts {
                let secId: Int = sec.IdNum ?? 0
                let profId: String = sec.ContactProfileId!
                secgrp.append(["ContactId":secId,"ContactProfileId":profId])
            }
            let priId: Int = contactdata.IdNum ?? 0
            let profId: String = contactdata.ContactProfileId!
            
            pricont.append(["PrimaryContact":["ContactId":priId,"ContactProfileId":profId],"SecondaryContact":secgrp])
        }
        
        var delpricont: [String] = []
        
        for contactdata in delGrpArr {
            var secgrp: [[String:Any]] = []
            
            for sec in contactdata.linkedContacts {
                let secId: Int = sec.IdNum!
                let profId: String = sec.ContactProfileId!
                secgrp.append(["ContactId":secId,"ContactProfileId":profId])
            }
            let priId: Int = contactdata.IdNum!
            let profId: String = contactdata.ContactProfileId!
            
            //delpricont.append(["PrimaryContact":["ContactId":priId,"ContactProfileId":profId],"SecondaryContact":secgrp])
            delpricont.append(profId)
        }
        
        let orgId: String = UserDefaults.standard.string(forKey: "OrganizationId")!
        
        let parameters = ["Id": groupId, "Name":grpName,"Description":grpDesc,"Thumbnail":"DefaultProfileSmall.jpg","OrganizationId":orgId,"DepartmentId":0,"AddedContacts":pricont, "DeletedContacts":delpricont] as [String : Any] //contactObj!.toDictionary()
        
        print("grp update params: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            DispatchQueue.main.async {
                                //self.alertSample(strTitle: "", strMsg: "Group updated successfully")
                                
                                
                                let alert = UIAlertController(title: "", message: "Group updated successfully", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                                    action in
                                    
                                    self.dismiss(animated: false, completion: {
                                        
                                        if self.popdelegate != nil {
                                            self.popdelegate.onDismiss()
                                        }
                                        
                                    })
                                }))
                                self.present(alert, animated: true, completion: nil)
                                alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
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
    
    func getGrpContact() {
        /*
         https://sandboxuser.zorrosign.com/api/UserManagement/GetContactsGroup
         
         Request:
         {"GroupIds":[284],"RetriveSecondaryContacts":true}
         
         Response:
         {"StatusCode":1000,"Message":"Operation successful","Data":[{"Id":284,"Name":"aaa","Description":"","Contacts":[{"PrimaryContact":{"ContactId":23569,"ContactProfileId":"bjGMU0l4CRE5HA1%2FBDWWvQ%3D%3D","Name":"Chetan p","ThumbnailURL":""},"SecondaryContact":null}],"OrganizationId":537,"Thumbnail":"android.graphics.drawable.BitmapDrawable@7a9bf85","DepartmentId":0}]}
         */
        
        for data in self.grpContactsArr {
            
            data.selected = false
            
        }
        
        selGrpArr = []
        
        let api = "UserManagement/GetContactsGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let parameters = ["GroupIds":[groupId],"RetriveSecondaryContacts":true] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
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
                                                
                                                
                                                if let SecContacts = dict["SecondaryContact"] as? [[String:Any]] {
                                                    
                                                    for dicsec in SecContacts {
                                                        
                                                        let contact1 = ContactsData(dictionary: dicsec)
                                                        contact.linkedContacts.append(contact1)
                                                    }
                                                }
                                                self.selGrpArr.append(contact)
                                                
                                                for data in self.grpContactsArr {
                                                    if data.ContactProfileId == contact.ContactProfileId {
                                                        data.selected = true
                                                        
                                                        data.linkedContacts.removeAll()
                                                        
                                                        if let SecContacts = dict["SecondaryContact"] as? [[String:Any]] {
                                                            
                                                            
                                                            
                                                            for dicsec in SecContacts {
                                                                
                                                                let contact1 = ContactsData(dictionary: dicsec)
                                                                data.linkedContacts.append(contact1)
                                                            }
                                                        }
                                                    }
                                                    
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                else {
                                    for data in self.grpContactsArr {
                                        
                                        data.selected = false
                                        data.linkedContacts.removeAll()
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
                    self.contactsTbl.reloadData()
                    self.showSelectedCount()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension LinkContactVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = Int(collectionView.accessibilityHint!)
        let data = grpContactsArr[tag!]
        
        return data.linkedContacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! LinkContactCell
        /*
        if cell == nil {
            let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
            var cell = (arr?[6] as? UICollectionViewCell)!
            
        }
 */
        let tag = Int(collectionView.accessibilityHint!)
        let data = grpContactsArr[tag!]
        
        let linkdcontact = data.linkedContacts[indexPath.row]
        let lblname = cell.viewWithTag(2) as! UILabel
        lblname.text = linkdcontact.Name
        
        cell.btndel.tag = indexPath.row
        cell.btndel.accessibilityHint = String(tag!)
        cell.btndel.addTarget(self, action: #selector(removeLink(_:)), for: UIControl.Event.touchUpInside)
        
        let imgProf = cell.viewWithTag(1) as! UIImageView
        if let thumbURL = linkdcontact.Thumbnail {
            imgProf.kf.setImage(with: URL(string: thumbURL))
        } else {
            imgProf.image = UIImage(named:"sign_up-gray")
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 12
        
        
    }
    
}
