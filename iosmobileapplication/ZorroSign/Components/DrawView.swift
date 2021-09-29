//
//  DrawView.swift
//  DrawSignDemo
//
//  Created by Apple on 12/07/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class DrawView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var delegate: CustomCellProtocol?
    var lines : [Line] = []
    
    var startPoint : CGPoint!
    var lastPoint : CGPoint!
    
    var lineColor: UIColor = UIColor.black
    
    var lineW: CGFloat = 2.0

    public let path = UIBezierPath()
    var controlPoints: [CGPoint] = []
    var signPathArr: [SignaturePath] = []
    var pathArr: [SignaturePath] = []
    var pointsArr: [CGPoint] = []
    
    required init(coder aDecoder : NSCoder) {
        
        super.init(coder: aDecoder)!
        self.contentMode = .left
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.beginPath()
        
        path.lineWidth = lineW
        
        path.lineJoinStyle = .round
        lineColor.setStroke()
        
        
        path.lineCapStyle = .round
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        pointsArr = []
        startPoint = touches.first?.location(in: self)
        lastPoint = touches.first?.location(in: self)
        pointsArr.append(lastPoint)
        
        controlPoints = [lastPoint]
        //path.removeAllPoints()
        path.move(to: lastPoint)
        
        let location: CGPoint = (touches.first?.location(in: self))!
        let v: UIView = self.hitTest(location, with: nil)!
        print("view tag: \(v.tag)")
        
        delegate?.onSelectCell(view: v)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first?.location(in: self)
        //lastPoint = point
        
        pointsArr.append(point!)
        
        if pointsArr.count > 2 {
            if pointsArr.count == 3 {
                pointsArr.insert(pointsArr[0], at: 0)
            }
            var tmp = self.calculateCP(s1: pointsArr[0], s2: pointsArr[1], s3: pointsArr[2])
            let c2 = tmp["c2"]
            tmp = self.calculateCP(s1: pointsArr[1], s2: pointsArr[2], s3: pointsArr[3])
            let c3 = tmp["c1"]
            
            let signpath = SignaturePath()
            signpath.startPoint = pointsArr[1]
            signpath.endPoint = pointsArr[2]
            signpath.control1 = c2
            signpath.control2 = c3
            
            signPathArr.append(signpath)
            
            pointsArr.remove(at: 0)
        }
        guard controlPoints.count == 4 else {
            controlPoints.append(point!)
            return
        }
        let endPoint = CGPoint(
            x: (controlPoints[2].x + (point?.x)!)/2,
            y: (controlPoints[2].y + (point?.y)!)/2
        )
        
        path.addCurve(
            to: endPoint,
            controlPoint1: controlPoints[1],
            controlPoint2: controlPoints[2]
        )
        //path.move(to: startPoint!)
        //path.addLine(to: point!)
        
        path.stroke()
        controlPoints = [endPoint, point] as! [CGPoint]
        startPoint = point
        
        self.setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first?.location(in: self)
        
        if controlPoints.count > 1 {
            for _ in controlPoints.count..<4 {
                touchesMoved(touches, with: event)
            }
        }
        controlPoints = []
        
        let location: CGPoint = (touches.first?.location(in: self))!
        if let v = self.hitTest(location, with: nil) {
        //print("view tag: \(v.tag)")
        
            let image = captureImg()
        
        //delegate?.onDrawEnd(lines: lines, tag: v.tag, img: image)
        //calculateCP()
            delegate?.onDrawEnd(pathArr: signPathArr, tag: v.tag, img: image)
            print("SELF")
            print(self.bounds.size)
            print(self.frame.size)
            print("SELF")
        }
    }
    
    public func touchesCancelled(at point: CGPoint) {
        //path.removeAllPoints()
    }
    
    override func draw(_ rect: CGRect) {
     
        path.lineWidth = lineW
        
        path.lineJoinStyle = .round
        lineColor.setStroke()
        
        
        path.lineCapStyle = .round
        path.stroke()
    }
    
    func createPath() {
        
        lineColor.setStroke()
        path.stroke()
        
        var cnt = 0
        for spath in signPathArr {
            if cnt == 0 {
                //path.move(to: spath.startPoint!)
            }
            /*
            path.addCurve(
                to: spath.endPoint!,
                controlPoint1: spath.control1!,
                controlPoint2: spath.control2!
            )*/
            if spath.startPoint != nil {
                path.move(to: spath.startPoint!)
            }
            if spath.endPoint != nil {
                path.addLine(to: spath.endPoint!)
            }
            
            if spath.startPoint != nil && spath.endPoint != nil {
                cnt = cnt + 1
            }
        }
    }
    
    func updatePath() {
        
        lineColor.setStroke()
        var cnt = 0
        for spath in signPathArr {
            if cnt == 0 {
                //path.move(to: spath.startPoint!)
            }
            
            if spath.startPoint != nil {
                path.move(to: spath.startPoint!)
            }
            
             path.addCurve(
             to: spath.endPoint!,
             controlPoint1: spath.control1!,
             controlPoint2: spath.control2!
             )
            
            if spath.endPoint != nil {
                //path.addLine(to: spath.endPoint!)
            }
            
            if spath.startPoint != nil && spath.endPoint != nil {
                cnt = cnt + 1
            }
        }
    }
    
    func changePathColor() {
        
        lineColor.setStroke()
        path.stroke()
    }
    
    func captureImg()-> UIImage {
        
        self.layer.borderWidth = 0.0
        self.backgroundColor = .clear
        let rect: CGRect = self.bounds
//        UIGraphicsBeginImageContext(rect.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }

    func calculateCP(s1: CGPoint, s2: CGPoint, s3: CGPoint) -> [String:CGPoint] {
       /*
        var derivative:NSMutableArray = NSMutableArray.init()
        
        for i in 0..<pointsArr.count {
            let prev:CGPoint = pointsArr[max(i-1,0)]
            let next:CGPoint = pointsArr[min(i+1, pointsArr.count-1)]
            
            let subval = (next - prev)
            derivative[i] = divide(val1: subval, divider: 2)
        }
        let tension: Int = 1
        
        for i in 0..<pointsArr.count {
            if i > 0 {
            let cp1:CGPoint = pointsArr[i-1] + (derivative[i-1] as! CGPoint) // /tension;
            let cp2:CGPoint = pointsArr[i] + (derivative[i] as! CGPoint) // /tension;
            
            let signpath = SignaturePath()
            signpath.startPoint = pointsArr[i-1]
            signpath.endPoint = pointsArr[i]
            signpath.control1 = cp1
            signpath.control2 = cp2
            
            pathArr.append(signpath)
            }
        }
 */
        
         
         let dx1 = s1.x - s2.x, dy1 = s1.y - s2.y,
         dx2 = s2.x - s3.x, dy2 = s2.y - s3.y
         
         let m1 = CGPoint( x: (s1.x + s2.x) / 2.0, y: (s1.y + s2.y) / 2.0 )
         let m2 = CGPoint( x: (s2.x + s3.x) / 2.0, y: (s2.y + s3.y) / 2.0 )
        
         let l1 = (dx1 * dx1 + dy1 * dy1).squareRoot()
         let l2 = (dx2 * dx2 + dy2 * dy2).squareRoot()
         
         let dxm = (m1.x - m2.x)
         let dym = (m1.y - m2.y)
         
         let k = l2 / (l1 + l2)
         let cm = CGPoint( x: m2.x + dxm * k, y: m2.y + dym * k )
         
         let tx = s2.x - cm.x
         let ty = s2.y - cm.y
        
         let pt1 = CGPoint(x: m1.x + tx, y: m1.y + ty)
         let pt2 = CGPoint(x: m2.x + tx, y: m2.y + ty)
        
        return ["c1":pt1, "c2":pt2]//NSArray(objects: pt1,pt2)
  
    }
    
    func reset() {
        
        path.removeAllPoints()
        pointsArr.removeAll()
        signPathArr.removeAll()
        
    }
        
}
