//
//  ColorTheme.swift
//  ZorroSign
//
//  Created by CHATHURA ELLAWALA on 9/8/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

public class ColorTheme {
    
    //MARK: - Button, button text colors
    
    static let btnTextWithoutBG: UIColor = UIColor(named: "BtnTextWithoutBG") ?? UIColor.green
    static let btnTextWithBG: UIColor = UIColor(named: "BtnTextWithBG") ?? UIColor.white
    static let btnBG: UIColor = UIColor(named: "BtnBG") ?? UIColor.green
    static let btnBGDefault: UIColor = UIColor(named: "BtnBGDefault") ?? UIColor.white
    static let btnBorder: UIColor = UIColor(named: "BtnBorder") ?? UIColor.green
    static let BtnTintDisabled: UIColor = UIColor(named: "BtnTintDisabled") ?? UIColor.darkGray
    static let BtnTintEnabled: UIColor = UIColor(named: "BtnTintEnabled") ?? UIColor.green
    
    //MARK: - Image colors
    
    static let imgTint: UIColor = UIColor(named: "ImgTint") ?? UIColor.green
    
    //MARK: - Label colors
    
    static let lblBody: UIColor = UIColor(named: "LblBody") ?? UIColor.black
    static let lblBodyDefault: UIColor = UIColor(named: "LblBodyDefault") ?? UIColor.black
    static let lblBgSpecial: UIColor = UIColor(named: "LblBGSpecial") ?? UIColor.green
    static let lblBodySpecial: UIColor = UIColor(named: "LblBodySpecial") ?? UIColor.white
    static let lblBodySpecial2: UIColor = UIColor(named: "") ?? UIColor.darkGray
    static let lblError: UIColor = UIColor(named: "LblError") ?? UIColor.red
    
    //MARK: - Navigation bar colors
    
    static let navTitleDefault: UIColor = UIColor(named: "NavTitleDefault") ?? UIColor.black
    static let navTitle: UIColor = UIColor(named: "NavTitle") ?? UIColor.green
    static let navTint: UIColor = UIColor(named: "NavTint") ?? UIColor.green
    static let barBtnTint: UIColor = UIColor(named: "BarBtnTint") ?? UIColor.green
    
    //MARK: - Switch active color
    
    static let switchActive: UIColor = UIColor(named: "Switch") ?? UIColor.darkGray
    
    //MARK: - Activityindicator color
    
    static let activityindicator: UIColor = UIColor(named: "Activityindicator") ?? UIColor.green
    static let activityindicatorSpecial: UIColor = UIColor(named: "ActivityindicatorSpecial") ?? UIColor.white
    
    //MARK: - Radio btton colors
    
    static let radioBtnBorder: UIColor = UIColor(named: "RadioBtnBorder") ?? UIColor.darkGray
    static let radioBtnInside: UIColor = UIColor(named: "RadioBtnInside") ?? UIColor.green
    
    // MARK: - AlertView
    
    static let alertTint: UIColor = UIColor(named: "AlertTint") ?? UIColor.systemBlue
}
