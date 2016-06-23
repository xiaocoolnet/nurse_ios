//
//  NewsPageHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class NewsPageHelper: NSObject {
    
    // 获取新闻轮播图片
    func getSlideImages(typeid:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"getslidelist"
        let param = [
            "typeid":typeid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = PhotoList(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }

    }
    
}
