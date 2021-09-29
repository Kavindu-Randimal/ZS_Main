//
//  SaveTreeVC.swift
//  ZorroSign
//
//  Created by Apple on 28/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SaveTreeCell: UITableViewCell {
    
    @IBOutlet weak var txt1: UITextView!
    
    @IBOutlet weak var lblPageCnt: UILabel!
    
    
    
    func setBottomText() {
        let attributedString = NSMutableAttributedString(string: "Click on ")
        
        
        let attributedString1 = NSMutableAttributedString(string: "Environmental Savings Calculator")
        attributedString1.addAttribute(.link, value: "", range: NSRange(location: 0, length: 32))
        
        
        attributedString.append(attributedString1)
        
        let attributedString2 = NSMutableAttributedString(string: " to see your overall impact as of today")
        attributedString.append(attributedString2)
        
        txt1.attributedText = attributedString
        txt1.textAlignment = NSTextAlignment.center
        
        
    }
}

class SaveTreeVC: BaseVC, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tblTree: UITableView!
    var pageCnt: Int = 0
    
    let dataArr:[[String:Any]] = [["":""],["icon": ["tree_saved","save_wood"], "cnt":["0.01","0.01"],"txt1":["# of Trees Saved. Save 7913 Pages to Save Your Next Tree","Wood Saved (in lbs and kg)"],"txt2":["",""]],
                   ["icon": ["save_water","save_time"], "cnt":["0.01","0.01"],"txt1":["Water Saved (in Gallions)","Time Saved (in Hours))"],"txt2":["*Source: Atlantic Monthly","*Source: Harmon.ie"]],
                   ["icon": ["cost_saving","co_2"], "cnt":["0.01","0.01"],"txt1":["CC2 Emission Avoided (in # Tons)","Cost Savings (in $US)"],"txt2":["","*Source: IDC"]]]
    
    var envSavingArr: [[Double]] = []
    
    var WoodSavedkg: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        // Do any additional setup after loading the view.
        //getPageCount()
        
        if FeatureMatrix.shared.save_a_tree {
            getEnvironmentSaving()
        } else {
            AlertProvider.init(vc: self).showAlertWithAction(title: "", message: "Please upgrade your subscription to enable this feature ", action: AlertAction(title: "Dismiss")) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        if indexPath.row == 0 {
            let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! SaveTreeCell
            header.setBottomText()
            print(pageCnt)
            header.lblPageCnt.text = "Your current page count is \(pageCnt)"
            
            let cnt = getTreeImg()
            let treeName = "tree_\(cnt)"
            let img = UIImage(named: treeName)
            
            let imgvw = header.viewWithTag(4) as! UIImageView
            imgvw.image = img
            
            return header
            
        }
        else {
            let cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "treeCell")
            
            let data = dataArr[indexPath.row]
            let iconArr = data["icon"] as! [String]
            let lblArr1 = data["cnt"] as! [String]
            let lblArr2 = data["txt1"] as! [String]
            let lblArr3 = data["txt2"] as! [String]
            
            
            let icon1 = cell?.viewWithTag(1) as! UIImageView
            let lbl1 = cell?.viewWithTag(2) as! UILabel
            let lbl2 = cell?.viewWithTag(3) as! UILabel
            let lbl3 = cell?.viewWithTag(4) as! UILabel
            
            icon1.image = UIImage(named: iconArr[0])
            
            let arr = envSavingArr.count > indexPath.row-1 ? envSavingArr[indexPath.row-1] : [0,0]
            
            var txt1: String = lblArr2[0]
            if indexPath.row == 1 {
                let cnt = 8000 - pageCnt
                txt1 = "# of Trees Saved. Save \(cnt) Pages to Save Your Next Tree"
            }
            
            lbl1.text = String(arr[0]) //lblArr1[0]
            lbl2.text = txt1//lblArr2[0]
            lbl3.text = lblArr3[0]
            
            let icon2 = cell?.viewWithTag(5) as! UIImageView
            let lbl4 = cell?.viewWithTag(6) as! UILabel
            let lbl5 = cell?.viewWithTag(7) as! UILabel
            let lbl6 = cell?.viewWithTag(8) as! UILabel
            
            icon2.image = UIImage(named: iconArr[1])
            if indexPath.row == 1 {
                lbl4.text = String(arr[1]) + " & " + String(self.WoodSavedkg)
            } else {
                lbl4.text = String(arr[1]) //lblArr1[1]
            }
            lbl5.text = lblArr2[1]
            lbl6.text = lblArr3[1]
            
            return cell!
        }
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 321
        }
        return 154
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getTreeImg() -> Int {
        if pageCnt > 0 {
            if pageCnt > 0 && pageCnt < 1000 {
                return 1
            }
            if pageCnt >= 1000 && pageCnt < 2000 {
                return 2
            }
            if pageCnt >= 2000 && pageCnt < 3000 {
                return 3
            }
            if pageCnt >= 3000 && pageCnt < 4000 {
                return 4
            }
            if pageCnt >= 4000 && pageCnt < 5000 {
                return 5
            }
            if pageCnt >= 5000 && pageCnt < 6000 {
                return 6
            }
            if pageCnt >= 6000 && pageCnt < 7000 {
                return 7
            }
            if pageCnt >= 7000 && pageCnt < 8000 {
                return 8
            }
            if pageCnt >= 8000 {
                return 9
            }
        }
        return pageCnt
    }
    
    func getPageCount(){
    //https://zsdemowebworkflow.zorrosign.com/Help/Api/GET-api-v1-process-GetPageCount
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetPageCount")
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
                        
                            let statusCode = jsonDic["StatusCode"] as! Int
                            if statusCode == 1000 {
                                let msg = jsonDic["Message"] as! String
                                self.pageCnt = jsonDic["Data"] as! Int
                                
                                self.tblTree.reloadData()
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
    
    func getEnvironmentSaving() {
        
        /*
         {
         "StatusCode": 1000,
         "Message": "Success. ",
         "Data": {
         "PageCount": 39,
         "TreesSaved": 0,
         "WoodSavedlbs": 53.97,
         "WoodSavedkg": 24.48,
         "WaterSaved": 117,
         "TimeSaved": 7.8,
         "Co2Emission": 0.03,
         "CostSaving": 270.27
         }
         }
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetEnvironmentSaving")
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
                        
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            let msg = jsonDic["Message"] as! String
                            let dataDic = jsonDic["Data"] as! [String:Any]
                            
                            self.pageCnt = dataDic["PageCount"] as! Int
                            
                            var arr: [Double] = []
                            arr.append(dataDic["TreesSaved"] as! Double)
                            arr.append(dataDic["WoodSavedlbs"] as! Double)
                            self.WoodSavedkg = dataDic["WoodSavedkg"] as! Double
                            //self.envSavingArr.append(dataDic["PageCount"] as! Double)
                            self.envSavingArr.append(arr)
                            
                            arr = []
                            arr.append(dataDic["WaterSaved"] as! Double)
                            arr.append(dataDic["TimeSaved"] as! Double)
                            
                            self.envSavingArr.append(arr)
                            
                            arr = []
                            arr.append(dataDic["Co2Emission"] as! Double)
                            arr.append(dataDic["CostSaving"] as! Double)
                            
                            self.envSavingArr.append(arr)
                            
                            self.tblTree.reloadData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
