//
//  ZorroAuditTrailView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import RxSwift

class ZorroAuditTrailView: UIView {
    
    private var separatorView: UIView!
    private var auditrailTitle: UILabel!
    private var auditrailcollectionView: UICollectionView!
    private let auditratilCellidentifier = "auditrailcellidentifier"
    
    private let disposebag = DisposeBag()
    
    var UserSteps: [Steps] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let x = UserSteps
        print(x)
        setupAudiTrailCollectionView()
        updateduefromView()
        updateCellWhenDateIsSelected()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Setup audit trail collection view
extension ZorroAuditTrailView {
    fileprivate func setupAudiTrailCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        auditrailcollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        auditrailcollectionView.translatesAutoresizingMaskIntoConstraints = false
        auditrailcollectionView.register(ZorroAuditTrailCell.self, forCellWithReuseIdentifier: auditratilCellidentifier)
        auditrailcollectionView.backgroundColor = .clear
        auditrailcollectionView.contentInset = UIEdgeInsets(top: 20, left: 30, bottom: -20, right: 30)
        auditrailcollectionView.delegate = self
        auditrailcollectionView.dataSource = self
        auditrailcollectionView.backgroundColor = .white
        addSubview(auditrailcollectionView)
        
        let auditrailcollectionviewConstraints = [auditrailcollectionView.leftAnchor.constraint(equalTo: leftAnchor),
                                                  auditrailcollectionView.topAnchor.constraint(equalTo: topAnchor),
                                                  auditrailcollectionView.rightAnchor.constraint(equalTo: rightAnchor),
                                                  auditrailcollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        
        NSLayoutConstraint.activate(auditrailcollectionviewConstraints)
    }
}

//MARK: Collectionview datasource methods
extension ZorroAuditTrailView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("step count : \(UserSteps.count)")
        return UserSteps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let trailmaincell = collectionView.dequeueReusableCell(withReuseIdentifier: auditratilCellidentifier, for: indexPath) as! ZorroAuditTrailCell
        let step = UserSteps[indexPath.row]
        trailmaincell.UserStep = step
        return trailmaincell
    }
}

//MARK: Collection view delegates
extension ZorroAuditTrailView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.frame.width/2.5
        let height = self.frame.height
        return CGSize(width: width, height: height)
    }
}

//MARK: Sharing manager
extension ZorroAuditTrailView {
    fileprivate func updateduefromView() {
        SharingManager.sharedInstance.onduedateChangefromView?.observeOn(MainScheduler.instance).subscribe(onNext:{
            [weak self] newusersteps in
            self?.UserSteps = newusersteps
            self?.auditrailcollectionView.reloadData()
        }).disposed(by: disposebag)
    }
}

//MARK: Update cell with picker date
extension ZorroAuditTrailView{
    fileprivate func updateCellWhenDateIsSelected(){
        SharingManager.sharedInstance.onSelectDatefromPicker?.observeOn(MainScheduler.instance).subscribe(onNext:{
            [weak self] cellDetails in
            let (cellIndex,dueDate) = cellDetails
            
            for i in 0..<(self!.UserSteps.count){
                if(self!.UserSteps[i].StepNo == String(cellIndex+1)){
                    for j in 0..<(self!.UserSteps[i].Tags.count){
                        self!.UserSteps[i].Tags[j].dueDate = dueDate
                    }
                }
            }
            //self?.auditrailcollectionView.reloadData()
            let indexPath = IndexPath(row: cellIndex, section: 0)
            self?.auditrailcollectionView.reloadItems(at: [indexPath])
            SharingManager.sharedInstance.triggeronDueDateChangeFromView(userSteps: self!.UserSteps)
        }).disposed(by: disposebag)
    }
}
