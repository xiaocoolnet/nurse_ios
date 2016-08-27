//
//  LoginUserInfoModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
//  得到数据
class LoginUserInfoModel: JSONJoy{
    //  请求状态
    var status:String?
    //  请求得到的数据
    var data:LoginUserInfo?
    //  错误
    var errorData:String?
    //  数据
    var datastring:String?
    
    init(){
    }
    //  初始化方法
    required init(_ decoder:JSONDecoder){
        //  得到请求状态
        status = decoder["status"].string
        //  状态为成功
        if status == "success"{
             // 得到数据 model
            data = LoginUserInfo(decoder["data"])
        }else{
            //  得到错误数据
            errorData = decoder["data"].string
        }
    }
}

//  登录信息的解析
class LoginUserInfo: JSONJoy {

    var user_phone:String
    var user_devicestate:String
    var user_usertype:String
    var user_sex:String
    var user_id:String
    var user_name:String
    var user_city:String
    var user_address:String
    var user_qq:String
    var user_weixin:String
    var user_avatar:String
    var user_time:String
    var user_level:String
    var user_score:String
    var user_birthDay:String
    var user_realname:String
    var user_fanscount:String
    var user_followcount:String
    var user_money:String
    var user_email:String
    var user_email_2:String
    var user_school:String
    var user_school_2:String
    var user_major:String
    var user_major_2:String
    var user_education:String
    var user_education_2:String
    var all_information:String
    

    //  初始化方法
    required init(_ decoder:JSONDecoder){
        //  指针赋值  解析并且向下转型
        user_phone = decoder["phone"].string ?? ""
        user_id = decoder["userid"].string ?? ""
        user_usertype = decoder["usertype"].string ?? ""
        user_sex = decoder["sex"].string ?? ""
        user_devicestate = decoder["devicestate"].string ?? ""
        user_name = decoder["name"].string ?? ""
        user_city = decoder["city"].string ?? ""
        user_address = decoder["address"].string ?? ""
        user_qq = decoder["qq"].string ?? ""
        user_weixin = decoder["weixin"].string ?? ""
        user_avatar = decoder["photo"].string ?? ""
        user_time = decoder["time"].string ?? ""
        user_level = decoder["level"].string ?? "1"
        user_score = decoder["score"].string ?? "1"
        user_birthDay = decoder["birthday"].string ?? ""
        user_realname = decoder["realname"].string ?? ""
        user_fanscount = decoder["fanscount"].string ?? "0"
        user_followcount = decoder["followcount"].string ?? "0"
        user_money = String(decoder["money"].integer ?? 0)
        user_email = decoder["user_email"].string ?? ""
        user_email_2 = decoder["email"].string ?? ""
        user_school = decoder["user_school"].string ?? ""
        user_school_2 = decoder["school"].string ?? ""
        user_major = decoder["user_major"].string ?? ""
        user_major_2 = decoder["major"].string ?? ""
        user_education = decoder["user_education"].string ?? ""
        user_education_2 = decoder["education"].string ?? ""
        all_information = decoder["all_information"].string ?? ""
    }
}
