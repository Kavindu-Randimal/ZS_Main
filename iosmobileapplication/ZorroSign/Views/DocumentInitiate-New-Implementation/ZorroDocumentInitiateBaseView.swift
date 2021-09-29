//
//  ZorroDocumentInitiateBaseView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/12/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import FontAwesome_swift

class ZorroDocumentInitiateBaseView: UIView {
    var tagtempId: String!
    var fullwidth: CGFloat!
    var fullheight: CGFloat!
    let greencolor: UIColor = ColorTheme.btnBG
    
    //MARK - Outlets
    var containersubView: UIView!
    var resizeCircle: UIView!
    var stepnumberCircleLabel: UILabel!
    var closebuttonCircle: UIButton!
    var lockbuttonCircle: UIButton!
    var minimizebuttonCircel: UIButton!
    
    //MARK: - Callbacks
    var draggableCallBack: ((ZorroDocumentInitiateBaseView) ->())?
    var viewresizeCallBack: ((Bool, ZorroDocumentInitiateBaseView) -> ())?
    var closebuttonCallBack: ((ZorroDocumentInitiateBaseView, String, Int) -> ())?
    var settingsCallBack: ((ZorroDocumentInitiateBaseView, Int) -> ())?
    
    //MARK: - UI Proplerties
    var borderColor: UIColor!
    
    //MARK: - Properties
    var step: Int!
    var tagType: Int!
    var signatories: [Signatory]!
    var contactDetails: [ContactDetailsViewModel] = [ContactDetailsViewModel]()
    var extrametadata: SaveExtraMetaData?
    var attachmentCount: Int = 1
    var attachmentDescription: String = ""
    var FontColor: String!
    var FontId: Int!
    var FontSize: Int!
    var FontStyle: String!
    var FontType: String!
    var lock: Bool = false
    var hide: Bool = false
    var signature: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        fullwidth = self.frame.width
        fullheight = self.frame.height
        
        settagTempId()
        setBorder()
        setPanGesture()
        setresizableCircle()
        setClosebutton()
        setlockButton()
        setminimizeButton()
        setsubContainer()
        setstepnumberCircleLabel()
        setsubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Set Tag Temp Id
extension ZorroDocumentInitiateBaseView {
    fileprivate func settagTempId() {
        let uuidstring = UUID().uuidString
        tagtempId = uuidstring
    }
}


//MARK: Setup initial layer
extension ZorroDocumentInitiateBaseView {
    fileprivate func setBorder() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0
        self.backgroundColor = .clear
    }
}

//MARK: Set pangesture for the view
extension ZorroDocumentInitiateBaseView {
    fileprivate func setPanGesture() {
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(setGesture(_:)))
        pangesture.delegate = self
        self.addGestureRecognizer(pangesture)
    }
}

//MARK: Defining pangesture for the view
extension ZorroDocumentInitiateBaseView {
    @objc fileprivate func setGesture(_ recognizer: UIPanGestureRecognizer) {
        guard let draggableObject = recognizer.view else { return }
        
//        let newframex = draggableObject.frame.origin.x
//        let newframey = draggableObject.frame.origin.y
//
//        let superviewwidth = draggableObject.superview?.frame.width
//        let superviewheight = draggableObject.superview?.frame.height
//        print("NEW FRAME X ----> \(newframex)")
//        print("NEW FRAME Y ----> \(newframey)")
//        print("SUPERVIEW WIDTH ----> \(superviewwidth!)")
//        print("SUPERVIEW HEIGHT----> \(superviewheight!)")
//        print("\n----------------------\n")
//
//        let newviewviaxaxis = newframex + draggableObject.frame.width
//        let newviewviayaxis = newframey + draggableObject.frame.height
//        print("NEW X AXIS : \(newviewviaxaxis)")
//        print("NEW Y AXIX : \(newviewviayaxis)")
        
        let translation = recognizer.translation(in: self.superview)
        draggableObject.center = CGPoint(x: draggableObject.center.x + translation.x, y: draggableObject.center.y + translation.y)
        recognizer.setTranslation(CGPoint.zero, in: self.superview)
        
        if recognizer.state == UIGestureRecognizer.State.ended {
            draggableCallBack!(self)
        }
    }
}

//MARK: Assign resizable circle
extension ZorroDocumentInitiateBaseView {
    fileprivate func setresizableCircle() {
        resizeCircle = UIView()
        resizeCircle.translatesAutoresizingMaskIntoConstraints = false
        resizeCircle.backgroundColor = greencolor
        addSubview(resizeCircle)
        
        let resizecircleConstraints = [resizeCircle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                                       resizeCircle.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                                       resizeCircle.widthAnchor.constraint(equalToConstant: 30),
                                       resizeCircle.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(resizecircleConstraints)
        
        let resizeLabel: UILabel = UILabel()
        resizeLabel.translatesAutoresizingMaskIntoConstraints = false
        resizeLabel.font = UIFont.fontAwesome(ofSize: 17, style: .solid)
        resizeLabel.textColor = .white
        resizeLabel.textAlignment = .center
        resizeLabel.adjustsFontSizeToFitWidth = true
        resizeLabel.minimumScaleFactor = 0.2
        resizeLabel.text = String.fontAwesomeIcon(name: .expand)
        
        resizeCircle.addSubview(resizeLabel)
        
        let resizelabelConstraints = [resizeLabel.leftAnchor.constraint(equalTo: resizeCircle.leftAnchor),
                                      resizeLabel.topAnchor.constraint(equalTo: resizeCircle.topAnchor),
                                      resizeLabel.rightAnchor.constraint(equalTo: resizeCircle.rightAnchor),
                                      resizeLabel.bottomAnchor.constraint(equalTo: resizeCircle.bottomAnchor)]
        NSLayoutConstraint.activate(resizelabelConstraints)
        
        resizeCircle.layer.masksToBounds = true
        resizeCircle.layer.cornerRadius = 15
    }
}

//MARK: - Setup close button
extension ZorroDocumentInitiateBaseView {
    fileprivate func setClosebutton() {
        closebuttonCircle = UIButton()
        closebuttonCircle.translatesAutoresizingMaskIntoConstraints = false
        closebuttonCircle.setImage(UIImage(named: "doccancel"), for: .normal)
        closebuttonCircle.backgroundColor = .white
        self.addSubview(closebuttonCircle)
        
        let closebuttoncircleConstraints = [closebuttonCircle.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
                                            closebuttonCircle.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                                            closebuttonCircle.widthAnchor.constraint(equalToConstant: 30),
                                            closebuttonCircle.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(closebuttoncircleConstraints)
        
        closebuttonCircle.layer.masksToBounds = true
        closebuttonCircle.layer.cornerRadius = 15
        
        closebuttonCircle.addTarget(self, action: #selector(closeAction(_:)), for: .touchUpInside)
    }
}

//MARK: - setup lock button
extension ZorroDocumentInitiateBaseView {
    fileprivate func setlockButton() {
        lockbuttonCircle = UIButton()
        lockbuttonCircle.translatesAutoresizingMaskIntoConstraints = false
        lockbuttonCircle.setImage(UIImage(named: "docunlock"), for: .normal)
        lockbuttonCircle.backgroundColor = .white
        lockbuttonCircle.isHidden = true
        self.addSubview(lockbuttonCircle)
        
        let lockbuttoncircleConstraints = [lockbuttonCircle.centerXAnchor.constraint(equalTo: closebuttonCircle.centerXAnchor, constant: 0),
                                           lockbuttonCircle.topAnchor.constraint(equalTo: closebuttonCircle.bottomAnchor, constant: 0),
                                           lockbuttonCircle.widthAnchor.constraint(equalToConstant: 30),
                                           lockbuttonCircle.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(lockbuttoncircleConstraints)
        
        lockbuttonCircle.layer.masksToBounds = true
        lockbuttonCircle.layer.cornerRadius = 15
        
        lockbuttonCircle.addTarget(self, action: #selector(lockAction(_:)), for: .touchUpInside)
    }
}

//MARK: setup minimize button
extension ZorroDocumentInitiateBaseView {
    fileprivate func setminimizeButton() {
        minimizebuttonCircel = UIButton()
        minimizebuttonCircel.translatesAutoresizingMaskIntoConstraints = false
        minimizebuttonCircel.setImage(UIImage(named: "docminus"), for: .normal)
        minimizebuttonCircel.backgroundColor = .white
        minimizebuttonCircel.isHidden = true
        self.addSubview(minimizebuttonCircel)
        
        let minimizebuttoncircelConstraints = [minimizebuttonCircel.centerXAnchor.constraint(equalTo: lockbuttonCircle.centerXAnchor, constant: 0),
                                           minimizebuttonCircel.topAnchor.constraint(equalTo: lockbuttonCircle.bottomAnchor, constant: 0),
                                           minimizebuttonCircel.widthAnchor.constraint(equalToConstant: 30),
                                           minimizebuttonCircel.heightAnchor.constraint(equalToConstant: 30)]
        
        NSLayoutConstraint.activate(minimizebuttoncircelConstraints)
        
        minimizebuttonCircel.layer.masksToBounds = true
        minimizebuttonCircel.layer.cornerRadius = 15
        minimizebuttonCircel.addTarget(self, action: #selector(minimizeAction(_:)), for: .touchUpInside)
    }
}

//MARK: Assing Container view
extension ZorroDocumentInitiateBaseView {
    fileprivate func setsubContainer() {
    
        containersubView = UIView()
        containersubView.translatesAutoresizingMaskIntoConstraints = false
        containersubView.backgroundColor = .clear
        self.addSubview(containersubView)
        
        let containersubviewCons = [containersubView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
        containersubView.topAnchor.constraint(equalTo: closebuttonCircle.centerYAnchor, constant: 0),
        containersubView.rightAnchor.constraint(equalTo: resizeCircle.centerXAnchor),
        containersubView.bottomAnchor.constraint(equalTo: resizeCircle.centerYAnchor)]
        NSLayoutConstraint.activate(containersubviewCons)
        
        containersubView.layer.borderColor = UIColor.black.cgColor
        containersubView.layer.borderWidth = 2
    }
}


extension ZorroDocumentInitiateBaseView {
    fileprivate func setstepnumberCircleLabel() {
        stepnumberCircleLabel = UILabel()
        stepnumberCircleLabel.translatesAutoresizingMaskIntoConstraints = false
        stepnumberCircleLabel.backgroundColor = .white
        stepnumberCircleLabel.text = "1"
        stepnumberCircleLabel.textAlignment = .center
        self.addSubview(stepnumberCircleLabel)
        
        let stepnumbercirclelabelConstraints = [stepnumberCircleLabel.centerXAnchor.constraint(equalTo: containersubView.leftAnchor, constant: -10),
                                                stepnumberCircleLabel.centerYAnchor.constraint(equalTo: containersubView.topAnchor, constant: -10),
                                           stepnumberCircleLabel.widthAnchor.constraint(equalToConstant: 30),
                                           stepnumberCircleLabel.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(stepnumbercirclelabelConstraints)
        
        stepnumberCircleLabel.layer.masksToBounds = true
        stepnumberCircleLabel.layer.cornerRadius = 15
    }
}

//MARK: resize functions
extension ZorroDocumentInitiateBaseView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if touch.view!.isDescendant(of: resizeCircle) {
                viewresizeCallBack!(false, self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            if touch.view == resizeCircle {
                
                let touchlocation = touch.location(in: resizeCircle)
                viewresizeCallBack!(true, self)
                
                if let tagtype = tagType {
                    switch tagtype {
                    case 0, 1, 2, 13:
                        var scalvalue: CGFloat!
                        touchlocation.x > touchlocation.y ? (scalvalue = touchlocation.x) : (scalvalue = touchlocation.y)
                        
                        switch tagtype {
                        case 0:
                            let newwidth = self.frame.width + scalvalue
                            let newheight = newwidth/5
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newwidth, height: newheight)
                        default:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + scalvalue, height: self.frame.height + scalvalue)
                        }
                    case 6:
                        return
                    case 8:
                        if self.frame.height >= 200 && self.frame.width >= 150 {
                            var scalvalue: CGFloat!
                            touchlocation.x > touchlocation.y ? (scalvalue = touchlocation.x) : (scalvalue = touchlocation.y)
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + scalvalue, height: self.frame.height + scalvalue)
                        } else {
                            return
                        }
                    default:
                        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + touchlocation.x, height: self.frame.height + touchlocation.y)
                    }
                } else {
                    self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width + touchlocation.x, height: self.frame.height + touchlocation.y)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if let touch = touches.first {
            if touch.view == resizeCircle {
                if let tagtype = tagType {
                   
                    let isvalid = isminimumValid(width: self.frame.width, height: self.frame.height, tagtype: tagtype)
                    if !isvalid {
                        switch tagtype {
                        case 0:
                             self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 148 , height: 56)
                        case 1:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 61 , height: 76)
                        case 2:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 130 , height: 130)
                        case 3:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 135 , height: 56)
                        case 4:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 100 , height: 60)
                        case 6:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 91 , height: 128)
                        case 8:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 163 , height: 196)
                        case 13:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 59 , height: 59)
                        case 14:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 136 , height: 56)
                        case 16:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 210 , height: 56)
                        case 17:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 193 , height: 56)
                        case 18, 19, 20:
                            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: 136 , height: 56)
                        default:
                            return
                        }
                    }
                }
            }
        }
    }
}

//MARK: check minimum width height
extension ZorroDocumentInitiateBaseView {
    fileprivate func isminimumValid(width: CGFloat, height: CGFloat, tagtype: Int) -> Bool {
        var isvalid: Bool = true
        switch tagtype {
        case 0:
            (width >= 148 && height >= 56) ? (isvalid = true) : (isvalid = false)
        case 1:
            (width >= 61 && height >= 76) ? (isvalid = true) : (isvalid = false)
        case 2:
            (width >= 130 && height >= 130) ? (isvalid = true) : (isvalid = false)
        case 3:
            (width >= 135 && height >= 56) ? (isvalid = true) : (isvalid = false)
        case 4:
            (width >= 100 && height >= 60) ? (isvalid = true) : (isvalid = false)
        case 6:
            (width >= 91 && height >= 128) ? (isvalid = true) : (isvalid = false)
        case 8:
            (width >= 163 && height >= 196) ? (isvalid = true) : (isvalid = false)
        case 13:
            (width >= 59 && height >= 59) ? (isvalid = true) : (isvalid = false)
        case 14:
            (width >= 136 && height >= 56) ? (isvalid = true) : (isvalid = false)
        case 16:
            (width >= 210 && height >= 56) ? (isvalid = true) : (isvalid = false)
        case 17:
            (width >= 193 && height >= 56) ? (isvalid = true) : (isvalid = false)
        case 18, 19, 20:
            (width >= 136 && height >= 56) ? (isvalid = true) : (isvalid = false)
        default:
            isvalid = true
        }
        return isvalid
    }
}

//MARK: Gesture recognizer delegate methods
extension ZorroDocumentInitiateBaseView: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer.isKind(of: UIPanGestureRecognizer.self) {
            
            if touch.view!.isDescendant(of: resizeCircle) {
                print("panning on circle")
                return false
            }
            return true
        }
        return true
    }
}

//MARK: - override function
extension ZorroDocumentInitiateBaseView {
    @objc func setsubViews() { }
}

//MARK: - bring sub views to front
extension ZorroDocumentInitiateBaseView {
    @objc func bringviewstoFront() {
        self.bringSubviewToFront(resizeCircle)
        self.bringSubviewToFront(closebuttonCircle)
        self.bringSubviewToFront(lockbuttonCircle)
        self.bringSubviewToFront(minimizebuttonCircel)
        containersubView.bringSubviewToFront(stepnumberCircleLabel)
    }
}

//MARK: - show hidden buttons
extension ZorroDocumentInitiateBaseView {
    @objc func showhiddenButtons() {
        lockbuttonCircle.isHidden = false
        minimizebuttonCircel.isHidden = false
    }
}

//MARK: Button Actions
extension ZorroDocumentInitiateBaseView {
    @objc fileprivate func closeAction(_ sender: UIButton) {
        closebuttonCallBack!(self, tagtempId, step)
    }
    
    @objc func lockAction(_ sender: UIButton) { }
    
    @objc func minimizeAction(_ sender: UIButton) { }
}

//MARK: - Set Step number and the color
extension ZorroDocumentInitiateBaseView {
    func setstepandtagNumber(stepnumber: Int, tagtype: Int) {
        step = stepnumber
        tagType = tagtype
        
        if tagtype == 8 {
            stepnumberCircleLabel.text = "\(stepnumber)"
            stepnumberCircleLabel.backgroundColor = .red
            stepnumberCircleLabel.textColor = .white
            stepnumberCircleLabel.layer.borderColor = UIColor.red.cgColor
            stepnumberCircleLabel.layer.borderWidth = 2
        } else {
            let color = DocumentHelper.sharedInstance.getstepColor(step: stepnumber-1)
            stepnumberCircleLabel.text = "\(stepnumber)"
            stepnumberCircleLabel.layer.borderColor = color.cgColor
            stepnumberCircleLabel.layer.borderWidth = 2
        }
    }
}

//MARK: - Get image
extension ZorroDocumentInitiateBaseView {
    func getImage(signature: String) -> UIImage {
        if signature.contains(",") {
            let splitsignature = signature.components(separatedBy: ",")
            let base64string = splitsignature[1]
            guard let decodedata = Data(base64Encoded: base64string) else { return UIImage()}
            let signatureimage = UIImage(data: decodedata)
            return signatureimage!
        } else {
            return UIImage()
        }
    }
}

//MARK: - Remove resizer
extension ZorroDocumentInitiateBaseView {
    func removeResizer() {
        resizeCircle.isHidden = true
        resizeCircle.isUserInteractionEnabled = false
    }
}

//MARK: - Remove pangesture
extension ZorroDocumentInitiateBaseView {
    func removepanGesture() {
        if let gestures = self.gestureRecognizers {
            for gesture in gestures {
                if let recognizer = gesture as? UIPanGestureRecognizer {
                    self.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
}

//MARK: - Remove Stepnumber
extension ZorroDocumentInitiateBaseView {
    func removeStepnumber() {
        stepnumberCircleLabel.isHidden = true
    }
}

//MARK: - Set Signatories
extension ZorroDocumentInitiateBaseView {
    func setSignatories(contacts: [ContactDetailsViewModel]) {
        
        contactDetails = contacts
        var allsignatories: [Signatory] = []
        for contact in contacts {
            var _id = contact.ContactProfileId
            var _Type = contact.Type
            if contact.Type == 2 {
                _id = contact.Id
                _Type = 3
            }
            let signatory = Signatory(id: _id, type: _Type, userName: contact.Email, groupName: nil, groupImage: nil, friendlyName: contact.Name, profileImage: contact.profileimage, profileID: nil, isLocked: nil)
            allsignatories.append(signatory)
        }
        signatories = allsignatories
    }
}

//MARK: - Set User Profile id
extension ZorroDocumentInitiateBaseView {
    func setuserProfileId() {
        let profileid = ZorroTempData.sharedInstance.getProfileId()
        signature = profileid
    }
}

//MARK: - Hide/Show Views
extension ZorroDocumentInitiateBaseView {
    func hideshowviewforDynamicnote(hideshow: Bool) {
        containersubView.isHidden = hideshow
        closebuttonCircle.isHidden = hideshow
        resizeCircle.isHidden = hideshow
        lockbuttonCircle.isHidden = hideshow
        minimizebuttonCircel.isHidden = hideshow
    }
}
