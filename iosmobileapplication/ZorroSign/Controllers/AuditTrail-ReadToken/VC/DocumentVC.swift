//
//  DocumentVC.swift
//  ZorroSign
//
//  Updated by Anuradh Caldera on 5/27/19.
//  Copyright © 2019 ZorroSign. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import QRCodeReader
import MapKit

class DocumentVC: Loader, QRCodeReaderViewControllerDelegate, UITextFieldDelegate {
    
    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
        }
        return QRCodeReaderViewController(builder: builder)
    }()

    //MARK: - New outlet connections
    @IBOutlet weak var documenttrailNavBar: UINavigationItem!
    
    //MARK: - New Implementation
    private var documentdownloadView: UIView!
    private var documentname: UILabel!
    private var restartedId: UILabel!
    private var documentnameValue: UILabel!
    private var documentdownloadIcon: UIImageView!
    private var documentdownlodButton: UIButton!
    private var changetimezoneView: UIView!
    private var topseparatorView: UIView!
    private var timezonename: UILabel!
    private var timezonenameValue: UILabel!
    private var changetimezoneIcon: UIImageView!
    private var changetimezoneButton: UIButton!
    private var documenttrailTableView: UITableView!
    private var documenttraildefaultcellId = "documenttrailcellid"
    private var documenttrailstartCellid = "documenttarilstartcellid"
    private var documenttrailstartCellkbaid = "documenttrailstartCellkbaid"
    private var documenttraildetailCellid = "documenttraildetailcellid"
    private var documenttrailsignatureCellid = "documenttrailsignaturecellid"
    private var documenttraildownloadCellid = "documenttraildownloadcellid"
    private var documenttraildownloadattachmentCellid = "documenttraildownloadattachmentcellid"
    
    private var documentdownloadviewConstraints: Array<NSLayoutConstraint>!
    
    private var processid: Int!
    private var qrcodestring: String!
    private var chainofcustody: ChainofCustody?
    private var chainofsignature: ChainofSignature?
    private var chainofdocument: ChainofDocument?
    private var chainofattachment: ChainofAttachment?
    private var renamehistory: RenameDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
        
        setNavBarButton()
        checkExistingToken()
    }
    
    fileprivate func checkExistingToken() {
        var token = ZorroTempData.sharedInstance.get4n6Token()
//        token = "H4sIAAAAAAAEAKsKdMnPdspzzHB2DgutzPJwDy70LSxXNXYBohoAVueG/h0AAAA="
        let splittedstrings = token.components(separatedBy: ",")
        qrcodestring = splittedstrings[0]
        if token != "" {
            setdocumentDownloadUI()
            setdocumentTimeZoneUI()
            setdocumentTrailTableViewUI()
            fetchDocumentTrail(qrstring: qrcodestring)
            return
        } else {
            readToken()
        }
    }

    func readToken() {
        readerVC.delegate = self
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        
        reader.stopScanning()
        let isloginqr = differentiateQR(qrstring: result.value)
        if isloginqr {
            passwordlessAuthentication(qrstring: result.value)
            return
        } else {
            let fullstring = result.value
            let splittedstrings = fullstring.components(separatedBy: ",")
            qrcodestring = splittedstrings[0]
            self.dismiss(animated: true, completion: nil)
            setdocumentDownloadUI()
            setdocumentTimeZoneUI()
            setdocumentTrailTableViewUI()
            fetchDocumentTrail(qrstring: qrcodestring)
            
            return
        }
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
        #if !AuditTrailClip
        performSegue(withIdentifier: "gotoDashboard", sender: self)
        #endif
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        #if !AuditTrailClip
        performSegue(withIdentifier: "gotoDashboard", sender: self)
        #endif
    }
}

extension DocumentVC {
    private func differentiateQR(qrstring: String) -> Bool {
        if qrstring.contains("SessionID") {
            return true
        }
        return false
    }
}

extension DocumentVC {
    private func setNavBarButton() {
        let downloadbutton = UIBarButtonItem(image: UIImage(named: "Download")?.tabBarImageWithCustomTint(tintColor: .lightGray), style: .done, target: self, action: #selector(downloadDigitalCertificateAction(_:)))
        #if !AuditTrailClip
        self.navigationItem.rightBarButtonItem = downloadbutton
        #endif
        
        #if AuditTrailClip
        let scanbutton = UIBarButtonItem(image: UIImage(named: "Token")?.tabBarImageWithCustomTint(tintColor: .lightGray), style: .done, target: self, action: #selector(scanQR(_:)))
        self.navigationItem.rightBarButtonItems = [downloadbutton, scanbutton]
        #endif
    }
    
    @objc fileprivate func scanQR(_ sender: UIBarButtonItem) {
        readToken()
    }
}

//MARK: - New Implementation
//MARK: - Set download UI
extension DocumentVC {
    fileprivate func setdocumentDownloadUI() {
        
        let safearea = view.safeAreaLayoutGuide
        
//        // Logo Image
//        let logoImageView = UIImageView()
//        logoImageView.translatesAutoresizingMaskIntoConstraints = false
//        logoImageView.contentMode = .center
//        logoImageView.image = UIImage(named: "audit_trail")
//        logoImageView.clipsToBounds = false
//
//        let logoImageViewConstraints  = [
//            logoImageView.heightAnchor.constraint(equalToConstant: 40),
//            logoImageView.widthAnchor.constraint(equalToConstant: 40)
//        ]
//
//        NSLayoutConstraint.activate(logoImageViewConstraints)
//
//        // Title
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        titleLabel.font = UIFont(name: "Helvetica-Bold", size: 17)
//        titleLabel.text = "Audit Trail Based on Blockchain"
//        titleLabel.textColor = .black
//
//        // StackView
//        let stackView   = UIStackView()
//        stackView.axis  = NSLayoutConstraint.Axis.horizontal
//        stackView.distribution  = UIStackView.Distribution.equalSpacing
//        stackView.alignment = UIStackView.Alignment.center
//        stackView.spacing   = 5.0
//
//        stackView.addArrangedSubview(logoImageView)
//        stackView.addArrangedSubview(titleLabel)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(stackView)
//
//        let stackViewConstraints = [stackView.topAnchor.constraint(equalTo: safearea.topAnchor, constant: 5),
//                                   stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//                                   stackView.heightAnchor.constraint(equalToConstant: 50)]
//
//        NSLayoutConstraint.activate(stackViewConstraints)
        
        documentdownloadView = UIView()
        documentdownloadView.translatesAutoresizingMaskIntoConstraints = false
        documentdownloadView.backgroundColor = .white
        view.addSubview(documentdownloadView)
        
        documentdownloadviewConstraints = [documentdownloadView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                               documentdownloadView.topAnchor.constraint(equalTo: safearea.topAnchor),
                                               documentdownloadView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                               documentdownloadView.heightAnchor.constraint(equalToConstant: 60)]
        NSLayoutConstraint.activate(documentdownloadviewConstraints)
        
        
        documentdownloadIcon = UIImageView()
        documentdownloadIcon.translatesAutoresizingMaskIntoConstraints = false
        documentdownloadIcon.image = UIImage(named: "Down-arrow_tools")
        documentdownloadIcon.setImageColor(color: UIColor.init(red: 159/255, green: 159/255, blue: 159/255, alpha: 1))
        documentdownloadIcon.contentMode = .center
        documentdownloadIcon.backgroundColor = .clear
        documentdownloadView.addSubview(documentdownloadIcon)
        
        let documentdownloadiconCosntraints = [documentdownloadIcon.centerYAnchor.constraint(equalTo: documentdownloadView.centerYAnchor),
                                               documentdownloadIcon.rightAnchor.constraint(equalTo: documentdownloadView.rightAnchor, constant: -5),
                                               documentdownloadIcon.widthAnchor.constraint(equalToConstant: 35),
                                               documentdownloadIcon.heightAnchor.constraint(equalToConstant: 35)]
        NSLayoutConstraint.activate(documentdownloadiconCosntraints)
        
        documentname = UILabel()
        documentname.translatesAutoresizingMaskIntoConstraints = false
        documentname.font = UIFont(name: "Helvetica", size: 16)
        documentname.text = "Document set: "
        documentname.textColor = .darkGray
        documentdownloadView.addSubview(documentname)
        
        let documentnameConstraints = [documentname.leftAnchor.constraint(equalTo: documentdownloadView.leftAnchor, constant: 10),
                                       documentname.topAnchor.constraint(equalTo: documentdownloadView.topAnchor),
                                       documentname.heightAnchor.constraint(equalToConstant: 40),
                                       documentname.widthAnchor.constraint(equalToConstant: 105)]
        NSLayoutConstraint.activate(documentnameConstraints)
        
        documentnameValue = UILabel()
        documentnameValue.translatesAutoresizingMaskIntoConstraints = false
        documentnameValue.font = UIFont(name: "Helvetica-Bold", size: 16)
        documentnameValue.text = ""
        documentnameValue.textColor = .darkGray
        documentdownloadView.addSubview(documentnameValue)
        
        let documentnamevalueConstraints = [documentnameValue.leftAnchor.constraint(equalTo: documentname.rightAnchor, constant: 5),
                                       documentnameValue.topAnchor.constraint(equalTo: documentdownloadView.topAnchor),
                                       documentnameValue.heightAnchor.constraint(equalToConstant: 40),
                                       documentnameValue.rightAnchor.constraint(equalTo: documentdownloadIcon.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(documentnamevalueConstraints)
        
        restartedId = UILabel()
        restartedId.translatesAutoresizingMaskIntoConstraints = false
        restartedId.font = UIFont(name: "Helvetica", size: 16)
        restartedId.text = "Restarted from document ID: "
        restartedId.textColor = .darkGray
        documentdownloadView.addSubview(restartedId)
        
        let restartedIdConstraints = [restartedId.leftAnchor.constraint(equalTo: documentdownloadView.leftAnchor, constant: 10),
                                       restartedId.topAnchor.constraint(equalTo: documentname.topAnchor, constant: 30),
                                       restartedId.bottomAnchor.constraint(equalTo: documentdownloadView.bottomAnchor),
                                       restartedId.rightAnchor.constraint(equalTo: documentdownloadView.rightAnchor, constant: -10)]
        NSLayoutConstraint.activate(restartedIdConstraints)
        
        documentdownlodButton = UIButton()
        documentdownlodButton.translatesAutoresizingMaskIntoConstraints = false
        documentdownlodButton.backgroundColor = .clear
        documentdownloadView.addSubview(documentdownlodButton)
        
        let documentdownloadbuttonContraints = [documentdownlodButton.leftAnchor.constraint(equalTo: documentdownloadIcon.leftAnchor),
                                                documentdownlodButton.topAnchor.constraint(equalTo: documentdownloadIcon.topAnchor),
                                                documentdownlodButton.rightAnchor.constraint(equalTo: documentdownloadIcon.rightAnchor),
                                                documentdownlodButton.bottomAnchor.constraint(equalTo: documentdownloadIcon.bottomAnchor)]
        NSLayoutConstraint.activate(documentdownloadbuttonContraints)
        
        // Initilally hiding this
        restartedId.isHidden = true
        
        #if !AuditTrailClip
        documentdownlodButton.addTarget(self, action: #selector(showRename(_:)), for: .touchUpInside)
        #endif
    }
}

//MARK: - Set time zone UI
extension DocumentVC {
    fileprivate func setdocumentTimeZoneUI() {
        changetimezoneView = UIView()
        changetimezoneView.translatesAutoresizingMaskIntoConstraints = false
        changetimezoneView.backgroundColor = .white
        view.addSubview(changetimezoneView)
        
        let changetimezoneViewConstraints = [changetimezoneView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             changetimezoneView.topAnchor.constraint(equalTo: documentdownloadView.bottomAnchor),
                                             changetimezoneView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             changetimezoneView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(changetimezoneViewConstraints)
        
        topseparatorView = UIView()
        topseparatorView.translatesAutoresizingMaskIntoConstraints = false
        topseparatorView.backgroundColor = UIColor.init(red: 198/255, green: 203/255, blue: 198/255, alpha: 1)
        changetimezoneView.addSubview(topseparatorView)
        
        let topseparatorviewConstraints = [topseparatorView.topAnchor.constraint(equalTo: changetimezoneView.topAnchor),
                                           topseparatorView.centerXAnchor.constraint(equalTo: changetimezoneView.centerXAnchor),
                                           topseparatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 20),
                                           topseparatorView.heightAnchor.constraint(equalToConstant: 1)]
        NSLayoutConstraint.activate(topseparatorviewConstraints)
        
        changetimezoneIcon = UIImageView()
        changetimezoneIcon.translatesAutoresizingMaskIntoConstraints = false
        changetimezoneIcon.contentMode = .center
        changetimezoneIcon.image = UIImage(named: "Time-zone")
        changetimezoneIcon.setImageColor(color: UIColor.init(red: 159/255, green: 159/255, blue: 159/255, alpha: 1))
        changetimezoneIcon.backgroundColor = .clear
        changetimezoneView.addSubview(changetimezoneIcon)
        
        let changetimezoneIconCosntraints = [changetimezoneIcon.centerYAnchor.constraint(equalTo: changetimezoneView.centerYAnchor),
                                             changetimezoneIcon.rightAnchor.constraint(equalTo: changetimezoneView.rightAnchor, constant: -5),
                                             changetimezoneIcon.widthAnchor.constraint(equalToConstant: 35),
                                             changetimezoneIcon.heightAnchor.constraint(equalToConstant: 35)]
        NSLayoutConstraint.activate(changetimezoneIconCosntraints)

        timezonename = UILabel()
        timezonename.translatesAutoresizingMaskIntoConstraints = false
        timezonename.font = UIFont(name: "Helvetica", size: 16)
        timezonename.text = "Time: "
        timezonename.textColor = .darkGray
        changetimezoneView.addSubview(timezonename)
        
        let timezonenameConstraints = [timezonename.leftAnchor.constraint(equalTo: changetimezoneView.leftAnchor, constant: 10),
                                       timezonename.topAnchor.constraint(equalTo: changetimezoneView.topAnchor),
                                       timezonename.bottomAnchor.constraint(equalTo: changetimezoneView.bottomAnchor),
                                       timezonename.widthAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(timezonenameConstraints)
        
        timezonenameValue = UILabel()
        timezonenameValue.translatesAutoresizingMaskIntoConstraints = false
        timezonenameValue.font = UIFont(name: "Helvetica-Bold", size: 16)
        timezonenameValue.text = ""
        timezonenameValue.textColor = .darkGray
        changetimezoneView.addSubview(timezonenameValue)
        
        let timezonenamevalueConstraints = [timezonenameValue.leftAnchor.constraint(equalTo: timezonename.rightAnchor, constant: 5),
                                       timezonenameValue.topAnchor.constraint(equalTo: changetimezoneView.topAnchor),
                                       timezonenameValue.bottomAnchor.constraint(equalTo: changetimezoneView.bottomAnchor),
                                       timezonenameValue.rightAnchor.constraint(equalTo: changetimezoneIcon.leftAnchor, constant: -5)]
        NSLayoutConstraint.activate(timezonenamevalueConstraints)
        
        changetimezoneButton = UIButton()
        changetimezoneButton.translatesAutoresizingMaskIntoConstraints = false
        changetimezoneView.addSubview(changetimezoneButton)
        
        let changetimezonebuttonConstraints = [changetimezoneButton.leftAnchor.constraint(equalTo: changetimezoneView.leftAnchor),
                                               changetimezoneButton.topAnchor.constraint(equalTo: changetimezoneView.topAnchor),
                                               changetimezoneButton.rightAnchor.constraint(equalTo: changetimezoneView.rightAnchor),
                                               changetimezoneButton.bottomAnchor.constraint(equalTo: changetimezoneView.bottomAnchor)]
        NSLayoutConstraint.activate(changetimezonebuttonConstraints)
        
        changetimezoneButton.addTarget(self, action: #selector(changetimeZoneAction(_:)), for: .touchUpInside)
    }
}

//MARK: Download, Rename and TimeZone Button Actions
extension DocumentVC {
    
    @objc fileprivate func downloadDigitalCertificateAction(_ sender: UIBarButtonItem) {
        
        if FeatureMatrix.shared.digital_certificate {
            let connectivity = Connectivity.isConnectedToInternet()
            if !connectivity {
                alertSample(strTitle: "Connectivity !", strMsg: "Please check your internet connection and try again !")
                return
            }
            
            self.showActivityIndicatory(uiView: self.view)
            let getdocumenttrails = GetDocumentTrail()
            getdocumenttrails.downloadDigitalCertificate(processid: self.processid) { (filename, err) in
                self.stopActivityIndicator()
                if err {
                    self.alertSample(strTitle: "Sorry !", strMsg: "Unable to download the digital certificate.")
                    return
                }
                self.showFile(filename: filename!)
                return
            }
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
    
    #if !AuditTrailClip
    @objc private func showRename(_ sender: UIButton) {
        
        let documentrenameController = DocumentRenameDetailsController()
        documentrenameController.modalPresentationStyle = .popover
        documentrenameController.popoverPresentationController?.delegate = self
        documentrenameController.popoverPresentationController?.sourceView = self.view
        
        let renamwidth: CGFloat = UIScreen.main.bounds.width
        
        documentrenameController.popoverPresentationController?.sourceRect = CGRect(x: changetimezoneView.bounds.minX, y: changetimezoneView.bounds.minY + 230, width: 0, height: 0)
        documentrenameController.popoverPresentationController?.permittedArrowDirections = []
        documentrenameController.documentrenameHistory = renamehistory
        documentrenameController.preferredContentSize = CGSize(width: renamwidth, height: 200)
        
        if (self.renamehistory?.renamedocumentSub.count)! > 0 {
            self.present(documentrenameController, animated: true, completion: nil)
        }
    }
    #endif
    
    @objc fileprivate func changetimeZoneAction(_ sender: UIButton) {
        print("working change timezone action")
        let documentutccontroller = DocumentUTCController()
        documentutccontroller.timezoneCallback = { selectedzone in
            print("Selected Time Zone is : \(selectedzone!)")
            self.timezonenameValue.text = selectedzone!.DisplayName!
            self.chainofsignature = self.chainofsignature?.updatedChainofSignature(chainofsignature: self.chainofsignature!, selectedtimezone: selectedzone!)
            self.chainofcustody = self.chainofcustody?.updateChainofCustody(chainofcustody: self.chainofcustody!, selectedtimezone: selectedzone!)
            self.renamehistory = self.renamehistory?.updatedRenameHistory(renameHistory: self.renamehistory!, selectedtimezone: selectedzone!)
            self.documenttrailTableView.reloadData()
            
        }
        documentutccontroller.modalPresentationStyle = .popover
        
        let documentutcpopovercontroller = documentutccontroller.popoverPresentationController
        documentutcpopovercontroller?.delegate = self
        documentutcpopovercontroller?.sourceView = sender
        documentutcpopovercontroller?.sourceRect = CGRect(x: sender.bounds.midX, y: sender.bounds.maxY, width: 0, height: 0)
        documentutccontroller.preferredContentSize = CGSize(width: 300, height: 400)
        
        self.present(documentutccontroller, animated: true, completion: nil)
    }
}

//MARK: pop over delegates
extension DocumentVC : UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

//MARK: - Set document trail UI
extension DocumentVC {
    fileprivate func setdocumentTrailTableViewUI() {
        documenttrailTableView = UITableView(frame: .zero, style: .plain)
        documenttrailTableView.register(UITableViewCell.self, forCellReuseIdentifier: documenttraildefaultcellId)
        documenttrailTableView.register(DocumentTrailStartCellKBA.self, forCellReuseIdentifier: documenttrailstartCellkbaid)
        documenttrailTableView.register(DocumentTrailStartCell.self, forCellReuseIdentifier: documenttrailstartCellid)
        documenttrailTableView.register(DocumentTrailDetailCell.self, forCellReuseIdentifier: documenttraildetailCellid)
        documenttrailTableView.register(DocumentTrailSignatureCell.self, forCellReuseIdentifier: documenttrailsignatureCellid)
        documenttrailTableView.register(DocumentTrailDownloadCell.self, forCellReuseIdentifier: documenttraildownloadCellid)
        documenttrailTableView.register(DocumentTrailAttachmentDownloadCell.self, forCellReuseIdentifier: documenttraildownloadattachmentCellid)
        documenttrailTableView.translatesAutoresizingMaskIntoConstraints = false
        documenttrailTableView.tableFooterView = UIView()
        documenttrailTableView.showsVerticalScrollIndicator = false
        documenttrailTableView.separatorStyle = .none
        documenttrailTableView.dataSource = self
        documenttrailTableView.delegate = self
        view.addSubview(documenttrailTableView)
        let documenttableviewConstraints = [documenttrailTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                            documenttrailTableView.topAnchor.constraint(equalTo: changetimezoneView.bottomAnchor, constant: 10),
                                            documenttrailTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                            documenttrailTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(documenttableviewConstraints)
    }
}

//MARK: Document trail table view data source
extension DocumentVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let isexpand = chainofcustody?.isExpand else { return chainofcustody?.chainofcustodySub.count ?? 0 }
            if isexpand {
                return chainofcustody?.chainofcustodySub.count ?? 0
            } else {
                return 0
            }
        case 1:
            guard let isexpand = chainofsignature?.isExpand else { return chainofsignature?.chainofsignatureSub.count ?? 0 }
            if isexpand {
                return chainofsignature?.chainofsignatureSub.count ?? 0
            } else {
                return 0
            }
        case 2:
            guard let isexpand = chainofdocument?.isExpand else { return chainofdocument?.chainofdocumentSub.count ?? 0 }
            if isexpand {
                return chainofdocument?.chainofdocumentSub.count ?? 0
            } else {
                return 0
            }
        case 3:
            guard let isexpand = chainofattachment?.isExpand else { return chainofattachment?.chainofattachmentSub.count ?? 0 }
            if isexpand {
                return chainofattachment?.chainofattachmentSub.count ?? 0
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let isimage = chainofcustody?.chainofcustodySub[indexPath.row].isImage
            if isimage! {
                let isKba = chainofcustody?.chainofcustodySub[indexPath.row].isKBA
                if isKba! {
                    let usercell = tableView.dequeueReusableCell(withIdentifier: documenttrailstartCellkbaid) as! DocumentTrailStartCellKBA
                    let chainofcustodysingle = chainofcustody?.chainofcustodySub[indexPath.row]
                    usercell.chainofsub = chainofcustodysingle
                    return usercell
                } else {
                    let usercell = tableView.dequeueReusableCell(withIdentifier: documenttrailstartCellid) as! DocumentTrailStartCell
                    let chainofcustodysingle = chainofcustody?.chainofcustodySub[indexPath.row]
                    usercell.chainofsub = chainofcustodysingle
                    return usercell
                }
            } else {
                let detailcell = tableView.dequeueReusableCell(withIdentifier: documenttraildetailCellid) as! DocumentTrailDetailCell
                let chainofcustodysingle = chainofcustody?.chainofcustodySub[indexPath.row]
                detailcell.chainofsub = chainofcustodysingle
                return detailcell
            }
        case 1:
            let signaturecell = tableView.dequeueReusableCell(withIdentifier: documenttrailsignatureCellid) as! DocumentTrailSignatureCell
            let chainofsignaturesingle = chainofsignature?.chainofsignatureSub[indexPath.row]
            signaturecell.chainofsignaturesub = chainofsignaturesingle
            return signaturecell
        case 2:
            let downloadcell = tableView.dequeueReusableCell(withIdentifier: documenttraildownloadCellid) as! DocumentTrailDownloadCell
            let chainofdocumentsingle = chainofdocument?.chainofdocumentSub[indexPath.row]
            downloadcell.chainofdocument = chainofdocumentsingle
            return downloadcell
        case 3:
            let downloadattachmentcell = tableView.dequeueReusableCell(withIdentifier: documenttraildownloadattachmentCellid) as! DocumentTrailAttachmentDownloadCell
            let chainofattachmentsingle = chainofattachment?.chainofattachmentSub[indexPath.row]
            downloadattachmentcell.chainofattchment = chainofattachmentsingle
            return downloadattachmentcell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: documenttraildefaultcellId)!
            cell.textLabel?.text = "doc trail"
            return cell
        }
    }
}

//MARK: Document trail table view delegate
extension DocumentVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let containerview = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 45))
        containerview.backgroundColor = .white
        let backgroundview = UIView()
        backgroundview.translatesAutoresizingMaskIntoConstraints = false
        backgroundview.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        containerview.addSubview(backgroundview)
        
        let backgroundviewconstraints = [backgroundview.leftAnchor.constraint(equalTo: containerview.leftAnchor, constant: 5),
                                         backgroundview.topAnchor.constraint(equalTo: containerview.topAnchor, constant: 2),
                                         backgroundview.rightAnchor.constraint(equalTo: containerview.rightAnchor, constant: -5),
                                         backgroundview.bottomAnchor.constraint(equalTo: containerview.bottomAnchor, constant: -2)]
        NSLayoutConstraint.activate(backgroundviewconstraints)
        backgroundview.layer.masksToBounds = true
        backgroundview.layer.cornerRadius = 5
        
        let arroimage = UIImageView()
        arroimage.translatesAutoresizingMaskIntoConstraints = false
        
        switch section {
        case 0:
            if let isexpand = chainofcustody?.isExpand {
                if isexpand {
                    arroimage.image = UIImage(named: "Up-Arrow_tools")
                } else {
                    arroimage.image = UIImage(named: "Down-arrow_tools")
                }
            } else {
                arroimage.image = UIImage(named: "Down-arrow_tools")
            }
        case 1:
            if let isexpand = chainofsignature?.isExpand {
                if isexpand {
                    arroimage.image = UIImage(named: "Up-Arrow_tools")
                } else {
                    arroimage.image = UIImage(named: "Down-arrow_tools")
                }
            } else {
                arroimage.image = UIImage(named: "Down-arrow_tools")
            }
        case 2:
            if let isexpand = chainofdocument?.isExpand {
                if isexpand {
                    arroimage.image = UIImage(named: "Up-Arrow_tools")
                } else {
                    arroimage.image = UIImage(named: "Down-arrow_tools")
                }
            } else {
                arroimage.image = UIImage(named: "Down-arrow_tools")
            }
        case 3:
            if let isexpand = chainofattachment?.isExpand {
                if isexpand {
                    arroimage.image = UIImage(named: "Up-Arrow_tools")
                } else {
                    arroimage.image = UIImage(named: "Down-arrow_tools")
                }
            } else {
                arroimage.image = UIImage(named: "Down-arrow_tools")
            }
        default:
            arroimage.image = UIImage(named: "Down-arrow_tools")
        }
        
        arroimage.backgroundColor = .clear
        arroimage.contentMode = .center
        backgroundview.addSubview(arroimage)
        
        let arroimageConstraints = [arroimage.centerYAnchor.constraint(equalTo: backgroundview.centerYAnchor),
                                    arroimage.rightAnchor.constraint(equalTo: backgroundview.rightAnchor, constant: 0),
                                    arroimage.widthAnchor.constraint(equalToConstant: 40),
                                    arroimage.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(arroimageConstraints)
        
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont(name: "Helvetica", size: 16)
        title.textColor = .darkGray
        
        switch section {
        case 0:
            title.text = "CHAIN OF CUSTODY & AUDIT TRAIL"
        case 1:
            title.text = "SIGNATORIES"
        case 2:
            title.text = "DOCUMENT"
        case 3:
            title.text = "ATTACHMENTS"
        default:
            title.text = ""
        }
   
        backgroundview.addSubview(title)
        let titleconatraints = [title.leftAnchor.constraint(equalTo: backgroundview.leftAnchor, constant: 5),
                                title.topAnchor.constraint(equalTo: backgroundview.topAnchor),
                                title.rightAnchor.constraint(equalTo: arroimage.leftAnchor, constant: -2),
                                title.bottomAnchor.constraint(equalTo: backgroundview.bottomAnchor)]
        NSLayoutConstraint.activate(titleconatraints)
        
        
        let collapsebutton = UIButton()
        collapsebutton.translatesAutoresizingMaskIntoConstraints = false
        collapsebutton.tag = section
        backgroundview.addSubview(collapsebutton)
        
        let collapsebuttonConstraints = [collapsebutton.leftAnchor.constraint(equalTo: arroimage.leftAnchor),
                                         collapsebutton.topAnchor.constraint(equalTo: arroimage.topAnchor),
                                         collapsebutton.rightAnchor.constraint(equalTo: arroimage.rightAnchor),
                                         collapsebutton.bottomAnchor.constraint(equalTo: arroimage.bottomAnchor)]
        NSLayoutConstraint.activate(collapsebuttonConstraints)
        
        collapsebutton.addTarget(self, action: #selector(sectionCollapse(_:)), for: .touchUpInside)
        
        return containerview
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let custody = chainofcustody?.chainofcustodySub[indexPath.row]
            
            let isimage = custody?.isImage
            if isimage! {
                return 70
            } else {
                let isaction = custody?.isAction
                if isaction! {
                    let isinitial = custody?.intialAction
                    if isinitial! {
                        return 40
                    } else {
                        let ishidden = custody?.isactionHidden
                        if ishidden! {
                            return 0
                        } else {
                            return 40
                        }
                    }
                } else {
                   return 40
                }
            }
        case 1:
            return UITableView.automaticDimension
        case 2:
            return UITableView.automaticDimension
        case 3:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let selectedcustody = chainofcustody?.chainofcustodySub[indexPath.row]
            switch selectedcustody?.leftData {
            case "Geolocation":
                if let _coordinates = selectedcustody?.rightData, _coordinates != "N/A", !_coordinates.isEmpty {
                    let lat = _coordinates.split(separator: ",")[0]
                    let long = _coordinates.split(separator: ",")[1]
                    openMapForPlace(lat: String(lat), long: String(long))
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.alertSample(strTitle: "Alert", strMsg: "Sorry there is no Geo-Location for this action.")
                    }
                }
            case "Action(s)":
                updateActions(selectedcustody: selectedcustody!)
            case "Blockchain Transaction ID":
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let _transactionID = selectedcustody?.rightData {
                        self.alertSample(strTitle: "Blockchain Transaction ID", strMsg: _transactionID)
                    }
                }
//            case "Blockchain Transaction Timestamp":
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    if let _transactionTimeStamp = selectedcustody?.rightData {
//                        self.alertSample(strTitle: "Blockchain Transaction Timestamp", strMsg: _transactionTimeStamp)
//                    }
//                }
            case "Digital Signature":
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if let _digitalSignature = selectedcustody?.rightData {
                        self.alertSample(strTitle: "Digital Signature", strMsg: _digitalSignature)
                    }
                }
            default:
                return
            }
            return
        case 2:
            let selecteddocument = chainofdocument?.chainofdocumentSub[indexPath.row]
            downloadseperateDocument(objectid: (selecteddocument?.documenturl)!, multidocid: (selecteddocument?.documentid)!, docname: (selecteddocument?.documentname)!)
        case 3:
            let selectedattachment = chainofattachment?.chainofattachmentSub[indexPath.row]
            downloadseperateAttachment(objectid: (selectedattachment?.attachmentobjectid)!, docname: (selectedattachment?.attachmentname)!)
        default:
            return
        }
    }
}

extension DocumentVC {
    @objc fileprivate func sectionCollapse(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            guard let isexpand = chainofcustody?.isExpand else { return }
            if isexpand {
                chainofcustody?.isExpand = false
            } else {
                chainofcustody?.isExpand = true
            }
        case 1:
            guard let isexpand = chainofsignature?.isExpand else { return }
            if isexpand {
                chainofsignature?.isExpand = false
            } else {
                chainofsignature?.isExpand = true
            }
        case 2:
            guard let isexpand = chainofdocument?.isExpand else { return }
            if isexpand {
                chainofdocument?.isExpand = false
            } else {
                chainofdocument?.isExpand = true
            }
        case 3:
            guard let isexpand = chainofattachment?.isExpand else { return }
            if isexpand {
                chainofattachment?.isExpand = false
            } else {
                chainofattachment?.isExpand = true
            }
        default:
            return
        }
        print("workind for button \(sender.tag)")
        documenttrailTableView.reloadData()
    }
}

extension DocumentVC {
    fileprivate func fetchDocumentTrail(qrstring: String) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connectivity !", strMsg: "Please check your internet connection and try again !")
            return
        }
    
        self.showActivityIndicatory(uiView: self.view)
        let getdoctrail = GetDocumentTrail(QRCodeData: qrstring, Request: 1)
        getdoctrail.getdocumenttrailDetails(getdoctrail: getdoctrail) { [self] (doctraildetails, err, statuscode) in
            self.stopActivityIndicator()
            
            if err {
                var doctrailalerttitle = ""
                var doctrailalertmessage = ""
                switch statuscode {
                case 3000, 3003:
                    doctrailalerttitle = "Something Wrong!"
                    doctrailalertmessage = "Unable to read the token"
                case 3558:
                    doctrailalerttitle = "Authentication!"
                    doctrailalertmessage = "Login failed"
                case 1500,3901:
                    doctrailalerttitle = "Permission !"
                    doctrailalertmessage = "You don't have permission to view this doucument trail. Would you like to request permission ?"
                    print("NO PERMISSION GRANTED. REQUEST FOR PERMISSION")
                case 3903:
                    doctrailalerttitle = "Something Wrong!"
                    doctrailalertmessage = "Cannot get the token histroy"
                case 3904:
                    doctrailalerttitle = "Permission Pending"
                    doctrailalertmessage = "Permission request is pending."
                case 3907:
                    doctrailalerttitle = "Invalid Token"
                    doctrailalertmessage = "Please try again with a valid token"
                case 3908:
                    doctrailalerttitle = "Permission"
                    doctrailalertmessage = "Permissions cannot be granted for this Token version"
                default:
                    doctrailalerttitle = "Something Wrong !"
                    doctrailalertmessage = "Unable to view the document, please contact the administration"
                }
                
                ZorroTempData.sharedInstance.set4n6Token(tokenstring: "")
                UserDefaults.standard.set("", forKey: "qrcode")
                UserDefaults.standard.set("", forKey: "scannedqrcode")
                self.documenttrailAlerts(title: doctrailalerttitle, message: doctrailalertmessage, statuscode: statuscode!)
                return
            }
            
            ZorroTempData.sharedInstance.set4n6Token(tokenstring: "")
            UserDefaults.standard.set("", forKey: "qrcode")
            UserDefaults.standard.set("", forKey: "scannedqrcode")
            
            self.processid = doctraildetails?.Data?.InstanceId
            
            self.documentnameValue.text = (doctraildetails?.Data?.DocumentSetName)!
            
            let chainofCustody = ChainofCustody(isexpanded: true, documenttrailDetails: doctraildetails, contractversion: doctraildetails?.Data?.ContractVersion)
            self.chainofcustody = chainofCustody
            
            let chainofSignature = ChainofSignature(isexpand: true, documenttrailDetails: doctraildetails)
            self.chainofsignature = chainofSignature
            
            let chainofDocument = ChainofDocument(isexpand: true, documenttrailDetails: doctraildetails)
            self.chainofdocument = chainofDocument
            
            let chainofAttachment = ChainofAttachment(isexpand: true, documenttrailDetails: doctraildetails)
            self.chainofattachment = chainofAttachment
            
            let docrenamehistory = RenameDocument(documenttrailDetails: doctraildetails)
            self.renamehistory = docrenamehistory
            
            if self.renamehistory?.renamedocumentSub.count == 0 {
                self.documentdownloadIcon.isHidden = true
            }
            
            // Show Restart Details
            
            if let _restartedFromProcessId = doctraildetails?.Data?.RestartedFromProcessId {
                if _restartedFromProcessId > 0 {
                    self.restartedId.isHidden = false
                    self.restartedId.text = "Restarted from document ID: \(_restartedFromProcessId)"
                }
            } else {
                hideRestart()
            }
            
            let usermomentZoneName = TimeZone.current.identifier
            let zorrotimezone = ZorroTimeZone()
            
            zorrotimezone.getUserTimeZoneDisplayName(momentzonename: usermomentZoneName, completion: { (timezone) in
                if timezone != nil {
                    self.timezonenameValue.text = (timezone?.DisplayName)!
                    self.chainofsignature = self.chainofsignature?.updatedChainofSignature(chainofsignature: self.chainofsignature!, selectedtimezone: timezone!)
                    self.chainofcustody = self.chainofcustody?.updateChainofCustody(chainofcustody: self.chainofcustody!, selectedtimezone: timezone!)
                    self.renamehistory = self.renamehistory?.updatedRenameHistory(renameHistory: self.renamehistory!, selectedtimezone: timezone!)
                    
                    self.documenttrailTableView.reloadData()
                    self.stopActivityIndicator()
                }
            })
        }
    }
}

extension DocumentVC {
    fileprivate func updateActions(selectedcustody: ChainofCustodySub) {
        if selectedcustody.isAction && selectedcustody.intialAction {
            self.chainofcustody = self.chainofcustody?.updateChainofCustodywithAction(chainofcustody: self.chainofcustody!, selectedactionIndex: selectedcustody.instanceStep!)
            DispatchQueue.main.async {
                self.documenttrailTableView.reloadData()
            }
        }
        return
    }
}

extension DocumentVC {
    fileprivate func downloadseperateAttachment(objectid: String, docname: String) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connectivity !", strMsg: "Please check your internet connection and try again !")
            return
        }
        
        self.showActivityIndicatory(uiView: self.view)
        let getdocumenttrails = GetDocumentTrail()
        getdocumenttrails.downloadSpecificFileNew(processid: "\(processid!)", objectid: objectid, docname: docname) { (filename, err) in
            self.stopActivityIndicator()
            if err {
                print("unable to download the file.")
                self.alertSample(strTitle: "Sorry !", strMsg: "Unable to download the selected attachment.")
                return
            }
            self.showFile(filename: filename!)
            return
        }
    }
}

extension DocumentVC {
    fileprivate func downloadseperateDocument(objectid: String, multidocid: Int, docname: String) {
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connectivity !", strMsg: "Please check your internet connection and try again !")
            return
        }
        
        self.showActivityIndicatory(uiView: self.view)
        let getdocumenttrails = GetDocumentTrail()
        getdocumenttrails.downloadseperateDocument(processid: "\(processid!)", multidocid: multidocid, docname: docname) { (filename, err) in
            self.stopActivityIndicator()
            if err {
                self.alertSample(strTitle: "Sorry !", strMsg: "Unable to download the selected document.")
                return
            }
            self.showFile(filename: filename!)
            return
        }
        
    }
}

// MARK: - Open Maps

extension DocumentVC {
    func openMapForPlace(lat: String, long: String) {

        let lat1 : NSString = lat as NSString
        let lng1 : NSString = long as NSString

        let latitude:CLLocationDegrees =  lat1.doubleValue
        let longitude:CLLocationDegrees =  lng1.doubleValue

        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "Colombo"
        mapItem.openInMaps(launchOptions: options)

    }
}

extension DocumentVC {
    fileprivate func showFile(filename: String) {
        
        if filename.contains(".pdf.pdf") {
            
        }
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent(filename) {
            let filepath = pathComponent.path
            let filemanager = FileManager.default
            if filemanager.fileExists(atPath: filepath) {
                let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: filepath))
                viewer.delegate = self
                viewer.presentPreview(animated: true)
            }
        } else {
            self.alertSample(strTitle: "Unable to view, Sorry !", strMsg: "Unable to view selected file type in iOS/iPad, please use web browser")
            return
        }
    }
}

extension DocumentVC: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

extension DocumentVC {
    fileprivate func documenttrailAlerts(title: String, message: String, statuscode: Int) {
        
        let documenttrailAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        documenttrailAlert.view.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        
        switch statuscode {
        case 1500, 3901:
            let permissionAction = UIAlertAction(title: "Request Permission", style: .cancel) { (alert) in
                print("grant permission")
                self.requestPermission()
                return
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (alert) in
                print("cancel the grant action")
                #if !AuditTrailClip
                self.performSegue(withIdentifier: "gotoDashboard", sender: self)
                #endif
                return
            }
            documenttrailAlert.addAction(permissionAction)
            documenttrailAlert.addAction(cancelAction)
        default:
            let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
                print("ok action")
                #if !AuditTrailClip
                self.performSegue(withIdentifier: "gotoDashboard", sender: self)
                #endif
                return
            }
            documenttrailAlert.addAction(okAction)
        }
        self.present(documenttrailAlert, animated: true, completion: nil)
    }
}

extension DocumentVC {
    fileprivate func requestPermission() {
        self.showActivityIndicatory(uiView: self.view)
        let getdocumentdetails = GetDocumentDetails(QRCodeData: qrcodestring, Request: 1)
        getdocumentdetails.requestdoctrailPermission(getdocdetails: getdocumentdetails) { (success, message,statuscode) in
            var title = ""
            var message = message
            if success {
                title = "Success !"
            } else {
                
                title = "Failure !"
                if statuscode == 3904 {
                    title = "Pending !"
                    message = "Previous request is in pending state"
                }
                
            }
            self.stopActivityIndicator()
            self.documenttrailAlerts(title: title, message: message ?? "", statuscode: 0)
            return
        }
    }
}

extension DocumentVC {
    private func passwordlessAuthentication(qrstring: String) {
           
           let userid = ZorroTempData.sharedInstance.getpasswordlessUser()
           let deviceid = ZorroTempData.sharedInstance.getpasswordlessUUID()
           
           
        LoginAPI.sharedInstance.passwordlessStatusCheck(username: userid.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (success, keyid) in
               
               if success {
                   
                   let sessionidSplit = qrstring.components(separatedBy: " ")
                   let isIndexValid = sessionidSplit.indices.contains(1)
                   
                   if isIndexValid && userid != "" {
                       
                       let sessionid = sessionidSplit[1]
                       let biometricWrapper = BiometricsWrapper()
                       
                       biometricWrapper.authenticateWithBiometric { (_success, _errmsg) in
                           guard let _issuccess = _success else { return }
                           
                           if _issuccess {
                               
                               let pkiHelper = PKIHelper()
                            pkiHelper.signWithPrivateKey(textIn: sessionid, keyid: keyid) { (signsuccess, signedmessage) in
                                   
                                   if signsuccess {
                                       
                                       let passwordlesAuth = PasswordlessAuthentication(UserId: userid, SessionId: sessionid, DeviceId: deviceid, Signature: signedmessage)
                                       passwordlesAuth.userAuthenticateWithQR(passwordlessauthentication: passwordlesAuth) { (success) in
                                           
                                           if success {
                                               DispatchQueue.main.async {
                                                   self.dismiss(animated: true) {
                                                       self.alertSample(strTitle: "Success!", strMsg: "Successfully Authenticated")
                                                   }
                                               }
                                               return
                                           }
                                           DispatchQueue.main.async {
                                               self.dismiss(animated: true) {
                                                   self.alertSample(strTitle: "Error!", strMsg: "Unable to Authenticated!")
                                               }
                                           }
                                       }
                                       return
                                       
                                   }
                                   DispatchQueue.main.async {
                                       self.dismiss(animated: true) {
                                           self.alertSample(strTitle: "Error!", strMsg: "Unable to Authenticated!")
                                       }
                                   }
                                   return
                               }
                               return
                           }
                           DispatchQueue.main.async {
                               self.dismiss(animated: true) {
                                   self.alertSample(strTitle: "Error!", strMsg: _errmsg ?? "Unable to Authenticate")
                               }
                           }
                           return
                       }
                       return
                   }
                   DispatchQueue.main.async {
                       self.dismiss(animated: true) {
                           self.alertSample(strTitle: "Invalid QR!", strMsg: "Please scan a valid QR to login")
                       }
                   }
                   return
               }
               DispatchQueue.main.async {
                   self.dismiss(animated: true) {
                       self.alertSample(strTitle: "Not Enrolled!", strMsg: "Please enroll for the passwordless feature in order to use it")
                   }
               }
               return
           }
           return
       }
}

extension DocumentVC {
    
    func hideRestart() {
        let safearea = view.safeAreaLayoutGuide
        
        documentdownloadviewConstraints = [documentdownloadView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                               documentdownloadView.topAnchor.constraint(equalTo: safearea.topAnchor),
                                               documentdownloadView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                               documentdownloadView.heightAnchor.constraint(equalToConstant: 40)]
        NSLayoutConstraint.activate(documentdownloadviewConstraints)
        restartedId.isHidden = true
        
        if chainofcustody != nil {
            self.documenttrailTableView.reloadData()
        }
        
    }
    
//    func showRestart() {
//        let safearea = view.safeAreaLayoutGuide
//
//        documentdownloadviewConstraints = [documentdownloadView.leftAnchor.constraint(equalTo: view.leftAnchor),
//                                               documentdownloadView.topAnchor.constraint(equalTo: safearea.topAnchor),
//                                               documentdownloadView.rightAnchor.constraint(equalTo: view.rightAnchor),
//                                               documentdownloadView.heightAnchor.constraint(equalToConstant: 80)]
//        NSLayoutConstraint.activate(documentdownloadviewConstraints)
//        restartedId.isHidden = false
//
//        if chainofcustody != nil {
//            self.documenttrailTableView.reloadData()
//        }
//    }
}
