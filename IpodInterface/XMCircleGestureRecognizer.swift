//
//  XMCircleGestureRecognizer.swift
//  XMCircleGestureRecognizer
//
//  Created by Michael Teeuw on 20-06-14.
//  Copyright (c) 2014 Michael Teeuw. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

private let π = CGFloat(M_PI)

public extension CGFloat {
    var degrees:CGFloat {
        return self * 180 / π;
    }
    var radians:CGFloat {
        return self * π / 180;
    }
    var rad2deg:CGFloat {
        return self.degrees
    }
    var deg2rad:CGFloat {
        return self.radians
    }

}

public class XMCircleGestureRecognizer: UIGestureRecognizer {
    
    //MARK: Public Properties
    
    // midpoint for gesture recognizer
    public var midPoint = CGPointZero
    
    // minimal distance from midpoint
    public var innerRadius:CGFloat?
    
    // maximal distance to midpoint
    public var outerRadius:CGFloat?
    
    public var beforeView : UIView?
    
    // relative rotation for current gesture (in radians)
    public var rotation:CGFloat? {
        if let currentPoint = self.currentPoint {
            if let previousPoint = self.previousPoint {
                var rotation = angleBetween(currentPoint, andPointB: previousPoint)
                
                if (rotation > π) {
                    rotation -= π*2
                } else if (rotation < -π) {
                    rotation += π*2
                }
                
                return rotation
            }
        }
        
        return nil
    }
    
    // absolute angle for current gesture (in radians)
    public var angle:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.angleForPoint(nowPoint)
        }
    
        return nil
    }
    
    // distance from midpoint
    public var distance:CGFloat? {
        if let nowPoint = self.currentPoint {
            return self.distanceBetween(self.midPoint, andPointB: nowPoint)
        }
    
        return nil
    }
    
    // current touch postion (add by Huiyuan Ren)
    public var currentTouchPostion : CGPoint?{
        if let currPoint = self.currentPoint{
            return currPoint
        }
        return nil
    }
    
    //MARK: Private Properties
    
    // internal usage for calculations. (Please give us Access Modifiers, Apple!)
    private var currentPoint:CGPoint?
    private var previousPoint:CGPoint?
    
    //MARK: Public Methods
    
    // designated initializer
    public init(midPoint:CGPoint, innerRadius:CGFloat?, outerRadius:CGFloat?, target:AnyObject, action:Selector, view: UIView) {
        super.init(target: target, action: action)
        
        self.midPoint = midPoint
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.beforeView = view
    }
   
    // convinience initializer if innerRadius and OuterRadius are not necessary
    public convenience init(midPoint:CGPoint, target:AnyObject, action:Selector, view: UIView) {
        self.init(midPoint:midPoint, innerRadius:nil, outerRadius:nil, target:target, action:action, view: view)
    }
    
    
    //MARK: Private Methods
    
    private func distanceBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        let dx = Float(pointA.x - pointB.x)
        let dy = Float(pointA.y - pointB.y)
        return CGFloat(sqrtf(dx*dx + dy*dy))
    }
    
    private func angleForPoint(point:CGPoint) -> CGFloat {
        var angle = -atan2(point.x - midPoint.x, point.y - midPoint.y) + π/2

        if (angle < 0) {
            angle += π*2;
        }
        
        return angle
    }

    private func angleBetween(pointA:CGPoint, andPointB pointB:CGPoint) -> CGFloat {
        return angleForPoint(pointA) - angleForPoint(pointB)
    }
    
    //MARK: Subclassed Methods
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent)
    {
        
        let touch : UITouch! = touches.first
        currentPoint = touch.locationInView(self.beforeView)
        
        var newState:UIGestureRecognizerState = .Began
    
        if let innerRadius = self.innerRadius {
            if distance < innerRadius {
                newState = .Failed
            }
        }
        
        if let outerRadius = self.outerRadius {
            if distance > outerRadius {
                newState = .Failed
            }
        }
        
        state = newState

    }

    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent) {
        
        
        if state == .Failed {
            return
        }
        
        let touch : UITouch! = touches.first
        currentPoint = touch.locationInView(self.beforeView)
        previousPoint = touch.previousLocationInView(self.beforeView)
        
        state = .Changed
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent) {
        state = .Ended
        
        currentPoint = nil
        previousPoint = nil
    }
    
}
