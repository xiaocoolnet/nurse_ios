//
//  OnlineTextModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class OnlineTextModel: JSONJoy {
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

class titList: JSONJoy {
    var status:String?
    var objectlist: [OnlineTextInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<OnlineTextInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<OnlineTextInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(OnlineTextInfo(childs))
        }
    }
    
    func append(list: [OnlineTextInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class OnlineTextInfo: JSONJoy {
    
    var term_id:String
    var name:String
    var count:String
    
    required init(_ decoder: JSONDecoder){
        
        term_id = decoder["term_id"].string ?? ""
        name = decoder["name"].string ?? ""
        count = decoder["count"].string ?? ""
    }
    
}





