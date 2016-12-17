//
//  NewsPageHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
class NewsPageHelper: NSObject {
    
    func collectionNews(_ refid:String,type:String,title:String,description:String,handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"addfavorite"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":type,
            "refid":refid,
            "title":title,
            "description":description
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "error"){
                    handle(false, result.errorData as AnyObject?)
                }
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }
            }
            
        }

    }
    
    // 获取分类列表
    func getChannellist(_ id:String,handle:@escaping ResponseBlock) {
        let url = PARK_URL_Header+"getChannellist"
        let param = [
                "parentid":id
            ];
        
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, nil)
            }else{
                let result = GNewsCateModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "error"){
                    handle(true, Array<GNewsCate>() as AnyObject?)
                }
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }
            }
            
        }
        
    }
    
    // 添加积分——阅读资讯
    func addScore_ReadingInformation(_ remarks:String, handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"addScore_ReadingInformation"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "remarks":remarks
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, "网络错误" as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "error"){
                    handle(false, "阅读资讯加积分到上限值" as AnyObject?)
                }
                if(result.status == "success"){
                    handle(true, result.data)
                }
            }
        }
    }
    
    // 添加积分——分享
    func addScore_fenxiang(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"addScore_fenxiang"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, "网络错误" as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "error"){
                    handle(false, result.errorData as AnyObject?)
                }
                if(result.status == "success"){
                    handle(true, result.data)
                }
            }
        }
    }
    
}
