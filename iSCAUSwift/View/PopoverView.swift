//
//  PopoverView.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/12/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

@objc protocol PopoverViewDelegate {
    optional func popoverView(popoverView: PopoverView, didSelectItemAtIndex index: Int)
    optional func popoverViewDidDismiss(popoverView: PopoverView)
}

class PopoverView: UIView {
    let kArrowHeight: CGFloat = 12.0
    let kBoxPadding: CGFloat = 0.0
    let kCPOffset: CGFloat = 1.8
    let kBoxRadius: CGFloat = 4.0
    let kArrowCurvature: CGFloat = 6.0
    let kArrowHorizontalPadding: CGFloat = 5.0
    let kShadowAlpha: CGFloat = 0.4
    let kBoxAlpha: CGFloat = 1
    let kTopMargin: CGFloat = 50.0
    let kHorizontalMargin: CGFloat = 10.0
    let kShowDividerBetweenViews = true
    let kDividerColor: UIColor = UIColor(red: 0.329, green: 0.341, blue: 0.3533, alpha: 0.15)
    let kGradientBottomColor: UIColor
    let kGradientTopColor: UIColor
    let kGradientTitleBottomColor: UIColor
    let kGradientTitleTopColor: UIColor
    let kTitleFont: UIFont = UIFont(name: "HelveticaNeue", size: 22.0)!
    let kTitleColor: UIColor = UIColor(red: 0.329, green: 0.341, blue: 0.353, alpha: 1)
    
    var boxFrame: CGRect = CGRectZero
    var contentSize: CGSize = CGSizeZero
    var arrowPoint: CGPoint = CGPointZero
    var above: Bool = false
    var delegate: PopoverViewDelegate? = nil
    var subviewsArray: NSArray? = nil
    var dividerRects: NSMutableArray?
    var titleView: UIView? = nil
    var contentView: UIView? = nil
    var activityIndicator: UIActivityIndicatorView? = nil
    var showDividerRects: Bool = true
    
    override init(frame: CGRect) {
        kGradientBottomColor = UIColor(white: 0.98, alpha: kBoxAlpha)
        kGradientTopColor = UIColor(white: 1.0, alpha: kBoxAlpha)
        kGradientTitleBottomColor = UIColor(white: 0.93, alpha: kBoxAlpha)
        kGradientTitleTopColor = UIColor(white: 1.0, alpha: kBoxAlpha)
        dividerRects = NSMutableArray()
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func showPopoverAtPoint(point: CGPoint, inView view: UIView, withViewArray viewArray: Array<UIView>, delegate: PopoverViewDelegate?) {
        var popoverView = PopoverView(frame: CGRectZero)
        popoverView.showAtPoint(point, inView: view, withViewArray: viewArray)
        popoverView.delegate = delegate
    }
    
    func showAtPoint(point: CGPoint, inView view: UIView, withViewArray viewArray:Array<UIView>) {
        var container = UIView(frame: CGRectZero)
        
        var totalHeight: CGFloat = 0.0
        var totalWidth: CGFloat = 0.0
        var padding: CGFloat = 0.0
        var i: Int = 0
        
        for view: UIView in viewArray {
            view.frame = CGRectMake(0.0, totalHeight, view.frame.size.width, view.frame.size.height)
            
            padding = (i == viewArray.count - 1) ? 0.0 : kBoxPadding
            
            totalHeight += view.frame.size.height + padding
            
            if (view.frame.size.width > totalWidth) {
                totalWidth = view.frame.size.width
            }
            
            container.addSubview(view)
            
            ++i
        }
        
        if kShowDividerBetweenViews {
            dividerRects = NSMutableArray(capacity: viewArray.count - 1)
        }
        
        container.frame = CGRectMake(0, 0, totalWidth, totalHeight)
        
        i = 0
        
        for view: UIView in viewArray {
            if let lable = view as? UILabel {
                lable.frame = CGRectMake(lable.frame.origin.x, lable.frame.origin.y, totalWidth, lable.frame.size.height)
            }
            
            if kShowDividerBetweenViews && i != viewArray.count - 1 {
                let dividerRect = CGRectMake(view.frame.origin.x, view.frame.origin.y + view.frame.size.height + kBoxPadding * 0.5, view.frame.size.width, 0.5)
                
                dividerRects!.addObject(NSValue(CGRect: dividerRect))
            }
            
            //Only add padding below the view if it's not the last item
            padding = (i == viewArray.count - 1) ? 0.0 : kBoxPadding

            totalHeight += view.frame.size.height + padding
            
            ++i
        }
        
        subviewsArray = viewArray
        
        showAtPoint(point, inView: view, withContentView: container)
    }
    
    func showAtPoint(point: CGPoint, inView view: UIView, withContentView cView: UIView) {
        contentView = cView
        
        var keyWindow = UIApplication.sharedApplication().keyWindow
        keyWindow = UIApplication.sharedApplication().windows[0] as UIWindow

        let topView = keyWindow?.subviews[0] as UIView

        let topPoint = topView.convertPoint(point, fromView: view)
        
        arrowPoint = topPoint
        
        var topViewBounds = topView.bounds
        
        var contentHeight = contentView?.frame.size.height
        var contentWidth = contentView?.frame.size.width
        
        var padding = kBoxPadding
        
        var boxHeight = contentHeight! + 2 * padding
        var boxWidth = contentWidth! + 2 * padding
        
        var xOrigin: CGFloat = 0.0
       
        if arrowPoint.x + kArrowHeight > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding {
            arrowPoint.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - kArrowHeight
        } else if arrowPoint.x - kArrowHeight < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding {  //Too far to the left
            arrowPoint.x = kHorizontalMargin + kArrowHeight + kBoxRadius + kArrowHorizontalPadding
        }
        
        xOrigin = arrowPoint.x - boxWidth * 0.5
        
        if xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin {
            xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin
        } else if xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin {
            xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth
        }
        
        var arrowHeight = kArrowHeight
        
        var topPadding = kTopMargin
        
        above = true
        
        if topPoint.y - contentHeight! - arrowHeight - topPadding < CGRectGetMinY(topViewBounds) {
            //Position below because it won't fit above.
            above = false
            
            boxFrame = CGRectMake(xOrigin, arrowPoint.y + arrowHeight, boxWidth, boxHeight)
        } else {
            //Position above.
            above = true
            
            boxFrame = CGRectMake(xOrigin, arrowPoint.y - arrowHeight - boxHeight, boxWidth, boxHeight)
        }
        
        var contentFrame = CGRectMake(boxFrame.origin.x + padding, boxFrame.origin.y + padding, contentWidth!, contentHeight!)
        contentView!.frame = contentFrame
        self.addSubview(contentView!)
        
        //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
        //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
        //implicitly set the frame for the view, which we do not want.
        self.layer.anchorPoint = CGPointMake(arrowPoint.x / topViewBounds.size.width, arrowPoint.y / topViewBounds.size.height)
        self.frame = topViewBounds
        self.setNeedsDisplay()
        
        topView.addSubview(self)
        
        //Add a tap gesture recognizer to the large invisible view (self), which will detect taps anywhere on the screen.
        var tap = UITapGestureRecognizer(target: self, action: "tapped:")
        self.addGestureRecognizer(tap)
        
        self.userInteractionEnabled = true
        
        //Make the view small and transparent before animation
        self.alpha = 0.0
        self.transform = CGAffineTransformMakeScale(0.1, 0.1)
        
        //animate into full size
        //First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
        //This two-stage animation creates a little "pop" on open.
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.alpha = 1.0
            self.transform = CGAffineTransformMakeScale(1.05, 1.05)
            }, completion: {
                (finished: Bool) in
                UIView.animateWithDuration(0.08, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.transform = CGAffineTransformIdentity
                    }, completion: nil)
            })
    }
    
    func tapped(tap: UITapGestureRecognizer) {
        var point = tap.locationInView(contentView)
        
        var found = false
        
        for var i = 0; i < subviewsArray!.count && !found; ++i {
            var view = subviewsArray![i] as UIView
            
            if CGRectContainsPoint(view.frame, point) {
                found = true
                
                if let label = view as? UILabel {
                    label.backgroundColor = UIColor(red: 0.329, green: 0.341, blue: 0.353, alpha: 1)
                    label.textColor = UIColor.whiteColor()
                }
                
                delegate?.popoverView?(self, didSelectItemAtIndex: i)
                
                break
            }
        }
        
        if !found && CGRectContainsPoint(contentView!.bounds, point) {
            found = true
        }
        
        if !found {
            self.dismiss()
        }
    }
    
    func dismiss() {
        UIView.animateWithDuration(0.3, animations: {
            self.alpha = 0.1
            self.transform = CGAffineTransformMakeScale(0.1, 0.1)
            }, completion: {
                (finished: Bool) in
                self.removeFromSuperview()
                self.delegate?.popoverViewDidDismiss?(self)
            })
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        // Build the popover path
        var frame = boxFrame
        
        var xMin = CGRectGetMinX(frame)
        var yMin = CGRectGetMinY(frame)
        var xMax = CGRectGetMaxX(frame)
        var yMax = CGRectGetMaxY(frame)
        
        var radius = kBoxRadius         //Radius of the curvature.
        var cpOffset = kCPOffset        //Control Point Offset.  Modifies how "curved" the corners are.
        
        /*
        LT2            RT1
        LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
        |               |
        |    popover    |
        |               |
        LB2⌞_______________⌟RB1
        LB1           RB2
        
        Traverse rectangle in clockwise order, starting at LT1
        L = Left
        R = Right
        T = Top
        B = Bottom
        1,2 = order of traversal for any given corner
        
        */
        
        var popoverPath = UIBezierPath()
        popoverPath.moveToPoint(CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius))       //LT1
        popoverPath.addCurveToPoint(CGPointMake(xMin + radius, yMin),
            controlPoint1: CGPointMake(xMin, yMin + radius - cpOffset),
            controlPoint2: CGPointMake(xMin + radius - cpOffset, yMin))     //LT2
        
        //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
        //In this case, the arrow is located between LT2 and RT1
        if !above {
            popoverPath.addLineToPoint(CGPointMake(arrowPoint.x - kArrowHeight, yMin))      //left side
            popoverPath.addCurveToPoint(arrowPoint,
                controlPoint1: CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin),
                controlPoint2: arrowPoint)      //actual arrow point
            popoverPath.addCurveToPoint(CGPointMake(arrowPoint.x + kArrowHeight, yMin),
                controlPoint1: arrowPoint,
                controlPoint2: CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin))    //right side
        }

        popoverPath.addLineToPoint(CGPointMake(xMax - radius, yMin))    //RT1
        popoverPath.addCurveToPoint(CGPointMake(xMax, yMin + radius),
            controlPoint1: CGPointMake(xMax - radius + cpOffset, yMin),
            controlPoint2: CGPointMake(xMax, yMin + radius - cpOffset))    //RT2
        

        popoverPath.addLineToPoint(CGPointMake(xMax, yMax - radius))    //RB1
        popoverPath.addCurveToPoint(CGPointMake(xMax - radius, yMax),
            controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset),
            controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax))  //RB2
        
        if above {
            popoverPath.addLineToPoint(CGPointMake(arrowPoint.x + kArrowHeight, yMax))  //right side
            popoverPath.addCurveToPoint(arrowPoint,
                controlPoint1: CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMax),
                controlPoint2: arrowPoint)  //arrow point
            popoverPath.addCurveToPoint(CGPointMake(arrowPoint.x - kArrowHeight, yMax),
                controlPoint1: arrowPoint,
                controlPoint2: CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMax))
        }
        
        popoverPath.addLineToPoint(CGPointMake(xMin + radius, yMax)) //LB1
        popoverPath.addCurveToPoint(CGPointMake(xMin, yMax - radius),
            controlPoint1: CGPointMake(xMin + radius - cpOffset, yMax),
            controlPoint2: CGPointMake(xMin, yMax - radius + cpOffset)) //LB2
        popoverPath.closePath()
        
        //// General Declarations
        var colorSpace = CGColorSpaceCreateDeviceRGB()
        var context = UIGraphicsGetCurrentContext()
        
        //// Shadow Declarations
        var shadow = UIColor(white: 0.0, alpha: kShadowAlpha)
        var shadowOffset = CGSizeMake(0, 1)
        var shadowBlurRadius: CGFloat = 10.0
        
        //// Gradient Declarations
        let gradientColors = [ kGradientTopColor, kGradientBottomColor ].map {(color: UIColor!) -> AnyObject! in
            return color.CGColor as AnyObject!
            } as NSArray
        var gradient = CGGradientCreateWithColors(colorSpace, gradientColors, [0.0, 1.0])
        
        //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
        var bottomOffset = above ? kArrowHeight : 0.0
        var topOffset = !above ? kArrowHeight : 0.0
        
        //Draw the actual gradient and shadow.
        CGContextSaveGState(context)
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor)
        CGContextBeginTransparencyLayer(context, nil)
        popoverPath.addClip()
        CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0)
        CGContextEndTransparencyLayer(context)
        CGContextRestoreGState(context)
        
        var titleBGHeight: CGFloat = -1.0
        if (titleView? != nil) {
            titleBGHeight = kBoxPadding * 2.0 + titleView!.frame.size.height
        }
        
        if titleBGHeight > 0.0 {
            var startingPoint = CGPointMake(xMin, yMin + titleBGHeight)
            var endingPoint = CGPointMake(xMax, yMin + titleBGHeight)
            
            var titleBGPath = UIBezierPath()
            titleBGPath.moveToPoint(startingPoint)
            titleBGPath.addLineToPoint(CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius))    //LT1
            titleBGPath.addCurveToPoint(CGPointMake(xMin + radius, yMin), controlPoint1: CGPointMake(xMin, yMin + radius - cpOffset), controlPoint2: CGPointMake(xMin + radius - cpOffset, yMin))   //LT2
            
            //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
            //In this case, the arrow is located between LT2 and RT1
            if !above {
                titleBGPath.addLineToPoint(CGPointMake(arrowPoint.x - kArrowHeight, yMin))  //left side
                titleBGPath.addCurveToPoint(arrowPoint,
                    controlPoint1: CGPointMake(arrowPoint.x - kArrowHeight + kArrowCurvature, yMin),
                    controlPoint2: arrowPoint)  //actual arrow point
                titleBGPath.addCurveToPoint(CGPointMake(arrowPoint.x + kArrowHeight, yMin),
                    controlPoint1: arrowPoint,
                    controlPoint2: CGPointMake(arrowPoint.x + kArrowHeight - kArrowCurvature, yMin))    //right side
            }
            
            titleBGPath.addLineToPoint(CGPointMake(xMax - radius, yMin))    //RT1
            titleBGPath.addCurveToPoint(CGPointMake(xMax, yMin + radius), controlPoint1: CGPointMake(xMax - radius + cpOffset, yMin), controlPoint2: CGPointMake(xMax, yMin + radius - cpOffset))   //RT2
            titleBGPath.addLineToPoint(endingPoint)
            titleBGPath.addLineToPoint(startingPoint)
            titleBGPath.closePath()
            
            //// General Declarations
            var colorSpace = CGColorSpaceCreateDeviceRGB()
            var context = UIGraphicsGetCurrentContext()
            
            //// Gradient Declarations
            var gradientColors = [kGradientTitleTopColor.CGColor, kGradientTitleBottomColor.CGColor] as CFArrayRef
//            var gradientLocations = [ CGFloat(0.0), CGFloat(1.0) ]
            var gradient = CGGradientCreateWithColors(colorSpace, gradientColors, [0.0, 1.0])
            
            //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
            var topOffset: CGFloat = !above ? kArrowHeight : 0.0
            //Draw the actual gradient and shadow.
            CGContextSaveGState(context)
            CGContextBeginTransparencyLayer(context, nil)
            titleBGPath.addClip()
            CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) + titleBGHeight), 0)
            CGContextEndTransparencyLayer(context)
            CGContextRestoreGState(context)
            
            var dividerLine = UIBezierPath(rect: CGRectMake(startingPoint.x, startingPoint.y, (endingPoint.x - startingPoint.x), 0.5))
            UIColor(red: 0.741, green: 0.741, blue: 0.741, alpha: 0.5).setFill()
            dividerLine.fill()
        }
        
        if kShowDividerBetweenViews && showDividerRects {
            if dividerRects?.count > 0 {
                for a: AnyObject in dividerRects! {
                    var r = (a as NSValue).CGRectValue()
                    r.origin.x += contentView!.frame.origin.x
                    r.origin.y += contentView!.frame.origin.y
                    
                    var dividerPath = UIBezierPath(rect: r)
                    kDividerColor.setFill()
                    dividerPath.fill()
                }
            }
        }
    }
}
