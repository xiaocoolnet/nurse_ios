//
//  CircleNetUtil.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import HandyJSON

typealias ResponseClouse = (_ success:Bool,_ response:Any?)->Void

class CircleNetUtil: NSObject {

    // MARK: - 获取圈子列表
    //接口地址：a=getCommunityList
    //入参：userid,term_id(父类的分类id,全部则传0),best(选精1,不0),hot(热门1,不0),pager 分页
    //出参：id,community_name 圈子名称,photo圈子头像,description圈子介绍,best(是否精选),create_time 创建时间,hot 是否热门,term_id 圈子类型id,term_name圈子类型名称,f_count 帖子数量,person_num 人数,join(是否加入该圈子 1已加入，0未加入)
    //Demo:http:/nurse.xiaocool.net/index.php?g=apps&m=index&a=getCommunityList
    class func getCommunityList(userid:String, term_id:String, best:String, hot:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getCommunityList"
        let param = [
            "userid":userid,
            "term_id":term_id,
            "best":best,
            "hot":hot,
            "pager":pager
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<CommunityListModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 获取帖子列表
    //接口地址：a=getForumList
    //入参：cid(圈子的id),userid,isbest(选精1,不0),istop(置顶1,不0),pager 分页
    //出参：id(帖子id),community_id(圈子的id),userid,title标题,create_time,content内容,description介绍,review_time(回复时间),photo帖子图片,hits点击数,like点赞数,istop是否置顶,isbest是否精华,isreward是否打赏,user_photo(用户头像),level(用户的等级),comments_count评论数量,add_like判断我是否点赞,term_id(对应的圈子的分类id),term_name(对应的圈子的分类名称),c_master(发帖人是否是圈主:1是,0不)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getForumList&cid=1
    class func getForumList(userid:String, cid:String, isbest:String, istop:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getForumList"
        let param = [
            "userid":userid,
            "cid":cid,
            "isbest":isbest,
            "istop":istop,
            "pager":pager
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<ForumListModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    // MARK: - 获取圈主列表
    //接口地址：a=getMasterList
    //入参：userid,cid(圈子id),pager 分页
    //出参：userid,community_id(圈子id),power,create_time,user_name(圈主的姓名),user_photo(圈主的头像)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getMasterList&userid=603&cid=1
    class func getMasterList(userid:String, cid:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getMasterList"
        let param = [
            "userid":userid,
            "cid":cid,
            "pager":pager
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<MasterListModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 判断是否为圈主
    //接口地址：a=judge_apply_community
    //入参：userid,cid(圈子id)
    //出参：成功 yes
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=judge_apply_community&userid=603&cid=1
    class func judge_apply_community(userid:String, cid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"judge_apply_community"
        let param = [
            "userid":userid,
            "cid":cid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<JudgeMasterModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, nil)
                }
            }
        }
    }
    
    // MARK: - 判断是否加入圈子
    //接口地址：a=judge_Community
    //入参：userid,cid
    //出参：userid,community_id,power,create_time
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=judge_Community&userid=603&cid=1
    class func judge_Community(userid:String, cid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"judge_Community"
        let param = [
            "userid":userid,
            "cid":cid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<JudgeCommunityModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    if result.errorData == "" {
                        handle(true, result.data)
                    }else{
                        handle(true, result.errorData)
                    }
                }else if(result.status == "error"){
                    handle(false, nil)
                }
            }
        }
    }
    
    // MARK: - 加入圈子
    //接口地址：a=addCommunity
    //入参：userid,cid
    //出参：success
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addCommunity&userid=603&cid=1
    class func addCommunity(userid:String, cid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addCommunity"
        let param = [
            "userid":userid,
            "cid":cid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<JudgeMasterModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.data)
                }
            }
        }
    }

}
