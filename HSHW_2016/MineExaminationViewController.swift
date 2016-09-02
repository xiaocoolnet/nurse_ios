//
//  MineExaminationViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

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
        self.title = "收藏试题"
        loadData_Exampaper()
        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        
        // 每日一练列表
        fansTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
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
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.labelText = "正在获取收藏试题"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        
        helper.getCollectionInfoWith("2") { (success, response) in
            
            if success {
                self.fansListArray = response as! Array<xamInfo>
                self.fansTableView.reloadData()
            }else{
                if String(response!) == "no data" {
                    self.fansListArray = response as! Array<xamInfo>
                    self.fansTableView.reloadData()
                }
            }
            
            hud.hide(true, afterDelay: 1)
        }
        
    }
    
    // MARK: tableView 代理方法
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return fansListArray.count

    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GMyErrorTableViewCell
        cell.selectionStyle = .None
//        cell.inde = indexPath.row
        
//        if tableView.tag == 410 {
            let model = fansListArray[indexPath.row]
            //            model.post_title = "每日一练"
            cell.fanModel = model
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let userPageVC = GMyExaminationViewController()
        userPageVC.type = 3
//        if tableView.tag == 410 {
//            userPageVC.subType = 1
            print(fansListArray[indexPath.row])
            userPageVC.a = indexPath.row
            userPageVC.dataSource = fansListArray
//        }else{
//            userPageVC.subType = 2
//            userPageVC.a = indexPath.row
//            userPageVC.dataSource = focusListArray
//        }
//
        self.navigationController?.pushViewController(userPageVC, animated: true)
//        let userPageVC = GMyExamViewController()
//        userPageVC.type = 1
//        userPageVC.subType = 1
//        print(fansListArray[indexPath.row])
//        userPageVC.a = indexPath.row
//        userPageVC.dataSource = fansListArray
//        
//        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            //        获取选中删除行索引值
            let row = indexPath.row
            //        通过获取的索引值删除数组中的值
            
            let newsInfo = self.fansListArray[row]
            
            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            
            HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.questionid, type: "2", handle: { (success, response) in
                if success {
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "取消收藏成功"
                    hud.hide(true, afterDelay: 0.5)
                    
                    self.fansListArray.removeAtIndex(row)
                    
                    //        删除单元格的某一行时，在用动画效果实现删除过程
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }else{
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = String(response!)
                    hud.hide(true, afterDelay: 1)
                }
            })
        }
    }
    
}