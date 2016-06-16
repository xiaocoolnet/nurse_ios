//
//  SetDataViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit


class SetDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    let oneArr:[String] = ["头像","用户名","性别","手机","邮箱"]
    let onedeArr:[String] = ["","Alanhky","女","13239847823","fangeeqoswqi@163.com"]
    
    let twoArr:[String] = ["姓名","出生日期","地址"]
    let twodeArr:[String] = ["杨艳萍","1991-02-24","北京市－大兴区"]
    
    let threeArr:[String] = ["学校","专业","学历"]
    let threedeArr:[String] = ["北京应用技术大学","软件工程","大专"]
 
    
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
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView()
        one.backgroundColor = UIColor.clearColor()
        return one
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 72
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 3
        }else{
            return 3
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        if indexPath.section == 0 {
            cell.textLabel?.text = oneArr[indexPath.row]
            cell.detailTextLabel?.text = onedeArr[indexPath.row]
            if indexPath.row == 0 {
                let titImage = UIImageView(frame: CGRectMake(WIDTH-86, 11, 50, 50))
                titImage.layer.cornerRadius = 25
                titImage.clipsToBounds = true
                titImage.image = UIImage(named: "6.png")
                cell.addSubview(titImage)
            }
        }else if indexPath.section == 1 {
            cell.textLabel?.text = twoArr[indexPath.row]
            cell.detailTextLabel?.text = twodeArr[indexPath.row]
        }else{
            cell.textLabel?.text = threeArr[indexPath.row]
            cell.detailTextLabel?.text = threedeArr[indexPath.row]
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //  进行修改的操作
        print(indexPath.row)
        //  先进行页面的跳转
        //
        let changeNameVC = ChangeName()
        self.navigationController?.pushViewController(changeNameVC, animated: true)
        
        
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
