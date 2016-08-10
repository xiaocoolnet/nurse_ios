//
//  HSMineHelper.swift
//  HSHW_2016
//  Created by xiaocool on 16/6/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class HSMineHelper: NSObject {
    //获取个人资料
    func getPersonalInfo(handle:ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = LoginUserInfoModel(JSONDecoder(json!))
                print("状态是")
                print(result.status)
                if(result.status == "success"){
                    QCLoginUserInfo.currentInfo.avatar = result.data?.user_avatar ?? ""
                    QCLoginUserInfo.currentInfo.userName = result.data?.user_name ?? ""
                    QCLoginUserInfo.currentInfo.level = result.data?.user_level ?? ""
                    QCLoginUserInfo.currentInfo.sex = result.data!.user_sex ?? ""
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
                    QCLoginUserInfo.currentInfo.city = result.data?.user_city ?? ""
                    QCLoginUserInfo.currentInfo.email = result.data?.user_email_2 ?? ""
                    QCLoginUserInfo.currentInfo.school = result.data?.user_school_2 ?? ""
                    QCLoginUserInfo.currentInfo.major = result.data?.user_major_2 ?? ""
                    QCLoginUserInfo.currentInfo.education = result.data?.user_education_2 ?? ""
                    QCLoginUserInfo.currentInfo.usertype = result.data?.user_usertype ?? ""
                    print("=-=-=-=-=-=-"+String(QCLoginUserInfo.currentInfo.email))
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改姓名
    func changeUserName(niceName:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserName"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"nicename":niceName
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }

    }
    //上传图片
    func uploadImageWithData(imageData:NSData,imageName:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"uploadavatar"
        let param = ["POST":imageData]
        Alamofire.request(.POST, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改头像
    func changeUserAvatar(avatar:String,handle:ResponseBlock) {
        let url = PARK_URL_Header+"UpdateUserAvatar"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"avatar":avatar
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改性别
    func changeUserSex(sex:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserSex"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"sex":sex
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改手机号
    func changePhoneNumber(phoneNumber:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserPhone"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"phone":phoneNumber
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改邮箱
    func changeEmail(email:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserEmail"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"email":email
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改生日
    func changeBirthday(birthday:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserBirthday"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "birthday":birthday
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改地址
    func changeAddress(address:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserAddress"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"address":address
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改学校
    func changeSchool(school:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserSchool"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"school":school
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改专业
    func changeMajor(major:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserMajor"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"major":major
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    //修改学历
    func changeEducation(education:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"UpdateUserEducation"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,"education":education
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    // TODO:目前是假的！！！
    // 获取粉丝列表 type 1 粉丝  !=1  关注
    func getFansOrFollowList(type:Int,handle:ResponseBlock){
        
        let url:String
        
        if type == 1 {
            url = PARK_URL_Header+"getMyFansList"
        }else{
            url = PARK_URL_Header+"getMyFollowList"
        }
        
        let param = ["userid":QCLoginUserInfo.currentInfo.userid];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSMineList(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: result.datas)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    // 关注/收藏 type:1、新闻、2考试,4论坛帖子,5招聘,6用户
    func addFavorite(userid:String,refid:String,type:String,title:String,description:String,handle:ResponseBlock){
        
        let url = PARK_URL_Header+"addfavorite"
        
        let param = ["userid":userid,"refid":refid,"type":type,"title":title,"description":description];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    // 取消关注/取消收藏 type:1、新闻、2考试,4论坛帖子,5招聘,6用户
    func cancelFavorite(userid:String,refid:String,type:String,handle:ResponseBlock){
        
        let url = PARK_URL_Header+"cancelfavorite"
        
        let param = ["userid":userid,"refid":refid,"type":type];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
    
    func getPersonalInfo_2(userid:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSMineList(JSONDecoder(json!))
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
    
    //获取收藏列表 type: 1 新闻 , 2 考试, 4 帖子
    func getCollectionInfoWithType(type:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"getfavoritelist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":type
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    handle(success: true, response: JSONDecoder(json!))
                }else{
                    handle(success: false, response: "error")
                }
            }
        }
    }
    
    // 获取做题记录 type 1 每日一练 2 在线考试
    func GetExampaper(userid:String, type:String, handle:ResponseBlock){
//        let user = NSUserDefaults.standardUserDefaults()
//        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"GetExampaper"
        
        let param = ["userid":userid,"type":type];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                
                let result = HSGTestModel(JSONDecoder(json!))
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
    
    // 获取错题集 type 1 每日一练 2 在线考试
    func GetErrorExampaper(userid:String, type:String, handle:ResponseBlock){
        //        let user = NSUserDefaults.standardUserDefaults()
        //        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"GetMyErrorExampaper"
        
        let param = ["userid":userid,"type":type];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                
                let result = GHSErrorExamModel(JSONDecoder(json!))
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
    
    // 获取收藏试题
    func GetCollectList(userid:String, type:String, handle:ResponseBlock){
    
        let url = PARK_URL_Header+"getfavoritelist"
        
        let param = ["userid":userid,"type":type];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                
                let result = CollectModel(JSONDecoder(json!))
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


    // 获取用户信息
    func getUserInfo(userid:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"getuserinfo"
        let param = [
            "userid":userid
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let result = HSUserInfoModel(JSONDecoder(json!))
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

    //获取收藏记录列表 
    func getCollectionInfoWith(type:String, handle:ResponseBlock){
        let url = PARK_URL_Header+"getfavoritelist"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            "type":type
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                
                let result = HSErrorExamModel(JSONDecoder(json!))
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
