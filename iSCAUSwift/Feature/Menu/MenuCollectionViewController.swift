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
            [kMenuNameKey : "查询成绩", kMenuIconNameKey : "9.png"],
            [kMenuNameKey : "空余课室", kMenuIconNameKey : "2.png"],
            [kMenuNameKey : "考试安排", kMenuIconNameKey : "4.png"],
            [kMenuNameKey : "选课情况", kMenuIconNameKey : "3.png"],
        ],
        [
            [kMenuNameKey : "搜索图书", kMenuIconNameKey : "6.png"],
            [kMenuNameKey : "当前借阅", kMenuIconNameKey : "13.png"],
            [kMenuNameKey : "历史借阅", kMenuIconNameKey : "1.png"],
        ],
        [
            [kMenuNameKey : "地图", kMenuIconNameKey : "8.png"],
            [kMenuNameKey : "校历", kMenuIconNameKey : "7.png"],
            [kMenuNameKey : "常用电话", kMenuIconNameKey : "10.png"],
            [kMenuNameKey : "英语角", kMenuIconNameKey : "5.png"],
        ],
        [
            [kMenuNameKey : "设置", kMenuIconNameKey : "settting.png"],
            [kMenuNameKey : "意见反馈", kMenuIconNameKey : "12.png"],
        ],
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // Edu
        case (0, 0):
            let marksVC = EduSysMarksViewController()
            marksVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(marksVC, animated: true)
        case (0, 1):
            let emptyClassroomVC = EduSysEmptyClassroomViewController()
            emptyClassroomVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(emptyClassroomVC, animated: true)
        case (0, 2):
            let examInfoVC = EduSysExamViewController()
            examInfoVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(examInfoVC, animated: true)
        case (0, 3):
            let pickedClassInfoVC = EduSysPickClassInfoViewController()
            pickedClassInfoVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(pickedClassInfoVC, animated: true)
        // Lib
        case (1, 0):
            let searchBooksVC = LibSearchBooksViewController()
            searchBooksVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(searchBooksVC, animated: true)
        case (1, 1):
            let borrowingVC = LibListNowViewController()
            borrowingVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(borrowingVC, animated: true)
        case (1, 2):
            let borrowedVC = LibListHistoryViewController()
            borrowedVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(borrowedVC, animated: true)
        // 地图
        case (2, 0):
            performSegueWithIdentifier("PushMapViewController", sender: nil)
        // 校历
        case (2, 1):
            let chvc = CalendarHomeViewController()
            chvc.calendartitle = "校历"
            chvc.setAirPlaneToDay(365, toDateforString: nil)
            chvc.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chvc, animated: true)
        case (2, 2):
            performSegueWithIdentifier("PushPhoneCallListViewController", sender: nil)
        case (2, 3):
            performSegueWithIdentifier("PushEnglishCornerViewController", sender: nil)
        // 设置
        case (3, 0):
            performSegueWithIdentifier("PushSettingsTableViewController", sender: nil)
        case (3, 1):
            UMFeedback.showFeedback(self, withAppkey: kUMengAppKey)
        default:
            return
        }
    }

}
