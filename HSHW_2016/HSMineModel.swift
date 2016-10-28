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
        errorData = decoder["data"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(GTestExamList(childs))
        }
    }
}

// Model 错题集
class GHSErrorExamModel:JSONJoy {
    var status:String
    var datas = Array<xamInfo>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["data"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(xamInfo(childs))
        }
    }
}

// Model 错题集
class HSErrorExamModel:JSONJoy {
    var status:String
    var datas = Array<xamInfo>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["data"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(xamInfo(childs))
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
    var question = Array<xamInfo>()
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        post_title = decoder["post_title"].string ?? "Post_title"
        type = decoder["type"].string ?? ""
        count = decoder["count"].string ?? ""
        rightcount = decoder["rightcount"].string ?? ""
        for childs:JSONDecoder in decoder["question"].array ?? [] {
            question.append(xamInfo(childs))
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
        questionid = decoder["questionid"].string ?? ""
        post_title = decoder["post_title"].string ?? ""
        post_difficulty = decoder["post_difficulty"].string ?? ""
        post_description = decoder["post_description"].string ?? ""
        answer = decoder["answer"].string ?? ""
        for childs: JSONDecoder in decoder["answers"].array!{
            answers.append(GAnswersInfo(childs))
        }
    }
    func append(list: [GAnswersInfo]){
        self.answers = list + self.answers
    }
}

// Model 错题集（data）
class xamInfo: JSONJoy{
    var questionid:String
    var post_title:String
    var title:String
    var createtime:String
    
    var post_description:String
    var post_difficulty:String
    var answer:String
    var answers_2 = Array<AnswersInfo>()
    var answers = Array<AnswersInfo>()
    
    required init(_ decoder: JSONDecoder){
        questionid = decoder["questionid"].string ?? ""
        post_title = decoder["post_title"].string ?? ""
        post_difficulty = decoder["post_difficulty"].string ?? "0"
        post_description = decoder["post_description"].string ?? ""
        answer = decoder["answer"].string ?? ""
        title = decoder["title"].string ?? ""
        createtime = decoder["createtime"].string ?? "0"
        for childs: JSONDecoder in decoder["answerslist"].array ?? []{
            answers_2.append(AnswersInfo(childs))
        }
        for childs: JSONDecoder in decoder["answers"].array ?? []{
            answers.append(AnswersInfo(childs))
        }
    }
    func append(list: [AnswersInfo]){
        self.answers_2 = list + self.answers_2
        self.answers = list + self.answers
    }
//    func append(list: [AnswersInfo]){
//    }
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

// Model 错题集（data（answers））
class AnswersInfo: JSONJoy {
    
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


// Model 收藏其他记录
class CollectModel:JSONJoy {
    var status:String
    var datas = Array<NewsInfo>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["data"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(NewsInfo(childs))
        }
    }
}


//// Model 收藏记录
//class CollectModel:JSONJoy {
//    var status:String
//    var datas = Array<CollectList>()
//    var errorData:String
//    
//    required init(_ decoder: JSONDecoder) {
//        status = decoder["status"].string ?? ""
//        errorData = decoder["errorData"].string ?? ""
//        for childs:JSONDecoder in decoder["data"].array ?? [] {
//            datas.append(CollectList(childs))
//        }
//    }
//}


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

// Model 企业信息状态
class CompanyInfoStatus:JSONJoy {

    var status: String?

    var data:CompanyInfo?
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        if status == "success"{
            data = (CompanyInfo(decoder["data"]))
        }else{
        }
    }
}

// Model 企业信息（data）
class CompanyInfo:JSONJoy {

    var userid: String?

    var companyinfo: String?

    var phone: String?

    var id: String?

    var status: String?

    var linkman: String?

    var email: String?

    var create_time: String?

    var license: String?

    var companyname: String?
    
    
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
        companyinfo = decoder["companyinfo"].string ?? ""
        phone = decoder["phone"].string ?? ""
        id = decoder["id"].string ?? ""
        status = decoder["status"].string ?? ""
        linkman = decoder["linkman"].string ?? ""
        email = decoder["email"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        license = decoder["license"].string ?? ""
        companyname = decoder["companyname"].string ?? ""
    }
}

// List 积分排行榜
class RankList:JSONJoy {
    
    var status: String?
    
    var data = Array<RankModel>()
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            data.append(RankModel(childs))
        }
    }
}

// Model 积分排行榜（data）
class RankModel: JSONJoy {

    var id: String

    var score: String

    var name: String

    var photo: String

    var time: String
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        score = decoder["score"].string ?? ""
        name = decoder["name"].string ?? "NO NAME"
        photo = decoder["photo"].string ?? ""
        
        let timeStr = NSString(string: decoder["time"].string ?? "")
        let timeSta:NSTimeInterval = timeStr.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        time = dfmatter.stringFromDate(date)
    }

}

// List 个人积分详情
class Ranking_User:JSONJoy {
    
    var status: String?
    
    var data = Array<Ranking_UserModel>()
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            data.append(Ranking_UserModel(childs))
        }
    }
}

// Model 个人积分详情（data）
class Ranking_UserModel: JSONJoy {
    
    var userid: String
    
    var event: String
    
    var score: String
    
    var create_time: String
    
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
        score = decoder["score"].string ?? ""
        event = decoder["event"].string ?? "NO NAME"
//        create_time = decoder["create_time"].string ?? ""
        
        let timeStr = NSString(string: decoder["create_time"].string ?? "")
        let timeSta:NSTimeInterval = timeStr.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        create_time = dfmatter.stringFromDate(date)
    }
    
}

// Model 得分数据
class examData:JSONJoy {
    var status:String
    var datas = Array<examDataModel>()
    var errorData:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        errorData = decoder["data"].string ?? ""
        for childs:JSONDecoder in decoder["data"].array ?? [] {
            datas.append(examDataModel(childs))
        }
    }
}

class examDataModel:JSONJoy {

    var rate: Int = 0

    var id: String

    var post_title: String

    var count: String

    var rightcount: String

    var create_time: String

    var type: String
    
    
    required init(_ decoder: JSONDecoder) {
        rate = decoder["rate"].integer ?? 0
        id = decoder["id"].string ?? ""
        post_title = decoder["post_title"].string ?? ""
        count = decoder["count"].string ?? ""
        rightcount = decoder["rightcount"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        type = decoder["type"].string ?? ""
    }
}

// Model 折线图数据
class LineChartData:JSONJoy {
    var status:String
    var data:LineChartDataModel?
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        data = (LineChartDataModel(decoder["data"]))
    }
}

class LineChartDataModel:JSONJoy {
    
    
    var create_time_6: Float = 0

    var rate_7: Float = 0

    var rate_6: Float = 0

    var create_time_2: Float = 0

    var create_time_7: Float = 0

    var rate_5: Float = 0

    var create_time_3: Float = 0

    var rate_4: Float = 0

    var create_time_4: Float = 0

    var rate_3: Float = 0

    var rate_2: Float = 0

    var create_time_5: Float = 0

    var create_time_1: Float = 0

    var rate_1: Float = 0
    
    required init(_ decoder: JSONDecoder) {
        
        rate_1 = decoder["rate_1"].float ?? 0
        create_time_1 = decoder["create_time_1"].float ?? 0
        
        rate_2 = decoder["rate_2"].float ?? 0
        create_time_2 = decoder["create_time_2"].float ?? 0
        
        rate_3 = decoder["rate_3"].float ?? 0
        create_time_3 = decoder["create_time_3"].float ?? 0
        
        rate_4 = decoder["rate_4"].float ?? 0
        create_time_4 = decoder["create_time_4"].float ?? 0
        
        rate_5 = decoder["rate_5"].float ?? 0
        create_time_5 = decoder["create_time_5"].float ?? 0
        
        rate_6 = decoder["rate_6"].float ?? 0
        create_time_6 = decoder["create_time_6"].float ?? 0
        
        rate_7 = decoder["rate_7"].float ?? 0
        create_time_7 = decoder["create_time_7"].float ?? 0
        
    }
}

// Model 综合正确率
class SynAccuracy:JSONJoy {
    var status:String
    var data:SynAccuracyModel?
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        data = (SynAccuracyModel(decoder["data"]))
    }
}

class SynAccuracyModel:JSONJoy {
    
    
    
    var userid: String?

    var rates_average: Double = 0
    
    
    required init(_ decoder: JSONDecoder) {
        
        userid = decoder["userid"].string ?? ""
        rates_average = decoder["rates_average"].double ?? 0
        
    }
}

// Model 状态
class HSStatusModel:JSONJoy {
    var status:String
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string ?? ""
        
    }
}
