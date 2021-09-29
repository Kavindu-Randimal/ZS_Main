//
//  DetailsVC.swift
//  ZorroSign
//
//  Created by Apple on 26/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

@available(iOS 11.0, *)
class DetailsVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIAdaptivePresentationControllerDelegate, labelCellDelegate {

    
    @IBOutlet weak var tblDetails: UITableView!
    //@IBOutlet weak var btnShare: UIButton!
    
    var detailObject:[String:Any]?
    
    var selCategory: Int?
    
    @IBOutlet weak var con_tblHgt: NSLayoutConstraint!
    
    
    var printFlag: Bool = false
    var orgArray: NSMutableArray = NSMutableArray.init()
    var processData: ProcessData!
    
    var optionAlert: SwiftAlertView!
    var cancelAlert: SwiftAlertView!
    
    var contactsArr: [ContactsData] = []
    var filteredContArr: [ContactsData] = []
    var selContactsArr: [ContactsData] = []
    var contactAlert: SwiftAlertView!
    var addMeFlag: Bool = false
    
    var searchTxt: String = ""
    var selectAllFlag: Bool = false
    
    var selOption: String = ""
    var selReject: String = ""
    
    //@IBOutlet weak var printBtn: UIButton!
    
    /*
     ["OriginatorImage": cdmTAigxUeYFh0dos8ojw.png, "DueDays": 99794, "Reason": , "ExpiryDateTime": <null>, "CurrentUser": , "CurrentStep": 2, "SortOrder": 1, "EndDate": <null>, "Originator": Ruwan LastName, "DueDateTime": 2291-10-18T00:00:00Z, "TemplateId": 4259, "Flag": 0, "InstanceId": 3261, "CurrentUserList": [], "Template": Test, "ElapsedDays": <null>, "CanAccess": 1, "LabelList": [["LabelColor": #64dd17, "LabelId": 13385, "ParentLabelId": 0, "LabelPath": My Documents/AAAAAA, "LabelName": AAAAAA], ["LabelColor": #707478, "LabelId": 15191, "ParentLabelId": 15257, "LabelPath": My Documents/AAAAAA/Test2/Test2, "LabelName": Test2], ["LabelColor": #ff5722, "LabelId": 15526, "ParentLabelId": 0, "LabelPath": My Documents/Pankaj, "LabelName": Pankaj]], "MainDocumentType": 0, "CurrentUserImage": <null>, "WorkflowSourceCategory": 1, "TotalSteps": 2, "IsExpired": 0, "DocumentSet": Test, "StartDate": 2018-01-02T05:53:06, "DashboardCategoryType": 0]
     */
    override func viewDidLoad() {
        super.viewDidLoad()

        print("details: \(detailObject)")
        // Do any additional setup after loading the view.
        tblDetails.layer.cornerRadius = 5.0
        
        con_tblHgt.constant = 250
        
        
        
        if selCategory == 92 {
            con_tblHgt.constant = 300
            
        } else if selCategory == 93 {
            con_tblHgt.constant = 350
        }
        getProcessDetailsAPI()
        callLabelAPI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selCategory == 92 {
            return 9
        }
        if selCategory == 93 {
            return 9
        }
        return 5
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblDetails
        {
            var cell = tableView.dequeueReusableCell(withIdentifier: "detailCellId") as! DetailsCell
            
            cell.lblTitle.font = UIFont.boldSystemFont(ofSize: 14)
            
            if indexPath.row == 0 {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCellId") as! DetailsCell
                cell.btnPrint.addTarget(self, action: #selector(printDoc), for: UIControl.Event.touchUpInside)
                if selCategory == 93 {
                    //cell.con_workW.constant = 0
                }
                cell.con_dotbtnW.constant = 0
                cell.btnReminder.isHidden = true
                
                if selCategory == 91 {
                    cell.btnReminder.isHidden = false
                    cell.btnReminder.setImage(UIImage(named: "icon_share"), for: UIControl.State.normal)
                    cell.btnReminder.addTarget(self, action: #selector(getContacts), for: UIControl.Event.touchUpInside)
                    
                    if selOption == "Shared To Me" || selOption == "Scanned Token" {
                        cell.btnReminder.isHidden = true
                    }
                }
                
                if selCategory == 92 {
                    cell.con_dotbtnW.constant = 30
                    cell.btnReminder.isHidden = false
                    
                    
                    cell.btnReminder.addTarget(self, action: #selector(sendReminder), for: UIControl.Event.touchUpInside)
                    
                    cell.btnOption.addTarget(self, action: #selector(openMenu(sender:)), for: UIControl.Event.touchUpInside)
                    //cell.btnOption.addTarget(self, action: #selector(showOption), for: UIControlEvents.touchUpInside)
                    
                }
            }
            if indexPath.row == 1 {
                if selCategory == 90 || selCategory == 91 || selCategory == 93 {
                    
                    cell.lblTitle.text = "Workflow Start Date "
                    let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(stdt)"
                    
                } else if selCategory == 92 {
                    
                    cell.lblTitle.text = "Workflow Start Date "
                    let stdt = (processData.CreatedDate ?? "").formatDate()
                    cell.lblText.text = ":   \(stdt)"
                }
            }
            if indexPath.row == 2 {
                if selCategory == 91 {
                    
                    cell.lblTitle.text = "End Date "
                    
                    let stdt = (processData.ModifiedDate as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(stdt)"
                    
                }
                else if selCategory == 90 || selCategory == 92 {
                    cell.lblTitle.text = "Current Step "
                    if let currstep = processData.ProcessingStep,
                        let totsteps = processData.Steps?.count
                    {
                        cell.lblText.text = ":   \(currstep) of \(totsteps)"
                    } else{
                        cell.lblText.text = ":  N/A"
                    }
                } else if selCategory == 93 {
                    
                    
                    cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                    cell.lblTitle.text = "Step "
                    if let currstep = detailObject?["CurrentStep"],
                        let totsteps = processData.Steps?.count
                    {
                        cell.lblText.text = ":   \(currstep) of \(totsteps)"
                    } else{
                        cell.lblText.text = ":  N/A"
                    }
                    /*
                     
                     cell.lblTitle.text = "Start Date "
                     let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                     cell.lblText.text = ":   \(stdt)"
                     */
                }
            }
            
            if indexPath.row == 3 {
                
                if selCategory == 90 {
                    cell.lblTitle.text = "Template Used "
                    let tempstr = detailObject?["Template"] as? String ?? ""
                    cell.lblText.text =  ":   \(tempstr)"
                }
                else if selCategory == 91 {
                    cell.lblTitle.text = "Elapsed Days "
                    let elapseddays = detailObject?["ElapsedDays"] as! Int
                    cell.lblText.text = ":   \(elapseddays)"
                }
                else if selCategory == 92 {
                    /*
                     cell.lblTitle.text = "In Process With"
                     //cell.lblText.text = ":  N/A"
                     //let arr = detailObject?["CurrentUserList"] as? [[String:Any]]
                     for step in processData.Steps! { //![processData.ProcessingStep!] {
                     for tag in step.Tags! {
                     if let signs = tag.SignatoriesData, signs.count > 0 {
                     if let name = signs[0].FriendlyName
                     {
                     cell.lblText.text = cell.lblText.text! + ":   \(name) \n"
                     }
                     }
                     }
                     }*/
                    cell.lblTitle.text = "Originator"
                    let originator = detailObject?["Originator"] ?? ""
                    cell.lblText.text = ":   \(originator)"
                }
                else if selCategory == 93 {
                    /*
                     cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                     cell.lblTitle.text = "By "
                     let reason = detailObject?["CurrentUser"] as! String
                     cell.lblText.text = ":   \(reason)"
                     */
                    /*
                     cell.lblTitle.text = "Template Active Until "
                     let activeUntil = (detailObject?["ExpiryDateTime"] as? String ?? "").formatDate()
                     cell.lblText.text = ":   \(activeUntil)"*/
                    
                    cell.lblTitle.text = "Originator"
                    let originator = detailObject?["Originator"] ?? ""
                    cell.lblText.text = ":   \(originator)"
                }
                else {
                    cell.lblTitle.text = "Start Date "
                    
                    let stdtstr = (detailObject?["StartDate"] as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(stdtstr)"
                    
                }
            }
            if indexPath.row == 4 {
                
                if selCategory == 91 {
                    
                    cell.lblTitle.text = "Template Used "
                    let tempstr = detailObject?["Template"] as? String ?? ""
                    cell.lblText.text =  ":   \(tempstr)"
                    
                } else if selCategory == 92 {
                    /*
                     cell.lblTitle.text = "Since "
                     //let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                     let stdt = (processData.ModifiedDate as? String ?? "").formatDate()
                     cell.lblText.text = ":   \(stdt)"
                     */
                    cell.lblTitle.text = "In Process With"
                    //cell.lblText.text = ":  N/A"
                    //let arr = detailObject?["CurrentUserList"] as? [[String:Any]]
                    //for step in processData.Steps! { //![processData.ProcessingStep!] {
                    
                    let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
                    
                    let step = processData.Steps![processData.ProcessingStep! - 1]
                    for tag in step.Tags! {
                        if let signs = tag.SignatoriesData, signs.count > 0 {
                            for sign in signs {
                                if tag.State == 1 {
                                    if profileId != sign.Id {
                                        if let name = sign.FriendlyName, !(cell.lblText.text?.contains(name))!
                                        {
                                            cell.lblText.text = cell.lblText.text! + ":   \(name) \n"
                                        }
                                    } else if processData.ProcessingStep != 1 {
                                        if let name = sign.FriendlyName, !(cell.lblText.text?.contains(name))!
                                        {
                                            cell.lblText.text = cell.lblText.text! + ":   \(name) \n"
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    //}
                    
                }
                else if selCategory == 93 {
                    /*
                     cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                     cell.lblTitle.text = "On "
                     let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                     cell.lblText.text = ":   \(stdt)"
                     */
                    cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                    cell.lblTitle.text = "By "
                    let reason = detailObject?["CurrentUser"] as! String
                    if selReject == "Expired" {
                        cell.lblText.text = ":   Zorrosign"
                    } else {
                        cell.lblText.text = ":   \(reason)"
                    }
                }
                    /*
                     else if selCategory == 93 {
                     
                     cell.lblTitle.text = "Rejected Details, "
                     cell.lblText.text = ""
                     }*/
                else {
                    cell.lblTitle.text = "Template Active Until "
                    let activeUntil = (detailObject?["ExpiryDateTime"] as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(activeUntil)"
                }
            }
            
            if indexPath.row == 5 {
                if selCategory == 92 {
                    /*
                     cell.lblTitle.text = "Due Date "
                     cell.lblText.text = ":   N/A"
                     
                     //let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                     let step = processData.Steps![processData.ProcessingStep!]
                     if let tags = step.Tags, tags.count > 0 {
                     let stdt = tags[0].DueDate
                     cell.lblText.text = ":   \(stdt)"
                     }
                     */
                    cell.lblTitle.text = "Since "
                    //let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                    let stdt = (processData.ModifiedDate as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(stdt)"
                    
                } else if selCategory == 90 {
                    cell.lblTitle.text = "Template Active Until "
                    let activeUntil = (detailObject?["ExpiryDateTime"] as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(activeUntil)"
                }
                else if selCategory == 93 {
                    /*
                     cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                     cell.lblTitle.text = "Step "
                     if let currstep = detailObject?["CurrentStep"] as? NSNumber,
                     let totsteps = detailObject?["TotalSteps"] as? NSNumber
                     {
                     cell.lblText.text = ":   \(currstep) of \(totsteps)"
                     } else{
                     cell.lblText.text = ": N/A"
                     }*/
                    /*
                     cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                     cell.lblTitle.text = "Reason "
                     let reason = detailObject?["Reason"] as? String ?? ""
                     cell.lblText.text = ":   \(reason)"
                     */
                    cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                    cell.lblTitle.text = "On "
                    let stdt = (processData.ModifiedDate as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(stdt)"
                }
            }
            if indexPath.row == 6 {
                if selCategory == 92 {
                    
                    cell.lblTitle.text = "Due Date "
                    cell.lblText.text = ":   N/A"
                    
                    //let stdt = (detailObject?["StartDate"] as? String ?? "").formatDate()
                    let step = processData.Steps![processData.ProcessingStep! - 1]
                    if let tags = step.Tags, tags.count > 0 {
                        let stdt = (tags[0].DueDate as? String ?? "").formatDate()
                        cell.lblText.text = ":   \(stdt)"
                    }
                }
                else if selCategory == 93 {
                    /*
                     cell.lblTitle.text = "Template Used"
                     let tempstr = detailObject?["DocumentSet"] as? String ?? ""
                     cell.lblText.text =  ":   \(tempstr)"
                     */
                    cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                    cell.lblTitle.text = "Reason "
                    let reason = detailObject?["Reason"] as? String ?? ""
                    cell.lblText.text = ":   \(reason)"
                    
                } else if selCategory == 93 {
                    /*
                     cell.lblTitle.font = UIFont.systemFont(ofSize: 14)
                     cell.lblTitle.text = "By "
                     let reason = detailObject?["CurrentUser"] as! String
                     cell.lblText.text = ":   \(reason)"
                     */
                }
            }
            if indexPath.row == 7 {
                if selCategory == 92 {
                    
                    cell.lblTitle.text = "Template Used"
                    let tempstr = detailObject?["Template"] as? String ?? ""
                    cell.lblText.text =  ":   \(tempstr)"
                    
                }
                else if selCategory == 93 {
                    /*
                     cell.lblTitle.text = "Template Active Until "
                     let activeUntil = (detailObject?["ExpiryDateTime"] as? String ?? "").formatDate()
                     cell.lblText.text = ":   \(activeUntil)"
                     */
                    cell.lblTitle.text = "Template Used"
                    let tempstr = detailObject?["Template"] as? String ?? ""
                    cell.lblText.text =  ":   \(tempstr)"
                }
                
            }
            
            if indexPath.row == 8 {
                if selCategory == 92 || selCategory == 93 {
                    cell.lblTitle.text = "Template Active Until "
                    let activeUntil = (detailObject?["ExpiryDateTime"] as? String ?? "").formatDate()
                    cell.lblText.text = ":   \(activeUntil)"
                }
            }
            return cell
        }
        else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
            
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[0] as? UITableViewCell)! as? LabelCell
            }
            cell?.delegate = self
            let lbl = cell?.lblName as! UILabel
            var data: ContactsData!
            
            data = filteredContArr[indexPath.row]
            lbl.text = data.Name!
            
            cell?.btnchk.tag = indexPath.row
            cell?.btnchk.isSelected = data.selected
            
            return cell!
        }
        
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView != tblDetails {
            let data = filteredContArr[indexPath.row]
            let name: String = data.Name ?? ""//data.FullName!
            
            if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) {
                return 0
            }
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if printFlag && indexPath.row == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        con_tblHgt.constant = tblDetails.contentSize.height
        
    }
   
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "headerCellId") as! CustomCell
        return headerView
    }*/
    
    @IBAction func btnBackAction(_ sender: Any) {
        //self.performSegue(withIdentifier: "segBackDashboard", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func printDoc(_ sender: UIButton) {
        
        if FeatureMatrix.shared.archive_doc {
            let labelId = isValidFolderName(pid: 0)
            if labelId > 0 {
                //alertSample(strTitle: "", strMsg: "Label/Folder name already exists")
                
                addLabelsToDocs(labelId: labelId)
            }
            else {
                addFolderAPI()
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        return true
    }
    
    @IBAction func showWorkflow() {
        
        if FeatureMatrix.shared.view_doc_wf {
            //getProcessDetailsAPI()
            if #available(iOS 11.0, *) {
                let workflowVC = self.getVC(sbId: "WorkflowVC_ID") as! WorkflowVC
                
                let instanceId: String = String(describing:detailObject!["InstanceId"] ?? 0)
                workflowVC.instanceID = instanceId
                self.present(workflowVC, animated: false, completion: nil)
            } else {
                // Fallback on earlier versions
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    func isValidFolderName(pid: Int) -> Int {
        
        let predicate = NSPredicate(format: "SELF.ParentId = 0 and SELF.Name contains [c] %@","Archive")
        
        let arr = self.orgArray.filter{ predicate.evaluate(with: $0) }//{ $0.ParentId == 0 && $0.Name == "Archive" } //{ predicate.evaluate(with: $0) }
        
        if arr.count > 0 {
            let labeldata = LabelData(dictionary:arr[0] as! [AnyHashable : Any])
            return labeldata.Id!
        } else {
            return 0
        }
    }
    
    func callLabelAPI() {
        
        
        self.orgArray.removeAllObjects()
        
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/label/getlabels?labelCategory=1"
        let apiURL = Singletone.shareInstance.apiUserService + api
        //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/getlabels?labelCategory=1"
        
        if Connectivity.isConnectedToInternet() == true
        {
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            let data = jsonObj["Data"].array
                            
                            for dic in data! {
                                
                                print("label dic: \(dic.dictionaryObject)")
                                var labeldata = LabelData(dictionary: dic.dictionaryObject!)
                                
                                self.orgArray.add(labeldata.toDictionary())
                                
                            }
                            
                           
                        }
                        else
                        {
                            
                        }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getProcessDetailsAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        let instanceID = detailObject!["InstanceId"] ?? 0
        var apiURL = Singletone.shareInstance.apiUserService
        
        let api = String("v1/process/GetProcessDetails?processId=\(instanceID)")
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            if statusCode == 1000 {
                                let msg = jsonDic["Message"] as! String
                                //self.alertSample(strTitle: "", strMsg: msg)
                                if #available(iOS 11.0, *) {
                                    self.processData = ProcessData(dictionary: jsonObj as! [AnyHashable : Any])
                                    
                                    self.tblDetails.dataSource = self
                                    self.tblDetails.delegate = self
                                    self.tblDetails.reloadData()
                                } else {
                                    // Fallback on earlier versions
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
    
    func addFolderAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api: String = "v1/label/Create"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        
        let Name: String = "Archive"
        var Color: String = "" //+ colorArr[selColorId]
    
        
        let CreatedProfileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        let LabelCategory = 1
        //let ParentId = 0
        
        let parameters: [String:Any] = ["Name": Name, "Color": Color, "CreatedProfileId": CreatedProfileId, "LabelCategory": 1, "ParentId": 0 ]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            //self.dismiss(animated: true, completion: nil)
                            DispatchQueue.main.async {
                                
                            }
                            let labelId = jsonObj["Data"]
                            self.addLabelsToDocs(labelId: labelId.intValue)
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error adding folder")
                        }
                    
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func addLabelsToDocs(labelId: Int) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/label/AddUserWorkflows"
        let apiURL: String = Singletone.shareInstance.apiUserService + api
        //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/AddUserWorkflows"
        
        /*
         [
         {"ItemId":3178,"LabelId":13385},
         {"ItemId":3265,"LabelId":13385}
         ]
         */
        var docLabelArr = [[String:Any]]()
        
        let docId: Int = detailObject!["InstanceId"] as! Int
        
        
        let dataDic = ["ItemId":docId,"LabelId":labelId]
        docLabelArr.append(dataDic as! [String : Int])
        
            
        
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            //creates the request
            
            var request = URLRequest(url: URL(string: apiURL)!)
            
            request.httpMethod = "POST"
            request.setValue("Bearer \(strAuth)",
                forHTTPHeaderField: "Authorization")
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            //parameter array
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: docLabelArr)
            
            Alamofire.request(request).responseJSON { response in
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                let jsonObj: JSON = JSON(response.result.value!)
                
                if jsonObj["StatusCode"] == 1000
                {
                    
                    DispatchQueue.main.async {
                        self.alertSample(strTitle: "", strMsg: "Document archived successfully.")
                    }
                }
                else
                {
                    self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                }
                DispatchQueue.main.async {
                    self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
    }
    
    
    @objc func getContacts(_ sender: UIButton) {
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
        
        if FeatureMatrix.shared.share_doc {
            
            contactsArr = []
            filteredContArr = []
            
            self.showActivityIndicatory(uiView: self.view)
            
            let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
            let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
            
            let orgId: String = UserDefaults.standard.string(forKey: "OrganizationId")!
            let api = "UserManagement/GetContactSummary?ProfileId==\(orgId)"
            var apiURL = Singletone.shareInstance.apiURL
            apiURL = apiURL + api
            
            
            if Connectivity.isConnectedToInternet() == true {
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
                        self.showContactAlert(sender)
                        
                        
                    }
            } else {
                alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    func showContactAlert(_ sender: UIButton) {
        
        
        let viewController:ShareContactsVC = getVC(sbId: "ShareVC") as! ShareContactsVC
        
        let instanceID: Int = (detailObject!["InstanceId"] ?? 0) as! Int
        let templateID: Int = (detailObject!["TemplateId"] ?? 0) as! Int
        
        viewController.instanceID = instanceID
        viewController.templateID = templateID
        
        let contW: CGFloat = self.view.bounds.width - 80
        let popOverHeight = self.view.frame.size.height / 2 + 75
        
        viewController.preferredContentSize = CGSize(width: contW, height: popOverHeight)
        let navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .popover
        navController.isNavigationBarHidden = true
        if let pctrl = navController.popoverPresentationController {
            pctrl.delegate = self
            pctrl.sourceView = self.view
            pctrl.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            pctrl.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            self.present(navController, animated: true, completion: nil)
        }
        
        
    }
    
    @objc func addMeAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        addMeFlag = !addMeFlag
    }
    
    @objc func addContactAction(_ sender: UIButton) {
        
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
        
        let instanceID = detailObject!["InstanceId"] ?? 0
        let templateID = detailObject!["TemplateId"] ?? 0
        
        var refIds:[[String:Any]] = []
        
        for data in selContactsArr {
            
            let utype: Int = data.UserType!
            
            //if grp utype = 3
            
            let refId: String = data.ContactProfileId!
            
            let dic = ["Type":utype,"ReferenceId":refId,"add":false] as [String : Any]
            refIds.append(dic)
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
                            self.alertSample(strTitle: "", strMsg: "Document shared successfully.")
                        }
                        else
                        {
                        }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func onChecked(id: Int, flag: Bool)
    {
        if selectAllFlag {
            selectAllFlag = false
            
        }
            
        let data = contactsArr[id]
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
        let tablevw = contactAlert.viewWithTag(4) as! UITableView
        tablevw.reloadData()
        
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
        let tablevw = contactAlert.viewWithTag(4) as! UITableView
        tablevw.reloadData()
        
    }
    
    @IBAction func searchInvite(_ sender: UIButton) {
        
        let txtsrch = contactAlert.viewWithTag(23) as! UITextField
        searchTxt = txtsrch.text ?? ""
        
        let tablevw = contactAlert.viewWithTag(4) as! UITableView
        tablevw.beginUpdates()
        tablevw.endUpdates()
        
    }
    
    @IBAction func sortContacts(_ sender: UIButton) {
        
        let titles = ["ALL","CONTACTS","GROUPS","MY COMPANY"]
        let descriptions = ["","","",""]
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.set(descriptions: descriptions)
        
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.preferredContentSize = CGSize(width: 200, height:120)
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
                
                self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 2) }
                break
                
            case 3:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.UserType == 1) }
                break
                
            default:
                break
            }
            
            sender.setTitle(titles[selectRow], for: UIControl.State.normal)
            
            let tablevw = self.contactAlert.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        };
        
        present(popOverViewController, animated: true, completion: nil)
        
        self.view.bringSubviewToFront(popOverViewController.view)
    }
    
    @objc func sendReminder() {
        //https://sandboxworkflow.zorrosign.com/api/v1/process/SendReminder
        //{"ProcessId":11224,"StepNo":1}
        
        if FeatureMatrix.shared.send_remminders {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/process/SendReminder"
        let apiURL: String = Singletone.shareInstance.apiUserService + api
       
        let instanceID = detailObject!["InstanceId"] ?? 0
        let stepNo = processData.ProcessingStep//detailObject!["CurrentStep"] ?? 1
        let parameters: [String:Any] = ["ProcessId":instanceID,"StepNo":stepNo]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                           self.alertSample(strTitle: "", strMsg: "Email reminder sent.")
                        }
                        else
                        {
                            let errmsg: String = "Email reminder already sent."//jsonObj["Message"].stringValue
                            
                            self.alertSample(strTitle: "Information!", strMsg: errmsg)
                        }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    @objc func showOption() {
        
        optionAlert = SwiftAlertView(title: "", message: "", delegate: self, cancelButtonTitle: "Cancel")
        optionAlert.tag = 1
        optionAlert.delegate = self
        optionAlert.show()
        
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 0 {
            if alertView.tag == 1 {
                showCancelAlert()
            }
        }
        if buttonIndex == 1 {
            if alertView.tag == 4 {
                cancelDocAPI()
                
            }
            if alertView.tag == 41 {
                
                if selContactsArr.count == 0 || !addMeFlag {
                    
                    alertSample(strTitle: "", strMsg: "Please select contact")
                    
                } else {
                    shareToContacts()
                }
            }
        }
    }
    func showCancelAlert() {
        
        let arr = Bundle.main.loadNibNamed("SendEmail", owner: self, options: nil)
        let view = arr![1] as! UIView
        
        cancelAlert = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["DONE"])
        cancelAlert.tag = 4
        cancelAlert.dismissOnOtherButtonClicked = false
        cancelAlert.highlightOnButtonClicked = false
        
        let txtreason = cancelAlert.viewWithTag(1) as! UITextView
        txtreason.setBorder()
        /*
        txtreason.layer.borderColor = UIColor(red: 138/255, green: 138/255, blue: 138/255, alpha: 1).cgColor
        txtreason.layer.borderWidth = 1.0
         */
        
        let btnclose = cancelAlert.buttonAtIndex(index: 0)
        let btnadd = cancelAlert.buttonAtIndex(index: 1)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        cancelAlert.show()
        
    }
    func cancelDocAPI() {
        
        let txtreason = cancelAlert.viewWithTag(1) as! UITextView
        let passwd = cancelAlert.viewWithTag(2) as! UITextField
        
        let errreason = cancelAlert.viewWithTag(5) as! UILabel
        let errpasswd = cancelAlert.viewWithTag(6) as! UILabel
        
        let reason: String = txtreason.text
        let pass: String = passwd.text!
        
        print("reason: \(reason)")
        print("pass: \(pass)")
        
        let userpass = UserDefaults.standard.string(forKey: "Pass")
        
        //https://sandboxworkflow.zorrosign.com/api/v1/process/CancelProcess
        //{"Reason":"testing","Password":"Pankaj#11","Processes":[{"ProcessId":11281,"IsBulkSent":false,"ChildProcessList":[]}]}
        
        errreason.text = ""
        errpasswd.text = ""
        
        if reason.isEmpty {
            
            //alertSample(strTitle: "", strMsg: "Please enter reason")
            errreason.text = "Please enter reason"
        }
        else if pass.isEmpty {
            //alertSample(strTitle: "", strMsg: "Please enter password")
            errpasswd.text = "Please enter password"
        }
        else if pass != userpass {
            //alertSample(strTitle: "", strMsg: "Invalid password")
            errpasswd.text = "Error! User password is invalid."
        }
        else {
            
            cancelAlert.dismiss()
            
            self.showActivityIndicatory(uiView: self.view)
            
            let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
            let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
            
            let api = "v1/process/CancelProcess"
            let apiURL: String = Singletone.shareInstance.apiUserService + api
            
            let instanceID = detailObject!["InstanceId"] ?? 0
            
            let parameters: [String:Any] = ["Reason":reason,"Password":pass,"Processes":[["ProcessId":instanceID,"IsBulkSent":false,"ChildProcessList":[]]]]
            
            if Connectivity.isConnectedToInternet() == true
            {
                var request = URLRequest(url: URL(string: apiURL)!)
                
                request.httpMethod = "POST"
                request.setValue("Bearer \(strAuth)",
                    forHTTPHeaderField: "Authorization")
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //parameter array
                
                request.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
                
                Alamofire.request(request).responseJSON { response in
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                    }
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    if jsonObj["StatusCode"] == 1000
                    {
                        
                        DispatchQueue.main.async {
                            self.alertSample(strTitle: "", strMsg: "Document cancelled successfully.")
                            
                        }
                    }
                    else
                    {
                        self.alertSample(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                    }
                    
                    DispatchQueue.main.async {
                        self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                    }
                }
            }
            else
            {
                alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
        }
    }
    
    @objc public func openMenu(sender:UIButton) {
        let titles = ["Cancel"]
        let descriptions = [""]
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.set(descriptions: descriptions)
        
        // option parameteres
        // popOverViewController.setSelectRow(1)
        // popOverViewController.setShowsVerticalScrollIndicator(true)
        // popOverViewController.setSeparatorStyle(UITableViewCellSeparatorStyle.singleLine)
        
        //popOverViewController.popoverPresentationController?.barButtonItem = sender
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.preferredContentSize = CGSize(width: 100, height:40)
        popOverViewController.presentationController?.delegate = self 
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                if FeatureMatrix.shared.cancel_doc {
                    self.showCancelAlert()
                } else {
                    FeatureMatrix.shared.showRestrictedMessage()
                }
                break
            case 1:
                break
            case 2:
                break
            default:
                break
            }
            
        };
        present(popOverViewController, animated: true, completion: nil)
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

@available(iOS 11.0, *)
extension DetailsVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
