//
//  PermisssionsVC.swift
//  ZorroSign
//
//  Created by Apple on 10/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PermissionCell: UITableViewCell {
    
    @IBOutlet weak var btnOpen: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!
}

class PermisssionsVC: BaseVC, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblDoc: UITableView!
    
    var docArr: NSMutableArray = NSMutableArray.init()
    var sharedDocArr: NSMutableArray = NSMutableArray.init()
    
    var selIdArr: [Int] = []
    var selIdArr1: [Int] = []
    
    var rowTxtArr: [String] = ["Access Requested by:","ACCESS REQUESTED BY EMAIL:","Status:"]
    var sharedRowTxtArr: [String] = ["Shared with:","ACCESS REQUESTED BY EMAIL:","Status:"]
    
    var statusArr = ["Pending","Accepted","Rejected","","Shared","Removed"]
    
    var shareType: Int = 0
    var openFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //getUnreadPushCount()
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        tblDoc.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblDoc.frame.size.width, height: 1))
        
        addFooterView()
        // Do any additional setup after loading the view.
        getPermissions()
        getSharedDocs()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return shareType == 0 ? sharedDocArr.count : docArr.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shareType == 0 {
            if sharedDocArr.count > 0 {
                return 4
            }
        } else if shareType == 1 {
            if docArr.count > 0 {
                return 4
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        if indexPath.row < 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "docCell")
            
            let lbl1 = cell?.viewWithTag(1) as! UILabel
            
            
            var docdata:PermissionData! //= self.sharedDocArr[indexPath.section] as! PermissionData
            lbl1.text = sharedRowTxtArr[indexPath.row]
            
            if shareType == 1 {
                lbl1.text = rowTxtArr[indexPath.row]
                docdata = self.docArr[indexPath.section] as! PermissionData
            } else {
                docdata = self.sharedDocArr[indexPath.section] as! PermissionData
            }
            
            let lbl2 = cell?.viewWithTag(2) as! UILabel
            var lbltxt: String = ""
            
            if indexPath.row == 0 {
                    lbltxt = "\(docdata.RequesterName!) | \(docdata.RequesterEmail!) "
            }
            if indexPath.row == 1 {
                lbltxt = docdata.RequesterEmail!
            }
            if indexPath.row == 2 {
                if docdata.Status! < statusArr.count {
                    lbltxt = statusArr[docdata.Status!-1]
                }
            }
            lbl2.text = lbltxt
            
            return cell!
        }
        else {
            if shareType == 1 {
                
                let docdata = self.docArr[indexPath.section] as! PermissionData
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "scanBtnCell") as! PermissionCell
                
                //if let btn1 = cell?.viewWithTag(1) as? UIButton {
                let btn1 = cell.btnOpen
                        
                    btn1?.tag = indexPath.section
                    btn1?.accessibilityHint = "open"
                btn1?.addTarget(self, action: #selector(changePermission), for: UIControl.Event.touchUpInside)
                    //btn1.setImage(UIImage(named: "icview"), for: UIControlState.normal)
                    
                //}
                //if let btn2 = cell?.viewWithTag(2) as? UIButton {
                
                let btn2 = cell.btnAccept
                
                btn2?.tag = indexPath.section
                btn2?.addTarget(self, action: #selector(changePermission), for: UIControl.Event.touchUpInside)
                    btn2?.accessibilityHint = "Accepted"
                    
                    if statusArr[docdata.Status!-1] == "Pending" {
                        //btn2.setImage(UIImage(named: "ictick"), for: UIControlState.normal)
                        btn2?.isSelected = false
                    }
                    else if statusArr[docdata.Status!-1] == "Accepted" {
                        //btn2.setImage(UIImage(named: "ictick_gray"), for: UIControlState.normal)
                        btn2?.isSelected = true
                        
                    } else {
                        //btn2.setImage(UIImage(named: "ictick"), for: UIControlState.normal)
                        btn2?.isSelected = false
                    }
                    
                //}
                //if let btn3 = cell?.viewWithTag(3) as? UIButton {
                
                let btn3 = cell.btnReject
                
                    btn3?.tag = indexPath.section
                    
                    btn3?.accessibilityHint = "Rejected"
                    
                btn3?.addTarget(self, action: #selector(changePermission), for: UIControl.Event.touchUpInside)
                    if statusArr[docdata.Status!-1] == "Pending" {
                        //btn3.setImage(UIImage(named: "icreject"), for: UIControlState.normal)
                        btn3?.isSelected = false
                    }
                    else if statusArr[docdata.Status!-1] == "Rejected" {
                        //btn3.setImage(UIImage(named: "icreject_gray"), for: UIControlState.normal)
                        btn3?.isSelected = true
                        
                    } else {
                        //btn3.setImage(UIImage(named: "icreject"), for: UIControlState.normal)
                        btn3?.isSelected = false
                    }
                //}
                return cell
            }
            if shareType == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "docBtnCell") as! PermissionCell
                
                //if let btn1 = cell?.viewWithTag(1) as? UIButton {
                let btn1 = cell.btnOpen
                
                    btn1?.tag = indexPath.section
                    btn1?.accessibilityHint = "open"
                btn1?.addTarget(self, action: #selector(changePermission), for: UIControl.Event.touchUpInside)
                    //btn1.setImage(UIImage(named: "icview"), for: UIControlState.normal)
                    
                //}
                //if let btn2 = cell?.viewWithTag(2) as? UIButton {
                
                let btn2 = cell.btnReject
                
                btn2?.tag = indexPath.section
                btn2?.addTarget(self, action: #selector(changePermission), for: UIControl.Event.touchUpInside)
                    btn2?.accessibilityHint = "Removed"
                    //btn2.setImage(UIImage(named: "icremove"), for: UIControlState.normal)
                //}
                
                return cell
            }
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        let title = cell?.viewWithTag(1) as! UILabel
        let btn = cell?.viewWithTag(2) as! UIButton
        btn.tag = section
        
        var docdata:PermissionData! //= self.docArr[section] as! PermissionData
        
        if shareType == 0 {
            docdata = self.sharedDocArr[section] as! PermissionData
        } else {
            docdata = self.docArr[section] as! PermissionData
        }
        title.text = "DOCUMENT: " + docdata.DocumentName!
        
        btn.addTarget(self, action: #selector(expandAction), for: UIControl.Event.touchUpInside)
        
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.gray.cgColor
        
        return cell?.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if openFlag  {
            if indexPath.row == 1 {
                return 0
            }
            return UITableView.automaticDimension//40
        } else if shareType == 0 {
            if selIdArr.contains(indexPath.section) {
                if indexPath.row == 1 {
                    return 0
                    //return UITableViewAutomaticDimension
                }
                return UITableView.automaticDimension//40
                //return 0
            }
        } else if shareType == 1 {
            if selIdArr1.contains(indexPath.section) {
                if indexPath.row == 1 {
                    return 0
                    //return UITableViewAutomaticDimension
                }
                return UITableView.automaticDimension//40
                //return 0
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getPermissions() {
        //TokenPermission/StartScreen
        
        /*
         {"StatusCode":1000,"Message":"Success. ","Data":[{"Id":919,"WorkflowId":15843,"InstanceId":11220,"PermissionGrantedProfileId":11428,"PermissionReceivedProfileId":11429,"ObjectId":"workspace://SpacesStore/d7c46bb5-095c-410f-bf4a-225d25a98663;1.0","TokenId":5925,"Status":5,"DocumentShareType":2,"ModifiedDate":"2018-12-27T13:08:15","PermissionExpiryDate":"0001-01-01T00:00:00","PendingRequestCount":1,"Identifier":"18b7d1ac934147ad8a487ec8e9bfe341","DocumentName":"Manage Permission Scanned Token","RequesterName":"Anil Saindane","RequesterEmail":"anil.hoh@gmail.com","GzippedTokenId":"H4sIAAAAAAAEAKvINqosDa0Kdimv8jD286+IqEoycC9XNXYBIgAx7ubIHAAAAA==","ThumbnailURL":"P7N4KZ1fvk6QyPPqjpi4xg.png"},{"Id":920,"WorkflowId":15843,"InstanceId":11220,"PermissionGrantedProfileId":11428,"PermissionReceivedProfileId":11427,"ObjectId":"workspace://SpacesStore/d7c46bb5-095c-410f-bf4a-225d25a98663;1.0","TokenId":5925,"Status":5,"DocumentShareType":2,"ModifiedDate":"2018-12-27T13:08:15","PermissionExpiryDate":"0001-01-01T00:00:00","PendingRequestCount":1,"Identifier":"ca890923b85f423581da5e2c7270efb5","DocumentName":"Manage Permission Scanned Token","RequesterName":"Tushar Pabale","RequesterEmail":"tushar.hoh@gmail.com","GzippedTokenId":"H4sIAAAAAAAEAKvINqosDa0Kdimv8jD286+IqEoycC9XNXYBIgAx7ubIHAAAAA==","ThumbnailURL":"DefaultProfileSmall.jpg"}]}
         */
        
        docArr = NSMutableArray.init()
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        //let api = "api/v1/tokenReader/DisplayTokenManagingDocumentList" // old API
        let api = "api/v1/tokenReader/TokenManagingDocumentList?identifier=&documentShareType=1" // new API
        
        let apiURL = Singletone.shareInstance.apiDoc + api
        
        let parameters: NSDictionary = NSDictionary.init()  //as [String:Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            do {
            let parameters = [:] as [String : Any]
            
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"//"POST"
            request.allHTTPHeaderFields = headerAPIDashboard
            //request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                    let jsonObj: JSON = JSON(data)
                        if let data = jsonObj["Data"].array {
                            
                            var cnt = 0
                            for dic in data {
                                
                                let dict = dic.dictionaryObject
                                print("dict: \(dict)")
                                let docdata = PermissionData(dictionary: dict!)
                                self.docArr.add(docdata)
                                print("docdata: \(docdata.DocumentName)")
                                
                                //self.selIdArr1.append(cnt)
                                cnt = cnt + 1
                            }
                        }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        let arr = self.docArr.sorted(by: { ($0 as! PermissionData).permDate! > ($1 as! PermissionData).permDate! })
                        self.docArr = NSMutableArray.init(array: arr)
                        self.tblDoc.reloadData()
                    }
                }
            })
            
            dataTask.resume()
            } catch{}
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getSharedDocs() {
        
        /*
         {"StatusCode":1000,"Message":"Success. ","Data":[{"Id":919,"WorkflowId":15843,"InstanceId":11220,"PermissionGrantedProfileId":11428,"PermissionReceivedProfileId":11429,"ObjectId":"workspace://SpacesStore/d7c46bb5-095c-410f-bf4a-225d25a98663;1.0","TokenId":5925,"Status":5,"DocumentShareType":2,"ModifiedDate":"2018-12-27T13:08:15","PermissionExpiryDate":"0001-01-01T00:00:00","PendingRequestCount":1,"Identifier":"18b7d1ac934147ad8a487ec8e9bfe341","DocumentName":"Manage Permission Scanned Token","RequesterName":"Anil Saindane","RequesterEmail":"anil.hoh@gmail.com","GzippedTokenId":"H4sIAAAAAAAEAKvINqosDa0Kdimv8jD286+IqEoycC9XNXYBIgAx7ubIHAAAAA==","ThumbnailURL":"P7N4KZ1fvk6QyPPqjpi4xg.png"},{"Id":920,"WorkflowId":15843,"InstanceId":11220,"PermissionGrantedProfileId":11428,"PermissionReceivedProfileId":11427,"ObjectId":"workspace://SpacesStore/d7c46bb5-095c-410f-bf4a-225d25a98663;1.0","TokenId":5925,"Status":5,"DocumentShareType":2,"ModifiedDate":"2018-12-27T13:08:15","PermissionExpiryDate":"0001-01-01T00:00:00","PendingRequestCount":1,"Identifier":"ca890923b85f423581da5e2c7270efb5","DocumentName":"Manage Permission Scanned Token","RequesterName":"Tushar Pabale","RequesterEmail":"tushar.hoh@gmail.com","GzippedTokenId":"H4sIAAAAAAAEAKvINqosDa0Kdimv8jD286+IqEoycC9XNXYBIgAx7ubIHAAAAA==","ThumbnailURL":"DefaultProfileSmall.jpg"}]}
         */
        
        sharedDocArr = NSMutableArray.init()
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        //let api = "api/v1/tokenReader/DisplayTokenManagingDocumentList" // old API
        let api = "api/v1/tokenReader/TokenManagingDocumentList?identifier=&documentShareType=2" // new API
        
        let apiURL = Singletone.shareInstance.apiDoc + api
        
        let parameters: NSDictionary = NSDictionary.init()  //as [String:Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            do {
                let parameters = [:] as [String : Any]
                
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "GET"//"POST"
                request.allHTTPHeaderFields = headerAPIDashboard
                //request.httpBody = postData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    if (error != nil) {
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse)
                        
                        let jsonObj: JSON = JSON(data)
                            if let data = jsonObj["Data"].array {
                                
                                var cnt = 0
                                for dic in data {
                                    
                                    let dict = dic.dictionaryObject
                                    print("dict: \(dict)")
                                    let docdata = PermissionData(dictionary: dict!)
                                    self.sharedDocArr.add(docdata)
                                    print("docdata: \(docdata.DocumentName)")
                                    
                                    //self.selIdArr.append(cnt)
                                    cnt = cnt + 1
                                }
                            }
                        
                        
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                            let arr = self.sharedDocArr.sorted(by: { ($0 as! PermissionData).permDate! > ($1 as! PermissionData).permDate! })
                            self.sharedDocArr = NSMutableArray.init(array: arr)
                            self.tblDoc.reloadData()
                        }
                    }
                })
                
                dataTask.resume()
            } catch{}
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func setPermission(id: Int, status: Int) {
        
        /*
         {"DocumentName":"","Recepient":"anil.hoh@gmail.com","Identifier":"3ae833616ba8416a93ebff075cca7916","Language":"en-US","Status":"6","InstanceId":0,"WorkflowId":0}
         
         {"DocumentName":"9Feb1","Recepient":"radhikapmalik@gmail.com","Identifier":"a8aa29a46f274e8db9cbb383b4a9d9e3","Language":"en-US","Status":"2","InstanceId":12143,"WorkflowId":8859}
         
         ["Status": 2, "Identifier": "5aa8ae19c1a04cb3a3f00edd85635e7e", "Language": "en-US", "DocumentName": "Test Token", "InstanceId": 12132, "Recepient": "radhikapmalik@gmail.com", "WorkflowId": 8842]
        */
        self.showActivityIndicatory(uiView: self.view)
        
        //SetPermission
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "api/v1/tokenReader/SetPermission"
        
        let apiURL = Singletone.shareInstance.apiDoc + api
        
        let data:PermissionData! //= docArr[id] as! PermissionData
        
        if shareType == 0 {
            data = sharedDocArr[id] as! PermissionData
        } else {
            data = docArr[id] as! PermissionData
        }
        let name = data.DocumentName
        let identifier = data.Identifier
        let recepient = data.RequesterEmail
        let strStat: String = String(status)
        
        let parameters = ["DocumentName": name!,
            "Identifier": identifier!,
            "Language": "en-US",
            "Recepient": recepient!,
            "Status": strStat,
            "InstanceId": data.InstanceId!,
            "WorkflowId": data.WorkflowId!] as [String:Any]
        
        print("parameters: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    
                    if let httpResponse = response as? HTTPURLResponse {
                        print(httpResponse)
                        
                        let jsonObj: JSON = JSON(data)
                            print("jsonObj: \(jsonObj)")
                        
                    }
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.getPermissions()
                        self.getSharedDocs()
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
        
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        
        
        openFlag = false
        
        let tag = sender.tag
        
        sender.isSelected = !sender.isSelected
        
        if shareType == 0 {
            if selIdArr.contains(tag) {
                let index = selIdArr.index(of: tag)
                selIdArr.remove(at: index!)
            } else {
                selIdArr.append(tag)
            }
        }
        if shareType == 1 {
            if selIdArr1.contains(tag) {
                let index = selIdArr1.index(of: tag)
                selIdArr1.remove(at: index!)
            } else {
                selIdArr1.append(tag)
            }
        }
        
        tblDoc.beginUpdates()
        tblDoc.endUpdates()
    }
    
    @IBAction func changePermission(_ sender: UIButton) {
        let tag = sender.tag
        sender.isSelected = !sender.isSelected
        
        if sender.accessibilityHint != "open" {
            let status = statusArr.index(of: sender.accessibilityHint!)
            setPermission(id: tag, status: status!+1)
        } else {
            //callDocTrailAPI(tag: tag)
            let data:PermissionData! //= sharedDocArr[tag] as! PermissionData
            if shareType == 0 {
                data = sharedDocArr[tag] as! PermissionData
            } else {
                data = docArr[tag] as! PermissionData
            }
            showDoc(instId: String(data.InstanceId!), tag: tag)
        }
    }

    func showDoc(instId: String, tag: Int) {
        
        print("showDoc: tag: \(tag), \(instId)")
        if #available(iOS 11.0, *) {
        let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
        
            let data:PermissionData! //= sharedDocArr[tag] as! PermissionData
            if shareType == 0 {
                data = sharedDocArr[tag] as! PermissionData
            } else {
                data = docArr[tag] as! PermissionData
            }
        let instanceId = data.TokenId
        let id: String = "\(instanceId)"
        docSignVC.instanceID = instId
        docSignVC.docCat = 92
        docSignVC.docName = data.DocumentName!
        docSignVC.permissionFlag = true
        self.navigationController?.pushViewController(docSignVC, animated: true)
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    func callDocTrailAPI(tag: Int) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        let qrdata = UserDefaults.standard.value(forKey: "qrcode") as? String
        
        let data:PermissionData!// = docArr[tag] as! PermissionData
        
        if shareType == 0 {
            data = sharedDocArr[tag] as! PermissionData
        } else {
            data = docArr[tag] as! PermissionData
        }
        //let arr = qrdata?.components(separatedBy: ",")
        let qrcode: String = data.GzippedTokenId! //arr![0]
        //"H4sIAAAAAAAEAAs1cjcOSI0yyyh1y0y3LFM1cjNWNXJKjUxLVzV2ASIAg3UoZyAAAAA="//arr![0]
        let parameters = ["QRCodeData":qrcode, "Request":1, "Mode": 2] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            Alamofire.request(URL(string: Singletone.shareInstance.apiDoc + "api/v1/tokenReader/GetDocumentTrail")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000
                        {
                            if let jsonData = jsonDic["Data"] as? NSArray {
                                print(jsonData)
                                
                                for dic in jsonData {
                                    let doctrail = DocumentTrailData(dictionary: dic as! [AnyHashable : Any])
                                    //self.docTrailData.append(doctrail)
                                    if doctrail.InstanceId! > 0 {
                                        let instId: String = "\(doctrail.InstanceId!)"
                                        let instanceID: String = instId
                                        self.showDoc(instId: instanceID, tag: tag)
                                        
                                    }
                                }
                                
                            }
                        }
                        else
                        {
                            
                            //self.alertSample(strTitle: "", strMsg: jsonDic["Message"] as! String)
                            self.alertSample(strTitle: "", strMsg: "Error occured in getting history details")
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
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        
        shareType = sender.selectedSegmentIndex
        tblDoc.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "segDashboard", sender: self)
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
