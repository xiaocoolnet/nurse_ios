//
//  NSCircleHomeViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleHomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var communityModel = CommunityListDataModel()
    var isJoin = false

    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var cellNameArray = ["置顶贴","精华贴","申请圈主","取消关注"]
    
    var masterListModelArray = [MasterListDataModel]()

//    var communityModel = CommunityModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        self.loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 详情")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 详情")
    }
    
    // MARK: - 加载数据
    func loadData() {
        CircleNetUtil.getMasterList(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, pager: "") { (success, response) in
            if success {
                self.masterListModelArray = response as! [MasterListDataModel]
                self.setTableViewHeaderView()
            }
        }
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        self.title = "圈子详情"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        rootTableView.backgroundColor = UIColor.white
        
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleHomeTableViewCell.self, forCellReuseIdentifier: "circleHomeCell")
        
        self.view.addSubview(rootTableView)
        
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView(_ unfoldIntroduce:Bool = false) {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH/375*60+20))
        
        let btn2Width = WIDTH/375*80
        
        // 圈子
//        let imgBgView = UIView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
//        imgBgView.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
//        tableHeaderView.addSubview(imgBgView)
        
        let img = UIImageView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
        //        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleAspectFit
        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
        tableHeaderView.addSubview(img)
        
//        let img = UIImageView(frame: CGRect(x: 8, y: 10, width: btn2Width, height: WIDTH/375*60))
//        img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
//        img.contentMode = .center
//        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
//        tableHeaderView.addSubview(img)
        
        let nameLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: img.frame.minY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        nameLab.textAlignment = .left
        nameLab.font = UIFont.systemFont(ofSize: 18)
        nameLab.textColor = COLOR
        nameLab.text = communityModel.community_name
        tableHeaderView.addSubview(nameLab)
        
        let countLab = UILabel(frame: CGRect(x: img.frame.maxX+8, y: nameLab.frame.maxY, width: WIDTH-88-btn2Width-16, height: WIDTH/375*30))
        countLab.textAlignment = .left
        countLab.font = UIFont.systemFont(ofSize: 12)
        countLab.textColor = UIColor.lightGray
        countLab.adjustsFontSizeToFitWidth = true
        var personNum = "\(communityModel.person_num)人"
        
        if NSString(string: communityModel.person_num).doubleValue >= 10000 {
            personNum = NSString(format: "%.2f万人", NSString(string: communityModel.person_num).doubleValue/10000.0) as String
        }
        
        var forumNum = "\(communityModel.f_count)贴子"
        
        if NSString(string: communityModel.f_count).doubleValue >= 10000 {
            forumNum = NSString(format: "%.2f万贴子", NSString(string: communityModel.f_count).doubleValue/10000.0) as String
        }
        
        countLab.text = "\(personNum) \(forumNum)"
        tableHeaderView.addSubview(countLab)
        
        let joinBtn = UIButton(frame: CGRect(x: WIDTH-88, y: tableHeaderView.frame.height/2.0-15, width: 80, height: 30))
        joinBtn.layer.cornerRadius = 4
        joinBtn.layer.borderColor = COLOR.cgColor
        joinBtn.layer.borderWidth = 1
        joinBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        joinBtn.setTitleColor(COLOR, for: UIControlState())
        joinBtn.setTitleColor(UIColor.white, for: .selected)
        joinBtn.setTitle("加入", for: UIControlState())
        joinBtn.setTitle("已加入", for: .selected)
        joinBtn.setImage(UIImage(named: "加入"), for: UIControlState())
        joinBtn.setImage(UIImage(named: "已加入"), for: .selected)
        joinBtn.addTarget(self, action: #selector(joinBtnClick(_:)), for: .touchUpInside)
        tableHeaderView.addSubview(joinBtn)
        //        joinBtn.backgroundColor = COLOR
        //        joinBtn.selected = true
        joinBtn.backgroundColor = UIColor.white
        //        joinBtn.selected = false
        
        if isJoin {
            joinBtn.backgroundColor = COLOR
            joinBtn.isSelected = true
        }else{
            joinBtn.backgroundColor = UIColor.white
            joinBtn.isSelected = false
        }
        
        let line = UIView(frame: CGRect(x: 0, y: img.frame.maxY+img.frame.minY, width: WIDTH, height: 2/UIScreen.main.scale))
        line.backgroundColor = UIColor.lightGray
        tableHeaderView.addSubview(line)
        
        // 圈子介绍
        let introduceTagLab = UILabel(frame: CGRect(x: 8, y: line.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFont(ofSize: 14).lineHeight))
        introduceTagLab.textAlignment = .left
        introduceTagLab.font = UIFont.systemFont(ofSize: 14)
        introduceTagLab.textColor = UIColor.gray
        introduceTagLab.text = "圈子介绍"
        tableHeaderView.addSubview(introduceTagLab)
        
        let introduceBtn = UIButton(frame: CGRect(x: 8, y: introduceTagLab.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFont(ofSize: 14).lineHeight))
        introduceBtn.titleLabel?.numberOfLines = 0
        introduceBtn.contentHorizontalAlignment = .left
        introduceBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        introduceBtn.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), for: UIControlState())

        let introduceStr:NSString = communityModel.description as NSString
        if introduceStr.length > 40 {
            
            let range = NSMakeRange(40, introduceStr.length-40)
            let cutIntroduceStr = introduceStr.length > 40 ? introduceStr.replacingCharacters(in: range, with: "..."):introduceStr as String
            let attrStr = NSMutableAttributedString(string: "    \(cutIntroduceStr) 展开")
            attrStr.addAttributes([NSForegroundColorAttributeName:UIColor(red: 28/255.0, green: 159/255.0, blue: 227/255.0, alpha: 1),NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(attrStr.length-2, 2))
            
            let attrStrUnfold = NSMutableAttributedString(string: "    \(introduceStr) 收起")
            
            attrStrUnfold.addAttributes([NSForegroundColorAttributeName:UIColor(red: 28/255.0, green: 159/255.0, blue: 227/255.0, alpha: 1),NSUnderlineStyleAttributeName:NSUnderlineStyle.styleSingle.rawValue], range: NSMakeRange(attrStrUnfold.length-2, 2))
            
            introduceBtn.setAttributedTitle(attrStr, for: UIControlState())
            introduceBtn.setAttributedTitle(attrStrUnfold, for: .selected)
            introduceBtn.isSelected = unfoldIntroduce
            introduceBtn.frame.size.height = calculateHeight(introduceBtn.currentAttributedTitle!.string, size: 14, width: WIDTH-16)
            introduceBtn.addTarget(self, action: #selector(introduceBtnClick(_:)), for: .touchUpInside)
        }else{
            introduceBtn.setTitle("    \(introduceStr)", for: UIControlState())
            introduceBtn.frame.size.height = calculateHeight("    \(introduceStr)", size: 14, width: WIDTH-16)
        }
        
        tableHeaderView.addSubview(introduceBtn)
        
        // MARK: - 圈主
        let managerTagLab = UILabel(frame: CGRect(x: 8, y: introduceBtn.frame.maxY+10, width: WIDTH-16, height: UIFont.systemFont(ofSize: 14).lineHeight))
        managerTagLab.textAlignment = .left
        managerTagLab.font = UIFont.systemFont(ofSize: 14)
        managerTagLab.textColor = UIColor.gray
        managerTagLab.text = "圈主"
        tableHeaderView.addSubview(managerTagLab)
        
        let managerBgView = UIView(frame: CGRect(x: 8, y: managerTagLab.frame.maxY+10, width: WIDTH-16, height: 0))
        tableHeaderView.addSubview(managerBgView)
        
        let margin = (WIDTH-16)/12
        for i in 0 ..< 3 {
            let headerImg = UIImageView(frame: CGRect(x: margin+(margin*4*CGFloat(i)), y: 0, width: margin*2, height: margin*2))
//            headerImg.backgroundColor = UIColor.lightGray
            headerImg.layer.cornerRadius = margin
            headerImg.clipsToBounds = true
            
            managerBgView.addSubview(headerImg)
            
            let nameLab = UILabel(frame: CGRect(x: margin*4*CGFloat(i), y: headerImg.frame.maxY+10, width: margin*4, height: UIFont.systemFont(ofSize: 12).lineHeight))
            nameLab.textAlignment = .center
            nameLab.font = UIFont.systemFont(ofSize: 12)
            nameLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            managerBgView.addSubview(nameLab)
            
            if i < self.masterListModelArray.count {
                headerImg.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+self.masterListModelArray[i].user_photo), placeholderImage: #imageLiteral(resourceName: "申请圈主（默认）"))
                nameLab.text = self.masterListModelArray[i].user_name
            }else{
                headerImg.image = #imageLiteral(resourceName: "申请圈主（默认）")
                nameLab.text = "还有空位哦~"
            }
        }
        
        managerBgView.frame.size.height = margin*2+10+UIFont.systemFont(ofSize: 12).lineHeight
        
//        let introduceLab = UILabel(frame: CGRect(x: 8, y: introduceTagLab.frame.maxY+8, width: WIDTH-16, height: UIFont.systemFontOfSize(14).lineHeight))
//        introduceLab.numberOfLines = 0
//        introduceLab.textAlignment = .Left
//        introduceLab.font = UIFont.systemFontOfSize(14)
//        introduceLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
//        
//        introduceLab.attributedText = attrStr
//        introduceLab.sizeToFit()
//        tableHeaderView.addSubview(introduceLab)
        
        tableHeaderView.frame.size.height = managerBgView.frame.maxY+10
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // MARK: - 加入按钮点击事件
    func joinBtnClick(_ joinBtn:UIButton) {
        
        if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
            
        }else{
            return
        }
        
        if isJoin {
            
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "您已加入该圈子"
            hud.hide(animated: true, afterDelay: 1.5)
            return
        }else{
            CircleNetUtil.addCommunity(userid: QCLoginUserInfo.currentInfo.userid, cid: communityModel.id, handle: { (success, response) in
                if success {
                    joinBtn.isSelected = !joinBtn.isSelected
                    joinBtn.backgroundColor = joinBtn.isSelected ? COLOR:UIColor.white
                    self.isJoin = !self.isJoin
                }
            })
        }
        
    }
    
    // MARK: - 点击展开按钮
    func introduceBtnClick(_ introduceBtn:UIButton) {
        setTableViewHeaderView(!introduceBtn.isSelected)
    }
    
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleHomeCell", for: indexPath) as! NSCircleHomeTableViewCell
        
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        
//        cell.setCellWithNewsInfo(forumModelArray[indexPath.row])
        cell.setCellWith(cellNameArray[indexPath.row], imageName: cellNameArray[indexPath.row], noteStr: nil)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    //    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
    //        footerView.addTarget(self, action: #selector(footerViewClick), forControlEvents: .TouchUpInside)
    //
    //        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
    //        nameBtn.setImage(UIImage(named: "精华贴"), forState: .Normal)
    //        nameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
    //        nameBtn.setTitleColor(COLOR, forState: .Normal)
    //        nameBtn.setTitle("内科", forState: .Normal)
    //        nameBtn.sizeToFit()
    //        nameBtn.frame.origin = CGPoint(x: 8, y: (35-nameBtn.frame.height)/2.0)
    //        footerView.addSubview(nameBtn)
    //
    //        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
    //        comeinLab.textAlignment = .Right
    //        comeinLab.font = UIFont.systemFontOfSize(12)
    //        comeinLab.textColor = COLOR
    //        comeinLab.text = "进入圈子"
    //        footerView.addSubview(comeinLab)
    //
    //        return footerView
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            let forumListController = NSCircleForumListViewController()
            forumListController.title = "置顶贴子列表"
            forumListController.communityId = self.communityModel.id
            forumListController.isTop = "1"
            forumListController.isBest = ""
            self.navigationController?.pushViewController(forumListController, animated: true)
        case 1:
            let forumListController = NSCircleForumListViewController()
            forumListController.title = "加精贴子列表"
            forumListController.communityId = self.communityModel.id
            forumListController.isTop = ""
            forumListController.isBest = "1"
            self.navigationController?.pushViewController(forumListController, animated: true)
        case 2:
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            // 申请圈主
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            
            CircleNetUtil.judge_apply_community(userid: QCLoginUserInfo.currentInfo.userid, cid: "", handle: { (success, response) in
                if success {
                    let isMaster = response as! String
                    if isMaster == "yes" {
                        hud.mode = .text
                        hud.label.text = "您已经是圈主了"
                        hud.hide(animated: true, afterDelay: 1)
                    }else{
                        hud.hide(animated: true)
                        let circleApplyMasterController = NSCircleApplyMasterViewController()
                        circleApplyMasterController.circleName = self.communityModel.community_name
                        circleApplyMasterController.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(circleApplyMasterController, animated: true)
                    }
                }else{
                    hud.mode = .text
                    hud.label.text = "请稍后再试"
                    hud.hide(animated: true, afterDelay: 1)
                }
            })

        case 3:
            if requiredLogin(self.navigationController, previousViewController: self, hiddenNavigationBar: false) {
                
            }else{
                return
            }
            let alert = UIAlertController(title: "取消关注?", message: "确定取消关注 \(communityModel.community_name)", preferredStyle: .alert)
            
            let sureAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                CircleNetUtil.delJoinCommunity(userid: QCLoginUserInfo.currentInfo.userid, cid: self.communityModel.id, handle: { (success, response) in
                    if success {
                        self.isJoin = false
                        self.setTableViewHeaderView()
                        
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.removeFromSuperViewOnHide = true
                        hud.mode = .text
                        hud.label.text = "取消关注圈子成功"
                        hud.hide(animated: true, afterDelay: 1)
                        
                    }else{
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.removeFromSuperViewOnHide = true
                        hud.mode = .text
                        hud.label.text = "取消关注圈子成功"
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            })
            
            alert.addAction(sureAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        default:
            break
        }
        
    }
    
    // 调整 button 图片和文字
    func initButton(_ btn:UIButton) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.center//使图片和文字水平居中显示
        btn.titleEdgeInsets = UIEdgeInsetsMake((btn.imageView!.frame.size.height+btn.titleLabel!.bounds.size.height)/2+8, -btn.imageView!.frame.size.width, 0.0,0.0)//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,(btn.imageView!.frame.size.height+btn.titleLabel!.bounds.size.height)/2+5, -btn.titleLabel!.bounds.size.width)//图片距离右边框距离减少图片的宽度，其它不边
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
