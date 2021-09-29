//
//  CustomCell.swift
//  ZorroSign
//
//  Created by Apple on 13/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import RGSColorSlider

protocol CustomCellProtocol {
    
    func onSelectCell(view:UIView)
    func sliderValueChanged(type:String, value:AnyObject)
    func onDrawEnd(lines:[Line], tag:Int, img:UIImage)
    func onDrawEnd(pathArr:[SignaturePath], tag:Int, img:UIImage)
    func onClearCell(tag: Int)
    
}

@objc protocol DeptCellProtocol {
    
    @objc optional func onEditClick(tag: Int, flag: Bool)
    @objc optional func onExpandClick(tag: Int, flag: Bool)
    @objc optional func btnResetClicked(isLocked: Bool, email: String)
}

protocol DocCellProtocol {
    
    func onDetailClick(hint: String)
}


class CustomCell: UITableViewCell {

    var delegate: CustomCellProtocol?
    var deptDelegate: DeptCellProtocol?
    var docDelegate: DocCellProtocol?
    
    
    @IBOutlet weak var colorSlider: RGSColorSlider!
    @IBOutlet weak var fontSlider: UISlider!
    @IBOutlet weak var drawview: DrawView!
    
    @IBOutlet weak var txtDD: DesignableUITextField!
    @IBOutlet weak var txtFFDD: DesignableUITextField!
    
    @IBOutlet weak var txtHandwritten: UITextField!
    
    @IBOutlet weak var lblGen: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtDispSign: UITextField!
    
    @IBOutlet weak var defaultVal: UISwitch!
    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var con_logoW: NSLayoutConstraint!
    @IBOutlet weak var con_logoH: NSLayoutConstraint!
    @IBOutlet weak var con_lead: NSLayoutConstraint!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var signatureBorder: UIView!
    @IBOutlet weak var initialBorder: UIView!
    
    func configUserReset() {
        if let _isLocked = isLocked {
            btnReset.isEnabled = _isLocked ? false : true
        }
        
        if let _email = email {
            if email == ZorroTempData.sharedInstance.getUserEmail() {
                btnReset.isHidden = true
            } else {
                btnReset.isHidden = false
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("customcell touches")
        
        self.next?.touchesBegan(touches, with: event)
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        super.touchesEnded(touches, with: event)
        self.next?.touchesEnded(touches, with: event)
    }
    
    
    override func draw(_ rect: CGRect) {
        
    }
    
    @IBAction func colorChanged(_ sender: RGSColorSlider) {
        
        let sliderImg = UIImage(named: "color-picker-bar")
        //let thumbpoint = self.currentThumbRect(slider: sender).origin
        let point = CGPoint(x: Int(sender.value), y: 10)//self.currentThumbRect(slider: sender).origin
        let color = sliderImg?.getPixelColor(pos: point) ?? UIColor.black
        delegate?.sliderValueChanged(type: "color", value: color)
    }
    
    @IBAction func fontChanged(_ sender: UISlider) {
        delegate?.sliderValueChanged(type: "font", value: sender.value as AnyObject)
    }
    
    @IBAction func clearAction(_ sender: Any) {
        
        self.drawview.reset()
        delegate?.onClearCell(tag: (sender as AnyObject).tag)
    }
    
    @IBAction func expandAction(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        let flag: Bool = btn.isSelected
        deptDelegate?.onExpandClick!(tag: (sender as AnyObject).tag, flag: flag)
    }
    
    @IBAction func editAction(_ sender: Any) {
    
        let btn = sender as! UIButton
        var flag: Bool = false
        if btn.accessibilityHint == "edit" {
            flag = true
        }
        deptDelegate?.onEditClick!(tag: btn.tag, flag: flag)
    }
    
    var isLocked: Bool?
    var email: String?
    
    @IBAction func didTapOnReset(_ sender: Any) {
        if let _isLocked = isLocked, let _email = email {
            deptDelegate?.btnResetClicked!(isLocked: _isLocked, email: _email)
        }
    }
    
    @IBAction func detailAction(_ sender: Any) {
        
        let btn = sender as! UIButton
        let hint = btn.accessibilityHint
        
        docDelegate?.onDetailClick(hint: hint!)
    }
    
    func captureImg(label: UILabel, initial: Bool)-> UIImage {
        
        if !initial {
           label.text = "  " + label.text!
        }
        
        
        label.layer.masksToBounds = false
        label.layer.borderWidth = 0
        label.backgroundColor = .clear

        let rect: CGRect = label.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, label.isOpaque, 0.0)
//        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        label.layer.render(in: context!)
        var img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if !initial {
            img = resizeImagex(image: img, taragetSize: CGSize(width: 500 * 1.3, height: 100 * 1.3))
        } else {
            img = resizeImagex(image: img, taragetSize: CGSize(width: 500, height: 100))
        }

        return img
    }
    
    func captureImg(view: UIView)-> UIImage {
        
        let rect: CGRect = view.bounds
        UIGraphicsBeginImageContext(rect.size)
       
        let context = UIGraphicsGetCurrentContext()
        UIColor.clear.set()
        context?.fill(rect)
//        view.isOpaque = false
//        view.layer.isOpaque = false
        view.backgroundColor = .clear
        view.layer.backgroundColor = UIColor.clear.cgColor
        view.layer.masksToBounds = false
        view.layer.borderWidth = 0
        
        view.layer.render(in: context!)
        
        var img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        img = resizeImagex(image: img, taragetSize: CGSize(width: 500, height: 100))
        return img
    }
    
    func currentThumbRect(slider: UISlider) -> CGRect{
        
        let trackrect =  slider.trackRect(forBounds:slider.bounds)
        return slider.thumbRect(forBounds: slider.bounds,
                                trackRect: trackrect,value: slider.value)
        //return [self thumbRectForBounds:self.bounds trackRect:[self trackRectForBounds:self.bounds] value:self.value];
    }
    
}

extension CustomCell {
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
