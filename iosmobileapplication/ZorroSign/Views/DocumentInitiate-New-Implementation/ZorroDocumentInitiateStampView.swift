//
//  ZorroDocumentInitiateStampView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/4/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift

class ZorroDocumentInitiateStampView: ZorroDocumentInitiateBaseView {

    private var backView: UIView!
    private var imageView: UIImageView!
    private var stampLabel: UILabel!
    private let disposebag = DisposeBag()
   
}

extension ZorroDocumentInitiateStampView {
    override func setsubViews() {
        
        setbackView()
        setimageView()
        setstampLabelView()
        bringviewstoFront()
        
    }
}

extension ZorroDocumentInitiateStampView {
    fileprivate func setbackView() {
        backView = UIView()
        backView.translatesAutoresizingMaskIntoConstraints = false
        containersubView.addSubview(backView)
        
        let backviewConstraints = [backView.leftAnchor.constraint(equalTo: containersubView.leftAnchor),
                                   backView.topAnchor.constraint(equalTo: containersubView.topAnchor),
                                   backView.rightAnchor.constraint(equalTo: containersubView.rightAnchor),
                                   backView.bottomAnchor.constraint(equalTo: containersubView.bottomAnchor)]
        NSLayoutConstraint.activate(backviewConstraints)
    }
}

extension ZorroDocumentInitiateStampView {
    fileprivate func setimageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        backView.addSubview(imageView)
        
        let imageviewConstraints = [imageView.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                    imageView.topAnchor.constraint(equalTo: backView.topAnchor),
                                    imageView.rightAnchor.constraint(equalTo: backView.rightAnchor),
                                    imageView.bottomAnchor.constraint(equalTo: backView.bottomAnchor)]
        NSLayoutConstraint.activate(imageviewConstraints)
    }
}

extension ZorroDocumentInitiateStampView {
    fileprivate func setstampLabelView() {
        stampLabel = UILabel()
        stampLabel.translatesAutoresizingMaskIntoConstraints = false
        stampLabel.font = UIFont(name: "Helvetica", size: 17)
        stampLabel.textAlignment = .center
        stampLabel.adjustsFontSizeToFitWidth = true
        stampLabel.minimumScaleFactor = 0.2
        stampLabel.backgroundColor = .white
        stampLabel.textColor = .black
        backView.addSubview(stampLabel)
        
        let stamplabelConstraints = [stampLabel.leftAnchor.constraint(equalTo: backView.leftAnchor),
                                     stampLabel.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
                                     stampLabel.rightAnchor.constraint(equalTo: backView.rightAnchor),
                                     stampLabel.heightAnchor.constraint(equalToConstant: 30)]
        NSLayoutConstraint.activate(stamplabelConstraints)
    }
}

extension ZorroDocumentInitiateStampView {
    func setStamp(contacts: [ContactDetailsViewModel]) {
        
        guard let stepnumber = step else { return }
        
        if stepnumber == 1 {
            let isinitiator = DocumentHelper.sharedInstance.checkisInitiatorPresents(selectedcontacts: contacts)
            if isinitiator {
                let stampstring = ZorroTempData.sharedInstance.getStamp()
                if stampstring != "" {
                    let stampimage = getImage(signature: stampstring)
                    imageView.image = stampimage
                    stampLabel.isHidden = true
                } else {
                    SharingManager.sharedInstance.triggerstampTapped(tapped: true)
                    SharingManager.sharedInstance.onstampSelect?.observeOn(MainScheduler.instance).subscribe(onNext: { [weak self]
                        image in
                        self!.imageView.image = image
                        self!.stampLabel.isHidden = true
                    }).disposed(by: self.disposebag)
                }
            } else {
                if contacts.count == 1 {
                    stampLabel.text = contacts.first?.Name
                } else {
                    stampLabel.text = "[Multiple - \(contacts.count)]"
                }
            }
        } else {
            if contacts.count == 1 {
                stampLabel.text = contacts.first?.Name
            } else {
                stampLabel.text = "[Multiple - \(contacts.count)]"
            }
        }
    }
}
