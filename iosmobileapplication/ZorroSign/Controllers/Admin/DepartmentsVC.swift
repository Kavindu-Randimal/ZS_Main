//
//  DepartmentsVC.swift
//  ZorroSign
//
//  Created by Apple on 30/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SwiftyJSON

struct Dept {
    
    let Name: String
    let DepartmentId: Int
    
    init(Name: String, DepartmentId: Int) { // default struct initializer
        self.Name = Name
        self.DepartmentId = DepartmentId
    }
}

extension Dept: Decodable {
    enum MyStructKeys: String, CodingKey { // declaring our keys
        case Name = "Name"
        case DepartmentId = "DepartmentId"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MyStructKeys.self) // defining our (keyed) container
        let fullName: String = try container.decode(String.self, forKey: .Name) // extracting the data
        let id: Int = try container.decode(Int.self, forKey: .DepartmentId) // extracting the data
        
        self.init(Name: fullName, DepartmentId: id) // initializing our struct
    }
}

class DepartmentsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DeptCellProtocol {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var tblDept: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    var arrDept: NSMutableArray = NSMutableArray.init()
    var editFlag: Bool = false
    var selDeptId: Int = 0
    var txtDept: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //addView.layer.borderColor = UIColor.black.cgColor
        //addView.layer.borderWidth = 1.0
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        addFooterView()
        tblDept.dataSource = self
        tblDept.delegate = self
        tblDept.sectionHeaderHeight = 216
        
        tblDept.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblDept.frame.size.width, height: 1))
        
        getDepartments()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func getDepartments() {
        
        arrDept = NSMutableArray.init()

        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/GetAllDepartments"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        let data = jsonObj["Data"].array
                        for dic in data! {
                            
                            let dict = dic.dictionaryObject
                            self.arrDept.add(Dept(Name: dict!["Name"] as! String, DepartmentId: dict!["DepartmentId"] as! Int))
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.tblDept.reloadData()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDept.count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "addDeptCell") as! CustomCell
            
            let viewAdd = cell.viewWithTag(10)
            viewAdd?.layer.borderColor = UIColor.black.cgColor
            viewAdd?.layer.borderWidth = 1.0
            
            cell.txtDispSign.text = txtDept
            
            if selDeptId > 0 {
                cell.btnSave.setTitle("UPDATE DEPARTMENT", for: UIControl.State.normal)
            } else {
                cell.btnSave.setTitle("ADD DEPARTMENT", for: UIControl.State.normal)
            }
            cell.btnSave.addTarget(self, action: #selector(addAction), for: UIControl.Event.touchUpInside)
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "deptCell") as! CustomCell
            
            let data = arrDept[indexPath.row - 1] as! Dept
            //cell.textLabel?.text = data.Name
            cell.lblEmail.text = data.Name
            cell.btnEdit.accessibilityHint = "edit"
            cell.btnDelete.accessibilityHint = "delete"
            
            cell.btnEdit.tag = indexPath.row - 1
            cell.btnDelete.tag = indexPath.row - 1
            
            cell.deptDelegate = self
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        return indexPath.row == 0 ? 216 : 40
    }
   
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let charset = CharacterSet(charactersIn: Singletone.shareInstance.alphaNumCharset).inverted
        let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
        
        let maxlimit = 50
        let currStr: NSString = textField.text! as NSString
        let newStr: NSString = currStr.replacingCharacters(in: range, with: filtered) as NSString
        
        return (string == filtered) && newStr.length <= maxlimit
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        txtDept = textField.text!
    }
    
    func addDepartment() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let deptName: String = txtDept//txtName.text!
        
        let api = "UserManagement/CreateDepartment?departmentName=\(deptName)"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.txtDept = ""
                            self.alertSample(strTitle: "", strMsg: "Department added successfully")
                            
                        } else {
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                        
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.getDepartments()
                        
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func updateDepartment() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let deptName: String = txtDept//txtName.text!
        
        let api = "UserManagement/UpdateDepartment"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let parameters = ["DepartmentId": selDeptId, "Name": deptName] as [String:Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.txtDept = ""
                            self.selDeptId = 0
                            self.editFlag = false
                            self.alertSample(strTitle: "", strMsg: "Department updated successfully")
                            
                        } else {
                            self.txtDept = ""
                            self.selDeptId = 0
                            self.editFlag = false
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                        
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
                    DispatchQueue.main.async {
                        self.txtName.text = ""
                        self.btnAdd.setTitle("ADD DEPARTMENT", for: UIControl.State.normal)
                        self.stopActivityIndicator()
                        self.getDepartments()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func deleteDepartment() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let deptName: String = txtName.text!
        
        let api = "UserManagement/DeleteDepartment?departmentId=\(selDeptId)"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.txtDept = ""
                            self.selDeptId = 0
                            self.alertSample(strTitle: "", strMsg: "Department deleted successfully")
                            
                        } else {
                            self.txtDept = ""
                            self.selDeptId = 0
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                        
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.getDepartments()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func onEditClick(tag: Int, flag: Bool) {
        
        if flag {
            editFlag = true
            editAction(tag: tag)
        } else {
            
            deleteAction(tag: tag)
        }
    }
    
    func editAction(tag: Int) {
        let data = arrDept[tag] as! Dept
        selDeptId = data.DepartmentId
        //txtName.text = data.Name
        txtDept = data.Name
        
        tblDept.reloadData()
        //btnAdd.setTitle("UPDATE DEPARTMENT", for: UIControlState.normal)
    }
    
    func deleteAction(tag: Int) {
        let alert = UIAlertController(title: "", message: "Do your really want to delete this department?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
            let data = self.arrDept[tag] as! Dept
            self.selDeptId = data.DepartmentId
            self.deleteDepartment()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func addAction() {
        
        if (txtDept.isEmpty) {
            
            alertSample(strTitle: "", strMsg: "Please enter department name")
            
        } else {
            if !editFlag {
                addDepartment()
            } else {
                
                updateDepartment()
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
