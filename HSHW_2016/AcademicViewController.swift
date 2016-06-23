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

class AcademicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
    var dataSource = NewsList()
    var isLike:Bool = false
    var likeNum :Int!
    var currentIndexRow:Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetData()
        self.view.backgroundColor = COLOR
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
    
        
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":"7"
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
                    
                    self.createTableView()
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }

    
    }
    
    func createTableView() {
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-108)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*120/355+63

        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!AcademicTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let photoUrl:String = "http://nurse.xiaocool.net"+newsInfo.thumb!
        print(photoUrl)
        cell.titImage.sd_setImageWithURL(NSURL(string:photoUrl), placeholderImage: UIImage(named: "2.png"))
        //cell.titImage.image = UIImage(named: "2.png")
        
        cell.titLab.text = newsInfo.post_title
        cell.conNum.text = newsInfo.recommended
        let time:Array = (newsInfo.post_date?.componentsSeparatedByString(" "))!
        cell.timeLab.text = time[0]
//        cell.zanNum.text = newsInfo.post_like
        let hashValue = newsInfo.likes.count.hashValue
        print(hashValue)
        if hashValue != 0 {
            cell.zan.setImage(UIImage(named:"ic_like_sel"), forState: UIControlState.Normal)
        }
//        print(hashValue)
        print("\(hashValue)")
        self.likeNum = hashValue
        cell.zanNum.text =  String(self.likeNum)
        cell.zan.addTarget(self, action: #selector(AcademicViewController.click1(_:)), forControlEvents: .TouchUpInside)
        cell.zan.tag = indexPath.row
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    
    func click1(btn:UIButton){
        print(btn.tag)
        print("赞")
        let newsInfo = self.dataSource.objectlist[btn.tag]
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        user.setObject("true", forKey: String(btn.tag))
        print(uid)
        if uid==nil {
            //btn.setImage(UIImage(named: "img_like.png"), forState: .Normal)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
            //self.presentViewController(vc, animated: true, completion: nil)
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
                            hud.hide(true, afterDelay: 3)
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
                            //user.setObject("false", forKey: (self.newsInfo?.object_id)!)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "取消点赞成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 3)
                            print(status.data)
                            self.isLike=false
                            user.setObject("false", forKey: "isLike")
                            user.setObject("false", forKey: (newsInfo.object_id)!)
                            user.setObject("false", forKey: String(btn.tag))
                            self.performSelectorOnMainThread(#selector(self.upDateUI(_:)), withObject: [btn.tag,"0"], waitUntilDone:true)
                            //user.removeObjectForKey((self.newsInfo?.object_id)!)
                        }
                    }
                    
                }
                
            }
            
            
        }
        
        
    }
    
    func upDateUI(status:NSArray){
        print("更新UI")
        
//        let userdefault = NSUserDefaults.standardUserDefaults()
//        print(status[0])
//        let indexPath = NSIndexPath.init(forRow: status[0] as! Int, inSection: 0)
//        print(indexPath.row)
//
//        print(self.currentIndexRow)
//        let isFirst:String = userdefault.objectForKey(String(indexPath.row)) as! String
//        print(isFirst)
//        if self.currentIndexRow != indexPath.row && isFirst == "true" {
//            let newsInfo = self.dataSource.objectlist[indexPath.row]
//            let hashValue = newsInfo.likes.count.hashValue
//            print(hashValue)
//            print(hashValue)
//            print("\(hashValue)")
//            self.likeNum = hashValue
//            currentIndexRow = indexPath.row
//            userdefault.setObject("false", forKey: String(indexPath.row))
//        }else{
//            print(userdefault.objectForKey(String(indexPath.row+10)) as! Int)
//            self.likeNum = Int(userdefault.objectForKey(String(indexPath.row+1)) as! String)
//        }
//        
//        let cell = self.myTableView.cellForRowAtIndexPath(indexPath)as! AcademicTableViewCell
////        let cell1 = self.myTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath:indexPath!)as! AcademicTableViewCell
//        if status[1] as! String=="1" {
//            self.likeNum  = self.likeNum+1
//            cell.zan.setImage(UIImage(named: "ic_like_sel"), forState: .Normal)
//            
//            userdefault.setObject(self.likeNum, forKey:String(indexPath.row+10))
//        }else{
//        
//            self.likeNum = self.likeNum-1
//            cell.zan.setImage(UIImage(named: "ic_like_gray.png"), forState: .Normal)
//            userdefault.setObject(self.likeNum, forKey:String(indexPath.row+10))
//        }
//         cell.zanNum.text = String(self.likeNum)
    }
    
    func getUpZanNum() {
        print("赞")
        
        
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
