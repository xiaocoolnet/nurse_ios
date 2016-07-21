//
//  OnlineTextViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class OnlineTextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    var dataSource = titleList()
    let picArr:[String] = ["ic_rn.png","ic_earth.png","ic_moon.png","ic_maozi_one.png","ic_maozi_two.png","ic_maozi_three.png"]
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        
        self.view.backgroundColor = RGREY
        self.view .addSubview(line)
        self.title = "在线考试"
        
        self.createTableView()
        self.getData()
    }
    
    func createTableView(){
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT - 60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        self.view.addSubview(myTableView)
        myTableView.registerClass(OnlineTextTableViewCell.self, forCellReuseIdentifier: "onlineCell")
        
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 10))
        myTableView.tableHeaderView = one
    }
    
    func getData(){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"getDaliyExamTypeList"
        let param = [
            "userid":uid,
            "type":"11"
        ];
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            print(request)
            if(error != nil){
                
            }else{
                let status = EveryDayModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                //print(status.array)
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
                    self.dataSource = titleList(status.data!)
                    
                    print(self.dataSource)
                    print("-----")
                    print(titleList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.objectlist.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.objectlist[section].haschild == 0 {
            return 1
        }
        return dataSource.objectlist[section].childlist.count
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource.objectlist[section].haschild == 0 {
            return 0
        }
        return 30
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataSource.objectlist[section].haschild == 0 {
            return nil
        }
        let backview = UIView(frame: CGRectMake(0,0,WIDTH,0))
        let image = UIImageView(frame: CGRectMake(10, 5, 20, 20))
        image.image = UIImage(named: picArr[section])
        
        let titleLabel = UILabel(frame: CGRectMake(35,5,WIDTH - 45,20))
        titleLabel.text = dataSource.objectlist[section].name
        
        backview.addSubview(image)
        backview.addSubview(titleLabel)
        return backview
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("onlineCell", forIndexPath: indexPath)as!OnlineTextTableViewCell
        var info:EveryDayInfo
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            info = self.dataSource.objectlist[indexPath.section]
        }else {
            info = self.dataSource.objectlist[indexPath.section].childlist[indexPath.row]
        }
        cell.selectionStyle = .None
        cell.titleLable.text = info.name
        cell.titleImg.setImage(UIImage(named: picArr[indexPath.section]), forState: .Normal)
        cell.startBtn.userInteractionEnabled = false
        let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
//        line.backgroundColor = UIColor.grayColor()
        line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        cell.addSubview(line)
//        if 5 == indexPath.row{
//            line.removeFromSuperview()
//        }
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            if indexPath.section == self.dataSource.objectlist.count - 1 {
                line.removeFromSuperview()
                let lastLine = UILabel(frame: CGRectMake(0, 59.5, WIDTH, 0.5))
                lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }else{
            if indexPath.row == self.dataSource.objectlist[indexPath.section].childlist.count - 1 {
                line.removeFromSuperview()
                 let lastLine = UILabel(frame: CGRectMake(0, 59.5, WIDTH, 0.5))
                 lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }
        cell.numLable.text = info.count
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var info:EveryDayInfo
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            info = dataSource.objectlist[indexPath.section]
        }else {
            info = dataSource.objectlist[indexPath.section].childlist[indexPath.row]
        }

        let nextVC = OnLineViewController()
        nextVC.questionCount = info.count
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
