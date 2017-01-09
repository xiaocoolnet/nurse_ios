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
    var timer = Timer()
    var dataSource = Array<NewsInfo>()
    //    var likedataSource = LikeList()
//    var requestHelper = NewsPageHelper()
    
    internal var newsId = String()
    var slideImageId = String()
    internal var post_title=String()
    internal var post_modified=String()
    var post_excerpt = String()
    var requestManager:AFHTTPSessionManager?
    var newsType:Int?
    //    var titArr:[String] = Array<String>()
    var imageArr = Array<NewsInfo>()
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "新闻/出国 "+(self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if newsType != nil {
            self.navigationController?.navigationBar.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
        }
        
        let rightItem = UIButton.init(frame: CGRect(x: 0, y: 0, width: 50, height: 28))
        rightItem.backgroundColor = COLOR
        rightItem.layer.cornerRadius = 5
        rightItem.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        
        let rightLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: rightItem.frame.width, height: rightItem.frame.height))
        rightLab.textAlignment = NSTextAlignment.center
        rightLab.text = "报名"
        rightLab.textColor = UIColor.white
        rightItem.addSubview(rightLab)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightItem)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "新闻/出国 "+(self.title ?? "")!)

        recivePush()
    }
    
    func recivePush() {
        
        let userInfo = UserDefaults.standard.value(forKey: "recivePushNotification") as? [AnyHashable: Any]
        
        if (userInfo != nil) {
            
            if userInfo!["aps"] != nil {
                
                // 取得APNS通知内容
                let aps = userInfo!["aps"] as? NSDictionary
                // 内容
                let content = aps!["alert"] as? NSString
                // badge数量
                let badge = aps!["badge"] as? NSInteger
                // 播放声音
                let sound = aps!.value(forKey: "sound") as? NSString
                //            // 取得Extras字段内容
                //            let Extras = userInfo!["Extras"] as? NSString //服务端中Extras字段，key是自己定义的
                print("content = [%@], badge = [%ld], sound = [%@], Extras = [%@] \(content) \(badge) \(sound)")
                //             iOS badge 清0
                UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - (badge ?? 0)!
                
                if (userInfo!["news"] != nil) {
                    
                    //                [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil
                    //                let data = try?NSJSONSerialization.dataWithJSONObject(userInfo, options: NSJSONWritingOptions.PrettyPrinted)
                    var data2 = Data()
                    if (userInfo!["news"]! is NSString) {
                        data2 = (userInfo!["news"] as! NSString).data(using: String.Encoding.utf8.rawValue)!
                    }else if (userInfo!["news"]! is NSDictionary) {
                        data2 = try!JSONSerialization.data(withJSONObject: userInfo!["news"] as! NSDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
                    }
                    //                let data = (userInfo["news"] as! NSString).dataUsingEncoding(NSUTF8StringEncoding)
                    
                    let newsInfo =  NewsInfo(JSONDecoder(data2 as AnyObject))
                    let next = NewsContantViewController()
                    next.newsInfo = newsInfo
                    
                    self.navigationController!.pushViewController(next, animated: true)
                }
                // 通知打开回执上报
                CloudPushSDK.handleReceiveRemoteNotification(userInfo)
                
                UserDefaults.standard.removeObject(forKey: "recivePushNotification")
            }
        }
    }
    
    func rightItemClick() {
        UIApplication.shared.openURL(URL.init(string: "http://crm.chinanurse.cn/form/sign_up.php")!)
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
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.reloadData()
                    self.pager += 1
                })
                
                self.myTableView.mj_footer.endRefreshing()
                
            }else{
                
                DispatchQueue.main.async(execute: {
                    
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
                DispatchQueue.main.async(execute: {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                
                flag += 1
                if flag == 2 {
                    self.myTableView.mj_header.endRefreshing()
                }
            }else{
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if String(describing: (response ?? ("" as AnyObject))!)  == "no data" {
                        self.imageArr = Array<NewsInfo>()
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    }else{
                        
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "轮播图获取失败"
                        hud.detailsLabel.text = String(describing: (response ?? ("" as AnyObject))!)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    
                })
            }
        }
        
        HSNurseStationHelper().getArticleListWithID(newsType == nil ? newsId : String(newsType!), pager: "1") { (success, response) in
            
            if success {
                //                print(response)
                
                self.dataSource = response as! Array<NewsInfo>
                DispatchQueue.main.async(execute: {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                
                flag += 1
                if flag == 2 {
                    self.myTableView.mj_header.endRefreshing()
                    self.pager += 1
                }
                
            }else{
                
                DispatchQueue.main.async(execute: {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                        self.dataSource = Array<NewsInfo>()
                        self.myTableView.reloadData()
                    }else{
                        
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "文章列表获取失败"
                        hud.detailsLabel.text = String(describing: (response ?? ("" as AnyObject))!)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    
                })
            }
        }        
    }
    
    
    func updateSlideImage(){
        
        for subView in self.scrollView.subviews {
            if subView.isKind(of: UIImageView.self) {
                subView.removeFromSuperview()
            }
        }
        
        let margin:CGFloat = 4
        pageControl.numberOfPages = self.imageArr.count
        pageControl.frame = CGRect(
            x: WIDTH-margin-pageControl.rect(forPageIndicator: 0).width*CGFloat(self.imageArr.count)-margin*CGFloat(self.imageArr.count-1),
            y: WIDTH*190/375-25,
            width: pageControl.rect(forPageIndicator: 0).width*CGFloat(self.imageArr.count)+margin*CGFloat(self.imageArr.count-1),
            height: 25)
        pageControl.indicatorMargin = margin
        pageControl.currentPage = 0
        
        for (i,slideImage) in self.imageArr.enumerated() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRect(x: CGFloat(i)*WIDTH, y: 0, width: WIDTH, height: WIDTH*190/375)
            imageView.tag = i+1

            if  (!NurseUtil.net.isWifi() && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImage(with: URL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRect(x: 0, y: WIDTH*190/375-25, width: WIDTH, height: 25))
            bottom.backgroundColor = UIColor.gray
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRect(x: 10, y: WIDTH*190/375-25, width: pageControl.frame.minX-10, height: 25))
            titLab.font = UIFont.systemFont(ofSize: 13)
            titLab.textColor = UIColor.white
            titLab.adjustsFontSizeToFitWidth = true
            titLab.text = slideImage.post_title
            titLab.tag = i+1
            imageView.addSubview(titLab)
            
            //为图片视图添加点击事件
            imageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(self.imageArr.count)*WIDTH, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
    }
    
    func createTableView() {
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: newsType == nil ? HEIGHT-114:HEIGHT-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRect(x: 0, y: 0,width: WIDTH, height: WIDTH*190/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: 4*WIDTH, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: WIDTH-80, y: WIDTH*190/375-25, width: 80, height: 25)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 100
        myTableView.tableHeaderView = one
    }
    
    //    func GetDate(){
    //        let url = PARK_URL_Header+"getNewslist_new"
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
    //                    //hud.label.text = status.errorData
    //                    hud.margin = 10.0
    //                    hud.removeFromSuperViewOnHide = true
    //                    hud.hide(animated: true, afterDelay: 1)
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
    func tapAction(_ tap:UIGestureRecognizer) {
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
        //        timer.fireDate = NSDate.distantPast()
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //            timer.fireDate = NSDate.distantFuture()
        timer.invalidate()
    }
    //结束拖拽时
    //    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //            timer.fireDate = NSDate.distantPast()
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toutiao", for: indexPath)as!GToutiaoTableViewCell
        //        cell.type = 1
        cell.delegate = self
        cell.selectionStyle = .none
        let newsInfo = self.dataSource[indexPath.row]
        
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    func cateBtnClicked(_ categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        cateDetail.type = 1
        NSLog("%d", categoryBtn.tag)
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.dataSource[andIndex] = newInfo
        self.myTableView.reloadData()
    }
    
}
