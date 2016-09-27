//
//  QuestionModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class QuestionModel: JSONJoy {
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

class QuestionList: JSONJoy {
    var status:String?
    var objectlist: [QuestionInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<QuestionInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<QuestionInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(QuestionInfo(childs))
        }
    }
    
    func append(list: [QuestionInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class QuestionInfo: JSONJoy{
    var object_id : String?
    var term_id :String?
    var post_title:String?
    var post_excerpt:String?
    var post_date:String?
    var post_source:String?
    var post_like:String?
    var post_hits :String?
    var recommended :String?
    var thumb :String?
    var likes:[LikeInfo]
    var smeta :JSONDecoder?
    
    init(){
        likes = Array<LikeInfo>()
    }
    
    required init(_ decoder: JSONDecoder){
        object_id = decoder["object_id"].string
        term_id = decoder["term_id"].string
        post_title = decoder["post_title"].string
        post_excerpt = decoder["post_excerpt"].string
        post_date = decoder["post_date"].string
        post_source = decoder["post_source"].string
        post_like = decoder["post_like"].string
        post_hits = decoder["post_hits"].string
        recommended = decoder["recommended"].string
        thumb = decoder["decoder"].string
        likes = Array<LikeInfo>()
        smeta = decoder["smeta"]
//        print(post_excerpt)
//        print(decoder["likes"].array)
        if decoder["likes"].array != nil {
            for childs: JSONDecoder in decoder["likes"].array!{
                self.likes.append(LikeInfo(childs))
            }
        }
        
        
    }
    func addpend(list: [LikeInfo]){
        self.likes = list + self.likes
    }
    
}

