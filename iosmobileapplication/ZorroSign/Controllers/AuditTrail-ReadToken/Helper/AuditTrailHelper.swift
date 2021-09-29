//
//  AuditTrailHelper.swift
//  ZorroSign
//
//  Created by Mathivathanan on 8/17/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Alamofire

class AuditTrailHelper {
    private let queueGroup = DispatchGroup()
    static let sharedInstance = AuditTrailHelper()
    private init() {}
}

//MARK: Get color
extension AuditTrailHelper {
    func getstepColor(step: Int) -> UIColor{
        let colors = ["#009812", "#2d0fff", "#ea0000", "#b39ddb", "#fec107", "#827717", "#ef9a9a", "#00c853", "#c6ff00", "#b2ebf2", "#795547", "#304ffe", "#f8bbd0", "#dce775", "#f44336", "#00bcd4", "#ffcc80", "#009688", "#1a237e"]
        let colorString = colors[step]
        let color = UIColor(hex: colorString)
        return color ?? UIColor.darkGray
    }
}

extension UIView {
    func addShadowAllSide(radius: CGFloat = 4.0, color: UIColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.21)) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = 0.8
        self.layer.shouldRasterize = false
        self.layer.masksToBounds = false
    }
}


//MARK: Get document saved url
extension AuditTrailHelper {
    func returnfileDestination(documentname: String) -> DownloadRequest.DownloadFileDestination {
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentsUrl.appendingPathComponent(documentname)
            return (fileUrl, [.removePreviousFile])
        }
        return destination
    }
}



extension AuditTrailHelper {
    func returnTagImage(tagtype: Int) -> UIImage {
        var imagename = ""
        switch tagtype {
        case 0:
            imagename = "Signature_tools"
        case 1:
            imagename = "Initials_tools"
        case 2:
            imagename = "Seal_tools"
        case 3:
            imagename = "Text_tools"
        case 4:
            imagename = "Calendar_tools"
        case 5:
            imagename = ""
        case 6:
            imagename = "Token"
        case 7:
            imagename = ""
        case 8:
            imagename = "Note_tools"
        case 9:
            imagename = "CC_tools"
        case 10:
            imagename = ""
        case 11:
            imagename = ""
        case 12:
            imagename = "Attach"
        case 13:
            imagename = "Checkbox_tools"
        case 14:
            imagename = "Editabletext_tools"
        case 15:
            imagename = "User_tools"
        case 16:
            imagename = "User_tools"
        case 17:
            imagename = "Email_tools"
        case 18:
            imagename = "Company_tools"
        case 19:
            imagename = "Title_tools"
        case 20:
            imagename = "Phone_tools"
        case 22:
            imagename = "Radio_button_gray"
        default:
            imagename = ""
        }
        
        let image = UIImage(named: imagename)
        return image!
    }
}
