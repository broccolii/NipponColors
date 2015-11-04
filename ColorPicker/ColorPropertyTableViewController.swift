//
//  ColorPropertyTableViewController.swift
//  ColorPicker
//
//  Created by Broccoli on 15/11/2.
//  Copyright © 2015年 Broccoli. All rights reserved.
//

import UIKit

class ColorPropertyTableViewController: UITableViewController {
    
    var colorInfo: ColorInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        NSNotificationCenter.defaultCenter().addObserverForName("kChangeColorProperty", object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            self.colorInfo = notification.userInfo!["colorInfo"] as! ColorInfo
            self.tableView.reloadData()
        }
    }
}

// MARK: - Table view data source
private let CMYKCellIdentifier = "CMYKTableViewCell"
private let RGBCellIdentifier = "RGBTableViewCell"

extension ColorPropertyTableViewController {
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let CMYKCell = tableView.dequeueReusableCellWithIdentifier(CMYKCellIdentifier, forIndexPath: indexPath) as! CMYKTableViewCell
            CMYKCell.colorValue = colorInfo.CValue
            CMYKCell.lblCMYK.text = "C"
            return CMYKCell
        case 1:
            let CMYKCell = tableView.dequeueReusableCellWithIdentifier(CMYKCellIdentifier, forIndexPath: indexPath) as! CMYKTableViewCell
            CMYKCell.colorValue = colorInfo.MValue
            CMYKCell.lblCMYK.text = "M"
            return CMYKCell
        case 2:
            let CMYKCell = tableView.dequeueReusableCellWithIdentifier(CMYKCellIdentifier, forIndexPath: indexPath) as! CMYKTableViewCell
            CMYKCell.colorValue = colorInfo.YValue
            CMYKCell.lblCMYK.text = "Y"
            return CMYKCell
        case 3:
            let CMYKCell = tableView.dequeueReusableCellWithIdentifier(CMYKCellIdentifier, forIndexPath: indexPath) as! CMYKTableViewCell
            CMYKCell.colorValue = colorInfo.KValue
            CMYKCell.lblCMYK.text = "K"
            return CMYKCell
        case 4:
            let RBGCell = tableView.dequeueReusableCellWithIdentifier(RGBCellIdentifier, forIndexPath: indexPath) as! RGBTableViewCell
            RBGCell.colorValue = colorInfo.RValue
            RBGCell.lblRGB.text = "R"
            return RBGCell
        case 5:
            let RBGCell = tableView.dequeueReusableCellWithIdentifier(RGBCellIdentifier, forIndexPath: indexPath) as! RGBTableViewCell
            RBGCell.colorValue = colorInfo.GValue
            RBGCell.lblRGB.text = "G"
            return RBGCell
        case 6:
            let RBGCell = tableView.dequeueReusableCellWithIdentifier(RGBCellIdentifier, forIndexPath: indexPath) as! RGBTableViewCell
            RBGCell.colorValue = colorInfo.BValue
            RBGCell.lblRGB.text = "B"
            return RBGCell
        default :
            let RBGCell = tableView.dequeueReusableCellWithIdentifier(RGBCellIdentifier, forIndexPath: indexPath) as! RGBTableViewCell
            return RBGCell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 1, 2, 3 :
            return 60
        case 4, 5, 6:
            return 40
        default :
            return 60
        }
    }
}

class CMYKTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblCMYK: UILabel!
    
    var colorValue: Int? {
        set {
            labelValueAnimation(Int(newValue!))
            if colorValue == nil {
                circleAnimation(newValue!, oldValue: 0)
            } else {
                circleAnimation(newValue!, oldValue: colorValue!)
            }
        }
        get {
            return nil
        }
    }
    
    // cell width = 60
    // cell heigt = 60
    
    var index: Int!
    var lblValue: UILabel!
    var shapeLayer: CAShapeLayer!
    
    private func circleAnimation(newValue: Int, oldValue: Int) {
        
        let animation = POPBasicAnimation(propertyNamed: kPOPShapeLayerStrokeEnd)
        animation.fromValue = CGFloat(oldValue) / 100.0
        animation.toValue = CGFloat(newValue) / 100.0
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        shapeLayer.pop_addAnimation(animation, forKey: "circleAnimation")
    }
    
    private func labelValueAnimation(newValue: Int) {
        
        let animation = POPBasicAnimation()
        animation.property = POPMutableAnimatableProperty.propertyWithName("labelValue", initializer: { (prop) -> Void in
            prop.writeBlock = {
            (obj, values) in
                let lbl = obj as! UILabel
                let num = Int(values[0])
                lbl.text = "\(num)"
            }
        }) as! POPAnimatableProperty
        if lblValue.text == nil {
             animation.fromValue = 0
        } else {
            animation.fromValue = Int(lblValue.text!)
        }
        animation.toValue = newValue
        animation.duration = 1.0
        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.12, 1, 0.11, 0.94)
        lblValue.pop_addAnimation(animation, forKey: "labelValueAnimation")
    }
    
    override func awakeFromNib() {
        createLblValue()
        
        let path = UIBezierPath(arcCenter: CGPoint(x: 30, y: 35), radius: 20, startAngle: CGFloat(-M_PI / 2), endAngle: CGFloat(-M_PI / 2) + CGFloat(M_PI * 2), clockwise: true)
        
        shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.darkGrayColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.path = path.CGPath
        shapeLayer.lineWidth = 2.0
        self.layer.addSublayer(shapeLayer)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // draw line
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, 2)
        
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.6)
        let pointsTop = [CGPoint(x: 10, y: 0), CGPoint(x: 50, y: 0)]
        CGContextAddLines(ctx, pointsTop, 2)
        CGContextStrokePath(ctx)
        
        // draw base white circle
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.4)
        CGContextAddArc(ctx, 30, 35, 20, 0, CGFloat(2 * M_PI), 0)
        CGContextDrawPath(ctx, CGPathDrawingMode.Stroke)
        
        
    }
    
    private func createLblValue() {
        lblValue = UILabel(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        lblValue.center = CGPoint(x: 30, y: 35)
        lblValue.textAlignment = NSTextAlignment.Center
        lblValue.textColor = UIColor.whiteColor()
        lblValue.font = UIFont.systemFontOfSize(20)
        self.addSubview(lblValue)
    }
}

class RGBTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblRGB: UILabel!
    @IBOutlet weak var lblRGBValue: UILabel!
    
    // cell width = 60
    // cell heigt = 40
    
    var colorValue: Int! {
        didSet {
            lblRGBValue.text = "\(colorValue)"
        }
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // draw line
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(ctx, 2)
        CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 0.6)
        let pointsTop = [CGPoint(x: 10, y: 0), CGPoint(x: 50, y: 0)]
        CGContextAddLines(ctx, pointsTop, 2)
        CGContextStrokePath(ctx)
        
    }
}

// TODO :
// 1. 右上角 文本 显示
// 2. 背景色演示的 time function 的贝塞尔曲线
// 3. RBG 数值动画
// 4. 做旧 遮罩
// 5. CollectionView Layout
// 6. 代码重构
// 7. CMYK circle 不能从0开始
// 待定