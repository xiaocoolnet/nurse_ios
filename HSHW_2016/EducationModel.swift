//
//  EducationModel.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class EduModel: JSONJoy{
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

class EduList: JSONJoy {
    var status:String?
    var objectlist: [EduInfo]
    
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<EduInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<EduInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(EduInfo(childs))
        }
    }
    
    func append(_ list: [EduInfo]){
        self.objectlist = list + self.objectlist
    }
    
}

class EduInfo: JSONJoy{
    var id:String
    var name:String
    
    required init(_ decoder: JSONDecoder){
        
        id = decoder["id"].string ?? ""
        name = decoder["name"].string ?? ""
        
        name = name.replacingOccurrences(of: "&lt;", with: "<")
        name = name.replacingOccurrences(of: "&gt;", with: ">")
        name = name.replacingOccurrences(of: "&amp;", with: "&")
    }
}
