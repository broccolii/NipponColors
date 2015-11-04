//
//  ColorInfo.swift
//  ColorPicker
//
//  Created by Broccoli on 15/11/3.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ColorInfo {
    var colorEN: String!
    var colorName: String!
    var colorCount: String!
    var RBGHexValue: String!
    
    var CValue: Int!
    var MValue: Int!
    var YValue: Int!
    var KValue: Int!
    
    var RValue: Int!
    var GValue: Int!
    var BValue: Int!
    
    init() {
        colorEN = ""
        colorName = ""
        colorCount = ""
        RBGHexValue = ""
        
        CValue = 0
        MValue = 0
        YValue = 0
        KValue = 0
        
        RValue = 0
        GValue = 0
        BValue = 0
    }
    
    class func randomInit() -> ColorInfo {
        let info = ColorInfo()
        
        let colorENArr = ["MIZU", "ASAGI", "KARAKURENAI", "HANADA", "KON"]
        info.colorEN = colorENArr[Int(arc4random() % 5)]
        
        let colorNameArr = ["苗", "芥子", "玉蜀黍", "肥後煤竹", "錆鉄御納戸"]
        info.colorName = colorNameArr[Int(arc4random() % 5)]
        
        let colorCountArr = ["008", "088", "099", "222", "111"]
        info.colorCount = colorCountArr[Int(arc4random() % 5)]
        
        let RBGHexValueArr = ["#B5495B", "#D05A6E", "#FEDFE1", "#D0104C", "#EEA9A9"]
        info.RBGHexValue = RBGHexValueArr[Int(arc4random() % 5)]
        
        info.CValue = Int(arc4random() % 100)
        info.MValue = Int(arc4random() % 100)
        info.YValue = Int(arc4random() % 100)
        info.KValue = Int(arc4random() % 100)
        
        info.RValue = Int(arc4random() % 256)
        info.GValue = Int(arc4random() % 256)
        info.BValue = Int(arc4random() % 256)

        return info
    }
    
    /**
     "name": "燕脂",
     "cmyk": "042093068006",
     "rgb": "9F353A",
     "color": "ENJI"
     */
    class func dicToModel(dic: [String: String], index: Int) -> ColorInfo {
        let model = ColorInfo()
        model.colorEN = dic["color"]
        model.colorName = dic["name"]
        model.colorCount = formatColorCount(index)
        model.RBGHexValue = "#\(dic["rgb"]!)"
        
        let CMYKValue = formatCMYKValue(dic["cmyk"]!)
        model.CValue = CMYKValue.0
        model.MValue = CMYKValue.1
        model.YValue = CMYKValue.2
        model.KValue = CMYKValue.3
        
        let RGBValue = formatRGBValue(dic["rgb"]!)
        model.RValue = RGBValue.0
        model.GValue = RGBValue.1
        model.BValue = RGBValue.2
        
        return model
    }
    
    class func formatRGBValue(str: String) -> (Int, Int, Int) {
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0
        
        let range1 = Range<String.Index>(start: str.startIndex.advancedBy(0) , end: str.startIndex.advancedBy(2))
        NSScanner(string: str.substringWithRange(range1)).scanHexInt(&red)
        
        let range2 = Range<String.Index>(start: str.startIndex.advancedBy(2) , end: str.startIndex.advancedBy(4))
        NSScanner(string: str.substringWithRange(range2)).scanHexInt(&green)
        
        let range3 = Range<String.Index>(start: str.startIndex.advancedBy(4) , end: str.startIndex.advancedBy(6))
        NSScanner(string: str.substringWithRange(range3)).scanHexInt(&blue)
        
        return (Int(red), Int(green), Int(blue))
    }
    
    class func formatCMYKValue(str: String) -> (Int, Int, Int, Int) {
        let range1 = Range<String.Index>(start: str.startIndex.advancedBy(0) , end: str.startIndex.advancedBy(3))
        let int1 = Int(str.substringWithRange(range1))
        
        let range2 = Range<String.Index>(start: str.startIndex.advancedBy(3) , end: str.startIndex.advancedBy(6))
        let int2 = Int(str.substringWithRange(range2))
        
        let range3 = Range<String.Index>(start: str.startIndex.advancedBy(6) , end: str.startIndex.advancedBy(9))
        let int3 = Int(str.substringWithRange(range3))
        
        let range4 = Range<String.Index>(start: str.startIndex.advancedBy(9) , end: str.startIndex.advancedBy(12))
        let int4 = Int(str.substringWithRange(range4))
        
        return (int1!, int2!, int3!, int4!)
    }
    
    class func formatColorCount(count: Int) -> String {
        if count < 9 {
            return "00\(count + 1)"
        } else if count < 98 {
            return "0\(count + 1)"
        } else {
            return "\(count + 1)"
        }
    }
}
