//
//  DocumentSignElementSelectController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentSignElementSelectController: UIViewController {
    
    private var elementTableView: UITableView!
    private var elementIdentifier = "elementidentifier"
    var addelementCallBack: ((String, Int) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setelemetTableView()
    }
}

extension DocumentSignElementSelectController {
    fileprivate func setelemetTableView() {
        self.view.backgroundColor = ColorTheme.alertTint
        elementTableView = UITableView(frame: .zero, style: .plain)
        elementTableView.translatesAutoresizingMaskIntoConstraints = false
        elementTableView.register(DocumentSignElementCell.self, forCellReuseIdentifier: elementIdentifier)
        elementTableView.dataSource = self
        elementTableView.delegate = self
        elementTableView.tableFooterView = UIView()
        elementTableView.rowHeight = 0.0
        view.addSubview(elementTableView)
        
        let elementtableviewConstraints = [elementTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                           elementTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                                           elementTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                           elementTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant:  -5)]
        NSLayoutConstraint.activate(elementtableviewConstraints)
    }
}

//MARK: Datasource methods
extension DocumentSignElementSelectController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let elementcell = tableView.dequeueReusableCell(withIdentifier: elementIdentifier) as! DocumentSignElementCell
        elementcell.elementIndex = indexPath.row
        return elementcell
    }
}

//MARK: Delegate methods
extension DocumentSignElementSelectController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 8 || indexPath.row == 14 {
            return 44
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addelementCallBack!("new element added", indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
}
