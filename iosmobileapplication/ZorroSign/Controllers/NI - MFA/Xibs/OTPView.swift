//
//  OTPView.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

//enum VerificationStage {
//    case AddNumber, Verify
//}

class OTPView: UIView {
    
    // MARK: - Variables
    
    var stage: VerificationStage = .AddNumber

    // MARK: - Outlets
    
    @IBOutlet weak var stackMobileNumber: UIStackView!
    @IBOutlet weak var stackVerification: UIStackView!
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblMobileDetail: UILabel!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    @IBOutlet weak var btnSaveSendCode: UIButton!
    
    @IBOutlet weak var lblResendChange: UILabel!
    
    @IBOutlet weak var btnVerify: UIButton!
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
//        configUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
//        configUI()
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    func setupUI() {
        let nib = loadViewFromNib()
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nib.translatesAutoresizingMaskIntoConstraints = true
        
        addSubview(nib)
    }
    
    // MARK: - ConfigUI
    
//    func configUI() {
//        switch stage {
//        case .AddNumber:
//            stackVerification.isHidden = true
//            stackMobileNumber.isHidden = false
//            break
//        case .cha:
//            stackVerification.isHidden = false
//            stackMobileNumber.isHidden = true
//            break
//        }
//    }
}
