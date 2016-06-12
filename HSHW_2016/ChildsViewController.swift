//
//  ChildsViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class ChildsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    let nameArr:[String] = ["“张鑫仁”","“柳行”","“折木秀一郎”","“swift”"]
    
    
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
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MineRecruitTableViewCell
        cell.selectionStyle = .None
        cell.timeLab.text = "15分钟前"
//        let name = nameArr[indexPath.row]
//        let titSize = CGSize()
        let nameTit = UILabel()
        
        nameTit.frame = CGRectMake(15, 15, 50, 20)
        nameTit.text = nameArr[indexPath.row]
        nameTit.font = UIFont.systemFontOfSize(14)
        nameTit.textColor = COLOR
        nameTit.sizeToFit()
        let one = UILabel(frame: CGRectMake(15+nameTit.bounds.size.width, 15, 59, 20))
        one.text = "申请面试"
        one.font = UIFont.systemFontOfSize(14)
        one.textColor = UIColor.grayColor()
        one.sizeToFit()
        let job = UILabel(frame: CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width, 15, 50, 20))
        job.textColor = COLOR
        job.text = "[高薪诚聘主管护士]"
        job.font = UIFont.systemFontOfSize(14)
        job.sizeToFit()
        let two = UILabel(frame: CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width+job.bounds.size.width, 15, 50, 20))
        two.textColor = UIColor.grayColor()
        two.text = "的职位"
        two.font = UIFont.systemFontOfSize(14)
        two.sizeToFit()
    
        cell.addSubview(nameTit)
        cell.addSubview(one)
        cell.addSubview(job)
        cell.addSubview(two)
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
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
