//
//  MineMessDetailViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/23.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineMessDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    let myTableView = UITableView()
    var info = MessageInfo?()
    
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
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        myTableView.bounces = false
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        
        self.title = info?.title
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let height = calculateHeight(info?.content ?? "", size: 17, width: WIDTH-20)
        return height+40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        cell.textLabel?.text = info?.content
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.sizeToFit()
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
