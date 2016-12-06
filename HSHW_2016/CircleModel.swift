//
//  CircleModel.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import HandyJSON

class CommunityModel: HandyJSON {
    
    var community_id = ""
    
    var community_name = ""
    
    var photo = ""
    
    var description = ""
    
    var best = ""

    var create_time = ""
    
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        // 指定 JSON中的`cat_id`字段映射到Model中的`id`字段
        mapper.specify(&community_id, name: "id")
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
    
    func mapping(mapper: HelpingMapper) {
        // 指定 JSON中的`cat_id`字段映射到Model中的`id`字段
        
        mapper.specify(&forum_id, name: "id")
        
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
