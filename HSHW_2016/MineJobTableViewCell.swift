//
//  MineJobTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage

class MineJobTableViewCell: UITableViewCell {

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
    
    func showforJobModel(_ model:MineJobInfo){

        if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
            self.titImg.image = UIImage.init(named: "img_head_nor")
        }else{
            self.titImg.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), placeholderImage: UIImage.init(named: "img_head_nor"))
        }
        title.text = model.title
        name.text = model.companyname
        location.text = model.address.components(separatedBy: "-").first! + "-" + model.address.components(separatedBy: "-")[1]

//        location.text = model.address.componentsSeparatedByString(" ").first
        location.sizeToFit()
        let contentStr = "薪资待遇:"+model.salary+"\n福利待遇:"+model.welfare+"\n招聘职位:"+model.jobtype
        content.text = contentStr
        let contStr = "学历要求:"+model.education+"\n工作年限:"+model.experience+"\n招聘人数:"+model.count

//        let contStr = "学历要求:"+model.education+"\n工作年限:"+"\n相关证件:"+model.certificate
        cont.text = contStr
        let titleHeight:CGFloat = calculateHeight(model.title, size: 16, width: WIDTH*300/375)
        title.frame.size.height = titleHeight
        content.frame.origin.y = title.frame.size.height + title.frame.origin.y
        cont.frame.origin.y = title.frame.size.height + title.frame.origin.y
        time.font = UIFont.systemFont(ofSize: 10)
        
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImg.frame = CGRect(x: WIDTH*15/375, y: WIDTH*80/375, width: WIDTH*60/375, height: WIDTH*60/375)
        titImg.layer.cornerRadius = WIDTH*30/375
        titImg.layer.borderColor = GREY.cgColor
        titImg.layer.borderWidth = 0.5
        titImg.clipsToBounds = true
        
        title.frame = CGRect(x: WIDTH*95/375, y: WIDTH*20/375, width: WIDTH*300/375, height: 16)
        title.font = UIFont.systemFont(ofSize: 16)
        title.textColor = COLOR
        title.numberOfLines = 0
        
        //        content.frame = CGRectMake(WIDTH*95/375, WIDTH*20/375+20, WIDTH*152/375, 142-WIDTH*20/375+20-WIDTH*20/375-30)
        content.frame = CGRect(x: WIDTH*95/375, y: title.frame.size.height+title.frame.origin.y , width: WIDTH*152/375, height: 142-WIDTH*20/375+20-WIDTH*20/375-30)
        content.font = UIFont.systemFont(ofSize: 12)
        content.numberOfLines = 0
        //        content.backgroundColor = UIColor.redColor()
        
        name.frame = CGRect(x: WIDTH*10/375, y: WIDTH*85/375, width: WIDTH*70/375, height: WIDTH*40/375)
        name.font = UIFont.systemFont(ofSize: 10)
        name.numberOfLines = 0
        name.textColor = GREY
        name.textAlignment = .center
        
        //        delivery.frame = CGRectMake(WIDTH-WIDTH*15/375-80, 142-WIDTH*20/375-24, 80, 24)
        delivery.frame = CGRect(x: WIDTH-WIDTH*15/375-80, y: content.frame.size.height+content.frame.origin.y-5, width: 80, height: 24)
        delivery.layer.cornerRadius = 12
        delivery.layer.borderWidth = 1
        delivery.layer.borderColor = COLOR.cgColor
        
        //        let img = UIImageView(frame: CGRectMake(WIDTH-WIDTH*15/375-71, 142-WIDTH*20/375-18, 11, 13))
        img.frame = CGRect(x: WIDTH-WIDTH*15/375-71, y: content.frame.size.height+content.frame.origin.y, width: 11, height: 13)
        img.image = UIImage(named: "ic_note.png")
        
        //let btnTit = UILabel(frame: CGRectMake(WIDTH-WIDTH*15/375-56, 142-WIDTH*20/375-18, 48, 12))
//        btnTit.frame = CGRectMake(WIDTH-WIDTH*15/375-56, content.frame.size.height+content.frame.origin.y, 48, 12)
//        //        btnTit.text = "投递简历"
//        btnTit.textColor = COLOR
//        btnTit.font = UIFont.systemFontOfSize(12)
        
        
        
        //let timeImg = UIImageView(frame: CGRectMake(WIDTH*95/375, 142-WIDTH*20/375-16, 8, 8))
        timeImg = UIImageView(frame: CGRect(x: WIDTH*95/375, y: content.frame.size.height+content.frame.origin.y, width: 8, height: 8))
        timeImg.image = UIImage(named: "ic_time_purple.png")
        //time.frame = CGRectMake(WIDTH*95/375+10, 142-WIDTH*20/375-17, 50, 10)
        time.frame = CGRect(x: WIDTH*95/375+10, y: content.frame.size.height+content.frame.origin.y, width: 50, height: 10)
        time.font = UIFont.systemFont(ofSize: 10)
        time.textColor = GREY
        time.text = "2016/05/24"
        time.sizeToFit()
        
        //let loca = UIImageView(frame: CGRectMake(WIDTH*95/375+20+time.bounds.size.width, 142-WIDTH*20/375-16.5, 6, 9))
        loca = UIImageView(frame: CGRect(x: WIDTH*95/375+20+time.bounds.size.width, y: content.frame.size.height+content.frame.origin.y, width: 6, height: 9))
        loca.image = UIImage(named: "ic_location.png")
        //        location.frame = CGRectMake(WIDTH*95/375+28+time.bounds.size.width, 142-WIDTH*20/375-17, 50, 10)
        location.frame = CGRect(x: WIDTH*95/375+28+time.bounds.size.width, y: content.frame.size.height+content.frame.origin.y, width: 70, height: 10)
        location.textColor = GREY
        location.font = UIFont.systemFont(ofSize: 10)
        location.text = "北京市朝阳区"
        location.sizeToFit()
        
        cont.frame = CGRect(x: WIDTH*95/375+WIDTH*162/375, y: title.frame.size.height+title.frame.origin.y, width: WIDTH*100/375, height: 142-WIDTH*20/375+20-WIDTH*20/375-30)
        cont.font = UIFont.systemFont(ofSize: 12)
        cont.numberOfLines = 0
        //        cont.backgroundColor = UIColor.greenColor()
        
        let line = UILabel(frame: CGRect(x: 0, y: 164.5, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        
        
        self.addSubview(line)
        self.addSubview(cont)
        self.addSubview(content)
        self.addSubview(timeImg)
        self.addSubview(time)
        self.addSubview(loca)
        self.addSubview(location)
//        self.addSubview(img)
//        self.addSubview(btnTit)
//        self.addSubview(delivery)
        self.addSubview(titImg)
        self.addSubview(title)
        //        self.addSubview(name)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
