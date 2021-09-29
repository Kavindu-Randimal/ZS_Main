//
//  RolesVC.swift
//  ZorroSign
//
//  Created by Apple on 01/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class RolesVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, labelCellDelegate, DeptCellProtocol
{
    var arrRoles: NSMutableArray = NSMutableArray.init()
    
    var arrPermissions = ["Admin Privileges", "Manage Departments", "Manage Roles", "Manage Users", "Manage Seal", "Create Workflow", "Publish Workflow", "Delete Workflow", "Manage Token Permission", "View Reports" ]
    
    var arrPermissionValues = ["AdminPrivileges","ManageDepartments","ManagerRoles","ManageUsers","AccessAdminPage","CreateWorkflow","PublishWorkflow","DeleteWorkflow","ManagerTokenPermissions","ViewReports"]
    
    var arrPermissionIds = [0,6,8,7,5,1,2,3,9,4]
    /*
     ["AdminPrivileges", "ManageDepartments", "ManagerRoles", "ManageUsers", "AccessAdminPage",…]
     0: "AdminPrivileges"
     1: "ManageDepartments"
     2: "ManagerRoles"
     3: "ManageUsers"
     4: "AccessAdminPage"
     5: "CreateWorkflow"
     6: "PublishWorkflow"
     7: "DeleteWorkflow"
     8: "ManagerTokenPermissions"
     */
    @IBOutlet weak var tblRoles: UITableView!
    
    var strRoleName: String = ""
    var arrSelRoles:[String] = []
    var editFlag: Bool = false
    var selRoleId: Int = 0
    var selRoleData: RoleData!
    var permissionIds:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        // Do any additional setup after loading the view.
        
        tblRoles.separatorStyle = .none
        tblRoles.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblRoles.frame.size.width, height: 1))
        
        addFooterView()
        getRoles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getRoles() {
        
        arrRoles = NSMutableArray.init()
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/GetAllRoles"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                   
                    let jsonObj: JSON = JSON(response.result.value)
                       
                        print("response: \(jsonObj)")
                        let data = jsonObj["Data"].array
                        for dic in data! {
                            
                            let dict = dic.dictionaryObject
                            let roledata = RoleData(dictionary: dict!)
                            /*
                            if let arr = dict!["Permissions"] as? [Int] {
                                for id in arr {
                                    roledata.Permissions.append(id)
                                }
                            }*/
                            self.arrRoles.add(roledata)
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.tblRoles.reloadData()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }

    func createRole() {
        //["AdminPrivileges", "ManageDepartments", "ManagerRoles", "ManageUsers", "AccessAdminPage"],
        /*
         {"Name":"ss","Permissions":["AdminPrivileges","ManageDepartments","ManagerRoles","ManageUsers","AccessAdminPage"]}
         */
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/CreateRole"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let parameters = ["Name" : strRoleName, "Permissions": arrSelRoles] as [String:Any]
        
        print("create role parameters: \(parameters)")
        print("############")
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    print("create role response:")
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.strRoleName = ""
                            self.arrSelRoles.removeAll()
                            self.alertSample(strTitle: "", strMsg: "Role added successfully")
                            
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
                        self.getRoles()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }

    func editRole() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        formatPermissionArray()
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/EditRole"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let parameters = ["RoleId": selRoleId, "IsDefault": selRoleData.IsDefault, "Name" : strRoleName, "Permissions": permissionIds] as [String:Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.permissionIds.removeAll()
                            self.alertSample(strTitle: "", strMsg: "Role edited successfully")
                            
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
                        self.strRoleName = ""
                        self.arrSelRoles.removeAll()
                        self.getRoles()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }

    
    func deleteRole() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/DeleteRole?roleId=\(selRoleId)"
        
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
                            self.alertSample(strTitle: "", strMsg: "Role deleted successfully")
                            
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
                        self.strRoleName = ""
                        self.arrSelRoles.removeAll()
                        self.getRoles()
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 12
        }
        return arrRoles.count
    }

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (cell.responds(to: #selector(getter: UIView.tintColor))) {
            let cornerRadius: CGFloat = 5
            cell.backgroundColor = UIColor.clear
            let layer: CAShapeLayer  = CAShapeLayer()
            let pathRef: CGMutablePath  = CGMutablePath()
            let bounds: CGRect  = cell.bounds.insetBy(dx: 4, dy: 0)
            var addLine: Bool  = false
            if (indexPath.row == 0 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                pathRef.__addRoundedRect(transform: nil, rect: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
            } else if (indexPath.row == 0) {
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.maxY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.minY), tangent2End: CGPoint(x:bounds.midX,y:bounds.minY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.minY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.maxY))
                addLine = true;
            } else if (indexPath.row == tableView.numberOfRows(inSection: indexPath.section)-1) {
                
                pathRef.move(to: CGPoint(x:bounds.minX,y:bounds.minY))
                pathRef.addArc(tangent1End: CGPoint(x:bounds.minX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.midX,y:bounds.maxY), radius: cornerRadius)
                
                pathRef.addArc(tangent1End: CGPoint(x:bounds.maxX,y:bounds.maxY), tangent2End: CGPoint(x:bounds.maxX,y:bounds.midY), radius: cornerRadius)
                pathRef.addLine(to: CGPoint(x:bounds.maxX,y:bounds.minY))
                
            } else {
                pathRef.addRect(bounds)
                addLine = true
            }
            layer.path = pathRef
            //CFRelease(pathRef)
            //set the border color
            layer.strokeColor = UIColor.lightGray.cgColor;
            //set the border width
            layer.lineWidth = 1
            layer.fillColor = UIColor(white: 1, alpha: 1.0).cgColor
            
            
            if (addLine == true) {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat  = (1 / UIScreen.main.scale)
                lineLayer.frame = CGRect(x:bounds.minX, y:bounds.size.height-lineHeight, width:bounds.size.width, height:lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor!.cgColor
                layer.addSublayer(lineLayer)
            }
            
            let testView: UIView = UIView(frame:bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = UIColor.clear
            cell.backgroundView = testView
        }
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "roleCell") as! UITableViewCell
                
                let txtfld = cell.viewWithTag(4) as! UITextField
                txtfld.delegate = self
                txtfld.text = strRoleName
                
                return cell
            }
            if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "headCell") as! UITableViewCell
                return cell
            }
            if indexPath.row > 1 && indexPath.row < 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "chkCell") as! LabelCell
                
                cell.lblName.text = arrPermissions[indexPath.row - 2]
                
                if indexPath.row > 2 && indexPath.row < 7 {
                    cell.btnchkW.constant = 25
                }
                cell.delegate = self
                cell.btnchk.tag = indexPath.row
                
                let str = arrPermissionValues[indexPath.row - 2]
                if arrSelRoles.contains(str) {
                    cell.btnchk.isSelected = true
                } else {
                    cell.btnchk.isSelected = false
                }
                
                return cell
            }
            if indexPath.row == 11 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell") as! UITableViewCell
                
                let btnsave = cell.viewWithTag(4) as! UIButton
                btnsave.addTarget(self, action: #selector(saveAction), for: UIControl.Event.touchUpInside)
                
                let btncancel = cell.viewWithTag(2) as! UIButton
                btncancel.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
                
                
                return cell
            }
        }
        if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailCell") as! CustomCell
            
            let data = arrRoles[indexPath.row] as! RoleData
            let name: String = data.Name!
            //print("Name: \(name)")
            cell.lblGen?.text = name
           // print("Name: \(cell.textLabel?.text)")
            
            cell.btnEdit.accessibilityHint = "edit"
            cell.btnDelete.accessibilityHint = "delete"
            
            /*
             "CreateWorkflow",
             "PublishWorkflow",
             "DeleteWorkflow",
             "ViewReports",
             "AccessAdminPage",
             "ManageDepartments",
             "ManageUsers",
             "ManagerRoles",
             "ManagerTokenPermissions"
             */
            
            /*if let permissions = data.Permissions as? NSArray {
                if permissions.contains(1) && permissions.contains(2) && permissions.contains(3) && permissions.contains(4) && permissions.contains(5) && permissions.contains(6) && permissions.contains(7) && permissions.contains(8) && permissions.contains(9)
                {*/
                if data.IsDefault { // check for admin
                    cell.btnDelete.isEnabled = false
                    cell.btnEdit.isEnabled = false
                }
                else {
                    cell.btnDelete.isEnabled = true
                    cell.btnEdit.isEnabled = true
                }
        /*} else {
            cell.btnDelete.isEnabled = true
        }*/
            
            cell.btnEdit.tag = indexPath.row
            cell.btnDelete.tag = indexPath.row
            
            cell.deptDelegate = self
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                return 65
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            view.text = "Add New Role"
            //view.backgroundColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/155.0, alpha: 1)
            //view.textColor = UIColor(red: 39.0/255.0, green: 171.0/255.0, blue: 17.0/155.0, alpha: 1)
            view.textColor = UIColor.black
            
            return view
        }
        if section == 1 {
        let header = tableView.dequeueReusableCell(withIdentifier: "roleHeadCell")
        
        return header?.contentView
        }
        return nil
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
        let charset = CharacterSet(charactersIn: Singletone.shareInstance.alphaNumCharset).inverted
        let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
        
        let maxlimit = 50
        let currStr: NSString = textField.text! as NSString
        let newStr: NSString = currStr.replacingCharacters(in: range, with: filtered) as NSString
        
        
        return (string == filtered) && newStr.length <= maxlimit
        
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        strRoleName = textField.text!
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        strRoleName = textField.text!
        return true
    }
    
    // add the permision ids to send it back to server
    func formatPermissionArray() {
        for i in arrSelRoles {
            switch i {
            case "CreateWorkflow":
                permissionIds.append(1)
            case "PublishWorkflow":
                permissionIds.append(2)
            case "DeleteWorkflow":
                permissionIds.append(3)
            case "AccessAdminPage":
                permissionIds.append(5)
            case "ManageDepartments":
                permissionIds.append(6)
            case "ManageUsers":
                permissionIds.append(7)
            case "ManagerRoles":
                permissionIds.append(8)
            case "ManagerTokenPermissions":
                permissionIds.append(9)
            default:
                print("")
            }
        }
    }
    
    func onChecked(id: Int, flag: Bool) {
        
        let tag = id - 2
        let str = arrPermissionValues[tag]
        if arrSelRoles.contains(str) {
            let index = arrSelRoles.index(of: str)
            arrSelRoles.remove(at: index!)
            if tag == 0 {
                for i in 1..<5 {
                    let str = arrPermissionValues[i]
                    let index = arrSelRoles.index(of: str)
                    arrSelRoles.remove(at: index!)
                }
            }
            if tag == 1 || tag == 2 || tag == 3 || tag == 4 {
                if arrSelRoles.contains("AdminPrivileges") {
                    let idx = arrSelRoles.index(of: "AdminPrivileges")
                    arrSelRoles.remove(at: idx!)
                }
            }
        } else {
            arrSelRoles.append(str)
            if tag == 0 {
                for i in 1..<5 {
                    let str = arrPermissionValues[i]
                    arrSelRoles.append(str)
                }
            }
        }
        tblRoles.reloadData()
    }
    
    @IBAction func saveAction() {
        if strRoleName.isEmpty {
            
            alertSample(strTitle: "", strMsg: "Please enter role name")
            
        } else if arrSelRoles.count == 0 {
            alertSample(strTitle: "", strMsg: "A value required")
        }
        else {
            if editFlag {
                editRole()
            } else {
                createRole()
            }
        }
    }
    
    @IBAction func cancelAction() {
    
        editFlag = false
        strRoleName = ""
        arrSelRoles.removeAll()
        tblRoles.reloadData()
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
        selRoleData = arrRoles[tag] as! RoleData
        selRoleId = selRoleData.RoleId!
        strRoleName = selRoleData.Name!
        arrSelRoles.removeAll()
        
        for id in selRoleData.Permissions {
            if let permIndex = arrPermissionIds.index(of: id){
                let val = arrPermissionValues[permIndex]
                arrSelRoles.append(val)
            }
        }
        if arrSelRoles.contains("ManageDepartments") && arrSelRoles.contains("ManagerRoles") && arrSelRoles.contains("ManageUsers") && arrSelRoles.contains("AccessAdminPage")
        {
            arrSelRoles.append("AdminPrivileges")
        }
        tblRoles.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        tblRoles.reloadData()
        //btnAdd.setTitle("UPDATE DEPARTMENT", for: UIControlState.normal)
    }
    
    func deleteAction(tag: Int) {
        let alert = UIAlertController(title: "", message: "Do your really want to delete this role?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            action in
            
            let data = self.arrRoles[tag] as! RoleData
            self.selRoleId = data.RoleId!
            self.deleteRole()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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
