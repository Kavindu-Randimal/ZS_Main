//
//  ZorroTagImageView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift

class ZorroSignatureView: ZorroTagBaseView {
    
    private var imageView: UIImageView!
    private var setimageButton: UIButton!
    private var signagurepickerView: UIPickerView!
    private var userSignature: [UserSignature] = []
    private var selecteImage: UIImage!
    var usersignatureId: Int?
    private let disposebag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroSignatureView {
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
        
        setimageButton = UIButton()
        setimageButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(setimageButton)
        
        let setimageButtonConstraints = [setimageButton.leftAnchor.constraint(equalTo: leftAnchor),
                                         setimageButton.topAnchor.constraint(equalTo: topAnchor),
                                         setimageButton.rightAnchor.constraint(equalTo: rightAnchor),
                                         setimageButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(setimageButtonConstraints)
        setimageButton.addTarget(self, action: #selector(setimageButtonAction(_:)), for: .touchUpInside)
    }
}

extension ZorroSignatureView {
    func setelementTag() {
        imageView.tag = tagID
        setimageButton.tag = tagID
        setimageButton.setTitle("\(tagName!)", for: .normal)
        setimageButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        setimageButton.setTitleColor(.black, for: .normal)
    }
}

extension ZorroSignatureView {
    func setProperties(autosaved: AutoSavedData?) {
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 0 {
                        guard let apply = tagdetail.apply else { return }
                        if apply {
                            let signature = ZorroTempData.sharedInstance.getSignature()
                            if signature != "" {
                                guard let decodedata = Data(base64Encoded: signature) else { return }
                                let signatureimage = UIImage(data: decodedata)
                                imageView.image = signatureimage
                                setimageButton.isHidden = true
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

extension ZorroSignatureView {
    @objc fileprivate func setimageButtonAction(_ sender: UIButton) {
        
        sender.isEnabled = false
        
        if let allSignatures = ZorroTempData.sharedInstance.getallSignatures() {
            userSignature = allSignatures
            if userSignature.count > 0 {
                guard let signature = userSignature[0].Signature else {
                    self.setcommonAlert(title: "No Signature Found", message: "Please add a signature to your account", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
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
            self.setcommonAlert(title: "No Signature Found", message: "Please add a signature to your account", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                return
            })
            return
        }
    }
}

//MARK : Set signature picker view
extension ZorroSignatureView {
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
        
        let pickeralert = UIAlertController(title: "Signature", message: "Please select a signature", preferredStyle: .alert)
        pickeralert.view.tintColor = ColorTheme.alertTint
        let selectAction = UIAlertAction(title: "SELECT", style: .cancel) { (alert) in
            print("selection")
            self.iscompleted = true
            self.tagText = ""
            self.imageView.image = self.selecteImage
            self.setimageButton.isHidden = false
            self.setimageButton.isEnabled = true
            self.setimageButton.setTitle("", for: .normal)
            return
        }
        
        pickeralert.addAction(selectAction)
        pickeralert.setValue(signatureviewcontroller, forKey: "contentViewController")
        self.window?.rootViewController?.present(pickeralert, animated: true, completion: nil)
    }
}

//MARK: Pickerview delegates
extension ZorroSignatureView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return userSignature.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let signaturestring = userSignature[row].Signature
        let signatureimage = getImage(signature: signaturestring!)
        let widthheightratio = signatureimage.size.width / signatureimage.size.height
        let imageview = UIImageView(frame: CGRect(x: 0, y: 0, width: widthheightratio * 50, height: 50))
        imageview.backgroundColor = .clear
        imageview.image = signatureimage
        
        return imageview
    }
}

extension ZorroSignatureView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(row)
        let selectedsignature = userSignature[row]
        let signaturestring = selectedsignature.Signature
        let signatureimage = getImage(signature: signaturestring!)
        selecteImage = signatureimage
        usersignatureId = selectedsignature.UserSignatureId
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

//MARK: Get image
extension ZorroSignatureView {
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

