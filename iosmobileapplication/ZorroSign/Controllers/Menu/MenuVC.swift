//
//  MenuVC.swift
//  ZorroSign
//
//  Created by Apple on 04/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit


class MenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var menutbl: UITableView!
    
    var arrMenu = ["DMS", "Address Book", "Add / Upgrade", "Admin", "Manage Permissions", "Read 4n6 Token","Business Card" ,"Logout"]
    var arrImg = ["dms","addressbook","upgrade","admin","permission","token","vcard", "logout"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as? CustomCell
        
        
        cell?.lblGen?.text = arrMenu[indexPath.row]
        cell?.menuIcon.image = UIImage(named: arrImg[indexPath.row])
        
        if indexPath.row == 0 {
            cell?.con_logoW.constant = 40
            cell?.con_logoH.constant = 40
        } else {
            cell?.con_logoW.constant = 30
            cell?.con_logoH.constant = 30
        }
        cell?.con_lead.constant = 5
        
        if indexPath.row == 5 || indexPath.row == 0 {
            cell?.con_lead.constant = 2
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = UIColor.white
        
        if indexPath.row == 2 {
            cell.backgroundColor = UIColor(red: 229.0/255.0, green: 231.0/255.0, blue: 228.0/255.0, alpha: 1.0)
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        if !adminflag && indexPath.row == 3 {
            return 0
        }
        if indexPath.row == 2 {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 1 {
            if FeatureMatrix.shared.address_book {
                performSegue(withIdentifier: "segContacts", sender: self)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
        
        if indexPath.row == 0 {
            if FeatureMatrix.shared.dms {
                performSegue(withIdentifier: "segDMS", sender: self)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
        if indexPath.row == 3 {
            performSegue(withIdentifier: "segAdmin", sender: self)
        }
        if indexPath.row == 4 {
            performSegue(withIdentifier: "segPermission", sender: self)
        }
        
        if indexPath.row == 5 {
            if FeatureMatrix.shared.audit_trail {
                performSegue(withIdentifier: "segDocument", sender: self)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
        if indexPath.row == 6 {
            if FeatureMatrix.shared.business_card {
            let vcardqrgeneratorController = VcardqrgeneratorController()
            vcardqrgeneratorController.isFromLogin = false
            self.revealViewController()?.pushFrontViewController(vcardqrgeneratorController, animated: true)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
        
        if indexPath.row == 7 {
            btnLogOutAction()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menutbl.tableFooterView = UIView(frame: .zero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func btnLogOutAction() {
        alertSampleWithLogin(strTitle: "", strMsg: "Do you want to logout?")
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
