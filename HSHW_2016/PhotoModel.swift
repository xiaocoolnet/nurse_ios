//
//  PhotoModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/7.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class PhotoList: JSONJoy {
//    var status:String?
    var objectlist: [PhotoInfo]
    var count: Int{
        return self.objectlist.count
    }
    init(){
        objectlist = Array<PhotoInfo>()
    }
    required init(_ decoder: JSONDecoder) {
        
        objectlist = Array<PhotoInfo>()
        for childs: JSONDecoder in decoder.array!{
            objectlist.append(PhotoInfo(childs))
        }
    }
    
    func append(list: [PhotoInfo]){
        self.objectlist = list + self.objectlist
    }
    
}


class PhotoInfo: JSONJoy{
    
    var url:String?
    
    init(){
        
    }
    
    required init(_ decoder: JSONDecoder){
        
        url = decoder["url"].string
        
    }
    
}