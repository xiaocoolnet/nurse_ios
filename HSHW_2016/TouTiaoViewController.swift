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

class TouTiaoViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

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
    var post_excerpt=String()
    var requestManager:AFHTTPSessionManager?
    let titArr:[String] = ["韩国美女，都长一个样～","有这样的治疗，我想受伤！","兄弟，就是打打闹闹。","石中剑，你是王者吗？"]
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createTableView()
        self.GetDate()
        self.view.backgroundColor = COLOR
        requestHelper.getSlideImages("3") { [unowned self] (success, response) in
            if success {
                print(response)
                let imageArr = response as! Array<PhotoInfo>
                for imageInfo in imageArr {
                    self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    })
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    func updateSlideImage(){
        for i in 1...4 {
            let imgView = scrollView.viewWithTag(i) as! UIImageView
            imgView.sd_setImageWithURL(NSURL(string: picArr[i-1]))
        }
    }
    
    func createTableView() {
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*190/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TouTiaoViewController.scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*190/375)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        for i in 0...3 {
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*190/375)
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
//    
//        requestHelper.getData("4") { (success, response) in
//            if success {
//                print(response)
//               let news = response as! NewsModel
//                print(news)
//                let newsArr = response as! NewsList
//                print(response?.data)
//                print("-----")
//                print(newsArr)
////                for newsInfo in newsArr {
////                   self.dataSource.append(<#T##list: [NewsInfo]##[NewsInfo]#>)
////                   
////                    dispatch_async(dispatch_get_main_queue(), {
////                     
////                        self.myTableView.reloadData()
////                    })
////                }
//            }
//        }
      //MBProgressHUD  HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES], retain];
        
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":"4"
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
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    print(LikeList(status.data!).objectlist)
                    self.likedataSource = LikeList(status.data!)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(14)], context: nil)
      print(boundingRect.height)
        if boundingRect.height+60>100 {
            return boundingRect.height+60
        }else{
            return 100
        }

    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!TouTiaoTableViewCell
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        cell.setCellWithNewsInfo(newsInfo)
        let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 14, width: WIDTH-140)
        cell.titLab.frame.size.height = titleHeight
        cell.heal.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
        cell.conNum.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
        cell.timeLab.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
        cell.comBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
        cell.timeBtn.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+5
        cell.contant.frame.origin.y = cell.titLab.frame.size.height + cell.titLab.frame.origin.y+20
        return cell
   
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.likeNum = newsInfo.likes.count
        print(newsInfo.likes.count)
        self.navigationController?.pushViewController(next, animated: true)
    }

}
