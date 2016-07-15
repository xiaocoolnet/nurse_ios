//
//  HSUserPageViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSUserPageViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    var userTableView = UITableView()
    
    var helper = HSNurseStationHelper()
    var dataSource = Array<PostModel>()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        helper.getForumList("1",isHot:  false) {[unowned self] (success, response) in
            self.dataSource = response as? Array<PostModel> ?? []
            dispatch_async(dispatch_get_main_queue(), {
                self.userTableView.reloadData()
            })
        }
        
        setSubviews()
        
    }
    
    func setSubviews() {
        userTableView = UITableView.init(frame: CGRectMake(0, 0, WIDTH, HEIGHT-64), style: .Grouped)
        userTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        userTableView.rowHeight = UITableViewAutomaticDimension
        userTableView.delegate = self
        userTableView.dataSource = self
        userTableView.tableHeaderView = setTableHeaderView()
        self.view.addSubview(userTableView)
    }
    
    func setTableHeaderView() -> UIImageView {
        
        let bgImageView = UIImageView.init(frame: CGRectMake(0, 0, WIDTH, WIDTH*0.9))
        bgImageView.backgroundColor = UIColor.purpleColor()
        bgImageView.userInteractionEnabled = true
        
        let headerView = UIImageView.init(frame: CGRectMake(WIDTH/3.0, 30, WIDTH/3.0, WIDTH/3.0))
        headerView.layer.cornerRadius = WIDTH/6.0
        headerView.backgroundColor = UIColor.cyanColor()
        bgImageView.addSubview(headerView)
        
        let nameLabel = UILabel.init(frame: CGRectMake(self.view.center.x, CGRectGetMaxY(headerView.frame)+30, 100, 30))
        nameLabel.textColor = UIColor.whiteColor()
        nameLabel.text = "苏丽珍"
        nameLabel.sizeToFit()
        bgImageView.addSubview(nameLabel)
        
        let leavel = UIButton.init(frame: CGRectMake(CGRectGetMaxX(nameLabel.frame), CGRectGetMinY(nameLabel.frame), 18, 20))
        leavel.setBackgroundImage(UIImage.init(named: "ic_shield_purple.png"), forState: .Normal)
        leavel.titleLabel?.font = UIFont.systemFontOfSize(9)
        leavel.setTitleColor(UIColor.init(red: 250/255.0, green: 235/255.0, blue: 60/255.0, alpha: 1), forState: .Normal)
        leavel.setTitle("25", forState: .Normal)
        bgImageView.addSubview(leavel)
        
        let noteLab = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(leavel.frame)+20, WIDTH, 50))
        noteLab.numberOfLines = 0
        noteLab.textAlignment = NSTextAlignment.Center
        noteLab.textColor = UIColor.init(red: 248/255.0, green: 122/255.0, blue: 215/255.0, alpha: 1)
        noteLab.text = "性别：女    科室：外科\n医院：北京大学第二附属医院"
        bgImageView.addSubview(noteLab)
        
        let focusBtn = UIButton.init(frame: CGRectMake(WIDTH/4.0, CGRectGetMaxY(noteLab.frame)+20, WIDTH/2.0, 50))
        focusBtn.layer.borderWidth = 1
        focusBtn.layer.borderColor = UIColor.whiteColor().CGColor
        focusBtn.layer.cornerRadius = 25
        focusBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        focusBtn.setTitle("关注Ta", forState: .Normal)
        bgImageView.addSubview(focusBtn)
        
        bgImageView.frame = CGRectMake(0, 0, WIDTH, CGRectGetMaxY(focusBtn.frame)+20)
        
        return bgImageView
    }
    
    // MARK: tableView 代理方法
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSComTableCell

        cell.showForForumModel(dataSource[indexPath.row])
        cell.selectionStyle = .None
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRectMake(0, 0, WIDTH, 40))
        bgView.backgroundColor = UIColor.whiteColor()
        
        let label = UILabel.init(frame: CGRectMake(20, 10, WIDTH-40, 28))
        label.textColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        label.text = "他的帖子"
        bgView.addSubview(label)
        
        let lineView = UIView.init(frame: CGRectMake(20, CGRectGetMaxY(label.frame), CGRectGetWidth(label.frame), 2))
        lineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        bgView.addSubview(lineView)
        
        return bgView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
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
