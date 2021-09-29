    //
    //  ZorroDocumentInitiateSignatureView.swift
    //  ZorroSign
    //
    //  Created by Anuradh Caldera on 8/12/19.
    //  Copyright © 2019 Apple. All rights reserved.
    //
    
    import UIKit
    
    class ZorroDocumentInitiateSignatureView: ZorroDocumentInitiateBaseView {
        
        private var userSignatures: [UserSignature] = []
        private var contacts: [ContactDetailsViewModel] = []
        private var selectedsignatureImage: UIImage!
        var selectedsignatureId: Int!
        private var signagurepickerView: UIPickerView!
        
        private var signatureimageView: UIImageView!
        private var usernameLabel: UILabel!
        private var textInputBtn:UIButton!
        
    }
    
    extension ZorroDocumentInitiateSignatureView {
        override func setsubViews() {
            
            setsignatureiImage()
            setusernameLabel()
            bringviewstoFront()
            setTextBtn()
        }
    }
    
    //MARK: - Setup textInput button
    extension ZorroDocumentInitiateSignatureView{
        fileprivate func setTextBtn(){
            textInputBtn = UIButton()
            textInputBtn.translatesAutoresizingMaskIntoConstraints = false
            containersubView.addSubview(textInputBtn)
            let setimageButtonConstraints = [textInputBtn.leftAnchor.constraint(equalTo: leftAnchor),
                                             textInputBtn.topAnchor.constraint(equalTo: topAnchor),
                                             textInputBtn.rightAnchor.constraint(equalTo: rightAnchor),
                                             textInputBtn.bottomAnchor.constraint(equalTo: bottomAnchor)]
            NSLayoutConstraint.activate(setimageButtonConstraints)
            
            textInputBtn.addTarget(self, action: #selector(openpickeronTouch), for: .touchUpInside)
        }
    }
    
    //MARK: - Setup signature view
    extension ZorroDocumentInitiateSignatureView {
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
    
    //MARK: - Setup namelabel
    extension ZorroDocumentInitiateSignatureView {
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
    extension ZorroDocumentInitiateSignatureView {
        func setSignature(contacts: [ContactDetailsViewModel]) {
            
            self.contacts = contacts
            guard let stepnumber = step else { return }
            
            if stepnumber == 1 {
                let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
                
                if isinitiator {
                    if let signatures = ZorroTempData.sharedInstance.getallSignatures() {
                        guard let defaultsignaure = signatures.first else {
                            return
                        }
                        userSignatures = signatures
                        selectedsignatureImage = getImage(signature: defaultsignaure.Signature!)
                        selectedsignatureId = defaultsignaure.UserSignatureId
                        usernameLabel.isHidden = true
                        signatureimageView.image = selectedsignatureImage
                        extrametadata = SaveExtraMetaData(SignatureId: defaultsignaure.UserSignatureId!, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: nil, AttachmentDiscription: nil, AddedBy: nil, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: nil)
                        
                        if signatures.count > 1{
                            setsignaturePicker()
                        }
                    } else {
                        
                    }
                } else {
                    if contacts.count == 1 {
                        usernameLabel.text = contacts.first?.Name
                    } else {
                        usernameLabel.text = "[Multiple - \(contacts.count)]"
                    }
                }
            } else {
                if contacts.count == 1 {
                    usernameLabel.text = contacts.first?.Name
                } else {
                    usernameLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        }
    }
    
    //MARK: - Set signature before display the picker view when tool is selected
    extension ZorroDocumentInitiateSignatureView {
        @objc fileprivate func openpickeronTouch() {
            
            guard let stepnumber = step else { return }
            if stepnumber == 1 {
                let initiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
                
                if initiator {
                    if let signatures = ZorroTempData.sharedInstance.getallSignatures() {
                        userSignatures = signatures
                        usernameLabel.isHidden = true
                        signatureimageView.image = selectedsignatureImage
                        
                        if signatures.count > 0{
                            setsignaturePicker()
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Signature Picker view
    extension ZorroDocumentInitiateSignatureView {
        @objc fileprivate func setsignaturePicker() {
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
            
            let pickeralert = UIAlertController(title: "Signature", message: "Please select a signature", preferredStyle: .alert)
            pickeralert.view.tintColor = ColorTheme.alertTint
            let selectAction = UIAlertAction(title: "SELECT", style: .cancel) { (alert) in
                if(self.signagurepickerView.selectedRow(inComponent: 0) == 0){
                    let selectedsignature = self.userSignatures[0]
                    let signaturestring = selectedsignature.Signature
                    let signatureimage = self.getImage(signature: signaturestring!)
                    self.selectedsignatureImage = signatureimage
                    self.selectedsignatureId = selectedsignature.UserSignatureId
                    self.signatureimageView.image = signatureimage
                    
                    self.extrametadata = SaveExtraMetaData(SignatureId: selectedsignature.UserSignatureId!, CheckState: nil, DateFormat: nil, IsDateAuto: nil, IsTimeOnly: nil, IsWithTime: nil, TagText: nil, TimeFormat: nil, TimeStamp: nil, AttachmentCount: nil, AttachmentDiscription: nil, AddedBy: nil, FontColor: nil, FontId: nil, FontSize: nil, FontStyle: nil, FontType: nil, lock: nil)
                    
                }
                
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
    extension ZorroDocumentInitiateSignatureView: UIPickerViewDataSource {
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return userSignatures.count
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let signaturestring = userSignatures[row].Signature
            let signatureimage = getImage(signature: signaturestring!)
            let widthheightratio = signatureimage.size.width / signatureimage.size.height
            let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: widthheightratio * 50, height: 50))
            imageview.backgroundColor = .clear
            imageview.image = signatureimage
            
            return imageview
        }
    }
    
    extension ZorroDocumentInitiateSignatureView: UIPickerViewDelegate {
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            print(row)
            let selectedsignature = userSignatures[row]
            let signaturestring = selectedsignature.Signature
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


