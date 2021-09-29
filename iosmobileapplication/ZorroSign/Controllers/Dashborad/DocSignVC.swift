//
//  DocSignVC.swift
//  ZorroSign
//
//  Created by Apple on 25/08/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PDFKit



@available(iOS 11.0, *)
class DocSignVC: BaseVC, PDFViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {

    var txtPanGesture       = UIPanGestureRecognizer()
    var notePanGesture = UIPanGestureRecognizer()
    var instanceID: String?
    var pdfURL: URL?
    @IBOutlet weak var printBtn: UIButton!
    
    @IBOutlet weak var con_btmView: NSLayoutConstraint!
    @IBOutlet weak var pdfView: PDFView!
    @IBOutlet weak var lblPageNo: UILabel!
    
    var processData: ProcessData!
    var currPageNumber: Int = 1
    var signFlag = false
    var pageTagsDic: [Int:Any] = [:]
    var scrollFlag: String = ""
    var docObjId: String?
    var savedFlag: Bool = false
    var docCat: Int?
    var pageCount: Int = 1
    var permissionFlag: Bool = false
    
    @IBOutlet weak var btmView: UIView!
    var pdfW: Int = 672
    var pdfH: Int = 792
    
    var commentAlertView: SwiftAlertView!
    var commentAlertView1: SwiftAlertView!
    var multiSignAlertView: SwiftAlertView!
    var signAlertView: SwiftAlertView!
    
    var rejectComment: String = ""
    var passwd: String = ""
    var multiSign: Bool = false
    var docIdArr: [Int] = []
    var processDataArr: [ProcessData] = []
    var docsArr: [[String:Any]] = []
    var userTxtArr: [DynamicTagDetailsData] = []
    var userNoteArr: [DynamicTagDetailsData] = []
    var actionReqCnt: Int = 0
    
    @IBOutlet weak var multiSignPicker: UIPickerView!
    @IBOutlet weak var viewPicker: UIView!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    private var timer: Timer?
    var workflowCatId: Int = 0
    var documentsURL: URL?
    
    var subscriptionPlan: Int?
    var docName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loader.isHidden = true
        loader.color = ColorTheme.activityindicator
//        webview.delegate = self
        
        getSubscription()
        
        if permissionFlag {
            
            savedFlag = true
            self.con_btmView.constant = 0
            self.btmView.isHidden = true
            self.getProcessDetailsAPI()
            //callDocTrailAPI()
        }
        else if multiSign {
            getProcessList()
        }
        else if docCat == 90 {
            //NotificationCenter.default.addObserver(self, selector: #selector(pageChangedNotification(notification:)), name: Notification.Name.PDFViewPageChanged, object: nil)
            if workflowCatId == 3 {
                savedFlag = true
                self.con_btmView.constant = 0
                self.btmView.isHidden = true
                getProcessDetailsAPI()
            } else {
                getProcessAPI()
            }
        } else //if docCat == 91 || docCat == 93
        {
            savedFlag = true
            self.con_btmView.constant = 0
            self.btmView.isHidden = true
            getProcessDetailsAPI()
        }
        pdfView.delegate = self
        txtPanGesture = UIPanGestureRecognizer(target: self, action: #selector(DocSignVC.draggedView(_:)))
        
        notePanGesture = UIPanGestureRecognizer(target: self, action: #selector(DocSignVC.draggedNoteView(_:)))
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.title = docName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        //self.performSegue(withIdentifier: "segBackDashboard", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    
    func addnewTextField() {
        
        
        
        // *** Create Toolbar
        
        let inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(inputToolbar)
        inputToolbar.center = self.view.center
        
        let arr = Bundle.main.loadNibNamed("ViewTextField", owner: self, options: nil)
        let view = arr![0] as? UIView //arr![1] as? GrowingTextView
        //view?.delegate = self
//        view?.center = webview.center
        //view?.translatesAutoresizingMaskIntoConstraints = false
        
        view?.layer.borderWidth = 1
        view?.layer.borderColor = UIColor.gray.cgColor
        let closebtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        closebtn.backgroundColor = UIColor.gray
        closebtn.setTitle("x", for: UIControl.State.normal)
        view?.addSubview(closebtn)
        view?.addGestureRecognizer(txtPanGesture)
        
        //let button = view?.viewWithTag(1) as? UIButton
        closebtn.addTarget(self, action: #selector(removeTxtFld), for: UIControl.Event.touchUpInside)
        
        let cnt = userTxtArr.count
        closebtn.accessibilityHint = "\(cnt)"
        view?.accessibilityHint = "\(cnt)"
        
        let txtview = view?.viewWithTag(1) as! UITextView
        txtview.delegate = self
        
        self.view.addSubview(view!)
        let txtdata = createUserTxtData(view: view!)
        userTxtArr.append(txtdata)
    }
    
    func addNote() {
        
        // *** Create Toolbar
        
        let inputToolbar = UIView()
        inputToolbar.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        inputToolbar.translatesAutoresizingMaskIntoConstraints = false
        //self.view.addSubview(inputToolbar)
        inputToolbar.center = self.view.center
        
        let arr = Bundle.main.loadNibNamed("ViewTextField", owner: self, options: nil)
        let view = arr![2] as? UIView //arr![1] as? GrowingTextView
        //view?.delegate = self
//        view?.center = webview.center
        //view?.translatesAutoresizingMaskIntoConstraints = false
        
        view?.layer.borderWidth = 1
        view?.layer.borderColor = UIColor.gray.cgColor
        
        view?.addGestureRecognizer(notePanGesture)
        
        let closebtn = view?.viewWithTag(4) as! UIButton
        closebtn.addTarget(self, action: #selector(removeNote), for: UIControl.Event.touchUpInside)
        
        let cnt = userNoteArr.count
        closebtn.accessibilityHint = "\(cnt)"
        view?.accessibilityHint = "\(cnt)"
        
        let btnCnt = view?.viewWithTag(1) as! UIButton
        let strCnt: String = "\(cnt+1)"
        btnCnt.setTitle(strCnt, for: UIControl.State.normal)
        
        let btnMin = view?.viewWithTag(3) as! UIButton
        btnMin.addTarget(self, action: #selector(hideNote), for: UIControl.Event.touchUpInside)
        
        let btnLock = view?.viewWithTag(2) as! UIButton
        btnLock.addTarget(self, action: #selector(lockNote), for: UIControl.Event.touchUpInside)
        
        btnLock.accessibilityHint = "\(cnt)"
        
        btnCnt.addTarget(self, action: #selector(showNote), for: UIControl.Event.touchUpInside)
        
        let txtview = view?.viewWithTag(5) as! UITextView
        txtview.delegate = self
        
        let lblname = view?.viewWithTag(6) as! UILabel
        
        let fname: String = UserDefaults.standard.string(forKey: "FName")!
        let lname: String = UserDefaults.standard.string(forKey: "LName")!
        let uname = fname + " " + lname
        
        lblname.text = "Note by \(uname)"
        
        self.view.addSubview(view!)
        let txtdata = createUserNoteData(view: view!)
        userNoteArr.append(txtdata)
    }
    
    func createUserTxtData(view: UIView) -> DynamicTagDetailsData {
        
        let txtview = view.viewWithTag(1) as! UITextView
        txtview.delegate = self
        
        let cnt = userTxtArr.count
        txtview.accessibilityHint = "\(cnt)"
        let txtdata = DynamicTagDetailsData()
        let tagvalue = TagsData()
        tagvalue.type = 14
        tagvalue.State = 1
        //tagvalue.TagNo = cnt + 1
        txtdata.txtvw = txtview
        txtdata.TagValue = tagvalue
        
        let tagplaceholder = TokenPlaceholderData()
        var point = view.frame.origin
        //point = pdfView.convert(point, to: pdfView.currentPage!)
        
        tagplaceholder.XCoordinate = point.x
        
        if point.x >= 80 {
            tagplaceholder.XCoordinate = point.x - 80
        }
        
        tagplaceholder.YCoordinate = point.y
        
        if point.y >= 90 {
            tagplaceholder.YCoordinate = point.y - 90
        }
        
        /*
        if point.y >= 435 {
            tagplaceholder.YCoordinate = point.y - 435
        }
        else if point.y >= 140 {
            tagplaceholder.YCoordinate = point.y - 140
        }
        else {
            tagplaceholder.YCoordinate = point.y
        }
 */
        tagplaceholder.Width = view.frame.size.width
        tagplaceholder.Height = view.frame.size.height
        tagplaceholder.PageNumber = CGFloat(currPageNumber)
        tagvalue.TagPlaceHolder = tagplaceholder
        
        let fullname = UserDefaults.standard.value(forKey: "FullName") as! String
        tagvalue.ExtraMetaData = ["lock": false,
                                  "AddedBy": fullname]
        
        let signId: String = ZorroTempData.sharedInstance.getProfileId()
        txtdata.Signatory = signId
        txtdata.IsDynamicTag = 1
        txtdata.IsDeleted = 0
        txtdata.IsLocked = 0
        
        let date = Date()
        let format = "yyyy-MM-dd'T'HH:mm:ss"
        let df = DateFormatter()
        df.dateFormat = format
        txtdata.SignedAt = df.string(from: date)
        
        return txtdata
    }
    
    func createUserNoteData(view: UIView) -> DynamicTagDetailsData {
        
        let txtview = view.viewWithTag(5) as! UITextView
        txtview.delegate = self
        
        let cnt = userNoteArr.count
        txtview.accessibilityHint = "\(cnt)"
        let txtdata = DynamicTagDetailsData()
        let tagvalue = TagsData()
        tagvalue.type = 8
        tagvalue.State = 1
        //tagvalue.TagNo = cnt + 1
        txtdata.txtvw = txtview
        txtdata.TagValue = tagvalue
        
        let tagplaceholder = TokenPlaceholderData()
        var point = view.frame.origin
        //point = pdfView.convert(point, to: pdfView.currentPage!)
        
        tagplaceholder.XCoordinate = point.x
        
        if point.x >= 80 {
            tagplaceholder.XCoordinate = point.x - 80
        }
        
        tagplaceholder.YCoordinate = point.y
        
        if point.y >= 90 {
            tagplaceholder.YCoordinate = point.y - 90
        }
        
        tagplaceholder.Width = view.frame.size.width
        tagplaceholder.Height = view.frame.size.height
        tagplaceholder.PageNumber = CGFloat(currPageNumber)
        tagvalue.TagPlaceHolder = tagplaceholder
        
        let fullname = UserDefaults.standard.value(forKey: "FullName") as! String
        tagvalue.ExtraMetaData = ["lock": false,
                                  "AddedBy": fullname]
        
        let signId: String = ZorroTempData.sharedInstance.getProfileId()
        txtdata.Signatory = signId
        txtdata.IsDynamicTag = 1
        txtdata.IsDeleted = 0
        txtdata.IsLocked = 0
        
        let date = Date()
        let format = "yyyy-MM-dd'T'HH:mm:ss"
        let df = DateFormatter()
        df.dateFormat = format
        txtdata.SignedAt = df.string(from: date)
        
        return txtdata
    }
    
    @IBAction func removeTxtFld(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Do you want to remove this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "CONFIRM", style: .default, handler: {
            action in
            
            let btn = sender as? UIButton
            let view = btn?.superview
            //let txtview = view?.viewWithTag(1) as! UITextView
            if let index = Int((btn?.accessibilityHint)!) {
            
                self.userTxtArr.remove(at: index)
            
            }
            view?.removeFromSuperview()
        }))
        
        
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func hideNote(_ sender: UIButton) {
    
        let view = sender.superview
        var frame: CGRect = (view?.frame)!
        
        frame.size = CGSize(width: 20, height: 20)
        view?.frame = frame
        
        let btnlock = view?.viewWithTag(2) as! UIButton
        btnlock.isHidden = true
        
        let btnmin = view?.viewWithTag(3) as! UIButton
        btnmin.isHidden = true
        
        let btnclose = view?.viewWithTag(4) as! UIButton
        btnclose.isHidden = true
        
    }
    
    @IBAction func lockNote(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if let hint = sender.accessibilityHint {
            let index = Int(hint)
            let txtdata = userNoteArr[index!]
            
            let tagvalue = txtdata.TagValue
            
            if let lockval = tagvalue?.ExtraMetaData!["lock"] as? Bool {
                tagvalue?.ExtraMetaData!["lock"] = !lockval
            }
        }
    }
    
    @IBAction func showNote(_ sender: UIButton) {
        
        let view = sender.superview
        var frame: CGRect = (view?.frame)!
        
        frame.size = CGSize(width: 120, height: 170)
        view?.frame = frame
        
        let btnlock = view?.viewWithTag(2) as! UIButton
        btnlock.isHidden = false
        
        let btnmin = view?.viewWithTag(3) as! UIButton
        btnmin.isHidden = false
        
        let btnclose = view?.viewWithTag(4) as! UIButton
        btnclose.isHidden = false
    }
    
    @IBAction func removeNote(_ sender: Any) {
        
        let alert = UIAlertController(title: "", message: "Do you want to remove this note?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "CONFIRM", style: .default, handler: {
            action in
            
            let btn = sender as? UIButton
            let view = btn?.superview
            //let txtview = view?.viewWithTag(1) as! UITextView
            if let index = Int((btn?.accessibilityHint)!) {
                
                self.userNoteArr.remove(at: index)
                
            }
            view?.removeFromSuperview()
        }))
        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func onDragClicked(_ sender: Any)
    {
        //addnewTextField()
        if (sender as? UIButton)?.tag == 0 {
            addnewTextField()
        } else {
            addNote()
        }
    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        
        self.view.bringSubviewToFront(sender.view!)
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        updateTextPosition(view: sender.view!)
    }
    
    @objc func draggedNoteView(_ sender:UIPanGestureRecognizer){
        
        self.view.bringSubviewToFront(sender.view!)
        let translation = sender.translation(in: self.view)
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
        
        updateNotePosition(view: sender.view!)
    }
    
    func updateTextPosition(view: UIView) {
        
        let hint = Int(view.accessibilityHint!)
        
        let txtdata = userTxtArr[hint!]
        
        let tagvalue = txtdata.TagValue
        let tagplaceholder = tagvalue?.TagPlaceHolder
        
        var point = view.frame.origin
        //point = pdfView.convert(point, to: pdfView.currentPage!)
        
        tagplaceholder?.XCoordinate = point.x
        
        if point.x >= 80 {
            tagplaceholder?.XCoordinate = point.x - 80
        }
        
        tagplaceholder?.YCoordinate = point.y
        
        if point.y >= 90 {
            tagplaceholder?.YCoordinate = point.y - 90
        }
        /*
        if point.y >= 435 {
            tagplaceholder?.YCoordinate = point.y - 435
        }
        else if point.y >= 140 {
            tagplaceholder?.YCoordinate = point.y - 140
        }
        else {
            tagplaceholder?.YCoordinate = point.y
        }*/
        
    }
    
    func updateNotePosition(view: UIView) {
        
        let hint = Int(view.accessibilityHint!)
        
        let txtdata = userNoteArr[hint!]
        
        let tagvalue = txtdata.TagValue
        let tagplaceholder = tagvalue?.TagPlaceHolder
        
        var point = view.frame.origin
        //point = pdfView.convert(point, to: pdfView.currentPage!)
        
        tagplaceholder?.XCoordinate = point.x
        
        if point.x >= 80 {
            tagplaceholder?.XCoordinate = point.x - 80
        }
        
        tagplaceholder?.YCoordinate = point.y
        
        if point.y >= 90 {
            tagplaceholder?.YCoordinate = point.y - 90
        }
       
    }

    @IBAction func onZoomIn(_ sender: Any) {
        
//        if(webview.scrollView.zoomScale < webview.scrollView.maximumZoomScale) {
//            webview.scrollView.zoomScale = (webview.scrollView.zoomScale + 0.15);
//        }
        if pdfView.scaleFactor < pdfView.maxScaleFactor {
            pdfView.zoomIn(nil)
        }
    }
    //zoom out button action
    
    @IBAction func onZoomOut(_ sender: Any) {
        
//        if(webview.scrollView.zoomScale > webview.scrollView.minimumZoomScale) {
//            webview.scrollView.zoomScale = (webview.scrollView.zoomScale - 0.15);
//        }
        if pdfView.scaleFactor > pdfView.minScaleFactor {
            pdfView.zoomOut(nil)
        }
    }
    
    @IBAction func onFitWindow(_ sender: Any) {
        
//        webview.scalesPageToFit = true
        pdfView.autoScales = true
        
    }
    
    @IBAction func printDoc() {
        
        downloadDoc()
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func callDocTrailAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        let qrdata = UserDefaults.standard.value(forKey: "qrcode") as? String
        
        let arr = qrdata?.components(separatedBy: ",")
        let qrcode = arr![0]
        //"H4sIAAAAAAAEAAs1cjcOSI0yyyh1y0y3LFM1cjNWNXJKjUxLVzV2ASIAg3UoZyAAAAA="//arr![0]
        let parameters = ["QRCodeData":qrcode, "Request":1, "Mode": 2] as [String : Any]
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            Alamofire.request(URL(string: Singletone.shareInstance.apiDoc + "api/v1/tokenReader/GetDocumentTrail")!, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject {
                        debugPrint(jsonDic)
                        let statusCode = jsonDic["StatusCode"] as! Int
                        if statusCode == 1000
                        {
                            if let jsonData = jsonDic["Data"] as? NSArray {
                                print(jsonData)
                                
                                for dic in jsonData {
                                    let doctrail = DocumentTrailData(dictionary: dic as! [AnyHashable : Any])
                                    //self.docTrailData.append(doctrail)
                                    if doctrail.InstanceId! > 0 {
                                        let instId: String = "\(doctrail.InstanceId!)"
                                        self.instanceID = instId
                                    }
                                }
                                self.getProcessDetailsAPI()
                                
                            }
                        }
                        else
                        {
                            
                            self.alertSample(strTitle: "", strMsg: jsonDic["Message"] as! String)
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
    
    func getProcessList() {
        
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetProcessList")
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            Alamofire.request(URL(string: apiURL)!, method: .post, parameters: docIdArr.asParameters(), encoding: ArrayEncoding(), headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    self.stopActivityIndicator()
                    var json: JSON = JSON(response.data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        
                        if let jsonObjMain:[[String:Any]] = jsonDic["Data"] as? [[String:Any]] {
                            var cntr = 0
                            for jsonDic in jsonObjMain {
                                if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                                    print(jsonObj)
                                    
                                    let processData: ProcessData = ProcessData(dictionary: jsonObj as! [AnyHashable : Any])
                                    let doclist = processData.Documents![0]
                                    let docObjId = doclist.ObjectId
                                    var processType: String = ""
                                    var typeArr:[Int] = []
                                    
                                    for step in processData.Steps! {
                                        
                                        if step.CCList != nil {
                                            for cclist in step.CCList! {
                                                processType = "Auto Fill"
                                            }
                                        }
                                        for tag in step.Tags! {
                                            /*
                                            if tag.type == 0 || tag.type == 1 || tag.type == 4 || tag.type == 9 {
                                                processType = "Auto Fill"
                                            } else {
                                                processType = "Action Required"
                                            }*/
                                            typeArr.append(tag.type!)
                                        }
                                    }
                                    
                                    if typeArr.contains(3) || typeArr.contains(5) || typeArr.contains(7) || typeArr.contains(13) || typeArr.contains(14)
                                    {
                                        processType = "Action Required"
                                    } else {
                                        processType = "Auto Fill"
                                    }
                                    
                                    processData.processType = processType
                                    processData.selected = true
                                    
                                    self.processDataArr.append(processData)
                                    let processId: Int = processData.ProcessId!
                                    
                                    if cntr == 0 {
                                        self.docObjId = docObjId
                                        self.instanceID = "\(processData.ProcessId!)"
                                        self.processData = processData
                                    }
                                    self.docsArr.append(["processId":processId, "docId": docObjId])
                                    
                                }
                                cntr = cntr + 1
                            }
                            
                            print("self.docsArr: \(self.docsArr)")
                            self.showMultiSignAlert()
                            //self.getDocSize(objectId: self.docObjId as! String)
                            DispatchQueue.main.async {
                                self.getDocAPI(objID: self.docObjId!, processID: self.instanceID!)
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
    // API call
    func getProcessAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetProcess?processId=\(instanceID!)")
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let parameters = ["key":"1"]
        
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
                        if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            let jsonData = jsonDic["Data"] as! NSDictionary
                            self.processData = ProcessData(dictionary: jsonData as! [AnyHashable : Any])
                            let doclist = self.processData.Documents![0]
                            self.docObjId = doclist.ObjectId //jsonData["ObjectId"]
                            var processType: String = ""
                            var typeArr:[Int] = []
                            
                            for step in self.processData.Steps! {
                                
                                if step.CCList != nil {
                                    for cclist in step.CCList! {
                                        processType = "Auto Fill"
                                    }
                                }
                                for tag in step.Tags! {
                                   
                                    typeArr.append(tag.type!)
                                }
                            }
                            if typeArr.contains(3) || typeArr.contains(5) || typeArr.contains(7) || typeArr.contains(13) || typeArr.contains(14)
                            {
                                processType = "Action Required"
                            } else {
                                processType = "Auto Fill"
                            }
                            
                            self.processData.processType = processType
                            
                            //self.getDocSize(objectId: self.docObjId as! String)
                            DispatchQueue.main.async {
                                
                                if doclist.DocType == 2 { // for user specific workflow
                                    
                                    /*
                                     https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=<token>&ctrl=Dashboard&destination=workflow/-1/ndcprocess/<processId>
                                     https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=uqrnZ8906AmE0kxdaoKBxeV45wCWspWrN394iHRQJltwVScI0vxEqYateRRG4E9ONKRBJYNQxGJaEr5Zc7CatrQbTf4pbD6JInCcLKBuypzC8kp5AvvBU5P27mySwkoY&ctrl=Dashboard&destination=workflow/-1/ndcprocess/11383
                                     */
                                    let msg = "You will now be directed to our web app to complete this document."
                                    
                                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                    alert.addAction(UIAlertAction(title: "Open in browser", style: .default, handler: {
                                        action in
                                        
                                        let procId: String = self.instanceID!
                                        let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/-1/ndcprocess/\(procId)"
                                        let url = URL(string: urlstr)
                                        UIApplication.shared.openURL(url!)
                                        
                                    }))
                                    alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                                    self.present(alert, animated: true, completion: {
                                        self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                    })
                                    
                                } else {
                                    
                                    self.getDocAPI(objID: self.docObjId as! String, processID: self.instanceID!)
                                }
                                //self.getDocAPI(objID: self.docObjId!, processID: self.instanceID!)
                            }
                            /*
                             ["Data": ["Steps": [["StepNo": 2, "Tags": [["TagPlaceHolder": ["Height": 26.67, "XCoordinate": 286, "PageNumber": 1, "YCoordinate": 66, "Width": 133.33], "Signatories": [["ProfileImage": <null>, "UserName": <null>, "FriendlyName": <null>, "Type": 1, "Id": F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D]], "State": 1, "TagId": 13105, "ObjectId": <null>, "ExtraMetaData": [:], "DueDate": 2018-08-23T23:59:59, "Type": 0, "TagNo": 1]], "CCList": []]], "UserPlaceHolders": [], "ModifiedDate": 2018-08-22T16:03:37, "DynamicTagDetails": [], "IsLastStep": 1, "IsInitiated": 1, "ProcessingSubSteps": [1], "OrganizationId": 0, "CreatedDate": 2018-08-22T16:03:32, "MainDocumentType": 0, "DefinitionId": 5053, "ProcessId": 3674, "CreatedUser": 2031, "HasAToken": 0, "PageSizes": [], "DocumentSetName": Test 6, "ExtendedProcessData": <null>, "ModifiedUser": 2031, "ProcessState": 1, "ProcessingStep": 2, "TokenPlaceholder": ["Height": 0, "XCoordinate": 0, "PageNumber": 0, "YCoordinate": 0, "Width": 0], "DefinitionName": Test 6, "Documents": [["DocType": 0, "OriginalName": <null>, "Name": AAA_TestPdf, "ObjectId": workspace://SpacesStore/2c3a5569-cf5a-4b63-8388-f0e2d597ad6d;1.0, "IsDeletable": 0, "AttachedUserProfileId": 0, "AttachedUser": <null>]], "DynamicTextDetails": []], "StatusCode": 1000, "Message": Get Process successful. ProcessId : 3674.]
                             */
                            
                            /*
                             {
                             CreatedDate = "2018-08-22T16:03:32";
                             CreatedUser = 2031;
                             DefinitionId = 5053;
                             DefinitionName = "Test 6";
                             DocumentSetName = "Test 6";
                             Documents =     (
                             {
                             AttachedUser = "<null>";
                             AttachedUserProfileId = 0;
                             DocType = 0;
                             IsDeletable = 0;
                             Name = "AAA_TestPdf";
                             ObjectId = "workspace://SpacesStore/2c3a5569-cf5a-4b63-8388-f0e2d597ad6d;1.0";
                             OriginalName = "<null>";
                             }
                             );
                             DynamicTagDetails =     (
                             );
                             DynamicTextDetails =     (
                             );
                             ExtendedProcessData = "<null>";
                             HasAToken = 0;
                             IsInitiated = 1;
                             IsLastStep = 1;
                             MainDocumentType = 0;
                             ModifiedDate = "2018-08-22T16:03:37";
                             ModifiedUser = 2031;
                             OrganizationId = 0;
                             PageSizes =     (
                             );
                             ProcessId = 3674;
                             ProcessState = 1;
                             ProcessingStep = 2;
                             ProcessingSubSteps =     (
                             1
                             );
                             Steps =     (
                             {
                             CCList =             (
                             );
                             StepNo = 2;
                             Tags =             (
                             {
                             DueDate = "2018-08-23T23:59:59";
                             ExtraMetaData =                     {
                             };
                             ObjectId = "<null>";
                             Signatories =                     (
                             {
                             FriendlyName = "<null>";
                             Id = "F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D";
                             ProfileImage = "<null>";
                             Type = 1;
                             UserName = "<null>";
                             }
                             );
                             State = 1;
                             TagId = 13105;
                             TagNo = 1;
                             TagPlaceHolder =                     {
                             Height = "26.67";
                             PageNumber = 1;
                             Width = "133.33";
                             XCoordinate = 286;
                             YCoordinate = 66;
                             };
                             Type = 0;
                             }
                             );
                             }
                             );
                             TokenPlaceholder =     {
                             Height = 0;
                             PageNumber = 0;
                             Width = 0;
                             XCoordinate = 0;
                             YCoordinate = 0;
                             };
                             UserPlaceHolders =     (
                             );
                             }
                             */
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
    
    //https://zsdemowebworkflow.zorrosign.com/api/v1/process/3658/document?objectId=

    func getDocAPI(objID: String, processID: String) {
        
        self.showActivityIndicatory(uiView: self.view)
        
        //self.loader.isHidden = false
        //self.loader.startAnimating()
        
        ////https://zsdemowebworkflow.zorrosign.com/api/v1/process/3658/document?objectId=
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/\(processID)/document?objectId=\(objID)")
        apiURL = apiURL + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let parameters = ["key":"1"]
        
        //(documentData?.ObjectId!)!
        let filename =  "test.pdf"
        documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        documentsURL!.appendPathComponent(filename)
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            
            return (self.documentsURL!, [.removePreviousFile])
        }
        
        if Connectivity.isConnectedToInternet() == true
        {
            //let strPid = UserDefaults.standard.string(forKey: "ProfileId")!
            //let urlReq: URLRequest = URLRequest(url: URL(string: apiURL))
            
            Alamofire.download(URL(string: apiURL)!, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headerAPIDashboard, to: destination).responseData { (response) in
                
                
                print(response.destinationURL?.absoluteString)
                if let statusCode = response.response?.statusCode, statusCode == 200 {
                    //self.alertSample(strTitle: "", strMsg: "Downlaod completed")
                    
                    self.pdfURL = URL(fileURLWithPath: (self.documentsURL?.path)!)
                    //let path = Bundle.main.path(forResource: "test", ofType: "pdf")
                    //self.pdfURL = URL(fileURLWithPath: path!)
                    
                    let req = NSURLRequest(url: self.pdfURL!)
                    //self.webview.loadRequest(req as URLRequest)
                    
                    
                    
                    guard var pdf = CGPDFDocument(self.pdfURL as! CFURL) else {
                        print("Not able to load pdf file.")
                        return
                    }
                    let pdfRef = pdf.page(at: 1)
                    let rect = pdfRef?.getBoxRect(.mediaBox)
                    self.pdfW = Int((rect?.size.width)!)
                    self.pdfH = Int((rect?.size.height)!)
                    
                    let format = self.getDocFormat(width: self.pdfW , height: self.pdfH) as? String
                    
                    if format != "NA"
                    {
                        //self.resetTimer()
                        
                        let pdfDoc = PDFDocument(url: self.pdfURL!)
                        self.pdfView.document = pdfDoc
                        self.pdfView.displayMode = .singlePage
                        
                        self.pageCount = pdf.numberOfPages
                        self.lblPageNo.text = "\(self.currPageNumber)/\(self.pageCount)"
                        
                        if !self.savedFlag {
                            
                            self.showTags()
                        }
                        self.removePageTags()
                        self.pdfView.scaleFactor = 1
                        //let pageCount = CGPDFDocument.page(pdf)//CGPDFDocumentGetNumberOfPages(pdf);
                        //print("pageCount: \(pageCount)")
                        
                        //self.loader.stopAnimating()
                        //self.loader.isHidden = true
                        self.stopActivityIndicator()
                       
                    } else {
                        DispatchQueue.main.async {
                            
                            let msg = "The document size (Letter, A4 etc) that you are trying to sign is currently incompatible with our  mobile app. Click following button to sign this document using your mobile web browser. Alternatively you can sign this document by logging into ZorroSign on your computer."
                            
                            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            alert.addAction(UIAlertAction(title: "Open in browser", style: .default, handler: {
                                action in
                                
                                if self.docCat == 90 {
                                    let procId: String = self.instanceID!
                                    let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/-1/process/\(procId)"
                                    let url = URL(string: urlstr)
                                    UIApplication.shared.openURL(url!)
                                } else {
                                    let procId: String = self.instanceID!
                                    let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=download/process/\(procId)/code/"
                                    let url = URL(string: urlstr)
                                    UIApplication.shared.openURL(url!)
                                }
                                /*
                                 InBox:
                                 https://app.zorrosign.com/home/SSOLogin?serviceToken=qLlpo9fRYmgLDTBIpLzjikdidB3yTUvoYBcR3A2by0NG7fagOVwmJbyJslXBjtZn5iF4iX9FdnUTn7T9eiqWoHdAtEKlHL8pUadOq4GFzU1qwTcXNUoKAOlYuXIMZeUP&ctrl=Dashboard&destination=workflow/-1/process/11269
                                 
                                 In-Process / Completed / Rejected
                                 https://app.zorrosign.com/home/SSOLogin?serviceToken=qLlpo9fRYmgLDTBIpLzjikdidB3yTUvoYBcR3A2by0NG7fagOVwmJbyJslXBjtZn5iF4iX9FdnUTn7T9eiqWoHdAtEKlHL8pUadOq4GFzU1qwTcXNUoKAOlYuXIMZeUP&ctrl=Dashboard&destination=download/process/11266/code/
                                 */
                                
                            }))
                            alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                            self.present(alert, animated: true, completion: {
                                self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                //self.navigationController?.popViewController(animated: true)
                            })
                            self.stopActivityIndicator()
                            
                        }
                        
                    }
                    
                    //print("pdfrect: \(rect?.size.width), \(rect?.size.height)")
                    
                    
                    
                } else {
                    self.alertSample(strTitle: "", strMsg: "Download error")
                }
                //self.stopActivityIndicator()
            }
            
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func showTags() {
        
        //self.loader.isHidden = false
        ///self.loader.startAnimating()
        //addObservers()
        removePageTags()
        pageTagsDic.removeAll()
        currPageNumber = 1
        
        for steps in self.processData.Steps! {
            
            for tagdata in steps.Tags! {
                
                let tagplaceholder = tagdata.TagPlaceHolder
                var point = calcPos(x: (tagplaceholder?.XCoordinate)!, y: (tagplaceholder?.YCoordinate)!, w: (tagplaceholder?.Width)!, h: (tagplaceholder?.Height)!, type: tagdata.type!)
                
                if tagdata.type == 0 || tagdata.type == 1  {
                    point = CGPoint(x: point.x, y: point.y - 15)
                }
                if tagdata.type == 2 {
                    //point = CGPoint(x: point.x, y: point.y - 80)
                    point = CGPoint(x: point.x, y: point.y)
                }
                if tagdata.type == 3 {
                    //let point1 = CGPoint(x: point.x, y: point.y+4)
                    point = CGPoint(x: point.x, y: point.y - 8)
                }
                
                var tokenview = UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                if tagdata.type == 13 {
                    tokenview = UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Height)!, height: (tagplaceholder?.Height)!)))
                }
                if tagdata.type == 4 {
                    tokenview = UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                }
                tokenview.titleLabel?.font = UIFont.systemFont(ofSize: 8)
                tokenview.layer.borderColor = UIColor.gray.cgColor
                tokenview.layer.borderWidth = 2
                tokenview.tag = tagdata.TagId
                
                if tagdata.type == 0 || tagdata.type == 1 {
                    tokenview.setTitle("Signature", for: UIControl.State.normal)
                    tokenview.setTitleColor(UIColor.black, for: UIControl.State.normal)
                    tokenview.addTarget(self, action: #selector(signAction), for: UIControl.Event.touchUpInside)
                    
                }
                if tagdata.type == 4 {
                    tokenview.setTitle("Click ", for: UIControl.State.normal)
                    tokenview.setTitleColor(UIColor.black, for: UIControl.State.normal)
                    //tokenview.addTarget(self, action: #selector(dateAction), for: UIControlEvents.touchUpInside)
                }
                if tagdata.type == 3 {
                    let tokenview = UITextField(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                    tokenview.layer.borderColor = UIColor.black.cgColor
                    tokenview.layer.borderWidth = 2
                    tokenview.tag = tagdata.TagId
                    tokenview.delegate = self
                    
                    let page = self.pdfView.currentPage
                    let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                    
                    
                    button.widgetFieldType = .text
                    
                    //button.buttonWidgetStateString = ""
                    button.widgetStringValue = tagdata.TagText
                    //button.widgetControlType = .pushButtonControl
                    button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                    button.border?.lineWidth = 1
                    button.border?.style = .solid
                    let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                    button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                    
                    let strurl = "\(tagdata.TagId)"
                    button.action = PDFActionURL(url: URL(string: strurl)!)
                    
                    //page?.addAnnotation(button)
                    tagdata.pdfAnnotation = button
                    
                }
                let pageNo = Int((tagplaceholder?.PageNumber)!)
                if let arr = pageTagsDic[pageNo] as? NSMutableArray{
                    var flag = false
                    if pageNo == currPageNumber {
                        flag = true
                    }
                    
                    if tagdata.type == 3 {
                        let tokenview = UITextField(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                        tokenview.layer.borderColor = UIColor.black.cgColor
                        tokenview.layer.borderWidth = 2
                        tokenview.tag = tagdata.TagId
                        tokenview.delegate = self
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        
                        button.widgetFieldType = .text
                        button.buttonWidgetStateString = ""
                        
                        //button.widgetControlType = .pushButtonControl
                        button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                        button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                        
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        //page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                        tagdata.flagAdded = flag
                        tagdata.view = tokenview
                        arr.add(tagdata)
                        pageTagsDic[pageNo] = arr
                    } else {
                        
                        tagdata.flagAdded = flag
                        tagdata.view = tokenview
                        arr.add(tagdata)
                        pageTagsDic[pageNo] = arr
                    }
                } else {
                    var flag = false
                    if pageNo == currPageNumber {
                        flag = true
                    }
                    
                    if tagdata.type == 3 {
                        let point1 = CGPoint(x:point.x, y: point.y-100)
                        let tokenview = UITextField(frame: CGRect(origin: point1, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                        tokenview.layer.borderColor = UIColor.black.cgColor
                        tokenview.layer.borderWidth = 2
                        tokenview.tag = tagdata.TagId
                        tokenview.delegate = self
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        
                        
                        
                        button.widgetFieldType = .text
                        button.isMultiline = true
                        button.buttonWidgetStateString = ""
                        //button.widgetControlType = .pushButtonControl
                        button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                        button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                        
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        //page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                        
                        var arr = NSMutableArray.init()
                        tagdata.flagAdded = flag
                        tagdata.view = tokenview
                        arr.add(tagdata)
                        pageTagsDic[pageNo] = arr
                    }
                    else {
                        var arr = NSMutableArray.init()
                        tagdata.flagAdded = flag
                        tagdata.view = tokenview
                        arr.add(tagdata)
                        pageTagsDic[pageNo] = arr
                    }
                }
                
                
                
                if pageNo == currPageNumber {
                    
                    let page = self.pdfView.currentPage
                    
                    //self.view.addSubview(tokenview)
                    if tagdata.type == 0 || tagdata.type == 1 || tagdata.type == 4 {
                        
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        if tagdata.type == 4 {
                            button.buttonWidgetStateString = "Date"
                            button.caption = "Date"
                        } else if tagdata.type == 2 {
                            button.buttonWidgetStateString = "Seal"
                            button.caption = "Seal"
                        }
                        else if tagdata.type == 0 {
                            button.buttonWidgetStateString = "Signature"
                            button.caption = "Signature"
                        }
                        else if tagdata.type == 1 {
                            button.buttonWidgetStateString = "Initial"
                            button.caption = "Initial"
                        }
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.border?.style = .solid
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                        
                    }
                    
                    if tagdata.type == 2 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        button.buttonWidgetStateString = "Seal"
                        button.caption = "Seal"
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                        
                    }
                    if tagdata.type == 16 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        /*
                        let fname: String = UserDefaults.standard.string(forKey: "FName")!
                        let lname: String = UserDefaults.standard.string(forKey: "LName")!
                        let uname = fname + " " + lname
                        */
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Name"
                        button.caption = "Name"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 0
                        //button.border?.style = .solid
                        
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    
                    if tagdata.type == 17 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        /*
                        let email: String = UserDefaults.standard.string(forKey: "Email")!
                        
                        */
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Email"
                        button.caption = "Email"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                         let strurl = "\(tagdata.TagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    
                    if tagdata.type == 18 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        /*
                        let email: String = UserDefaults.standard.string(forKey: "Email")!
                        
 */
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Company"
                        button.caption = "Company"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                         let strurl = "\(tagdata.TagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    
                    if tagdata.type == 19 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        /*
                        let jobTitle: String = UserDefaults.standard.string(forKey: "jobTitle")!
                        
                        
                         */
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Title"
                        button.caption = "Title"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                         let strurl = "\(tagdata.TagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    
                    if tagdata.type == 20 {
                        
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        /*
                        let phone: String = UserDefaults.standard.string(forKey: "Phone")!
                        
                        
                         */
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Phone"
                        button.caption = "Phone"
                        
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                         let strurl = "\(tagdata.TagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                   
                    if tagdata.type == 3 {
                        let point1 = CGPoint(x: point.x, y: point.y-100)
                        let tokenview = UITextField(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                        tokenview.layer.borderColor = UIColor.black.cgColor
                        tokenview.layer.borderWidth = 2
                        tokenview.tag = tagdata.TagId
                        tokenview.delegate = self
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        
                        button.widgetStringValue = tagdata.TagText
                        button.widgetFieldType = .text
                        button.isMultiline = true
                        button.buttonWidgetStateString = ""
                        //button.widgetControlType = .pushButtonControl
                        button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                        button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                        
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                        
                    }
                    if tagdata.type == 8 {
                        let tokenview = UITextField(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                        tokenview.layer.borderColor = UIColor.gray.cgColor
                        tokenview.layer.borderWidth = 2
                        tokenview.tag = tagdata.TagId
                        tokenview.delegate = self
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.text, withProperties: nil)
                        
                        button.widgetFieldType = .text
                        //button.widgetControlType = .unknownControl
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        button.isReadOnly = false
                        
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    if tagdata.type == 13 {
                        //tokenview = UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Height)!, height: (tagplaceholder?.Height)!)))
                        tokenview.setImage(UIImage(named: "checkbox_black"), for: UIControl.State.normal)
                        tokenview.setImage(UIImage(named: "checkbox_sel_black"), for: UIControl.State.selected)
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        
                        button.widgetFieldType = .button
                        button.widgetControlType = .checkBoxControl
                        //button.buttonWidgetStateString = "Click to Sign"
                        //button.caption = "Click to Sign"
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                    
                    if multiSign && processData.processType == "Auto Fill" {
                        autoFillSign(tag: tagdata.TagId)
                    }
                }
                
                
            }
        }
        
        for data in processData.DynamicTagDetails {
         
            let tagdata: TagsData = data.TagValue!
            
            tagdata.TagText = data.TagText!
            
            let tagplaceholder = tagdata.TagPlaceHolder
            let point = calcPos(x: (tagplaceholder?.XCoordinate)!, y: (tagplaceholder?.YCoordinate)!+180, w: (tagplaceholder?.Width)!, h: (tagplaceholder?.Height)!, type: tagdata.type!)
            
            
            //if tagdata.type == 8 {
                let tokenview = UITextView(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                    //UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
                tokenview.layer.borderColor = UIColor.gray.cgColor
                tokenview.layer.borderWidth = 2
                tokenview.text = data.TagText
                tokenview.textColor = UIColor.black
                tokenview.delegate = self
                
                let pageNo = Int((tagplaceholder?.PageNumber)!)
                if let arr = pageTagsDic[pageNo] as? NSMutableArray{
                    var flag = false
                    if pageNo == currPageNumber {
                        flag = true
                    }
                    tagdata.flagAdded = flag
                    tagdata.view = tokenview
                    arr.add(tagdata)
                    pageTagsDic[pageNo] = arr
                } else {
                    var flag = false
                    if pageNo == currPageNumber {
                        flag = true
                    }
                    var arr = NSMutableArray.init()
                    tagdata.flagAdded = flag
                    tagdata.view = tokenview
                    arr.add(tagdata)
                    pageTagsDic[pageNo] = arr
                }
                if pageNo == currPageNumber {
                    
                    //self.view.addSubview(tokenview)
                    
                    let page = self.pdfView.currentPage
                    let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype(rawValue: PDFAnnotationSubtype.freeText.rawValue), withProperties: nil)
                    //button.widgetFieldType = .text
                    button.widgetStringValue = tagdata.TagText
                    button.caption = tagdata.TagText
                   // page?.addAnnotation(button)
                    
                    if tagdata.type == 8 {
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype.freeText, withProperties: nil)
                        
                        button.widgetFieldType = .text
                        button.buttonWidgetStateString = data.TagText ?? ""
                        button.caption = data.TagText ?? ""
                        button.contents = data.TagText ?? ""
                        button.fontColor = UIColor.black
                        button.widgetStringValue = data.TagText ?? ""
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.isReadOnly = false
                        
                        button.border?.style = .solid
                        let strurl = "\(tagdata.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        page?.addAnnotation(button)
                        tagdata.pdfAnnotation = button
                    }
                   
                }
            //}
            
        }
        for data in processData.DynamicTextDetails {
            
            
            let tagdata: TagsData = data.TagValue!
            tagdata.dynamicTagData = data
            let tagplaceholder = tagdata.TagPlaceHolder
            let point = calcPos(x: (tagplaceholder?.XCoordinate)!, y: (tagplaceholder?.YCoordinate)!, w: (tagplaceholder?.Width)!, h: (tagplaceholder?.Height)!, type: tagdata.type!)
            
            
            //if tagdata.type == 8 {
            let tokenview = UITextView(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
            //UIButton(frame: CGRect(origin: point, size: CGSize(width: (tagplaceholder?.Width)!, height: (tagplaceholder?.Height)!)))
            tokenview.layer.borderColor = UIColor.gray.cgColor
            tokenview.layer.borderWidth = 2
            //tokenview.text = tagdata.TagText
            tokenview.textColor = UIColor.black
            tokenview.delegate = self
            
            let pageNo = Int((tagplaceholder?.PageNumber)!)
            if let arr = pageTagsDic[pageNo] as? NSMutableArray{
                var flag = false
                
                if pageNo == currPageNumber {
                    flag = true
                }
                tagdata.flagAdded = flag
                tagdata.view = tokenview
                arr.add(tagdata)
                pageTagsDic[pageNo] = arr
            } else {
                var flag = false
                
                if pageNo == currPageNumber {
                    flag = true
                }
                tagdata.flagAdded = flag
                var arr = NSMutableArray.init()
                
                tagdata.view = tokenview
                arr.add(tagdata)
                pageTagsDic[pageNo] = arr
            }
            if pageNo == currPageNumber {
                
                //self.view.addSubview(tokenview)
                
                let page = self.pdfView.currentPage
                
                
                let button = PDFAnnotation(bounds: tokenview.frame, forType: PDFAnnotationSubtype(rawValue: PDFAnnotationSubtype.freeText.rawValue), withProperties: nil)
                //button.widgetFieldType = .text
                //button.widgetStringValue = tagdata.TagText
                //button.caption = tagdata.TagText
                
                let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                // page?.addAnnotation(button)
                tagdata.pdfAnnotation = button
               
                if tagdata.type == 14 {
                    
                    let button = PDFAnnotation(bounds: (tokenview.frame), forType: PDFAnnotationSubtype.widget, withProperties: nil)
                    
                    //button.buttonWidgetStateString = data.TagText!//""
                    button.widgetStringValue = data.TagText
                    //button.caption = data.TagText//""
                    button.widgetFieldType = .text
                    button.isMultiline = true
                    button.iconType = .note
                    button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                    button.border?.lineWidth = 1
                    button.border?.style = .solid
                    let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                    button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                    
                    let tag: Int = (tokenview.tag)
                    let strurl = "\(tag)"
                    button.action = PDFActionURL(url: URL(string: strurl)!)
                    
                    page?.addAnnotation(button)
                    tagdata.pdfAnnotation = button
                    
                }
            }
            //}
            
        }
        
        
        
        //self.loader.stopAnimating()
        //self.loader.isHidden = true
    }
    
    
    
    func addPageTags() {
        
        //if pageTagsDic.count >= currPageNumber {
        if let arr = pageTagsDic[currPageNumber] as? NSMutableArray {
            let page = self.pdfView.currentPage
            if arr != nil {
                for viewobj in arr {
                    let tagdata = viewobj as? TagsData
                    let tokenview = tagdata?.view
                    
                    if tagdata?.type == 0 || tagdata?.type == 1 || tagdata?.type == 4 {
                    
                    let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                    button.widgetFieldType = .button
                    button.widgetControlType = .pushButtonControl
                    if tagdata?.type == 4 {
                        button.buttonWidgetStateString = "Date"
                        button.caption = "Date"
                    }
                    else if tagdata?.type == 0 {
                        button.buttonWidgetStateString = "Signature"
                        button.caption = "Signature"
                    }
                    else if tagdata?.type == 1 {
                        button.buttonWidgetStateString = "Initial"
                        button.caption = "Initial"
                        }
                    button.backgroundColor = UIColor.white
                    button.border?.lineWidth = 1
                    button.border?.style = .solid
                    button.font = UIFont.systemFont(ofSize: 10)
                    let tag: Int = (tokenview?.tag)!
                    let strurl = "\(tag)"
                    button.action = PDFActionURL(url: URL(string: strurl)!)
                    
                    if tagdata?.flagAdded == false {
                        tagdata?.flagAdded = true
                        
                        
                        /*
                        if (viewobj as? TagsData)?.type == 3 {
                            var frame1 = tokenview?.frame
                            //frame1?.size = CGSize(width: (frame1?.size.width)! + 10, height: (frame1?.size.height)! + 10)
                            
                            
                            let button1 = PDFAnnotation(bounds: frame1!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                            button1.widgetFieldType = .button
                            button1.border?.lineWidth = 1
                            button1.border?.style = .solid
                            page?.addAnnotation(button1)
                        }*/
                        page?.addAnnotation(button)
                        tagdata?.pdfAnnotation = button
                    }
                }
               
                    if tagdata?.type == 3 || tagdata?.type == 14 {
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        //button.buttonWidgetStateString = ""
                        //button.caption = ""
                        if tagdata?.type == 14 {
                            let data = tagdata?.dynamicTagData
                            button.widgetStringValue = data?.TagText
                        } else {
                            button.widgetStringValue = tagdata?.TagText
                        }
                        button.widgetFieldType = .text
                        button.isMultiline = true
                        button.iconType = .note
                        button.backgroundColor = UIColor(red: 229/255, green: 231/255, blue: 228/255, alpha: 1)
                        button.border?.lineWidth = 1
                        button.border?.style = .solid
                        button.font = UIFont.systemFont(ofSize: 10)
                        let keyBorderColor = PDFAnnotationKey(rawValue: "widgetBorderColor")
                        button.setValue(UIColor.black, forAnnotationKey: keyBorderColor)
                        
                        let tag: Int = (tokenview?.tag)!
                        let strurl = "\(tag)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 8 {
                        
                        let page = self.pdfView.currentPage
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.freeText, withProperties: nil)
                        
                        button.widgetFieldType = .text
                        button.buttonWidgetStateString = tagdata?.TagText ?? ""
                        button.caption = tagdata?.TagText ?? ""
                        button.contents = tagdata?.TagText ?? ""
                        button.fontColor = UIColor.black
                        button.widgetStringValue = tagdata?.TagText ?? ""
                        button.backgroundColor = UIColor.white
                        button.border?.lineWidth = 1
                        button.isReadOnly = false
                        
                        button.border?.style = .solid
                        let strurl = "\(tagdata?.TagId)"
                        button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 2 {
                    
                    let tokenview = tagdata?.view
                    let button1 = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                    button1.widgetFieldType = .button
                    button1.widgetControlType = .pushButtonControl
                    button1.buttonWidgetStateString = "Seal"
                    button1.caption = "Seal"
                    
                    button1.backgroundColor = UIColor.white
                    button1.border?.lineWidth = 1
                    button1.border?.style = .solid
                    button1.font = UIFont.systemFont(ofSize: 10)
                    let tag: Int = (tokenview?.tag)!
                    let strurl = "\(tag)"
                    button1.action = PDFActionURL(url: URL(string: strurl)!)
                    
                    if tagdata?.flagAdded == false {
                        tagdata?.flagAdded = true
                        
                        page?.addAnnotation(button1)
                        tagdata?.pdfAnnotation = button1
                    }
                }
                if tagdata?.type == 13 {
                    let tokenview = tagdata?.view
                    let button2 = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                    button2.widgetFieldType = .button
                    button2.widgetControlType = .checkBoxControl
                    //button.buttonWidgetStateString = "Click to Sign"
                    //button.caption = "Click to Sign"
                    button2.backgroundColor = UIColor.white
                    button2.border?.lineWidth = 1
                    button2.border?.style = .solid
                    button2.font = UIFont.systemFont(ofSize: 10)
                    
                    let tag: Int = (tokenview?.tag)!
                    let strurl = "\(tag)"
                    button2.action = PDFActionURL(url: URL(string: strurl)!)
                    
                    if tagdata?.flagAdded == false {
                        tagdata?.flagAdded = true
                        
                        page?.addAnnotation(button2)
                        tagdata?.pdfAnnotation = button2
                    }
                }
                    if tagdata?.type == 16 {
                        
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        let fname: String = UserDefaults.standard.string(forKey: "FName")!
                        let lname: String = UserDefaults.standard.string(forKey: "LName")!
                        let uname = fname + " " + lname
                        
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Name"
                        button.caption = "Name"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        let tagId: Int = (tagdata?.TagId)!
                        let strurl = "\(tagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 17 {
                        
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        let email: String = UserDefaults.standard.string(forKey: "Email")!
                        
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Email"
                        button.caption = "Email"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        let tagId: Int = (tagdata?.TagId)!
                        let strurl = "\(tagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 18 {
                        
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        let email: String = UserDefaults.standard.string(forKey: "Email")!
                        
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Company"
                        button.caption = "Company"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                        let tagId: Int = (tagdata?.TagId)!
                        let strurl = "\(tagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 19 {
                        
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        let email: String = UserDefaults.standard.string(forKey: "Email")!
                        
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Title"
                        button.caption = "Title"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                        let tagId: Int = (tagdata?.TagId)!
                        let strurl = "\(tagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if tagdata?.type == 20 {
                        
                        let button = PDFAnnotation(bounds: (tokenview?.frame)!, forType: PDFAnnotationSubtype.widget, withProperties: nil)
                        button.widgetFieldType = .button
                        button.widgetControlType = .pushButtonControl
                        
                        let phone: String = UserDefaults.standard.string(forKey: "Phone")!
                        
                        button.font = UIFont.systemFont(ofSize: 10)
                        button.buttonWidgetStateString = "Phone"
                        button.caption = "Phone"
                        
                        button.backgroundColor = UIColor.white
                        //button.border?.lineWidth = 1
                        //button.border?.style = .solid
                        
                        let tagId: Int = (tagdata?.TagId)!
                        let strurl = "\(tagId)"
                         button.action = PDFActionURL(url: URL(string: strurl)!)
                        
                        if tagdata?.flagAdded == false {
                            tagdata?.flagAdded = true
                            page?.addAnnotation(button)
                            tagdata?.pdfAnnotation = button
                        }
                    }
                    
                    if multiSign && processData.processType == "Auto Fill" {
                        autoFillSign(tag: (tagdata?.TagId)!)
                    }
            }
            }
        }
        //}
        
        
       
    }
    
    
    func removePageTags() {
        
        let document = PDFDocument(url: self.pdfURL!)
        let pageCount = pageTagsDic.count
        for i in 0..<pageCount {
            let page = document?.page(at: i)
            
            if let annotations = page?.annotations {
                for annotation in annotations {
                    page?.removeAnnotation(annotation)
                }
            }
        }
        if userTxtArr.count > 0 {
            
            for dynamicText in userTxtArr {
                
                if let txtview = dynamicText.txtvw {
                    if let view = txtview.superview as? UIView {
                        view.removeFromSuperview()
                    }
                }
                
            }
        }
        if userNoteArr.count > 0 {
            
            for dynamicText in userNoteArr {
                
                if let txtview = dynamicText.txtvw {
                    if let view = txtview.superview as? UIView {
                        view.removeFromSuperview()
                    }
                }
                
            }
        }
        
    }
    
    func calcPos(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, type: Int) -> CGPoint{
        
        //var pdf = CGPDFDocument(self.pdfURL as! CFURL)
        let pdfRef = pdfView.currentPage?.pageRef//pdf?.page(at: 1)
        let rect = pdfRef?.getBoxRect(.mediaBox)
        print("pdfrect: \(rect?.size.width), \(rect?.size.height)")
        
        let refW: CGFloat = (rect?.size.width)!//923
        let refH: CGFloat = (rect?.size.height)!//558
        
        let scrW: CGFloat = self.view.frame.size.width
        let scrH: CGFloat = self.view.frame.size.height
        
        print("scrW: \(scrW), scrH: \(scrH)")
        
        var newX = x //((scrW/refW) * x) + 40
        let yPos = ((scrH/refH) * y) //+ 50
        var newY = y //CGFloat(refH - yPos) - 10 //- 5//((scrH/refH) * y) //+ 100
       
        if scrW == 375 && scrH == 812 { // iPhone X
            if (Int(refW) >= Int(595.32) && Int(refW) <= Int(595.42)) && (Int(refH) >= Int(841.92) && Int(refH) <= Int(841.95)) {
                newX = x+10
                //newY = y+19
                /*
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 19
                }*/
                
                if type == 3 { // abc text
                    newX = x+6
                    newY = y + h + 5
                }
                else if type == 0 || type == 1 { // sign, initial
                    newX = x+8
                    newY = y + 23
                }
                else if type == 4 { // date
                    newX = x+8
                    newY = y + 28
                }
                else if type == 13 { // a checkbox
                    newX = x+7
                    newY = y + 24
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 27
                }
                else if type == 14 { // a text
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
            if (Int(refW) >= Int(612) && Int(refW) <= Int(613)) && (Int(refH) >= Int(792) && Int(refH) <= Int(793)) {
                newX = x+10
                //newY = y+17
                /*
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 17
                }*/
                
                if type == 3 {
                    newY = y + h + 4
                }
                else if type == 0 || type == 1 {
                    newX = x+8
                    newY = y + 24
                }
                else if type == 4 {
                    newY = y + 26
                }
                else if type == 13 {
                    newX = x+8
                    newY = y + 23
                }
                else if type == 14 {
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 29
                }
                else if type == 2 {
                    newX = x+9
                    newY = y + h + 10
                }
                else {
                    newY = y + 17
                }
            }
            if Int(refW) == Int(841.92) && Int(refH) == Int(1190.64) {
                newX = x+10
                //newY = y+25
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
        }
        else if scrW == 375 && scrH == 667 { // iPhone 6
            if (Int(refW) >= Int(595.32) && Int(refW) <= Int(595.42)) && (Int(refH) >= Int(841.92) && Int(refH) <= Int(841.95)) {
                newX = x+10
                
                if type == 3 { // abc text
                    newX = x+6
                    newY = y + h + 5
                }
                else if type == 0 || type == 1 { // sign, initial
                    newX = x+7
                    newY = y + 23
                }
                else if type == 4 { // date
                    newX = x+8
                    newY = y + 28
                }
                else if type == 13 { // a checkbox
                    newX = x+7
                    newY = y + 24
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 27
                }
                else if type == 14 { // a text
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
            if (Int(refW) >= Int(612) && Int(refW) <= Int(613)) && (Int(refH) >= Int(792) && Int(refH) <= Int(793)) {
                newX = x+10
                //newY = y+17
                /*
                 if type == 3 || type == 14 {
                 newY = y + h
                 }
                 else if type == 2 {
                 newY = y + h + 10
                 }
                 else {
                 newY = y + 17
                 }*/
                
                if type == 3 {
                    newY = y + h + 4
                }
                else if type == 0 || type == 1 {
                    newX = x+8
                    newY = y + 24
                }
                else if type == 4 {
                    newY = y + 26
                }
                else if type == 13 {
                    newX = x+8
                    newY = y + 23
                }
                else if type == 14 {
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 29
                }
                else if type == 2 {
                    newX = x+9
                    newY = y + h + 10
                }
                else {
                    newY = y + 17
                }
            }
            if Int(refW) == Int(841.92) && Int(refH) == Int(1190.64) {
                newX = x+10
                //newY = y+25
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
        }
        else if scrW == 414 && scrH == 736 { // iPhone 6s plus
            if (Int(refW) >= Int(595.32) && Int(refW) <= Int(595.42)) && (Int(refH) >= Int(841.92) && Int(refH) <= Int(841.95)) {
                newX = x+10
                //newY = y+19
                /*
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 19
                }*/
                
                if type == 3 { // abc text
                    newX = x+6
                    newY = y + h + 5
                }
                else if type == 0 || type == 1 { // sign, initial
                    newX = x+9
                    newY = y + 23
                }
                else if type == 4 { // date
                    newX = x+8
                    newY = y + 28
                }
                else if type == 13 { // a checkbox
                    newX = x+8
                    newY = y + 23
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 27
                }
                else if type == 14 { // a text
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
            if (Int(refW) >= Int(612) && Int(refW) <= Int(613)) && (Int(refH) >= Int(792) && Int(refH) <= Int(793)) {
                newX = x+10
                //newY = y+17
                if type == 3 {
                    newY = y + h + 4
                }
                else if type == 0 || type == 1 {
                    newX = x+8
                     newY = y + 24
                }
                else if type == 4 {
                    newY = y + 25
                }
                else if type == 13 {
                    newX = x+8
                    newY = y + 22
                }
                else if type == 14 {
                    newX = x+8
                    newY = y + h + 10
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 29
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 17
                }
            }
            if Int(refW) == Int(841.92) && Int(refH) == Int(1190.64) {
                newX = x+10
                //newY = y+25
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
        }
        else if scrW == 414 && scrH == 896 { // iPhone X max
            if (Int(refW) >= Int(595.32) && Int(refW) <= Int(595.42)) && (Int(refH) >= Int(841.92) && Int(refH) <= Int(841.95)) {
                newX = x+7
                //newY = y+19
                /*
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 19
                }*/
               
                
                if type == 3 { // abc text
                    newY = y + h + 5
                }
                else if type == 4 { // date
                    newY = y + 27
                }
                else if type == 13 { // a checkbox
                    newY = y + 23
                }
                else if type == 14 { // a text
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
            if (Int(refW) >= Int(612) && Int(refW) <= Int(613)) && (Int(refH) >= Int(792) && Int(refH) <= Int(793)) {
                newX = x+7
                //newY = y+17
                /*
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 17
                }*/
                
                if type == 3 { // abc text
                    newY = y + h + 5
                }
                else if type == 4 { // date
                    newY = y + 28
                }
                else if type == 13 { // checkbox
                    newY = y + 49
                }
                else if type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newX = x+8
                    newY = y + 25
                }
                else if type == 14 { // a text
                    newX = x+7
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                    newY = y + h + 10
                }
                else if type == 0 || type == 1 { // sign, initial, date
                    newY = y + 20
                }
                else {
                    newY = y + 37
                }
            }
            if Int(refW) == Int(841.92) && Int(refH) == Int(1190.64) {
                newX = x+10
                //newY = y+25
                if type == 3 || type == 14 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
        }
        else {
            if (Int(refW) >= Int(595.32) && Int(refW) <= Int(595.42)) && (Int(refH) >= Int(841.90) && Int(refH) <= Int(841.95)) { // A4
                newX = x+70
                
                if type == 14 {
                    newX = x+75
                }
                
                if type == 3 { // abc text
                    newY = y + h + 5
                }
                else if type == 4 { // date
                    newY = y + 27
                }
                else if type == 13 { // a checkbox
                    newY = y + 23
                }
                else if type == 14 { // a text
                    newY = y + h + 10
                }
                else if type == 2 { // seal
                     newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
                
            }
            if Int(refW) == Int(612) && Int(refH) == Int(792) { // letter
                newX = x+70
                
                if type == 13 { //checkbox
                    newX = x+60
                }
                else if type == 14 {
                    newX = x+65
                }
                else if type == 13 || type == 16 || type == 17 || type == 18 || type == 19 || type == 20 { //new tags name, email, phone, company, title
                    newX = x+65
                }
                else if type == 2 { //seal
                    newX = x+60
                }
                
                
                
                //newY = y+37
                if type == 3 { // abc text
                    newY = y + h + 20
                }
                else if type == 4 { // date
                    newY = y + 45
                }
                else if type == 13 { // checkbox
                    newY = y + 40
                }
                else if type == 13 || type == 16 || type == 17 || type == 18 || type == 19 || type == 20  { //  new tags name, email, phone, company, title
                    newY = y + 45
                }
                else if type == 14 { // a text
                    newY = y + h + 27
                }
                else if type == 2 { // seal
                    newY = y + h + 25
                }
                else {
                    newY = y + 37
                }
            }
            if Int(refW) == Int(841.92) && Int(refH) == Int(1190.64) {
                newX = x+10
                //newY = y+25
                if type == 3 {
                    newY = y + h
                }
                else if type == 2 {
                    newY = y + h + 10
                }
                else {
                    newY = y + 25
                }
            }
        }
        
        var point = CGPoint(x: newX, y: newY)
        
        point = pdfView.convert(point, to: pdfView.currentPage!)
        return point//CGPoint(x: x, y: y+35)
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(chkTagAction), name: .PDFViewAnnotationHit, object: PDFAnnotation.self)
    }
    
    @objc func chkTagAction(notif: NSNotification) {
        print("notif: \(notif.object)")
    }
    
    @objc func signAction(_ sender: Any) {
        
        let button = (sender as! UIButton)
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == button.tag) }
        
        //let pos = button.center
        if tagdataArr[0].type == 0 {
            
            if let strsign = UserDefaults.standard.string(forKey: "UserSign") {
                let sign = strsign.base64ToImage()
                let imgvw: UIImageView = UIImageView(frame: button.frame)
                (sender as! UIButton).setTitle("", for: UIControl.State.normal)
                imgvw.image = sign
                self.view.addSubview(imgvw)
                //imgvw.center = pos
                signFlag = true
                tagdataArr[0].signed = true
                let signId = UserDefaults.standard.value(forKey: "UserSignId")
                
                tagdataArr[0].ExtraMetaData = ["TickX":button.center.x,"TickY":button.center.y,"TickW":button.frame.size.width,"TickH":button.frame.size.height,"SignatureId":signId]
                tagdataArr[0].State = 4
                tagdataArr[0].signImg = imgvw
            }
        }
        
    }
    
    @objc func signAction(tag: Int) {
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        if tagdataArr[0].type == 0 {
            
            showSignAlert(tag:tag)
        }
        if tagdataArr[0].type == 1 {
            showInitAlert(tag:tag)
        }
        
    }
    
    func showSignAlert(tag: Int) {
        
        let strsign: String = UserDefaults.standard.string(forKey: "UserSign") ?? ""
        let strsign1: String = UserDefaults.standard.string(forKey: "UserSign1") ?? ""
        let strsign2: String = UserDefaults.standard.string(forKey: "UserSign2") ?? ""
        
        if !strsign.isEmpty || !strsign1.isEmpty || !strsign2.isEmpty {
            
            signAlertView = SwiftAlertView(nibName: "SignAlert", delegate: self, cancelButtonTitle: "Close", otherButtonTitles: nil)
            //"Apply Changes"
            signAlertView.tag = 44
            
            
            let btnclose = signAlertView.buttonAtIndex(index: 0)
            
            btnclose?.backgroundColor = UIColor.white
            btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
            
            
            let img1 = signAlertView.viewWithTag(1) as! UIImageView
            let img2 = signAlertView.viewWithTag(2) as! UIImageView
            let img3 = signAlertView.viewWithTag(3) as! UIImageView
            
            img1.accessibilityHint = String(tag)
            img2.accessibilityHint = String(tag)
            img3.accessibilityHint = String(tag)
            
            let gest1 = UITapGestureRecognizer(target: self, action:  #selector(self.selectSign))
            img1.addGestureRecognizer(gest1)
            
            let gest2 = UITapGestureRecognizer(target: self, action:  #selector(self.selectSign))
            img2.addGestureRecognizer(gest2)
            
            let gest3 = UITapGestureRecognizer(target: self, action:  #selector(self.selectSign))
            img3.addGestureRecognizer(gest3)
            
            var err = 0
            if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty {
                
                let sign = strsign.base64ToImage()
                img1.image = sign
            } else {
                err = err + 1
            }
            if let strsign1 = UserDefaults.standard.string(forKey: "UserSign1"), !strsign1.isEmpty {
                
                let sign = strsign1.base64ToImage()
                img2.image = sign
            } else {
                err = err + 1
            }
            if let strsign2 = UserDefaults.standard.string(forKey: "UserSign2"), !strsign2.isEmpty {
                
                let sign = strsign2.base64ToImage()
                img3.image = sign
            } else {
                err = err + 1
            }
            if err < 2 {
                signAlertView.show()
            } else {
                let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
                let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
                let tagplaceholder = tagdataArr[0].TagPlaceHolder
                let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
                
                let button: UIButton = tagdataArr[0].view as! UIButton
                var sign: UIImage = UIImage()//strsign.base64ToImage()
                
                if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty
                {
                    sign = strsign.base64ToImage()
                }
                
                let imgvw: UIImageView = UIImageView(frame: button.frame)
                //(sender as! UIButton).setTitle("", for: UIControlState.normal)
                imgvw.image = sign
                let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
                self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
                let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
                imgAnnot.border?.lineWidth = 1
                self.pdfView.currentPage?.addAnnotation(imgAnnot)
                
                signFlag = true
                
                tagdataArr[0].signed = true
                let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
                
                tagdataArr[0].ExtraMetaData = ["TickX":(tagplaceholder?.XCoordinate)!+30,"TickY":(tagplaceholder?.YCoordinate)!+15 ,"TickW":53.332,"TickH":4.800,"SignatureId":signId]
                tagdataArr[0].State = 4
                tagdataArr[0].signImg = imgvw
                
            }
        } else {
            alertSample(strTitle: "", strMsg: "Signature not found")
        }
    }
    
    func showInitAlert(tag: Int) {
        
        if let strsign = UserDefaults.standard.string(forKey: "UserInitial"), !strsign.isEmpty {
            
            signAlertView = SwiftAlertView(nibName: "SignAlert", delegate: self, cancelButtonTitle: "Close", otherButtonTitles: nil)
            //"Apply Changes"
            signAlertView.tag = 44
            
            let btnclose = signAlertView.buttonAtIndex(index: 0)
            
            btnclose?.backgroundColor = UIColor.white
            btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
            
            let img1 = signAlertView.viewWithTag(1) as! UIImageView
            let img2 = signAlertView.viewWithTag(2) as! UIImageView
            let img3 = signAlertView.viewWithTag(3) as! UIImageView
            
            img1.accessibilityHint = String(tag)
            img2.accessibilityHint = String(tag)
            img3.accessibilityHint = String(tag)
            
            let gest1 = UITapGestureRecognizer(target: self, action:  #selector(self.selectInitial))
            img1.addGestureRecognizer(gest1)
            
            let gest2 = UITapGestureRecognizer(target: self, action:  #selector(self.selectInitial))
            img2.addGestureRecognizer(gest2)
            
            let gest3 = UITapGestureRecognizer(target: self, action:  #selector(self.selectInitial))
            img3.addGestureRecognizer(gest3)
            
            var err = 0
            
            if let strsign = UserDefaults.standard.string(forKey: "UserInitial"), !strsign.isEmpty {
                
                let sign = strsign.base64ToImage()
                img1.image = sign
            } else {
                err = err + 1
            }
            if let strsign1 = UserDefaults.standard.string(forKey: "UserInitial1"), !strsign1.isEmpty {
                
                let sign = strsign1.base64ToImage()
                img2.image = sign
            } else {
                err = err + 1
            }
            if let strsign2 = UserDefaults.standard.string(forKey: "UserInitial2"), !strsign2.isEmpty {
                
                let sign = strsign2.base64ToImage()
                img3.image = sign
            } else {
                err = err + 1
            }
            if err < 2 {
                signAlertView.show()
            } else {
                
                let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
                let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
                
                let tagplaceholder = tagdataArr[0].TagPlaceHolder
                let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
                
                let button: UIButton = tagdataArr[0].view as! UIButton
                var sign: UIImage = UIImage()//strsign.base64ToImage()
                
                if let strsign = UserDefaults.standard.string(forKey: "UserInitial"), !strsign.isEmpty
                {
                    sign = strsign.base64ToImage()
                }
                
                let imgvw: UIImageView = UIImageView(frame: button.frame)
                //(sender as! UIButton).setTitle("", for: UIControlState.normal)
                imgvw.image = sign
                let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
                self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
                let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
                imgAnnot.border?.lineWidth = 1
                self.pdfView.currentPage?.addAnnotation(imgAnnot)
                
                signFlag = true
                
                tagdataArr[0].signed = true
                let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
                
                tagdataArr[0].ExtraMetaData = ["SignatureId":signId]
                tagdataArr[0].State = 4
                tagdataArr[0].signImg = imgvw
            }
        } else {
            alertSample(strTitle: "", strMsg: "Signature not found")
        }
    }
    
    @objc func selectSign(sender : UITapGestureRecognizer)
    {
        
        let img1 = signAlertView.viewWithTag(1) as! UIImageView
        let img2 = signAlertView.viewWithTag(2) as! UIImageView
        let img3 = signAlertView.viewWithTag(3) as! UIImageView
        
        img1.layer.borderColor = UIColor.clear.cgColor
        img2.layer.borderColor = UIColor.clear.cgColor
        img3.layer.borderColor = UIColor.clear.cgColor
        
        let img = sender.view as! UIImageView
        
        img.layer.borderWidth = 1.0
        img.layer.borderColor = UIColor.gray.cgColor
        
        let tag = Int(img.accessibilityHint!)
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        if tagdataArr[0].type == 0 {
            //if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty {
                //if pageTagsDic.count >= currPageNumber {
                let tagplaceholder = tagdataArr[0].TagPlaceHolder
            let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
                
                let button: UIButton = tagdataArr[0].view as! UIButton
                var sign: UIImage = UIImage()//strsign.base64ToImage()
            
                if  img.tag == 1 {
                    if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty
                    {
                        sign = strsign.base64ToImage()
                    }
                }
                if  img.tag == 2 {
                    if let strsign = UserDefaults.standard.string(forKey: "UserSign1"), !strsign.isEmpty
                    {
                        sign = strsign.base64ToImage()
                    }
                }
                if  img.tag == 3 {
                    if let strsign = UserDefaults.standard.string(forKey: "UserSign2"), !strsign.isEmpty
                    {
                        sign = strsign.base64ToImage()
                    }
                }
                let imgvw: UIImageView = UIImageView(frame: button.frame)
                //(sender as! UIButton).setTitle("", for: UIControlState.normal)
                imgvw.image = sign
                let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
                self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
                let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
                imgAnnot.border?.lineWidth = 1
                self.pdfView.currentPage?.addAnnotation(imgAnnot)
                
                signFlag = true
                
                tagdataArr[0].signed = true
                let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
                
                tagdataArr[0].ExtraMetaData = ["TickX":(tagplaceholder?.XCoordinate)!+30,"TickY":(tagplaceholder?.YCoordinate)!+15 ,"TickW":53.332,"TickH":4.800,"SignatureId":signId]
                tagdataArr[0].State = 4
                tagdataArr[0].signImg = imgvw
                //}
            /*} else {
                alertSample(strTitle: "", strMsg: "Signature not found")
            }*/
        }
    }
    
    func autoFillSign(tag: Int)
    {
        var sign: UIImage = UIImage()
        
        if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty
        {
            sign = strsign.base64ToImage()
        }
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        if tagdataArr[0].type == 0 {
            //if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty {
            //if pageTagsDic.count >= currPageNumber {
            let tagplaceholder = tagdataArr[0].TagPlaceHolder
            let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
            
            let button: UIButton = tagdataArr[0].view as! UIButton
           
            let imgvw: UIImageView = UIImageView(frame: button.frame)
            //(sender as! UIButton).setTitle("", for: UIControlState.normal)
            imgvw.image = sign
            
            let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
            imgAnnot.border?.lineWidth = 1
            self.pdfView.currentPage?.addAnnotation(imgAnnot)
            
            signFlag = true
            
            tagdataArr[0].signed = true
            let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
            
            tagdataArr[0].ExtraMetaData = ["TickX":(tagplaceholder?.XCoordinate)!+30,"TickY":(tagplaceholder?.YCoordinate)!+15 ,"TickW":53.332,"TickH":4.800,"SignatureId":signId]
            tagdataArr[0].State = 4
            tagdataArr[0].signImg = imgvw
            //}
            /*} else {
             alertSample(strTitle: "", strMsg: "Signature not found")
             }*/
        }
        
        var initial: UIImage = UIImage()
        
        if let strsign = UserDefaults.standard.string(forKey: "UserInitial"), !strsign.isEmpty
        {
            initial = strsign.base64ToImage()
        }
        
        if tagdataArr[0].type == 1 {
            //if let strsign = UserDefaults.standard.string(forKey: "UserSign"), !strsign.isEmpty {
            //if pageTagsDic.count >= currPageNumber {
            let tagplaceholder = tagdataArr[0].TagPlaceHolder
            let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
            
            let button: UIButton = tagdataArr[0].view as! UIButton
            
            let imgvw: UIImageView = UIImageView(frame: button.frame)
            //(sender as! UIButton).setTitle("", for: UIControlState.normal)
            imgvw.image = initial
            
            let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
            imgAnnot.border?.lineWidth = 1
            self.pdfView.currentPage?.addAnnotation(imgAnnot)
            
            signFlag = true
            
            tagdataArr[0].signed = true
            let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
            
            tagdataArr[0].ExtraMetaData = ["TickX":(tagplaceholder?.XCoordinate)!+30,"TickY":(tagplaceholder?.YCoordinate)!+15 ,"TickW":53.332,"TickH":4.800,"SignatureId":signId]
            tagdataArr[0].State = 4
            tagdataArr[0].signImg = imgvw
            //}
            /*} else {
             alertSample(strTitle: "", strMsg: "Signature not found")
             }*/
        }
        if tagdataArr[0].type == 4 {
            let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
            let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
            
            
            //if pageTagsDic.count >= currPageNumber {
            let button: UIButton = tagdataArr[0].view as! UIButton
            var btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            var strdf: String = ""
            if let dateformat = tagdataArr[0].ExtraMetaData!["DateFormat"] {
                strdf = dateformat as! String
                strdf = "\(strdf) "
            }
            if let IsWithTime = tagdataArr[0].ExtraMetaData!["IsWithTime"] as? Bool, IsWithTime == true {
                if let timeformat = tagdataArr[0].ExtraMetaData!["TimeFormat"] {
                    strdf = "\(strdf) \(timeformat as! String)"
                }
            }
            
            let strdate = dateToString(date: Date(), dtFormat: strdf as String, strFormat: strdf as String)
            
            btnAnnot = PDFAnnotation(bounds: button.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
            btnAnnot?.widgetFieldType = .button
            btnAnnot?.widgetControlType = .pushButtonControl
            btnAnnot?.backgroundColor = UIColor.white
            btnAnnot?.border?.lineWidth = 1
            btnAnnot?.border?.style = .solid
            let strurl = "\(tagdataArr[0].TagId)"
            btnAnnot?.action = PDFActionURL(url: URL(string: strurl)!)
            
            btnAnnot?.caption = strdate
            // signFlag = true
            btnAnnot?.buttonWidgetStateString = strdate
            
            self.pdfView.currentPage?.addAnnotation(btnAnnot!)
            tagdataArr[0].TagText = strdate
            tagdataArr[0].State = 4
        }
    }
    
    @objc func selectInitial(sender : UITapGestureRecognizer)
    {
        let img1 = signAlertView.viewWithTag(1) as! UIImageView
        let img2 = signAlertView.viewWithTag(2) as! UIImageView
        let img3 = signAlertView.viewWithTag(3) as! UIImageView
        
        img1.layer.borderColor = UIColor.clear.cgColor
        img2.layer.borderColor = UIColor.clear.cgColor
        img3.layer.borderColor = UIColor.clear.cgColor
        
        
        let img = sender.view as! UIImageView
        
        img.layer.borderWidth = 1.0
        img.layer.borderColor = UIColor.gray.cgColor
        
        
        let tag = Int(img.accessibilityHint!)
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        let tagplaceholder = tagdataArr[0].TagPlaceHolder
        let point = calcPos(x: (tagplaceholder?.XCoordinate)! + 19, y: (tagplaceholder?.YCoordinate)! + 23, w: 53.332, h: 4.800, type: tagdataArr[0].type!)
        
        let button: UIButton = tagdataArr[0].view as! UIButton
        var sign: UIImage = UIImage()//strsign.base64ToImage()
        
        if  img.tag == 1 {
            if let strsign = UserDefaults.standard.string(forKey: "UserInitial"), !strsign.isEmpty
            {
                sign = strsign.base64ToImage()
            }
        }
        if  img.tag == 2 {
            if let strsign = UserDefaults.standard.string(forKey: "UserInitial1"), !strsign.isEmpty
            {
                sign = strsign.base64ToImage()
            }
        }
        if  img.tag == 3 {
            if let strsign = UserDefaults.standard.string(forKey: "UserInitial2"), !strsign.isEmpty
            {
                sign = strsign.base64ToImage()
            }
        }
        let imgvw: UIImageView = UIImageView(frame: button.frame)
        //(sender as! UIButton).setTitle("", for: UIControlState.normal)
        imgvw.image = sign
        let btnAnnot = pdfView.currentPage?.annotation(at: button.center)
        self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
        let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: sign)
        imgAnnot.border?.lineWidth = 1
        self.pdfView.currentPage?.addAnnotation(imgAnnot)
        
        signFlag = true
        
        tagdataArr[0].signed = true
        let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
        
        tagdataArr[0].ExtraMetaData = ["SignatureId":signId]
        tagdataArr[0].State = 4
        tagdataArr[0].signImg = imgvw
    }
    
    func autoFill() {
        
        for processData in processDataArr {
            if processData.selected {
                for step in processData.Steps! {
                    for tag in step.Tags! {
                        if tag.type == 0 {
                            
                            let tagplaceholder = tag.TagPlaceHolder
                            let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
                            
                            tag.ExtraMetaData = ["TickX":(tagplaceholder?.XCoordinate)!+30,"TickY":(tagplaceholder?.YCoordinate)!+15 ,"TickW":53.332,"TickH":4.800,"SignatureId":signId]
                            tag.State = 4
                        }
                        if tag.type == 1 {
                            let signId: Int = UserDefaults.standard.value(forKey: "UserSignId") as! Int
                            
                            tag.ExtraMetaData = ["SignatureId":signId]
                            tag.State = 4
                        }
                        if tag.type == 4 {
                            var strdf: String = ""
                            if let dateformat = tag.ExtraMetaData!["DateFormat"] {
                                strdf = dateformat as! String
                                strdf = "\(strdf)"
                            }
                            if let IsWithTime = tag.ExtraMetaData!["IsWithTime"] as? Bool, IsWithTime == true {
                                if let timeformat = tag.ExtraMetaData!["TimeFormat"] {
                                    strdf = "\(strdf) \(timeformat as! String)"
                                }
                            }
                            
                            let strdate = dateToString(date: Date(), dtFormat: strdf as String, strFormat: strdf as String)
                            tag.TagText = strdate
                            tag.State = 4
                        }
                    }
                }
            }
        }
    }
    
    @objc func sealAction(tag: Int) {
        
        let adminflag = UserDefaults.standard.bool(forKey: "AdminFlag")
        
        //if adminflag {
            
            self.getStamp(tag: tag)
            
        /*} else {
            self.alertSample(strTitle: "Action not allowed", strMsg: "Please upgrade your subscription plan to Professional or Business to apply seal")
        }*/
    }
    
    func setSealImg(img: UIImage, tag: Int) {
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        
        //if pageTagsDic.count >= currPageNumber {
            let button: UIButton = tagdataArr[0].view as! UIButton
            var btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            let imgAnnot = ImageAnnotation.init(imageBounds: button.frame, image: img)
            imgAnnot.border?.lineWidth = 1
        
            tagdataArr[0].State = 4
            self.pdfView.currentPage?.addAnnotation(imgAnnot)
            
        //}
        
        
    }
    
    @objc func dateAction(tag: Int) {
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
        
        //if pageTagsDic.count >= currPageNumber {
            let button: UIButton = tagdataArr[0].view as! UIButton
            var btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            var strdf: String = ""
            if let dateformat = tagdataArr[0].ExtraMetaData!["DateFormat"] {
                strdf = dateformat as! String
                strdf = "\(strdf) "
            } else {
               strdf = "MM/dd/yyyy"
            }
            if let IsWithTime = tagdataArr[0].ExtraMetaData!["IsWithTime"] as? Bool, IsWithTime == true {
                if let timeformat = tagdataArr[0].ExtraMetaData!["TimeFormat"] {
                    strdf = "\(strdf) \(timeformat as! String)"
                }
            }
            
            let strdate = dateToString(date: Date(), dtFormat: strdf as String, strFormat: strdf as String)
            
            btnAnnot = PDFAnnotation(bounds: button.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
            btnAnnot?.widgetFieldType = .button
            btnAnnot?.widgetControlType = .pushButtonControl
            btnAnnot?.backgroundColor = UIColor.white
            btnAnnot?.border?.lineWidth = 1
            btnAnnot?.border?.style = .solid
            let strurl = "\(tagdataArr[0].TagId)"
            btnAnnot?.action = PDFActionURL(url: URL(string: strurl)!)
            
            btnAnnot?.caption = strdate
           // signFlag = true
            btnAnnot?.buttonWidgetStateString = strdate
            btnAnnot?.font = UIFont.systemFont(ofSize: 10)
        
            self.pdfView.currentPage?.addAnnotation(btnAnnot!)
            tagdataArr[0].TagText = strdate
            tagdataArr[0].State = 4
            
        //}
    }
    
    @objc func profileAction(tag: Int) {
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        let tagdata = tagdataArr[0]
        
        //if pageTagsDic.count >= currPageNumber {
        
        
        var content: String = ""
        var err: Bool = false
        
        if tagdata.type == 16 {
            let fname: String = UserDefaults.standard.string(forKey: "FName")!
            let mname: String = UserDefaults.standard.string(forKey: "MName")!
            let lname: String = UserDefaults.standard.string(forKey: "LName")!
            let uname = fname + " " + mname + " " + lname
            
            content = uname
        }
        else if tagdata.type == 17 {
            
            let email: String = UserDefaults.standard.string(forKey: "Email")!
            content = email
        }
        else if tagdata.type == 18 {
            
            let company: String = UserDefaults.standard.string(forKey: "Company")!
            content = company
            
            if subscriptionPlan == 1 {
                self.alertSample(strTitle: "Information!", strMsg: "Please upgrade your account to business to enter company name.")
                return
            }
            
        }
        else if tagdata.type == 19 {
            
            let jobTitle: String = UserDefaults.standard.string(forKey: "JobTitle")!
            content = jobTitle
            
            if jobTitle.isEmpty {
                err = true
                gotoUserProfile(msg: "Please add JobTitle in your profile")
                return
            }
            
        }
        else if tagdata.type == 20 {
            
            let phone: String = UserDefaults.standard.string(forKey: "Phone")!
            content = phone
            
            if phone.isEmpty {
                err = true
                gotoUserProfile(msg: "Please add Phone in your profile")
                return
            }
            
        }
        
        if !err {
            
            let button: UIButton = tagdata.view as! UIButton
            var btnAnnot = pdfView.currentPage?.annotation(at: button.center)
            self.pdfView.currentPage?.removeAnnotation(btnAnnot!)
            
            
            btnAnnot = PDFAnnotation(bounds: button.frame, forType: PDFAnnotationSubtype.widget, withProperties: nil)
            btnAnnot?.widgetFieldType = .button
            btnAnnot?.widgetControlType = .pushButtonControl
            btnAnnot?.backgroundColor = UIColor.white
            btnAnnot?.border?.lineWidth = 1
            btnAnnot?.border?.style = .solid
            let strurl = "\(tagdata.TagId)"
            btnAnnot?.action = PDFActionURL(url: URL(string: strurl)!)
            
            btnAnnot?.font = UIFont.systemFont(ofSize: 10)
            btnAnnot?.caption = content
            // signFlag = true
            btnAnnot?.buttonWidgetStateString = content
            
            self.pdfView.currentPage?.addAnnotation(btnAnnot!)
            tagdataArr[0].TagText = content
            tagdataArr[0].State = 4
        }
        //}
    }
    
    func gotoUserProfile(msg: String){
    
        let alert = UIAlertController(title: "Information!", message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            
            let userVC = self.getVC(sbId: "userprofile_SBID") as! UserProfileViewController
            userVC.docSignFlag = true
            
            self.navigationController?.pushViewController(userVC, animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotoSeal() {
        
        let alert = UIAlertController(title: "Information!", message: "Please upload seal", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            action in
            
            let sealVC = self.getVC(sbId: "Seal_SBID") as! SealVC
            sealVC.docSignFlag = true
            
            self.navigationController?.pushViewController(sealVC, animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func checkAction(tag: Int) {
        
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        
    }
    
    @objc func pageChangedNotification(notification: Notification) {
        
        
        if scrollFlag == "top" {
            if currPageNumber > 0 {
                currPageNumber = currPageNumber - 1
            }
        } else if scrollFlag == "bottom" {
            currPageNumber = currPageNumber + 1
        }
        print("pageChanged: \(currPageNumber)")
        currPageNumber = (pdfView.currentPage?.pageRef?.pageNumber)!
        addPageTags()
    }
   
    func getStamp(tag: Int) {
        
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "Organization/GetStamp"
        
        let apiURL = Singletone.shareInstance.apiURL + api
        
        if Connectivity.isConnectedToInternet() == true
        {
            self.showActivityIndicatory(uiView: self.view)
            
            Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    
                    let jsonObj: JSON = JSON(response.result.value!)
                    
                    //print(jsonObj)
                    if jsonObj["StatusCode"] == 1000
                    {
                        DispatchQueue.main.async {
                            
                            let StampImage = jsonObj["Data"]["StampImage"].stringValue
                            if !StampImage.isEmpty {
                                let strImgArr = StampImage.split(separator: ",")
                                if strImgArr.count > 1 {
                                    let strStampImage = String(strImgArr[1])
                                    
                                    let decodedimage = strStampImage.base64ToImage()
                                    let sealImage = decodedimage
                                    self.setSealImg(img: sealImage, tag: tag)
                                    self.stopActivityIndicator()
                                }
                            } else {
                                DispatchQueue.main.async {
                                    self.stopActivityIndicator()
                                    //self.alertSample(strTitle: "", strMsg: "Seal not found")
                                    self.gotoSeal()
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.alertSample(strTitle: "", strMsg: "Error fetching seal")
                            self.stopActivityIndicator()
                        }
                    }
                    
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    
    func validateMutiSign() {
        
        var err = false
        
        let chkForActionReq = processDataArr.filter{ ($0.processType == "Action Required" && $0.selected == true) }
        
        if !chkForActionReq.isEmpty && chkForActionReq.count > 0 {
            
            let processData = chkForActionReq[actionReqCnt]
            
            //for processData in processDataArr {
                
                //if processData.selected {
                    
                    for step in processData.Steps! {
                        for tag in step.Tags! {
                            //if tag.type != 0 && tag.type != 1 && tag.type != 4 && tag.type == 9 {
                                
                                if tag.type == 3 || tag.type == 14 {
                                    let btnAnnot = tag.pdfAnnotation
                                    tag.TagText = btnAnnot?.widgetStringValue ?? ""
                                    if tag.TagText.isEmpty {
                                        err = true
                                    }
                                }
                                else if tag.type == 13 {
                                    //if (tag.ExtraMetaData?.isEmpty)! {
                                    let btnAnnot = tag.pdfAnnotation
                                    let state = btnAnnot?.buttonWidgetState
                                    if state != PDFWidgetCellState.onState
                                    {
                                        err = true
                                    }
                                }
                            //}
                        }
                    }
                //}
            //}
        }
        
        if !err {
            //saveAllProcessAPI()
            if actionReqCnt < chkForActionReq.count-1 {
                actionReqCnt = actionReqCnt + 1
                
                let processData = chkForActionReq[actionReqCnt]
                let doclist = processData.Documents![0]
                self.docObjId = doclist.ObjectId
                
                self.instanceID = "\(processData.ProcessId!)"
                self.processData = processData
                
                //self.getDocSize(objectId: self.docObjId!)
                self.getDocAPI(objID: self.docObjId!, processID: self.instanceID!)
            } else {
                //saveAllProcessAPI()
                showApproveAlert()
            }
        }
    }
    
    func saveAllProcessAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "v1/process/SaveAllProcess"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)", "Content-Type":"application/json"]
        
        let ProcessSaveDetailsDto: NSMutableArray = NSMutableArray.init()
        
        let chkForAutoFill = processDataArr.filter{ ($0.processType == "Auto Fill") }
        if !chkForAutoFill.isEmpty && chkForAutoFill.count > 0 {
            autoFill()
        }
        var errflag = false
        for processData in processDataArr {
            
            if processData.selected {
                
                var TagDetails:[[String: Any]] = []
                
                for step in processData.Steps! {
                    for tag in step.Tags! {
                        
                        if tag.type == 0 || tag.type == 1 {
                            tag.State = 4
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                        }
                        if tag.type == 2 {
                            
                            let tagtext = tag.TagText ?? ""
                            tag.State = 4
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                        }
                        if tag.type == 3 {
                            //let button = tag.view as? UIButton
                            //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                            //let btnAnnot = tag.pdfAnnotation
                            //tag.TagText = (btnAnnot?.widgetStringValue)!
                            let btnAnnot = tag.pdfAnnotation
                            tag.TagText = (btnAnnot?.widgetStringValue)!
                            let tagtext = tag.TagText
                            tag.State = 4
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                        }
                        if tag.type == 4 {
                            tag.State = 4
                            let tagtext = tag.TagText ?? ""
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                        }
                        if tag.type == 8 {
                            //let button = tag.view as? UITextField
                            //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                            let btnAnnot = tag.pdfAnnotation
                            tag.TagText = (btnAnnot?.widgetStringValue)!
                            let tagtext = tag.TagText
                            tag.State = 4
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                        }
                        if tag.type == 13 {
                            //let button = tag.view as? UIButton
                            //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                            let btnAnnot = tag.pdfAnnotation
                            let state = btnAnnot?.buttonWidgetState
                            if state == PDFWidgetCellState.onState {
                                print("state: On")
                                let tagplaceholder = tag.TagPlaceHolder
                                tag.ExtraMetaData = ["CheckState": "Checked",
                                                     "TextH": tagplaceholder?.Height,
                                                     "TextW": tagplaceholder?.Width,
                                                     "TextX": tagplaceholder?.XCoordinate,
                                                     "TextY": tagplaceholder?.YCoordinate]
                                tag.State = 4
                               let tagtext = tag.TagText
                                TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                                
                            } else {
                                print("Off")
                                //errflag = true
                            }
                        }
                        if tag.type == 16 || tag.type == 17 || tag.type == 18 || tag.type == 19 || tag.type == 20  {
                            
                            tag.State = 4
                            TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                        }
                    }
                    
                }
                
                
                let defID = processData.DefinitionId
                let processId = processData.ProcessId
                let dynamicTagDetails = processData.DynamicTagDetails
                let dynamicTextDetails = processData.DynamicTextDetails
                
                var dynamicTagArr:[[String:Any]]  = []
                var dynamicTextArr:[[String:Any]]  = []
                
                for data in dynamicTagDetails {
                    dynamicTagArr.append(data.toDictionary())
                }
                for data in dynamicTextDetails {
                    dynamicTextArr.append(data.toDictionary())
                }
                
                if userTxtArr.count > 0 {
                    var cnt = dynamicTextArr.count
                    for data in userTxtArr {
                        let tagvalue = data.TagValue
                        tagvalue?.TagNo = cnt
                        dynamicTextArr.append(data.toDictionary())
                        cnt = cnt + 1
                    }
                }
                
                let processDic = ["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr] as [String : Any]
                ProcessSaveDetailsDto.add(processDic)
            }
        }
        
        
       // let ProcessSaveDetailsDto = [["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr]] as [[String : Any]]
        
        if !errflag {
            
            let pass = UserDefaults.standard.string(forKey: "Pass")
            let parameters = [  "Password": pass!,
                                "ProcessSaveDetailsDto": ProcessSaveDetailsDto
                ] as [String : Any]
            print("############")
            print("parameters: \(parameters)")
            print("############")
            
            if let theJSONData = try? JSONSerialization.data(
                withJSONObject: parameters,
                options: []) {
                let theJSONText = String(data: theJSONData,
                                         encoding: .ascii)
                print("JSON string = \(theJSONText!)")
            }
            
            if Connectivity.isConnectedToInternet() == true
            {
                
                do {
                    let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                    
                    let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                                      cachePolicy: .useProtocolCachePolicy,
                                                      timeoutInterval: 10.0)
                    request.httpMethod = "PUT"
                    request.allHTTPHeaderFields = headerAPIDashboard
                    request.httpBody = postData as Data
                    
                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                        
                        DispatchQueue.main.async {
                            self.stopActivityIndicator()
                        }
                        if (error != nil) {
                            print(error)
                        } else {
                            let httpResponse = response as? HTTPURLResponse
                            print(httpResponse)
                            
                            
                            var json: JSON = JSON(data!)
                            if let jsonDic = json.dictionaryObject as? [String:Any] {
                                debugPrint(jsonDic)
                                let statusCode = jsonDic["StatusCode"] as! Int
                                //let jsonData = jsonDic["Data"] as! NSDictionary
                                if statusCode == 1000 {
                                    self.savedFlag = true
                                    DispatchQueue.main.async {
                                        let msg = jsonDic["Message"] as! String
                                        self.alertSample(strTitle: "", strMsg: msg)
                                    }
                                    self.con_btmView.constant = 0
                                    self.btmView.isHidden = true
                                    //self.removePageTags()
                                    self.getProcessDetailsAPI()
                                }
                                
                                if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                                    print(jsonObj)
                                    
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async {
                                    self.alertSample(strTitle: "", strMsg: "Error from server")
                                }
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
        }
    }
    
    func saveProcessAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "v1/process/SaveAllProcess"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)", "Content-Type":"application/json"]
        
        let step = self.processData.Steps![0]
        let tag = step.Tags![0]
        var dic = tag.toDictionary()
        /*
        if signFlag {
            let signId = UserDefaults.standard.value(forKey: "UserSignId")
            dic["ExtraMetaData"] = ["TickX":286.66266666666667,"TickY":95.87256666666667,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":signId]
            dic["State"] = 4
        }*/
        var TagDetails:[[String: Any]] = []//[["TagValue":dic,"TagText":"","Comment":""]]
        
        for step in self.processData.Steps! {
            for tag in step.Tags! {
                
               if tag.type == 0 || tag.type == 1 {
                tag.State = 4
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                }
                if tag.type == 2 {
                    //let button = tag.view as? UIButton
                    //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                    
                    let btnAnnot = tag.pdfAnnotation
                    tag.TagText = (btnAnnot?.widgetStringValue)!
                    let tagtext = tag.TagText
                    tag.State = 4
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                }
                if tag.type == 3 {
                    //let button = tag.view as? UIButton
                    //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                    //let btnAnnot = tag.pdfAnnotation
                    //tag.TagText = btnAnnot?.widgetStringValue ?? ""
                    let btnAnnot = tag.pdfAnnotation
                    tag.TagText = (btnAnnot?.widgetStringValue)!
                    let tagtext = tag.TagText
                    tag.State = 4
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                }
                if tag.type == 4 {
                    tag.State = 4
                    let tagtext = tag.TagText
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                }
                if tag.type == 8 {
                    //let button = tag.view as? UITextField
                    //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                    let btnAnnot = tag.pdfAnnotation
                    tag.TagText = (btnAnnot?.widgetStringValue)!
                    let tagtext = tag.TagText
                    tag.State = 4
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                }
                if tag.type == 13 {
                    //let button = tag.view as? UIButton
                    //let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                    let btnAnnot = tag.pdfAnnotation
                    let state = btnAnnot?.buttonWidgetState
                    if state == PDFWidgetCellState.onState {
                        print("state: On")
                        let tagplaceholder = tag.TagPlaceHolder
                        tag.ExtraMetaData = ["CheckState": "Checked",
                                             "TextH": tagplaceholder?.Height,
                                                       "TextW": tagplaceholder?.Width,
                                                       "TextX": tagplaceholder?.XCoordinate,
                                                       "TextY": tagplaceholder?.YCoordinate]
                        tag.State = 4
                        //let btnAnnot = tag.pdfAnnotation
                        //tag.TagText = btnAnnot?.widgetStringValue ?? ""
                        let tagtext = tag.TagText
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":""])
                        
                    } else {
                        print("Off")
                    }
                }
                if tag.type == 16 || tag.type == 17 || tag.type == 18 || tag.type == 19 || tag.type == 20  {
                    
                    tag.State = 4
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                }
            }
        }
        
        
        let defID = self.processData.DefinitionId
        let processId = self.processData.ProcessId
        let dynamicTagDetails = self.processData.DynamicTagDetails
        let dynamicTextDetails = self.processData.DynamicTextDetails
        
        var dynamicTagArr:[[String:Any]]  = []
        var dynamicTextArr:[[String:Any]]  = []
        
        for data in dynamicTagDetails {
            //if data.type == 14 {
            if let annotation = data.TagValue?.pdfAnnotation {
                data.TagText = annotation.widgetStringValue ?? ""
            }
            //}
            dynamicTagArr.append(data.toDictionary())
        }
        for data in dynamicTextDetails {
            if let annotation = data.TagValue?.pdfAnnotation {
                data.TagText = annotation.widgetStringValue ?? ""
            }
            dynamicTextArr.append(data.toDictionary())
        }
        
        if userTxtArr.count > 0 {
            var cnt = dynamicTextArr.count
            for data in userTxtArr {
                let tagvalue = data.TagValue
                let txtvw = data.txtvw
                tagvalue?.TagText = txtvw?.text ?? ""
                tagvalue?.TagNo = cnt + 1
                data.TagText = txtvw?.text ?? ""
                dynamicTextArr.append(data.toDictionary())
                cnt = cnt + 1
            }
        }
        
        if userNoteArr.count > 0 {
            var cnt = dynamicTextArr.count
            for data in userNoteArr {
                let tagvalue = data.TagValue
                let txtvw = data.txtvw
                tagvalue?.TagText = txtvw?.text ?? ""
                tagvalue?.TagNo = cnt + 1
                data.TagText = txtvw?.text ?? ""
                dynamicTagArr.append(data.toDictionary())
                cnt = cnt + 1
            }
        }
        
        let ProcessSaveDetailsDto = [["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr]] as [[String : Any]]
        
        let pass = UserDefaults.standard.string(forKey: "Pass")
        let parameters = [  "Password": pass!,
                            "ProcessSaveDetailsDto": ProcessSaveDetailsDto
            ] as [String : Any]
        print("############")
        print("parameters: \(parameters)")
        print("############")
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        if Connectivity.isConnectedToInternet() == true
        {
           
            do {
            let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "PUT"
            request.allHTTPHeaderFields = headerAPIDashboard
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                }
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    
                    
                    var json: JSON = JSON(data!)
                    if let jsonDic = json.dictionaryObject as? [String:Any] {
                        debugPrint(jsonDic)
                        //let statusCode = jsonDic["StatusCode"] as! Int
                        if let jsonData = jsonDic["Data"] as? NSArray {
                            if let dataObj = jsonData[0] as? [String:Any] {
                                let statusCode = dataObj["StatusCode"] as! Int
                                if statusCode == 1000 {
                                    self.savedFlag = true
                                    DispatchQueue.main.async {
                                        let msg = "Document approved successfully."//jsonDic["Message"] as! String
                                        self.alertSample(strTitle: "", strMsg: msg)
                                    }
                                    self.con_btmView.constant = 0
                                    self.btmView.isHidden = true
                                    //self.removePageTags()
                                    self.getProcessDetailsAPI()
                                } else {
                                    
                                    let errmsg = dataObj["Message"] as! String
                                    
                                    DispatchQueue.main.async {
                                        self.alertSample(strTitle: "", strMsg: errmsg)
                                    }
                                }
                            }
                        }
                        /*
                        if statusCode == 1000 {
                            self.savedFlag = true
                            DispatchQueue.main.async {
                                let msg = "Document approved successfully."//jsonDic["Message"] as! String
                                self.alertSample(strTitle: "", strMsg: msg)
                            }
                            self.con_btmView.constant = 0
                            self.btmView.isHidden = true
                            //self.removePageTags()
                            self.getProcessDetailsAPI()
                        }
                        */
                        if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                            print(jsonObj)
                            
                        }
                    }
                    else
                    {
                        DispatchQueue.main.async {
                            self.alertSample(strTitle: "", strMsg: "Error from server")
                        }
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
    }
    
    func rejectAllProcessAPI() {
        
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "v1/process/SaveAllProcess"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)", "Content-Type":"application/json"]
        
       
        
        var TagDetails:[[String: Any]] = []//[["TagValue":dic,"TagText":"","Comment":""]]
        
        let ProcessSaveDetailsDto: NSMutableArray = NSMutableArray.init()
        
        for processData in processDataArr {
            
            for step in processData.Steps! {
                for tag in step.Tags! {
                    
                    if tag.type == 0 || tag.type == 1 {
                       
                       tag.State = 2
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":rejectComment])
                    }
                    if tag.type == 3 {
                        let button = tag.view as? UIButton
                        let btnAnnot = tag.pdfAnnotation
                        tag.TagText = (btnAnnot?.widgetStringValue)!
                        let tagtext = tag.TagText
                        tag.State = 2
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":rejectComment])
                    }
                    if tag.type == 4 {
                        let tagtext = tag.TagText
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":rejectComment])
                    }
                    if tag.type == 13 {
                        let button = tag.view as? UIButton
                        let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                        let state = btnAnnot?.buttonWidgetState
                        //if state == PDFWidgetCellState.onState {
                        print("state: On")
                        let tagplaceholder = tag.TagPlaceHolder
                        tag.ExtraMetaData = ["CheckState": "Checked",
                                             "TextH": tagplaceholder?.Height,
                                             "TextW": tagplaceholder?.Width,
                                             "TextX": tagplaceholder?.XCoordinate,
                                             "TextY": tagplaceholder?.YCoordinate]
                        tag.State = 2
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":rejectComment])
                        
                        /*} else {
                         print("Off")
                         }*/
                    }
                    if tag.type == 16 || tag.type == 17 || tag.type == 18 || tag.type == 19 || tag.type == 20  {
                        
                        tag.State = 2
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                    }
                }
            }
            
            
            let defID = processData.DefinitionId
            let processId = processData.ProcessId
            let dynamicTagDetails = processData.DynamicTagDetails
            let dynamicTextDetails = processData.DynamicTextDetails
            
            var dynamicTagArr:[[String:Any]]  = []
            var dynamicTextArr:[[String:Any]]  = []
            
            for data in dynamicTagDetails {
                dynamicTagArr.append(data.toDictionary())
            }
            for data in dynamicTextDetails {
                dynamicTextArr.append(data.toDictionary())
            }
            
            ProcessSaveDetailsDto.add(["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr])
        }
        //let ProcessSaveDetailsDto = [["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr]] as [[String : Any]]
        
        let pass = passwd//UserDefaults.standard.string(forKey: "Pass")
        let parameters = [  "Password": pass,
                            "ProcessSaveDetailsDto": ProcessSaveDetailsDto
            ] as [String : Any]
        print("############")
        print("parameters: \(parameters)")
        print("############")
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        if Connectivity.isConnectedToInternet() == true
        {
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = headerAPIDashboard
                request.httpBody = postData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                    }
                    if (error != nil) {
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse)
                        
                        
                        var json: JSON = JSON(data!)
                        if let jsonDic = json.dictionaryObject as? [String:Any] {
                            debugPrint(jsonDic)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            //let jsonData = jsonDic["Data"] as! NSDictionary
                            if statusCode == 1000 {
                                self.savedFlag = true
                                DispatchQueue.main.async {
                                    let msg = jsonDic["Message"] as! String
                                    self.alertSample(strTitle: "", strMsg: msg)
                                    self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                }
                                self.con_btmView.constant = 0
                                self.btmView.isHidden = true
                                //self.removePageTags()
                                //self.getProcessDetailsAPI()
                                
                            }
                            
                            if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                                print(jsonObj)
                                
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "Error from server")
                            }
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
    }
    
    func rejectProcessAPI() {
        
        /*
         
         {"Password":"13R@ds13","ProcessSaveDetailsDto":[{"WorkflowDefinitionId":8774,"ProcessId":12072,"TagDetails":[{"TagValue":{"Type":0,"Signatories":[{"Id":"BOtwqPvVhvJ56JWW4SkcsA%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":136.66666666666666,"YCoordinate":279.3366666666667,"Height":26.67,"Width":133.33},"ExtraMetaData":{"TickX":163.33266666666665,"TickY":299.8725666666667,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":2825},"TagNo":1,"State":2,"ObjectId":""},"TagText":"","Comment":"test"}],"UserPlaceHolderDetails":[],"DynamicTagDetails":[],"DynamicTextDetails":[]}]}
         
         
         parameters: ["Password": "13R@ds13", "ProcessSaveDetailsDto": [["DynamicTextDetails": [], "UserPlaceHolderDetails": [], "ProcessId": 12067, "DynamicTagDetails": [], "TagDetails": [["TagValue": ["TagPlaceHolder": ["Height": 26.67, "XCoordinate": 126.0, "PageNumber": 1.0, "YCoordinate": 274.67, "Width": 133.33], "Signatories": [["ProfileImage": "", "UserName": "", "FriendlyName": "", "Type": 1, "Id": "BOtwqPvVhvJ56JWW4SkcsA%3D%3D"]], "TagText": "", "State": 4, "ObjectId": "", "ExtraMetaData": ["TickW": 53.332000000000001, "TickH": 4.7999999999999998, "TickX": 156.0, "TickY": 289.67, "SignatureId": 2825], "Type": 0, "TagNo": 1], "TagText": "", "Comment": "test"]], "WorkflowDefinitionId": 8769]]]
         */
        
        self.showActivityIndicatory(uiView: self.view)
        
        let api = "v1/process/SaveAllProcess"
        let apiURL = Singletone.shareInstance.apiUserService + api
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)", "Content-Type":"application/json"]
        
        let step = self.processData.Steps![0]
        let tag = step.Tags![0]
        var dic = tag.toDictionary()
       
        var TagDetails:[[String: Any]] = []//[["TagValue":dic,"TagText":"","Comment":""]]
        
        for step in self.processData.Steps! {
            for tag in step.Tags! {
                
                if tag.type == 0 || tag.type == 1 {
                   
                    tag.State = 2
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":rejectComment])
                }
                if tag.type == 3 {
                    let button = tag.view as? UIButton
                    let btnAnnot = tag.pdfAnnotation
                    tag.TagText = (btnAnnot?.widgetStringValue)!
                    let tagtext = tag.TagText
                    tag.State = 2
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":rejectComment])
                }
                if tag.type == 4 {
                    let tagtext = tag.TagText
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":tagtext,"Comment":rejectComment])
                }
                if tag.type == 13 {
                    let button = tag.view as? UIButton
                    let btnAnnot = pdfView.currentPage?.annotation(at: (button?.center)!)
                    let state = btnAnnot?.buttonWidgetState
                    //if state == PDFWidgetCellState.onState {
                        print("state: On")
                        let tagplaceholder = tag.TagPlaceHolder
                        tag.ExtraMetaData = ["CheckState": "Checked",
                                             "TextH": tagplaceholder?.Height,
                                             "TextW": tagplaceholder?.Width,
                                             "TextX": tagplaceholder?.XCoordinate,
                                             "TextY": tagplaceholder?.YCoordinate]
                        tag.State = 2
                        TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":rejectComment])
                        
                    /*} else {
                        print("Off")
                    }*/
                }
                if tag.type == 16 || tag.type == 17 || tag.type == 18 || tag.type == 19 || tag.type == 20  {
                    
                    tag.State = 2
                    TagDetails.append(["TagValue":tag.toDictionary(),"TagText":"","Comment":""])
                }
            }
        }
        
        
        let defID = self.processData.DefinitionId
        let processId = self.processData.ProcessId
        let dynamicTagDetails = self.processData.DynamicTagDetails
        let dynamicTextDetails = self.processData.DynamicTextDetails
        
        var dynamicTagArr:[[String:Any]]  = []
        var dynamicTextArr:[[String:Any]]  = []
        
        for data in dynamicTagDetails {
            dynamicTagArr.append(data.toDictionary())
        }
        for data in dynamicTextDetails {
            dynamicTextArr.append(data.toDictionary())
        }
        
        let ProcessSaveDetailsDto = [["WorkflowDefinitionId":defID!, "ProcessId":processId!, "TagDetails":TagDetails, "UserPlaceHolderDetails":[],"DynamicTagDetails": dynamicTagArr,"DynamicTextDetails":dynamicTextArr]] as [[String : Any]]
        
        let pass = passwd//UserDefaults.standard.string(forKey: "Pass")
        let parameters = [  "Password": pass,
                            "ProcessSaveDetailsDto": ProcessSaveDetailsDto
            ] as [String : Any]
        print("############")
        print("parameters: \(parameters)")
        print("############")
        
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: parameters,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            print("JSON string = \(theJSONText!)")
        }
        
        if Connectivity.isConnectedToInternet() == true
        {
           
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let request = NSMutableURLRequest(url: NSURL(string: apiURL)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = headerAPIDashboard
                request.httpBody = postData as Data
                
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    
                    DispatchQueue.main.async {
                        self.stopActivityIndicator()
                    }
                    if (error != nil) {
                        print(error)
                    } else {
                        let httpResponse = response as? HTTPURLResponse
                        print(httpResponse)
                        
                        
                        var json: JSON = JSON(data!)
                        if let jsonDic = json.dictionaryObject as? [String:Any] {
                            debugPrint(jsonDic)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            //let jsonData = jsonDic["Data"] as! NSDictionary
                            if statusCode == 1000 {
                                self.savedFlag = true
                                DispatchQueue.main.async {
                                    let msg = "Document rejected successfully."//jsonDic["Message"] as! String
                                    self.alertSample(strTitle: "", strMsg: msg)
                                    self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                }
                                self.con_btmView.constant = 0
                                self.btmView.isHidden = true
                                //self.removePageTags()
                                //self.getProcessDetailsAPI()
                                
                            }
                            
                            if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                                print(jsonObj)
                                
                            }
                        }
                        else
                        {
                            DispatchQueue.main.async {
                                self.alertSample(strTitle: "", strMsg: "Error from server")
                            }
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
    }

    
    func getProcessDetailsAPI() {
        
        self.showActivityIndicatory(uiView: self.view)
        //https://zsdemowebworkflow.zorrosign.com/api/v1/process/GetProcess?processId=3658
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/process/GetProcessDetails?processId=\(instanceID!)")
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
                        if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            if statusCode == 1000 {
                                let msg = jsonDic["Message"] as! String
                                //self.alertSample(strTitle: "", strMsg: msg)
                                self.processData = ProcessData(dictionary: jsonObj as! [AnyHashable : Any])
                                let doclist = self.processData.Documents![0]
                                self.docObjId = doclist.ObjectId
                                //self.getDocSize(objectId: self.docObjId as! String)
                                DispatchQueue.main.async {
                                    
                                    if doclist.DocType == 2 { // for user specific workflow
                                        
                                        /*
                                         https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=<token>&ctrl=Dashboard&destination=workflow/-1/ndcprocess/<processId>
                                         https://sandboxapp.zorrosign.com/home/SSOLogin?serviceToken=uqrnZ8906AmE0kxdaoKBxeV45wCWspWrN394iHRQJltwVScI0vxEqYateRRG4E9ONKRBJYNQxGJaEr5Zc7CatrQbTf4pbD6JInCcLKBuypzC8kp5AvvBU5P27mySwkoY&ctrl=Dashboard&destination=workflow/-1/ndcprocess/11383
                                         */
                                        let msg = "You will now be directed to our web app to complete this document."
                                        
                                        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        alert.addAction(UIAlertAction(title: "Open in browser", style: .default, handler: {
                                            action in
                                            
                                                let procId: String = self.instanceID!
                                                let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/-1/ndcprocess/\(procId)"
                                                let url = URL(string: urlstr)
                                                UIApplication.shared.openURL(url!)
                                            
                                        }))
                                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                                        self.present(alert, animated: true, completion: {
                                            self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                        })
                                        
                                    } else {
                                    
                                        self.getDocAPI(objID: self.docObjId as! String, processID: self.instanceID!)
                                    }
                                }
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
    
    @IBAction func approveAction(_ sender: Any) {
        
        if multiSign {
            
            validateMutiSign()
            
        } else {
            //saveProcessAPI()
            //showApproveAlert()
            validateTags()
        }
    }
    
    @IBAction func rejectAction(_ sender: Any) {
        //rejectProcessAPI()
        showCommentAlert()
    }
    
    @IBAction func prevAction(_ sender: Any) {
        if currPageNumber > 1 {
            currPageNumber = currPageNumber - 1
            self.lblPageNo.text = "Page: \(currPageNumber)/\(pageCount)"
            self.pdfView.goToPreviousPage(sender)
            if !self.savedFlag {
                addPageTags()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        if currPageNumber < pageCount {
            currPageNumber = currPageNumber + 1
            
            self.lblPageNo.text = "Page: \(currPageNumber)/\(pageCount)"
            self.pdfView.goToNextPage(sender)
            if !self.savedFlag {
                addPageTags()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if(scrollView.contentOffset.y
            >=
            (scrollView.contentSize.height - scrollView.frame.size.height)){
            print("BOTTOM REACHED");
            scrollFlag = "bottom"
        }
        if(scrollView.contentOffset.y <= 0.0){
            print("TOP REACHED");
            scrollFlag = "top"
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("begin")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end")
        
        let hint = textField.accessibilityHint
        
        if hint != "comment" && hint != "pass" {
            let tag = textField.tag
            let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
            let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
            let tagdata = tagdataArr[0]
            tagdata.TagText = textField.text!
            tagdata.State = 4
            print("textFieldDidEndEditing: \(textField.text)")
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        // for dynamic text
        if textView.tag == 1 {
            let index = Int(textView.accessibilityHint!)
            let txtdata = userTxtArr[index!]
            let tagdata = txtdata.TagValue
            tagdata?.TagText = textView.text
        }
        
        if textView.tag == 5 {
            let index = Int(textView.accessibilityHint!)
            let txtdata = userNoteArr[index!]
            let tagdata = txtdata.TagValue
            tagdata?.TagText = textView.text
        }
    }
    
    func pdfViewWillClick(onLink sender: PDFView, with url: URL) {
        
        print("URL: \(url)")
        let tag: Int = Int(url.absoluteString)!
        let arr: [TagsData] = pageTagsDic[currPageNumber] as? NSMutableArray as! [TagsData]
        let tagdataArr: [TagsData] = arr.filter{ ($0.TagId == tag) }
        if tagdataArr[0].type == 4 {
            dateAction(tag: tag)
        }
        if tagdataArr[0].type == 0 || tagdataArr[0].type == 1 {
            signAction(tag: tag)
        }
        if tagdataArr[0].type == 2 {
            sealAction(tag: tag)
        }
        if tagdataArr[0].type == 13 {
            checkAction(tag: tag)
        }
        if tagdataArr[0].type == 16 || tagdataArr[0].type == 17 || tagdataArr[0].type == 18 || tagdataArr[0].type == 19 || tagdataArr[0].type == 20 {
            profileAction(tag: tag)
        }
        
    }
    
    func getDocSize(objectId: String) {
        //https://zsdemowebworkflow.zorrosign.com/api/v1/processdocument/GetDocumentPageSize?processIdNum=3656&objectId=workspace://SpacesStore/877c51f8-40b6-4e50-8bce-8e44d59688d7;1.0
     
        self.showActivityIndicatory(uiView: self.view)
        
        var apiURL = Singletone.shareInstance.apiUserService
        let api = String("v1/processdocument/GetDocumentPageSize?processIdNum=\(instanceID!)&objectId=\(objectId)")
        
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
                        if let jsonObj:NSDictionary = jsonDic["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic["StatusCode"] as! Int
                            if statusCode == 0 {
                                /*
                                 {
                                 "StatusCode": 0,
                                 "Message": null,
                                 "Data": {
                                 "Width": 612,
                                 "Height": 792
                                 }
                                 */
                                if let data = jsonDic["Data"] as? [String:Any] {
                                    if let width = data["Width"] {
                                        let W = width as? NSNumber
                                        self.pdfW = Int(W!)
                                    }
                                    if let height = data["Height"] {
                                        let H = height as? NSNumber
                                        self.pdfH = Int(H!)
                                    }
                                }
                                let format = self.getDocFormat(width: self.pdfW , height: self.pdfH) as? String
                                
                                if format != "NA"
                                {
                                    DispatchQueue.main.async {
                                    self.getDocAPI(objID: self.docObjId as! String, processID: self.instanceID!)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                     
                                        let msg = "The document size (Letter, A4 etc) that you are trying to sign is currently incompatible with our  mobile app. Click following button to sign this document using your mobile web browser. Alternatively you can sign this document by logging into ZorroSign on your computer."
                                        
                                        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                        alert.addAction(UIAlertAction(title: "Open in browser", style: .default, handler: {
                                            action in
                                            
                                            if self.docCat == 90 {
                                                let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(strAuth)&ctrl=Dashboard&destination=workflow/-1/process/\(self.instanceID)"
                                                let url = URL(string: urlstr)
                                                UIApplication.shared.openURL(url!)
                                            } else {
                                                let urlstr: String = "https://app.zorrosign.com/home/SSOLogin?serviceToken=\(self.instanceID)&ctrl=Dashboard&destination=download/process/\(self.instanceID)/code/"
                                                let url = URL(string: urlstr)
                                                UIApplication.shared.openURL(url!)
                                            }
                                            /*
                                             InBox:
                                             https://app.zorrosign.com/home/SSOLogin?serviceToken=qLlpo9fRYmgLDTBIpLzjikdidB3yTUvoYBcR3A2by0NG7fagOVwmJbyJslXBjtZn5iF4iX9FdnUTn7T9eiqWoHdAtEKlHL8pUadOq4GFzU1qwTcXNUoKAOlYuXIMZeUP&ctrl=Dashboard&destination=workflow/-1/process/11269
                                             
                                             In-Process / Completed / Rejected
                                             https://app.zorrosign.com/home/SSOLogin?serviceToken=qLlpo9fRYmgLDTBIpLzjikdidB3yTUvoYBcR3A2by0NG7fagOVwmJbyJslXBjtZn5iF4iX9FdnUTn7T9eiqWoHdAtEKlHL8pUadOq4GFzU1qwTcXNUoKAOlYuXIMZeUP&ctrl=Dashboard&destination=download/process/11266/code/
                                             */
                                            
                                        }))
                                        alert.view.tintColor = Singletone.shareInstance.footerviewBackgroundGreen
                                        self.present(alert, animated: true, completion: {
                                            self.perform(#selector(self.btnBackAction(_:)), with: nil, afterDelay: 1.0)
                                            //self.navigationController?.popViewController(animated: true)
                                        })
                                        
                                        
                                    }
                                    
                                }
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
    
    func getDocFormat(width: Int, height: Int) -> String {
        
        /*
          if ((width>=595f && width<=596f && height>=841f && height<=842f) || (width>=612f && width<=613f && height>=792f && height<=793f))
         */
        /*
        if width == 612 && height == 792 {
            return "Letter"
        }*/
        if ((width >= Int(595) && width <= Int(596) && height >= Int(841) && height <= Int(842)) || (width >= Int(612) && width <= Int(613) && height >= Int(792) && height <= Int(793))) {
            return "A4"
        }
        return "NA"
    }
    
    func showCommentAlert() {
        commentAlertView = SwiftAlertView(nibName: "CommentAlert", delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["CONFIRM"])
        //"Apply Changes"
        commentAlertView.tag = 14
        commentAlertView.dismissOnOtherButtonClicked = false
        
        
        let txtcomment = commentAlertView.viewWithTag(1) as! UITextField
        txtcomment.delegate = self
        txtcomment.accessibilityHint = "comment"
        
        let txtpass = commentAlertView.viewWithTag(2) as! UITextField
        txtpass.delegate = self
        txtpass.accessibilityHint = "pass"
        
        let errcmt = commentAlertView.viewWithTag(3) as! UILabel
        let errpwd = commentAlertView.viewWithTag(4) as! UILabel
        
        errcmt.isHidden = true
        errpwd.isHidden = true
        
        let btnclose = commentAlertView.buttonAtIndex(index: 0)
        let btnadd = commentAlertView.buttonAtIndex(index: 1)
        
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        commentAlertView.delegate = self
        commentAlertView.show()
    }
    
    func showApproveAlert() {
        
        let viewarr = Bundle.main.loadNibNamed("CommentAlert", owner: self, options: nil)
        let commAlert = viewarr![1] as! UIView
        
        commentAlertView1 = SwiftAlertView(contentView: commAlert, delegate: self, cancelButtonTitle: "CANCEL", otherButtonTitles: ["CONFIRM"])
            //SwiftAlertView(nibName: "CommentAlert", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: ["Confirm"])
        //"Apply Changes"
        commentAlertView1.tag = 41
        commentAlertView1.dismissOnOtherButtonClicked = false
        
        
        let txtpass = commentAlertView1.viewWithTag(2) as! UITextField
        txtpass.delegate = self
        txtpass.accessibilityHint = "pass"
        
        let errpwd = commentAlertView1.viewWithTag(4) as! UILabel
        
        errpwd.isHidden = true
        
        let btnclose = commentAlertView1.buttonAtIndex(index: 0)
        let btnadd = commentAlertView1.buttonAtIndex(index: 1)
        
        
        btnclose?.backgroundColor = UIColor.white
        btnclose?.setTitleColor(Singletone.shareInstance.footerviewBackgroundGreen, for: UIControl.State.normal)
        
        btnadd?.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        btnadd?.setTitleColor(UIColor.white, for: UIControl.State.normal)
        
        commentAlertView1.delegate = self
        commentAlertView1.show()
    }
    
    func showMultiSignAlert(){
        
        multiSignAlertView = SwiftAlertView(nibName: "MultiSignAlert", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Ok")
        multiSignAlertView.tag = 41
        
        let tblvw = multiSignAlertView.viewWithTag(1) as! UITableView
        tblvw.dataSource = self
        tblvw.delegate = self
        tblvw.reloadData()
        
        
    }
    
    func alertView(alertView: SwiftAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        if alertView.tag == 14 {
            if buttonIndex == 1 {
                let txtcomm = alertView.viewWithTag(1) as! UITextField
                rejectComment = txtcomm.text!
                
                
                let txtpass = alertView.viewWithTag(2) as! UITextField
                passwd = txtpass.text!
                
                let pass = UserDefaults.standard.string(forKey: "Pass")
                
                let errcmt = alertView.viewWithTag(3) as! UILabel
                let errpwd = alertView.viewWithTag(4) as! UILabel
                
                errcmt.isHidden = true
                errpwd.isHidden = true
                
                if rejectComment.isEmpty {
                    //alertSample(strTitle: "Error", strMsg: "Please enter comment")
                    errcmt.isHidden = false
                }
                else if passwd.isEmpty {
                    errpwd.text = "This field is required"
                    errpwd.isHidden = false
                }
                else if passwd != pass {
                    //alertSample(strTitle: "Error", strMsg: "Wrong password")
                    errpwd.text = "Wrong password"
                    errpwd.isHidden = false
                    
                } else {
                    commentAlertView.dismiss()
                    if multiSign {
                        rejectAllProcessAPI()
                    } else {
                        rejectProcessAPI()
                    }
                }
            }
        }
        if alertView.tag == 41 {
            if buttonIndex == 1 {
                
                let txtpass = alertView.viewWithTag(2) as! UITextField
                passwd = txtpass.text!
                
                let pass = UserDefaults.standard.string(forKey: "Pass")
                
                let errpwd = alertView.viewWithTag(4) as! UILabel
                
                errpwd.isHidden = true
                
                if passwd.isEmpty {
                    errpwd.text = "This field is required"
                    errpwd.isHidden = false
                }
                else if passwd != pass {
                    //alertSample(strTitle: "Error", strMsg: "Wrong password")
                    errpwd.text = "Wrong password"
                    errpwd.isHidden = false
                    
                } else {
                    commentAlertView1.dismiss()
                    if multiSign {
                        saveAllProcessAPI()
                    } else {
                        
                        saveProcessAPI()
                    }
                }
            }
        }
    }
    
    func validateTags() {
        
        for step in self.processData.Steps! {
            for tag in step.Tags! {
                let btnAnnot = tag.pdfAnnotation
                let txt = btnAnnot?.widgetStringValue ?? ""
                
                //if tag.State != 4  || txt.isEmpty{
                    //alertSample(strTitle: "Error", strMsg: "All tags are mandatory")
                    if tag.type == 0 && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter signature")
                        return
                    }
                    if tag.type == 1 && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter initial")
                        return
                    }
                    if tag.type == 2  && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter seal")
                        return
                    }
                    if tag.type == 3 && txt.isEmpty {
                        
                        alertSample(strTitle: "Error", strMsg: "Please enter text")
                        return
                    }
                    if tag.type == 4  && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter date")
                        return
                    }
                    if tag.type == 13 {
                        let btnAnnot = tag.pdfAnnotation
                        let state = btnAnnot?.buttonWidgetState
                        if state != PDFWidgetCellState.onState {
                            alertSample(strTitle: "Error", strMsg: "Please click checkbox")
                            return
                        }
                        
                    }
                    if tag.type == 16  && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter name")
                        return
                    }
                    if tag.type == 17  && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter email")
                        return
                    }
                    if tag.type == 18 && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter company")
                        return
                    }
                    if tag.type == 19 && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter title")
                        return
                    }
                    if tag.type == 20 && tag.State != 4 {
                        alertSample(strTitle: "Error", strMsg: "Please enter phone")
                        return
                    }
                
                //}
            }
        }
        //saveProcessAPI()
        showApproveAlert()
        
        
    }
    
    @IBAction func showWorkflow() {
        
        //getProcessDetailsAPI()
        let workflowVC = self.getVC(sbId: "WorkflowVC_ID") as! WorkflowVC
        workflowVC.instanceID = instanceID
        self.present(workflowVC, animated: false, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return processDataArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            //pickerLabel = UILabel()
            let arr = Bundle.main.loadNibNamed("LabelCell", owner: self, options: nil)
            cell = ((arr?[3] as? UITableViewCell)! as? LabelCell)!
            
        }
        let btnchk = cell?.viewWithTag(1) as! UIButton
        let pickerLabel = cell?.viewWithTag(2) as! UILabel
        let typeLabel = cell?.viewWithTag(3) as! UILabel
        
        
        pickerLabel.textAlignment = .center
        typeLabel.textAlignment = .center
        
        let processData = processDataArr[indexPath.row]
        
        let type: String = processData.processType!
        let name: String = processData.DocumentSetName!
        
        pickerLabel.text = name
        pickerLabel.textColor = UIColor.black
        typeLabel.textColor = UIColor.black
        
        typeLabel.text = type
        btnchk.tag = indexPath.row
        btnchk.isSelected = processData.selected
        
        btnchk.addTarget(self, action: #selector(onChecked), for: UIControl.Event.touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let processData = processDataArr[indexPath.row]
        let doclist = processData.Documents![0]
        self.docObjId = doclist.ObjectId
       
        self.instanceID = "\(processData.ProcessId!)"
        self.processData = processData
        
        multiSignAlertView.dismiss()
        //self.getDocSize(objectId: self.docObjId!)
        self.getDocAPI(objID: self.docObjId!, processID: self.instanceID!)
    }
 
    func multiSignPickerSetting() {
        
        multiSignPicker.dataSource = self
        multiSignPicker.delegate = self
        multiSignPicker.reloadAllComponents()
    }
    
    @IBAction func showMultiSignPicker() {
        if multiSign {
            //viewPicker.isHidden = false
            //multiSignPicker.isHidden = false
            showMultiSignAlert()
            multiSignAlertView.show()
        }
    }
    
    @IBAction func doneAction(){
        
        viewPicker.isHidden = true
        multiSignPicker.isHidden = true
        
    }
    
    @IBAction func onChecked(_ sender: UIButton) {
        
        let tag: Int = sender.tag
        let processData = processDataArr[tag]
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            processData.selected = true
        } else {
            processData.selected = false
        }
        //multiSignPicker.reloadAllComponents()
        let tblvw = multiSignAlertView.viewWithTag(1) as! UITableView
        tblvw.reloadData()
    }
    /*
    override func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
    }*/
    
    
    
    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        timer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: #selector(self.timeHasExceeded),
                                     userInfo: nil,
                                     repeats: false)
    }
    
    @objc private func timeHasExceeded() {
        self.loader.stopAnimating()
        self.loader.isHidden = true
        self.stopActivityIndicator()
        
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func downloadDoc() {
        //UIApplication.shared.openURL(documentsURL!)
        let pdfViewControlelr = PDFViewController()
        pdfViewControlelr.pdfURL = documentsURL
        //self.present(pdfViewControlelr, animated: false, completion: nil)
        self.navigationController?.pushViewController(pdfViewControlelr, animated: false)
    }
    
    
    
    // get user subscription data
    func getSubscription() {
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        let api = "v3/Subscription/GetSubscriptionData"
        let apiURL = Singletone.shareInstance.apiSubscription + api
        
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        Alamofire.request(URL(string: apiURL)!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
            .responseJSON { response in
                
                let jsonObj: JSON = JSON(response.result.value!)
                if jsonObj["StatusCode"] == 1000
                {
                    Singletone.shareInstance.stopActivityIndicator()
                    
                    self.subscriptionPlan = jsonObj["Data"]["SubscriptionPlan"].intValue
                    
                }
                else
                {
                    Singletone.shareInstance.stopActivityIndicator()
                   
                }
        }
    }
}

@available(iOS 11.0, *)
extension DocSignVC: GrowingTextViewDelegate {
    
    // *** Call layoutIfNeeded on superview for animation when changing height ***
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: [.curveLinear], animations: { () -> Void in
            //self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
/*
 Request
 {
 "Password": "11111111!A",
 "ProcessSaveDetailsDto": [{
 "WorkflowDefinitionId": 5072,
 "ProcessId": 3683,
 "TagDetails": [{
 "TagValue": {
 "Type": 0,
 "Signatories": [{
 "Id": "F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D",
 "Type": 1,
 "UserName": null,
 "FriendlyName": null,
 "ProfileImage": null
 }],
 "TagPlaceHolder": {
 "PageNumber": 1,
 "XCoordinate": 102.66666666666667,
 "YCoordinate": 113.99666666666667,
 "Height": 26.67,
 "Width": 133.33
 },
 "ExtraMetaData": {
 "TickX": 129.33266666666668,
 "TickY": 134.5325666666667,
 "TickW": 53.33200000000001,
 "TickH": 4.8006,
 "SignatureId": 3304
 },
 "TagNo": 1,
 "State": 4,
 "ObjectId": ""
 },
 "TagText": "",
 "Comment": ""
 }],
 "UserPlaceHolderDetails": [],
 "DynamicTagDetails": [],
 "DynamicTextDetails": []
 }]
 }
 */
/*
 Response:
 
 {
 "CreatedDate": "2018-08-22T16:03:32",
 "CreatedUser": 2031,
 "DefinitionId": 5053,
 "DefinitionName": "Test 6",
 "DocumentSetName": "Test 6",
 "Documents": [
 {
 "AttachedUser": "<null>",
 "AttachedUserProfileId": 0,
 "DocType": 0,
 "IsDeletable": 0,
 "Name": "AAA_TestPdf",
 "ObjectId": "workspace://SpacesStore/2c3a5569-cf5a-4b63-8388-f0e2d597ad6d,1.0",
 "OriginalName": "<null>"
 }
 ],
 "DynamicTagDetails": [],
 "DynamicTextDetails": [],
 "ExtendedProcessData": "<null>",
 "HasAToken": 0,
 "IsInitiated": 1,
 "IsLastStep": 1,
 "MainDocumentType": 0,
 "ModifiedDate": "2018-08-22T16:03:37",
 "ModifiedUser": 2031,
 "OrganizationId": 0,
 "PageSizes": [],
 "ProcessId": 3674,
 "ProcessState": 1,
 "ProcessingStep": 2,
 "ProcessingSubSteps": [
 1
 ],
 "Steps": [
 {
 "CCList": [],
 "StepNo": 2,
 "Tags": [
 {
 "DueDate": "2018-08-23T23:59:59",
 "ExtraMetaData": {},
 "ObjectId": "<null>",
 "Signatories": [
 {
 "FriendlyName": "<null>",
 "Id": "F%2BnxcRjh5o8J1DmN%2Bn8Qtg%3D%3D",
 "ProfileImage": "<null>",
 "Type": 1,
 "UserName": "<null>"
 }
 ],
 "State": 1,
 "TagId": 13105,
 "TagNo": 1,
 "TagPlaceHolder": {
 "Height": "26.67",
 "PageNumber": 1,
 "Width": "133.33",
 "XCoordinate": 286,
 "YCoordinate": 66
 },
 "Type": 0
 }
 ]
 }
 ],
 "TokenPlaceholder": {
 "Height": 0,
 "PageNumber": 0,
 "Width": 0,
 "XCoordinate": 0,
 "YCoordinate": 0
 },
 "UserPlaceHolders": []
 }
 */

/*
 ExtraMetaData
 :
 {TickX: 286.66266666666667, TickY: 95.87256666666667, TickW: 53.33200000000001, TickH: 4.8006,…}
 SignatureId
 :
 3307
 TickH
 :
 4.8006
 TickW
 :
 53.33200000000001
 TickX
 :
 286.66266666666667
 TickY
 :
 95.87256666666667
 }
 {"Password":"11111111!A","ProcessSaveDetailsDto":[{"WorkflowDefinitionId":5084,"ProcessId":3692,"TagDetails":[{"TagValue":{"Type":0,"Signatories":[{"Id":"n5JeREur4kaeWi%2BcNKU3%2BA%3D%3D","Type":2,"UserName":null,"FriendlyName":null,"ProfileImage":null}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":259.99666666666667,"YCoordinate":75.33666666666667,"Height":26.67,"Width":133.33},"ExtraMetaData":{"TickX":286.66266666666667,"TickY":95.87256666666667,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":3307},"TagNo":1,"State":4,"ObjectId":""},"TagText":"","Comment":""}],"UserPlaceHolderDetails":[],"DynamicTagDetails":[],"DynamicTextDetails":[{"TextRevisionHistory":[],"IsDeleted":false,"IsLocked":false,"TagValue":{"Type":14,"Signatories":[],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":256,"YCoordinate":118.67,"Height":26.67,"Width":106.67},"ExtraMetaData":{"lock":false,"AddedBy":"Anil Saindane"},"TagNo":1,"State":1,"ObjectId":null,"TagId":570,"DueDate":null},"TagText":"Hello","Comment":null,"IsDynamicTag":false,"SignedAt":"2018-09-10T15:14:14"}]}]}
 */


/*
 Web Req
 {"Password":"11111111!A","ProcessSaveDetailsDto":[{"WorkflowDefinitionId":5086,"ProcessId":3694,"TagDetails":[{"TagValue":{"Type":0,"Signatories":[{"Id":"n5JeREur4kaeWi%2BcNKU3%2BA%3D%3D","Type":2,"UserName":null,"FriendlyName":null,"ProfileImage":null}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":339.3366666666667,"YCoordinate":157.99666666666667,"Height":26.67,"Width":133.33},"ExtraMetaData":{"TickX":366.0026666666667,"TickY":178.5325666666667,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":3307},"TagNo":1,"State":4,"ObjectId":""},"TagText":"","Comment":""}],"UserPlaceHolderDetails":[],"DynamicTagDetails":[],"DynamicTextDetails":[]}]}

 */

/*
 My Req
 {
 "Password": "11111111!A",
 "ProcessSaveDetailsDto": {
 "DynamicTextDetails": [],
 "UserPlaceHolderDetails": [],
 "ProcessId": 3695,
 "DynamicTagDetails": [],
 "TagDetails": [
 {
 "TagValue": {
 "TagPlaceHolder": {
 "Height": 26.67,
 "XCoordinate": 336.67,
 "PageNumber": 1,
 "YCoordinate": 156,
 "Width": 133.33
 },
 "Signatories": [
 {
 "Id": "n5JeREur4kaeWi%2BcNKU3%2BA%3D%3D",
 "FriendlyName" : null,
 "ProfileImage" : null,
 "Type" : 2,
 "UserName" : null
 }
 ],
 "Type": 0,
 "TagNo": 1,
 "State": 1,
 "ObjectId": "",
 "ExtraMetaData": {
 "TickW": 53.33200000000001,
 "TickH": 4.8006,
 "TickX": 286.66266666666667,
 "TickY": 95.87256666666667,
 "SignatureId": 0
 }
 },
 "TagText": "",
 "Comment": ""
 }
 ],
 "WorkflowDefinitionId": 5087
 }
 }
 
 {"Password":"11111111!A","ProcessSaveDetailsDto":[{"WorkflowDefinitionId":5087,"ProcessId":3695,"TagDetails":[{"TagValue":{"Type":0,"Signatories":[{"Id":"n5JeREur4kaeWi%2BcNKU3%2BA%3D%3D","Type":2,"UserName":null,"FriendlyName":null,"ProfileImage":null}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":339.3366666666667,"YCoordinate":158.66666666666666,"Height":26.67,"Width":133.33},"ExtraMetaData":{"TickX":366.0026666666667,"TickY":179.20256666666666,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":3307},"TagNo":1,"State":4,"ObjectId":""},"TagText":"","Comment":""}],"UserPlaceHolderDetails":[],"DynamicTagDetails":[],"DynamicTextDetails":[]}]}
 */



//saveallprocess

/*
 {"Password":"Pankaj#11","ProcessSaveDetailsDto":[{"WorkflowDefinitionId":15904,"ProcessId":11276,"TagDetails":[{"TagValue":{"Type":0,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":128.66666666666666,"YCoordinate":279.3366666666667,"Height":26.67,"Width":133.33},"ExtraMetaData":{"TickX":155.33266666666665,"TickY":299.8725666666667,"TickW":53.33200000000001,"TickH":4.8006,"SignatureId":3847},"TagNo":1,"State":4,"ObjectId":""},"TagText":"","Comment":""},{"TagValue":{"Type":16,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":69.99666666666667,"YCoordinate":161.33666666666664,"Height":16.67,"Width":106.67},"ExtraMetaData":{"fontSize":14},"TagNo":2,"State":4,"ObjectId":""},"TagText":"","Comment":""},{"TagValue":{"Type":17,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":112.66666666666667,"YCoordinate":326.6666666666667,"Height":16.67,"Width":106.67},"ExtraMetaData":{"fontSize":14},"TagNo":3,"State":4,"ObjectId":""},"TagText":"","Comment":""},{"TagValue":{"Type":18,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":370.6666666666667,"YCoordinate":749.3366666666666,"Height":16.67,"Width":106.67},"ExtraMetaData":{"fontSize":14},"TagNo":4,"State":4,"ObjectId":""},"TagText":"","Comment":""},{"TagValue":{"Type":19,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":255.99666666666667,"YCoordinate":749.3366666666666,"Height":16.67,"Width":106.67},"ExtraMetaData":{},"TagNo":5,"State":4,"ObjectId":""},"TagText":"","Comment":""},{"TagValue":{"Type":20,"Signatories":[{"Id":"hYQHxbH7tM4WH0aogzF3ow%3D%3D","Type":1,"UserName":null,"GroupName":null,"GroupImage":null,"FriendlyName":null,"ProfileImage":null,"ProfileId":""}],"TagPlaceHolder":{"PageNumber":1,"XCoordinate":139.99666666666667,"YCoordinate":748.6666666666666,"Height":16.67,"Width":106.67},"ExtraMetaData":{"fontSize":14},"TagNo":6,"State":4,"ObjectId":""},"TagText":"","Comment":""}],"UserPlaceHolderDetails":[],"DynamicTagDetails":[],"DynamicTextDetails":[]}]}
 */
