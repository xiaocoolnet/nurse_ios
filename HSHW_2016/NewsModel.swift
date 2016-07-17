//
//  NewsModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class NewsModel: JSONJoy{
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

class NewsList: JSONJoy {
    var status:String?
    var objectlist: [NewsInfo]

    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<NewsInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<NewsInfo>()
        for childs: JSONDecoder in decoder.array!{
           objectlist.append(NewsInfo(childs))
        }
    }
    
    func append(list: [NewsInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class newsInfoModel: JSONJoy {
    var status:String?
    var data = Array<NewsInfo>()
    var errorData:String?
    
    required init(_ decoder: JSONDecoder) {
        status = decoder["status"].string
        if status == "success" {
            for child in decoder["data"].array ?? []{
                data.append(NewsInfo(child))
            }
        }
        else{
            errorData = decoder["data"].string
        }
    }
}

class NewsInfo: JSONJoy{
    var post_title:String?
    var create_time:String?
    var post_excerpt:String?
    var tid:String?
    var title:String?
    var object_id : String?
    var post_source :String?
    var post_content:String?
    var post_like:String?
    var post_date:String?
    var recommended:String?
    var thumb:String?
    var term_id :String?
    var term_name:String
    var term_hits:String
    var likes = Array<LikeInfo>()
    var smeta :JSONDecoder?
    
    required init(_ decoder: JSONDecoder){
        post_title = decoder["post_title"].string
        title = decoder["title"].string
        post_excerpt = decoder["post_excerpt"].string
        post_date = decoder["post_date"].string
        tid = decoder["tid"].string
        object_id = decoder["object_id"].string
        post_source = decoder["post_source"].string
        post_content = decoder["post_content"].string
        post_like = decoder["post_like"].string
        recommended = decoder["recommended"].string
        thumb = decoder["thumb"].string
        term_id = decoder["term_id"].string
        smeta = decoder["smeta"]
        term_name = decoder["term_name"].string ?? ""
        term_hits = decoder["term_hits"].string ?? ""
        print(post_excerpt)
        print(decoder["likes"].array)
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

class LikeList: JSONJoy {
    var status:String?
    var objectlist: [LikeInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<LikeInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<LikeInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(LikeInfo(childs))
        }
    }
    
    func append(list: [LikeInfo]){
        self.objectlist = list + self.objectlist
    }
}

class LikeInfo: JSONJoy {
    
    var userid :String?
    init() {}
    required init(_ decoder: JSONDecoder){
        userid = decoder["userid"].string
    }
}


