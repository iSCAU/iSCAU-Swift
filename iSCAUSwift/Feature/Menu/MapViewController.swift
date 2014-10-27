//
//  MapViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/2/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var bgScrollView: UIScrollView!
    var imgMap: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgScrollView.height = ScreenHeight - 64
        let map = UIImage(named: "map.png")
        if let mapSize = map?.size {
            let widthScale: CGFloat = bgScrollView.width / mapSize.width
            let heightScale = bgScrollView.height / mapSize.height
            let minScale = widthScale < heightScale ? widthScale : heightScale
            let maxScale = UIScreen.mainScreen().scale
            
            bgScrollView.maximumZoomScale = 1 / minScale * 4
            bgScrollView.minimumZoomScale = 1
            bgScrollView.zoomScale = 1
            
            var imgFrame = CGRectZero
            if widthScale < heightScale {
                imgFrame = CGRectMake(0, 0, bgScrollView.width, mapSize.height * widthScale)
            } else {
                imgFrame = CGRectMake(0, 0, mapSize.width * heightScale, bgScrollView.height)
            }
            
            imgMap = UIImageView(frame: imgFrame)
            imgMap?.center = bgScrollView.center
            imgMap?.image = map
            bgScrollView.addSubview(imgMap!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ScrollView delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgMap
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        let offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) / 2 : 0.0
        let offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) / 2 : 0.0
        imgMap?.center = CGPointMake(scrollView.contentSize.width / 2 + offsetX, scrollView.contentSize.height / 2 + offsetY)
    }
    
    // MARK: - Gesture delegate
    @IBAction func handleDoubleTap(sender: AnyObject) {
        let tap = sender as UITapGestureRecognizer

        let touchPoint = tap.locationInView(imgMap)
        if bgScrollView.zoomScale == bgScrollView.maximumZoomScale {
            bgScrollView.setZoomScale(bgScrollView.minimumZoomScale, animated: true)
        } else {
            bgScrollView.zoomToRect(zoomRect(bgScrollView.maximumZoomScale, center: touchPoint), animated: true)
        }
    }
    
    private func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        let width = bgScrollView.width / scale
        let height = bgScrollView.height / scale
        return CGRectMake(center.x - width / 2, center.y - height / 2, width, height)
    }
}
