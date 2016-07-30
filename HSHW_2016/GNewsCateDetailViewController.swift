//
//  GNewsCateDetailViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class GNewsCateDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
        
    var type = 0
    var id = ""
    var name = ""

    var myTableView = UITableView()
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var picArr = Array<String>()
    var dataSource = NewsList()
//    var likedataSource = LikeList()
    var requestHelper = NewsPageHelper()
    
    internal var newsId = String()
    internal var post_title=String()
    internal var post_modified=String()
    var post_excerpt = String()
    var requestManager:AFHTTPSessionManager?
    var newsType:Int?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem()
        back.title = "返回"
        self.navigationItem.backBarButtonItem = back
        self.title = name
        
        self.createTableView()
        // Do any additional setup after loading the view.
    }
    
    func createTableView() {
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        myTableView.rowHeight = 100
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetDate))
        myTableView.mj_header.beginRefreshing()
    }
    
    func GetDate(){
        let url = PARK_URL_Header+"getNewslist"
        print(newsType)
        let param = ["channelid":String(newsType!)]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
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
                    print(status.data)
                }
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
        print(boundingRect.height)
        if boundingRect.height+60>100 {
            return boundingRect.height+60
        }else{
            return 100
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!GToutiaoTableViewCell
        cell.type = 2
        cell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        cell.setCellWithNewsInfo(newsInfo)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.likeNum = newsInfo.likes.count
        print(newsInfo.likes.count)
        self.navigationController?.pushViewController(next, animated: true)
    }
}
