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
    
    @IBOutlet weak var lblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblWidthConstraint: NSLayoutConstraint!
    
    var dataArr = [ColorInfo]()
    
    // 隐藏 状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Life cycle
    override func loadView() {
        super.loadView()
        // 在 viewdidload 之前 调用 prepareForSegue 所以 需要 提前 读取到 数据
        readColorInfoData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加 页面数据
        view.backgroundColor = UIColor(red: CGFloat(dataArr[0].RValue) / 255.0, green: CGFloat(dataArr[0].GValue) / 255.0, blue: CGFloat(dataArr[0].BValue) / 255.0, alpha: 1.0)
        lblColorName.text = dataArr[0].colorName
        
        addOverLayer()
        screenAdaptation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ColorPropertyTableViewController" {
            let VC = segue.destinationViewController as! ColorPropertyTableViewController
            VC.colorInfo = dataArr[0]
        }
    }
    
    // MARK: - private method
    /// 读取 颜色数据
    func readColorInfoData() {
        let path = NSBundle.mainBundle().pathForResource("ColorInfoData", ofType: nil)
        let data =  NSData(contentsOfFile: path!)
        
        do {
            let jsonArr = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! Array<[String: String]>
            
            for (index, value) in jsonArr.enumerate() {
                dataArr.append(ColorInfo.dicToModel(value, index: index))
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    /// 愚蠢的版本适配
    private func screenAdaptation() {
        // TODO: - 考虑 用最小 约束 修改适配
        if UIScreen.mainScreen().bounds.width == 320 {
            lblWidthConstraint.constant = 60
            lblColorName.font = UIFont(name: "HeiseiMinStd-W7", size: 35.0)
        } else {
            lblBottomConstraint.constant = 20
            lblColorName.font = UIFont(name: "HeiseiMinStd-W7", size: 43.0)
        }
    }
    
    // 添加 宣纸样式的遮罩
    private func addOverLayer() {
        let overLayer = UIImageView()
        overLayer.frame = UIScreen.mainScreen().bounds
        overLayer.image = UIImage(named: "blurLayer")
        overLayer.alpha = 0.4
        view.insertSubview(overLayer, aboveSubview: lblColorName)
    }
}

private let CellIdentifier = "ColorCollectionViewCell"
// MARK: - UICollectionViewDataSource
extension ColorListViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ColorCollectionViewCell
        // 清空 cell 之前的 view 和 layer
        // TODO: -  为了 VC 代码 简洁 这个可以写成 cell 的方法
        for view in cell.subviews {
            view.removeFromSuperview()
        }
        
        if let sublayer = cell.layer.sublayers {
            for layer in sublayer {
                layer.removeFromSuperlayer()
            }
        }
        
        cell.colorInfo = dataArr[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ColorListViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 系统自带动画 修改 lblColorName 的 透明度 文本 并且通知 下方 属性栏 开始动画
        UIView.animateWithDuration(1.2, animations: { () -> Void in
            self.lblColorName.alpha = 0.0
            }) { (finish) -> Void in
                self.lblColorName.text = self.dataArr[indexPath.row].colorName
                UIView.animateWithDuration(1.8, animations: { () -> Void in
                    self.lblColorName.alpha = 1.0
                    NSNotificationCenter.defaultCenter().postNotificationName("kChangeColorProperty", object: nil, userInfo: ["colorInfo" : self.dataArr[indexPath.row]])
                })
        }
        
        // POP 动画修改颜色
        let animation = POPBasicAnimation(propertyNamed: kPOPLayerBackgroundColor)
        animation.toValue = UIColor(red: CGFloat(dataArr[indexPath.row].RValue) / 255.0, green: CGFloat(dataArr[indexPath.row].GValue) / 255.0, blue: CGFloat(dataArr[indexPath.row].BValue) / 255.0, alpha: 1.0)
        animation.duration = 2.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        self.view.layer.pop_addAnimation(animation, forKey: nil)
        
        collectionView.reloadItemsAtIndexPaths([indexPath])
    }
}



/// MARK: - ColorCollectionViewCell
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
    
    /// 绘制 layer 的基础 data
    private let moveToPointArr = [CGPoint(x: 22, y: 195), CGPoint(x: 27, y: 195), CGPoint(x: 32, y: 195)]
    private let addLineToPointArr = [CGPoint(x: 22, y: 360), CGPoint(x: 27, y: 360), CGPoint(x: 32, y: 360)]
    private let arcCenterArr = [CGPoint(x: 18, y: 39), CGPoint(x: 18, y: 81), CGPoint(x: 18, y: 123), CGPoint(x: 18, y: 165)]
    
    /// RGB 线段
    private lazy var lineLayerArr: [CAShapeLayer]! = {
        var arr = [CAShapeLayer]()
        for i in 0 ..< 3 {
            let linePath = UIBezierPath()
            linePath.moveToPoint(self.moveToPointArr[i])
            linePath.addLineToPoint(self.addLineToPointArr[i])
            linePath.closePath()
            let lineLayer = CAShapeLayer()
            lineLayer.strokeColor = UIColor(white: 1.0, alpha: 0.7).CGColor
            lineLayer.lineWidth = 2.0
            lineLayer.path = linePath.CGPath
            
            arr.append(lineLayer)
        }
        return arr
    }()
    
    /// CMYK 圆弧
    private lazy var shapeLayerArr: [CAShapeLayer]! = {
        var arr = [CAShapeLayer]()
        for i in 0 ..< 4 {
            let path = UIBezierPath(arcCenter: self.arcCenterArr[i], radius: 12, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(M_PI * 3 / 2), clockwise: true)
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.whiteColor().CGColor
            shapeLayer.fillColor = UIColor.clearColor().CGColor
            shapeLayer.path = path.CGPath
            shapeLayer.lineWidth = 8.0
            
            arr.append(shapeLayer)
        }
        return arr
    }()
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        // draw base white circle
        CGContextSetLineWidth(ctx, 8)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.2)
        
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
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.2)
        
        let pointsValue1 = [CGPoint(x: 22, y: 195), CGPoint(x: 22, y: 360)]
        CGContextAddLines(ctx, pointsValue1, 2)
        
        let pointsValue2 = [CGPoint(x: 27, y: 195), CGPoint(x: 27, y: 360)]
        CGContextAddLines(ctx, pointsValue2, 2)
        
        let pointsValue3 = [CGPoint(x: 32, y: 195), CGPoint(x: 32, y: 360)]
        CGContextAddLines(ctx, pointsValue3, 2)
        CGContextStrokePath(ctx)
    }
    
    /// 绘制 底层视图
    private func drawMaskLayer() {
        for lineLayer in lineLayerArr {
            layer.addSublayer(lineLayer)
        }
        
        for shapeLayer in shapeLayerArr {
            layer.addSublayer(shapeLayer)
        }
        
        // draw color view
        let colorView = CALayer()
        colorView.frame = CGRect(x: 0, y: 0, width: 60, height: 8)
        colorView.backgroundColor = UIColor(red: CGFloat(colorInfo.RValue) / 255.0, green: CGFloat(colorInfo.GValue) / 255.0, blue: CGFloat(colorInfo.BValue) / 255.0, alpha: 1.0).CGColor
        self.layer.addSublayer(colorView)
    }
}

// MARK: - create widget
extension ColorCollectionViewCell {
    // 创建 颜色 英文名
    private func createEnglishName() {
        let lblEN = UILabel(frame: CGRect(x: 60 - 17, y: 195 + 17, width: 165, height: 17))
        lblEN.font = UIFont(name: "DeepdeneBQ-Roman", size: 17.0)
        lblEN.textColor = UIColor(white: 1.0, alpha: 0.9)
        lblEN.text = colorInfo.colorEN
        lblEN.layer.anchorPoint = CGPoint(x: 0, y: 1)
        lblEN.layer.position = CGPoint(x: 60 - 17, y: 195)
        lblEN.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblEN)
    }
    
    // 创建 颜色 RGB 值
    private func createRBGValue() {
        let lblRGB = UILabel(frame: CGRect(x: 0, y: 195 + 9, width: 55, height: 11))
        lblRGB.font = UIFont.systemFontOfSize(11.0)
        lblRGB.textColor = UIColor(white: 1.0, alpha: 0.9)
        lblRGB.text = colorInfo.RBGHexValue
        lblRGB.layer.anchorPoint = CGPoint(x: 0, y: 1)
        lblRGB.layer.position = CGPoint(x: 0, y: 195)
        lblRGB.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblRGB)
    }
    
    // 创建 颜色 编号
    private func createColorCount() {
        let lblCount = UILabel(frame: CGRect(x: 60, y: 23, width: 30, height: 13))
        lblCount.font = UIFont.systemFontOfSize(13.0)
        lblCount.textColor = UIColor(red: CGFloat(colorInfo.RValue) / 255.0, green: CGFloat(colorInfo.GValue) / 255.0, blue: CGFloat(colorInfo.BValue) / 255.0, alpha: 1.0)
        lblCount.text = colorInfo.colorCount
        lblCount.layer.anchorPoint = CGPoint(x: 0, y: 0)
        lblCount.layer.position = CGPoint(x: 60, y: 23)
        lblCount.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 2))
        self.addSubview(lblCount)
    }
    
    // 创建 颜色 中文名
    private func createColorName() {
        let lblName = UILabel(fontname: "HeiseiMinStd-W7", labelText: colorInfo.colorName, fontSize: 17.0)
        lblName.textColor = UIColor(white: 1.0, alpha: 0.9)
        lblName.frame = CGRect(x: 60 - CGRectGetWidth(lblName.bounds), y: 180 - CGRectGetHeight(lblName.bounds), width: CGRectGetWidth(lblName.bounds), height: CGRectGetHeight(lblName.bounds))
        self.addSubview(lblName)
    }
}
// MARK: - Add Animation
extension ColorCollectionViewCell {
    
    private func beginAnimation() {
        /// 添加 线段 的动画
        let lineAnimationToValueArr = [CGFloat(colorInfo.RValue) / 255.0 / 2.0, CGFloat(colorInfo.GValue) / 255.0 / 2.0, CGFloat(colorInfo.BValue) / 255.0 / 2.0]
        lineLayerAddAnimation(lineAnimationToValueArr)
        
        /// 添加 圆弧 的动画
        let shapeLayerToValueArr = [CGFloat(colorInfo.CValue) / 100.0, CGFloat(colorInfo.MValue) / 100.0, CGFloat(colorInfo.YValue) / 100.0, CGFloat(colorInfo.KValue) / 100.0]
        shapeLayerAddAnimation(shapeLayerToValueArr)
    }
    
    private func lineLayerAddAnimation(toValueArr: [CGFloat]) {
        for (i, lineLayer) in lineLayerArr.enumerate() {
            let lineAnimation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
            lineAnimation.fromValue = 0.5
            lineAnimation.toValue = toValueArr[i]
            lineAnimation.duration = 1.0
            lineAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            
            lineLayer.pop_addAnimation(lineAnimation, forKey: "strokeEnd")
        }
    }
    
    private func shapeLayerAddAnimation(toValueArr: [CGFloat]) {
        for (i, shapeLayer) in shapeLayerArr.enumerate() {
            let animation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
            animation.fromValue = 1.0
            animation.toValue = toValueArr[i]
            animation.duration = 3.0
            animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
            shapeLayer.pop_addAnimation(animation, forKey: "shapeLayer1Animation")
        }
    }
}

extension UILabel {
    // 生成 竖向文本 水平居下对齐
    convenience init(fontname: String ,labelText: String, fontSize :CGFloat) {
        let font = UIFont(name: fontname, size: fontSize) as UIFont!
        let textAttributes: [String : AnyObject] = [NSFontAttributeName: font]
        let labelSize = labelText.boundingRectWithSize(CGSizeMake(fontSize, 480), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: textAttributes, context: nil)
        self.init(frame: labelSize)
        self.attributedText = NSAttributedString(string: labelText, attributes: textAttributes)
        self.lineBreakMode = NSLineBreakMode.ByCharWrapping
        self.numberOfLines = 0
    }
}