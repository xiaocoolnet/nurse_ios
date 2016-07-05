//
//  HSStudyNetHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class HSStudyNetHelper: NSObject {
    //提交考试答案
    func sendtestAnswerByType(type:String,count:String,questionlist:String,answerlist:String,handle:ResponseBlock){
        let url = PARK_URL_Header+"SubmitAnswers"
        let param = [
            "type":type,"count":count,"questionlist":questionlist,"answerlist":answerlist,"userid":QCLoginUserInfo.currentInfo.userid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                handle(success: false, response: error?.description)
            }else{
                let model =  Http(JSONDecoder(json!))
                if(model.status == "success"){
                    let result = model.data
                    handle(success: true, response: result)
                }else{
                    handle(success: false, response: nil)
                }
            }
        }
    }
}