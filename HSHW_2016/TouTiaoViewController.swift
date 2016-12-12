//
//  TouTiaoViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class TouTiaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,cateBtnClickedDelegate,changeModelDelegate {
    
    //    var userInfo:[NSObject : AnyObject]?
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = SMPageControl()
    //    var picArr = Array<String>()
    var timer = NSTimer()
    var dataSource = Array<NewsInfo>()
    //    var likedataSource = LikeList()
    var requestHelper = NewsPageHelper()
    
    internal var newsId = String()
    var slideImageId = String()
    internal var post_title=String()
    internal var post_modified=String()
    var post_excerpt = String()
    var requestManager:AFHTTPSessionManager?
    var newsType:Int?
    //    var titArr:[String] = Array<String>()
    var imageArr = Array<NewsInfo>()
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("新闻/出国 "+(self.title ?? "")!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if newsType != nil {
            self.navigationController?.navigationBar.hidden = false
            self.tabBarController?.tabBar.hidden = true
        }
        
        let rightItem = UIButton.init(frame: CGRectMake(0, 0, 50, 28))
        rightItem.backgroundColor = COLOR
        rightItem.layer.cornerRadius = 5
        rightItem.addTarget(self, action: #selector(rightItemClick), forControlEvents: .TouchUpInside)
        
        let rightLab = UILabel.init(frame: CGRectMake(0, 0, CGRectGetWidth(rightItem.frame), CGRectGetHeight(rightItem.frame)))
        rightLab.textAlignment = NSTextAlignment.Center
        rightLab.text = "报名"
        rightLab.textColor = UIColor.whiteColor()
        rightItem.addSubview(rightLab)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightItem)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("新闻/出国 "+(self.title ?? "")!)

        recivePush()
    }
    
    func recivePush() {
        
        let userInfo = NSUserDefaults.standardUserDefaults().valueForKey("recivePushNotification") as? [NSObject : AnyObject]
        
        if (userInfo != nil) {
            
            if userInfo!["aps"] != nil {
                
                // 取得APNS通知内容
                let aps = userInfo!["aps"] as? NSDictionary
                // 内容
                let content = aps!["alert"] as? NSString
                // badge数量
                let badge = aps!["badge"] as? NSInteger
                // 播放声音
                let sound = aps!.valueForKey("sound") as? NSString
                //            // 取得Extras字段内容
                //            let Extras = userInfo!["Extras"] as? NSString //服务端中Extras字段，key是自己定义的
                print("content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, badge, sound)
                //             iOS badge 清0
                UIApplication.sharedApplication().applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber - (badge ?? 0)!
                
                if (userInfo!["news"] != nil) {
                    
                    //                [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil
                    //                let data = try?NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted)
                    var data2 = NSData()
                    if userInfo!["news"]!.isKindOfClass(NSString) {
                        data2 = (userInfo!["news"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)!
                    }else if userInfo!["news"]!.isKindOfClass(NSDictionary) {
                        data2 = try!NSJSONSerialization.dataWithJSONObject(userInfo!["news"] as! NSDictionary, options: NSJSONWritingOptions.PrettyPrinted)
                    }
                    //                let data = (userInfo["news"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let newsInfo =  NewsInfo(JSONDecoder(data2))
                    let next = NewsContantViewController()
                    next.newsInfo = newsInfo
                    
                    self.navigationController!.pushViewController(next, animated: true)
                }
                // 通知打开回执上报
                CloudPushSDK.handleReceiveRemoteNotification(userInfo)
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("recivePushNotification")
            }
        }
    }
    
    func rightItemClick() {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "http://crm.chinanurse.cn/form/sign_up.php")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        let back = UIBarButtonItem()
        back.title = "返回";
        self.navigationItem.backBarButtonItem = back;
        
        self.createTableView()
        //        self.GetDate()
        myTableView.tableFooterView = UIView()
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        self.view.backgroundColor = COLOR
        
        
        // Do any additional setup after loading the view.
    }
    
    var pager = 2
    func loadData_pullUp() {
        
        HSNurseStationHelper().getArticleListWithID(newsType == nil ? newsId : String(newsType!), pager: String(pager)) { (success, response) in
            
            if success {
                //                print(response)
                
                for element in response as! Array<NewsInfo> {
                    self.dataSource.append(element)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.reloadData()
                    self.pager += 1
                })
                
                self.myTableView.mj_footer.endRefreshing()
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                    
                })
            }
        }
    }
    
    func loadData() {
        
        var flag = 0
        
        HSNurseStationHelper().getArticleListWithID(slideImageId) { (success, response) in
            
            if success {
                //                print(response)
                let imageArr = response as! Array<NewsInfo>
                self.imageArr = imageArr.count>=5 ? Array(imageArr[0...slideImageListMaxNum-1]):imageArr
                
                //                for imageInfo in self.imageArr {
                //                    self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
                //                    self.titArr.append(imageInfo.name)
                //                    //                    self.titArr.append(imageInfo)
                
                //                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                
                flag += 1
                if flag == 2 {
                    self.myTableView.mj_header.endRefreshing()
                }
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if String((response ?? "")!)  == "no data" {
                        self.imageArr = Array<NewsInfo>()
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    }else{
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "轮播图获取失败"
                        hud.detailsLabelText = String((response ?? "")!)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    
                })
            }
        }
        
        HSNurseStationHelper().getArticleListWithID(newsType == nil ? newsId : String(newsType!), pager: "1") { (success, response) in
            
            if success {
                //                print(response)
                
                self.dataSource = response as! Array<NewsInfo>
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                
                flag += 1
                if flag == 2 {
                    self.myTableView.mj_header.endRefreshing()
                    self.pager += 1
                }
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if String((response ?? "")!) == "no data" {
                        self.dataSource = Array<NewsInfo>()
                        self.myTableView.reloadData()
                    }else{
                        
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "文章列表获取失败"
                        hud.detailsLabelText = String((response ?? "")!)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    
                })
            }
        }
        
        //        let slideTypeId = Int(newsId)!-1
        //        requestHelper.getSlideImages(String(slideTypeId)) { [unowned self] (success, response) in
        //            if success {
        //                print(response)
        //                self.imageArr = response as! Array<PhotoInfo>
        ////                for imageInfo in self.imageArr {
        ////                    self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
        ////                    self.titArr.append(imageInfo.name)
        ////                    //                    self.titArr.append(imageInfo)
        //                    dispatch_async(dispatch_get_main_queue(), {
        //                        self.updateSlideImage()
        //                        self.myTableView.reloadData()
        //                    })
        ////                }
        //                self.GetDate()
        //            }else{
        //                self.myTableView.mj_header.endRefreshing()
        //
        //                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //                hud.mode = MBProgressHUDMode.Text;
        //                hud.labelText = String((response ?? "")!)
        //                hud.margin = 10.0
        //                hud.removeFromSuperViewOnHide = true
        //                hud.hide(true, afterDelay: 1)
        //            }
        //        }
        
    }
    
    
    func updateSlideImage(){
        
        for subView in self.scrollView.subviews {
            if subView.isKindOfClass(UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        let margin:CGFloat = 4
        pageControl.numberOfPages = self.imageArr.count
        pageControl.frame = CGRectMake(
            WIDTH-margin-pageControl.rectForPageIndicator(0).width*CGFloat(self.imageArr.count)-margin*CGFloat(self.imageArr.count-1),
            WIDTH*190/375-25,
            pageControl.rectForPageIndicator(0).width*CGFloat(self.imageArr.count)+margin*CGFloat(self.imageArr.count-1),
            25)
        pageControl.indicatorMargin = margin
        pageControl.currentPage = 0
        
        for (i,slideImage) in self.imageArr.enumerate() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.tag = i+1

            if  (!NurseUtil.net.isWifi() && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImageWithURL(NSURL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRectMake(0, WIDTH*190/375-25, WIDTH, 25))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRectMake(10, WIDTH*190/375-25, CGRectGetMinX(pageControl.frame)-10, 25))
            titLab.font = UIFont.systemFontOfSize(13)
            titLab.textColor = UIColor.whiteColor()
            titLab.adjustsFontSizeToFitWidth = true
            titLab.text = slideImage.post_title
            titLab.tag = i+1
            imageView.addSubview(titLab)
            
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSizeMake(CGFloat(self.imageArr.count)*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        
    }
    
    func createTableView() {
        myTableView.frame = CGRectMake(0, 1, WIDTH, newsType == nil ? HEIGHT-114:HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*190/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*190/375-25, 80, 25)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 100
        myTableView.tableHeaderView = one
    }
    
    //    func GetDate(){
    //        let url = PARK_URL_Header+"getNewslist"
    //        let param = ["channelid":newsType == nil ? newsId : String(newsType!+17)]
    //
    //        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
    //            if(error != nil){
    //
    //            }else{
    //                let status = NewsModel(JSONDecoder(json!))
    //                print("状态是")
    //                print(status.status)
    //                if(status.status == "error"){
    //                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    //                    hud.mode = MBProgressHUDMode.Text;
    //                    //hud.labelText = status.errorData
    //                    hud.margin = 10.0
    //                    hud.removeFromSuperViewOnHide = true
    //                    hud.hide(true, afterDelay: 1)
    //                }
    //                if(status.status == "success"){
    //                    print(status)
    //                    self.dataSource = NewsList(status.data!)
    //                    print(LikeList(status.data!).objectlist)
    //                    self.likedataSource = LikeList(status.data!)
    //                    self.myTableView .reloadData()
    //                    print(status.data)
    //                }
    //            }
    //            dispatch_async(dispatch_get_main_queue(), {
    //                self.myTableView.mj_header.endRefreshing()
    //            })
    //       }
    //    }
    // MARK: 图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
        
        let next = NewsContantViewController()
        next.newsInfo = imageArr[imageView.tag-1]
        //        next.index = imageView.tag-1
        //        next.navTitle = imageArr[imageView.tag-1].term_name
        //        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
        //        for (i,newsInfo) in self.dataSource.objectlist.enumerate() {
        //            print(imageArr[imageView.tag-1].thumbArr.first?.url)
        //            if newsInfo.object_id == imageArr[imageView.tag-1].thumbArr.first?.url {
        //
        //            }
        //        }
    }
    
    func scroll(){
        if self.pageControl.currentPage == self.pageControl.numberOfPages-1 {
            self.pageControl.currentPage = 0
        }else{
            self.pageControl.currentPage += 1
        }
        let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * CGFloat(self.scrollView.frame.size.width)
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
        //        timer.fireDate = NSDate.distantPast()
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        //            timer.fireDate = NSDate.distantFuture()
        timer.invalidate()
    }
    //结束拖拽时
    //    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //            timer.fireDate = NSDate.distantPast()
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsInfo = self.dataSource[indexPath.row]
        
        //        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        //        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        //        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        //        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
        //        print(boundingRect.height)
        
        if newsInfo.thumbArr.count >= 3 {
            
            let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
            
            let margin:CGFloat = 15
            return (WIDTH-20-margin*2)/3.0*2/3.0+19+height+27+4
        }else{
            
            let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-140)
            
            if height+27>100 {
                return height+27+4
            }else{
                return 100
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!GToutiaoTableViewCell
        //        cell.type = 1
        cell.delegate = self
        cell.selectionStyle = .None
        let newsInfo = self.dataSource[indexPath.row]
        
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        //        next.navTitle = "新闻内容"
        next.delegate = self
        //        print(newsInfo.likes.count)
        //        let str = newsInfo.likes
        //        var answerInfo = NSString()
        //        for j in 0 ..< str.count {
        //            answerInfo = str[j].userid!
        //            print(answerInfo)
        //        }
        //
        //        if answerInfo == QCLoginUserInfo.currentInfo.userid{
        //            print(1)
        //        }else{
        //            print(222)
        //        }
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: 点击分类按钮
    func cateBtnClicked(categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        cateDetail.type = 1
        NSLog("%d", categoryBtn.tag)
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.dataSource[andIndex] = newInfo
        self.myTableView.reloadData()
    }
    
}
