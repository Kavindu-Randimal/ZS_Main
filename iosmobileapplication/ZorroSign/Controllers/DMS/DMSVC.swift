//
//  DMSVC.swift
//  ZorroSign
//
//  Created by Apple on 19/09/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import KJExpandableTableTree
import Speech

@objc protocol TreeCellDelegate {
    
    @objc optional
    func onChecked(id: Int, flag: Bool)
    func onExpand(id: Int, row: Int)
    func onOptionsClick(id: Int)
    func onChecked(id: Int, pid: Int, flag: Bool)
}

class TreeCell: UITableViewCell {
    
    @IBOutlet weak var con_leadIcon: NSLayoutConstraint!
    @IBOutlet weak var btnchk: UIButton!
    @IBOutlet weak var btnexpand: UIButton!
    @IBOutlet weak var btnoption: UIButton!
    
    
    
    weak var delegate: TreeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkedAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        delegate?.onChecked!(id: sender.tag, flag: sender.isSelected)
    }
    
    @IBAction func docCheckedAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        let hint = sender.accessibilityHint ?? "0"
        delegate?.onChecked(id: sender.tag, pid: Int(hint)!, flag: sender.isSelected)
        //delegate?.onChecked!(id: sender.tag, pid: Int(hint)!, flag: sender.isSelected)
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        
        let hint: Int = Int(sender.accessibilityHint!)!
        sender.isSelected = !sender.isSelected
        delegate?.onExpand(id: sender.tag, row: hint)
    }
    
    @IBAction func optionsAction(_ sender: UIButton) {
        
        //let hint: Int = Int(sender.accessibilityHint!)!
        delegate?.onOptionsClick(id: sender.tag)
    }
}

@available(iOS 10.0, *)

class DMSVC: BaseVC, UITableViewDataSource, UITableViewDelegate, TreeCellDelegate, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    var kjtreeInstance: KJTree? = nil
    var arrayNodes: NSArray = NSArray.init()//[[String:Any]] = []
    var arrayTree: [LabelData] = []//[[String:Any]] = []
    var arrLabelsCat:[LabelData] = []
    var filtertedArray: NSMutableArray = NSMutableArray.init() //[[String:Any]] = []
    var orgArray: NSMutableArray = NSMutableArray.init()
    var selLabelId: String = "0"
    var selLabelData: LabelData?
    var selSourceData: LabelData?
    var clickedIds: NSMutableArray = NSMutableArray.init()
    var selDocArr: [Int] = []
    var sourcePid: Int = 0
    var targetPid: Int?
    var pasteCnt: Int = 0
    var copyFlag: Bool = false
    var mydoc: LabelData!
    var searchTxt: String = ""
    
    @IBOutlet weak var tblDMS: UITableView!
    @IBOutlet weak var btnPaste: UIButton!
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
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCopy: UIButton!
    
    @IBOutlet weak var viewSearchAction: UIView!
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en_US")) // 1
    
    private var recognizationRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognizationTask: SFSpeechRecognitionTask?
    private var audioEngin = AVAudioEngine()
    
    var DMSOptionsView: SwiftAlertView!
    
    var colorArr = ["70292C","7A5549","F9403D","FF5431","F97A2C","FFBF43","4C1A86","1A2679","2F55F4","0298EC","00BDD1","00E6FC","80742B","009689","00C764","57DC4B","C2FE54","CCDB5A","F2999B","FBBBCF","B49ED6","AEEBF1","FFCB8A","DBE685"]
    
    var optionsArr = ["Change Color","Rename","Remove"]
    var optionsIcon = ["colorIcon","edit-gray","delete"]
    
    let statusArr = ["Inbox", "In Process", "Completed", "Rejected", "","Expired","Cancelled","Shared","Scanned Token"]
    
    let bucketArr = ["0": "Inbox", "1": "In Process", "2": "Completed", "3": "Rejected","4":"","5":"Expired","6":"Cancelled","7":"Shared","8":"Scanned Token"]
    
    var selOption: Int = -1
    var selColorId: Int = -1
    var updatedLblName: String?
    var optionsFlag: Bool = false
    var deleteFlag = false
    
    var selId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        //getUnreadPushCount()
        
        mydoc = LabelData()
        mydoc.Id = 0
        mydoc.Name = "My Documents"
        mydoc.ParentId = -1
        mydoc.Color = "#000000"
        mydoc.selected = false
        mydoc.expanded = true
        
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
       // initDMSOptions()
        // Do any additional setup after loading the view.
        addObsever()
        
    }
    
    deinit {
        removeObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callLabelAPI()
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
    
    @IBAction func actionClear(_ sender: Any) {
       
        viewSearchBar.isHidden = true
        txtSearchText.text = ""
        
        searchTxt = ""
        imgSearchMic.image = UIImage(named: "mic_white_icon")
        UserDefaults.standard.set("mic", forKey: "MicORArrow")
        
        tblDMS.beginUpdates()
        tblDMS.endUpdates()
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
                
                tblDMS.beginUpdates()
                tblDMS.endUpdates()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
            
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
    
    func createTree(array: NSArray) {
        
        let predicate = NSPredicate(format: "SELF.Name contains [c] %@", searchTxt)
        let arr = array.filter{ predicate.evaluate(with: $0) }
        let arrnew = NSMutableArray(array: array)
        var sortedArray = arrnew.sorted {
            (obj1, obj2) -> Bool in
            
            return (obj1 as! LabelData).isArchive < (obj2 as! LabelData).isArchive
            //return (obj1 as! LabelData).DashboardCategoryType.count > (obj2 as! LabelData).DashboardCategoryType.count
        }
        //let finalArr = arrnew.sort{ $0.DashboardCategoryType.length > $1.DashboardCategoryType.length }
        
        print("array in createTree: \(sortedArray)")
        //if let arrayOfParents = array {
        kjtreeInstance = KJTree.init(parents: array as NSArray, childrenKey: "Labels", expandableKey: "expanded", key: "Name")
        kjtreeInstance?.isInitiallyExpanded = false
        tblDMS.dataSource = self
        tblDMS.delegate = self
        tblDMS.reloadData()
        //}
    }

    
    func createTreeData(id: Int, arr: NSArray) {
        
        
        if arr.count > 0 {
            //labelDic.setObject(arr, forKey: id as NSCopying)
            
            for i in 0..<arr.count {
                let data = arr[i] as! NSMutableDictionary
                let Id: Int = data.object(forKey: "Id") as! Int
                
                //let predicate = NSPredicate(format: "SELF.Name contains [c] %@", searchTxt)
                let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d", Id)
                
                data["Labels"] = self.filtertedArray.filter{ predicate.evaluate(with: $0) }
                
                if (data["Labels"] as! NSArray).count > 0 {
                    data["expanded"] = true
                }
                
                
                //print("data1: \(data)")
                
                let labelData = LabelData(dictionary: data as! [AnyHashable : Any])
                arrayTree.append(labelData)
                
                
                createTreeData(id: data["Id"] as! Int, arr: data["Labels"] as! NSArray)
            }
        }
        
        //return labelDic
    }
    
    //MARK: - Add Observer to callLabelAPI
    
    func addObsever() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.callLableApi),
            name: NSNotification.Name(rawValue: "callLableApi"),
            object: nil)
    }
    
    //MARK: - Remove Observer
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "callLableApi"), object: nil)
    }
    
    //MARK: - Call Observer action
    @objc private func callLableApi(notification: NSNotification){
        callLabelAPI()
    }
   
    func callLabelAPI() {
        
        
        self.orgArray.removeAllObjects()
        self.filtertedArray.removeAllObjects()
        self.arrayTree.removeAll()
        self.arrayNodes = NSArray.init()
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v1/label/getlabels?labelCategory=1"
        let apiURL = Singletone.shareInstance.apiUserService + api
        //"https://zsdemowebworkflow.zorrosign.com/api/v1/label/getlabels?labelCategory=1"
        
        if Connectivity.isConnectedToInternet() == true
        {
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value) 
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            let data = jsonObj["Data"].array
                            var parentIdArr:[Int] = []
                            
                            
                            self.filtertedArray.add(self.mydoc.toDictionary())
                            self.orgArray.add(self.mydoc.toDictionary())
                            
                            var archiveData: LabelData!
                            for dic in data! {
                                
                                print("label dic: \(dic.dictionaryObject)")
                                var labeldata = LabelData(dictionary: dic.dictionaryObject!)
                                labeldata.type = 0
                                
                                if (dic.dictionaryObject!["Name"] as! String) == "Archive" {
                                    labeldata.isArchive = 1
                                    archiveData = labeldata
                                }
                                else {
                                    let predicate = NSPredicate(format: "SELF.Id =[cd] %d", labeldata.Id!)
                                    let arr = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
                                    if arr.count == 0 {
                                        self.filtertedArray.add(labeldata.toDictionary())
                                        self.orgArray.add(labeldata.toDictionary())
                                    }
                                }
                                
                            }
                            if archiveData != nil {
                                self.filtertedArray.add(archiveData.toDictionary())
                                self.orgArray.add(archiveData.toDictionary())
                            }
                            
                            let predicate = NSPredicate(format: "SELF.ParentId =[cd] %d", -1)
                            self.arrayNodes = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
                            
                            //arrayNodes = self.filtertedArray.filter{ (Int($0["ParentId"]) == 0) }
                            //self.createTreeData(id: 0, arr: self.arrayNodes)
                            //self.createTree(array: self.arrayNodes)
                            self.getDetailsForCatAPI(Id: 0)
                            
                        }
                        else
                        {
                            
                        }
                    
                   
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func getDetailsForCatAPI(Id: Int) {
        
        //GetDetailsForCategory?type=4&startIndex=0&pageSize=-1&orderBy=5&isAscending=false&labelId=14578
        
        //https://webworkflow.zorrosign.com/api/v1/dashboard/GetDetailsForCategory?type=4&startIndex=0&pageSize=-1&orderBy=5&isAscending=false&labelId=14578
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let labelId: Int = Id
        self.clickedIds.add(labelId)
        
        let api = "v1/dashboard/GetDetailsForCategory?type=4&startIndex=0&pageSize=-1&orderBy=5&isAscending=false&labelId=\(labelId)"
        
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value)
                        
                        
                        
                        if jsonObj["StatusCode"] == 1000
                        {
                            
                            
                            let data = jsonObj["Data"].arrayObject as? [[String:Any]]
                            
                            if self.deleteFlag {
                                self.deleteFlag = false
                                let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d", Int(self.selLabelId)!)
                                
                                let arrdel = self.filtertedArray.filter{ predicate.evaluate(with: $0) }
                                if arrdel.count == 0 && data?.count == 0 {
                                    self.deleteLabelAPI()
                                } else {
                                    //Folder can not be deleted when it has contents
                                    self.alertSample(strTitle: "", strMsg: "Folder can not be deleted when it has contents")
                                }
                                
                            } else {
                                
                                
                                for dic in data! {
                                    
                                    print("dic: \(dic)")
                                    //if dic["IsExpired"] as? Bool == false {
                                    let lbldata = LabelData()
                                    lbldata.Name = dic["DocumentSet"] as? String
                                    lbldata.Id = dic["InstanceId"] as? Int
                                    lbldata.ParentId = labelId
                                    lbldata.type = 1
                                    lbldata.Color = "#000000"
                                    lbldata.MainDocumentType = dic["MainDocumentType"] as? Int ?? 0
                                    lbldata.IsBulkSend = dic["IsBulkSend"] as? Bool ?? false
                                    
                                    if let type = dic["DashboardCategoryType"] as? Int, type < self.statusArr.count  {
                                    
                                        lbldata.DashboardCategoryType = self.statusArr[type]
                                    
                                    }
                                    let predicate = NSPredicate(format: "SELF.Id =[cd] %d and SELF.ParentId =[cd] %d", lbldata.Id!, labelId)
                                    let arr = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
                                    if arr.count == 0 {
                                        var lblDic = lbldata.toDictionary()
                                        if let type = dic["DashboardCategoryType"] as? Int, type < self.statusArr.count
                                        {
                                            lblDic["DashboardCategoryType"] = self.statusArr[type]
                                        }
                                        self.filtertedArray.add(lblDic)
                                        if labelId == 0 {
                                            self.orgArray.add(lblDic)
                                        }
                                    }
                                    
                                    else {
                                        let dict = arr[0] as! [AnyHashable : Any]
                                        let label = LabelData(dictionary: dict)
                                        if let type = dic["DashboardCategoryType"] as? Int, type < self.statusArr.count
                                        {
                                            if !label.dispCatArr.contains(self.statusArr[type]) {
                                                label.dispCatArr.append(self.statusArr[type])
                                            }
                                            if !label.dispCatArr.contains(dict["DashboardCategoryType"] as! String) {
                                                label.dispCatArr.append(dict["DashboardCategoryType"] as! String)
                                            }
                                            self.arrLabelsCat.append(label)
                                        }
                                    }
                                    
                                    //}
                                }
                                
                                //let predicate = NSPredicate(format: "SELF.ParentId =[cd] %d", 0)
                                let predicate = NSPredicate(format: "SELF.ParentId =[cd] %d", -1)
                                self.arrayNodes = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
                                
                                //arrayNodes = self.filtertedArray.filter{ (Int($0["ParentId"]) == 0) }
                                self.arrayTree = []
                                self.createTreeData(id: 0, arr: self.arrayNodes)
                                self.createTree(array: self.arrayNodes)
                            }
                            
                        }
                        else
                        {
                            
                        }
                    
                   
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if optionsFlag && tableView != tblDMS {
            return 3
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblDMS {
            return kjtreeInstance!.tableView(tableView, numberOfRowsInSection: section)
        }
        return optionsFlag ? 1 : 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = UITableViewCell.SelectionStyle.gray
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        if tableView == tblDMS {
            
            let node = kjtreeInstance?.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
            
            // You can return different cells for Parents, childs, subchilds, .... as below.
            let indexTuples = node?.index.components(separatedBy: ".")
            if indexTuples?.count == 1  || indexTuples?.count == 4 {
                // return cell for Parents and subchilds at level 4. (For Level-1 and Internal level-4)
                
            }else if indexTuples?.count == 2{
                // return cell for Childs of Parents. (Level-2)
            }else if indexTuples?.count == 3{
                // return cell for Subchilds of Childs inside Parent. (Level-3)
            }
            
            // Return below cell for more internal levels....
            var tableviewcell = tableView.dequeueReusableCell(withIdentifier: "dmsCell") as? TreeCell
            
            tableviewcell?.delegate = self
            
            let statushead = tableviewcell?.viewWithTag(3) as! UILabel
           
            if indexPath.row != 0 {
                statushead.isHidden = true
            } else {
                statushead.isHidden = false
            }
            /*
             if tableviewcell == nil {
             tableviewcell = UITableViewCell(style: .default, reuseIdentifier: "dmsCell")
             }*/
            var space: CGFloat = 0
            for i in 0..<(indexTuples?.count)! {
                space = space + 10
            }
            
            let nameId = (node?.key)!
            let arrname = nameId.components(separatedBy: "#")
            let name = arrname[0]
            let Id = arrname[1]
            let parentId = arrname[2]
            //tableviewcell?.textLabel?.text = space + (node?.key)!
            
            print("name: \(name), \(Id), \(parentId)")
            
            var arr: [LabelData] = []
           
            if Id != "" && parentId != "" {
                arr = self.arrayTree.filter{ (($0.Id == Int(Id)!) && ($0.ParentId == Int(parentId)!)) }
            }
            
            
            
            
            let label: LabelData?
            if !arr.isEmpty {
                label = arr[0]
                
                if label?.type == 1 {
                    tableviewcell = tableView.dequeueReusableCell(withIdentifier: "docCell") as? TreeCell
                    tableviewcell?.delegate = self
                }
                
                
                let txtLbl = tableviewcell?.viewWithTag(2) as! UILabel
                
                let statusLbl = tableviewcell?.viewWithTag(3) as! UILabel
                var strCat = label?.DashboardCategoryType
                
                //let predicate = NSPredicate(format: "SELF.Id =[cd] %d", Id)
                let arr1 = self.arrLabelsCat.filter( {$0.Id == Int(Id)} ) as NSArray
                if arr1.count > 0 {
                    var catArr = (arr1[0] as? LabelData)?.dispCatArr
                    catArr?.sort(by: { (str1, str2) -> Bool in
                        return str1.count < str2.count
                    })
                    strCat = catArr?.joined(separator: " & ")
                }
                print("strCat ==== \(strCat)")
                if label?.type == 1 {
                    txtLbl.text = "\(Id) - \(name)"
                    statusLbl.text = strCat //label?.DashboardCategoryType
                } else {
                    txtLbl.text = name
                }
                
                if indexPath.row == 0 {
                    txtLbl.textColor = UIColor(red: 39/255, green: 171/255, blue: 17/155, alpha: 1)
                } else {
                    txtLbl.textColor = UIColor.black
                }
                tableviewcell?.con_leadIcon.constant = space
                
                let icon = tableviewcell?.viewWithTag(1) as? UIImageView
                
                
                icon?.image = nil
                
                if name == "Archive" {
                    icon?.image = UIImage(named: "icarchive")
                    //tableviewcell?.btnoption.isHidden = true
                    //tableviewcell?.btnexpand.isHidden = true
                    
                } else {
                    var img = UIImage(named: "my_documents")
                    img = img?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                    icon?.image = img
                    icon?.tintColor = UIColor(hex: (label?.Color)!)
                    
                }
                
                
                
                let btnchk = tableviewcell?.btnchk
                btnchk?.tag = (label?.Id)!
                btnchk?.accessibilityHint = String(parentId)
                btnchk?.isSelected = (label?.selected)!
                
            }
            let icon1 = tableviewcell?.viewWithTag(4) as? UIImageView
            
            if arr.count > 0 {
                
                
                let docdata = arr[0] as? LabelData
                print("docname: \(docdata?.Name)")
                
                if docdata?.IsBulkSend == false && docdata?.MainDocumentType == 0
                {
                    icon1?.image = UIImage(named: "doc_green.png")
                }
                else if docdata?.IsBulkSend == false &&  docdata?.MainDocumentType == 1
                {
                    icon1?.image = UIImage(named: "doc_green_bldg.png")
                }
                else if docdata?.IsBulkSend == true && docdata?.MainDocumentType == 0
                {
                    icon1?.image = UIImage(named: "bulk_send.png")
                }
                else if docdata?.IsBulkSend == false &&  docdata?.MainDocumentType == 2
                {
                    icon1?.image = UIImage(named: "doc_green_ppl.png")
                }
            } else {
                icon1?.image = UIImage(named: "doc_green.png")
            }
            
            if let btnexpand = tableviewcell?.btnexpand {
                if Id != "" {
                  btnexpand.tag = Int(Id)!
                }
                
                let hint: String = "\(indexPath.row)"
                btnexpand.accessibilityHint = hint
                
                if node?.state == .open {
                    btnexpand.isSelected = true
                }else if node?.state == .close {
                    btnexpand.isSelected = false
                }
                let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d", Id)
                let arrChild = self.filtertedArray.filter{ predicate.evaluate(with: $0) }
                if !arrChild.isEmpty {
                    
                    if arrChild.count == 0 || name == "Archive" {
                        btnexpand.isHidden = true
                    } else {
                        btnexpand.isHidden = false
                    }
                }
                /*
                if name == "Archive" {
                    btnexpand.isHidden = true
                } else {
                    btnexpand.isHidden = false
                }*/
                
            }
            
            if let btnoption = tableviewcell?.btnoption {
                if Id != "" {
                   btnoption.tag = Int(Id)!
                }
                btnoption.isHidden = false
            }
            
            if indexPath.row == 0 || name == "Archive" {
                if let btnoption = tableviewcell?.btnoption {
                    btnoption.isHidden = true
                }
                let view = tableviewcell?.viewWithTag(8)
                if name == "Archive" {
                    view?.isHidden = true
                } else {
                    view?.isHidden = false
                }
            } else {
                let view = tableviewcell?.viewWithTag(8)
                view?.isHidden = true
            }
            
            tableviewcell?.backgroundColor = UIColor.white
            
            if Int(Id) == sourcePid {
                //tableviewcell?.backgroundColor = UIColor.gray
            }
            if Int(Id) == targetPid {
                //tableviewcell?.backgroundColor = UIColor.blue
            }
            tableviewcell?.selectionStyle = .none
            return tableviewcell!
        }
        else {
            if indexPath.section == 0 {
                let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
                let cell = (arr?[0] as? UITableViewCell)! as? UITableViewCell
                
                for i in 1..<colorArr.count+1 {
                    let btn = cell?.viewWithTag(i) as! UIButton
                    //let hint: Int = indexPath.row
                    //btn.accessibilityHint = "\(hint)"
                    btn.backgroundColor = UIColor(hex: colorArr[i-1])
                    
                    btn.addTarget(self, action: #selector(colorSelected), for: UIControl.Event.touchUpInside)
                     
                     if selColorId == i-1 {
                     btn.layer.borderWidth = 5
                     btn.layer.borderColor = UIColor.black.cgColor
                     } else {
                     btn.layer.borderWidth = 0
                     btn.layer.borderColor = UIColor.white.cgColor
                     }
                }
                return cell!
            }
            if indexPath.section == 1 {
                let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
                let cell = (arr?[1] as? UITableViewCell)! as? UITableViewCell
                
                let txtfld = cell?.viewWithTag(2) as! UITextField
                txtfld.delegate = self
                
                return cell!
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tableView != tblDMS {
            
            if section == 0 {
                return "Change Color"
            }
            if section == 1 {
                return "Rename"
            }
            if section == 2 {
                return "Remove"
            }
            
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        
        if optionsFlag {
        let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
        let cell = (arr?[2] as? UITableViewCell)! as? UITableViewCell
        
        if section != 3 {
            let header = tableView.dequeueReusableCell(withIdentifier: "header")
            
            let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
            let cell = (arr?[2] as? UITableViewCell)! as? UITableViewCell
            
            let title = cell?.viewWithTag(2) as! UILabel
            title.text = optionsArr[section]
            
            let icon = cell?.viewWithTag(1) as! UIImageView
            icon.image = UIImage(named: optionsIcon[section])
            
            let btn = cell?.viewWithTag(4) as! UIButton
            btn.tag = section
            
            btn.addTarget(self, action: #selector(optionAction), for: UIControl.Event.touchUpInside)
            
            
            if selOption == section {
                cell?.contentView.backgroundColor = UIColor(red: 39/255, green: 171/255, blue: 17/255, alpha: 1)
            } else {
                cell?.contentView.backgroundColor = UIColor.white
            }
            return cell
        }
        else {
            let arr = Bundle.main.loadNibNamed("DMSOptionsCell", owner: self, options: nil)
            let cell = (arr?[3] as? UITableViewCell)! as? UITableViewCell
            
            let cancel = cell?.viewWithTag(1) as! UIButton
            let ok = cell?.viewWithTag(2) as! UIButton
            
            cancel.addTarget(self, action: #selector(optionButtonClick), for: UIControl.Event.touchUpInside)
            ok.addTarget(self, action: #selector(optionButtonClick), for: UIControl.Event.touchUpInside)
            
            if selOption == section {
                cell?.contentView.backgroundColor = UIColor(red: 39, green: 171, blue: 17, alpha: 1)
            } else {
                cell?.backgroundColor = UIColor.white
            }
            return cell
        }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == tblDMS {
            //let node = kjtreeInstance?.tableView(tableView, didSelectRowAt: indexPath)
            let node = kjtreeInstance?.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
            
            print(node?.index)
            print(node?.key)
            let nameId = (node?.key)!
            let arrname = nameId.components(separatedBy: "#")
            let name = arrname[0]
            let Id = arrname[1] ?? "0"
            let parentId = arrname[2]
            print("Id: \(Id)")
            selLabelId = Id
            selId = Int(Id)!
            
            
            if name == "Archive" {
                
                btnAdd.isHidden = true
                btnCopy.isHidden = true
                
            } else {
                
                btnAdd.isHidden = false
                btnCopy.isHidden = false
                
            }
            let arr = self.arrayTree.filter{ (($0.Id == Int(Id)!) && ($0.ParentId == Int(parentId))) }
            
            if !arr.isEmpty {
                let pid = arr[0].ParentId
                selLabelData = arr[0]
                //arr[0].expanded = !arr[0].expanded
                let arrP = self.arrayTree.filter{ ($0.Id == pid!) }
                
                if !arrP.isEmpty {
                    //selLabelData = arrP[0]
                }
                
                if arr[0].type != 1 {
                    let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d and SELF.type = 1", Int(Id)!)
                    
                    let lblArr = self.filtertedArray.filter{ predicate.evaluate(with: $0) }
                    if lblArr.count == 0 {
                        /*
                        if !clickedIds.contains(selId) {
                            self.filtertedArray.removeAllObjects()
                            self.filtertedArray.addObjects(from: self.orgArray as! [Any])
                            getDetailsForCatAPI(Id: Int(Id)!)
                        }*/
                        arr[0].expanded = !arr[0].expanded
                        
                    } else {
                        arr[0].expanded = !arr[0].expanded
                    }
                    
                } else {
                    
                    if #available(iOS 11.0, *) {
                        if indexPath.row > 0 {
                            let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
                            
                            docSignVC.instanceID = Id
                            //docSignVC.docCat = selCategory
                            self.navigationController?.pushViewController(docSignVC, animated: true)
                        }
                        //performSegue(withIdentifier: "detailsVC", sender: self)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
            else {
                
                if #available(iOS 11.0, *) {
                    if indexPath.row > 0 {
                        let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
                        
                        docSignVC.instanceID = Id
                        //docSignVC.docCat = selCategory
                        self.navigationController?.pushViewController(docSignVC, animated: true)
                        //performSegue(withIdentifier: "detailsVC", sender: self)
                    }
                } else {
                    // Fallback on earlier versions
                }
            }
            
        }
        else {
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView != tblDMS {
            if indexPath.section == selOption {
                if indexPath.section == 0 {
                    return 153
                }
                if indexPath.section == 1 {
                    return 75
                }
            }
            return 0
        }
        
        let node = kjtreeInstance?.cellIdentifierUsingTableView(tableView, cellForRowAt: indexPath)
        let nameId = (node?.key)!
        
        if !searchTxt.isEmpty && !nameId.lowercased().contains(searchTxt.lowercased()) {
            return 0
        }
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        /*
        if section == 3 {
            if selOption == -1 {
                return 0
            }
        }*/
        if selOption == section {
            return 50
        } else if selOption == -1 {
            return optionsFlag ? 50 : 0
        }
        return 0
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updatedLblName = textField.text!
    }
    
    @IBAction func optionAction(_ sender: UIButton) {
        let tblvw = DMSOptionsView.viewWithTag(4) as! UITableView
        
        sender.isSelected = !sender.isSelected
        
        var strcancel: String = ""
        var strok: String = ""
        
        DMSOptionsView.hideSeparator = true
        
        if selOption == sender.tag {
            selOption = -1
        } else {
            selOption = sender.tag
            strcancel = "Cancel"
            strok = "Ok"
            //DMSOptionsView.hideSeparator = false
        }
        let btncancel = DMSOptionsView.buttonAtIndex(index: 0)
        btncancel?.setTitle(strcancel, for: UIControl.State.normal)
        btncancel?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        //btncancel?.
        
        let btnok = DMSOptionsView.buttonAtIndex(index: 1)
        btnok?.setTitle(strok, for: UIControl.State.normal)
        btnok?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        tblvw.beginUpdates()
        tblvw.endUpdates()
        tblvw.reloadData()
        
        if sender.tag == 2 {
            tblvw.contentSize.height = 80
            tblvw.frame = CGRect(x: 0, y: 0, width: tblvw.frame.size.width, height: 80)
            DMSOptionsView.frame = tblvw.frame
        } else {
            tblvw.contentSize.height = 240
            tblvw.frame = CGRect(x: 0, y: 0, width: tblvw.frame.size.width, height: 240)
        }
        
        //if selOption != sender.tag {
        DMSOptionsView.refreshElementBeforeShowing(view: self.view, tag: sender.tag, flag: selOption)
        //}
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        performSegue(withIdentifier: "segDashboard", sender: self)
    }
    
    @IBAction func addFolderAction(_ sender: Any) {
        
        let addFolderVC = getVC(sbId: "addFolderVC") as! AddFolderVC
        if selLabelId != "0" {
            addFolderVC.parentId = Int(selLabelId)!
        }
        if selLabelData == nil {
            addFolderVC.parentId = 0
        }
        addFolderVC.selLabel = selLabelData
        addFolderVC.filterArr = filtertedArray
        self.present(addFolderVC, animated: true, completion: nil)
    }
    
    func resetIcons() {
        
        btnCopy.isSelected = false
        btnPaste.isSelected = false
    }
    
    @IBAction func copyAction(_ sender: Any){
        
        copyFlag = true
        
        let btnCopy = sender as! UIButton
        btnCopy.isSelected = !btnCopy.isSelected
        btnPaste.isSelected = !btnPaste.isSelected
        
        sourcePid = Int(selLabelId)!
        
    }
    
    @IBAction func pasteAction(_ sender: Any){
        
        pasteCnt = pasteCnt + 1
        let btn = sender as! UIButton
        targetPid = Int(selLabelId)
        //15531, 15532
        
        if selDocArr.count > 0 {
            if pasteCnt == 2 && btn.isSelected {
                moveItemsToLabelAPI()
                pasteCnt = 0
                btn.isSelected = false
            } else if copyFlag {
                copyFlag = false
                pasteCnt = 0
                copyItemsAPI()
            }
            btn.isSelected = !btn.isSelected
            
        } else {
            if sourcePid != 0 {
                
                let arr = self.arrayTree.filter{ ($0.Id == sourcePid) }
                if arr.count > 0 {
                    
                    
                    if pasteCnt == 1 {
                        selSourceData = arr[0]
                        let pid = arr[0].ParentId
                        sourcePid = pid!
                        btn.isSelected = !btn.isSelected
                    }
                    if arr[0].Labels.count > 0 {
                        for label in arr[0].Labels {
                            label.selected = true
                            selDocArr.append(label.Id!)
                        }
                    }
                    
                    
                    
                } else {
                    alertSample(strTitle: "", strMsg: "Please select items to copy.")
                }
            }
            else if !selLabelId.isEmpty {
                
                let arr = self.arrayTree.filter{ ($0.Id == Int(selLabelId)) }
                if arr.count > 0 {
                    
                    
                    if pasteCnt == 1 {
                        selSourceData = arr[0]
                        let pid = arr[0].ParentId
                        sourcePid = pid!
                        btn.isSelected = !btn.isSelected
                    }
                    if arr[0].Labels.count > 0 {
                        for label in arr[0].Labels {
                            label.selected = true
                            selDocArr.append(label.Id!)
                        }
                    }
                    
                    
                    
                } else {
                    alertSample(strTitle: "", strMsg: "Please select items to copy.")
                }
            }
            else {
                alertSample(strTitle: "", strMsg: "Please select items.")
            }
            if pasteCnt == 2 && btn.isSelected {
                moveItemsToLabelAPI()
                pasteCnt = 0
                btn.isSelected = false
            } else if copyFlag {
                copyFlag = false
                pasteCnt = 0
                copyItemsAPI()
            }
        }
    }
    
    //func onChecked(id: Int, flag: Bool)
    func onChecked(id: Int, pid: Int, flag: Bool)
    {
        let arr = self.arrayTree.filter{ ($0.Id == id && $0.ParentId == pid) }
        
        if !arr.isEmpty {
            let data = arr[0]
            data.selected = flag
            sourcePid = data.ParentId!
            
            
            if flag {
                selLabelId = String(data.ParentId!)
                selDocArr.append(data.Id!)
            } else {
                selLabelId = "0"
                let index = self.selDocArr.index(of: data.Id!)
                selDocArr.remove(at: index!)
            }
            tblDMS.reloadData()
        }
    }
    
    func onExpand(id: Int, row: Int) {
        let indexPath = IndexPath(row: row, section: 0)
        //kjtreeInstance?.tableView(tblDMS, didSelectRowAt: indexPath)
        
        let node = kjtreeInstance?.tableView(tblDMS, didSelectRowAt: indexPath)
        
        print(node?.index)
        print(node?.key)
        let nameId = (node?.key)!
        let arrname = nameId.components(separatedBy: "#")
        let name = arrname[0]
        let Id = arrname[1] ?? "0"
        print("Id: \(Id)")
        selLabelId = Id
        
        
        let arr = self.arrayTree.filter{ ($0.Id == Int(Id)!) }
        if !arr.isEmpty {
            let pid = arr[0].ParentId
            selLabelData = arr[0]
            //arr[0].expanded = !arr[0].expanded
            let arrP = self.arrayTree.filter{ ($0.Id == pid!) }
            
            if !arrP.isEmpty {
                //selLabelData = arrP[0]
            }
            
            if arr[0].type != 1 {
                let predicate = NSPredicate(format: "SELF.ParentId = [cd] %d and SELF.type = 1", Int(Id)!)
                
                let lblArr = self.filtertedArray.filter{ predicate.evaluate(with: $0) }
                if lblArr.count == 0 {
                    
                    self.filtertedArray.removeAllObjects()
                    self.filtertedArray.addObjects(from: self.orgArray as! [Any])
                    getDetailsForCatAPI(Id: Int(Id)!)
                    
                }
                
                else {
                    arr[0].expanded = !arr[0].expanded
                }
                
            } else {
                
                if #available(iOS 11.0, *) {
                    let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
                    
                    docSignVC.instanceID = Id
                    //docSignVC.docCat = selCategory
                    self.navigationController?.pushViewController(docSignVC, animated: true)
                    //performSegue(withIdentifier: "detailsVC", sender: self)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
        else {
            
            if #available(iOS 11.0, *) {
                let docSignVC = self.getVC(sbId: "docSignVC") as! DocSignVC
                
                docSignVC.instanceID = Id
                //docSignVC.docCat = selCategory
                self.navigationController?.pushViewController(docSignVC, animated: true)
                //performSegue(withIdentifier: "detailsVC", sender: self)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func copyItemsAPI() {

        /*
         {
         "SourceParentId" : 14653,
         "LabelList" : [
         {
         "Name" : "a",
         "Id" : 1
         }
         ],
         "LabelCategory" : 1,
         "TargetParentId" : 14676,
         "DocumentSetList" : [
         12435
         ]
         }
         
         
         request for folder copy
         
         {"TargetParentId":14641,"SourceParentId":0,"LabelList":[{"Id":14642,"Name":"csgs"}],"DocumentSetList":[],"LabelCategory":1}
         */
        print("copyItemsAPI")
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api: String = "v1/label/CopyItemsToLabel"
        let apiURL = Singletone.shareInstance.apiUserService + api

        var sellblArr: [[String: Any]] = []
        if selDocArr.count == 0 {
            
            let arrname = selSourceData?.Name!.components(separatedBy: "#")
            let name = arrname?[0]
            
            sellblArr.append(["Id":selSourceData?.Id ?? 0,"Name":
                name ?? ""])
        }
        
        let parameters = ["SourceParentId": sourcePid, "TargetParentId": targetPid!, "LabelCategory": 1, "LabelList": sellblArr, "DocumentSetList": selDocArr] as [String : Any]
        do{
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [JSONSerialization.WritingOptions.prettyPrinted])
        
        if let JSONString = String(data: postData, encoding: String.Encoding.utf8) {
            print(JSONString)
        }
        }catch{}
        /*
         ["SourceParentId": 15535, "LabelList": [], "LabelCategory": 1, "TargetParentId": 15554, "DocumentSetList": [5083]]
         OFXVX55uWmfW0MCpUkudnUIDfYQUJViJR1syKTG9vfNw6qlPr5dYW4ZCDDHB8LP5dCiFCI9a2ns18O5RereWz3ZXanPNBTqQ23O5OaC5Kpc7A3QV7Jtsmyphtg0IL4h0
         */
        print("parameters: \(parameters)")
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value!)
                        
                        print("jsonObj: \(jsonObj)")
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.alertSample(strTitle: "", strMsg: "Items copied successfully.")
                            
                            
                            self.callLabelAPI()
                        }
                        else
                        {
                            let msg = jsonObj["Message"].stringValue
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                    
                    self.resetIcons()
            }
 
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func moveItemsToLabelAPI() {
        //MoveItemsToLabel
        print("moveItemsToLabelAPI")
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api: String = "v1/label/MoveItemsToLabel"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        var sellblArr: [[String: Any]] = []
        if selDocArr.count == 0 {
            
            let arrname = selSourceData?.Name!.components(separatedBy: "#")
            let name = arrname?[0]
            
            sellblArr.append(["Id":selSourceData?.Id ?? 0,"Name":
                name ?? ""])
        }
        
        let parameters = ["SourceParentId": sourcePid, "TargetParentId": targetPid!, "LabelCategory": 1, "LabelList": sellblArr, "DocumentSetList": selDocArr] as [String : Any]
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [JSONSerialization.WritingOptions.prettyPrinted])
            
            if let JSONString = String(data: postData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
        }catch{}
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value!)
                        
                        print("jsonObj: \(jsonObj)")
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.selDocArr = []
                            self.alertSample(strTitle: "", strMsg: "Items moved successfully.")
                            self.resetIcons()
                            self.callLabelAPI()
                            self.getDetailsForCatAPI(Id: self.targetPid ?? 0)
                        }
                        else
                        {
                            let msg = jsonObj["Message"].stringValue
                            self.alertSample(strTitle: "", strMsg: msg)
                        }
                    
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @objc func colorSelected(_ sender: UIButton) {
        
        let tag = sender.tag
        selColorId = tag - 1
        let tablevw = DMSOptionsView.viewWithTag(4) as! UITableView
        tablevw.reloadData()
    }
    
    func onOptionsClick(id: Int) {
        print("optionsClicked: \(id)")
        selLabelId = "\(id)"
        initDMSOptions()
        DMSOptionsView.show()
    }
    
    func initDMSOptions() {
        
        DMSOptionsView = SwiftAlertView(nibName: "DMSOptions", delegate: self, cancelButtonTitle: "", otherButtonTitles: "")
        //"Apply Changes"
        DMSOptionsView.tag = 14
        DMSOptionsView.delegate = self
        
        let tablevw = DMSOptionsView.viewWithTag(4) as! UITableView
        tablevw.dataSource = self
        tablevw.delegate = self
        tablevw.isScrollEnabled = false
        DMSOptionsView.hideSeparator = true
        DMSOptionsView.dismissOnOutsideClicked = true
        
        optionsFlag = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func updateLabelAPI() {
        //MoveItemsToLabel
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api: String = "v1/label/update"
        let apiURL = Singletone.shareInstance.apiUserService + api
        var color: String = ""
        
        if selColorId >= 0 {
            color = "#" + colorArr[selColorId]
        } else {
            color = "#000000"
        }
        
        let predicate = NSPredicate(format: "SELF.Id =[cd] %d", Int(selLabelId)!)
        let arrLbl = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
        let lbldic = arrLbl[0] as! [String:Any]
        
        print("lbldic: \(lbldic)")
        var name: String = lbldic["Name"] as! String
        let arrname = name.components(separatedBy: "#")
        name = arrname[0]
        let datetime: String = lbldic["CreatedDateTime"] as! String
        let deleted: Int = lbldic["IsDeleted"] as! Int
        let lblcat: Int = lbldic["LabelCategory"] as! Int
        let updatedtime: String = lbldic["LastUpdatedDateTime"] as! String
        let parentId: Int = lbldic["ParentId"] as! Int
        
        
        let parameters = ["Color": color,
            "CreatedDateTime": datetime,
            "Id": selLabelId,
            "IsDeleted": deleted,
            "LabelCategory": lblcat,
            "LastUpdatedDateTime": updatedtime,
            "Name": updatedLblName ?? name,
            "ParentId": parentId,
            "Path": updatedLblName ?? name,
            "Selected": false
            ] as [String : Any]
        
        print("parameters: \(parameters)")
        
        do{
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [JSONSerialization.WritingOptions.prettyPrinted])
            
            if let JSONString = String(data: postData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
        }catch{}
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                        
                        print("jsonObj: \(jsonObj)")
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.callLabelAPI()
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error")
                        }
                    
                   
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func deleteLabelAPI() {
        //v1/label/delete?profileId=F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D&labelId=15599&labelCategory=1
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let predicate = NSPredicate(format: "SELF.Id =[cd] %d", Int(selLabelId)!)
        let arrLbl = self.filtertedArray.filter{predicate.evaluate(with: $0)} as NSArray
        let lbldic = arrLbl[0] as! [String:Any]
        
        print("lbldic: \(lbldic)")
        
        let CreatedProfileId = UserDefaults.standard.string(forKey: "OrgProfileId")!
        let lblcat: Int = lbldic["LabelCategory"] as! Int
        
        let api: String = "v1/label/delete?profileId=\(CreatedProfileId)&labelId=\(selLabelId)&labelCategory=\(lblcat)"
        
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    if response.result.isFailure {
                        return
                    }
                    
                     let jsonObj: JSON = JSON(response.result.value!) 
                        
                        print("jsonObj: \(jsonObj)")
                        if jsonObj["StatusCode"] == 1000
                        {
                            self.selLabelData = nil
                            self.alertSample(strTitle: "", strMsg: "Folder deleted successfully.")
                            self.callLabelAPI()
                        }
                        else
                        {
                            self.alertSample(strTitle: "", strMsg: "Error")
                        }
                    
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    @IBAction func optionButtonClick(sender: UIButton){
        
        
        optionsFlag = false
        let buttonIndex = sender.tag
        if buttonIndex == 2 {
            if selOption == 0 || selOption == 1 {
                updateLabelAPI()
            }
            if selOption == 2 {
                deleteLabelAPI()
            }
        } else {
            selOption = -1
        }
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        optionsFlag = false
        print("buttonIndex: \(buttonIndex)")
        if buttonIndex == 1 {
            if selOption == 0 || selOption == 1 {
                
                updateLabelAPI()
            }
            if selOption == 2 {
                deleteFlag = true
                let lblid = selLabelId ?? "0"
                getDetailsForCatAPI(Id: Int(lblid)!)
            }
            selOption = -1
        } else {
            selOption = -1
        }
    }
    
    override func didDismissAlertView(alertView: SwiftAlertView) {
        optionsFlag = false
    }
    
    @objc func optionButtonsAction(_ sender: UIButton) {
        
        let buttonIndex = sender.tag
        
        optionsFlag = false
        print("buttonIndex: \(buttonIndex)")
        if buttonIndex == 2 {
            if selOption == 0 || selOption == 1 {
                updateLabelAPI()
            }
            if selOption == 2 {
                deleteFlag = true
                let lblid = selLabelId ?? "0"
                getDetailsForCatAPI(Id: Int(lblid)!)
            }
            selOption = -1
        } else {
            selOption = -1
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
     //api/v1/label/update
     
     Color: "#f44336"
     CreatedDateTime: "0001-01-01T00:00:00"
     Id: 15529
     IsDeleted: false
     LabelCategory: 0
     LastUpdatedDateTime: "0001-01-01T00:00:00"
     Name: "test23"
     ParentId: 0
     Path: "test23"
     Selected: false
     */
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
