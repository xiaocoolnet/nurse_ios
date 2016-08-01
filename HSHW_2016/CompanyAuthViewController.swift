//
//  CompanyAuthViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import QuartzCore

class CompanyAuthViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var licenseBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    
        bgView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        bgView.layer.borderWidth = 1
        
        licenseBtn.layer.borderColor = UIColor.grayColor().CGColor
        licenseBtn.layer.borderWidth = 1
        
//        let dashPattern[] = {3.0, 2}
        
//        var content = UIGraphicsGetCurrentContext()
//        CGContext.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
