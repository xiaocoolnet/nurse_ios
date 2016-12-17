//
//  HSWorkPlaceController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSWorkPlaceController: UIViewController,UITableViewDelegate,UITableViewDataSource,ToutiaoCateBtnClickedDelegate,changeModelDelegate {
    @IBOutlet weak var listTableView:UITableView!
    var newsList:Array<NewsInfo>?
    var articleID:String?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("护士站 招聘 " + (self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        listTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "zhichangbaodiancell")
        listTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        listTableView.mj_header.beginRefreshing()
        
        listTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
        
        listTableView.tableFooterView = UIView()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
    }
    
    func loadData(){
        
        let url = PARK_URL_Header+"getNewslist"
        
        let param = [
            "channelid":(articleID ?? "")!,
            "pager":"1",
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            //            print(request)
            if(error != nil){
            }else{
                let status = NewsModel(JSONDecoder(json!))

                if(status.status == "error"){
                    
                }
                if (status.status == "success") {
                    self.newsList = NewsList(status.data!).objectlist
                    dispatch_async(dispatch_get_main_queue(), {
                        self.listTableView.reloadData()
                    })
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.listTableView.mj_header.endRefreshing()
            })
            
        }
        
        
    }
    
    var pager = 2
    func loadData_pullUp() {
        
        HSNurseStationHelper().getArticleListWithID((articleID ?? "")!, pager: String(pager)) { (success, response) in
            
            if success {
                //                print(response)
                
                for element in response as! Array<NewsInfo> {
                    self.newsList?.append(element)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.listTableView.reloadData()
                    self.pager += 1
                })
                
                self.listTableView.mj_footer.endRefreshing()
                
            }else{
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.listTableView.mj_footer.endRefreshingWithNoMoreData()
                    
                })
            }
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsInfo = newsList![indexPath.row]
        
//        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
//        let screenBounds:CGRect = UIScreen.mainScreen().bounds
//        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
//        print(boundingRect.height)
//        if boundingRect.height+60>100 {
//            return boundingRect.height+60
//        }else{
//            return 100
//        }
        
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList != nil {
            return newsList!.count
        }else{
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("zhichangbaodiancell") as! TouTiaoTableViewCell
        cell.selectionStyle = .None
        cell.delegate = self
        let newsInfo = self.newsList![indexPath.row]
//        print(newsInfo.thumbArr.count)
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
        let newsInfo = newsList![indexPath.row]
        let next = NewsContantViewController()
        next.delegate = self
        next.newsInfo = newsInfo
        next.likeNum = newsInfo.likes.count
//        print(newsInfo.likes.count)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: 点击分类按钮
    func cateBtnClicked(categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        cateDetail.type = 1
//        cateDetail.name = categoryBtn.currentTitle!
        NSLog("%d", categoryBtn.tag)
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.newsList![andIndex] = newInfo
        self.listTableView.reloadData()
    }
}