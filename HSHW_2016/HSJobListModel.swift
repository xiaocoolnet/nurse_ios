//
//  HSJobListModel.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/24.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSJobListModel: JSONJoy {
    var status:String?
    var datas:Array<JobModel>?
    var errorData:String?
    var datastring:String?
    
    init(){
    }
    required init(_ decoder:JSONDecoder){
        status = decoder["status"].string
        if status == "success"{
            for childs:JSONDecoder in decoder["data"].array! {
                datas?.append(JobModel(childs))
            }
        }else{
            errorData = decoder["data"].string
        }
    }
}

class JobModel: JSONJoy {
    
    required init(_ decoder:JSONDecoder){
        
    }
}
