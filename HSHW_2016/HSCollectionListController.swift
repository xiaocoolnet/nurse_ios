//
//  HSCollectionListController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class HSCollectionListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let myTableView: UITableView! = UITableView()
    var collectionType = 0
    var helper = HSMineHelper()
    var dataSource = Array<NewsInfo>()
    
    fileprivate var collectListArray:Array<CollectList> = []
    fileprivate var fansListArray:Array<xamInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        myTableView.mj_header.beginRefreshing()
        self.view.addSubview(myTableView)
        
        myTableView.backgroundColor = UIColor.white
        
//        loadData()
    }
    
    // MARK: 获取数据
    func loadData() {
        if collectionType == 1 {
            
            myTableView.register(UINib(nibName:"HSArticleCollectCell",bundle: nil), forCellReuseIdentifier: "cell")
            
            //返回json
            helper.getCollectionInfoWithType("1", handle: { (success, response) in
                if success {
                    DispatchQueue.main.async(execute: {
//                        let list =  newsInfoModel(response as! JSONDecoder).data
                        self.dataSource = newsInfoModel(response as! JSONDecoder).data
                        self.myTableView.reloadData()
                    })
                }
                if self.myTableView.mj_header.isRefreshing(){
                    self.myTableView.mj_header.endRefreshing()
                }
            })
        } else if collectionType == 2 {
            
            myTableView.register(GHSExamCollectTableViewCell.self, forCellReuseIdentifier: "cell")

            helper.getCollectionInfoWith("2") { (success, response) in
                self.fansListArray = response as! Array<xamInfo>
                self.myTableView.reloadData()
                
                if self.myTableView.mj_header.isRefreshing(){
                    self.myTableView.mj_header.endRefreshing()
                }
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionType == 2 {
            // print(fansListArray.count)
            return fansListArray.count
        }else{
            
            return dataSource.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if collectionType == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.selectionStyle = .none
            (cell as! HSArticleCollectCell).showforModel(dataSource[indexPath.row] )
            return cell!

        }else if collectionType == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GHSExamCollectTableViewCell
            cell.selectionStyle = .none
//            cell.inde = indexPath.row
            
            cell.showforModel(fansListArray[indexPath.row])
            
            //        if tableView.tag == 410 {
//            let model = fansListArray[indexPath.row]
            //            model.post_title = "每日一练"
//            cell.fanModel = model
            return cell

        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            
            return cell!
        }
//        else if collectionType == 3 {
//            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
//            
//            (cell as! HSComTableCell).showForForumModel(dataSource[indexPath.row] as! PostModel)
//            return cell!
//        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if collectionType == 1{
            if dataSource.count > indexPath.row {
                let next = NewsContantViewController()
                next.newsInfo = dataSource[indexPath.row]
//                next.navTitle = dataSource[indexPath.row] as? NewsInfo)
                navigationController!.pushViewController(next, animated: true)
            }
        }else if collectionType == 2 {
            let userPageVC = GMyExamViewController()
            userPageVC.type = 1
            userPageVC.subType = 1
            // print(fansListArray[indexPath.row])
            // TODO:接口数据，收藏的试题 examInfo.post_difficulty 有时为空
            userPageVC.currentIndex = indexPath.row
            userPageVC.dataSource = fansListArray
            
            self.navigationController?.pushViewController(userPageVC, animated: true)

        }
//        else if collectionType == 3 {
//            let vc = HSPostDetailViewController(nibName: "HSPostDetailViewController",bundle: nil)
//            vc.postInfo = dataSource[indexPath.row] as? PostModel
//            // print((dataSource[indexPath.row] as? PostModel)?.mid)
//            
//            navigationController?.pushViewController(vc, animated: true)
//        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if collectionType == 1 {
            return 56
        }else if collectionType == 2{
            return 56
        }else if collectionType == 3 {
            return 140
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            //        获取选中删除行索引值
            let row = indexPath.row
            //        通过获取的索引值删除数组中的值
            if collectionType == 1 {
                
                let newsInfo = self.dataSource[row] 
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                
                HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.object_id, type: "1", handle: { (success, response) in
                    if success {
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "取消收藏成功"
                        hud.hide(animated: true, afterDelay: 0.5)
                        
                        self.dataSource.remove(at: row)
                        
                        //        删除单元格的某一行时，在用动画效果实现删除过程
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }else{
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = String(describing: (response ?? ("" as AnyObject))!)
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            }else{
                
                let newsInfo = self.fansListArray[row]
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                
                HSMineHelper().cancelFavorite(QCLoginUserInfo.currentInfo.userid, refid: newsInfo.questionid, type: "2", handle: { (success, response) in
                    if success {
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "取消收藏成功"
                        hud.hide(animated: true, afterDelay: 0.5)
                        
                        self.fansListArray.remove(at: row)
                        
                        //        删除单元格的某一行时，在用动画效果实现删除过程
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                    }else{
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = String(describing: (response ?? ("" as AnyObject))!)
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            }
        }
    }
    
}
