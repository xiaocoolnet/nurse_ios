//
//  MineExaminationViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineExaminationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var helper = HSMineHelper()
    var dailyBtn = UIButton()
    var examBtn = UIButton()
    
//    let myScrollView = UIScrollView()
    let fansTableView = UITableView()
    let focusTableView = UITableView()
    var navigationBarLineView = UIView()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData_Exampaper()
        

        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        // 每日一练列表
        fansTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-115)
        fansTableView.backgroundColor = UIColor.clearColor()
        fansTableView.registerClass(GMyErrorTableViewCell.self, forCellReuseIdentifier: "cell")
        fansTableView.rowHeight = 70
        fansTableView.tag = 410
        fansTableView.delegate = self
        fansTableView.dataSource = self
        self.view.addSubview(fansTableView)
        

        // Do any additional setup after loading the view.
    }
    

    private var fansListArray:Array<xamInfo> = []
    
    // 加载数据_做题记录
    func loadData_Exampaper() {
        
        helper.getCollectionInfoWith("2") { (success, response) in
            self.fansListArray = response as! Array<xamInfo>
            self.fansTableView.reloadData()
        }
        
    }
    
    // MARK: tableView 代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return fansListArray.count

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GMyErrorTableViewCell
        cell.selectionStyle = .None
        cell.inde = indexPath.row
        
//        if tableView.tag == 410 {
            let model = fansListArray[indexPath.row]
            //            model.post_title = "每日一练"
            cell.fanModel = model
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let userPageVC = GMyExamViewController()
        userPageVC.type = 1
        userPageVC.subType = 1
        print(fansListArray[indexPath.row])
        userPageVC.a = indexPath.row
        userPageVC.dataSource = fansListArray
        
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
}