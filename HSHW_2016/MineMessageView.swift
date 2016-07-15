//
//  MineMessageView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class MessageModel: JSONJoy {
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

class MessageList: JSONJoy {
    var status:String?
    var objectlist: [MessageInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<MessageInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<MessageInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(MessageInfo(childs))
        }
    }
    
    func append(list: [MessageInfo]){
        self.objectlist = list + self.objectlist
    }
    
}


class MessageInfo: JSONJoy{
    
    var id:String
    var title:String
    var content : String
    var photo : String
    var create_time : String
    
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string ?? ""
        title = decoder["title"].string ?? ""
        content = decoder["content"].string ?? ""
        photo = decoder["photo"].string ?? ""
        create_time = decoder["create_time"].string ?? ""
    }
    
}