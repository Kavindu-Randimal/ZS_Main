//
//  DocumentInitiateController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/29/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocumentInitiateSelectController: DocumentInitiateBaseController {
    
    private var bottombuttonContainer: UIView!
    private var documentcancelButton: UIButton!
    private var documentcreateButton: UIButton!
    
    private var contentContainer: UIView!
    private var headerText: UILabel!
    
    private var documentnameLabel: UILabel!
    private var documentnametextField: UITextField!
    private var documentdescriptionLabel: UILabel!
    private var passworddescriptionLabel: UILabel!
    private var passwordagreeTextView: UIView!
    private var documentdescriptiontextField: UITextField!
    
    private var pdfpasswordtextField: UITextField!
    private var passwordeprotectedLabel: UILabel!
    private var showPasswordButton: UIButton!
    
    private var uploadContainer: UIView!
    private var uploadtitleLabel: UILabel!
    
    private var uploadlargebuttonContainer: UIView!
    private var uploadlargeButton: UIButton!
    
    
    private var uploadmoreContainer: UIView!
    private var uploadedcountLabel: UILabel!
    private var uploadmoreButton: UIButton!
    private var checkboxButton: UIButton!
    
    private var uploadedfilecontentTableView: UITableView!
    private let uploadedfilecellIdentifier = "uploadedfilecellidentifier"
    
    private var selectedDocuments: [DocumentinitiateSelectFile] = []
    var workflowId: Int!
    private var ischecked: Bool = false
    private var isEnabledShowPassword = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setnavBar()
        setbottomButtons()
        setContent()
        updateuploadUI()
        
        //Show Subscription Banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
    }
    
    override func viewDidLayoutSubviews() {
        setdashedBorder()
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setnavBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.title = "E-Sign"
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setbottomButtons() {
        
        let safearea = view.safeAreaLayoutGuide
        
        bottombuttonContainer = UIView()
        bottombuttonContainer.backgroundColor = .white
        bottombuttonContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottombuttonContainer)
        
        let bottombuttoncontainerConstraints = [bottombuttonContainer.leftAnchor.constraint(equalTo: view.leftAnchor),
                                                bottombuttonContainer.rightAnchor.constraint(equalTo: view.rightAnchor),
                                                bottombuttonContainer.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                                bottombuttonContainer.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(bottombuttoncontainerConstraints)
        
        let buttonwidth = UIScreen.main.bounds.width/2 - 20
        
        documentcancelButton = UIButton()
        documentcancelButton.translatesAutoresizingMaskIntoConstraints = false
        documentcancelButton.setTitle("CANCEL", for: .normal)
        documentcancelButton.setTitleColor(greencolor, for: .normal)
        documentcancelButton.backgroundColor = .white
        
        bottombuttonContainer.addSubview(documentcancelButton)
        
        let documentcancelbuttonConstraints = [documentcancelButton.leftAnchor.constraint(equalTo: bottombuttonContainer.leftAnchor, constant: 10),
                                               documentcancelButton.topAnchor.constraint(equalTo: bottombuttonContainer.topAnchor, constant: 5),
                                               documentcancelButton.bottomAnchor.constraint(equalTo: bottombuttonContainer.bottomAnchor, constant: -5),
                                               documentcancelButton.widthAnchor.constraint(equalToConstant: buttonwidth)]
        NSLayoutConstraint.activate(documentcancelbuttonConstraints)
        documentcancelButton.addTarget(self, action: #selector(documentcancelAction(_:)), for: .touchUpInside)
        
        documentcancelButton.layer.borderColor = greencolor.cgColor
        documentcancelButton.layer.borderWidth = 2
        documentcancelButton.layer.cornerRadius = 5
        documentcancelButton.layer.masksToBounds = true
        
        
        documentcreateButton = UIButton()
        documentcreateButton.translatesAutoresizingMaskIntoConstraints = false
        documentcreateButton.setTitle("CREATE", for: .normal)
        documentcreateButton.setTitleColor(.white, for: .normal)
        documentcreateButton.backgroundColor = greencolor
        
        bottombuttonContainer.addSubview(documentcreateButton)
        
        let documentcreatebuttonConstraints = [documentcreateButton.rightAnchor.constraint(equalTo: bottombuttonContainer.rightAnchor, constant: -10),
                                               documentcreateButton.topAnchor.constraint(equalTo: bottombuttonContainer.topAnchor, constant: 5),
                                               documentcreateButton.bottomAnchor.constraint(equalTo: bottombuttonContainer.bottomAnchor, constant: -5),
                                               documentcreateButton.widthAnchor.constraint(equalToConstant: buttonwidth)]
        NSLayoutConstraint.activate(documentcreatebuttonConstraints)
        documentcreateButton.addTarget(self, action: #selector(documentcreateAction(_:)), for: .touchUpInside)
        
        documentcreateButton.layer.cornerRadius = 5
        documentcreateButton.layer.masksToBounds = true
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setContent() {
        let safearea = view.safeAreaLayoutGuide
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentContainer = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        contentContainer.backgroundColor = .white
        
        headerText = UILabel()
        headerText.translatesAutoresizingMaskIntoConstraints = false
        headerText.text = "Create New Document Set"
        headerText.font = UIFont(name: "Helvetica-Bold", size: 20)
        contentContainer.addSubview(headerText)
        
        let headertextConstraints = [headerText.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
                                     headerText.topAnchor.constraint(equalTo: contentContainer.topAnchor),
                                     headerText.rightAnchor.constraint(equalTo: contentContainer.rightAnchor)]
        
        NSLayoutConstraint.activate(headertextConstraints)
        
        documentnameLabel = UILabel()
        documentnameLabel.translatesAutoresizingMaskIntoConstraints = false
        documentnameLabel.text = "DOCUMENT SET NAME *"
        documentnameLabel.textColor = .darkGray
        documentnameLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        contentContainer.addSubview(documentnameLabel)
        
        let documentnamelabelConstraints = [documentnameLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
                                            documentnameLabel.topAnchor.constraint(equalTo: headerText.bottomAnchor, constant: 30),
                                            documentnameLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor)]
        NSLayoutConstraint.activate(documentnamelabelConstraints)
        
        documentnametextField = UITextField()
        documentnametextField.translatesAutoresizingMaskIntoConstraints = false
        documentnametextField.delegate = self
        documentnametextField.borderStyle = .roundedRect
        documentnametextField.placeholder = "Enter text here"
        documentnametextField.font = UIFont(name: "Helvetica", size: 16)
        
        contentContainer.addSubview(documentnametextField)
        
        let documentnametextfieldConstraints = [documentnametextField.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 12),
                                                documentnametextField.topAnchor.constraint(equalTo: documentnameLabel.bottomAnchor, constant: 5),
                                                documentnametextField.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -12),
                                                documentnametextField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(documentnametextfieldConstraints)
        documentnametextField.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingChanged)
        
        documentnametextField.layer.shadowRadius = 1.5
        documentnametextField.layer.shadowColor   = UIColor.lightGray.cgColor
        documentnametextField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        documentnametextField.layer.shadowOpacity = 0.9
        documentnametextField.layer.masksToBounds = false
        documentnametextField.layer.cornerRadius = 8
        
        
        documentdescriptionLabel = UILabel()
        documentdescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        documentdescriptionLabel.text = "DESCRIPTION"
        documentdescriptionLabel.textColor = .darkGray
        documentdescriptionLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        contentContainer.addSubview(documentdescriptionLabel)
        
        let documentdescriptionlabelConstraints = [documentdescriptionLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
                                                   documentdescriptionLabel.topAnchor.constraint(equalTo: documentnametextField.bottomAnchor, constant: 15),
                                                   documentdescriptionLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor)]
        NSLayoutConstraint.activate(documentdescriptionlabelConstraints)
        
        documentdescriptiontextField = UITextField()
        documentdescriptiontextField.translatesAutoresizingMaskIntoConstraints = false
        documentdescriptiontextField.borderStyle = .roundedRect
        documentdescriptiontextField.placeholder = "Enter text here"
        documentdescriptiontextField.font = UIFont(name: "Helvetica", size: 16)
        
        contentContainer.addSubview(documentdescriptiontextField)
        
        let documentdescriptiontextfieldConstraints = [documentdescriptiontextField.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 12),
                                                       documentdescriptiontextField.topAnchor.constraint(equalTo: documentdescriptionLabel.bottomAnchor, constant: 5),
                                                       documentdescriptiontextField.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -12),
                                                       documentdescriptiontextField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(documentdescriptiontextfieldConstraints)
        
        documentdescriptiontextField.layer.shadowRadius = 1.5
        documentdescriptiontextField.layer.shadowColor   = UIColor.lightGray.cgColor
        documentdescriptiontextField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0)
        documentdescriptiontextField.layer.shadowOpacity = 0.9
        documentdescriptiontextField.layer.masksToBounds = false
        documentdescriptiontextField.layer.cornerRadius = 8
        
        checkboxButton = UIButton()
        checkboxButton.translatesAutoresizingMaskIntoConstraints = false
        checkboxButton.titleLabel?.font = UIFont(name: "Helvetica", size: 16)//UIFont.fontAwesome(ofSize: 12, style: .solid)
        //checkboxButton.titleLabel?.adjustsFontSizeToFitWidth = true
        checkboxButton.titleLabel?.minimumScaleFactor = 0.2
        checkboxButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        checkboxButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: -6)
        checkboxButton.setTitle("Password Protect Document", for: .normal)
        checkboxButton.setTitleColor(.darkGray, for: .normal)
        checkboxButton.setImage(UIImage(named: "checkbox_black"), for: .normal)
        checkboxButton.isEnabled = true
        contentContainer.addSubview(checkboxButton)
        
        let checkboxbuttonConstriants = [checkboxButton.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 20),
        checkboxButton.topAnchor.constraint(equalTo: documentdescriptiontextField.bottomAnchor, constant: 5),
        //checkboxButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: 10),
        checkboxButton.heightAnchor.constraint(equalToConstant: 45)]
        
        NSLayoutConstraint.activate(checkboxbuttonConstriants)
        checkboxButton.addTarget(self, action: #selector(checkboxAction(_:)), for: .touchUpInside)
        
        passwordeprotectedLabel = UILabel()
        passwordeprotectedLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordeprotectedLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        passwordeprotectedLabel.numberOfLines = 2
        passwordeprotectedLabel.text = "PDF PASSWORD *"
        passwordeprotectedLabel.adjustsFontSizeToFitWidth = true
        passwordeprotectedLabel.minimumScaleFactor = 0.2
        passwordeprotectedLabel.textColor = .darkGray
        passwordeprotectedLabel.isHidden = true
        contentContainer.addSubview(passwordeprotectedLabel)
        
        let passwordprotectedlableConstraint = [passwordeprotectedLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
                                                passwordeprotectedLabel.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 10),
                                                passwordeprotectedLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor)]
        NSLayoutConstraint.activate(passwordprotectedlableConstraint)
        
        pdfpasswordtextField = UITextField()
        pdfpasswordtextField.translatesAutoresizingMaskIntoConstraints = false
        pdfpasswordtextField.borderStyle = .roundedRect
        pdfpasswordtextField.isSecureTextEntry = true
        pdfpasswordtextField.placeholder = "Enter password here"
        pdfpasswordtextField.font = UIFont(name: "Helvetica", size: 16)
        pdfpasswordtextField.isSecureTextEntry = true
        
        contentContainer.addSubview(pdfpasswordtextField)
        
        let pdfpasswordtextfieldConstraints = [pdfpasswordtextField.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 12),
                                               pdfpasswordtextField.topAnchor.constraint(equalTo: passwordeprotectedLabel.bottomAnchor, constant: 5),
                                               pdfpasswordtextField.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -12),
                                               pdfpasswordtextField.heightAnchor.constraint(equalToConstant: 45)]
        NSLayoutConstraint.activate(pdfpasswordtextfieldConstraints)   
        
        pdfpasswordtextField.addTarget(self, action: #selector(passfieldDidChange(_:)), for: .editingChanged)
        
        pdfpasswordtextField.layer.shadowRadius = 1.5;
        pdfpasswordtextField.layer.shadowColor   = UIColor.lightGray.cgColor
        pdfpasswordtextField.layer.shadowOffset  = CGSize(width: 0.0, height: 0.0);
        pdfpasswordtextField.layer.shadowOpacity = 0.9;
        pdfpasswordtextField.layer.masksToBounds = false;
        pdfpasswordtextField.layer.cornerRadius = 8
        pdfpasswordtextField.isHidden = true
        
        showPasswordButton = UIButton()
        showPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        showPasswordButton.setImage(UIImage(named: "ic_view_pass"), for: .normal)
        
        contentContainer.addSubview(showPasswordButton)
        
        let showPasswordButtonConstraints = [showPasswordButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -15),
                                             showPasswordButton.topAnchor.constraint(equalTo: passwordeprotectedLabel.bottomAnchor, constant: 10),
                                             showPasswordButton.heightAnchor.constraint(equalToConstant: 35),
                                             showPasswordButton.widthAnchor.constraint(equalToConstant: 35)]
        NSLayoutConstraint.activate(showPasswordButtonConstraints)
        
        showPasswordButton.addTarget(self, action: #selector(showHidePassword), for: .touchUpInside)
        
        
        passwordagreeTextView = UIView()
        passwordagreeTextView.translatesAutoresizingMaskIntoConstraints = false
        passwordagreeTextView.backgroundColor = lightgray
        
        contentContainer.addSubview(passwordagreeTextView)
        
        let passwordagreeTextViewConstraints = [passwordagreeTextView.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
                                                passwordagreeTextView.topAnchor.constraint(equalTo: pdfpasswordtextField.bottomAnchor, constant: 10),
                                                passwordagreeTextView.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(passwordagreeTextViewConstraints)
        
        passwordagreeTextView.layer.masksToBounds = true
        passwordagreeTextView.layer.cornerRadius = 5
        
        
        passworddescriptionLabel = UILabel()
        passworddescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        passworddescriptionLabel.text = "This password will be required each time the document is accessed via ZorroSign or opened as a downloaded file. If the password is forgotten the document cannot be recovered. The user who creates the document password is responsible for securely sharing with all users in the document set's workflow."
        passworddescriptionLabel.textColor = .darkGray
        passworddescriptionLabel.font = UIFont(name: "Helvetica", size: 15)
        passworddescriptionLabel.numberOfLines = 8
        passworddescriptionLabel.textAlignment = .justified
        passworddescriptionLabel.isHidden = true
        passworddescriptionLabel.adjustsFontSizeToFitWidth = true
        passworddescriptionLabel.minimumScaleFactor = 0.2
        contentContainer.addSubview(passworddescriptionLabel)
        
        let passworddescriptionlabelConstraints = [passworddescriptionLabel.leftAnchor.constraint(equalTo: passwordagreeTextView.leftAnchor, constant: 5),
        passworddescriptionLabel.topAnchor.constraint(equalTo: passwordagreeTextView.topAnchor, constant: 5),
        passworddescriptionLabel.rightAnchor.constraint(equalTo: passwordagreeTextView.rightAnchor, constant: -5),
        passworddescriptionLabel.bottomAnchor.constraint(equalTo: passwordagreeTextView.bottomAnchor, constant: -5)]
        
        NSLayoutConstraint.activate(passworddescriptionlabelConstraints)
        
        scrollView.addSubview(contentContainer)
        
        scrollView.contentSize = CGSize(width: screenWidth, height: 800)
        view.addSubview(scrollView)
        
        let scrollViewConstraints = [scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     scrollView.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 10),
                                     scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     scrollView.bottomAnchor.constraint(equalTo: bottombuttonContainer.topAnchor)]
        NSLayoutConstraint.activate(scrollViewConstraints)
        
        setuploadContent()
    }
}

extension DocumentInitiateSelectController {
    @objc fileprivate func checkboxAction(_ sender: UIButton) {
        
        if FeatureMatrix.shared.create_pwd_doc {
            ischecked = !ischecked
            if ischecked {
                checkboxButton.setImage(UIImage(named: "checkbox_sel_black"), for: .normal)
                
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: [.curveEaseInOut , .allowUserInteraction],
                    animations: {
                        self.uploadContainer.frame = CGRect(x: self.uploadContainer.frame.origin.x, y: self.checkboxButton.frame.origin.y + 250, width: self.uploadContainer.frame.width, height: self.uploadContainer.frame.height)
                        
                        // self.uploadContainer.center = CGPoint(x: self.checkboxButton.frame.origin.x, y: self.checkboxButton.frame.origin.x + 200)
                    },
                    completion: { finished in
                        self.passwordeprotectedLabel.isHidden = false
                        self.pdfpasswordtextField.isHidden = false
                        self.passworddescriptionLabel.isHidden = false
                    }
                )
                
            } else {
                checkboxButton.setImage(UIImage(named: "checkbox_black"), for: .normal)
                passwordeprotectedLabel.isHidden = true
                pdfpasswordtextField.isHidden = true
                passworddescriptionLabel.isHidden = true
                UIView.animate(
                    withDuration: 1.0,
                    delay: 0.0,
                    options: [.curveEaseInOut , .allowUserInteraction],
                    animations: {
                        self.uploadContainer.frame = CGRect(x: self.uploadContainer.frame.origin.x, y: self.checkboxButton.frame.origin.y + 45, width: self.uploadContainer.frame.width, height: self.uploadContainer.frame.height)
                    },
                    completion: { finished in
                    }
                )
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setuploadContent() {
        uploadContainer = UIView()
        uploadContainer.translatesAutoresizingMaskIntoConstraints = false
        uploadContainer.backgroundColor = .white
        contentContainer.addSubview(uploadContainer)
        
        let uploadcontainerConstraints = [uploadContainer.leftAnchor.constraint(equalTo: contentContainer.leftAnchor),
                                          uploadContainer.topAnchor.constraint(equalTo: checkboxButton.bottomAnchor, constant: 0),
                                          uploadContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor),
                                          uploadContainer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -5)]
        NSLayoutConstraint.activate(uploadcontainerConstraints)
        
        uploadtitleLabel = UILabel()
        uploadtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadtitleLabel.text = "UPLOAD FILE(S) *"
        uploadtitleLabel.textColor = .darkGray
        uploadtitleLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        uploadContainer.addSubview(uploadtitleLabel)
        
        let uploadtitlelabelConstraints = [uploadtitleLabel.leftAnchor.constraint(equalTo: uploadContainer.leftAnchor, constant: 10),
                                           uploadtitleLabel.topAnchor.constraint(equalTo: uploadContainer.topAnchor, constant: 10)]
        NSLayoutConstraint.activate(uploadtitlelabelConstraints)
        
        setuploadlargeButton()
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setuploadlargeButton() {
        
        uploadlargebuttonContainer = UIView()
        uploadlargebuttonContainer.translatesAutoresizingMaskIntoConstraints = false
        uploadlargebuttonContainer.backgroundColor = .white
        uploadContainer.addSubview(uploadlargebuttonContainer)
        
        let uploadlargeConstraints = [uploadlargebuttonContainer.leftAnchor.constraint(equalTo: uploadContainer.leftAnchor, constant: 12),
                                      uploadlargebuttonContainer.topAnchor.constraint(equalTo: uploadtitleLabel.bottomAnchor, constant: 10),
                                      uploadlargebuttonContainer.rightAnchor.constraint(equalTo: uploadContainer.rightAnchor, constant: -12),
                                      uploadlargebuttonContainer.heightAnchor.constraint(equalToConstant: 100)]
        
        NSLayoutConstraint.activate(uploadlargeConstraints)
        
        uploadlargebuttonContainer.layer.cornerRadius = 5
        uploadlargebuttonContainer.layer.masksToBounds = true
        
        uploadlargeButton = UIButton()
        uploadlargeButton.translatesAutoresizingMaskIntoConstraints = false
        uploadlargeButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 25, style: .solid)
        uploadlargeButton.setTitle(String.fontAwesomeIcon(name: .plus), for: .normal)
        uploadlargeButton.setTitleColor(.lightGray, for: .normal)
        uploadlargebuttonContainer.addSubview(uploadlargeButton)
        
        let uploadlargebuttonConstraints = [uploadlargeButton.leftAnchor.constraint(equalTo: uploadlargebuttonContainer.leftAnchor),
                                            uploadlargeButton.topAnchor.constraint(equalTo: uploadlargebuttonContainer.topAnchor),
                                            uploadlargeButton.rightAnchor.constraint(equalTo: uploadlargebuttonContainer.rightAnchor),
                                            uploadlargeButton.bottomAnchor.constraint(equalTo: uploadlargebuttonContainer.bottomAnchor)]
        NSLayoutConstraint.activate(uploadlargebuttonConstraints)
        uploadlargeButton.addTarget(self, action: #selector(uploadlargebuttonAction(_:)), for: .touchUpInside)
        
        uploadmoreContent()
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setdashedBorder() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.darkGray.cgColor
        border.fillColor = nil
        border.lineDashPattern = [4,4]
        border.path = UIBezierPath(rect: uploadlargebuttonContainer.bounds).cgPath
        border.frame = uploadlargebuttonContainer.bounds
        uploadlargebuttonContainer.layer.addSublayer(border)
    }
}

extension DocumentInitiateSelectController {
    fileprivate func uploadmoreContent() {
        uploadmoreContainer = UIView()
        uploadmoreContainer.translatesAutoresizingMaskIntoConstraints = false
        uploadmoreContainer.backgroundColor = .white
        uploadContainer.addSubview(uploadmoreContainer)
        
        let uploadmoreConstraints = [uploadmoreContainer.leftAnchor.constraint(equalTo: uploadContainer.leftAnchor),
                                     uploadmoreContainer.topAnchor.constraint(equalTo: uploadtitleLabel.bottomAnchor),
                                     uploadmoreContainer.rightAnchor.constraint(equalTo: uploadContainer.rightAnchor),
                                     uploadmoreContainer.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(uploadmoreConstraints)
        
        
        uploadmoreButton = UIButton()
        uploadmoreButton.translatesAutoresizingMaskIntoConstraints = false
        uploadmoreButton.setImage(UIImage(named: "Upload more"), for: .normal)
        uploadmoreContainer.addSubview(uploadmoreButton)
        
        let uploadmorebuttonConstraints = [uploadmoreButton.topAnchor.constraint(equalTo: uploadmoreContainer.topAnchor),
                                           uploadmoreButton.rightAnchor.constraint(equalTo: uploadmoreContainer.rightAnchor),
                                           uploadmoreButton.bottomAnchor.constraint(equalTo: uploadmoreContainer.bottomAnchor),
                                           uploadmoreButton.widthAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(uploadmorebuttonConstraints)
        
        uploadmoreButton.addTarget(self, action: #selector(uploadmorebuttonAction(_:)), for: .touchUpInside)
        
        uploadedcountLabel = UILabel()
        uploadedcountLabel.translatesAutoresizingMaskIntoConstraints = false
        uploadedcountLabel.font = UIFont(name: "Helvetica-Bold", size: 16)
        uploadedcountLabel.text = "Select 0 item(s)"
        uploadedcountLabel.textColor = .darkGray
        uploadmoreContainer.addSubview(uploadedcountLabel)
        
        let uploadcountlabelConstraints = [uploadedcountLabel.leftAnchor.constraint(equalTo: uploadmoreContainer.leftAnchor, constant: 10),
                                           uploadedcountLabel.centerYAnchor.constraint(equalTo: uploadmoreContainer.centerYAnchor)]
        
        NSLayoutConstraint.activate(uploadcountlabelConstraints)
        
        setuploadedfileContent()
    }
}

extension DocumentInitiateSelectController {
    fileprivate func setuploadedfileContent() {
        
        uploadedfilecontentTableView = UITableView(frame: .zero, style: .plain)
        uploadedfilecontentTableView.register(DocumentInitiateSelectFileCell.self, forCellReuseIdentifier: uploadedfilecellIdentifier)
        uploadedfilecontentTableView.translatesAutoresizingMaskIntoConstraints = false
        uploadedfilecontentTableView.dataSource = self
        uploadedfilecontentTableView.delegate = self
        uploadedfilecontentTableView.separatorStyle = .none
        uploadedfilecontentTableView.tableFooterView = UIView()
        uploadContainer.addSubview(uploadedfilecontentTableView)
        
        let uploadfilecontenttableviewConstraints = [uploadedfilecontentTableView.leftAnchor.constraint(equalTo: uploadContainer.leftAnchor),
                                                     uploadedfilecontentTableView.topAnchor.constraint(equalTo: uploadmoreContainer.bottomAnchor),
                                                     uploadedfilecontentTableView.rightAnchor.constraint(equalTo: uploadContainer.rightAnchor),
                                                     uploadedfilecontentTableView.bottomAnchor.constraint(equalTo: uploadContainer.bottomAnchor)]
        NSLayoutConstraint.activate(uploadfilecontenttableviewConstraints)
        
    }
}

//MARK: - Data Source and Delegate methods
extension DocumentInitiateSelectController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedDocuments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filecell = tableView.dequeueReusableCell(withIdentifier: uploadedfilecellIdentifier) as! DocumentInitiateSelectFileCell
        let thedocument = selectedDocuments[indexPath.row]
        filecell.documentinitiateselectfile = thedocument
        filecell.buttonindex = indexPath.row
        filecell.removeindexat = { index in
            self.removefile(at: indexPath.section, row: index)
        }
        return filecell
    }
}

extension DocumentInitiateSelectController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

//MARK: - Button Actions
extension DocumentInitiateSelectController {
    @objc fileprivate func uploadlargebuttonAction(_ sender: UIButton) {
        opendocumentPicker()
    }
    
    @objc fileprivate func uploadmorebuttonAction(_ sender: UIButton) {
        if FeatureMatrix.shared.multiple_doc_upload {
        opendocumentPicker()
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    fileprivate func opendocumentPicker() {
        
        let documentpicker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        documentpicker.delegate = self
        documentpicker.modalPresentationStyle = .formSheet
        self.present(documentpicker, animated: true, completion: nil)
    }
    
    
    @objc fileprivate func documentcancelAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func documentcreateAction(_ sender: UIButton) {
        
        let isconnected = Connectivity.isConnectedToInternet()
        if !isconnected {
            showalertMessage(title: "Connection !", message: "No Internet connection, Please try again later", cancel: false)
            return
        }
        
        let isvalid = validateFields()
        if !isvalid {
            return
        }
        showbackDrop()
        let documentname = documentnametextField.text
        let documentdescription = documentdescriptiontextField.text
        let pdfpassword = pdfpasswordtextField.text ?? ""
        let createworkflow = CreateWorkflow(Name: documentname, Description: documentdescription, IsSingleInstance: true,MainDocumentType: 0, PdfPassword: pdfpassword)
        createworkflow.creatnewWorkFlow(createworkflow: createworkflow) { (workflowid) in
            
            if let workflowid = workflowid {
                self.workflowId = workflowid
                
                let newdocumentselect = DocumentinitiateSelectFile()
                newdocumentselect.uploadcreateworkflowfilesQueue(workflowid: workflowid, pdfpassword: pdfpassword, selectedDocuments: self.selectedDocuments, completion: { (completed) in
                    
                    if !completed {
                        self.errHanlder()
                        return
                    }
                    
                    ZorroTempData.sharedInstance.setpdfprotectionPassword(password: pdfpassword)
                    
                    DispatchQueue.main.async {
                        let documentinitiatecontactController = DocumentInitiateContactsController()
                        documentinitiatecontactController.workflowID = self.workflowId
                        self.navigationController?.pushViewController(documentinitiatecontactController, animated: true)
                    }
                })
            } else {
                self.errHanlder()
            }
        }
    }
}

//MARK: - Document picker delegate implementation
extension DocumentInitiateSelectController: UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        DocumentHelper.sharedInstance.addfilestodocinitiateArray(urls: urls, documentinitiateselectfiles: selectedDocuments) { (newselectedfiles) in
            
            self.selectedDocuments = newselectedfiles
            if self.selectedDocuments.count > 0 {
                self.uploadtitleLabel.textColor = .darkGray
            }
            self.uploadedfilecontentTableView.reloadData {
                self.updateuploadUI()
            }
        }
    }
}

//MARK: - Remove files
extension DocumentInitiateSelectController {
    fileprivate func removefile(at section: Int, row: Int) {
        let indexpath = IndexPath(row: row, section: section)
        selectedDocuments.remove(at: row)
        self.uploadedfilecontentTableView.deleteRows(at: [indexpath], with: .left)
        self.uploadedfilecontentTableView.reloadData {
            self.updateuploadUI()
        }
    }
}

//MARK: - Check for document count for update UI
extension DocumentInitiateSelectController {
    fileprivate func updateuploadUI() {
        let selectedfiles = selectedDocuments
        if selectedfiles.count > 0 {
            uploadlargebuttonContainer.isHidden = true
            uploadmoreContainer.isHidden = false
            uploadedcountLabel.text = "Select \(selectedfiles.count) item(s)"
            uploadedfilecontentTableView.isHidden = false
        } else {
            uploadlargebuttonContainer.isHidden = false
            uploadmoreContainer.isHidden = true
            uploadedcountLabel.text = ""
            uploadedfilecontentTableView.isHidden = true
        }
    }
}

extension DocumentInitiateSelectController {
    @objc fileprivate func showHidePassword() {
        if isEnabledShowPassword {
            showPasswordButton.setImage(#imageLiteral(resourceName: "ic_view_pass"), for: .normal)
            pdfpasswordtextField.isSecureTextEntry = true
            isEnabledShowPassword = false
            
        } else {
            showPasswordButton.setImage(#imageLiteral(resourceName: "ic_hide_pass"), for: .normal)
            pdfpasswordtextField.isSecureTextEntry = false
            isEnabledShowPassword = true
        }
    }
}

//MARK: Check for text change
extension DocumentInitiateSelectController {
    @objc fileprivate func textfieldDidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (documentnameLabel.textColor = .red) : (documentnameLabel.textColor = .darkGray)
    }
}

//MARK: Check for password field change
extension DocumentInitiateSelectController {
    @objc fileprivate func passfieldDidChange(_ textfield: UITextField) {
        guard let text = textfield.text else { return }
        text.isEmpty ? (passwordeprotectedLabel.textColor = .red) : (passwordeprotectedLabel.textColor = .darkGray)
    }
}

//MARK: - UITextField Delegates to prevent special characters
extension DocumentInitiateSelectController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let characterset = NSCharacterSet(charactersIn: ZorroTempStrings.NOT_ACCEPTABLE_CHARACTERS).inverted
        let filtered = string.components(separatedBy: characterset).joined(separator: "")
        
        if string.isEmpty {
            return true
        }
        return string != filtered
    }
}

//MARK: - Handle error UI
extension DocumentInitiateSelectController {
    fileprivate func errHanlder() {
        self.selectedDocuments = []
        self.uploadedfilecontentTableView.reloadData {
            self.updateuploadUI()
        }
    }
}

//MARK: - Validate Text Fields
extension DocumentInitiateSelectController {
    fileprivate func validateFields() -> Bool {
        let documentname = documentnametextField.text
        let documentcount = selectedDocuments.count
        let passwordtext = pdfpasswordtextField.text
        var isvalid = true
        
        if documentname!.isEmpty {
            documentnameLabel.textColor = .red
            isvalid = false
        }
        
        if documentcount == 0 {
            uploadtitleLabel.textColor = .red
            isvalid = false
        }
        
        if ischecked && passwordtext!.isEmpty {
            passwordeprotectedLabel.textColor = .red
            isvalid = false
        }
        
        if !isvalid {
            return false
        }
        
        documentnameLabel.textColor = .darkGray
        uploadtitleLabel.textColor = .darkGray
        passwordeprotectedLabel.textColor = .darkGray
        
        return true
    }
}

//MARK: - alert actions
extension DocumentInitiateSelectController {
    override func genericokAction() {
        return
    }
}
