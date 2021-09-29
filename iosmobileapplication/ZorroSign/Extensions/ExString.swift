//
//  ExString.swift
//  ZorroSign
//
//  Created by Apple on 25/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

let TakePhoto = "Take Photo"
let ChooseFromLibrary = "Choose from photos"

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    func rgbToColor() -> UIColor {
        
        var color: UIColor = UIColor.black
        //rgb(250,4,10)
        let arr = self.components(separatedBy: ",")
        if !arr.isEmpty && arr.count > 2 {
        let R = arr[0].substring(4..<arr[0].count)
        let G = arr[1]
        let B = arr[2].substring(to: arr[2].count-2)
        
        guard let R1 = NumberFormatter().number(from: R) else { return UIColor.black}
        guard let G1 = NumberFormatter().number(from: G) else { return UIColor.black}
        guard let B1 = NumberFormatter().number(from: B) else { return UIColor.black}
        
        let RR = (R as NSString).floatValue
        let GG = (G as NSString).floatValue
        let BB = (B as NSString).floatValue
            
        color = UIColor(red: CGFloat(RR/255), green: CGFloat(GG/255), blue: CGFloat(BB/255), alpha: 1)
        }
        return color
    }
    
    func formatDate() -> String {
        
        if !self.isEmpty {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2018-01-02T05:53:06
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "MMM dd, yyyy"
            
            let dateFormatterPrint1 = DateFormatter()
            dateFormatterPrint1.dateFormat = "hh:mm a"
            
            if let date = dateFormatterGet.date(from: self){
                
                let formattedDate = dateFormatterPrint.string(from: date)
                let formattedTime = dateFormatterPrint1.string(from: date)
                let datetime = "\(formattedDate) at \(formattedTime)"
                print(formattedDate)
                print(formattedTime)
                return datetime
            }
            else {
                print("There was an error decoding the string")
            }
        } else {
            return "N/A"
        }
        return self
    }
    
    func formatDateWith(format: String) -> String {
        
        if !self.isEmpty {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2018-01-02T05:53:06
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = format
            
            //let dateFormatterPrint1 = DateFormatter()
            //dateFormatterPrint1.dateFormat = "hh:mm a"
            
            if let date = dateFormatterGet.date(from: self){
                
                let formattedDate = dateFormatterPrint.string(from: date)
                //let formattedTime = dateFormatterPrint1.string(from: date)
                //let datetime = "\(formattedDate) at \(formattedTime)"
                print(formattedDate)
                //print(formattedTime)
                return formattedDate
            }
            else {
                print("There was an error decoding the string")
            }
        } else {
            return "N/A"
        }
        return self
    }
    
    func formatDateWith(format: String, timeDiff: String) -> String {
        
        if !self.isEmpty {
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //2018-01-02T05:53:06
            dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
            
            let dateFormatterPrint = DateFormatter()
            if !timeDiff.isEmpty {
                dateFormatterPrint.timeZone = TimeZone(identifier: "UTC")
            }
            dateFormatterPrint.dateFormat = format
            
            if let date = dateFormatterGet.date(from: self){
                var formattedDate: String = ""
                
                if !timeDiff.isEmpty {
                    
                    let arr = timeDiff.components(separatedBy: ":")
                    
                    let diff = arr[0].substring(to: 0)
                    let hr = Int(arr[0].substring(from: 1))
                    let min = Int(arr[1])
                    let sec = Int(arr[2])
                    
                    
                    let calendar = Calendar.current
                    var hr1  = calendar.component(.hour, from: date)
                    var min1  = calendar.component(.minute, from: date)
                    var sec1  = calendar.component(.second, from: date)
                    
                    if diff == "-" {
                        hr1 = hr1 - hr!
                        min1 = min1 - min!
                        sec1 = sec1 - sec!
                    } else {
                        hr1 = hr1 + hr!
                        min1 = min1 + min!
                        sec1 = sec1 + sec!
                    }
                    
                    var components = DateComponents()
                    components.day = calendar.component(.day, from: date)
                    components.month = calendar.component(.month, from: date)
                    components.year = calendar.component(.year, from: date)
                    components.hour = hr1
                    components.minute = min1
                    components.second = sec1
                    
                    let convertedDate = calendar.date(from: components)
                    
                    formattedDate = dateFormatterPrint.string(from: convertedDate!)
                } else {
                    formattedDate = dateFormatterPrint.string(from: date)
                }
                print(formattedDate)
                //print(formattedTime)
                return formattedDate
            }
            else {
                print("There was an error decoding the string")
            }
        } else {
            return "N/A"
        }
        return self
    }
    
    func stringToDate() -> Date {
        
        if self.isEmpty {
            return Date()
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        dateFormatterGet.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatterGet.date(from: self) ?? Date()
        
    }
    
    func base64ToImage() -> UIImage {
        
        if let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            let decodedimage = UIImage(data: dataDecoded)
            
            return decodedimage ?? UIImage()
        }
        return UIImage()
    }
    
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text!
    }
}
