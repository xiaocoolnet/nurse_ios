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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName(self.title == "学术会议" ? ("新闻 "+(self.title ?? "")!):("学习 "+(self.title ?? "")!))
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName(self.title == "学术会议" ? ("新闻 "+(self.title ?? "")!):("学习 "+(self.title ?? "")!))
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if articleID != nil {
            self.tabBarController?.tabBar.hidden = true
        }else{
            self.tabBarController?.tabBar.hidden = false
            
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
        ]
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
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
                    dispatch_async(dispatch_get_main_queue(), {
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
        ];
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
////            print(request)
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
//                print("状态是")
//                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
//                    self.createTableView()
//                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
//                    print(status.data)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { 
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
//                    //hud.labelText = status.errorData
//                    hud.margin = 10.0
//                    hud.removeFromSuperViewOnHide = true
//                    hud.hide(true, afterDelay: 1)
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
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, articleID == nil ? HEIGHT-64-49-1:HEIGHT-20)
//        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
//        myTableView.rowHeight = (WIDTH-20)*0.5+63

        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(GetData))
        myTableView.mj_header.beginRefreshing()
        
        myTableView.mj_footer = MJRefreshBackNormalFooter.init(refreshingTarget: self, refreshingAction: #selector(loadData_pullUp))

    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let titleHeight = calculateHeight(newsInfo.post_title, size: 14, width: WIDTH-20)
        return (WIDTH-20)*0.5+15+titleHeight+30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if articleID == nil {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!AcademicTableViewCell
            cell.selectionStyle = .None
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            cell.newsInfo = newsInfo
            cell.aca_zan.tag = indexPath.row
            cell.aca_zan.addTarget(self, action: #selector(click1(_:)), forControlEvents: .TouchUpInside)
            cell.comBtn.tag = indexPath.row
            cell.comBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!AcademicTableViewCell
            cell.selectionStyle = .None
            let newsInfo = self.dataSource.objectlist[indexPath.row]
            cell.academicNewsInfo = newsInfo
            cell.aca_zan.tag = indexPath.row
            cell.aca_zan.addTarget(self, action: #selector(click1(_:)), forControlEvents: .TouchUpInside)
            cell.comBtn.tag = indexPath.row
            cell.comBtn.addTarget(self, action: #selector(collectionBtnClick(_:)), forControlEvents: .TouchUpInside)
            
            return cell
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
//        next.navTitle = self.title == nil ? self.title!:"新闻内容"
        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func click1(btn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        let newsInfo = self.dataSource.objectlist[btn.tag]
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text;
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
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
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
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "取消点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
//                        print(status.data)
                        
                        for (i,obj) in (newsInfo.likes).enumerate() {
                            if obj.userid == QCLoginUserInfo.currentInfo.userid {
                                newsInfo.likes.removeAtIndex(i)
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
            
            hud.labelText = "正在点赞"
            
            let url = PARK_URL_Header+"SetLike"
            let param = [
                
                "id":newsInfo.object_id,
                "type":"1",
                "userid":QCLoginUserInfo.currentInfo.userid,
                ];
            
            NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param) { (json, error) in
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
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 3)
                    }
                    if(status.status == "success"){
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "点赞成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 0.5)
                        
                        let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
                        let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
                        newsInfo.likes.append(model)
                        self.dataSource.objectlist[btn.tag] = newsInfo
                        
                        self.myTableView.reloadData()
                        //                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
                        
                        //                            user.setObject("true", forKey: "isLike")
                        //                            user.setObject("true", forKey: (newsInfo.object_id)!)
                        //                            user.setObject("true", forKey: String(btn.tag))
//                        print(status.data)
                        
                        if ((status.data?.event) != "") {
                            self.showScoreTips((status.data?.event)!, score: (status.data?.score)!)
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
//                            hud.labelText = status.errorData
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 3)
//                        }
//                        if(status.status == "success"){
//                            
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.labelText = "点赞成功"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 0.5)
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
//                            hud.labelText = status.errorData
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 1)
//                        }
//                        if(status.status == "success"){
//                            
//                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                            hud.mode = MBProgressHUDMode.Text;
//                            hud.labelText = "取消点赞成功"
//                            hud.margin = 10.0
//                            hud.removeFromSuperViewOnHide = true
//                            hud.hide(true, afterDelay: 0.5)
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
    
    // MARK: 显示积分提示
    func showScoreTips(name:String, score:String) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.opacity = 0.3
        hud.margin = 10
        hud.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud.mode = .CustomView
        let customView = UIImageView(frame: CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*30/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .Left
        titLab.font = UIFont.systemFontOfSize(16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .Left
        scoreLab.font = UIFont.systemFontOfSize(24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRectMake(
            CGRectGetMaxX(scoreLab.frame)+5,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)-CGRectGetMaxX(scoreLab.frame)-5-CGRectGetWidth(customView.frame)*13/537,
            CGRectGetHeight(customView.frame)*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .Center
        jifenLab.font = UIFont.systemFontOfSize(16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud.customView = customView
        hud.hide(true, afterDelay: 3)
    }
    
    func collectionBtnClick(collectionBtn:UIButton) {
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
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
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = String((response ?? "")!)
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
                    
//                    let dic = ["userid":QCLoginUserInfo.currentInfo.userid]
//                    let model:LikeInfo = LikeInfo.init(JSONDecoder(dic))
//                    newsInfo.favorites.append(model)
                    newsInfo.favorites_count = String(NSString(string: (newsInfo.favorites_count ?? "0")!).integerValue+1)
                    newsInfo.favorites_add = "1"
                    
                    self.dataSource.objectlist[collectionBtn.tag] = newsInfo
                    
                    self.myTableView.reloadData()
                }else{
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = String((response ?? "")!)
                    hud.hide(true, afterDelay: 3)
                }
            })
        }
    }
    
    func upDateUI(status:NSArray){
//        print("更新UI")
//        print(status)
//        if num == 2 {
//            self.GetData1()
//        }else{
//            self.GetData()
//        }
        self.myTableView.reloadData()
        let indexPath = NSIndexPath.init(forRow: status[0] as! Int, inSection: 0)
        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! AcademicTableViewCell
        if status[1] as! String=="1" {
            cell.aca_zan.setImage(UIImage(named: "ic_like_sel"), forState: .Normal)
        }else{
            cell.aca_zan.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
        }

    }
    
    // MARK:更新模型
    func changeModel(newInfo: NewsInfo, andIndex: Int) {
        self.dataSource.objectlist[andIndex] = newInfo
        self.myTableView.reloadData()
    }
}
