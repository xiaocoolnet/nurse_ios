//
//  EveryDayModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import  Foundation

class EveryDayModel: JSONJoy {
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

class titleList: JSONJoy {
    var status:String?
    var objectlist: [EveryDayInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<EveryDayInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<EveryDayInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(EveryDayInfo(childs))
        }
    }
    
    func append(list: [EveryDayInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class EveryDayInfo: JSONJoy {
    
    var term_id:String?
    var name:String?
    var count:String?
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
        
        term_id = decoder["term_id"].string
        name = decoder["name"].string
        count = decoder["count"].string
    }
    
}
