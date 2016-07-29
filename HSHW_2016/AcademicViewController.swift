//
//  AcademicViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AcademicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,changeModelDelegate {
    
    var myTableView = UITableView()
    var dataSource = NewsList()
    var isLike:Bool = false
//    var likeNum :Int!
    var currentIndexRow:Int?
//    let likeNumDict = NSMutableDictionary()
    
    var num = 1
    var articleID:NSString?
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.createTableView()
        if num == 2 {
//            self.GetData1()
        }else{
            
        }
        self.GetData()

        self.view.backgroundColor = COLOR
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
    
        let url = PARK_URL_Header+"getNewslist"
        
        let param = [
            "channelid":articleID == nil ? "7":articleID!
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
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    
//                    self.createTableView()
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
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
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-108)
//        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*0.5+63

        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!AcademicTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
       
        cell.newsInfo = newsInfo
        cell.aca_zan.tag = indexPath.row
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        //        print(newsInfo.title,newsInfo.term_id)
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.index = indexPath.row
        next.navTitle = self.title == nil ? self.title!:"新闻内容"
        next.delegate = self
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    func click1(btn:UIButton){
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        
        print(btn.tag)
        print("赞")
        let newsInfo = self.dataSource.objectlist[btn.tag]
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        user.setObject("true", forKey: String(btn.tag))
        print(uid)
        if uid==nil {
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            print(newsInfo.object_id)
            let userID = user.stringForKey((newsInfo.object_id)!)
            let row = user.stringForKey(String(btn.tag))
            print(userID)
            print(row)
            if (userID == nil || row == nil)||(userID == "false"||row == "false") {
                let url = PARK_URL_Header+"SetLike"
                let param = [
                    
                    "id":newsInfo.object_id,
                    "type":"1",
                    "userid":uid,
                    ];
                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 3)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 0.5)
                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"1"], waitUntilDone:true)
                            
                            user.setObject("true", forKey: "isLike")
                            user.setObject("true", forKey: (newsInfo.object_id)!)
                            user.setObject("true", forKey: String(btn.tag))
                            print(status.data)
                            self.isLike=true
                        }
                    }
                    
                }
                
            }else{
                
                let url = PARK_URL_Header+"ResetLike"
                let param = [
                    "id":newsInfo.object_id,
                    "type":"1",
                    "userid":uid,
                    ];
                Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
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
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "取消点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 0.5)
                            print(status.data)
                            self.isLike=false
                            user.setObject("false", forKey: "isLike")
                            user.setObject("false", forKey: (newsInfo.object_id)!)
                            user.setObject("false", forKey: String(btn.tag))
                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                            
                        }
                    }
                }
            }
        }
    }
    
    func upDateUI(status:NSArray){
        print("更新UI")
        print(status)
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
