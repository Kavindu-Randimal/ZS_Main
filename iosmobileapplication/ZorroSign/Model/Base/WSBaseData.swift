//
//  WSBaseData.swift
//  ACTApp
//
//  Created by Andrei Boulgakov on 15/06/17.
//  Copyright © 2017 Andrei Boulgakov. All rights reserved.
//

import Foundation
import ObjectiveC.runtime

//  Converted with Swiftify v1.0.6355 - https://objectivec2swift.com/
//#import "AWSKeyConstant.h"
class WSBaseData: NSObject {
    static var dtFormatter: DateFormatter?
    
    class func uniqueStringName() -> String {
        var imgName: String = UUID().uuidString
        imgName = imgName.lowercased()
        imgName = imgName.replacingOccurrences(of: " ", with: "")
        return imgName
    }
    
    override init() {
        super.init()
    }
    
    init(dictionary dict: [AnyHashable: Any]) {
       
        super.init()
        parse(withDictionary: dict)
        
    }
    
    func populate(fromDictionary dict: NSDictionary) {
        var outCount = UInt32()
        //var i: UInt
        
        var myClass: AnyClass = self.classForCoder
        guard let properties = class_copyPropertyList(myClass, &outCount) else { return }
        //let nullVal: Any? = NSNull()
        
        for i in 0..<outCount {
            let property: objc_property_t = properties[Int(i)]
            let propertyName = String(utf8String: property_getName(property))
            
            var propertyValue: Any? = dict.value(forKey: (propertyName)!)
            
            //var (key, valueInfo) = properties[Int(i)]
            //let propertyType = self.getPropertyType(parentType: self, propertyName: propertyName)
            //now check if value is empty then ignore field
            
            if propertyValue is NSNull {
                propertyValue = nil
            }
            else if let val = propertyValue as? NSArray {
                if val.count == 0 {
                    propertyValue = nil
                }
            }
            else if let val = propertyValue as? NSDictionary {
                if val.count == 0 {
                    propertyValue = nil
                }
            }
            else if let val = propertyValue as? String {
                if val.isEmpty {
                    propertyValue = nil
                }
            }
            
            
            
          //  if (propertyValue as? NSString) != nil
             if propertyValue != nil
            {
                if ((propertyValue as? NSNumber) != nil)
                {
                    let sVal  = (propertyValue as! NSNumber).stringValue;
                    self.setValue(sVal, forKey: propertyName!)

                }
                else{
                    self.setValue(propertyValue ?? nil, forKey: propertyName!)
                }
              
            }
        }
        free(properties)
    }
    
    
    func parse(withDictionary dict: [AnyHashable: Any]) {
        
        self.populate(fromDictionary: dict as NSDictionary)
    }
    /*
    func getPropertyType(parentType: NSObject.Type, propertyName: String) -> Any.Type? {
        var instance = parentType.init()
        var mirror = reflect(instance)
        
        for i in 0..<mirror.count {
            var (key, valueInfo) = mirror[i]
            if key == propertyName {
                return valueInfo.valueType
            }
        }
        
        return nil
    }*/
    
}
