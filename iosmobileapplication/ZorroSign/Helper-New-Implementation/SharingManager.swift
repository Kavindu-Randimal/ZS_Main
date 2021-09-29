//
//  SharingManager.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import RxSwift

class SharingManager {
    
    static let sharedInstance = SharingManager()
    
    private let _dynamicnoteRemove = PublishSubject<Int>()
    let onnoteRemove: Observable<Int>?
    private let _stampViewAdded = PublishSubject<Bool>()
    let onstampTouch: Observable<Bool>?
    private let _stampSelected = PublishSubject<UIImage>()
    let onstampSelect: Observable<UIImage>?
    private let _signatureSelected = PublishSubject<Bool>()
    let onsignatureSelect: Observable<Bool>?
    private let _attachmentCreate = PublishSubject<Bool>()
    let onattachmentCreate: Observable<Bool>?
    private let _duedateChange = PublishSubject<(Int,String)>()
    let onduedateChange: Observable<(Int,String)>?
    private let _duedateChangefromView = PublishSubject<[Steps]>()
    let onduedateChangefromView: Observable<[Steps]>?
    private let _selectDatefromPicker = PublishSubject<(Int,String)>()
    let onSelectDatefromPicker: Observable<(Int,String)>?
    
    init() {
        onnoteRemove = _dynamicnoteRemove.share(replay: 1)
        onstampTouch = _stampViewAdded.share(replay: 1)
        onstampSelect = _stampSelected.share(replay: 1)
        onsignatureSelect = _signatureSelected.share(replay: 1)
        onattachmentCreate = _attachmentCreate.share(replay: 1)
        onduedateChange = _duedateChange.share(replay: 1)
        onduedateChangefromView = _duedateChangefromView.share(replay: 1)
        onSelectDatefromPicker = _selectDatefromPicker.share(replay: 1)
    }
    
    func triggernoteRemove(removedItem: Int) {
        _dynamicnoteRemove.onNext(removedItem)
    }
    
    func triggerstampTapped(tapped: Bool) {
        _stampViewAdded.onNext(tapped)
    }
    
    func triggerstampSelected(image: UIImage) {
        _stampSelected.onNext(image)
    }
    
    func triggerSignatureSlected(tapped: Bool) {
        _signatureSelected.onNext(tapped)
    }
    
    func triggeronAttachmentCrate(created: Bool) {
        _attachmentCreate.onNext(created)
    }
    
    func triggeronDueDateChange(index:Int,duedate: String) {
        _duedateChange.onNext((index,duedate))
    }
    
    func triggeronDueDateChangeFromView(userSteps: [Steps]) {
        _duedateChangefromView.onNext(userSteps)
    }
    
    func triggerSelectDate(index:Int, date:String){
        _selectDatefromPicker.onNext((index,date))
    }
}
