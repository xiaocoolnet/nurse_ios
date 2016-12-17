//
//  QuestionBankViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class QuestionBankViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeModelDelegate {

    let myTableView = UITableView()
    var dataSource = NewsList()

    var term_id = "11"
    // 8万道题库
    
    var hasMenuHeight = true
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 出国考试 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 出国考试 "+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = RGREY
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: hasMenuHeight ? HEIGHT-44-64-1:HEIGHT-64-1)
        myTableView.backgroundColor = UIColor.clear
        myTableView.delegate = self
        myTableView.dataSource = self
//        myTableView.separatorStyle = .None
        myTableView.register(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 75
        // Do any additional setup after loading the view.
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))

        
//        self.GetData()
    }
    
    var pager = 2
    func loadData_pullUp(){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":term_id,
            "pager":String(pager),
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
            
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
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
                    self.myTableView .reloadData()
                    self.myTableView.mj_header.endRefreshing()
                    // print(status.data)
                }else{
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
        }
    }
    
    func GetData(){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":term_id,
            "pager":"1",
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ];
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
            // print(request)
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = status.errorData
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dataSource = NewsList(status.data!)
                    // print(LikeList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    // print(status.data)
                }
            }
            self.myTableView.mj_header.endRefreshing()
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let QuestionInfo = self.dataSource.objectlist[indexPath.row]
        let height = calculateHeight((QuestionInfo.post_title), size: 14, width: WIDTH-45)
        
        return height+18+10+12+10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!QuestionTableViewCell
        cell.selectionStyle = .none
        let QuestionInfo = self.dataSource.objectlist[indexPath.row]

        cell.newsInfo = QuestionInfo
        cell.likeImage.tag = indexPath.row
        cell.likeImage.addTarget(self, action: #selector(click1(_:)), for: .touchUpInside)
        cell.colBtn.tag = indexPath.row
        cell.colBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
        
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // print(indexPath.row)
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = "美国RN"
        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func click1(_ btn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[btn.tag]
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        if btn.isSelected {
            
            hud?.labelText = "正在取消点赞"
            
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
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = status.errorData
                        
                        hud?.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "取消点赞成功"
                        
                        hud?.hide(true, afterDelay: 0.5)
                        // print(status.data)
                        
                        for (i,obj) in (newsInfo.likes).enumerated() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                newsInfo.likes.remove(at: i)
                            }
                        }
                        
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                        
                    }
                }
            }
        }else {
            
            hud?.labelText = "正在点赞"
            
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
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = status.errorData
                        
                        hud?.hide(true, afterDelay: 3)
                    }
                    if(status.status == "success"){
                        
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "点赞成功"
                       
                        hud?.hide(true, afterDelay: 0.5)
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic as AnyObject))
                        newsInfo.likes.append(model)
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
          
                        // print(status.data)
                        if ((status.data?.event) != "") {
                            self.showScoreTips((status.data?.event)!, score: (status.data?.score)!)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: 显示积分提示
    func showScoreTips(_ name:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.opacity = 0.3
        hud?.margin = 10
        hud?.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud?.mode = .customView
        let customView = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH*0.8, height: WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*30/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .left
        titLab.font = UIFont.systemFont(ofSize: 16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*100/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .left
        scoreLab.font = UIFont.systemFont(ofSize: 24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRect(
            x: scoreLab.frame.maxX+5,
            y: customView.frame.height*100/238,
            width: customView.frame.width-scoreLab.frame.maxX-5-customView.frame.width*13/537,
            height: customView.frame.height*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .center
        jifenLab.font = UIFont.systemFont(ofSize: 16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud?.customView = customView
        hud?.hide(true, afterDelay: 3)
    }
    
    func collectionBtnClick(_ collectionBtn:UIButton) {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[collectionBtn.tag]
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        if collectionBtn.isSelected {
            
            hud?.labelText = "正在取消收藏"
            
            HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", handle: { (success, response) in
                if success {
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = "取消收藏成功"
                    hud?.hide(true, afterDelay: 0.5)
                    
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
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = String(describing: response)
                    hud?.hide(true, afterDelay: 1)
                }
            })
            
        }else {
            
            hud?.labelText = "正在收藏"
            
            HSMineHelper().addFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", title: newsInfo.post_title, description: newsInfo.post_excerpt, handle: { (success, response) in
                if success {
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = "收藏成功"
                    hud?.hide(true, afterDelay: 0.5)
                    
//                    let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
//                    let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
//                    newsInfo.favorites.append(model)
                    
                    newsInfo.favorites_count = String(NSString(string: (newsInfo.favorites_count ?? "0")!).integerValue+1)
                    newsInfo.favorites_add = "1"
                    
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = String(describing: response)
                    hud?.hide(true, afterDelay: 3)
                }
            })
        }
    }
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
