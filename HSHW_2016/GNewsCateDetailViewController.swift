//
//  GNewsCateDetailViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class GNewsCateDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,changeModelDelegate {
        
    var type = 0
    var id = ""
    var name = ""

    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = Array<String>()
    var dataSource = NewsList()
//    var likedataSource = LikeList()
//    var requestHelper = NewsPageHelper()
    
    internal var newsId = String()
    internal var post_title=String()
    internal var post_modified=String()
    var post_excerpt = String()
    var requestManager:AFHTTPSessionManager?
    var newsType:Int?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "新闻分类页"+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "新闻分类页"+(self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.title = name
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.createTableView()
        // Do any additional setup after loading the view.
    }
    
    func createTableView() {
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        myTableView.rowHeight = 100
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetDate))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))

    }
    
    func GetDate(){
        let url = PARK_URL_Header+"getNewslist"
        // print(newsType)
        let param = ["channelid":String(newsType!)]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    //hud.labelText = status.errorData
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dataSource = NewsList(status.data!)
                    // print(LikeList(status.data!).objectlist)
                    //                    self.likedataSource = LikeList(status.data!)
                    switch self.newsType!{
                    case 4:
                        self.title = "头条资讯"
                    case 5:
                        self.title = "护理园地"
                    case 6:
                        self.title = "健康知识"
                    default:
                        self.title = self.dataSource.objectlist.first?.term_name
                    }
                    self.myTableView.reloadData()
                    self.myTableView.mj_header.endRefreshing()
                    // print(status.data)
                }
            }
            
        }
    }
    
    var pager = 2
    func loadData_pullUp(){
        let url = PARK_URL_Header+"getNewslist"
        // print(newsType)
        let param = ["channelid":String(newsType!),"pager":String(pager)]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                self.myTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                let status = NewsModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                
                if(status.status == "success"){
                    // print(status)
                    
                    self.pager += 1
                    self.dataSource.append(NewsList(status.data!).objectlist)
                    // print(LikeList(status.data!).objectlist)
//                    self.likedataSource = LikeList(status.data!)
                    
                    self.myTableView.reloadData()
                    self.myTableView.mj_header.endRefreshing()
                    // print(status.data)
                }else{
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]

        if newsInfo.thumbArr.count >= 3 {
            
            let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-20)
            
            let margin:CGFloat = 15
            return (WIDTH-20-margin*2)/3.0*2/3.0+19+height+27+4
        }else{
            
            let height = calculateHeight((newsInfo.post_title), size: 17, width: WIDTH-140)
            
            if height+27>100 {
                return height+27+4
            }else{
                return 100
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toutiao", for: indexPath)as!GToutiaoTableViewCell
        cell.type = 2
        cell.selectionStyle = .none
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.likeNum = newsInfo.likes.count
        next.delegate = self
        // print(newsInfo.likes.count)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
