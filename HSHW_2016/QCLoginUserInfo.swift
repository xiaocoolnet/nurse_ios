//
//  QCLoginUserInfo.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class QCLoginUserInfo {
    
    var phoneNumber = ""
    var devicestate = ""
    var usertype = ""// 1 个人 2 企业
    var userid = ""
    var userName = ""
    var avatar = ""
    var city = ""
    var address = ""
    var qqNumber = ""
    var weixinNumber = ""
    var time = ""
    var level = "1"
    var attentionCount = "0"
    var fansCount = "0"
    var money = "0"
    var sex = ""
    var realName = ""
    var birthday = ""
    var email = ""
    var school = ""
    var major = ""
    var education = ""
    var score = "0"
    var all_information = ""
    var isCircleManager = ""
    
    
    static let currentInfo = QCLoginUserInfo()
    fileprivate init() {
        
    }
    
    func initUserInfo() {
        QCLoginUserInfo.currentInfo.phoneNumber = ""
        QCLoginUserInfo.currentInfo.devicestate = ""
        QCLoginUserInfo.currentInfo.usertype = ""// 1 个人 2 企业
        QCLoginUserInfo.currentInfo.userid = ""
        QCLoginUserInfo.currentInfo.userName = ""
        QCLoginUserInfo.currentInfo.avatar = ""
        QCLoginUserInfo.currentInfo.city = ""
        QCLoginUserInfo.currentInfo.address = ""
        QCLoginUserInfo.currentInfo.qqNumber = ""
        QCLoginUserInfo.currentInfo.weixinNumber = ""
        QCLoginUserInfo.currentInfo.time = ""
        QCLoginUserInfo.currentInfo.level = "1"
        QCLoginUserInfo.currentInfo.attentionCount = "0"
        QCLoginUserInfo.currentInfo.fansCount = "0"
        QCLoginUserInfo.currentInfo.money = "0"
        QCLoginUserInfo.currentInfo.sex = ""
        QCLoginUserInfo.currentInfo.realName = ""
        QCLoginUserInfo.currentInfo.birthday = ""
        QCLoginUserInfo.currentInfo.email = ""
        QCLoginUserInfo.currentInfo.school = ""
        QCLoginUserInfo.currentInfo.major = ""
        QCLoginUserInfo.currentInfo.education = ""
        QCLoginUserInfo.currentInfo.score = "0"
        QCLoginUserInfo.currentInfo.all_information = ""
        QCLoginUserInfo.currentInfo.isCircleManager = ""
    }
}
