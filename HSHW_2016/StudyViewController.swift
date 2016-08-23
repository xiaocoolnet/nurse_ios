//
//  StudyViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class StudyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
//    var picArr = Array<String>()
//    var titArr = Array<String>()
    var timer = NSTimer()
    var times = Int()
    var requestHelper = NewsPageHelper()
    var newsList = Array<NewsInfo>()
    var imageArr = Array<NewsInfo>()
    
    var noRead = true
    
    let titLabArr:[String] = ["每日一练","5万道题库","在线考试"]
    let titImgArr:[String] = ["ic_bi.png","ic_fuzhi.png","ic_phone.png"]
    
    let titLabArrTwo:[String] = ["临床护理","50项护理操作","考试宝典"]
    let titImgArrTwo:[String] = ["ic_hushi.png","ic_zhen.png","ic_book.png"]
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.tabBarController?.tabBar.hidden = false
        myTableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(MineTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.separatorStyle = .None
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        myTableView.mj_header.beginRefreshing()
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*188/375))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*188/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*188/375-25, 80, 25)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 60
        myTableView.tableHeaderView = one
        
        // Do any additional setup after loading the view.
    }
    
    func loadData() {
        
//        HSNurseStationHelper().getArticleListWithID("10") {[unowned self] (success, response) in
//            if success {
//                self.newsList = response as? Array<NewsInfo> ?? []
//                
//                self.requestHelper.getSlideImages("6") { [unowned self] (success, response) in
//                    if success {
//                        print(response)
//                        self.imageArr = response as! Array<PhotoInfo>
////                        for imageInfo in self.imageArr {
////                            self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
////                            self.titArr.append(imageInfo.name)
//                            dispatch_async(dispatch_get_main_queue(), {
//                                self.updateSlideImage()
//                                self.myTableView.reloadData()
//                                self.myTableView.mj_header.endRefreshing()
//                            })
////                        }
//                    }
//                }
//            }
//        }
        
        
//        var flag = 0
        
        HSNurseStationHelper().getArticleListWithID("111") { (success, response) in
            
            if success {
                print(response)
                self.imageArr = response as! Array<NewsInfo>
                //                for imageInfo in self.imageArr {
                //                    self.picArr.append(IMAGE_URL_HEADER + imageInfo.picUrl)
                //                    self.titArr.append(imageInfo.name)
                //                    //                    self.titArr.append(imageInfo)
                
                //                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                
//                flag += 1
//                if flag == 2 {
                    self.myTableView.mj_header.endRefreshing()
//                }
            }else{
                dispatch_async(dispatch_get_main_queue(), {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if response as? String == "no data" {
                        self.imageArr = Array<NewsInfo>()
                        self.updateSlideImage()
                        self.myTableView.reloadData()
                    }
                    
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "轮播图获取失败"
                    hud.detailsLabelText = String(response!)
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                })
            }
        }
        
//        HSNurseStationHelper().getArticleListWithID("10") { (success, response) in
//            
//            if success {
//                print(response)
//                
//                self.newsList = response as! Array<NewsInfo>
//                
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.updateSlideImage()
//                    self.myTableView.reloadData()
//                })
//                
//                flag += 1
//                if flag == 2 {
//                    self.myTableView.mj_header.endRefreshing()
//                }
//                
//            }else{
//                self.myTableView.mj_header.endRefreshing()
//                
//                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text;
//                hud.labelText = "文章列表获取失败"
//                hud.detailsLabelText = String(response!)
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
        
        for (i,slideImage) in self.imageArr.enumerate() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*188/375)
            imageView.tag = i+1
            if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImageWithURL(NSURL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRectMake(0, WIDTH*188/375-25, WIDTH, 25))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRectMake(10, WIDTH*188/375-25, WIDTH-100, 25))
            titLab.font = UIFont.systemFontOfSize(14)
            titLab.textColor = UIColor.whiteColor()
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
        
        pageControl.numberOfPages = self.imageArr.count
        pageControl.frame = CGRectMake(WIDTH-20*CGFloat(imageArr.count), WIDTH*188/375-25, 20*CGFloat(imageArr.count), 25)
        pageControl.currentPage = 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1 {
            return 3
        }else if section == 2 {
            return 1
        }else if section == 3 {
            return 3
        }else{
            return 1
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineTableViewCell
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        
        if indexPath.section == 0 {
            cell.titImage.setImage(UIImage(named: "ic_wirte"), forState: .Normal)
            cell.titLab.text = "护士笔记"
            
//            if noRead {
//                let numLab = UILabel()
//                numLab.frame = CGRectMake(0, 0, 25, 25)
//                numLab.backgroundColor = UIColor.redColor()
//                numLab.layer.cornerRadius = 12.5
//                numLab.clipsToBounds = true
//                numLab.textAlignment = .Center
//                numLab.textColor = UIColor.whiteColor()
//                numLab.font = UIFont.systemFontOfSize(10)
//                numLab.text = "99+"
//                cell.accessoryView = numLab
//            }else{
//                cell.accessoryView = nil
//            }
        }else if indexPath.section == 1 {
            cell.titImage.setImage(UIImage(named: titImgArr[indexPath.row]), forState: .Normal)
            cell.titLab.text = titLabArr[indexPath.row]
            let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//            line.backgroundColor = UIColor.grayColor()
            line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            
            cell.addSubview(line)
            if indexPath.row == 2 {
                line.removeFromSuperview()
            }
        }else if indexPath.section == 2 {
            cell.titImage.setImage(UIImage(named: "ic_plane.png"), forState: .Normal)
            cell.titLab.text = "出国考试"
        }else if indexPath.section == 3 {
            cell.titImage.setImage(UIImage(named: titImgArrTwo[indexPath.row]), forState: .Normal)
            cell.titLab.text = titLabArrTwo[indexPath.row]
            let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//            line.backgroundColor = UIColor.grayColor()
            line.backgroundColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
            
            cell.addSubview(line)
            if indexPath.row == 2 {
                line.removeFromSuperview()
            }
        }else{
            cell.titImage.setImage(UIImage(named: "ic_benzi.png"), forState: .Normal)
            cell.titLab.text = "护理论文"
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 {
            print("学习-护士笔记点击事件")
            self.noRead = false
            self.myTableView.reloadData()
            
            let noteVC = AllStudyViewController()
            noteVC.articleID = "95"
            noteVC.title = "护士笔记"
            self.navigationController?.pushViewController(noteVC, animated: true)
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let next = OnlineTextViewController()
                next.title = "每日一练"
                next.type = 1
//                let nextVC = DayPracticeViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 1 {
                let next = QuestionViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 2 {
                let next = OnlineTextViewController()
                next.title = "在线考试"
                next.type = 2
                self.navigationController?.pushViewController(next, animated: true)
//                
            }
        } else if indexPath.section == 2 {
//            let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
            let goAboard = AllStudyViewController()
            goAboard.articleID = "12"
            goAboard.title = "出国考试"
            self.navigationController?.pushViewController(goAboard, animated: true)
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                let goAboard = AllStudyViewController()
                goAboard.articleID = "13"
                goAboard.title = "临床护理"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }else if indexPath.row == 1{
                let goAboard = AcademicViewController()
                goAboard.articleID = "14"
                goAboard.num = 2
                goAboard.title = "50项护理操作"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }else if indexPath.row == 2 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                let goAboard = AllStudyViewController()
                goAboard.articleID = "15"
                goAboard.title = "考试宝典"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 0 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                let goAboard = AllStudyViewController()
                goAboard.articleID = "16"
                goAboard.title = "护理论文"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }
    }
    // MARK:图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
        
        let next = NewsContantViewController()
        next.newsInfo = imageArr[imageView.tag-1]
        next.navTitle = imageArr[imageView.tag-1].term_name
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func pageNext() {
        scrollView.contentOffset = CGPointMake(WIDTH*CGFloat(pageControl.currentPage), 0)
    }
    
//    func scroll(){
//        if times == 4 {
//            self.pageControl.currentPage = 0
//        }else{
//            self.pageControl.currentPage = times
//        }
//        scrollView.setContentOffset(CGPointMake(WIDTH*CGFloat(times), 0), animated: true)
//        times += 1
//        print("学习1")
//    }
    
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
//
//    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        if times >= 5 {
//            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
//            times = 1
//        }
//        print("学习2")
//    }
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        var number = Int(scrollView.contentOffset.x/WIDTH)
//        if number == 4 {
//            number = 0
//            pageControl.currentPage = number
//        }else{
//            pageControl.currentPage = number
//        }
//    }
}
