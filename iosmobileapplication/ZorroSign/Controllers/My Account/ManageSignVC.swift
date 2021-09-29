//
//  ManageSignVC.swift
//  ZorroSign
//
//  Created by Apple on 12/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import Foundation
import RGSColorSlider
import IQKeyboardManagerSwift
import Alamofire
import SwiftyJSON


class ManageSignVC: BaseVC, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CustomCellProtocol, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var tableViewList: CustomTable!
    
    @IBOutlet weak var viewBottomDashborad: UIView!
    //@IBOutlet weak var viewBottomStart: UIView!
    @IBOutlet weak var viewBottomSearch: UIView!
    @IBOutlet weak var viewBottomMyAccount: UIView!
    @IBOutlet weak var btnBottomHelp: UIView!
    
    @IBOutlet weak var imgDashboard: UIImageView!
    @IBOutlet weak var imgStart: UIImageView!
    @IBOutlet weak var imgSearch: UIImageView!
    @IBOutlet weak var imgMyAccount: UIImageView!
    @IBOutlet weak var imgHelp: UIImageView!
    
    @IBOutlet weak var lblDashboard: UILabel!
    @IBOutlet weak var lblStart: UILabel!
    @IBOutlet weak var lblSearch: UILabel!
    @IBOutlet weak var lblMyAccount: UILabel!
    @IBOutlet weak var lblHelp: UILabel!
    @IBOutlet var drawView : AnyObject!
    @IBOutlet weak var txtSignDD: DesignableUITextField!
    
    @IBOutlet weak var fontPicker: UIPickerView!
    var picker: UIPickerView!
    
    @IBOutlet weak var fontPickerView: UIView!
    
    
    var signColor: UIColor = UIColor.black
    var signFont: CGFloat = 1.0
    var txtSignOpt: String = ""
    var txtFontOpt: String = ""
    var txtInitialSignOpt: String = ""
    var txtInitialFontOpt: String = ""
    var selSignOpt: Int = 1
    var selInSignOpt: Int = 1
    var selFont: String = Singletone.shareInstance.fontArray[0]
    var selInFont: String = Singletone.shareInstance.fontArray[0]
    var txtGen: String = ""
    var txtInitGen: String = ""
    var minFontVal = 1
    var maxFontVal = 5//25
    var minInFontVal = 1
    var maxInFontVal = 5//25
    var txtSaveOpt: String = "Saving as"
    var saveOptIndex: Int = 0
    var saveOpt1: String = ""
    var saveOpt2: String = ""
    var saveOpt3: String = ""
    var selSign: String = ""
    var prevSelSign: String = ""
    var selSignObject: SignObject?
    var signLines: [Line] = []
    var initialLines: [Line] = []
    var finalSignDataArray:[SignObject] = []
    var userSignArray:[UserSignatures] = []
    let savePlaceholder1: String = "E.g. John Smith As Trusty of ABC"
    let savePlaceholder2: String = "E.g. J.Smith"
    let savePlaceholder3: String = "E.g. John Smith On Behalf of Jane Smith"
    let savePlaceholder4: String = "Custom John Smith"
    
    var savePlaceholderArr: [String] = []
    
    let reasonPlaceholder1: String = "Reason: Power of Attorney"
    let reasonPlaceholder2: String = "Reason: Acme, Inc. Singatrue"
    let reasonPlaceholder3: String = "Reason: Minor"
    let reasonPlaceholder4: String = "Reason: Standard"
    
    var reasonPlaceholderArr: [String] = []
    var selSignIndex: Int = 0
    
    var signUpdate: Bool = false
    var initialUpdate: Bool = false
    
    var profstat: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Show Subscription banner
        let isBannerClosed = ZorroTempData.sharedInstance.isBannerClosd()
        if !isBannerClosed {
            setTitleForSubscriptionBanner()
        }
        
        // get Signature data
        self.navigationController?.navigationBar.tintColor = UIColor.init(red: 20/255, green: 150/255, blue: 32/255, alpha: 1)
        self.navigationItem.leftBarButtonItem = nil
        let bckbutn = UIBarButtonItem(image: UIImage(named: "Back"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(goback(_:)))
        self.navigationItem.leftBarButtonItem = bckbutn
        initialSettings()
        //printFonts()
        txtSignDD.delegate = self
        
        viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgMyAccount.image = UIImage(named: "landing_screen_signup_icon")
        lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundWhite
        lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundGreen
        imgDashboard.image = UIImage(named: "dashboard_green_bottom_bar_icon")
        viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
        
        //Gesture bottom
        let gestureDashboard = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureStart = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureSearch = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureMyAccount = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        let gestureHelp = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        
        viewBottomDashborad.addGestureRecognizer(gestureDashboard)
        //viewBottomStart.addGestureRecognizer(gestureStart)
        viewBottomSearch.addGestureRecognizer(gestureSearch)
        viewBottomMyAccount.addGestureRecognizer(gestureMyAccount)
        btnBottomHelp.addGestureRecognizer(gestureHelp)
        
    }
    
    @objc fileprivate func goback(_ sender: UIBarButtonItem) {
        print("working")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getUnreadPushCount()
    }
    
    func initialSettings() {
        
        self.getProfile()
        
        savePlaceholderArr = [savePlaceholder1,savePlaceholder2,savePlaceholder3,savePlaceholder4]
        reasonPlaceholderArr = [reasonPlaceholder1,reasonPlaceholder2,reasonPlaceholder3,reasonPlaceholder4]
        
        //IQKeyboardManager.shared.enable = false
        txtSignDD.text = Singletone.shareInstance.signArray[0]
        txtSignOpt = Singletone.shareInstance.signOptArray[0]
        txtFontOpt = "Select Font"//Singletone.shareInstance.fontOptArray[0]
        txtGen = "Display Signature As"
        txtInitialSignOpt = Singletone.shareInstance.signOptArray[0]
        txtInitialFontOpt = Singletone.shareInstance.fontArray[0]
        txtInitGen = "Display Initials As"
        txtSaveOpt = "Saving as"
        
        let FullName = UserDefaults.standard.string(forKey: "FullName")
        let fName: String = UserDefaults.standard.string(forKey: "FName")!
        let lName: String = UserDefaults.standard.string(forKey: "LName")!
        let f1: String = String(fName.prefix(1))
        let l1: String = String(lName.prefix(1))
        
        let initial = "\(f1) \(l1)"
        
        let cnt = userSignArray.count
        
        Singletone.shareInstance.signObjectArray.removeAll()
        Singletone.shareInstance.signObjectArray = []
        
        for i in cnt..<3 {
            
        let signObj = SignObject()
        signObj.signOpt = Singletone.shareInstance.signOptArray[0]
        if i == 0 {
            signObj.signDisp = FullName//""
        } else {
            signObj.signDisp = ""
        }
        signObj.signFont = ""//Singletone.shareInstance.fontOptArray[0]
        //signObj.signImg = UIImage()
        signObj.signDrawLines = []
        signObj.signPathArr = []
        signObj.initialPathArr = []
        signObj.initialOpt = Singletone.shareInstance.signOptArray[0]
        signObj.initialFont = ""//Singletone.shareInstance.fontOptArray[0]
        
        if i == 0 {
            signObj.initialDisp = initial//""
        } else {
            signObj.initialDisp = ""
        }
            
        //signObj.initialImg = UIImage()
        signObj.initialDrawLines = []
        signObj.signColor = UIColor.black
        signObj.signFontSize = 1
        signObj.saveOpt = "Saving as"
        signObj.saveOptVal1 = ""
        signObj.saveOptVal2 = ""
        signObj.saveOptVal3 = ""
        signObj.isDefault = false//true
        Singletone.shareInstance.signObjectArray.append(signObj)
        }
        
        selSign = Singletone.shareInstance.signArray[0]
        prevSelSign = Singletone.shareInstance.signArray[0]
        selSignObject = Singletone.shareInstance.signObjectArray[0]
        //selSignObject?.isDefault = false//true
        //pickerDataArray = Singletone.shareInstance.fontArray
        //fontPicker.reloadAllComponents()
        fontPicker.isHidden = true
        fontPickerView.isHidden = true
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        whtsFlag = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if !whtsFlag {
            Singletone.shareInstance.signObjectArray.removeAll()
            Singletone.shareInstance.signObjectArray = []
        }
    }
    
    func resetSignObj() {
        
        selSignObject = SignObject()
        selSignObject?.signOpt = Singletone.shareInstance.signOptArray[0]
        selSignObject?.signDisp = ""
        selSignObject?.signFont = ""//Singletone.shareInstance.fontOptArray[0]
        //signObj.signImg = UIImage()
        selSignObject?.signDrawLines = []
        selSignObject?.initialOpt = Singletone.shareInstance.signOptArray[0]
        selSignObject?.initialFont = ""//Singletone.shareInstance.fontOptArray[0]
        selSignObject?.initialDisp = ""
        //signObj.initialImg = UIImage()
        selSignObject?.initialDrawLines = []
        selSignObject?.signPathArr = []
        selSignObject?.initialPathArr = []
        selSignObject?.signColor = UIColor.black
        selSignObject?.signFontSize = 1
        selSignObject?.saveOpt = "Saving as"
        selSignObject?.saveOptVal1 = ""
        selSignObject?.saveOptVal2 = ""
        selSignObject?.saveOptVal3 = ""
        //selSignObject?.isDefault = false//true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableViewList.dequeueReusableCell(withIdentifier: "signLblCell") as! CustomCell
        
        if indexPath.row == 0 {
            (cell ).defaultVal.addTarget(self, action: #selector(onDefaultValChanged), for: UIControl.Event.valueChanged)
            (cell ).defaultVal.isOn = selSignObject?.isDefault ?? false
        }
        if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12  {
            cell = tableViewList.dequeueReusableCell(withIdentifier: "dropdwnCell") as! CustomCell
         
            if indexPath.row == 1 {
                (cell ).txtDD.accessibilityHint = "signOpt"
                (cell ).txtDD.placeholder = txtSignOpt
                (cell ).txtDD.text = selSignObject?.signOpt ?? "" //txtSignOpt
                (cell).txtDD.font = UIFont.systemFont(ofSize: 17)
                //(cell as! CustomCell).txtDD.rightView = UIImageView(image: UIImage(named: "down"))
            }
            if indexPath.row == 2 {
                (cell ).txtDD.accessibilityHint = "handsign"
                (cell).txtDD.placeholder = txtGen
                (cell).txtDD.text = selSignObject?.signDisp ?? "" //txtGen
                (cell).txtDD.rightView = nil
                (cell).txtDD.font = UIFont.systemFont(ofSize: 17)
                
            }
            if indexPath.row == 3 {
                (cell).txtDD.accessibilityHint = "fontOpt"
                (cell).txtDD.placeholder = txtFontOpt
                (cell).txtDD.text = txtFontOpt //selSignObject?.signDisp//txtFontOpt
                cell.txtDD.font = UIFont.systemFont(ofSize: 17)
                
                
            }
            if indexPath.row == 11 {
                cell = tableViewList.dequeueReusableCell(withIdentifier: "reasonCell") as! CustomCell
                
            }
            if indexPath.row == 2 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 {
                
                cell.txtDD.rightView = nil
                cell.txtDD.rightImage = nil
                
            } else {
                cell.txtDD.rightImage = UIImage(named: "down")
            }
            cell.txtDD.delegate = self
        }
        
        if indexPath.row == 4  {
            cell = tableViewList.dequeueReusableCell(withIdentifier: "signViewCell") as! CustomCell
            
            let drawview = cell.drawview
            cell.delegate = self
            
            if signUpdate {
                drawview?.reset()
            }
            
            cell.signatureBorder.layer.masksToBounds = false
            cell.signatureBorder.layer.borderColor = UIColor.lightGray.cgColor
            cell.signatureBorder.layer.borderWidth = 1
            
            
            if selSignOpt == 1 {
                cell.lblGen.isHidden = false
                drawview?.isUserInteractionEnabled = false
                drawview?.isHidden = true
                let signfont = selSignObject?.signFont
                var font = UIFont.systemFont(ofSize: 30)
                if signfont != nil && !(signfont?.isEmpty)! {
                    if let fontone = UIFont(name: (selSignObject!.signFont!), size: (selSignObject?.signFontSize)!+30) {
                        font = fontone
                    }
                }
                print(font)
                cell.lblGen.adjustsFontSizeToFitWidth = true
                cell.lblGen.minimumScaleFactor = 0.2
                cell.lblGen.font = font
                cell.lblGen.textColor = selSignObject?.signColor ?? UIColor.black
                cell.lblGen.text = selSignObject?.signDisp ?? "" //txtGen
            
                if selSignObject?.signImg == nil {
                    
                    selSignObject?.signImg = cell.captureImg(label: cell.lblGen, initial: false)
                }
            }
            if selSignOpt == 2 {
                cell.lblGen.isHidden = true
                drawview?.isUserInteractionEnabled = true
                drawview?.isHidden = false
                //selSignObject?.signDrawLines = (drawview?.lines)!
                
                if selSign != prevSelSign {
                    //drawview?.reset()
                }
                if signUpdate {
                    drawview?.reset()
                    signUpdate = false
                }
                
                if (selSignObject?.colorUpdate)! {
                
                    drawview?.reset()
                    //drawview?.changePathColor()
                }
                
                drawview?.lines = (selSignObject?.signDrawLines)!
                drawview?.lineColor = selSignObject?.signColor ?? UIColor.black
                drawview?.signPathArr = (selSignObject?.signPathArr)!
                
                //if !(selSignObject?.colorUpdate)! {
                    drawview?.createPath()
                /*} else {
                    drawview?.updatePath()
                }*/
                
                drawview?.setNeedsDisplay()
                
                if selSignObject?.signImg == nil {
                    selSignObject?.signImg = cell.captureImg(view: drawview!)
                }
            }
            //drawview?.layer.borderColor = UIColor.white.cgColor
            //drawview?.layer.borderWidth = 1.0
            drawview?.delegate = self
            drawview?.lineColor = selSignObject?.signColor ?? UIColor.black//signColor
            drawview?.lineW = selSignObject?.signFontSize ?? 1//signFont
            drawview?.setNeedsDisplay()
        }
        if indexPath.row == 5  {
            cell = tableViewList.dequeueReusableCell(withIdentifier: "lblInitialCell") as! CustomCell
        }
        if indexPath.row == 6  {
            
            cell = tableViewList.dequeueReusableCell(withIdentifier: "initialViewCell") as! CustomCell
            cell.delegate = self
            
            let drawview = (cell).drawview
            
            if signUpdate {
                drawview?.reset()
            }
            
            (cell).txtDD.accessibilityHint = "initialSignOpt"
            (cell).txtFFDD.accessibilityHint = "initialFontOpt"
            (cell ).txtDispSign.accessibilityHint = "initialHandsign"
            
            //(cell as! CustomCell).txtDD.rightView = UIImageView(image: UIImage(named: "down"))
            //(cell as! CustomCell).txtFFDD.rightView = UIImageView(image: UIImage(named: "down"))
            
            (cell).txtDD.delegate = self
            (cell).txtFFDD.delegate = self
            (cell).txtDispSign.delegate = self
            
            (cell).txtDD.placeholder = txtSignOpt
            (cell).txtDD.text = selSignObject?.initialOpt//txtInitialSignOpt
            (cell).txtFFDD.placeholder = txtFontOpt
            cell.txtFFDD.text = txtFontOpt//selSignObject?.initialDisp//txtInitialFontOpt
            cell.txtFFDD.font = UIFont.systemFont(ofSize: 17)
            cell.txtDD.font = UIFont.systemFont(ofSize: 17)
           
            
            cell.txtDispSign.placeholder = txtInitGen
            cell.txtDispSign.text = selSignObject?.initialDisp//txtInitGen
            cell.txtDispSign.font = UIFont.systemFont(ofSize: 17)
            
            cell.initialBorder.layer.masksToBounds = false
            cell.initialBorder.layer.borderColor = UIColor.lightGray.cgColor
            cell.initialBorder.layer.borderWidth = 1
            
            if selInSignOpt == 1 {
                cell.txtDispSign.isHidden = false
                cell.txtFFDD.isHidden = false
                
                cell.lblGen.isHidden = false
                drawview?.isUserInteractionEnabled = false
                drawview?.isHidden = true
                let initialFont = selSignObject?.initialFont
                var font = UIFont.systemFont(ofSize: 30)
                if initialFont != nil && !(initialFont?.isEmpty)! {
                    if let fontone = UIFont(name: (selSignObject!.signFont!), size: (selSignObject?.signFontSize)!+30) {
                        font = fontone
                    }
                }
                print(font)
                cell.lblGen.adjustsFontSizeToFitWidth = true
                cell.lblGen.minimumScaleFactor = 0.2
                cell.lblGen.font = font
                cell.lblGen.textAlignment = .center
                cell.lblGen.textColor = selSignObject?.signColor ?? UIColor.black //signColor
//                cell.lblGen.layer.borderColor = UIColor.lightGray.cgColor
//                cell.lblGen.layer.borderWidth = 1.0
                
                cell.lblGen.text = selSignObject?.initialDisp ?? ""//txtInitGen
                
                if selSignObject?.initialImg == nil {
                //if cell.lblGen.text != selSignObject?.initialDisp {
                    selSignObject?.initialImg = cell.captureImg(label: cell.lblGen, initial: true)
                }
                
                
            }
            if selInSignOpt == 2 {
                (cell).txtDispSign.isHidden = true
                (cell).txtFFDD.isHidden = true
                
                cell.lblGen.isHidden = true
                drawview?.isUserInteractionEnabled = true
                drawview?.isHidden = false
                
                if selSign != prevSelSign {
                    //drawview?.reset()
                }
                if initialUpdate {
                    drawview?.reset()
                    initialUpdate = false
                }
                
                if (selSignObject?.colorUpdate)! {
                    
                    drawview?.reset()
                    //drawview?.changePathColor()
                }
                
                drawview?.lines = (selSignObject?.initialDrawLines)!
                
                drawview?.signPathArr = (selSignObject?.initialPathArr)!
                drawview?.lineColor = selSignObject?.signColor ?? UIColor.black
                
                //if !(selSignObject?.colorUpdate)! {
                    drawview?.createPath()
                /*} else {
                    drawview?.updatePath()
                }*/
                
                drawview?.setNeedsDisplay()
                
                if selSignObject?.initialImg == nil {
                    //if cell.lblGen.text != selSignObject?.initialDisp {
                    selSignObject?.initialImg = cell.captureImg(view: drawview!)
                }
            }
            drawview?.layer.borderColor = UIColor.black.cgColor
            drawview?.layer.borderWidth = 1.0
            drawview?.delegate = self
            drawview?.lineColor = selSignObject?.signColor ?? UIColor.black//signColor
            drawview?.lineW = selSignObject?.signFontSize ?? 1//signFont
            drawview?.setNeedsDisplay()
        }
        if indexPath.row == 7 || indexPath.row == 8 {
            cell = tableViewList.dequeueReusableCell(withIdentifier: "sliderCell") as! CustomCell
            
            cell.colorSlider.isContinuous = false
            let imgIcon = cell.viewWithTag(5) as! UIImageView
            
            if indexPath.row == 7 {
                
                cell.colorSlider.isHidden = false
                cell.colorSlider.color = (selSignObject?.signColor)
                imgIcon.image = UIImage(named: "colorIcon")
                cell.fontSlider.isHidden = true
                cell.delegate = self
            }
            if indexPath.row == 8 {
                cell.colorSlider.isHidden = true
                cell.fontSlider.isHidden = false
                cell.delegate = self
                imgIcon.image = UIImage(named: "edit-black")
                
                if selSignOpt == 2 {
                    cell.fontSlider.minimumValue = Float(minFontVal)
                    cell.fontSlider.maximumValue = Float(maxFontVal)
                }
                else if selInSignOpt == 2 {
                    cell.fontSlider.minimumValue = Float(minInFontVal)
                    cell.fontSlider.maximumValue = Float(maxInFontVal)
                }
                cell.fontSlider.value = Float(selSignObject?.signFontSize ?? 1)
            }
        }
        if indexPath.row == 9 {
            //(cell as! CustomCell).txtDD.rightView = UIImageView(image: UIImage(named: "down"))
            cell.txtDD.placeholder = txtSaveOpt
            cell.txtDD.text = selSignObject?.saveOpt//txtSaveOpt
            cell.txtDD.accessibilityHint = "saveOpt"
            cell.txtDD.font = UIFont.systemFont(ofSize: 17)
            
        }
        if indexPath.row == 10 {
            
            cell.txtDD.text = selSignObject?.saveOptVal1//saveOpt1
            cell.txtDD.placeholder = savePlaceholderArr[saveOptIndex]
           
            cell.txtDD.accessibilityHint = "saveOpt1"
            cell.txtDD.font = UIFont.systemFont(ofSize: 17)
        }
        if indexPath.row == 11 {
            
            cell.txtDD.text = selSignObject?.saveOptVal2//saveOpt2
            cell.txtDD.placeholder = reasonPlaceholderArr[saveOptIndex]
            cell.txtDD.accessibilityHint = "saveOpt2"
            cell.txtDD.font = UIFont.systemFont(ofSize: 17)
        }
        if indexPath.row == 12 {
            
            cell.txtDD.text = selSignObject?.saveOptVal3//saveOpt3
            cell.txtDD.placeholder = ""
            cell.txtDD.accessibilityHint = "saveOpt3"
            cell.txtDD.font = UIFont.systemFont(ofSize: 17)
        }
        if indexPath.row == 13  {
            cell = tableViewList.dequeueReusableCell(withIdentifier: "buttonCell") as! CustomCell
            cell.btnSave.addTarget(self, action: #selector(saveData), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selSignOpt == 2 {
            if indexPath.row == 2 || indexPath.row == 3 {
                return 0
            }
        }
        if indexPath.row == 4  {
            return 150
        }
        if indexPath.row == 6  {
            return 200
        }
        if indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 {
            if selSignObject?.saveOpt == "Saving as" || selSignObject?.saveOpt == "" {
                return 0
            } else {
                
                let saveoption = selSignObject?.saveOpt?.trimmingCharacters(in: .whitespacesAndNewlines)
                
                guard let saveOptIndex = Singletone.shareInstance.saveOptArray.index(of: saveoption!) else {
                    return 0
                }
                if indexPath.row == 12 && saveOptIndex < 3 {
                    return 0
                }
                if indexPath.row == 11 {
                    return 80
                }
                return 40
            }
            
        }
        if (selSignOpt == 1 && selInSignOpt == 1) && indexPath.row == 8  {
            return 0
        }
        
        if indexPath.row == 11 {
            return 80
        }
        
        return 40
    }
    
    @objc func touchHappen(_ sender: UITapGestureRecognizer) {
        print("Tap On Image")
        
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        let s = sender.view?.tag
        print(s!)
        
        switch s! {
        case 100:
            //viewSearchBar.isHidden = true
            
            viewBottomDashborad.backgroundColor = Singletone.shareInstance.footerviewBackgroundGreen
            //viewBottomStart.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomSearch.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            viewBottomMyAccount.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            btnBottomHelp.backgroundColor = Singletone.shareInstance.footerviewBackgroundWhite
            
            imgDashboard.image = UIImage(named: "dashboard_white_bottom_bar_icon")  //dashboard_white_bottom_bar_icon
            //imgStart.image = UIImage(named: "launch_green_bottom_bar_icon")  //launch_white_bottom_bar_icon
            //imgSearch.image = UIImage(named: "search_green_icon")  //search_white_icon
            imgMyAccount.image = UIImage(named: "landing_screen_signup_green_icon")  //landing_screen_signup_icon
            imgHelp.image = UIImage(named: "help_green_icon")  //help_white_icon
            
            lblDashboard.textColor = Singletone.shareInstance.footerviewBackgroundWhite
            //lblStart.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblSearch.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblMyAccount.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            lblHelp.textColor = Singletone.shareInstance.footerviewBackgroundGreen
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            performSegue(withIdentifier: "segBackDashboard", sender: self)
            
            break
        case 101:
            //viewSearchBar.isHidden = true
            
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
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 102:
            //viewSearchBar.isHidden = false
            
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
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            
            break
        case 103:
            //viewSearchBar.isHidden = true
            
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
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            //performSegue(withIdentifier: "segCancel", sender: self)
            self.navigationController?.popViewController(animated: false)
            break
        case 104:
            //viewSearchBar.isHidden = true
            
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
            
            UserDefaults.standard.set("MyAccount", forKey: "footerFlag")
            performSegue(withIdentifier: "segContactUs", sender: self)
            break
        default:
            break
        }
    }
    @IBAction func btnBackAction(_ sender: Any) {
        //performSegue(withIdentifier: "segCancel", sender: self)
        Singletone.shareInstance.signObjectArray.removeAll()
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func goBack() {
        Singletone.shareInstance.signObjectArray.removeAll()
        
        let profComplStat:Int = UserDefaults.standard.value(forKey: "ProfileStatus") as? Int ?? 1
        
        //if self.profstat != 6 &&  self.profstat != nil {
        if profComplStat != 6  {
            performSegue(withIdentifier: "segBackDashboard", sender: self)
        } else {
            self.navigationController?.popViewController(animated: false)
        }
    }
    
    @IBAction func sliderDidChange(_ sender: RGSColorSlider) {
        
        (drawView as? DrawView)!.lineColor = sender.color
        //(drawView as? DrawView)!.lineW =
        (drawView as? DrawView)!.setNeedsDisplay()
    }
    
    @IBAction func sizeChanged(_ sender: UISlider) {
        
        selSignObject?.signFontSize = CGFloat(sender.value)
        (drawView as? DrawView)!.lineW = CGFloat(sender.value)
        (drawView as? DrawView)!.setNeedsDisplay()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("managesignvc touches")
        //lastPoint = touches.first?.location(in: self)
        
        tableViewList.isScrollEnabled = true
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        self.next?.touchesEnded(touches, with: event)
    }
    
    func onSelectCell(view: UIView) {
        print("view tag: \(view.tag)")
        if view.tag == 143 || view.tag == 413 {
            tableViewList.isScrollEnabled = false
        } else {
            tableViewList.isScrollEnabled = true
        }
        //selSignObject?.signDrawLines = 
    }
    
    func sliderValueChanged(type: String, value: AnyObject) {
        
        //signUpdate = false
        
        let indexpath1 = IndexPath(row: 4, section: 0)
        let indexpath2 = IndexPath(row: 6, section: 0)
        var arrIdxPath: [IndexPath] = []
        
        if type == "color" {
            signColor = value as! UIColor
            selSignObject?.signColor = signColor
            selSignObject?.colorUpdate = true
            
            arrIdxPath.append(indexpath1)
            arrIdxPath.append(indexpath2)
        }
        if type == "font" {
            signFont = value as! CGFloat
            selSignObject?.signFontSize = signFont
            
            if selSignOpt == 2 {
                arrIdxPath.append(indexpath1)
            }
            if selInSignOpt == 2 {
                arrIdxPath.append(indexpath2)
            }
        }
        
        
        selSignObject?.signImg = nil
        selSignObject?.initialImg = nil
        
        
        tableViewList.reloadRows(at: arrIdxPath, with: UITableView.RowAnimation.none)
    }
    
    //textfield delegates
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let charset = CharacterSet(charactersIn: Singletone.shareInstance.acceptableCharset).inverted
        let filtered: String = (string.components(separatedBy: charset) as NSArray).componentsJoined(by: "")
        
        if textField.accessibilityHint == "initialHandsign" {
            
            if range.location == 3 {
                return false
            }
            return (string == filtered)
        } else {
        
        return (string == filtered)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.accessibilityHint == "handsign" {
            return true
        }
        if textField == txtSignDD {
            self.showDropDown(optArr: Singletone.shareInstance.signArray, type: "sign")
            return false
        }
        if textField.accessibilityHint == "signOpt"  {
            //self.showDropDown(optArr: Singletone.shareInstance.signOptArray, type: "signOpt")
            self.setPickerData(dataArr: Singletone.shareInstance.signOptArray, type: "signOpt")
            fontPicker.reloadAllComponents()
            fontPickerView.isHidden = false
            fontPicker.isHidden = false
            return false
        }
        if textField.accessibilityHint == "fontOpt" {
            //var arrFont = Singletone.shareInstance.fontOptArray
            
            if selSignOpt == 1 && !txtGen.isEmpty {
                //arrFont = [txtGen,txtGen,txtGen,txtGen]
            }
            //self.showDropDown(optArr: arrFont, type: "fontOpt")
            //self.customDropDown(optArr: arrFont)
            if (selSignObject?.signDisp?.isEmpty)! {
                self.setPickerData(dataArr: Singletone.shareInstance.fontArray, type: "fontOpt")
            } else {
                let arr = [selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp,selSignObject?.signDisp]
                self.setPickerData(dataArr: arr as! [String], type: "fontOpt")
            }
            fontPicker.reloadAllComponents()
            fontPickerView.isHidden = false
            fontPicker.isHidden = false
            return false
        }
        if textField.accessibilityHint == "initialSignOpt"  {
            //self.showDropDown(optArr: Singletone.shareInstance.signOptArray, type: "initialSignOpt")
            self.setPickerData(dataArr: Singletone.shareInstance.signOptArray, type: "initialSignOpt")
            fontPicker.reloadAllComponents()
            fontPickerView.isHidden = false
            fontPicker.isHidden = false
            return false
        }
        if textField.accessibilityHint == "initialFontOpt" {
            //self.showDropDown(optArr: Singletone.shareInstance.fontOptArray, type: "initialFontOpt")
            if (selSignObject?.initialDisp?.isEmpty)! {
                self.setPickerData(dataArr: Singletone.shareInstance.fontArray, type: "initialFontOpt")
            } else {
                let arr = [selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp,selSignObject?.initialDisp]
                self.setPickerData(dataArr: arr as! [String], type: "initialFontOpt")
            }
            fontPicker.reloadAllComponents()
            fontPickerView.isHidden = false
            fontPicker.isHidden = false
            return false
        }
        if textField.accessibilityHint == "saveOpt" {
            //self.showDropDown(optArr: Singletone.shareInstance.saveOptArray, type: "saveOpt")
            self.setPickerData(dataArr: Singletone.shareInstance.saveOptArray, type: "saveOpt")
            fontPicker.reloadAllComponents()
            fontPickerView.isHidden = false
            fontPicker.isHidden = false
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.accessibilityHint == "handsign" {
            
            //txtGen = textField.text!
            //selSignObject?.signOpt = textField.text!
            selSignObject?.signDisp = textField.text!
            selSignObject?.signImg = nil
            
            let arr = [textField.text!,textField.text!,textField.text!,textField.text!]
            self.setPickerData(dataArr: arr, type: "fontOpt")
            fontPicker.reloadAllComponents()
            
            let indexpath1 = IndexPath(row: 4, section: 0)
            tableViewList.reloadRows(at: [indexpath1], with: UITableView.RowAnimation.none)
            
            
        }
        if textField.accessibilityHint == "initialHandsign" {
            
            //txtInitGen = textField.text!
            //selSignObject?.initialOpt = textField.text!
            selSignObject?.initialDisp = textField.text!//txtInitGen
            selSignObject?.initialImg = nil
            
            let arr = [textField.text!,textField.text!,textField.text!,textField.text!]
            self.setPickerData(dataArr: arr, type: "initialFontOpt")
            fontPicker.reloadAllComponents()
            
            
            let indexpath1 = IndexPath(row: 6, section: 0)
            tableViewList.reloadRows(at: [indexpath1], with: UITableView.RowAnimation.none)
        }
        if textField.accessibilityHint == "saveOpt1" {
            saveOpt1 = textField.text!
            selSignObject?.saveOptVal1 = saveOpt1
        }
        if textField.accessibilityHint == "saveOpt2" {
            saveOpt2 = textField.text!
            selSignObject?.saveOptVal2 = saveOpt2
        }
        if textField.accessibilityHint == "saveOpt3" {
            saveOpt3 = textField.text!
            selSignObject?.saveOptVal3 = saveOpt3
        }
    }
    
    override func onSelectOption(selOpt: String, type: String) {
        
        //signUpdate = false
        
        let test = Singletone.shareInstance.signOptArray
        
        
        if type == "sign" {
            
            signUpdate = true
            initialUpdate = true
            //if self.validateFields() {
                txtSignDD.text = selOpt
            
                // copy prev sign data
                let previndex = Singletone.shareInstance.signArray.index(of: prevSelSign)
            if previndex! < Singletone.shareInstance.signObjectArray.count {
                Singletone.shareInstance.signObjectArray[previndex!] = selSignObject!
            }
            
                selSign = selOpt
            
                let indexpath1 = IndexPath(row: 4, section: 0)
                let indexpath2 = IndexPath(row: 6, section: 0)
            
                //tableViewList.reloadRows(at: [indexpath1,indexpath2], with: UITableViewRowAnimation.none)
            
                prevSelSign = selOpt
            
                let index = Singletone.shareInstance.signArray.index(of: selSign)
                selSignIndex = index!
            
                resetSignObj()
            
            if index != nil {
                let selexists = Singletone.shareInstance.signObjectArray.indices.contains(index!)
                if selexists {
                    selSignObject = Singletone.shareInstance.signObjectArray[index!]
                }
            }
                
            
            print("index: \(index)")
            print("selSignObject signDisp: \(selSignObject?.signDisp)")
            
            if let index = Singletone.shareInstance.signOptArray.index(of: (selSignObject?.signOpt ?? "")!)
            {
                selSignOpt = index + 1
            } else {
                selSignOpt = 0
            }
            if let index = Singletone.shareInstance.signOptArray.index(of: (selSignObject?.initialOpt ?? "")!)
            {
                selInSignOpt = index + 1
            } else {
                selInSignOpt = 0
            }
            //selInSignOpt = selSignOpt
            
            self.perform(#selector(reloadTable(arrIndex:)), with: [indexpath1,indexpath2], afterDelay: 0.5)
            
            
            
            //}
        }
        if type == "signOpt" {
            txtSignOpt = selOpt
            txtInitialSignOpt = selOpt
            
            selSignObject?.signOpt = selOpt
            selSignObject?.initialOpt = selOpt
            
            let indexpath1 = IndexPath(row: 1, section: 0)
            let indexpath2 = IndexPath(row: 4, section: 0)
            let indexpath3 = IndexPath(row: 8, section: 0)
            let indexpath4 = IndexPath(row: 6, section: 0)
            
            let index = Singletone.shareInstance.signOptArray.index(of: selOpt)
            selSignOpt = index! + 1
            selInSignOpt = selSignOpt
            
            if selSignOpt == 1 {
                minFontVal = 17
                maxFontVal = 37
                signFont = 17
            }
            if selSignOpt == 2 {
                minFontVal = 1
                maxFontVal = 5
                signFont = 1
            }
            
            selSignObject?.signImg = nil
            selSignObject?.initialImg = nil
            
            tableViewList.reloadRows(at: [indexpath1,indexpath2,indexpath3,indexpath4], with: UITableView.RowAnimation.none)
            
        }
        if type == "fontOpt" {
            //txtFontOpt = selOpt
            
            let indexpath1 = IndexPath(row: 3, section: 0)
            let indexpath2 = IndexPath(row: 4, section: 0)
            
            let index = pickerDataArray.index(of: selOpt)
            selFont = Singletone.shareInstance.fontArray[index!]
            selSignObject?.signFont = selFont
            fontPicker.isHidden = true
            fontPickerView.isHidden = true
            tableViewList.reloadRows(at: [indexpath1,indexpath2], with: UITableView.RowAnimation.none)
            
        }
        if type == "initialSignOpt" {
            txtInitialSignOpt = selOpt
            selSignObject?.initialOpt = selOpt
            
            let indexpath1 = IndexPath(row: 6, section: 0)
            let indexpath2 = IndexPath(row: 8, section: 0)
            
            let index = Singletone.shareInstance.signOptArray.index(of: selOpt)
            selInSignOpt = index! + 1
            
            if selInSignOpt == 1 {
                minInFontVal = 17
                maxInFontVal = 37
                signFont = 17
            }
            if selInSignOpt == 2 {
                minInFontVal = 1
                maxInFontVal = 5
                signFont = 1
            }
            
            tableViewList.reloadRows(at: [indexpath1,indexpath2], with: UITableView.RowAnimation.none)
            
        }
        if type == "initialFontOpt" {
            txtInitialFontOpt = selOpt
            selSignObject?.initialFont = selOpt
            
            let indexpath1 = IndexPath(row: 6, section: 0)
            
            let index = pickerDataArray.index(of: selOpt)
            selInFont = Singletone.shareInstance.fontArray[index!]
            
            selSignObject?.initialFont = selInFont
            fontPicker.isHidden = true
            fontPickerView.isHidden = true
            tableViewList.reloadRows(at: [indexpath1], with: UITableView.RowAnimation.none)
        }
        if type == "saveOpt" {
            txtSaveOpt = selOpt
            selSignObject?.saveOpt = txtSaveOpt
            saveOptIndex = Singletone.shareInstance.saveOptArray.index(of: selOpt)!
            let indexpath1 = IndexPath(row: 9, section: 0)
            tableViewList.reloadRows(at: [indexpath1], with: UITableView.RowAnimation.none)
        }
    }
    
    @objc func reloadTable(arrIndex: [IndexPath]) {
        
        tableViewList.reloadRows(at: arrIndex, with: UITableView.RowAnimation.none)
        tableViewList.reloadData()
    }
    
    override func onSelectFontOption(selOpt: Int, type: String) {
        
        //signUpdate = false
        
        if type == "fontOpt" {
            //txtFontOpt = Singletone.shareInstance.fontArray[selOpt]
            
            let indexpath1 = IndexPath(row: 3, section: 0)
            let indexpath2 = IndexPath(row: 4, section: 0)
            
            let index = selOpt
            selFont = Singletone.shareInstance.fontArray[index]
            selSignObject?.signFont = selFont
            fontPicker.isHidden = true
            fontPickerView.isHidden = true
            
            selSignObject?.signImg = nil
            
            tableViewList.reloadRows(at: [indexpath1,indexpath2], with: UITableView.RowAnimation.none)
            
        }
        if type == "initialFontOpt" {
            txtInitialFontOpt = Singletone.shareInstance.fontArray[selOpt]
            selSignObject?.initialFont = Singletone.shareInstance.fontArray[selOpt]
            
            let indexpath1 = IndexPath(row: 6, section: 0)
            
            let index = selOpt
            selInFont = Singletone.shareInstance.fontArray[index]
            
            selSignObject?.initialFont = selInFont
            fontPicker.isHidden = true
            fontPickerView.isHidden = true
            
            selSignObject?.initialImg = nil
            
            tableViewList.reloadRows(at: [indexpath1], with: UITableView.RowAnimation.none)
        }
        
        if type == "signOpt" {
            if selOpt < Singletone.shareInstance.signOptArray.count {
                
                txtSignOpt = Singletone.shareInstance.signOptArray[selOpt]
                txtInitialSignOpt = Singletone.shareInstance.signOptArray[selOpt]
                
                selSignObject?.signOpt = Singletone.shareInstance.signOptArray[selOpt]
                selSignObject?.initialOpt = Singletone.shareInstance.signOptArray[selOpt]
                
                let indexpath1 = IndexPath(row: 1, section: 0)
                let indexpath2 = IndexPath(row: 4, section: 0)
                let indexpath3 = IndexPath(row: 8, section: 0)
                let indexpath4 = IndexPath(row: 6, section: 0)
                
                let index = selOpt
                selSignOpt = index + 1
                selInSignOpt = selSignOpt
                
                if selSignOpt == 1 {
                    minFontVal = 17
                    maxFontVal = 37
                    signFont = 17
                }
                if selSignOpt == 2 {
                    minFontVal = 1
                    maxFontVal = 5
                    signFont = 1
                }
                fontPicker.isHidden = true
                fontPickerView.isHidden = true
                
                // 4 April updates
                selSignObject?.signImg = nil
                selSignObject?.initialImg = nil
                
                tableViewList.reloadRows(at: [indexpath1,indexpath2,indexpath3,indexpath4], with: UITableView.RowAnimation.none)
            }
        }
        if type == "initialSignOpt" {
            //txtSignOpt = Singletone.shareInstance.signOptArray[selOpt]
            if selOpt < Singletone.shareInstance.signOptArray.count {
                
                txtInitialSignOpt = Singletone.shareInstance.signOptArray[selOpt]
                
                //selSignObject?.signOpt = Singletone.shareInstance.signOptArray[selOpt]
                selSignObject?.initialOpt = Singletone.shareInstance.signOptArray[selOpt]
                
                
                let indexpath3 = IndexPath(row: 8, section: 0)
                let indexpath4 = IndexPath(row: 6, section: 0)
                
                let index = selOpt
                //selSignOpt = index + 1
                selInSignOpt = index + 1
                
                if selSignOpt == 1 {
                    minFontVal = 17
                    maxFontVal = 37
                    signFont = 17
                }
                if selSignOpt == 2 {
                    minFontVal = 1
                    maxFontVal = 5
                    signFont = 1
                }
                fontPicker.isHidden = true
                fontPickerView.isHidden = true
                tableViewList.reloadRows(at: [indexpath3,indexpath4], with: UITableView.RowAnimation.none)
                
            }
        }
        if type == "saveOpt" {
            
            if selOpt < Singletone.shareInstance.saveOptArray.count {
                
                txtSaveOpt = Singletone.shareInstance.saveOptArray[selOpt]
                selSignObject?.saveOpt = txtSaveOpt
                saveOptIndex = selOpt
                /*
                selSignObject?.saveOptVal1 = ""
                selSignObject?.saveOptVal2 = ""
                selSignObject?.saveOptVal3 = ""
                */
                let indexpath1 = IndexPath(row: 9, section: 0)
                let indexpath2 = IndexPath(row: 10, section: 0)
                let indexpath3 = IndexPath(row: 11, section: 0)
                tableViewList.reloadRows(at: [indexpath1,indexpath2,indexpath3], with: UITableView.RowAnimation.none)
            }
        }
    }
    
    override func onCancelOption() {
        
        fontPicker.isHidden = true
        fontPickerView.isHidden = true
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.onCancelOption()
    }
    
    func onDrawEnd(lines: [Line], tag: Int, img: UIImage) {
        if tag == 143 {
            selSignObject?.signDrawLines.append(contentsOf: lines)
            selSignObject?.signImg = img
        }
        if tag == 413 {
            selSignObject?.initialDrawLines.append(contentsOf: lines)
            selSignObject?.initialImg = img
        }
    
    }
    func onDrawEnd(pathArr: [SignaturePath], tag: Int, img: UIImage) {
        if tag == 143 {
            let img1 = resizeImagex(image: img, taragetSize: CGSize(width: 500, height: 100))
            selSignObject?.signPathArr.append(contentsOf: pathArr)
            selSignObject?.signImg = img1
        }
        if tag == 413 {
            //selSignObject?.initialDrawLines.append(contentsOf: lines)
            let img1 = resizeImagex(image: img, taragetSize: CGSize(width: 300, height: 100))
            selSignObject?.initialPathArr.append(contentsOf: pathArr)
            selSignObject?.initialImg = img1
        }
        
    }
    
    func onClearCell(tag: Int) {
        signUpdate = false
        initialUpdate = false
        
        if tag == 4 {
            selSignObject?.signPathArr = []
            selSignObject?.signDisp = ""
        }
        if tag == 6 {
            selSignObject?.initialPathArr = []
            selSignObject?.initialDisp = ""
        }
        let indexpath = IndexPath(row: tag, section: 0)
        tableViewList.reloadRows(at: [indexpath], with: UITableView.RowAnimation.none)
    }
    
    @objc func onDefaultValChanged(sender: UISwitch) {
        var cntr = 0
        for signObj in Singletone.shareInstance.signObjectArray {
            if sender.isOn {
                signObj.isDefault = false
            }
            if selSignIndex == cntr {
                signObj.isDefault = true
            }
            cntr = cntr + 1
        }
        selSignObject?.isDefault = sender.isOn
    }
    
    
    func validateFields()-> Bool {
        
        self.showActivityIndicatory(uiView: view)
        
        var errcnt = 0
        var errcnt1 = 0
        var errcnt2 = 0
        
        var cnt = 0
        var errmsg:String = ""
        var errmsg1:String = ""
        
        var msgarr: [String] = []
        //let signObj = selSignObject!
        
        for signObj in Singletone.shareInstance.signObjectArray {
            
            cnt = cnt + 1
            
            if (signObj.signDisp?.isEmpty)!  && signObj.signPathArr.isEmpty {
                errcnt = errcnt + 1
                let selOpt = signObj.signOpt
                
                let index = Singletone.shareInstance.signOptArray.index(of: selOpt!)
                if index == 0 {
                    errmsg = "Please enter signature \(cnt)"
                }
                if index == 1 {
                    errmsg = "Please draw signature \(cnt)"
                }
                if cnt < userSignArray.count + 1 {
                    msgarr.append(errmsg)
                }
                
            } else if (signObj.initialDisp == nil || (signObj.initialDisp?.isEmpty)!) && signObj.initialPathArr.isEmpty {
                errcnt1 = errcnt1 + 1
                let selOpt = signObj.initialOpt
                let index = Singletone.shareInstance.signOptArray.index(of: selOpt!)
                if index == 0 {
                    errmsg = "Please enter initials \(cnt)"
                }
                if index == 1 {
                    errmsg = "Please draw initials \(cnt)"
                }
                if cnt < userSignArray.count + 1 {
                    msgarr.append(errmsg)
                }
                if errcnt == 0 && errcnt1 == 0 {
                    continue
                }
            }
            else {
                finalSignDataArray.append(signObj)
            }
            if !(signObj.isDefault) {
                errcnt2 = errcnt2 + 1
                
            }
            
            
        }
        let arrcnt = Singletone.shareInstance.signObjectArray.count
        /*
        for signObj in Singletone.shareInstance.signObjectArray {
            if (!signObj.isDefault) {
                errcnt2 = errcnt2 + 1
                errmsg = "Select at least one signature as default"
            }
        }*/
        /*
         if errmsg.isEmpty && errcnt < 3 {
         for signObj in Singletone.shareInstance.signObjectArray {
         
         if !(signObj.isDefault) {
         errcnt2 = errcnt2 + 1
         
         }
         }
         }*/
        if errcnt2 == arrcnt {
            errmsg = "Select at least one signature as default"
            msgarr.append(errmsg)
        }
        
        if msgarr.count > 0 {
            errmsg1 = msgarr.joined(separator: "\n")
        }
        //if errcnt == arrcnt || errcnt1 == arrcnt || errcnt2 == 1 {
        if !errmsg1.isEmpty {
        //if errcnt2 == arrcnt || errcnt == arrcnt || errcnt1 == arrcnt {
            alertSample(strTitle: "", strMsg: errmsg1)
            self.stopActivityIndicator()
            return false
        //}
        }
        return true
    }
    // Save action
    
    @objc func saveData() {
        
        if self.validateFields() {
        //Singletone.shareInstance.showActivityIndicatory(uiView: view)
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Content-Type": "application/json", "Authorization" : "Bearer \(strAuth)"]
        
        
        print("***")
        //print("data:image/png;base64,\(strAbc)")
        print("***")
        
            var UserSignatures: [[String:Any]] = []
            
            for selSignobject in finalSignDataArray {
                
                let savestr = selSignobject.saveOpt ?? ""
                let saveopt = savestr.trimmingCharacters(in: .whitespacesAndNewlines)
                var saveAsTxt: String = ""
                var optindex = 0
                if let saveoptindex = Singletone.shareInstance.saveOptArray.index(of: saveopt) {
                    optindex = saveoptindex
                }
                saveAsTxt = saveopt//selSign.saveOpt!
                if optindex == 3 {
                    saveAsTxt = selSignobject.saveOptVal3 ?? ""
                }
                
                
                let signDescript = ["DescriptionKey": "\(optindex)",
                    "DescriptionText": saveAsTxt ?? "",
                                    "DescriptionValue": selSignobject.saveOptVal1 ?? "",
                                    "Reason": selSignobject.saveOptVal2 ?? ""]
                
                var signaturePath:[[String:Any]] = []
                
                if !(selSignobject.signPathArr.isEmpty) {
                    var cnt = 0
                    for line in (selSignobject.signPathArr) {
                        
                        let sx = (line.startPoint == nil || line.startPoint!.x.isNaN) ? 0 : line.startPoint!.x
                        let sy = (line.startPoint == nil || line.startPoint!.y.isNaN) ? 0 : line.startPoint!.y
                        let ex = (line.endPoint == nil || line.endPoint!.x.isNaN) ? 0 : line.endPoint!.x
                        let ey = (line.endPoint == nil || line.endPoint!.y.isNaN) ? 0 : line.endPoint!.y
                        
                        let c1x = (line.control1 == nil || line.control1!.x.isNaN) ? 0 : line.control1!.x
                        let c1y = (line.control1 == nil || line.control1!.y.isNaN) ? 0 : line.control1!.y
                        
                        let c2x = (line.control2 == nil || line.control2!.x.isNaN) ? 0 : line.control2!.x
                        let c2y = (line.control2 == nil || line.control2!.y.isNaN) ? 0 : line.control2!.y
                        
                        //signaturePath.append(signpath)
                        signaturePath.append(["startPoint":["x":sx,"y":sy],"endPoint":["x":ex,"y":ey],"control1":["x":c1x,"y":c1y],"control2":["x":c2x,"y":c2y]])
                        cnt = cnt + 1
                    }
                }
                
                var initialPath:[[String:Any]] = []
                
                if !(selSignobject.initialPathArr.isEmpty) {
                    
                    for line in (selSignobject.initialPathArr) {
                        
                        let sx = (line.startPoint == nil || line.startPoint!.x.isNaN) ? 0 : line.startPoint!.x
                        let sy = (line.startPoint == nil || line.startPoint!.y.isNaN) ? 0 : line.startPoint!.y
                        let ex = (line.endPoint == nil || line.endPoint!.x.isNaN) ? 0 : line.endPoint!.x
                        let ey = (line.endPoint == nil || line.endPoint!.y.isNaN) ? 0 : line.endPoint!.y
                        
                        let c1x = (line.control1 == nil || line.control1!.x.isNaN) ? 0 : line.control1!.x
                        let c1y = (line.control1 == nil || line.control1!.y.isNaN) ? 0 : line.control1!.y
                        
                        let c2x = (line.control2 == nil || line.control2!.x.isNaN) ? 0 : line.control2!.x
                        let c2y = (line.control2 == nil || line.control2!.y.isNaN) ? 0 : line.control2!.y
                        
                        //initialPath.append(signpath)
                        initialPath.append(["startPoint":["x":sx,"y":sy],"endPoint":["x":ex,"y":ey],"control1":["x":c1x,"y":c1y],"control2":["x":c2x,"y":c2y]])
                    }
                }
                
                //(selSignObject?.signImg?.base64(format: ImageFormat.PNG))!
                //(selSignObject?.initialImg?.base64(format: ImageFormat.PNG))!
                var encSignImg = ""
                var encInitImg = ""
                
                if selSignobject.signImg != nil {
                    let pngimage = selSignobject.signImg.pngData()
                    let testimage = UIImage(data: pngimage!)
                    encSignImg = (selSignobject.signImg?.base64(format: ImageFormat.PNG))!
                    encSignImg = "data:image/png;base64,\(encSignImg)"
                } else if selSignobject.signature != nil {
                    encSignImg = selSignobject.signature!
                }
                if selSignobject.initialImg != nil {
                    encInitImg = (selSignobject.initialImg?.base64(format: ImageFormat.PNG))!
                    encInitImg = "data:image/png;base64,\(encInitImg)"
                } else if selSignobject.initials != nil {
                    encInitImg = selSignobject.initials!
                }
                
                let index1 = Singletone.shareInstance.signOptArray.index(of: selSignobject.signOpt!)
                let signtype = Singletone.shareInstance.signOptDict[index1!]
                
                let index2 = Singletone.shareInstance.signOptArray.index(of: selSignobject.initialOpt!)
                let inittype = Singletone.shareInstance.signOptDict[index2!]
                
                //let signSize = 1.8//selSign.signFontSize/10
                //let initialSize = 1//selSign.signFontSize/10
                let pencolor: String = selSignobject.signColor?.toRGB() ?? "rgb(0,0,0)"
                
                let strSignSize = "1.8px"
                let strInitSize = "1px"
                var penWidth = selSignobject.signFontSize
                
//                if penWidth >= 2 {
//                    penWidth =
//                }
                if penWidth <= 0.6 {
                    penWidth = 0.6
                }
                
                let settings = [
                    "signatureImage": encSignImg,
                    "initialImage": encInitImg,
                    "signatureType": signtype,
                    "initialType": inittype,
                    "signaturetext": selSignobject.signDisp ?? "",
                    "initialtext": selSignobject.initialDisp ?? "",
                    "editProfilesignFont": selSignobject.signFont ?? "",
                    "editProfilesignFontsize": strSignSize,
                    "editProfileinitFont": selSignobject.initialFont ?? "",
                    "editProfileinitFontsize": strInitSize,
                    "signaturePath": signaturePath,
                    "initialPath": initialPath,
                    "signatureIsolatedPoints": "[]",
                    "initialIsolatedPoints": "[]",
                    "penWidth": Int(penWidth),//penWidth,//1.6,
                    "PenColor": pencolor, //?? "rgb(244,7,0)"
                    "penColorSliderPosition": 166,
                    "signatureWidth": 500,
                    "signatureHeight": 100,
                    "initialWidth": 100,
                    "initialHeight": 100
                    ] as [String : Any]
                
                UserSignatures.append([
                    "Signature": encSignImg, //selSign.signDisp!,
                    "Initials": encInitImg, //selSign.initialDisp!,
                    "SignatureDescription":signDescript,
                    "Settings":settings,
                    "IsDefault":selSignobject.isDefault,
                    "IsDeleted":false,
                    "UserSignatureId":selSignobject.userSignId ?? ""] as [String : Any])
            }
        
        
            var strPid = ZorroTempData.sharedInstance.getProfileId()
//            if strPid == "" {
//                strPid = ZorroTempData.sharedInstance.getProfileId()
//            }
        
            let parameter = ["ProfileId":strPid, "PinCode":"", "UserSignatures":UserSignatures] as [String : Any]
            /////
            print("parameter: \(parameter)")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: parameter, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            //print(jsonString)
            
            print("***")
            //print(parameter)
            
            print(jsonString)
            print("***")
            
        if Connectivity.isConnectedToInternet() == true
        {
            
            do {
                let postData = try JSONSerialization.data(withJSONObject: parameter, options: [])
            
            let request = NSMutableURLRequest(url: NSURL(string: Singletone.shareInstance.apiSign + "api/UserManagement/UpdateSignatures")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = headerAPIDashboard
            request.httpBody = postData as Data
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                
                 self.stopActivityIndicator()
                
                if (error != nil) {
                    print(error)
                } else {
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse)
                    let responseData = String(data: data!, encoding: String.Encoding.utf8)
                   // let jsondata = try JSONSerialization.jsonObject(with: data, options: .prettyPrinted)
                    print(responseData)
                    //let jsonObj: JSON = JSON(responseData)
                    do {
                        let jsonObj = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        
                        print(jsonObj)
                        if jsonObj["StatusCode"] as! Int == 1000
                        {
                            DispatchQueue.main.async {
                                self.updateSignatures(completion: { (completed) in
                                    if completed {
                                        self.alertSample(strTitle: "", strMsg: "Signatures updated successfully")
                                        self.getUpdatedProfile()
                                        self.getProfile()
                                        self.stopActivityIndicator()
                                    } else {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                })
                            }
                        }
                        else
                        {
                            self.stopActivityIndicator()
                            //self.alertSampleWithFailed(strTitle: "", strMsg: jsonObj["Message"].stringValue)
                            self.alertSample(strTitle: "", strMsg: (jsonObj["Message"])! as! String)
                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
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
    
    func getProfile() {
        
        userSignArray = []
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            let strPid = ZorroTempData.sharedInstance.getProfileId()
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetProfile?profileId=\(strPid)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    var json: JSON = JSON(response.data!)
                    
//                    print("getprofile json: \(json)")
                    
                    let jsonDic = json.dictionaryObject
                    if jsonDic != nil {
                        if let jsonObj = jsonDic!["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic!["StatusCode"] as! Int
                            let jsonData = jsonDic!["Data"] as! NSDictionary
                            let settings = jsonData["Settings"]
                            if statusCode == 1000
                            {
                                
                                self.profstat = jsonObj["ProfileStatus"] as? Int
                                
                                UserDefaults.standard.set(jsonObj["ProfileStatus"], forKey: "ProfileStatus")
                                
                                let userSign = jsonData["UserSignatures"] as? NSArray
                                
                                let userSignObj = UserSignatures()
                                if let settingsDic = settings as? [AnyHashable : Any] {
                                    userSignObj.settings = Settings(dictionary: settingsDic)
                                }
                                if let sign = jsonData["Signature"] as? String {
                                    userSignObj.Signature = sign //jsonData["Signature"] as! String
                                }
                                if let initials = jsonData["Initials"] as? String {
                                    userSignObj.Initials = initials
                                }
                                if let signDesc = jsonData["SignatureDescription"] as? [AnyHashable : Any] {
                                    userSignObj.SignatureDescription = SignatureDescription(dictionary: signDesc )
                                }
                                userSignObj.IsDefault = true//jsonData["IsDefault"] as? Bool
                                
                                self.userSignArray.append(userSignObj)
                                
                                if userSign != nil {
                                    var cnt = 0
                                    
                                    for sign in userSign! {
                                        
                                        let dic = sign as! [AnyHashable : Any]
                                        let usrSignObj = UserSignatures(dictionary:dic)
                                        
                                        if let signDesc = dic["SignatureDescription"] as? [AnyHashable : Any] {
                                            usrSignObj.SignatureDescription = SignatureDescription(dictionary: signDesc )
                                        }
                                        
                                        cnt = cnt + 1
                                        
                                        if let signature = dic["Signature"] as? String {
                                            
                                            let arr = signature.components(separatedBy: ",")
                                            if arr.count > 1 {
                                                let sign = arr[1]
                                                let key: String = "UserSign\(cnt)"
                                                UserDefaults.standard.set(sign, forKey: key)
                                            }
                                        }
                                        
                                        if let initialstr = dic["Initials"] as? String {
                                            let arr1 = initialstr.components(separatedBy: ",")
                                            if arr1.count > 1 {
                                                let initial = arr1[1]
                                                let key1: String = "UserInitial\(cnt)"
                                                UserDefaults.standard.set(initial, forKey: key1)
                                            }
                                        }
                                        
                                        self.userSignArray.append(usrSignObj)
                                     }
                                } else {
                                    
                                }
                                
                                
                                
                                if (userSignObj.Signature != nil && !(userSignObj.Signature?.isEmpty)!) || self.userSignArray.count > 0 {
                                    self.populateSignObject()
                                }
                                
                                
                            }
                            else
                            {
                                
                                self.alertSampleWithFailed(strTitle: "", strMsg: jsonData["Message"] as! String)
                            }
                        }
                    }
            }
        }
        else
        {
            alertSample(strTitle: "", strMsg: "No internet found. Check your network connection and Try again..")
        }
    }
    func getUpdatedProfile() {
        
        
        let strAuth: String = UserDefaults.standard.string(forKey: "ServiceToken")!
        let headerAPIDashboard = ["Authorization" : "Bearer \(strAuth)"]
        
        if Connectivity.isConnectedToInternet() == true
        {
            let strPid = ZorroTempData.sharedInstance.getProfileId()
            Alamofire.request(URL(string: Singletone.shareInstance.apiURL + "UserManagement/GetProfile?profileId=\(strPid)")!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headerAPIDashboard)
                .responseJSON { response in
                    
                    var json: JSON = JSON(response.data!)
                    
//                    print("getprofile json: \(json)")
                    
                    let jsonDic = json.dictionaryObject
                    if jsonDic != nil {
                        if let jsonObj = jsonDic!["Data"] as? NSDictionary {
                            print(jsonObj)
                            let statusCode = jsonDic!["StatusCode"] as! Int
                            let jsonData = jsonDic!["Data"] as! NSDictionary
                            
                            if statusCode == 1000
                            {
                                
                                UserDefaults.standard.set(jsonObj["ProfileStatus"], forKey: "ProfileStatus")
                                
                                let userSign = jsonData["UserSignatures"] as? NSArray
                                
                                if userSign != nil {
                                    var cnt = 0
                                    
                                    for sign in userSign! {
                                        
                                        let dic = sign as! [AnyHashable : Any]
                                        
                                        cnt = cnt + 1
                                        
                                        if let signature = dic["Signature"] as? String {
                                            
                                            let arr = signature.components(separatedBy: ",")
                                            if arr.count > 1 {
                                                let sign = arr[1]
                                                let key: String = "UserSign\(cnt)"
                                                UserDefaults.standard.set(sign, forKey: key)
                                            }
                                        }
                                        
                                        if let initialstr = dic["Initials"] as? String {
                                            let arr1 = initialstr.components(separatedBy: ",")
                                            if arr1.count > 1 {
                                                let initial = arr1[1]
                                                let key1: String = "UserInitial\(cnt)"
                                                UserDefaults.standard.set(initial, forKey: key1)
                                            }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.perform(#selector(self.goBack), with: self, afterDelay: 0.0)
                    }
            }
        }
    }
    
    func populateSignObject() {
        
        var cnt = 0
        for userSign in self.userSignArray {
            if cnt < Singletone.shareInstance.signObjectArray.count {
                let signObj  = userSign.convertToSignObject(cnt: cnt)
                
                if let strInitImgArr = userSign.Initials?.split(separator: ","){
                    if (strInitImgArr.count) > 1 {
                        let strImage = String(strInitImgArr[1])
                        
                        let decodedimage = strImage.base64ToImage()
                        signObj.initialImg = decodedimage
                    }
                } else if let strInitImgArr = userSign.settings?.initialImage.split(separator: ","){
                    if (strInitImgArr.count) > 1 {
                        let strImage = String(strInitImgArr[1])
                        
                        let decodedimage = strImage.base64ToImage()
                        signObj.initialImg = decodedimage
                    }
                }
                if let strSignImgArr = userSign.Signature?.split(separator: ",") {
                    if (strSignImgArr.count) > 1 {
                        let strImage = String(strSignImgArr[1])
                        
                        let decodedimage = strImage.base64ToImage()
                        signObj.signImg = decodedimage
                    }
                } else if let strSignImgArr = userSign.settings?.signatureImage.split(separator: ",") {
                    if (strSignImgArr.count) > 1 {
                        let strImage = String(strSignImgArr[1])
                        
                        let decodedimage = strImage.base64ToImage()
                        signObj.signImg = decodedimage
                    }
                }
                
                if let penW = userSign.settings?.penWidth {
                    /*if penW >= 2 {
                        signObj.signFontSize = 5
                    } else {*/
                        signObj.signFontSize = CGFloat(penW)
                    //}
                }
                //txtSaveOpt = signObj.saveOpt!
                
                if cnt == 0 {
                    let FullName = UserDefaults.standard.string(forKey: "FullName")
                    let fName: String = UserDefaults.standard.string(forKey: "FName")!
                    let lName: String = UserDefaults.standard.string(forKey: "LName")!
                    let f1: String = String(fName.prefix(1))
                    let l1: String = String(lName.prefix(1))
                    
                    let initial = "\(f1) \(l1)"
                    
                    
                    signObj.signDisp = (signObj.signDisp ?? "").isEmpty ? FullName : signObj.signDisp
                    
                    signObj.initialDisp = (signObj.initialDisp ?? "").isEmpty ? initial : signObj.initialDisp
                    
                }
                Singletone.shareInstance.signObjectArray[cnt] = signObj
                cnt = cnt + 1
            }
        }
        
        if Singletone.shareInstance.signObjectArray.count > 0 {
            selSignObject = Singletone.shareInstance.signObjectArray[0]
            if let index = Singletone.shareInstance.signOptArray.index(of: (selSignObject?.signOpt ?? "")!)
            {
                selSignOpt = index + 1
            } else {
                selSignOpt = 1
            }
            if let index = Singletone.shareInstance.signOptArray.index(of: (selSignObject?.initialOpt ?? "")!)
            {
                selInSignOpt = index + 1
            } else {
                selInSignOpt = 1
            }
            //selInSignOpt = selSignOpt
        }
        
        self.tableViewList.reloadData()
        
    }
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName as! String)
            print("Font Names = [\(names)]")
        }
    }
    
    //picker delegate methods
    override func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selPickerRow = row
        
    }
    
    @IBAction func onDonePicker(_ sender: Any) {
        
        self.onSelectFontOption(selOpt: selPickerRow, type: selType)
        fontPickerView.isHidden = true
        fontPicker.isHidden = true
    }
    

    
    
}
public enum ImageFormat {
    case PNG
    case JPEG(CGFloat)
}

extension UIImage {
    
    public func base64(format: ImageFormat) -> String {
        var imageData: NSData
        switch format {
        case .PNG: imageData = self.pngData() as! NSData
        case .JPEG(let compression): imageData = self.jpegData(compressionQuality: compression) as! NSData
        }
        return imageData.base64EncodedString(options: .endLineWithCarriageReturn)
    }
}


extension ManageSignVC {
    fileprivate func updateSignatures(completion: @escaping(Bool) -> ()) {
        
        let connectivity = Connectivity.isConnectedToInternet()
        if !connectivity {
            alertSample(strTitle: "Connection!", strMsg: "Your connection appears to be offline, please try again!")
            completion(false)
            return
        }
        
        self.showActivityIndicatory(uiView: self.view)
        let userprofile = UserProfile()
        userprofile.getuserprofileData { (userprofiledata, err) in
            if err {
                self.alertSample(strTitle: "Something Went Wrong ", strMsg: "Unable to get user details, please try again")
                completion(false)
                return
            }
            
            var signatures: [UserSignature] = []
            
            if let signatureid = userprofiledata?.Data?.UserSignatureId, let signature = userprofiledata?.Data?.Signature, let intial = userprofiledata?.Data?.Initials {
                var newSignature = UserSignature()
                newSignature.UserSignatureId = signatureid
                newSignature.Signature = signature
                newSignature.Initials = intial
                signatures.append(newSignature)
            }
            
            if let signatories = userprofiledata?.Data?.UserSignatures {
                if signatories.count > 0 {
                    for signature in signatories {
                        signatures.append(signature)
                    }
                }
            }
            
            ZorroTempData.sharedInstance.setallSignatures(signatures: signatures)
            completion(true)
        }
    }
}


extension ManageSignVC {
    fileprivate func resizeImagex(image: UIImage, taragetSize: CGSize) -> UIImage {
        let size = image.size
        let widthratio = taragetSize.width / size.width
        let heightratio = taragetSize.height / size.height
        
        var newsize: CGSize
        
        if widthratio > heightratio {
            newsize = CGSize(width: size.width * heightratio, height: size.height * heightratio)
        } else {
            newsize = CGSize(width: size.width * widthratio, height: size.height * widthratio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newsize.width, height: newsize.height)
        UIGraphicsBeginImageContextWithOptions(newsize, false, 1.0)
        image.draw(in: rect)
        let newimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newimage!
    }
}

