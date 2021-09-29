//
//  AdminSettingsController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 11/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class AdminSettingsController: UIViewController {
    
    private var settingTableView: UITableView!
    private let kbasettigscellIdentifier: String = "kabsettigscellIdentifier"
    private var saveadminsettingsButton: UIButton!
    private var activityIndicator: UIActivityIndicatorView!
    
    private var _kbaStatus: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setnavbar()
        setupSettingTableView()
        setupSaveButton()
        setactivityIndicator()
        getadminSettings()
    }
}

//MARK: - Setup Nav
extension AdminSettingsController {
    private func setnavbar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.title = "Settings"
        self.navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}

//MARK: - Setup Settings Table View
extension AdminSettingsController {
    private func setupSettingTableView() {
        
        settingTableView = UITableView(frame: .zero, style: .plain)
        settingTableView.register(AdminSettingsKBACell.self, forCellReuseIdentifier: kbasettigscellIdentifier)
        settingTableView.translatesAutoresizingMaskIntoConstraints = false
        settingTableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.estimatedRowHeight = 200
        settingTableView.tableFooterView = UIView()
        settingTableView.separatorStyle = .none
        view.addSubview(settingTableView)
        
        let safearea = view.safeAreaLayoutGuide
        
        let settingstableviewConstraints = [settingTableView.leftAnchor.constraint(equalTo: safearea.leftAnchor),
                                            settingTableView.topAnchor.constraint(equalTo: safearea.topAnchor),
                                            settingTableView.rightAnchor.constraint(equalTo: safearea.rightAnchor),
                                            settingTableView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor)]
        NSLayoutConstraint.activate(settingstableviewConstraints)
    }
}

//MARK: - Table View Datasource implementation
extension AdminSettingsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let kbaCell = tableView.dequeueReusableCell(withIdentifier: kbasettigscellIdentifier) as! AdminSettingsKBACell
        kbaCell.setkbaStatus = _kbaStatus
        
        kbaCell.kbaStatusCallBack = { [weak self] status in
            if let _status = status {
                self?._kbaStatus = _status
            }
            return
        }
        return kbaCell
    }
}
//MARK: - Table View Delegates
extension AdminSettingsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//MARK: - Setup Save Button
extension AdminSettingsController {
    private func setupSaveButton() {
        saveadminsettingsButton = UIButton()
        saveadminsettingsButton.translatesAutoresizingMaskIntoConstraints = false
        saveadminsettingsButton.backgroundColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        saveadminsettingsButton.setTitleColor(.white, for: .normal)
        saveadminsettingsButton.setTitle("SAVE", for: .normal)
        saveadminsettingsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 18)
        saveadminsettingsButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveadminsettingsButton.titleLabel?.minimumScaleFactor = 0.2
        saveadminsettingsButton.titleLabel?.textAlignment = .center
        
        view.addSubview(saveadminsettingsButton)
        
        let safearea = view.safeAreaLayoutGuide
        
        let saveadminsettingsButtonConstraints = [saveadminsettingsButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                                  saveadminsettingsButton.bottomAnchor.constraint(equalTo: safearea.bottomAnchor, constant: -10),
                                                  saveadminsettingsButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                                  saveadminsettingsButton.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(saveadminsettingsButtonConstraints)
        
        saveadminsettingsButton.layer.shadowRadius = 1.0
        saveadminsettingsButton.layer.shadowColor  = UIColor.lightGray.cgColor
        saveadminsettingsButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        saveadminsettingsButton.layer.shadowOpacity = 0.5
        saveadminsettingsButton.layer.masksToBounds = false
        saveadminsettingsButton.layer.cornerRadius = 5
        
        saveadminsettingsButton.addTarget(self, action: #selector(saveSettingsAction(_:)), for: .touchUpInside)
    }
}

//MARK: - Set Activity Indicator
extension AdminSettingsController {
    private func setactivityIndicator() {
        
        activityIndicator = UIActivityIndicatorView(style: .white)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        saveadminsettingsButton.addSubview(activityIndicator)
        
        let activityindicatorConstraints = [activityIndicator.centerYAnchor.constraint(equalTo: saveadminsettingsButton.centerYAnchor),
                                            activityIndicator.leftAnchor.constraint(equalTo: saveadminsettingsButton.leftAnchor, constant: 10)]
        
        NSLayoutConstraint.activate(activityindicatorConstraints)
        
    }
}

//MARK: - Fetch Settings Details
extension AdminSettingsController {
    private func getadminSettings() {
        view.isUserInteractionEnabled = false
        saveadminsettingsButton.isEnabled = false
        activityIndicator.startAnimating()
        let getorgsettings = GetOrganizationSettings()
        getorgsettings.getAdminSettings { (_orgsettings) in
            guard let orgsettings = _orgsettings else {
                self.showSettingsAlert(title: "Error !", messsage: "Unable to get Settings")
                return
            }
            
            guard let kbastaus = orgsettings.Data?.KBAStatus else {
                self.showSettingsAlert(title: "Error !", messsage: "Unable to get Settings")
                return
            }
            
            self.view.isUserInteractionEnabled = true
            self.activityIndicator.stopAnimating()
            self.saveadminsettingsButton.isEnabled = true
            self._kbaStatus = kbastaus
            
            DispatchQueue.main.async {
                self.settingTableView.reloadData()
            }
            return
        }
    }
}

//MARK: - Update kba Settings
extension AdminSettingsController {
    @objc private func saveSettingsAction(_ sender: UIButton) {
        
        view.isUserInteractionEnabled = false
        saveadminsettingsButton.isEnabled = false
        activityIndicator.startAnimating()
        var postorgSettings = PostOrganizationSettings()
        postorgSettings.KBAStatus = _kbaStatus
        
        postorgSettings.updateAdminSettings(postoraganizationsettings: postorgSettings) { (_success, _err) in
            self.view.isUserInteractionEnabled = true
            self.saveadminsettingsButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            if _success {
                self.showSettingsAlert(title: "Success !", messsage: "Settings Updated Successfully")
                return
            }
            
            self.showSettingsAlert(title: "Error !", messsage: _err ?? "Unable to update Settings")
            return
        }
    }
}

extension AdminSettingsController {
    @objc private func showSettingsAlert(title: String, messsage: String) {
        let alertcontroller = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        alertcontroller.view.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        
        let alertaction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertcontroller.addAction(alertaction)
        
        DispatchQueue.main.async {
            self.present(alertcontroller, animated: true, completion: nil)
        }
    }
}
