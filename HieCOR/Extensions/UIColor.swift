//
//  UIColor.swift
//  HieCOR
//
//  Created by ios on 23/04/18.
//  Copyright © 2018 ios. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //MARK: Enumeration
    enum HieCORColor {
        
        case blue
        case gray
        case buttonGray
        
        func colorWith(alpha: CGFloat) -> UIColor {
            var colorToReturn:UIColor?
            switch self {
            case .blue:
                colorToReturn = UIColor.init(red: 11.0/255.0, green: 118/255.0, blue: 201.0/255.0, alpha: 1.0)
            case .gray:
                colorToReturn = #colorLiteral(red: 0.631372549, green: 0.6431372549, blue: 0.6745098039, alpha: 1).withAlphaComponent(alpha)
            case .buttonGray:
                colorToReturn = #colorLiteral(red: 0.9528579116, green: 0.9529945254, blue: 0.9528279901, alpha: 1).withAlphaComponent(alpha)
            }
            return colorToReturn!
        }
    }
    
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        setFill()
        UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return image
    }
    public convenience init?(hexCode: String) {
        var cString:String = hexCode.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
            return
        }else{
            var rgbValue:UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)
            
            self.init(
                red: CGFloat((rgbValue & 0xff000000) >> 24) / 255.0,
                green: CGFloat((rgbValue & 0x00ff0000) >> 16) / 255.0,
                blue: CGFloat((rgbValue & 0x0000ff00) >> 8) / 255.0,
                alpha: CGFloat(rgbValue & 0x000000ff) / 255
            )
            return
        }
    }
    
    func darker(by percentage: CGFloat = 15.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 15) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
}

