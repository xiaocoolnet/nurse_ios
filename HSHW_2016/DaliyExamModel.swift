//
//  DaliyExamModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

//class DaliyExamModel:JSONJoy {
//    var status:String?
//    var data: JSONDecoder?
//    var array : Array<JSONDecoder>?
//    var errorData:String?
//    init(){
//    }
//    required init(_ decoder:JSONDecoder){
//        
//        status = decoder["status"].string
//        if status == "success" {
//            data = decoder["data"]
//        }else{
//            errorData = decoder["data"].string
//        }
//    }
//}
//class HSTestModel:JSONJoy {
//    var status:String
//    var data = Array<testExamList>()
//    
//    required init(_ decoder: JSONDecoder) {
//        status = decoder["status"].string ?? ""
//        for childs:JSONDecoder in decoder["data"].array ?? [] {
//            data.append(testExamList(childs))
//        }
//    }
//}
class testExamList:JSONJoy {
    var id:String
    var userid:String
    var create_time:String
    var post_title:String
    var type:String
    var count:String
    var question = Array<ExamInfo>()
    
    required init(_ decoder: JSONDecoder) {
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
        post_title = decoder["post_title"].string ?? ""
        type = decoder["type"].string ?? ""
        count = decoder["count"].string ?? ""
        for childs:JSONDecoder in decoder["question"].array ?? [] {
            question.append(ExamInfo(childs))
        }
    }
}

class DaliyExamList: JSONJoy {
    var status:String?
//    var objectlist: [ExamInfo]
    var objectlist = Array<ExamInfo>()
    var count: Int{
        return self.objectlist.count
    }
    
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ExamInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ExamInfo(childs))
        }
    }
    
//    func append(list: [ExamInfo]){
//        self.objectlist = list + self.objectlist
//    }
    
}

class ExamInfo: JSONJoy{
    var id:String?
    var post_title:String?
    var post_description:String?
    var post_difficulty:String?
    var answerlist = Array<answerInfo>()
    
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string
        post_title = decoder["post_title"].string
        post_difficulty = decoder["post_difficulty"].string
        post_description = decoder["post_description"].string
        for childs: JSONDecoder in decoder["answerlist"].array!{
            answerlist.append(answerInfo(childs))
        }
    }
    func append(_ list: [answerInfo]){
        self.answerlist = list + self.answerlist
    }
}



//class answerList: JSONJoy {
//    var status:String?
//    var objectlist: [answerInfo]
//    
//    var count: Int{
//        return self.objectlist.count
//    }
//    init(){
//        objectlist = Array<answerInfo>()
//    }
//    required init(_ decoder: JSONDecoder) {
//        
//        objectlist = Array<answerInfo>()
//        for childs: JSONDecoder in decoder.array!{
//            objectlist.append(answerInfo(childs))
//        }
//    }
//    
//    func append(list: [answerInfo]){
//        self.objectlist = list + self.objectlist
//    }
//    
//}

class answerInfo: JSONJoy {
    
    var answer_title:String
    var isanswer :String
    var id :String
    var questionid:String

    required init(_ decoder: JSONDecoder){
        answer_title = decoder["answer_title"].string ?? ""
        isanswer = decoder["isanswer"].string ?? ""
        id = decoder["id"].string ?? ""
        questionid = decoder["questionid"].string ?? ""
    }
}





