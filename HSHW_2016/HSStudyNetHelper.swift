//
//  HSStudyNetHelper.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSStudyNetHelper: NSObject {
    //提交考试答案
    class func sendtestAnswerByType(_ type:String,count:String,questionlist:String,answerlist:String,handle:@escaping ResponseBlock){
        let url = PARK_URL_Header+"SubmitAnswers"
        let param = [
            "type":type,
            "count":count,
            "questionlist":questionlist,
            "answerlist":answerlist,
            "userid":QCLoginUserInfo.currentInfo.userid
        ]
//        print(param)
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            print(request?.URLString)
            if(error != nil){
                handle(false, error?.localizedDescription as AnyObject?)
            }else{
                let model =  ScoreModel(JSONDecoder(json!))
                if(model.status == "success"){
//                    let result = model.data!.allscore
                    handle(true, model.data)
                }else{
                    handle(false, error as AnyObject?)
                }
            }
        }
    }
}
