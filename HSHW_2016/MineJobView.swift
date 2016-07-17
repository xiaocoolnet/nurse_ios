//
//  MineJobView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class MineJobModel: JSONJoy{
    var status:String?
    var data: JSONDecoder?
    var array : Array<JSONDecoder>?
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = decoder["data"]
        }
        else{
            errorData = decoder["data"].string
        }
    }
}

class MineJobList: JSONJoy {
    var status:String?
    var objectlist: [MineJobInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MineJobInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MineJobInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MineJobInfo(childs))
        }
    }
    
    func append(list: [MineJobInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MineJobInfo: JSONJoy {
    
    var id:String
    var companyid:String
    var companyname:String
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
    
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string ?? ""
        companyid = decoder["companyid"].string ?? ""
        companyname = decoder["companyname"].string ?? ""
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

    }
}