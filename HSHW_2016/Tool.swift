//
//  Tool.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
import UIKit

let WIDTH = UIScreen.mainScreen().bounds.size.width
let HEIGHT = UIScreen.mainScreen().bounds.size.height
let COLOR = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 1.0)
let GREY = UIColor(red: 158/255.0, green: 158/255.0, blue: 158/255.0, alpha: 1.0)
let RGREY = UIColor(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1.0)
let PARK_URL_Header = "http://nurse.xiaocool.net/index.php?g=apps&m=index&a="
let NewsInfo_Header = "http://nurse.xiaocool.net/index.php?g=portal&m=article&a=index&id="


func calculateHeight(string:String,size:CGFloat,width:  CGFloat) -> CGFloat {
    let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
    //let screenBounds:CGRect = UIScreen.mainScreen().bounds
    let boundingRect = String(string).boundingRectWithSize(CGSizeMake(width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(size)], context: nil)
    print(boundingRect.height)
    return boundingRect.height
}