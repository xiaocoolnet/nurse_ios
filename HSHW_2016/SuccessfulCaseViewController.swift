//
//  SuccessfulCaseViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class SuccessfulCaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeModelDelegate {
    
    var myTableView = UITableView()
    var dataSource = NewsList()
    var isLike:Bool = false
    //    var likeNum :Int!
    var currentIndexRow:Int?
    //    let likeNumDict = NSMutableDictionary()
    
    var num = 1
    var articleID:NSString?
    
    let nameArr:[String] = ["在线翻译","汇率查询","时差查询","学历认证","天气查询","地图查询","机票查询","酒店预订"]
    let picArr:[String] = ["ic_translate.png","ic_huilv.png","ic_shicha.png","ic_xueli.png","ic_weather.png","ic_map.png","ic_jipiao.png","ic_jiudian.png","ic_qianzhen.png"]
    
    let headerView = UIView()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createTableView()
        
        self.view.backgroundColor = COLOR
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
        
        let url = PARK_URL_Header+"getNewslist"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!
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
                    
                    //                    self.createTableView()
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.myTableView.mj_header.endRefreshing()
            })
            
        }
        
        
    }
    
    func createTableView() {
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-114)
        //        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "successfulCasecell")
        setheaderView()
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*0.5+63
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let successfulCaseCell = tableView.dequeueReusableCellWithIdentifier("successfulCasecell", forIndexPath: indexPath)as!AcademicTableViewCell
        successfulCaseCell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        successfulCaseCell.newsInfo = newsInfo
        successfulCaseCell.aca_zan.tag = indexPath.row
        successfulCaseCell.aca_zan.addTarget(self, action: #selector(click1(_:)), forControlEvents: .TouchUpInside)
        
        return successfulCaseCell
    }
    
    // MARK: 设置tableView头视图
    func setheaderView() {
        
        headerView.frame = CGRectMake(0, 0, WIDTH, WIDTH*281/3*2/375)
        for i in 0 ... 7 {
            
            let name = UILabel(frame: CGRectMake(WIDTH/4*CGFloat(i%4), WIDTH*(62+94*CGFloat(i/4))/375, WIDTH/4, 15))
            name.font = UIFont.systemFontOfSize(12)
            name.textAlignment = .Center
            name.text = nameArr[i]
            headerView.addSubview(name)
            let kindBtn = UIButton(frame: CGRectMake(WIDTH/4*CGFloat(i%4), WIDTH*(15+94*CGFloat(i/4))/375, WIDTH/4, WIDTH/16*3*281/375))
            kindBtn.setImage(UIImage(named: picArr[i]), forState: .Normal)
            
            kindBtn.addTarget(self, action: #selector(selectorCountry), forControlEvents: .TouchUpInside)
            kindBtn.tag = i
            headerView.addSubview(kindBtn)
        }
        
//        let horizontalLine_1 = UILabel(frame: CGRectMake(0, WIDTH*281/3/375, WIDTH, 0.5))
//        horizontalLine_1.backgroundColor = UIColor.grayColor()
//        headerView.addSubview(horizontalLine_1)
//        
//        let horizontalLine_2 = UILabel(frame: CGRectMake(0, WIDTH*281/3*2/375, WIDTH, 0.5))
//        horizontalLine_2.backgroundColor = UIColor.grayColor()
//        headerView.addSubview(horizontalLine_2)
        
        for i in 1 ... 3 {
            let linel = UILabel(frame: CGRectMake(WIDTH/4*CGFloat(i), 0, 0.5, WIDTH*281/3*2/375))
            linel.backgroundColor = UIColor.grayColor()
            headerView.addSubview(linel)
            
            let horizontalLine_1 = UILabel(frame: CGRectMake(0, WIDTH*281/3*CGFloat(i-1)/375, WIDTH, 0.5))
            horizontalLine_1.backgroundColor = UIColor.grayColor()
            headerView.addSubview(horizontalLine_1)
        }
        
        self.myTableView.tableHeaderView = headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        next.navTitle = self.title == nil ? self.title!:"新闻内容"
        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func click1(btn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[btn.tag]
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        if btn.selected {
            
            hud.labelText = "正在取消点赞"
            
            let url = PARK_URL_Header+"ResetLike"
            let param = [
                "id":newsInfo.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
                        hud.hide(true, afterDelay: 0.5)
                        print(status.data)
                        
                        for (i,obj) in (newsInfo.likes).enumerate() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                newsInfo.likes.removeAtIndex(i)
                            }
                        }
                        
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                    }
                }
            }
        }else {
            
            hud.labelText = "正在点赞"
            
            let url = PARK_URL_Header+"SetLike"
            let param = [
                
                "id":newsInfo.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
                        hud.hide(true, afterDelay: 3)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
                        hud.hide(true, afterDelay: 0.5)
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                        newsInfo.likes.append(model)
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
             
                        print(status.data)
                    }
                }
            }
        }
    }
    
    func upDateUI(status:NSArray){
        print("更新UI")
        print(status)
        //        if num == 2 {
        //            self.GetData1()
        //        }else{
        //            self.GetData()
        //        }
        self.myTableView.reloadData()
        let indexPath = NSIndexPath.init(forRow: status[0] as! Int, inSection: 0)
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! AcademicTableViewCell
        if status[1] as! String=="1" {
            cell.aca_zan.setImage(UIImage(named: "ic_like_sel"), forState: .Normal)
        }else{
            cell.aca_zan.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        }
        
    }
    
    //  MARK:- 点击出国百宝箱 功能
    func selectorCountry(btn:UIButton) {
        print(btn.tag)
        let vc = HSWebViewDetailController(nibName: "HSWebViewDetailController", bundle: nil)
        vc.navigationController?.navigationBar.hidden = false
        if btn.tag == 0 {
            //            vc.url = NSURL(string: "http://fanyi.youdao.com")
            vc.url = NSURL(string: "http://m.youdao.com/translate?vendor=fanyi.web")
            vc.title = "翻译"
        }else if btn.tag == 1{
            vc.url = NSURL(string: "http://www.boc.cn/sourcedb/whpj")
            vc.title = "汇率"
        }else if btn.tag == 2{
            vc.url = NSURL(string: "http://time.123cha.com")
            vc.title = "时差"
        }else if btn.tag == 3{
            vc.url = NSURL(string: "http://www.chsi.com.cn/xlcx")
            vc.title = "学历查询"
        }else if btn.tag == 4{
            vc.url = NSURL(string: "http://www.weather.com.cn")
            vc.title = "天气查询"
        }else if btn.tag == 5{
            vc.url = NSURL(string: "http://map.baidu.com")
            vc.title = "地图查询"
        }else if btn.tag == 6{
            vc.url = NSURL(string: "http://flight.qunar.com")
            vc.title = "机票查询"
        }else if btn.tag == 7{
            vc.url = NSURL(string: "http://m.ctrip.com/html5/")
            vc.title = "酒店"
        }else if btn.tag == 8{
            vc.url = NSURL(string: "http://baidu.com")
            vc.title = "签证"
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}