//
//  ForumlistModel.swift
//  HSHW_2016
//  Created by xiaocool on 16/7/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class ForumlistModel: JSONJoy {
    var status:String?
    var datas = Array<ForumModel>()
    var errorData:String?
    var datastring:String?
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas.append(ForumModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
}

class ForumModel: JSONJoy {
    
    var mid:String
    var type:String
    var userid:String
    var name:String
    var title:String
    var content:String
    var write_time:String
    var photo:String
    var pic = Array<PicModel>()
    var like:String
    var comment = Array<CommentModel>()
    
    required init(_ decoder:JSONDecoder){
        mid = decoder["mid"].string ?? ""
        type = decoder["type"].string ?? ""
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
        title = decoder["title"].string ?? ""
        content = decoder["content"].string ?? ""
        write_time = decoder["write_time"].string ?? ""
        photo = decoder["photo"].string ?? ""
        for child:JSONDecoder in decoder["pic"].array ?? [] {
            pic.append(PicModel(child))
        }
        like = decoder["like"].string ?? ""
        for child:JSONDecoder in decoder["comment"].array ?? [] {
            comment.append(CommentModel(child))
        }
    }
}

class PicModel:JSONJoy {
    var pictureurl:String
    
    required init(_ decoder: JSONDecoder) {
        pictureurl = decoder["pictureurl"].string ?? ""
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