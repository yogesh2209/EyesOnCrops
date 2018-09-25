//
//  ColorMap.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/19/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation

import UIKit

class ColorMap {
    
    func getStoredDataFromUserDefaults(for key: String) -> String? {
        let defaults = UserDefaults.standard
        if let mapTypeStored = defaults.object(forKey: key) as? String {
            return mapTypeStored
        }
        else{
            return nil
        }
    }
    
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
        else if currValue >= -20.0 && currValue < 20.0 {
            return (-20.0, 20.0)
        }
        else if currValue >= 20.0 && currValue < 40.0 {
            return (20, 40.0)
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
    
    func rgbOnLimits(currentColorMapIndex: Int, minValue: Float, maxValue: Float) -> (UIColor, UIColor)? {
        
        var minColor = UIColor.gray
        var maxColor = UIColor.gray
        
        if let colorMap = getColorMapFromJSONFile(for: currentColorMapIndex) {
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
        
        return (minColor, maxColor)
    }
    
    func getColorMapFromJSONFile(for colorMapIndex: Int) -> [[String : String]]?{
        
        //get data from json file
        if let path = Bundle.main.path(forResource: "colorMap", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jr = jsonResult as? [Any], let colorMap = jr[colorMapIndex] as? [[String : String]] {
                    return colorMap
                }
            } catch {
                return nil
            }
        }
        return nil
    }
    
    //function which takes limits and their color and returns gradient of the current value
    func gradientColor(minColor: UIColor, maxColor: UIColor, currentValue: Float, minValue: Float, maxValue: Float) -> UIColor? {
        
        guard let (diffR, diffG, diffB) = rgbDifference(minColor: minColor, maxColor: maxColor) else { return nil }
        
        let diff =  CGFloat((currentValue - minValue) / (maxValue - minValue))
        
        if  let minR = colorToRGBComponents(color: minColor) {
            let newRed = minR.0 + diffR * diff
            let newGreen = minR.1 + diffG * diff
            let newBlue = minR.2 + diffB * diff
            
            return (UIColor(red: newRed/255.0, green: newGreen/255.0, blue: newBlue/255.0, alpha: 1.0))
        }
        
        return nil
    }
    
    func colorToRGBComponents(color: UIColor) -> (CGFloat, CGFloat, CGFloat)? {
        guard
            let (r, g, b) = color.colorComponents()
            else { return nil }
        
        return (r, g, b)
    }
    
    func rgbDifference(minColor: UIColor, maxColor: UIColor) -> (CGFloat, CGFloat, CGFloat)? {
        guard
            let (minR, minG, minB) = minColor.colorComponents(),
            let (maxR, maxG, maxB) = maxColor.colorComponents()
            else { return nil }
        
        return (maxR - minR, maxG - minG, maxB - minB)
    }
    
    func getColor(colorValue: Float) -> UIColor? {
        
        let (m, n) = giveColorMapLimits(currValue: colorValue)
        
        var colorMapIndex = 0
        
        if let colorMap = self.getStoredDataFromUserDefaults(for: "COLOR_SCHEME") {
            if colorMap == "DEFAULT" {
                colorMapIndex = 0
            }
            else if colorMap == "CUSTOM-1" {
                colorMapIndex = 1
            }
        }
        
        if  let (a, b) = rgbOnLimits(currentColorMapIndex: colorMapIndex, minValue: m, maxValue: n),
            let color = gradientColor(minColor: a, maxColor: b, currentValue: colorValue, minValue: m, maxValue: n) {
            
            return color
        }
        
        return UIColor.gray
    }
}




