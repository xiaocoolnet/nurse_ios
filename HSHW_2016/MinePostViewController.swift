//
//  MinePostViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MinePostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    
    var helper = HSNurseStationHelper()
    var typeid = "1"
    var userid = QCLoginUserInfo.currentInfo.userid
    var dataSource = Array<PostModel>()
    var hotData = Array<PostModel>()
    var postM:Array<ForumModel>?
    
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
        myTableView.registerClass(MinePostTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 72
        
        helper.getList(userid,type: typeid,isHot:  false) {[unowned self] (success, response) in
            self.dataSource = response as? Array<PostModel> ?? []
            dispatch_async(dispatch_get_main_queue(), {
                self.myTableView.reloadData()
            })
        }
//        helper.getForumList(typeid, isHot: false) { (success, response) in
//            self.hotData = response as? Array<PostModel> ?? []
//            print(response?.firstObject)
//            print(self.hotData.count)
//            print(self.hotData.first?.title)
//            dispatch_async(dispatch_get_main_queue(), {
//                self.myTableView.reloadData()
//            })
//        }

        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
//        return self.hotData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!MinePostTableViewCell
        cell.selectionStyle = .None
        let model = self.dataSource[indexPath.row]
        cell.title.text = model.title
//        cell.title.text = "真是醉了，上班时间谈人生"
//        cell.timeLab.text = "2016/05/23"
        cell.zanNum.text = String(model.like.count)
        // TODO:阅读量暂无
        cell.conLab.text = String(model.comment.count)
        
        cell.timeLab.text = timeStampToString(model.write_time)
        
        
        return cell
//        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)

        helper.showPostInfo(self.dataSource[indexPath.row].mid) { (success, response) in
            let data = (response as? PostModel ?? nil)!
            let vc = HSPostDetailViewController(nibName: "HSPostDetailViewController",bundle: nil)
            vc.postInfo = data
            self.navigationController?.pushViewController(vc, animated: true)
            
//            print(response)
        }

    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
//        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }

}
