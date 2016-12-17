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
            if v.isKind(of: UIScrollView.self) == true
            {
                (v as! UIScrollView).isScrollEnabled = false
                (v as! UIScrollView).alwaysBounceVertical = false
                
                (v as! UIScrollView).showsHorizontalScrollIndicator = false
                (v as! UIScrollView).showsVerticalScrollIndicator = false
            }
        }
    }
    func loadRequestUrl(_ requestUrl:URL){
//        contentWebView.scalesPageToFit = true
        contentWebView.loadRequest(URLRequest(url: requestUrl))
    }
 
//
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
