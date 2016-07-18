//
//  HSCVListModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/25.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSCVListModel: JSONJoy {
    var status:String?
    var datas = Array<CVModel>()
    var errorData:String?
    var datastring:String?
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas.append(CVModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
}
class CVModel: JSONJoy {
    
    var id:String
    var userid:String
    var name:String
    var sex:String
    var avatar:String
    var birthday:String
    var experience:String
    var address:String
    var education:String
    var wantposition:String
    var certificate:String
    var currentsalary:String
    var count:String
    var description:String
    var linkman:String
    var phone:String
    var title:String
    var jobstate:String
    var email:String
    var hiredate:String
    var wantcity:String
    var wantsalary:String
    
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
        sex = decoder["sex"].string ?? ""
        avatar = decoder["avatar"].string ?? ""
        birthday = decoder["birthday"].string ?? ""
        address = decoder["address"].string ?? ""
        currentsalary = decoder["currentsalary"].string ?? ""
        certificate = decoder["certificate"].string ?? ""
        count = decoder["count"].string ?? ""
        description = decoder["description"].string ?? ""
        linkman = decoder["linkman"].string ?? ""
        phone = decoder["phone"].string ?? ""
        education = decoder["education"].string ?? ""
        experience = decoder["experience"].string ?? ""
        title = decoder["title"].string ?? ""
        jobstate = decoder["jobstate"].string ?? ""
        wantposition = decoder["wantposition"].string ?? ""
        description = decoder["description"].string ?? ""
        email = decoder["email"].string ?? ""
        phone = decoder["phone"].string ?? ""
        hiredate = decoder["hiredate"].string ?? ""
        wantcity = decoder["wantcity"].string ?? ""
        wantsalary = decoder["wantsalary"].string ?? ""
    }
}