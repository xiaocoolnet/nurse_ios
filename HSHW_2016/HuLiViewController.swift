//
//  HuLiViewController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/6.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class HuLiViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = NSArray()
    var timer = NSTimer()
    var times = Int()
    var dataSource = NewsList()
//    internal var newsId = String()
//    internal var post_title=String()
//    internal var post_modified=String()
//    var post_excerpt=String()
    //internal var roomnum=Int()
    var requestManager:AFHTTPSessionManager?
    let titArr:[String] = ["韩国美女，都长一个样～","有这样的治疗，我想受伤！","兄弟，就是打打闹闹。","石中剑，你是王者吗？"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.GetDate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.GetDate()
        self.view.backgroundColor = COLOR
        requestManager = AFHTTPSessionManager()
        requestManager?.responseSerializer = AFHTTPResponseSerializer()
        
    
        // Do any additional setup after loading the view.
    }
    
    func createTableView() {
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*190/375)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        
        
        picArr = ["1.png","2.png","3.png","4.png"]
        for i in 0...3 {
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.image = UIImage(named: picArr[i] as! String)
            imageView.tag = i+1
            
            let bottom = UIView(frame: CGRectMake(CGFloat(i)*WIDTH, WIDTH*190/375-30, WIDTH, 30))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.3
            let titLab = UILabel(frame: CGRectMake(CGFloat(i)*WIDTH+10, WIDTH*190/375-30, WIDTH-100, 30))
            titLab.font = UIFont.systemFontOfSize(14)
            titLab.textColor = UIColor.whiteColor()
            titLab.text = titArr[i]
            
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
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*190/375-30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 100
        myTableView.tableHeaderView = one
    }
    
    func GetDate(){
        //MBProgressHUD  HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES], retain];
     
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":"5"
        ];
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
                    
                    self.createTableView()
                    
//                    let news = status.data
//                    news?.post_modified = (status.data?.post_modified)!
//                    news?.post_title = (status.data?.post_modified)!
//                    // news.post_excerpt = (status.data?.post_excerpt)!
//                    //news.post_excerpt = (status.data?.post_excerpt)!
//                    self.post_title = (status.data?.post_title)!
//                    self.post_modified = (status.data?.post_modified)!
//                    self.post_excerpt = (status.data?.post_excerpt)!
//                    self.dataSource.append(news!)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
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
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offsetX:CGFloat = self.scrollView.contentOffset.x
        offsetX = offsetX + (self.scrollView.frame.size.width * 0.5)
        //pageControll改变
        let page:Int = Int(offsetX)/Int(self.scrollView.frame.size.width)
        pageControl.currentPage = page
    }
    //开始拖拽时
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        timer.fireDate = NSDate.distantFuture()
    }
    //结束拖拽时
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        timer.fireDate = NSDate.distantPast()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.dataSource.count)
        return self.dataSource.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!TouTiaoTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        cell.titLab.text = newsInfo.post_title
        cell.conNum.text = newsInfo.recommended
        let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
        cell.timeLab.text = time[0]
        cell.contant.text = newsInfo.post_excerpt
        cell.contant.text = newsInfo.post_excerpt
        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 14, width: WIDTH-140)
        print(titleHeight)
        cell.titLab.frame.size.height = titleHeight
        // cell.contant.text = "真的很累吗？累就对了，舒服是留给死人的！苦-才是人生 ，累-才是工作， 变-才是命运 ， 忍-才是历练，容-才是智慧 ， 静-才是修养，舍-才是得到 ，做-才是拥有！"
        cell.titImage.image = UIImage(named: "1.png")
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let next = NewsContantViewController()
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        next.newsInfo = newsInfo
        self.navigationController?.pushViewController(next, animated: true)
        
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
