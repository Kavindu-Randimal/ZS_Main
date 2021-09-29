//
//  WorkflowVC.swift
//  ZorroSign
//
//  Created by Apple on 25/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher


class ColCell: UICollectionViewCell {
    
    @IBOutlet weak var leftVw_conW: NSLayoutConstraint!
    @IBOutlet weak var rghtVw_conW: NSLayoutConstraint!
    
    @IBOutlet weak var btmleftVw_conW: NSLayoutConstraint!
    @IBOutlet weak var btmrghtVw_conW: NSLayoutConstraint!
    
    @IBOutlet weak var midVw_conH: NSLayoutConstraint!
    
    @IBOutlet weak var leftLine_conW: NSLayoutConstraint!
    @IBOutlet weak var rgtLine_conW: NSLayoutConstraint!
    
    @IBOutlet weak var icon_conW: NSLayoutConstraint!
    @IBOutlet weak var icon_conH: NSLayoutConstraint!
    
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    
    
}

@available(iOS 11.0, *)
class WorkflowVC: BaseVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var lblDocName: UILabel!
    @IBOutlet weak var kbaTextView: UIView!
    
    var processData: ProcessData!
    var instanceID: String!
    var sectionCnt: Int = 0
    var rowCnt: Int = 0
    var arrData: NSMutableArray = NSMutableArray.init()
        //[[String:Any]] = []
    var arrId:NSMutableArray = NSMutableArray.init()
    let alphabets = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var arrTagcnt: [Int] = []
    
    var CCAlertView: SwiftAlertView!
    var arrSignCC: [Signatories] = []
    var selStepData: StepsData?
    var tagTypeArr: [Int:[String:[Int:[Int]]]] = [:]
    var selStep: Int = 0
    var scale: CGFloat = 1
    
    @IBOutlet weak var lineVw: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scale = 1
        // Do any additional setup after loading the view.
        
        kbaTextView.layer.shadowRadius = 1.5;
        kbaTextView.layer.shadowColor   = UIColor.lightGray.cgColor
        kbaTextView.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        kbaTextView.layer.shadowOpacity = 0.9;
        kbaTextView.layer.masksToBounds = false;
        kbaTextView.layer.cornerRadius = 8
        getProcessDetailsAPI()
    }

    func getProcessDetailsAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetProcessDetails?processId=\(instanceID!)")
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
                                self.processData = ProcessData(dictionary: jsonObj as! [AnyHashable : Any])
                                let doclist = self.processData.Documents![0]
                                
                                var stepcnt = 0
                                for step in self.processData.Steps! {
                                    let tagcnt = step.Tags?.count ?? 0
                                    var signCnt = 0
                                    if (step.CCList?.count)! > 0 {
                                        signCnt = 1
                                    }
                                    let totcnt = tagcnt + signCnt
                                    
                                    if totcnt > 0 {
                                        //self.arrTagcnt.append(totcnt)
                                    }
                                    var tagDic:NSMutableDictionary = NSMutableDictionary.init()
                                    var typeArr: [Int:[Int]] = [:]
                                    var stepDic: [String:[Int:[Int]]] = [:]
                                    for tagdata in step.Tags! {
                                        //var typeArr: [Int:[Int]] = [:]
                                        let signatories = tagdata.SignatoriesData
                                        
                                        if signatories != nil && !(signatories?.isEmpty)! {
                                            
                                            let signature = signatories![0] as! Signatories
                                            let id: String = signature.Id!
                                            signature.TagNo = tagdata.TagNo!
                                            signature.isCC = false
                                            signature.state = tagdata.State
                                            tagDic[id] = signature
                                            print("tagDic id: \(id)")
                                            
                                            if stepDic[id] == nil {
                                                typeArr.removeAll()
                                            }
                                            if let arr = typeArr[tagdata.type!] {
                                                typeArr[tagdata.type!]?.append(tagdata.type!)
                                            } else {
                                                var arr:[Int] = []
                                                arr.append(tagdata.type!)
                                                typeArr[tagdata.type!] = arr
                                            }
                                            //typeArr[tagdata.type!]?.append(tagdata.type!)
                                            stepDic[id] = typeArr
                                            
                                        }
                                        self.tagTypeArr[step.StepNo!] = stepDic
                                        print("tagTypeArr: \(self.tagTypeArr)")
                                    }
                                    if signCnt > 0 {
                                        var signArr: [String] = []
                                        let ccArr = step.CCList
                                        let cclist = ccArr![0]
                                        //for cclist in step.CCList! {
                                            let id: String = cclist.Id!
                                            cclist.TagNo = tagcnt + 1
                                            cclist.isCC = true
                                        
                                            tagDic[id] = cclist
                                            print("tagDic id: \(id)")
                                        //}
                                        
                                    }
                                    step.signNo = tagDic.count
                                    stepcnt = stepcnt + 1
                                    //self.arrData.add(tagDic)
                                    var arr: [Signatories] = tagDic.allValues as! [Signatories]
                                    arr.sort(by: { (obj1, obj2) -> Bool in
                                        obj1.TagNo < obj2.TagNo
                                    })
                                    
                                    self.arrData.add(arr)
                                    self.arrId.add(tagDic.allKeys)
                                    self.arrTagcnt.append(tagDic.count)
                                }
                                
                                
                                self.sectionCnt = self.arrTagcnt.max()!
                                self.rowCnt = (self.processData.Steps?.count)!
                                
                                self.lblDocName.text = self.processData.DocumentSetName
                                self.collView.reloadData()
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionCnt
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rowCnt
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColCell
       
        let stepdata = self.processData.Steps![indexPath.row]
        
        if indexPath.section == 0 {
            cell.leftVw_conW.constant = 0
            cell.rghtVw_conW.constant = 0
        } else {
            cell.leftVw_conW.constant = 1
            cell.rghtVw_conW.constant = 1
        }
        if indexPath.row == 0 && sectionCnt == 1 {
            lineVw.backgroundColor = UIColor.white
            cell.leftLine_conW.constant = 0
            cell.leftLine.backgroundColor = UIColor.white
        } else {
            //lineVw.backgroundColor = UIColor.black
            cell.leftLine_conW.constant = 1//cell.frame.size.width / 2
            cell.leftLine.backgroundColor = UIColor.black
        }
        if indexPath.row == rowCnt - 1 && sectionCnt == 1 {
            cell.rgtLine_conW.constant = 0
            cell.rightLine.backgroundColor = UIColor.white
        }
        else {
            cell.rgtLine_conW.constant = 1//cell.frame.size.width / 2
            cell.rightLine.backgroundColor = UIColor.black
        }
        
        cell.setNeedsDisplay()
        
        let sections = ((arrData[indexPath.row] as AnyObject).count) - 1
        
        if indexPath.section == sections {
            cell.btmleftVw_conW.constant = 0
            cell.btmrghtVw_conW.constant = 0
        } else {
            cell.btmleftVw_conW.constant = 1
            cell.btmrghtVw_conW.constant = 1
        }
        
        let profIcon = cell.viewWithTag(1) as! UIImageView
        let title = cell.viewWithTag(2) as! UILabel
        let txtdate = cell.viewWithTag(3) as! UILabel
        let txtnum = cell.viewWithTag(4) as! UILabel
        let stepView = cell.viewWithTag(5)!
        let stepnumber = cell.viewWithTag(6) as! UILabel
        let kbaImage = cell.viewWithTag(7) as! UIImageView
        let processIcon = cell.viewWithTag(10) as! UIImageView
        
//        stepView.layer.masksToBounds = true
//        stepView.layer.cornerRadius = 8
//        stepView.layer.borderWidth = 1
//        stepView.layer.borderColor = UIColor.black.cgColor
        stepView.layer.masksToBounds = true
        stepView.layer.cornerRadius = 8
        
        if let _processingStep = processData.ProcessingStep {
            if processData.ProcessState == 0 || processData.ProcessState == 11 || processData.ProcessState == 12 {
                stepView.layer.backgroundColor = ColorTheme.imgTint.cgColor
                stepnumber.textColor = ColorTheme.lblBodySpecial
                processIcon.image = UIImage(named: "completed_white_icon")
            } else if processData.ProcessState == 1 || processData.ProcessState == 3 {
                if indexPath.row + 1 < _processingStep {
                    stepView.layer.backgroundColor = ColorTheme.imgTint.cgColor
                    stepnumber.textColor = ColorTheme.lblBodySpecial
                    processIcon.image = UIImage(named: "completed_white_icon")
                } else if indexPath.row + 1 == _processingStep {
                    stepView.layer.borderWidth = 1
                    stepView.layer.borderColor = UIColor.black.cgColor
                    stepnumber.textColor = ColorTheme.lblBodyDefault
                    processIcon.image = UIImage(named: "inprocess_white_icon")
                    processIcon.tintColor = ColorTheme.BtnTintDisabled
                } else {
                    stepView.layer.borderWidth = 1
                    stepView.layer.borderColor = UIColor.black.cgColor
                    stepnumber.textColor = ColorTheme.lblBodyDefault
                }
            } else if processData.ProcessState == 2 || processData.ProcessState == 7 || processData.ProcessState == 10 {
                if indexPath.row + 1 < _processingStep {
                    stepView.layer.backgroundColor = ColorTheme.imgTint.cgColor
                    stepnumber.textColor = ColorTheme.lblBodySpecial
                    processIcon.image = UIImage(named: "completed_white_icon")
                } else if indexPath.row + 1 == _processingStep {
                    stepView.layer.borderWidth = 1
                    stepView.layer.borderColor = UIColor.black.cgColor
                    stepnumber.textColor = ColorTheme.lblBodyDefault
                    processIcon.image = UIImage(named: "rejected_white_icon")
                    processIcon.tintColor = ColorTheme.BtnTintDisabled
                } else {
                    stepView.layer.borderWidth = 1
                    stepView.layer.borderColor = UIColor.black.cgColor
                    stepnumber.textColor = ColorTheme.lblBodyDefault
                }
            }
        }
        
        txtnum.isHidden = true
        kbaImage.isHidden = true
        
        txtnum.text = ""
        
        //let stepdata = self.processData.Steps![indexPath.row]
        
        if indexPath.section < (arrData[indexPath.row] as AnyObject).count {
            
            cell.midVw_conH.constant = 1
            
            let dic = arrData[indexPath.row] as? NSArray//NSMutableDictionary
            //let keysArr = arrId[indexPath.row] as! [String]
            let signature = dic![indexPath.section] as? Signatories//dic![keysArr[indexPath.section]] as? Signatories
            
            if signature != nil {
                
                let img: String = signature!.ProfileImage!
                let strurl: String = "https://s3.amazonaws.com/zfpi/\(img)"
                let imgurl = URL(string: strurl)
                profIcon.kf.setImage(with: imgurl)
                
                profIcon.layer.borderWidth = 2.0
                //profIcon.layer.borderColor = UIColor.lightGray.cgColor
                
                if signature?.state == 0 {
                    profIcon.layer.borderColor = Singletone.shareInstance.footerviewBackgroundGreen.cgColor
                } else if signature?.state == 1 {
                    profIcon.layer.borderColor = UIColor.darkGray.cgColor
                } else {
                    profIcon.layer.borderColor = UIColor.lightGray.cgColor
                }
                    
                cell.icon_conW.constant = 50 * scale
                cell.icon_conH.constant = 50 * scale
                
                if (stepdata.Tags?.count)! > 0 {
                    if indexPath.section < (stepdata.Tags?.count)! {
                        let signdata = stepdata.Tags![indexPath.section].SignatoriesData
                        if (signdata?.count)! > 1 {
                            let cnt: Int = (signdata?.count)!
                            title.text = "Multiple - \(cnt)"
                            profIcon.image = UIImage(named: "alerts_user")
                        } else {
                            title.text = signature?.FriendlyName
                        }
                    } else {
                        title.text = signature?.FriendlyName
                    }
                }
                else if (signature?.isCC)! {
                    
                    profIcon.layer.borderColor = UIColor.lightGray.cgColor
                    
                    let ccdata = stepdata.CCList
                    let cnt: Int = (ccdata!.count)
                    if cnt > 1 {
                        title.text = "Multiple - \(cnt)"
                        profIcon.image = UIImage(named: "alerts_user")
                    } else {
                        title.text = signature?.FriendlyName//"Multiple - \(cnt)"
                    }
                }
                else {
                    title.text = signature?.FriendlyName
                }
                
            } else {
                
                if indexPath.section < (stepdata.Tags?.count)! {
                    let tagdata = stepdata.Tags![indexPath.section]
                    if tagdata.type == 6 {
                        profIcon.image = UIImage(named: "read_token")
                    } else {
                        profIcon.image = nil
                    }
                    let signatories = tagdata.SignatoriesData
                    
                    if signatories != nil && !(signatories?.isEmpty)! {
                        if (signatories?.count)! > 1 {
                            title.text = "Multiple - \(signatories?.count)"
                            profIcon.image = UIImage(named: "alerts_user")
                        } else {
                            let signature = signatories![0]
                            title.text = signature.FriendlyName
                        }
                    }
                    else {
                        
                        title.text = ""
                    }
                    
                } else {
                    profIcon.image = nil
                    title.text = ""
                    cell.leftLine_conW.constant = 0
                    cell.rgtLine_conW.constant = 0
                }
            }
            
            if indexPath.section < (stepdata.Tags?.count)! {
                let tagdata = stepdata.Tags![indexPath.section]
                txtdate.text = tagdata.DueDate?.formatDateWith(format: "MMM dd, YYYY")
            } else {
                txtdate.text = ""
            }
            
            if let iskba = stepdata.IsKBA {
                if iskba {
                    kbaImage.isHidden = false
                    kbaTextView.isHidden = false
                }
            }
            
            //if arrTagcnt[indexPath.row] > 1 {
            if stepdata.signNo > 1 {
                /*
                if arrTagcnt[indexPath.row] == 2 {
                    if (stepdata.CCList?.count)! > 0 {
                        txtnum.text = "\(indexPath.row+1)"
                    } else {
                        txtnum.text = "\(indexPath.row+1)\(alphabets[indexPath.section])"
                    }
                } else {
                    txtnum.text = "\(indexPath.row+1)\(alphabets[indexPath.section])"
                }*/
                txtnum.text = "\(indexPath.row+1)\(alphabets[indexPath.section])"
                stepnumber.text = "\(indexPath.row+1)\(alphabets[indexPath.section])"
                
            } else {
                txtnum.text = "\(indexPath.row+1)"
                stepnumber.text = "\(indexPath.row+1)"
            }
            txtnum.layer.borderColor = UIColor.black.cgColor
            txtnum.layer.borderWidth = 1.0
            txtnum.layer.cornerRadius = 10.0
            
        }else {
            profIcon.image = nil
            title.text = ""
            
            cell.midVw_conH.constant = 0
            
            if indexPath.section < (stepdata.Tags?.count)! {
                let tagdata = stepdata.Tags![indexPath.section]
                if tagdata.type == 6 {
                    cell.midVw_conH.constant = 1
                    profIcon.image = UIImage(named: "read_token")
                    txtnum.text = "\(indexPath.row+1)"
                    stepnumber.text = "\(indexPath.row+1)"
                    txtnum.layer.borderColor = UIColor.black.cgColor
                    txtnum.layer.borderWidth = 1.0
                    txtnum.layer.cornerRadius = 10.0
                } else {
                    profIcon.image = nil
                }
                
                
            } else {
                profIcon.image = nil
                title.text = ""
                cell.leftLine_conW.constant = 0
                cell.rgtLine_conW.constant = 0
            }
 
            cell.leftVw_conW.constant = 0
            cell.rghtVw_conW.constant = 0
            cell.btmleftVw_conW.constant = 0
            cell.btmrghtVw_conW.constant = 0
            
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = ((collectionView.bounds.size.width)  / CGFloat(rowCnt))
        print("itemWidth: \(itemWidth)")
        return CGSize(width: itemWidth * scale, height: (itemWidth+50) * scale )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let stepdata = self.processData.Steps![indexPath.row]
        selStepData = stepdata
        
        if let tags = stepdata.Tags, !tags.isEmpty {
            if indexPath.section < tags.count {
                let tagdata = tags[indexPath.section] as TagsData
                let signdata = tagdata.SignatoriesData
                arrSignCC = signdata!
            }
            
        } else if let ccdata = stepdata.CCList {
            if ccdata.count > 0 {
                arrSignCC = ccdata
            }
        }
        if arrSignCC.count > 0 {
            selStep = stepdata.StepNo!
            showCCData(step: stepdata)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrSignCC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "header")
        
        if cell == nil {
            let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
            cell = (arr?[2] as? UITableViewCell)! as? UITableViewCell
            
        }
        
        let btnarrow = cell?.viewWithTag(3) as! UIButton
        btnarrow.isHidden = true
        
        let signdata = arrSignCC[indexPath.row]
        
        let title = cell?.viewWithTag(2) as! UILabel
        if signdata.isCC {
            title.text = (signdata.FriendlyName ?? "") + "\n CC (1)"
        }
        else if let tagsType = tagTypeArr[selStep] {
            
            var strTags = ""
            if let tags = tagsType[signdata.Id!] {
                
                
                for typeDic in tags {
                    if let tag = Singletone.shareInstance.tagsNameByType[typeDic.key] {
                        let tagcnt = typeDic.value.count
                        strTags.append("\n")
                        strTags.append(tag+"(\(tagcnt))")
                    }
                    
                }
              
            }
            if (selStepData?.CCList?.count)! > 0 {
                let ccCnt: Int = (selStepData?.CCList?.count)!
                strTags.append("\n")
                strTags.append("Cc(\(ccCnt))")
            }
            title.text = (signdata.FriendlyName ?? "") + "\n" + strTags
        } else {
            title.text = signdata.FriendlyName ?? ""
        }
        
        let icon = cell?.viewWithTag(1) as! UIImageView
        //icon.image = UIImage(named: optionsIcon[section])
        let img: String = signdata.ProfileImage!
        let strurl: String = "https://s3.amazonaws.com/zfpi/\(img)"
        let imgurl = URL(string: strurl)
        icon.kf.setImage(with: imgurl)
        
        
        return cell!
            
        
    }
    
    func showCCData(step: StepsData) {
        
        initCCAlert()
    }
    
    func initCCAlert() {
        
        let dmsviewarr = Bundle.main.loadNibNamed("DMSOptions", owner: self, options: nil)
        let dmsview = dmsviewarr![1] as! UIView
        
        CCAlertView = SwiftAlertView(contentView: dmsview, delegate: self, cancelButtonTitle: "CLOSE")
            //SwiftAlertView(nibName: "DMSOptions", delegate: self, cancelButtonTitle: "Close", otherButtonTitles: nil)
        CCAlertView.tag = 14
        let tablevw = CCAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.reloadData()
        tablevw.isScrollEnabled = false
        
        let btnclose = CCAlertView.buttonAtIndex(index: 0)
        let btnadd = CCAlertView.buttonAtIndex(index: 1)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        CCAlertView.show()
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelAction() {
        self.dismiss(animated: false, completion: nil)
    }

    @IBAction func zoomIn() {
        if self.scale < 2 {
            self.scale = self.scale + 1
        }
        collView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func zoomOut() {
        if self.scale > 0 {
            self.scale = self.scale - 1
        }
        collView.collectionViewLayout.invalidateLayout()
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
