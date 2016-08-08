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
    
    var type = 2 // 1 个人 2 企业
    
    let myTableView = UITableView()
    let resumeDetail = NSBundle.mainBundle().loadNibNamed("HSFindPersonDetailView", owner: nil, options: nil).first as! HSFindPersonDetailView
    var CVDataSource:Array<CVModel>?
    let jobHelper = HSNurseStationHelper()
    var dataSource = Array<CVModel>()
    var myInvitedList = InvitedList()
    
    weak var superViewController:MineRecruitViewController?
    
    var str = NSString()
    
    var name = NSString()
    var sex = NSString()
    var avatar = NSString()
    var birthday = NSString()
    var address = NSString()
    var education = NSString()
    var certificate = NSString()
    var currentsalary = NSString()
    var count = NSString()
    var descrip = NSString()
    var linkman = NSString()
    var phone = NSString()
    var experience = NSString()
    var wantposition = NSString()
    var tit = NSString()
    var jobstate = NSString()
    var wantsalary = NSString()
    var ema = NSString()
    var hiredate = NSString()
    var wantcity = NSString()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resumeDetail.delegate = self
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        resumeDetail.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(MineRecruitTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 72
        
        self.GetDate()
    
        // Do any additional setup after loading the view.
    }
    
    func sendInvite(model:CVModel){
        inviteJob(model)
    }
    
    func inviteJob(model:CVModel) {
        print("邀请面试")

        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("你确定要向 \(model.name) 发送邀请吗？", comment: "empty message"), preferredStyle: .Alert)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: { (cancelAction) in
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "正在发送邀请"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            let url = PARK_URL_Header+"InviteJob"
            let param = [
                "userid":model.userid,
                "jobid":model.id,
                "companyid":QCLoginUserInfo.currentInfo.userid
            ]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                print(request)
                if(error != nil){
                    
                }else{
                    let result = Http(JSONDecoder(json!))
                    if(result.status == "success"){
                        //  菊花加载
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "发送邀请成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(111111)
                    }else{
                        //  菊花加载
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "发送邀请失败"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(2222222)
                    }
                }
            }
            
        })
        alertController.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler: { (cancelAction) in
            return
        })
        alertController.addAction(cancelAction)
    }
    
    func hiddenResumeDetail() {
        resumeDetail.removeFromSuperview()
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return CVDataSource?.count ?? 0
        if type == 1 {
            print(self.myInvitedList.data.count)
            return self.myInvitedList.data.count
        }else{
            return self.dataSource.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineRecruitTableViewCell
        cell.selectionStyle = .None
        
        
        if type == 1 {
            cell.showforUserModel(self.myInvitedList.data[indexPath.row])
        }else{
            let model = self.dataSource[indexPath.row]
            cell.showforCVModel(model)
        }
//        cell.timeLab.text = "15分钟前"
//        cell.job.text = model.birthday
//        cell.nameTit.text = model.userid
//        cell.one.text = "申请面试"
//        cell.two.text = "的面试"

        return cell
        
    }
    
    
    func GetDate(){
        
        if type == 1 {
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.labelText = "正在获取面试邀请"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            let url = PARK_URL_Header+"UserGetInvite"
            // TODO: userid 待更新
            let param = ["userid":"607"]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = InvitedModel(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = status.errorData
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        print(status)
                        self.myInvitedList = InvitedList(status.data!)
                        self.myTableView.reloadData()
                        print(status.data)
                        hud.hide(true, afterDelay: 1)
                    }
                }
                
            }
        }else{
            
            let url = PARK_URL_Header+"getMyReciveResumeList"
            // TODO: userid 待更新
            let param = ["userid":"1"]
            Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
                if(error != nil){
                    
                }else{
                    let status = HSCVListModel(JSONDecoder(json!))
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
                        self.dataSource = status.datas
                        self.myTableView .reloadData()
                        print(status.datas)
                    }
                }
                
            }
        }
    }

    func makeCVMessage(){
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-154.5)

//        resumeDetail.showFor(birthday)
//        resumeDetail.showSex(sex)
//        resumeDetail.showName(name)
//        resumeDetail.education(education)
//        resumeDetail.address(address)
//        resumeDetail.experience(experience)
//        resumeDetail.jobName(tit)
//        resumeDetail.comeTime(hiredate)
//        resumeDetail.expectSalary(wantsalary)
//        resumeDetail.targetLocation(wantcity)
//        resumeDetail.targetPosition(wantposition)
//        resumeDetail.selfEvaluation(descrip)
//        resumeDetail.phoneNumber(phone)
//        resumeDetail.email(ema)
//        resumeDetail.currentSalary(currentsalary)
//        resumeDetail.jobState(jobstate)
        self.view.addSubview(resumeDetail)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let model = self.dataSource[indexPath.row]
        self.name = model.name
        self.sex = model.sex
        self.avatar = model.avatar
        self.birthday = model.birthday
        self.address = model.address
        self.education = model.education
        self.certificate = model.certificate
        self.currentsalary = model.currentsalary
        self.count = model.count
        self.descrip = model.description
        self.linkman = model.linkman
        self.phone = model.phone
        self.experience = model.experience
        self.wantposition = model.wantposition
        self.tit = model.title
        self.jobstate = model.jobstate
        self.ema = model.email
        self.hiredate = model.hiredate
        self.wantcity = model.wantcity
        self.wantsalary = model.wantsalary
        superViewController?.showRightBtn()
        
//        self.makeCVMessage()
        resumeDetail.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-107.5)
        resumeDetail.delegate = self
        resumeDetail.model = model
        self.view.addSubview(resumeDetail)
    }
    
    func rightBarButtonClicked(){
    
//        findPersonnel.rightBarButtonClicked()
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
