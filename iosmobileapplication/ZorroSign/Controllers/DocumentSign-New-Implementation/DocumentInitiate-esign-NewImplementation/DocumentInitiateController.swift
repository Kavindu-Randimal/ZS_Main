//
//  DocumentInitiateController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/7/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PDFKit
import RxSwift

class DocumentInitiateController: DocumentInitiateBaseController {
    
    var createworkflowData: GetWorkflowData?
    var initiatorContact: ContactDetailsViewModel!
    var selectedContacts: [ContactDetailsViewModel]!
    var allthetimeContacts: [[ContactDetailsViewModel]] = [[ContactDetailsViewModel]]()
    var numberofTagsInStep: [Int] = [Int]()
    
    //MARK: - properties
    let barbuttons: [String] = ["docpages", "approvedocument", "Download", "Attach", "Recipients"]
    let selectedbarButtons: [String] = ["docpages", "approvedocument", "Download", "Attach-green", "Recipients-green"]
    
    private var pdfPages: [UIImageView] = []
    
    //MARK: - Outlet connections
    private var pdfView: PDFView!
    private var pdfviewbottomConstraint: NSLayoutConstraint!
    private var pdfDocument: PDFDocument!
    private var pdfUrl: URL!
    private var pdfScrollView: UIScrollView!
    private var mainsubContainer: UIView!
    private var subnavBar: UINavigationBar!
    private var attachmentccView: UIScrollView!
    private var attachmentccSubContainer: UIView!
    
    private var zoomScale: CGFloat = 1.0
    
    private var documentStep: Int = 0
    private var previoususers: [ContactDetailsViewModel] = []
    private var assignedUsers: [ContactDetailsViewModel]!
    private var noteCount: Int = 1
    
    private var newinitiatedViews: [ZorroDocumentInitiateBaseView] = []
    private var newinitiatedDynamicTextViews: [ZorroDocumentInitiateBaseView] = []
    private var newinitiatedDynamicNoteViews: [ZorroDocumentInitiateBaseView] = []
    
    private var pagesbarButton: UIBarButtonItem!
    private var donebarbutton: UIBarButtonItem!
    private var downloadbarbutton: UIBarButtonItem!
    private var attachmentbarButton: UIBarButtonItem!
    private var userpanelbarbutton: UIBarButtonItem!
    private var navbarButtons: [UIBarButtonItem]!
    private var navbarTitle: UILabel!
    
    private let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setnavBar()
        setcloseBarButton()
        downloadworkflowPDF()
        updateStamp()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        updatebarButtons()
    }
}

//MARK: Set Navigation var properties
extension DocumentInitiateController {
    fileprivate func setnavBar() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        guard let documentname = createworkflowData?.Name else { return }
        
        navbarTitle = UILabel()
        navbarTitle.text = documentname
        navbarTitle.font = UIFont(name: "Helvetica-Bold", size: 17)
        let width = navbarTitle.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        navbarTitle.frame = CGRect(origin:CGPoint.zero, size:CGSize(width: width, height: 500))
        self.navigationItem.titleView = navbarTitle
        
        let titletapGesture = UITapGestureRecognizer(target: self, action: #selector(titletapAction(_:)))
        navbarTitle.isUserInteractionEnabled = true
        navbarTitle.addGestureRecognizer(titletapGesture)
    }
}

//MARK: Set Close bar button
extension DocumentInitiateController {
    fileprivate func setcloseBarButton() {
        let closebarButton = UIBarButtonItem(image: UIImage(named: "Close-1"), style: .done, target: self, action: #selector(cancelEsign(_:)))
        self.navigationItem.rightBarButtonItem = closebarButton
    }
}

//MARK: Downlod the merged pdf document
extension DocumentInitiateController {
    fileprivate func downloadworkflowPDF() {
        showbackDrop()
        if !Connectivity.isConnectedToInternet() {
            print("no internet connection. please try again")
            return
        }
        
        guard let workflowid = createworkflowData?.Id else { return }
        guard let objectid = createworkflowData?.Documents![0].ObjectId else { return }
        guard let documentname = createworkflowData?.Name else { return }
        
        let getworkflow = GetWorkflow()
        getworkflow.downloadworkflowmergedPDF(workflowid: workflowid, objectid: objectid, documentname: documentname.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "document") { (documenturl) in
            print ("documenturl : \(documenturl)")
            if documenturl != nil {
                self.setuppdfView(documenturl: documenturl!, completion: { (success, password) in
                    if success {
                        
                        if password == "" {
                            let pdfprotectedpromptController = PdfprotectedPromptController()
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
                                } else{
                                    let isUnlocked = self!.pdfDocument.unlock(withPassword: textvalue)
                                    ZorroTempData.sharedInstance.setpdfprotectionPassword(password: textvalue)
                                    
                                    if isUnlocked {
                                        pdfprotectedpromptController.dismiss(animated: true, completion: nil)
                                        
                                        self!.pdfView.document = self!.pdfDocument
                                        self!.pdfView.autoScales = false
                                        self!.pdfView.displayMode = .singlePageContinuous
                                        self!.pdfView.documentView?.isHidden = true
                                        
                                        self!.setupContainer(completion: { (success) in
                                            if success {
                                                self!.setmainsubContainer(completion: { (success) in
                                                    if success {
                                                        self!.setuppdfPages(completion: { (success) in
                                                            if success {
                                                                self!.setdocumenttoFit(scrollview: self!.pdfScrollView)
                                                                self!.setsubnavBar()
                                                                self!.hidebackDrop()
                                                                self!.setattachmentccView()
                                                                self!.showstartHint()
                                                                
                                                                //Show Subscription Banner
                                                                let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                                                                if !isBannerClosed {
                                                                    self!.setTitleForSubscriptionBanner()
                                                                }
                                                            }
                                                        })
                                                    }
                                                })
                                            }
                                        })
                                        
                                    } else {
                                        pdfprotectedpromptController.ispasswordCorrect = false
                                    }
                                }
                                return
                            }
                        } else {
                            self.setupContainer(completion: { (success) in
                                if success {
                                    self.setmainsubContainer(completion: { (success) in
                                        if success {
                                            self.setuppdfPages(completion: { (success) in
                                                if success {
                                                    self.setdocumenttoFit(scrollview: self.pdfScrollView)
                                                    self.setsubnavBar()
                                                    self.hidebackDrop()
                                                    self.setattachmentccView()
                                                    self.showstartHint()
                                                    
                                                    //Show Subscription Banner
                                                    let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
                                                    if !isBannerClosed {
                                                        self.setTitleForSubscriptionBanner()
                                                    }
                                                }
                                            })
                                        }
                                    })
                                }
                            })
                        }
                    }
                })
            }
        }
    }
}

// Setup PDF View
extension DocumentInitiateController {
    fileprivate func setuppdfView(documenturl: URL, completion: @escaping(Bool, String) -> ()) {
        pdfUrl = documenturl
        
        pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.backgroundColor = .white
        view.addSubview(pdfView)
        
        let pdfviewConstraints = [pdfView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                  pdfView.topAnchor.constraint(equalTo: view.topAnchor),
                                  pdfView.rightAnchor.constraint(equalTo: view.rightAnchor)]
        
        pdfviewbottomConstraint = pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pdfviewbottomConstraint.priority = UILayoutPriority(999)
        pdfviewbottomConstraint.isActive = true
        NSLayoutConstraint.activate(pdfviewConstraints)
        
        if let pdfdocument = PDFDocument(url: documenturl) {
            pdfDocument = pdfdocument
            
            if self.pdfDocument.isLocked {
                
                let unlockpassword = ZorroTempData.sharedInstance.getpdfprotectionPassword()
                
                if unlockpassword == "" {
                    completion(true, unlockpassword)
                    return
                } else {
                    let isUnlocked = pdfDocument.unlock(withPassword: unlockpassword)
                    //ZorroTempData.sharedInstance.setpdfprotectionPassword(password: textvalue)
                    if isUnlocked {
                        pdfView.document = pdfDocument
                        pdfView.autoScales = false
                        pdfView.displayMode = .singlePageContinuous
                        pdfView.documentView?.isHidden = true
                        completion(true, unlockpassword)
                        return
                    }
                }
            }
            
            pdfView.document = pdfDocument
            pdfView.autoScales = false
            pdfView.displayMode = .singlePageContinuous
            pdfView.documentView?.isHidden = true
            completion(true, "notLocked")
            return
        }
        completion(false, "")
        return
    }
}

extension DocumentInitiateController {
    fileprivate func setupContainer(completion: @escaping(Bool) -> ()) {
        
        for subview in pdfView.subviews {
            if let  pdfsubview = subview as? UIScrollView {
                pdfScrollView = UIScrollView()
                pdfScrollView.delegate = self
                pdfScrollView.translatesAutoresizingMaskIntoConstraints = false
                pdfScrollView.maximumZoomScale = 2.0
                pdfScrollView.minimumZoomScale = 0.4
                pdfScrollView.bounces = false
                pdfScrollView.contentInsetAdjustmentBehavior = .never
                pdfScrollView.tag = 0
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

//MARK: - Setup main sub container
extension DocumentInitiateController {
    fileprivate func setmainsubContainer(completion: @escaping(Bool) ->()) {
        let mainsubContent = pdfScrollView.contentSize
        mainsubContainer = UIView(frame: CGRect(x: 0, y: 0, width: mainsubContent.width, height: mainsubContent.height))
        mainsubContainer.backgroundColor = .white
        pdfScrollView.addSubview(mainsubContainer)
    
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(mainsubTapGesture(_:)))
        mainsubContainer.addGestureRecognizer(tapgesture)
        
        completion(true)
        return
    }
}

//MARK: setup pdf pages
extension DocumentInitiateController {
    fileprivate func setuppdfPages(completion: @escaping(Bool) -> ()) {
        DocumentHelper.sharedInstance.getpdfPages(pdfurl: pdfUrl) { [weak self] imageviews in
            for imageview in imageviews {
                self!.pdfPages.append(imageview!)
                self!.mainsubContainer.addSubview(imageview!)
            }
            completion(true)
            return
        }
    }
}

//MARK: set document to fit
extension DocumentInitiateController {
    fileprivate func setdocumenttoFit(scrollview: UIScrollView) {
        if scrollview.tag == 0 {
            let minzoom = self.view.frame.size.width / self.mainsubContainer.frame.size.width
            zoomScale = minzoom
            print("self.view.frame.size.width : \(self.view.frame.size.width)")
            print("self.mainsubContainer.frame.size.width : \(self.mainsubContainer.frame.size.width)")
            print("zoom scale for maincontainer : \(minzoom)")
            scrollview.zoomScale = zoomScale
        } else {
            scrollview.zoomScale = 0.5
        }
    }
}

//MARK: set sub navbar
extension DocumentInitiateController {
    fileprivate func setsubnavBar() {
        let safearea = view.safeAreaLayoutGuide
        subnavBar = UINavigationBar()
        subnavBar.translatesAutoresizingMaskIntoConstraints = false
        subnavBar.tintColor = darkgray
        subnavBar.backgroundColor = .white
        view.addSubview(subnavBar)
        
        let subnavbarConstraints = [subnavBar.leftAnchor.constraint(equalTo: view.leftAnchor),
                                    subnavBar.topAnchor.constraint(equalTo: safearea.topAnchor),
                                    subnavBar.rightAnchor.constraint(equalTo: view.rightAnchor)]
        
        NSLayoutConstraint.activate(subnavbarConstraints)
        
        let subnavbarItem = UINavigationItem(title: "")
        
        var barbuttonitems: [UIBarButtonItem] = []
        
        for i in 0..<barbuttons.count {
            let barbuttonitem = UIBarButtonItem(image: UIImage(named: barbuttons[i]), landscapeImagePhone: nil, style: .done, target: self, action: #selector(navbarActions(_:)))
            barbuttonitem.tag = i
            if i == 0 {
                pagesbarButton = barbuttonitem
            }
            if i == 1 {
                donebarbutton = barbuttonitem
            }
            if i == 2 {
                downloadbarbutton = barbuttonitem
            }
            if i == 3 {
                attachmentbarButton = barbuttonitem
            }
            if i == 4 {
                userpanelbarbutton = barbuttonitem
            }
            barbuttonitems.append(barbuttonitem)
        }
        navbarButtons = barbuttonitems
        subnavbarItem.setRightBarButtonItems(barbuttonitems, animated: true)
        subnavBar.setItems([subnavbarItem], animated: false)
    }
}

//MARK: - Bar Button Actions
extension DocumentInitiateController {
    @objc fileprivate func titletapAction(_ sender: UITapGestureRecognizer) {
        guard let documents = createworkflowData?.Documents else { return }
        let (names, count) = DocumentHelper.sharedInstance.getdocumentNames(documents: documents)
        let contentsize = CGSize(width: 150, height: 40 * count)
        showHint(message: names, showarrow: true, contentSize: contentsize, barbutton: nil)
    }

    @objc fileprivate func cancelEsign(_ sender: UIBarButtonItem) {
        cancelDocument = true;
        showalertMessage(title: "", message: "Do you want to delete this document?", cancel: true)
    }
    
    @objc fileprivate func navbarActions(_ sender: UIBarButtonItem) {
        
        sender.image = sender.image?.tabBarImageWithCustomTint(tintColor: greencolor)
        switch sender.tag {
        case 0:
            guard let pdfdoc = self.pdfDocument else { return }
            let documentthumbnailController = DocumentThumbnailController()
            documentthumbnailController.pdfDocumet = pdfdoc
            documentthumbnailController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
            documentthumbnailController.modalPresentationStyle = .popover
            documentthumbnailController.popoverPresentationController?.delegate = self
            documentthumbnailController.popoverPresentationController?.barButtonItem = sender
            documentthumbnailController.pageSelected = { pageindex in
                self.updatebarButtons()
                self.scrolltoSelectePage(selectedIndex: pageindex)
            }
            self.present(documentthumbnailController, animated: true, completion: nil)
            return
        case 1:
            saveAction()
            return
        case 2:
            let contentsize = CGSize(width: 250, height: 50)
            showHint(message: "Download Completed", showarrow: true, contentSize: contentsize, barbutton: downloadbarbutton)
            return
        case 3:
            guard let processid = createworkflowData?.Id else { return }
            let documentattachmentController = DocumentAttachmentController()
            documentattachmentController.attachmentCallback = { count in
                self.updatebarButtons()
            }
            documentattachmentController.processID = "\(processid)"
            documentattachmentController.minimumAttachmentCount = 0
            documentattachmentController.attachmenttagId = -1
            documentattachmentController.preferredContentSize = CGSize(width: 3*UIScreen.main.bounds.width/4, height: 220)
            documentattachmentController.modalPresentationStyle = .popover
            documentattachmentController.popoverPresentationController?.delegate = self
            documentattachmentController.popoverPresentationController?.barButtonItem = sender
            self.present(documentattachmentController, animated: true, completion: nil)
            return
        case 4:
            
            let docstep = DocumentHelper.sharedInstance.updateDocumenStepValue(documentstep: documentStep, newinitiatedViews: newinitiatedViews)
            if !docstep {
                documentStep > 0 ? (documentStep -= 1) : (documentStep = 0)
            }
            
            let userpanelController = UserPanelController()
            userpanelController.initiatorContact = initiatorContact
            userpanelController.selectedContacts = selectedContacts
            userpanelController.documentStep = documentStep
            userpanelController.previousContacts = previoususers
            userpanelController.modalPresentationStyle = .popover
            userpanelController.popoverPresentationController?.delegate = self
            userpanelController.popoverPresentationController?.barButtonItem = sender
            userpanelController.preferredContentSize = CGSize(width: 300, height: 200)
            userpanelController.userpanelCallBack = { (users, docustep) in
                
                self.updatebarButtons()
                if users.count > 0 {
                    self.assignedUsers = users
                    self.previoususers = users
                    self.allthetimeContacts.append(users)
                    self.documentStep = docustep + 1
                }
            }
            
            userpanelController.addmoreContacts = { addmore in
                print(addmore)
                self.addmoreContacts()
                return
            }
            
            self.present(userpanelController, animated: true, completion: nil)
            return
        default:
            return
        }
    }
}

//MARK: Scroll to page
extension DocumentInitiateController {
    fileprivate func scrolltoSelectePage(selectedIndex: Int) {
        let index = selectedIndex + 1
        
        for pageimageview in pdfPages {
            if pageimageview.tag == index {
                DocumentHelper.sharedInstance.getdocumentScrollPosition(imageview: pageimageview, zoomScale: zoomScale) { (xposition, yposition) in
                    
                    self.pdfScrollView.setContentOffset(CGPoint(x: xposition, y: yposition), animated: true)
                }
                return
            }
        }
    }
}

// MARK: - tool panel action for touch point
extension DocumentInitiateController {
    @objc fileprivate func mainsubTapGesture(_ touch: UITapGestureRecognizer) {
        let touchpoint = touch.location(in: self.mainsubContainer)
        let toolpanelController = ToolPanelController()
        toolpanelController.toolpanelCallback = { tool in
            self.updatebarButtons()
            guard let users = self.assignedUsers else {
                if self.documentStep > 1 {
                    let contentsize = CGSize(width: 250, height: 45)
                    self.showHint(message: "Please select recipient(s)", showarrow: true, contentSize: contentsize, barbutton: self.userpanelbarbutton)
                } else {
                    let contentsize = CGSize(width: 100, height: 50)
                    self.showHint(message: "Start Here", showarrow: true, contentSize: contentsize, barbutton: self.userpanelbarbutton)
                }
                return
            }
            
            
            if let _tagtype = tool.tagtype {
                if _tagtype == 6 {
                    if let _laststep = self.newinitiatedViews.last?.step {
                        if self.documentStep != _laststep {
                            self.documentStep = _laststep
                        }
                    }
                }
            }
            
            self.setnewcustomView(step: self.documentStep, type: tool.tagtype!, users: users, x: touchpoint.x, y: touchpoint.y - 20)
        }
        
        var popovercontenSize = CGSize(width: UIScreen.main.bounds.width, height: 200)
        
        if deviceName == .pad {
            popovercontenSize = CGSize(width: UIScreen.main.bounds.width/2, height: 200)
        }
        
        toolpanelController.preferredContentSize = popovercontenSize
        toolpanelController.modalPresentationStyle = .popover
        toolpanelController.popoverPresentationController?.delegate = self
        toolpanelController.popoverPresentationController?.sourceView = mainsubContainer
        toolpanelController.popoverPresentationController?.sourceRect = CGRect(x: touchpoint.x, y: touchpoint.y, width: 0, height: 0)
        toolpanelController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
        self.present(toolpanelController, animated: true, completion: nil)
    }
}

//MARK: - Popover delegates
extension DocumentInitiateController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        updatebarButtons()
        if ((popoverPresentationController.presentedViewController as? AttachmentSettingsController) != nil) || ((popoverPresentationController.presentedViewController as? UserPanelController) != nil)  {
            return false
        }
        return true
    }
}

//MARK: ScrollView Delegats
extension DocumentInitiateController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if scrollView.tag == 0 {
            return mainsubContainer
        } else {
            return attachmentccSubContainer
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        zoomScale = scrollView.zoomScale
    }
}

//MARK: - Set Attachment view
extension DocumentInitiateController {
    fileprivate func setattachmentccView() {
        attachmentccView = UIScrollView()
        attachmentccView.translatesAutoresizingMaskIntoConstraints = false
        attachmentccView.backgroundColor = .white
        attachmentccView.isHidden = true
        attachmentccView.delegate = self
        attachmentccView.tag = 1
        attachmentccView.maximumZoomScale = 2.0
        attachmentccView.minimumZoomScale = 0.4
        
        let safearea = view.safeAreaLayoutGuide
        
        view.addSubview(attachmentccView)
        let attachmentccviewConstraints = [attachmentccView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                           attachmentccView.bottomAnchor.constraint(equalTo: safearea.bottomAnchor),
                                           attachmentccView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                           attachmentccView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(attachmentccviewConstraints)
        attachmentccView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: 40)
        
        let attachmentContent = attachmentccView.contentSize
        print("attachment content size : \(attachmentContent)")
        attachmentccSubContainer = UIView(frame: CGRect(x: 10, y: 0, width: attachmentContent.width, height: attachmentContent.height))
        attachmentccSubContainer.backgroundColor = .clear
        attachmentccView.addSubview(attachmentccSubContainer)
        
        setdocumenttoFit(scrollview: attachmentccView)
    }
}

//MARK: - remove attachment cc view
extension DocumentInitiateController {
    fileprivate func displayhideAttachmentCCview() {
        let isccorattachmentexists = DocumentHelper.sharedInstance.isccorattachmentExists(newinitiatedViews: newinitiatedViews)
        if isccorattachmentexists {
            attachmentccView.isHidden = false
            pdfviewbottomConstraint = pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40)
            pdfviewbottomConstraint.isActive = true
            return
        }
        attachmentccView.isHidden = true
        pdfviewbottomConstraint = pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        pdfviewbottomConstraint.isActive = true
        return
    }
}

//MARK: Setup New Custom Views
extension DocumentInitiateController {
    fileprivate func setnewcustomView(step: Int, type: Int, users: [ContactDetailsViewModel], x: CGFloat, y: CGFloat) {
        
        switch type {
        case 6:
            let (newviewis, errmessage) = DocumentHelper.sharedInstance.initiatenewTokenView(step: self.newinitiatedViews.last?.step ?? step, tagtype: type, users: users, xposition: x, yposition: y, newinitiatedviews: newinitiatedViews)
            
            guard let newview = newviewis as? ZorroDocumentInitiateBaseView else {
                let contentsize = CGSize(width: 200, height: 100)
                showHint(message: errmessage!, showarrow: true, contentSize: contentsize, barbutton: donebarbutton)
                return
            }
            
            newview.draggableCallBack = { draggedview in
                DocumentHelper.sharedInstance.checktoolcoordinatesareValid(newinitiatedview: draggedview, pages: self.pdfPages, zoomscal: self.zoomScale)
            }
            
            newview.viewresizeCallBack = { (scroll, resizedview) in
                self.pdfScrollView.isScrollEnabled = scroll
            }
            
            newview.closebuttonCallBack = { (view, tagtempid, step) in
                
                view.removeFromSuperview()
                
                let filterredviews = DocumentHelper.sharedInstance.initiateUpdateSteps(initiatedViews: self.newinitiatedViews, step: step, tempid: tagtempid)
                self.newinitiatedViews = filterredviews
                
                if let _lstep = self.newinitiatedViews.last?.step {
                    self.documentStep = _lstep
                    if let _lusers = self.newinitiatedViews.last?.contactDetails {
                        self.assignedUsers = nil
                        self.previoususers = _lusers
                    }
                }
            }
            
            newview.backgroundColor = .clear
            mainsubContainer.addSubview(newview)
            newinitiatedViews.append(newview)
            updatestepwithToken()
            updatetoolwithXPosition(draggedview: newview)
            return
        case 8:
            print("note count : \(noteCount)")
            let newview = DocumentHelper.sharedInstance.initiateNewView(step: noteCount, tagtype: type, users: users, xposition: x, yposition: y) as! ZorroDocumentInitiateBaseView
            
            newview.draggableCallBack = { draggedview in
                DocumentHelper.sharedInstance.checktoolcoordinatesareValid(newinitiatedview: draggedview, pages: self.pdfPages, zoomscal: self.zoomScale)
            }
            
            newview.viewresizeCallBack = { (scroll, resizedview) in
                self.pdfScrollView.isScrollEnabled = scroll
            }
            
            newview.closebuttonCallBack = { (view, tagtempid, step) in
                view.removeFromSuperview()
                self.newinitiatedDynamicNoteViews = DocumentHelper.sharedInstance.initiateUpdateDynamicNote(initiatedynamicnoteViews: self.newinitiatedDynamicNoteViews, tempid: tagtempid, step: step)
                if self.noteCount > 1 {
                    self.noteCount -= 1
                }
            }
            
            mainsubContainer.addSubview(newview)
            newinitiatedDynamicNoteViews.append(newview)
            noteCount += 1
            updatetoolwithXPosition(draggedview: newview)
            return
        case 9,12:
            let (newviewis, errmessage) = DocumentHelper.sharedInstance.initiatenewattachmentccView(step: step, tagtype: type, users: users, newviews: newinitiatedViews)
            
            let newview = newviewis as? ZorroDocumentInitiateBaseView
            
            guard let newlyaddedview = newview else {
                print(errmessage!)
                let contentsize = CGSize(width: 200, height: 100)
                showHint(message: errmessage!, showarrow: true, contentSize: contentsize, barbutton: donebarbutton)
                return
            }
            
            newlyaddedview.closebuttonCallBack = { (tagview, tagtempid, step) in
 
                tagview.removeFromSuperview()
                let filterredviews = DocumentHelper.sharedInstance.initiateUpdateSteps(initiatedViews: self.newinitiatedViews, step: step, tempid: tagtempid)
                
                if let _laststep = self.newinitiatedViews.last?.step {
                    if _laststep == step {
                        if let _filterredlaststep = filterredviews.last?.step {
                            
                            if _filterredlaststep == 1 {
                                if let _filterredusers = filterredviews.last?.contactDetails {
                                    self.previoususers = _filterredusers
                                    self.assignedUsers = _filterredusers
                                }
                            } else {
                                let _users = tagview.contactDetails
                                if let _step = tagview.step  {
                                    self.assignedUsers = nil
                                    self.documentStep = _step
                                    self.previoususers = _users
                                    self.assignedUsers = _users
                                }
                            }
                        }
                    } else {
                        if let _laststepusers = self.newinitiatedViews.last?.contactDetails {
                            self.assignedUsers = nil
                            _laststep > 0 ? (self.documentStep = _laststep - 1) : (self.documentStep = _laststep)
                            self.previoususers = _laststepusers
                            self.assignedUsers = _laststepusers
                        }
                    }
                }
                
                self.newinitiatedViews = filterredviews
                self.displayhideAttachmentCCview()
            }
            
            newlyaddedview.settingsCallBack = { (tagview, tagtype) in
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    let attachmentsettingsController = AttachmentSettingsController()
                    attachmentsettingsController.attachmentokCallBack = { (doccount, description) in
                        print("document count : \(doccount)")
                        print("description : \(description)")
                    }
                    attachmentsettingsController.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 250)
                    attachmentsettingsController.modalPresentationStyle = .popover
                    attachmentsettingsController.popoverPresentationController?.delegate = self
                    attachmentsettingsController.popoverPresentationController?.sourceView = self.view
                    
                    let yvalue = self.deviceHeight - 50
                    
                    
                    attachmentsettingsController.popoverPresentationController?.sourceRect = CGRect(x: tagview.bounds.midX, y: yvalue, width: 0, height: 0)
                    attachmentsettingsController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
                    self.present(attachmentsettingsController, animated: true, completion: nil)
                })
            }
            
            attachmentccSubContainer.addSubview(newlyaddedview)
            newinitiatedViews.append(newlyaddedview)
            displayhideAttachmentCCview()
            
            if type == 12 {
                SharingManager.sharedInstance.triggeronAttachmentCrate(created: true)
            }
            updatestepwithToken()
            return
        case 14:
            let newview = DocumentHelper.sharedInstance.initiateNewView(step: step, tagtype: type, users: users, xposition: x, yposition: y) as! ZorroDocumentInitiateBaseView
            
            newview.draggableCallBack = { draggedview in
                DocumentHelper.sharedInstance.checktoolcoordinatesareValid(newinitiatedview: draggedview, pages: self.pdfPages, zoomscal: self.zoomScale)
            }
            
            newview.viewresizeCallBack = { (scroll, resizedview) in
                self.pdfScrollView.isScrollEnabled = scroll
            }
        
            newview.closebuttonCallBack = { (view, tagtempid, step) in
                view.removeFromSuperview()
                let filterredtextViews = DocumentHelper.sharedInstance.initiateUpdateDynamicText(initiateddynamicViews: self.newinitiatedDynamicTextViews, tempid: tagtempid)
                self.newinitiatedDynamicTextViews = filterredtextViews
            }
            mainsubContainer.addSubview(newview)
            newinitiatedDynamicTextViews.append(newview)
            updatetoolwithXPosition(draggedview: newview)
            return
        default:
            let newview = DocumentHelper.sharedInstance.initiateNewView(step: step, tagtype: type, users: users, xposition: x, yposition: y) as! ZorroDocumentInitiateBaseView
            
            newview.draggableCallBack = { draggedview in
                DocumentHelper.sharedInstance.checktoolcoordinatesareValid(newinitiatedview: draggedview, pages: self.pdfPages, zoomscal: self.zoomScale)
            }
            
            newview.viewresizeCallBack = { (scroll, resizedview) in
                self.pdfScrollView.isScrollEnabled = scroll
            }
            
            newview.closebuttonCallBack = { (view, tagtempid, step) in
               
                view.removeFromSuperview()
                let filterredviews = DocumentHelper.sharedInstance.initiateUpdateSteps(initiatedViews: self.newinitiatedViews, step: step, tempid: tagtempid)

                if let _laststep = self.newinitiatedViews.last?.step {
                    if _laststep == step {
                        
                        if let _filterredlaststep = filterredviews.last?.step {
                            
                            if _filterredlaststep == 1 {
                                if let _filterredusers = filterredviews.last?.contactDetails {
                                    self.previoususers = _filterredusers
                                    self.assignedUsers = _filterredusers
                                    self.documentStep = _filterredlaststep
                                }
                            } else {
                                let _users = view.contactDetails
                                if let _step = view.step  {
                                    self.assignedUsers = nil
                                    self.documentStep = _step
                                    self.previoususers = _users
                                    self.assignedUsers = _users
                                }
                            }
                        }
                    } else {
                        if let _laststepusers = self.newinitiatedViews.last?.contactDetails {
                            self.assignedUsers = nil
                            _laststep > 0 ? (self.documentStep = _laststep - 1) : (self.documentStep = _laststep)
                            self.previoususers = _laststepusers
                            self.assignedUsers = _laststepusers
                        }
                    }
                }
                
                self.newinitiatedViews = filterredviews
                
            }
            
            newview.backgroundColor = .clear
            mainsubContainer.addSubview(newview)
            newinitiatedViews.append(newview)
            showdoneHint()
            updatestepwithToken()
            updatetoolwithXPosition(draggedview: newview)
            return
        }
    }
}

//MARK: - show hint popup
extension DocumentInitiateController {
    fileprivate func showHint(message: String, showarrow: Bool, contentSize: CGSize, barbutton: UIBarButtonItem?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            let hintController = HintController()
            hintController.hintmessage = message
            hintController.modalPresentationStyle = .popover
            hintController.popoverPresentationController?.delegate = self
            hintController.preferredContentSize = contentSize
            if barbutton != nil {
                hintController.popoverPresentationController?.barButtonItem = barbutton
            } else {
                hintController.popoverPresentationController?.sourceView = self.view
                hintController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: 64, width: 0, height: 0)
                hintController.popoverPresentationController?.permittedArrowDirections = [.up, .down]
                if !showarrow {
                    hintController.popoverPresentationController?.permittedArrowDirections = []
                }
            }
            self.present(hintController, animated: true, completion: nil)
        }
    }
}

//MARK: - Manage Sharings
extension DocumentInitiateController {
    fileprivate func updateStamp() {
        let stamp = ZorroTempData.sharedInstance.getStamp()
        if stamp == "" {
            SharingManager.sharedInstance.onstampTouch?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
                tapped in
                
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
}

//MARK: --- pass data forward to final controller
extension DocumentInitiateController {
    @objc fileprivate func saveAction() {
        showbackDrop()
        let isvalid = DocumentHelper.sharedInstance.numberofTags(newinitiatedviews: newinitiatedViews)
        if isvalid {
            
            let _otpactivateSettings = OTPActivateSettings()
            _otpactivateSettings.approvalotpType { (approvalType) in
                let documentinitiatesaveWorkflowController = DocumentInitiateSaveWorkflowController(zoomscale: self.zoomScale)
                documentinitiatesaveWorkflowController.newInitiatedViews = self.newinitiatedViews
                documentinitiatesaveWorkflowController.newInitiatedDynamictextViews = self.newinitiatedDynamicTextViews
                documentinitiatesaveWorkflowController.newInitiatedDynamicnoteViews = self.newinitiatedDynamicNoteViews
                documentinitiatesaveWorkflowController.documentPages = self.pdfPages
                documentinitiatesaveWorkflowController.getWorkFlowData = self.createworkflowData
                documentinitiatesaveWorkflowController.otpapprovalType = approvalType
                self.navigationController?.pushViewController(documentinitiatesaveWorkflowController, animated: true)
                self.hidebackDrop()
                return
            }
            return
        }
        hidebackDrop()
        let contentsize = CGSize(width: 200, height: 100)
        showHint(message: "Cannot approve a document without any user assigned tags", showarrow: true, contentSize: contentsize, barbutton: donebarbutton)
        return
    }
}

//MARK: -- show hint at the beginning
extension DocumentInitiateController {
    fileprivate func showstartHint() {
        let content = CGSize(width: 100, height: 50)
        showHint(message: "Start Here", showarrow: true, contentSize: content, barbutton: userpanelbarbutton)
        return
    }
}

//MARK: update navbaricons
extension DocumentInitiateController {
    fileprivate func updatebarButtons() {
        
        if navbarButtons != nil {
            for (index, item) in navbarButtons.enumerated() {
                if barbuttons.indices.contains(index) {
                    item.image = UIImage(named: barbuttons[index])
                }
            }
        }
    }
}

//MARK: show done hint
extension DocumentInitiateController {
    fileprivate func showdoneHint() {
        if documentStep == 1 && newinitiatedViews.count > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let contentSize = CGSize(width: 100, height: 40)
                self.showHint(message: "Done", showarrow: true, contentSize: contentSize, barbutton: self.donebarbutton)
            }
        }
    }
}

//MARK: - update step number with token
extension DocumentInitiateController {
    fileprivate func updatestepwithToken() {
        let filterredviews = DocumentHelper.sharedInstance.updateStepwithToken(initiatedView: self.newinitiatedViews, step: documentStep)
        self.newinitiatedViews = filterredviews
    }
}

//MARK: - update for valid x value
extension DocumentInitiateController {
    fileprivate func updatetoolwithXPosition(draggedview: ZorroDocumentInitiateBaseView) {
        DocumentHelper.sharedInstance.checktoolcoordinatesareValid(newinitiatedview: draggedview, pages: self.pdfPages, zoomscal: self.zoomScale)
    }
}

//MARK: - add more contacts
extension DocumentInitiateController {
    fileprivate func addmoreContacts() {
        DispatchQueue.main.async {
            let documentinitiatecontactController = DocumentInitiateContactsController()
            documentinitiatecontactController.frominitiatePage = true
            documentinitiatecontactController.addMoreCallBack = { morecontact in
                
                self.selectedContacts = DocumentHelper.sharedInstance.removeduplicateContats(selectedcontacts: self.selectedContacts, morecontacts: morecontact)
               
            }
            self.navigationController?.pushViewController(documentinitiatecontactController, animated: true)
        }
    }
}


