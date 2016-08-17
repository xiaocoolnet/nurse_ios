//
//  TouTiaoViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class TouTiaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,cateBtnClickedDelegate,changeModelDelegate {

    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = Array<String>()
    var timer = NSTimer()
    var dataSource = NewsList()
    var likedataSource = LikeList()
    var requestHelper = NewsPageHelper()
    
    internal var newsId = String()
    internal var post_title=String()
    internal var post_modified=String()
    var post_excerpt = String()
    var requestManager:AFHTTPSessionManager?
    var newsType:Int?
    var titArr:[String] = Array<String>()
    
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
    
    func rightItemClick() {
        UIApplication.sharedApplication().openURL(NSURL.init(string: "http://crm.chinanurse.cn/form/sign_up.php")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let back = UIBarButtonItem()
        back.title = "返回";
        self.navigationItem.backBarButtonItem = back;
        
        self.createTableView()
//        self.GetDate()
        myTableView.tableFooterView = UIView()
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        myTableView.mj_header.beginRefreshing()
        
        self.view.backgroundColor = COLOR


        // Do any additional setup after loading the view.
    }
    
    
    func loadData() {
        requestHelper.getSlideImages("3") { [unowned self] (success, response) in
            if success {
                print(response)
                let imageArr = response as! Array<PhotoInfo>
                for imageInfo in imageArr {
                    self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
                    self.titArr.append(imageInfo.name)
                    //                    self.titArr.append(imageInfo)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    })
                }
                self.GetDate()
            }
        }
        
    }
    
    
    func updateSlideImage(){
        for i in 1...4 {
            let imgView = scrollView.viewWithTag(i) as! UIImageView
            if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                imgView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imgView.sd_setImageWithURL(NSURL(string: picArr[i-1]), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
//            imgView.sd_setImageWithURL(NSURL(string: picArr[i-1]))
//            print(picArr)
            for lab in imgView.subviews {
                if lab.tag == imgView.tag {
                    let titLab = lab.viewWithTag(i) as? UILabel
                    titLab!.text = titArr[i-1]
                }
            }
        }
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
        
        for i in 0...3 {
            
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.tag = i+1
            
            let bottom = UIView(frame: CGRectMake(0, WIDTH*190/375-25, WIDTH, 25))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRectMake(10, WIDTH*190/375-25, WIDTH-100, 25))
            titLab.font = UIFont.systemFontOfSize(14)
            titLab.textColor = UIColor.whiteColor()
//            titLab.text = titArr[i]
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
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*190/375-25, 80, 25)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 100
        myTableView.tableHeaderView = one
    }
    
    func GetDate(){
        let url = PARK_URL_Header+"getNewslist"
        let param = ["channelid":newsType == nil ? newsId : String(newsType!+17)]
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    print(LikeList(status.data!).objectlist)
                    self.likedataSource = LikeList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { 
                self.myTableView.mj_header.endRefreshing()
            })
       }
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
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
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
//        print(boundingRect.height)
        
        if newsInfo.thumbArr.count >= 3 {
            let margin:CGFloat = 15
            return (WIDTH-20-margin*2)/3.0*2/3.0+19+height+27+4
        }else{
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
        let newsInfo = self.dataSource.objectlist[indexPath.row]
                
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        next.navTitle = "新闻内容"
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
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }

}
