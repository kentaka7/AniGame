//
//  UIColorExtension.swift
//  AniGame
//
//  Created by takakura naohiro on 2018/10/19.
//  Copyright © 2018年 GeoMagnet. All rights reserved.
//

import UIKit

extension UIColor {
    class func hex ( hexStr : NSString, alpha : CGFloat) -> UIColor {
        var hexStr = hexStr
        let alpha = alpha
        hexStr = hexStr.replacingOccurrences(of: "#", with: "") as NSString
        let scanner = Scanner(string: hexStr as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            return UIColor(red:r,green:g,blue:b,alpha:alpha)
        } else {
            return UIColor.white;
        }
    }
    
    class func textColor() -> UIColor {
        return self.hex(hexStr: "#333333", alpha: 1.0)
    }
    
    class func viewBackgroundColor() -> UIColor {
        return self.hex(hexStr: "#CCCCCC", alpha: 1.0)
    }
    
    class func cellBackgroundColor() -> UIColor {
        return self.hex(hexStr: "#f1f1f1", alpha: 1.0)
    }
}
