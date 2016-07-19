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

class HSUserInfoModel: JSONJoy {
    
    var status:String?
    var datas:HSFansAndFollowModel?
    var errorData:String?
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            datas = (HSFansAndFollowModel(decoder["data"]))
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
        name = decoder["name"].string ?? "暂无用户名"
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

// Model 做题记录
class HSGTestModel:JSONJoy {
    var status:String
    var datas = Array<GTestExamList>()
    var errorData:String
        
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["errorData"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(GTestExamList(childs))
        }
    }
}

// Model 错题集
class GHSErrorExamModel:JSONJoy {
    var status:String
    var datas = Array<GExamInfo>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["errorData"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(GExamInfo(childs))
        }
    }
}

// Model 做题记录（data）
class GTestExamList:JSONJoy {
    var id:String
    var userid:String
    var create_time:String
    var post_title:String
    var type:String
    var count:String
    var rightcount:String
    var question = Array<GExamInfo>()
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        post_title = decoder["post_title"].string ?? "Post_title"
        type = decoder["type"].string ?? ""
        count = decoder["count"].string ?? ""
        rightcount = decoder["rightcount"].string ?? ""
        for childs:JSONDecoder in decoder["question"].array ?? [] {
            question.append(GExamInfo(childs))
        }
    }
}

// Model 做题记录（data（question））
// Model 错题集（data）
class GExamInfo: JSONJoy{
    var questionid:String?
    var post_title:String?
    var post_description:String?
    var post_difficulty:String?
    var answer:String?
    var answers = Array<GAnswersInfo>()
    
    required init(_ decoder: JSONDecoder){
        questionid = decoder["questionid"].string
        post_title = decoder["post_title"].string
        post_difficulty = decoder["post_difficulty"].string
        post_description = decoder["post_description"].string
        answer = decoder["answer"].string
        for childs: JSONDecoder in decoder["answers"].array!{
            answers.append(GAnswersInfo(childs))
        }
    }
    func append(list: [GAnswersInfo]){
        self.answers = list + self.answers
    }
}

// Model 做题记录（data（question（answers）））
// Model 错题集（data（answers））
class GAnswersInfo: JSONJoy {
    
    var title:String
    var isanswer :String
    var id :String
    var questionid:String
    var listorder:String
    
    required init(_ decoder: JSONDecoder){
        title = decoder["title"].string ?? ""
        isanswer = decoder["isanswer"].string ?? ""
        id = decoder["id"].string ?? ""
        questionid = decoder["questionid"].string ?? ""
        listorder = decoder["listorder"].string ?? ""
    }
}


// Model 收藏记录
class CollectModel:JSONJoy {
    var status:String
    var datas = Array<CollectList>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["errorData"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(CollectList(childs))
        }
    }
}

// Model 收藏记录（data）
class CollectList:JSONJoy {
    var id:String
    var userid:String
    var title:String
    var description:String
    var type:String
    var object_id:String
    var createtime:String
    var questionid:String
    var post_title:String
    var post_description:String
    var post_difficulty:String
    var answer:String
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        title = decoder["title"].string ?? ""
        description = decoder["description"].string ?? ""
        type = decoder["type"].string ?? ""
        object_id = decoder["object_id"].string ?? ""
        createtime = decoder["createtime"].string ?? ""
        questionid = decoder["questionid"].string ?? ""
        post_title = decoder["post_title"].string ?? ""
        post_description = decoder["post_description"].string ?? ""
        post_difficulty = decoder["post_difficulty"].string ?? ""
        answer = decoder["answer"].string ?? ""
    }
}










