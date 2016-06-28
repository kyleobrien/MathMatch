//
//  UIColor+MMXColor.swift
//  MathMatch
//
//  Created by Kyle O'Brien on 2016.6.25.
//  Copyright © 2016 Computer Lab. All rights reserved.
//

import UIKit

extension UIColor {
    
    func mmx_blackColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (43.0 / 255.0), green: (43.0 / 255.0), blue: (43.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_blueColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (1.0 / 255.0), green: (170.0 / 255.0), blue: (227.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_greenColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (76.0 / 255.0), green: (217.0 / 255.0), blue: (100.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_orangeColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (255.0 / 255.0), green: (143.0 / 255.0), blue: (0.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_purpleColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (95.0 / 255.0), green: (64.0 / 255.0), blue: (222.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_redColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (255.0 / 255.0), green: (0.0 / 255.0), blue: (64.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_whiteColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (247.0 / 255.0), green: (247.0 / 255.0), blue: (247.0 / 255.0), alpha: withAlpha)
    }
    
    func mmx_yellowColor(withAlpha withAlpha: Float) -> UIColor {
        return UIColor.init(colorLiteralRed: (255.0 / 255.0), green: (206.0 / 255.0), blue: (1.0 / 255.0), alpha: withAlpha)
    }
}
