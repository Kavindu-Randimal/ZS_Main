//
//  ContactCellTableViewCell.swift
//  ZorroSign
//
//  Created by Apple on 20/11/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Contact {
    let givenName: String
    let surname: String
    let email: String
}

class ContactCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var givenName: String? {
        didSet {
            nameLabel.text = givenName! + " " + (surname ?? "")
        }
    }
    
    var surname: String? {
        didSet {
            nameLabel.text = (givenName ?? "") + " " + surname!
        }
    }
    
    var email: String? {
        didSet {
            emailLabel.text = email
        }
    }
}

class ContactsDataSource: NSObject {
    let contacts: [Contact]
    
    init(contacts: [JSON]?) {
        var ctctArray = [Contact]()
        
        if let unwrappedContacts = contacts {
            for (contact) in unwrappedContacts {
                let newContact = Contact(
                    givenName: contact["givenName"].stringValue,
                    surname: contact["surname"].stringValue,
                    email: contact["emailAddresses"][0]["address"].stringValue)
                
                ctctArray.append(newContact)
            }
        }
        
        self.contacts = ctctArray
    }
}

extension ContactsDataSource: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ContactCell.self)) as! ContactCell
        let contact = contacts[indexPath.row]
        cell.givenName = contact.givenName
        cell.surname = contact.surname
        cell.email = contact.email
        return cell
    }
}
