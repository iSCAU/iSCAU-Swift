//
//  AddressUpdateView.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/4/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

let kTitleOffset: CGFloat = 15.0
let kCommonMarginX: CGFloat = 10.0
let kCommonPadding: CGFloat = 20.0
let kViewWidth: CGFloat = ScreenWidth - 20.0 * 2

class AddressUpdateView: UIView {

    var txtAddress: UITextView?
    var btnCancle: UIButton?
    var btnConfirm: UIButton?
    var backgroundTxtAddress: UIView?
    lazy var background: UIControl? = {
        let bg = UIControl(frame: UIScreen.mainScreen().bounds)
        bg.backgroundColor = UIColor.blackColor()
        bg.alpha = 0
        bg.addTarget(self, action: Selector("dismiss"), forControlEvents: .TouchUpInside)
        return bg
    }()
    lazy var labNotice: UILabel? = {
        let notice = UILabel()
        notice.textColor = UIColor.lightGrayColor()
        notice.backgroundColor = UIColor.clearColor()
        notice.font = UIFont.systemFontOfSize(14)
        notice.text = "请填入宿舍地址"
        notice.sizeToFit()
        notice.left = kCommonMarginX
        
        return notice
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        layer.cornerRadius = 5.0
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5.0
        backgroundColor = UIColor(r: 236, g: 240, b: 241, a: 1)
        
        addSubview(labNotice!)
        labNotice!.top = 0
        labNotice!.height = kCommonMarginX + 20
        
        backgroundTxtAddress = UIView(frame: CGRectMake(kCommonMarginX, kCommonMarginX + 20, kViewWidth - kCommonMarginX * 2, 100))
        backgroundTxtAddress?.layer.cornerRadius = 3
        backgroundTxtAddress?.backgroundColor = UIColor.whiteColor()
        addSubview(backgroundTxtAddress!)
        
        txtAddress = UITextView(frame: CGRectMake(backgroundTxtAddress!.left + kCommonMarginX / 2,  backgroundTxtAddress!.top + kCommonMarginX / 2, backgroundTxtAddress!.width - kCommonMarginX, backgroundTxtAddress!.height - kCommonMarginX))
        txtAddress?.font = UIFont.systemFontOfSize(17)
        txtAddress?.backgroundColor = UIColor.clearColor()
        addSubview(txtAddress!)

        let horizontalBorder = UIImageView(image: UIImage(named: "sep.png"))
        horizontalBorder.frame = CGRectMake(0, backgroundTxtAddress!.bottom + kCommonMarginX, kViewWidth, 1)
        self.addSubview(horizontalBorder)
        
        let verticalBorder = UIImageView(image: UIImage(color: UIColor(r: 198, g: 202, b: 202, a: 0.5)))
        verticalBorder.frame = CGRectMake(kViewWidth / 2, backgroundTxtAddress!.bottom + kCommonMarginX, 1, 44)
        addSubview(verticalBorder)
        
        btnCancle = UIButton.buttonWithType(.Custom) as? UIButton
        btnCancle?.frame = CGRectMake(0, backgroundTxtAddress!.bottom + kCommonMarginX, kViewWidth / 2, 44)
        btnCancle?.setTitle("取消", forState: .Normal)
        btnCancle?.setTitleColor(UIColor(r: 195, g: 0, b: 19, a: 1), forState: .Normal)
        btnCancle?.setBackgroundImage(UIImage(color: UIColor(white: 0, alpha: 0.1)), forState:.Highlighted)
        btnCancle?.addTarget(self, action: Selector("dismiss"), forControlEvents:.TouchUpInside)
        addSubview(btnCancle!)
        
        var maskPath = UIBezierPath(roundedRect: btnCancle!.bounds, byRoundingCorners: UIRectCorner.BottomLeft, cornerRadii: CGSizeMake(5.0, 5.0))
        var maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.CGPath
        btnCancle!.layer.mask = maskLayer
        
        btnConfirm = UIButton.buttonWithType(.Custom) as? UIButton
        btnConfirm?.frame = CGRectMake(kViewWidth / 2, backgroundTxtAddress!.bottom + kCommonMarginX, kViewWidth / 2, 44)
        btnConfirm?.setTitleColor(UIColor(r: 195, g: 0, b: 19, a: 1), forState: .Normal)
        btnConfirm?.setTitle("确认", forState: .Normal)
        btnConfirm?.setBackgroundImage(UIImage(color: UIColor(white: 0, alpha: 0.1)), forState:.Highlighted)
        btnConfirm?.addTarget(self, action: Selector("confirm"), forControlEvents:.TouchUpInside)
        addSubview(btnConfirm!)
        
        maskPath = UIBezierPath(roundedRect: btnCancle!.bounds, byRoundingCorners: UIRectCorner.BottomRight, cornerRadii: CGSizeMake(5.0, 5.0))
        maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.CGPath
        btnConfirm!.layer.mask = maskLayer
        
        frame = CGRectMake((ScreenWidth - kViewWidth) / 2, -btnCancle!.bottom, kViewWidth, btnCancle!.bottom)
    }
    
    func show() {
        let topVC = rootViewController()
        topVC.view.addSubview(background!)
        
        let afterFrame = CGRectMake((ScreenWidth - kViewWidth) / 2, (ScreenHeight - btnCancle!.bottom - 270) / 2, kViewWidth, btnCancle!.bottom)
        
        UIView.animateWithDuration(0.27, delay: 0, options: .CurveEaseOut, animations: {
            self.frame = afterFrame
            self.background!.alpha = 0.8
        }, completion: { finished in
            if finished {
                self.txtAddress!.becomeFirstResponder()
            }
        })
        
        topVC.view.addSubview(self)
    }
    
    func dismiss() {
        txtAddress!.resignFirstResponder()
        let topVC = rootViewController()
        topVC.view.addSubview(background!)
        
        let afterFrame = CGRectMake((ScreenWidth - kViewWidth) / 2, topVC.view.bottom, kViewWidth, btnCancle!.bottom)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
            self.frame = afterFrame
            self.background!.alpha = 0
            }, completion: { finished in
                if finished {
                    self.background!.removeFromSuperview()
                    self.removeFromSuperview()
                }
        })
        topVC.view.addSubview(self)
    }
    
    func confirm() {
        if countElements(txtAddress!.text) == 0 {
            labNotice!.text = "请填入宿舍地址（不能为空）"
            labNotice!.sizeToFit()
            labNotice!.height = kCommonMarginX + 20
            return
        }
        
        Utils.dormitoryAddress = txtAddress!.text
        NSNotificationCenter.defaultCenter().postNotificationName(kReloadRestaurantTableNotification, object: nil)
        dismiss()
    }
    
    func rootViewController() -> UIViewController {
        var vc = UIApplication.sharedApplication().keyWindow!.rootViewController
        while vc?.presentedViewController != nil {
            vc = vc?.presentedViewController
        }
        return vc!
    }
    
}
