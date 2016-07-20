
//
//  FiftyView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

class FifModel: JSONJoy{
    var status:String?
    var data: FifInfo?
    var datastring:String?
    var errorData:String?
    init(){
    }
    required init(_ decoder:JSONDecoder){
        
        status = decoder["status"].string
        if status == "success" {
            data = FifInfo(decoder["data"])
        }
        else{
            errorData = decoder["data"].string
        }
    }
}



class FifInfo: JSONJoy{
    var id:String?
    var userid:String?
    var day:String?
    var time:String?
    
    required init(_ decoder: JSONDecoder){
        id = decoder["id"].string 
        userid = decoder["userid"].string
        day = decoder["day"].string
        time = decoder["time"].string
    }
}
