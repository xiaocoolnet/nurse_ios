//
//  LoginUserInfoModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/6/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation
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
             // 得到数据(元组)
            data = LoginUserInfo(decoder["data"])
        }else{
            //  得到错误数据
            errorData = decoder["data"].string
        }
        
    }
}
//  得到一个元组  装data里面的属性
class LoginUserInfo: JSONJoy {
//    var user_name:String
    var user_phone:String
//    var avatar:String
//    var addr:String
//    var card_id:String
//    var sex:String
//    var current_car:String
    var id:String
//    var create_time:Int
//    var status:Int
//    var bank_type:String
//    var bank_branch:String
//    var bank_no:String
//    var bank_user_name:String
//    var car_number:String
    //  初始化方法
    required init(_ decoder:JSONDecoder){
        //  指针赋值  解析并且向下转型
//        user_name = decoder["user_name"].string!
        user_phone = decoder["phone"].string!
//        avatar = decoder["avatar"].string!
//        addr = decoder["addr"].string!
//        card_id = decoder["card_id"].string!
//        sex = decoder["sex"].string!
//        current_car = decoder["current_car"].string!
        id = decoder["userid"].string!
//        create_time = decoder["create_time"].integer!
//        status = decoder["status"].integer!
//        bank_type = decoder["bank_type"].string!
//        bank_branch = decoder["bank_branch"].string!
//        bank_no = decoder["bank_no"].string!
//        bank_user_name = decoder["bank_user_name"].string!
//        car_number = decoder["car_number"].string!
        

    }
}
