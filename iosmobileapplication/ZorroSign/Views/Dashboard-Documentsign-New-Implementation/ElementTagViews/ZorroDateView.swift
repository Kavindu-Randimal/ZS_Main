//
//  ZorroDateView.swift
//  ZorroSign
//
//  Created by Anuradh Caldera on 5/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class ZorroDateView: ZorroTagBaseView {
    
    private var textField: UITextField!
    private var setDateButton: UIButton!
    private var datePicker: UIDatePicker!
    private var isAutoDate: String!
    private var isTimeonly: String?
    private var isWithtime: String?
    private var dateFormat: String!
    private var timeFormat: String!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setsubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: Setup date ui
extension ZorroDateView {
    fileprivate func setsubView() {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .line
        textField.backgroundColor = .white
        textField.minimumFontSize = 8.0
        textField.adjustsFontSizeToFitWidth = true
        textField.isUserInteractionEnabled = false
        addSubview(textField)
        
        let textfieldConstrants = [textField.leftAnchor.constraint(equalTo: leftAnchor),
                                   textField.topAnchor.constraint(equalTo: topAnchor),
                                   textField.rightAnchor.constraint(equalTo: rightAnchor),
                                   textField.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(textfieldConstrants)
        
        setDateButton = UIButton()
        setDateButton.translatesAutoresizingMaskIntoConstraints = false
        setDateButton.setTitleColor(.black, for: .normal)
        addSubview(setDateButton)
        
        let setdatebuttonConstraints = [setDateButton.leftAnchor.constraint(equalTo: leftAnchor),
                                        setDateButton.topAnchor.constraint(equalTo: topAnchor),
                                        setDateButton.rightAnchor.constraint(equalTo: rightAnchor),
                                        setDateButton.bottomAnchor.constraint(equalTo: bottomAnchor)]
        NSLayoutConstraint.activate(setdatebuttonConstraints)
        setDateButton.addTarget(self, action: #selector(setDateActioni(_:)), for: .touchUpInside)
    }
}

//MARK: Set extra meta data && auto saved data
extension ZorroDateView {
    func setProperties(extrametadta: ExtraMetaData?, autosaved: AutoSavedData?) {
        textField.tag = tagID
        setDateButton.tag = tagID
        setDateButton.setTitle("\(tagName!)", for: .normal)
        
        
        guard let exdata = extrametadta else { return }
        guard let isautodate = exdata.isDateAuto else { return }
        
        if let istimeonly = exdata.isTimeOnly {
            isTimeonly = istimeonly
        }
        
        if let iswithtime = exdata.isWithTime {
            isWithtime = iswithtime
        }
        guard let dateformat = exdata.dateFormat else { return }
        guard let timeformat = exdata.timeFormat else { return }
        
        isAutoDate = isautodate
        dateFormat = dateformat
        timeFormat = timeformat
        
        
        if let fontsizeString = exdata.fontSize {
            if let fontsize = NumberFormatter().number(from: fontsizeString) {
                textField.font = UIFont(name: "Helvetica", size: CGFloat(truncating: fontsize))
                setDateButton.titleLabel?.font = UIFont(name: "Helvetica", size: CGFloat(truncating: fontsize))
                setDateButton.titleLabel?.adjustsFontSizeToFitWidth = true
            }
        }
        
        //MARK: setup auto saved data
        if let autosaved = autosaved {
            if let tagdetails = autosaved.tagDetails?.tagData {
                for tagdetail in tagdetails {
                    if tagdetail.type == 4 && tagdetail.tagID == tagID {
                        if let apply = tagdetail.apply {
                            if apply {
                                if let data = tagdetail.data {
                                    let date = getDate(dateString: data)
                                    tagText = setDate(istimeonly: isTimeonly, iswithtime: isWithtime, dateformat: dateFormat, timeformat: timeFormat, datevalue: date)
                                    textField.text = tagText
                                    iscompleted = true
                                    setDateButton.isHidden = true
                                    return
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //MARK: allow user to select a date
        if isautodate == "False" {
            return
        }
        
        //MARK: set default date
        tagText = setDate(istimeonly: isTimeonly, iswithtime: isWithtime, dateformat: dateFormat, timeformat: timeformat, datevalue: nil)
        return
    }
}

//MARK: Set Date action
extension ZorroDateView {
    @objc fileprivate func setDateActioni(_ sender: UIButton) {
        
        if isAutoDate == "True" {
            iscompleted = true
            textField.text = tagText
            sender.isHidden = true
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            self.setDatePicker()
        }
        return
    }
}

//MARK: Convert string to date
extension ZorroDateView {
    fileprivate func getDate(dateString: String) -> Date {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateformatter.locale = Locale(identifier: "en_US_POSIX")
        var date = dateformatter.date(from: dateString)
        
        if date == nil {
            dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateformatter.locale = Locale(identifier: "en_US_POSIX")
            date = dateformatter.date(from: dateString)
        }
        
        return date!
    }
}

//MARK: Get date and format
extension ZorroDateView {
    fileprivate func setDate(istimeonly: String?, iswithtime: String?, dateformat: String, timeformat: String, datevalue: Date?) -> String {
        
        var date: Date
        if let datevalue = datevalue {
            date = datevalue
        } else {
            date = Date()
        }
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "\(dateformat) \(timeformat)"
        let datestring = dateformatter.string(from: date)
        print(datestring)
        
        if let withtime = iswithtime {
            if withtime == "True" {
                return datestring
            }
        }
        
        let datetime = datestring.components(separatedBy: " ")
        
        if let timeonly = istimeonly {
            if timeonly == "True" {
                return datetime[1]
            }
        }
        
        return datetime[0]
    }
}

//MARK: Show date picker
extension ZorroDateView {
    fileprivate func setDatePicker() {
        let dateviewConroller = UIViewController()
        dateviewConroller.preferredContentSize = CGSize(width: UIScreen.main.bounds.size.width/2, height: UIScreen.main.bounds.height/5)
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = dateFormat
        
        if let istimeonly = isTimeonly {
            if istimeonly == "True" {
                datePicker.datePickerMode = .time
                dateformatter.dateFormat = timeFormat
            }
        }
        
        if let iswithtime = isWithtime {
            if iswithtime == "True" {
                datePicker.datePickerMode = .dateAndTime
                dateformatter.dateFormat = dateFormat + " " + timeFormat
            }
        }
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        dateviewConroller.view.addSubview(datePicker)
        let datepickerconstraints = [datePicker.leftAnchor.constraint(equalTo: dateviewConroller.view.leftAnchor, constant: 5),
                                     datePicker.topAnchor.constraint(equalTo: dateviewConroller.view.topAnchor),
                                     datePicker.rightAnchor.constraint(equalTo: dateviewConroller.view.rightAnchor, constant: -5),
                                     datePicker.bottomAnchor.constraint(equalTo: dateviewConroller.view.bottomAnchor)]
        NSLayoutConstraint.activate(datepickerconstraints)
        
        let dateAlert = UIAlertController(title: "Please select a date", message: "select a date to continue", preferredStyle: .alert)
        dateAlert.view.tintColor = ColorTheme.alertTint
        let selectAction = UIAlertAction(title: "SELECT", style: .cancel) { (alert) in
            print(self.datePicker.date)
            let datestring = dateformatter.string(from: self.datePicker.date)
            self.tagText = datestring
            self.textField.text = self.tagText
            self.iscompleted = true
            self.setDateButton.isHidden = true
            return
        }
        
        dateAlert.addAction(selectAction)
        dateAlert.setValue(dateviewConroller, forKey: "contentViewController")
        self.window?.rootViewController?.present(dateAlert, animated: true, completion: nil)
    }
}


