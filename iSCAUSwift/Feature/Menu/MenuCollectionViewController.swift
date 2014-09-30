//
//  MenuCollectionViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 9/30/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

let menuItemIdentifier = "MenuItemIdentifier"
let menuHeaderIdentifier = "MenuHeaderIdentifier"
let kMenuNameKey = "kMenuNameKey"
let kMenuIconNameKey = "kMenuIconNameKey"

let kMenuHeaderLabelTag = 1000

class MenuCollectionViewController: UICollectionViewController {
    
    let menuHeader = [ "教务系统", "图书馆", "百宝箱", "其他" ]
    let menus =
    [
        [
            [kMenuNameKey : "查询成绩", kMenuIconNameKey : "1.png"],
            [kMenuNameKey : "空余课室", kMenuIconNameKey : "2.png"],
            [kMenuNameKey : "考试安排", kMenuIconNameKey : "3.png"],
            [kMenuNameKey : "选课情况", kMenuIconNameKey : "4.png"],
        ],
        [
            [kMenuNameKey : "搜索图书", kMenuIconNameKey : "1.png"],
            [kMenuNameKey : "当前借阅", kMenuIconNameKey : "2.png"],
            [kMenuNameKey : "历史借阅", kMenuIconNameKey : "3.png"],
        ],
        [
            [kMenuNameKey : "地图", kMenuIconNameKey : "1.png"],
            [kMenuNameKey : "校历", kMenuIconNameKey : "2.png"],
            [kMenuNameKey : "常用电话", kMenuIconNameKey : "3.png"],
            [kMenuNameKey : "英语角", kMenuIconNameKey : "4.png"],
        ],
        [
            [kMenuNameKey : "设置", kMenuIconNameKey : "1.png"],
            [kMenuNameKey : "意见反馈", kMenuIconNameKey : "2.png"],
        ],
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 4
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 3
        case 2:
            return 4
        case 3:
            return 2
        default:
            return 0
        }
    }

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(menuItemIdentifier, forIndexPath: indexPath) as MenuItemCollectionViewCell

        if let menuName = menus[indexPath.section][indexPath.item][kMenuNameKey] {
            cell.labTitle!.text = menuName
        }
        if let menuIconName = menus[indexPath.section][indexPath.item][kMenuIconNameKey] {
            cell.imgIcon!.image = UIImage(named: menuIconName)
        }
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: menuHeaderIdentifier, forIndexPath: indexPath) as UICollectionReusableView
        
        if let labTitle = header.viewWithTag(kMenuHeaderLabelTag) as? UILabel {
            labTitle.text = menuHeader[indexPath.section]
        }
        return header
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
            case (3, 0):
                self.performSegueWithIdentifier("PushSettingsTableViewController", sender: nil)
            default:
                return
        }
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    func collectionView(collectionView: UICollectionView!, shouldHighlightItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    func collectionView(collectionView: UICollectionView!, shouldSelectItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    func collectionView(collectionView: UICollectionView!, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, canPerformAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) -> Bool {
        return false
    }

    func collectionView(collectionView: UICollectionView!, performAction action: String!, forItemAtIndexPath indexPath: NSIndexPath!, withSender sender: AnyObject!) {
    
    }
    */

}
