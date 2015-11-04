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
}
