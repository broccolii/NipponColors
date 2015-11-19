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
  
    /**
     dictionary To model
     
     - parameter dic:   从本地文件中读取的数据
     - parameter index: 编号
     
     - returns:  model
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
    
    /**
     将 十六进制  转换成 255, 255, 255
     
     - parameter str: 十六进制字符串
     
     - returns:  RGB value
     */
    class func formatRGBValue(str: String) -> (Int, Int, Int) {
        var red: UInt32 = 0
        var green: UInt32 = 0
        var blue: UInt32 = 0
        
        let RRange = Range<String.Index>(start: str.startIndex.advancedBy(0) , end: str.startIndex.advancedBy(2))
        NSScanner(string: str.substringWithRange(RRange)).scanHexInt(&red)
        
        let GRange = Range<String.Index>(start: str.startIndex.advancedBy(2) , end: str.startIndex.advancedBy(4))
        NSScanner(string: str.substringWithRange(GRange)).scanHexInt(&green)
        
        let BRange = Range<String.Index>(start: str.startIndex.advancedBy(4) , end: str.startIndex.advancedBy(6))
        NSScanner(string: str.substringWithRange(BRange)).scanHexInt(&blue)
        
        return (Int(red), Int(green), Int(blue))
    }
    
    /**
     分割字符串
     
     - parameter str:  CMYK 字符串
     
     - returns:  CMYK 四个 值
     */
    class func formatCMYKValue(str: String) -> (Int, Int, Int, Int) {
        let CRange = Range<String.Index>(start: str.startIndex.advancedBy(0) , end: str.startIndex.advancedBy(3))
        let CValue = Int(str.substringWithRange(CRange))!
        
        let MRange = Range<String.Index>(start: str.startIndex.advancedBy(3) , end: str.startIndex.advancedBy(6))
        let MValue = Int(str.substringWithRange(MRange))!
        
        let YRange = Range<String.Index>(start: str.startIndex.advancedBy(6) , end: str.startIndex.advancedBy(9))
        let YValue = Int(str.substringWithRange(YRange))!
        
        let KRange = Range<String.Index>(start: str.startIndex.advancedBy(9) , end: str.startIndex.advancedBy(12))
        let KValue = Int(str.substringWithRange(KRange))!
        
        return (CValue, MValue, YValue, KValue)
    }
    
    /**
     位数不足 用零补齐
     
     - parameter count: 编号
     
     - returns: 转换后的字符串
     */
    class func formatColorCount(count: Int) -> String {
       return String(format: "%03d", count + 1)
    }
}
