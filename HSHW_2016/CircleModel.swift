//
//  CircleModel.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import HandyJSON

// 圈子分类
class CommunityCateModel: HandyJSON {
    var status = ""
    var data = [CommunityCateDataModel]()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}
class CommunityCateDataModel: HandyJSON {
    var term_id = ""
    var name = ""
    
    required init() {}
    
}

// 圈子列表
class CommunityListModel: HandyJSON {
    var status = ""
    var data = [CommunityListDataModel]()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}

// 圈子详情
class CommunityInfoModel: HandyJSON {
    var status = ""
    var data = CommunityListDataModel()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}

class CommunityListDataModel: HandyJSON {
    var id = ""
    var community_name = ""
    var photo = ""
    var description = ""
    var best = ""
    var create_time = ""
    var hot = ""
    var term_id = ""
    var term_name = ""
    var f_count = ""
    var person_num = ""
    var join = ""
    
    required init() {}
}

// 贴子列表
class ForumListModel: HandyJSON {
    var status = ""
    var data = [ForumListDataModel]()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}

class ForumListDataModel: HandyJSON {
    var id = ""// 帖子id
    var community_id = ""// 圈子的id
    var userid = ""
    var title = ""// 标题
    var create_time = ""
    var content = ""// 内容
    var description = ""// 介绍
    var review_time = ""// 回复时间
    var photo = [String]()// 帖子图片
    var hits = ""// 点击数
    var like = ""// 点赞数
    var istop = ""// 是否置顶
    var isbest = ""// 是否精华
    var isreward = ""// 是否打赏
    var user_photo = ""// 用户头像
    var level = ""// 用户的等级
    var comments_count = ""// 评论数量
    var add_like = ""// 判断我是否点赞
    var community_name = ""// 圈子名称
    var community_photo = ""// 圈子照片
    var c_master = ""// 发帖人是否是圈主:1是,0不

    required init() {}
}

// 圈主列表
class MasterListModel: HandyJSON {
    var status = ""
    var data = [MasterListDataModel]()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}

class MasterListDataModel: HandyJSON {
    var userid = ""
    var community_id = ""// 圈子id
    var power = ""//
    var create_time = ""//
    var user_name = ""// 圈主姓名
    var user_photo = ""// 圈主头像
    
    required init() {}
}

// 判断是否为圈主
class JudgeMasterModel: HandyJSON {
    var status = ""
    var data = ""
    
    required init() {}
}

// 判断是否加入圈子
class JudgeCommunityModel: HandyJSON {
    var status = ""
    var data = JudgeCommunityDataModel()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper.exclude(property: &errorData)
    }
}
class JudgeCommunityDataModel: HandyJSON {
    var userid = ""
    var community_id = ""
    var power = ""
    var create_time = ""
    
    required init() {}
}

// 获取帖子详情
class ForumInfoModel: HandyJSON {
    var status = ""
    var data = ForumInfoDataModel()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}
class ForumInfoDataModel: HandyJSON {
    var tid = ""
    var community_id = ""
    var userid = ""
    var title = ""
    var create_time = ""
    var content = ""
    var description = ""
    var status = ""
    var review_time = ""
    var photo = [String]()
    var hits = ""
    var like = ""
    var istop = ""
    var isbest = ""
    var isreward = ""
    var add_like = ""
    var favorites = ""
    var favorites_add = ""
    
    required init() {}
}

// 选择发布圈子
class PublishCommunityModel: HandyJSON {
    var status = ""
    var data = [PublishCommunityDataModel]()
    var errorData = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        if status != "success" {
            mapper.specify(property: &errorData, name: "data")
        }
    }
}
class PublishCommunityDataModel: HandyJSON {
    var term_id = ""
    var name = ""
    var community = [PublishCommunityDataCommunityModel]()
    
    required init() {}
}
class PublishCommunityDataCommunityModel: HandyJSON {
    var id = ""
    var community_name = ""
    
    required init() {}
}




class CommunityModel: HandyJSON {
    
    var community_id = ""
    
    var community_name = ""
    
    var photo = ""
    
    var description = ""
    
    var best = ""

    var create_time = ""
    
    required init() {}
    
    func mapping(_ mapper: HelpingMapper) {
        // 指定 JSON中的`cat_id`字段映射到Model中的`id`字段
        mapper.specify(property: &community_id, name: "id")
        //        mapper.specify(property: &forum_id, name: "id")
        
        //        // 指定JSON中的`parent`字段解析为Model中的`parent`字段
        //        // 因为(String, String)?是一个元组，既不是基本类型，也不服从`HandyJSON`协议，所以需要自己实现解析过程
        //        mapper.specify(property: &parent, converter: { (rawString) -> (String, String) in
        //            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
        //            return (parentNames[0], parentNames[1])
        //        })
    }
}

class ForumModel: HandyJSON {
    
    var forum_id = ""
    
    var community_id = ""
    
    var userid = ""
    
    var title = ""
    
    var create_time = ""
    
    var content = ""
    
    var description = ""
    
    var status = ""
    
    var review_time = ""
    
    var photo = [photoModel]()
    
    var hits = ""
    
    var like = ""
    
    var istop = ""
    
    var isbest = ""
    
    var isreward = ""
    
    required init() {}
    
    func mapping(_ mapper: HelpingMapper) {
        // 指定 JSON中的`cat_id`字段映射到Model中的`id`字段
        
        mapper.specify(property: &forum_id, name: "id")
        
//        // 指定JSON中的`parent`字段解析为Model中的`parent`字段
//        // 因为(String, String)?是一个元组，既不是基本类型，也不服从`HandyJSON`协议，所以需要自己实现解析过程
//        mapper.specify(property: &parent, converter: { (rawString) -> (String, String) in
//            let parentNames = rawString.characters.split{$0 == "/"}.map(String.init)
//            return (parentNames[0], parentNames[1])
//        })
    }
}

class photoModel: HandyJSON {
    var alt = ""
    
    var url = ""
    
    required init() {}
}

class ForumCommentDataModel: HandyJSON {
    
    var userid = ""
    
    var content = ""
    
    var major = ""
    
    var cid = ""
    
    var child_comments = [ForumChildCommentDataModel]()
    
    var userlevel = ""
    
    var username = ""
    
    var photo = ""
    
    var refid = ""
    
    var type = ""
    
    var add_time = ""
    
    required init() {}
}

class ForumChildCommentDataModel: HandyJSON {
    
    var userid = ""
    
    var content = ""
    
    var add_time = ""
    
    var major = ""
    
    var userlevel = ""
    
    var username = ""
    
    var photo = ""
    
    var type = ""
    
    var pid = ""
    
    var cid = ""
    
    required init() {}
}
