//
//  DocumentDownloadSelectViewController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/21/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentDownloadSelectViewController: UIViewController {
    
    private var options: [DownlodOptions] = []
    
    private var headerView: UIView!
    private var headerBotomLine: UIView!
    private var headerLabel: UILabel!
    
    private var footerView: UIView!
    
    private var selectiontableView: UITableView!
    private var optionIdentifier = "optionidentifier"
    
    private var selectedOption: Int!
    var downloadusecaseIndex: Int?
    var downloadCallback: ((Int?) ->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setoptionValues()
        setHeader()
        setdownloadselectionTableView()
    }
}

//MARK: Setup details
extension DocumentDownloadSelectViewController {
    fileprivate func setoptionValues() {
        
        options = [
            DownlodOptions(index: 0, title: "Document", isSelected: false),
            DownlodOptions(index: 1, title: "As separate documents", isSelected: false),
            DownlodOptions(index: 2, title: "Attachment(s)", isSelected: false),
            DownlodOptions(index: 3, title: "Download All", isSelected: false)
        ]
    }
}

//MARK: Update Details
extension DocumentDownloadSelectViewController {
    fileprivate func updateOptions(options: [DownlodOptions], selectedindex: Int, completion: @escaping([DownlodOptions]) -> ()) {
     
        var newoptions : [DownlodOptions] = []
        
        for var option in options {
            if option.index == selectedindex {
                option.isSelected = !option.isSelected
            } else {
                option.isSelected = false
            }
            newoptions.append(option)
        }
        completion(newoptions)
    }
}

//MARK: Setup header view
extension DocumentDownloadSelectViewController {
    fileprivate func setHeader() {
        headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .white
        view.addSubview(headerView)
        
        let headerViewConstraints = [headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     headerView.topAnchor.constraint(equalTo: view.topAnchor),
                                     headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                     headerView.heightAnchor.constraint(equalToConstant: 50)]
        NSLayoutConstraint.activate(headerViewConstraints)
        
        
        headerBotomLine = UIView()
        headerBotomLine.translatesAutoresizingMaskIntoConstraints = false
        headerBotomLine.backgroundColor = .lightGray
        headerView.addSubview(headerBotomLine)
        
        let headerbottomlineConstraints = [headerBotomLine.leftAnchor.constraint(equalTo: headerView.leftAnchor),
                                           headerBotomLine.rightAnchor.constraint(equalTo: headerView.rightAnchor),
                                           headerBotomLine.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
                                           headerBotomLine.heightAnchor.constraint(equalToConstant: 1)]
        
        NSLayoutConstraint.activate(headerbottomlineConstraints)
        
        
        headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textAlignment = .left
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        headerLabel.text = "Download Document(s)"
        headerView.addSubview(headerLabel)
        
        let headerlableConstraints = [headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10),
                                      headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor),
                                      headerLabel.rightAnchor.constraint(equalTo: headerView.rightAnchor),
                                      headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)]
        NSLayoutConstraint.activate(headerlableConstraints)
        
    }
}

//MARK: Setup TableView
extension DocumentDownloadSelectViewController {
    fileprivate func setdownloadselectionTableView() {
        selectiontableView = UITableView(frame: .zero, style: .grouped)
        selectiontableView.register(DownloadOptionCell.self, forCellReuseIdentifier: optionIdentifier)
        selectiontableView.translatesAutoresizingMaskIntoConstraints = false
        selectiontableView.tableFooterView = UIView()
        selectiontableView.backgroundColor = .white
        selectiontableView.separatorStyle = .none
        selectiontableView.showsVerticalScrollIndicator = false
        selectiontableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        selectiontableView.bounces = false
        selectiontableView.dataSource = self
        selectiontableView.delegate = self
        view.addSubview(selectiontableView)
        let selectiontableviewConstraints = [selectiontableView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                             selectiontableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
                                             selectiontableView.rightAnchor.constraint(equalTo: view.rightAnchor),
                                             selectiontableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        NSLayoutConstraint.activate(selectiontableviewConstraints)
    }
}

//MARK: Data Source Methods
extension DocumentDownloadSelectViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        guard let usecase = downloadusecaseIndex else { return 0 }
        
        switch usecase {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 3
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard  let usecase = downloadusecaseIndex else {
            return 0
        }
        
        switch usecase {
        case 0:
            switch section {
            case 0:
                return 2
            case 1:
                return 1
            default:
                return 0
            }
        case 1:
            return 3
        case 2:
            switch section {
            case 0:
                return 2
            case 1:
                return 1
            case 2:
                return 1
            default:
                return 0
            }
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let optioncell = tableView.dequeueReusableCell(withIdentifier: optionIdentifier) as! DownloadOptionCell
       
        guard let usecase = downloadusecaseIndex else {
            return optioncell
        }
        
        switch usecase {
        case 0:
            switch indexPath.section {
            case 0:
                let downloadoption = options[indexPath.row]
                optioncell.downloadoption = downloadoption
            case 1:
                let downloadoption = options[3]
                optioncell.downloadoption = downloadoption
            default:
                print("default")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let downloadoption = options[indexPath.row]
                optioncell.downloadoption = downloadoption
            case 1:
                let downloadoption = options[2]
                optioncell.downloadoption = downloadoption
            case 2:
                let downloadoption = options[3]
                optioncell.downloadoption = downloadoption
            default:
                print("default")
            }
        case 2:
            switch indexPath.section {
            case 0:
                let downloadoption = options[indexPath.row]
                optioncell.downloadoption = downloadoption
            case 1:
                let downloadoption = options[2]
                optioncell.downloadoption = downloadoption
            case 2:
                let downloadoption = options[3]
                optioncell.downloadoption = downloadoption
            default:
                print("default")
            }
        default:
            print("invalid cell index")
        }
        return optioncell
    }
}

//MARK: Setup Delegates
extension DocumentDownloadSelectViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let usecase = downloadusecaseIndex else { return 0 }
        
        switch usecase {
        case 0:
            return 40
        case 1:
            return 0
        case 2:
            return 40
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        let label = UILabel(frame: CGRect(x: 20, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        label.textAlignment = .left
        label.font = UIFont(name: "Helvetica", size: 18)
        view.addSubview(label)
        
        guard let usecase = downloadusecaseIndex else { return UIView() }
        
        switch usecase {
        case 0:
            switch section {
            case 0:
                label.text = "Document(s)"
            case 1:
                label.text = "Document(s) and Attachment(s)"
            default:
                label.text = ""
            }
        case 1:
            label.text = ""
        case 2:
            switch section {
            case 0:
                label.text = "Document(s)"
            case 1:
                label.text = "Attachment(s)"
            case 2:
                label.text = "Document(s) and Attachment(s)"
            default:
                label.text = ""
            }
        default:
            label.text = ""
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        guard let usecase = downloadusecaseIndex else { return 0 }
        
        switch usecase {
        case 0:
            switch section {
            case 0:
                return 0
            case 1:
                return 40
            default:
                return 0
            }
        case 1:
            return 40
        case 2:
            switch section {
            case 0,1:
                return 0
            case 2:
                return 40
            default:
                return 0
            }
        default:
            return 0
        }
    
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
        let greencolor = ColorTheme.btnBG
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        view.backgroundColor = .clear
        
        let cancelbutton = UIButton()
        cancelbutton.translatesAutoresizingMaskIntoConstraints = false
        cancelbutton.backgroundColor = .white
        cancelbutton.setTitle("CANCEL", for: .normal)
        cancelbutton.setTitleColor(greencolor, for: .normal)
        view.addSubview(cancelbutton)
        
        let cancelbuttonConstraints = [cancelbutton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
                                       cancelbutton.topAnchor.constraint(equalTo: view.topAnchor),
                                       cancelbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                       cancelbutton.widthAnchor.constraint(equalToConstant: (3*UIScreen.main.bounds.width/4)/2 - 20)]
        NSLayoutConstraint.activate(cancelbuttonConstraints)
        
        cancelbutton.layer.masksToBounds = true
        cancelbutton.layer.cornerRadius = 5
        cancelbutton.layer.borderWidth = 1
        cancelbutton.layer.borderColor = greencolor.cgColor
        cancelbutton.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
        
        
        let downloadbutton = UIButton()
        downloadbutton.translatesAutoresizingMaskIntoConstraints = false
        downloadbutton.backgroundColor = greencolor
        downloadbutton.setTitle("DOWNLOAD", for: .normal)
        downloadbutton.setTitleColor(.white, for: .normal)
        view.addSubview(downloadbutton)
        
        let downloadbuttonConstraints = [downloadbutton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
                                       downloadbutton.topAnchor.constraint(equalTo: view.topAnchor),
                                       downloadbutton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                       downloadbutton.widthAnchor.constraint(equalToConstant: (3*UIScreen.main.bounds.width/4)/2 - 20)]
        NSLayoutConstraint.activate(downloadbuttonConstraints)
        
        downloadbutton.layer.masksToBounds = true
        downloadbutton.layer.cornerRadius = 5
        
        downloadbutton.addTarget(self, action: #selector(downloadAction(_:)), for: .touchUpInside)
        
        
        guard let usecase = downloadusecaseIndex else { return UIView() }
        
        switch usecase {
        case 0:
            switch section {
            case 0:
                return UIView()
            case 1:
                return view
            default:
                return UIView()
            }
        case 1:
            return view
        case 2:
            switch section {
            case 0,1:
                return UIView()
            case 2:
                return view
            default:
                return UIView()
            }
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedIndex: Int = 0
        
        guard let usecase = downloadusecaseIndex else { return }
        
        switch usecase {
        case 0:
            switch indexPath.section {
            case 0:
                selectedIndex = indexPath.row
            case 1:
                selectedIndex = 3
            default:
                return
            }
        case 1:
            switch indexPath.row {
            case 0 :
                selectedIndex = indexPath.row
            case 1:
                selectedIndex = 2
            case 2:
                selectedIndex = 3
            default:
                return
            }
        case 2:
            switch indexPath.section {
            case 0:
                selectedIndex = indexPath.row
            case 1:
                selectedIndex = 2
            case 2:
                selectedIndex = 3
            default:
                return
            }
        default:
            return
        }
        
        selectedOption = selectedIndex
        updateOptions(options: options, selectedindex: selectedIndex) { (newoptions) in
            self.options = newoptions
            self.selectiontableView.reloadData()
        }
    }
   
}

//MARK: - Button Functions
extension DocumentDownloadSelectViewController {
    @objc fileprivate func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func downloadAction(_ sender: UIButton) {
        downloadCallback!(selectedOption)
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Data model
struct  DownlodOptions {
    var index: Int!
    var title: String!
    var isSelected: Bool!
}

// MARK: - Download Option Cell

class DownloadOptionCell: UITableViewCell {
    
    var optionImage: UIImageView!
    var optionTitle: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        setcellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var downloadoption: DownlodOptions! {
        didSet {
            optionTitle.text = downloadoption.title
            
            if downloadoption.isSelected {
                optionImage.backgroundColor = .lightGray
            } else {
                optionImage.backgroundColor = .white
            }
        }
    }
    
}

extension DownloadOptionCell {
    fileprivate func setcellUI() {
        optionImage = UIImageView()
        optionImage.translatesAutoresizingMaskIntoConstraints = false
        optionImage.backgroundColor = .lightGray
        addSubview(optionImage)
        
        let optionimageConstraints = [optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      optionImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
                                      optionImage.widthAnchor.constraint(equalToConstant: 20),
                                      optionImage.heightAnchor.constraint(equalToConstant: 20)]
        NSLayoutConstraint.activate(optionimageConstraints)
        
        optionImage.layer.masksToBounds = true
        optionImage.layer.cornerRadius = 10
        optionImage.layer.borderColor = UIColor.darkGray.cgColor
        optionImage.layer.borderWidth = 1
        
        optionTitle = UILabel()
        optionTitle.translatesAutoresizingMaskIntoConstraints = false
        optionTitle.textAlignment = .left
        optionTitle.font = UIFont(name: "Helvetica", size: 18)
        optionTitle.text = ""
        optionTitle.textColor = .darkGray
        addSubview(optionTitle)
        
        let optiontitleConstraints = [optionTitle.centerYAnchor.constraint(equalTo: centerYAnchor),
                                      optionTitle.leftAnchor.constraint(equalTo: optionImage.rightAnchor, constant: 10),
                                      optionTitle.rightAnchor.constraint(equalTo: rightAnchor)]
        
        NSLayoutConstraint.activate(optiontitleConstraints)
    }
}
