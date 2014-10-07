//
//  ActivityDetailViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 10/7/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class ActivityDetailViewController: UIViewController {

    @IBOutlet weak var webContent: UIWebView!
    var content = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webContent.loadHTMLString(content, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
