//
//  SubscriptionVC.swift
//  ZorroSign
//
//  Created by Mathivathanan on 2021-03-30.
//  Copyright © 2021 Apple. All rights reserved.
//

import UIKit
import StoreKit

// In-App Purchase product type

enum ProductType: String, CaseIterable {
    case businessPlan = "ZSBP", professionalPlan = "ZSPA", autorenew = "testauto01"
}

//enum ProductType: String {
//
//    case subscription =  "tf_pkg_monthly"
//
//    static var all: [ProductType] {
//        return [.subscription]
//    }
//}

// Handling all In-App Purchase

enum InAppErrors: Swift.Error {
    case noSubscriptionPurchased
    case noHintAvailable
    
    var localizedDescription: String {
        switch self {
        case .noSubscriptionPurchased:
            return "No subscription purchased"
        case .noHintAvailable:
            return "No clues available"
        }
    }
}

// MARK: - In-app purchase delegate

protocol InAppManagerDelegate: class {
    func inAppLoadingStarted()
    func inAppLoadingSucceded(productType: ProductType)
    func inAppLoadingFailed(error: Swift.Error?)
}

class SubscriptionVC: UIViewController, UITextFieldDelegate {
    
    // In-app purchase Variables
    
    let vm = SubscriptionVM()
    
    var productsRequest = SKProductsRequest()
    var iapProducts     = [SKProduct]()
    
    var selectedProduct: ProductType = .professionalPlan
    var isFromMyAccountOrBanner = false
    
    weak var delegate: InAppManagerDelegate?
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblUpgradeMessage: UILabel!
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var lblPriceDetailMonth: UILabel!
    @IBOutlet weak var lblTermsPrivacy: UILabel!
    
    @IBOutlet weak var viewDescription: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popUpBaseView: UIView!
    @IBOutlet weak var btnOutside: UIButton!
    @IBOutlet weak var viewOrganizationName: UIView!
    @IBOutlet weak var txtFieldOrganizationName: UITextField! {
        didSet {
            txtFieldOrganizationName.delegate = self
        }
    }
    @IBOutlet weak var btnCOuntine: UIButton!
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setDisplayProfessional()
        fetchAvailableProducts()
        SKPaymentQueue.default().add(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        UINavigationBar.appearance().tintColor = UIColor(red: 0.00, green: 0.60, blue: 0.07, alpha: 1.00)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        SKPaymentQueue.default().remove(self)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: - ConfigUI
    
    func setupPopup() {
        popupView.isHidden = false
        popUpBaseView.layer.cornerRadius = 10
        btnCOuntine.layer.cornerRadius = 10
        btnCOuntine.backgroundColor = ColorTheme.btnBG
        btnCOuntine.setTitleColor(ColorTheme.btnTextWithBG, for: .normal)
        popupView.backgroundColor = .clear //UIColor(red: 0.55, green: 0.55, blue: 0.55, alpha: 0.8)
        
        viewOrganizationName.layer.cornerRadius = 10
        viewOrganizationName.layer.borderWidth = 2
        viewOrganizationName.layer.borderColor = UIColor.lightGray.cgColor
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = view.bounds
        blurredEffectView.tag = Constants.BLURVIEW_SUBSCRIPTION
        baseView.addSubview(blurredEffectView)
    }
    
    func setupUI() {
        popupView.isHidden = true
        
        if isFromMyAccountOrBanner {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        btnBuy.layer.cornerRadius = 8
        btnBuy.setTitleColor(.white, for: .normal)
        btnBuy.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.07, alpha: 1.00)
        
        lblDescription.textColor = .white
        viewDescription.backgroundColor = UIColor(red: 0.00, green: 0.60, blue: 0.07, alpha: 1.00)
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let selectedTextAttribute = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.00, green: 0.60, blue: 0.07, alpha: 1.00)]
        segmentControl.setTitleTextAttributes(titleTextAttributes, for: .normal)
        segmentControl.setTitleTextAttributes(selectedTextAttribute, for: .selected)
        
        // MARK: - DISABLED THE BUTTON FOR RELEASE
        /// Please change it later
        btnBuy.isEnabled = false
    }
    
    func setDisplayProfessional() {
        imageView.image = UIImage(named: "doc") ?? UIImage()
        lblUpgradeMessage.text = "Upgrade to ZorroSign Professional"
        setButtonTitle(price: "$119.99", rest: " / Year")
        lblPriceDetailMonth.text = "(12 months at $9.99/mo)"
        lblDescription.text = "Unlock 240 document sets per year"
    }
    
    func setDisplayBusiness() {
        imageView.image = UIImage(named: "doc+") ?? UIImage()
        lblUpgradeMessage.text = "Upgrade to ZorroSign Business"
        setButtonTitle(price: "239.99", rest: " / Year for 1 user")
        lblPriceDetailMonth.text = "(12 months at $19.99/mo)"
        lblDescription.text = "Unlock unlimited document sets"
    }
    
    func setButtonTitle(price: String, rest: String) {
        let attributedString = NSMutableAttributedString()
        
        let attributes = [ NSAttributedString.Key.font: UIFont(name: "Helvetica-Bold", size: 17.0)! ]
        let firstString = NSMutableAttributedString(string: price, attributes: attributes )
        
        let secondString = NSAttributedString(string: rest, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)])
        attributedString.append(firstString)
        attributedString.append(secondString)
        
        btnBuy.setAttributedTitle(attributedString, for: .normal)
    }
    
    // MARK: - Outlet Actions
    
    @IBAction func didTapOnTerms(_ sender: Any) {
        if let url = URL(string: "https://www.zorrosign.com/terms-and-conditions/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func didTapOnPrivacy(_ sender: Any) {
        if let url = URL(string: "https://www.zorrosign.com/privacy-policy") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func valueChangedSegment(_ sender: UISegmentedControl) {
        txtFieldOrganizationName.text = ""
        vm.iapTransactionDetail.organizationName = nil
        
        switch sender.selectedSegmentIndex {
        case 0:
            // Professional Plan
            setDisplayProfessional()
            selectedProduct = .professionalPlan
            break
        case 1:
            // Business Plan
            setDisplayBusiness()
            selectedProduct = .businessPlan
            break
        default:
            break
        }
    }
    
    @IBAction func didTapOnBuy(_ sender: UIButton) {
        // Show pop up to get the Organization Name
        setupPopup()
    }
    
    @IBAction func didTapOnSkip(_ sender: Any) {
        Singletone.shareInstance.showActivityIndicatory(uiView: view)
        biometricsOnboarding()
    }
    
    @IBAction func didTapOnOutSideButton(_ sender: Any) {
        view.endEditing(true)
        popupView.isHidden = true
        vm.iapTransactionDetail.organizationName = nil
        txtFieldOrganizationName.text = ""
        
        if let viewWithTag = self.view.viewWithTag(Constants.BLURVIEW_SUBSCRIPTION) {
            viewWithTag.removeFromSuperview()
        }
    }
    
    @IBAction func endEditingOrganizationName(_ sender: UITextField) {
        vm.iapTransactionDetail.organizationName = sender.text
    }
    
    @IBAction func didTapOnCountine(_ sender: Any) {
        view.endEditing(true)
        if let organizationName = vm.iapTransactionDetail.organizationName {
            if organizationName.isEmpty {
                AlertProvider.init(vc: self).showAlert(title: "Alert", message: "Please enter a organisation name.", action: AlertAction(title: "Okay"))
            } else {
                popupView.isHidden = true
                if selectedProduct == ProductType.professionalPlan {
                    purchaseProduct(productType: ProductType(rawValue: ProductType.professionalPlan.rawValue)!)
                } else if selectedProduct == ProductType.businessPlan {
                    purchaseProduct(productType: ProductType(rawValue: ProductType.businessPlan.rawValue)!)
                }
            }
        } else {
            AlertProvider.init(vc: self).showAlert(title: "Alert", message: "Please enter a organisation name.", action: AlertAction(title: "Okay"))
        }
    }
}

// MARK: - Subscription logic based functions

extension SubscriptionVC: SKProductsRequestDelegate,SKPaymentTransactionObserver {
    
    // Product fetch request
    
    func fetchAvailableProducts() {
        let productIdentifiers = Set<String>(ProductType.allCases.map({$0.rawValue}))
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    // Getting available Products
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.iapProducts = response.products
    }
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct(productType: ProductType) {
        if self.canMakePurchases() {
            guard let product = self.iapProducts.filter({$0.productIdentifier == productType.rawValue}).first else {
                self.delegate?.inAppLoadingFailed(error: InAppErrors.noSubscriptionPurchased)
                AlertProvider.init(vc: self).showAlert(title: "Something went wrong, Please try again", message: "", action: AlertAction(title: "Dismiss"))
                return
            }
            Singletone.shareInstance.showActivityIndicatory(uiView: view)
            let payment = SKMutablePayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            self.fetchAvailableProducts()
        }
    }
    
    func callSandboxURLtoVerifyReceipt() {
        self.vm.netReqReceiptValidation(url: Singletone.shareInstance.verifyReceiptSandbox) { (success, statusCode, message) in
            if success {
                self.postTransactionData()
            } else {
                self.navigateToNext()
            }
        }
    }
    
    func postTransactionData() {
        self.vm.netReqPostTransactionData { (success, statusCode, message) in
            if success {
                ZorroTempData.sharedInstance.setUserSubscribedOrNot(subscribed: true)
                UserDefaults.standard.set(true, forKey: "AdminFlag")
                self.navigateToNext()
            } else {
                self.navigateToNext()
            }
        }
    }
    
    func navigateToNext() {
        if isFromMyAccountOrBanner {
            Singletone.shareInstance.stopActivityIndicator()
            self.navigationController?.popViewController(animated: true)
        } else {
            biometricsOnboarding()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    vm.netReqReceiptValidation(url: Singletone.shareInstance.verifyReceiptProd) { (success, statusCode, message) in
                        if success {
                            self.postTransactionData()
                        } else {
                            if statusCode == 21007 {
                                self.callSandboxURLtoVerifyReceipt()
                            } else {
                                self.navigateToNext()
                            }
                        }
                    }
                    break
                    
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    Singletone.shareInstance.stopActivityIndicator()
                    if let viewWithTag = self.view.viewWithTag(Constants.BLURVIEW_SUBSCRIPTION) {
                        viewWithTag.removeFromSuperview()
                    }
                    AlertProvider(vc: self).showAlert(title: "Purchase Failed", message: "Your purchase could not be completed due to an issue.", action: AlertAction(title: "Dismiss"))
                    break
                    
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().restoreCompletedTransactions()
                    break
                    
                default:
                    break
                }
            }
        }
    }
    
    private func biometricsOnboarding() {
        
        let username: String = ZorroTempData.sharedInstance.getpasswordlessUser()
        let deviceid: String = ZorroTempData.sharedInstance.getpasswordlessUUID()
        
        ZorroHttpClient.sharedInstance.passwordlessStatusCheck(username: username.stringByAddingPercentEncodingForRFC3986() ?? "", deviceid: deviceid) { (onboarded, keyid) in
            Singletone.shareInstance.stopActivityIndicator()
            
            if !onboarded {
                let passwordlessIntroController = PasswordlessIntroController()
                passwordlessIntroController.providesPresentationContextTransitionStyle = true
                passwordlessIntroController.definesPresentationContext = true
                passwordlessIntroController.modalPresentationStyle = .overCurrentContext
                
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
                self.view.window?.layer.add(transition, forKey: kCATransition)
                
                DispatchQueue.main.async {
                    self.present(passwordlessIntroController, animated: false, completion: nil)
                }
                
                passwordlessIntroController.skipCallBack = { skip in
                    if skip {
                        
                        let appdelegate = UIApplication.shared.delegate
                        let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                        let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                        DispatchQueue.main.async {
                            appdelegate?.window!?.rootViewController = viewcontroller
                        }
                    }
                    return
                }
                
                passwordlessIntroController.onBoardStatus = {
                    let appdelegate = UIApplication.shared.delegate
                    let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
                    let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
                    DispatchQueue.main.async {
                        appdelegate?.window!?.rootViewController = viewcontroller
                    }
                    return
                }
                return
            }
            
            let appdelegate = UIApplication.shared.delegate
            let storyboad = UIStoryboard.init(name: "Main", bundle: nil)
            let viewcontroller = storyboad.instantiateViewController(withIdentifier: "reveal_SBID")
            DispatchQueue.main.async {
                appdelegate?.window!?.rootViewController = viewcontroller
            }
            return
        }
        return
    }
}
