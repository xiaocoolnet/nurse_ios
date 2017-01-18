//
//  NSNewsSearchViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/18.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSNewsSearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,cateBtnClickedDelegate,changeModelDelegate {
    
    let rootTableView = UITableView()
    
    var newsInfoArray = [NewsInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = COLOR
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = COLOR
        
    }
    
    
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let search = UISearchBar(frame: CGRect(x: 0, y: 0, width: WIDTH-100, height: 35))
        search.barTintColor = UIColor.white
        search.tintColor = UIColor.blue
        search.searchBarStyle = .default
        //        search.layer.cornerRadius = 6
        //        search.layer.borderWidth = 1/UIScreen.mainScreen().scale
        //        search.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        search.placeholder = "大家都在搜：护士那些事"
        search.showsCancelButton = true
        
        //找到取消按钮
        let cancleBtn = search.value(forKey: "cancelButton") as! UIButton
        //修改标题和标题颜色
        cancleBtn.setTitle("搜索", for: .normal)
        cancleBtn.setTitleColor(UIColor.white, for: .normal)
        cancleBtn.setTitleColor(UIColor(red: 117/255.0, green: 43/255.0, blue: 93/255.0, alpha: 1), for: .disabled)
        
        search.delegate = self
        self.navigationItem.titleView = search
        
        rootTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64)
        rootTableView.dataSource = self
        rootTableView.delegate = self
        rootTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "toutiao")

        self.view.addSubview(rootTableView)
    }
    
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchAction(searchBar)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchAction(searchBar)
    }
    
    // MARK: - 搜索事件
    func searchAction(_ searchBar: UISearchBar) {
        
        self.keyword = searchBar.text!
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        HSNurseStationHelper().getArticleListWithID(nil, pager: "1", keyword: keyword) { (success, response) in
            
            if success {
                
                self.pager = 2
                
                self.rootTableView.mj_footer.resetNoMoreData()

                hud.hide(animated: true)
                
                searchBar.text = ""
                searchBar.resignFirstResponder()
                
                self.newsInfoArray = response as! [NewsInfo]
                self.rootTableView.reloadData()
                
                //                let circleSearchResultController = NSCircleSearchResultViewController()
                //                circleSearchResultController.hidesBottomBarWhenPushed = true
                //                circleSearchResultController.forumModelArray = forumList
                //                circleSearchResultController.title = "搜索结果"
                //                self.navigationController?.pushViewController(circleSearchResultController, animated: true)
            }else{
                
                if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                    self.newsInfoArray = []
                    self.rootTableView.reloadData()
                    hud.mode = .text
                    hud.label.text = "无结果"
                    hud.hide(animated: true, afterDelay: 1)
                }else{
                    
                    hud.mode = .text
                    hud.label.text = "搜索失败"
                    hud.hide(animated: true, afterDelay: 1)
                }
                
            }
            //                self.dataSource = response as! Array<NewsInfo>
//            if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
//                self.dataSource = Array<NewsInfo>()
//                self.myTableView.reloadData()
//            }else{
//                
//                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//                hud.mode = MBProgressHUDMode.text;
//                hud.label.text = "文章列表获取失败"
//                hud.detailsLabel.text = String(describing: (response ?? ("" as AnyObject))!)
//                hud.margin = 10.0
//                hud.removeFromSuperViewOnHide = true
//                hud.hide(animated: true, afterDelay: 1)
//            }
        }
        
//        CircleNetUtil.getForumList(userid: QCLoginUserInfo.currentInfo.userid, cid: "", isbest: "", istop: "", pager: "", title: searchBar.text!) { (success, response) in
//            if success {
//                
//                hud.hide(animated: true)
//                
//                searchBar.text = ""
//                searchBar.resignFirstResponder()
//                
//                self.forumModelArray = response as! [ForumListDataModel]
//                self.rootTableView.reloadData()
//                //                let circleSearchResultController = NSCircleSearchResultViewController()
//                //                circleSearchResultController.hidesBottomBarWhenPushed = true
//                //                circleSearchResultController.forumModelArray = forumList
//                //                circleSearchResultController.title = "搜索结果"
//                //                self.navigationController?.pushViewController(circleSearchResultController, animated: true)
//            }else{
//                hud.mode = .text
//                hud.label.text = "搜索失败"
//                hud.hide(animated: true, afterDelay: 1)
//            }
//            
//        }
    }
    
    var keyword = "" {
        didSet {
            if keyword != "" {
                rootTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
            }
        }
    }
    var pager = 2
    func loadData_pullUp() {
        
        if keyword == "" {
            self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        HSNurseStationHelper().getArticleListWithID(nil, pager: String(pager), keyword: keyword) { (success, response) in
            
            if success {
                self.pager += 1
                
                let newsInfoArray = response as! [NewsInfo]
                for newsInfo in newsInfoArray {
                    self.newsInfoArray.append(newsInfo)
                }
                self.rootTableView.reloadData()
                
                self.rootTableView.mj_footer.endRefreshing()

                //                let circleSearchResultController = NSCircleSearchResultViewController()
                //                circleSearchResultController.hidesBottomBarWhenPushed = true
                //                circleSearchResultController.forumModelArray = forumList
                //                circleSearchResultController.title = "搜索结果"
                //                self.navigationController?.pushViewController(circleSearchResultController, animated: true)
            }else{
                
                if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                    
                    self.rootTableView.mj_footer.endRefreshingWithNoMoreData()
                    
                }else{
                    
                    self.rootTableView.mj_footer.endRefreshing()

                }
                
            }
        }
    }
    
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.newsInfoArray.count;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsInfo = self.newsInfoArray[indexPath.row]
        
        //        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        //        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        //        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)], context: nil)
        //        let height = calculateHeight((newsInfo.post_title)!, size: 17, width: WIDTH-140)
        //        print(boundingRect.height)
        
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
        //        cell.type = 1
        cell.delegate = self
        cell.selectionStyle = .none
        let newsInfo = self.newsInfoArray[indexPath.row]
        
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = self.newsInfoArray[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        //        next.navTitle = "新闻内容"
        next.delegate = self
        //        print(newsInfo.likes.count)
        //        let str = newsInfo.likes
        //        var answerInfo = NSString()
        //        for j in 0 ..< str.count {
        //            answerInfo = str[j].userid!
        //            print(answerInfo)
        //        }
        //
        //        if answerInfo == QCLoginUserInfo.currentInfo.userid{
        //            print(1)
        //        }else{
        //            print(222)
        //        }
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    // MARK: 点击分类按钮
    func cateBtnClicked(_ categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        cateDetail.type = 1
        NSLog("%d", categoryBtn.tag)
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.newsInfoArray[andIndex] = newInfo
        self.rootTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
