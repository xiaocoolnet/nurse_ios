//
//  NSCircleDiscoverViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let rootTableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var forumModelArray = [ForumListDataModel]()
    var communityModelArray = [CommunityListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 发现")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 发现")
    }
    
    func loadData() {
        
        CircleNetUtil.getForumList(userid: QCLoginUserInfo.currentInfo.userid, cid: "", isbest: "", istop: "", pager: "") { (success, response) in
            if success {
                self.forumModelArray = response as! [ForumListDataModel]
                self.rootTableView.reloadData()
            }
            self.rootTableView.mj_header.endRefreshing()
        }
        
        CircleNetUtil.getCommunityList(userid: QCLoginUserInfo.currentInfo.userid, term_id: "", best: "", hot: "1", pager: "") { (success, response) in
            if success {
                self.communityModelArray = response as! [CommunityListDataModel]
                self.setTableViewHeaderView()
            }
        }
       
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65-45-49)
        rootTableView.backgroundColor = UIColor.white

        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.register(NSCircleDiscoverTableViewCell.self, forCellReuseIdentifier: "circleDiscoverCell")

        rootTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        rootTableView.mj_header.beginRefreshing()
        
//        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        
        var messageBtnMaxY:CGFloat = 0
        if false {
            let messageCount = "2"
            let messageBtn = UIButton(frame: CGRect(x: 8, y: 10, width: WIDTH-16, height: 35))
            messageBtn.backgroundColor = UIColor(white: 0.95, alpha: 1)
            
            messageBtn.setImage(UIImage(named: "新消息"), for: UIControlState())
            let titleAttrStr = NSMutableAttributedString(string: "您有 \(messageCount) 条新消息", attributes: [NSForegroundColorAttributeName:UIColor.gray,NSFontAttributeName:UIFont.systemFont(ofSize: 15)])
            titleAttrStr.addAttributes([NSForegroundColorAttributeName:COLOR], range: NSMakeRange(3, NSString(string: messageCount).length))
            messageBtn.setAttributedTitle(titleAttrStr, for: UIControlState())
            tableHeaderView.addSubview(messageBtn)
            messageBtnMaxY = messageBtn.frame.maxY
        }
        
        // "精选圈子","热门圈子","全部圈子"
        let btn1Width = (WIDTH-32)/3.0
        let btn1Height = btn1Width*0.65
        let btn1ColorArray = [
            UIColor(red: 34/255.0, green: 156/255.0, blue: 77/255.0, alpha: 1),
            UIColor(red: 80/255.0, green: 135/255.0, blue: 201/255.0, alpha: 1),
            UIColor(red: 164/255.0, green: 93/255.0, blue: 227/255.0, alpha: 1)]
        let btn1NameArray = ["精选圈子","热门圈子","全部圈子"]
        for i in 0 ..< 3 {
            let btn1 = UIButton(frame: CGRect(x: 8+(btn1Width+8)*CGFloat(i), y: messageBtnMaxY+10, width: btn1Width, height: btn1Height))
            btn1.tag = 100+i
            btn1.backgroundColor = btn1ColorArray[i]
            btn1.setImage(UIImage(named: btn1NameArray[i]), for: UIControlState())
            btn1.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn1.setTitle(btn1NameArray[i], for: UIControlState())
            initButton(btn1)
            btn1.addTarget(self, action: #selector(btn1Click(_:)), for: .touchUpInside)
            tableHeaderView.addSubview(btn1)
        }
        
        // "热门圈子推荐"
        let recommendLab = UILabel(frame: CGRect(x: 8, y: messageBtnMaxY+10+btn1Height, width: WIDTH-16, height: 35))
        recommendLab.textAlignment = .left
        recommendLab.font = UIFont.systemFont(ofSize: 14)
        recommendLab.textColor = UIColor.lightGray
        recommendLab.text = "热门圈子推荐"
        tableHeaderView.addSubview(recommendLab)
        
        // 推荐的圈子
        let btn2ScrollView = UIScrollView(frame: CGRect(x: 0, y: recommendLab.frame.maxY, width: WIDTH, height: 0))
        btn2ScrollView.showsVerticalScrollIndicator = false
        btn2ScrollView.showsHorizontalScrollIndicator = false
        tableHeaderView.addSubview(btn2ScrollView)
        
        let btn2Width = WIDTH/375*100
        var btn2Height:CGFloat = 0

        for (i,communityModel) in communityModelArray.enumerated() {
            let btn2 = UIButton(frame: CGRect(x: 8+(btn2Width+8)*CGFloat(i), y: 0, width: btn2Width, height: 0))
            btn2.tag = 200+i

//            btn2.setImage(UIImage(named: btn2NameArray[i]), forState: .Normal)
            btn2.addTarget(self, action: #selector(btn2Click(_:)), for: .touchUpInside)
            btn2ScrollView.addSubview(btn2)
            
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
            img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
            img.contentMode = .center
            img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+communityModel.photo), placeholderImage: nil)
            btn2.addSubview(img)
            
            let nameLab = UILabel(frame: CGRect(x: 0, y: img.frame.maxY, width: btn2Width, height: WIDTH/375*22))
            nameLab.textAlignment = .left
            nameLab.font = UIFont.systemFont(ofSize: 14)
            nameLab.textColor = COLOR
            nameLab.text = communityModel.community_name
            nameLab.adjustsFontSizeToFitWidth = true
            btn2.addSubview(nameLab)
            
            let countLab = UILabel(frame: CGRect(x: 0, y: nameLab.frame.maxY, width: btn2Width, height: WIDTH/375*15))
            countLab.textAlignment = .left
            countLab.font = UIFont.systemFont(ofSize: 10)
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
            btn2.addSubview(countLab)
            
            btn2.frame.size.height = countLab.frame.maxY
            btn2Height = btn2.frame.size.height
            
            btn2ScrollView.frame.size.height = btn2.frame.size.height
            
        }
        
        btn2ScrollView.contentSize = CGSize(width: 8+(btn2Width+8)*CGFloat(communityModelArray.count), height: 0)

        
        tableHeaderView.frame.size.height = recommendLab.frame.maxY+btn2Height+8
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // btn1 点击事件
    func btn1Click(_ btn1:UIButton) {
        switch btn1.tag {
        case 100:
            print("精选圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            circleListController.titleString = "精选圈子"
            circleListController.best = "1"
            self.navigationController?.pushViewController(circleListController, animated: true)
        case 101:
            print("热门圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            circleListController.titleString = "热门圈子"
            circleListController.hot = "1"
            self.navigationController?.pushViewController(circleListController, animated: true)
        case 102:
            print("全部圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            circleListController.titleString = "圈子列表"
            self.navigationController?.pushViewController(circleListController, animated: true)
        default:
            break
        }
    }
    
    // btn2 点击事件
    func btn2Click(_ btn2:UIButton) {
        
        print("点击热门圈子推荐 之 \(btn2.tag-200)")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.communityModel = communityModelArray[btn2.tag-200]
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)

    }
    
    // MARK: - UItableViewdatasource
    func numberOfSections(in tableView: UITableView) -> Int {
        return forumModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "circleDiscoverCell", for: indexPath) as! NSCircleDiscoverTableViewCell

        cell.selectionStyle = .none
        
        cell.setCell(with: forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    fileprivate let titleSize:CGFloat = 14
    fileprivate let contentSize:CGFloat = 12
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let forum = forumModelArray[indexPath.section]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)

            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            return 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 8+80+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFont(ofSize: contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFont(ofSize: contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 8+height+8+contentHeight+8+imgHeight+8+8+8// 上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
        footerView.tag = 100 + section
        footerView.addTarget(self, action: #selector(footerViewClick(footerBtn:)), for: .touchUpInside)
        
        let img = UIImageView(frame: CGRect(x: 8, y: 8, width: 25, height: 19))
        img.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+forumModelArray[section].community_photo), placeholderImage: nil)
        img.contentMode = .scaleAspectFit
        img.clipsToBounds = true
        footerView.addSubview(img)
        
        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        nameBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        nameBtn.setTitleColor(COLOR, for: UIControlState())
        nameBtn.setTitle(forumModelArray[section].community_name, for: UIControlState())
        nameBtn.sizeToFit()
        nameBtn.frame.origin = CGPoint(x: img.frame.maxX+5, y: (35-nameBtn.frame.height)/2.0)
        footerView.addSubview(nameBtn)
        
        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
        comeinLab.textAlignment = .right
        comeinLab.font = UIFont.systemFont(ofSize: 12)
        comeinLab.textColor = COLOR
        comeinLab.text = "进入圈子"
        footerView.addSubview(comeinLab)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("贴子详情")
        
        let forumDetailController = NSCircleForumDetailViewController()
        forumDetailController.hidesBottomBarWhenPushed = true
        forumDetailController.forumDataModel = forumModelArray[indexPath.section]
        self.navigationController?.pushViewController(forumDetailController, animated: true)
    }
    
    // footerView 点击事件
    func footerViewClick(footerBtn:UIButton)  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        circleDetailController.communityId = self.forumModelArray[footerBtn.tag-100].community_id
        self.navigationController?.pushViewController(circleDetailController, animated: true)
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
