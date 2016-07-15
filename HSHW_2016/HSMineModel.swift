//
//  HSMineModel.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSMineList: JSONJoy {
    
    var status:String?
    var datas = Array<HSFansAndFollowModel>()
    var errorData:String?
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas.append(HSFansAndFollowModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }

}

class HSFansAndFollowModel: JSONJoy {
    
    var id:String
    var userid:String
    var title:String
    var description:String
    var type:String
    var object_id:String
    var createtime:String
    var name:String
    var realname:String
    var userType:String
    var phone:String
    var password:String
    var birthday:String
    var sex:String
    var email:String
    var qq:String
    var weixin:String
    var photo:String
    var school:String
    var major:String
    var education:String
    var from:String
    var time:String
    var devicestate:String
    var city:String
    var level:String
    
    // TODO:待接口好后看
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        title = decoder["title"].string ?? ""
        description = decoder["description"].string ?? ""
        type = decoder["type"].string ?? ""
        object_id = decoder["object_id"].string ?? ""
        createtime = decoder["createtime"].string ?? ""
        name = decoder["name"].string ?? ""
        realname = decoder["realname"].string ?? ""
        userType = decoder["userType"].string ?? ""
        phone = decoder["phone"].string ?? ""
        password = decoder["password"].string ?? ""
        birthday = decoder["birthday"].string ?? ""
        sex = decoder["sex"].string ?? ""
        email = decoder["email"].string ?? ""
        qq = decoder["qq"].string ?? ""
        weixin = decoder["weixin"].string ?? ""
        photo = decoder["photo"].string ?? ""
        school = decoder["school"].string ?? ""
        major = decoder["major"].string ?? ""
        education = decoder["education"].string ?? ""
        from = decoder["from"].string ?? ""
        time = decoder["time"].string ?? ""
        devicestate = decoder["devicestate"].string ?? ""
        city = decoder["city"].string ?? ""
        level = decoder["level"].string ?? ""
    }
}
