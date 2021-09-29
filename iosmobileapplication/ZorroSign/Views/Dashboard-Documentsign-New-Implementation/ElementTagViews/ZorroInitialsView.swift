//
//  ZorroInitialsView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroInitialsView: ZorroTagBaseView {
    
    private var imageView: UIImageView!
    private var setInitialButton: UIButton!
    private var signagurepickerView: UIPickerView!
    private var userSignature: [UserSignature] = []
    private var selecteImage: UIImage!
    var usersignatureId: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroInitialsView {
    fileprivate func setsubViews() {
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        addSubview(imageView)
        
        let imageviewConstraints = [imageView.leftAnchor.constraint(equalTo: leftAnchor),
                                    imageView.topAnchor.constraint(equalTo: topAnchor),
                                    imageView.rightAnchor.constraint(equalTo: rightAnchor),
                                    imageView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(imageviewConstraints)
        
        setInitialButton = UIButton()
        setInitialButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(setInitialButton)
        
        let buttonConstraints = [setInitialButton.leftAnchor.constraint(equalTo: leftAnchor),
                                 setInitialButton.topAnchor.constraint(equalTo: topAnchor),
                                 setInitialButton.rightAnchor.constraint(equalTo: rightAnchor),
                                 setInitialButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(buttonConstraints)
        setInitialButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
    }
}

extension ZorroInitialsView {
    func setelementTag() {
        imageView.tag = tagID
        setInitialButton.tag = tagID
        setInitialButton.setTitle("Initial", for: .normal)
        setInitialButton.titleLabel?.adjustsFontSizeToFitWidth = true
        setInitialButton.titleLabel?.minimumScaleFactor = 0.2
        setInitialButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        setInitialButton.setTitleColor(.black, for: .normal)
    }
}

extension ZorroInitialsView {
    func setProperties(autosaved: AutoSavedData?) {
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 1 {
                        guard let apply = tagdetail.apply else { return }
                        if apply {
                            let signature = ZorroTempData.sharedInstance.getInitials()
                            if signature != "" {
                                guard let decodedata = Data(base64Encoded: signature) else { return }
                                let signatureimage = UIImage(data: decodedata)
                                imageView.image = signatureimage
                                setInitialButton.isHidden = true
                                iscompleted = true
                                return
                            }
                        }
                    }
                }
            }
        }
        return
    }
}

extension ZorroInitialsView {
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        if let allSignatures = ZorroTempData.sharedInstance.getallSignatures() {
            userSignature = allSignatures
            if userSignature.count > 0 {
                guard let signature = userSignature[0].Initials else {
                    self.setcommonAlert(title: "No Initial Found", message: "Please add an initial to your account", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                        return
                    })
                    return
                }
                
                self.selecteImage = self.getImage(signature: signature)
                self.usersignatureId = self.userSignature[0].UserSignatureId
                self.setsignaturePicker()
            } else {
                SharingManager.sharedInstance.triggerSignatureSlected(tapped: true)
                sender.isEnabled = true
            }
        } else {
            sender.isEnabled = true
            self.setcommonAlert(title: "No Initial Found", message: "Please add an initial to your account", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                return
            })
            return
        }
    }
}

//MARK : Set signature picker view
extension ZorroInitialsView {
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
            self.iscompleted = true
            self.tagText = ""
            self.imageView.image = self.selecteImage
            self.setInitialButton.isHidden = true
            return
        }
        
        pickeralert.addAction(selectAction)
        pickeralert.setValue(signatureviewcontroller, forKey: "contentViewController")
        self.window?.rootViewController?.present(pickeralert, animated: true, completion: nil)
    }
}

//MARK: Pickerview delegates
extension ZorroInitialsView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userSignature.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let signaturestring = userSignature[row].Initials
        let signatureimage = getImage(signature: signaturestring!)
        let widthheightratio = signatureimage.size.width / signatureimage.size.height
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: widthheightratio * 50, height: 50))
        imageview.backgroundColor = .clear
        imageview.image = signatureimage
        
        return imageview
    }
}

extension ZorroInitialsView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        let selectedsignature = userSignature[row]
        let signaturestring = selectedsignature.Initials
        let signatureimage = getImage(signature: signaturestring!)
        selecteImage = signatureimage
        usersignatureId = selectedsignature.UserSignatureId
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

//MARK: Get image
extension ZorroInitialsView {
    fileprivate func getImage(signature: String) -> UIImage {
        
        if signature.contains(",") {
            let splitsignature = signature.components(separatedBy: ",")
            let base64string = splitsignature[1]
            guard let decodedata = Data(base64Encoded: base64string) else { return UIImage()}
            let signatureimage = UIImage(data: decodedata)
            return signatureimage!
        } else {
            return UIImage()
        }
    }
}





