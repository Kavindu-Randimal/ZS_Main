//
//  ZorroAuditTrailCell.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 9/18/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroAuditTrailCell: UICollectionViewCell {
    
    private var trailtableView: UITableView!
    private let trailcellIdentifier = "trailcellidentifier"
    private var documentauditrail: [DocumentAuditTrail] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var UserStep: Steps! {
        didSet {
            setcellUI()
            setuptrailData(steps: UserStep)
        }
    }

}

//MARK: - Setup UI
extension ZorroAuditTrailCell {
    fileprivate func setcellUI() {
        
        trailtableView = UITableView(frame: .zero, style: .plain)
        trailtableView.translatesAutoresizingMaskIntoConstraints = false
        trailtableView.register(ZorroAuditCell.self, forCellReuseIdentifier: trailcellIdentifier)
        trailtableView.dataSource = self
        trailtableView.delegate = self
        trailtableView.estimatedRowHeight = UITableView.automaticDimension
        trailtableView.rowHeight = 250
        trailtableView.separatorStyle = .none
        trailtableView.bounces = false
        addSubview(trailtableView)
        
        let trailtableviewConstraints = [trailtableView.leftAnchor.constraint(equalTo: leftAnchor),
                                         trailtableView.topAnchor.constraint(equalTo: topAnchor),
                                         trailtableView.rightAnchor.constraint(equalTo: rightAnchor),
                                         trailtableView.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(trailtableviewConstraints)
    }
}

//MARK - Setup Data
extension ZorroAuditTrailCell {
    fileprivate func setuptrailData(steps: Steps) {
        let _documentauditTrail = DocumentAuditTrail()
        documentauditrail = _documentauditTrail.gettrailDetails(step: steps)
        trailtableView.reloadData()
    }
}

//MARK: - Set table view datasource
extension ZorroAuditTrailCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentauditrail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let documenttrailUnit = documentauditrail[indexPath.row]
        let auditcell = tableView.dequeueReusableCell(withIdentifier: trailcellIdentifier) as! ZorroAuditCell
        auditcell.documentaudittrail = documenttrailUnit
        return auditcell
    }
}

//MARK: - Set Table view delegate
extension ZorroAuditTrailCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
