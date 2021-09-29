//
//  SignatureSelectVC.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2021-01-24.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit

class AddSignatureVC: BaseVC, LoadingIndicatorDelegate {
    
    // MARK: - Variables
    
    var vm = AddSignatureVM()
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableViewSignature: UITableView! {
        didSet {
            tableViewSignature.delegate = self
            tableViewSignature.dataSource = self
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getProfileData()
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        
    }
    
    // MARK: - GET ProfileData
    
    func getProfileData() {
        startLoading()
        vm.getProfiledata { (success, statusCode, message) in
            self.stopLoading()
            if success {
                self.tableViewSignature.reloadData()
            } else {
                AlertProvider.init(vc: self).showAlert(title: "Alert", message: message, action: AlertAction(title: "Dismiss"))
            }
        }
    }
    
    // MARK: - POST Default Signature Changes
    
    func sentSelectedDefaultSignature(selectedIndex: Int) {
        
        vm.prepareSignArrayForDefaultChanges(selectedIndex: selectedIndex)
        
        startLoading()
        vm.netReqUpdateSignature { (success, statusCode, message) in
            self.stopLoading()
            
            if success {
                self.vm.defaultSignature = nil
                self.vm.arrOptionalSignatures = nil
                self.getProfileData()
            } else {
                AlertProvider.init(vc: self).showAlert(title: "Unable to set default signature", message: message, action: AlertAction(title: "Dismiss"))
                
                self.vm.revertBackToOriginalArray(selectedIndex: selectedIndex)
                self.tableViewSignature.reloadData()
            }
        }
    }
}

// MARK: - TableView Delegate

extension AddSignatureVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if vm.signatureCount == 0 {
            return 1
        } else {
            if vm.signatureCount < 3 {
                return vm.signatureCount + 1
            } else {
                return vm.signatureCount
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if vm.signatureCount == 0 {
            if let addSignatureCell = tableView.dequeueReusableCell(withIdentifier: "AddSignatureTVCell", for: indexPath) as? AddSignatureTVCell {
                addSignatureCell.addObservers()
                addSignatureCell.delegate = self
                addSignatureCell.lblSignatureNo.text = "Signature \(indexPath.row + 1)"
                
                return addSignatureCell
            }
        } else {
            
            if indexPath.row == 0 {
                if let signatureCell = tableView.dequeueReusableCell(withIdentifier: "SignatureTVCell", for: indexPath) as? SignatureTVCell {
                    signatureCell.setDefaultSignature(signature: vm.defaultSignature, isDefault: true)
                    signatureCell.delegate = self
                    signatureCell.signatureNo = .One
                    signatureCell.lblSignatureNo.text = "Signature \(indexPath.row + 1)"
                    return signatureCell
                }
            } else {
                // If there is more row available than signatureCount Then adding AddSignatureTVCell
                if indexPath.row > (vm.signatureCount - 1) {
                    if let addSignatureCell = tableView.dequeueReusableCell(withIdentifier: "AddSignatureTVCell", for: indexPath) as? AddSignatureTVCell {
                        addSignatureCell.delegate = self
                    
                        addSignatureCell.addObservers()
                        addSignatureCell.lblSignatureNo.text = "Signature \(indexPath.row + 1)"
                        return addSignatureCell
                    }
                } else {
                    if let signatureCell = tableView.dequeueReusableCell(withIdentifier: "SignatureTVCell", for: indexPath) as? SignatureTVCell {
                        signatureCell.setOptionalSignature(signature: vm.arrOptionalSignatures?[indexPath.row - 1], isDefault: false, signatureIndex: indexPath.row - 1)
                        signatureCell.delegate = self
                        signatureCell.lblSignatureNo.text = "Signature \(indexPath.row + 1)"
                        
                        if indexPath.row == 1 {
                            signatureCell.signatureNo = .Two
                        } else if indexPath.row == 2 {
                            signatureCell.signatureNo = .Three
                        }
                        
                        return signatureCell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if vm.signatureCount == 0 {
            return 170
        } else if indexPath.row > (vm.signatureCount - 1) {
            return 170
        } else {
            return 200
        }
    }
}

// MARK: - SignatureCell Delegate

extension AddSignatureVC: SignatureCellDelegate {
    
    func didTapOnDefault(index: Int) {
        sentSelectedDefaultSignature(selectedIndex: index)
    }
    
    func didTapOnEdit(signatureNo: SignatureNo) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
        let signatureVC = storyBoard.instantiateViewController(withIdentifier: "SignatureVC") as! SignatureVC
        
        signatureVC.vm.isEditingOldSignature = true
        signatureVC.vm.selectedSignatureToEdit = signatureNo
        
        signatureVC.vm.userProfile = vm.userProfile
        signatureVC.vm.defaultSignature = vm.defaultSignature
        signatureVC.vm.arrOptionalSignatures = vm.arrOptionalSignatures
        
        self.navigationController?.pushViewController(signatureVC, animated: true)
    }
    
    func didTapOnDelete(signatureNo: SignatureNo) {
        AlertProvider.init(vc: self).showAlertWithActions(title: "Confirmation", message: "Do you want to delete the signature", actions: [AlertAction(title: "Cancel"), AlertAction(title: "Confirm")]) { (action) in
            if action.title == "Confirm" {
                print(signatureNo.rawValue)
                self.vm.prepareSignArray(signatureNo: signatureNo.rawValue) { [weak self] isDeleted in
                    if isDeleted {
                        self!.startLoading()
                        self?.vm.updateSignature { (success, statusCode, message) in
                            self!.stopLoading()
                            if success {
                                AlertProvider.init(vc: self!).showAlertWithAction(title: "Signature deleted", message: message, action: AlertAction(title: "Dismiss")) { (action) in
                                    self!.getProfileData()
                                }
                            } else {
                                AlertProvider.init(vc: self!).showAlert(title: "Unable to delete Signature", message: message, action: AlertAction(title: "Dismiss"))
                            }
                        }
                    } else {
                        AlertProvider.init(vc: self!).showAlert(title: "Cannot delete Signature", message: "You have to add atleast one signature before deleting the default signature", action: AlertAction(title: "Dismiss"))
                    }
                }
            }
        }
    }
}

// MARK: - AddSignatureCell Delegate

extension AddSignatureVC: AddSignatureCellDelegate {
    
    func didTapOnAddSiganture() {
        if vm.signatureCount != 0 {
            if FeatureMatrix.shared.multiple_signature_capture {
                openSignatureScreen()
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
        } else {
            openSignatureScreen()
        }
    }
    
    func openSignatureScreen() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Signature", bundle:nil)
        let signatureVC = storyBoard.instantiateViewController(withIdentifier: "SignatureVC") as! SignatureVC
        
        signatureVC.vm.userProfile = vm.userProfile
        signatureVC.vm.defaultSignature = vm.defaultSignature
        signatureVC.vm.arrOptionalSignatures = vm.arrOptionalSignatures
        
        self.navigationController?.pushViewController(signatureVC, animated: true)
    }
}
