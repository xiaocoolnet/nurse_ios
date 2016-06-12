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
        }else{
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


class NewsInfo: JSONJoy{
    var post_title:String?
    var create_time:String?
    var post_excerpt:String?
    var tid:String?
    var id : String?
    var post_source :String?
    var post_content:String?
    var post_like:String?
    var post_date:String?
    var recommended:String?
    
    var smeta :JSONDecoder?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        post_title = decoder["post_title"].string
        post_excerpt = decoder["post_excerpt"].string
        post_date = decoder["post_date"].string
        tid = decoder["tid"].string
        id = decoder["id"].string
        post_source = decoder["post_source"].string
        post_content = decoder["post_content"].string
        post_like = decoder["post_like"].string
        recommended = decoder["recommended"].string
      
        smeta = decoder["smeta"]
        print(post_excerpt)
        
        
    }
   
}

//
//class NewsPhoto: JSONJoy {
//
//    var photo :Array<JSONDecoder>?
//    
//    init(){
//        
//    }
//    
//    required init(_ decoder: JSONDecoder){
//
//        photo = decoder["photo"].array
//    }
//
//    
//}
//
//class PhotoUrl: JSONJoy {
//    var url:String?
//    init(){
//        
//    }
//    required init(_ decoder: JSONDecoder) {
//        url = decoder["url"].string
//    }
//    
//}

