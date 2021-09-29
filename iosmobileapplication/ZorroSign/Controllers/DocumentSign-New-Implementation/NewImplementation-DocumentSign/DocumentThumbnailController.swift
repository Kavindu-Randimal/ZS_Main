//
//  DocumentThumbnailController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/16/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import PDFKit

class DocumentThumbnailController: UIViewController {

    private var thumbnailcollectionView: UICollectionView!
    private let thumbnailcellIdentifier = "thumbnailIdentifier"
    var pdfDocumet: PDFDocument!
    var pageSelected: ((Int) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupthumbnailCollectoinView()
    }
}


extension DocumentThumbnailController {
    fileprivate func setupthumbnailCollectoinView() {
        self.view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        thumbnailcollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        thumbnailcollectionView.translatesAutoresizingMaskIntoConstraints = false
        thumbnailcollectionView.backgroundColor = .white
        thumbnailcollectionView.register(DocumentThumbnailCell.self, forCellWithReuseIdentifier: thumbnailcellIdentifier)
        thumbnailcollectionView.dataSource = self
        thumbnailcollectionView.delegate = self
        view.addSubview(thumbnailcollectionView)
        
        let thumbnailcollectionviewConstraints = [thumbnailcollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                                  thumbnailcollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
                                                  thumbnailcollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                                  thumbnailcollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)]
        NSLayoutConstraint.activate(thumbnailcollectionviewConstraints)
    }
}

//MARK: Datasource methods
extension DocumentThumbnailController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfDocumet.pageCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let thumbnailcell = collectionView.dequeueReusableCell(withReuseIdentifier: thumbnailcellIdentifier, for: indexPath) as! DocumentThumbnailCell
        thumbnailcell.setThumbnail(pdfdoc: pdfDocumet, index: indexPath.row)
        return thumbnailcell
    }
}

//MARK: Delegate methods
extension DocumentThumbnailController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageSelected?(indexPath.item)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: UIDelegates
extension DocumentThumbnailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width/3
        let height = self.view.frame.height - 40
        
        return CGSize(width: width, height: height)
    }
}
