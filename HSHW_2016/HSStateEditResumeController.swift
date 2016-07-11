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

//typealias dateBlock = (str:String)->()

class HSStateEditResumeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private static let _shareInstance = HSStateEditResumeController()
    class func getShareInstance()-> HSStateEditResumeController{
        return _shareInstance;
    }
    var block:dateBlock?
    
    var myTableView = UITableView()
    var dateSource = EduList()
    
    

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
        
        self.dataGet()
        
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
        print(1111)
        let eduInfo = self.dateSource.objectlist[indexPath.row]
        QCLoginUserInfo.currentInfo.education = eduInfo.name
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func dataGet(){
        
        let url = PARK_URL_Header+"getDictionaryList"
        let param = ["type":"1"]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status)
                    self.dateSource = EduList(status.data!)
                
                    self.myTableView .reloadData()
                }
            }
            
        }

    }


}
