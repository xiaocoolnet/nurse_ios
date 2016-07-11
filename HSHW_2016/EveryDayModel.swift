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
class ScoreModel: JSONJoy {
    var status:String
    var data:String?
    var errorData:String?
    
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string ?? ""
        
        if status == "success"{
            data = String(decoder["data"].integer ?? 0)
        }else{
            errorData = decoder["data"].string
        }
        
    }
}
class titleList: JSONJoy {
    var status:String?
    var objectlist = Array<EveryDayInfo>()
    var count: Int{
        return self.objectlist.count
    }
    init () {
        
    }
    required init(_ decoder: JSONDecoder) {
        
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(EveryDayInfo(childs))
        }
    }
    
    func append(list: [EveryDayInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class EveryDayInfo: JSONJoy {

    var term_id:String
    var name:String
    var count:String
    var haschild:Int
    var childlist = Array<EveryDayInfo>()
    
<<<<<<< Updated upstream
    required init(_ decoder: JSONDecoder){
        
        term_id = decoder["term_id"].string ?? ""
        name = decoder["name"].string ?? ""
        count = decoder["count"].string ?? ""
        haschild = decoder["haschild"].integer ?? 0
        if decoder["childlist"].array != nil {
            for child in decoder["childlist"].array! {
                childlist.append(EveryDayInfo(child))
            }
        }
=======
    var term_id:String?
    var name:String?
    var count:String?
    var haschild:Int?
    var childlist = Array<ChildInfo>()

    required init(_ decoder: JSONDecoder){
        
        term_id = decoder["term_id"].string
        name = decoder["name"].string
        count = decoder["count"].string
        haschild = decoder["haschild"].integer
        childlist = Array<ChildInfo>()
        if decoder["childlist"].array != nil {
            for childs: JSONDecoder in decoder["childlist"].array!{
                self.childlist.append(ChildInfo(childs))
            }
        }


    }
    
    func addpend(list: [ChildInfo]){
        self.childlist = list + self.childlist
    }
    
}

class ChildList: JSONJoy {
    var status:String?
    var objectlist: [ChildInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<ChildInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<ChildInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(ChildInfo(childs))
        }
    }
    
    func append(list: [ChildInfo]){
        self.objectlist = list + self.objectlist
    }
    
}



class ChildInfo: JSONJoy {
    
    var term_id :String?
    var name :String?
    init() {
        
    }
    required init(_ decoder: JSONDecoder){
        
        term_id = decoder["term_id"].string
        name = decoder["name"].string
>>>>>>> Stashed changes
    }
}




