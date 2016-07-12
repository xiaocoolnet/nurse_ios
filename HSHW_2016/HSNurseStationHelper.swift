//
//  HSNurseStationHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/24.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class HSNurseStationHelper: NSObject {
    //获取职位列表
    func getJobList(handle:ResponseBlock){
        let url = PARK_URL_Header+"getjoblist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSJobListModel(JSONDecoder(json!))
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
    //获取简历列表
    func getCVList(handle:ResponseBlock){
        let url = PARK_URL_Header+"getResumeList"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSCVListModel(JSONDecoder(json!))
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
    //获取资讯文章列表
    func getArticleListWithID(articleid:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":articleid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let model =  NewsModel(JSONDecoder(json!))
                if(model.status == "success"){
                let result = NewsList(model.data!)
                print("状态是")
                print(result.status)
                    handle(success: true, response: result.objectlist)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
    //获取论坛帖子列表
    func getForumList(type:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"getbbspostlist"
        let param = ["type":type]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = ForumlistModel(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
    //发布帖子
    func postForumCard(typid:String,title:String,content:String,picurl:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"addbbsposts"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"typeid":typid,"title":title,"content":content,"picurl":picurl]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
    //获取论坛分类
    func getBBSTypeData(handle:ResponseBlock){
        let url = PARK_URL_Header+"getbbstype"
        
        Alamofire.request(.GET, url, parameters: nil).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = ForumTypes(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
}
