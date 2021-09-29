//
//  AddFolderVC.swift
//  ZorroSign
//
//  Created by Apple on 20/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class AddFolderVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtParent: UITextField!
    @IBOutlet weak var colorCollvw: UICollectionView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var labelTblView: UITableView!
    
    @IBOutlet weak var con_collHgt: NSLayoutConstraint!
    
    var parentId: Int = 0
    var selColorId: Int = -1
    var selLabel: LabelData?
    
    var colorArr = ["70292C","7A5549","F9403D","FF5431","F97A2C","FFBF43","4C1A86","1A2679","2F55F4","0298EC","00BDD1","00E6FC","80742B","009689","00C764","57DC4B","C2FE54","CCDB5A","F2999B","FBBBCF","B49ED6","AEEBF1","FFCB8A","DBE685"]
    
    var labelArr: [LabelData] = []
    var labelAlertView: SwiftAlertView!
    var filterArr: NSMutableArray = NSMutableArray.init()
    
    @IBOutlet weak var pickerContView: UIView!
    var pickerview: UIPickerView!
    
    @IBOutlet weak var con_tblHgt: NSLayoutConstraint!
    var parentFlag: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        //self.view.addGestureRecognizer(tapGesture)
        //labelTblView.canCancelContentTouches = false
        
        colorCollvw.layer.borderColor = UIColor.clear.cgColor
        colorCollvw.layer.borderWidth = 0.0
        btnCancel.layer.borderWidth = 1.0
        btnCancel.layer.borderColor = UIColor(named: "BtnBorder")?.cgColor
        
        colorCollvw.dataSource = self
        colorCollvw.delegate = self
        // Do any additional setup after loading the view.
        
        pickerview = UIPickerView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        pickerview.dataSource = self
        pickerview.delegate = self
        
        //pickerContView.addSubview(pickerview)
        print("parentId: \(parentId)")
        con_tblHgt.constant = 0
        
        if selLabel != nil {
            let arrname = selLabel?.Name?.components(separatedBy: "#")
            let name = arrname![0]
            txtParent.isEnabled = false
            txtParent.text = name
            con_tblHgt.constant = 0
        }
        else if parentId == 0 {
            txtParent.isEnabled = true
            txtParent.delegate = self
            txtParent.text = "My Documents"
            //txtParent.inputView = pickerview
            //labelTblView.dataSource = self
            //labelTblView.delegate = self
            labelTblView.layer.borderColor = UIColor.gray.cgColor
            labelTblView.layer.borderWidth = 1.0
            initLabelAlert()
        }
    }
    
    func isValidFolderName(pid: Int) -> Bool {
        
        let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d and SELF.Name contains [c] %@", pid, txtName.text!)
        
        let arr = self.filterArr.filter{ predicate.evaluate(with: $0) }
        
        if arr.count > 0 {
            return false
        } else {
            return true
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath)
        
        let clrVw = cell.viewWithTag(2) as! UIView
        clrVw.backgroundColor = UIColor(hex: colorArr[indexPath.row])
        
        let btn = cell.viewWithTag(4) as! UIButton
        let hint: Int = indexPath.row
        btn.accessibilityHint = "\(hint)"
        
        btn.addTarget(self, action: #selector(colorSelected), for: UIControl.Event.touchUpInside)
        
        if selColorId == indexPath.row {
            btn.layer.borderWidth = 5
            btn.layer.borderColor = UIColor.black.cgColor
        } else {
            btn.layer.borderWidth = 0
            btn.layer.borderColor = UIColor.clear.cgColor
        }
        
        cell.contentView.layer.masksToBounds = false
        cell.contentView.layer.shadowColor = UIColor.black.cgColor
        cell.contentView.layer.shadowOpacity = 0.5
        cell.contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.contentView.layer.shadowRadius = 1
        
        //cell.contentView.layer.shadowPath = UIBezierPath(rect: self.v.bounds).cgPath
        cell.contentView.layer.shouldRasterize = true
        
        cell.contentView.layer.rasterizationScale = UIScreen.main.scale
        cell.layer.borderColor = UIColor.clear.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selColorId = indexPath.row
        colorCollvw.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update placeholder constraint
        self.con_collHgt.constant = self.colorCollvw.collectionViewLayout.collectionViewContentSize.height
    }
    
    @objc func colorSelected(_ sender: UIButton) {
        let hint = Int(sender.accessibilityHint!)
        selColorId = hint!
        colorCollvw.reloadData()
    }
    
    @IBAction func cancelAction() {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Call Lable Api
    func callLableApi() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "callLableApi"), object: nil, userInfo: nil)
    }
    
    func gotoDMS(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            self.callLableApi()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func addAction() {
    
        let Name: String = txtName.text!
        
        if Name.isEmpty {
            alertSample(strTitle: "", strMsg: "Please enter a folder name")
        }
        else if !isValidFolderName(pid: parentId) {
            alertSample(strTitle: "", strMsg: "Label/Folder name already exists")
        }
        else {
            addFolderAPI()
        }
    }
    
    func addFolderAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api: String = "v1/label/Create"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        
        let Name: String = txtName.text!
        var Color: String = "" //+ colorArr[selColorId]
        
        if selColorId >= 0 {
            Color = "#" + colorArr[selColorId]
        } else {
            Color = "#000000"
        }
        
        let CreatedProfileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        let LabelCategory = 1
        //let ParentId = 0
        
        let parameters: [String:Any] = ["Name": Name, "Color": Color, "CreatedProfileId": CreatedProfileId, "LabelCategory": LabelCategory, "ParentId": parentId ]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .put, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    if !response.result.isFailure {
                        
                         let jsonObj: JSON = JSON(response.result.value!)
                            
                            if jsonObj["StatusCode"] == 1000
                            {
                                
                                //self.dismiss(animated: true, completion: nil)
                                DispatchQueue.main.async {
                                    //self.alertSample(strTitle: "", strMsg: "Folder added successfully.")
                                    self.gotoDMS(msg: "Folder added successfully.")
                                    //self.perform(#selector(self.cancelAction), with: self, afterDelay: 0.5)
                                }
                                
                            }
                            else
                            {
                                self.alertSample(strTitle: "", strMsg: "Error adding folder")
                            }
                        
                       
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func callLabelAPI() {
        
        self.labelArr = []
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/label/getlabels?labelCategory=1"
        let apiURL = Singletone.shareInstance.apiUserService + api
        //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/getlabels?labelCategory=1"
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            let data = jsonObj["Data"].array
                            var parentIdArr:[Int] = []
                            
                            for dic in data! {
                                
                                let labeldata = LabelData(dictionary: dic.dictionaryObject!)
                                self.labelArr.append(labeldata)
                                print("getParentNodes: \(self.getParentNodes(id: labeldata.Id!, name: ""))")
                            }
                            //self.pickerview.isHidden = false
                            //self.pickerview.reloadAllComponents()
                            if self.parentFlag {
                                self.con_tblHgt.constant = 200
                            }
                            self.labelTblView.dataSource = self
                            self.labelTblView.delegate = self
                            self.labelTblView.reloadData()
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
    
    func initLabelAlert() {
        callLabelAPI()
    }
    
    func getParentNodes(id: Int, name: String) -> String {
        
        let data = self.labelArr.filter{ ($0.Id == id) }
        if data != nil && data.count > 0 {
            let str1 = data[0].Name!
            let str = "\(str1)\\\(name)"
            getParentNodes(id: data[0].ParentId!, name: str)
        }
        print(name)
        return name
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        parentFlag = true
        if labelArr.count > 0 {
            if con_tblHgt.constant == 0 {
                con_tblHgt.constant = 200
            } else {
                con_tblHgt.constant = 0
            }
        }
        return false
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return labelArr.count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let data = self.labelArr[indexPath.row]
        if data.Name == "Archive" {
            return 0
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.backgroundColor = UIColor.green
        //let lbl = cell.viewWithTag(2) as! UILabel
        //lbl.textColor = UIColor.black
        cell.textLabel?.textColor = UIColor.black
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "labelCell")
        }
        
        let data = self.labelArr[indexPath.row]
        let strname = self.getParentNodes(id: data.Id!, name: "")
        print("getParentNodes: \(strname)")
        
        //cell?.textLabel?.text = strname
        let lbl = cell?.viewWithTag(1) as! UILabel
        lbl.text = data.Name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.labelArr[indexPath.row]
        print("name: \(data.Name)")
        txtParent.text = data.Name
        parentId = data.Id!
        con_tblHgt.constant = 0
        parentFlag = false
    }
    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    override func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return labelArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let data = self.labelArr[row]
        let strname = self.getParentNodes(id: data.Id!, name: "")
        print("getParentNodes: \(strname)")
        
        return strname
    }
    
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let data = self.labelArr[row]
        print("name: \(data.Name)")
        txtParent.text = data.Name
        parentId = data.Id!
        
        pickerview.isHidden = true
    }
    
    @objc func tapAction() {
        con_tblHgt.constant = 0
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
