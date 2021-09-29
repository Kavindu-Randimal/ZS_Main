//
//  VcardqrgeneratorController.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 2/19/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class VcardqrgeneratorController: BaseVC {
    
    var isFromLogin: Bool!
    private var backdropIndicator: UIActivityIndicatorView!
    private var backdropView: UIView!
    private var qrimageView: UIImageView!
    private var qrimage: UIImage!
    private var alertController: UIAlertController!
    
    private var firstName: String!
    private var lastName: String!
    private var landLine: String!
    private var phone: String!
    private var officePhone: String!
    private var email: String!
    private var companyName: String!
    private var jobtitle: String!
    private var addressLine1: String!
    private var addressLine2: String!
    private var city: String!
    private var state: String!
    private var zipcode: String!
    private var country: String!
    private var website: String!
    private var dialcodelabel: String!
    
    private let deviceName = UIDevice.current.userInterfaceIdiom
    private let deviceWidth: CGFloat = UIScreen.main.bounds.width
    private let deviceHeight: CGFloat = UIScreen.main.bounds.height
    private let greencolor: UIColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLoading()
        setnavbar()
        setqrcodeView()
        setbottomView()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        getprofileDetails()
    }
    
}

//MARK: - Add Activity Indicator constarints
extension VcardqrgeneratorController {
    fileprivate func setupLoading() {
        
        backdropView = UIView()
        backdropView.translatesAutoresizingMaskIntoConstraints = false
        backdropView.backgroundColor = .white
        view.addSubview(backdropView)
        
        let backdropviewConstraints = [backdropView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       backdropView.topAnchor.constraint(equalTo: view.topAnchor),
                                       backdropView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                       backdropView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(backdropviewConstraints)
        
        backdropIndicator = UIActivityIndicatorView(style: .whiteLarge)
        backdropIndicator.color = ColorTheme.activityindicator
        backdropIndicator.translatesAutoresizingMaskIntoConstraints = false
        backdropView.addSubview(backdropIndicator)
        
        let backdropindicatorConstraints = [backdropIndicator.centerXAnchor.constraint(equalTo: backdropView.centerXAnchor),
                                            backdropIndicator.centerYAnchor.constraint(equalTo: backdropView.centerYAnchor),
                                            backdropIndicator.widthAnchor.constraint(equalToConstant: 50),
                                            backdropIndicator.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(backdropindicatorConstraints)
    }
}

//MARK: - Add navbar
extension VcardqrgeneratorController {
    private func setnavbar() {
        
        let safearea = view.safeAreaLayoutGuide
        
        let navbar = UINavigationBar()
        navbar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(navbar)
        
        let navbarConstraints = [
            navbar.topAnchor.constraint(equalTo: safearea.topAnchor),
            navbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navbar.heightAnchor.constraint(equalToConstant: 44)]
        NSLayoutConstraint.activate(navbarConstraints)
        
        let navItem = UINavigationItem(title: "Business Card QR Code")
        let textColor = [NSAttributedString.Key.foregroundColor: ColorTheme.navTitleDefault]
        navbar.titleTextAttributes = textColor
        
        let backimg = UIImage(named: "back_arrow")
        
        let button = UIButton()
        button.setImage(backimg, for: .normal)
        button.addTarget(self, action: #selector(gobackAgain), for: .touchUpInside)
        
        let backItem = UIBarButtonItem(customView: button)
        
        navItem.leftBarButtonItem = backItem
        navbar.setItems([navItem], animated: false)
        
    }
}

//MARK: - Set Qr image view
extension VcardqrgeneratorController {
    private func setqrcodeView(){
        qrimageView = UIImageView()
        qrimageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(qrimageView)
        
        var qrimagewidth: CGFloat = 0.65
        let qrheightconst: CGFloat = deviceHeight * 0.05
        if deviceName == .pad {
            qrimagewidth = 0.4
        }
        
        let qrimageviewConstraints = [
            qrimageView.centerYAnchor.constraint(equalTo: view.centerYAnchor,constant: -1 * qrheightconst),
            qrimageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            qrimageView.widthAnchor.constraint(equalToConstant: deviceWidth * qrimagewidth),
            qrimageView.heightAnchor.constraint(equalToConstant: deviceWidth * qrimagewidth)
        ]
        NSLayoutConstraint.activate(qrimageviewConstraints)
    }
}

//MARK: - Set footer view
extension VcardqrgeneratorController {
    private func setbottomView(){
        
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = ColorTheme.imgTint
        view.addSubview(bottomView)
        
        let bottomviewConstraints = [
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 120)]
        NSLayoutConstraint.activate(bottomviewConstraints)
        
        let bottomimgView = UIImageView()
        bottomimgView.translatesAutoresizingMaskIntoConstraints = false
        bottomimgView.contentMode = .scaleAspectFit
        bottomimgView.image = UIImage(named: "treesqrhighres")
        view.addSubview(bottomimgView)
        
        var imageviewHeight: CGFloat = 100
        var imageviewConstant: CGFloat = 8
        var labelfontSize: CGFloat = 16
        
        if deviceName == .pad {
            imageviewHeight = 150
            imageviewConstant = 14
            labelfontSize = 18
        }
        
        let bottomimgviewConstraints = [
            bottomimgView.leftAnchor.constraint(equalTo: view!.leftAnchor),
            bottomimgView.rightAnchor.constraint(equalTo: view!.rightAnchor),
            bottomimgView.bottomAnchor.constraint(equalTo: bottomView.topAnchor,constant: imageviewConstant),
            bottomimgView.heightAnchor.constraint(equalToConstant: imageviewHeight)]
        NSLayoutConstraint.activate(bottomimgviewConstraints)
        
        let bottomtextLabel = UILabel()
        bottomtextLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomtextLabel.font = UIFont(name: "Helvetica", size: labelfontSize)
        bottomtextLabel.adjustsFontSizeToFitWidth = true
        bottomtextLabel.minimumScaleFactor = 0.2
        bottomtextLabel.text = "Saving the planet is a core focus for ZorroSign. Keeping business cards digital and not printing helps us maintain our commitment to save trees, water and decrease our carbon footprint."
        bottomtextLabel.textAlignment = .center
        bottomtextLabel.textColor = ColorTheme.lblBodySpecial
        bottomtextLabel.numberOfLines = 4
        bottomView.addSubview(bottomtextLabel)
        
        let bottomtextLabelConstraints = [bottomtextLabel.leftAnchor.constraint(equalTo: bottomView.leftAnchor, constant: 10),
                                          bottomtextLabel.rightAnchor.constraint(equalTo: bottomView.rightAnchor, constant: -10),
                                          bottomtextLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor)]
        NSLayoutConstraint.activate(bottomtextLabelConstraints)
        
    }
}

//MARK: Show Alert message
extension VcardqrgeneratorController {
    private func showalertMessage(title: String, message: String, canecl: Bool) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.view.tintColor = greencolor
        
        let okaction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            self.onclickOkay()
        }
        alertController.addAction(okaction)
        
        if canecl {
            let cancelaction = UIAlertAction(title: "cancel", style: .cancel){
                (alert) in
                self.onclickCancel()
            }
            alertController.addAction(cancelaction)
        }
        
        DispatchQueue.main.async {
            self.present(self.alertController, animated: true, completion: nil)
        }
    }
}

//MARK: Alert Actions
extension VcardqrgeneratorController {
    @objc func onclickOkay(){
        if isFromLogin {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let appdelegate = UIApplication.shared.delegate
            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
            DispatchQueue.main.async {
                appdelegate?.window!?.rootViewController = viewcontroller
            }
        }
    }
    
    @objc func onclickCancel(){}
}

//MARK: Show Backdrop
extension VcardqrgeneratorController {
    private func showbackdrop(){
        backdropIndicator.startAnimating()
        backdropView.isHidden = false
        view.bringSubviewToFront(backdropView)
    }
}

//MARK: - Hide Backdrop
extension VcardqrgeneratorController {
    private func hidebackdop(){
        backdropIndicator.stopAnimating()
        backdropView.isHidden = true
        view.sendSubviewToBack(backdropView)
    }
}

//MARK: - Generate Qr image
extension VcardqrgeneratorController {
    private func generateQR(){
        // Get define string to encode
        var vcardqrString: String = ""
        var address: String = ""
        
        if let fname = firstName, let lname = lastName, let job = jobtitle, let weblink = website, let phone = phone, let officePhone = officePhone, let email = email, let addressLine1 = addressLine1, let addressLine2 = addressLine2, let state = state, let city = city, let zipcode = zipcode, let country = country, let companyName = companyName {
            
            if addressLine1 != "" && addressLine2 != "" {
                address = addressLine1 + "," + addressLine2
            }
            if addressLine1 != "" && addressLine2 == "" {
                address = addressLine1
            }
            if addressLine1 == "" && addressLine2 != "" {
                address = addressLine2
            }
            
            vcardqrString = "BEGIN:VCARD \n" +
                "VERSION:3.0 \n" +
                "FN:\(fname) \(lname) \n" +
                "N:\(lname);\(fname) \n" +
                "TITLE:\(job) \n" +
                "ORG:\(companyName) \n" +
                "ADR;WORK:;;\(address);\(city);\(state);\(zipcode);\(country) \n" +
                "TEL;TYPE=WORK:\(officePhone) \n" +
                "TEL;TYPE=CELL,VOICE:\(phone) \n" +
                "EMAIL;WORK;INTERNET:\(email) \n" +
                "URL:\(weblink) \n" +
            "END:VCARD"
        }
        
        // Get data from the string
        let data = vcardqrString.data(using: String.Encoding.ascii)
        // Get a QR CIFilter
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
        // Input the data
        qrFilter.setValue(data, forKey: "inputMessage")
        // Get the output image
        guard let qrImage = qrFilter.outputImage else { return }
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledQrImage = qrImage.transformed(by: transform)
        // Do some processing to get the UIImage
        let context = CIContext()
        guard let cgImage = context.createCGImage(scaledQrImage, from: scaledQrImage.extent) else { return }
        let processedImage = UIImage(cgImage: cgImage)
        qrimageView.image = processedImage
    }
}

//MARK: - Get data from app to generate qr
extension VcardqrgeneratorController {
    private func fetchfromApp() {
        let userprofile = ZorroTempData.sharedInstance.getUserprofile()
        
        if userprofile != nil {
            
            if let userdata = userprofile?.Data {
                
                guard let fname = userdata.FirstName, let lname = userdata.LastName, let phone = userdata.PhoneNumber, let offphone = userdata.OfficePhoneNumber else {
                    showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                    
                    return
                }
                
                if fname != "" && lname != "" && phone != "" && offphone != "" {
                    self.firstName = fname
                    self.lastName = lname
                    self.phone = phone
                    self.officePhone = offphone
                    self.email = userprofile?.Data?.Email
                    self.jobtitle = userprofile?.Data?.JobTitle
                    self.addressLine1 = userprofile?.Data?.AddressLine1
                    self.addressLine2 = userprofile?.Data?.AddressLine2
                    self.city = userprofile?.Data?.City
                    self.state = userprofile?.Data?.StateCode
                    self.zipcode = userprofile?.Data?.ZipCode
                    self.country = userprofile?.Data?.Country
                    self.website = userprofile?.Data?.WebSite
                    
                    if userprofile?.Data?.UserType == 1 {
                        self.companyName = ZorroTempData.sharedInstance.getOrganizationLegalName()
                    }
                    
                    if userprofile?.Data?.UserType == 2 {
                        self.companyName = userprofile?.Data?.BusinessName
                    }
                    
                    self.generateQR()
                }
                else {
                    showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                }
                
            }
            else {
                showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
            }
        }
        else {
            showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
        }
    }
}

//MARK: - Api call to get profile details
extension VcardqrgeneratorController {
    private func getprofileDetails(){
        
        if !isFromLogin {
            let isconnected = Connectivity.isConnectedToInternet()
            if(!isconnected){
                fetchfromApp()
                
                return
            }
            
            showbackdrop()
            
            let userProfile = UserProfile()
            userProfile.getuserprofileData { (userprofile, err) in
                if(!err){
                    self.hidebackdop()
                    
                    guard let userprofile = userprofile else {
                        self.showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                        return
                    }
                    
                    if let userdata = userprofile.Data {
                        guard let fname = userdata.FirstName, let lname = userdata.LastName, let phone = userdata.PhoneNumber, let offphone = userdata.OfficePhoneNumber else {
                            self.showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                            
                            return
                        }
                        
                        if fname != "" && lname != "" && phone != "" && offphone != "" {
                            self.firstName = userprofile.Data?.FirstName
                            self.lastName = userprofile.Data?.LastName
                            self.phone = userprofile.Data?.PhoneNumber
                            self.officePhone = userprofile.Data?.OfficePhoneNumber
                            self.email = userprofile.Data?.Email
                            self.jobtitle = userprofile.Data?.JobTitle
                            self.addressLine1 = userprofile.Data?.AddressLine1
                            self.addressLine2 = userprofile.Data?.AddressLine2
                            self.city = userprofile.Data?.City
                            self.state = userprofile.Data?.StateCode
                            self.zipcode = userprofile.Data?.ZipCode
                            self.country = userprofile.Data?.Country
                            self.website = userprofile.Data?.WebSite
                            
                            if userprofile.Data?.UserType == 2 {
                                self.companyName = userprofile.Data?.BusinessName
                                
                                self.generateQR()
                            }
                            
                            if userprofile.Data?.UserType == 1 {
                                let organizationdetails = OrganizationDetails()
                                organizationdetails.geturerorganizationDetails { (orgdetails) in
                                    
                                    if let orglegalname = orgdetails?.Data?.Organization?.LegalName {
                                        ZorroTempData.sharedInstance.setOrganizationLegalname(legalname: orglegalname)
                                        self.companyName = orglegalname
                                        
                                        self.generateQR()
                                    }
                                    return
                                }
                            }
                            
                            ZorroTempData.sharedInstance.setUserprofile(userprofile: userprofile)
                        }
                        else {
                            self.showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                        }
                    }
                    else {
                        self.showalertMessage(title: "Error !", message: "Mandatory fields must be complete to generate digital business card. Please update this information via My Account / Manage Business Card.", canecl: false)
                    }
                }
                else {
                    self.fetchfromApp()
                }
                return
            }
        }
        else {
            fetchfromApp()
        }
    }
}

//MARK: - Navbar go back action
extension VcardqrgeneratorController {
    @objc fileprivate func gobackAgain(){
        
        if isFromLogin {
            self.dismiss(animated: true, completion: nil)
        }
        else {
            let appdelegate = UIApplication.shared.delegate
            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
            DispatchQueue.main.async {
                appdelegate?.window!?.rootViewController = viewcontroller
            }
        }
    }
}
