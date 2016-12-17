//
//  ForumlistModel.swift
//  HSHW_2016
//  Created by xiaocool on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

//class ForumlistModel: JSONJoy {
//    var status:String?
//    var datas = Array<PostModel>()
//    var errorData:String?
//    var datastring:String?
//    
//    required init(_ decoder:JSONDecoder){
//        status = decoder["status"].string
//        if status == "success"{
//  
//            for childs:JSONDecoder in decoder["data"].array ?? [] {
//                datas.append(PostModel(childs))
//            }
//        }else{
//            errorData = decoder["data"].string
//        }
//    }
//}

//class ForumTypes: JSONJoy {
//    var status:String?
//    var datas = Array<ForumTypeModel>()
//    var errorData:String?
//    
//    required init(_ decoder:JSONDecoder){
//        status = decoder["status"].string
//        if status == "success"{
//            for childs:JSONDecoder in decoder["data"].array! {
//                datas.append(ForumTypeModel(childs))
//            }
//        }else{
//            errorData = decoder["data"].string
//        }
//    }
//}

//class ForumTypeModel: JSONJoy {
//    
//    var term_id:String
//    var name:String
//    
//    required init(_ decoder:JSONDecoder){
//        term_id = decoder["term_id"].string ?? ""
//        name = decoder["name"].string ?? ""
//    }
//}

//class ForumModel: JSONJoy {
//    
//    var mid:String
//    var type:String
//    var userid:String
//    var name:String
//    var title:String
//    var content:String
//    var write_time:String
//    var photo:String
//    var pic = Array<PicModel>()
//    var like:String
//    var comment = Array<CommentModel>()
//    
//    required init(_ decoder:JSONDecoder){
//        
//        mid = decoder["mid"].string ?? ""
//        type = decoder["type"].string ?? ""
//        userid = decoder["userid"].string ?? ""
//        name = decoder["name"].string ?? ""
//        title = decoder["title"].string ?? ""
//        content = decoder["content"].string ?? ""
//        write_time = decoder["write_time"].string ?? ""
//        photo = decoder["photo"].string ?? ""
//        for child:JSONDecoder in decoder["pic"].array ?? [] {
//            pic.append(PicModel(child))
//        }
//        like = decoder["like"].string ?? ""
//        for child:JSONDecoder in decoder["comment"].array ?? [] {
//            comment.append(CommentModel(child))
//        }
//    }
//}

//class PostlistModel: JSONJoy {
//    var status:String?
//    var datas:PostModel?
//    var errorData:String?
//    var datastring:String?
//    
//    required init(_ decoder:JSONDecoder){
//        status = decoder["status"].string
//        if status == "success"{
//            
//            datas = PostModel(decoder["data"])
//        }else{
//            errorData = decoder["data"].string
//        }
//    }
//}

//class PostCollectListModel: JSONJoy {
//    var status:String?
//    var datas = Array<PostModel>()
//    var errorData:String?
//    var datastring:String?
//    
//    required init(_ decoder:JSONDecoder){
//        status = decoder["status"].string
//        if status == "success"{
//            for child:JSONDecoder in decoder["data"].array ?? [] {
//                datas.append(PostModel(child))
//            }
////            datas = PostModel(decoder["data"])
//        }else{
//            errorData = decoder["data"].string
//        }
//    }
//}

class PostModel: JSONJoy {
    
    var mid:String
    var best:String
    var type:String
    var typename:String
    var userid:String
    var name:String
    var title:String
    var content:String
    var write_time:String
    var photo:String
    var pic = Array<PicModel>()
    var like = Array<likeModel>()
    var comment = Array<CommentModel>()
    
    var object_id:String
    
    
    required init(_ decoder:JSONDecoder){
        
        mid = decoder["mid"].string ?? decoder["object_id"].string! 
        best = decoder["best"].string ?? ""
        type = decoder["type"].string ?? ""
        typename = decoder["typename"].string ?? ""
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
        title = decoder["title"].string ?? ""
        content = decoder["content"].string ?? ""
        write_time = decoder["write_time"].string ?? ""
        photo = decoder["photo"].string ?? "default_header"
        for child:JSONDecoder in decoder["pic"].array ?? [] {
            pic.append(PicModel(child))
        }
        for child:JSONDecoder in decoder["like"].array ?? [] {
            like.append(likeModel(child))
        }
        for child:JSONDecoder in decoder["comment"].array ?? [] {
            comment.append(CommentModel(child))
        }
        
        object_id = decoder["object_id"].string ?? ""
    }
}

class PicModel:JSONJoy {
    var pictureurl:String
    
    required init(_ decoder: JSONDecoder) {
        pictureurl = decoder["pictureurl"].string ?? ""
    }
}

class likeModel: JSONJoy {
    var userid : String
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
    }
    
}

class CommentModel: JSONJoy {
    var userid:String
    var name:String
    var content:String
    
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
        content = decoder["content"].string ?? ""
    }
}
