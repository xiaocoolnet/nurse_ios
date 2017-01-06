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
    //入参：userid,term_id(父类的分类id,全部则传0),best(选精1,不0),hot(热门1,不0),pager 分页,sort(不传或传0：智能排序，传1：圈子关注度，传2：圈子帖子量)
    //出参：id,community_name 圈子名称,photo圈子头像,description圈子介绍,best(是否精选),create_time 创建时间,hot 是否热门,term_id 圈子类型id,term_name圈子类型名称,f_count 帖子数量,person_num 人数,join(是否加入该圈子 1已加入，0未加入)
    //Demo:http:/nurse.xiaocool.net/index.php?g=apps&m=index&a=getCommunityList
    class func getCommunityList(userid:String, term_id:String, best:String, hot:String, pager:String, sort:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getCommunityList"
        let param = [
            "userid":userid,
            "term_id":term_id,
            "best":best,
            "hot":hot,
            "pager":pager,
            "sort":sort
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
    //入参：cid(圈子的id),userid,isbest(选精1,不0),istop(置顶1,不0),pager 分页,title 搜索标题
    //出参：id(帖子id),community_id(圈子的id),userid,title标题,create_time,content内容,description介绍,review_time(回复时间),photo帖子图片,hits点击数,like_num 点赞数,istop是否置顶,isbest是否精华,isreward是否打赏,user_photo(用户头像),level(用户的等级),comments_count评论数量,add_like判断我是否点赞,community_name(圈子名称),community_photo(圈子照片),c_master(发帖人是否是圈主:1是,0不),user_name,auth_type(认证类型)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getForumList&cid=1
    class func getForumList(userid:String, cid:String, isbest:String, istop:String, pager:String, title:String="", handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getForumList"
        let param = [
            "userid":userid,
            "cid":cid,
            "isbest":isbest,
            "istop":istop,
            "pager":pager,
            "title":title
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
    
    // MARK: - 申请圈主
    //接口地址：a=apply_community
    //入参：c_name(圈子名称),userid,real_name(真实姓名),real_code(身份证号),real_address(联系地址),real_tel(手机号),real_qq(qq),real_content(申请感言),real_photo(个人日志生活照),real_photo_2(手持身份证照片)
    //出参：无
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=apply_community&userid=603&c_name=ddd
    class func apply_community(c_name:String, userid:String, real_name:String, real_code:String, real_address:String, real_tel:String, real_qq:String, real_content:String, real_photo:String, real_photo_2:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"apply_community"
        let param = [
            "c_name":c_name,
            "userid":userid,
            "real_name":real_name,
            "real_code":real_code,
            "real_address":real_address,
            "real_tel":real_tel,
            "real_qq":real_qq,
            "real_content":real_content,
            "real_photo":real_photo,
            "real_photo_2":real_photo_2
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
    
    // MARK: - 获取贴子详情
    //接口地址：a=getForumInfo
    //入参：userid,tid
    //出参：tid,community_id,userid(发贴人id),title,create_time,content,description,status(贴子状态 0审核拒绝，1通过),review_time审核时间,photo,hits点击数,like点赞数,istop,isbest,isreward(是否打赏 1显示，0不),add_like(判断我是否点赞),favorites(收藏数量),favorites_add(判断我是否收藏)
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
    //入参：userid,cid,title,content,description,photo,address
    //出参：data
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=PublishForum&userid=603&cid=1
    class func PublishForum(userid:String, cid:String, title:String, content:String, description:String, photo:String, address:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"PublishForum"
        let param = [
            "userid":userid,
            "cid":cid,
            "title":title,
            "content":content,
            "description":description,
            "photo":photo,
            "address":address
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
    
    // MARK: - 删除贴子
    //接口地址：a=DeleteForum
    //入参：tid 贴子id
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
    //入参：userid,t_id(帖子id或评论id),score,type(1帖子，2评论)
    //出参：userid,t_id,score,create_time
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addReport&userid=603&t_id=1&score=10&type=1
    class func addReport(userid:String, t_id:String, score:String, type:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addReport"
        let param = [
            "userid":userid,
            "t_id":t_id,
            "score":score,
            "type":type
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
    //出参：id,community_name 圈子名称,photo圈子头像,description圈子介绍,best(是否精选),create_time 创建时间,hot 是否热门,term_id 圈子类型id,term_name圈子类型名称,f_count 贴子数量,person_num 人数,join(是否加入该圈子 1已加入，0未加入)
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
    
    // MARK: - 获取我加入的圈子
    //接口地址：a=getMyCommunityList
    //入参：userid,pager分页从1开始
    //出参：id,community_name 圈子名称,photo圈子头像,description圈子介绍,best(是否精选),create_time 创建时间,hot 是否热门,term_id 圈子类型id,term_name圈子类型名称,f_count 贴子数量,person_num 人数,join(是否加入该圈子 1已加入，0未加入)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getMyCommunityList&userid=603&follow_id=597
    class func getMyCommunityList(userid:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getMyCommunityList"
        let param = [
            "userid":userid,
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

    // MARK: - 获取 我发的贴子
    //接口地址：a=getMyForumList
    //入参：cid(圈子的id),userid,isbest(选精1,不0),istop(置顶1,不0),pager 分页
    //出参：id(贴子id),community_id(圈子的id),userid,title标题,create_time,content内容,description介绍,review_time(回复时间),photo贴子图片,hits点击数,like点赞数,istop是否置顶,isbest是否精华,isreward是否打赏,user_photo(用户头像),level(用户的等级),comments_count评论数量,add_like判断我是否点赞,community_name(圈子名称),community_photo(圈子照片),c_master(发贴人是否是圈主:1是,0不),user_name,auth_type(认证类型)
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getForumList&cid=1
    class func getMyForumList(userid:String, cid:String, isbest:String, istop:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getMyForumList"
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
    
    // MARK: - 发布个人认证
    //接口地址：a=authentication_person
    //入参：userid,auth_type(认证类型 关联字典),auth_company(认证单位),auth_department(工作科室),photo(证件照)
    //出参：成功 ok
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=authentication_person&userid=603
    class func authentication_person(userid:String, auth_type:String, auth_company:String, auth_department:String, photo:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"authentication_person"
        let param = [
            "userid":userid,
            "auth_type":auth_type,
            "auth_company":auth_company,
            "auth_department":auth_department,
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
    
    // MARK: - 获取个人认证状态
    //接口地址：a=getPersonAuth
    //入参：userid
    //出参：userid,auth_type(认证类型 关联字典),auth_company(认证单位),auth_department(工作科室),photo(证件照),status(认证状态 1通过，0拒绝，2认证中),create_time
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getPersonAuth&userid=603
    class func getPersonAuth(userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getPersonAuth"
        let param = [
            "userid":userid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<PersonAuthModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

    // MARK: - 获取 关注 和 粉丝 的数量
    //接口地址：a=getFollowFans_num
    //入参：userid
    //出参：follows_count 关注的数量,fans_count 粉丝数量
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getFollowFans_num&userid=603
    class func getFollowFans_num(userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getFollowFans_num"
        let param = [
            "userid":userid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<FollowFansNumModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

    // MARK: - 添加打赏
    //接口地址：a=addReward
    //入参：to_userid(被打赏用户id),from_userid(发出打赏用户的id),t_id(贴子id),score
    //出参：to_userid,from_userid,t_id,score,create_time
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addReward&from_userid=603&to_userid=597&t_id=1&score=10
    class func addReward(to_userid:String, from_userid:String, t_id:String, score:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addReward"
        let param = [
            "to_userid":to_userid,
            "from_userid":from_userid,
            "t_id":t_id,
            "score":score
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<RewardModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 帖子加精
    //接口地址：a=forumSetBest
    //入参：tid(帖子id)
    //出参：success
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=forumSetBest&tid=1
    class func forumSetBest(tid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"forumSetBest"
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
    
    // MARK: - 帖子置顶
    //接口地址：a=forumSetTop
    //入参：tid(帖子id)
    //出参：success
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=forumSetTop&tid=1
    class func forumSetTop(tid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"forumSetTop"
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
    
    // MARK: - 点赞
    //接口地址：a=SetLike
    //入参：userid,id,type(新闻资讯为1，2圈子)
    //出参：无
    //Demo:http://app.chinanurse.cn/index.php?g=apps&m=index&a=SetLike&userid=599&id=38&type=2
    class func SetLike(userid:String, id:String, type:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"SetLike"
        let param = [
            "userid":userid,
            "id":id,
            "type":type
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<SetLikeModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 取消赞
    //接口地址：a=ResetLike
    //入参：userid,id,type
    //出参：无
    //Demo:http://app.chinanurse.cn/index.php?g=apps&m=index&a=ResetLike&userid=599&id=38&type=2
    class func ResetLike(userid:String, id:String, type:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"ResetLike"
        let param = [
            "userid":userid,
            "id":id,
            "type":type
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
    
    // MARK: - 检测是否点赞
    //接口地址：a=CheckHadLike
    //入参：userid,id,type(新闻资讯为1，2圈子)
    //出参：had/no
    //Demo:http://app.chinanurse.cn/index.php?g=apps&m=index&a=CheckHadLike&userid=614&id=31&type=2
    class func CheckHadLike(userid:String, id:String, type:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"CheckHadLike"
        let param = [
            "userid":userid,
            "id":id,
            "type":type
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

    // MARK: - 添加评论
    //接口地址：a=SetComment
    //入参(post)：userid,id，content,type:,1、新闻2、圈子,3评论,photo
    //出参：无
    //Demo:http://app.chinanurse.cn/index.php?g=apps&m=index&a=SetComment&userid=600&id=4&content=你好&type=2&photo=9.jpg
    class func SetComment(userid:String, id:String, content:String, type:String, photo:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"SetComment"
        let param = [
            "userid":userid,
            "id":id,
            "content":content,
            "type":type,
            "photo":photo
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<SetLikeModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 获取圈子评论
    //接口地址：a=getForumComments
    //入参：userid，refid(圈子id，或父评论id)
    //出参：refid,userid,username,content,photo,add_time,type(评论类型：1新闻，2圈子，3评论),userlevel,major,cid(评论id),auth_type(用户类型名称)
    //Demo:http://app.chinanurse.cn/index.php?g=apps&m=index&a=getForumComments&refid=305&userid=603
    class func getForumComments(userid:String, refid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getForumComments"
        let param = [
            "userid":userid,
            "refid":refid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<ForumCommentsModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 删除帖子评论以及子评论
    //接口地址：a=DelForumComments
    //入参：id(评论id),type(评论类型：2圈子，3评论),userid
    //出参：success
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=DelForumComments&id=70&userid=603&type=3
    class func DelForumComments(id:String, type:String, userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"DelForumComments"
        let param = [
            "id":id,
            "type":type,
            "userid":userid
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
 
    // MARK: - 添加 圈子 关注粉丝
    //接口地址：a=addfollow_fans
    //入参：follow_id(被关注人id,别人的userid),fans_id(关注人id,我的userid)
    //出参：follow_userid,fans_userid,create_time,status
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addfollow_fans&follow_id=603&fans_id=597
    class func addfollow_fans(follow_id:String, fans_id:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addfollow_fans"
        let param = [
            "follow_id":follow_id,
            "fans_id":fans_id
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<Follow_fansModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success" && result.errorData != ""){
                    handle(true, result.data)
                }else{
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 删除 圈子 关注
    //接口地址：a=delFollow_fans
    //入参：follow_id(被关注人id,别人的userid),follow_id(关注人id,我的userid)
    //出参：success
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=delFollow_fans&follow_id=603&follow_id=597
    class func delFollow_fans(follow_id:String, fans_id:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"delFollow_fans"
        let param = [
            "follow_id":follow_id,
            "fans_id":fans_id
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<Follow_fansModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, nil)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

    // MARK: - 判断是否添加关注
    //接口地址：a=judgeFollowFans
    //入参：follow_id(被关注人id),fans_id(关注人id)
    //出参：1:已关注，0:未关注
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=judgeFollowFans&fans_id=603&follow_id=597
    class func judgeFollowFans(follow_id:String, fans_id:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"judgeFollowFans"
        let param = [
            "follow_id":follow_id,
            "fans_id":fans_id
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

    // MARK: - 收藏
    //接口地址：a=addfavorite
    //入参：userid,refid,type:1、新闻、2考试,3其他收藏(学习中的新闻),4论坛帖子,5招聘,6用户,title,description
    //出参：favoriteid
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=addfavorite&userid=578&refid=12&type=1&title=一篇不错的文章或者考试题&description=非常棒的哦
    class func addfavorite(userid:String, refid:String, type:String, title:String, description:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"addfavorite"
        let param = [
            "userid":userid,
            "refid":refid,
            "type":type,
            "title":title,
            "description":description
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
    
    // MARK: - 取消收藏
    //接口地址：a=cancelfavorite
    //入参：userid,refid,type:1、新闻、2考试,4论坛帖子,5招聘,6用户
    //出参：favoriteid
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=cancelfavorite&userid=578&refid=12&type=1
    class func cancelfavorite(userid:String, refid:String, type:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"cancelfavorite"
        let param = [
            "userid":userid,
            "refid":refid,
            "type":type
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
    
    // MARK: - 判断是否是圈子管理员
    //接口地址：a=judge_community_admin
    //入参：userid
    //出参：1是，0不是
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=judge_community_admin&userid=603
    class func judge_community_admin(userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"judge_community_admin"
        let param = [
            "userid":userid
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
    
    // MARK: - 首页图片
    //接口地址：a=getHomePage
    //入参：userid
    //出参：id,photo,create_time,title,description
    //展示方式：http://nurse.xiaocool.net/uploads/microblog/20170103/586b72532acca.png
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getHomePage&userid=603
    class func getHomePage(userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getHomePage"
        let param = [
            "userid":userid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<HomePageModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 获取护士币
    //接口地址：a=getNurse_score
    //入参：userid
    //出参：score
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getNurse_score&userid=603
    class func getNurse_score(userid:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getNurse_score"
        let param = [
            "userid":userid
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

    // MARK: - 获取我评价的帖子
    //接口地址：a=getMyJudgeCommunity
    //入参：userid,pager
    //出参：list
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getMyJudgeCommunity&userid=603
    class func getMyJudgeCommunity(userid:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getMyJudgeCommunity"
        let param = [
            "userid":userid,
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
    
    // MARK: - 获取圈子粉丝列表（谁关注了我，我是被关注人） type 1 关注 2 粉丝
    //接口地址：a=getFansList
    //入参：userid被关注人id
    //出参：fid(关注人id),ffs_time(关注时间),name,sex,photo,score,level
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getFansList&userid=603
    class func getFansFollowList(userid:String, type:String, handle:@escaping ResponseClouse) {
        
        var url = ""

        if type == "1" {
            url = PARK_URL_Header+"getFollowList"
        }else{
            url = PARK_URL_Header+"getFansList"
        }

        let param = [
            "userid":userid
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<FansFollowListModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }
    
    // MARK: - 获取我加入的圈子中的帖子列表 以及 我关注的人发的帖子
    //接口地址：a=getFollowForumList
    //入参：userid,pager
    //出参：list
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getFollowForumList&userid=603
    class func getFollowForumList(userid:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getFollowForumList"
        let param = [
            "userid":userid,
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
    
    // MARK: - 获取我的消息（被加精置顶、被评论、被打赏等消息）
    //接口地址：a=getMyMessageList
    //入参：userid,pager
    //出参：list
    //Demo:http://nurse.xiaocool.net/index.php?g=apps&m=index&a=getMyMessageList&userid=603
    class func getMyMessageList(userid:String, pager:String, handle:@escaping ResponseClouse) {
        let url = PARK_URL_Header+"getMyMessageList"
        let param = [
            "userid":userid,
            "pager":pager
        ]
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
            // print(request)
            if(error != nil){
                handle(false, error?.localizedDescription)
            }else{
                
                let result = JSONDeserializer<NewsListModel>.deserializeFrom(dict: json as! NSDictionary?)!
                if(result.status == "success"){
                    handle(true, result.data)
                }else if(result.status == "error"){
                    handle(false, result.errorData)
                }
            }
        }
    }

}
