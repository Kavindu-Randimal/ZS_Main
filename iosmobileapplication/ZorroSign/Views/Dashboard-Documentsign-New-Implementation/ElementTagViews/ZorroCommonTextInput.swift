//
//  ZorroCommonTextInput.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroCommonTextInput: ZorroTagBaseView {

    private var textField: UITextField!
    private var setTextButton: UIButton!
    private var commontextAlertController: UIAlertController!
    var userProfile: UserProfile!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZorroCommonTextInput {
    fileprivate func setsubView() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.minimumFontSize = 6.0
        textField.adjustsFontSizeToFitWidth = true
        textField.isUserInteractionEnabled = false
        addSubview(textField)
        
        let textfieldConstrants = [textField.leftAnchor.constraint(equalTo: leftAnchor),
                                   textField.topAnchor.constraint(equalTo: topAnchor),
                                   textField.rightAnchor.constraint(equalTo: rightAnchor),
                                   textField.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(textfieldConstrants)
        
        setTextButton = UIButton()
        setTextButton.translatesAutoresizingMaskIntoConstraints = false
        setTextButton.setTitleColor(.black, for: .normal)
        addSubview(setTextButton)
        
        let settextbuttonConstraints = [setTextButton.leftAnchor.constraint(equalTo: leftAnchor),
                                        setTextButton.topAnchor.constraint(equalTo: topAnchor),
                                        setTextButton.rightAnchor.constraint(equalTo: rightAnchor),
                                        setTextButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(settextbuttonConstraints)
        setTextButton.addTarget(self, action: #selector(setTextAction(_:)), for: .touchUpInside)
    }
}

//MARK: set properties
extension ZorroCommonTextInput {
    func setProperties(extrametadta: ExtraMetaData?, autosaved: AutoSavedData?) {
        textField.tag = tagID
        setTextButton.tag = tagID
        setTextButton.setTitle("\(tagName!)", for: .normal)
        
        guard let exdata = extrametadta else { return }
        
        guard let fontsizeString = exdata.fontSize else { return }
        guard let fontsize = NumberFormatter().number(from: fontsizeString) else { return }
        textField.font = UIFont(name: "Helvetica", size: CGFloat(truncating: fontsize))
        
        setTextButton.titleLabel?.font = UIFont(name: "Helvetica", size: CGFloat(truncating: fontsize))
        setTextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        //setup auto saved data
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if let apply = tagdetail.apply {
                        if apply {
                            if tagdetail.type == tagtype {
                                setautoSaved { (complete) in
                                    if complete {
                                        self.iscompleted = true
                                        self.setTextButton.isHidden = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return
        }
    }
}

extension ZorroCommonTextInput {
    fileprivate func setautoSaved(completion: @escaping(Bool) ->()) {
        switch tagtype {
        case 16:
            textField.text = ZorroTempData.sharedInstance.getUserName()
            tagText = "UN"
            completion(true)
        case 17:
            textField.text = ZorroTempData.sharedInstance.getUserEmail()
            tagText = "UE"
            completion(true)
        case 18:
            let usertype = ZorroTempData.sharedInstance.getUserType()
            if usertype == 1 {
                let legalname = ZorroTempData.sharedInstance.getOrganizationLegalName()
                if legalname != "" {
                    textField.text = legalname
                    completion(true)
                } else {
                    getlegalName { (complete) in
                        if !complete {
                            self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Company Name", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                                return
                            })
                            return
                        }
                        self.textField.text = ZorroTempData.sharedInstance.getOrganizationLegalName()
                        completion(true)
                    }
                }
            } else {
                print("user company")
                let companyname = ZorroTempData.sharedInstance.getCompanyName()
                if companyname != "" {
                    textField.text = companyname
                    completion(true)
                } else {
                    updateProfile { (complete) in
                        if !complete {
                            self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Company Name", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                                return
                            })
                            return
                        }
                        self.textField.text = ZorroTempData.sharedInstance.getCompanyName()
                        completion(true)
                    }
                }
            }
            tagText = "UC"
            completion(true)
        case 19:
            textField.text = ZorroTempData.sharedInstance.getJobTitle()
            tagText = "UT"
            completion(true)
        case 20:
            textField.text = ZorroTempData.sharedInstance.getPhoneNumber()
            tagText = "UP"
            completion(true)
        default:
            print("invalid")
            textField.text = "defatul manual"
            completion(true)
        }
    }
}


extension ZorroCommonTextInput {
    @objc fileprivate func setTextAction(_ sender: UIButton) {
        setfieldValues { (complete) in
            if complete {
                self.iscompleted = true
                sender.isHidden = true
            }
        }
    }
}


extension ZorroCommonTextInput {
    fileprivate func setfieldValues(completion:@escaping(Bool) -> ()) {
        switch tagtype {
        case 16:
            print("username")
            textField.text = ZorroTempData.sharedInstance.getUserName()
            tagText = "UN"
            completion(true)
        case 17:
            print("user email")
            textField.text = ZorroTempData.sharedInstance.getUserEmail()
            tagText = "UE"
            completion(true)
        case 18:
            let usertype = ZorroTempData.sharedInstance.getUserType()
            if usertype == 1 {
                let legalname = ZorroTempData.sharedInstance.getOrganizationLegalName()
                if legalname != "" {
                    textField.text = legalname
                    completion(true)
                } else {
                    getlegalName { (complete) in
                        if !complete {
                            self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Company Name", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                                return
                            })
                            return
                        }
                        self.textField.text = ZorroTempData.sharedInstance.getOrganizationLegalName()
                        completion(true)
                    }
                }
            } else {
                print("user company")
                let companyname = ZorroTempData.sharedInstance.getCompanyName()
                if companyname != "" {
                    textField.text = companyname
                    completion(true)
                } else {
                    updateProfile { (complete) in
                        if !complete {
                            self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Company Name", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                                return
                            })
                            return
                        }
                        self.textField.text = ZorroTempData.sharedInstance.getCompanyName()
                        completion(true)
                    }
                }
            }
            tagText = "UC"
        case 19:
            print("user title")
            let jobtitle = ZorroTempData.sharedInstance.getJobTitle()
            if jobtitle != "" {
                textField.text = jobtitle
                completion(true)
            } else {
                updateProfile { (complete) in
                    if !complete {
                        self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Phone Job Title", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                            return
                        })
                        return
                    }
                    self.textField.text = ZorroTempData.sharedInstance.getJobTitle()
                    completion(true)
                }
            }
            tagText = "UT"
        case 20:
            print("user phone")
            let phonenumber = ZorroTempData.sharedInstance.getPhoneNumber()
            if phonenumber != "" {
                textField.text = phonenumber
                completion(true)
            } else {
                updateProfile { (complete) in
                    if !complete {
                        self.setcommonAlert(title: "Something Went Wrong", message: "Unabele to update Phone Number", actiontitleOne: nil, actiontitleTwo: "OK", addText: false, completion: { (cancel, upload, text) in
                            return
                        })
                        return
                    }
                    
                    self.textField.text = ZorroTempData.sharedInstance.getPhoneNumber()
                    completion(true)
                }
            }
            tagText = "UP"
        default:
            print("invalid")
            textField.text = "defatul manual"
            completion(true)
        }
    }
}

//MARK: update user profile
extension ZorroCommonTextInput {
    fileprivate func updateProfile(completion: @escaping(Bool) -> ()) {
        
        if !Connectivity.isConnectedToInternet() {
            setcommonAlert(title: "Connection!", message: "No Internet connection, Please try again later", actiontitleOne: nil, actiontitleTwo: "Try Again!", addText: false) { (cancel, upload, text) in
                return
            }
            
            completion(false)
            return
        }
        
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (profiledata, err) in
            if err {
                self.setcommonAlert(title: "Something Went Wrong !", message: "Unable to get user details", actiontitleOne: nil, actiontitleTwo: "Try Again", addText: false, completion: { (cancel, upload, text) in
                    return
                })
                
                completion(false)
                return
            }
            
            // MARK: Set if data available
            switch self.tagtype {
            case 18:
                if let usercompany = profiledata?.Data?.BusinessName {
                    if usercompany != "" {
                        ZorroTempData.sharedInstance.setCompanyName(companyname: usercompany)
                        
                        completion(true)
                        return
                    }
                }
            case 19:
                if let jobtitle = profiledata?.Data?.JobTitle {
                    if jobtitle != "" {
                        ZorroTempData.sharedInstance.setJobTitle(jobtitle: jobtitle)
                        
                        completion(true)
                        return
                    }
                }
            case 20:
                if let userphonenumber = profiledata?.Data?.PhoneNumber {
                    if userphonenumber != "" {
                        ZorroTempData.sharedInstance.setPhoneNumber(phonenumber: userphonenumber)
                        
                        completion(true)
                        return
                    }
                }
                print("")
            default:
                return
            }
        
            
            // MARK: Update with new values if not available
            self.userProfile = profiledata!
            var userprofileupdate = UserProfileUpdate(userprofile: self.userProfile)
            
            var alerttitle = ""
            var alertmessage = ""
            
            switch self.tagtype {
            case 18:
                alerttitle = "Enter The Company"
                alertmessage = "Please enter your company"
                self.commonkeyboardType = .default
            case 19:
                alerttitle = "Enter Job Title"
                alertmessage = "Please enter your job title"
                self.commonkeyboardType = .default
            case 20:
                alerttitle = "Enter Phone Number"
                alertmessage = "Please enter a valid Phone Number to continue"
                self.commonkeyboardType = .phonePad
                print("")
            default:
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.setcommonAlert(title: alerttitle, message: alertmessage, actiontitleOne: "CANCEL", actiontitleTwo: "SAVE", addText: true, completion: { (cancel, save, text) in
                    
                    if cancel {
                        
                        completion(false)
                        return
                    }
                    
                    switch self.tagtype {
                    case 18:
                        userprofileupdate.BusinessName = text!
                    case 19:
                        userprofileupdate.JobTitle = text!
                    case 20:
                        userprofileupdate.PhoneNumber = text!
                    default:
                        return
                    }
                    
                    userprofileupdate.updateuserprofileData(userprofileupdate: userprofileupdate, completion: { (success, errmessaeg) in
                        if !success {
                            return
                        }
                        switch self.tagtype {
                        case 18:
                            ZorroTempData.sharedInstance.setCompanyName(companyname: text!)
                        case 19:
                            ZorroTempData.sharedInstance.setJobTitle(jobtitle: text!)
                        case 20:
                            ZorroTempData.sharedInstance.setPhoneNumber(phonenumber: text!)
                        default:
                            return
                        }
                        
                        completion(true)
                    })
                })
            })
            
        }
    }
}

//MARK: updte legal name of the company for business users
extension ZorroCommonTextInput {
    fileprivate func getlegalName(completion: @escaping(Bool) -> ()) {
        if !Connectivity.isConnectedToInternet() {
            setcommonAlert(title: "Connection!", message: "No Internet connection, Please try again later", actiontitleOne: nil, actiontitleTwo: "Try Again!", addText: false) { (cancel, upload, text) in
                return
            }
            
            completion(false)
            return
        }
        
        let organizationdetails = OrganizationDetails()
        organizationdetails.geturerorganizationDetails { (organizationdetails) in
            if let details = organizationdetails?.Data {
                let legalname = details.Organization?.LegalName
                ZorroTempData.sharedInstance.setOrganizationLegalname(legalname: legalname!)
                completion(true)
                return
            }
            
            self.setcommonAlert(title: "Something Went Wrong !", message: "Unable to get user details", actiontitleOne: nil, actiontitleTwo: "Try Again", addText: false, completion: { (cancel, upload, text) in
                return
            })
            
            completion(false)
            return
        }
        
    }
}
