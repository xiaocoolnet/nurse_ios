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
            // print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSJobListModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    //发布招聘信息
    func publishJob(companyname:String,companyinfo:String,linkman:String,phone:String,email:String,title:String,jobtype:String,education:String,welfare:String,address:String,count:String,salary:String,description:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"publishjob"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,
                     "photo":QCLoginUserInfo.currentInfo.avatar,
                     "companyname":companyname,
                     "companyinfo":companyinfo,
                     "linkman":linkman,
                     "phone":phone,
                     "email":email,
                     "title":title,
                     "jobtype":jobtype,
                     "education":education,
                     "welfare":welfare,
                     "address":address,
                     "count":count,
                     "salary":salary,
                     "description":description]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                // print(request?.URLString)
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                   
                }else{
                    handle(success: false, response: nil)
                  
                }
            }
        }
    }
    
    //获取简历列表
    func getCVList(handle:ResponseBlock){
        let url = PARK_URL_Header+"getResumeList"
        
        Alamofire.request(.GET, url).response { request, response, json, error in
            // print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSCVListModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    //获取简历
    func getResumeInfo(userid:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"getResumeInfo"
        let param = [
            "userid":userid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            // print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = GCVModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    // 判断是否已投递
    func ApplyJob_judge(userid:String, companyid:String, jobid:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"ApplyJob_judge"
        let param = [
            "userid":userid,
            "companyid":companyid,
            "jobid":jobid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            // print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.data)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    // 判断是否已邀请
    func InviteJob_judge(userid:String, companyid:String, jobid:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"InviteJob_judge"
        let param = [
            "userid":userid,
            "companyid":companyid,
            "jobid":jobid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            // print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(success: true, response: result.data)
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
                    // print("状态是")
                    // print(result.status)
                    handle(success: true, response: result.objectlist)
                }else{
                    handle(success: false, response: model.errorData)
                }
            }
        }
    }
    
    //获取论坛帖子列表
    func getForumList(type:String,isHot:Bool,handle:ResponseBlock){
        let url = PARK_URL_Header+"getbbspostlist"
        var param = ["type":type]
        if isHot {
            param["ishot"] = "1"
        }
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
    //获取论坛帖子详情
    func showPostInfo(id:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"showpostinfo"
        let param = ["id":id]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = PostlistModel(JSONDecoder(json!))
                // print(result.datas)
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
        // print(param)
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            
            // print(response)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                // print(result)
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
    
    //添加评论
    func setComment(id:String,content:String,type:String,photo:String, handle:ResponseBlock){
        
//        http://app.chinanurse.cn/index.php?g=apps&m=index&a=SetComment&userid=600&id=4&content=你好&type=2&photo=9.jpg
        let url = PARK_URL_Header+"SetComment"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"id":id,"content":content,"type":type,"photo":photo]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            
            // print(request?.URLString)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: result.data)
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
                }
            }
        }
    }
    
    // 发布简历
    func postForum(userid:String,
                   avatar:String,
                   name:String,
                   experience:String,
                   sex:String,
                   birthday:String,
                   certificate:String,
                   education:String,
                   address:String,
                   jobstate:String,
                   currentsalary:String,
                   phone:String,
                   email:String,
                   hiredate:String,
                   wantcity:String,
                   wantsalary:String,
                   wantposition:String,
                   description:String,
                   handle:ResponseBlock){
        let url = PARK_URL_Header+"PublishResume"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,
                     "avatar":avatar,
                     "name":name,
                     "experience":experience,
                     "sex":sex,
                     "birthday":birthday,
                     "certificate":certificate,
                     "education":education,
                     "address":address,
                     "jobstate":jobstate,
                     "currentsalary":currentsalary,
                     "phone":phone,
                     "email":email,
                     "hiredate":hiredate,
                     "wantcity":wantcity,
                     "wantsalary":wantsalary,
                     "wantposition":wantposition,
                     "description":description,]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            // print(request?.URLString)
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
    
    // 修改简历
    func changeForum(userid:String,
                     avatar:String,
                     name:String,
                     experience:String,
                     sex:String,
                     birthday:String,
                     certificate:String,
                     education:String,
                     address:String,
                     jobstate:String,
                     currentsalary:String,
                     phone:String,
                     email:String,
                     hiredate:String,
                     wantcity:String,
                     wantsalary:String,
                     wantposition:String,
                     description:String,
                     type:Int,//1 发布  2 修改
                     handle:ResponseBlock){
        let url = type == 1 ? PARK_URL_Header+"PublishResume":PARK_URL_Header+"UpdataMyResume"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,
                     "avatar":avatar,
                     "name":name,
                     "experience":experience,
                     "sex":sex,
                     "birthday":birthday,
                     "certificate":certificate,
                     "education":education,
                     "address":address,
                     "jobstate":jobstate,
                     "currentsalary":currentsalary,
                     "phone":phone,
                     "email":email,
                     "hiredate":hiredate,
                     "wantcity":wantcity,
                     "wantsalary":wantsalary,
                     "wantposition":wantposition,
                     "description":description,]
        if type == 1 {
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                // print(request?.URLString)
                if(error != nil){
                    handle(success: false, response: error?.description)
                }else{
                    let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                    if(result.status == "success"){
                        handle(success: true, response: result.data)
                    }else{
                        handle(success: false, response: result.errorData)
                    }
                }
            }
        }else{
            
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                // print(request?.URLString)
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
    }
    
    //获取我的帖子列表
    func getList(userid:String,type:String,isHot:Bool,handle:ResponseBlock){
        let url = PARK_URL_Header+"getbbspostlist"
        var param = ["type":type,"userid":userid]
        if isHot {
            param["ishot"] = "1"
        }
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
    //收藏帖子
    func collectionForum(refid:String,title:String,description:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"addfavorite"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":"4",
            "refid":refid,
            "title":title,
            "description":description
        ];
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            
            if(error != nil){
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "error"){
                    handle(success: false, response: result.errorData)
                }
                if(result.status == "success"){
                    handle(success: true, response:result.data)
                }
            }
            
        }
    }
}
