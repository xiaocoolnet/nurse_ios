//
//  StudyViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class StudyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = Array<String>()
    var timer = NSTimer()
    var times = Int()
    var requestHelper = NewsPageHelper()
    
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
        
        let one = UIView(frame: CGRectMake(0, 1, WIDTH, WIDTH*188/375+10))
        self.view.addSubview(one)
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(StudyViewController.scroll), userInfo: nil, repeats: true)
        timer.fire()
        
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*188/375)
        scrollView.pagingEnabled = true
        scrollView.delegate = self

        for i in 0...3 {
            let imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*188/375)

            imageView.tag = i+1
            //为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(TouTiaoViewController.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSizeMake(4*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*188/375-30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(StudyViewController.pageNext), forControlEvents: .ValueChanged)
        one.addSubview(pageControl)
        
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
        myTableView.rowHeight = 60
        myTableView.tableHeaderView = one
        
        // Do any additional setup after loading the view.
    }
    
    func updateSlideImage(){
        for i in 1...4 {
            let imgView = scrollView.viewWithTag(i) as! UIImageView
            imgView.sd_setImageWithURL(NSURL(string: picArr[i-1]))
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if section == 0 {
            return 3
        }else if section == 1 {
            return 1
        }else if section == 2 {
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
            cell.titImage.setImage(UIImage(named: titImgArr[indexPath.row]), forState: .Normal)
            cell.titLab.text = titLabArr[indexPath.row]
            let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//            line.backgroundColor = UIColor.grayColor()
            line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
            
            cell.addSubview(line)
            if indexPath.row == 2 {
                line.removeFromSuperview()
            }
        }else if indexPath.section == 1 {
            cell.titImage.setImage(UIImage(named: "ic_plane.png"), forState: .Normal)
            cell.titLab.text = "出国考试"
        }else if indexPath.section == 2 {
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
            if indexPath.row == 0 {
                let next = EveryDayViewController()
//                let nextVC = DayPracticeViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 1 {
                let next = QuestionViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 2 {
                let next = OnlineTextViewController()
                self.navigationController?.pushViewController(next, animated: true)
//                
            }
        } else if indexPath.section == 1 {
            let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
            goAboard.articleID = "12"
            goAboard.title = "出国考试"
            self.navigationController?.pushViewController(goAboard, animated: true)
        } else if indexPath.section == 2 {
            
            if indexPath.row == 0 {
                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
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
                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                goAboard.articleID = "15"
                goAboard.title = "考试宝典"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }else if indexPath.section == 3 {
            if indexPath.row == 0 {
                let goAboard = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
                goAboard.articleID = "16"
                goAboard.title = "护理论文"
                self.navigationController?.pushViewController(goAboard, animated: true)
            }
        }
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
    }
    
    func pageNext() {
        scrollView.contentOffset = CGPointMake(WIDTH*CGFloat(pageControl.currentPage), 0)
    }
    
    func scroll(){
        if times == 4 {
            self.pageControl.currentPage = 0
        }else{
            self.pageControl.currentPage = times
        }
        scrollView.setContentOffset(CGPointMake(WIDTH*CGFloat(times), 0), animated: true)
        times += 1
        print("学习1")
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if times >= 5 {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            times = 1
        }
        print("学习2")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var number = Int(scrollView.contentOffset.x/WIDTH)
        if number == 4 {
            number = 0
            pageControl.currentPage = number
        }else{
            pageControl.currentPage = number
        }
    }
}
