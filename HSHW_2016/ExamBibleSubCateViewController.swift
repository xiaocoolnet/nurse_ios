//
//  ExamBibleSubCateViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class ExamBibleSubCateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,cateBtnClickedDelegate,changeModelDelegate, LFLUISegmentedControlDelegate {
    
    let listTableView = UITableView()
    
    var newsList:Array<NewsInfo>?
    var articleID:String?
    
    var showLineView = true
    
    var term_id = ""
    
    var data = Array<GNewsCate>()
    
    let headerScrollView = UIScrollView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadData_cate()
        
    }
    
    func setSubviews() {
        self.view.backgroundColor = UIColor.white
        
        if showLineView {
            
            let line = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
            line.backgroundColor = COLOR
            line.tag = 10001
            self.view.addSubview(line)
            
            listTableView.frame = CGRect(x: 0, y: 31, width: WIDTH, height: HEIGHT-65-30)
        }else{
            
            self.view.viewWithTag(10001)?.removeFromSuperview()
            listTableView.frame = CGRect(x: 0, y: 30, width: WIDTH, height: HEIGHT-64-30)
            
        }
        
        headerScrollView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 30)
        headerScrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(headerScrollView)
        
        listTableView.backgroundColor = UIColor.clear
        listTableView.delegate = self
        listTableView.dataSource = self
        self.view.addSubview(listTableView)
        listTableView.register(GToutiaoTableViewCell.self, forCellReuseIdentifier: "cell")
        listTableView.tableFooterView = UIView()
        
        listTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(loadData))
        listTableView.mj_header.beginRefreshing()
    }
    
    // MARK: 加载数据
    func loadData_cate() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.margin = 10
        hud?.labelText = "正在加载"
        hud?.removeFromSuperViewOnHide = true
        
        NewsPageHelper().getChannellist(self.term_id) { (success, response) in
            if success {
                self.data = response as! [GNewsCate]
                
                //                self.rootTableView.mj_header.endRefreshing()
                //                self.rootTableView.reloadData()
                self.articleID = self.data.first?.term_id
                
                var newsCateName = [String]()
                var str = ""
                
                for newsCate in self.data {
                    newsCateName.append((newsCate.name ?? "")!)
                    str += (newsCate.name ?? "")!
                }
                
                let margin:CGFloat = 5
                // 选择菜单
                let segChoose = LFLUISegmentedControl.segment(withFrame: CGRect(x: 0, y: 0,width: calculateWidth(str, size: 13, height: 30)+margin*CGFloat(newsCateName.count+1) ,height: 30), titleArray: newsCateName, defaultSelect: 0)
                segChoose?.tag = 101
                segChoose?.lineColor(COLOR)
                segChoose?.titleColor(UIColor.lightGray, selectTitleColor: COLOR, backGroundColor: UIColor.white, titleFontSize: 13)
                segChoose?.delegate = self
                self.headerScrollView.addSubview(segChoose!)
                
                self.headerScrollView.contentSize = CGSize(width: (segChoose?.frame.size.width)!, height: 0)
                
                self.setSubviews()
                
                hud?.hide(true)
                
            }else{
                hud?.mode = .text
                hud?.labelText = "网络错误，请稍后再试"
                hud?.hide(true, afterDelay: 1)
            }
        }
    }
    func loadData() {
        
        if articleID != nil {
            HSNurseStationHelper().getArticleListWithID(articleID!) {(success, response) in
                if success {
                    self.newsList = response as? Array<NewsInfo> ?? []
                    DispatchQueue.main.async(execute: {
                        self.listTableView.reloadData()
                    })
                }
                self.listTableView.mj_header.endRefreshing()
            }
        }
    }
    
    func uisegumentSelectionChange(_ selection: Int, segmentTag: Int) {
        print(selection)
        
        self.newsList = Array<NewsInfo>()
        self.listTableView.reloadData()
        
        self.articleID = self.data[selection].term_id
        self.listTableView.mj_header.beginRefreshing()
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
