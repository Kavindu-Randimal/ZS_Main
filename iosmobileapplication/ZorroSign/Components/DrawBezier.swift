//
//  DrawBezier.swift
//  ZorroSign
//
//  Created by Apple on 23/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DrawBezier: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    var delegate: CustomCellProtocol?
    var lines : [Line] = []
    
    var lastPoint : CGPoint!
    
    var lineColor: UIColor = UIColor.black
    
    var lineW: CGFloat = 1.0
    
    required init(coder aDecoder : NSCoder) {
        
        super.init(coder: aDecoder)!
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("drawview touches")
        let location: CGPoint = (touches.first?.location(in: self))!
        let v: UIView = self.hitTest(location, with: nil)!
        print("view tag: \(v.tag)")
        
        delegate?.onSelectCell(view: v)
        lastPoint = touches.first?.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let newPoint = touches.first?.location(in: self)
        
        lines.append(Line(start: lastPoint, end: newPoint!))
        
        lastPoint = newPoint
        
        self.setNeedsDisplay()
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location: CGPoint = (touches.first?.location(in: self))!
        let v: UIView = self.hitTest(location, with: nil)!
        print("view tag: \(v.tag)")
        
        let image = captureImg()
        
        delegate?.onDrawEnd(lines: lines, tag: v.tag, img: image)
    }
    
    override func draw(_ rect: CGRect) {
        
        var context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        for line in lines
            
        {
            
            let aPath = UIBezierPath()
            
            aPath.lineWidth = lineW
            
            aPath.lineJoinStyle = .round
            
            aPath.move(to: CGPoint(x:line.start.x,y:line.start.y))
            
            aPath.addLine(to: CGPoint(x:line.end.x,y:line.end.y))
            lineColor.setStroke()
            aPath.stroke()
            
            aPath.lineCapStyle = .round
            
            //cgcontextSetLineCap()
            
        }
        
    }
    
    func captureImg()-> UIImage {
        
        let rect: CGRect = self.bounds
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return img
    }
}
