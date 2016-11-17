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
    let locationLab = UILabel()
    //左侧要求
    let content = UILabel()
    //右侧要求
    let cont = UILabel()
    var locationImg = UIImageView()
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
        
        let contentStr = "招聘职位:"+model.jobtype+"\n薪资待遇:"+model.salary+"\n福利待遇:"+model.welfare
        let attrStr = NSMutableAttributedString(string: contentStr)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 8
        attrStr.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1], range: NSMakeRange(0, contentStr.characters.count))
        content.attributedText = attrStr
        
        let contStr = "学历要求:"+model.education+"\n工作年限:"+"\n招聘人数:"+model.count
        let attrcontStr = NSMutableAttributedString(string: contStr)
        let contParagraphStyle1 = NSMutableParagraphStyle()
        contParagraphStyle1.lineSpacing = 8
        attrcontStr.addAttributes([NSParagraphStyleAttributeName:contParagraphStyle1], range: NSMakeRange(0, contStr.characters.count))
        cont.attributedText = attrcontStr
        
        time.font = UIFont.systemFontOfSize(10)
        time.text = timeStampToString(model.create_time)
        time.sizeToFit()
        
        locationLab.text = model.address.componentsSeparatedByString("-").first! + "-" + model.address.componentsSeparatedByString("-")[1]

//        locationLab.text = model.address.stringByReplacingOccurrencesOfString("-"+(model.address.componentsSeparatedByString("-").last ?? "")!, withString: "")
//        locationLab.text = (model.address.componentsSeparatedByString(" ").first?.componentsSeparatedByString("-")[1])!+"-"+(model.address.componentsSeparatedByString(" ").first?.componentsSeparatedByString("-")[2])!
        locationLab.sizeToFit()
        
        delivery.setTitle("投递简历", forState: .Normal)
        delivery.sizeToFit()
        delivery.frame = CGRectMake(
            WIDTH-15-delivery.frame.size.width-delivery.frame.size.height-5,
            0,
            delivery.frame.size.width+delivery.frame.size.height+5,
            delivery.frame.size.height+5)
        delivery.layer.cornerRadius = delivery.frame.size.height/2.0
        delivery.layer.borderWidth = 1
        delivery.layer.borderColor = COLOR.CGColor
        
        let titleHeight:CGFloat = calculateHeight(model.title, size: 16, width: WIDTH*300/375)
        title.frame.size.height = titleHeight
        content.frame.origin.y = title.frame.size.height + title.frame.origin.y
        cont.frame.origin.y = title.frame.size.height + title.frame.origin.y
        time.frame.origin.y = content.frame.size.height+content.frame.origin.y
        locationLab.center.y = time.center.y
        locationImg.center.y = time.center.y
        timeImg.center.y = time.center.y
        titImg.frame.origin.y = title.frame.size.height + 5
        delivery.frame.origin.y = content.frame.size.height+content.frame.origin.y
        delivery.center.y = locationLab.center.y
        btnTit.center.y = locationLab.center.y
        img.center.y = locationLab.center.y
        
        locationImg.frame.origin.x = CGRectGetMaxX(time.frame)+5
        locationLab.frame.origin.x = CGRectGetMaxX(locationImg.frame)+5
    }
    
    func showforCVModel(model:CVModel){
        if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || model.avatar == "" {
            titImg.image = UIImage.init(named: "img_head_nor")
        }else{
            titImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+model.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
        }
        title.text = model.name

        let contentStr = "性别:"+(model.sex == "1" ? "男" : "女")+"\n当前薪资:"+model.currentsalary+"\n工作状态:"+model.jobstate
        
        let attrStr = NSMutableAttributedString(string: contentStr)
        let paragraphStyle1 = NSMutableParagraphStyle()
        paragraphStyle1.lineSpacing = 8
        attrStr.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1], range: NSMakeRange(0, contentStr.characters.count))
        content.attributedText = attrStr
        
        let contStr = "学历:"+model.education+"\n生日:"+model.birthday+"\n职称:"+model.certificate
        let attrcontStr = NSMutableAttributedString(string: contStr)
        let contParagraphStyle1 = NSMutableParagraphStyle()
        contParagraphStyle1.lineSpacing = 8
        attrcontStr.addAttributes([NSParagraphStyleAttributeName:contParagraphStyle1], range: NSMakeRange(0, contStr.characters.count))
        cont.attributedText = attrcontStr
        
        delivery.setTitle("邀请面试", forState: .Normal)
        delivery.sizeToFit()
        delivery.frame = CGRectMake(
            WIDTH-15-delivery.frame.size.width-delivery.frame.size.height-5,
            0,
            delivery.frame.size.width+delivery.frame.size.height+5,
            delivery.frame.size.height+5)
        delivery.layer.cornerRadius = delivery.frame.size.height/2.0
        delivery.layer.borderWidth = 1
        delivery.layer.borderColor = COLOR.CGColor
        
        time.font = UIFont.systemFontOfSize(10)
        time.text = timeStampToString(model.create_time)
        time.sizeToFit()
        
        locationLab.text = model.address.componentsSeparatedByString("-").first! + "-" + model.address.componentsSeparatedByString("-")[1]
        locationLab.sizeToFit()
        
        let titleHeight:CGFloat = calculateHeight(model.name, size: 16, width: WIDTH*300/375)
        title.frame.size.height = titleHeight
        content.frame.origin.y = title.frame.size.height + title.frame.origin.y
        cont.frame.origin.y = title.frame.size.height + title.frame.origin.y
        time.frame.origin.y = content.frame.size.height+content.frame.origin.y
        locationLab.center.y = time.center.y
        locationImg.center.y = time.center.y
        timeImg.center.y = time.center.y
        titImg.frame.origin.y = title.frame.size.height + 5
        delivery.frame.origin.y = content.frame.size.height+content.frame.origin.y
        delivery.center.y = locationLab.center.y
        btnTit.center.y = locationLab.center.y
        img.center.y = locationLab.center.y
        
        locationImg.frame.origin.x = CGRectGetMaxX(time.frame)+5
        locationLab.frame.origin.x = CGRectGetMaxX(locationImg.frame)+5
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
        
        content.frame = CGRectMake(WIDTH*95/375, title.frame.size.height+title.frame.origin.y , WIDTH*152/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        content.font = UIFont.systemFontOfSize(12)
        content.numberOfLines = 0
        
        name.frame = CGRectMake(WIDTH*10/375, WIDTH*85/375, WIDTH*70/375, WIDTH*40/375)
        name.font = UIFont.systemFontOfSize(10)
        name.numberOfLines = 0
        name.textColor = GREY
        name.textAlignment = .Center
        
        delivery.frame = CGRectMake(WIDTH-WIDTH*15/375-80, content.frame.size.height+content.frame.origin.y-5, 80, 24)
        
        delivery.setTitleColor(COLOR, forState: .Normal)
        delivery.titleLabel?.font = UIFont.systemFontOfSize(15)
        delivery.setImage(UIImage(named: "ic_note.png"), forState: .Normal)
        
        img.frame = CGRectMake(WIDTH-WIDTH*15/375-71, content.frame.size.height+content.frame.origin.y, 11, 13)
        img.image = UIImage(named: "ic_note.png")
        
        btnTit.frame = CGRectMake(WIDTH-WIDTH*15/375-56, content.frame.size.height+content.frame.origin.y, 48, 12)
        btnTit.textColor = COLOR
        btnTit.font = UIFont.systemFontOfSize(12)
        
        timeImg = UIImageView(frame: CGRectMake(WIDTH*95/375, content.frame.size.height+content.frame.origin.y, 8, 8))
        timeImg.image = UIImage(named: "ic_time_purple.png")
        time.frame = CGRectMake(WIDTH*95/375+10, content.frame.size.height+content.frame.origin.y, 50, 10)
        time.font = UIFont.systemFontOfSize(10)
        time.textColor = GREY
        time.text = "05/24"
        time.sizeToFit()
        
        locationImg = UIImageView(frame: CGRectMake(CGRectGetMaxX(time.frame)+10, content.frame.size.height+content.frame.origin.y, 6, 9))
        locationImg.image = UIImage(named: "ic_location.png")
        
        locationLab.frame = CGRectMake(CGRectGetMaxX(locationImg.frame)+10, content.frame.size.height+content.frame.origin.y, 50, 10)
        locationLab.textColor = GREY
        locationLab.font = UIFont.systemFontOfSize(10)
        locationLab.text = "北京市朝阳区"
        locationLab.sizeToFit()
        
        cont.frame = CGRectMake(WIDTH*95/375+WIDTH*162/375, title.frame.size.height+title.frame.origin.y, WIDTH*100/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        cont.font = UIFont.systemFontOfSize(12)
        cont.numberOfLines = 0
//        cont.backgroundColor = UIColor.greenColor()
        
        self.addSubview(cont)
        self.addSubview(content)
        self.addSubview(timeImg)
        self.addSubview(time)
        self.addSubview(locationImg)
        self.addSubview(locationLab)
//        self.addSubview(img)
//        self.addSubview(btnTit)
        self.addSubview(delivery)
        self.addSubview(titImg)
        self.addSubview(title)
        self.addSubview(name)
    }
    
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
