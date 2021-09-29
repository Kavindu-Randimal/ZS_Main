//
//  ContactsVC.swift
//  ZorroSign
//
//  Created by Apple on 13/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import SwiftyXMLParser
import Speech
import Contacts
import IHKeyboardAvoiding

@available(iOS 10.0, *)
class ContactsVC: BaseVC, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, labelCellDelegate, GIDSignInDelegate, SFSpeechRecognizerDelegate, UIDocumentPickerDelegate, UIAdaptivePresentationControllerDelegate, PopoverDismissDelegate {
    
    @IBOutlet weak var contactsTbl: UITableView!
    var contactsArr: [ContactsData] = []
    var extContactsArr: [ContactsData] = []
    var intContactsArr: [ContactsData] = []
    var selIntContactsArr: [ContactsData] = []
    var grpContactsArr: [ContactsData] = []
    var linkContactsArr: [ContactsData] = []
    var filteredContArr: [ContactsData] = []
    
    var selCnt = 0
    
    var contactAlertView: SwiftAlertView!
    var contactObj: ContactsData?
    var selectAllFlag: Bool = false
    var internalFlag: Bool = false
    var grpFlag: Bool = false
    var linkFlag: Bool = false
    var editGrpFlag: Bool = false
    
    @IBOutlet weak var signInButton: UIButton!//GIDSignInButton!
    @IBOutlet weak var signInView: UIView!
    
    var inviteAlertView: SwiftAlertView!
    var internalAlertView: SwiftAlertView!
    var viewContactAlertView: SwiftAlertView!
    var addGrpAlertView: SwiftAlertView!
    var linkAlertView: SwiftAlertView!
    
    var inviteFlag: Bool = false
    var googleContactsArr: [[String: Any]] = []
    
    var peopleDataArray: Array<Dictionary<NSObject, AnyObject>> = []
    let clientID = "287929891193-7q432fjbboe5i4qe71qoonmbtcj843s8.apps.googleusercontent.com"
    
    @IBOutlet weak var viewBottomDashborad: UIView!
    @IBOutlet weak var viewBottomSearch: UIView!
    @IBOutlet weak var viewBottomMyAccount: UIView!
    @IBOutlet weak var btnBottomHelp: UIView!
    
    @IBOutlet weak var lblDashboard: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblMyAccount: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    
    @IBOutlet weak var imgDashboard: UIImageView!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgMyAccount: UIImageView!
    @IBOutlet weak var imgHelp: UIImageView!
    
    @IBOutlet weak var viewSearchBar: UIView!
    @IBOutlet weak var viewSearchBarSubView: UIView!
    @IBOutlet weak var txtSearchText: UITextField!
    @IBOutlet weak var imgSearchMic: UIImageView!
    @IBOutlet weak var btnClear: UIButton!
    
    @IBOutlet weak var viewSearchAction: UIView!
    
    var searchTxt: String = ""
    var sortTitle: String = "ALL"
    
    var editGrpId: Int = 0
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US")) // 1
    
    private var recognizationRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognizationTask: SFSpeechRecognitionTask?
    private var audioEngin = AVAudioEngine()
    
    @available(iOS 11.0, *)
    lazy var documentBrowser: UIDocumentBrowserViewController = {
        return UIDocumentBrowserViewController()
    }()
    //Application Id
    //53cc3edc-fcbf-45f3-a8ab-a58b7ce7af75
    let service = OutlookService.shared()
    
    var grpName: String = ""
    var grpDesc: String = ""
    
    var selLinkContact: ContactsData!
    
    var titles: [String] = ["ALL","CONTACTS","GROUPS","MY COMPANY"]
    var navController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        KeyboardAvoiding.avoidingView = viewSearchBar
        
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        if !adminflag {
            titles.removeLast()
        }

        //getUnreadPushCount()
        
        //initAlert()
        // Do any additional setup after loading the view.
        contactsTbl.dataSource = self
        contactsTbl.delegate = self
        contactsTbl.rowHeight = 50
        contactsTbl.sectionHeaderHeight = 50
        
        self.automaticallyAdjustsScrollViewInsets = false
        //signInButton.style = GIDSignInButtonStyle.standard
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().clientID = clientID
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/contacts")

        
        
        signInView.isHidden = true
        
        UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        ////START RECORDING
        //btnRecord.isEnabled = false //2   error
        viewSearchAction.isUserInteractionEnabled = false
        speechRecognizer?.delegate = self   //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in   //4
            
            var isButtonEnable = false
            
            switch authStatus   //5
            {
            case .authorized:
                isButtonEnable = true
            case .denied:
                isButtonEnable = false
                print("User denied access to speech recognition")
            case .notDetermined:
                isButtonEnable = false
                print("Speech recognition not yet authorized")
            case .restricted:
                isButtonEnable = false
                print("Speech recognition restricted on this device")
            }
            
            OperationQueue.main.addOperation {
                //self.btnRecord.isEnabled = isButtonEnable
                self.viewSearchAction.isUserInteractionEnabled = isButtonEnable
            }
        }
        
        ////END RECORDING
        
        setBottomView()
        
        getContactsAPI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func setBottomView() {
        
        viewSearchBarSubView.layer.cornerRadius = 3
        viewSearchBarSubView.clipsToBounds = true
        
        viewSearchBar.isHidden = true
        txtSearchText.delegate = self
        
        //Gesture bottom
        let gestureDashboardSearch = UITapGestureRecognizer(target: self, action:  #selector(self.checkActionSearch))
        viewSearchAction.addGestureRecognizer(gestureDashboardSearch)
        
        let gestureDashboard = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureStart = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureSearch = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureMyAccount = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureHelp = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        
        viewBottomDashborad.addGestureRecognizer(gestureDashboard)
        viewBottomSearch.addGestureRecognizer(gestureSearch)
        viewBottomMyAccount.addGestureRecognizer(gestureMyAccount)
        btnBottomHelp.addGestureRecognizer(gestureHelp)
    }
    
    ///START RECORDING
    func startRecording()
    {
        if recognizationTask != nil
        {
            recognizationTask?.cancel()
            recognizationTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        if #available(iOS 10.0, *) {
            recognizationRequest = SFSpeechAudioBufferRecognitionRequest()
        } else {
            // Fallback on earlier versions
        }
        
        //        guard let iNode = audioEngin.inputNode else {
        //            fatalError("Audio engine has no input node")
        //        }
        
        let iNode = audioEngin.inputNode
        
        guard let recognitionRequest = recognizationRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognizationTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            var isFinal = false
            
            if result != nil
            {
                self.txtSearchText.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
                self.imgSearchMic.image = UIImage(named: "white_arw")
                self.audioEngin.stop()
                self.recognizationRequest?.endAudio()
                UserDefaults.standard.set("arrow", forKey: "MicORArrow")
            }
            
            if error != nil || isFinal
            {
                self.audioEngin.stop()
                iNode.removeTap(onBus: 0)
                
                self.recognizationRequest = nil
                self.recognizationTask = nil
                
                //self.btnRecord.isEnabled = true
                self.viewSearchAction.isUserInteractionEnabled = true
            }
        })
        
        let recordingFormat = iNode.outputFormat(forBus: 0)
        iNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognizationRequest?.append(buffer)
        }
        
        audioEngin.prepare()
        
        do {
            try audioEngin.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        txtSearchText.placeholder = "Say something, I'm listening!"
        //lblText.text = "Say something, I'm listening!"
    }
    
    @available(iOS 10.0, *)
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //btnRecord.isEnabled = true
            viewSearchAction.isUserInteractionEnabled = true
            print("availabilityDidChange = true")
        }
        else {
            //btnRecord.isEnabled = false
            viewSearchAction.isUserInteractionEnabled = false
            print("availabilityDidChange = false")
        }
    }
    
    ///END RECORDING
    @objc func checkActionSearch(sender : UITapGestureRecognizer)
    {
        //UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        if UserDefaults.standard.string(forKey: "MicORArrow") == "mic"
        {
            ///START RECORDING
            if audioEngin.isRunning {
                audioEngin.stop()
                recognizationRequest?.endAudio()
                //btnRecord.isEnabled = false
                //btnRecord.setTitle("Start Recording", for: .normal)
                viewSearchAction.isUserInteractionEnabled = false
            }
            else {
                startRecording()
                //btnRecord.setTitle("Stop Recording", for: .normal)
            }
            
            ///END RECORDING
        }
        else
        {
            print("tap on search")
            if txtSearchText.text != ""
            {
                searchTxt = txtSearchText.text!
                contactsTbl.beginUpdates()
                contactsTbl.endUpdates()
            }
        }
    }
    
    @IBAction func actionClear(_ sender: Any) {
        
        viewSearchBar.isHidden = true
        txtSearchText.text = ""
        
        searchTxt = ""
        imgSearchMic.image = UIImage(named: "mic_white_icon")
        UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        contactsTbl.beginUpdates()
        contactsTbl.endUpdates()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if textField.tag == 1 || textField.tag == 7 || textField.tag == 8 || textField.tag == 9 {
            
            let charset = CharacterSet(charactersIn: Singletone.shareInstance.stringSpaceCharset).inverted
            let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
            return (string == filtered)
        }
        if internalFlag && textField.tag == 2 {
            
            searchTxt = string
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
        }
        
        viewSearchAction.isUserInteractionEnabled = true
        if txtSearchText.text?.count == 0// == ""
        {
            imgSearchMic.image = UIImage(named: "mic_white_icon")
            UserDefaults.standard.set("mic", forKey: "MicORArrow")
        }
        else
        {
            imgSearchMic.image = UIImage(named: "white_arw")
            UserDefaults.standard.set("arrow", forKey: "MicORArrow")
            audioEngin.stop()
            recognizationRequest?.endAudio()
        }
        
        return true
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        print(s!)
        
        switch s! {
        case 100:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")  //dashboard_white_bottom_bar_icon
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")  //launch_white_bottom_bar_icon
            imgSearch.image = UIImage(named: "search_green_icon")  //search_white_icon
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")  //landing_screen_signup_icon
            imgHelp.image = UIImage(named: "help_green_icon")  //help_white_icon
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            viewBottomSearch.isUserInteractionEnabled = true
            viewBottomSearch.backgroundColor = UIColor.white//Singletone.shareInstance.footerviewBackgroundGreen.withAlphaComponent(0.1)
            performSegue(withIdentifier: "segDashboard", sender: self)
            
            
            break
        case 101:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_white_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen.withAlphaComponent(0.1)
            viewBottomSearch.isUserInteractionEnabled = false
            
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            
            break
        case 102:
            viewSearchBar.isHidden = false
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_white_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            
            //            let strImageName: String = (imgSearchMic.image?.accessibilityIdentifier)!
            //            print(strImageName)
            //            print("**")
            
            
            
            break
        case 103:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
            imgHelp.image = UIImage(named: "help_green_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            performSegue(withIdentifier: "segMyAccount", sender: self)
            
            break
        case 104:
            viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")
            imgSearch.image = UIImage(named: "search_green_icon")
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")
            imgHelp.image = UIImage(named: "help_white_icon")
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            UserDefaults.standard.set("Dashboard", forKey: "footerFlag")
            performSegue(withIdentifier: "segContactUs", sender: self)
            break
        default:
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == contactsTbl {
            print("Filterd Count : \(filteredContArr.count)")
            return filteredContArr.count
        }
        else if grpFlag {
            return grpContactsArr.count
        }
        else if linkFlag {
            return linkContactsArr.count
        }
        else {
            /*
            if internalFlag {
                return intContactsArr.count
            }
            return extContactsArr.count
 */
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //contactCell
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        if tableView == contactsTbl {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell") as! LabelCell
            cell.delegate = self
            
            let lblname = cell.viewWithTag(1) as? UILabel
            let lblemail = cell.viewWithTag(11) as? UILabel
            
            let data = filteredContArr[indexPath.row]
            
            if (data.Name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! {
                lblname?.text = "NA"
            } else {
                lblname?.text = data.Name
            }
            
            if data.ContactType == 2 {
                let contacts: Int = data.UserCount!
                lblemail?.text = "\(contacts) contact(s)"
                cell.iconW.constant = 0
            } else {
                lblemail?.text = data.Email
                cell.iconW.constant = 18
            }
            
            if data.UserType == 1 {
                cell.catIcon.image = UIImage(named: "usr_comp_icon")
            } else if data.ContactType == 1 {
                cell.catIcon.image = UIImage(named: "usr_contact_icon")
            }
            
            let logo = cell.viewWithTag(2) as? UIImageView
            if data.IsZorroUser {
                logo?.image = UIImage(named: "zorrosign")
                //logo?.isHidden = false
                //cell.con_logoW.constant = 30
            } else {
                logo?.image = nil
                //logo?.isHidden = true
                //cell.con_logoW.constant = 0
            }
            
            let profIcon = cell.viewWithTag(10) as! UIImageView
            
            if data.ContactType == 2 {
                profIcon.image = UIImage(named:"grp_icon")
            } else {
                if let thumbURL = data.Thumbnail {
                    profIcon.kf.setImage(with: URL(string: thumbURL))
                } else {
                    profIcon.image = UIImage(named:"contact_icon")
                }
            }
            profIcon.layer.cornerRadius = profIcon.frame.size.width / 2;
            profIcon.clipsToBounds = true
            
            let chkbox = cell.btnchk//cell.viewWithTag(4) as? UIButton
            chkbox?.tag = indexPath.row
            chkbox?.isSelected = data.selected
            
            let editBtn = cell.btnedit
            let viewBtn = cell.btnview
            
            editBtn?.accessibilityHint = "1"
            viewBtn?.accessibilityHint = "2"
            
            editBtn?.tag = indexPath.row
            viewBtn?.tag = indexPath.row
            
            return cell
        }
        else if grpFlag {
            if let tablevw = inviteAlertView.viewWithTag(4) as? UITableView {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
                
                if cell == nil {
                    
                    let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                    cell = (arr?[5] as? UITableViewCell)! as? LabelCell
                }
                
                let btnlink = cell?.viewWithTag(4) as! UIButton
                btnlink.accessibilityHint = String(indexPath.row)
                btnlink.addTarget(self, action: #selector(linkAction), for: UIControl.Event.touchUpInside)
                
                
                cell?.delegate = self
                let lbl = cell?.lblName
                var data: ContactsData!
                
                data = grpContactsArr[indexPath.row]
                lbl?.text = data.Name! //+ " " + data.LastName!
                
                cell?.btnchk.tag = indexPath.row
                cell?.btnchk.isSelected = data.selected
                
                /*
                if let collvw = cell?.viewWithTag(6) as? UICollectionView {
                    collvw.accessibilityHint = String(indexPath.row)
                    collvw.delegate = self
                    collvw.dataSource = self
                    
                    collvw.reloadData()
                }
 */
                return cell!
            }
        }
        else if linkFlag {
            if let tablevw = linkAlertView.viewWithTag(4) as? UITableView {
                
                var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
                
                if cell == nil {
                    
                    let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                    cell = (arr?[4] as? UITableViewCell)! as? LabelCell
                }
                
                let btnlink = cell?.viewWithTag(4) as! UIButton
                btnlink.isHidden = true
                
                cell?.delegate = self
                let lbl = cell?.lblName
                var data: ContactsData!
                
                data = linkContactsArr[indexPath.row]
                lbl?.text = data.Name! //+ " " + data.LastName!
                
                cell?.btnchk.tag = indexPath.row
                cell?.btnchk.isSelected = data.selected
                
                return cell!
            }
        }
        else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "labelCell") as? LabelCell
            
            if cell == nil {
                
                let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
                cell = (arr?[0] as? UITableViewCell)! as? LabelCell
            }
            cell?.delegate = self
            let lbl = cell?.lblName as! UILabel
            var data: ContactsData!
            
            if internalFlag {
                data = intContactsArr[indexPath.row]
                lbl.text = data.FirstName! + " " + data.LastName!
            } else {
                data = extContactsArr[indexPath.row]
                lbl.text = data.FullName
            }
            
            
            cell?.btnchk.tag = indexPath.row
            cell?.btnchk.isSelected = data.selected
            
            return cell!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView == contactsTbl {
            let data = filteredContArr[indexPath.row]
            let name: String = data.Name ?? ""//data.FullName!
            let email: String = data.Email ?? ""
            
            if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) && !email.lowercased().contains(searchTxt.lowercased()) {
                return 0
            }
            
            return UITableView.automaticDimension
        }
        else if grpFlag {
            if let tablevw = inviteAlertView.viewWithTag(4) as? UITableView {
                let data = grpContactsArr[indexPath.row]
                let name: String = data.Name ?? ""//data.FullName!
                let email: String = data.Email ?? ""
                
                if !searchTxt.isEmpty && (!name.lowercased().contains(searchTxt.lowercased()) || !email.lowercased().contains(searchTxt.lowercased())) {
                    return 0
                }
            }
            return 115
        }
        else if grpFlag {
        }
        else {
            /*
            if internalFlag {
                let data = intContactsArr[indexPath.row]
                let name: String = data.FirstName! + " " + data.LastName!
                
                if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) {
                    return 0
                }
            } else {
                let data = extContactsArr[indexPath.row]
                let name: String = data.Name!
                
                if !searchTxt.isEmpty && !name.lowercased().contains(searchTxt.lowercased()) {
                    return 0
                }
                
            }*/
            
        }
        return 50//UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //headerCell
        
        if tableView == contactsTbl {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! LabelCell
        
        let chkAll = header.contentView.viewWithTag(1) as? UIButton
        let btnDel = header.contentView.viewWithTag(3) as? UIButton
        
        let btnsort = header.contentView.viewWithTag(2) as? UIButton
            btnsort?.setTitle(sortTitle, for: UIControl.State.normal)
            
        let addext = header.contentView.viewWithTag(4) as? UIButton
        let impext = header.contentView.viewWithTag(5) as? UIButton
        let addint = header.contentView.viewWithTag(6) as? UIButton
        let invite = header.contentView.viewWithTag(7) as? UIButton
            
            
            let arr = filteredContArr.filter{ ($0.selected == true) }
            if (arr.count == filteredContArr.count) && filteredContArr.count > 0 {
                chkAll?.isSelected = true
            } else {
                chkAll?.isSelected = false
            }
            
            chkAll?.addTarget(self, action: #selector(selectAllAction), for: UIControl.Event.touchUpInside)
        //chkAll?.isSelected = selectAllFlag
        
            btnDel?.addTarget(self, action: #selector(deleteAction), for: UIControl.Event.touchUpInside)
            
            addext?.addTarget(self, action: #selector(addContactClicked), for: UIControl.Event.touchUpInside)
            impext?.addTarget(self, action: #selector(importAction), for: UIControl.Event.touchUpInside)
            addint?.addTarget(self, action: #selector(addGroupAction), for: UIControl.Event.touchUpInside)
            invite?.addTarget(self, action: #selector(inviteAction), for: UIControl.Event.touchUpInside)
        
        header.contentView.backgroundColor = UIColor(red: 231/255, green: 229/255, blue: 228/255, alpha: 1)
        
        return header.contentView
        }
        
        return nil
    }
    
    func getContactsAPI() {
        
        /*
         {"StatusCode":1000,"Message":"7 entries have been retrieved.","Data":[{"IdNum":23529,"Id":"j8DLjmaI310DqFaH%2Bf228g%3D%3D","ContactProfileId":"rdU3LSrmE28zTnXBeWbL2A%3D%3D","Name":"ABC","Description":"","Email":"abc@abc.com","DepartmentName":null,"Type":1,"Thumbnail":"","UserCount":1,"IsZorroUser":false,"UserType":2,"Company":"HOH","JobTitle":"Tester"}]}
         */
        contactsArr.removeAll()
        grpContactsArr.removeAll()
        linkContactsArr.removeAll()
        filteredContArr.removeAll()
        
        contactsArr = []
        grpContactsArr = []
        linkContactsArr = []
        filteredContArr = []
        
        let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        //let api = "UserManagement/GetContacts?ProfileId=\(profileId)"
        let api = "UserManagement/GetContactSummary?ProfileId=\(profileId)"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        if let jsonData = jsonDic["Data"] as? NSArray {
                            print(jsonData)
                            for dic in jsonData {
                                let contact = ContactsData(dictionary: dic as! [AnyHashable : Any])
                                let contact1 = ContactsData(dictionary: dic as! [AnyHashable : Any])
                                let contact2 = ContactsData(dictionary: dic as! [AnyHashable : Any])
                                
                                self.contactsArr.append(contact)
                                self.filteredContArr.append(contact)
                                self.grpContactsArr.append(contact1)
                                self.linkContactsArr.append(contact2)
                            }
                            self.filterContacts()
                            //self.contactsTbl.reloadData()
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getContactByEmail(id: Int, type: Int) {
        
        let data = filteredContArr[id]
        var email: String = data.Email ?? ""
        
        email = email.addingPercentEncoding(withAllowedCharacters: CharacterSet.rfc3986Unreserved)!
        
        let api = "UserManagement/GetContacts?Email=\(email)"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            /*
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        if let jsonData = jsonDic["Data"] as? NSArray, jsonData.count > 0 {
                            print(jsonData)
                            if let dic = jsonData[0] as? [String:Any] {
                                let contactData = ContactsData(dictionary: dic)
                                self.
             Contact(data: contactData, id: id, type: type)
                            }
                        }
                        else
                        {
                            
                            self.alertSample(strTitle: "", strMsg: "No data")
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
             */
            
            do {
               
                let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "GET"
                request.allHTTPHeaderFields = headerAPIDashboard
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                    }
                    if (error != nil) {
                        print(error)
                    } else {
                        
                        var json: JSON = JSON(data!)
                        
                        if let jsonDic = json.dictionaryObject as? [String:Any] {
                            debugPrint(jsonDic)
                            if let jsonData = jsonDic["Data"] as? NSArray, jsonData.count > 0 {
                                print(jsonData)
                                if let dic = jsonData[0] as? [String:Any] {
                                    DispatchQueue.main.async {
                                        let contactData = ContactsData(dictionary: dic)
                                        self.showContact(data: contactData, id: id, type: type)
                                    }
                                }
                            }
                            else
                            {
                                
                                self.alertSample(strTitle: "", strMsg: "No data")
                            }
                        }
                        else
                        {
                            
                            self.alertSample(strTitle: "", strMsg: "Error from server")
                        }
                    }
                })
                
                dataTask.resume()
            } catch {}
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
        /*
         {"StatusCode":1000,"Message":null,"Data":[{"ProfileId":"BOtwqPvVhvJ56JWW4SkcsA%3D%3D","ContactProfileId":"rlsok77Vyj2jsZn6LEqAqg%3D%3D","FullName":"aa bb cc","FirstName":"aa","MiddleName":"bb","LastName":"cc","DisplayName":"dd","Email":"ee@ff.com","Company":"HOH","JobTitle":"Tester","UserType":2,"ContactId":7133,"DepartmentId":0,"Thumbnail":"DefaultProfileSmall.jpg","DefaultPhone":"","HomePhone":"","MobilePhone":"","InternetEmail":"","HomeEmail":"","WorkEmail":"","CellMsg":"","HomeFax":"","WorkPhone":"","WorkFax":"","Address":null,"AddressList":null,"DobDate":"0001-01-01T00:00:00","IsZorroUser":false,"Other":"","ZorroUserType":null,"Website":""}]}
         */
    }
    
    
    func initAlert(closeTitle: String, type: Int) {
    
        contactAlertView = SwiftAlertView(nibName: "AddContactAlert", delegate: self, cancelButtonTitle: closeTitle, otherButtonTitles: [""])
        //"Apply Changes"
        contactAlertView.tag = 17
        contactAlertView.accessibilityHint = String(type)
        contactAlertView.dismissOnOtherButtonClicked = false
        contactAlertView.highlightOnButtonClicked = false
        
        let txtFName = contactAlertView.viewWithTag(7) as! UITextField
        let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
        let txtLName = contactAlertView.viewWithTag(39) as! UITextField
        
        let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
        let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
        
        txtFName.delegate = self
        txtMidName.delegate = self
        txtLName.delegate = self
        
        txtDispName.delegate = self
        txtEmail.delegate = self
        txtCompName.delegate = self
        txtJobTitle.delegate = self
        
        let closeBtn = contactAlertView.viewWithTag(5) as! UIButton
        //closeBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        
        closeBtn.isHidden = true
        
        
        let headlbl = contactAlertView.viewWithTag(10) as! UILabel
        let addBtn = contactAlertView.viewWithTag(6) as! UIButton
        
        addBtn.isHidden = true
        
        let btnclose = contactAlertView.buttonAtIndex(index: 0)
        let btnadd = contactAlertView.buttonAtIndex(index: 1)
        
        //btnclose?.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        btnclose?.setTitle("CLOSE", for: UIControl.State.normal)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        if type == 0 {
            //addBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
            //btnadd?.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
            btnadd?.setTitle("ADD TO ADDRESSBOOK", for: UIControl.State.normal)
        } else if type == 1 {
            //addBtn.addTarget(self, action: #selector(editAction), for: UIControlEvents.touchUpInside)
            headlbl.text = "Edit Contact"
            btnadd?.addTarget(self, action: #selector(editAction), for: UIControl.Event.touchUpInside)
            btnadd?.setTitle("UPDATE", for: UIControl.State.normal)
        } else if type == 2 {
            headlbl.text = "More Details"
            btnclose?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            btnclose?.setTitleColor(UIColor.white, for: UIControl.State.normal)
            btnadd?.isHidden = true
        }
        
    }
    
    func initViewAlert(closeTitle: String, type: Int) {
        
        viewContactAlertView = SwiftAlertView(nibName: "AddContactAlert", delegate: self, cancelButtonTitle: closeTitle, otherButtonTitles: nil)
        //"Apply Changes"
        viewContactAlertView.tag = 19
        
        let txtFullName = viewContactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = viewContactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = viewContactAlertView.viewWithTag(3) as! UITextField
        let txtJobTitle = viewContactAlertView.viewWithTag(4) as! UITextField
        
        let txtfname = viewContactAlertView.viewWithTag(7) as! UITextField
        let txtmname = viewContactAlertView.viewWithTag(8) as! UITextField
        let txtlname = viewContactAlertView.viewWithTag(39) as! UITextField
        
        txtfname.delegate = self
        txtmname.delegate = self
        txtlname.delegate = self
        txtFullName.delegate = self
        txtEmail.delegate = self
        txtCompName.delegate = self
        txtJobTitle.delegate = self
        
        let closeBtn = viewContactAlertView.viewWithTag(5) as! UIButton
        //closeBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        
        closeBtn.isHidden = true
        
        
        let headlbl = viewContactAlertView.viewWithTag(10) as! UILabel
        let addBtn = viewContactAlertView.viewWithTag(6) as! UIButton
        
        addBtn.isHidden = true
        
        let btnclose = viewContactAlertView.buttonAtIndex(index: 0)
        let btnadd = viewContactAlertView.buttonAtIndex(index: 1)
        
        //btnclose?.addTarget(self, action: #selector(alertButtonClicked), for: UIControlEvents.touchUpInside)
        btnclose?.setTitle("CLOSE", for: UIControl.State.normal)
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        headlbl.text = "More Details"
        btnclose?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnclose?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnadd?.isHidden = true
        
    }
    
    @IBAction func addContactClicked() {
        
        signInView.isHidden = true
        
        initAlert(closeTitle: "", type: 0)
        contactAlertView.show()
    }
    
    @IBAction func closeAction() {
        
        signInView.isHidden = true
    }
    
    @IBAction func addGroupAction() {
        
        let arr = Bundle.main.loadNibNamed("SendEmail", owner: self, options: nil)
        let view = arr![2] as! UIView
        
        addGrpAlertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["NEXT"])
        //"Apply Changes"
        addGrpAlertView.tag = 20
        
        addGrpAlertView.dismissOnOtherButtonClicked = false
        addGrpAlertView.highlightOnButtonClicked = false
        
        let btnclose = addGrpAlertView.buttonAtIndex(index: 0)
        let btnadd = addGrpAlertView.buttonAtIndex(index: 1)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnclose?.backgroundColor = UIColor.white 
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        
        let txtdesc = addGrpAlertView.viewWithTag(2) as! UITextView
        txtdesc.setBorder()
        addGrpAlertView.show()
        
    }
    
    
    @IBAction func viewGroupAction(tag: Int) {
        
        let data = filteredContArr[tag]
        editGrpId = data.IdNum!
        grpName = data.Name!
        grpDesc = data.Description ?? ""
        
        let viewController:GroupDetailsVC = getVC(sbId: "GroupDetailsVC") as! GroupDetailsVC
        
        viewController.grpName = grpName
        viewController.grpDesc = grpDesc
        viewController.groupId = editGrpId
        
        
        let contW: CGFloat = self.view.bounds.width - 80
        let popOverHeight = self.view.frame.size.height / 2
        
        viewController.preferredContentSize = CGSize(width: contW, height: popOverHeight)
        navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .popover
        navController.isNavigationBarHidden = true
        if let pctrl = navController.popoverPresentationController {
            //pctrl.delegate = self
            pctrl.sourceView = self.view
            pctrl.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            pctrl.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func editGroupAction(tag: Int) {
        
        editGrpFlag = true
        
        let data = filteredContArr[tag]
        editGrpId = data.IdNum!
        
        let arr = Bundle.main.loadNibNamed("SendEmail", owner: self, options: nil)
        let view = arr![2] as! UIView
        
        addGrpAlertView = SwiftAlertView(contentView: view, delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["NEXT"])
        //"Apply Changes"
        addGrpAlertView.tag = 22
        
        let btnclose = addGrpAlertView.buttonAtIndex(index: 0)
        let btnadd = addGrpAlertView.buttonAtIndex(index: 1)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        let txtname = addGrpAlertView.viewWithTag(1) as! UITextField
        let txtdesc = addGrpAlertView.viewWithTag(2) as! UITextView
        
        txtname.text = data.Name
        txtdesc.text = data.Description
        
        txtdesc.setBorder()
        addGrpAlertView.show()
        
    }
    
    @IBAction func showGrpContactAlert() {
        
        inviteAlertView = SwiftAlertView(nibName: "InviteAlert", delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["CREATE"])
        //"Apply Changes"
        inviteAlertView.tag = 21
        inviteAlertView.delegate = self
        
        inviteAlertView.highlightOnButtonClicked = false
        
        let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.reloadData()
        
        
        let txtfld = inviteAlertView.viewWithTag(2) as! UITextField
        txtfld.isHidden = true
        
        
        let lblHead = inviteAlertView.viewWithTag(5) as? UILabel
        //lblHead?.text = "Message (optional):"
        
        let lblTitle = inviteAlertView.viewWithTag(12) as? UILabel
        lblTitle?.text = "Add Contacts to Group"
        
        let btnclose = inviteAlertView.buttonAtIndex(index: 0)
        let btnsend = inviteAlertView.buttonAtIndex(index: 1)
        
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let btnSelectAll = inviteAlertView.viewWithTag(21) as? UIButton
        let btnSearch = inviteAlertView.viewWithTag(24) as? UIButton
        
        btnSelectAll?.addTarget(self, action: #selector(selectAllInvite), for: UIControl.Event.touchUpInside)
        
        btnSearch?.addTarget(self, action: #selector(searchInvite), for: UIControl.Event.touchUpInside)
        
        inviteAlertView.show()
    }
    
    func showGrp() {
        
        let viewController:LinkContactVC = getVC(sbId: "LinkContactVC") as! LinkContactVC
        
        let grpcontacts = self.grpContactsArr.filter{ ($0.ContactType == 1) }
        let linkcontacts = self.linkContactsArr.filter{ ($0.ContactType == 1) }
        
        if editGrpFlag {
            viewController.groupId = editGrpId
            editGrpFlag = false
        } else {
            for data in grpContactsArr {
                data.selected = false
                data.linkedContacts.removeAll()// = []
            }
            for data in linkContactsArr {
                data.selected = false
                data.linkedContacts.removeAll() //= []
            }
        }
        viewController.grpContactsArr = grpcontacts
        viewController.linkContactsArr = linkcontacts
        viewController.grpName = grpName
        viewController.grpDesc = grpDesc
        
        viewController.popdelegate = self
        
        let contW: CGFloat = self.view.bounds.width - 80
        let popOverHeight = self.view.frame.size.height / 2
        
        viewController.preferredContentSize = CGSize(width: contW, height: popOverHeight)
        navController = UINavigationController(rootViewController: viewController)
        navController.modalPresentationStyle = .popover
        navController.isNavigationBarHidden = true
        if let pctrl = navController.popoverPresentationController {
            //pctrl.delegate = self
            pctrl.sourceView = self.view
            pctrl.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            pctrl.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)
            self.present(navController, animated: true, completion: nil)
        }
        
        
    }
    
    func addGroupAPI() {
        
        /*
         ["Thumbnail": "DefaultProfileSmall.jpg", "Contacts": [["PrimaryContact": ["ContactId": 23602, "ContactProfileId": "xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"], "SecondaryContact": [["ContactId": 273, "ContactProfileId": ""]]]], "Name": "hoh", "Description": ""]
         ["Thumbnail": "DefaultProfileSmall.jpg", "Contacts": [["PrimaryContact": ["ContactId": 23602, "ContactProfileId": "xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"], "SecondaryContact": [["ContactId": 273, "ContactProfileId": ""]]]], "Name": "hoh", "Description": ""]
         ["Data": 276, "StatusCode": 1000, "Message": User group created successfully. But no contacts provided for the group.]
         */
        /*
         {"Name":"iOS","Description":"","Thumbnail":"DefaultProfileSmall.jpg","Contacts":[{"PrimaryContact":{"ContactId":23602,"ContactProfileId":"xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"},"SecondaryContact":[]},{"PrimaryContact":{"ContactId":23571,"ContactProfileId":"xyTqTzovWjPm98Q03wxxjg%3D%3D"},"SecondaryContact":[]}]}
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/CreateContactGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let selGrpContacts = grpContactsArr.filter{ ($0.selected == true) }
        
        var pricont: [[String:Any]] = []
        
        for contactdata in selGrpContacts {
            var secgrp: [[String:Any]] = []
            
            for sec in contactdata.linkedContacts {
                let secId: Int = sec.IdNum!
                let profId: String = sec.ContactProfileId!
                secgrp.append(["ContactId":secId,"ContactProfileId":profId])
            }
            let priId: Int = contactdata.IdNum!
            let profId: String = contactdata.ContactProfileId!
            
            pricont.append(["PrimaryContact":["ContactId":priId,"ContactProfileId":profId],"SecondaryContact":secgrp])
        }
        
        let parameters = ["Name":grpName,"Description":grpDesc,"Thumbnail":"DefaultProfileSmall.jpg","Contacts":pricont] as [String : Any] //contactObj!.toDictionary()
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Group created successfully")
                            
                            
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @IBAction func linkAction(_ sender: UIButton) {
        
        let tag: Int = Int(sender.accessibilityHint!)!
        selLinkContact = grpContactsArr[tag]
        
        grpFlag = false
        linkFlag = true
        //linkContactsArr.append(contentsOf: contactsArr)
        
        linkAlertView = SwiftAlertView(nibName: "InviteAlert", delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["CREATE"])
        //"Apply Changes"
        linkAlertView.tag = 24
        linkAlertView.delegate = self
        let tablevw = linkAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        
        let txtfld = linkAlertView.viewWithTag(2) as! UITextField
        txtfld.isHidden = true
        
        
        let lblTitle = linkAlertView.viewWithTag(12) as? UILabel
        lblTitle?.text = "Select Contacts to Link"
        
        let btnclose = linkAlertView.buttonAtIndex(index: 0)
        let btnsend = linkAlertView.buttonAtIndex(index: 1)
        
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let btnSelectAll = linkAlertView.viewWithTag(21) as? UIButton
        let btnSearch = linkAlertView.viewWithTag(24) as? UIButton
        
        btnSelectAll?.addTarget(self, action: #selector(selectAllInvite), for: UIControl.Event.touchUpInside)
        
        btnSearch?.addTarget(self, action: #selector(searchInvite), for: UIControl.Event.touchUpInside)
        
        linkAlertView.show()
    }
    
    func addLinkAPI() {
        
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/CreateContactGroup"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let txtname = addGrpAlertView.viewWithTag(1) as! UITextField
        let txtdscr = addGrpAlertView.viewWithTag(2) as! UITextView
        
        let grpname: String = txtname.text!
        let grpdesc: String  = txtdscr.text ?? ""
        
        
        let parameters = ["Name":grpname,"Description":grpdesc,"Thumbnail":"DefaultProfileSmall.jpg","Contacts":[["PrimaryContact":["ContactId":23602,"ContactProfileId":"xmTOmTS9dBq5C%2FPCwO9BLw%3D%3D"],"SecondaryContact":[]],["PrimaryContact":["ContactId":23571,"ContactProfileId":"xyTqTzovWjPm98Q03wxxjg%3D%3D"],"SecondaryContact":[]]]] as! [String:Any]//contactObj!.toDictionary()
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contact added successfully")
                            
                            
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func showContact(data: ContactsData, id: Int, type: Int) {
        
        contactObj = data
        
        if type == 2 {
            //initAlert(closeTitle: "CLOSE", type: type)
            initViewAlert(closeTitle: "CLOSE", type: type)
            
            let txtFullName = viewContactAlertView.viewWithTag(1) as! UITextField
            let txtEmail = viewContactAlertView.viewWithTag(2) as! UITextField
            let txtCompName = viewContactAlertView.viewWithTag(3) as! UITextField
            let txtJobTitle = viewContactAlertView.viewWithTag(4) as! UITextField
            
            let txtfname = viewContactAlertView.viewWithTag(7) as! UITextField
            let txtmname = viewContactAlertView.viewWithTag(8) as! UITextField
            let txtlname = viewContactAlertView.viewWithTag(39) as! UITextField
            
            txtEmail.isEnabled = false
            txtEmail.isUserInteractionEnabled = false
            
            //let data = contactsArr[id]
            txtfname.text = data.FirstName
            txtmname.text = data.MiddleName
            txtlname.text = data.LastName
            txtFullName.text = data.DisplayName//data.FullName
            txtEmail.text = data.Email
            txtCompName.text = data.Company
            txtJobTitle.text = data.JobTitle
            
            txtfname.isEnabled = false
            txtmname.isEnabled = false
            txtlname.isEnabled = false
            txtFullName.isEnabled = false
            txtEmail.isEnabled = false
            txtCompName.isEnabled = false
            txtJobTitle.isEnabled = false
            
            
            let closeBtn = viewContactAlertView.viewWithTag(5) as! UIButton
            closeBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControl.Event.touchUpInside)
            
            let addBtn = viewContactAlertView.viewWithTag(6) as! UIButton
            
            txtFullName.isEnabled = false
            txtEmail.isEnabled = false
            txtCompName.isEnabled = false
            txtJobTitle.isEnabled = false
            
            addBtn.isHidden = true
            closeBtn.isHidden = true
            
            viewContactAlertView.show()
            
        } else if type == 1 {
            initAlert(closeTitle: "", type: type)
            
            let txtFName = contactAlertView.viewWithTag(7) as! UITextField
            let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
            let txtLName = contactAlertView.viewWithTag(39) as! UITextField
            
            let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
            let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
            let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
            let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
            
            txtEmail.isEnabled = false
            txtEmail.isUserInteractionEnabled = false
            
            //let data = contactsArr[id]
            txtFName.text = data.FirstName
            txtMidName.text = data.MiddleName
            txtLName.text = data.LastName
            
            txtDispName.text = data.DisplayName
            txtEmail.text = data.Email
            txtCompName.text = data.Company
            txtJobTitle.text = data.JobTitle
            
            txtFName.isEnabled = true
            txtMidName.isEnabled = true
            txtLName.isEnabled = true
            txtDispName.isEnabled = true
            txtEmail.isEnabled = true
            txtCompName.isEnabled = true
            txtJobTitle.isEnabled = true
            
            let closeBtn = contactAlertView.viewWithTag(5) as! UIButton
            closeBtn.addTarget(self, action: #selector(alertButtonClicked), for: UIControl.Event.touchUpInside)
            
            let addBtn = contactAlertView.viewWithTag(6) as! UIButton
            
            if type == 2 {
                txtFName.isEnabled = false
                txtMidName.isEnabled = false
                txtLName.isEnabled = false
                
                txtDispName.isEnabled = false
                txtEmail.isEnabled = false
                txtCompName.isEnabled = false
                txtJobTitle.isEnabled = false
                
                addBtn.isHidden = true
                closeBtn.isHidden = true
                
            } else if type == 1 {
                addBtn.setTitle("UPDATE", for: UIControl.State.normal)
                addBtn.tag = id
                addBtn.addTarget(self, action: #selector(editAction), for: UIControl.Event.touchUpInside)
                
                let btnclose = contactAlertView.buttonAtIndex(index: 0)
                
                btnclose?.backgroundColor = UIColor.white
            }
            
            if data.UserType == 1 {
                
                txtFName.isEnabled = false
                txtMidName.isEnabled = false
                txtLName.isEnabled = false
                txtEmail.isEnabled = false
                txtCompName.isEnabled = false
                txtJobTitle.isEnabled = false
            }
            
            contactAlertView.show()
        }
    }
    
    func onEditClicked(id: Int, type: Int) {
        
        print("id: \(id), type: \(type)")
        if id < filteredContArr.count {
            let data = filteredContArr[id]
            
            if data.ContactType == 2 {
                
                if type == 2 {
                    
                    viewGroupAction(tag: id)
                    
                } else {
                    editGroupAction(tag: id)
                }
                
            } else {
                
                getContactByEmail(id: id, type: type)
                
                
            }
        }
    }
    
    func validateFields() -> Bool {
        
        let txtFName = contactAlertView.viewWithTag(7) as! UITextField
        let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
        let txtLName = contactAlertView.viewWithTag(39) as! UITextField
        
        let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
        //let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
        
        let errFName = contactAlertView.viewWithTag(31) as! UILabel
        //let errDispName = contactAlertView.viewWithTag(11) as! UILabel
        let errEmail = contactAlertView.viewWithTag(32) as! UILabel
        
        let email: String = txtEmail.text!
        
        errFName.text = ""
        errEmail.text = ""
        
        if (txtFName.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "First name should not be empty")
            errFName.text = "First name should not be empty"
            return false
        }
        else if (txtLName.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "Last name should not be empty")
            errFName.text = "Last name should not be empty"
            return false
        }
        else if (txtEmail.text?.isEmpty)! {
            //alertSample(strTitle: "", strMsg: "Email should not be empty")
            errEmail.text = "Email should not be empty"
            return false
        }
        else if Singletone.shareInstance.isValidEmail(testStr: email) == false {
            //alertSample(strTitle: "", strMsg: "Email should be in valid format")
            errEmail.text = "Email should be in valid format"
            return false
        }
            /*
        else if (txtCompName.text?.isEmpty)! {
            alertSample(strTitle: "", strMsg: "Company should not be empty")
            return false
        }*/
        return true
    }
    
    @IBAction func alertButtonClicked (_ sender: Any) {
    
        let btn = (sender as! UIButton)
        let tag = btn.tag
        
        if tag == 5 {
            contactAlertView.dismiss()
        }
        if tag == 6 {
         
            let txtFName = contactAlertView.viewWithTag(7) as! UITextField
            let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
            let txtLName = contactAlertView.viewWithTag(39) as! UITextField
            
            let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
            let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
            let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
            let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
            
            contactObj = ContactsData()
            //let fullName = txtFName.text + " " + txtMidName.text + " " + txtLName.text
            
            //contactObj?.Name = fullName //txtFullName.text
            contactObj?.FirstName = txtFName.text
            contactObj?.MiddleName = txtMidName.text
            contactObj?.LastName = txtLName.text
            contactObj?.DisplayName = txtDispName.text
            contactObj?.Email = txtEmail.text
            contactObj?.Company = txtCompName.text
            contactObj?.JobTitle = txtJobTitle.text
            
            let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
            contactObj?.ProfileId = profileId
            contactObj?.UserType = 2
            
            if validateFields() {
                contactAlertView.dismiss()
                addContactAPI()
            }
        }
    }
    
    @objc @IBAction func editAction(_ sender: Any) {
        
        let button = sender as! UIButton
        let id = button.tag
        
        let txtFName = contactAlertView.viewWithTag(7) as! UITextField
        let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
        let txtLName = contactAlertView.viewWithTag(39) as! UITextField
        
        let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
        let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
        let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
        let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
        
        //contactObj = contactsArr[id]
        
        //let fullName = txtFName.text + " " + txtMidName.text + " " + txtLName.text
        
        //contactObj?.Name = fullName //txtFullName.text
        contactObj?.FirstName = txtFName.text
        contactObj?.MiddleName = txtMidName.text
        contactObj?.LastName = txtLName.text
        contactObj?.DisplayName = txtDispName.text
        contactObj?.Email = txtEmail.text
        contactObj?.Company = txtCompName.text
        contactObj?.JobTitle = txtJobTitle.text
        
        
        
        let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        contactObj?.ProfileId = profileId
        
        
        if validateFields() {
            contactAlertView.dismiss()
            editContactAPI()
        }
    }
    
    func addContactAPI() {
        
        /* {"Firstname":"A","MiddleName":"B","Lastname":"C","DisplayName":"ABC","Email":"abc@abc.com","Company":"HOH","JobTitle":"Tester"}
         
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/CreateContact"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        
        let fname: String = (contactObj?.FirstName)!
        let midname: String  = (contactObj?.MiddleName)!
        let lname: String = (contactObj?.LastName)!
        let dispname: String = (contactObj?.DisplayName)!
        let email: String = (contactObj?.Email)!
        let company: String = (contactObj?.Company)!
        let jobtitle: String = (contactObj?.JobTitle)!
        
        let parameters = ["Firstname": fname,"MiddleName": midname,"Lastname": lname,"DisplayName": dispname,"Email": email,"Company": company,"JobTitle": jobtitle] as! [String:Any]//contactObj!.toDictionary()
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contact added successfully")
                            
                            self.getContactsAPI()
                            
                        } else if statusCode == 3561 {
                            
                            if self.selIntContactsArr.count > 0 && self.selCnt < self.selIntContactsArr.count {
                                self.selCnt = self.selCnt + 1
                                self.addIntContact()
                            } else {
                                self.getContactsAPI()
                            }
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func editContactAPI() {
        
        /*
         {"ProfileId":"BOtwqPvVhvJ56JWW4SkcsA%3D%3D","ContactProfileId":"EMww7R7s82Nx2o379r18dA%3D%3D","FullName":"Prajakta Bhagwat Pawar","FirstName":"Prajakta","MiddleName":"Bhagwat","LastName":"Pawar","DisplayName":"Prajuu","Email":"prajakta.hoh@gmail.com","Company":"Test Legal Name","JobTitle":"tester","UserType":1,"ContactId":7123,"DepartmentId":278,"Thumbnail":"oxDjHZBBokSWFFRwyyDZuw.png","DefaultPhone":"123456789","HomePhone":"","MobilePhone":"","InternetEmail":"","HomeEmail":"","WorkEmail":"","CellMsg":"","HomeFax":"","WorkPhone":"","WorkFax":"","Address":null,"AddressList":null,"DobDate":"0001-01-01T00:00:00","IsZorroUser":true,"Other":"","ZorroUserType":null,"Website":""}
         
         ["DefaultPhone": "", "Email": "prajakta.hoh@gmail.com", "WorkFax": "", "LastName": "Pawar", "DisplayName": "Prajuuuuuuu", "ContactProfileId": "8Ls7KYhQyR16PUhy6xvCuA%3D%3D", "ContactId": 0, "MiddleName": "Bhagwat", "InternetEmail": "", "WorkPhone": "", "Address": "<null>", "ZorroUserType": "<null>", "HomePhone": "", "Company": "Test Legal Name", "Thumbnail": "", "FullName": "", "DepartmentId": 0, "WorkEmail": "", "HomeEmail": "", "HomeFax": "", "JobTitle": "tester", "IsZorroUser": false, "DobDate": "", "CellMsg": "", "AddressList": [], "ProfileId": "BOtwqPvVhvJ56JWW4SkcsA%3D%3D", "FirstName": "Prajakta", "ThumbnailURL": "", "MobilePhone": "", "Website": "", "UserType": 2, "Other": ""]
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/UpdateContact"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let parameters = contactObj!.toDictionary()
        
        print("editcontact: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contact updated successfully")
                            self.getContactsAPI()
                        } else {
                            let errmsg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: errmsg)
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @objc func deleteAction() {
        
        let delArr = contactsArr.filter{ ($0.selected == true) }
        if delArr.count > 0 {
            let alert = UIAlertController(title: "", message: "Are you sure you want to delete selected contacts?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                
                let internalArr = self.contactsArr.filter{ ($0.selected == true && $0.UserType == 1) }
                let delArr = self.contactsArr.filter{ ($0.selected == true && $0.ContactType == 1 && $0.UserType != 1 ) }
                
                if internalArr.count > 0 {
                    self.alertSample(strTitle: "", strMsg: "User can not delete internal contacts")
                }
                if delArr.count > 0 {
                    self.deleteContactsAPI()
                }
                
                let delGrpArr = self.contactsArr.filter{ ($0.selected == true && $0.ContactType == 2) }
                if delGrpArr.count > 0 {
                    self.deleteContactGroupAPI()
                }
            }))
            alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
            self.present(alert, animated: true)
        } else {
            alertSample(strTitle: "", strMsg: "Please select at least one contact")
        }
    }
    
    func deleteContactsAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/DeleteContacts"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let delArr = contactsArr.filter{ ($0.selected == true && $0.ContactType == 1) }
        
        var contactIdArr: [Int] = []
        for data in delArr {
            if let contactId = data.IdNum {
                contactIdArr.append(contactId)
            }
        }
        
        let parameters = contactIdArr //as [String: Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contacts deleted successfully")
                            self.getContactsAPI()
                        } else {
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func deleteContactGroupAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "UserManagement/DeleteContactGroups"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let delArr = contactsArr.filter{ ($0.selected == true && $0.ContactType == 2) }
        
        var contactIdArr: [Int] = []
        for data in delArr {
            if let contactId = data.IdNum {
                contactIdArr.append(contactId)
            }
        }
        
        let parameters = contactIdArr //as [String: Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Contacts deleted successfully")
                            self.getContactsAPI()
                        } else {
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func stringArrayToNSData(array: [Int]) -> NSData {
        let data = NSMutableData()
        let terminator = [0]
        for string in array {
            var id: Int = string
            let encodedString = Data(bytes: &id, count: MemoryLayout.size(ofValue: id)) //{
                //string.data(using: String.Encoding.utf8) {
                data.append(encodedString)
                //data.append(terminator, length: 1)
           /* }
            else {
                NSLog("Cannot encode string \"\(string)\"")
            }*/
        }
        return data
    }
    
    func onChecked(id: Int, flag: Bool)
    {
        if selectAllFlag {
            selectAllFlag = false
            
        }
        /*
        if inviteFlag {
            
            let data = extContactsArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
            let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
            
        }
            
        else if grpFlag {
            
            let data = grpContactsArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
            let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
            
        }
        else if linkFlag {
            
            let data = linkContactsArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
            
        }
        else if internalFlag {
            
            let data = intContactsArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        }
        else {*/
            let data = filteredContArr[id]
            if flag {
                data.selected = true
            } else {
                data.selected = false
            }
        
        
            contactsTbl.reloadData()
        //}
    }
    
    @objc func selectAllAction(_ sender: Any) {
        
        let btn = sender as! UIButton
        
        btn.isSelected = !btn.isSelected
        selectAllFlag = btn.isSelected
        
        for data in contactsArr {
            
            data.selected = selectAllFlag
        }
        
        
        contactsTbl.reloadData()
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
     
        if buttonIndex == 0 {
            if alertView.tag == 14 {
                inviteFlag = false
                
                for data in extContactsArr {
                    data.selected = false
                }
            }
            if alertView.tag == 41 {
                internalFlag = false
            }
            if alertView.tag == 24 {
                grpFlag = true
                linkFlag = false
                
                showGrpContactAlert()
            }
        }
        if buttonIndex == 1 {
            
            if alertView.tag == 17 {
                let hint = Int(alertView.accessibilityHint!)
                
                if hint != 1 {
                    
                    let txtFName = contactAlertView.viewWithTag(7) as! UITextField
                    let txtMidName = contactAlertView.viewWithTag(8) as! UITextField
                    let txtLName = contactAlertView.viewWithTag(39) as! UITextField
                    
                    let txtDispName = contactAlertView.viewWithTag(1) as! UITextField
                    let txtEmail = contactAlertView.viewWithTag(2) as! UITextField
                    let txtCompName = contactAlertView.viewWithTag(3) as! UITextField
                    let txtJobTitle = contactAlertView.viewWithTag(4) as! UITextField
                    
                    contactObj = ContactsData()
                    contactObj?.FirstName = txtFName.text
                    contactObj?.MiddleName = txtMidName.text
                    contactObj?.LastName = txtLName.text
                    contactObj?.DisplayName = txtDispName.text
                    contactObj?.Email = txtEmail.text
                    contactObj?.Company = txtCompName.text
                    contactObj?.JobTitle = txtJobTitle.text
                    
                    let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
                    contactObj?.ProfileId = profileId
                    contactObj?.UserType = 2
                    
                    if validateFields() {
                        contactAlertView.dismiss()
                        addContactAPI()
                    }
                }
            }
            if alertView.tag == 14 {
                submitInviteAction()
            }
            if alertView.tag == 41 {
                submitInternalAction()
            }
            if alertView.tag == 20 {
            
                let txtname = addGrpAlertView.viewWithTag(1) as! UITextField
                let txtdesc = addGrpAlertView.viewWithTag(2) as! UITextView
                
                if (txtname.text?.isEmpty)! {
                    let errname = addGrpAlertView.viewWithTag(3) as! UILabel
                    errname.isHidden = false
                } else {
                    let errname = addGrpAlertView.viewWithTag(3) as! UILabel
                    errname.isHidden = true
                    grpName = txtname.text!
                    grpDesc = txtdesc.text ?? ""
                    
                    grpFlag = true
                    //grpContactsArr.append(contentsOf: contactsArr)
                    
                    //showGrpContactAlert()
                    addGrpAlertView.dismiss()
                    showGrp()
                }
            }
            if alertView.tag == 21 {
                let arr = grpContactsArr.filter{ ($0.selected == true) }
                
                if arr.count > 0 {
                    addGroupAPI()
                }
            }
            if alertView.tag == 22 {
                
                let txtname = addGrpAlertView.viewWithTag(1) as! UITextField
                let txtdesc = addGrpAlertView.viewWithTag(2) as! UITextView
                
                if (txtname.text?.isEmpty)! {
                    let errname = addGrpAlertView.viewWithTag(3) as! UILabel
                    errname.isHidden = false
                } else {
                    let errname = addGrpAlertView.viewWithTag(3) as! UILabel
                    errname.isHidden = true
                    grpName = txtname.text!
                    grpDesc = txtdesc.text ?? ""
                    
                    grpFlag = true
                    
                    showGrp()
                }
                
            }
            if alertView.tag == 24 {
                
                let arr = linkContactsArr.filter{ ($0.selected == true) }
                
                if arr.count > 0 {
                    selLinkContact.linkedContacts.append(contentsOf: arr)
                }
                
                grpFlag = true
                linkFlag = false
                
                //showGrpContactAlert()
                showGrp()
            }
        }
        
    }
    
    override func didDismissAlertView(alertView: SwiftAlertView) {
        
        if alertView.tag == 14 {
            inviteFlag = false
        }
    }
    
    @IBAction func importAction(_ sender: Any) {
        
        if FeatureMatrix.shared.import_contatcs {
            signInView.isHidden = false
            GIDSignIn.sharedInstance().signOut()
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
        //GIDSignIn.sharedInstance().signInSilently()
    }
    
    @IBAction func signInAction(_ sender: Any) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "segDashboard", sender: self)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        //self.stopActivityIndicator()
        DispatchQueue.main.async {
            self.signInView.isHidden = true
        }
        
        if error == nil {
            let userId = user?.userID//111383689183852664266
            getPeopleList(userId: userId!)
        }
    }
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    
    func getPeopleList(userId: String) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let token: String = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        let urlString = "https://www.google.com/m8/feeds/contacts/default/full?access_token=\(token)"

        //let urlString = "https://www.googleapis.com/plus/v1/people/\(userId)"
            //("https://www.googleapis.com/plus/v1/people/me/people/visible?access_token=\(token)")
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration)
        
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            self.stopActivityIndicator()
            
            let HTTPStatusCode = (response as! HTTPURLResponse).statusCode
            if HTTPStatusCode == 200 && error == nil {
                
                let xml = try! XML.parse(data!)
                print("xml: \(xml)")
                for entry in xml["feed","entry"] {
                    let email: String = entry["gd:email"].attributes["address"] ?? ""
                    let name: String = entry["title"].text ?? ""
                    print("email: \(email)")
                    let profileId = ZorroTempData.sharedInstance.getProfileId()
                    /*
                    let contactData = ContactsData()
                    contactData.FullName = name
                    contactData.Email = email
                    
                    contactData.ProfileId = profileId
                    contactData.UserType = 2
 */
                    let dic = ["ProfileId": profileId,
                               "FullName": name,
                               "Email": email,
                               "UserType": 2,
                               "FirstName": name,
                               "MiddleName": "",
                               "LastName": ""] as [String : Any]
                    //contactData.toDictionary()
                    self.googleContactsArr.append(dic)
                    
                }
                
                self.createContactListAPI()
            }
            else {
                print(HTTPStatusCode)
                print(error)
            }
            })
        
        task.resume()
        
    }
    
    func getAllProfiles() {
        
        //https://zsdemowebuser.zorrosign.com/api/UserManagement/GetAllProfiles?organizationId=%252F6jKdgcwNkwHHaiKTQu8dA%253D%253D
        
        self.showActivityIndicatory(uiView: self.view)
        
        let orgId: String = UserDefaults.standard.string(forKey: "OrganizationId")!
        let api = "UserManagement/GetAllProfiles?organizationId=\(orgId)"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        if let jsonData = jsonDic["Data"] as? NSArray {
                            print(jsonData)
                            for dic in jsonData {
                                let contact = ContactsData(dictionary: dic as! [AnyHashable : Any])
                                self.intContactsArr.append(contact)
                            }
                            
                            if self.intContactsArr.count > 0 {
                                DispatchQueue.main.async {
                                    
                                    self.initInternalAlertView()
                                    //self.contactsTbl.reloadData()
                                    self.internalAlertView.show()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.alertSample(strTitle: "", strMsg: "No internal contacts")
                                }
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "No internal contacts")
                            }
                        }
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
    }
    
    func createContactListAPI() {
        
        DispatchQueue.main.async {
            self.showActivityIndicatory(uiView: self.view)
            
            let api = "UserManagement/CreateContactList"
            var apiURL = Singletone.shareInstance.apiURL
            apiURL = apiURL + api
            
            let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
            let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
            
            let parameters = ["Contacts": self.googleContactsArr]  //contactObj!.toDictionary()
            
            
            if Connectivity.isConnectedToInternet() == true
            {
                
                Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                    .responseJSON { response in
                        
                        self.stopActivityIndicator()
                        var json: JSON = JSON(response.data!)
                        if let jsonDic = json.dictionaryObject as? [String:Any] {
                            debugPrint(jsonDic)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            if statusCode == 3609 {
                                DispatchQueue.main.async {
                                    self.alertSample(strTitle: "", strMsg: "Contacts imported successfully")
                                    GIDSignIn.sharedInstance().signOut()
                                }
                                
                                self.getContactsAPI()
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "Error from server")
                            }
                        }
                }
                
            }
            else
            {
                self.alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
            }
        }
    }
    
    func getGmailList() {
        
        let token: String = GIDSignIn.sharedInstance().currentUser.authentication.accessToken
        let urlString = ("https://www.googleapis.com/plus/v1/people/me/people/visible?access_token=\(token)")
        let url = NSURL(string: urlString)
        
        do {
            
            let request = NSMutableURLRequest(url: url! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                //if HTTPStatusCode == 200 && error == nil {
                    var resultsDictionary: JSON = JSON(data!)
                if resultsDictionary["error"] == nil {
                    // Get the array with people data dictionaries.
                    let peopleArray = resultsDictionary["items"] as! Array<Dictionary<NSObject, AnyObject>>
                    
                    // For each item get the display name and download the picture.
                    // Store these values in a new dictionary, and then in the peopleDataArray array.
                    for item in peopleArray {
                        /*
                        var dictionary = Dictionary<NSObject, AnyObject>()
                        dictionary["displayName"] = item["displayName"] as! String
                        
                        let imageURLString = (item["image"] as! Dictionary<NSObject, AnyObject>)["url"] as! String
                        dictionary["imageData"] = NSData(contentsOfURL: NSURL(string: imageURLString)!)
 
                        self.peopleDataArray.append(dictionary)
 */
                    }
                    
                    // Reload the tableview data.
                    //self.contactsTbl.reloadData()
                /*}
                else {
                    println(HTTPStatusCode)
                    println(error)
                }*/
                }
            })
            
            dataTask.resume()
        } catch {}
        
    }
    
    @IBAction func internalAction() {
        
        if intContactsArr.count == 0 {
            
            getAllProfiles()
        
        } else {
         
            initInternalAlertView()
            internalAlertView.show()
        }
    }
    
    func initInternalAlertView(){
        
        internalFlag = true
        
        internalAlertView = SwiftAlertView(nibName: "InviteAlert", delegate: self, cancelButtonTitle: "CLOSE", otherButtonTitles: ["ADD TO ADDRESS BOOK"])
        //"Apply Changes"
        internalAlertView.tag = 41
        internalAlertView.delegate = self
        let tablevw = internalAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.sectionHeaderHeight = 0
        tablevw.reloadData()
        
        let txtfld = internalAlertView.viewWithTag(2) as! UITextField
        //txtfld.delegate = self
        txtfld.isHidden = true
        /*
        let btnapply = internalAlertView.viewWithTag(10) as? UIButton
        btnapply?.setTitle("ADD TO ADDRESS BOOK", for: UIControlState.normal)
        btnapply?.addTarget(self, action: #selector(submitInternalAction), for: UIControlEvents.touchUpInside)
        
        let btnmanage = internalAlertView.viewWithTag(11) as? UIButton
        btnmanage?.isHidden = true
        */
        
        let lblHead = internalAlertView.viewWithTag(5) as? UILabel
        //lblHead?.text = "Search"
        lblHead?.isHidden = true
        
        let lblTitle = internalAlertView.viewWithTag(12) as? UILabel
        lblTitle?.text = "Add Internal Contact"
        
        let btnclose = internalAlertView.buttonAtIndex(index: 0)
        let btnsend = internalAlertView.buttonAtIndex(index: 1)
        
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let btnSelectAll = internalAlertView.viewWithTag(21) as? UIButton
        let btnSearch = internalAlertView.viewWithTag(24) as? UIButton
        
        btnSelectAll?.addTarget(self, action: #selector(selectAllInvite), for: UIControl.Event.touchUpInside)
        
        btnSearch?.addTarget(self, action: #selector(searchInvite), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func submitInternalAction() {
        
        selIntContactsArr = intContactsArr.filter{ ($0.selected == true) }
        addIntContact()
    }
    
    func addIntContact() {
     
        let contObj = selIntContactsArr[selCnt]
        
        contactObj = ContactsData()
        contactObj?.FullName = contObj.FirstName! + " " + contObj.LastName!
        contactObj?.Email = contObj.Email
        contactObj?.Company = contObj.Company
        contactObj?.JobTitle = contObj.JobTitle
        
        let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        contactObj?.ProfileId = profileId
        contactObj?.UserType = 1
        
        addContactAPI()
    }
    
    @IBAction func inviteAction() {
        
        inviteFlag = true
        signInView.isHidden = true
        extContactsArr = contactsArr.filter{ ($0.IsZorroUser == false) }
            
        initInviteAlert()
        inviteAlertView.show()
    }
    
    func initInviteAlert() {
        
        inviteAlertView = SwiftAlertView(nibName: "InviteAlert", delegate: self, cancelButtonTitle: "CLOSE", otherButtonTitles: ["SEND REQUEST"])
        //"Apply Changes"
        inviteAlertView.tag = 14
        inviteAlertView.delegate = self
        let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        
        let txtfld = inviteAlertView.viewWithTag(2) as! UITextField
        txtfld.delegate = self
        
        /*
        let btnapply = inviteAlertView.viewWithTag(10) as? UIButton
        btnapply?.setTitle("SEND REQUEST", for: UIControlState.normal)
        btnapply?.addTarget(self, action: #selector(submitInviteAction), for: UIControlEvents.touchUpInside)
        
        let btnmanage = inviteAlertView.viewWithTag(11) as? UIButton
        btnmanage?.isHidden = true
         */
        
        let lblHead = inviteAlertView.viewWithTag(5) as? UILabel
        //lblHead?.text = "Message (optional):"
        
        let lblTitle = inviteAlertView.viewWithTag(12) as? UILabel
        lblTitle?.text = "Invite Friends"
        
        let btnclose = inviteAlertView.buttonAtIndex(index: 0)
        let btnsend = inviteAlertView.buttonAtIndex(index: 1)
        
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnsend?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnsend?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        let btnSelectAll = inviteAlertView.viewWithTag(21) as? UIButton
        let btnSearch = inviteAlertView.viewWithTag(24) as? UIButton
        
        btnSelectAll?.addTarget(self, action: #selector(selectAllInvite), for: UIControl.Event.touchUpInside)
        
        btnSearch?.addTarget(self, action: #selector(searchInvite), for: UIControl.Event.touchUpInside)
    }
    
    @IBAction func selectAllInvite(_ sender: UIButton) {
     
        sender.isSelected = !sender.isSelected
        
        if grpFlag {
            
            for i in 0..<grpContactsArr.count {
                
                let data = grpContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        }
        else if linkFlag {
            
            for i in 0..<linkContactsArr.count {
                
                let data = linkContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        }
        else if internalFlag {
            
            for i in 0..<intContactsArr.count {
                
                let data = intContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
            
        } else {
            for i in 0..<extContactsArr.count {
                
                let data = extContactsArr[i]
                if sender.isSelected {
                    data.selected = true
                } else {
                    data.selected = false
                }
            }
            let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
            tablevw.reloadData()
        }
        
    }
    
    @IBAction func searchInvite(_ sender: UIButton) {
        
        if grpFlag {
            
            let txtsrch = internalAlertView.viewWithTag(23) as! UITextField
            searchTxt = txtsrch.text ?? ""
            
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
            
        }
        else if linkFlag {
            
            let txtsrch = linkAlertView.viewWithTag(23) as! UITextField
            searchTxt = txtsrch.text ?? ""
            
            let tablevw = linkAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
            
        }
        else if internalFlag {
        
            let txtsrch = internalAlertView.viewWithTag(23) as! UITextField
            searchTxt = txtsrch.text ?? ""
            
            let tablevw = internalAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
            
        } else {
            let txtsrch = inviteAlertView.viewWithTag(23) as! UITextField
            searchTxt = txtsrch.text ?? ""
            
            let tablevw = inviteAlertView.viewWithTag(4) as! UITableView
            tablevw.beginUpdates()
            tablevw.endUpdates()
        }
    }
    
    @IBAction func submitInviteAction() {
        
        let txtfld = inviteAlertView.viewWithTag(2) as! UITextField
        
        let msg = txtfld.text
        
        let arr = extContactsArr.filter{ ($0.selected == true) }
        var arrEmail: [String] = []
        for data in arr {
            arrEmail.append(data.Email!)
        }
        
        inviteContactAPI(msg: msg!, contactsArr: arrEmail)
    }
    
    func inviteContactAPI(msg: String, contactsArr: [String]) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let profileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        let fullName = UserDefaults.standard.string(forKey: "FullName")!
        let email = UserDefaults.standard.string(forKey: "Email")!
        
        let api = "UserManagement/InviteContacts"
        var apiURL = Singletone.shareInstance.apiURL
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let toEmailListArr: [String] = contactsArr
        
        let parameters = ["SenderProfileId": profileId, "SenderFullName":fullName, "SenderEmail": email, "PersonalMessage":msg, "toEmailList": toEmailListArr] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    self.inviteAlertView.dismiss()
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        //let jsonData = jsonDic["Data"] as! NSDictionary
                        if statusCode == 1000 {
                            self.alertSample(strTitle: "", strMsg: "Invitation sent successfully")
                            
                        } else {
                            let msg = jsonDic["Message"] as! String
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                       
                    }
                    else
                    {
                        
                        self.alertSample(strTitle: "", strMsg: "Error from server")
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
        
    }
    
    @IBAction func outlookClicked() {
        /*
        let outlookVC = getVC(sbId: "OutlookVC")
        self.present(outlookVC, animated: false, completion: nil)
 
        if #available(iOS 11.0, *) {
            self.present(documentBrowser, animated: false, completion: nil)
        } else {
            // Fallback on earlier versions
        }
        */
        
        let importMenu = UIDocumentPickerViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        print("URL: \(url)")
        
        parseOutlookContacts(url: url)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("Nothing selected")
        dismiss(animated: true, completion: nil)
    }
    
    func parseOutlookContacts(url: URL) {
        
        var str = ""
        
        do {
            str = try String(contentsOf: url)
            
            if let data = str.data(using: .utf8) {
                let contacts = try CNContactVCardSerialization.contacts(with: data)
                let contact = contacts.first
                print("\(String(describing: contact?.familyName))")
                
                let profileId = ZorroTempData.sharedInstance.getProfileId()
                
                for contact in contacts {
                    
                    let fullname = contact.familyName// + " " + contact.lastname
                    let dic = ["ProfileId": profileId,
                               "FullName": fullname,
                               "Email": contact.emailAddresses,
                               "UserType": 2,
                               "FirstName": contact.givenName,
                               "MiddleName": "",
                               "LastName": ""] as [String : Any]
                    
                    self.googleContactsArr.append(dic)
                }
                
                self.createContactListAPI()
            }
            
        } catch {
            print("Failed reading from URL")
        }
        
    }
    
    @IBAction func hotmailAction() {
        
        //let outlookVC = getVC(sbId: "OutlookVC")
        //self.present(outlookVC, animated: false, completion: nil)
        loginButtonTapped()
    }
    func setLogInState(loggedIn: Bool) {
       /*
        if (loggedIn) {
            loginButton.setTitle("Log Out", for: UIControlState.normal)
        }
        else {
            loginButton.setTitle("Log In", for: UIControlState.normal)
        }*/
        
    }
    
    func loginButtonTapped() {
        if (service.isLoggedIn) {
            // Logout
            //service.logout()
           
            loadUserData()
            
            //setLogInState(loggedIn: false)
        } else {
            // Login
            
            self.showActivityIndicatory(uiView: self.view)
            
            service.login(from: self) {
                error in
                
                self.stopActivityIndicator()
                
                if let unwrappedError = error {
                    NSLog("Error logging in: \(unwrappedError)")
                } else {
                    NSLog("Successfully logged in.")
                    //self.setLogInState(loggedIn: true)
                    self.loadUserData()
                    self.signInView.isHidden = false
                }
            }
        }
    }
    
    
    
    func loadUserData() {
        //service.getUserEmail() {
        //  email in
        //if let unwrappedEmail = email {
        //NSLog("Hello \(unwrappedEmail)")
        
        self.showActivityIndicatory(uiView: self.view)
        
        self.service.getContacts() {
            contacts in
            
            self.stopActivityIndicator()
            
            if let unwrappedContacts = contacts {
                
                let profileId = ZorroTempData.sharedInstance.getProfileId()
                
                let contacts = unwrappedContacts["value"].arrayValue
                
                for (contact) in contacts {
                    
                    let fullname = contact["givenName"].stringValue + " " + contact["surname"].stringValue
                    let dic = ["ProfileId": profileId,
                           "FullName": fullname,
                           "Email": contact["emailAddresses"][0]["address"].stringValue,
                           "UserType": 2,
                           "FirstName": contact["givenName"].stringValue,
                           "MiddleName": "",
                           "LastName": contact["surname"].stringValue] as [String : Any]
              
                    self.googleContactsArr.append(dic)
                }
                self.service.logout()
                self.createContactListAPI()
            }
        }
        //}
        //}
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    @IBAction func sortContacts(_ sender: UIButton) {
        
        let descriptions = ["","","",""]
        
        var contHgt = 200
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        
        if !adminflag {
            contHgt = 160
        }
        
        let popOverViewController = PopOverViewController.instantiate()
        popOverViewController.set(titles: titles)
        popOverViewController.set(descriptions: descriptions)
        
        popOverViewController.popoverPresentationController?.sourceView = sender
        popOverViewController.preferredContentSize = CGSize(width: 200, height:contHgt)
        popOverViewController.presentationController?.delegate = self
        popOverViewController.completionHandler = { selectRow in
            switch (selectRow) {
            case 0:
                
                self.filteredContArr = self.contactsArr
                break
                
            case 1:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 1) }
                break
                
            case 2:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 2) }
                break
                
            case 3:
                
                self.filteredContArr = self.contactsArr.filter{ ($0.UserType == 1) }
                break
                
            default:
                break
            }
            
            self.sortTitle = self.titles[selectRow]
            sender.setTitle(self.titles[selectRow], for: UIControl.State.normal)
            
            for data in self.filteredContArr {
                    data.selected = false
            }
            self.selectAllFlag = false
            
            self.contactsTbl.reloadData()
        };
        
        present(popOverViewController, animated: true, completion: nil)
        
        self.view.bringSubviewToFront(popOverViewController.view)
    }
    
    func filterContacts() {
        
        let index = titles.index(of: self.sortTitle)
        
        switch (index) {
        case 0:
            
            self.filteredContArr = self.contactsArr
            break
            
        case 1:
            
            self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 1) }
            break
            
        case 2:
            
            self.filteredContArr = self.contactsArr.filter{ ($0.ContactType == 2) }
            break
            
        case 3:
            
            self.filteredContArr = self.contactsArr.filter{ ($0.UserType == 1) }
            break
            
        default:
            break
        }
        
        self.contactsTbl.reloadData()
        self.contactsTbl.beginUpdates()
        self.contactsTbl.endUpdates()
    }
}
/*
 */

@available(iOS 10.0, *)
extension ContactsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tag = Int(collectionView.accessibilityHint!)
        let data = grpContactsArr[tag!]
        
        return data.linkedContacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath)
        
        if cell == nil {
            let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
            cell = (arr?[6] as? UICollectionViewCell)!
            
        }
        let tag = collectionView.tag
        let data = grpContactsArr[tag]
        
        let linkdcontact = data.linkedContacts[indexPath.row]
        let lblname = cell.viewWithTag(2) as! UILabel
        lblname.text = linkdcontact.Name
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 200, height: 30)
    }
    
    //PopoverDismissDelegate methods
    
    func onDismiss() {
        navController.dismiss(animated: false, completion: {
            self.getContactsAPI()
        })
        
    }
    
}
extension LinkContactVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
