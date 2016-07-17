//
//  MineChildView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class ChildModel: JSONJoy{
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

class ChildList: JSONJoy {
    var status:String?
    var objectlist: [ChildInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ChildInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ChildInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildInfo(childs))
        }
    }
    
    func append(list: [ChildInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class ChildInfo: JSONJoy {
    
    var id:String
    var userid:String
    var name:String
    var sex:String
    var avatar:String
    var birthday:String
    var address:String
    var education:String
    var certificate:String
    var currentsalary:String
    var count:String
    var description:String
    var linkman:String
    var phone:String
    
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
    }
}