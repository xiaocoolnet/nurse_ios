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
                    QCLoginUserInfo.currentInfo.fansCount = result.data?.user_fanscount ?? "0"
                    QCLoginUserInfo.currentInfo.attentionCount = result.data?.user_score ?? "0"
                    QCLoginUserInfo.currentInfo.money = result.data?.user_money ?? "0"
                    QCLoginUserInfo.currentInfo.city = result.data?.user_city ?? ""
                    QCLoginUserInfo.currentInfo.email = result.data?.user_email ?? ""
                    QCLoginUserInfo.currentInfo.school = result.data?.user_school ?? ""
                    QCLoginUserInfo.currentInfo.major = result.data?.user_major ?? ""
                    QCLoginUserInfo.currentInfo.education = result.data?.user_education ?? ""
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
            "userid":QCLoginUserInfo.currentInfo.userid,"birthday":birthday
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
}
