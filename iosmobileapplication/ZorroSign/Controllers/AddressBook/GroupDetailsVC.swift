//
//  GroupDetailsVC.swift
//  ZorroSign
//
//  Created by Apple on 02/02/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class GroupDetailsVC: BaseVC, UITableViewDataSource, UITableViewDelegate {

    
    var selGrpArr: [ContactsData] = []
    var groupId: Int = 0
    var grpName: String = ""
    var grpDesc: String = ""
    
    @IBOutlet weak var tblGrp: UITableView!
    //@IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getGrpContact()
    }

    func getGrpContact() {
       
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
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
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
                                                self.selGrpArr.append(contact)
                                                
                                                
                                            }
                                        }
                                    }
                                    self.tblGrp.reloadData()
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        if section == 2 {
            return selGrpArr.count
        }*/
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "titleCell") as! LabelCell
        
        if indexPath.section == 0 {
            let lblname = cell.viewWithTag(1) as! UILabel
            lblname.text = "Name:"
            
            let lblcontent = cell.viewWithTag(2) as! UILabel
            lblcontent.text = grpName
            
        }
        if indexPath.section == 1 {
            let lblname = cell.viewWithTag(1) as! UILabel
            lblname.text = "Description:"
            
            let lblcontent = cell.viewWithTag(2) as! UILabel
            lblcontent.text = grpDesc
            
        }
        if indexPath.section == 2 {
        
            cell = tableView.dequeueReusableCell(withIdentifier: "collvwCell") as! LabelCell
            
            cell.collView.reloadData()
            return cell
        }
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 2 {
            return "Contact Details:"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       
        
        return UITableView.automaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func contactDetailPopup(data: ContactsData) {
        
        let email: String = "Email: \(data.Email ?? "")"
        let jobtitle: String = "Job Title: \(data.JobTitle ?? "")"
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: email, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: jobtitle, style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
extension GroupDetailsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return selGrpArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! LinkContactCell
        
        
        let data = selGrpArr[indexPath.row]
        
        let lblname = cell.viewWithTag(2) as! UILabel
        lblname.text = data.Name
        
        cell.btndel.isHidden = true
        
        let imgProf = cell.viewWithTag(1) as! UIImageView
        if let thumbURL = data.Thumbnail {
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //let data = selGrpArr[indexPath.row]
        //contactDetailPopup(data: data)
    }
    
}
