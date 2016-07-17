//
//  ChildsViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ChildsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, HSFindPersonDetailViewDelegate {
    
    let myTableView = UITableView()
    let nameArr:[String] = ["“张鑫仁”","“柳行”","“折木秀一郎”","“swift”"]
    
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    var CVDataSource:Array<CVModel>?
    let jobHelper = HSNurseStationHelper()
    var dataSource = ChildList()
    
    
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
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(MineRecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 72
        
//        jobHelper.getList({[unowned self] (success, response) in
//           
//                if !success {
//                    return
//                }
//                self.CVDataSource = response as! Array<CVModel>
//             dispatch_async(dispatch_get_main_queue(), {
//                self.myTableView.reloadData()
//                //                    self.configureUI()
//            })
//        })

    self.GetDate()
    
        // Do any additional setup after loading the view.
    }
    
    func sendInvite(){
        resumeDetail.removeFromSuperview()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CVDataSource?.count ?? 0
        return self.dataSource.objectlist.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineRecruitTableViewCell
        cell.selectionStyle = .None
        
        let model = self.dataSource.objectlist[indexPath.row]
        
        cell.showforCVModel(model)
//        cell.timeLab.text = "15分钟前"
//        cell.job.text = model.birthday
//        cell.nameTit.text = model.userid
//        cell.one.text = "申请面试"
//        cell.two.text = "的面试"

        return cell
        
    }
    
    
    func GetDate(){
        let url = PARK_URL_Header+"getMyReciveResumeList"
        let param = ["userid":"1"]
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = ChildModel(JSONDecoder(json!))
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
                    self.dataSource = ChildList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }

    

    func makeCVMessage(){
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)
        self.view.addSubview(resumeDetail)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        self.makeCVMessage()
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
