//
//  OTPTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 12/6/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ADCountryPicker

enum VerificationStage {
    case AddNumber, ChangeNumber
}

protocol OTPTVCellDelegate {
    func showCountryPicker()
}

class OTPTVCell: UITableViewCell {
    
    // MARK: - Variables
    
    var stage: VerificationStage = .AddNumber
    var delegate: OTPTVCellDelegate?
    var bag = DisposeBag()

    // MARK: - Outlets
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var stackMobileNumber: UIStackView!
    
    @IBOutlet weak var lblHeader1: UILabel!
    @IBOutlet weak var lblMobileDetail: UILabel!
    
    @IBOutlet weak var btnCountry: UIButton!
    @IBOutlet weak var imgCountry: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var textFieldMobileNumber: UITextField!
    
    @IBOutlet weak var btnSaveSendCode: UIButton!

    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        baseView.layer.cornerRadius = 10
        baseView.addShadowAllSide()
        
        btnSaveSendCode.layer.cornerRadius = 10
    }
    
    // MARK: - ConfigUI

    func configUI() {
        addObservers()
        
        switch stage {
        case .AddNumber:
            imgCountry.image = setcountryImage(countryCode: "US")
            lblCountryCode.text = "+1"
            break
        case .ChangeNumber:
            break
        }
    }
    
    private func setcountryImage(countryCode: String) -> UIImage? {
        let bundle = "assets.bundle/"
        let image = UIImage(named: bundle + countryCode + ".png",
        in: Bundle(for: ADCountryPicker.self), compatibleWith: nil)
        
        return image ?? nil
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        
        btnCountry.rx.tap
            .subscribe() {[weak self] event in
                self?.delegate?.showCountryPicker()
            }
            .disposed(by: bag)
    }
}
