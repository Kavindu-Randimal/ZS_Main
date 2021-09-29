//
//  DocumentRenameDetailsController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 1/29/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class DocumentRenameDetailsController: UIViewController {

    private var renameTableView: UITableView!
    private var renamecellIdentifier = "renamecellIdentifier"
    var documentrenameHistory: RenameDocument!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeviewContentSize()
        setupRenameTableView()
    }
}

extension DocumentRenameDetailsController {
    private func changeviewContentSize() {
        let contentHeight = 160 * (documentrenameHistory?.renamedocumentSub.count)!
        self.preferredContentSize.height = CGFloat(contentHeight)
    }
}

extension DocumentRenameDetailsController {
    private func setupRenameTableView() {
        
        renameTableView = UITableView(frame: .zero, style: .plain)
        renameTableView.translatesAutoresizingMaskIntoConstraints = false
        renameTableView.register(DocumentRenameCell.self, forCellReuseIdentifier: renamecellIdentifier)
        renameTableView.dataSource = self
        renameTableView.delegate = self
        renameTableView.tableFooterView = UIView()
        renameTableView.estimatedRowHeight = 200
        renameTableView.rowHeight = UITableView.automaticDimension
        renameTableView.separatorStyle = .none
        view.addSubview(renameTableView)
        
        let renametableviewConstraints = [renameTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                          renameTableView.topAnchor.constraint(equalTo: view.topAnchor),
                                          renameTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                          renameTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        
        NSLayoutConstraint.activate(renametableviewConstraints)
    }
}

extension DocumentRenameDetailsController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (documentrenameHistory?.renamedocumentSub.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let renamehistoryIndex = documentrenameHistory?.renamedocumentSub[indexPath.row]
        let renamecell = tableView.dequeueReusableCell(withIdentifier: renamecellIdentifier) as! DocumentRenameCell
        renamecell.renamehistorydetails = renamehistoryIndex
        return renamecell
    }
}

extension DocumentRenameDetailsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
