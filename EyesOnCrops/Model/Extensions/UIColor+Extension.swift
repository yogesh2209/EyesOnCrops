//
//  UIColor+Extension.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/20/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    //r g b
    func colorComponents() -> (CGFloat, CGFloat, CGFloat)? {
   
        
        let rgbCgColor = self.cgColor

        let components = rgbCgColor.components

        if let rgb = components {
            return (rgb[0]*255.0, rgb[1]*255.0, rgb[2]*255.0)
        }
        
        return nil
    }
    
}
