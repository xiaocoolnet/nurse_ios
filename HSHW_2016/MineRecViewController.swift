//
//  MineRecViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class MineRecViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myTableView = UITableView()
    
    let employmentMessage = UIView()
    var dataSource = MineJobList()
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(MineJobTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.getDate()

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 165
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineJobTableViewCell
        cell.selectionStyle = .None
        let model = self.dataSource.objectlist[indexPath.row]
        cell.showforJobModel(model)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.dataSource.objectlist[indexPath.row]
        let vc = MineRecDetailsViewController()
        vc.currentJobModel = model
        vc.tit = model.title
        vc.companyDescription = model.companyinfo
        vc.name = model.companyname
        vc.criteriaLabel = model.education
        vc.criteriLabel = model.count
        vc.addressLabel = model.address
        vc.addresLabel = model.welfare
        vc.descripDetail = model.description
        vc.strId = model.id
        vc.phone = model.phone
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getDate(){
            let url = PARK_URL_Header+"getMyPublishJobList"
            let param = ["userid":QCLoginUserInfo.currentInfo.userid]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = MineJobModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        //hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        // print(status)
                        self.dataSource = MineJobList(status.data!)
                        self.myTableView .reloadData()
                        // print(status.data)
                    }
                }
                
            }

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
