//
//  MineRecDetailsViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class MineRecDetailsViewController: UIViewController {
    
//    let employmentMessageTableView = UITableView()
//    let employmentMessage = UIView()
    
//    var tit = NSString()
//    var companyDescription = NSString()
//    var name = NSString()
//    var criteriaLabel = NSString()
//    var criteriLabel = NSString()
//    var addressLabel = NSString()
//    var descripDetail = NSString()
//    var addresLabel = NSString()
//    var strId = NSString()
//    var phone = NSString()
//    var num = 1
    
    var currentJobModel:MineJobInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        employmentMessageTableView.separatorStyle = .None
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        self.title = "招聘信息详情"
        
        self.view.backgroundColor = UIColor.white
    
//        employmentMessageTableView.registerClass(MineJobDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
//        employmentMessageTableView.showsHorizontalScrollIndicator = true
//        employmentMessageTableView.delegate = self
//        employmentMessageTableView.dataSource = self
//        employmentMessageTableView.tag = 1
        
//        self.makeEmploymentMessage()
        self.setSubViews()
        // Do any additional setup after loading the view.
    }
    
    func setSubViews() {
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        let jobModel = currentJobModel
        
//        strId = jobModel!.id
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rootScrollView = UIScrollView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1-WIDTH*59/375))
        rootScrollView.backgroundColor = UIColor.white
        self.view.addSubview(rootScrollView)
        
        let title = UILabel()
        let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
        title.frame = CGRect(x: 10, y: 10, width: WIDTH-20, height: height)
        title.text = jobModel!.title
        title.font = UIFont.systemFont(ofSize: 22)
        title.textColor = COLOR
        title.numberOfLines = 0
        title.sizeToFit()
        rootScrollView.addSubview(title)
        
        let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
        eyeImage.frame = CGRect(x: 10,y: title.frame.maxY+10,width: 8,height: 8)
        eyeImage.contentMode = .scaleAspectFit
        rootScrollView.addSubview(eyeImage)

        let lookCount = UILabel(frame: CGRect(x: eyeImage.frame.maxX+5,y: title.frame.maxY+10,width: 30,height: 10))
        lookCount.font = UIFont.systemFont(ofSize: 10)
        lookCount.text = (jobModel?.hits ?? "0")!
        lookCount.sizeToFit()
        lookCount.center.y = eyeImage.center.y
        rootScrollView.addSubview(lookCount)
        
        let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
                timeImage.frame = CGRect(x: lookCount.frame.maxX+18, y: title.frame.maxY+10, width: 8, height: 8)
//        timeImage.frame = CGRectMake(10, CGRectGetMaxY(title.frame)+10, 8, 8)
        timeImage.contentMode = .scaleAspectFit
        rootScrollView.addSubview(timeImage)
        
        let timeLabel = UILabel(frame: CGRect(x: timeImage.frame.maxX+5,y: title.frame.maxY+10,width: 100,height: 10))
        timeLabel.font = UIFont.systemFont(ofSize: 10)
        timeLabel.text = self.timeStampToString((jobModel?.create_time)!)
        timeLabel.sizeToFit()
        timeLabel.center.y = timeImage.center.y
        rootScrollView.addSubview(timeLabel)
        
        
        
        let nameLabel = UILabel(frame: CGRect(x: 10,y: timeLabel.frame.maxY+10,width: 100,height: 25))
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
        nameLabel.text = "企业名称:"
        nameLabel.sizeToFit()
        rootScrollView.addSubview(nameLabel)
        
        let name = UILabel(frame: CGRect(x: nameLabel.frame.maxX+8,y: timeLabel.frame.maxY+10,width: 200,height: 25))
        name.font = UIFont.systemFont(ofSize: 14)
        name.text = jobModel!.companyname
        name.sizeToFit()
        name.center.y = nameLabel.center.y
        rootScrollView.addSubview(name)
        
        
        
        let descripTagLab = UILabel(frame: CGRect(x: 10,y: name.frame.maxY+10,width: WIDTH-20,height: 0))
        descripTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        descripTagLab.textColor = UIColor.black
        descripTagLab.text = "企业简介:"
        descripTagLab.sizeToFit()
        rootScrollView.addSubview(descripTagLab)
        
        let descripStr = jobModel!.companyinfo
        let attrStr = NSMutableAttributedString(string: descripStr)
        //                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
        attrStr.addAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 14)], range: NSMakeRange(0, attrStr.length))
        attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGray], range: NSMakeRange(0, attrStr.length))
        
        let descript = UILabel(frame: CGRect(
            x: descripTagLab.frame.maxX+8,
            y: name.frame.maxY+10,
            width: WIDTH-descripTagLab.frame.maxX-10,
            height: attrStr.boundingRect(with: CGSize(width: WIDTH-descripTagLab.frame.maxX-10, height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size.height))
        descript.font = UIFont.boldSystemFont(ofSize: 15)
        descript.numberOfLines = 0
        descript.attributedText = attrStr
        descript.sizeToFit()
        rootScrollView.addSubview(descript)
        
        
        
        let criteria = UILabel(frame: CGRect(x: 10,y: descript.frame.maxY+10,width: 70,height: 25))
        criteria.font = UIFont.boldSystemFont(ofSize: 15)
        criteria.text = "招聘条件:"
        criteria.sizeToFit()
        rootScrollView.addSubview(criteria)
        
        let criteriaLabel = UILabel(frame: CGRect(x: criteria.frame.maxX+8,y: descript.frame.maxY+10,width: 75,height: 25))
        criteriaLabel.font = UIFont.systemFont(ofSize: 14)
        criteriaLabel.textColor = UIColor.lightGray
        criteriaLabel.text = jobModel!.education
        criteriaLabel.sizeToFit()
        rootScrollView.addSubview(criteriaLabel)
        
        let salaryTagLab = UILabel(frame: CGRect(x: 170,y: descript.frame.maxY+10,width: 70,height: 25))
        salaryTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        salaryTagLab.text = "薪资待遇:"
        salaryTagLab.sizeToFit()
        rootScrollView.addSubview(salaryTagLab)
        
        let salaryLab = UILabel(frame: CGRect(x: salaryTagLab.frame.maxX+8,y: descript.frame.maxY+10,width: WIDTH-240,height: 25))
        salaryLab.font = UIFont.systemFont(ofSize: 14)
        salaryLab.textColor = UIColor.lightGray
        salaryLab.text = currentJobModel!.salary
        salaryLab.sizeToFit()
        rootScrollView.addSubview(salaryLab)
        
        
        let personalNumTagLab = UILabel(frame: CGRect(x: 10,y: salaryLab.frame.maxY+10,width: 70,height: 25))
        personalNumTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        personalNumTagLab.text = "招聘人数:"
        personalNumTagLab.sizeToFit()
        rootScrollView.addSubview(personalNumTagLab)
        
        let personalNumLab = UILabel(frame: CGRect(x: personalNumTagLab.frame.maxX+8,y: salaryLab.frame.maxY+10,width: 75,height: 25))
        personalNumLab.font = UIFont.systemFont(ofSize: 14)
        personalNumLab.textColor = UIColor.lightGray
        personalNumLab.text = jobModel!.count
        personalNumLab.sizeToFit()
        rootScrollView.addSubview(personalNumLab)
        
        let welfareTagLab = UILabel(frame: CGRect(x: 170,y: salaryLab.frame.maxY+10,width: 70,height: 25))
        welfareTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        welfareTagLab.text = "福利待遇:"
        welfareTagLab.sizeToFit()
        rootScrollView.addSubview(welfareTagLab)
        
        let welfareLab = UILabel(frame: CGRect(x: welfareTagLab.frame.maxX+8,y: salaryLab.frame.maxY+10,width: WIDTH-240,height: 25))
        welfareLab.font = UIFont.systemFont(ofSize: 14)
        welfareLab.textColor = UIColor.lightGray
        welfareLab.text = jobModel!.welfare
        welfareLab.sizeToFit()
        rootScrollView.addSubview(welfareLab)
        
        
        
        let addressTagLab = UILabel(frame: CGRect(x: 10,y: welfareLab.frame.maxY+10,width: 70,height: 25))
        addressTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        addressTagLab.text = "工作地点:"
        addressTagLab.sizeToFit()
        rootScrollView.addSubview(addressTagLab)
        
        let addressLab = UILabel(frame: CGRect(x: addressTagLab.frame.maxX+8,y: welfareLab.frame.maxY+10,width: WIDTH-240,height: 25))
        addressLab.font = UIFont.systemFont(ofSize: 14)
        addressLab.textColor = UIColor.lightGray
        addressLab.text = currentJobModel!.address
        addressLab.sizeToFit()
        addressLab.center.y = addressTagLab.center.y
        rootScrollView.addSubview(addressLab)
        
        
        
        let positionDescript = UILabel(frame: CGRect(x: 10,y: addressLab.frame.maxY+10,width: 100,height: 25))
        positionDescript.font = UIFont.boldSystemFont(ofSize: 15)
        positionDescript.text = "职位描述:"
        positionDescript.sizeToFit()
        rootScrollView.addSubview(positionDescript)
        
        let descripDetail = UILabel(frame: CGRect(x: 10,y: addressLab.frame.maxY+40,width: WIDTH-20,height: 200))
        descripDetail.font = UIFont.systemFont(ofSize: 14)
        descripDetail.textColor = UIColor.lightGray
        descripDetail.numberOfLines = 0
        descripDetail.text = jobModel!.description
        descripDetail.frame.size.height = calculateHeight((jobModel?.description)!, size: 14, width: WIDTH-20)
        descripDetail.sizeToFit()
        rootScrollView.addSubview(descripDetail)
        
        
        
        let contactTagLab = UILabel(frame: CGRect(x: 10,y: descripDetail.frame.maxY+10,width: 80,height: 25))
        contactTagLab.font = UIFont.boldSystemFont(ofSize: 15)
        contactTagLab.text = "联系方式:"
        contactTagLab.sizeToFit()
        rootScrollView.addSubview(contactTagLab)
        
        let contactNameLab = UILabel(frame: CGRect(x: contactTagLab.frame.maxX+8,y: descripDetail.frame.maxY+10,width: 80,height: 25))
        contactNameLab.font = UIFont.boldSystemFont(ofSize: 14)
        contactNameLab.textColor = UIColor.lightGray
        contactNameLab.text = jobModel?.linkman
        contactNameLab.sizeToFit()
        contactNameLab.center.y = contactTagLab.center.y
        rootScrollView.addSubview(contactNameLab)
        
        let contactTelBtn = UIButton()
        contactTelBtn.frame = CGRect(x: contactTagLab.frame.maxX+8, y: contactNameLab.frame.maxY+8, width: 10, height: 25)
        contactTelBtn.setTitleColor(COLOR, for: UIControlState())
        contactTelBtn.titleLabel!.font = UIFont.systemFont(ofSize: 14)
        contactTelBtn.setTitle(jobModel!.phone, for: UIControlState())
        contactTelBtn.sizeToFit()
        //        contactTelBtn.center.y = contactNameLab.center.y
        rootScrollView.addSubview(contactTelBtn)
        
        rootScrollView.contentSize = CGSize(width: 0, height: contactTelBtn.frame.maxY+10)
        
    }
    
    //  招聘信息详情
//    func makeEmploymentMessage() {
//        employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-64)
//        employmentMessage.backgroundColor = UIColor.whiteColor()
//        
//        self.view.addSubview(employmentMessage)
////        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,employmentMessage.frame.size.height - WIDTH*65/375)
//        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,HEIGHT-64)
//
//        //        employmentMessageTableView.tag = 1
//        //        employmentMessageTableView.backgroundColor = UIColor.redColor()
////        let tackBtn = UIButton(frame: CGRectMake(WIDTH*(WIDTH - 145 )/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
////        tackBtn.layer.cornerRadius = WIDTH*22.5/375
////        tackBtn.layer.borderColor = COLOR.CGColor
////        tackBtn.layer.borderWidth = 1
////        tackBtn.setTitle("返回", forState: .Normal)
////        tackBtn.setTitleColor(COLOR, forState: .Normal)
////        tackBtn.addTarget(self, action: #selector(self.takeResume), forControlEvents: .TouchUpInside)
////        employmentMessage.addSubview(tackBtn)
//        
////        let tack = UIButton(frame: CGRectMake(WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
////        tack.layer.cornerRadius = WIDTH*22.5/375
////        tack.layer.borderColor = COLOR.CGColor
////        tack.layer.borderWidth = 1
////        tack.setTitle("投递简历", forState: .Normal)
////        tack.setTitleColor(COLOR, forState: .Normal)
////        tack.addTarget(self, action: #selector(self.takeTheResume), forControlEvents: .TouchUpInside)
////        employmentMessage.addSubview(tack)
//        
//        employmentMessage.addSubview(employmentMessageTableView)
//        
//        
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            let height = calculateHeight(currentJobModel!.title, size: 18, width: WIDTH-20)
//            return 20+height
//        }else if indexPath.row == 1 {
//            return 20
//        }else if indexPath.row == 2 {
//            return 35
//        }else if indexPath.row == 3 {
//            
//            let descripTagLab = UILabel(frame: CGRectMake(10,10,WIDTH-20,0))
//            descripTagLab.font = UIFont.boldSystemFontOfSize(15)
//            descripTagLab.textColor = UIColor.blackColor()
//            descripTagLab.text = "企业简介:"
//            descripTagLab.sizeToFit()
//            
//            let jobModel = currentJobModel
//            
//            let descripStr = jobModel!.companyinfo
//            let attrStr = NSMutableAttributedString(string: descripStr)
//            //                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
//            attrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(0, attrStr.length))
//            attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(0, attrStr.length))
//            
//            return attrStr.boundingRectWithSize(CGSizeMake(WIDTH-CGRectGetMaxX(descripTagLab.frame)-10, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height+10
//        }else if indexPath.row == 4 {
//            return calculateHeight(currentJobModel!.address.stringByReplacingOccurrencesOfString(" ", withString: "\n"), size: 14, width: WIDTH-240)
//        }else if indexPath.row == 5 {
//            return 35
//        }else if indexPath.row == 6 {
////            let jobModel = jobDataSource![0]
//            let height = calculateHeight(currentJobModel!.description, size: 14, width: WIDTH-20)+10
//            return 40+height
//        }else if indexPath.row == 7 {
//            let name = UIButton(type: UIButtonType.Custom)
//            name.frame = CGRectMake(100, 10, 10, 25)
//            name.setTitleColor(COLOR, forState: .Normal)
//            name.titleLabel!.font = UIFont.systemFontOfSize(14)
////            if !canLookTel {
////                name.setTitle("查看联系方式", forState: .Normal)
////                name.sizeToFit()
////                return name.frame.size.height + 10
////            }else {
//                name.setTitle((currentJobModel?.linkman)! + "\n" + currentJobModel!.phone, forState: .Normal)
//                name.titleLabel?.numberOfLines = 0
//                name.sizeToFit()
//                return name.frame.size.height + 10
////            }
//            
//        }
//        else{
//            return 100
//        }
//        
//    }
    
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 8
//    }
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineJobDetailsTableViewCell
//        
//        cell1.selectionStyle = .None
//        cell1.textLabel?.numberOfLines = 0
//        
//        let jobModel = currentJobModel
//        // print(indexPath.row)
//        if indexPath.row==0 {
//            let title = UILabel()
//            let height = calculateHeight(jobModel!.title, size: 18, width: WIDTH-20)
//            title.frame = CGRectMake(10, 10, WIDTH-20, height)
//            title.text = jobModel!.title
//            title.font = UIFont.systemFontOfSize(20)
//            title.textColor = COLOR
//            title.numberOfLines = 0
//            cell1.addSubview(title)
//        }else if indexPath.row == 1 {
//            let eyeImage = UIImageView(image: UIImage(named: "ic_eye_purple.png"))
//            eyeImage.frame = CGRectMake(10,10,8,8)
//            let lookCount = UILabel(frame: CGRectMake(20,10,30,10))
//            lookCount.font = UIFont.systemFontOfSize(10)
//            lookCount.text = "3346"
//            let timeImage = UIImageView(image: UIImage(named: "ic_time_purple.png"))
//            timeImage.frame = CGRectMake(55, 10, 8, 8)
//            let timeLabel = UILabel(frame: CGRectMake(65,10,100,10))
//            timeLabel.font = UIFont.systemFontOfSize(10)
//            timeLabel.text = self.timeStampToString((jobModel?.create_time)!)
//            
//            cell1.addSubview(eyeImage)
//            cell1.addSubview(lookCount)
//            cell1.addSubview(timeImage)
//            cell1.addSubview(timeLabel)
//            
//        }else if indexPath.row == 2 {
//            let nameLabel = UILabel(frame: CGRectMake(10,10,100,25))
//            nameLabel.font = UIFont.boldSystemFontOfSize(15)
//            nameLabel.text = "企业名称:"
//            let name = UILabel(frame: CGRectMake(120,10,200,25))
//            name.font = UIFont.systemFontOfSize(14)
//            name.text = jobModel!.companyname
//            cell1.addSubview(nameLabel)
//            cell1.addSubview(name)
//        }else if indexPath.row == 3 {
//            let descripTagLab = UILabel(frame: CGRectMake(10,10,WIDTH-20,0))
//            descripTagLab.font = UIFont.boldSystemFontOfSize(15)
//            descripTagLab.textColor = UIColor.blackColor()
//            descripTagLab.text = "企业简介:"
//            descripTagLab.sizeToFit()
//            cell1.addSubview(descripTagLab)
//            
//            let descripStr = jobModel!.companyinfo
//            let attrStr = NSMutableAttributedString(string: descripStr)
//            //                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
//            attrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(0, attrStr.length))
//            attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(0, attrStr.length))
//            
//            let descript = UILabel(frame: CGRectMake(
//                CGRectGetMaxX(descripTagLab.frame),
//                10,
//                WIDTH-CGRectGetMaxX(descripTagLab.frame)-10,
//                attrStr.boundingRectWithSize(CGSizeMake(WIDTH-CGRectGetMaxX(descripTagLab.frame)-10, 0), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil).size.height))
//            descript.font = UIFont.boldSystemFontOfSize(15)
//            descript.numberOfLines = 0
//            
//            
//            //                    let paragraphStyle1 = NSMutableParagraphStyle()
//            //                    paragraphStyle1.lineSpacing = 8
//            //                    attrStr.addAttributes([NSParagraphStyleAttributeName:paragraphStyle1], range: NSMakeRange(0, descripStr.characters.count))
//            
//            descript.numberOfLines = 0
//            descript.attributedText = attrStr
//            cell1.addSubview(descript)
//        }else if indexPath.row == 4 {
//            let criteria = UILabel(frame: CGRectMake(10,10,70,25))
//            criteria.font = UIFont.boldSystemFontOfSize(15)
//            criteria.text = "招聘条件:"
//            criteria.sizeToFit()
//            let criteriaLabel = UILabel(frame: CGRectMake(80,10,75,25))
//            criteriaLabel.font = UIFont.systemFontOfSize(14)
//            criteriaLabel.textColor = UIColor.lightGrayColor()
//            criteriaLabel.text = jobModel!.education
//            criteriaLabel.sizeToFit()
//            let address = UILabel(frame: CGRectMake(170,10,70,25))
//            address.font = UIFont.boldSystemFontOfSize(15)
//            address.text = "工作地点:"
//            address.sizeToFit()
//            let addressLabel = UILabel(frame: CGRectMake(240,10,WIDTH-240,calculateHeight(currentJobModel!.address.stringByReplacingOccurrencesOfString(" ", withString: "\n"), size: 14, width: WIDTH-240)))
//            addressLabel.font = UIFont.systemFontOfSize(14)
//            addressLabel.textColor = UIColor.lightGrayColor()
//            addressLabel.text = currentJobModel!.address.stringByReplacingOccurrencesOfString(" ", withString: "\n")
//            addressLabel.numberOfLines = 0
//            cell1.addSubview(criteria)
//            cell1.addSubview(criteriaLabel)
//            cell1.addSubview(address)
//            cell1.addSubview(addressLabel)
//        }else if indexPath.row == 5{
//            let criteria = UILabel(frame: CGRectMake(10,10,70,25))
//            criteria.font = UIFont.boldSystemFontOfSize(15)
//            criteria.text = "招聘人数:"
//            let criteriaLabel = UILabel(frame: CGRectMake(80,10,75,25))
//            criteriaLabel.font = UIFont.systemFontOfSize(14)
//            criteriaLabel.textColor = UIColor.lightGrayColor()
//            criteriaLabel.text = jobModel!.count
//            let address = UILabel(frame: CGRectMake(170,10,70,25))
//            address.font = UIFont.boldSystemFontOfSize(15)
//            address.text = "福利待遇:"
//            let addressLabel = UILabel(frame: CGRectMake(240,10,WIDTH-240,25))
//            addressLabel.font = UIFont.systemFontOfSize(14)
//            addressLabel.textColor = UIColor.lightGrayColor()
//            addressLabel.text = jobModel!.welfare
//            cell1.addSubview(criteria)
//            cell1.addSubview(criteriaLabel)
//            cell1.addSubview(address)
//            cell1.addSubview(addressLabel)
//        }else if indexPath.row == 6 {
//            let positionDescript = UILabel(frame: CGRectMake(10,10,100,25))
//            positionDescript.font = UIFont.boldSystemFontOfSize(15)
//            positionDescript.text = "职位描述:"
//            let descripDetail = UILabel(frame: CGRectMake(10,40,WIDTH-20,200))
//            descripDetail.font = UIFont.systemFontOfSize(14)
//            descripDetail.textColor = UIColor.lightGrayColor()
//            descripDetail.numberOfLines = 0
//            descripDetail.text = jobModel!.description
//            descripDetail.frame.size.height = calculateHeight((jobModel?.description)!, size: 14, width: WIDTH-20)
//            cell1.addSubview(positionDescript)
//            cell1.addSubview(descripDetail)
//        }else if indexPath.row == 7 {
//            let nameLabel = UILabel(frame: CGRectMake(10,10,80,25))
//            nameLabel.font = UIFont.boldSystemFontOfSize(15)
//            nameLabel.text = "联系方式:"
//            
//            let name = UIButton(type: UIButtonType.Custom)
//            name.frame = CGRectMake(100, 10, 10, 25)
//            name.setTitleColor(COLOR, forState: .Normal)
//            name.titleLabel!.font = UIFont.systemFontOfSize(14)
////            if !canLookTel {
////                name.setTitle("查看联系方式", forState: .Normal)
////                name.sizeToFit()
////                name.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
////            }else {
//                name.setTitle((jobModel?.linkman)! + "\n" + jobModel!.phone, forState: .Normal)
//                name.titleLabel?.numberOfLines = 0
//                name.sizeToFit()
////            }
//            cell1.addSubview(nameLabel)
//            cell1.addSubview(name)
//        }
//        return cell1
//    }
    
//    func contactClick(){
//        num = 2
//        self.employmentMessageTableView.reloadData()
//    }
    
//    func takeResume(){
//        UIView.animateWithDuration(0.2) {
//            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
//        }
//        _ = self.navigationController?.popViewControllerAnimated(true)
//    }
    
//    func takeTheResume() {
//        // print("点击了提交简历")
//        
//        // MARK:要求登录
//        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
//            return
//        }
//        
//        UIView.animateWithDuration(0.2) {
//            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
//        }
//        
////        let model = self.jobDataSource![btnTag].companyid
//        
//        
//        let url = PARK_URL_Header+"ApplyJob"
//        let param = [
//            "userid":QCLoginUserInfo.currentInfo.userid,
//            //                "userid":"1",
//            //                "jobid":"1"
//            "jobid":strId,
//            "companyid" :QCLoginUserInfo.currentInfo.userid
//        ]
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            // print(request)
//            if(error != nil){
//                //                    handle(success: false, response: error?.description)
//            }else{
//                let result = Http(JSONDecoder(json!))
//                if(result.status == "success"){
//                    //                        handle(success: true, response: nil)
//                    // print(111111)
//                }else{
//                    //                        handle(success: false, response: nil)
//                    // print(2222222)
//                }
//            }
//        }
//        
//        _ = self.navigationController?.popViewControllerAnimated(true)
//    }

    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
