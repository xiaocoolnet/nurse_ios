//
//  RecruitTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class RecruitTableViewCell: UITableViewCell {
    //圆形图片
    let titImg = UIImageView()
    //右侧标题
    let title = UILabel()
    //图片下方文字
    let name = UILabel()
    //投简历
    let delivery = UIButton()
    //时间
    let time = UILabel()
    //位置信息
    let location = UILabel()
    //左侧要求
    let content = UILabel()
    //右侧要求
    let cont = UILabel()
    var loca = UIImageView()
    var timeImg = UIImageView()
    let btnTit = UILabel()
    var img = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func showforJobModel(model:JobModel){
        if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || model.photo == "" {
            titImg.image = UIImage.init(named: "img_head_nor")
        }else{
            titImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+model.photo), placeholderImage: UIImage.init(named: "img_head_nor"))
        }
        title.text = model.title
        name.text = model.companyname
        location.text = model.address.componentsSeparatedByString(" ").first
        location.sizeToFit()
        let contentStr = "薪资待遇:"+model.salary+"\n福利待遇:"+model.welfare+"\n招聘职位:"+model.jobtype
        content.text = contentStr
        let contStr = "学历要求:"+model.education+"\n工作年限:"+"\n相关证件:"+model.certificate
        cont.text = contStr
        let titleHeight:CGFloat = calculateHeight(model.title, size: 16, width: WIDTH*300/375)
        title.frame.size.height = titleHeight
        content.frame.origin.y = title.frame.size.height + title.frame.origin.y
        cont.frame.origin.y = title.frame.size.height + title.frame.origin.y
        time.font = UIFont.systemFontOfSize(10)
        
        time.frame.origin.y = content.frame.size.height+content.frame.origin.y
        location.center.y = time.center.y
        loca.center.y = time.center.y
        timeImg.center.y = time.center.y
        titImg.frame.origin.y = title.frame.size.height + 5
        delivery.frame.origin.y = content.frame.size.height+content.frame.origin.y
        delivery.center.y = location.center.y
        btnTit.center.y = location.center.y
        btnTit.text = "投递简历"
        img.center.y = location.center.y
    }
    
    func showforCVModel(model:CVModel){
        if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || model.avatar == "" {
            titImg.image = UIImage.init(named: "img_head_nor")
        }else{
            titImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
        }
//        titImg.sd_setImageWithURL(NSURL(string:SHOW_IMAGE_HEADER + model.avatar),placeholderImage: UIImage(named: "1"))
        title.text = model.name
        name.text = model.name
        location.text = model.address.componentsSeparatedByString(" ").first
        location.sizeToFit()
        let contentStr = "性别:"+(model.sex == "1" ? "男" : "女")+"\n当前薪资:"+model.currentsalary+"\n工作状态:"+model.jobstate
        content.text = contentStr
        let contStr = "学历:"+model.education+"\n生日:"+model.birthday+"\n职务名称:"+model.certificate
        cont.text = contStr
        let titleHeight:CGFloat = calculateHeight(model.name, size: 16, width: WIDTH*300/375)
        title.frame.size.height = titleHeight
        content.frame.origin.y = title.frame.size.height + title.frame.origin.y
        cont.frame.origin.y = title.frame.size.height + title.frame.origin.y
        time.font = UIFont.systemFontOfSize(10)
        time.frame.origin.y = content.frame.size.height+content.frame.origin.y
        location.center.y = time.center.y
        loca.frame.origin.y = content.frame.size.height+content.frame.origin.y
        timeImg.frame.origin.y = content.frame.size.height+content.frame.origin.y
        delivery.frame.origin.y = content.frame.size.height+content.frame.origin.y
        delivery.center.y = location.center.y
        btnTit.center.y = location.center.y
        btnTit.text = "邀请面试"
        img.center.y = location.center.y
        titImg.frame.origin.y = title.frame.size.height + 5
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImg.frame = CGRectMake(WIDTH*15/375, WIDTH*80/375, WIDTH*60/375, WIDTH*60/375)
        titImg.layer.cornerRadius = WIDTH*30/375
        titImg.layer.borderColor = GREY.CGColor
        titImg.layer.borderWidth = 0.5
        titImg.clipsToBounds = true
        
        title.frame = CGRectMake(WIDTH*95/375, WIDTH*20/375, WIDTH*300/375, 16)
        title.font = UIFont.systemFontOfSize(16)
        title.textColor = COLOR
        title.numberOfLines = 0
        
        //        content.frame = CGRectMake(WIDTH*95/375, WIDTH*20/375+20, WIDTH*152/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        content.frame = CGRectMake(WIDTH*95/375, title.frame.size.height+title.frame.origin.y , WIDTH*152/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        content.font = UIFont.systemFontOfSize(12)
        content.numberOfLines = 0
//        content.backgroundColor = UIColor.redColor()
        
        name.frame = CGRectMake(WIDTH*10/375, WIDTH*85/375, WIDTH*70/375, WIDTH*40/375)
        name.font = UIFont.systemFontOfSize(10)
        name.numberOfLines = 0
        name.textColor = GREY
        name.textAlignment = .Center
        
//        delivery.frame = CGRectMake(WIDTH-WIDTH*15/375-80, 142-WIDTH*20/375-24, 80, 24)
        delivery.frame = CGRectMake(WIDTH-WIDTH*15/375-80, content.frame.size.height+content.frame.origin.y-5, 80, 24)
        delivery.layer.cornerRadius = 12
        delivery.layer.borderWidth = 1
        delivery.layer.borderColor = COLOR.CGColor
        
//        let img = UIImageView(frame: CGRectMake(WIDTH-WIDTH*15/375-71, 142-WIDTH*20/375-18, 11, 13))
        img.frame = CGRectMake(WIDTH-WIDTH*15/375-71, content.frame.size.height+content.frame.origin.y, 11, 13)
        img.image = UIImage(named: "ic_note.png")
        
        //let btnTit = UILabel(frame: CGRectMake(WIDTH-WIDTH*15/375-56, 142-WIDTH*20/375-18, 48, 12))
        btnTit.frame = CGRectMake(WIDTH-WIDTH*15/375-56, content.frame.size.height+content.frame.origin.y, 48, 12)
//        btnTit.text = "投递简历"
        btnTit.textColor = COLOR
        btnTit.font = UIFont.systemFontOfSize(12)
        

        
        //let timeImg = UIImageView(frame: CGRectMake(WIDTH*95/375, 142-WIDTH*20/375-16, 8, 8))
        timeImg = UIImageView(frame: CGRectMake(WIDTH*95/375, content.frame.size.height+content.frame.origin.y, 8, 8))
        timeImg.image = UIImage(named: "ic_time_purple.png")
        //time.frame = CGRectMake(WIDTH*95/375+10, 142-WIDTH*20/375-17, 50, 10)
        time.frame = CGRectMake(WIDTH*95/375+10, content.frame.size.height+content.frame.origin.y, 50, 10)
        time.font = UIFont.systemFontOfSize(10)
        time.textColor = GREY
        time.text = "2016/05/24"
        time.sizeToFit()
        
        //let loca = UIImageView(frame: CGRectMake(WIDTH*95/375+20+time.bounds.size.width, 142-WIDTH*20/375-16.5, 6, 9))
        loca = UIImageView(frame: CGRectMake(WIDTH*95/375+20+time.bounds.size.width, content.frame.size.height+content.frame.origin.y, 6, 9))
        loca.image = UIImage(named: "ic_location.png")
//        location.frame = CGRectMake(WIDTH*95/375+28+time.bounds.size.width, 142-WIDTH*20/375-17, 50, 10)
         location.frame = CGRectMake(WIDTH*95/375+28+time.bounds.size.width, content.frame.size.height+content.frame.origin.y, 50, 10)
        location.textColor = GREY
        location.font = UIFont.systemFontOfSize(10)
        location.text = "北京市朝阳区"
        location.sizeToFit()
        
        cont.frame = CGRectMake(WIDTH*95/375+WIDTH*162/375, title.frame.size.height+title.frame.origin.y, WIDTH*100/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        cont.font = UIFont.systemFontOfSize(12)
        cont.numberOfLines = 0
//        cont.backgroundColor = UIColor.greenColor()
        
        self.addSubview(cont)
        self.addSubview(content)
        self.addSubview(timeImg)
        self.addSubview(time)
        self.addSubview(loca)
        self.addSubview(location)
        self.addSubview(img)
        self.addSubview(btnTit)
        self.addSubview(delivery)
        self.addSubview(titImg)
        self.addSubview(title)
//        self.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
