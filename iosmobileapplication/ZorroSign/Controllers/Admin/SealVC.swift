//
//  SealVC.swift
//  ZorroSign
//
//  Created by Apple on 30/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CropViewController

class SealVC: BaseVC, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SealTransProtocol, CropViewControllerDelegate {

    @IBOutlet weak var imgSeal: UIImageView!
    @IBOutlet weak var lblSeal: UILabel!
    var strStampImage: String = ""
    let picker = UIImagePickerController()
    var strImage = String()
    var Id: Int = 0
    var docSignFlag: Bool = false
    var fromStamp: Bool = false
    
    private var croppingStyle = CropViewCroppingStyle.default
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        // Do any additional setup after loading the view.
        /*
        lblSeal.layer.cornerRadius = 5
        lblSeal.layer.borderWidth = 1.0
        lblSeal.layer.borderColor = UIColor.gray.cgColor
 */
        addFooterView()
        getStamp()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getStamp() {
        
        /*
        {"StatusCode":1000,"Message":null,"Data":{"Id":303,"ProfileId":"t9ROJMvvhEvygBWRmhmz%2FQ%3D%3D","OrganizationId":"4hjWMmUuAA16gzlFnKnLgQ%3D%3D","StampImage":"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAJwAAACcCAYAAACKuMJNAAAgAElEQVR4Xuy9aZQl51Ulur+YI+6YNzMrs"}}
         */
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "Organization/GetStamp"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                   
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    //print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        DispatchQueue.main.async {
                            //for demo env
                            //let StampImage = jsonObj["Data"]
                            
                            // for demo v2 env
                            let StampImage = jsonObj["Data"]["StampImage"]
                            self.Id = jsonObj["Data"]["Id"].intValue
                            let strImg: String = StampImage.stringValue
                            
                            if !strImg.isEmpty {
                                let strImgArr = strImg.split(separator: ",")
                                if strImgArr.count > 1 {
                                    self.strStampImage = String(strImgArr[1])
                                    
                                    let decodedimage = self.strStampImage.base64ToImage()
                                    self.imgSeal.image = decodedimage
                                    
                                } else {
                                    
                                }
                            }
                            self.stopActivityIndicator()
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                        }
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func uploadStamp() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "Organization/UploadStamp"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        let stamp: String = "data:image/png;base64,\(strStampImage)"
        //let parameter = ["Stamp" : stamp] as [String:Any] for demo env
        
        let parameter = ["StampImage" : stamp, "Id": Id, "IsDefaultStamp": true] as [String:Any]  // for demo v2 env
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if let statusCode = response.response?.statusCode {
                        switch(statusCode) {
                        case 200:
                            self.showActivityIndicatory(uiView: self.view)
                            
                            ZorroHttpClient.sharedInstance.getOrganizationStamp(completion: { (orgstamp, err) in
                                
                                self.stopActivityIndicator()
                                
                                if err {
                                    self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                                    return
                                }
                                
                                guard let orgstamp = orgstamp else{
                                    self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                                    return
                                }
                                
                                if let orgdata = orgstamp.Data {
                                    if let stampImage = orgdata.StampImage, let stampid = orgdata.Id {
                                        self.Id = stampid
                                        ZorroTempData.sharedInstance.setStamp(stamp: stampImage)
                                        if self.fromStamp {
                                            SharingManager.sharedInstance.triggerstampSelected(image: self.imgSeal.image!)
                                        }
                                    }
                                }
                                self.alertCompletion(strTitle: "", strMsg: "Stamp uploaded successfully.", vc: self)
                                //                                self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                                return
                            })
                        default:
                            self.alertCompletion(strTitle: "", strMsg: "Stamp upload error.Try again", vc: self)
                            return
                        }
                    } else {
                        self.perform(#selector(self.goBack), with: self, afterDelay: 0.5)
                    }
                    
                }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @objc func goBack(){
        
        if docSignFlag {
            self.navigationController?.popViewController(animated: false)
        }
    }

    @IBAction func chooseFileAction() {
        picker.accessibilityHint = "10"
        picker.delegate = self
        let alert = UIAlertController(title: "Add Photo!", message: "", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .camera
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .camera)!
            self.present(self.picker, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "Choose from Gallery", style: .default, handler: {
            action in
            
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
//            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadAction() {
        if strStampImage.isEmpty {
            
            alertSample(strTitle: "", strMsg: "Please select image")
            
        } else {
            uploadStamp()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.showActivityIndicatory(uiView: view)
        if picker.accessibilityHint == "10" {
            
            let image: UIImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as! UIImage
            
            /*
            let imageData:NSData = UIImagePNGRepresentation(image)! as NSData  //  add this
            image = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
            
            let strBase64: String = image.base64(format: ImageFormat.PNG)
            //imageData.base64EncodedString(options: .endLineWithLineFeed)
            //let strBase64:String = imageData.base64EncodedString(options: .lineLength64Characters)//(options: .Encoding64CharacterLineLength)
            
            let escapedString: String = strBase64.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            //print(escapedString)
            
            strStampImage = strBase64//escapedString
            
            imgSeal.image = image
 */
            let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
            cropController.modalPresentationStyle = .fullScreen
            cropController.delegate = self
            cropController.accessibilityHint = "10"
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
                //self.navigationController!.pushViewController(cropController, animated: true)
            })
            
        }
        self.showActivityIndicatory(uiView: self.view)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        //self.croppedRect = cropRect
        //self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        //self.croppedRect = cropRect
        //self.croppedAngle = angle
//        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        
        var newimage = image.resizeImage(targetSize: CGSize(width: 500, height: 500))
        
        imgSeal.image = newimage
        
        //layoutImageView()
        
        //var strBase64: String = imageData.base64EncodedString(options: .endLineWithLineFeed)
        let strBase64: String = newimage.base64(format: ImageFormat.PNG)
        let escapedString: String = strBase64.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        strImage = strBase64//escapedString
        
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imgSeal.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: newimage,
                                                       toView: imgSeal,
                                                       toFrame: CGRect.zero,
                                                       setup: { self.layoutImageView() },
                                                       completion: {
                                                      
                                                        self.imgSeal.isHidden = false
                                                        let sealTransVC = self.getVC(sbId: "sealTransVC_ID") as! SealTransVC

                                                        sealTransVC.imgSeal = self.imgSeal.image
                                                        sealTransVC.delegateSTVC = self
                                                        self.present(sealTransVC, animated: false, completion: nil)
                                                        self.stopActivityIndicator()
            })
                
           
        }
        else {
            imgSeal.isHidden = false
            cropViewController.dismiss(animated: true, completion: {
                
                let sealTransVC = self.getVC(sbId: "sealTransVC_ID") as! SealTransVC
                
                sealTransVC.imgSeal = self.imgSeal.image
                sealTransVC.delegateSTVC = self
                self.present(sealTransVC, animated: false, completion: nil)
                self.stopActivityIndicator()
            })
        }
    }
    
    public func layoutImageView() {
    }
    
    func onSelectImg(img: UIImage) {
        
        imgSeal.image = img
        let strBase64: String = imgSeal.image!.base64(format: ImageFormat.PNG)
        strStampImage = strBase64
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
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

