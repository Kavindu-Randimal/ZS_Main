//
//  DoucmentViewController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/13/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PDFKit

class DocumentViewController: BaseVC {
    
    //MAKR: Variables
    var documentinstanceId: String?
    var documentName: String?
    var documentSender: String?
    var isregisterd: Bool = true
    
    var docProcess: DocProcess!
    private var maindocumentObjectId: String?
    private var pdfDocument: PDFDocument!
    var poptoroot: Bool = false
    
    //MARK: Outlets Variables
    private var pdfView: PDFView!
    private var loadingView: UIView!
    private var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setnavBar()
        setpdfView()
        setLoadingView()
        //registerUpprUser()
        getdocumentProcess()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTint
    }
}

//MARK: Navigation bar
extension DocumentViewController {
    
    fileprivate func setnavBar() {
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTint
        
        let showthumnailbutton = UIBarButtonItem(image: UIImage(named: "docpages"), style: .done, target: self, action: #selector(showThumbnail(_:)))
        showthumnailbutton.tag = 0
        self.navigationItem.rightBarButtonItem = showthumnailbutton
        
        let workflowbutton = UIBarButtonItem(image: UIImage(named: "Workflow_green_tools"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(showworkFlow(_:)))
        workflowbutton.tag = 1
        self.navigationItem.rightBarButtonItems?.append(workflowbutton)
        
        let downloadbutton = UIBarButtonItem(image: UIImage(named: "Download"), style: .done, target: self, action: #selector(downloadPdf(_:)))
        downloadbutton.tag = 2
        self.navigationItem.rightBarButtonItems?.append(downloadbutton)
    }
}

extension DocumentViewController {
    fileprivate func setnavTitle(docname: String) {
        self.navigationController?.navigationBar.tintColor = ColorTheme.navTint
        self.navigationController?.navigationBar.topItem?.title = docname
    }
}

//MARK: Bar button actions
extension DocumentViewController {
    //MARK: Show Thumbnail
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
            self.scrolltoPageAt(pageIndex: pageindex)
        }
        self.present(documentthumbnailController, animated: true, completion: nil)
    }
    
    //MARK: Show workflow
    @objc fileprivate func showworkFlow(_ sender: UIBarButtonItem) {
        
        guard let instid = documentinstanceId else { return }
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let showworkflowviewController = storyboard.instantiateViewController(withIdentifier: "WorkflowVC_ID") as! WorkflowVC
        showworkflowviewController.instanceID = instid
        self.present(showworkflowviewController, animated: true, completion: nil)
    }
    
    //MARK: Download
    @objc fileprivate func downloadPdf(_ sender: UIBarButtonItem) {
        
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
        
        setAlertView(alerttitle: "Download Completed !", alertmessage: "Your document is downloaded to Files App → Locations(On My iPhone) → ZorroSign → \(documentName!)")
    }
}

// MARK: Popover Delegate
extension DocumentViewController : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: Loading view -> need to create a generic function for this. unbale to this with existing structure
extension DocumentViewController {
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

//MARK: Set up pdf view
extension DocumentViewController {
    fileprivate func setpdfView() {
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.backgroundColor = .darkGray
        view.addSubview(pdfView)
        
        let pdfviewConstraints = [pdfView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                  pdfView.topAnchor.constraint(equalTo: view.topAnchor),
                                  pdfView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                  pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        NSLayoutConstraint.activate(pdfviewConstraints)
    }
}

//MARK: Get document process details
extension DocumentViewController {
    func getdocumentProcess() {
        
        if !Connectivity.isConnectedToInternet() {
            poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "")
            return
        }
        
        guard let instancdid = documentinstanceId else {
            print("something wrong, please try again !")
            return
        }
        
        ZorroHttpClient.sharedInstance.getDocumentProcessDetails(instanceID: instancdid) {docprocess, err in
            if docprocess == nil {
                print(err!)
                self.dismiss(animated: true, completion: nil)
                return
            }
            
            guard let _docname = docprocess?.data?.documentSetName else {
                return
            }
            self.documentName = _docname
            
            guard let _createdUsersName = docprocess?.data?.createdUsersName else {
                return
            }
            self.documentSender = _createdUsersName
            
            self.docProcess = docprocess
            self.setnavTitle(docname: (self.docProcess.data?.documentSetName)!)
            
            // Check for unsupported tools and go back
            self.checkForUnsupportedTools()
            
            if let documents = docprocess?.data!.documents {
                for document in documents {
                    guard let doctype = document.docType else {
                        print("Unable to get the document")
                        return
                    }
                    if doctype == 0 {
                        let documentobjectID: String = document.objectID!
                        if documentobjectID != "" {
                            self.maindocumentObjectId = documentobjectID
                            self.downloadandSetPdf(processid: instancdid, objectid: documentobjectID)
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

//MARK: Download the document
extension DocumentViewController {
    fileprivate func downloadandSetPdf(processid: String, objectid: String) {
        
        if !Connectivity.isConnectedToInternet() {
            poptoroot = true
            setAlertView(alerttitle: "Connection !", alertmessage: "")
            return
        }
        
        guard let docname = self.docProcess.data?.documentSetName else {
            print("WARNING! ---> unable to continue with the document sign in , please try again!")
            return
        }
        
        ZorroHttpClient.sharedInstance.downloadpdfWithUrl(processID: processid, objectID: objectid, docname: docname.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "document") { (destinationUrl: URL?) in
            
            guard let destinationurl = destinationUrl else {
                print("WARNING! ---> unable to fetche document destination url")
                return
            }
            
            self.setpdfDocument(destinatinUrl: destinationurl, completion: { (documentloaded) in
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
                                
                                if isUnlocked {
                                    pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                                    
                                    self!.pdfView.autoScales = true
                                    self!.pdfView.document = self!.pdfDocument
                                    self!.pdfView.displayMode = .singlePageContinuous
                                    self!.removeAnnotations()
                                    //Show Subscription banner
                                    let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                                    if !isBannerClosed {
                                        self?.setTitleForSubscriptionBanner()
                                    }
                                } else {
                                    pdfprotectedpromptController.ispasswordCorrect = false
                                }
                            }
                            
                            return
                        }
                    } else {
                        self.pdfView.autoScales = true
                        self.pdfView.document = self.pdfDocument
                        self.pdfView.displayMode = .singlePageContinuous
                        self.removeAnnotations()
                        //Show Subscription banner
                        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                        if !isBannerClosed {
                            self.setTitleForSubscriptionBanner()
                        }
                    }
                    self.loadingView.isHidden = true
                }
            })
        }
    }
}

//MARK: Setup the document
extension DocumentViewController {
    fileprivate func setpdfDocument(destinatinUrl: URL, completion: @escaping(Bool) ->()) {
        
        guard let pdfdocument = PDFDocument(url: destinatinUrl) else {
            poptoroot = true
            setAlertView(alerttitle: "Something Wrong !", alertmessage: "Unable to view this document")
            print("unabel to load the document -> lin 226 at DocumentViewController.Swift")
            return
        }
        
        self.pdfDocument = pdfdocument
        //        pdfView.autoScales = true
        //        pdfView.document = pdfdocument
        //        pdfView.displayMode = .singlePageContinuous
        //        removeAnnotations()
        
        completion(true)
    }
}

//MARK: Scroll to page at
extension DocumentViewController {
    fileprivate func scrolltoPageAt(pageIndex: Int) {
        if let page = pdfView.document?.page(at: pageIndex) {
            pdfView.go(to: page)
        }
    }
}

//MARK: Set Alert
extension DocumentViewController {
    fileprivate func setAlertView(alerttitle: String, alertmessage: String) {
        let docsignalertView = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        docsignalertView.view.tintColor = ColorTheme.alertTint
        
        let tryagainAction = UIAlertAction(title: "OK", style: .cancel) { (alert) in
            if self.poptoroot {
                self.navigationController?.popViewController(animated: true)
            }
            return
        }
        docsignalertView.addAction(tryagainAction)
        
        self.present(docsignalertView, animated: true, completion: nil)
    }
}

//MARK: Remove annotations
extension DocumentViewController {
    fileprivate func removeAnnotations() {
        let pagecount = pdfDocument.pageCount
        
        for i in 0..<pagecount {
            let page = pdfDocument.page(at: i)
            if let annotations = page?.annotations {
                for annotation in annotations {
                    page?.removeAnnotation(annotation)
                }
            }
        }
        
    }
}

//MARK: - Document Download options
extension DocumentViewController {
    fileprivate func documentdownlodOptions(selectedOption: Int) {
        
        if !Connectivity.isConnectedToInternet() {
            self.poptoroot = true
            
            self.setAlertView(alerttitle: "Connection !", alertmessage: "No Internet connection, Please try again later")
            return
        }
        
        
        guard let documentprocess = docProcess else { return }
        guard let processid = documentinstanceId else { return }
        guard let objectid = maindocumentObjectId else { return }
        
        DocumentHelper.sharedInstance.downloadFilesQueue(processID: processid, objectID: objectid, docprocessDetails: documentprocess, downloadoption: selectedOption) { (success) in
            
            if success {
                print("successfully downloaded")
                DispatchQueue.main.async {
                    self.setAlertView(alerttitle: "Success !", alertmessage: "Successfully Downloaded")
                }
                return
            }
            print("ERROR OCCURED ......")
        }
    }
}

//MARK: - Register uppr user
extension DocumentViewController {
    func registerUpprUser() {
        if isregisterd {
            getdocumentProcess()
            return
        }
        
        let upprregistercontroller = DocumentSignUPPRRegisterController()
        upprregistercontroller.modalPresentationStyle = .overCurrentContext
        self.present(upprregistercontroller, animated: true, completion: nil)
        
        upprregistercontroller.registrationCompletion = {[weak self] success in
            if success {
                self!.getdocumentProcess()
            }
            return
        }
        return
    }
}

// MARK: - Check For Unsupported Tools

extension DocumentViewController {
    func checkForUnsupportedTools() {
        if let _steps = docProcess.data?.steps {
            for step in _steps {
                if let _tags = step.tags {
                    for tag in _tags {
                        if tag.type == 22 {
                            AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "Unsupported Tools, Please open the document in web", action: AlertAction(title: "Dismiss")) { (action) in
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                        if tag.type == 22 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if _extraMetaData.Group != nil {
                                    AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "Unsupported Tools, Please open the document in web", action: AlertAction(title: "Dismiss")) { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                        
                        if tag.type == 13 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if _extraMetaData.Group != nil {
                                    AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "Unsupported Tools, Please open the document in web", action: AlertAction(title: "Dismiss")) { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                        
                        if tag.type == 3 {
                            if let _extraMetaData =  tag.extraMetaData {
                                if let _CustomTextBoxEnable = _extraMetaData.CustomTextBoxEnable, _CustomTextBoxEnable == "True" {
                                    AlertProvider.init(vc: self).showAlertWithAction(title: "Alert", message: "Unsupported Tools, Please open the document in web", action: AlertAction(title: "Dismiss")) { (action) in
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
