//
//  SignatureTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-24.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SignatureCellDelegate {
    func didTapOnEdit(signatureNo: SignatureNo)
    func didTapOnDelete(signatureNo: SignatureNo)
    func didTapOnDefault(index: Int)
}

class SignatureTVCell: UITableViewCell {
    
    // MARK: - Variables
    
    var delegate: SignatureCellDelegate?
    
    var isDefault: Bool = false
    var signatureNo: SignatureNo?
    var defaultSignature: UserSettings?
    var optionalSignatures: UserSignature?
    var optionalSigIndexNo: Int?
    
    // MARK: - Outlets
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var btnDefault: UIButton!
    @IBOutlet weak var imgViewDefault: UIImageView!
    @IBOutlet weak var lblSignatureNo: UILabel!
    
    @IBOutlet weak var signatureBaseView: UIView!
    @IBOutlet weak var imgSignature: UIImageView!
    @IBOutlet weak var imgInitial: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configUI()
    }
    
    override func prepareForReuse() {
        isDefault = false
        signatureNo = nil
        defaultSignature = nil
        optionalSignatures = nil
        optionalSigIndexNo = nil
    }
    
    // MARK: - Set Default Signature
    
    func setDefaultSignature(signature: UserSettings?, isDefault: Bool) {
        self.isDefault = isDefault
        defaultSignature = signature
        
        setUI()
    }
    
    // MARK: - Set Optional Signature
    
    func setOptionalSignature(signature: UserSignature?, isDefault: Bool, signatureIndex: Int) {
        self.isDefault = isDefault
        optionalSignatures = signature
        optionalSigIndexNo = signatureIndex
        
        setUI()
    }
    
    // MARK: - SetUI
    
    func setUI() {
        if isDefault {
            setRadioBtnAsSelected()
           
            // Show edit option for computer generated signature
            if let _signatureType = defaultSignature?.signatureType {
                if _signatureType == SignatureType.ComputerGenerated.rawValue {
                    btnEdit.isHidden = true
                } else {
                    btnEdit.isHidden = true
                }
            }
            
            // Set Signatures
            if let _signatureImage = defaultSignature?.signatureImage {
                imgSignature.image = convertBase64StringToImage(imageBase64String: _signatureImage.components(separatedBy: ",")[1])
            }
            if let _initialImage = defaultSignature?.initialImage {
                imgInitial.image = convertBase64StringToImage(imageBase64String: _initialImage.components(separatedBy: ",")[1])
            }
        } else {
            setRadioBtnAsDeSelected()
            
            // Show edit option only for computer generated signature
            if let _signatureType = optionalSignatures?.Settings?.signatureType {
                if _signatureType == SignatureType.ComputerGenerated.rawValue {
                    btnEdit.isHidden = true
                } else {
                    btnEdit.isHidden = true
                }
            }
            
            // Set Signatures
            if let _signatureImage = optionalSignatures?.Signature {
                imgSignature.image = convertBase64StringToImage(imageBase64String: _signatureImage.components(separatedBy: ",")[1])
            }
            if let _initialImage = optionalSignatures?.Initials {
                imgInitial.image = convertBase64StringToImage(imageBase64String: _initialImage.components(separatedBy: ",")[1])
            }
        }
    }
    
    func convertBase64StringToImage(imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData!)
        return image!
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        baseView.layer.cornerRadius = 10
        baseView.addShadowAllSide()
    }
    
    func setRadioBtnAsSelected() {
        imgViewDefault.layer.borderWidth = 0
        imgViewDefault.image = UIImage(named: "Radio_button_gray")
        imgViewDefault.tintColor = ColorTheme.BtnTintEnabled
    }
    
    func setRadioBtnAsDeSelected() {
        imgViewDefault.image = UIImage()
        imgViewDefault.layer.cornerRadius = 13
        imgViewDefault.layer.borderColor = UIColor.darkGray.cgColor
        imgViewDefault.layer.borderWidth = 1
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func didTapOnBtnDefault(_ sender: Any) {
        if !isDefault {
            isDefault = !isDefault
            if isDefault {
                setRadioBtnAsSelected()
            } else {
                setRadioBtnAsDeSelected()
            }
            
            if let _optionalSigIndexNo = optionalSigIndexNo {
                delegate?.didTapOnDefault(index: _optionalSigIndexNo)
            }
        }
    }
    
    @IBAction func didTapOnEdit(_ sender: Any) {
        if let _signatureNo = signatureNo {
            delegate?.didTapOnEdit(signatureNo: _signatureNo)
        }
    }
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        if let _signatureNo = signatureNo {
            delegate?.didTapOnDelete(signatureNo: _signatureNo)
        }
    }
}
