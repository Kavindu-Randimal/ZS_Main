//
//  DocumentUTCController.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 6/27/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class DocumentUTCController: UIViewController {
    
    private var searchbar: UISearchBar!
    private var utctableview: UITableView!
    private var utctableviewdefaultcellid = "utctableviewdefaultcellid"
    private var utctableviewtimezonecellId = "utctableviewtimezonecellid"
    
    private var zorrotimeZone: [ZorroTimeZone] = []
    private var filteredtimeZone: [ZorroTimeZone] = []
    
    var timezoneCallback: ((ZorroTimeZone?) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setuputcTableView()
        fetchutcData()
    }
}

//MARK: Fetch data from json file
extension DocumentUTCController {
    fileprivate func fetchutcData() {
        let zorrotimezone = ZorroTimeZone()
        zorrotimezone.getZorroTimeZoneData { (zorrotime) in
            self.zorrotimeZone = zorrotime!
            self.filteredtimeZone = zorrotime!
            self.utctableview.reloadData()
        }
    }
}

//MARK: Setup search bar
extension DocumentUTCController {
    fileprivate func setupSearchBar() {
        searchbar = UISearchBar()
        searchbar.translatesAutoresizingMaskIntoConstraints = false
        searchbar.backgroundColor = .white
        searchbar.delegate = self
        view.addSubview(searchbar)
        
        let safearea = self.view.safeAreaLayoutGuide
        let searchbarConstraints = [searchbar.leftAnchor.constraint(equalTo: view.leftAnchor),
                                    searchbar.topAnchor.constraint(equalTo: safearea.topAnchor),
                                    searchbar.rightAnchor.constraint(equalTo: view.rightAnchor),
                                    searchbar.heightAnchor.constraint(equalToConstant: 44)]
        
        NSLayoutConstraint.activate(searchbarConstraints)
    }
}

//MARK: Search bar delegates
extension DocumentUTCController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("cancelled")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let filteredTimeZones =  getfilteredTimeZone(timezone: zorrotimeZone, searchstring: searchBar.text!)
        filteredtimeZone = filteredTimeZones
        self.utctableview.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
    }
}

//MARK: search bar filter
extension DocumentUTCController {
    fileprivate func getfilteredTimeZone(timezone: [ZorroTimeZone], searchstring: String) -> [ZorroTimeZone] {
        
        print("Search String : \(searchstring)")
        if searchstring != "" {
            let filterdarry = timezone.filter {
                $0.DisplayName!.contains(searchstring)
            }
            return filterdarry
        }
        return zorrotimeZone
    }
}

//MARK: Setup utc table view
extension DocumentUTCController {
    fileprivate func setuputcTableView() {
        utctableview = UITableView(frame: .zero, style: .plain)
        utctableview.translatesAutoresizingMaskIntoConstraints = false
        utctableview.register(UITableViewCell.self, forCellReuseIdentifier: utctableviewdefaultcellid)
        utctableview.register(ZorroUTCTimeZoneCell.self, forCellReuseIdentifier: utctableviewtimezonecellId)
        utctableview.tableFooterView = UIView()
        utctableview.dataSource = self
        utctableview.delegate = self
        view.addSubview(utctableview)
        
        let utctableviewConstraints = [utctableview.leftAnchor.constraint(equalTo: view.leftAnchor),
                                       utctableview.topAnchor.constraint(equalTo: searchbar.bottomAnchor),
                                       utctableview.widthAnchor.constraint(equalToConstant: 300),
                                       utctableview.heightAnchor.constraint(equalToConstant: 400)]
        
        NSLayoutConstraint.activate(utctableviewConstraints)
    }
}

//MARK: Tableview datasource
extension DocumentUTCController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredtimeZone.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let utccell = tableView.dequeueReusableCell(withIdentifier: utctableviewtimezonecellId) as! ZorroUTCTimeZoneCell
        let utcsingletimezone = filteredtimeZone[indexPath.row]
        utccell.zorrotimezone = utcsingletimezone
        return utccell
    }
}

//MARK: Tablevew delegates
extension DocumentUTCController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedtimezone = filteredtimeZone[indexPath.row]
        timezoneCallback!(selectedtimezone)
        self.dismiss(animated: true, completion: nil)
    }
}

