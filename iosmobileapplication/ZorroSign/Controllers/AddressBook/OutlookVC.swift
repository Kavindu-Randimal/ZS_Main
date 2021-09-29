//
//  OutlookVC.swift
//  ZorroSign
//
//  Created by Apple on 20/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class OutlookVC: BaseVC {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let service = OutlookService.shared()
    var dataSource: ContactsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setLogInState(loggedIn: service.isLoggedIn)
        
        tableView.estimatedRowHeight = 90;
        tableView.rowHeight = UITableView.automaticDimension
        
        if (service.isLoggedIn) {
            loadUserData()
        }
    }
    
    func setLogInState(loggedIn: Bool) {
        if (loggedIn) {
            loginButton.setTitle("Log Out", for: UIControl.State.normal)
        }
        else {
            loginButton.setTitle("Log In", for: UIControl.State.normal)
        }
    }
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        if (service.isLoggedIn) {
            // Logout
            service.logout()
            setLogInState(loggedIn: false)
        } else {
            // Login
            service.login(from: self) {
                error in
                if let unwrappedError = error {
                    NSLog("Error logging in: \(unwrappedError)")
                } else {
                    NSLog("Successfully logged in.")
                    self.setLogInState(loggedIn: true)
                }
            }
        }
    }
    
  
    
    func loadUserData() {
        //service.getUserEmail() {
          //  email in
            //if let unwrappedEmail = email {
                //NSLog("Hello \(unwrappedEmail)")
                
                self.service.getContacts() {
                    contacts in
                    if let unwrappedContacts = contacts {
                        self.dataSource = ContactsDataSource(contacts: unwrappedContacts["value"].arrayValue)
                        self.tableView.dataSource = self.dataSource
                        self.tableView.reloadData()
                    }
                }
            //}
        //}
    }
    
    
    
    @IBAction func closeAction() {
        
        self.dismiss(animated: false, completion: nil)
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
