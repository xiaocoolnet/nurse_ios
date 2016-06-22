//
//  QCLoginUserInfo.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class QCLoginUserInfo {
    
    var phoneNumber:String = ""
    var devicestate:String = ""
    var usertype:String = ""
    var userid:String = ""
    var userName:String = ""
    var avatar:String = ""
    var city:String = ""
    var qqNumber:String = ""
    var weixinNumber:String = ""
    
    static let currentInfo = QCLoginUserInfo()
    private init() {
        
    }
}
