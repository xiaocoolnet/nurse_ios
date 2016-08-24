//
//  RankViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class RankViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    let myTableView = UITableView()
    var scoreArray = Array<RankModel>()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.title = "积分排行榜"
        self.view.backgroundColor = COLOR
        
//        scoreArray = [["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"],["imageName":"img_head_nor","name":"陈小杰","score":"+2589","time":"2016-07-06"]]
        
        let cupImage = UIImageView(frame: CGRectMake(0, 0, WIDTH, WIDTH*476/750))
        cupImage.image = UIImage(named: "cup")
        self.view.addSubview(cupImage)
        
        myTableView.frame = CGRectMake(20/750.0*WIDTH, 188/1380.0*HEIGHT, 71/75.0*WIDTH, 778/1380.0*HEIGHT)
        myTableView.registerClass(RankTableViewCell.self, forCellReuseIdentifier: "scoreCell")
        myTableView.rowHeight = 110/1380.0*HEIGHT
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.layer.cornerRadius = 3
        myTableView.dataSource = self
        myTableView.delegate = self
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
        
        loadData()
    }
    
    // MARK:- 获取数据
    func loadData() {
        HSMineHelper().getRankingList { (success, response) in
            if success {
                self.scoreArray = response as! Array<RankModel>
                self.myTableView.reloadData()
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                hud.mode = MBProgressHUDMode.Text
                hud.labelText = response as! String
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
        }
    }
    
    // MARK:- TableView datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! RankTableViewCell
        
        cell.selectionStyle = .None
        
        switch indexPath.row {
        case 0:
            cell.indexBtn.setImage(UIImage(named: "rank_1"), forState: .Normal)
        case 1:
            cell.indexBtn.setImage(UIImage(named: "rank_2"), forState: .Normal)
        case 2:
            cell.indexBtn.setImage(UIImage(named: "rank_3"), forState: .Normal)
            
        default:
            cell.indexBtn.setImage(nil, forState: .Normal)
            cell.indexBtn.setTitle(String(indexPath.row+1), forState: .Normal)
        }
        cell.scoreImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+scoreArray[indexPath.row].photo), placeholderImage: UIImage.init(named: "img_head_nor"))
        cell.nameLab.text = scoreArray[indexPath.row].name
        cell.scoreLab.text = scoreArray[indexPath.row].score
        cell.timeLab.text = scoreArray[indexPath.row].time
        
        return cell
    }
    
    // TableView delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let scoreVC = ScoreViewController()
//        self.navigationController?.pushViewController(scoreVC, animated: true)
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