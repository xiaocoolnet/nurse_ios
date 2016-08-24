//
//  ScoreViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class ScoreViewController: UIViewController,UITableViewDataSource {

    var scoreArray = [[String:String]]()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "个人积分"
        self.view.backgroundColor = COLOR
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "score"), style: .Done, target: self, action: #selector(rankBtnClick))
                
        scoreArray = [["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"],["name":"积分名称","score":"+2589","time":"2016-07-06"]]
        
        let cupImage = UIImageView(frame: CGRectMake(0, 0, WIDTH, WIDTH*476/750))
        cupImage.image = UIImage(named: "cup")
        self.view.addSubview(cupImage)
        
        let myTableView = UITableView(frame: CGRectMake(20/750.0*WIDTH, 188/1380.0*HEIGHT, 71/75.0*WIDTH, 778/1380.0*HEIGHT), style: .Plain)
        myTableView.registerClass(ScoreTableViewCell.self, forCellReuseIdentifier: "scoreCell")
        myTableView.rowHeight = 110/1380.0*HEIGHT
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.cornerRadius = 3
        myTableView.dataSource = self
        self.view.addSubview(myTableView)
        
        let noteLab = UILabel(frame: CGRectMake(20/750.0*WIDTH, CGRectGetMaxY(myTableView.frame), 71/75.0*WIDTH, 158/1380.0*HEIGHT))
        noteLab.numberOfLines = 0
        noteLab.font = UIFont.systemFontOfSize(12)
        noteLab.textColor = UIColor.whiteColor()
        noteLab.text = "  排行榜是一个对进行综合评比和展示的栏目。以日为单位，主要依据会员买卖通指数、登录次数、受关注程度、信息丰富程度等来进行评比。"
        noteLab.layer.cornerRadius = 3
        self.view.addSubview(noteLab)
        
        let shareBtn = UIButton(frame: CGRectMake(20/750.0*WIDTH, CGRectGetMaxY(noteLab.frame), 71/75.0*WIDTH, 84/1380.0*HEIGHT))
        shareBtn.backgroundColor = UIColor(red: 254/255.0, green: 232/255.0, blue: 90/255.0, alpha: 1)
        shareBtn.setTitle("邀请朋友赚积分", forState: .Normal)
        shareBtn.setTitleColor(UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1), forState: .Normal)
        shareBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        shareBtn.layer.cornerRadius = 3
        shareBtn.addTarget(self, action: #selector(shareBtnClick), forControlEvents: .TouchUpInside)
        self.view.addSubview(shareBtn)
        
        print(myTableView.frame,noteLab.frame,shareBtn.frame)
    }
    
    // MARK:- TableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! ScoreTableViewCell
        cell.selectionStyle = .None
        
        cell.nameLab.text = scoreArray[indexPath.row]["name"]
        cell.scoreLab.text = scoreArray[indexPath.row]["score"]
        cell.timeLab.text = scoreArray[indexPath.row]["time"]
        
        return cell
    }
    
    //  MARK:- 邀请朋友赚积分
    func shareBtnClick() {
        print("点击 邀请朋友赚积分 按钮")
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "敬请期待"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        hud.hide(true, afterDelay: 1)

//        let downLoadVC = DownLoadViewController()
//        self.navigationController?.pushViewController(downLoadVC, animated: true)
    }
    
    // MARK:- 点击排行榜按钮
    func rankBtnClick() {
        let rankVC = RankViewController()
        self.navigationController?.pushViewController(rankVC, animated: true)
        
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
