//
//  AcademicViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class AcademicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeModelDelegate {
    
    var myTableView = UITableView()
    var dataSource = NewsList()
    var isLike:Bool = false
    var isCollection = false
//    var likeNum :Int!
    var currentIndexRow:Int?
//    let likeNumDict = NSMutableDictionary()
    
    var num = 1
    var articleID:NSString?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: self.title == "学术会议" ? ("新闻 "+(self.title ?? "")!):("学习 "+(self.title ?? "")!))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: self.title == "学术会议" ? ("新闻 "+(self.title ?? "")!):("学习 "+(self.title ?? "")!))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if articleID != nil {
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         self.createTableView()
//        if num == 2 {
////            self.GetData1()
//        }else{
//            
//        }
//        self.GetData()

        self.view.backgroundColor = COLOR
        
        // Do any additional setup after loading the view.
    }
    var pager = 2
    func loadData_pullUp(){
        
        let url = PARK_URL_Header+"getNewslist"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!,
            "pager":String(pager),
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ] as [String : Any]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//            <#code#>
//        }
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            //            print(request)
            if(error != nil){
                self.myTableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                let status = NewsModel(JSONDecoder(json!))
                //                print("状态是")
                //                print(status.status)
                
                if(status.status == "success"){
                    
                    //                    self.createTableView()
                    //                    print(status)
                    self.pager += 1
                    self.dataSource.append(NewsList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    //                    print(status.data)
                    DispatchQueue.main.async(execute: {
                        self.myTableView.mj_header.endRefreshing()
                    })
                }else{
                    self.myTableView.mj_footer.endRefreshingWithNoMoreData()
                }
            }
            
        }
        
        
    }
    
    func GetData(){
    
        let url = PARK_URL_Header+"getNewslist"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!,
            "pager":"1",
            "userid":QCLoginUserInfo.currentInfo.userid,
            "show_fav":"1"
        ] as [String : Any];
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
////            print(request)
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text;
                    //hud.label.text = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
//                    self.createTableView()
//                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
//                    print(status.data)
                }
            }
            DispatchQueue.main.async(execute: { 
                self.myTableView.mj_header.endRefreshing()
            })
            
        }

    
    }
//    func GetData1(){
//        
//        let url = PARK_URL_Header+"getNewslist"
//        
//        let param = [
//            "channelid":"14"
//        ];
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//            print(request)
//            if(error != nil){
//                
//            }else{
//                let status = NewsModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
//                if(status.status == "error"){
//                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                    hud.mode = MBProgressHUDMode.Text;
//                    //hud.label.text = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(animated: true, afterDelay: 1)
//                }
//                if(status.status == "success"){
//                    
////                    self.createTableView()
//                    print(status)
//                    self.dataSource = NewsList(status.data!)
//                    self.myTableView .reloadData()
//                    print(status.data)
//                }
//            }
//            
//        }
//        
//        
//    }

    
    func createTableView() {
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: articleID == nil ? HEIGHT-64-49-1:HEIGHT-20)
//        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
//        myTableView.rowHeight = (WIDTH-20)*0.5+63

        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let titleHeight = calculateHeight(newsInfo.post_title, size: 14, width: WIDTH-20)
        return (WIDTH-20)*0.5+15+titleHeight+30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if articleID == nil {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!AcademicTableViewCell
            cell.selectionStyle = .none
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            cell.newsInfo = newsInfo
            cell.aca_zan.tag = indexPath.row
            cell.aca_zan.addTarget(self, action: #selector(click1(_:)), for: .touchUpInside)
            cell.comBtn.tag = indexPath.row
            cell.comBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)as!AcademicTableViewCell
            cell.selectionStyle = .none
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            cell.academicNewsInfo = newsInfo
            cell.aca_zan.tag = indexPath.row
            cell.aca_zan.addTarget(self, action: #selector(click1(_:)), for: .touchUpInside)
            cell.comBtn.tag = indexPath.row
            cell.comBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), for: .touchUpInside)
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = self.title == nil ? self.title!:"新闻内容"
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
//
//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//                print(request)
                if(error != nil){
                    
                }else{
                    let status = Http(JSONDecoder(json!))
//                    print("状态是")
//                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "取消点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 0.5)
//                        print(status.data)
                        
                        for (i,obj) in (newsInfo.likes).enumerated() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                newsInfo.likes.remove(at: i)
                            }
                        }
                        
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                        
//                        self.isLike=false
//                        user.setObject("false", forKey: "isLike")
//                        user.setObject("false", forKey: (newsInfo.object_id)!)
//                        user.setObject("false", forKey: String(btn.tag))
//                        self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                        
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
//
//            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
//                print(request)
                if(error != nil){
                    
                }else{
                    let status = addScore_ReadingInformationModel(JSONDecoder(json!))
//                    print("状态是")
//                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 3)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 0.5)
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic as AnyObject))
                        newsInfo.likes.append(model)
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                        //                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
                        
                        //                            user.setObject("true", forKey: "isLike")
                        //                            user.setObject("true", forKey: (newsInfo.object_id)!)
                        //                            user.setObject("true", forKey: String(btn.tag))
//                        print(status.data)
                        
                        if ((status.data?.event) != "") {
                            NursePublicAction.showScoreTips(self.view, nameString: (status.data?.event)!, score: (status.data?.score)!)
                        }
                        //                            self.isLike=true
                    }
                }
        }
        
//        print(btn.tag)
//        print("赞")
//        let newsInfo = self.dataSource.objectlist[btn.tag]
//        let user = NSUserDefaults.standardUserDefaults()
//        let uid = user.stringForKey("userid")
//        user.setObject("true", forKey: String(btn.tag))
//        print(uid)
//        if uid==nil {
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        }else{
//            print(newsInfo.object_id)
//            let userID = user.stringForKey((newsInfo.object_id)!)
//            let row = user.stringForKey(String(btn.tag))
//            print(userID)
//            print(row)
//            if (userID == nil || row == nil)||(userID == "false"||row == "false") {
//                let url = PARK_URL_Header+"SetLike"
//                let param = [
//                    
//                    "id":newsInfo.object_id,
//                    "type":"1",
//                    "userid":uid,
//                    ];
//                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
//                    print(request)
//                    if(error != nil){
//                        
//                    }else{
//                        let status = Http(JSONDecoder(json!))
//                        print("状态是")
//                        print(status.status)
//                        if(status.status == "error"){
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.label.text = status.errorData
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(animated: true, afterDelay: 3)
//                        }
//                        if(status.status == "success"){
//                            
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.label.text = "点赞成功"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(animated: true, afterDelay: 0.5)
//                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
//                            
//                            user.setObject("true", forKey: "isLike")
//                            user.setObject("true", forKey: (newsInfo.object_id)!)
//                            user.setObject("true", forKey: String(btn.tag))
//                            print(status.data)
//                            self.isLike=true
//                        }
//                    }
//                    
//                }
//                
//            }else{
//                
//                let url = PARK_URL_Header+"ResetLike"
//                let param = [
//                    "id":newsInfo.object_id,
//                    "type":"1",
//                    "userid":uid,
//                    ];
//                Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
//                    print(request)
//                    if(error != nil){
//                        
//                    }else{
//                        let status = Http(JSONDecoder(json!))
//                        print("状态是")
//                        print(status.status)
//                        if(status.status == "error"){
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.label.text = status.errorData
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(animated: true, afterDelay: 1)
//                        }
//                        if(status.status == "success"){
//                            
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.label.text = "取消点赞成功"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(animated: true, afterDelay: 0.5)
//                            print(status.data)
//                            self.isLike=false
//                            user.setObject("false", forKey: "isLike")
//                            user.setObject("false", forKey: (newsInfo.object_id)!)
//                            user.setObject("false", forKey: String(btn.tag))
//                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
//                            
//                        }
//                    }
//                }
//            }
        }
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
    
    func upDateUI(_ status:NSArray){
//        print("更新UI")
//        print(status)
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
    
    // MARK:更新模型
    func changeModel(_ newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
