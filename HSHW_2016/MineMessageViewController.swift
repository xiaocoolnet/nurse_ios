//
//  MineMessageViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MineMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView = UITableView()
    var dataSource = MessageList()

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(MineMessageTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 80

        self.getDate()
        
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MineMessageTableViewCell
        cell.selectionStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        cell.titleLable.text = model.title
        cell.nameLable.text = model.content
//        cell.imgBtn.setBackgroundImage(UIImage(named: model.photo), forState: .Normal)
        cell.imgBtn.sd_setImageWithURL(NSURL(string:"http://nurse.xiaocool.net"+model.photo), placeholderImage: UIImage(named: "ic_lan.png"))
        cell.small.setBackgroundImage(UIImage(named: "ic_xin.png"), forState: .Normal)
//        cell.timeLable.text = "2016-07-04"
        cell.timeLable.text = timeStampToString(model.create_time)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = MineMessDetailViewController()
        vc.info = self.dataSource.objectlist[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

    
    
    func getDate(){
        let url = PARK_URL_Header+"getsystemmessage"
        let param = ["userid":QCLoginUserInfo.currentInfo.userid]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = MessageModel(JSONDecoder(json!))
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
                    print(status)
                    self.dataSource = MessageList(status.data!)
//                    print(LikeList(status.data!).objectlist)
//                    self.likedataSource = LikeList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }

    }

}
