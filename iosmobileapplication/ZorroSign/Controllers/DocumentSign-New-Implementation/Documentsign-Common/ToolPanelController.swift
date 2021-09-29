//
//  ToolPanelController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 8/9/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ToolPanelController: UIViewController {
    
    let deviceName = UIDevice.current.userInterfaceIdiom
    private var toolpanelView: UICollectionView!
    private let toollpanelIdentifier = "cellIdentifier"
    private var tools: [ToolPanel] = []
    
    var toolpanelCallback: ((ToolPanel) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        settoolpanelData()
        settupToolbox()
    }
}

//MARK: - Setup tool data
extension ToolPanelController {
    fileprivate func settoolpanelData() {
        
        tools = [
            ToolPanel(isselected: false, noramlImag: "Signature_tools", selectedImage: "", tagtype: 0),
            ToolPanel(isselected: false, noramlImag: "Initials_tools", selectedImage: "", tagtype: 1),
            ToolPanel(isselected: false, noramlImag: "Seal_tools", selectedImage: "", tagtype: 2),
            ToolPanel(isselected: false, noramlImag: "Calendar_tools", selectedImage: "", tagtype: 4),
            ToolPanel(isselected: false, noramlImag: "User_tools", selectedImage: "", tagtype: 16),
            ToolPanel(isselected: false, noramlImag: "Email_tools", selectedImage: "", tagtype: 17),
            ToolPanel(isselected: false, noramlImag: "Company_tools", selectedImage: "", tagtype: 18),
            ToolPanel(isselected: false, noramlImag: "Title_tools", selectedImage: "", tagtype: 19),
            ToolPanel(isselected: false, noramlImag: "Phone_tools", selectedImage: "", tagtype: 20),
            ToolPanel(isselected: false, noramlImag: "Text_tools", selectedImage: "", tagtype: 3),
            ToolPanel(isselected: false, noramlImag: "Checkbox_tools", selectedImage: "", tagtype: 13),
            ToolPanel(isselected: false, noramlImag: "Note_tools", selectedImage: "", tagtype: 8),
            ToolPanel(isselected: false, noramlImag: "Editabletext_tools", selectedImage: "", tagtype: 14),
            ToolPanel(isselected: false, noramlImag: "Attach", selectedImage: "", tagtype: 12),
            ToolPanel(isselected: false, noramlImag: "CC_tools", selectedImage: "", tagtype: 9),
            ToolPanel(isselected: false, noramlImag: "Token", selectedImage: "", tagtype: 6)
        ]
    }
}

//MARK: - Setup tool panel
extension ToolPanelController {
    fileprivate func settupToolbox() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1
        toolpanelView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        toolpanelView.register(ToolPanelCell.self, forCellWithReuseIdentifier: toollpanelIdentifier)
        toolpanelView.translatesAutoresizingMaskIntoConstraints = false
        toolpanelView.backgroundColor = .white
        toolpanelView.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        toolpanelView.dataSource = self
        toolpanelView.delegate = self
        view.addSubview(toolpanelView)
        
        let toolpanelviewConstraints = [toolpanelView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                        toolpanelView.topAnchor.constraint(equalTo: view.topAnchor),
                                        toolpanelView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                        toolpanelView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(toolpanelviewConstraints)
    }
}

//MARK: - collectoinview datasource and delegate methods
extension ToolPanelController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tools.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let toolcell = collectionView.dequeueReusableCell(withReuseIdentifier: toollpanelIdentifier, for: indexPath) as! ToolPanelCell
        let tool = tools[indexPath.row]
        toolcell.tool = tool
        toolcell.backgroundColor = .white
        return toolcell
    }
}

extension ToolPanelController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var isAllowed = false
        
        // Special Case
        /// 11 - Note_tools, 12 - Editabletext_tools, 13 - Attach, 15 - 4N6Token
        
        //  Basic Tools
        ///  0 - Signature, 1 - Initial, 2 - Seal, 3 - Date, 4 - UserProfile, 9 - TextBox , 10 - CheckBox , 14 - CC
        
        switch indexPath.row {
        case 11:
            if FeatureMatrix.shared.post_it_notes {
                isAllowed = true
            }
            break
        case 12:
            if FeatureMatrix.shared.colloborative_tools {
                isAllowed = true
            }
            break
        case 13:
            if FeatureMatrix.shared.mandatory_attachments {
                isAllowed = true
            }
            break
        case 15:
            if FeatureMatrix.shared.token_4n6 {
                isAllowed = true
            }
            break
        case 0, 1, 2, 3, 4, 9, 10, 14:
            if FeatureMatrix.shared.basic_tools {
                isAllowed = true
            }
            break
        default:
            isAllowed = true
            break
        }
        
        if isAllowed {
            let selectedtool: ToolPanel = tools[indexPath.row]
            toolpanelCallback!(selectedtool)
            self.dismiss(animated: true, completion: nil)
        } else {
            FeatureMatrix.shared.showRestrictedMessage()
        }
    }
}

extension ToolPanelController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var widthheight = (UIScreen.main.bounds.width - 10)/7
        if deviceName == .pad {
            widthheight = (UIScreen.main.bounds.width/2 - 10)/7
        }
        return CGSize(width: widthheight, height: widthheight)
    }
}
