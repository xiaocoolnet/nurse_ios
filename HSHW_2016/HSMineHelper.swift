//
//  HSMineHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class HSMineHelper: NSObject {
    
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
                    handle(success: true, response: nil)
                }else{
                    handle(success: false, response: result.errorData)
                }
            }
        }
    }
}
