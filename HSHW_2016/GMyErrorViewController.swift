//
//  GMyErrorViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class GMyErrorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {
    
    var helper = HSMineHelper()
    var dailyBtn = UIButton()
    var examBtn = UIButton()
    
    let myScrollView = UIScrollView()
    let fansTableView = UITableView()
    let focusTableView = UITableView()
    var navigationBarLineView = UIView()
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData_Exampaper()
        
        setTitleView()
        
        // 线
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        // 总滚动视图
        myScrollView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        myScrollView.contentSize = CGSize(width: WIDTH*2.0, height: HEIGHT-65)
        myScrollView.isPagingEnabled = true
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.delegate = self
        myScrollView.tag = 688
        self.view.addSubview(myScrollView)
        
        // 每日一练列表
        fansTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-64)
        fansTableView.backgroundColor = UIColor.clear
        fansTableView.register(GMyErrorTableViewCell.self, forCellReuseIdentifier: "cell")
        fansTableView.rowHeight = 70
        fansTableView.tag = 410
        fansTableView.delegate = self
        fansTableView.dataSource = self
        myScrollView.addSubview(fansTableView)
        
        // 在线考试列表
        focusTableView.frame = CGRect(x: WIDTH, y: 0, width: WIDTH, height: HEIGHT-64)
        focusTableView.backgroundColor = UIColor.clear
        focusTableView.register(GMyErrorTableViewCell.self, forCellReuseIdentifier: "cell")
        focusTableView.rowHeight = 70
        focusTableView.tag = 411
        focusTableView.delegate = self
        focusTableView.dataSource = self
        myScrollView.addSubview(focusTableView)
        
        myScrollView.contentOffset = CGPoint(x: self.fansTableView.frame.minX, y: self.fansTableView.frame.minY)
        
        // Do any additional setup after loading the view.
    }
    
    // 设置 TitleView
    func setTitleView() {
        let titleBgView = UIView.init(frame: CGRect(x: 0, y: 0, width: WIDTH/2.0, height: 44))
        
        // 每日一练按钮
        dailyBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: titleBgView.frame.width/2.0, height: titleBgView.frame.height))
        dailyBtn.setTitle("每日一练", for: UIControlState())
        dailyBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), for: UIControlState())
        dailyBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), for: .selected)
        dailyBtn.addTarget(self, action: #selector(self.fansBtnClick(_:)), for: .touchUpInside)
        dailyBtn.isSelected = true
        titleBgView.addSubview(dailyBtn)
        
        // 在线考试按钮
        examBtn = UIButton.init(frame: CGRect(x: dailyBtn.frame.maxX, y: 0, width: titleBgView.frame.width-dailyBtn.frame.maxX, height: titleBgView.frame.height))
        examBtn.setTitle("在线考试", for: UIControlState())
        examBtn.setTitleColor(UIColor.init(red: 157/255.0, green: 158/255.0, blue: 159/255.0, alpha: 1), for: UIControlState())
        examBtn.setTitleColor(UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1), for: .selected)
        examBtn.addTarget(self, action: #selector(self.focusBtnClick(_:)), for: .touchUpInside)
        titleBgView.addSubview(examBtn)
        
        // 线
        navigationBarLineView = UIView.init(frame: CGRect(x: dailyBtn.frame.minX, y: dailyBtn.frame.maxY-5, width: dailyBtn.frame.width, height: 5))
        navigationBarLineView.backgroundColor = UIColor.init(red: 145/255.0, green: 0, blue: 105/255.0, alpha: 1)
        titleBgView.addSubview(navigationBarLineView)
        
        self.navigationItem.titleView = titleBgView
    }
    
    // 每日一练按钮 点击事件
    func fansBtnClick(_ fineBtn: UIButton) {
        fineBtn.isSelected = true
        for subView in (fineBtn.superview?.subviews)! {
            if subView .isKind(of: UIButton.classForCoder()) {
                if subView != fineBtn {
                    (subView as! UIButton).isSelected = false
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationBarLineView.frame = CGRect(x: fineBtn.frame.minX, y: fineBtn.frame.maxY-5, width: fineBtn.frame.width, height: 5)
            self.myScrollView.contentOffset = CGPoint(x: self.fansTableView.frame.minX, y: self.fansTableView.frame.minY)
        }) 
    }
    
    // 在线考试按钮 点击事件
    func focusBtnClick(_ focusBtn: UIButton) {
        focusBtn.isSelected = true
        for subView in (focusBtn.superview?.subviews)! {
            if subView .isKind(of: UIButton.classForCoder()) {
                if subView != focusBtn {
                    (subView as! UIButton).isSelected = false
                }
            }
            
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.navigationBarLineView.frame = CGRect(x: focusBtn.frame.minX, y: focusBtn.frame.maxY-5, width: focusBtn.frame.width, height: 5)
            self.myScrollView.contentOffset = CGPoint(x: self.focusTableView.frame.minX, y: self.focusTableView.frame.minY)
        }) 
    }
    
    fileprivate var fansListArray:Array<xamInfo> = []
    fileprivate var focusListArray:Array<xamInfo> = []
    
    // 加载数据_做题记录
    func loadData_Exampaper() {
        
//        let userid = QCLoginUserInfo.currentInfo.userid
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.Text;
        hud.label.text = "正在获取试题详情"
        hud.margin = 10.0
        hud.removeFromSuperViewOnHide = true
        var flag = 0
        
        let userid = QCLoginUserInfo.currentInfo.userid
        helper.GetErrorExampaper(userid, type: "1") { (success, response) in
            
            if success {
                
                self.fansListArray = response as! Array<xamInfo>
                self.fansTableView.reloadData()
            }else{
                if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                    self.fansListArray = Array<xamInfo>()
                    self.fansTableView.reloadData()
                }else{
                    
                }
            }
            
            flag += 1
            if flag == 2 {
                hud.hide(animated: true, afterDelay: 1)
            }
        }
        
        helper.GetErrorExampaper(userid, type: "2") { (success, response) in

            if success {
                
                self.focusListArray = response as! Array<xamInfo>
                self.focusTableView.reloadData()
            }else{
                
                if String(describing: (response ?? ("" as AnyObject))!) == "no data" {
                    self.focusListArray = Array<xamInfo>()
                    self.focusTableView.reloadData()
                }else{
                    
                }
            }
            
            flag += 1
            if flag == 2 {
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    // MARK: tableView 代理方法
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 410 {
            return fansListArray.count
        }else{
            return focusListArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GMyErrorTableViewCell
        cell.selectionStyle = .none
//        cell.inde = indexPath.row
        
        if tableView.tag == 410 {
            let model = fansListArray[indexPath.row]
//            model.post_title = "每日一练"
            cell.fansModel = model
//            cell.textLabel?.text = model.post_title
        }else if tableView.tag == 411{
            let model = focusListArray[indexPath.row]
//            model.post_title = "在线考试"
            cell.fansModel = model
//            cell.textLabel?.text = model.post_title
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        
        let userPageVC = GMyExaminationViewController()
        userPageVC.type = 1
        if tableView.tag == 410 {
            userPageVC.subType = 1
//            print(fansListArray[indexPath.row])
            userPageVC.a = indexPath.row
            userPageVC.dataSource = fansListArray
        }else{
            userPageVC.subType = 2
            userPageVC.a = indexPath.row
            userPageVC.dataSource = focusListArray
        }
        
        self.navigationController?.pushViewController(userPageVC, animated: true)
    }
    
    // MARK: UIScrollView 代理方法
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag == 688 {
            if scrollView.contentOffset.x == 0 {
                fansBtnClick(dailyBtn)
            }else if scrollView.contentOffset.x == WIDTH {
                focusBtnClick(examBtn)
            }
        }
    }
}
