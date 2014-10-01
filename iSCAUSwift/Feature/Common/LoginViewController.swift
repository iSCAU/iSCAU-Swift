//
//  LoginViewController.swift
//  iSCAUSwift
//
//  Created by Alvin on 6/5/14.
//  Copyright (c) 2014 Alvin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var txtStuNum: UITextField!
    @IBOutlet weak var txtStuPwd: UITextField!
    @IBOutlet weak var txtLibPwd: UITextField!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // Custom initialization
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let btnBack = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("back"))
        navigationItem.leftBarButtonItem = btnBack
        
        let btnSave = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("save"))
        navigationItem.rightBarButtonItem = btnSave
        
        txtStuNum.text = Utils.stuNum
        txtStuPwd.text = Utils.stuPwd
        txtLibPwd.text = Utils.libPwd
        
        txtStuNum.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tryExperienceAccount(sender: AnyObject) {
        txtStuNum.text = "ilovescau"
        txtStuPwd.text = "1"
        txtLibPwd.text = "1"
    }
    
    func save() {
        Utils.stuNum = txtStuNum.text
        Utils.stuPwd = txtStuPwd.text
        Utils.libPwd = txtLibPwd.text
        
        back()
    }
    
    func back() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
