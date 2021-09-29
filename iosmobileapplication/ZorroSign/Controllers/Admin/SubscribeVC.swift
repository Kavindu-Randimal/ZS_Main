//
//  SubscribeVC.swift
//  ZorroSign
//
//  Created by Apple on 12/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LicenseCell: UITableViewCell {
    
    @IBOutlet weak var txtPlan: UITextField!
    //@IBOutlet weak var btnCancel: UIButton!
}

protocol SubscribeVCDelegate {
    func callUserApi()
}

class SubscribeVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var orgUserArr:[AccountData] = []
    var userArr:[AccountData] = []
    var profArr:[ProfileData] = []
    var thumbArr:[String] = []
    var filtertedArray: [AccountData] = []
    var filteredProfArr: [ProfileData] = []
    var planArr: [SubscriptionData] = []
    var assignPlanArr: NSMutableArray = NSMutableArray.init()
    
    //@IBOutlet weak
    var pickerView: UIPickerView!
    @IBOutlet weak var tblUser: UITableView!
    
    
    var planAlert: SwiftAlertView!
    
    var selPlan: String = "Select a plan"
    var selPlanId: Int?
    var selPlanDic: [Int:Int] = [:]
    var selRow: Int = 0
    
    var subscriptionVCDelegate: SubscribeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //pickerView.addDoneOnKeyboardWithTarget(self, action: nil)
        //pickerView.isHidden = false
        
//        let usrArr = orgUserArr.filter{ ($0.IsSubscribed == false) }
//        userArr = usrArr
//        filtertedArray = usrArr
        
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        pickerView.backgroundColor = UIColor.white
        planAPI()
    }

    
    func planAPI() {
        
        //https://zsdemowebsubscription.zorrosign.com/api/v2/subscription/GetActiveUserLicenses
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v3/subscription/GetActiveUserLicenses"
        //GetSubscriptionData
        let apiURL = Singletone.shareInstance.apiSubscription + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value)
                    
                    if !jsonObj["Data"].isEmpty  {
                        print("response: \(jsonObj)")
                        let usrArr = self.orgUserArr.filter{ ($0.IsSubscribed == false && $0.IsLocked == false) }
                        self.userArr = usrArr
                        self.filtertedArray = usrArr
                        
                        let data = jsonObj["Data"].array
                        
                        self.planArr = []
                        let plan = SubscriptionData()
                        plan.UserSubscriptionId = 0
                        plan.plandetailStr = "Select a Plan"
                        self.planArr.append(plan)
                        
                        for dic in data! {
                            
                            let dict = dic.dictionaryObject
                            let plandata = SubscriptionData(dictionary: dict!)
                            self.planArr.append(plandata)
                            
                        }
                    } else {
                        let msg = jsonObj["Message"].stringValue
                        self.alertSampleError(strTitle: "", strMsg: msg)
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                        self.pickerView.dataSource = self
                        self.pickerView.delegate = self
                        self.pickerView.reloadAllComponents()
                        self.tblUser.reloadData()
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filtertedArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "licenceCell") as! LicenseCell
        
        let accdata = filtertedArray[indexPath.row]
        let title = cell.viewWithTag(2) as! UILabel
        title.text = accdata.Email
        
        var  selPlanStr = "Select a Plan"
        if let plan = selPlanDic[indexPath.row] as? Int {
            let data = planArr[plan]
        
            selPlanStr = data.plandetailStr!
        }
        if let btnplan = cell.txtPlan {
            pickerView.tag = indexPath.row
            
            btnplan.tag = indexPath.row
            btnplan.delegate = self
            btnplan.inputView = pickerView
            btnplan.inputAccessoryView = addDoneButton()
            btnplan.text = selPlanStr
            //btnplan.setTitle(selPlanStr, for: UIControlState.normal)
            //btnplan.addTarget(self, action: #selector(planAction), for: UIControlEvents.touchUpInside)
        }
        
        let thumbnail = accdata.Thumbnail
        
        let strImgArr = thumbnail.split(separator: ",")
        if strImgArr.count > 1 {
            let strImage = String(strImgArr[1])
            
            let dataDecoded : Data = Data(base64Encoded: String(strImgArr[1]), options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            
            let profIcon = cell.viewWithTag(1) as! UIImageView
            
            profIcon.image = decodedimage
        } else {
            let profIcon = cell.viewWithTag(1) as! UIImageView
            
            profIcon.image = UIImage(named:"sign_up_btn")
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")
        
        let txtfld = cell?.viewWithTag(1) as! UITextField
        txtfld.delegate = self
        cell?.contentView.backgroundColor = .white
        
        return cell?.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "btnCell")
        
        let btnAssign = cell?.viewWithTag(4) as! UIButton
        btnAssign.addTarget(self, action: #selector(assignAction), for: UIControl.Event.touchUpInside)
        
        let btnCancel = cell?.viewWithTag(2) as! UIButton
        btnCancel.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
        cell?.contentView.backgroundColor = .white
        
        return cell?.contentView
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50//UITableViewAutomaticDimension//40
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 50
    }
    
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return planArr.count
    }
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let data = planArr[row]
        print("plan: \(data.plandetailStr)")
        return data.plandetailStr
    }*/
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let cell = tblUser.dequeueReusableCell(withIdentifier: "planCell")!
        
        let data = planArr[row]
        
        let titlelbl = cell.viewWithTag(1) as! UILabel
        titlelbl.text = data.plandetailStr
        
        let cntlbl = cell.viewWithTag(2) as! UILabel
        cntlbl.text = ""
        
        if let cnt: Int = data.UserLicenseCount {
            cntlbl.text = "\(cnt)"
            cntlbl.layer.borderColor = UIColor.green.cgColor
            cntlbl.layer.borderWidth = 1.0
        } else {
            cntlbl.layer.borderColor = UIColor.clear.cgColor
            cntlbl.layer.borderWidth = 0.0
        }
        
        cell.contentView.backgroundColor = UIColor.white
        return cell.contentView
        
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        let tag = selRow //pickerView.tag
        let data = planArr[row]
        selPlanId = data.UserSubscriptionId
        
        selPlan = data.plandetailStr!
        selPlanDic[tag] = row
        
        print("selPlanDic: \(selPlanDic)")
        //tblUser.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField.tag == 1 {
            
            var srchstr: String = ""
            if range.length == 0 {
                srchstr = "\((textField.text!))" + "\(string)"
                
            } else if range.location > 0 {
                srchstr = (textField.text?.substring(to: range.location-1))!
            }
            
            if !srchstr.isEmpty {
                filtertedArray = userArr.filter{ ($0.Email?.contains(srchstr))! }
                //filteredProfArr = profArr.filter{ ($0.Email.contains(srchstr)) }
            } else {
                filtertedArray = userArr
                //filteredProfArr = profArr
            }
            //let tablevw = labelAlertView.viewWithTag(4) as! UITableView
            tblUser.reloadData()
            
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selRow = textField.tag
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    @IBAction func planAction(_ sender: UIButton) {
        /*
        if pickerView.isHidden {
            pickerView.isHidden = false
        } else {
            pickerView.isHidden = true
        }*/
        //initPlanAlert(tag: sender.tag)
    }
    
    func initPlanAlert(tag: Int) {
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 300, height: 150))
        
        planAlert = SwiftAlertView(contentView: pickerView, delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok")
        pickerView.tag = tag
        
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.reloadAllComponents()
        
        //planAlert.frame = pickerView.frame
        planAlert.show()
        
    }
    
    @IBAction func assignAction() {
        
        assignSubscriptionAPI()
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if buttonIndex == 1 {
            tblUser.reloadData()
        }
    }
    
    func assignSubscriptionAPI() {
        
      //https://zsdemowebsubscription.zorrosign.com/api/v2/Subscription/ActivateOrgUserSubscription
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v3/subscription/ActivateOrgUserSubscription"
        
        let apiURL = Singletone.shareInstance.apiSubscription + api
        
        //let parameters = ["ProfileId": "", "UserSubscriptionId": ""] as! [String:Any]
        
        var parameters: [[String:Any]] = []
        
        //for i in 0..<selPlanDic.count {
        for dic in selPlanDic {
            let key = dic.key
            let val = dic.value
            let subdata = planArr[val]
            let accdata = userArr[key]
            let index = orgUserArr.index(of: accdata)
            let profdata = profArr[index!]//profArr[selPlanDic[key]!]
            let userid: String = profdata.ProfileId
            let subid: Int = subdata.UserSubscriptionId!
            
            let dic = ["ProfileId":userid , "UserSubscriptionId": subid] as! [String:Any]
            parameters.append(dic)
        }
        print("parameters: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .put, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value as Any)
                    
                    if jsonObj["StatusCode"] == 1000 && jsonObj["Data"] == true {
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                            self.alertSubscribeVC(strTitle: "", strMsg: "User subscribed successfully")
                        }
                    }
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    //MARK: - Added an alert to dismiss the view after successful subscription assigning
    func alertSubscribeVC(strTitle: String, strMsg: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.subscriptionVCDelegate?.callUserApi()
            self.dismiss(animated: false, completion: nil)
        }))
        //alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
    }
    
    override func donePicker (sender: UIBarButtonItem) {
        
        tblUser.reloadData()
    }
    
    override func cancelPicker (sender: UIBarButtonItem) {
       self.view.endEditing(true)
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
