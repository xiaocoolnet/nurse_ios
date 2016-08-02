//
//  HSWebViewDetailController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSWebViewDetailController: UIViewController {
    
    @IBOutlet weak var netView:UIWebView!
    var url:NSURL?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
        if url != nil {
            netView.loadRequest(NSURLRequest(URL: url!))
            netView.scalesPageToFit = true
        }
    }

}
