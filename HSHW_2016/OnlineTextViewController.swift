//
//  OnlineTextViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class OnlineTextViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT - 64-49), style: .grouped)
    var type = 1 // 1 每日一练  2在线考试
    var dataSource = titleList()
    let picArr:[String] = ["ic_rn.png","ic_earth.png","ic_moon.png","ic_maozi_one.png","ic_maozi_two.png","ic_maozi_three.png"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        
        self.view.backgroundColor = RGREY
        self.view .addSubview(line)
//        self.title = "在线考试"
        
        self.createTableView()
//        self.getData()
    }
    
    func createTableView(){
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT - 64)
        myTableView.backgroundColor = UIColor.clear
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .none
        self.view.addSubview(myTableView)
        myTableView.register(OnlineTextTableViewCell.self, forCellReuseIdentifier: "onlineCell")
        
        let one = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 10))
        myTableView.tableHeaderView = one
        
        myTableView.mj_header = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(getData))
        myTableView.mj_header.beginRefreshing()
    }
    
    func getData(){
        let user = UserDefaults.standard
        let uid = user.string(forKey: "userid")
        let url = PARK_URL_Header+"getDaliyExamTypeList"
        let param = [
            "userid":uid,
            "type":type == 1 ? "1":"11"
        ];
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { request, response, json, error in
            // print(request)
            if(error != nil){
                
            }else{
                let status = EveryDayModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                //// print(status.array)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    //hud.labelText = status.errorData
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dataSource = titleList(status.data!)
                    
                    // print(self.dataSource)
                    // print("-----")
                    // print(titleList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    // print(status.data)
                }
            }
            self.myTableView.mj_header.endRefreshing()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.objectlist.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.objectlist[section].haschild == 0 {
            return 1
        }
        return dataSource.objectlist[section].childlist.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource.objectlist[section].haschild == 0 {
            return 0.0000000001
        }
        return 30
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if dataSource.objectlist[section].haschild == 0 {
            return nil
        }
        let backview = UIView(frame: CGRect(x: 0,y: 0,width: WIDTH,height: 30))
        let image = UIButton(frame: CGRect(x: 10, y: 5, width: 20, height: 20))
        image.setImage(UIImage(named: picArr[section]), for: UIControlState())
        
        let titleLabel = UILabel(frame: CGRect(x: 35,y: 5,width: WIDTH - 45,height: 20))
        titleLabel.text = dataSource.objectlist[section].name
        
        backview.addSubview(image)
        backview.addSubview(titleLabel)
        return backview
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0000000001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onlineCell", for: indexPath)as!OnlineTextTableViewCell
        var everyDayInfo:EveryDayInfo
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            everyDayInfo = self.dataSource.objectlist[indexPath.section]
            cell.titleImg.setImage(UIImage(named: picArr[indexPath.section]), for: UIControlState())
        }else {
            everyDayInfo = self.dataSource.objectlist[indexPath.section].childlist[indexPath.row]
            cell.titleImg.setImage(nil, for: UIControlState())
        }
        cell.selectionStyle = .none
        cell.titleLable.text = everyDayInfo.name
        cell.titleLable.sizeToFit()
        cell.titleLable.center.y = cell.titleImg.center.y
        cell.startBtn.isUserInteractionEnabled = false
        let line = UILabel(frame: CGRect(x: 55, y: 59.5, width: WIDTH-55, height: 0.5))
//        line.backgroundColor = UIColor.grayColor()
        line.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        cell.addSubview(line)
//        if 5 == indexPath.row{
//            line.removeFromSuperview()
//        }
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            if indexPath.section == self.dataSource.objectlist.count - 1 {
                line.removeFromSuperview()
                let lastLine = UILabel(frame: CGRect(x: 0, y: 59.5, width: WIDTH, height: 0.5))
                lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }else{
            if indexPath.row == self.dataSource.objectlist[indexPath.section].childlist.count - 1 {
                line.removeFromSuperview()
                 let lastLine = UILabel(frame: CGRect(x: 0, y: 59.5, width: WIDTH, height: 0.5))
                 lastLine.backgroundColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
                cell.addSubview(lastLine)
            }
        }
        if type == 1 {
            cell.startBtn.setTitle("开始练习", for: UIControlState())
        }else{
            cell.startBtn.setTitle("开始考试", for: UIControlState())
        }
        cell.numLable.text = everyDayInfo.count
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // MARK:要求登录
        if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
            return
        }
        
        var everyDayInfo:EveryDayInfo
        if dataSource.objectlist[indexPath.section].haschild == 0 {
            everyDayInfo = dataSource.objectlist[indexPath.section]
        }else {
            everyDayInfo = dataSource.objectlist[indexPath.section].childlist[indexPath.row]
        }

        if type == 1 {
            let nextVC = WordViewController()
            nextVC.title = "每日一练·\(everyDayInfo.name)"
            nextVC.questionCount = everyDayInfo.count
            nextVC.type = everyDayInfo.term_id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }else{
            let nextVC = GOnlineViewController()
            nextVC.title = "在线考试·\(everyDayInfo.name)"
            nextVC.questionCount = everyDayInfo.count
            nextVC.exam_time = Int(everyDayInfo.exam_time)!
            nextVC.type = everyDayInfo.term_id
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    

}
