//
//  NurseUtil.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/10.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import AFNetworking

//创建请求类枚举
enum RequestType: Int {
    case requestTypeGet
    case requestTypePost
    case requestTypeDelegate
}
//关于网络检测枚举
let ReachabilityStatusChangedNotification = "ReachabilityStatusChangedNotification"

enum ReachabilityType: CustomStringConvertible {
    case wwan
    case wiFi
    
    var description: String {
        switch self {
        case .wwan: return "WWAN"
        case .wiFi: return "WiFi"
        }
    }
}

enum ReachabilityStatus: CustomStringConvertible  {
    case offline
    case online(ReachabilityType)
    case unknown
    
    var description: String {
        switch self {
        case .offline: return "Offline"
        case .online(let type): return "Online (\(type))"
        case .unknown: return "Unknown"
        }
    }
}
enum ResultType {
    case success
    case failure
}

//创建一个闭包(注:oc中block)
typealias sendVlesClosure = (AnyObject?, NSError?)->Void
typealias uploadClosure = (AnyObject?, NSError?,Int64?,Int64?,Int64?)->Void
class NurseUtil: NSObject {
    
    static let net = NurseUtil()
    
    private let sessionManager = AFHTTPSessionManager()
    
    //网络请求中的GET,Post,DELETE
    func request(type:RequestType ,URLString:String, Parameter:[String:AnyObject]?, block: sendVlesClosure) {
        
        sessionManager.responseSerializer = AFHTTPResponseSerializer()
        
        switch type {
        case .requestTypeGet:
            
            sessionManager.GET(URLString, parameters: Parameter, progress: { (progress) in
                
                }, success: { (task, responseObject) in
                    let data = responseObject as! NSData
                    
                    do {
                        let dic = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                        
                        block(dic as AnyObject?,nil)
                        
                    }catch {
                        print("json 解析失败")
                        block(nil,nil)
                        
                    }
                }, failure: { (task, error) in
                    block(nil,error)
            })
            
            
//            sessionManager.get(URLString, parameters: Parameter, progress: { (progress) in
//                
//                }, success: { (task, responseObject) in
//                    
//                    let data = responseObject as! Data
//                    
//                    do {
//                        let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                        
//                        block(dic as AnyObject?,nil)
//                        
//                    }catch {
//                        print("json 解析失败")
//                        
//                        block(nil,error)
//                        
//                    }
//                    
//                }, failure: { (task, error) in
//                    
//                    block(nil,error)
//                    
//            })
            
            
            //            Alamofire.request(URLString, method: .get, parameters: Parameter).responseJSON(completionHandler: { (response) in
            //                block(response.result.value as AnyObject?,nil)
            //                //把得到的JSON数据转为字典
            //            })
            
        case .requestTypePost:
            sessionManager.POST(URLString, parameters: Parameter, progress: { (progress) in
                
                }, success: { (task, responseObject) in
                    let data = responseObject as! NSData
                    
                    do {
                        let dic = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                        
                        block(dic as AnyObject?,nil)
                        
                    }catch {
                        print("json 解析失败")
                        block(nil,nil)
                        
                    }
                }, failure: { (task, error) in
                    block(nil,error)
            })
//            sessionManager.post(URLString, parameters: Parameter, progress: { (progress) in
//                
//                }, success: { (task, responseObject) in
//                    let data = responseObject as! Data
//                    
//                    do {
//                        let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
//                        
//                        block(dic as AnyObject?,nil)
//                        
//                    }catch {
//                        print("json 解析失败")
//                        
//                        block(nil,error)
//                        
//                    }
//                    
//                }, failure: { (task, error) in
//                    
//                    block(nil,error)
//                    
//            })
            
        default: break
            
        }
        
    }
    
    //关于文件上传的方法
    //fileURL实例:let fileURL = NSBundle.mainBundle().URLForResource("Default",withExtension: "png")
    //    func upload(_ type:RequestType,URLString:String,fileURL:URL,block:uploadClosure) {
    //
    //
    //
    //
    //    }
    
    func uploadWithPOST(URLString:String,data: NSData, name: String, fileName: String, mimeType: String,block: (resultType:ResultType) -> Void) {
        
        let request = AFHTTPRequestSerializer().multipartFormRequestWithMethod("POST", URLString: URLString, parameters: nil, constructingBodyWithBlock: { (formData) in
            formData.appendPartWithFileData(data, name: name, fileName: fileName, mimeType: mimeType)
            }, error: nil)
        
//        let request = AFHTTPRequestSerializer().multipartFormRequest(withMethod: "POST", urlString: URLString, parameters: nil, constructingBodyWith: { (formData) in
//            formData.appendPart(withFileData: data, name: name, fileName: fileName, mimeType: mimeType)
//            }, error: nil)
        //        let manager = AFURLSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = (NSSet(object: "image/jpeg") as! Set<String>)
        
        let uploadTask = manager.uploadTaskWithStreamedRequest(request, progress: { (progress) in
            
        }) { (response, responseObject, error) in
            
            if (error == nil) {
                
                block(resultType: .success)
                
            }else{
                
                block(resultType: .failure)
                
            }
            
        }
//        let uploadTask = manager.uploadTask(withStreamedRequest: request as URLRequest, progress: { (uploadProgress) in
//            
//            
//        }) { (response, responseObject, error) in
//            
//            if (error == nil) {
//                
//                block(.success)
//                
//            }else{
//                
//                block(.failure)
//                
//            }
//            
//        }
        
        
        uploadTask.resume()
        
        
        
        //        Alamofire.upload(multipartFormData: { (multipartFormData) in
        //
        //            multipartFormData.append(data, withName: name, fileName: fileName, mimeType: mimeType)
        //
        //            }, to: URLString) { (response) in
        //                switch response {
        //                case .success(request: _, streamingFromDisk: _, streamFileURL: _):
        //                    block(.success)
        //
        //                case .failure(_):
        //                    block(.failure)
        //
        //                }
        //        }
        
    }
    
    //检测网络
    
    //下面是关于网络检测的方法
    func isWifi() -> Bool {
        
        return (NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)!

        
    }
    
    
}
