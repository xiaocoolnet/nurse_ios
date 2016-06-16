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

class AbroadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = NSArray()
    var timer = NSTimer()
    var times = Int()
    //  请求认证id
    var channelid = Int()
    //  初始化数据源
    var dataSource = NewsList()
    let countryArr:[String] = ["ic_eng.png","ic_canada.png","ic_germany.png","ic_australia.png","ic_meiguo.png","ic_american.png","ic_guo.png","ic_guotwo.png"]
    let nameArr:[String] = ["美国","加拿大","德国","芬兰","澳洲","新西兰","新加坡","沙特"]
    let titArr:[String] = ["韩国美女，都长一个样～","有这样的治疗，我想受伤！","兄弟，就是打打闹闹。","石中剑，你是王者吗？"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-113)
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "Abroad")
        self.view.addSubview(myTableView)
        channelid = 4
        self.GetDate()
        // Do any additional setup after loading the view.
    }
    
    //  数据请求
    func GetDate( ){
        
        //MBProgressHUD  HUD = [[MBProgressHUD showHUDAddedTo:self.view animated:YES], retain];
        let url = PARK_URL_Header+"getNewslist"
        
        //  请求体
        
        let param = [
            "channelid":NSString.localizedStringWithFormat("%ld", channelid)
        ]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
                    //                    self.createTableView1()
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
            imageView.frame = CGRectMake(CGFloat(i) * WIDTH, 0, WIDTH, WIDTH*190/375)
            imageView.image = UIImage(named: picArr[i] as! String)
            imageView.tag = i + 1
            
            let bottom = UIView(frame: CGRectMake(CGFloat(i) * WIDTH, WIDTH * 190 / 375 - 30, WIDTH, 30))
            bottom.backgroundColor = UIColor.grayColor()
            bottom.alpha = 0.3
            let titLab = UILabel(frame: CGRectMake(CGFloat(i) * WIDTH + 10, WIDTH * 190 / 375 - 30, WIDTH - 100, 30))
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
        scrollView.contentSize = CGSizeMake(4 * WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH - 80, WIDTH * 190 / 375 - 30, 80, 30)
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
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "Abroad")
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
            return 100
        }
    }
    //  段尾视图的定义
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        //  创建视图
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, WIDTH*140/375))
        //  添加定时器
        timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(AbroadViewController.scroll), userInfo: nil, repeats: true)
        timer.fire()
        //  添加轮播效果
        scrollView.frame = CGRectMake(0, 0,WIDTH, WIDTH*140/375)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        picArr = ["1.png","2.png","3.png","4.png"]
        for i in 0...4 {
            let imageView = UIImageView()
            imageView.frame = CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH, WIDTH * 140 / 375)
            if i == 4 {
                imageView.image = UIImage(named: "1.png")
            }else{
                imageView.image = UIImage(named: "\(i+1).png")
            }
            imageView.tag = i + 1
            //  为图片视图添加点击事件
            imageView.userInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(AbroadViewController.tapAction(_:)))
            //            手指头
            tap.numberOfTapsRequired = 1
            //            单击
            tap.numberOfTouchesRequired = 1
            imageView.addGestureRecognizer(tap)
            scrollView.addSubview(imageView)
        }
        scrollView.contentSize = CGSizeMake(5 * WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        one.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(WIDTH - 80, WIDTH * 140 / 375 - 30, 80, 30)
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = COLOR
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(AbroadViewController.pageNext), forControlEvents: .ValueChanged)
        one.addSubview(pageControl)
        
        
        
        return one
    }
    //  段尾高度设置
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return WIDTH * 140 / 375
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            
            for i in 0...7 {
                let country = UIButton(frame: CGRectMake(WIDTH * (30 + 95 * CGFloat( i % 4 )) / 375, WIDTH * ( 20 + 70 * CGFloat(i / 4)) / 375, WIDTH * 34 / 375, WIDTH * 34 / 375))
                country.tag = i
                country.setBackgroundImage(UIImage(named: countryArr[i]), forState: .Normal)
                country.addTarget(self, action: #selector(AbroadViewController.selectorCountry(_:)), forControlEvents: .TouchUpInside)
                cell.addSubview(country)
                let countryName = UILabel(frame: CGRectMake(WIDTH*(95*CGFloat(i%4))/375, WIDTH*(59+70*CGFloat(i/4))/375, WIDTH*93/375, 18))
                countryName.font = UIFont.systemFontOfSize(12)
                countryName.textAlignment = .Center
                countryName.text = nameArr[i]
                cell.addSubview(countryName)
                
            }
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("Abroad", forIndexPath: indexPath)as!TouTiaoTableViewCell
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            cell.selectionStyle = .None
            cell.titLab.text = newsInfo.post_title
            //  动态计算高度
            let titleHeight:CGFloat = calculateHeight(newsInfo.post_title!, size: 14, width: WIDTH-140)
            print(titleHeight)
            cell.titLab.frame.size.height = titleHeight
            cell.conNum.text = newsInfo.recommended
            cell.timeLab.text = newsInfo.create_time
            let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
            cell.timeLab.text = time[0]
            cell.contant.text = newsInfo.post_excerpt
            //            cell.titLab.text = "保护好你的眼睛"
            //            cell.contant.text = "真的很累吗？累就对了，舒服是留给死人的！苦-才是人生 ，累-才是工作， 变-才是命运 ， 忍-才是历练，容-才是智慧 ， 静-才是修养，舍-才是得到 ，做-才是拥有！"
            cell.titImage.image = UIImage(named: "3.png")
            //            cell.conNum.text = "4352"
            //            cell.timeLab.text = "2016/05/24"
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
            //  push一个界面
            
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    //    国家
    func selectorCountry(btn:UIButton) {
        print(btn.tag)
        //  执行国家图片的点击内容
        channelid = btn.tag
        self.GetDate( )
        
        
    }
    //    图片点击事件
    func tapAction(tap:UIGestureRecognizer) {
        var imageView = UIImageView()
        imageView = tap.view as! UIImageView
        print("这是第\(Int(imageView.tag))张图片")
        //  执行点击操作
        //  进行数据请求，加载对应的页面
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
        // print("出国1")
    }
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        if times == 5 {
            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            times = 1
        }
        //print("出国2")
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //  偏移量
        var number = Int(scrollView.contentOffset.x/WIDTH)
        if number == 4 {
            number = 0
            //  设置当前页面
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
