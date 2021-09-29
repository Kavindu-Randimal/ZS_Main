//
//  DocumentAttachmentController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 7/11/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class DocumentAttachmentController: UIViewController {
    
    var docProcess: DocProcess!
    var processID: String!
    var minimumAttachmentCount: Int!
    var attachmenttagId: Int!
    var attachmentCallback: ((Int) -> ())?
    
    var required: Bool!
    var docAttachments: [DocAttachments] = []
    var docAttachmentsOptional: [DocAttachments] = []
    
    private var initialcontentHeight: CGFloat!
    
    private var containerView: UIView!
    
    private var headerView: UIView!
    private var headerTitle: UILabel!
    private var headerbottomLine: UIView!
    
    private var footerView: UIView!
    private var footertopLine: UIView!
    private var uploadButton: UIButton!
    private var cancelButton: UIButton!
    
    private var attachmentTableView: UITableView!
    private let defaultcell = "cellidentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setintialHeight()
        print("view content size : \(self.preferredContentSize)")
        setContainer()
        setHeader()
        setFooter()
        setAttachmentList()
        fetchlatestfromAPI()
    }
}

extension DocumentAttachmentController {
    fileprivate func setintialHeight() {
        initialcontentHeight = self.preferredContentSize.height
    }
}

extension DocumentAttachmentController {
    fileprivate func setContainer() {
        
        let viewwidth = self.preferredContentSize.width
        let viewheight = self.preferredContentSize.height
        
        containerView = UIView(frame: CGRect(x: 0, y: 20, width: viewwidth, height: viewheight))
        containerView.backgroundColor = .white
        view.addSubview(containerView)
    }
}

extension DocumentAttachmentController {
    fileprivate func setHeader() {
        
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        containerView.addSubview(headerView)
        
        let headerviewConstraints = [headerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                     headerView.topAnchor.constraint(equalTo: containerView.topAnchor),
                                     headerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                     headerView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(headerviewConstraints)
        
        headerbottomLine = UIView()
        headerbottomLine.translatesAutoresizingMaskIntoConstraints = false
        headerbottomLine.backgroundColor = .black
        headerView.addSubview(headerbottomLine)
        
        let headerbottomConstraints = [headerbottomLine.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 2),
                                       headerbottomLine.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -2),
                                       headerbottomLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
                                       headerbottomLine.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(headerbottomConstraints)
        
        headerTitle = UILabel()
        headerTitle.translatesAutoresizingMaskIntoConstraints = false
        headerTitle.textAlignment = .left
        headerTitle.font = UIFont(name: "Helvetica", size: 20)
        headerTitle.text = "ATTACH DOCUMENT(S)"
        headerView.addSubview(headerTitle)
        
        let headertitleConstraints = [headerTitle.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
                                      headerTitle.topAnchor.constraint(equalTo: headerView.topAnchor),
                                      headerTitle.rightAnchor.constraint(equalTo: headerView.rightAnchor),
                                      headerTitle.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)]
        
        NSLayoutConstraint.activate(headertitleConstraints)
    }
}

extension DocumentAttachmentController {
    fileprivate func setFooter() {
        
        footerView = UIView()
        footerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.backgroundColor = .white
        containerView.addSubview(footerView)
        
        let footerviewConstraints = [footerView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                     footerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                                     footerView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                     footerView.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(footerviewConstraints)
        
        footertopLine = UIView()
        footertopLine.translatesAutoresizingMaskIntoConstraints = false
        footertopLine.backgroundColor = .black
        footerView.addSubview(footertopLine)
        
        let footertoplineConstraints = [footertopLine.leftAnchor.constraint(equalTo: footerView.leftAnchor, constant: 2),
                                        footertopLine.topAnchor.constraint(equalTo: footerView.topAnchor),
                                        footertopLine.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -2),
                                        footertopLine.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(footertoplineConstraints)
        
        let greencolor = ColorTheme.btnBG
        
        uploadButton = UIButton()
        uploadButton.translatesAutoresizingMaskIntoConstraints = false
        uploadButton.backgroundColor = greencolor
        uploadButton.setTitle("UPLOAD", for: .normal)
        uploadButton.setTitleColor(.white, for: .normal)
        footerView.addSubview(uploadButton)
        
        let uploadbuttonConstraints = [uploadButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
                                       uploadButton.rightAnchor.constraint(equalTo: footerView.rightAnchor, constant: -10),
                                       uploadButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -5),
                                       uploadButton.widthAnchor.constraint(equalToConstant: 100)]
        NSLayoutConstraint.activate(uploadbuttonConstraints)
        
        uploadButton.layer.masksToBounds = true
        uploadButton.layer.cornerRadius = 5
        
        uploadButton.addTarget(self, action: #selector(uploadAction(_:)), for: .touchUpInside)
        
        cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.backgroundColor = .white
        cancelButton.setTitle("CANCEL", for: .normal)
        cancelButton.setTitleColor(greencolor, for: .normal)
        footerView.addSubview(cancelButton)
        
        let cancelButtonConstraints = [cancelButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 5),
                                       cancelButton.rightAnchor.constraint(equalTo: uploadButton.leftAnchor, constant: -10),
                                       cancelButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -5),
                                       cancelButton.widthAnchor.constraint(equalToConstant: 100)]
        NSLayoutConstraint.activate(cancelButtonConstraints)
        
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderColor = greencolor.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 5
        
        cancelButton.addTarget(self, action: #selector(cancelFunction(_:)), for: .touchUpInside)
    }
}

//MARK: - Button Function
extension DocumentAttachmentController {
    @objc fileprivate func uploadAction(_ sender: UIButton) {
        
        let upload = DocumentHelper.sharedInstance.shouldupload(docattachments: docAttachments, optionalattachments: docAttachmentsOptional)
        if upload {
            uploadAttachedFiles()
        }
    }
    
    @objc fileprivate func cancelFunction(_ sender: UIButton) {
        let requiredcount = DocumentHelper.sharedInstance.ensureAttachmentCount(docattachments: docAttachments)
        attachmentCallback!(requiredcount)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: Setup Attachment List Table View
extension DocumentAttachmentController {
    fileprivate func setAttachmentList() {
        
        attachmentTableView = UITableView(frame: .zero, style: .plain)
        attachmentTableView.register(DocAttachmentCell.self, forCellReuseIdentifier: defaultcell)
        attachmentTableView.translatesAutoresizingMaskIntoConstraints = false
        attachmentTableView.tableFooterView = UIView()
        attachmentTableView.backgroundColor = .white
        attachmentTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        attachmentTableView.dataSource = self
        attachmentTableView.delegate = self
        containerView.addSubview(attachmentTableView)
        
        let attachmenttableviewConstraints = [attachmentTableView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
                                              attachmentTableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                                              attachmentTableView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
                                              attachmentTableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)]
        
        NSLayoutConstraint.activate(attachmenttableviewConstraints)
    }
}

extension DocumentAttachmentController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return docAttachments.count
        case 1:
            return docAttachmentsOptional.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let attachmentcell = tableView.dequeueReusableCell(withIdentifier: defaultcell) as! DocAttachmentCell
        
        switch indexPath.section {
        case 0:
            let singledocattachment = docAttachments[indexPath.row]
            attachmentcell.docattachment = singledocattachment
            attachmentcell.buttonIndex = indexPath.row
            attachmentcell.cellCallback = { selectedindex in
                print("selected index is : \(selectedindex)")
                self.deleteAttachment(atsection: indexPath.section, row: selectedindex)
            }
        case 1:
            let singledocattachmentoptional = docAttachmentsOptional[indexPath.row]
            attachmentcell.docattachment = singledocattachmentoptional
            attachmentcell.buttonIndex = indexPath.row
            attachmentcell.cellCallback = { selectedindex in
                print("selected index is : \(selectedindex)")
                self.deleteAttachment(atsection: indexPath.section, row: selectedindex)
            }
        default:
            return attachmentcell
        }
        
        return attachmentcell
    }
}

extension DocumentAttachmentController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            if minimumAttachmentCount == 0 {
                return 50
            } else {
                return 70
            }
        case 1:
            if minimumAttachmentCount == 0 {
                return 0
            } else {
                return 70
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerview = UIView(frame: CGRect(x: 0, y: 0, width: self.preferredContentSize.width, height: 70))
        headerview.backgroundColor = .white
        
        let greencolor = ColorTheme.btnBG
       
        
        let buttoncontainer = UIView()
        buttoncontainer.translatesAutoresizingMaskIntoConstraints = false
        buttoncontainer.backgroundColor = .white
        headerview.addSubview(buttoncontainer)
        
        let buttoncontainerconstraints = [buttoncontainer.topAnchor.constraint(equalTo: headerview.topAnchor, constant: 5),
                                          buttoncontainer.rightAnchor.constraint(equalTo: headerview.rightAnchor, constant: -5),
                                          buttoncontainer.widthAnchor.constraint(equalToConstant: 100),
                                          buttoncontainer.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(buttoncontainerconstraints)
        
        
        let addiconlabel = UILabel()
        addiconlabel.translatesAutoresizingMaskIntoConstraints = false
        addiconlabel.textColor = greencolor
        addiconlabel.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        addiconlabel.text = String.fontAwesomeIcon(name: .plusSquare)
        
        buttoncontainer.addSubview(addiconlabel)
        
        let addiconlabelconstraints = [addiconlabel.leftAnchor.constraint(equalTo: buttoncontainer.leftAnchor, constant: 5),
                                       addiconlabel.topAnchor.constraint(equalTo: buttoncontainer.topAnchor),
                                       addiconlabel.bottomAnchor.constraint(equalTo: buttoncontainer.bottomAnchor),
                                       addiconlabel.widthAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(addiconlabelconstraints)
        
        let addlabel = UILabel()
        addlabel.translatesAutoresizingMaskIntoConstraints = false
        addlabel.textColor = greencolor
        addlabel.text = "ADD"
        addlabel.textAlignment = .left
        
        buttoncontainer.addSubview(addlabel)
        
        let addlabelconstraints = [addlabel.leftAnchor.constraint(equalTo: addiconlabel.rightAnchor, constant: 5),
                                   addlabel.topAnchor.constraint(equalTo: buttoncontainer.topAnchor),
                                   addlabel.rightAnchor.constraint(equalTo: buttoncontainer.rightAnchor),
                                   addlabel.bottomAnchor.constraint(equalTo: buttoncontainer.bottomAnchor)]
        
        NSLayoutConstraint.activate(addlabelconstraints)
        
        let attachbutton = UIButton()
        attachbutton.translatesAutoresizingMaskIntoConstraints = false
        attachbutton.tag = section
        attachbutton.backgroundColor = .clear
        buttoncontainer.addSubview(attachbutton)

        let attachbuttonconstraints = [attachbutton.topAnchor.constraint(equalTo: buttoncontainer.topAnchor),
                                       attachbutton.rightAnchor.constraint(equalTo: buttoncontainer.rightAnchor),
                                       attachbutton.leftAnchor.constraint(equalTo: buttoncontainer.leftAnchor),
                                       attachbutton.bottomAnchor.constraint(equalTo: buttoncontainer.bottomAnchor)]

        NSLayoutConstraint.activate(attachbuttonconstraints)

        buttoncontainer.layer.masksToBounds = true
        buttoncontainer.layer.cornerRadius = 5
        buttoncontainer.layer.borderColor = greencolor.cgColor
        buttoncontainer.layer.borderWidth = 1

        attachbutton.addTarget(self, action: #selector(attachDocument(_:)), for: .touchUpInside)

        let headertitle = UILabel()
        headertitle.translatesAutoresizingMaskIntoConstraints = false
        headertitle.textAlignment = .left
        headertitle.font = UIFont(name: "Helvetica", size: 18)
        headerview.addSubview(headertitle)

        let headertitleconstraints = [headertitle.leftAnchor.constraint(equalTo: headerview.leftAnchor, constant: 10),
                                      headertitle.topAnchor.constraint(equalTo: headerview.topAnchor, constant: 5),
                                      headertitle.rightAnchor.constraint(equalTo: attachbutton.leftAnchor)]

        NSLayoutConstraint.activate(headertitleconstraints)
        
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.textAlignment = .left
        subtitle.font = UIFont(name: "Helvetica", size: 16)
        headerview.addSubview(subtitle)
        
        let subtitleconstraints = [subtitle.leftAnchor.constraint(equalTo: headerview.leftAnchor, constant: 10),
                                   subtitle.topAnchor.constraint(equalTo: attachbutton.bottomAnchor, constant: 5),
                                   subtitle.rightAnchor.constraint(equalTo: headerview.rightAnchor)]
        
        NSLayoutConstraint.activate(subtitleconstraints)
        
        
        switch section {
        case 0:
            let docattachmentcount = docAttachments.count
            
            if minimumAttachmentCount == 0 {
                headertitle.text = "add attachment"
                subtitle.text = ""
            } else {
                if docattachmentcount >= minimumAttachmentCount {
                    attachbutton.isEnabled = false
                }
                headertitle.text = "REQUIRED (\(minimumAttachmentCount!)) *"
                subtitle.text = "add attachments"
            }
        case 1:
            
            let topline = UIView()
            topline.translatesAutoresizingMaskIntoConstraints = false
            topline.backgroundColor = .black
            
            headerview.addSubview(topline)
            
            let toplineconstraints = [topline.leftAnchor.constraint(equalTo: headerview.leftAnchor, constant: 5),
                                      topline.topAnchor.constraint(equalTo: headerview.topAnchor),
                                      topline.rightAnchor.constraint(equalTo: headerview.rightAnchor, constant:  -5),
                                      topline.heightAnchor.constraint(equalToConstant: 1)]

            NSLayoutConstraint.activate(toplineconstraints)
            
            headertitle.text = "OPTIONAL"
            subtitle.text = "Please upload additional document(s)"
        default:
           headertitle.text = ""
        }
       
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

// MARK: - Setup document picker
extension DocumentAttachmentController {
    @objc fileprivate func attachDocument(_ sender: UIButton) {
        print("Working : \(sender.tag)")
        
        switch sender.tag {
        case 0:
            print("permanant")
            required = true
        case 1:
            print("optional")
            required = false
        default:
            return
        }
        
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
}

//MARK: - Document Picker Delegates
extension DocumentAttachmentController: UIDocumentPickerDelegate, UINavigationControllerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        print("Selected Documents  :---> \(urls)")
        let documentName = urls[0].lastPathComponent
        
        let newattachment = DocAttachments(Id: 0, ObjectId: "", DocType: 1, Name: documentName, IsDeletable: true, CreatedBy: 0, AttachedUserProfileId: 0, PageCount: 0, IsPermanent: required, SubStepId: 0, isUploaded: false, fileUrl: urls[0])
        
        if required {
            docAttachments.append(newattachment)
        } else {
            docAttachmentsOptional.append(newattachment)
        }
        
        updateUIIncrease()
        
    }
}

extension DocumentAttachmentController {
    fileprivate func fetchlatestfromAPI() {
        
        let connectivity = Connectivity.isConnectedToInternet()
        
        if !connectivity {
            setInteraction()
            DispatchQueue.main.async {
                self.alertSample(strTitle: "Connection !", strMsg: "Internet connection appears to be offline, Please check your internet connection and try again !")
            }
            return
        }
        
        ZorroHttpClient.sharedInstance.getDocumentProcessDetails(instanceID: processID) { (docprocess, err) in
            
            guard let documentprocess = docprocess else { return }
            self.docProcess = documentprocess
            self.fetchinitialAttachmentDetails()
            
            // Check for unsupported tools and go back
            self.checkForUnsupportedTools()
        }
    }
}


//MARK: - Fetch existing attachment details
extension DocumentAttachmentController {
    fileprivate func fetchinitialAttachmentDetails() {
        guard let documents = docProcess.data?.documents else { return }
        
        docAttachments = []
        docAttachmentsOptional = []
        
        var numberofitems: Int = 0
        
        for document in documents {
            if document.docType != 0 {
                let newattachment = DocAttachments(Id: document.id, ObjectId: document.objectID, DocType: document.docType, Name: document.name, IsDeletable: document.isDeletable, CreatedBy: 0, AttachedUserProfileId: document.attachedUserProfileID, PageCount: document.pageCount, IsPermanent: document.isPermanent, SubStepId: 0, isUploaded: true, fileUrl: nil)
                
                if newattachment.IsPermanent! {
                    docAttachments.append(newattachment)
                } else {
                    docAttachmentsOptional.append(newattachment)
                }
                numberofitems += 1
            }
        }
        
        setintialcontentHeight(numberofItems: numberofitems)
    }
}

//MARK: - Set Initial Height
extension DocumentAttachmentController {
    fileprivate func setintialcontentHeight(numberofItems: Int) {
        DispatchQueue.main.async {
            self.attachmentTableView.reloadData()
            let maximumHeight = 3 * UIScreen.main.bounds.height/4
            let newHeight = self.initialcontentHeight + 40 * CGFloat(numberofItems)
            
            if newHeight < maximumHeight {
                self.preferredContentSize.height = newHeight
                self.containerView.frame.size.height = newHeight
            } else {
                self.preferredContentSize.height = maximumHeight
                self.containerView.frame.size.height = maximumHeight
            }
        }
    }
}

//MARK: - Increase the content height
extension DocumentAttachmentController {
    fileprivate func updateUIIncrease() {
        DispatchQueue.main.async {
            self.attachmentTableView.reloadData()
            
            let maximumHeight = 3 * UIScreen.main.bounds.height/4
            let currentHeight = self.preferredContentSize.height
            
            if currentHeight < maximumHeight {
                self.preferredContentSize.height += 40
                self.containerView.frame.size.height  += 40
            }
        }
    }
}

//MARK: - Decrease the content height
extension DocumentAttachmentController {
    fileprivate func updateUIDecrease(byreloading section: Int) {

        DispatchQueue.main.async {
            let minimumHeight = self.initialcontentHeight!
            let currentHeight = self.preferredContentSize.height
            
            if minimumHeight < currentHeight {
                self.preferredContentSize.height -= 40
                self.containerView.frame.size.height -= 40
            }
            self.attachmentTableView.reloadSections([1], with: .automatic)
        }
    }
}

//MARK: - Delete attachment
extension DocumentAttachmentController {
    fileprivate func deleteAttachment(atsection section: Int, row: Int) {
        
        var selectedItem : DocAttachments!
        
        switch section {
        case 0:
            let selecteditem = docAttachments[row]
            selectedItem = selecteditem
        case 1:
            let selecteditem = docAttachmentsOptional[row]
            selectedItem = selecteditem
        default:
            return
        }
        
        if !selectedItem.isUploaded! {
            self.removeAttachments(in: section, at: row)
        } else {
            guard let processid = processID else { return }
            guard let objectid = selectedItem.ObjectId else { return }
            guard let tagid = attachmenttagId else { return }
            
            var tagidstring = "\(tagid)"
            if minimumAttachmentCount == 0 {
                guard let substepid = selectedItem.SubStepId else { return }
                tagidstring = "\(substepid)"
            }
            
            let docattachment = DocAttachments()
            docattachment.deleteAttachment(processid: processid, objectid: objectid, tagid: tagidstring) { (success) in
                if success {
                    self.removeAttachments(in: section, at: row)
                    return
                }
                return
            }
        }
    }
}


//MARK: - Remove Items at index
extension DocumentAttachmentController {
    fileprivate func removeAttachments(in section:Int, at index: Int) {
        
        switch section {
        case 0:
            let indexpath = IndexPath(row: index, section: section)
            docAttachments.remove(at: index)
            self.attachmentTableView.deleteRows(at: [indexpath], with: .automatic)
        case 1:
            let indexpath = IndexPath(row: index, section: section)
            docAttachmentsOptional.remove(at: index)
            self.attachmentTableView.deleteRows(at: [indexpath], with: .automatic)
        default:
            return
        }
        updateUIDecrease(byreloading: section)
    }
}

//MARK: - Upload attachements
extension DocumentAttachmentController {
    fileprivate func uploadAttachedFiles() {
        
        removeInteraction()
        
        let connectivity = Connectivity.isConnectedToInternet()

        if !connectivity {
            setInteraction()
            DispatchQueue.main.async {
                 self.alertSample(strTitle: "Connection !", strMsg: "Internet connection appears to be offline, Please check your internet connection and try again !")
            }
            return
        }

        let docattachment = DocAttachments()
        docattachment.uploadFilesQueue(processid: self.processID, mandatoryAttachments: docAttachments, optionalAttachments: docAttachmentsOptional) { (success) in
            print(success)
            DispatchQueue.main.async {
                self.fetchlatestfromAPI()
                self.setInteraction()
                let requiredcount = DocumentHelper.sharedInstance.ensureAttachmentCount(docattachments: self.docAttachments)
                self.attachmentCallback!(requiredcount)
                self.alertSample(strTitle: "Success", strMsg: "Attachment(s) Uploaded Successfully")
            }
        }
    }
}

//MARK: Helper function to set and remove interaction
extension DocumentAttachmentController {
    fileprivate func removeInteraction() {
        self.view.isUserInteractionEnabled = false
    }
    
    fileprivate func setInteraction() {
        self.view.isUserInteractionEnabled = true
    }
}

// MARK: - Check For Unsupported Tools

extension DocumentAttachmentController {
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
