//
//  SmetaModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/7.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class SmetaList: JSONJoy {
    var status:String?
    var objectlist: [SmetaInfo]
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<SmetaInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<SmetaInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(SmetaInfo(childs))
        }
    }
    func append(list: [SmetaInfo]){
        self.objectlist = list + self.objectlist
    }
    
}
class SmetaInfo: JSONJoy{

//    var photo :JSONDecoder?
    var thumb :String?
    
    init(){
        
    }
    required init(_ decoder: JSONDecoder){
//        photo = decoder["photo"]
        thumb = decoder["thumb"].string
        //// print("--------------")
        //// print(thumb)
    }
    
}