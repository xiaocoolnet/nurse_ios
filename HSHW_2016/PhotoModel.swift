//
//  PhotoModel.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/7.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class PhotoList: JSONJoy {
    var status:String?
    var datas: Array<PhotoInfo>?
    var errorData:String?
    var count: Int{
        return self.datas!.count
    }
    
    init(){
    }

    required init(_ decoder: JSONDecoder) {
        
        status = decoder["status"].string
        
        if status == "success" {
            datas = []
            for childs: JSONDecoder in decoder["data"].array!{
                datas?.append(PhotoInfo(childs))
            }
            
        }else{
            errorData = decoder["data"].string
        }
    }
    
}



class PhotoInfo: JSONJoy{
    
    var url:String
    var picUrl:String
    
    required init(_ decoder: JSONDecoder){
        
        url = decoder["slide_url"].string ?? ""
        picUrl = decoder["slide_pic"].string ?? ""
    }
    
}