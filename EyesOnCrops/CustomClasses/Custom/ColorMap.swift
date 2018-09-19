//
//  ColorMap.swift
//  EyesOnCrops
//
//  Created by Yogesh Kohli on 9/19/18.
//  Copyright © 2018 Yogesh Kohli. All rights reserved.
//

import Foundation

import UIKit

/*
 
 STEPS TO GET COLOR VALUE AND GET IT'S COLOR VALUE IN RGB
 
 
 createGradient(colorMap) {
 var gradient : {
 Offset: string,
 StopColor: string
 }[] = [];
 
 for (var currPercentage = 0; currPercentage <= 1.0; currPercentage += 0.05) {
 var offsetString = (currPercentage * 100).toString() + "%";
 var currColors;
 currColors = this.customColorMapByPercentage(colorMap, 0.0, 1.0, 1.0 - currPercentage);
 var colorsHex = this.rgbToHex(Math.round(currColors[0] * 255),
 Math.round(currColors[1] * 255),
 Math.round(currColors[2] * 255));
 gradient.push({
 Offset: offsetString,
 StopColor: colorsHex
 });
 }
 return gradient;
 }
 
 func createGradient(colorMap: [UIColor]) {
 
 var gradient : [String : Any] = [:]
 
 for currentPercentage in 0.stride(to: 1, by: 0.05) {
    print(currentPercentage)
    var offsetString = String(currPercentage * 100) + "%"
    var currColors = [UIColor]()
 }

 
 }
 
 
 func customColorMapByPercentage(colorMap: [UIColor], minValue: Float, maxValue: Float, percentage: Float) {
 var currValue = ((maxValue - minValue)*percentage) + minValue
 return customColorMap(colormap, minValue, maxValue, currValue)
 
 }
 
 
 customColorMap (colormap, minValue, maxValue, currValue){
 var valueScaled = (currValue - minValue)/(maxValue - minValue);
 
 if (currValue < minValue) {
 var lowerColor = [colormap[0].r, colormap[0].g, colormap[0].b];
 var upperColor = [colormap[0].r, colormap[0].g, colormap[0].b];
 var percentFade = 1.0;
 } else if (currValue > maxValue) {
 var curLoc = colormap.length-1;
 var lowerColor = [colormap[curLoc].r, colormap[curLoc].g, colormap[curLoc].b];
 var upperColor = [colormap[curLoc].r, colormap[curLoc].g, colormap[curLoc].b];
 var percentFade = 1.0;
 } else {
 for (var i = 1; i < colormap.length; i++) {
 if (valueScaled >= colormap[i - 1].x && valueScaled <= colormap[i].x) {
 var lowerColor = [colormap[i - 1].r, colormap[i - 1].g, colormap[i - 1].b];
 var upperColor = [colormap[i].r, colormap[i].g, colormap[i].b];
 var percentFade = (valueScaled - colormap[i - 1].x) / (colormap[i].x - colormap[i - 1].x);
 break;
 } else if (i == colormap.length - 1 && valueScaled > colormap[i].x) {
 
 break;
 }
 }
 }
 
 var diffRed = upperColor[0] - lowerColor[0];
 var diffGreen = upperColor[1] - lowerColor[1];
 var diffBlue = upperColor[2] - lowerColor[2];
 
 diffRed = (diffRed * percentFade) + lowerColor[0];
 diffGreen = (diffGreen * percentFade) + lowerColor[1];
 diffBlue = (diffBlue * percentFade) + lowerColor[2];
 
 return [diffRed, diffGreen, diffBlue];
 }
 
 
 
 func customColorMap(colorMap: [UIColor], minValue: Float, maxValue: Float, currValue: Float) {
 var valueScaled = (currValue - minValue)/(maxValue - minValue)
 
 if currValue < minValue {
 
 var percentFade = 1.0
 }
 else{
 
 }
 
 }
 
 
*/

func customColorMap(colorMap: [UIColor], minValue: Float, maxValue: Float, currValue: Float) {
    var valueScaled = (currValue - minValue)/(maxValue - minValue)
    
    if currValue < minValue {
        var lowerColor = colorMap[0]
       
    }
    else if currValue > maxValue {
        
    }
    
}

//Color map from hex values
func createColorMapFromHexValues(hexValues : [String]) -> [UIColor] {
    var colorsMap : [UIColor] = []
    var currColor = UIColor()
    
    for index in 0..<hexValues.count {
        currColor = hexStringToUIColor(hex: hexValues[index])
        colorsMap.append(currColor)
    }
    
    return colorsMap
}

//RGB to HEX
func rgbToHex(r: Float, g: Float, b: Float) -> String {
    return "#" + componentToHex(c: r) + componentToHex(c: g) + componentToHex(c: b)
}

func componentToHex(c: Float)  -> String {
    let hex = String(c)
    return hex.count == 1 ? "0" + hex : hex
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


