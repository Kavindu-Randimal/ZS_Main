//
//  UsersVC.swift
//  ZorroSign
//
//  Created by Apple on 03/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import IQKeyboardManagerSwift

class UsersVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, labelCellDelegate, DeptCellProtocol, SubscribeVCDelegate {
    
    var lblArr = ["First Name *:","Middle Name:","Last Name *:","Email *:","Title:","Designation:","Department:","Phone *:"]
    
    var hintArr = ["FirstName","MiddleName","LastName","Email","Title","JobTitle","DepartmentId","PhoneNumber"]
    
    var titleDataArr = ["Mr","Ms","Dr.","Eng."]
    
    var arrRoles: NSMutableArray = NSMutableArray.init()
    var arrSelRoles: [RoleData] = []
    var userArr: NSMutableArray = NSMutableArray.init()
    var arrDept: NSMutableArray = NSMutableArray.init()
    var arrAcc: [AccountData] = []
    var arrProf: [ProfileData] = []
    var arrThumb: [String] = []
    
    var profData: ProfileData = ProfileData()
    var accData: AccountData = AccountData()
    var userDataDic:[String:Any] = [:]
    var editFlag: Bool = false
    var selDeptName: String = ""
    var selTitle: String = ""
    var selIdArr:[Int] = []
    
    @IBOutlet weak var tblUser: UITableView!
    
    var deptPicker: UIPickerView!
    var titlePicker: UIPickerView!
    
    @IBOutlet weak var conW_Arrrow: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        // Do any additional setup after loading the view.
        //        IQKeyboardManager.shared.enable = true
        
        tblUser.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblUser.frame.size.width, height: 1))
        
        addFooterView()
        initUserData()
        getRoles()
        getDepartments()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        usersAPI()
        
    }
    
    //MARK: - SubscribeVC Delegate to call usersAPI
    func callUserApi() {
        usersAPI()
    }
    
    func initUserData(){
        
        userDataDic["FirstName"] = ""
        userDataDic["LastName"] = ""
        userDataDic["Email"] = ""
        userDataDic["PhoneNumber"] = ""
        userDataDic["Title"] = ""
        userDataDic["JobTitle"] = ""
        userDataDic["OrganizationId"] = ""
        
        deptPicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        deptPicker.dataSource = self
        deptPicker.delegate = self
        deptPicker.accessibilityHint = "DepartmentId"
        
        titlePicker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 150))
        titlePicker.dataSource = self
        titlePicker.delegate = self
        titlePicker.accessibilityHint = "Title"
        
    }
    
    func populateUserData() {
        /*
         userDataDic["FirstName"] = profData.FirstName
         userDataDic["LastName"] = profData.LastName
         userDataDic["Email"] = profData.Email
         userDataDic["PhoneNumber"] = profData.PhoneNumber
         userDataDic["Title"] = profData.Title
         userDataDic["JobTitle"] = profData.JobTitle
         userDataDic["OrganizationId"] = accData.OrganizationId
         userDataDic["DepartmentId"] = accData.DepartmentId
         */
        let profDic = profData.toDictionary()
        let accDic = accData.toDictionary()
        
        let mergedDic: NSMutableDictionary = NSMutableDictionary.init()
        mergedDic.addEntries(from: profDic as! [AnyHashable : Any])
        mergedDic.addEntries(from: accDic as! [AnyHashable : Any])
        
        
        for key : Any in mergedDic.allKeys {
            let stringKey = key as! String
            if let keyValue = mergedDic.value(forKey: stringKey){
                userDataDic[stringKey] = keyValue
            }
        }
        print("userDataDic: \(userDataDic)")
        //let predicate = NSPredicate(format: "SELF.DepartmentId =[cd] %d", accData.DepartmentId!)
        //let arr = self.arrDept.filter { ($0.DepartmentId = accData.DepartmentId) }
        //filter{predicate.evaluate(with: $0)} as NSArray
        //if arr.count > 0 {
        // selDeptName = ((arr[0] as? Dept)?.Name)!
        // }
        /*
         if let deptId = accData.DepartmentId as? Int {
         let predicate = NSPredicate(format: "SELF.DepartmentId = [cd] %d", deptId)
         let arr = self.arrDept.filter{ predicate.evaluate(with: $0) }
         selDeptName = (arr[0] as! Dept).Name
         }
         */
        for dept in arrDept {
            if (dept as! Dept).DepartmentId == userDataDic["DepartmentId"] as! Int {
                selDeptName = (dept as! Dept).Name
                break
            }
        }
        tblUser.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: false)
        self.tblUser.reloadData()
    }
    
    func getDepartments() {
        
        self.showActivityIndicatory(uiView: self.view)
        
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
                        var arrDeptName: [String] = []
                        for dic in data! {
                            
                            let dict = dic.dictionaryObject
                            self.arrDept.add(Dept(Name: dict!["Name"] as! String, DepartmentId: dict!["DepartmentId"] as! Int))
                            arrDeptName.append(dict!["Name"] as! String)
                        }
                        self.setPickerData(dataArr: arrDeptName, type: "")
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.deptPicker.reloadAllComponents()
                        self.tblUser.reloadData()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getRoles() {
        
        self.showActivityIndicatory(uiView: self.view)
        
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
                            if let arr = dict!["Permissions"] as? [Int] {
                                for id in arr {
                                    roledata.Permissions.append(id)
                                }
                            }
                            self.arrRoles.add(roledata)
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.tblUser.reloadData()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getUser(userId: String) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let uid:String = userId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let api = "UserManagement/GetUser?userId=\(uid)"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                        print("response: \(jsonObj)")
                        if let data = jsonObj["Data"].dictionaryObject {
                            if let profObj = data["Profile"] as? [[String:Any]] {
                                for profdic in profObj {
                                    self.profData = ProfileData(dictionary: profdic as! [AnyHashable : Any])
                                }
                            }
                            if let accObj = data["Account"] as? [String:Any] {
                                
                                self.accData = AccountData(dictionary: accObj as! [AnyHashable : Any])
                                self.arrSelRoles = []
                                self.arrSelRoles.append(contentsOf: self.accData.Roles)
                            }
                            self.populateUserData()
                        } else {
                            self.alertSample(strTitle: "", strMsg: "Error from server")
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.tblUser.reloadData()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    func usersAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        //arrRoles = NSMutableArray.init()
        userArr = NSMutableArray.init()
        arrAcc = []
        arrProf = []
        arrThumb = []
        
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/GetOrganizationUsers"
        
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
                            var userDic:[String:Any] = [:]
                            if let accObj = dic["Account"].dictionaryObject {
                                
                                let userdata = AccountData(dictionary: accObj)
                                
                                if let profObj = dic["Profile"].arrayObject {
                                    for profdic in profObj {
                                        let profdata = ProfileData(dictionary: profdic as! [AnyHashable : Any])
                                        userDic["Profile"] = profdata
                                        self.arrProf.append(profdata)
                                        self.arrThumb.append(profdata.Thumbnail)
                                        userdata.Thumbnail = profdata.Thumbnail
                                    }
                                }
                                userDic["Account"] = userdata
                                
                                self.arrAcc.append(userdata)
                                
                                
                            }
                            self.userArr.add(userDic)
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.tblUser.reloadData()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.accessibilityHint! == "FirstName" ||  textField.accessibilityHint! == "MiddleName" || textField.accessibilityHint! == "LastName"{
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        if textField.accessibilityHint == "PhoneNumber" {
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.numCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        return true
    }
    
    func addUserAPI() {
        
        /*
         {"FirstName":"userA","MiddleName":"","LastName":"userA","DepartmentId":"0","Email":"userA@gmail.com","Title":"","JobTitle":"","PhoneNumber":"1111111111","OrganizationId":"4hjWMmUuAA16gzlFnKnLgQ%3D%3D","IsActive":true,"IsDeleted":false,"Signature":"","Initials":"","Roles":["928"]}
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        //arrRoles = NSMutableArray.init()
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/RegisterInternalUser"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let accDic = accData.toDictionary()
        var profDic = profData.toDictionary()
        
        var rolesDic: [Int] = []
        
        if arrSelRoles.count > 0 {
            
            for role in arrSelRoles {
                rolesDic.append(role.RoleId!)
            }
            profDic["Roles"] = rolesDic
        }
        
        /*
         jsonObject.put("FirstName",FirstName);
         jsonObject.put("MiddleName",MiddleName);
         jsonObject.put("LastName",LastName);
         jsonObject.put("DepartmentId",DepartId);
         jsonObject.put("Email",Email);
         jsonObject.put("Title",Title);
         jsonObject.put("JobTitle",JobTitle);
         jsonObject.put("PhoneNumber",PhoneNo);
         jsonObject.put("OrganizationId",OrgId);
         jsonObject.put("IsActive",Isactive);
         jsonObject.put("IsDeleted",false);
         jsonObject.put("Signature","");
         jsonObject.put("Initials","");
         
         */
        /*
         let parameters = ["Account": accDic,
         "Profile": [profDic]
         ] as [String:Any]
         */
        let fname: String = profData.FirstName
        let lname: String = profData.LastName
        let middle: String = profData.MiddleName
        let email: String = profData.Email
        let title: String = profData.Title
        let phone: String = profData.PhoneNumber
        let jobTitle: String = profData.JobTitle
        let orgId: String = UserDefaults.standard.string(forKey: "OrganizationId")!
        let isActive: Bool = true
        let isDeleted: Bool = profData.IsDeleted
        let sign: String = ""
        let initial: String = ""
        
        let parameters = ["FirstName": fname, "Email": email, "LastName": lname, "Title": title, "Roles": rolesDic ,"MiddleName": middle, "DepartmentId" : profData.DepartmentId, "PhoneNumber":phone, "JobTitle":jobTitle, "OrganizationId": orgId, "IsActive": isActive, "IsDeleted": isDeleted, "Signature": sign, "Initials": initial] as [String:Any]
        
        print("parameters: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                     let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            //self.dismiss(animated: true, completion: nil)
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "User added successfully.")
                                
                            }
                            
                        }
                        else
                        {
                            let msg: String = jsonObj["Message"].stringValue
                            self.alertSample(strTitle: "", strMsg: msg)
                            //self.alertSample(strTitle: "", strMsg: "Error adding user")
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.userDataDic.removeAll()
                        self.arrSelRoles.removeAll()
                        self.selDeptName = ""
                        self.usersAPI()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func updateUserAPI() {
        //UpdateUser
        /*
         {"Account":{"UserID":"H62mAmIk4Ty9tsb2HGQJ%2Fw%3D%3D","SPassId":"","Email":"a@bc.com","OrganizationId":"37VBXu3HN1QTfr7SANccTg%3D%3D","DepartmentId":"0","IsActive":false,"IsDeleted":false,"IsLocked":false,"Status":0,"UserType":1,"Roles":[{"RoleId":"436"}],"Permissions":[],"ProfileCompletionStatus":2,"IsSubscribed":false,"CretedBy":null,"ModifiedBy":null,"SubscriptionExpiryDate":"0001-01-01T00:00:00"},"Profile":[{"ProfileId":"9qrdcUikcMEqns391XocSw%3D%3D","UserId":"H62mAmIk4Ty9tsb2HGQJ%2Fw%3D%3D","OrganizationId":"37VBXu3HN1QTfr7SANccTg%3D%3D","Email":"a@bc.com","FirstName":"abc","MiddleName":"abc","MiddleInitials":"","LastName":"abc","Rating":0,"Link":"","Locale":"","Picture":"","Thumbnail":"","ThumbnailURL":"","IsActive":true,"IsDeleted":false,"IsWelcomeVisible":false,"IsVideoHelpVisible":false,"IsDefault":false,"AddressLine1":"","AddressLine2":"","ZipCode":"","StateCode":"","City":"","County":"","Country":"","CountryCode":"","Address":"","OfficialName":"","Suffix":"","Title":"Ms","JobTitle":"tester","PhoneNumber":"123456788","UserSignatureId":0,"Signature":"","Initials":"","SignatureDescription":null,"UserSignatures":null,"ProfileStatus":2,"Settings":null,"CreatedBy":null,"ModifiedBy":null,"UserType":1,"IsMerged":false,"BusinessName":"","DepartmentId":"0"}]}
         
         ["Profile": {
         Email = "a@bc.com";
         FirstName = abc;
         Initials = "";
         IsActive = 0;
         IsDeleted = 0;
         JobTitle = tester;
         LastName = abc;
         MiddleName = abc;
         OrganizationId = "37VBXu3HN1QTfr7SANccTg%3D%3D";
         PhoneNumber = 123456788;
         Signature = "";
         Title = Ms;
         }, "Account": {
         DepartmentId = 0;
         Email = "a@bc.com";
         IsActive = 0;
         IsDeleted = 0;
         IsLocked = 0;
         IsSubscribed = 0;
         OrganizationId = "37VBXu3HN1QTfr7SANccTg%3D%3D";
         Permissions =     (
         );
         ProfileCompletionStatus = 2;
         Roles =     (
         {
         RoleId = 436;
         }
         );
         SPassId = "";
         Status = 0;
         SubscriptionExpiryDate = "0001-01-01T00:00:00";
         UserID = "H62mAmIk4Ty9tsb2HGQJ%2Fw%3D%3D";
         UserType = 1;
         }]
         */
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "UserManagement/UpdateUser"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let accDic = accData.toDictionary()
        var profDic = profData.toDictionary()
        
        var rolesDic: [[String:Any]] = []
        
        if arrSelRoles.count > 0 {
            
            for role in arrSelRoles {
                rolesDic.append(["RoleId": role.RoleId!])
            }
            accDic["Roles"] = rolesDic
        } else {
            accDic["Roles"] = "null"
        }
        /*
         let userid = accDic["UserID"] as! String
         
         let uid:String = userid.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
         
         accDic["UserID"] = uid*/
        
        let parameters = ["Account": accDic, "Profile": [profDic]] as [String:Any]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        
        print("parameters: \(jsonString)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            //self.dismiss(animated: true, completion: nil)
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "User updated successfully.")
                                
                            }
                            
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error updating user")
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.userDataDic.removeAll()
                        self.arrSelRoles.removeAll()
                        self.selDeptName = ""
                        self.editFlag = false
                        self.usersAPI()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func lockUserAPI(userId: String){
        
        //LockUser?userId=WP6m68gmFBe%252F%252FqBz2vF6yg%253D%253D
        //UnlockUser?userId=
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let uid:String = userId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let api = "UserManagement/LockUser?userId=\(uid)"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "User locked successfully.")
                                
                            }
                            
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error")
                        }
                
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.usersAPI()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    func unlockUserAPI(userId: String){
        
        //LockUser?userId=WP6m68gmFBe%252F%252FqBz2vF6yg%253D%253D
        //UnlockUser?userId=
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let uid:String = userId.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        let api = "UserManagement/UnlockUser?userId=\(uid)"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "User unlocked successfully.")
                                
                            }
                            
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error")
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.usersAPI()
                    }
                    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrRoles.count + 9
        }
        return self.userArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryTxtCell") as! CustomCell
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "entryTxtCell") as! CustomCell
            
            cell.con_logoW.constant = 0
            
            if (indexPath.row >= 0 && indexPath.row < 4) {
                let label = cell.viewWithTag(1) as! UILabel
                label.text = lblArr[indexPath.row]
                
                let txtfld = cell.viewWithTag(2) as! UITextField
                txtfld.accessibilityHint = hintArr[indexPath.row]
                txtfld.delegate = self
                txtfld.text = userDataDic[txtfld.accessibilityHint!] as? String
                txtfld.isEnabled = true
                
                if hintArr[indexPath.row] == "Email" && editFlag {
                    txtfld.isEnabled = false
                }
                
            } else if  ((indexPath.row > arrRoles.count + 3) && indexPath.row < arrRoles.count + 8) {
                let label = cell.viewWithTag(1) as! UILabel
                if indexPath.row > arrRoles.count {
                    label.text = lblArr[indexPath.row - arrRoles.count]
                }
                let txtfld = cell.viewWithTag(2) as! UITextField
                txtfld.accessibilityHint = hintArr[indexPath.row - arrRoles.count]
                txtfld.delegate = self
                txtfld.text = userDataDic[txtfld.accessibilityHint!] as? String
                
                if txtfld.accessibilityHint == "Title" {
                    cell.con_logoW.constant = 25
                    txtfld.text = userDataDic[txtfld.accessibilityHint!] as? String
                    txtfld.inputView = titlePicker
                    txtfld.inputAccessoryView = self.addDoneButton()
                    txtfld.placeholder = "Select Title"
                    
                }
                
                if txtfld.accessibilityHint == "DepartmentId" {
                    cell.con_logoW.constant = 25
                    txtfld.text = selDeptName
                    txtfld.inputView = deptPicker
                    txtfld.inputAccessoryView = self.addDoneButton()
                    txtfld.placeholder = "Select Department"
                }
                
            }
            if indexPath.row > 3 && indexPath.row < (arrRoles.count + 4) {
                
                var cell: LabelCell!
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                
                if indexPath.row == 4 {
                    cell = (arr?[2] as? UITableViewCell)! as? LabelCell
                } else {
                    cell = (arr?[0] as? UITableViewCell)! as? LabelCell
                }
                
                cell?.delegate = self
                let lbl = cell?.viewWithTag(2) as! UILabel
                if arrRoles.count > indexPath.row - 4 {
                    let roledata = arrRoles[indexPath.row - 4] as! RoleData
                    lbl.text = roledata.Name
                    
                    cell?.btnchk.tag = indexPath.row - 4
                    
                    let arr = arrSelRoles.filter{ ($0.RoleId == roledata.RoleId) }
                    if arrSelRoles.contains(roledata) || arr.count > 0 {
                        cell?.btnchk.isSelected = true
                    } else {
                        cell?.btnchk.isSelected = false
                    }
                }
                return cell!
            }
            
            if indexPath.row == arrRoles.count + 8 {
                let footer = tableView.dequeueReusableCell(withIdentifier: "btnCell") as! CustomCell
                
                let btnsave = footer.contentView.viewWithTag(4) as! UIButton
                btnsave.addTarget(self, action: #selector(saveAction), for: UIControl.Event.touchUpInside)
                
                let btncancel = footer.contentView.viewWithTag(2) as! UIButton
                btncancel.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
                
                return footer
            }
            return cell
        }
        if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
                
                let btnSub = cell?.viewWithTag(1) as! UIButton
                let btnBuy = cell?.viewWithTag(2) as! UIButton
                
                btnSub.addTarget(self, action: #selector(subscribeAction), for: UIControl.Event.touchUpInside)
                
                return cell!
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! CustomCell
            
            let row = indexPath.row - 1
            let userdata = userArr.object(at: row) as! [String:Any]
            let uname = cell.viewWithTag(2) as! UILabel
            let accdata = userdata["Account"] as! AccountData
            uname.text = accdata.Email//"ssss"
            
            cell.isLocked = accdata.IsLocked
            cell.email = accdata.Email
            
            cell.btnEdit.accessibilityHint = "edit"
            cell.btnDelete.accessibilityHint = "delete"
            
            cell.btnEdit.tag = row
            cell.btnDelete.tag = row
            cell.btnDelete.isSelected = !accdata.IsLocked
            cell.deptDelegate = self
            
            
            cell.configUserReset()
            
            let usrdata = self.userArr[row] as! [String:Any]
            let thumbnail = (usrdata["Profile"] as! ProfileData).Thumbnail
            
            let profIcon = cell.viewWithTag(1) as! UIImageView
            
            if thumbnail != "" {
                // This validation used because of some old accounts use empty canvas uploaded as their profile image
                if thumbnail == "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADIAAAAyCAYAAAAeP4ixAAAAkElEQVRoQ+2SwQkAMAyEkv2X7g6CUIL9nxDtzpG3R+6YDvmtZEUqIhnoa0liMbYiWJ00rIgkFmMrgtVJw4pIYjG2IlidNKyIJBZjK4LVScOKSGIxtiJYnTSsiCQWYyuC1UnDikhiMbYiWJ00rIgkFmMrgtVJw4pIYjG2IlidNKyIJBZjK4LVScOKSGIx9kyRBxCRADOd5J92AAAAAElFTkSuQmCC" {
                    profIcon.image = UIImage(named:"sign_up-gray")
                } else {
                    profIcon.image =  convertBase64StringToImage(imageBase64String: thumbnail.components(separatedBy: ",")[1])
                }
            } else {
                profIcon.image = UIImage(named:"sign_up-gray")
            }
            
//            let strImgArr = thumbnail.split(separator: ",")
//            if strImgArr.count > 1 {
//                profIcon.image =  convertBase64StringToImage(imageBase64String: thumbnail.components(separatedBy: ",")[1])
//            } else {
//                profIcon.image = UIImage(named:"sign_up-gray")
//            }
            
            profIcon.layer.cornerRadius = profIcon.frame.size.width / 2;
            profIcon.clipsToBounds = true
            //let btnexp = cell.viewWithTag(5) as! UIButton
            cell.btnExpand.tag = row
            
            //let lblEmail = cell.viewWithTag(7) as! UILabel
            //let lblSubExp = cell.viewWithTag(8) as! UILabel
            
            cell.lblEmail.text = accdata.Email
            if accdata.IsSubscribed {
                cell.lblDate.text = accdata.SubscriptionExpiryDate?.formatDateWith(format: "MMM dd,yyyy")
            } else {
                cell.lblDate.text = "Not subscribed"
            }
            
            return cell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Add User"
        }
        return ""
    }
    
    /*
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     //headerCell
     if section == 1 {
     let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
     
     let btnSub = cell?.viewWithTag(1) as! UIButton
     let btnBuy = cell?.viewWithTag(2) as! UIButton
     
     btnSub.addTarget(self, action: #selector(subscribeAction), for: UIControlEvents.touchUpInside)
     return cell?.contentView
     }
     return UIView()
     }*/
    /*
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     if section == 1 {
     return 110
     }
     return 0
     }*/
    /*
     func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
     
     if section == 0 {
     let footer = tableView.dequeueReusableCell(withIdentifier: "btnCell") as! CustomCell
     
     let btnsave = footer.contentView.viewWithTag(4) as! UIButton
     btnsave.addTarget(self, action: #selector(saveAction), for: UIControlEvents.touchUpInside)
     
     let btncancel = footer.contentView.viewWithTag(2) as! UIButton
     btncancel.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
     
     return footer.contentView
     }
     return nil
     }*/
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selIdArr.contains(indexPath.row-1) {
            return 100
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            return 80
        }
        if indexPath.section == 0 && indexPath.row == 4 {
            return 93
        }
        if indexPath.section == 0 && indexPath.row > 4 && indexPath.row < (arrRoles.count + 4){
            return 40
        }
        if indexPath.section == 0 {
            return 70
        }
        return 60
    }
    
    
    
    func onChecked(id: Int, flag: Bool) {
        
        let data = arrRoles[id] as! RoleData
        
        let selArr = arrSelRoles.filter{ ($0.RoleId == data.RoleId) }
        if selArr.count > 0 {
            let index = arrSelRoles.index(of: selArr[0])
            arrSelRoles.remove(at: index!)
        } else {
            arrSelRoles.append(data)
        }
        tblUser.reloadData()
    }
    
    @IBAction func subscribeAction(_ sender: UIButton) {
        
        if FeatureMatrix.shared.subscription_reassigning {
            let usrArr = arrAcc.filter{ ($0.IsSubscribed == false) }
            
            let subscribeVC = getVC(sbId: "SubscribeVC_ID") as! SubscribeVC
            subscribeVC.subscriptionVCDelegate = self
            subscribeVC.orgUserArr = arrAcc //usrArr
            subscribeVC.profArr = arrProf
            //subscribeVC.filtertedArray = usrArr
            //subscribeVC.thumbArr = arrThumb
            self.present(subscribeVC, animated: false, completion: nil)
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.accessibilityHint! != "DepartmentId" && textField.accessibilityHint! != "Title" {
            userDataDic[textField.accessibilityHint!] = textField.text
        }
        print("userDataDic: \(userDataDic)")
        
    }
    
    func onEditClick(tag: Int, flag: Bool) {
        
        if flag {
            editFlag = true
            editAction(tag: tag)
        } else {
            let usrdata = userArr[tag] as! [String:Any]
            let uid = (usrdata["Account"] as! AccountData).UserID
            let profileId = (usrdata["Profile"] as! ProfileData).ProfileId
            let isLocked = (usrdata["Account"] as! AccountData).IsLocked
            let logUserId = UserDefaults.standard.string(forKey: "OrgProfileId")
            
            if profileId != logUserId {
                
                if isLocked {
                    unlockUserAPI(userId: uid!)
                } else {
                    lockUserAPI(userId: uid!)
                }
            } else {
                self.alertSample(strTitle: "", strMsg: "Logged user can not be locked")
            }
            //deleteAction(tag: tag)
        }
    }
    
    func onExpandClick(tag: Int, flag: Bool) {
        print("on expand click: \(tag), \(flag)")
        if flag {
            selIdArr.append(tag)
        } else {
            if selIdArr.contains(tag) {
                let index = selIdArr.index(of: tag)
                selIdArr.remove(at: index!)
            }
        }
        tblUser.beginUpdates()
        tblUser.endUpdates()
        //tblUser.reloadData()
    }
    
    func editAction(tag: Int) {
        let usrdata = userArr[tag] as! [String:Any]
        let uid = (usrdata["Account"] as! AccountData).UserID
        getUser(userId: uid!)
    }
    
    func validateFields() -> Bool {
        
        let emailstr = userDataDic["Email"] as? String
        let arr = arrAcc.filter{ $0.Email == emailstr }
        
        if let fname = userDataDic["FirstName"] as? String, fname.isEmpty {
            alertSample(strTitle: "", strMsg: "Please enter first name")
            return false
        }
        if let lname = userDataDic["LastName"] as? String, lname.isEmpty {
            alertSample(strTitle: "", strMsg: "Please enter last name")
            return false
        }
        if let email = userDataDic["Email"] as? String, email.isEmpty {
            alertSample(strTitle: "", strMsg: "Please enter email")
            return false
        }
        if let email = userDataDic["Email"] as? String, Singletone.shareInstance.isValidEmail(testStr: email) == false {
            alertSample(strTitle: "", strMsg: "Email should be in valid format")
            return false
        }
        if !editFlag && arr.count > 0 {
            if let newemailstr = emailstr {
                if !newemailstr.isEmpty {
                    alertSample(strTitle: "", strMsg: "User already exists")
                    return false
                }
            }
            return false
        }
        
        if let phone = userDataDic["PhoneNumber"] as? String, phone.isEmpty {
            alertSample(strTitle: "", strMsg: "Please enter phone number")
            return false
        }
        if !editFlag {
            if arrSelRoles.count > 0 {
                var roleDic: [[String:Any]] = []
                for role in arrSelRoles {
                    roleDic.append(role.toDictionary() as! [String : Any])
                }
                userDataDic["Roles"] = roleDic
            }
        }
        profData = ProfileData(dictionary: userDataDic)
        accData = AccountData(dictionary: userDataDic)
        
        return true
    }
    
    @IBAction func saveAction() {
        if validateFields() {
            if editFlag {
                updateUserAPI()
            } else {
                addUserAPI()
            }
        }
    }
    
    @IBAction func cancelAction() {
        
        self.editFlag = false
        self.userDataDic.removeAll()
        self.arrSelRoles.removeAll()
        self.selDeptName = ""
        tblUser.reloadData()
    }
    
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let hint = pickerView.accessibilityHint
        if hint == "Title" {
            return titleDataArr.count
        }
        return arrDept.count
    }
    
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            
            pickerLabel?.textAlignment = .center
        }
        if pickerView.accessibilityHint == "Title" {
            let title = self.titleDataArr[row]
            pickerLabel?.text = title//pickerDataArray[row] as! String
            
        }
        if pickerView.accessibilityHint == "DepartmentId" {
            let deptData = self.arrDept[row] as! Dept
            pickerLabel?.text = deptData.Name//pickerDataArray[row] as! String
            
        }
        pickerLabel?.textColor = UIColor.black
        pickerLabel?.font = UIFont.systemFont(ofSize: 20)
        
        return pickerLabel!
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.accessibilityHint == "DepartmentId" {
            let deptData = self.arrDept[row] as! Dept
            userDataDic["DepartmentId"] = deptData.DepartmentId
            selDeptName = deptData.Name
        }
        if pickerView.accessibilityHint == "Title" {
            let title = self.titleDataArr[row]
            userDataDic["Title"] = title
            selTitle = title
        }
        
        //self.tblUser.reloadData()
    }
    
    override func donePicker (sender: UIBarButtonItem) {
        self.tblUser.reloadData()
        self.view.endEditing(true)
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
    
    func btnResetClicked(isLocked: Bool, email: String) {
        AlertProvider.init(vc: self).showAlertWithActions(title: "Confirmation", message: "Do you want to reset the password of \(email)", actions: [AlertAction(title: "Cancel"), AlertAction(title: "Confirm")]) { (action) in
            
            if action.title == "Confirm" {
                print(email)
                print(isLocked)
                
                self.showActivityIndicatory(uiView: self.view)
                self.sendResentLink(email: email) { (success, statusCode, message) in
                    self.stopActivityIndicator()
                    if success {
                        AlertProvider.init(vc: self).showAlert(title: "Success", message: "You have successfully made a request to reset the password of \(email).", action: AlertAction(title: "OK"))
                    } else {
                        AlertProvider.init(vc: self).showAlert(title: "Failed", message: message, action: AlertAction(title: "OK"))
                    }
                }
            }
        }
    }
    
    func sendResentLink(email: String, completion: @escaping (Bool, Int, String) -> ()) {
        
        // Check Internet
        guard (Connectivity.isConnectedToInternet()) else {
            completion(true, 1000, "Approved")
            return
        }
        
        let url = "\(Singletone.shareInstance.apiURL)Account/AdminResetPassword"
        
        
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let header = ["Authorization" : "Bearer \(strAuth)"]
        
        let parameters: [String: Any] = [
            "Username" : email
        ]
        
        Alamofire.request(URL(string: url)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            
            
             let jsonObj: JSON = JSON(response.result.value)
                
                if let rawString = jsonObj.rawString() {
                    if rawString.contains("Data") && rawString.contains("StatusCode") {
                        
                        if jsonObj["Data"].boolValue {
                            completion(true, 200, "Success")
                        } else {
                            completion(false, 3653, jsonObj["Message"].stringValue)
                        }
                    } else {
                        completion(false, 3653, "Failed")
                    }
                } else {
                    completion(false, 3653, "Failed")
                }
            
        }
    }
    
    func convertBase64StringToImage(imageBase64String:String) -> UIImage {

            let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))

            let image = UIImage(data: imageData!)

            return image!

        }
}
