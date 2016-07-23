//
//  MineFinesView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class MinePostModel: JSONJoy{
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

class MinePostList: JSONJoy {
    var status:String?
    var objectlist: [MinePostInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MinePostInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MinePostInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MinePostInfo(childs))
        }
    }
    
    func append(list: [MinePostInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class MinePostInfo: JSONJoy{
    var id:String
    var userid:String
    var title:String
    var description:String
    var type:String
    var object_id:String
    var createtime:String
    var best:String
    var typename:String
    var name:String
    var content:String
    var write_time:String
    var pic = Array<MinePicModel>()
    var like = Array<MineLikeModel>()
    var comment = Array<MineCommentModel>()
    
    required init(_ decoder:JSONDecoder){
        
        id = decoder["id"].string ?? ""
        userid = decoder["userid"].string ?? ""
        title = decoder["title"].string ?? ""
        description = decoder["description"].string ?? ""
        type = decoder["type"].string ?? ""
        object_id = decoder["object_id"].string ?? ""
        createtime = decoder["createtime"].string ?? ""
        best = decoder["best"].string ?? ""
        typename = decoder["typename"].string ?? ""
        name = decoder["name"].string ?? ""
        content = decoder["content"].string ?? ""
        write_time = decoder["write_time"].string ?? ""
        for child:JSONDecoder in decoder["pic"].array ?? [] {
            pic.append(MinePicModel(child))
        }
        for child:JSONDecoder in decoder["like"].array ?? [] {
            like.append(MineLikeModel(child))
        }
        for child:JSONDecoder in decoder["comment"].array ?? [] {
            comment.append(MineCommentModel(child))
        }
    }
}

class MinePicModel:JSONJoy {
    var pictureurl:String
    
    required init(_ decoder: JSONDecoder) {
        pictureurl = decoder["pictureurl"].string ?? ""
    }
}

class MineLikeModel: JSONJoy {
    var userid:String
    var name:String
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
    }
}

class MineCommentModel: JSONJoy {
    var userid:String
    var name:String
    var content:String
    
    required init(_ decoder: JSONDecoder) {
        userid = decoder["userid"].string ?? ""
        name = decoder["name"].string ?? ""
        content = decoder["content"].string ?? ""
    }
}