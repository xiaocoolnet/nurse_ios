//
//  AbroadViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AbroadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,cateBtnClickedDelegate,changeModelDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
//  var picArr = NSArray()
    var picArr = Array<String>()
    var timer = NSTimer()
    var times = Int()
    //  请求认证id
    var channelid = Int()
    //  初始化数据源
    var dataSource = NewsList()
    let countryArr:[String] = ["ic_eng.png","ic_canada.png","ic_germany.png","ic_australia.png","ic_meiguo.png","ic_guo.png","ic_guotwo.png","ic_flag_japan.png"]
    let nameArr:[String] = ["美国","加拿大","德国","芬兰","澳洲","新加坡","沙特","日本"]
    var titArr:[String] = Array<String>()
    var country = Int()
    var requestHelper = NewsPageHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-113)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "Abroad")
        self.view.addSubview(myTableView)
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetDate))
        myTableView.mj_header.beginRefreshing()
        
        //  添加定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(AbroadViewController.scroll), userInfo: nil, repeats: true)
        
        channelid = 8
//        self.GetDate()        
        // Do any additional setup after loading the view.
    }
    
    
    func updateSlideImage(){
        for i in 1...4 {
            let imgView = scrollView.viewWithTag(i) as! UIImageView
            imgView.sd_setImageWithURL(NSURL(string: picArr[i-1]))
            //            print(picArr)
            for lab in imgView.subviews {
                if lab.tag == imgView.tag {
                    let titLab = lab.viewWithTag(i) as? UILabel
                    titLab!.text = titArr[i-1]
                }
            }
        }
    }
    
    //  数据请求
    func GetDate( ){
        
        let url = PARK_URL_Header+"getNewslist"
        
        //  请求体
        
        let param = [
            "channelid":NSString.localizedStringWithFormat("%ld", channelid)
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            
            
            self.requestHelper.getSlideImages("3") { [unowned self] (success, response) in
                if success {
                    print(response)
                    let imageArr = response as! Array<PhotoInfo>
                    for imageInfo in imageArr {
                        self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
                        self.titArr.append(imageInfo.name)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.updateSlideImage()
                            self.myTableView.reloadData()
                        })
                    }
                }
                
                self.myTableView.mj_header.endRefreshing()
            }
            
            print(request)
            if(error != nil){
                print(error)
            }else{
                let status = NewsModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    //  菊花加载
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
                    //  请求成功
                    print(status)
                    //  填充数据源
                    self.dataSource = NewsList(status.data!)
                    //  刷新界面
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }
    
    func createTableView1(){
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(AbroadViewController.scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*190/375)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        for i in 0...3 {
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.tag = i+1
            let bottom = UIView(frame: CGRectMake(CGFloat(i)*WIDTH, WIDTH*190/375-30, WIDTH, 30))
            bottom.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
//            bottom.alpha = 0.3
            let titLab = UILabel(frame: CGRectMake(CGFloat(i)*WIDTH+10, WIDTH*190/375-30, WIDTH-100, 30))
            titLab.font = UIFont.systemFontOfSize(14)
            titLab.textColor = UIColor.whiteColor()
            titLab.text = titArr[i]
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(_:)))
            //        手指头
            tap.numberOfTapsRequired = 1
            //        单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            self.scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*190/375-30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 100
        myTableView.tableHeaderView = one
    }
    //  创建tableView
    func createTableView(){
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-113)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "Abroad")
        self.view.addSubview(myTableView)
    }
    //  段数据
    //  MARK: - UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    //  行数据
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  第一次走  section 为1   其次为0
        if section == 0 {
            return 1
        }else{
            return self.dataSource.count;
        }
    }
    //  认证cell
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH*160/375
        }else{
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            
            let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
            
            if newsInfo.thumbArr.count >= 3 {
                let margin:CGFloat = 15
                return (WIDTH-20-margin*2)/3.0*2/3.0+10+height+27
            }else{
                if height+27>100 {
                    return height+27
                }else{
                    return 100
                }
            }
        }
    }
    //  段尾视图的定义
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //  创建视图
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, WIDTH*188/375))
       
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*188/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        for i in 0...3 {
            
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*188/375)
            imageView.tag = i+1
            
            let bottom = UIView(frame: CGRectMake(0, WIDTH*188/375-25, WIDTH, 25))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRectMake(10, WIDTH*188/375-25, WIDTH-100, 25))
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
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*188/375-25, 80, 25)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
//        myTableView.rowHeight = 100
//        myTableView.tableHeaderView = one
       
        
        
        return one
    }
    //  段尾高度设置
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return WIDTH * 188 / 375
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor.init(red: 242/255.0, green: 242/255.0, blue: 242/255.0, alpha: 1)
            for view in cell.contentView.subviews {
                view.removeFromSuperview()
            }
            for i in 0...7 {
                let country = UIButton(frame: CGRectMake(WIDTH * (30 + 95 * CGFloat( i % 4 )) / 375, WIDTH * ( 20 + 70 * CGFloat(i / 4)) / 375, WIDTH * 34 / 375, WIDTH * 34 / 375))
                country.tag = i
//                country.layer.cornerRadius = country.frame.size.width/2.0
//                country.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
//                country.layer.borderWidth = 0.5
                country.setBackgroundImage(UIImage(named: countryArr[i]), forState: .Normal)
                country.addTarget(self, action: #selector(AbroadViewController.selectorCountry(_:)), forControlEvents: .TouchUpInside)
                cell.addSubview(country)
                let countryName = UILabel(frame: CGRectMake(WIDTH*(95*CGFloat(i%4))/375, WIDTH*(59+70*CGFloat(i/4))/375, WIDTH*93/375, 18))
                countryName.font = UIFont.systemFontOfSize(12)
                countryName.textAlignment = .Center
                countryName.text = nameArr[i]
                cell.contentView.addSubview(countryName)
                
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Abroad", forIndexPath: indexPath)as!GToutiaoTableViewCell
            cell.delegate = self
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            if newsInfo.thumbArr.count >= 3 {
                cell.setThreeImgCellWithNewsInfo(newsInfo)
            }else{
                cell.setCellWithNewsInfo(newsInfo)
            }
            cell.selectionStyle = .None
            return cell
        }
        
        
    }
    //  cell的点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        if indexPath.section == 0 {
        }else{
            //  进入详情界面
            let next = NewsContantViewController()
            //  需要传值的内容
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            //  传值操作
            next.newsInfo = newsInfo
            next.index = indexPath.row
            next.navTitle = "出国动态"
            next.delegate = self
            //  push一个界面
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    //    国家
    func selectorCountry(btn:UIButton) {
        print(btn.tag)
        //  执行国家图片的点击内容
        channelid = btn.tag
        country = btn.tag
        let vc = TouTiaoViewController()
        vc.newsType = btn.tag
        vc.title = nameArr[btn.tag]
        navigationController?.pushViewController(vc, animated: true)
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
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(AbroadViewController.scroll), userInfo: nil, repeats: true)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        pageControl.currentPage = page
    }

    //开始拖拽时
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
//        timer.fireDate = NSDate.distantFuture()
        timer.invalidate()
        
    }
//    //结束拖拽时
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
////        timer.fireDate = NSDate.distantPast()
//        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(AbroadViewController.scroll), userInfo: nil, repeats: true)
//
//    }

    
    func getData(){
        
        let url = PARK_URL_Header+"getNewslist"
//        let param = [
//            "channelid":"17"
//        ];
    
        let param = [
            "channelid":NSString.localizedStringWithFormat("%ld", country + 17)
            ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
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
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
        }
    }
    
    // MARK: 点击分类按钮
    func cateBtnClicked(categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }

}
