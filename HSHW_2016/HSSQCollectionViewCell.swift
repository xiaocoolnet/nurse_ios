//
//  HSSQCollectionViewCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSSQCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var webView:UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let request = NSURLRequest(URL: NSURL(string: "http://nurse.xiaocool.net/index.php?g=portal&m=article&a=index&id=25")!)
        webView.loadRequest(request)
        webView.scalesPageToFit = true
        webView.userInteractionEnabled = true
        webView.scrollView.bounces = false
    }

}
