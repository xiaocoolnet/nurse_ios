//
//  NSCircleDiscoverViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCircleDiscoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let rootTableView = UITableView(frame: CGRect.zero, style: .Grouped)
    
    var forumModelArray = [ForumModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.view.backgroundColor = UIColor.cyanColor()
        self.setSubview()
        
        loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 圈子 发现")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 圈子 发现")
    }
    
    func loadData() {
        let forum1 = ForumModel()
        forum1.title = "1请问各位同行，职场新手如何‘谈薪’才合适？"
        forum1.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum1.like = "2254"
        forum1.hits = "2255"
        
        let forum2 = ForumModel()
        forum2.title = "2请问各位同行，职场新手如何‘谈薪’才合适？"
        forum2.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum2.like = "2254"
        forum2.hits = "2255"
        let photo1 = photoModel()
        photo1.url = "20161202/5840e94624cb0.jpg"
        forum2.photo = [photo1]
        
        let forum3 = ForumModel()
        forum3.title = "3请问各位同行，职场新手如何‘谈薪’才合适？"
        forum3.content = "从期望薪资可以从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可...从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum3.like = "2254"
        forum3.hits = "2255"
        let photo2 = photoModel()
        photo2.url = "20161130/583eb4efc6dad.jpg"
        let photo3 = photoModel()
        photo3.url = "20161129/583ce3b933d98.jpg"
        forum3.photo = [photo2,photo3]
        
        let forum4 = ForumModel()
        forum4.title = "4请问各位同行，职场新手如何‘谈薪’才合适？"
        forum4.content = "从期望薪资可以看出求职者对自己的定位，符合自己能力及潜力的薪资报价，体现的是对自身能力的认可..."
        forum4.like = "2254"
        forum4.hits = "2255"

        forum4.photo = [photo1,photo2,photo3]
        
        forumModelArray = [forum1,forum2,forum3,forum4]
        
        self.rootTableView.reloadData()
    }
    
    // MARK: - 设置子视图
    func setSubview() {
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65-45-49)
        rootTableView.backgroundColor = UIColor.whiteColor()

        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.registerClass(NSCircleDiscoverTableViewCell.self, forCellReuseIdentifier: "circleDiscoverCell")

//        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(makeDataSource))
//        rootTableView.mj_header.beginRefreshing()
        
//        myTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.addSubview(rootTableView)
        
        self.setTableViewHeaderView()
    }
    
    // MARK: - 设置头视图
    func setTableViewHeaderView() {
        
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 50))
        
        var messageBtnMaxY:CGFloat = 0
        if true {
            let messageCount = "2"
            let messageBtn = UIButton(frame: CGRect(x: 8, y: 10, width: WIDTH-16, height: 35))
            messageBtn.backgroundColor = UIColor(white: 0.95, alpha: 1)
            
            messageBtn.setImage(UIImage(named: "新消息"), forState: .Normal)
            let titleAttrStr = NSMutableAttributedString(string: "您有 \(messageCount) 条新消息", attributes: [NSForegroundColorAttributeName:UIColor.grayColor(),NSFontAttributeName:UIFont.systemFontOfSize(15)])
            titleAttrStr.addAttributes([NSForegroundColorAttributeName:COLOR], range: NSMakeRange(3, NSString(string: messageCount).length))
            messageBtn.setAttributedTitle(titleAttrStr, forState: .Normal)
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
            btn1.setImage(UIImage(named: btn1NameArray[i]), forState: .Normal)
            btn1.titleLabel?.font = UIFont.systemFontOfSize(15)
            btn1.setTitle(btn1NameArray[i], forState: .Normal)
            initButton(btn1)
            btn1.addTarget(self, action: #selector(btn1Click(_:)), forControlEvents: .TouchUpInside)
            tableHeaderView.addSubview(btn1)
        }
        
        // "热门圈子推荐"
        let recommendLab = UILabel(frame: CGRect(x: 8, y: messageBtnMaxY+10+btn1Height, width: WIDTH-16, height: 35))
        recommendLab.textAlignment = .Left
        recommendLab.font = UIFont.systemFontOfSize(14)
        recommendLab.textColor = UIColor.lightGrayColor()
        recommendLab.text = "热门圈子推荐"
        tableHeaderView.addSubview(recommendLab)
        
        // 推荐的圈子
        let btn2ScrollView = UIScrollView(frame: CGRect(x: 0, y: recommendLab.frame.maxY, width: WIDTH, height: 0))
        btn2ScrollView.showsVerticalScrollIndicator = false
        btn2ScrollView.showsHorizontalScrollIndicator = false
        tableHeaderView.addSubview(btn2ScrollView)
        
        let btn2Width = WIDTH/375*100
        var btn2Height:CGFloat = 0
        let btn2NameArray = ["儿科","内科","外科","妇产科","急诊科","灌水吐槽"]
        
        for (i,circleName) in btn2NameArray.enumerate() {
            let btn2 = UIButton(frame: CGRect(x: 8+(btn2Width+8)*CGFloat(i), y: 0, width: btn2Width, height: 0))
            btn2.tag = 200+i

//            btn2.setImage(UIImage(named: btn2NameArray[i]), forState: .Normal)
            btn2.addTarget(self, action: #selector(btn2Click(_:)), forControlEvents: .TouchUpInside)
            btn2ScrollView.addSubview(btn2)
            
            let img = UIImageView(frame: CGRect(x: 0, y: 0, width: btn2Width, height: WIDTH/375*72))
            img.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1)
            btn2.addSubview(img)
            
            let nameLab = UILabel(frame: CGRect(x: 0, y: img.frame.maxY, width: btn2Width, height: WIDTH/375*22))
            nameLab.textAlignment = .Left
            nameLab.font = UIFont.systemFontOfSize(14)
            nameLab.textColor = COLOR
            nameLab.text = circleName
            btn2.addSubview(nameLab)
            
            let countLab = UILabel(frame: CGRect(x: 0, y: nameLab.frame.maxY, width: btn2Width, height: WIDTH/375*15))
            countLab.textAlignment = .Left
            countLab.font = UIFont.systemFontOfSize(10)
            countLab.textColor = UIColor.lightGrayColor()
            countLab.adjustsFontSizeToFitWidth = true
            countLab.text = "13.5万人 16.5万贴子"
            btn2.addSubview(countLab)
            
            btn2.frame.size.height = countLab.frame.maxY
            btn2Height = btn2.frame.size.height
            
            btn2ScrollView.frame.size.height = btn2.frame.size.height
            
        }
        
        btn2ScrollView.contentSize = CGSizeMake(8+(btn2Width+8)*CGFloat(btn2NameArray.count), 0)

        
        tableHeaderView.frame.size.height = recommendLab.frame.maxY+btn2Height+8
        
        rootTableView.tableHeaderView = tableHeaderView
    }
    
    // btn1 点击事件
    func btn1Click(btn1:UIButton) {
        switch btn1.tag {
        case 100:
            print("精选圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(circleListController, animated: true)
        case 101:
            print("热门圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(circleListController, animated: true)
        case 102:
            print("全部圈子")
            let circleListController = NSCircleListViewController()
            circleListController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(circleListController, animated: true)
        default:
            break
        }
    }
    
    // btn2 点击事件
    func btn2Click(btn2:UIButton) {
        
        print("点击热门圈子推荐 之 \(btn2.tag-200)")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)

    }
    
    // MARK: - UItableViewdatasource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return forumModelArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("circleDiscoverCell", forIndexPath: indexPath) as! NSCircleDiscoverTableViewCell

        cell.selectionStyle = .None
        
        cell.setCellWithNewsInfo(forumModelArray[indexPath.section])
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    private let titleSize:CGFloat = 14
    private let contentSize:CGFloat = 12
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let forum = forumModelArray[indexPath.section]
        
        if forum.photo.count == 0 {
            
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)

            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            return 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
        }else if forum.photo.count < 3 {
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16-110-8)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16-110-8)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            let cellHeight1:CGFloat = 8+80+8// 上边距+图片高+下边距
            let cellHeight2 = 8+height+8+contentHeight+8+8+8// 上边距+标题高+间距+内容高+间距+点赞评论按钮高+下边距
            
            
            return max(cellHeight1, cellHeight2)
        }else{
            let height = calculateHeight((forum.title), size: titleSize, width: WIDTH-16)
            
            
            var contentHeight = calculateHeight((forum.content), size: contentSize, width: WIDTH-16)
            if contentHeight >= UIFont.systemFontOfSize(contentSize).lineHeight*3 {
                contentHeight = UIFont.systemFontOfSize(contentSize).lineHeight*2
            }
            
            let imgHeight = (WIDTH-16-15*2)/3.0*2/3.0
            
            return 8+height+8+contentHeight+8+imgHeight+8+8+8// 上边距+标题高+间距+内容高+间距+图片高+间距+点赞评论按钮高+下边距
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 35))
        footerView.addTarget(self, action: #selector(footerViewClick), forControlEvents: .TouchUpInside)
        
        let nameBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 30))
        nameBtn.setImage(UIImage(named: "精华贴"), forState: .Normal)
        nameBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        nameBtn.setTitleColor(COLOR, forState: .Normal)
        nameBtn.setTitle("内科", forState: .Normal)
        nameBtn.sizeToFit()
        nameBtn.frame.origin = CGPoint(x: 8, y: (35-nameBtn.frame.height)/2.0)
        footerView.addSubview(nameBtn)
        
        let comeinLab = UILabel(frame: CGRect(x: nameBtn.frame.maxX, y: 0, width: WIDTH-nameBtn.frame.maxX-8, height: 35))
        comeinLab.textAlignment = .Right
        comeinLab.font = UIFont.systemFontOfSize(12)
        comeinLab.textColor = COLOR
        comeinLab.text = "进入圈子"
        footerView.addSubview(comeinLab)
        
        return footerView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 20))
        headerView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("贴子详情")
        
        let forumDetailController = NSCircleForumDetailViewController()
        forumDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(forumDetailController, animated: true)
    }
    
    // footerView 点击事件
    func footerViewClick()  {
        print("进入圈子")
        
        let circleDetailController = NSCircleDetailViewController()
        circleDetailController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(circleDetailController, animated: true)
    }
    
    // 调整 button 图片和文字
    func initButton(btn:UIButton) {
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Center//使图片和文字水平居中显示
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
