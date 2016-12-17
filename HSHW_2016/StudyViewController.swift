//
//  StudyViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class StudyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = SMPageControl()
//    var picArr = Array<String>()
//    var titArr = Array<String>()
    var timer = Timer()
    var times = Int()
//    var requestHelper = NewsPageHelper()
    var newsList = Array<NewsInfo>()
    var imageArr = Array<NewsInfo>()
    
    let titLabArr:[String] = ["每日一练","8万道题库","模拟考场"]
    let titImgArr:[String] = ["ic_bi.png","ic_fuzhi.png","在线考试"]
    
    let titLabArrTwo:[String] = ["临床护理","50项护理操作","考试宝典"]
    let titImgArrTwo:[String] = ["ic_hushi.png","ic_zhen.png","ic_book.png"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.tabBarController?.tabBar.isHidden = false
                
        myTableView.reloadData()
        
        HSNurseStationHelper().getArticleListWithID("95") { (success, response) in
            if success {
                self.hulibu_newsArray = response as! Array<NewsInfo>
                let hulibu_originalNewsUpdateTime = UserDefaults.standard.string(forKey: HULIBU_ORIGINALNEWSUPDATETIME)
                if hulibu_originalNewsUpdateTime == nil {
                    hulibu_updateNum = self.hulibu_newsArray.count
                }else{
                    
                    for (i,newsInfo) in self.hulibu_newsArray.enumerated() {
                        if newsInfo.post_modified == hulibu_originalNewsUpdateTime {
                            hulibu_updateNum = i
                            break
                        }
                    }
                }
                
                self.myTableView.reloadData()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR
//        NSUserDefaults.standardUserDefaults().removeObjectForKey(HULIBU_ORIGINALNEWSUPDATETIME)
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-60)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(MineTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.separatorStyle = .none
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        myTableView.mj_header.beginRefreshing()
        
        let one = UIView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: WIDTH*188/375))
        self.view.addSubview(one)
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(scroll), userInfo: nil, repeats: true)
        
        scrollView.frame = CGRect(x: 0, y: 0,width: WIDTH, height: WIDTH*188/375)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        scrollView.contentSize = CGSize(width: 4*WIDTH, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: WIDTH-80, y: WIDTH*188/375-25, width: 80, height: 25)
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = self.imageArr.count
        pageControl.currentPage = 0
        one.addSubview(pageControl)
        
        myTableView.rowHeight = 60
        myTableView.tableHeaderView = one
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(hulibu_updateNumChanged), name: "hulibu_updateNumChanged", object: nil)
        
        // Do any additional setup after loading the view.
    }
    
//    func hulibu_updateNumChanged() {
//        myTableView.reloadData()
//    }
    var hulibu_newsArray = [NewsInfo]()
    func loadData() {
        
        HSNurseStationHelper().getArticleListWithID("95") { (success, response) in
            if success {
                self.hulibu_newsArray = response as! Array<NewsInfo>
                let hulibu_originalNewsUpdateTime = UserDefaults.standard.string(forKey: HULIBU_ORIGINALNEWSUPDATETIME)
                if hulibu_originalNewsUpdateTime == nil {
//                    NSUserDefaults.standardUserDefaults().setValue(self.hulibu_newsArray.first?.post_modified, forKey: HULIBU_ORIGINALNEWSUPDATETIME)
                    hulibu_updateNum = self.hulibu_newsArray.count
                }else{
                    
                    for (i,newsInfo) in self.hulibu_newsArray.enumerated() {
                        if newsInfo.post_modified == hulibu_originalNewsUpdateTime {
                            hulibu_updateNum = i
                            self.myTableView.reloadData()
                            break
                        }
                    }
                }
                
//                if hulibu_alreadyRead {
//                    NSUserDefaults.standardUserDefaults().setValue(hulibu_newsArray.first?.post_modified, forKey: HULIBU_ORIGINALNEWSUPDATETIME)
//                    hulibu_alreadyRead = false
//                }
            }
        }

        
        HSNurseStationHelper().getArticleListWithID("111") { (success, response) in
            
            if success {
//                print(response)
                let imageArr = response as! Array<NewsInfo>
                self.imageArr = imageArr.count>=5 ? Array(imageArr[0...slideImageListMaxNum-1]):imageArr

                DispatchQueue.main.async(execute: {
                    self.updateSlideImage()
                    self.myTableView.reloadData()
                })
                

                self.myTableView.mj_header.endRefreshing()
            }else{
                DispatchQueue.main.async(execute: {
                    self.myTableView.mj_header.endRefreshing()
                    
                    if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
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
            y: WIDTH*188/375-25,
            width: pageControl.rect(forPageIndicator: 0).width*CGFloat(self.imageArr.count)+margin*CGFloat(self.imageArr.count-1),
            height: 25)
        pageControl.indicatorMargin = margin
        pageControl.currentPage = 0
        
        for (i,slideImage) in self.imageArr.enumerated() {
            
            let  imageView = UIImageView()
            imageView.frame = CGRect(x: CGFloat(i)*WIDTH, y: 0, width: WIDTH, height: WIDTH*188/375)
            imageView.tag = i+1
            // TODO:JUDGE WIFI
            if  (!NurseUtil.net.isWifi() && loadPictureOnlyWiFi) && slideImage.thumbArr.count == 0 {
//            if  (!(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi) || slideImage.thumbArr.count == 0 {
                imageView.image = UIImage.init(named: "defaultImage.png")
            }else{
                imageView.sd_setImage(with: URL(string: DomainName+"data/upload/"+(slideImage.thumbArr.first?.url)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
            }
            
            let bottom = UIView(frame: CGRect(x: 0, y: WIDTH*188/375-25, width: WIDTH, height: 25))
            bottom.backgroundColor = UIColor.gray
            bottom.alpha = 0.5
            imageView.addSubview(bottom)
            
            let titLab = UILabel(frame: CGRect(x: 10, y: WIDTH*188/375-25, width: pageControl.frame.minX-10, height: 25))
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!MineTableViewCell
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.accessoryView = nil

        if indexPath.section == 0 {
            cell.titImage.setImage(UIImage(named: "ic_wirte"), for: UIControlState())
            cell.titLab.text = "护理部「智库」"

            if hulibu_updateNum > 0 {
                cell.accessoryType = .none
                let numLab = UILabel()
                numLab.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
                numLab.backgroundColor = UIColor.red
                numLab.layer.cornerRadius = 12.5
                numLab.clipsToBounds = true
                numLab.textAlignment = .center
                numLab.textColor = UIColor.white
                numLab.font = UIFont.systemFont(ofSize: 15)
                if hulibu_updateNum > 99 {
                    numLab.text = "99+"
                }else{
                    numLab.text = String(hulibu_updateNum)
                }
                numLab.adjustsFontSizeToFitWidth = true
                cell.accessoryView = numLab
            }else{
                cell.accessoryView = nil
            }
        }else if indexPath.section == 1 {
            cell.titImage.setImage(UIImage(named: titImgArr[indexPath.row]), for: UIControlState())
            cell.titLab.text = titLabArr[indexPath.row]
            let line = UILabel(frame: CGRect(x: 55, y: 59.5, width: WIDTH-55, height: 0.5))
//            line.backgroundColor = UIColor.grayColor()
            line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            
            cell.addSubview(line)
            if indexPath.row == 2 {
                line.removeFromSuperview()
            }
        }else if indexPath.section == 2 {
            cell.titImage.setImage(UIImage(named: "ic_plane.png"), for: UIControlState())
            cell.titLab.text = "出国考试"
        }else if indexPath.section == 3 {
            cell.titImage.setImage(UIImage(named: titImgArrTwo[indexPath.row]), for: UIControlState())
            cell.titLab.text = titLabArrTwo[indexPath.row]
            let line = UILabel(frame: CGRect(x: 55, y: 59.5, width: WIDTH-55, height: 0.5))
//            line.backgroundColor = UIColor.grayColor()
            line.backgroundColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 204/255.0, alpha: 1.0)
            
            cell.addSubview(line)
            if indexPath.row == 2 {
                line.removeFromSuperview()
            }
        }else{
            cell.titImage.setImage(UIImage(named: "ic_benzi.png"), for: UIControlState())
            cell.titLab.text = "护理论文"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("学习-护理部点击事件")
            
            hulibu_updateNum = 0
//            hulibu_alreadyRead = true
            
            UserDefaults.standard.setValue(hulibu_newsArray.first?.post_modified, forKey: HULIBU_ORIGINALNEWSUPDATETIME)

            
            let noteVC = AllStudyViewController()
            noteVC.articleID = "95"
            noteVC.title = "护理部「智库」"
            noteVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(noteVC, animated: true)
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let next = OnlineTextViewController()
                next.title = "每日一练"
                next.type = 1
//                let nextVC = DayPracticeViewController()
                next.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 1 {
                let next = QuestionViewController()
                next.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 2 {
                let next = OnlineTextViewController()
                next.title = "模拟考场"
                next.type = 2
                next.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(next, animated: true)
//                
            }
        } else if indexPath.section == 2 {
//            let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
            let goAboard = GoAboardExamViewController()
//            goAboard.articleID = "12"
            goAboard.title = "出国考试"
            goAboard.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(goAboard, animated: true)
        } else if indexPath.section == 3 {
            
            if indexPath.row == 0 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                let goAboard = AllStudyViewController()
                goAboard.articleID = "13"
                goAboard.title = "临床护理"
                goAboard.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(goAboard, animated: true)
            }else if indexPath.row == 1{
                let goAboard = AcademicViewController()
                goAboard.articleID = "14"
                goAboard.num = 2
                goAboard.title = "50项护理操作"
                goAboard.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(goAboard, animated: true)
            }else if indexPath.row == 2 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                
                let goAboard = ExamBibleViewController()
                goAboard.title = "考试宝典"
                goAboard.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(goAboard, animated: true)
                
                // TODO: 需要子类时  放开上边  注释下边
//                let goAboard = AllStudyViewController()
//                goAboard.articleID = "15"
//                goAboard.title = "考试宝典"
//                goAboard.hidesBottomBarWhenPushed = true
//                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }else if indexPath.section == 4 {
            if indexPath.row == 0 {
//                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                let goAboard = AllStudyViewController()
                goAboard.articleID = "16"
                goAboard.title = "护理论文"
                goAboard.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }
    }
    // MARK:图片点击事件
    func tapAction(_ tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
        
        let next = NewsContantViewController()
        next.newsInfo = imageArr[imageView.tag-1]
//        next.navTitle = imageArr[imageView.tag-1].term_name
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func pageNext() {
        scrollView.contentOffset = CGPoint(x: WIDTH*CGFloat(pageControl.currentPage), y: 0)
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
