//
//  GNewsCateViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/7/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class GNewsCateViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var type = 0
    var id = ""
    var name = ""
    
    let helper = NewsPageHelper()
        
    var myTableView = UITableView()
    var dataSource = Array<GNewsCate>()
    
    internal var newsId = String()
    internal var post_title=String()
    internal var post_modified=String()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem()
        back.title = "返回";
        self.navigationItem.backBarButtonItem = back;
        
        self.title = name
        
        self.createTableView()
        self.GetDate()
        // Do any additional setup after loading the view.
    }
    
    func createTableView() {
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-49-64)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(GCateTableViewCell.self, forCellReuseIdentifier: "toutiao")
        self.view.addSubview(myTableView)
        
        myTableView.rowHeight = 50
    }
    
    func GetDate(){
        
        helper.GGetCateList(type, id: id) { (success, response) in
            if success{
                self.dataSource = response as! Array<GNewsCate>
                self.myTableView.reloadData()
            }
        }
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("toutiao", forIndexPath: indexPath)as!GCateTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.dataSource[indexPath.row]
//        cell.setCellWithNewsInfo(newsInfo)
        cell.textLabel?.text = newsInfo.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let newsInfo = self.dataSource[indexPath.row]
        let next = GNewsCateDetailViewController()
        next.type = 2
        next.id = newsInfo.term_id!
        next.name = newsInfo.name!

        self.navigationController?.pushViewController(next, animated: true)
    }
}
