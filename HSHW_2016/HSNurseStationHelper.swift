//
//  HSNurseStationHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/24.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSNurseStationHelper: NSObject {
    //获取职位列表
    func getJobList(_ address:String, salary:String, jobtype:String, pager:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getjoblist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "address":address,
            "salary":salary == "不限" ? "":salary,
            "jobtype":jobtype == "不限" ? "":jobtype,
            "pager":pager
        ]
//        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = HSJobListModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.datas as AnyObject?)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    //发布招聘信息
    func publishJob(_ companyname:String,companyinfo:String,linkman:String,phone:String,email:String,title:String,jobtype:String,education:String,experience:String,welfare:String,address:String,count:String,salary:String,description:String, handle:@escaping ResponseBlock){
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
                     "experience":experience,
                     "welfare":welfare,
                     "address":address,
                     "count":count,
                     "salary":salary,
                     "description":description]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                // print(request?.URLString)
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, nil)
                   
                }else{
                    handle(false, nil)
                  
                }
            }
        }
    }
    
    //获取简历列表
    func getCVList(_ education:String, experience:String, certificate:String, pager:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getResumeList"
        
        var param = [
            "education":education == "不限" ? "":education,
            "experience":experience == "不限" ? "":experience,
            "certificate":certificate == "不限" ? "":certificate,
            "pager":pager
        ]
        
        param["experience"] = param["experience"]?.components(separatedBy: "-").first
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = HSCVListModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.datas as AnyObject?)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    //获取简历
    func getResumeInfo(_ userid:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getResumeInfo"
        let param = [
            "userid":userid
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = GCVModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.datas)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    // 判断是否已投递
    func ApplyJob_judge(_ userid:String, companyid:String, jobid:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"ApplyJob_judge"
        let param = [
            "userid":userid,
            "companyid":companyid,
            "jobid":jobid
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    // 判断是否已邀请
    func InviteJob_judge(_ userid:String, companyid:String, jobid:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"InviteJob_judge"
        let param = [
            "userid":userid,
            "companyid":companyid,
            "jobid":jobid
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    //获取资讯文章列表
    func getArticleListWithID(_ articleid:String, pager:String = "", handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":articleid,
            "pager":pager
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let model =  NewsModel(JSONDecoder(json!))
                if(model.status == "success"){
                    let result = NewsList(model.data!)
                    // print("状态是")
                    // print(result.status)
                    handle(true, result.objectlist as AnyObject?)
                }else{
                    handle(false, model.errorData as AnyObject?)
                }
            }
        }
    }
    
    //添加评论
    func setComment(_ id:String,content:String,type:String,photo:String, handle:@escaping ResponseBlock){
        
//        http://app.chinanurse.cn/index.php?g=apps&m=index&a=SetComment&userid=600&id=4&content=你好&type=2&photo=9.jpg
        let url = PARK_URL_Header+"SetComment"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid,"id":id,"content":content,"type":type,"photo":photo]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            
            // print(request?.URLString)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, result.data)
                }else{
                    handle(false, nil)
                }
            }
        }
    }
    
    // 发布简历
    func postForum(_ userid:String,
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
                   handle:@escaping ResponseBlock){
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
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request?.URLString)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, nil)
                }else{
                    handle(false, nil)
                }
            }
        }
    }
    
    // 修改简历
    func changeForum(_ userid:String,
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
                     handle:@escaping ResponseBlock){
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
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                // print(request?.URLString)
                if(error != nil){
                    handle(false, error?.localizedDescription as AnyObject?)
                }else{
                    let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                    if(result.status == "success"){
                        handle(true, result.data)
                    }else{
                        handle(false, result.errorData as AnyObject?)
                    }
                }
            }
        }else{
            
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                // print(request?.URLString)
                if(error != nil){
                    handle(false, error?.localizedDescription as AnyObject?)
                }else{
                    let result = Http(JSONDecoder(json!))
                    if(result.status == "success"){
                        handle(true, nil)
                    }else{
                        handle(false, nil)
                    }
                }
            }
        }
    }
    
    //获取我的帖子列表
    func getList(_ userid:String,type:String,isHot:Bool,handle:ResponseBlock){
//        let url = PARK_URL_Header+"getbbspostlist"
//        var param = ["type":type,"userid":userid]
//        if isHot {
//            param["ishot"] = "1"
//        }
//        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
//            if(error != nil){
//                handle(success: false, response: error?.localizedDescription)
//            }else{
//                let result = ForumlistModel(JSONDecoder(json!))
//                if(result.status == "success"){
//                    handle(success: true, response: result.datas)
//                }else{
//                    handle(success: false, response: nil)
//                }
//            }
//        }
    }
    
    // 设置点击量
    // userid，object_id（推送消息的id）,type(1简历，2招聘)
    func setHits(_ object_id:String, type:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"setHits"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "object_id":object_id,
            "type":type
        ];
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            
            if(error != nil){
                handle(false, nil)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "error"){
                    handle(false, nil)
                }
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }
            }
            
        }
    }
}
