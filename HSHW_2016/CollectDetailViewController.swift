//
//  CollectDetailViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class CollectDetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    

    let myTableView = UITableView()
    
    var helper = HSMineHelper()
    private var collectListArray:Array<NewsInfo> = []
    
    override func viewDidLoad() {
        self.title = "其他收藏"
        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.registerClass(MineExamCollectTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.rowHeight = 70
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        self.getData()

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MineExamCollectTableViewCell
        cell.selectionStyle = .None
        
        cell.fanModel = collectListArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let next = NewsContantViewController()
        next.newsInfo = collectListArray[indexPath.row]
        navigationController!.pushViewController(next, animated: true)
    }
    
    func getData() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.labelText = "正在获取其他收藏"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        let userid = QCLoginUserInfo.currentInfo.userid
        helper.GetCollectList(userid, type: "3") { (success, response) in
            
            if success {
                self.collectListArray = response as! Array<NewsInfo>
                self.myTableView.reloadData()
            }else{
                if String(response!) == "no data" {
                    self.collectListArray = response as! Array<NewsInfo>
                    self.myTableView.reloadData()
                }
            }
            
            hud.hide(true, afterDelay: 1)
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
