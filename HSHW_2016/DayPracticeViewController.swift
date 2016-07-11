//
//  DayPracticeViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/8.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class DayPracticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myTableView = UITableView()
    var dataSource = titleList()
    var childDataSource = ChildList()
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
        
        // Do any additional setup after loading the view.
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
                    self.dataSource = titleList(status.data!)
                    
                    print(self.dataSource)
                    print("-----")
                    print(titleList(status.data!).objectlist)
                    self.childDataSource = ChildList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
        }
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.dataSource.objectlist.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
                   return self.dataSource.objectlist.count
    
    }
    

    
//    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 30
//    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let nameLable = UILabel()
//        nameLable.backgroundColor = UIColor.grayColor()
//        nameLable.text = "练习"
//        return nameLable
//        
//    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!EveryDayTableViewCell
        let info = self.dataSource.objectlist[indexPath.section]
        if info.haschild == 1 {
            let child = self.childDataSource.objectlist[indexPath.row]
            cell.titLab.text = child.name
            cell.titImage.setImage(UIImage(named: picArr[indexPath.row]), forState: .Normal)
        }else{
        cell.selectionStyle = .None
        cell.titLab.text = info.name
        cell.titImage.setImage(UIImage(named: picArr[indexPath.row]), forState: .Normal)
//        cell.start.addTarget(self, action: #selector(self.startTheTest), forControlEvents: .TouchUpInside)
//        cell.start.tag = indexPath.row
        }
        
        let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
        line.backgroundColor = UIColor.grayColor()
        cell.addSubview(line)
    
        
        return cell
        
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
