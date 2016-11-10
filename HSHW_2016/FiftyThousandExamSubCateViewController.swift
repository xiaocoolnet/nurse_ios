//
//  FiftyThousandExamSubCateViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class FiftyThousandExamSubCateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var term_id = ""
    
    var term_name = ""
    
    let rootTableView = UITableView()
    
    var data = Array<GNewsCate>()

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("学习 8万题库 "+(self.term_name ?? "")!+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("学习 8万题库 "+(self.term_name ?? "")!+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
        self.loadData()
    }
    
    // MARK: 加载数据
    func loadData() {
        NewsPageHelper().getChannellist(self.term_id) { (success, response) in
            if success {
                self.data = response as! [GNewsCate]
                
                self.rootTableView.mj_header.endRefreshing()
                self.rootTableView.reloadData()
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = .Text
                hud.margin = 10
                hud.labelText = "网络错误，请稍后再试"
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
        }
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        print(self.term_id)
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        
        rootTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64-1)
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.tableFooterView = UIView(frame: CGRectZero)
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.view.addSubview(rootTableView)
        
        rootTableView.mj_header.beginRefreshing()
    }
    
    // MARK:- UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("fiftyThousandExamSubCateCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: "fiftyThousandExamSubCateCell")
            cell?.accessoryType = .DisclosureIndicator
            cell?.selectionStyle = .None
        }
        
        cell?.textLabel?.font = UIFont.systemFontOfSize(18)
        cell?.textLabel?.text = self.data[indexPath.row].name
        
        return cell!
    }
    
    // MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let twoView = QuestionBankViewController()
        twoView.hasMenuHeight = false
        twoView.title = self.data[indexPath.row].name
        twoView.term_id = (self.data[indexPath.row].term_id ?? "")!
        
        self.navigationController?.pushViewController(twoView, animated: true)
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
