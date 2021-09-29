//
//  UploadSignatureTVCell.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-01-15.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CropViewController

protocol UploadSignatureCellDelegate {
    func showImagePickerAlert(for signaturePart: SignaturePart)
    func clearImage(_ signaturePart: SignaturePart)
}

class UploadSignatureTVCell: UITableViewCell {
    
    // MARK: - Variables
    
    private var bag = DisposeBag()
    var delegate: UploadSignatureCellDelegate?

    // MARK: - Outlets
    
    @IBOutlet weak var vwBaseView: UIView!
    
    // Signature
    @IBOutlet weak var baseViewSignature: UIView!
    @IBOutlet weak var imgViewSignature: UIImageView!
    @IBOutlet weak var btnClearSignature: UIButton!
    @IBOutlet weak var btnBrowseSignature: UIButton!
    
    // Initial
    @IBOutlet weak var baseViewInitial: UIView!
    @IBOutlet weak var imgViewInital: UIImageView!
    @IBOutlet weak var btnClearInital: UIButton!
    @IBOutlet weak var btnBrowseInital: UIButton!
    
    // MARK: Set data
    
    func configCell(with model: UploadSignature) {
        vwBaseView.layer.cornerRadius = 10
        vwBaseView.addShadowAllSide()
        
        if let imgInitial = model.imgInitial {
            imgViewInital.image = imgInitial
            btnBrowseInital.setTitle("", for: .normal)
        } else {
            imgViewInital.image = UIImage()
            btnBrowseInital.setTitle("Browse initial*", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.baseViewInitial.addBorderWithCornerRadius(color: UIColor(red: 0.153, green: 0.671, blue: 0.067, alpha: 1.00))
            }
        }
        
        if let imgSignature = model.imgSignature {
            imgViewSignature.image = imgSignature
            btnBrowseSignature.setTitle("", for: .normal)
        } else {
            imgViewSignature.image = UIImage()
            btnBrowseSignature.setTitle("Browse signature*", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.baseViewSignature.addBorderWithCornerRadius(color: UIColor(red: 0.153, green: 0.671, blue: 0.067, alpha: 1.00))
            }
        }
    }
    
    // MARK: - Observers
    
    func addObservers() {
        btnClearSignature.rx.tap
            .subscribe() { [weak self] event in
                self?.delegate?.clearImage(.Signature)
                self?.imgViewSignature.image = UIImage()
                self!.btnBrowseSignature.setTitle("Browse signature*", for: .normal)
        }.disposed(by: bag)
        
        btnBrowseSignature.rx.tap
            .subscribe() { [weak self] event in
                self?.delegate?.showImagePickerAlert(for: .Signature)
        }.disposed(by: bag)
        
        btnClearInital.rx.tap
            .subscribe() { [weak self] event in
                self?.delegate?.clearImage(.Initial)
                self?.imgViewInital.image = UIImage()
                self!.btnBrowseInital.setTitle("Browse initial*", for: .normal)
        }.disposed(by: bag)
        
        btnBrowseInital.rx.tap
            .subscribe() { [weak self] event in
                self?.delegate?.showImagePickerAlert(for: .Initial)
        }.disposed(by: bag)
    }
}
