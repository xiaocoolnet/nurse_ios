//
//  MineExaminationViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineExaminationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let myTableView = UITableView()
    var helper = HSMineHelper()
    private var collectListArray:Array<CollectList> = []
    

    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "收藏试题"
        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.registerClass(MineExamCollectTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.rowHeight = 70
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
     
        self.getData()
        

        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectListArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MineExamCollectTableViewCell
        cell.selectionStyle = .None
        
        cell.fansModel = collectListArray[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(11111)
//        let vc = CollectDetailViewController()
//        vc.collect = self.collectListArray
        
    }
    
    
    func getData() {
        helper.GetCollectList(QCLoginUserInfo.currentInfo.userid, type: "2") { (success, response) in
            self.collectListArray = response as! Array<CollectList>
            self.myTableView.reloadData()
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
