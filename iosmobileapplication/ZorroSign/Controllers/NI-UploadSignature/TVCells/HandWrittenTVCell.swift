//
//  HandWrittenTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HandWrittenCellDelegate {
    func setTableScroll(enable value: Bool)
    func getInitialImage(initialImg: UIImage)
    func getSignatureImage(signatureImg: UIImage)
    func clearHandwritten(_ signaturePart: SignaturePart)
    func getStrokeColorAndWidth(color: UIColor, width: CGFloat)
}

class HandWrittenTVCell: UITableViewCell {
    
    // MARK: - Variables
    
    private var bag = DisposeBag()
    var delegate: HandWrittenCellDelegate?
    
    var strokeWidth: CGFloat = 1.0
    var strokeColor: UIColor = UIColor.black
    
    // MARK: - Outlets
    
    @IBOutlet weak var vwBaseView: UIView!
    @IBOutlet weak var btnClearSignature: UIButton!
    @IBOutlet weak var lblPlaceHolderSignature: UILabel!
    
    @IBOutlet weak var btnClearInitial: UIButton!
    @IBOutlet weak var lblPlaceholderInitial: UILabel!
    
    @IBOutlet weak var viewSignature: YPDrawSignatureView!
    @IBOutlet weak var viewInital: YPDrawSignatureView!
    
    @IBOutlet var strokeWidthButtons: [UIButton]!
    @IBOutlet weak var colorSlider: RGSColorSlider!
    

    // MARK: - LifeCycle
    
    override func prepareForReuse() {
        strokeWidth = 1.0
        strokeColor = UIColor.black
        
        lblPlaceholderInitial.text = ""
        lblPlaceHolderSignature.text = ""
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        viewInital.layer.cornerRadius = 10
        viewSignature.layer.cornerRadius = 10
        vwBaseView.layer.cornerRadius = 10
        
        viewInital.addShadowAllSide()
        viewSignature.addShadowAllSide()
        vwBaseView.addShadowAllSide()
        
        strokeWidthButtons.forEach { (btn) in
            btn.backgroundColor = UIColor.white
            btn.tintColor = ColorTheme.BtnTintDisabled
            btn.imageView?.contentMode = .scaleAspectFit
        }
    }
    
    // MARK: - initializeUI
    
    func initializeUI() {
        strokeColor = UIColor.black
        strokeWidth = getStrokeWidth(tag: 0)
        
        colorSlider.color = strokeColor
        
        viewInital.strokeColor = strokeColor
        viewSignature.strokeColor = strokeColor
        viewInital.strokeWidth = strokeWidth
        viewSignature.strokeWidth = strokeWidth
        
        viewInital.clear()
        viewSignature.clear()
        
        viewInital.delegate = self
        viewSignature.delegate = self
        
        viewInital.setNeedsDisplay()
        viewSignature.setNeedsDisplay()
        
        strokeWidthButtons[0].layer.cornerRadius = 8
        strokeWidthButtons[0].tintColor = UIColor.white
        strokeWidthButtons[0].backgroundColor = ColorTheme.BtnTintEnabled
        
        setLabelState(for: lblPlaceholderInitial, isHidden: false, text: "Create Initial*")
        setLabelState(for: lblPlaceHolderSignature, isHidden: false, text: "Create Signature*")
        
        delegate?.getStrokeColorAndWidth(color: strokeColor, width: strokeWidth)
    }
    
    func setLabelState(for lbl: UILabel, isHidden: Bool, text: String) {
        lbl.text = text
        lbl.isHidden = isHidden
    }
    
    private func getStrokeWidth(tag: Int) -> CGFloat {
        switch(tag) {
        case 0:
            return 1
        case 1:
            return 1.2
        case 2:
            return 1.4
        case 3:
            return 1.6
        case 4:
            return 1.8
        case 5:
            return 2
        case 6:
            return 2.2
        case 7:
            return 2.4
        case 8:
            return 2.6
        default:
            return 2.7
        }
    }
    
    // MARK: - Observers
    
    func addObservers() {
        btnClearSignature.rx.tap
            .subscribe() { [weak self] event in
                self?.didTapOnClearSignature()
        }.disposed(by: bag)
        
        btnClearInitial.rx.tap
            .subscribe() { [weak self] event in
                self?.didTapOnClearInitial()
        }.disposed(by: bag)
    }
    
    // MARK: - Outlet Actions
    
    func didTapOnClearSignature() {
        viewSignature.clear()
        delegate?.clearHandwritten(.Signature)
        
        setLabelState(for: lblPlaceHolderSignature, isHidden: false, text: "Create Signature*")
    }

    func didTapOnClearInitial() {
        viewInital.clear()
        delegate?.clearHandwritten(.Initial)
        
        setLabelState(for: lblPlaceholderInitial, isHidden: false, text: "Create Initial*")
    }
    
    @IBAction func colorChanged(_ sender: RGSColorSlider) {
        strokeColor = sender.color
        viewInital.strokeColor = strokeColor
        viewSignature.strokeColor = strokeColor
        
        viewInital.setNeedsDisplay()
        viewSignature.setNeedsDisplay()
        
        if let _signatureimg = viewSignature.getSignature() {
            delegate?.getSignatureImage(signatureImg: _signatureimg)
        }
        if let _initialimg = viewInital.getSignature() {
            delegate?.getInitialImage(initialImg: _initialimg)
        }
        
        delegate?.getStrokeColorAndWidth(color: strokeColor, width: strokeWidth)
    }
    
    
    @IBAction func didTapOnBtnStroke(_ sender: UIButton) {
        strokeWidth = getStrokeWidth(tag: sender.tag)
        viewInital.strokeWidth = strokeWidth
        viewSignature.strokeWidth = strokeWidth
        
        viewInital.setNeedsDisplay()
        viewSignature.setNeedsDisplay()
        
        strokeWidthButtons.forEach { (btn) in
            if sender.tag == btn.tag {
                sender.layer.cornerRadius = 8
                sender.tintColor = UIColor.white
                sender.backgroundColor = ColorTheme.BtnTintEnabled
            } else {
                btn.layer.cornerRadius = 0
                btn.backgroundColor = UIColor.white
                btn.tintColor = ColorTheme.BtnTintDisabled
            }
        }
        
        if let _signatureimg = viewSignature.getSignature() {
            delegate?.getSignatureImage(signatureImg: _signatureimg)
        }
        if let _initialimg = viewInital.getSignature() {
            delegate?.getInitialImage(initialImg: _initialimg)
        }
        
        delegate?.getStrokeColorAndWidth(color: strokeColor, width: strokeWidth)
    }
}

// MARK: - PSignature Delegate

extension HandWrittenTVCell: YPSignatureDelegate {
    
    // The delegate functions gives feedback to the instanciating class. All functions are optional,
    // meaning you just implement the one you need.
    
    // didStart() is called right after the first touch is registered in the view.
    // For example, this can be used if the view is embedded in a scroll view, temporary
    // stopping it from scrolling while signing.
    func didStart(_ view : YPDrawSignatureView) {
        print("Started Drawing", view)
        delegate?.setTableScroll(enable: false)
        
        if view == viewSignature {
            setLabelState(for: lblPlaceHolderSignature, isHidden: true, text: "")
        } else {
            setLabelState(for: lblPlaceholderInitial, isHidden: true, text: "")
        }
    }
    
    // didFinish() is called rigth after the last touch of a gesture is registered in the view.
    // Can be used to enabe scrolling in a scroll view if it has previous been disabled.
    func didFinish(_ view : YPDrawSignatureView) {
        if view == viewSignature {
            if let _signatureimg = view.getSignature() {
                delegate?.getSignatureImage(signatureImg: _signatureimg)
            }
        } else {
            if let _initialimg = view.getSignature() {
                delegate?.getInitialImage(initialImg: _initialimg)
            }
        }
        delegate?.setTableScroll(enable: true)
    }
}
