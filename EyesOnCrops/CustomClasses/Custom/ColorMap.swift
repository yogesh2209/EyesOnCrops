//
//  ColorMap.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/19/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation

import UIKit

//HEX to RGB - UIColor
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//return min and max value
func giveColorMapLimits(currValue: Float) -> (Float, Float) {
    
    if currValue < -125.0  {
        return (-125.0, -125.0)
    }
    else if currValue >= -125.0 && currValue < -80.0 {
        return (-125.0, -80.0)
    }
    else if currValue >= -80.0 && currValue < -60.0 {
        return (-80.0, -60.0)
    }
    else if currValue >= -60.0 && currValue < -40.0 {
        return (-60.0, -40.0)
    }
    else if currValue >= -40.0 && currValue < -20.0 {
        return (-40.0, -20.0)
    }
    else if currValue >= -20.0 && currValue < 0.0 {
        return (-20.0, 0.0)
    }
    else if currValue >= 0.0 && currValue < 20.0 {
        return (0, 20.0)
    }
    else if currValue >= 20.0 && currValue < 40.0 {
        return (0, 20.0)
    }
    else if currValue >= 40.0 && currValue < 60.0 {
        return (40.0, 60.0)
    }
    else if currValue >= 60.0 && currValue < 80.0 {
        return (60.0, 80.0)
    }
    else if currValue >= 80.0 && currValue < 125.0 {
        return (80.0, 125.0)
    }
    else {
        return (125.0, 125.0)
    }
}

func rgbOnLimits(currentColorMap: String, minValue: Float, maxValue: Float) -> (UIColor, UIColor)? {
    
    var minColor = UIColor()
    var maxColor = UIColor()
    var colorMapIndex = 0
    
    if currentColorMap == "DEFAULT" {
        colorMapIndex = 0
    }
    else if currentColorMap == "UPDATE_1" {
        colorMapIndex = 1
    }
    
    //get data from json file
    if let path = Bundle.main.path(forResource: "colorMap", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            if let jr = jsonResult as? [Any], let colorMap = jr[colorMapIndex] as? [[String : String]] {
                // do stuff
                print(colorMap)
                print(colorMap.count)
                
                for index in 0..<colorMap.count {
                    
                    if let r = colorMap[index]["r"], let g = colorMap[index]["g"], let b = colorMap[index]["b"], let floatR = Float(r), let floatG = Float(g), let floatB = Float(b) {
                        
                        if let min = colorMap[index]["value"], minValue == Float(min) {
                            minColor = UIColor(red: CGFloat(floatR/255.0), green: CGFloat(floatG/255.0), blue: CGFloat(floatB/255.0), alpha: 1.0)
                        }
                        if let max = colorMap[index]["value"], maxValue == Float(max) {
                            maxColor = UIColor(red: CGFloat(floatR/255.0), green: CGFloat(floatG/255.0), blue: CGFloat(floatB/255.0), alpha: 1.0)
                        }
                    }
                }
            }
        } catch {
            // handle error
        }
    }
    
    return (minColor, maxColor)
}

//function which takes limits and their color and returns gradient of the current value
func gradientColor(minColor: UIColor, maxColor: UIColor, currentValue: Float, minValue: Float, maxValue: Float) -> UIColor? {
    
    
    guard
        let (minR, minG, minB) = minColor.colorComponents(),
        let (maxR, maxG, maxB) = maxColor.colorComponents()
        else { return nil }
    
     
    
    
    
    return nil
}


