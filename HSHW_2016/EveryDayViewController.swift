//
//  EveryDayViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class EveryDayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    var netData = titleList()
    let picArr:[String] = ["ic_rn.png","ic_earth.png","ic_moon.png","ic_maozi_one.png","ic_maozi_two.png","ic_maozi_three.png"]
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 10))
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.backgroundColor = RGREY
        
        self.title = "每日一练"
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(EveryDayTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 60
        self.view.addSubview(line)
        myTableView.tableHeaderView = one
        self.getData()

    }
    
    func getData(){
        
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"getDaliyExamTypeList"
        let param = [
            "userid":uid,
            "type":"1"
        ];
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            print(request)
            if(error != nil){
                
            }else{
                let status = EveryDayModel(JSONDecoder(json!))
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    self.netData = titleList(status.data!)
                    self.myTableView .reloadData()
                }
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return netData.objectlist.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if netData.objectlist[section].haschild == 0 {
            return 1
        }
        return netData.objectlist[section].childlist.count
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if netData.objectlist[section].haschild == 0 {
            return 0
        }
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if netData.objectlist[section].haschild == 0 {
            return nil
        }
        let backview = UIView(frame: CGRectMake(0,0,WIDTH,0))
        let image = UIImageView(frame: CGRectMake(10, 5, 20, 20))
        image.image = UIImage(named: picArr[section])
        
        let titleLabel = UILabel(frame: CGRectMake(35,5,WIDTH - 45,20))
        titleLabel.text = netData.objectlist[section].name
        
        backview.addSubview(image)
        backview.addSubview(titleLabel)
        return backview
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!EveryDayTableViewCell
        var info:EveryDayInfo
        if netData.objectlist[indexPath.section].haschild == 0 {
            info = self.netData.objectlist[indexPath.section]
        }else {
            info = self.netData.objectlist[indexPath.section].childlist[indexPath.row]
        }
        cell.selectionStyle = .None
        cell.titLab.text = info.name
        cell.titImage.setImage(UIImage(named: picArr[indexPath.section]), forState: .Normal)
        cell.start.userInteractionEnabled = false
        let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//        line.backgroundColor = UIColor.grayColor()
        line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        
        cell.addSubview(line)
        if netData.objectlist[indexPath.section].haschild == 0 {
            if indexPath.section == self.netData.objectlist.count - 1 {
                line.removeFromSuperview()
                let lastLine = UILabel(frame: CGRectMake(0, 59.5, WIDTH, 0.5))
                lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }else{
            if indexPath.row == self.netData.objectlist[indexPath.section].childlist.count - 1 {
                line.removeFromSuperview()
                let lastLine = UILabel(frame: CGRectMake(0, 59.5, WIDTH, 0.5))
                lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }
        cell.num.text = info.count
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, hasBackItem: true) {
            return
        }
        
        var info:EveryDayInfo
        if netData.objectlist[indexPath.section].haschild == 0 {
            info = self.netData.objectlist[indexPath.section]
        }else {
            info = self.netData.objectlist[indexPath.section].childlist[indexPath.row]
        }
        
        let next = WordViewController()
        next.questionCount = info.count
        self.navigationController?.pushViewController(next, animated: true)
        next.title = "练习题"
    }
}
