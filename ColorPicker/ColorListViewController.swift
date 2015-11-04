//
//  ColorListViewController.swift
//  ColorPicker
//
//  Created by Broccoli on 15/11/2.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ColorListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblColorName: UILabel!
    
    var dataArr = [ColorInfo]()
    // 隐藏 状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor(red: 225 / 255.0, green: 107 / 255.0, blue: 140 / 255.0, alpha: 1)
        
        lblColorName.text = dataArr[0].colorName
        lblColorName.font = UIFont(name: "HeiseiMinStd-W7", size: 36.0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ColorPropertyTableViewController" {
            let VC = segue.destinationViewController as! ColorPropertyTableViewController
            for _ in 0 ..< 250 {
                dataArr.append(ColorInfo.randomInit())
            }
            VC.colorInfo = dataArr[0]
        }
    }
}

private let CellIdentifier = "ColorCollectionViewCell"
extension ColorListViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ColorCollectionViewCell
        for view in cell.subviews {
            view.removeFromSuperview()
            
        }
        if let sublayer = cell.layer.sublayers {
            for layer in sublayer {
                layer.removeFromSuperlayer()
            }
        }
      
        
        print(indexPath.row)
        print(dataArr[indexPath.row].RValue)
        print(dataArr[indexPath.row].GValue)
        print(dataArr[indexPath.row].BValue)
        cell.colorInfo = dataArr[indexPath.row]
        return cell
    }
}

extension ColorListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // TODO: 动画 动画 动画
        NSNotificationCenter.defaultCenter().postNotificationName("kChangeColorProperty", object: nil, userInfo: ["colorInfo" : dataArr[indexPath.row]])
        lblColorName.text = dataArr[indexPath.row].colorName
        
        // 动画修改颜色
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerBackgroundColor)
        animation.toValue = UIColor(red: CGFloat(dataArr[indexPath.row].RValue) / 255.0, green: CGFloat(dataArr[indexPath.row].GValue) / 255.0, blue: CGFloat(dataArr[indexPath.row].BValue) / 255.0, alpha: 1.0)
        animation.duration = 3.0
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        self.view.layer.pop_addAnimation(animation, forKey: nil)
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
}























class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var lblRGBValue: UILabel!
    @IBOutlet var lblRGBName: UILabel!
    
    var colorInfo: ColorInfo! {
        didSet {
            createRBGValue()
            createColorName()
            createColorCount()
            createEnglishName()
            drawMaskLayer()
            
            beginAnimation()
        }
    }
    
    var lblEN: UILabel!
    var lblRGB: UILabel!
    var lblCount: UILabel!
    var lblName: UILabel!
    
    var lineLayer1: CAShapeLayer!
    var lineLayer2: CAShapeLayer!
    var lineLayer3: CAShapeLayer!
    
    var shapeLayer1: CAShapeLayer!
    var shapeLayer2: CAShapeLayer!
    var shapeLayer3: CAShapeLayer!
    var shapeLayer4: CAShapeLayer!
    
  
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    private func beginAnimation() {
        
        let lineAnimation1 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        lineAnimation1.fromValue = 0.5
        lineAnimation1.toValue = CGFloat(colorInfo.RValue) / 255.0 / 2.0
        lineAnimation1.duration = 1.0
        lineAnimation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        lineLayer1.pop_addAnimation(lineAnimation1, forKey: "strokeEnd")
        
        let lineAnimation2 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        lineAnimation2.fromValue = 0.5
        lineAnimation2.toValue = CGFloat(colorInfo.GValue) / 255.0 / 2.0
        lineAnimation2.duration = 1.0
         lineAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        lineLayer2.pop_addAnimation(lineAnimation2, forKey: "strokeEnd")
        
        let lineAnimation3 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        lineAnimation3.fromValue = 0.5
        lineAnimation3.toValue = CGFloat(colorInfo.BValue) / 255.0 / 2.0
        lineAnimation3.duration = 1.0
        lineAnimation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        lineLayer3.pop_addAnimation(lineAnimation3, forKey: "strokeEnd")
        
        let animation1 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation1.fromValue = 1.0
        animation1.toValue = CGFloat(colorInfo.CValue) / 100.0
        animation1.duration = 3.0
        animation1.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        shapeLayer1.pop_addAnimation(animation1, forKey: "shapeLayer1Animation")
        
        let animation2 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation2.fromValue = 1.0
        animation2.toValue = CGFloat(colorInfo.MValue) / 100.0
        animation2.duration = 3.0
        animation2.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        shapeLayer2.pop_addAnimation(animation2, forKey: "shapeLayer2Animation")
        
        let animation3 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation3.fromValue = 1.0
        animation3.toValue = CGFloat(colorInfo.YValue) / 100.0
        animation3.duration = 3.0
        animation3.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        shapeLayer3.pop_addAnimation(animation3, forKey: "shapeLayer3Animation")
        
        let animation4 = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation4.fromValue = 1.0
        animation4.toValue = CGFloat(colorInfo.KValue) / 100.0
        animation4.duration = 3.0
        animation4.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        shapeLayer4.pop_addAnimation(animation4, forKey: "shapeLayer4Animation")
    }
    
    private func drawMaskLayer() {
        
        let linePath1 = UIBezierPath()
        linePath1.moveToPoint(CGPoint(x: 22, y: 195))
        linePath1.addLineToPoint(CGPoint(x: 22, y: 360))
        linePath1.closePath()
        lineLayer1 = CAShapeLayer()
        lineLayer1.strokeColor = UIColor.whiteColor().CGColor
        lineLayer1.lineWidth = 2.0
        lineLayer1.path = linePath1.CGPath
        layer.addSublayer(lineLayer1)
        
        let linePath2 = UIBezierPath()
        linePath2.moveToPoint(CGPoint(x: 27, y: 195))
        linePath2.addLineToPoint(CGPoint(x: 27, y: 360))
        linePath2.closePath()
        lineLayer2 = CAShapeLayer()
        lineLayer2.strokeColor = UIColor.whiteColor().CGColor
        lineLayer2.lineWidth = 2.0
        lineLayer2.path = linePath2.CGPath
        layer.addSublayer(lineLayer2)
        
        let linePath3 = UIBezierPath()
        linePath3.moveToPoint(CGPoint(x: 32, y: 195))
        linePath3.addLineToPoint(CGPoint(x: 32, y: 360))
        linePath3.closePath()
        lineLayer3 = CAShapeLayer()
        lineLayer3.strokeColor = UIColor.whiteColor().CGColor
        lineLayer3.lineWidth = 2.0
        lineLayer3.path = linePath3.CGPath
        layer.addSublayer(lineLayer3)
        
        
        
        let path1 = UIBezierPath(arcCenter: CGPoint(x: 18, y: 39), radius: 12, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
        shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer1.fillColor = UIColor.clearColor().CGColor
        shapeLayer1.path = path1.CGPath
        shapeLayer1.lineWidth = 8.0
        self.layer.addSublayer(shapeLayer1)
        
        let path2 = UIBezierPath(arcCenter: CGPoint(x: 18, y: 81), radius: 12, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
        shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer2.fillColor = UIColor.clearColor().CGColor
        shapeLayer2.path = path2.CGPath
        shapeLayer2.lineWidth = 8.0
        self.layer.addSublayer(shapeLayer2)
        
        let path3 = UIBezierPath(arcCenter: CGPoint(x: 18, y: 123), radius: 12, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
        shapeLayer3 = CAShapeLayer()
        shapeLayer3.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer3.fillColor = UIColor.clearColor().CGColor
        shapeLayer3.path = path3.CGPath
        shapeLayer3.lineWidth = 8.0
        self.layer.addSublayer(shapeLayer3)
        
        let path4 = UIBezierPath(arcCenter: CGPoint(x: 18, y: 165), radius: 12, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
        shapeLayer4 = CAShapeLayer()
        shapeLayer4.strokeColor = UIColor.whiteColor().CGColor
        shapeLayer4.fillColor = UIColor.clearColor().CGColor
        shapeLayer4.path = path4.CGPath
        shapeLayer4.lineWidth = 8.0
        self.layer.addSublayer(shapeLayer4)
    }
    
    // 创建 颜色 英文名
    private func createEnglishName() {
        lblEN = UILabel(frame: CGRect(x: 60 - 17, y: 195 + 17, width: 165, height: 17))
        lblEN.font = UIFont(name: "DeepdeneBQ-Roman", size: 17.0)
        lblEN.textColor = UIColor.whiteColor()
        lblEN.text = colorInfo.colorEN
        lblEN.layer.anchorPoint = CGPoint(x: 0, y: 1)
        lblEN.layer.position = CGPoint(x: 60 - 17, y: 195)
        lblEN.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblEN)
    }
    
    // 创建 颜色 RGB 值
    private func createRBGValue() {
        lblRGB = UILabel(frame: CGRect(x: 0, y: 195 + 9, width: 55, height: 11))
        lblRGB.font = UIFont.systemFontOfSize(11.0)
        lblRGB.textColor = UIColor.whiteColor()
        lblRGB.text = colorInfo.RBGHexValue
        lblRGB.layer.anchorPoint = CGPoint(x: 0, y: 1)
        lblRGB.layer.position = CGPoint(x: 0, y: 195)
        lblRGB.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblRGB)
    }
    
    // 创建 颜色 编号
    private func createColorCount() {
        lblCount = UILabel(frame: CGRect(x: 60, y: 23, width: 30, height: 13))
        lblCount.font = UIFont.systemFontOfSize(13.0)
        lblCount.textColor = UIColor.whiteColor()
        lblCount.text = colorInfo.colorCount
        lblCount.layer.anchorPoint = CGPoint(x: 0, y: 0)
        lblCount.layer.position = CGPoint(x: 60, y: 23)
        lblCount.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblCount)
    }
    
    // 创建 颜色 中文名
    private func createColorName() {
        lblName = UILabel(fontname: "HeiseiMinStd-W7", labelText: colorInfo.colorName, fontSize: 17.0)
        lblName.textColor = UIColor.whiteColor()
        lblName.frame = CGRect(x: 60 - CGRectGetWidth(lblName.bounds), y: 180 - CGRectGetHeight(lblName.bounds), width: CGRectGetWidth(lblName.bounds), height: CGRectGetHeight(lblName.bounds))
        self.addSubview(lblName)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        // draw color view
        CGContextSetRGBFillColor(ctx, CGFloat(colorInfo.RValue) / 255.0, CGFloat(colorInfo.GValue) / 255.0, CGFloat(colorInfo.BValue) / 255.0, 0.5)
        CGContextFillRect(ctx, CGRect(x: 0, y: 0, width: 60, height: 8))
        
        // draw base white circle
        CGContextSetLineWidth(ctx, 8)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.6)

        CGContextAddArc(ctx, 18, 39, 12, 0, CGFloat(2 * M_PI), 0)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        CGContextAddArc(ctx, 18, 81, 12, 0, CGFloat(2 * M_PI), 0)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        CGContextAddArc(ctx, 18, 123, 12, 0, CGFloat(2 * M_PI), 0)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        CGContextAddArc(ctx, 18, 165, 12, 0, CGFloat(2 * M_PI), 0)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        // RGB 数值 线
        CGContextSetLineWidth(ctx, 2)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.4)
        
        let pointsValue1 = [CGPoint(x: 22, y: 195), CGPoint(x: 22, y: 360)]
        CGContextAddLines(ctx, pointsValue1, 2)
        
        let pointsValue2 = [CGPoint(x: 27, y: 195), CGPoint(x: 27, y: 360)]
        CGContextAddLines(ctx, pointsValue2, 2)
        
        let pointsValue3 = [CGPoint(x: 32, y: 195), CGPoint(x: 32, y: 360)]
        CGContextAddLines(ctx, pointsValue3, 2)
        CGContextStrokePath(ctx)
    }
}

extension UILabel {
    
    // 生成 竖向文本
    convenience init(fontname: String ,labelText: String, fontSize :CGFloat){
        let font = UIFont(name: fontname, size: fontSize) as UIFont!
        let textAttributes: [String : AnyObject] = [NSFontAttributeName: font]
        let labelSize = labelText.boundingRectWithSize(CGSizeMake(fontSize, 480), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
        self.init(frame: labelSize)
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
        self.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.numberOfLines = 0
    }
}