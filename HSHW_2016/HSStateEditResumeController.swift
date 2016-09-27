//
//  HSStateEditResumeController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

//接口类型
enum PortType{
    case position,condition,welfare,number,money,defaut
}

//定义协议改变Label内容
protocol ChangeWordDelegate:NSObjectProtocol{
    //回调方法
    func changeWord(controller:HSStateEditResumeController,string:String)
}

class HSStateEditResumeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private static let _shareInstance = HSStateEditResumeController()
    class func getShareInstance()-> HSStateEditResumeController{
        return _shareInstance;
    }
    var block:dateBlock?
    
    var myTableView = UITableView()
    var dateSource = EduList()
    var delegate: ChangeWordDelegate?
    
    var portType: PortType = .defaut{
        didSet{
            dataGet(portType)
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR
        // Do any additional setup after loading the view.
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-108)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.bounces = false
        self.view.addSubview(myTableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.objectlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        
        let eduInfo  = self.dateSource.objectlist[indexPath.row]
        cell.textLabel?.text = eduInfo.name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // print(1111)
        let eduInfo = self.dateSource.objectlist[indexPath.row]
        QCLoginUserInfo.currentInfo.education = eduInfo.name
        delegate?.changeWord(self, string: eduInfo.name)
        self.navigationController?.popViewControllerAnimated(true)
        // print(eduInfo.name)
    }
    
    func dataGet(portType:PortType){
        
        let url = PARK_URL_Header+"getDictionaryList"
        var param = ["type":"1"]
        
        switch portType {
            case .position:
                param = ["type":"7"]
                self.title = "招聘职位"
            case .condition:
                param = ["type":"8"]
                self.title = "招聘条件"
            case .welfare:
                param = ["type":"9"]
                self.title = "福利待遇"
            case .number:
                param = ["type":"10"]
                self.title = "招聘人数"
            case .money:
                param = ["type":"11"]
                self.title = "薪资待遇"
            default:
                 print("HSStateEditResumeController dataGet defaut")
        }
        // print(param)
        
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dateSource = EduList(status.data!)
                
                    self.myTableView .reloadData()
                }
            }
            
        }

    }


}
