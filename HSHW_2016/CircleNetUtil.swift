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

    // MARK: - 获取圈子分类列表
    //接口地址：a=getChannellist
    //入参：parentid(新闻的parentid=1,出国的parentid=2)
    //出参：list
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getChannellist&parentid=1
    class func getChannellist(parentid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getChannellist"
        let param = [
            "parentid":parentid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<CommunityCateModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

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
    
    // MARK: - 取消 加入圈子
    //接口地址：a=delJoinCommunity
    //入参：userid,cid
    //出参：无
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=delJoinCommunity&userid=603&cid=1
    class func delJoinCommunity(userid:String, cid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"delJoinCommunity"
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
    
    // MARK: - 获取帖子详情
    //接口地址：a=getForumInfo
    //入参：userid,tid
    //出参：tid,community_id,userid(发帖人id),title,create_time,content,description,status(帖子状态 0审核拒绝，1通过),review_time审核时间,photo,hits点击数,like点赞数,istop,isbest,isreward(是否打赏 1显示，0不),add_like(判断我是否点赞),favorites(收藏数量),favorites_add(判断我是否收藏)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getForumInfo&userid=603&tid=1
    class func getForumInfo(userid:String, tid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getForumInfo"
        let param = [
            "userid":userid,
            "tid":tid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<ForumInfoModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 发布帖子
    //接口地址：a=PublishForum
    //入参：userid,cid,title,content,description,photo
    //出参：data
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=PublishForum&userid=603&cid=1
    class func PublishForum(userid:String, cid:String, title:String, content:String, description:String, photo:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"PublishForum"
        let param = [
            "userid":userid,
            "cid":cid,
            "title":title,
            "content":content,
            "description":description,
            "photo":photo
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
    
    // MARK: - 删除帖子
    //接口地址：a=DeleteForum
    //入参：tid 帖子id
    //出参：无
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=DeleteForum&tid=3
    class func DeleteForum(tid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"DeleteForum"
        let param = [
            "tid":tid
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
    
    // MARK: - 添加举报
    //接口地址：a=addReport
    //入参：userid,t_id(帖子id),score
    //出参：userid,t_id,score,create_time
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addReport&userid=603&t_id=1&score=10
    class func addReport(userid:String, t_id:String, score:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addReport"
        let param = [
            "userid":userid,
            "t_id":t_id,
            "score":score
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
    
    // MARK: - 选择发布圈子
    //接口地址：a=getPublishCommunity
    //入参：userid,parentid
    //出参：term_id(分类id),name(分类名称),community[id(圈子id),community_name(圈子名称)]
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getPublishCommunity&parentid=27
    class func getPublishCommunity(userid:String, parentid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getPublishCommunity"
        let param = [
            "userid":userid,
            "parentid":parentid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<PublishCommunityModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

    // MARK: - 获取圈子详情
    //接口地址：a=getCommunityInfo
    //入参：userid,cid 圈子id
    //出参：id,community_name 圈子名称,photo圈子头像,description圈子介绍,best(是否精选),create_time 创建时间,hot 是否热门,term_id 圈子类型id,term_name圈子类型名称,f_count 帖子数量,person_num 人数,join(是否加入该圈子 1已加入，0未加入)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getCommunityInfo&userid=603&cid=1
    class func getCommunityInfo(userid:String, cid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getCommunityInfo"
        let param = [
            "userid":userid,
            "cid":cid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<CommunityInfoModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
}
