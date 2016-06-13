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
    var picArr = NSArray()
    var timer = NSTimer()
    var times = Int()
    
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
        
        picArr = ["1.png","2.png","3.png","4.png"]
        for i in 0...4 {
            let imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH*188/375)
            if i == 4 {
                imageView.image = UIImage(named: "1.png")
            }else{
                imageView.image = UIImage(named: "\(i+1).png")
            }

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
        scrollView.contentSize = CGSizeMake(5*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH-80, WIDTH*188/375-30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(StudyViewController.pageNext), forControlEvents: .ValueChanged)
        one.addSubview(pageControl)
        
        
        myTableView.rowHeight = 60
        myTableView.tableHeaderView = one
        
        // Do any additional setup after loading the view.
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
            line.backgroundColor = UIColor.grayColor()
            
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
            line.backgroundColor = UIColor.grayColor()
            
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
        print(indexPath.row)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let next = EveryDayViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 1 {
                let next = QuestionBankViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
            if indexPath.row == 2 {
                let next = OnlineExaminationViewController()
                self.navigationController?.pushViewController(next, animated: true)
                
            }
        }else{
            let next = NewsContantViewController()
            self.navigationController?.pushViewController(next, animated: true)
            
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
        if times == 5 {
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