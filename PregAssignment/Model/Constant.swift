//
//  Constant.swift
//  PregAssignment
//
//  Created by Ashwinkumar Mangrulkar on 10/03/18.
//  Copyright © 2018 Ashwinkumar Mangrulkar. All rights reserved.
//

import UIKit

class Constant: NSObject {

}

/// Define screen size
struct ScreenSize {
    
    static let SCREEN_WIDTH = UIScreen.main.bounds.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

/// Identify device type
struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0)
    static let IS_IPHONE_5          = (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0) || (UIDevice.current.model == "iPhone 5") || (UIDevice.current.model == "iPhone 5c") || (UIDevice.current.model == "iPhone 5s")
    static let IS_IPHONE_6          = (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0) //|| (UIDevice.currentDevice().modelName == "iPhone 6") //|| (UIDevice.currentDevice().modelName == "iPhone 6s")
    static let IS_IPHONE_6P         = (UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0)// || (UIDevice.currentDevice().modelName == "iPhone 6 Plus") //|| (UIDevice.currentDevice().modelName == "iPhone 6s Plus")
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

let maxConstantVal: CGFloat = 200.0
let minConstantVal: CGFloat = 0.0
