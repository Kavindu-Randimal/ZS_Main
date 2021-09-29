//
//  ComputerGeneratedTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-09.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

protocol ComputerGeneratedCellDelegate {
    func getFontStyle(font: String)
    func getStrokeColor(color: UIColor)
    func getInitial(initial value: String, image: UIImage)
    func getSignature(signature value: String, image: UIImage)
    func clearComputerGenerated(_ signaturePart: SignaturePart)
}

class ComputerGeneratedTVCell: UITableViewCell {
    
    // MARK: - Variables
    
    private var bag = DisposeBag()
    var delegate: ComputerGeneratedCellDelegate?
    
    var initialText: String = ""
    var signatureText: String = ""
    
    var strokeColor: UIColor = UIColor.black
    var selectedFont: String = "Pacifico"
    
    // PickerData
    var tempFont: String?
    var fontTypes = ["Pacifico","Satisfy","HomemadeApple","OvertheRainbow","Tangerine","BadScript","Signerica","Scotosaurus","MySillyWillyGirl","NellaSueDemo"]
    let fontArray = ["Pacifico","Satisfy-Regular","HomemadeApple-Regular","OvertheRainbow","Tangerine-Regular","BadScript-Regular","SignericaMedium","Scotosaurus","MySillyWillyGirl","NellaSueDemo"]
    
    private var isPickerShown: Bool = false
    private let hiddenField = UITextField()
    private var fontPicker = UIPickerView()
    
    // MARK: - Outlets
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var btnSelectFont: UIButton!
    
    @IBOutlet weak var viewSignature: UIView!
    @IBOutlet weak var btnClearSignature: UIButton!
    @IBOutlet weak var textFieldSignature: UITextField!
    
    @IBOutlet weak var viewInitial: UIView!
    @IBOutlet weak var btnClearInital: UIButton!
    @IBOutlet weak var textFieldInitial: UITextField!
    
    @IBOutlet weak var viewColorSlider: RGSColorSlider!
    
    // MARK: - ConfigUI
    
    func configUI() {
        viewSignature.layer.cornerRadius = 10
        viewSignature.layer.borderWidth = 1
        viewSignature.layer.borderColor = UIColor.lightGray.cgColor
        
        viewInitial.layer.cornerRadius = 10
        viewInitial.layer.borderWidth = 1
        viewInitial.layer.borderColor = UIColor.lightGray.cgColor
        
        baseView.layer.cornerRadius = 10
        baseView.addShadowAllSide()
    }
    
    // MARK: - InitializeUI
    
    func initializeUI(initial: String, signature: String, strokeColor: UIColor) {
        initialText = initial
        signatureText = signature
        
        textFieldInitial.text = initial
        textFieldSignature.text = signature
        
        textFieldInitial.font = UIFont(name: selectedFont, size: 30)
        textFieldSignature.font = UIFont(name: selectedFont, size: 30)
        
        textFieldInitial.textColor = strokeColor
        textFieldSignature.textColor = strokeColor
        
        self.strokeColor = strokeColor
        viewColorSlider.color = strokeColor
        
        textFieldInitial.delegate = self
        textFieldSignature.delegate = self
        
        delegate?.getFontStyle(font: selectedFont)
        delegate?.getStrokeColor(color: strokeColor)
    }
    
    // MARK: - Observers
    
    func addObservers() {
        btnClearSignature.rx.tap
            .subscribe() { [weak self] event in
                self?.didTapOnClearSignature()
        }.disposed(by: bag)
        
        btnClearInital.rx.tap
            .subscribe() { [weak self] event in
                self?.didTapOnClearInitial()
        }.disposed(by: bag)
    }
    
    func setLabelState(for lbl: UILabel, isHidden: Bool, text: String) {
        lbl.text = text
        lbl.isHidden = isHidden
    }
    
    // MARK: - Outlet Actions
    
    func didTapOnClearSignature() {
        signatureText = ""
        textFieldSignature.text = ""
        delegate?.clearComputerGenerated(.Signature)
    }

    func didTapOnClearInitial() {
        initialText = ""
        textFieldInitial.text = ""
        delegate?.clearComputerGenerated(.Initial)
    }
    
    // TextField Outlets
    
    @IBAction func didBeginEditingSignature(_ sender: Any) {
        isPickerShown = false
    }
    
    @IBAction func didBeginEditingInitial(_ sender: Any) {
        isPickerShown = false
    }
    
    @IBAction func didEndEditingSignature(_ sender: UITextField) {
        signatureText = sender.text ?? ""
        fontPicker.reloadAllComponents()
        
        delegate?.getSignature(signature: signatureText, image: getStringAsImage(tf: textFieldSignature))
    }
    
    @IBAction func didEndEditingInitial(_ sender: UITextField) {
        initialText = sender.text ?? ""
        
        delegate?.getInitial(initial: initialText, image: getStringAsImage(tf: textFieldInitial))
    }
    
    // Other Outlets
    
    @IBAction func didTapOnSelectFont(_ sender: Any) {
        showFontPicker()
    }
    
    @IBAction func colorChanged(_ sender: RGSColorSlider) {
        strokeColor = sender.color
        textFieldInitial.textColor = strokeColor
        textFieldSignature.textColor = strokeColor
        delegate?.getStrokeColor(color: strokeColor)
        delegate?.getSignature(signature: signatureText, image: getStringAsImage(tf: textFieldSignature))
        delegate?.getInitial(initial: initialText, image: getStringAsImage(tf: textFieldInitial))
    }
    
    func getStringAsImage(tf: UITextField)-> UIImage {
        tf.layer.masksToBounds = false
        tf.layer.borderWidth = 0
        tf.backgroundColor = .clear

        let rect: CGRect = tf.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, tf.isOpaque, 0.0)
        
        let context = UIGraphicsGetCurrentContext()
        
        if let _context = context {
            tf.layer.render(in: _context)
        }
        
        let imgTF: UIImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()

        return imgTF
    }
}

// MARK: - Setup Picker

extension ComputerGeneratedTVCell {
    
    func setUpPicker() {
        fontPicker.delegate = self
        
        hiddenField.isHidden = true
        hiddenField.inputView = fontPicker
        hiddenField.inputAccessoryView = toolBarForPicker()
        
        baseView.addSubview(hiddenField)
    }
    
    func showFontPicker() {
        isPickerShown = !isPickerShown
        
        if isPickerShown {
            hiddenField.becomeFirstResponder()
        } else {
            hiddenField.resignFirstResponder()
        }
    }
    
    func toolBarForPicker() -> UIToolbar {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .darkGray
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneGender))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.done, target: self, action: #selector(cancel))

        doneButton.tintColor = baseView.tintColor
        cancelButton.tintColor = baseView.tintColor
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    @objc func doneGender() {
        hiddenField.resignFirstResponder()
    }
    
    @objc func cancel() {
        hiddenField.resignFirstResponder()
    }
}

// MARK: - TextField Delegate

extension ComputerGeneratedTVCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.letters.union(CharacterSet(charactersIn: " "))
        
        if textField == self.textFieldInitial {
            // For intial
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            guard newText.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
            guard newText.count <= 3 else { return false }
            
            return true
        } else {
            //For signature
            let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            guard newText.rangeOfCharacter(from: allowedCharacters.inverted) == nil else { return false }
            
            return true
        }
    }
}

// MARK: - PickerView Delegate

extension ComputerGeneratedTVCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fontTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var label: UILabel
        
        if let v = view as? UILabel{
            label = v
        } else {
            label = UILabel()
        }
        
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont(name: fontArray[row], size: 30)
        
        if signatureText.isEmpty {
            label.text = fontTypes[row]
        } else {
            label.text = signatureText
        }
        
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedFont = fontArray[row]
        
        textFieldInitial.font = UIFont(name: selectedFont, size: 30)
        textFieldSignature.font = UIFont(name: selectedFont, size: 30)
        
        delegate?.getFontStyle(font: selectedFont)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
    }
}
