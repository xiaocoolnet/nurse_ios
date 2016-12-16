//
//  NSCircleForumDetailViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/13.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleForumDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
//    var forumBestOrTopModelArray = [ForumModel]()
    
    var forumModel = ForumModel()
    
    var communityModel = CommunityModel()
    
    var forumCommentArray = [ForumCommentDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 详情")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 详情")
    }
    
    func loadData() {
        
        let photo1 = photoModel()
        photo1.url = "20161202/5840e94624cb0.jpg"
        let photo2 = photoModel()
        photo2.url = "20161130/583eb4efc6dad.jpg"
        let photo3 = photoModel()
        photo3.url = "20161129/583ce3b933d98.jpg"
        
        
        forumModel.title = "请问各位同行，职场新手如何‘谈薪’才合适？"
        forumModel.content = "　　儿科学属临床医学的二级学科，研究对象是自胎儿至青春期的儿童。它是一门研究小儿生长发育规律、提高小儿身心健康水平和疾病防治质量的医学科学。\n    1、学科研究范围：儿科学研究从胎儿到青春期儿童有关促进生理及心理健康成长和疾病的防治。目前有儿童保健、新生儿学、呼吸、心血管、血液、肾脏、神经、内分泌与代谢、免疫感染与消化、急救以及小儿外科等专业。每个专业学科又和基础医学某些学科有密切联系，如生理、生化、病理、遗传以及分子生物学等。\n    2、课程设置：基础理论课：生理学，病理学，生物化学，分子生物学，免疫学，医学遗传学，医学统计学，临床流行病学，电子计算机应用以及与研究课题有关的基础医学课程。\n    专业课：儿科学与研究课题有关的内科各专业课程。\n儿科学主要相关学科：内科学、外科学，神经病学，妇产科学，传染病学等。"
        forumModel.like = "1136"
        forumModel.hits = "151"
        forumModel.istop = "1"
        forumModel.isbest = "1"
        forumModel.isreward = "1"
        
        forumModel.photo = [photo1,photo2,photo3]
        
        let comment1 = ForumCommentDataModel()
        comment1.userid = "639"
        comment1.content = "谢谢您"
        comment1.major = "护士"
        comment1.cid = ""
        
        let childComment1 = ForumChildCommentDataModel()
        childComment1.userid = "617"
        childComment1.content = "自作自受，和谁也不能和他最近的人啊。还有就是他弟弟也不怎么样。"
        childComment1.add_time = ""
        childComment1.major = ""
        childComment1.userlevel = ""
        childComment1.username = "树友322j"
        childComment1.photo = ""
        childComment1.type = ""
        childComment1.pid = ""
        childComment1.cid = ""
        comment1.child_comments = [childComment1]
        
        comment1.userlevel = "5"
        comment1.username = "小丫头妈咪宝贝"
        comment1.photo = "avatar20161210111815639.png"
        comment1.refid = ""
        comment1.type = ""
        comment1.add_time = "1471762340"
        
        let comment2 = ForumCommentDataModel()
        comment2.userid = "617"
        comment2.content = "中国护士网圈子功能上线，欢迎大家测试使用~"
        comment2.major = "学生"
        comment2.cid = ""
        
//        let childComment1 = ForumChildCommentDataModel()
//        childComment1.userid = "617"
//        childComment1.content = "自作自受，和谁也不能和他最近的人啊。还有就是他弟弟也不怎么样。"
//        childComment1.add_time = ""
//        childComment1.major = ""
//        childComment1.userlevel = ""
//        childComment1.username = "树友322j"
//        childComment1.photo = ""
//        childComment1.type = ""
//        childComment1.pid = ""
//        childComment1.cid = ""
//        comment2.child_comments = [childComment1]
        
        comment2.userlevel = "6"
        comment2.username = "小丫头妈咪宝贝6小丫头妈咪宝贝"
        comment2.photo = "avatar20161210111815639.png"
        comment2.refid = ""
        comment2.type = ""
        comment2.add_time = "1471865340"
        
        self.forumCommentArray = [comment1,comment2]

        self.rootTableView.reloadData()
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        self.title = "贴子详情"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-49)
        rootTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        rootTableView.separatorStyle = .None
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(NSCircleDetailTableViewCell.self, forCellReuseIdentifier: "circleDetailCell")
        rootTableView.registerClass(NSCircleDetailTopTableViewCell.self, forCellReuseIdentifier: "circleDetailTopCell")
        rootTableView.registerNib(UINib.init(nibName: "NSCircleCommentTableViewCell", bundle: nil), forCellReuseIdentifier: "circleForumCommentCell")

        //        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
        //        rootTableView.mj_header.beginRefreshing()
        
        //        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
        
        self.setReplyView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        tableHeaderView.backgroundColor = UIColor.whiteColor()
        tableHeaderView.addTarget(self, action: #selector(tableViewHeaderViewClick), forControlEvents: .TouchUpInside)
        
        // 用户信息

        let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 35, height: 35))
        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        img.layer.cornerRadius = 17.5
        img.clipsToBounds = true
        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: 8, width: calculateWidth("用户名", size: 12, height: 17), height: 17))
        nameLab.textAlignment = .Left
        nameLab.font = UIFont.systemFontOfSize(12)
        nameLab.textColor = UIColor.blackColor()
        nameLab.text = "用户名"
        tableHeaderView.addSubview(nameLab)
        
        let positionLab = UILabel(frame: CGRect(x: nameLab.frame.maxX+8, y: 0, width: calculateWidth("护士", size: 8, height: 12)+12, height: 12))
        positionLab.font = UIFont.systemFontOfSize(8)
        positionLab.textColor = UIColor.whiteColor()
        positionLab.layer.backgroundColor = COLOR.CGColor
        positionLab.textAlignment = .Center
        positionLab.center.y = nameLab.center.y
        positionLab.layer.cornerRadius = 6
        positionLab.text = "护士"
        tableHeaderView.addSubview(positionLab)

        let levelLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY+1, width: calculateWidth("Lv.35", size: 10, height: 17), height: 17))
        levelLab.font = UIFont.systemFontOfSize(10)
        levelLab.textColor = COLOR
        levelLab.textAlignment = .Center
        levelLab.text = "Lv.35"
        tableHeaderView.addSubview(levelLab)
        
        let timeLab = UILabel(frame: CGRect(
            x: WIDTH-10-calculateWidth("3分钟前", size: 10, height: 17),
            y: (50-UIFont.systemFontOfSize(10).lineHeight)/2.0,
            width: calculateWidth("3分钟前", size: 10, height: UIFont.systemFontOfSize(10).lineHeight),
            height: UIFont.systemFontOfSize(10).lineHeight))
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = UIColor(red: 128/255.0, green: 128/255.0, blue: 128/255.0, alpha: 1)
        timeLab.text = "3分钟前"
        tableHeaderView.addSubview(timeLab)
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    let replyView = UIView()
    var send_bottom_Btn:UIButton = UIButton() // 下方发送按钮
    let replyTextField = UIPlaceHolderTextView()
    var keyboardShowState = false
    
    // MARK: 设置回复视图
    func setReplyView() {
        // 回复 视图
        replyView.frame = CGRectMake(0, HEIGHT-49-65, WIDTH, 49)
        replyView.backgroundColor = UIColor(red: 244/255.0, green: 245/255.0, blue: 246/255.0, alpha: 1)
        
        // 回复框
        replyTextField.frame = CGRectMake(10, 8, WIDTH-10-10-80-10, 33)
        replyTextField.layer.cornerRadius = 6
        //        replyTextField.borderStyle = UITextBorderStyle.RoundedRect
        replyTextField.placeholder = "回复"
        replyTextField.font = UIFont.systemFontOfSize(14)
        replyTextField.returnKeyType = UIReturnKeyType.Send
        replyTextField.delegate = self
        replyView.addSubview(replyTextField)
        
        // 发送
        send_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(replyTextField.frame)+10, 8, 80, 33)
        send_bottom_Btn.layer.cornerRadius = 6
        send_bottom_Btn.backgroundColor = UIColor.grayColor()
        send_bottom_Btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        send_bottom_Btn.titleLabel!.font = UIFont.systemFontOfSize(14)
        send_bottom_Btn.setTitle("发送", forState: .Normal)
//        send_bottom_Btn.tag = NSString(string: (newsInfo?.object_id)!).integerValue
        send_bottom_Btn.addTarget(self, action: #selector(sendComment), forControlEvents: .TouchUpInside)
        replyView.addSubview(send_bottom_Btn)
        
        let line_topView:UIView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 1/UIScreen.mainScreen().scale))
        line_topView.backgroundColor = UIColor.lightGrayColor()
        replyView.addSubview(line_topView)
        
        self.view.addSubview(replyView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - 获取键盘信息并改变视图
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        replyView.frame = CGRectMake(0, HEIGHT-86-33-8-65, WIDTH, 86+33+8)
        replyTextField.frame.size = CGSizeMake(WIDTH-30, 70)
        send_bottom_Btn.frame = CGRect(x: replyTextField.frame.maxX-80, y: replyTextField.frame.maxY+8, width: 80, height: 33)
        
        UIView.animateWithDuration(0.3) {
            self.replyView.frame.origin.y = HEIGHT-86-33-65-keyboardheight
        }
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
        keyboardShowState = true
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            self.replyView.frame = CGRectMake(0, HEIGHT-49-65, WIDTH, 49)
            self.replyTextField.frame = CGRectMake(10, 8, WIDTH-10-10-80-10, 33)
            self.send_bottom_Btn.frame = CGRectMake(CGRectGetMaxX(self.replyTextField.frame)+10, 8, 80, 33)

            //            self.rootTableView.frame.size.height = HEIGHT-64-1-46
        }
        // print("键盘落下")
    }
    // MARK: -
    
    // MARK: - UITextViewDelegate
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        // MARK:要求登录
        if requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            
            HSMineHelper().getPersonalInfo { (success, response) in
                if success {
                    
                    
                }else{
                    
                }
            }
            return true
        }else{
            return false
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        self.send_bottom_Btn.selected = false
//        self.send_bottom_Btn.tag = NSString(string: ("111")).integerValue
        self.replyTextField.placeholder = "回复"
    }
    
    func textViewDidChange(textView: UITextView) {
        if textView.text.characters.count > 0 {
            send_bottom_Btn.backgroundColor = COLOR
        }else{
            send_bottom_Btn.backgroundColor = UIColor.whiteColor()
        }
    }
    // MARK: -
    
    // MARK: - 去除空格和回车
    func trimLineString(str:String)->String{
        let nowStr = str.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        return nowStr
    }
    //  MARK: - 发表评论
    func sendComment() {
        
        
        if replyTextField.text != "" && trimLineString(replyTextField.text) != ""{
            
            
            
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.labelText = "正在发表评论"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            
//            HSNurseStationHelper().setComment(
//                String(self.send_bottom_Btn.tag),
//                content: (replyTextField.text)!,
//                type: self.send_bottom_Btn.selected ? "3":"1",
//                photo: "",
//                handle: { (success, response) in
//                    // print("添加评论",success,response)
//                    let result = response as! addScore_ReadingInformationDataModel
//                    if success {
//                        
//                        let url = PARK_URL_Header+"getRefComments"
//                        let param = [
//                            "refid": ""
//                        ];
//                        
//                        
//                        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
//                            
//                            if(error != nil){
//                                
//                                hud.mode = MBProgressHUDMode.Text;
//                                hud.labelText = "评论失败"
//                                
//                                hud.hide(true, afterDelay: 1)
//                            }else{
//                                let status = commentModel(JSONDecoder(json!))
//                                
//                                if(status.status == "error"){
//                                    
//                                    hud.mode = MBProgressHUDMode.Text;
//                                    hud.labelText = "评论失败"
//                                    
//                                    hud.hide(true, afterDelay: 1)
//                                }
//                                if(status.status == "success"){
//                                    
//                                    hud.mode = MBProgressHUDMode.Text;
//                                    hud.labelText = "评论成功"
//                                    hud.hide(true, afterDelay: 1)
//                                    
//                                    self.replyTextField.placeholder = "写评论..."
////                                    self.send_bottom_Btn.tag = NSString(string: (self.newsInfo?.object_id)!).integerValue
//                                    self.send_bottom_Btn.selected = false
//                                    
////                                    self.commentArray = status.data
//                                    self.rootTableView.reloadData()
//                                    
////                                    if ((result.event) != "") {
////                                        self.showScoreTips((result.event), score: (result.score))
////                                    }
//                                    
//                                    self.rootTableView.contentOffset.y = self.rootTableView.contentSize.height-self.rootTableView.frame.size.height
//                                    
//                                }
//                            }
//                        }
//                        
//                        self.replyTextField.text = nil
//                        
//                    }else{
//                        dispatch_async(dispatch_get_main_queue(), {
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.labelText = "评论失败"
//                            hud.hide(true, afterDelay: 1)
//                        })
//                    }
//            })
            replyTextField.resignFirstResponder()
        }else{
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "请输入内容"
            hud.hide(true, afterDelay: 1)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if keyboardShowState == true {
            
            replyTextField.resignFirstResponder()
            keyboardShowState = false
        }
    }
    
    // MARK:- tableView header click
    func tableViewHeaderViewClick() {
        self.navigationController?.pushViewController(NSCircleHomeViewController(), animated: true)
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 2
        }else if section == 1 {
            if self.forumCommentArray.count == 0 {
                return 1
            }else{
                
                return (self.forumCommentArray.count)
            }
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("forumDetailCell")
            
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "forumDetailCell")
                cell?.selectionStyle = .None
                cell?.textLabel?.numberOfLines = 0
            }
            
            switch indexPath.row {
            case 0:
                cell?.textLabel?.font = UIFont.systemFontOfSize(18)
                cell?.textLabel?.textColor = UIColor.blackColor()
                cell?.textLabel?.textAlignment = .Center
                cell?.textLabel?.text = forumModel.title
                
            case 1:
                cell?.textLabel?.font = UIFont.systemFontOfSize(14)
                cell?.textLabel?.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
                cell?.textLabel?.textAlignment = .Left
                cell?.textLabel?.text = forumModel.content
                
            default:
                break
            }
            
            
            return cell!
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("circleForumCommentCell") as! NSCircleCommentTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        if self.forumCommentArray.count == 0 {
            cell.textLabel?.text = "暂无评论"
            cell.textLabel?.textColor = UIColor.grayColor()
            cell.textLabel?.textAlignment = .Center
            
            cell.nameLab.text = nil
            cell.contentLab.text = nil
            cell.timeLab.text = nil
            cell.headerBtn.setImage(nil, forState: .Normal)
        }else{
            cell.textLabel?.text = nil
            cell.floorLab.text = "\(self.forumCommentArray.count-indexPath.row)楼"
            cell.commentModel = self.forumCommentArray[indexPath.row]
            cell.reportBtn.addTarget(self, action: #selector(reportBtnClick(_:)), forControlEvents: .TouchUpInside)
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return calculateHeight(forumModel.title, size: 18, width: WIDTH-48)+20
            case 1:
                return calculateHeight(forumModel.content, size: 14, width: WIDTH-48)+20
            default:
                break
            }
            return 0
        }
        if self.forumCommentArray.count == 0 {
            return 100
        }else{
            
            let height = calculateHeight((self.forumCommentArray[indexPath.row].content), size: 14, width: WIDTH-10-16)
            
            var child_commentBtnY = height+8+40+8+8
            for child_comment in (self.forumCommentArray[indexPath.row].child_comments) {
                
                let child_commentBtnHeight = child_comment.content.boundingRectWithSize(
                    CGSizeMake(WIDTH-60-10-16, 0),
                    options: .UsesLineFragmentOrigin,
                    attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)],
                    context: nil).size.height+10
                
                child_commentBtnY += child_commentBtnHeight+25+5
                
            }
            
            return child_commentBtnY+8+7+8+1
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 0 ? 50:0.001
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let contentView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
            contentView.backgroundColor = UIColor.whiteColor()
            
            let collectBtn = UIButton(frame: CGRect(x: 20, y: 8, width: 30, height: 30))
            collectBtn.tag == 100
            collectBtn.layer.cornerRadius = 15
//            collectBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            collectBtn.setImage(UIImage(named: "收藏（默认）"), forState: .Normal)
            collectBtn.setImage(UIImage(named: "收藏"), forState: .Selected)
            collectBtn.addTarget(self, action: #selector(collectBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(collectBtn)
            
            let collectNumLab = UILabel(frame: CGRect(x: collectBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            collectNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            collectNumLab.font = UIFont.systemFontOfSize(14)
            collectNumLab.text = forumModel.hits
            collectNumLab.sizeToFit()
            collectNumLab.center.y = collectBtn.center.y
            contentView.addSubview(collectNumLab)
            
            let likeBtn = UIButton(frame: CGRect(x: collectNumLab.frame.maxX+20, y: 8, width: 30, height: 30))
            likeBtn.tag == 101
            likeBtn.layer.cornerRadius = 15
//            likeBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            //                likeBtn.setImage(UIImage(named: "点赞（默认）"), forState: .Normal)
            likeBtn.setImage(UIImage(named: "点赞"), forState: .Normal)
            likeBtn.addTarget(self, action: #selector(likeBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(likeBtn)
            
            let likeNumLab = UILabel(frame: CGRect(x: likeBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            likeNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            likeNumLab.font = UIFont.systemFontOfSize(14)
            likeNumLab.text = forumModel.like
            likeNumLab.sizeToFit()
            likeNumLab.center.y = likeBtn.center.y
            contentView.addSubview(likeNumLab)
            
            let rewardBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+20, y: 8, width: 30, height: 30))
            rewardBtn.tag == 102
            rewardBtn.layer.cornerRadius = 15
//            rewardBtn.layer.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1).CGColor
            rewardBtn.setImage(UIImage(named: "打赏（默认）"), forState: .Normal)
            rewardBtn.setImage(UIImage(named: "打赏"), forState: .Selected)
            rewardBtn.addTarget(self, action: #selector(rewardBtnClick(_:)), forControlEvents: .TouchUpInside)
            contentView.addSubview(rewardBtn)
            
            let rewardNumLab = UILabel(frame: CGRect(x: rewardBtn.frame.maxX+8, y: 0, width: 0, height: 0))
            rewardNumLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            rewardNumLab.font = UIFont.systemFontOfSize(14)
            rewardNumLab.text = "打赏"
            rewardNumLab.sizeToFit()
            rewardNumLab.center.y = rewardBtn.center.y
            contentView.addSubview(rewardNumLab)
            
            let moreBtn = UIButton(frame: CGRect(x: likeNumLab.frame.maxX+10, y: 8, width: 30, height: 30))
            
            moreBtn.setTitle("···", forState: .Normal)
            moreBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
            moreBtn.layer.cornerRadius = 2
            moreBtn.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
            moreBtn.backgroundColor = UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1)
            
            let moreBtnWidth = calculateWidth("···", size: 18, height: 10)+10
            moreBtn.frame = CGRect(x: contentView.frame.width-20-moreBtnWidth, y: 0, width: moreBtnWidth, height: 15)
            moreBtn.center.y = rewardNumLab.center.y
            
            moreBtn.addTarget(self, action: #selector(moreBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            contentView.addSubview(moreBtn)
            
            return contentView
        }else{
            return nil
        }

    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 15))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("点击cell")
        
        replyTextField.placeholder = "回复\(self.forumCommentArray[indexPath.row].username)"
        replyTextField.becomeFirstResponder()
    }
    
    // MARK: - 举报 按钮点击事件
    func reportBtnClick(reportBtn:UIButton) {
        print("举报 按钮点击事件",reportBtn.tag)
        
        NSCirclePublicAction.showReportAlert()
    }
    
    // MARK: - moreBtnClick
    func moreBtnClick(moreBtn:UIButton) {
        print(moreBtn.tag)
        
        
        //        let alert =
//        let labelTextArray = ["加精","置顶","删除","取消"]
//        let labelTextColorArray = [COLOR,COLOR,UIColor.blackColor(),UIColor.lightGrayColor()]

        let labelTextArray = ["举报","取消"]
        let labelTextColorArray = [UIColor.blackColor(),UIColor.lightGrayColor()]

        NSCirclePublicAction.showSheet(with: labelTextArray, buttonTitleColorArray: labelTextColorArray)
        
    }
    
    // MARK: - 收藏、点赞、打赏 按钮点击事件
    func collectBtnClick(collectBtn:UIButton) {
        print("1")
    }
    func likeBtnClick(likeBtn:UIButton) {
        print("2")
    }
    
    func rewardBtnClick(rewardBtn:UIButton) {
        print("3")
        
        NSCirclePublicAction.showAlert()
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
