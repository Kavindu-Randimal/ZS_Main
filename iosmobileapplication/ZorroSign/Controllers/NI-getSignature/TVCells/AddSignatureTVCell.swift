//
//  AddSignatureTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-24.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AddSignatureCellDelegate {
    func didTapOnAddSiganture()
}

class AddSignatureTVCell: UITableViewCell {

    // MARK: - Variables
    
    private var bag = DisposeBag()
    var delegate: AddSignatureCellDelegate?
    
    // MARK: - Outlet
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var viewAddSignature: UIView!
    @IBOutlet weak var btnAddSignature: UIButton!
    @IBOutlet weak var lblSignatureNo: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configUI()
        // addObservers()
    }
    
    // MARK: - Observers
    
    func addObservers() {
//        btnAddSignature.rx.tap
//            .subscribe() { [weak self] event in
//                self?.didTapOnAddSignature()
//            }
//            .disposed(by: bag)
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        baseView.layer.cornerRadius = 10
        baseView.addShadowAllSide(radius: 8)
        
        viewAddSignature.layer.borderWidth = 1
        viewAddSignature.layer.cornerRadius = 6
        viewAddSignature.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func didTapOnAddSignature() {
        self.delegate?.didTapOnAddSiganture()
    }
    
    @IBAction func didTapOnAddSignature(_ sender: Any) {
        didTapOnAddSignature()
    }
}
