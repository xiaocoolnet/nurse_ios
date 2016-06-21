//
//  HSWorkPlaceController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSWorkPlaceController: UIViewController {
    @IBOutlet weak var webView:UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL:NSURL(string: "http://nurse.xiaocool.net/index.php?g=portal&m=article&a=index&id=27")!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        webView.scrollView.bounces = false
        // Do any additional setup after loading the view.
    }

}
