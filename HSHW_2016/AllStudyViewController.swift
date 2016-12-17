//
//  AllStudyViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AllStudyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,cateBtnClickedDelegate,changeModelDelegate {
    
    let listTableView = UITableView()
    
//    var HSNurseStationHelper() = HSNurseStationHelper()
    var newsList:Array<NewsInfo>?
    var articleID:String?
    
    var showLineView = true
    
    var pager = 1

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        if showLineView {
            
            let line = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
            line.backgroundColor = COLOR
            line.tag = 10001
            self.view.addSubview(line)
            
            listTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        }else{
            
            self.view.viewWithTag(10001)?.removeFromSuperview()
            listTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64-70)

        }
        
        listTableView.backgroundColor = UIColor.clear
        listTableView.delegate = self
        listTableView.dataSource = self
        self.view.addSubview(listTableView)
        listTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "cell")
        listTableView.tableFooterView = UIView()
        
        listTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        listTableView.mj_header.beginRefreshing()
        
        listTableView.mj_footer = MJRefreshBackNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))
    }
    
    func loadData() {
        
        if articleID != nil {
            pager = 1
            HSNurseStationHelper().getArticleListWithID(articleID!, pager:String(pager)) { (success, response) in
                if success {
                    DispatchQueue.main.async(execute: {
                        self.pager += 1
                        self.newsList = response as? Array<NewsInfo> ?? []
                        self.listTableView.reloadData()
                    })
                }
                DispatchQueue.main.async(execute: {
                    if self.listTableView.mj_header.isRefreshing() {
                        
                        self.listTableView.mj_header.endRefreshing()
                    }
                })
            }
        }
    }
    func loadData_pullUp() {
        
        if articleID != nil {
            HSNurseStationHelper().getArticleListWithID(articleID!, pager: String(pager)) { (success, response) in
                if success {
                    
                    DispatchQueue.main.async(execute: {
                        self.pager += 1
                        
                        for newsInfo in response as? Array<NewsInfo> ?? []{
                            self.newsList?.append(newsInfo)
                        }
                        self.listTableView.reloadData()
                        self.listTableView.mj_footer.endRefreshing()
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.listTableView.mj_footer.endRefreshingWithNoMoreData()
                    })
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let newsInfo = newsList![indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList != nil {
            return newsList!.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GToutiaoTableViewCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!GToutiaoTableViewCell
        cell.delegate = self
        
        cell.selectionStyle = .none
        let newsInfo = self.newsList![indexPath.row]
        if newsInfo.thumbArr.count >= 3 {
            cell.setThreeImgCellWithNewsInfo(newsInfo)
        }else{
            cell.setCellWithNewsInfo(newsInfo)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        let newsInfo = newsList![indexPath.row]
//        let next = NewsContantViewController()
//        next.newsInfo = newsInfo
//        next.likeNum = newsInfo.likes.count
//        next.tagNum = 1
//        print(newsInfo.likes.count)
//        self.navigationController?.pushViewController(next, animated: true)
        
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = self.title!
        next.delegate = self
        
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
        self.newsList![andIndex] = newInfo
        self.listTableView.reloadData()
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
