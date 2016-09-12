//
//  QuestionBankViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class QuestionBankViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeModelDelegate {

    let myTableView = UITableView()
    var dataSource = NewsList()

    var term_id = "11"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = RGREY
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-44-64-1)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
//        myTableView.separatorStyle = .None
        myTableView.registerClass(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 75
        // Do any additional setup after loading the view.
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
//        self.GetData()
    }
    
    func GetData(){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":term_id
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
                    hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    print(LikeList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            self.myTableView.mj_header.endRefreshing()
        }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let QuestionInfo = self.dataSource.objectlist[indexPath.row]
        let height = calculateHeight((QuestionInfo.post_title), size: 14, width: WIDTH-45)
        
        return height+18+10+12+10
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!QuestionTableViewCell
        cell.selectionStyle = .None
        let QuestionInfo = self.dataSource.objectlist[indexPath.row]

        cell.newsInfo = QuestionInfo
        cell.likeImage.tag = indexPath.row
        cell.likeImage.addTarget(self, action: #selector(click1(_:)), forControlEvents: .TouchUpInside)
        cell.colBtn.tag = indexPath.row
        cell.colBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = "美国RN"
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
    
    func collectionBtnClick(collectionBtn:UIButton) {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hasBackItem: true) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[collectionBtn.tag]
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        if collectionBtn.selected {
            
            hud.labelText = "正在取消收藏"
            
            HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", handle: { (success, response) in
                if success {
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "取消收藏成功"
                    hud.hide(true, afterDelay: 0.5)
                    
                    for (i,obj) in (newsInfo.favorites).enumerate() {
                        if obj.userid == QCLoginUserInfo.currentInfo.userid {
                            newsInfo.favorites.removeAtIndex(i)
                        }
                    }
                    
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = String(response!)
                    hud.hide(true, afterDelay: 1)
                }
            })
            
        }else {
            
            hud.labelText = "正在收藏"
            
            HSMineHelper().addFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", title: newsInfo.post_title, description: newsInfo.post_excerpt, handle: { (success, response) in
                if success {
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "收藏成功"
                    hud.hide(true, afterDelay: 0.5)
                    
                    let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                    let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                    newsInfo.favorites.append(model)
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = String(response!)
                    hud.hide(true, afterDelay: 3)
                }
            })
        }
    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
