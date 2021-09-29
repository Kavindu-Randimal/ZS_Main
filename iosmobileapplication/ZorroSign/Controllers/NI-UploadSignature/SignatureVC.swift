//
//  SignatureVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CropViewController

class SignatureVC: BaseVC, UINavigationControllerDelegate, LoadingIndicatorDelegate {
    
    // MARK: - Variables
    
    let vm = SignatureVM()
    private let bag = DisposeBag()
    
    var cellType: CellType = .HandWritten
    
    var currentImageSelection: SignaturePart?
    private var imagePicker = UIImagePickerController()
    
    // MARK: - Outlets
    
    @IBOutlet weak var stackUserDetails: UIStackView!
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var txtMobileNo: UITextField!
    
    /// Tag Number: 0
    @IBOutlet weak var btnHandWritten: UIButton!
    @IBOutlet weak var viewBtmHandWritten: UIView!
    
    /// Tag Number: 1
    @IBOutlet weak var btnComputerGenerated: UIButton!
    @IBOutlet weak var viewBtmComputerGenerated: UIView!
    
    /// Tag Number: 2
    @IBOutlet weak var btnUploadSignature: UIButton!
    @IBOutlet weak var viewBtmUploadSignature: UIView!
    
    @IBOutlet weak var tableViewSignature: UITableView! {
        didSet {
            tableViewSignature.delegate = self
            tableViewSignature.dataSource = self
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        configUI()
        addObservers()
        configSignatureSettings()
        
        imagePicker.delegate = self
    }
    
    // MARK: - Config Signatures
    
    func configSignatureSettings() {
        if vm.isEditingOldSignature {
            removeSelectedSignature()
        }
    }
    
    func removeSelectedSignature() {
        if vm.selectedSignatureToEdit == .One {
            vm.defaultSignature = nil
        } else {
            if let selectedSignature = vm.selectedSignatureToEdit {
                vm.arrOptionalSignatures?.remove(at: selectedSignature.rawValue - 2)
            }
        }
    }
    
    // MARK: - ConfigUI
    
    private func configUI() {
        
        /// It's hidden all the time for Normal User, only available for UPPR user
        stackUserDetails.isHidden = true
        
        /// Set this as default
        setSelectedForButton(for: cellType.rawValue, in: [btnHandWritten, btnComputerGenerated, btnUploadSignature], and: [viewBtmHandWritten, viewBtmComputerGenerated, viewBtmUploadSignature])
        
        btnCancel.layer.borderWidth = 2
        btnCancel.layer.borderColor = ColorTheme.btnBorder.cgColor
        
        btnCancel.layer.cornerRadius = 8
        btnSave.layer.cornerRadius = 8
    }
    
    private func setSelectedForButton(for selectedBtnTag: Int, in arrBtn: [UIButton], and arrView: [UIView]) {
        arrBtn.forEach { (btn) in
            if btn.tag == selectedBtnTag {
                btn.tintColor = ColorTheme.BtnTintEnabled
                arrView[btn.tag].backgroundColor = ColorTheme.BtnTintEnabled
            } else {
                btn.tintColor = ColorTheme.BtnTintDisabled
                arrView[btn.tag].backgroundColor = ColorTheme.BtnTintDisabled
            }
        }
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        btnCountry.rx.tap
            .subscribe() { [unowned self] event in
                self.didTapOnBtnCountry()
        }.disposed(by: bag)
        
        btnCancel.rx.tap
            .subscribe() { [unowned self] event in
                self.navigationController?.popViewController(animated: true)
        }.disposed(by: bag)
        
        btnSave.rx.tap
            .subscribe() { [unowned self] event in
                self.didtapOnBtnSave()
        }.disposed(by: bag)
        
        // Menu Button Actions
        
        btnHandWritten.rx.tap
            .subscribe() { [unowned self] event in
                self.didTapOnMenu(celltype: .HandWritten)
        }.disposed(by: bag)
        
        btnComputerGenerated.rx.tap
            .subscribe() { [unowned self] event in
                self.didTapOnMenu(celltype: .ComputerGenerated)
        }.disposed(by: bag)
        
        btnUploadSignature.rx.tap
            .subscribe() { [unowned self] event in
                self.didTapOnMenu(celltype: .UploadSignature)
        }.disposed(by: bag)
    }
    
    // MARK: - OutletActions
    
    func didTapOnBtnCountry() {
        
    }
    
    func didtapOnBtnSave() {
        sentSignatures()
    }
    
    func didTapOnMenu(celltype: CellType) {
        view.endEditing(true)
        
        switch celltype {
        case .HandWritten:
            cellType = .HandWritten 
            break
        case .ComputerGenerated:
            cellType = .ComputerGenerated
            break
        case .UploadSignature:
            cellType = .UploadSignature
            break
        }
        
        // Clean the data
        vm.currentSignature = nil
        vm.localUploadSignatureImages.imgInitial = nil
        vm.localUploadSignatureImages.imgSignature = nil
        
        // Set the UI
        setSelectedForButton(
            for: celltype.rawValue,
            in: [btnHandWritten, btnComputerGenerated, btnUploadSignature],
            and: [viewBtmHandWritten, viewBtmComputerGenerated, viewBtmUploadSignature]
        )
        
        tableViewSignature.reloadData()
    }
    
    // MARK: - Send Signatures
    
    func sentSignatures() {
        view.endEditing(true)
        
        vm.validateAndUpdateSignature { (success, message) in
            if success {
                self.startLoading()
                vm.netReqUpdateSignature { (success, statusCode, message) in
                    self.stopLoading()
                    if success {
                        AlertProvider.init(vc: self).showAlertWithAction(title: "Signature updated", message: message, action: AlertAction(title: "Dismiss")) { (action) in
                            UserDefaults.standard.setValue(0, forKey: "ProfileStatus")
                            let isNewUser = UserDefaults.standard.bool(forKey: "isNewUser")
                            if isNewUser {
                                UserDefaults.standard.setValue(false, forKey: "isNewUser")
                                self.biometricsOnboarding()
                            } else {
                            self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        AlertProvider.init(vc: self).showAlert(title: "Unable to Update Signature", message: message, action: AlertAction(title: "Dismiss"))
                    }
                }
            } else {
                AlertProvider.init(vc: self).showAlert(title: "Alert", message: message, action: AlertAction(title: "Dismiss"))
            }
        }
    }
}

// MARK: - Tableview Delegate

extension SignatureVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellType {
        case .HandWritten:
            print("handwritten calling")
            if let handWrittenTVCell = tableView.dequeueReusableCell(withIdentifier: "HandWrittenTVCell", for: indexPath) as? HandWrittenTVCell {
                
                handWrittenTVCell.delegate = self
                handWrittenTVCell.configUI()
                handWrittenTVCell.initializeUI()
                handWrittenTVCell.addObservers()
                
                return handWrittenTVCell
            }
        case .ComputerGenerated:
            if let computerGeneratedTVCell = tableView.dequeueReusableCell(withIdentifier: "ComputerGeneratedTVCell", for: indexPath) as? ComputerGeneratedTVCell {
                
                computerGeneratedTVCell.delegate = self
                computerGeneratedTVCell.configUI()
                computerGeneratedTVCell.setUpPicker()

                computerGeneratedTVCell.initializeUI(
                    initial: vm.currentSignature?.Settings?.initialtext ?? "",
                    signature: vm.currentSignature?.Settings?.signaturetext ?? "",
                    strokeColor: vm.currentSignature?.Settings?.penColor?.rgbToColor() ?? UIColor.black
                )
                computerGeneratedTVCell.addObservers()
                
                return computerGeneratedTVCell
            }
        case .UploadSignature:
            if let uploadSignatureTVCell = tableView.dequeueReusableCell(withIdentifier: "UploadSignatureTVCell", for: indexPath) as? UploadSignatureTVCell {
                
                uploadSignatureTVCell.delegate = self
                uploadSignatureTVCell.addObservers()
                uploadSignatureTVCell.configCell(with: vm.localUploadSignatureImages)
                
                return uploadSignatureTVCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellType {
        case .HandWritten:
            return 500
        case .ComputerGenerated:
            return 500
        case .UploadSignature:
            return 500
        }
    }
}

// MARK: - HandWritten Delegate

extension SignatureVC: HandWrittenCellDelegate {
    
    func setTableScroll(enable value: Bool) {
        tableViewSignature.isScrollEnabled = value
    }
    
    func getSignatureImage(signatureImg: UIImage) {
        let convertedImage = resizeImagex(image: signatureImg, taragetSize: CGSize(width: 500, height: 100))
        let _signatureimgbase64 = "data:image/png;base64,\(convertedImage.base64(format: .PNG))"
        
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        vm.currentSignature?.Signature = _signatureimgbase64
        vm.currentSignature?.Settings?.signatureImage = _signatureimgbase64
        vm.currentSignature?.Settings?.signatureType = SignatureType.HandWritten.rawValue
    }
    
    func getInitialImage(initialImg: UIImage) {
        let convertedImage = resizeImagex(image: initialImg, taragetSize: CGSize(width: 100, height: 100))
        let _initialimgbase64 = "data:image/png;base64,\(convertedImage.base64(format: .PNG))"
        
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        vm.currentSignature?.Initials = _initialimgbase64
        vm.currentSignature?.Settings?.initialImage = _initialimgbase64
        vm.currentSignature?.Settings?.initialType = SignatureType.HandWritten.rawValue
    }
    
    func getStrokeColorAndWidth(color: UIColor, width: CGFloat) {
        let _penWidth = width
        let _penColor = color.toRGB()
       
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        vm.currentSignature?.Settings?.penColor = _penColor
        vm.currentSignature?.Settings?.penWidth = Double(_penWidth)
    }
    
    func clearHandwritten(_ signaturePart: SignaturePart) {
        if signaturePart == SignaturePart.Signature {
            vm.currentSignature?.Signature = nil
            vm.currentSignature?.Settings?.signatureImage = nil
        } else {
            vm.currentSignature?.Initials = nil
            vm.currentSignature?.Settings?.initialImage = nil
        }
    }
}

// MARK: - ComputerGenerated Delegate

extension SignatureVC: ComputerGeneratedCellDelegate {
    
    func getFontStyle(font: String) {
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        vm.currentSignature?.Settings?.editProfilesignFont = font
        vm.currentSignature?.Settings?.editProfileinitFont = font
    }
    
    func getStrokeColor(color: UIColor) {
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        vm.currentSignature?.Settings?.penColor = color.toRGB()
    }
    
    func getInitial(initial value: String, image: UIImage) {
        let convertedImage = resizeImagex(image: image, taragetSize: CGSize(width: 100, height: 100))
        let _initialimgbase64 = "data:image/png;base64,\(convertedImage.base64(format: .PNG))"
        
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        if value != "" {
            vm.currentSignature?.Initials = _initialimgbase64
            vm.currentSignature?.Settings?.initialtext = value
            vm.currentSignature?.Settings?.initialImage = _initialimgbase64
            vm.currentSignature?.Settings?.initialType = SignatureType.ComputerGenerated.rawValue
        } else {
            vm.currentSignature?.Initials = nil
            vm.currentSignature?.Settings?.initialtext = nil
            vm.currentSignature?.Settings?.initialImage = nil
            vm.currentSignature?.Settings?.initialType = nil
        }
    }
    
    func getSignature(signature value: String, image: UIImage) {
        let convertedImage = resizeImagex(image: image, taragetSize: CGSize(width: 500, height: 100))
        let _signatureimgbase64 = "data:image/png;base64,\(convertedImage.base64(format: .PNG))"
        
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        if value != "" {
            vm.currentSignature?.Signature = _signatureimgbase64
            vm.currentSignature?.Settings?.signaturetext = value
            vm.currentSignature?.Settings?.signatureImage = _signatureimgbase64
            vm.currentSignature?.Settings?.signatureType = SignatureType.ComputerGenerated.rawValue
        } else {
            vm.currentSignature?.Signature = nil
            vm.currentSignature?.Settings?.signaturetext = nil
            vm.currentSignature?.Settings?.signatureImage = nil
            vm.currentSignature?.Settings?.signatureType = nil
        }
    }
    
    func clearComputerGenerated(_ signaturePart: SignaturePart) {
        if signaturePart == SignaturePart.Signature {
            vm.currentSignature?.Signature = nil
            vm.currentSignature?.Settings?.signatureImage = nil
        } else {
            vm.currentSignature?.Initials = nil
            vm.currentSignature?.Settings?.initialImage = nil
        }
    }
}

// MARK: - UploadSignature Delegate

extension SignatureVC: UploadSignatureCellDelegate {
    
    func showImagePickerAlert(for signaturePart: SignaturePart) {
        currentImageSelection = signaturePart
        
        AlertProvider.init(vc: self).showActionSheetWithActions(title: nil, message: nil, actions: [AlertAction(title: TakePhoto), AlertAction(title: ChooseFromLibrary)], sourceView: view) { (action) in
            
            if action.title == TakePhoto {
                self.provideCameraForImagePicking(editting: true)
            } else {
                self.provideGalleryForImagePicking(editting: true)
            }
        }
    }
    
    func clearImage(_ signaturePart: SignaturePart) {
        if signaturePart == SignaturePart.Signature {
            vm.localUploadSignatureImages.imgSignature = nil
            vm.currentSignature?.Signature = nil
            vm.currentSignature?.Settings?.signatureImage = nil
        } else {
            vm.localUploadSignatureImages.imgInitial = nil
            vm.currentSignature?.Initials = nil
            vm.currentSignature?.Settings?.initialImage = nil
        }
    }
}

// MARK: - CropViewController Delegate

extension SignatureVC: CropViewControllerDelegate, UIImagePickerControllerDelegate {
    
    // Provide Camera
    func provideCameraForImagePicking(editting: Bool) {
        self.imagePicker.allowsEditing = editting
        self.imagePicker.sourceType = .camera
        self.imagePicker.cameraCaptureMode = .photo
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Provide Image Library
    func provideGalleryForImagePicking(editting: Bool) {
        self.imagePicker.allowsEditing = editting
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Proceed with image picker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.imagePicker.dismiss(animated: true, completion: nil)
                
//                print(pickedImage.jpegData(compressionQuality: 1)?.count)
                self.presentCropViewController(image: pickedImage)
            }
        }
    }
    
    //crop view controller function
    func presentCropViewController(image: UIImage) {
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        
        if currentImageSelection == SignaturePart.Signature {
            cropViewController.customAspectRatio = CGSize(width: 500, height: 100)
        } else {
            cropViewController.customAspectRatio = CGSize(width: 100, height: 100)
        }
        cropViewController.aspectRatioLockEnabled = true
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
//        print(image.jpegData(compressionQuality: 1)?.count)
        
//        guard image.jpegData(compressionQuality: 1)?.count ?? 0 < 1000000 else {
//            cropViewController.dismiss(animated: true, completion: nil)
//            AlertProvider.init(vc: self).showAlert(title: "Warning", message: "Maximum image size is 1MB, Please select a image under 1MB.", action: AlertAction(title: "Dismiss"))
//            return
//        }
        
        if vm.currentSignature == nil {
            vm.currentSignature = UserSignature()
        }
        if vm.currentSignature?.Settings == nil {
            vm.currentSignature?.Settings = UserSettings()
        }
        
        if currentImageSelection == SignaturePart.Initial {
            let _resizedinitial = resizeImagex(image: image, taragetSize: CGSize(width: 100, height: 100))
            vm.localUploadSignatureImages.imgInitial = image
            vm.currentSignature?.Initials = "data:image/png;base64,\(_resizedinitial.base64(format: .PNG))"
            vm.currentSignature?.Settings?.initialImage = "data:image/png;base64,\(_resizedinitial.base64(format: .PNG))"
            vm.currentSignature?.Settings?.initialType = SignatureType.UploadSignature.rawValue
        } else {
            let _resizedsignature = resizeImagex(image: image, taragetSize: CGSize(width: 500, height: 100))
            vm.localUploadSignatureImages.imgSignature = image
            vm.currentSignature?.Signature = "data:image/png;base64,\(_resizedsignature.base64(format: .PNG))"
            vm.currentSignature?.Settings?.signatureImage = "data:image/png;base64,\(_resizedsignature.base64(format: .PNG))"
            vm.currentSignature?.Settings?.signatureType = SignatureType.UploadSignature.rawValue
        }
        
        tableViewSignature.reloadData()
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension SignatureVC {
    
    fileprivate func resizeImagex(image: UIImage, taragetSize: CGSize) -> UIImage {
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
        return newimage!
    }
}


extension SignatureVC {
    private func biometricsOnboarding() {
        
        
        let username: String = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid: String = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: username.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (onboarded, keyid) in
            
            if !onboarded {
                let passwordlessIntroController = PasswordlessIntroController()
                passwordlessIntroController.providesPresentationContextTransitionStyle = true
                passwordlessIntroController.definesPresentationContext = true
                passwordlessIntroController.modalPresentationStyle = .overCurrentContext
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                self.view.window?.layer.add(transition, forKey: kCATransition)
                
                DispatchQueue.main.async {
                    self.present(passwordlessIntroController, animated: false, completion: nil)
                }
                
                passwordlessIntroController.skipCallBack = { skip in
                    if skip {
                        
                        let appdelegate = UIApplication.shared.delegate
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                        DispatchQueue.main.async {
                            appdelegate?.window!?.rootViewController = viewcontroller
                        }
                    }
                    return
                }
                
                passwordlessIntroController.onBoardStatus = {
                    let appdelegate = UIApplication.shared.delegate
                    let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                    DispatchQueue.main.async {
                        appdelegate?.window!?.rootViewController = viewcontroller
                    }
                    return
                }
                return
            }
            
            let appdelegate = UIApplication.shared.delegate
            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
            DispatchQueue.main.async {
                appdelegate?.window!?.rootViewController = viewcontroller
            }
            return
        }
        return
    }
}
