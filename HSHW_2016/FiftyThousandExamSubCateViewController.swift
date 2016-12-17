//
//  FiftyThousandExamSubCateViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class FiftyThousandExamSubCateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var term_id = ""
    
    var term_name = ""
    
    let rootTableView = UITableView()
    
    var data = Array<GNewsCate>()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 8万题库 "+(self.term_name )+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 8万题库 "+(self.term_name )+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
        self.loadData()
    }
    
    // MARK: 加载数据
    func loadData() {
        NewsPageHelper().getChannellist(self.term_id) { (success, response) in
            if success {
                self.data = response as! [GNewsCate]
                
                self.rootTableView.mj_header.endRefreshing()
                self.rootTableView.reloadData()
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = .text
                hud.margin = 10
                hud.label.text = "网络错误，请稍后再试"
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
        }
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
//        self.automaticallyAdjustsScrollViewInsets = false
        
        print(self.term_id)
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.white
        
        rootTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1)
        rootTableView.delegate = self
        rootTableView.dataSource = self
        
        rootTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        rootTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        
        self.view.addSubview(rootTableView)
        
        rootTableView.mj_header.beginRefreshing()
    }
    
    // MARK:- UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "fiftyThousandExamSubCateCell")
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "fiftyThousandExamSubCateCell")
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell?.textLabel?.text = self.data[indexPath.row].name
        
        return cell!
    }
    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let twoView = QuestionBankViewController()
        twoView.hasMenuHeight = false
        twoView.title = self.data[indexPath.row].name
        twoView.term_id = (self.data[indexPath.row].term_id ?? "")!
        
        self.navigationController?.pushViewController(twoView, animated: true)
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
