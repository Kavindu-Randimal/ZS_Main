//
//  ZorroStampView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/2/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift

class ZorroStampView: ZorroTagBaseView {
    
    //MARK: intializing outlets variables and variables
    private var imageView: UIImageView!
    private var setStampButton: UIButton!
    private var stampIndicator: UIActivityIndicatorView!
    private var stampalertController: UIAlertController!
    private var stampimagePicker: UIImagePickerController!
    private let disposebag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Set up stamp image viwe
extension ZorroStampView {
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
        
        setStampButton = UIButton()
        setStampButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(setStampButton)
        
        let buttonConstraints = [setStampButton.leftAnchor.constraint(equalTo: leftAnchor),
                                 setStampButton.topAnchor.constraint(equalTo: topAnchor),
                                 setStampButton.rightAnchor.constraint(equalTo: rightAnchor),
                                 setStampButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(buttonConstraints)
        setStampButton.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        
        stampIndicator = UIActivityIndicatorView()
        stampIndicator.translatesAutoresizingMaskIntoConstraints = false
        stampIndicator.style = .white
        stampIndicator.color = ColorTheme.activityindicator
        addSubview(stampIndicator)
        
        let stampindicatorConstraints = [stampIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
                                         stampIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
                                         stampIndicator.widthAnchor.constraint(equalToConstant: 20),
                                         stampIndicator.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(stampindicatorConstraints)
    }
}

//MARK: Set additional details
extension ZorroStampView {
    func setelementTag() {
        imageView.tag = tagID
        setStampButton.tag = tagID
        setStampButton.setTitle("\(tagName!)", for: .normal)
        setStampButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)
        setStampButton.setTitleColor(.black, for: .normal)
    }
}

//MARK: Stamp button action
extension ZorroStampView {
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        print("Button Tag : \(sender.tag)")
        getstampImage()
    }
}

//MARK: Check for the stamp image
extension ZorroStampView {
    fileprivate func getstampImage() {
        stampIndicator.startAnimating()
        let stamp = ZorroTempData.sharedInstance.getStamp()
        if stamp == "" {
            
            let oraganizationStamp = OrganizationStamp()
            oraganizationStamp.getstampImageString { (stampstring, err) in
                if stampstring == "" {
                    SharingManager.sharedInstance.triggerstampTapped(tapped: true)
                    SharingManager.sharedInstance.onstampSelect?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
                        image in
                        self!.imageView.image = image
                        self!.setStampButton.isHidden = true
                        self!.iscompleted = true
                        self!.tagText = ""
                    }).disposed(by: self.disposebag)
                    return
                }
                self.stampIndicator.stopAnimating()
                self.setImage(imagestring: stampstring)
                return
            }
        } else {
            self.stampIndicator.stopAnimating()
            setImage(imagestring: stamp)
            return
        }
    }
}

//MARK: Set stamp image if exist
extension ZorroStampView {
    fileprivate func setImage(imagestring: String) {
        let teststrings = imagestring.components(separatedBy: ",")
        guard let encodeddata = Data(base64Encoded: teststrings[1]) else { return }
        let stampimage = UIImage(data: encodeddata)
        imageView.image = stampimage
        setStampButton.isHidden = true
        iscompleted = true
        tagText = ""
    }
}

//MARK: Set properties
extension ZorroStampView {
    func setProperties(autosaved: AutoSavedData?) {
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 2 {
                        if let apply = tagdetail.apply {
                            if apply {
                                getstampImage()
                            }
                        }
                    }
                }
            }
        }
        return
    }
}

//MARK: Show common alert and image picker view
extension ZorroStampView: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    fileprivate func uploadStamp() {
        
        setcommonAlert(title: "Upload Stamp", message: "You don't have any stamp, Please upload", actiontitleOne: "Cancel", actiontitleTwo: "Upload", addText: false) { (cancel, upload, text)  in
            
            if cancel {
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.stampimagePicker = UIImagePickerController()
                self.stampimagePicker.sourceType = .photoLibrary
                self.stampimagePicker.allowsEditing = true
                self.stampimagePicker.delegate = self
                self.window?.rootViewController?.present(self.stampimagePicker, animated: true, completion: nil)
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selecteimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
      
        stampimagePicker.dismiss(animated: true) {
            print("dismissed")
            self.uploadStampImage(selectedImage: selecteimage, completion: { (uploaded) in
                self.stampIndicator.stopAnimating()
                if uploaded {
                    self.getstampImage()
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.setcommonAlert(title: "Upload Failed !", message: "Something wrong with the upload process, please try again in few minutes", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                        return
                    })
                })
            })
        }
    }
}

//MARK: Upload the image to server
extension ZorroStampView {
    fileprivate func uploadStampImage(selectedImage: UIImage, completion: @escaping(Bool) ->()) {
        
        let imagedata1 = selectedImage.pngData()
        let imagedatakb1 = Double(imagedata1!.count)/1000.0
        print("\(imagedatakb1) KB")
        
        
        resizeImage(image: selectedImage, taragetSize: CGSize(width: 156, height: 156)) { (newimage) in
            if let newimage = newimage {
                
                let imagedata = newimage.pngData()
                let imagedatakb = Double(imagedata!.count)/1000
                print("IMAGE SIZE : \(imagedatakb) KB")
                
                if imagedatakb <= 2000 {
                    guard let imagestring = imagedata?.base64EncodedString() else { return }
                    let imagebase64 = "data:image/png;base64,\(imagestring)"
                    let uploadorganizationstamp = OrganizationstampUpload(StampImage: imagebase64, Id: 0)
                    uploadorganizationstamp.uploadorgStamp(orgstampupload: uploadorganizationstamp) { (success, err) in
                        if success {
                            completion(true)
                            return
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            self.setcommonAlert(title: "Failed to upload !", message: "Something wrong with the selected image", actiontitleOne: "Cancel", actiontitleTwo: "Try Again", addText: false, completion: { (cancel, upload, text) in
                                if cancel {
                                    return
                                } else {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                                        self.uploadStamp()
                                    })
                                    return
                                }
                            })
                        })
                        completion(false)
                    }
                    return
                }
                print("unable to upload, image size is bigger")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.setcommonAlert(title: "Unabel to upload", message: "Image size should be 2MB or less, selected image size \(imagedatakb/1000.0) MB", actiontitleOne: "Cancel", actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                        return
                    })
                }
                completion(false)
                return
            }
            completion(false)
            return
        }
    }
}

//MARK: resizing the image -> 156 * 156
extension ZorroStampView {
    fileprivate func resizeImage(image: UIImage, taragetSize: CGSize, completion: @escaping(UIImage?) -> ()) {
        let size = image.size
        let widthratio = taragetSize.width / size.width
        let heightratio = taragetSize.height / size.height
        
        var newsize: CGSize
        
        if widthratio > heightratio {
            newsize = CGSize(width: size.width * heightratio, height: size.height * heightratio)
        } else {
            newsize = CGSize(width: size.width * widthratio, height: size.height * widthratio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newsize.width, height: newsize.height)
        UIGraphicsBeginImageContextWithOptions(newsize, false, 1.0)
        image.draw(in: rect)
        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(newimage)
    }
}
