//
//  DocumentSignController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 4/27/19.
//  Copyright © 2019 ZorroSign. All rights reserved.
//

import UIKit
import RxSwift
import PDFKit
import CoreLocation

class DocumentSignController: BaseVC {
    
    //MAKR: Variables
    var documentinstanceId: String?
    var documentName: String?
    var documentSender: String?
    var isregisterd: Bool = true
    
    var latitude: String = ""
    var longitude: String = ""
    let locationManager = CLLocationManager()
    
    var docProcess: DocProcess?
    private var maindocumentObjectId: String?
    private var docprocesspdfPages: [UIImageView] = []
    private var docprocessuiElements: [DocProcessUIElement] = []
    private var docprocessdynamicnoteElements: [DocProcessUIDynamicNoteElement] = []
    private var docprocessdynamictextElements: [DocProcessUIDynamicTextElement] = []
    private var newuiElements: [DocProcessUINewElement] = []
    private var userPassword: String = ""
    private var userComment: String = ""
    private var otpCode: Int = 0
    
    //MARK: Outlets Variables
    private var subnavBar: UINavigationBar!
    private var pdfView: PDFView!
    private var pdfDocument: PDFDocument!
    private var pdfScrollView: UIScrollView!
    private var mainsubView: UIView!
    private var pdfurl: URL!
    private var loadingView: UIView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: Private Variables
    private var documentdestinationUrl: URL!
    private var rejectDocument: Bool = false
    private var poptoroot: Bool = false
    private var scrollviweZoomScale: CGFloat = 1.0
    private var scrollviewcurrentYposition: CGFloat = 150.0
    private var dynamicnotetagNumber: Int = 0
    private var dynamictexttagNumber: Int = 0
    private var requiredAttachmentCount: Int?
    private var requiredAttachmentTagId: Int?
    private var requiredAttachmentisValid: Bool = false
    private var KBAStatus: Int = 0
    private var otpOnly: Bool = false
    private var biometricsOnly: Bool = false
    private var ssnValue: Int = 0
    private var shouldcontinueSSN: Bool = false
    private var isTagPasswordProtected: Bool = false
    

    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    
        
        setnavBar()
        setLoadingView()
        //registerUpprUser()
        updatedynamicnoteTag()
        updateStampImage()
        addSignature()
        getdocumentProcess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setnaveTitle()
        getCurrentLocation()
    }
    
    // MARK: - Location Config
    
    func getCurrentLocation() {
        
        locationManager.delegate = self
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - Location Delegate

extension DocumentSignController: CLLocationManagerDelegate {
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            //handle denied
            break
        case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
           break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        latitude = String(locValue.latitude)
        longitude = String(locValue.longitude)
    }
}

//MARK: Set navigation bar
extension DocumentSignController {
    fileprivate func setnavBar() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTint
    }
}

extension DocumentSignController {
    fileprivate func setnaveTitle() {
        self.navigationController?.navigationBar.topItem?.title = documentName ?? ""
        let textattributes = [NSAttributedString.Key.foregroundColor: ColorTheme.navTint]
        self.navigationController?.navigationBar.titleTextAttributes = textattributes
    }
}

extension DocumentSignController {
    fileprivate func setLoadingView() {
        loadingView = UIView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .white
        view.addSubview(loadingView)
        
        let loadingviewConstraints = [loadingView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                      loadingView.topAnchor.constraint(equalTo: view.topAnchor),
                                      loadingView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                      loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(loadingviewConstraints)
        
        loadingIndicator = UIActivityIndicatorView(style: .whiteLarge)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.color = ColorTheme.activityindicator
        loadingView.addSubview(loadingIndicator)
        
        let loadinindicatorCosntraints = [loadingIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
                                          loadingIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)]
        NSLayoutConstraint.activate(loadinindicatorCosntraints)
        loadingIndicator.startAnimating()
        view.bringSubviewToFront(loadingView)
    }
}

//MARK: Get Docuemnt Process
extension DocumentSignController {
    func getdocumentProcess() {
        
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        
        guard let instancdid = documentinstanceId else {
            print("something wrong, please try again !")
            return
        }
        
        ZorroHttpClient.sharedInstance.getDocumentProcess(instanceID: instancdid) {docprocess, err , code in 
            if docprocess == nil {
                print(err!)
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.docProcess = docprocess
            
            guard let _kbastatus = docprocess?.data?.kbaStatus else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.KBAStatus = _kbastatus
            
            guard let _createdUsersName = docprocess?.data?.createdUsersName else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.documentSender = _createdUsersName
            
            guard let _docname = docprocess?.data?.documentSetName else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            self.documentName = _docname
            
            // Check for unsupported tools and go back
            if self.checkForUnsupportedTools() {
                AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "Unsupported Tools, Please open the document in web", action: AlertAction(title: "Dismiss")) { (action) in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                //MARK: - TEST AREA
                self.ShowKBAInfoLabel()
            }
            
           
            
            //MARK: - TEST AREA
        }
    }
}

//MARK: - Check for KBA first and continue the process
extension DocumentSignController {
    private func kbaFirstCheck() {
        self.navigationController?.navigationBar.topItem?.title = docProcess?.data?.documentSetName ?? ""
        
        if let documents = docProcess?.data!.documents {
            for document in documents {
                guard let doctype = document.docType else {
                    print("Unable to get the document")
                    return
                }
                if doctype == 0 {
                    let documentobjectID: String = document.objectID!
                    if documentobjectID != "" {
                        self.maindocumentObjectId = documentobjectID
                        self.downloadandsetpdfFile(processid: documentinstanceId ?? "", objectid: documentobjectID)
                        return
                    }
                    print("WARNING! ---> empty object id of document")
                    return
                }
            }
        }
    }
}


//MARK: Download the document
extension DocumentSignController {
    fileprivate func downloadandsetpdfFile(processid: String, objectid: String) {
        
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        
        guard let docname = docProcess?.data?.documentSetName else {
            print("WARNING! ---> unable to continue with the document sign in , please try again!")
            return
        }
        
        ZorroHttpClient.sharedInstance.downloadpdfWithUrl(processID: processid, objectID: objectid, docname: docname.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "document") { (destinationUrl: URL?) in
            
            guard let destinationurl = destinationUrl else {
                self.poptoroot = true
                self.setAlertView(alerttitle: "Something Wrong !", alertmessage: "Unable to view document, Please use a browser to view this document.")
                print("WARNING! ---> unable to fetche document destination url line 163, DocumentSignController.swift")
                return
            }
            
            
            self.documentdestinationUrl = destinationurl
            self.setupPDFView(docdestinationUrl: destinationurl, completion: { [self] (documentloaded) in
                if documentloaded {
                    
                    if self.pdfDocument.isLocked {
                        
                        let pdfprotectedpromptController = PdfprotectedPromptController()
                        pdfprotectedpromptController.documentName = self.documentName ?? ""
                        pdfprotectedpromptController.documentSender = self.documentSender ?? ""
                        pdfprotectedpromptController.providesPresentationContextTransitionStyle = true
                        pdfprotectedpromptController.definesPresentationContext = true
                        pdfprotectedpromptController.modalPresentationStyle = .overCurrentContext
                        pdfprotectedpromptController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
                        
                        DispatchQueue.main.async {
                            self.present(pdfprotectedpromptController, animated: true, completion: nil)
                        }
                        
                        pdfprotectedpromptController.callBack = {[weak self] textvalue, tag in
                            
                            if tag == 0 {
                                pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                                self?.navigationController?.popViewController(animated: true)
                                
                                return
                            }
                            else {
                                let isUnlocked = self!.pdfDocument.unlock(withPassword: textvalue)
                                ZorroTempData.sharedInstance.setpdfprotectionPassword(password: textvalue)
                                
                                if isUnlocked {
                                    pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                                    
                                    self!.pdfView.document = self!.pdfDocument
                                    self!.pdfView.autoScales = false
                                    self!.pdfView.displayMode = .singlePageContinuous
                                    self!.pdfView.documentView?.isHidden = true
                                    
                                    self!.setupeditableContainer(completion: { (setcontainer) in
                                        if setcontainer {
                                            self!.setmainSubView(completion: { (setmainsubview) in
                                                if setmainsubview {
                                                    self!.setpdfSubViews(completion: { (setpdfsubview) in
                                                        if setpdfsubview {
                                                            self!.assignsubtagElements(completion: { (assignviews) in
                                                                if assignviews {
                                                                    self!.adddsubtagElements(completion: { (adddynamicviews) in
                                                                        if adddynamicviews {
                                                                            self!.assigndynamicnoteElements(completion: { (assingdynamicnotes) in
                                                                                if assingdynamicnotes {
                                                                                    self!.adddynamicNoteElements(completion: { (adddynamicnote) in
                                                                                        if adddynamicnote {
                                                                                            self!.assigndynamictexElements(completion: { (assigndynamictext) in
                                                                                                if assigndynamictext {
                                                                                                    self!.adddynamicTextElements(completion: { (adddynamictext) in
                                                                                                        if adddynamictext {
                                                                                                            self!.setcustomNavigationBar()
                                                                                                            self!.setdocumenttoFit()
                                                                                                            self!.scrolltoSelectePage(selectedIndex: 0)
                                                                                                            
                                                                                                            //Show Subscription banner
                                                                                                            let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                                                                                                            if !isBannerClosed {
                                                                                                                self!.setTitleForSubscriptionBanner()
                                                                                                            }
                                                                                                            return
                                                                                                        }
                                                                                                    })
                                                                                                }
                                                                                            })
                                                                                        }
                                                                                    })
                                                                                }
                                                                            })
                                                                        }
                                                                    })
                                                                }
                                                            })
                                                        }
                                                    })
                                                }
                                            })
                                        }
                                        return
                                    })
                                } else {
                                    pdfprotectedpromptController.ispasswordCorrect = false
                                }
                            }
                            
                            return
                        }
                    }
                    else {
                        
                        self.pdfView.document = self.pdfDocument
                        self.pdfView.autoScales = false
                        self.pdfView.displayMode = .singlePageContinuous
                        self.pdfView.documentView?.isHidden = true
                        
                        self.setupeditableContainer(completion: { (setcontainer) in
                            if setcontainer {
                                self.setmainSubView(completion: { (setmainsubview) in
                                    if setmainsubview {
                                        self.setpdfSubViews(completion: { (setpdfsubview) in
                                            if setpdfsubview {
                                                self.assignsubtagElements(completion: { (assignviews) in
                                                    if assignviews {
                                                        self.adddsubtagElements(completion: { (adddynamicviews) in
                                                            if adddynamicviews {
                                                                self.assigndynamicnoteElements(completion: { (assingdynamicnotes) in
                                                                    if assingdynamicnotes {
                                                                        self.adddynamicNoteElements(completion: { (adddynamicnote) in
                                                                            if adddynamicnote {
                                                                                self.assigndynamictexElements(completion: { (assigndynamictext) in
                                                                                    if assigndynamictext {
                                                                                        self.adddynamicTextElements(completion: { (adddynamictext) in
                                                                                            if adddynamictext {
                                                                                                self.setcustomNavigationBar()
                                                                                                self.setdocumenttoFit()
                                                                                                self.scrolltoSelectePage(selectedIndex: 0)
                                                                                                
                                                                                                //Show Subscription banner
                                                                                                let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                                                                                                if !isBannerClosed {
                                                                                                    self.setTitleForSubscriptionBanner()
                                                                                                }
                                                                                                return
                                                                                            }
                                                                                        })
                                                                                    }
                                                                                })
                                                                            }
                                                                        })
                                                                    }
                                                                })
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                    }
                                })
                            }
                            return
                        })
                    }
                    
                    return
                }
                
                self.poptoroot = true
                self.setAlertView(alerttitle: "Something Wrong !", alertmessage: "Unable to view document")
                print("WARNING! ---> unable to fetche document destination url line 247, DocumentSignController.swift")
                print("WARNING! ---> problem with loading doc")
                return
            })
        }
    }
}

//MAKR: Setup Pdf View and load the document
extension DocumentSignController {
    fileprivate func setupPDFView(docdestinationUrl: URL, completion: @escaping(Bool) ->()) {
        
        pdfurl = docdestinationUrl
        
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.backgroundColor = .white
        view.addSubview(pdfView)
        
        
        let pdfviewConstraints = [pdfView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                  pdfView.topAnchor.constraint(equalTo: view.topAnchor),
                                  pdfView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                  pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        NSLayoutConstraint.activate(pdfviewConstraints)
        
        if let pdfdocument = PDFDocument(url: docdestinationUrl) {
            pdfDocument = pdfdocument
//            pdfView.document = pdfDocument
//            pdfView.autoScales = false
//            pdfView.displayMode = .singlePageContinuous
//            pdfView.documentView?.isHidden = true
            completion(true)
            return
        }
        
        completion(false)
        return
    }
}

//MARK: Setup editable viwe
extension DocumentSignController {
    fileprivate func setupeditableContainer(completion: @escaping(Bool) -> ()) {
        for subview in pdfView.subviews {
            if let  pdfsubview = subview as? UIScrollView {
                pdfScrollView = UIScrollView()
                pdfScrollView.delegate = self
                pdfScrollView.translatesAutoresizingMaskIntoConstraints = false
                pdfScrollView.maximumZoomScale = 2.0
                pdfScrollView.minimumZoomScale = 0.4
                pdfScrollView.bounces = false
                pdfScrollView.contentInsetAdjustmentBehavior = .never
                let safearea = view.safeAreaLayoutGuide
                pdfScrollView.contentInset = UIEdgeInsets(top: safearea.layoutFrame.minY + 40, left: 0, bottom: 0, right: 0)
                pdfView.addSubview(pdfScrollView)
                
                let pdfscrollviewconstraints = [pdfScrollView.leftAnchor.constraint(equalTo: pdfsubview.leftAnchor),
                                                pdfScrollView.topAnchor.constraint(equalTo: pdfsubview.topAnchor),
                                                pdfScrollView.rightAnchor.constraint(equalTo: pdfsubview.rightAnchor),
                                                pdfScrollView.bottomAnchor.constraint(equalTo: pdfsubview.bottomAnchor)]
                NSLayoutConstraint.activate(pdfscrollviewconstraints)
                
                pdfScrollView.contentSize = pdfsubview.contentSize
                pdfScrollView.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
                completion(true)
                return
            }
        }
    }
}

//MARK: Set main subview
extension DocumentSignController {
    fileprivate func setmainSubView(completion: @escaping(Bool) ->()) {
        
        let mainsubviewContentSize = pdfScrollView.contentSize
        mainsubView = UIView(frame: CGRect(x: 0, y: 0, width: mainsubviewContentSize.width, height: mainsubviewContentSize.height))
        mainsubView.backgroundColor = .white
        pdfScrollView.addSubview(mainsubView)
        completion(true)
        return
    }
}

//MARK: Set pdf subviews
extension DocumentSignController {
    fileprivate func setpdfSubViews(completion: @escaping(Bool) -> ()) {
        DocumentHelper.sharedInstance.getpdfPages(pdfurl: pdfurl) { (imageviews) in
            for imageview in imageviews {
                self.docprocesspdfPages.append(imageview!)
                self.mainsubView.addSubview(imageview!)
            }
            completion(true)
        }
    }
}

//MARK: Setup Signing Sub Views
extension DocumentSignController {
    fileprivate func assignsubtagElements(completion: @escaping(Bool) ->()) {
        guard let tags: [Tag] = docProcess?.data!.steps![0].tags else {
            completion(true)
            return
        }
        
        DocumentHelper.sharedInstance.checkforAttachmentCount(documenttags: tags) { (count, tagid) in
            
            self.requiredAttachmentCount = count
            if count == 0 {
                self.requiredAttachmentisValid = true
            }
            if let tagid = tagid {
                self.requiredAttachmentTagId = tagid
            }
        
            for tag in tags {
                if tag.type != 12 {
                    let docprocesselement = DocProcessUIElement(tagtype: tag.type!, tagid: tag.tagID!, tagno: tag.tagNo!, tagstate: tag.state!, signatories: tag.signatories, tagplaceholder: tag.tagPlaceHolder!, extrametadata: tag.extraMetaData!, autosaveddata: self.docProcess?.data?.autoSavedData, pdfview: self.pdfView)
                    self.docprocessuiElements.append(docprocesselement)
                }
            }
            completion(true)
            return
        }
    }
}

//MARK: Add dynamic sub views
extension DocumentSignController {
    fileprivate func adddsubtagElements(completion: @escaping(Bool) -> ()) {
        for dynamicelement in docprocessuiElements {
            mainsubView.addSubview(dynamicelement.tagElement)
        }
        completion(true)
    }
}

//MARK: Setup Dynamic Note Views
extension DocumentSignController {
    fileprivate func assigndynamicnoteElements(completion: @escaping(Bool) -> ()) {
        guard let dynamictags: [DynamicTagDetail] = docProcess?.data?.dynamicTagDetails else {
            completion(true)
            return
        }
        
        for dynamicnote in dynamictags {
            dynamicnotetagNumber += 1
            let docprocessdynamictagelement = DocProcessUIDynamicNoteElement(dynamictagdetails: dynamicnote, pdfview: pdfView, notetagnumber: dynamicnotetagNumber)
            docprocessdynamicnoteElements.append(docprocessdynamictagelement)
        }
        completion(true)
        return
    }
}

//MARK: Add Dynamic Note Views
extension DocumentSignController {
    fileprivate func adddynamicNoteElements(completion: @escaping(Bool) -> ()) {
        for dynamicnoteelement in docprocessdynamicnoteElements {
            mainsubView.addSubview(dynamicnoteelement.tagElement)
        }
        completion(true)
    }
}

//MARK: Setup Dynamic Text Views
extension DocumentSignController {
    fileprivate func assigndynamictexElements(completion: @escaping(Bool) -> ()) {
        guard let dynamictexts: [DynamicTextDetail] = docProcess?.data?.dynamicTextDetails else {
            completion(true)
            return
        }
        
        for dynamictext in dynamictexts {
            let docprocessdynamictextelement = DocProcessUIDynamicTextElement(dynamictextdetails: dynamictext, pdfview: pdfView)
            docprocessdynamictextElements.append(docprocessdynamictextelement)
        }
        completion(true)
        return
    }
}

//MARK: Add Dynamic Text View
extension DocumentSignController {
    fileprivate func adddynamicTextElements(completion: @escaping(Bool) -> ()) {
        for dynamictextelement in docprocessdynamictextElements {
            mainsubView.addSubview(dynamictextelement.tagElement)
        }
        completion(true)
    }
}

//MARK: Set Document Set To Window
extension DocumentSignController {
    fileprivate func setdocumenttoFit() {
        let minzoom = self.view.frame.size.width / self.mainsubView.frame.size.width
        scrollviweZoomScale = minzoom
        pdfScrollView.zoomScale = scrollviweZoomScale
    }
}

//MARK: Scrollview Delegate methodds
extension DocumentSignController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yposition = scrollView.contentOffset.y
        scrollviewcurrentYposition = yposition + 150
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return mainsubView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        print("ZOOMING")
        print("ZOOM SCALE : \(scrollView.zoomScale)")
        scrollviweZoomScale = scrollView.zoomScale
    }
}


//MARK: Set Custom NavBar
extension DocumentSignController {
    private func setcustomNavigationBar() {
        let safearea = view.safeAreaLayoutGuide
        
        subnavBar = UINavigationBar()
        subnavBar.translatesAutoresizingMaskIntoConstraints = false
        subnavBar.tintColor = ColorTheme.navTint
        subnavBar.backgroundColor = .white
        view.addSubview(subnavBar)
        
        let subnavbarConstraints = [subnavBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                                    subnavBar.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 0),
                                    subnavBar.rightAnchor.constraint(equalTo: view.rightAnchor)]
        
        NSLayoutConstraint.activate(subnavbarConstraints)
        view.bringSubviewToFront(subnavBar)
        
        let barbuttonImages = ["Thumbnails_tools", "Workflow_green_tools", "Tools", "Reject-Doc_tools", "Approve-green", "Download-green", "Attach-green"]
        let subnavbarItem = UINavigationItem(title: "")
        var barbuttonitems: [UIBarButtonItem] = []
        
        for i in 0..<7 {
            let barbuttonitem = UIBarButtonItem(image: UIImage(named: barbuttonImages[i]), landscapeImagePhone: nil, style: .done, target: self, action: #selector(barbuttonAction(_:)))
            barbuttonitem.tag = i
            barbuttonitems.append(barbuttonitem)
        }
        subnavbarItem.setRightBarButtonItems(barbuttonitems, animated: true)
        subnavBar.setItems([subnavbarItem], animated: false)
    }
}

//MARK: Bar Button Actions
extension DocumentSignController {
    
    //MARK: - Generic
    @objc private func barbuttonAction(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            showThumbnail(sender)
            return
        case 1:
            showworkFlow(sender)
            return
        case 2:
            addnewElement(sender)
            return
        case 3:
            if FeatureMatrix.shared.sign_reject {
                rejectDocument(sender)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
            return
        case 4:
            approveDocument(sender)
            return
        case 5:
            if FeatureMatrix.shared.download_doc {
                downloadDocuments(sender)
            } else {
                FeatureMatrix.shared.showRestrictedMessage()
            }
            return
        case 6:
            addAttachments(sender)
            return
        default:
            return
        }
    }
    
    //MARK: Zoom in and out function
    @objc fileprivate func zoomAction(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            pdfScrollView.zoomScale += 0.1
        case 1:
            pdfScrollView.zoomScale -= 0.1
        default:
            print("Zooming Default")
        }
    }
    
    //MARK: thumbnail action
    @objc fileprivate func showThumbnail(_ sender: UIBarButtonItem) {
        
        guard let pdfdoc = self.pdfDocument else { return }
        
        let documentthumbnailController = DocumentThumbnailController()
        documentthumbnailController.pdfDocumet = pdfdoc
        documentthumbnailController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
        documentthumbnailController.modalPresentationStyle = .popover
        documentthumbnailController.popoverPresentationController?.delegate = self
        documentthumbnailController.popoverPresentationController?.barButtonItem = sender
        
        documentthumbnailController.pageSelected = { pageindex in
            print(pageindex)
            self.scrolltoSelectePage(selectedIndex: pageindex)
        }
        self.present(documentthumbnailController, animated: true, completion: nil)
    }
    
    
    //MARK: show workflow function
    @objc fileprivate func showworkFlow(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let showworkflowviewController = storyboard.instantiateViewController(withIdentifier: "WorkflowVC_ID") as! WorkflowVC
        showworkflowviewController.instanceID = documentinstanceId
        self.present(showworkflowviewController, animated: true, completion: nil)
    }
    
    // MARK: Add new element fuction
    @objc fileprivate func addnewElement(_ sender: UIBarButtonItem) {
        print("add new element ")
        let documentsignelementController = DocumentSignElementSelectController()
        documentsignelementController.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 100)
        documentsignelementController.modalPresentationStyle = .popover
        documentsignelementController.popoverPresentationController?.delegate = self
        documentsignelementController.popoverPresentationController?.barButtonItem = sender
        
        documentsignelementController.addelementCallBack = { (value1, tagtype) in
            print(value1)
            self.addnewItem(tagtype: tagtype)
        }
        
        self.present(documentsignelementController, animated: true, completion: nil)
    }
    
    // MARK: fit to window function -> not working yet
    @objc fileprivate func rejectDocument(_ sender: UIBarButtonItem) {
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        self.rejectDocument = true
//        checkforSSN()
        checkotpandNavigate()
        return
    }
    
    //MARK: Approve function (do validations then approve)
    @objc fileprivate func approveDocument(_ sender: UIBarButtonItem) {
        
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        self.rejectDocument = false
        
        print("approve function works")
//        checkforSSN()
        checkotpandNavigate()
        return
    }
    
    //MARK: Download the document
    @objc fileprivate func downloadDocuments(_ sender: UIBarButtonItem) {
        print("download working")
        
        guard let documents = docProcess?.data?.documents else { return }
        guard let multidocuments = docProcess?.data?.multiUploadDocumentInfo else { return }
        
        
        if documents.count == 1 && multidocuments.count == 1 {
            print("only the document")
            return
        } else {
            let documentdownloadselectControler = DocumentDownloadSelectViewController()
            
            if documents.count == 1 && multidocuments.count > 1 {
                print("multiple documents")
                documentdownloadselectControler.downloadusecaseIndex = 0
                documentdownloadselectControler.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 330)
            }
            
            if documents.count > 1 && multidocuments.count == 1 {
                print("only document and attachments")
                documentdownloadselectControler.downloadusecaseIndex = 1
                documentdownloadselectControler.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 250)
            }
            
            if documents.count > 1 && multidocuments.count > 1 {
                print("multiple documents and attachments")
                documentdownloadselectControler.downloadusecaseIndex = 2
                documentdownloadselectControler.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 400)
            }
            
            documentdownloadselectControler.downloadCallback = { optionindex in
                print("option index : \(optionindex ?? 999)")
                guard let index = optionindex else { return }
                self.documentdownlodOptions(selectedOption: index)
            }
            
            documentdownloadselectControler.modalPresentationStyle = .popover
            documentdownloadselectControler.popoverPresentationController?.delegate = self
            documentdownloadselectControler.popoverPresentationController?.barButtonItem = sender
            self.present(documentdownloadselectControler, animated: true, completion: nil)
        }
    }
    
    //MARK: Attachment function
    @objc fileprivate func addAttachments(_ sender: UIBarButtonItem) {
        print("attachment works")
        
        guard let docprocess = docProcess else { return }
        guard let docprocessid = docProcess?.data?.processID else { return }
        guard let requiredattachmentcount = requiredAttachmentCount else { return }
        
        let documentattachmentController = DocumentAttachmentController()
        
        if requiredattachmentcount == 0 {
            documentattachmentController.attachmentCallback = { count in
                print("uploded required count is : \(count)")
            }
            requiredAttachmentisValid = true
            documentattachmentController.docProcess = docprocess
            documentattachmentController.processID = "\(docprocessid)"
            documentattachmentController.minimumAttachmentCount = 0
            documentattachmentController.attachmenttagId = -1
            documentattachmentController.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 220)
        } else {
            guard let requiredattachtagid = requiredAttachmentTagId else { return }
            documentattachmentController.attachmentCallback = { count in
                print("uploded required count is : \(count)")
                if requiredattachmentcount == count {
                    self.requiredAttachmentisValid = true
                }
            }
            documentattachmentController.docProcess = docprocess
            documentattachmentController.processID = "\(docprocessid)"
            documentattachmentController.minimumAttachmentCount = requiredattachmentcount
            documentattachmentController.attachmenttagId = requiredattachtagid
            documentattachmentController.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 250)
        }
        documentattachmentController.modalPresentationStyle = .popover
        documentattachmentController.popoverPresentationController?.delegate = self
        documentattachmentController.popoverPresentationController?.barButtonItem = sender
        self.present(documentattachmentController, animated: true, completion: nil)
    }
}

// MARK: Popover Delegate
extension DocumentSignController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: Add new UI Element
extension DocumentSignController {
    fileprivate func addnewItem(tagtype: Int) {
        
        if tagtype == 8 {
            dynamicnotetagNumber += 1
        }
        
        let docprocessnewuielement = DocProcessUINewElement(tagtype: tagtype, yposition: scrollviewcurrentYposition, notetagnumber: dynamicnotetagNumber)
        mainsubView.addSubview(docprocessnewuielement.tagElement)
        let panguesture = UIPanGestureRecognizer(target: self, action: #selector(newelementGustureFuntion(_:)))
        docprocessnewuielement.tagElement.addGestureRecognizer(panguesture)
        newuiElements.append(docprocessnewuielement)
    }
}

//MARK: Add gesture for new elements
extension DocumentSignController {
    @objc fileprivate func newelementGustureFuntion(_ sender: UIPanGestureRecognizer) {
        
        guard let draggableObject = sender.view else { return }
        let translation = sender.translation(in: self.mainsubView)
        draggableObject.center = CGPoint(x: draggableObject.center.x + translation.x, y: draggableObject.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.mainsubView)
    }
}

//MARK: Default Alert View
extension DocumentSignController {
    fileprivate func setAlertView(alerttitle: String, alertmessage: String) {
        let docsignalertView = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        docsignalertView.view.tintColor = ColorTheme.alertTint
       
        
        let tryagainAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            if self.poptoroot {
                self.navigationController?.popViewController(animated: true)
                return
            }
            return
        }
        docsignalertView.addAction(tryagainAction)
        
        self.present(docsignalertView, animated: true, completion: nil)
    }
}

//MARK: Alert View For Uppr
extension DocumentSignController {
    fileprivate func setUpprAlertView(alerttitle: String, alertmessage: String) {
        let docsignalertView = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        docsignalertView.view.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
       
        
        let tryagainAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            self.showRegisterUpprUser()
            return
        }
        docsignalertView.addAction(tryagainAction)
        
        self.present(docsignalertView, animated: true, completion: nil)
    }
}

//MARK: Show KBA Info Label
extension DocumentSignController {
    private func ShowKBAInfoLabel() {
        
        guard let _docProcessData = self.docProcess?.data else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let _steps = _docProcessData.steps else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if _steps.count > 0 {
            guard let _tags = _steps[0].tags else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            if _tags.count > 0 {
                if let _isPasswordProtected = _tags[0].isTagPasswordProtected {
                    self.isTagPasswordProtected = _isPasswordProtected
                }
            }
        }
        
        if self.isTagPasswordProtected {
            let pdfprotectedpromptController = PdfprotectedPromptController()
            pdfprotectedpromptController.documentName = documentName ?? ""
            pdfprotectedpromptController.documentSender = documentSender ?? ""
            pdfprotectedpromptController.providesPresentationContextTransitionStyle = true
            pdfprotectedpromptController.definesPresentationContext = true
            pdfprotectedpromptController.modalPresentationStyle = .overCurrentContext
            pdfprotectedpromptController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
            
            DispatchQueue.main.async {
                self.present(pdfprotectedpromptController, animated: true, completion: nil)
            }
            
            pdfprotectedpromptController.callBack = {[weak self] textvalue, tag in
                if tag == 0 {
                    pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                    self?.navigationController?.popViewController(animated: true)
                    
                    return
                } else {
                    if textvalue != "" {
                        let stepPassword = StepPassword(ProcessId: Int(self!.documentinstanceId!) ?? 0, StepPassword: textvalue)
                        stepPassword.checkStepPassword(stepPassword: stepPassword) { [weak self] (res, error) in
                            if !res {
                                pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                                self!.navigationController?.popViewController(animated: true)
                                return
                            }
                            
                            pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                            self!.validateKBA()
                            return
                        }
                    } else {
                        pdfprotectedpromptController.ispasswordCorrect = false
                    }
                }
            }
        } else {
            self.validateKBA()
        }
    }
}

// MARK: - Validate the KBA Status

extension DocumentSignController {
    private func validateKBA() {
        
        if KBAStatus == 1 {
            showSSNInforLabel {[weak self] (_continue) in
                if _continue {
                    self?.checkforSSN()
                    return
                }
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
                return
            }
        } else {
            if let documents = docProcess?.data!.documents {
                for document in documents {
                    guard let doctype = document.docType else {
                        print("Unable to get the document")
                        return
                    }
                    if doctype == 0 {
                        let documentobjectID: String = document.objectID!
                        if documentobjectID != "" {
                            self.maindocumentObjectId = documentobjectID
                            self.downloadandsetpdfFile(processid: documentinstanceId ?? "", objectid: documentobjectID)
                            return
                        }
                        print("WARNING! ---> empty object id of document")
                        return
                    }
                }
            }
        }
    }
}

//MARK: Check for KBA
extension DocumentSignController {
    private func checkforSSN() {
        if KBAStatus == 1 {
            
            let _isssnEnabled = ZorroTempData.sharedInstance.getisSSNAvailabel()
            if _isssnEnabled {
                showKBAQuestionView()
                return
            }

            self.showSSNView { [weak self] (success) in
                if success {
                    self?.showKBAQuestionView()
                    return
                }
            }
            return
        }
        kbaFirstCheck()
//        checkotpandNavigate()
        return
    }
}

//MARK: Navigate to Save all Process & Check OTP
extension DocumentSignController {
    private func checkotpandNavigate() {
        
        let multifactorsettingsresponse = MultifactorSettingsResponse()
        multifactorsettingsresponse.getuserMultifactorSettings {
            (multifactorsettingsdata) in
            
            guard let multifactorsettingsData = multifactorsettingsdata else { return }
            
            switch multifactorsettingsData.ApprovalVerificationType {
            case 2:
                self.otpOnly = true
                let _requestOTP = OTPVerify()
                
                if !self.rejectDocument {
                    _requestOTP.requestOTP { (success, otpissue) in
                        if success {
                            
                            if otpissue {
                                self.setAlertView(alerttitle: "Unable to Approve!", alertmessage: "You have to verify One Time Password (OTP) to change mobile number. Please contact support@zorrosign.com or submit support ticket to reset OTP settings.")
                                return
                            }
                            
                            self.showotpView { (_otpcode) in
                                self.otpCode = _otpcode
                                self.approveorRejectDocument { (success, err) in
                                    if success {
                                        self.poptoroot = true
                                        self.setAlertView(alerttitle: "Success", alertmessage: err)
                                        return
                                    }
                                    self.poptoroot = false
                                    self.setAlertView(alerttitle: "Failure", alertmessage: err)
                                    return
                                }
                            }
                        }
                        //TOOD: Fall Back
                        return
                    }
                    return
                } else {
                    self.showpasswordView { (_pwd, _cmt) in
                        self.userPassword = _pwd ?? ""
                        self.userComment = _cmt ?? ""
                        
                        _requestOTP.requestOTP { (success, otpissue) in
                            if success {
                                
                                if otpissue {
                                    self.setAlertView(alerttitle: "Unable to Approve!", alertmessage: "You have to verify One Time Password (OTP) to change mobile number. Please contact support@zorrosign.com or submit support ticket to reset OTP settings.")
                                    return
                                }
                                
                                self.showotpView { (_otpcode) in
                                    self.otpCode = _otpcode
                                    self.approveorRejectDocument { (success, err) in
                                        if success {
                                            self.poptoroot = true
                                            self.setAlertView(alerttitle: "Success", alertmessage: err)
                                            return
                                        }
                                        self.poptoroot = false
                                        self.setAlertView(alerttitle: "Failure", alertmessage: err)
                                        return
                                    }
                                }
                            }
                            //TOOD: Fall Back
                            return
                        }
                        return
                    }
                    return
                }
            case 3:
                self.showpasswordView { (_pwd, _cmt) in
                    self.userPassword = _pwd ?? ""
                    self.userComment = _cmt ?? ""
                    let _requestotpwithpassword = OTPRequestwithPassword(issingleInstance: false, password: self.userPassword)
                    _requestotpwithpassword.requestuserotpWithPassword(otprequestwithpassword: _requestotpwithpassword) { (success, otpissue) in
                        if success {
                            
                            if otpissue {
                                self.setAlertView(alerttitle: "Unable to Approve!", alertmessage: "You have to verify One Time Password (OTP) to change mobile number. Please contact support@zorrosign.com or submit support ticket to reset OTP settings.")
                                return
                            }
                            
                            self.showotpView { (_otpcode) in
                                self.otpCode = _otpcode
                                self.approveorRejectDocument { (success, err) in
                                    if success {
                                        self.poptoroot = true
                                        self.setAlertView(alerttitle: "Success", alertmessage: err)
                                        return
                                    }
                                    self.poptoroot = false
                                    self.setAlertView(alerttitle: "Failure", alertmessage: err)
                                    return
                                }
                            }
                        }
                        return
                    }
                }
                return
            case 4:
                self.biometricsOnly = true
                
                if !self.rejectDocument {
                    self.approveorRejectDocument { (success, err) in
                        if success {
                            self.poptoroot = true
                            self.setAlertView(alerttitle: "Success", alertmessage: err)
                            return
                        }
                        self.poptoroot = false
                        self.setAlertView(alerttitle: "Failure", alertmessage: err)
                        return
                    }
                } else {
                    self.showpasswordView { (_pwd, _cmt) in
                        self.userPassword = _pwd ?? ""
                        self.userComment = _cmt ?? ""
                        self.approveorRejectDocument { (success, err) in
                            if success {
                                self.poptoroot = true
                                self.setAlertView(alerttitle: "Success", alertmessage: err)
                                return
                            }
                            self.poptoroot = false
                            self.setAlertView(alerttitle: "Failure", alertmessage: err)
                            return
                        }
                        return
                    }
                }
                return
            case 5:
                self.showpasswordView { (_pwd, _cmt) in
                    self.userPassword = _pwd ?? ""
                    self.userComment = _cmt ?? ""
                    let _requestotpwithpassword = OTPRequestwithPassword(issingleInstance: false, password: self.userPassword)
                    _requestotpwithpassword.requestuserotpWithPassword(otprequestwithpassword: _requestotpwithpassword) { (success, hasissue) in
                        if success {
                            
                            if hasissue {
                                self.setAlertView(alerttitle: "Unable to Save!", alertmessage: "Check your password again")
                                return
                            }
                            
                            self.approveorRejectDocument { (success, err) in
                                if success {
                                    self.poptoroot = true
                                    self.setAlertView(alerttitle: "Success", alertmessage: err)
                                    return
                                }
                                self.poptoroot = false
                                self.setAlertView(alerttitle: "Failure", alertmessage: err)
                                return
                            }
                        }
                        return
                    }
                    return
                }
                return
            default:
                if self.isregisterd {
                    self.showpasswordView { (_pwd, _cmt) in
                        self.userPassword = _pwd ?? ""
                        self.userComment = _cmt ?? ""
                        self.approveorRejectDocument { (success, err) in
                            if success {
                                self.poptoroot = true
                                self.setAlertView(alerttitle: "Success", alertmessage: err)
                                return
                            }
                            self.poptoroot = false
                            self.setAlertView(alerttitle: "Failure", alertmessage: err)
                            return
                        }
                        return
                    }
                } else {
                    if self.rejectDocument {
                        self.showCommentViewUPPRUser { (_pwd, _cmt) in
                            self.userPassword = _pwd ?? ""
                            self.userComment = _cmt ?? ""
                            self.approveorRejectDocument { (success, err) in
                                if success {
                                    self.setUpprAlertView(alerttitle: "Success", alertmessage: err)
                                    return
                                }
                                self.poptoroot = false
                                self.setAlertView(alerttitle: "Failure", alertmessage: err)
                                return
                            }
                            return
                        }
                    } else {
                        self.approveorRejectDocument { (success, err) in
                            if success {
                                self.setUpprAlertView(alerttitle: "Success", alertmessage: err)
                                return
                            }
                            self.poptoroot = false
                            self.setAlertView(alerttitle: "Failure", alertmessage: err)
                            return
                        }
                    }
                }
                return
            }
        }
        return
    }
}

//MARK: Show Password View
extension DocumentSignController {
    private func showpasswordView(completion: @escaping(String?, String?) -> ()) {
        let saveallController = DocumentSignSaveAllProcessController()
        saveallController.shouldrejectDocument = rejectDocument
        saveallController.isotpOnly = self.otpOnly
        saveallController.isbiometricsOnly = self.biometricsOnly
        saveallController.definesPresentationContext = true
        saveallController.modalPresentationStyle = .overCurrentContext
        saveallController.saveallCallBack = { (_password, _comment) in
            completion(_password, _comment)
            //TODO : fallback
            return
        }
        saveallController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        DispatchQueue.main.async {
            self.present(saveallController, animated: true, completion: nil)
        }
    }
}

//MARK: - Show comment view for UPPR user if he rejects the document
extension DocumentSignController {
    private func showCommentViewUPPRUser(completion: @escaping(String?, String?) -> ()) {
        let saveallUPPRController = DocumentSignSaveAllProcessUPPRController()
        saveallUPPRController.shouldrejectDocument = rejectDocument
        saveallUPPRController.definesPresentationContext = true
        saveallUPPRController.modalPresentationStyle = .overCurrentContext
        saveallUPPRController.saveallCallBack = { (_password, _comment) in
            completion(_password, _comment)
            return
        }
        saveallUPPRController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        DispatchQueue.main.async {
            self.present(saveallUPPRController, animated: true, completion: nil)
        }
    }
}

//MARK: - Show Activate Popup For Uppr User
extension DocumentSignController {
    private func showRegisterUpprUser() {
        let activateUpprUserController = ActivateUpprUserController()
        activateUpprUserController.definesPresentationContext = true
        activateUpprUserController.modalPresentationStyle = .overCurrentContext
        activateUpprUserController.uppruserEmail = ZorroTempData.sharedInstance.getUserEmail()
        activateUpprUserController.registeruserpopupCallBack = {
            ZorroTempData.sharedInstance.clearAllTempData()
            UserDefaults.standard.set("", forKey: "UserName")
            UserDefaults.standard.set("", forKey: "footerFlag")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let topController = storyboard.instantiateViewController(withIdentifier: "signup_SBID")
            appDelegate.setAsRoot(topController)
            return
        }
        activateUpprUserController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        DispatchQueue.main.async {
            self.present(activateUpprUserController, animated: true, completion: nil)
        }
    }
}

//MARK: Show OTP View
extension DocumentSignController {
    private func showotpView(completion: @escaping(Int) -> ()) {
        view.bringSubviewToFront(loadingView)
        let otpapprovalController = OTPApprovalController()
        otpapprovalController.providesPresentationContextTransitionStyle = true
        otpapprovalController.definesPresentationContext = true
        otpapprovalController.modalPresentationStyle = .overCurrentContext
        otpapprovalController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        otpapprovalController.otpapprovalCallback = { [weak self] otp in
            self!.view.sendSubviewToBack(self!.loadingView)
            if otp != nil {
                completion(otp!)
                return
            }
            return
        }
        
        otpapprovalController.otpverificationCancel = { [weak self] in
            self!.view.sendSubviewToBack(self!.loadingView)
            return
        }
        
        DispatchQueue.main.async {
            self.present(otpapprovalController, animated: true, completion: nil)
        }
    }
}

//MARK: - Show SSN Infor Label
extension DocumentSignController {
    private func showSSNInforLabel(completion: @escaping(Bool) -> ()) {
        
        let _isssnEnabled = ZorroTempData.sharedInstance.getisSSNAvailabel()
        
        let ssninfoController = KBAInfoController(isssn: _isssnEnabled)
        ssninfoController.providesPresentationContextTransitionStyle = true
        ssninfoController.definesPresentationContext = true
        ssninfoController.modalPresentationStyle = .overCurrentContext
        ssninfoController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        DispatchQueue.main.async {
            self.present(ssninfoController, animated: true, completion: nil)
        }
        
        ssninfoController.infoCallBack = { [weak self] shouldcontinue in
            self?.shouldcontinueSSN = shouldcontinue
            completion(shouldcontinue)
            return
        }
    }
}

//MARK: Show SSN View
extension DocumentSignController {
    private func showSSNView(completion: @escaping(Bool) ->()) {
        let ssnController = KBASSNVerifyController()
        ssnController.providesPresentationContextTransitionStyle = true
        ssnController.definesPresentationContext = true
        ssnController.modalPresentationStyle = .overCurrentContext
        ssnController.view.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)
        
        DispatchQueue.main.async {
            self.present(ssnController, animated: true, completion: nil)
        }
        
        ssnController.continueCallBack = { [weak self] ssn in
            self?.ssnValue = ssn
            completion(true)
            return
        }
    }
}

//MARK: Show KBA Question View
extension DocumentSignController {
    private func showKBAQuestionView() {
        
        guard let _processdata = docProcess?.data else { return }
        guard let _instanceid = _processdata.processID, let _step = _processdata.processingStep else { return }
        
        let kbaquestionController = KBAQuestionsController(instanceid: _instanceid, ssn: ssnValue, stepid: _step)
        DispatchQueue.main.async {
            self.navigationController?.pushViewController(kbaquestionController, animated: true)
        }
        
        kbaquestionController.questionCallBack = { [weak self] (success, err) in
            
            if success {
                self?.kbaFirstCheck()
//                self?.checkotpandNavigate()
                return
            }
            self?.setAlertView(alerttitle: "Unable to Continue!", alertmessage: err ?? "")
        }
    }
}

//MARK: Approve or Reject the doc function
extension DocumentSignController {
    fileprivate func approveorRejectDocument(completion: @escaping(Bool, String) -> ()) {
        
        view.bringSubviewToFront(loadingView)
        
        var docsaveProcess = DocSaveProcess()
        docsaveProcess.password = userPassword
        docsaveProcess.otpcode = otpCode
        
        
        var processsavedetailDto = ProcessSaveDetailsDto()
        processsavedetailDto.IssingleInstance = nil
        processsavedetailDto.workflowDefinitionID = docProcess?.data?.definitionID
        processsavedetailDto.processID = docProcess?.data?.processID
        
        let pdfPassword = ZorroTempData.sharedInstance.getpdfprotectionPassword()
        processsavedetailDto.pdfPassword = pdfPassword
        
        DocumentHelper.sharedInstance.setdocumentTagDetails(docprocessUIElements: docprocessuiElements, reject: rejectDocument, comment: userComment) { (tagdetails, validate) in
            
            
            if !validate {
                self.view.sendSubviewToBack(self.loadingView)
                print("All fields needs to be filled in")
                completion(false, "All fields needs to be filled in")
                return
            }
            
            if !self.requiredAttachmentisValid {
                self.view.sendSubviewToBack(self.loadingView)
                completion(false, "All required attachments needs to be uploaded")
                return
            }
            
            for tagdetail in tagdetails! {
                processsavedetailDto.tagDetails.append(tagdetail)
            }
            
            DocumentHelper.sharedInstance.setdynamicNoteDetails(docprocessdynamicNoteElements: self.docprocessdynamicnoteElements, completion: { (dynamicnotedetails, done) in
                
                for dynamictagdetail in dynamicnotedetails! {
                    processsavedetailDto.dynamicTagDetails.append(dynamictagdetail)
                }
                
                DocumentHelper.sharedInstance.setdynamicTextDetails(docprocessdynamicTextElement: self.docprocessdynamictextElements, completion: { (dynamictextdetails, done) in
            
                    for dynamictextdetail in dynamictextdetails! {
                        processsavedetailDto.dynamicTextDetails.append(dynamictextdetail)
                    }
                    
                    DocumentHelper.sharedInstance.setnewDynamicTags(newtagElements: self.newuiElements, pdfview: self.pdfView, pdfpages: self.docprocesspdfPages, completion: { (newdynamicdetails, done) in
                        
                        for newdynamicdetail in newdynamicdetails! {
                            
                            
                            let (tagdetial, type) = newdynamicdetail
                            
                            switch type{
                            case 8:
                                let newnotedetail = tagdetial as! DynamicTagDetail
                                
                                guard let notetext = newnotedetail.tagText else {
                                    self.setAlertView(alerttitle: "Unable To Save", alertmessage: "Note cannot be empty")
                                    self.view.sendSubviewToBack(self.loadingView)
                                    return
                                }
                                
                                if notetext == "" {
                                    self.setAlertView(alerttitle: "Unable To Save", alertmessage: "Note cannot be empty")
                                    self.view.sendSubviewToBack(self.loadingView)
                                    return
                                }
                                
                                if !newnotedetail.isDeleted! {
                                    processsavedetailDto.dynamicTagDetails.append(newnotedetail)
                                }
                            case 14:
                                let newtextdetails = tagdetial as! DynamicTextDetail
                                if !newtextdetails.isDeleted! {
                                    processsavedetailDto.dynamicTextDetails.append(newtextdetails)
                                }
                            default:
                                return
                            }
                        }
                        
                        // Add the Location
                        processsavedetailDto.geoLocation = "\(self.latitude),\(self.longitude)"
                        
                        //need the change here
                        
                        docsaveProcess.processSaveDetailsDto.append(processsavedetailDto)
                        docsaveProcess.savedocumentProcess(docsaveprocess: docsaveProcess) { (succss, err) in
                            self.view.sendSubviewToBack(self.loadingView)
                            if succss {
                                ZorroTempData.sharedInstance.setpdfprotectionPassword(password: "")
                            }
                            completion(succss, err!)
                        }
                    })
                })
            })
            
        }
    }
}

//MARK: -  Scroll to page
extension DocumentSignController {
    fileprivate func scrolltoSelectePage(selectedIndex: Int) {
        let index = selectedIndex + 1
        
        if docprocesspdfPages.count > 1 {
            for pageimageview in docprocesspdfPages {
                if pageimageview.tag == index {
                    DocumentHelper.sharedInstance.getdocumentScrollPosition(imageview: pageimageview, zoomScale: scrollviweZoomScale) { (xposition, yposition) in
                        
                        print("\(xposition) === \(yposition)")
                        self.pdfScrollView.setContentOffset(CGPoint(x: xposition, y: yposition-110), animated: true)
                    }
                    return
                }
            }
        }
    }
}

//MARK: -  Sharing Manager functions
extension DocumentSignController {
    fileprivate func updatedynamicnoteTag() {
        SharingManager.sharedInstance.onnoteRemove?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self] removedindex in
            
            DocumentHelper.sharedInstance.updatedynamicNoteTagNumber(docprocessuidynamicnoteElements: self!.docprocessdynamicnoteElements, docprocessnewuiElements: self!.newuiElements, removedtag: removedindex, completion: { (removed, existingelementcount) in
                
                if removed {
                    print("Existing element count is : \(existingelementcount)")
                    
                    if existingelementcount != 0 {
                        self!.dynamicnotetagNumber -= 1
                    }
                    
                    if existingelementcount == 0 {
                        self?.dynamicnotetagNumber = 0
                    }
                    
                }
                
            })
        }).disposed(by: self.disposebag)
    }
    
    fileprivate func updateStampImage() {
        self.view.endEditing(true)
        let stamp = ZorroTempData.sharedInstance.getStamp()
        if stamp == "" {
            SharingManager.sharedInstance.onstampTouch?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
                tapped in
                
                print(tapped)
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let seal = storyboard.instantiateViewController(withIdentifier: "Seal_SBID") as! SealVC
                    seal.fromStamp = true
                    seal.docSignFlag = true
                    self?.navigationController?.pushViewController(seal, animated: true)
                }
                
            }).disposed(by: self.disposebag)
        }
    }
    
    fileprivate func addSignature() {
        SharingManager.sharedInstance.onsignatureSelect?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
            tapped in
            print(tapped)
            DispatchQueue.main.async {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let seal = storyboard.instantiateViewController(withIdentifier: "managesign_SBID") as! ManageSignVC
                self?.navigationController?.pushViewController(seal, animated: true)
            }
            
        }).disposed(by: self.disposebag)
    }
}

//MARK: - Document Download options
extension DocumentSignController {
    fileprivate func documentdownlodOptions(selectedOption: Int) {
        
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        
        
        guard let documentprocess = docProcess else { return }
        guard let processid = documentinstanceId else { return }
        guard let objectid = maindocumentObjectId else { return }
        
        DocumentHelper.sharedInstance.downloadFilesQueue(processID: processid, objectID: objectid, docprocessDetails: documentprocess, downloadoption: selectedOption) { (success) in
            
            if success {
                print("successfully downloaded")
                DispatchQueue.main.async {
                    self.poptoroot = false
                    self.setAlertView(alerttitle: "Success !", alertmessage: "Successfully Downloaded")
                }
                return
            }
            print("ERROR OCCURED ......")
        }
    }
}

// MARK: - check For UnsupportedTools

extension DocumentSignController {
    func checkForUnsupportedTools() -> Bool {
        
        var isUnsupportedType = false
        
        if let _steps = docProcess?.data?.steps {
            for step in _steps {
                if let _tags = step.tags {
                    for tag in _tags {
                        if tag.type == 22 {
                            isUnsupportedType = true
                        }
                        if tag.type == 22 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if _extraMetaData.Group != nil {
                                    isUnsupportedType = true
                                }
                            }
                        }
                        if tag.type == 13 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if _extraMetaData.Group != nil {
                                    isUnsupportedType = true
                                }
                            }
                        }
                        if tag.type == 3 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if let _CustomTextBoxEnable = _extraMetaData.CustomTextBoxEnable, _CustomTextBoxEnable == "True" {
                                    isUnsupportedType = true
                                }
                            }
                        }
                    }
                }
            }
        }
        return isUnsupportedType
    }
}

