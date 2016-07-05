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
    var dataSource = titList()
    let picArr:[String] = ["ic_rn.png","ic_earth.png","ic_moon.png","ic_maozi_one.png","ic_maozi_two.png","ic_maozi_three.png"]
    
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 10))
        
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
            "userid":uid
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
                    
                    //                    self.createTableView()
                    print(status)
                    self.dataSource = titList(status.data!)
                    
                    print(self.dataSource)
                    print("-----")
                    print(titleList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.objectlist.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("onlineCell", forIndexPath: indexPath)as!OnlineTextTableViewCell
        let info = self.dataSource.objectlist[indexPath.row]
        cell.selectionStyle = .None
        cell.titleLable.text = info.name
        cell.titleImg.setImage(UIImage(named: picArr[indexPath.row]), forState: .Normal)
        cell.startBtn.addTarget(self, action: #selector(self.startText), forControlEvents: .TouchUpInside)
        let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
        line.backgroundColor = UIColor.grayColor()
        cell.addSubview(line)
        if 5 == indexPath.row{
            line.removeFromSuperview()
        }
        cell.numLable.text = info.count
        return cell
    }
    
    func startText(){
        let nextVC = OnlineExaminationViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
       
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
