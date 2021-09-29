//
//  ZorroDocumentInitiateInitialView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/20/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDocumentInitiateInitialView: ZorroDocumentInitiateBaseView {
    
    private var userInitials: [UserSignature] = []
    private var selectedsignatureImage: UIImage!
    var selectedsignatureId: Int!
    private var signagurepickerView: UIPickerView!
    
    private var signatureimageView: UIImageView!
    private var usernameLabel: UILabel!
}

extension ZorroDocumentInitiateInitialView {
    override func setsubViews() {
        
        setsignatureiImage()
        setusernameLabel()
        bringviewstoFront()
    }
}

extension ZorroDocumentInitiateInitialView {
    fileprivate func setsignatureiImage() {
        signatureimageView = UIImageView()
        signatureimageView.translatesAutoresizingMaskIntoConstraints = false
        signatureimageView.backgroundColor = .clear
        signatureimageView.contentMode = .scaleAspectFit
        
        containersubView.addSubview(signatureimageView)
        
        let signatureimageviewConstrains = [signatureimageView.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                            signatureimageView.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                            signatureimageView.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                            signatureimageView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(signatureimageviewConstrains)
    }
}

extension ZorroDocumentInitiateInitialView {
    fileprivate func setusernameLabel() {
        usernameLabel = UILabel()
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.textAlignment = .left
        usernameLabel.backgroundColor = .white
        usernameLabel.adjustsFontSizeToFitWidth = true
        usernameLabel.minimumScaleFactor = 0.2
        containersubView.addSubview(usernameLabel)
        
        let usernamelabelConstraints = [usernameLabel.leftAnchor.constraint(equalTo: containersubView.leftAnchor, constant: 5),
                                        usernameLabel.topAnchor.constraint(equalTo: containersubView.topAnchor, constant: 0),
                                        usernameLabel.rightAnchor.constraint(equalTo: containersubView.rightAnchor, constant: 0),
                                        usernameLabel.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor, constant: 0)]
        NSLayoutConstraint.activate(usernamelabelConstraints)
    }
}


//MARK: - Get the signatures
extension ZorroDocumentInitiateInitialView {
    func setSignature(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            
            if isinitiator {
                if let signatures = ZorroTempData.sharedInstance.getallSignatures() {
                    guard let defaultsignaure = signatures.first else {
                        return
                    }
                    userInitials = signatures
                    selectedsignatureImage = getImage(signature: defaultsignaure.Initials!)
                    selectedsignatureId = defaultsignaure.UserSignatureId
                    usernameLabel.isHidden = true
                    signatureimageView.image = selectedsignatureImage
                    setsignaturePicker()
                } else {
                    
                }
            } else {
                if contacts.count == 1 {
                    if let username = contacts.first?.Name {
                        usernameLabel.text = getuserInitials(username: username)
                    }
                } else {
                    usernameLabel.text = "Multiple \(contacts.count)"
                }
            }
        } else {
            if contacts.count == 1 {
                if let username = contacts.first?.Name {
                    usernameLabel.text = getuserInitials(username: username)
                }
            } else {
                usernameLabel.text = "Multiple \(contacts.count)"
            }
        }
    }
}

//MARK: - Signature Picker view
extension ZorroDocumentInitiateInitialView {
    fileprivate func setsignaturePicker() {
        let signatureviewcontroller = UIViewController()
        signatureviewcontroller.preferredContentSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height/4)
        
        signagurepickerView = UIPickerView()
        signagurepickerView.translatesAutoresizingMaskIntoConstraints = false
        signagurepickerView.dataSource = self
        signagurepickerView.delegate = self
        
        signatureviewcontroller.view.addSubview(signagurepickerView)
        let pickerviewconstriants = [signagurepickerView.leftAnchor.constraint(equalTo: signatureviewcontroller.view.leftAnchor),
                                     signagurepickerView.topAnchor.constraint(equalTo: signatureviewcontroller.view.topAnchor),
                                     signagurepickerView.rightAnchor.constraint(equalTo: signatureviewcontroller.view.rightAnchor),
                                     signagurepickerView.bottomAnchor.constraint(equalTo: signatureviewcontroller.view.bottomAnchor)]
        
        NSLayoutConstraint.activate(pickerviewconstriants)
        
        let pickeralert = UIAlertController(title: "Initial", message: "Please select a Initial", preferredStyle: .alert)
        pickeralert.view.tintColor = ColorTheme.alertTint
        let selectAction = UIAlertAction(title: "SELECT", style: .cancel) { (alert) in
            print("selection")
            return
        }
        
        pickeralert.addAction(selectAction)
        pickeralert.setValue(signatureviewcontroller, forKey: "contentViewController")
        DispatchQueue.main.async {
            self.window?.rootViewController?.present(pickeralert, animated: true, completion: nil)
        }
        
    }
}

//MARK: Pickerview delegates
extension ZorroDocumentInitiateInitialView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userInitials.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let signaturestring = userInitials[row].Initials
        let signatureimage = getImage(signature: signaturestring!)
        let widthheightratio = signatureimage.size.width / signatureimage.size.height
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: widthheightratio * 50, height: 50))
        imageview.backgroundColor = .clear
        imageview.image = signatureimage
        
        return imageview
    }
}

extension ZorroDocumentInitiateInitialView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        let selectedsignature = userInitials[row]
        let signaturestring = selectedsignature.Initials
        let signatureimage = getImage(signature: signaturestring!)
        selectedsignatureImage = signatureimage
        selectedsignatureId = selectedsignature.UserSignatureId
        signatureimageView.image = signatureimage
        
        extrametadata = SaveExtraMetaData(SignatureId: selectedsignature.UserSignatureId!, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: nil, AttachmentDiscription: nil, AddedBy: nil, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

//MARK: Set User Initials
extension ZorroDocumentInitiateInitialView {
    private func getuserInitials(username: String) -> String {
        var initials = ""
        let splitted = username.split(separator: " ")
        
        let firstnameexist = splitted.indices.contains(0)
        if firstnameexist {
            if let firstcharacter = splitted[0].first {
                initials.append(firstcharacter)
            }
        }
        
        let secondnameexist = splitted.indices.contains(1)
        if secondnameexist {
            if let secondcharacter = splitted[1].first {
                initials.append(secondcharacter)
            }
        }
        
        return initials
    }
}
