//
//  AdminVC.swift
//  ZorroSign
//
//  Created by Apple on 30/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class AdminVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let arrOptions = ["Manage Departments", "Manage Roles", "Manage Users", "Manage Seal", "Settings"]
    
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }

        tblView.layer.cornerRadius = 3
        tblView.layer.borderWidth = 1.0
        tblView.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        tblView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tblView.frame.size.width, height: 1))
        
        addFooterView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "adminCell")
        let title = cell?.viewWithTag(1) as! UILabel
        title.text = arrOptions[indexPath.row]
        return cell!
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "segDept", sender: self)
        }
        if indexPath.row == 1 {
            performSegue(withIdentifier: "segRole", sender: self)
        }
        if indexPath.row == 2 {
            if FeatureMatrix.shared.org_user_settings {
                performSegue(withIdentifier: "segUser", sender: self)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
        if indexPath.row == 3 {
            performSegue(withIdentifier: "segSeal", sender: self)
        }
        if indexPath.row == 4 {
            // let adminsettingsController = AdminSettingsController()
            // self.navigationController?.pushViewController(adminsettingsController, animated: true)
            
            if FeatureMatrix.shared.org_settings {
                let adminSettingsVC = UIStoryboard(name: "MFA", bundle:nil).instantiateViewController(withIdentifier: "AdminSettingsVC")
                self.navigationController?.pushViewController(adminSettingsVC, animated: true)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "gotoDashboard", sender: self)
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
