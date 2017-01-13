//
//  SuccessfulCaseViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "出国 " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "出国 " + (self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createTableView()
        
        self.view.backgroundColor = COLOR
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
        
        let url = PARK_URL_Header+"getNewslist_new"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!,
            "pager":"1",
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ] as [String : Any];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                DispatchQueue.main.async(execute: {
                    self.myTableView.mj_header.endRefreshing()
                    
                })
            }else{
                let status = NewsModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
//                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    //hud.label.text = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(animated: true, afterDelay: 1)
//                }
                if(status.status == "success"){
                    
                    BmobCloud.callFunction(inBackground: "show3rdInfo", withParameters: ["name":"hidden"], block: { (object, error) in

                        if object as! String == "show" {
//                            let time: NSTimeInterval = 1.0
//                            let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC)))
//                            
//                            dispatch_after(delay, dispatch_get_main_queue()) {
//                            }
                            DispatchQueue.main.async(execute: {
                                self.myTableView.mj_header.endRefreshing()
                                if self.myTableView.tableHeaderView == nil {
                                    if self.myTableView.tableHeaderView == nil {
                                        
                                        self.setheaderView()
                                        
                                        // print(status.data)
                                        self.dataSource = NewsList(status.data!)
                                        self.myTableView .reloadData()
                                        
                                        DispatchQueue.main.async(execute: {
                                            self.myTableView.mj_header.endRefreshing()
                                            
                                        })
                                    }
                                }
                            })
                            
                        }else{
                            self.dataSource = NewsList(status.data!)
                            self.myTableView .reloadData()
                            
                            DispatchQueue.main.async(execute: {
                                self.myTableView.mj_header.endRefreshing()
                                
                            })
                        }
                    })
                }
            }
            
            
        }
        
    }
    
    var pager = 2
    func loadData_pullUp(){
        
        let url = PARK_URL_Header+"getNewslist_new"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!,
            "pager":String(pager),
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ] as [String : Any];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                self.myTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                let status = NewsModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "success"){
                    
                    //                    self.createTableView()
                    // print(status)
                    self.pager += 1
                    self.dataSource.append(NewsList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    
                    DispatchQueue.main.async(execute: {
                        self.myTableView.mj_header.endRefreshing()
                        
                    })
                    // print(status.data)
                }else{
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
           
            
        }
        

        
        
    }
    
    func createTableView() {
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-114)
        //        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(AcademicTableViewCell.self, forCellReuseIdentifier: "successfulCasecell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*0.5+63
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let successfulCaseCell = tableView.dequeueReusableCell(withIdentifier: "successfulCasecell", for: indexPath)as!AcademicTableViewCell
        successfulCaseCell.selectionStyle = .none
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        successfulCaseCell.newsInfo = newsInfo
//        successfulCaseCell.aca_zan.tag = indexPath.row
//        successfulCaseCell.aca_zan.addTarget(self, action: #selector(click1(_:)), for: .touchUpInside)
//        successfulCaseCell.comBtn.tag = indexPath.row
//        successfulCaseCell.comBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
        
        return successfulCaseCell
    }
    
    // MARK: 设置tableView头视图
    func setheaderView() {
        
        headerView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*281/3*2/375)
        for i in 0 ... 7 {
            
            let name = UILabel(frame: CGRect(x: WIDTH/4*CGFloat(i%4), y: WIDTH*(62+94*CGFloat(i/4))/375, width: WIDTH/4, height: 15))
            name.font = UIFont.systemFont(ofSize: 12)
            name.textAlignment = .center
            name.text = nameArr[i]
            headerView.addSubview(name)
            let kindBtn = UIButton(frame: CGRect(x: WIDTH/4*CGFloat(i%4), y: WIDTH*(15+94*CGFloat(i/4))/375, width: WIDTH/4, height: WIDTH/16*3*281/375))
            kindBtn.setImage(UIImage(named: picArr[i]), for: UIControlState())
            
            kindBtn.addTarget(self, action: #selector(selectorCountry), for: .touchUpInside)
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
            let linel = UILabel(frame: CGRect(x: WIDTH/4*CGFloat(i), y: 0, width: 0.5, height: WIDTH*281/3*2/375))
            linel.backgroundColor = UIColor.gray
            headerView.addSubview(linel)
            
            let horizontalLine_1 = UILabel(frame: CGRect(x: 0, y: WIDTH*281/3*CGFloat(i-1)/375, width: WIDTH, height: 0.5))
            horizontalLine_1.backgroundColor = UIColor.gray
            headerView.addSubview(horizontalLine_1)
        }
        
        self.myTableView.tableHeaderView = headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        // print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = self.title == nil ? self.title!:"新闻内容"
        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func collectionBtnClick(_ collectionBtn:UIButton) {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[collectionBtn.tag]
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        if collectionBtn.isSelected {
            
            hud.label.text = "正在取消收藏"
            
            HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", handle: { (success, response) in
                if success {
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = "取消收藏成功"
                    hud.hide(animated: true, afterDelay: 0.5)
                    
                    //                    for (i,obj) in (newsInfo.favorites).enumerate() {
                    //                        if obj.userid == QCLoginUserInfo.currentInfo.userid {
                    //                            newsInfo.favorites.removeAtIndex(i)
                    //                        }
                    //                    }
                    
                    newsInfo.favorites_count = String(NSString(string: (newsInfo.favorites_count ?? "0")!).integerValue-1)
                    newsInfo.favorites_add = "0"
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = String(describing: (response ?? ("" as AnyObject))!)
                    hud.hide(animated: true, afterDelay: 1)
                }
            })
            
        }else {
            
            hud.label.text = "正在收藏"
            
            HSMineHelper().addFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", title: newsInfo.post_title, description: newsInfo.post_excerpt, handle: { (success, response) in
                if success {
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = "收藏成功"
                    hud.hide(animated: true, afterDelay: 0.5)
                    
                    //                    let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                    //                    let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                    //                    newsInfo.favorites.append(model)
                    newsInfo.favorites_count = String(NSString(string: (newsInfo.favorites_count ?? "0")!).integerValue+1)
                    newsInfo.favorites_add = "1"
                    
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud.mode = MBProgressHUDMode.text;
                    hud.label.text = String(describing: (response ?? ("" as AnyObject))!)
                    hud.hide(animated: true, afterDelay: 3)
                }
            })
        }
    }
    
    func click1(_ btn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[btn.tag]
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        if btn.isSelected {
            
            hud.label.text = "正在取消点赞"
            
            let url = PARK_URL_Header+"ResetLike"
            let param = [
                "id":newsInfo.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                // print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = status.errorData
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "取消点赞成功"
                        hud.hide(animated: true, afterDelay: 0.5)
                        // print(status.data)
                        
                        newsInfo.likes_count = String(NSString(string: newsInfo.likes_count).integerValue-1)
                        newsInfo.likes_add = "0"
//                        for (i,obj) in (newsInfo.likes).enumerated() {
//                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
//                                newsInfo.likes.remove(at: i)
//                            }
//                        }
                        
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                    }
                }
            }
        }else {
            
            hud.label.text = "正在点赞"
            
            let url = PARK_URL_Header+"SetLike"
            let param = [
                
                "id":newsInfo.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
                // print(request)
                if(error != nil){
                    
                }else{
                    let status = addScore_ReadingInformationModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){

                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = status.errorData
                        hud.hide(animated: true, afterDelay: 3)
                    }
                    if(status.status == "success"){
                        
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "点赞成功"
                        hud.hide(animated: true, afterDelay: 0.5)
                        
                        newsInfo.likes_count = String(NSString(string: newsInfo.likes_count).integerValue+1)
                        newsInfo.likes_add = "1"
//                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
//                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic as AnyObject))
//                        newsInfo.likes.append(model)
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
             
                        // print(status.data)
                        
                        if ((status.data?.event) != "") {
                            NursePublicAction.showScoreTips(self.view, nameString: (status.data?.event)!, score: (status.data?.score)!)
                        }
                    }
                }
            }
        }
    }
    
    func upDateUI(_ status:NSArray){
        // print("更新UI")
        // print(status)
        //        if num == 2 {
        //            self.GetData1()
        //        }else{
        //            self.GetData()
        //        }
        self.myTableView.reloadData()
        let indexPath = IndexPath.init(row: status[0] as! Int, section: 0)
        let cell = self.myTableView.cellForRow(at: indexPath)as! AcademicTableViewCell
        if status[1] as! String=="1" {
            cell.aca_zan.setImage(UIImage(named: "ic_like_sel"), for: UIControlState())
        }else{
            cell.aca_zan.setImage(UIImage(named: "ic_like_gray.png"), for: UIControlState())
        }
        
    }
    
    //  MARK:- 点击出国百宝箱 功能
    func selectorCountry(_ btn:UIButton) {
        // print(btn.tag)
        let vc = HSWebViewDetailController(nibName: "HSWebViewDetailController", bundle: nil)
        vc.navigationController?.navigationBar.isHidden = false
        if btn.tag == 0 {
            //            vc.url = NSURL(string: "http://fanyi.youdao.com")
            vc.url = URL(string: "http://m.youdao.com/translate?vendor=fanyi.web")
            vc.title = "翻译"
        }else if btn.tag == 1{
            vc.url = URL(string: "http://www.boc.cn/sourcedb/whpj")
            vc.title = "汇率"
        }else if btn.tag == 2{
            vc.url = URL(string: "http://time.123cha.com")
            vc.title = "时差"
        }else if btn.tag == 3{
            vc.url = URL(string: "http://www.chsi.com.cn/xlcx")
            vc.title = "学历查询"
        }else if btn.tag == 4{
            vc.url = URL(string: "http://www.weather.com.cn")
            vc.title = "天气查询"
        }else if btn.tag == 5{
            vc.url = URL(string: "http://map.baidu.com")
            vc.title = "地图查询"
        }else if btn.tag == 6{
            vc.url = URL(string: "http://flight.qunar.com")
            vc.title = "机票查询"
        }else if btn.tag == 7{
            vc.url = URL(string: "http://m.ctrip.com/html5/")
            vc.title = "酒店"
        }else if btn.tag == 8{
            vc.url = URL(string: "http://baidu.com")
            vc.title = "签证"
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
