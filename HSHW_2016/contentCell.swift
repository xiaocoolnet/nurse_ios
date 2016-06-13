//
//  contentCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

//protocol cellHeightProtocol:NSObjectProtocol {
//    
//    func changeCellHeight(height:CGFloat)
//    
//}
protocol ChangeCellHeightDelegate:NSObjectProtocol{
    //回调方法
   func changeCellHeight(height:CGFloat)
}

class contentCell: UITableViewCell,UIWebViewDelegate{

    @IBOutlet weak var contentWebView: UIWebView!
    
    var delegate:ChangeCellHeightDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        //contentView.alwaysBounceVertical = false
        contentView .sizeToFit()
        contentWebView.delegate = self
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
        
        // Initialization code
    }
 

    
    func webViewDidFinishLoad(webView: UIWebView) {

        
        contentWebView.frame.size.height = contentWebView.scrollView.contentSize.height
        NSUserDefaults.standardUserDefaults().setObject(contentWebView.frame.size.height, forKey: "height")

        print(contentWebView.frame.size.height)
            //contentWebView.height = contentWebView.scrollView.contentSize.height;
        
        
    }
//
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
