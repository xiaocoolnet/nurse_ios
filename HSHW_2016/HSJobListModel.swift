//
//  HSJobListModel.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/24.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSJobListModel: JSONJoy {
    var status:String?
    var datas = Array<JobModel>()
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas.append(JobModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
}

class JobModel: JSONJoy {
    
    var id:String
    var companyid:String
    var companyname:String
    var photo:String
    var title:String
    var education:String
    var certificate:String
    var address:String
    var salary:String
    var welfare:String
    var count:String
    var description:String
    var linkman:String
    var phone:String
    var jobtype:String
    var create_time:String
    var companyinfo:String
    var hits:String
    var experience:String
    
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string ?? ""
        companyid = decoder["companyid"].string ?? ""
        companyname = decoder["companyname"].string ?? ""
        photo = decoder["photo"].string ?? ""
        title = decoder["title"].string ?? ""
        education = decoder["education"].string ?? ""
        certificate = decoder["certificate"].string ?? ""
        address = decoder["address"].string ?? ""
        salary = decoder["salary"].string ?? ""
        welfare = decoder["welfare"].string ?? ""
        count = decoder["count"].string ?? ""
        description = decoder["description"].string ?? ""
        linkman = decoder["linkman"].string ?? ""
        phone = decoder["phone"].string ?? ""
        jobtype = decoder["jobtype"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        companyinfo = decoder["companyinfo"].string ?? ""
        hits = decoder["hits"].string ?? "0"
        experience = decoder["experience"].string ?? "0"

    }
}
