//
//  HSMineHelper.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSMineHelper: NSObject {
    //获取个人资料
    func getPersonalInfo(_ handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = LoginUserInfoModel(JSONDecoder(json!))
                // print("状态是")
                // print(result.status)
                if(result.status == "success"){
                    QCLoginUserInfo.currentInfo.avatar = result.data?.user_avatar ?? ""
                    QCLoginUserInfo.currentInfo.userName = result.data?.user_name ?? ""
                    QCLoginUserInfo.currentInfo.level = result.data?.user_level ?? ""
                    QCLoginUserInfo.currentInfo.sex = result.data!.user_sex 
                    QCLoginUserInfo.currentInfo.fansCount = result.data?.user_fanscount ?? "0"
                    QCLoginUserInfo.currentInfo.attentionCount = result.data?.user_followcount ?? "0"
                    QCLoginUserInfo.currentInfo.score = result.data?.user_score ?? "0"
                    QCLoginUserInfo.currentInfo.birthday = result.data?.user_birthDay ?? ""
                    QCLoginUserInfo.currentInfo.realName = result.data?.user_realname ?? ""
                    QCLoginUserInfo.currentInfo.phoneNumber = result.data?.user_phone ?? ""
                    QCLoginUserInfo.currentInfo.qqNumber = result.data?.user_qq ?? ""
                    QCLoginUserInfo.currentInfo.weixinNumber = result.data?.user_weixin ?? ""
                    QCLoginUserInfo.currentInfo.time = result.data?.user_time ?? ""
                    QCLoginUserInfo.currentInfo.money = result.data?.user_money ?? "0"
                    QCLoginUserInfo.currentInfo.address = result.data?.user_address ?? ""
                    QCLoginUserInfo.currentInfo.email = result.data?.user_email_2 ?? ""
                    QCLoginUserInfo.currentInfo.school = result.data?.user_school_2 ?? ""
                    QCLoginUserInfo.currentInfo.major = result.data?.user_major_2 ?? ""
                    QCLoginUserInfo.currentInfo.education = result.data?.user_education_2 ?? ""
                    QCLoginUserInfo.currentInfo.usertype = result.data?.user_usertype ?? ""
                    QCLoginUserInfo.currentInfo.all_information = result.data?.all_information ?? ""
                    // print("=-=-=-=-=-=-"+String(QCLoginUserInfo.currentInfo.email))
                    handle(true, nil)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改昵称
    func changeUserName(_ niceName:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserName"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"nicename":niceName
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    
                    if result.errorData == "Name repetition" {
                        handle(false, "用户名重复" as AnyObject?)
                    }else{
                        
                        self.getPersonalInfo({ (success, response) in
                            
                        })
                        handle(true, result.data)
                    }
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }

    }
    //修改真实姓名
    func changeUserRealName(_ realName:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserRealName"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"realname":realName
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
        
    }
    //上传图片
    func uploadImageWithData(_ imageData:Data,imageName:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"uploadavatar"
        let param = ["POST":imageData]
        NurseUtil.net.request(RequestType.requestTypePost, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//        Alamofire.request(.POST, url, parameters: param).response { request, response, json, error in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, nil)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改头像
    func changeUserAvatar(_ avatar:String,handle:@escaping ResponseBlock) {
        let url = PARK_URL_Header+"UpdateUserAvatar"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"avatar":avatar
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改性别
    func changeUserSex(_ sex:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserSex"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"sex":sex
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改手机号
    func changePhoneNumber(_ phoneNumber:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserPhone"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"phone":phoneNumber
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改邮箱
    func changeEmail(_ email:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserEmail"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"email":email
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改生日
    func changeBirthday(_ birthday:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserBirthday"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "birthday":birthday
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改地址
    func changeAddress(_ address:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserAddress"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"address":address
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改学校
    func changeSchool(_ school:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserSchool"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"school":school
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改专业
    func changeMajor(_ major:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserMajor"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"major":major
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    //修改学历
    func changeEducation(_ education:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserEducation"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"education":education
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = addScore_ReadingInformationModel(JSONDecoder(json!))
                if(result.status == "success"){
                    self.getPersonalInfo({ (success, response) in
                        
                    })
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    // 获取粉丝列表 type 1 粉丝  !=1  关注
    func getFansOrFollowList(_ type:Int,handle:@escaping ResponseBlock){
        
        let url:String
        
        if type == 1 {
            url = PARK_URL_Header+"getMyFansList"
        }else{
            url = PARK_URL_Header+"getMyFollowList"
        }
        
        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = HSMineList(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, result.datas as AnyObject?)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    // 关注/收藏 type:1、新闻、2考试,4论坛贴子,5招聘,6用户
    func addFavorite(_ userid:String,refid:String,type:String,title:String,description:String,handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"addfavorite"
        
        let param = ["userid":userid,"refid":refid,"type":type,"title":title,"description":description];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, nil)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    // 取消关注/取消收藏 type:1、新闻、2考试,4论坛贴子,5招聘,6用户
    func cancelFavorite(_ userid:String,refid:String,type:String,handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"cancelfavorite"
        
        let param = ["userid":userid,"refid":refid,"type":type];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request?.URLString)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, nil)
                }else{
                    handle(false, result.errorData as AnyObject?)
                }
            }
        }
    }
    
    func getPersonalInfo_2(_ userid:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":userid
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = HSMineList(JSONDecoder(json!))
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
    
    //获取收藏列表 type: 1 新闻 , 2 考试, 4 贴子
    func getCollectionInfoWithType(_ type:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getfavoritelist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":type
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(true, JSONDecoder(json!))
                }else{
                    handle(false, "error" as AnyObject?)
                }
            }
        }
    }
    
    // 获取做题记录 type 1 每日一练 2 在线考试
    func GetExampaper(_ userid:String, type:String, handle:@escaping ResponseBlock){
//        let user = NSUserDefaults.standardUserDefaults()
//        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"GetExampaper"
        
        let param = ["userid":userid,"type":type];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = HSGTestModel(JSONDecoder(json!))
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
    
    // 获取错题集 type 1 每日一练 2 在线考试
    func GetErrorExampaper(_ userid:String, type:String, handle:@escaping ResponseBlock){
        //        let user = NSUserDefaults.standardUserDefaults()
        //        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"GetMyErrorExampaper"
        
        let param = ["userid":userid,"type":type];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = GHSErrorExamModel(JSONDecoder(json!))
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
    
    // 获取收藏试题
    func GetCollectList(_ userid:String, type:String, handle:@escaping ResponseBlock){
    
        let url = PARK_URL_Header+"getfavoritelist"
        
        let param = ["userid":userid,"type":type];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = CollectModel(JSONDecoder(json!))
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


    // 获取用户信息
    func getUserInfo(_ userid:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":userid
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = HSUserInfoModel(JSONDecoder(json!))
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

    //获取收藏记录列表 
    func getCollectionInfoWith(_ type:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getfavoritelist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":type
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = HSErrorExamModel(JSONDecoder(json!))
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
    
    // MARK: 发布企业认证
    func updataCompanyCertifyWith(_ companyname:String, companyinfo:String, create_time:String, phone:String, email:String, linkman:String, license:String, handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"UpdataCompanyCertify"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "companyname":companyname,
            "companyinfo":companyinfo,
            "create_time":create_time,
            "phone":phone,
            "email":email,
            "linkman":linkman,
            "license":license
            
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let status = HSStatusModel(JSONDecoder(json!))

                if(status.status == "success"){
                    handle(true, nil)
                }else{
                    handle(false, nil)
                }
//                do {
//                    
////                    let result = try NSJSONSerialization.JSONObjectWithData(json!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
//                    // print("状态是")
//                    // print(result["status"])
//                   
//                }catch{
//                    handle(success: false, response: "json解析异常")
//                    
//                }

//                let result = Http(JSONDecoder(json!))
//                // print("状态是")
//                // print(result.status)
//                if(result.status == "success"){
//                    handle(success: true, response: result.data)
//                }else{
//                    handle(success: false, response: result.errorData)
//                }
            }
            
        }
    }
    
    // MARK: 获取企业认证状态
    func getCompanyCertify(_ handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"getCompanyCertify"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, "获取企业认证状态失败" as AnyObject?)
            }else{
                let result = CompanyInfoStatus(JSONDecoder(json!))
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.data)
                }else{
                    let dic = ["status":"0"]
                    let model:CompanyInfo = CompanyInfo.init(JSONDecoder(dic as AnyObject))
                    
                    handle(true, model)
                }
//
//                do {
//                    
//                    let result = try NSJSONSerialization.JSONObjectWithData(json!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
//                    // print("状态是")
//                    // print(result["status"])
//                    if(String(result["status"]!) == "success"){
//                        handle(success: true, response: String((result["data"]!["status"]!)!))
//                    }else{
//                        handle(success: false, response: String((result["data"]!["status"]!)!))
//                    }
//                }catch{
//                    handle(success: false, response: "json解析异常")
//
//                }
            }
        }
    }
    
    // MARK: 获取积分排行榜
    func getRankingList(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"getRankingList"
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: nil) { (json, error) in


//        Alamofire.request(.GET, url).response { (request, response, json, error) in
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = RankList(JSONDecoder(json!))
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }else{
                    handle(false, "获取积分排行榜失败" as AnyObject?)
                }
            }
        }
    }
    
    // MARK: 获取个人积分详情
    func getRanking_User(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"getRanking_User"
        
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            ];
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { (request, response, json, error) in
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let result = Ranking_User(JSONDecoder(json!))
                // print(result.status)
                if(result.status == "success"){
                    handle(true, result.data as AnyObject?)
                }else{
                    handle(false, "获取个人积分详情失败" as AnyObject?)
                }
            }
        }
    }
    
//    // 获取得分数据
//    func GetMyExamData(handle:ResponseBlock){
//        
//        let url = PARK_URL_Header+"GetMyExamData"
//        
//        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
//        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
//            // print(request)
//            if(error != nil){
//                handle(success: false, response: error?.localizedDescription)
//            }else{
//                
//                let result = examData(JSONDecoder(json!))
//                // print("状态是")
//                // print(result.status)
//                if(result.status == "success"){
//                    handle(success: true, response: result.datas)
//                }else{
//                    handle(success: false, response: result.errorData)
//                }
//            }
//        }
//    }
    
    // 获取折线图数据
    func GetLineChartData(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"GetLineChartData"
        
        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = LineChartData(JSONDecoder(json!))
                
                if(result.status == "success"){
                    handle(true, result.data)
                }else{
                    handle(false, nil)
                }
            }
        }
    }
    
    // 获取综合正确率
    func getSynAccuracy(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"getSynAccuracy"
        
        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = SynAccuracy(JSONDecoder(json!))
                
                if(result.status == "success"){
                    handle(true, result.data)
                }else{
                    handle(false, nil)
                }
            }
        }
    }
    
    // 意见反馈
    func addfeedback(_ content:String, devicestate:String, handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"addfeedback"
        
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "content":content,
            "devicestate":devicestate
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
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
    
    // 获取已意见反馈 包括系统回复列表
    func getfeedbackList(_ handle:@escaping ResponseBlock){
        
        let url = PARK_URL_Header+"getfeedbackList"
        
        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                
                let result = Http(JSONDecoder(json!))
                
                if(result.status == "success"){
                    
                    let feedbackList = FeedbackList(JSONDecoder(json!))
                    handle(true, feedbackList.data as AnyObject?)
                }else{
                    handle(false, nil)
                }
            }
        }
    }
}
