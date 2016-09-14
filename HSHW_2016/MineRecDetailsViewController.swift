//
//  MineRecDetailsViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MineRecDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let employmentMessageTableView = UITableView()
    let employmentMessage = UIView()
    
    var tit = NSString()
    var name = NSString()
    var criteriaLabel = NSString()
    var criteriLabel = NSString()
    var addressLabel = NSString()
    var descripDetail = NSString()
    var addresLabel = NSString()
    var strId = NSString()
    var phone = NSString()
    var num = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        employmentMessageTableView.separatorStyle = .None
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        self.title = "招聘信息详情"
        
        self.view.backgroundColor = UIColor.whiteColor()
    
        employmentMessageTableView.registerClass(MineJobDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        employmentMessageTableView.showsHorizontalScrollIndicator = true
        employmentMessageTableView.delegate = self
        employmentMessageTableView.dataSource = self
        employmentMessageTableView.tag = 1
        
        self.makeEmploymentMessage()
        // Do any additional setup after loading the view.
    }
    
    //  招聘信息详情
    func makeEmploymentMessage() {
        employmentMessage.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-64)
        employmentMessage.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(employmentMessage)
//        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,employmentMessage.frame.size.height - WIDTH*65/375)
        self.employmentMessageTableView.frame = CGRectMake(0, 0, employmentMessage.frame.size.width,HEIGHT-64)

        //        employmentMessageTableView.tag = 1
        //        employmentMessageTableView.backgroundColor = UIColor.redColor()
//        let tackBtn = UIButton(frame: CGRectMake(WIDTH*(WIDTH - 145 )/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
//        tackBtn.layer.cornerRadius = WIDTH*22.5/375
//        tackBtn.layer.borderColor = COLOR.CGColor
//        tackBtn.layer.borderWidth = 1
//        tackBtn.setTitle("返回", forState: .Normal)
//        tackBtn.setTitleColor(COLOR, forState: .Normal)
//        tackBtn.addTarget(self, action: #selector(self.takeResume), forControlEvents: .TouchUpInside)
//        employmentMessage.addSubview(tackBtn)
        
//        let tack = UIButton(frame: CGRectMake(WIDTH*15/375, self.employmentMessageTableView.frame.origin.y+self.employmentMessageTableView.frame.size.height+10, WIDTH*130/375, WIDTH*45/375))
//        tack.layer.cornerRadius = WIDTH*22.5/375
//        tack.layer.borderColor = COLOR.CGColor
//        tack.layer.borderWidth = 1
//        tack.setTitle("投递简历", forState: .Normal)
//        tack.setTitleColor(COLOR, forState: .Normal)
//        tack.addTarget(self, action: #selector(self.takeTheResume), forControlEvents: .TouchUpInside)
//        employmentMessage.addSubview(tack)
        
        employmentMessage.addSubview(employmentMessageTableView)
        
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
//            let height = calculateHeight(self.tit as String, size: 18, width: WIDTH-20)
            return 20+20
            }else if indexPath.row == 1 {
                return 20
            }else if indexPath.row == 2 {
                return 35
            }else if indexPath.row == 3 {
                return 50
            }else if indexPath.row == 4 {
                return 35
            }else if indexPath.row == 5 {
                return 35
            }else if indexPath.row == 6 {
            
                let height = calculateHeight(self.descripDetail as String, size: 14, width: WIDTH-20)
                return height+40
            }else if indexPath.row == 7 {
                return 35
            }
            else{
                return 100
            }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell1 = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineJobDetailsTableViewCell
        
        cell1.selectionStyle = .None
        cell1.textLabel?.numberOfLines = 0
        print(indexPath.row)
        if indexPath.row==0 {
            cell1.title.text = self.tit as String
        }else if indexPath.row == 1 {
            cell1.eyeImage.image = UIImage(named: "ic_eye_purple.png")
            cell1.lookCount.text = "3346"
            cell1.timeImage.image = UIImage(named: "ic_time_purple.png")
            cell1.timeLabel.text = "2016/03/16"
            return cell1
        }else if indexPath.row == 2 {
            cell1.nameLabel.text = "企业名称:"
            cell1.name.text = self.name as String
             return cell1
        }else if indexPath.row == 3 {
            let descripStr = "企业简介:" + (self.tit as String)
            let attrStr = NSMutableAttributedString(string: descripStr)
                    attrStr.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(15)], range: NSMakeRange(0, 5))
             attrStr.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSMakeRange(5, attrStr.length-5))
            attrStr.addAttributes([NSForegroundColorAttributeName:UIColor.lightGrayColor()], range: NSMakeRange(5, attrStr.length-5))
            cell1.descript.attributedText = attrStr
            return cell1
        }else if indexPath.row == 4 {
        
            cell1.criteria.text = "招聘条件:"
            cell1.criteriaLabel.text = self.criteriaLabel as String
            cell1.address.text = "工作地点:"
                    
            cell1.addressLabel.text = self.addressLabel as String
            return cell1
        }else if indexPath.row == 5{
            cell1.criteri.text = "招聘人数:"
            cell1.criteriLabel.text = self.criteriLabel as String
            cell1.addres.text = "福利待遇:"
            cell1.addresLabel.text = self.addresLabel as String
            return cell1
        }else if indexPath.row == 6 {
            cell1.positionDescript.text = "职位描述:"
            cell1.descripDetail.text = self.descripDetail as String
            let height = calculateHeight(self.descripDetail as String, size: 14, width: WIDTH-20)
            cell1.descripDetail.frame = CGRectMake(10, 40, WIDTH-20, height)
            return cell1
        }else if indexPath.row == 7 {
            cell1.namLabel.text = "联系方式:"
            if num == 1 {
                cell1.nam.setTitle("查看联系方式", forState: .Normal)
                cell1.nam.addTarget(self, action: #selector(contactClick), forControlEvents: .TouchUpInside)
            }else if num == 2{
                cell1.nam.setTitle(self.phone as String, forState: .Normal)
            }
            return cell1
        }
        return cell1
    }
    
    func contactClick(){
        num = 2
        self.employmentMessageTableView.reloadData()
    }
    
    func takeResume(){
        UIView.animateWithDuration(0.2) {
            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func takeTheResume() {
        print("点击了提交简历")
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        UIView.animateWithDuration(0.2) {
            self.employmentMessage.frame = CGRectMake(WIDTH, 0.5, WIDTH, HEIGHT-154.5)
        }
        
//        let model = self.jobDataSource![btnTag].companyid
        
        
        let url = PARK_URL_Header+"ApplyJob"
        let param = [
            "userid":QCLoginUserInfo.currentInfo.userid,
            //                "userid":"1",
            //                "jobid":"1"
            "jobid":strId,
            "companyid" :QCLoginUserInfo.currentInfo.userid
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                //                    handle(success: false, response: error?.description)
            }else{
                let result = Http(JSONDecoder(json!))
                if(result.status == "success"){
                    //                        handle(success: true, response: nil)
                    print(111111)
                }else{
                    //                        handle(success: false, response: nil)
                    print(2222222)
                }
            }
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
