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
    var user_id:String

    //  初始化方法
    required init(_ decoder:JSONDecoder){
        //  指针赋值  解析并且向下转型

        user_phone = decoder["phone"].string!
        user_id = decoder["userid"].string!
        user_usertype = decoder["usertype"].string!
        user_devicestate = decoder["devicestate"].string!
    }
}
