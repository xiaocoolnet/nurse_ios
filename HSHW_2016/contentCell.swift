//
//  contentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class contentCell: UITableViewCell{

    @IBOutlet weak var contentWebView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView .sizeToFit()
        for subView in contentWebView!.subviews
        {
            let v = subView
            if v.isKindOfClass(UIScrollView.self) == true
            {
                (v as! UIScrollView).scrollEnabled = false
                (v as! UIScrollView).alwaysBounceVertical = false
                
                (v as! UIScrollView).showsHorizontalScrollIndicator = false
                (v as! UIScrollView).showsVerticalScrollIndicator = false
            }
        }
    }
    func loadRequestUrl(requestUrl:NSURL){
//        contentWebView.scalesPageToFit = true
        contentWebView.loadRequest(NSURLRequest(URL: requestUrl))
    }
 
//
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
