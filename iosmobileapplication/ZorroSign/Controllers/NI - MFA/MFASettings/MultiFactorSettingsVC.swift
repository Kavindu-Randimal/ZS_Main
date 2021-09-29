//
//  MFAVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ADCountryPicker

class MultiFactorSettingsVC: UIViewController {
    
    // MARK: - Variables
    
    let vm = MultiFactorSettingsVM()
    
    // MARK: - Outlets
    
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var viewMenuSwitches: UIView!
    @IBOutlet weak var switchBiometric: UISwitch!
    @IBOutlet weak var switchOTP: UISwitch!
    
    @IBOutlet weak var viewMenuRadioButtons: UIView!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupUI()
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        switch vm.mfaSettings {
        case .Force:
            lblHeader.isHidden = true
            viewMenuSwitches.isHidden = true
            viewMenuRadioButtons.isHidden = false
            break
        case .Normal:
            lblHeader.isHidden = false
            viewMenuSwitches.isHidden = false
            viewMenuRadioButtons.isHidden = true
            break
        }
    }
    
    func setupUI() {
        viewMenuSwitches.layer.cornerRadius = 10
        viewMenuSwitches.addShadowAllSide()
    }
}

// MARK: - TableView Delegate

extension MultiFactorSettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OTPTVCell", for: indexPath) as! OTPTVCell
            cell.configUI()
            cell.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OTPVerifyTVCell", for: indexPath) as! OTPVerifyTVCell
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MFAEnablingOptionTVCell", for: indexPath) as! MFAEnablingOptionTVCell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - OTPTVCell Delegate

extension MultiFactorSettingsVC: OTPTVCellDelegate {
    
    internal func showCountryPicker() {
        let countryPicker = ADCountryPicker()
        countryPicker.showCallingCodes = true
        countryPicker.didSelectCountryWithCallingCodeClosure = { [weak self] (name, code, dialcode) in
            self?.vm.mobileNo = MobileNo(countryName: name, code: code, dialCode: dialcode)
            self?.navigationController?.popViewController(animated: true)
//            self?.dismiss(animated: true, completion: nil)
//            self?.multifactorSettingsViewModelData.countryDialcode = dialcode
//            self?.multifactorSettingsViewModelData.countryCode = code
//            DispatchQueue.main.async {
//                let indexpath = IndexPath(row: 1, section: 0)
//                self?.multifactorSettingsTableView.reloadRows(at: [indexpath], with: .none)
//            }
        }
        
//        self.present(countryPicker, animated: true, completion: nil)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(countryPicker, animated: true)
        }
    }
}
