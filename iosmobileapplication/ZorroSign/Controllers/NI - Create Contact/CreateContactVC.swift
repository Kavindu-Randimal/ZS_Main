//
//  CreateContactVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 10/7/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CreateContactVC: UIViewController {
    
    // MARK: - Variables
    
    private let vm = CreateContactVM()
    private let bag = DisposeBag()
    
    // MARK: - Outlets
    
    // TextFields
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldMiddleName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldDisplayName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldCompany: UITextField!
    @IBOutlet weak var textFieldJobTitle: UITextField!
    
    // Buttons
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnCreate: UIButton!
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
        addObservers()
    }
    
    // MARK: - ConfigUI
    
    func configUI() {
        
    }
    
    // MARK: - Observers
    
    func addObservers() {
        
        // TextFields
        
        textFieldFirstName.rx.text
            .orEmpty
            .bind(to: vm.firstName)
            .disposed(by: bag)
        
        textFieldMiddleName.rx.text
            .orEmpty
            .bind(to: vm.middelName)
            .disposed(by: bag)
        
        textFieldLastName.rx.text
            .orEmpty
            .bind(to: vm.lastName)
            .disposed(by: bag)
        
        textFieldDisplayName.rx.text
            .orEmpty
            .bind(to: vm.displayName)
            .disposed(by: bag)
        
        textFieldEmail.rx.text
            .orEmpty
            .bind(to: vm.email)
            .disposed(by: bag)
        
        textFieldJobTitle.rx.text
            .orEmpty
            .bind(to: vm.jobTitle)
            .disposed(by: bag)
        
        // Buttons
        
        btnCreate.rx.tap
            .subscribe() {[weak self] event in
                self?.didTapOnCreate()
            }
            .disposed(by: bag)
        
        btnCancel.rx.tap
            .subscribe() {[weak self] event in
                self?.didTapOnCancel()
            }
            .disposed(by: bag)
    }
    
    // MARK: - DidTapOn Create
    
    func didTapOnCreate() {
        
    }
    
    // MARK: - DidTapOn Cancel
    
    func didTapOnCancel() {
        self.navigationController?.popViewController(animated: true)
    }
}
