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

class InvitedModel: JSONJoy{
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
        }else{
            errorData = decoder["data"].string
        }
    }
}

class InvitedList: JSONJoy {
    var status:String?
    var data: [InvitedInfo]
    
    init(){
        data = Array<InvitedInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        data = Array<InvitedInfo>()
        for childs: JSONDecoder in decoder.array!{
            data.append(InvitedInfo(childs))
        }
    }
    
    func append(list: [InvitedInfo]){
        self.data = list + self.data
    }
    
}

class InvitedInfo: JSONJoy {
    
    var id:String
    var userid:String
    var photo:String
    var companyname:String
    var companyinfo:String
    var title:String
    var experience:String
    var jobtype:String
    var education:String
    var certificate:String
    var address:String
    var salary:String
    var description:String
    var welfare:String
    var count:String
    var linkman:String
    var phone:String
    var email:String
    var listorder:String
    var create_time:String
    var state:String
    var hits:String
    
    required init(_ decoder:JSONDecoder){
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        photo = decoder["photo"].string ?? ""
        companyname = decoder["companyname"].string ?? ""
        companyinfo = decoder["companyinfo"].string ?? ""
        title = decoder["title"].string ?? ""
        experience = decoder["experience"].string ?? ""
        jobtype = decoder["jobtype"].string ?? ""
        education = decoder["education"].string ?? ""
        certificate = decoder["certificate"].string ?? ""
        address = decoder["address"].string ?? ""
        salary = decoder["salary"].string ?? ""
        description = decoder["description"].string ?? ""
        welfare = decoder["welfare"].string ?? ""
        count = decoder["count"].string ?? ""
        linkman = decoder["linkman"].string ?? ""
        phone = decoder["phone"].string ?? ""
        email = decoder["email"].string ?? ""
        listorder = decoder["listorder"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        state = decoder["state"].string ?? ""
        hits = decoder["hits"].string ?? "0"
    }
}