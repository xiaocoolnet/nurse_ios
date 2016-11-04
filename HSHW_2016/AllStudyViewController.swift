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
    
    var helper = HSNurseStationHelper()
    var newsList:Array<NewsInfo>?
    var articleID:String?
    
    var showLineView = true
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        if showLineView {
            
            let line = UIView(frame: CGRectMake(0, 0, WIDTH, 1))
            line.backgroundColor = COLOR
            line.tag = 10001
            self.view.addSubview(line)
            
            listTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        }else{
            
            self.view.viewWithTag(10001)?.removeFromSuperview()
            listTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-64)

        }
        
        listTableView.backgroundColor = UIColor.clearColor()
        listTableView.delegate = self
        listTableView.dataSource = self
        self.view.addSubview(listTableView)
        listTableView.registerClass(GToutiaoTableViewCell.self, forCellReuseIdentifier: "cell")
        listTableView.tableFooterView = UIView()
        
        listTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        listTableView.mj_header.beginRefreshing()
    }
    
    func loadData() {
        
        if articleID != nil {
            helper.getArticleListWithID(articleID!) {[unowned self] (success, response) in
                if success {
                    self.newsList = response as? Array<NewsInfo> ?? []
                    dispatch_async(dispatch_get_main_queue(), {
                        self.listTableView.reloadData()
                    })
                }
                self.listTableView.mj_header.endRefreshing()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList != nil {
            return newsList!.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GToutiaoTableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!GToutiaoTableViewCell
        cell.delegate = self
        
        cell.selectionStyle = .None
        let newsInfo = self.newsList![indexPath.row]
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
    func cateBtnClicked(categoryBtn: UIButton) {
        let cateDetail = GNewsCateDetailViewController()
        cateDetail.newsType = categoryBtn.tag
        cateDetail.type = 1
        NSLog("%d", categoryBtn.tag)
        self.navigationController!.pushViewController(cateDetail, animated: true)
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
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
