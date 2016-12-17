//
//  HSStateEditResumeController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

//接口类型
enum PortType{
    case position,condition,welfare,number,money,defaut
}

//定义协议改变Label内容
protocol ChangeWordDelegate:NSObjectProtocol{
    //回调方法
    func changeWord(_ controller:HSStateEditResumeController,string:String)
}

class HSStateEditResumeController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    fileprivate static let _shareInstance = HSStateEditResumeController()
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
        
        myTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-108)
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.bounces = false
        self.view.addSubview(myTableView)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.objectlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let eduInfo  = self.dateSource.objectlist[indexPath.row]
        cell.textLabel?.text = eduInfo.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(1111)
        let eduInfo = self.dateSource.objectlist[indexPath.row]
        QCLoginUserInfo.currentInfo.education = eduInfo.name
        delegate?.changeWord(self, string: eduInfo.name)
        self.navigationController?.popViewController(animated: true)
        // print(eduInfo.name)
    }
    
    func dataGet(_ portType:PortType){
        
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
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1)
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
