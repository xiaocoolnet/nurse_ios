//
//  HSCollectionListController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSCollectionListController: UITableViewController {
    var collectionType = 0
    var helper = HSMineHelper()
    var dataSource = NSMutableArray()
    
    private var collectListArray:Array<CollectList> = []
    private var fansListArray:Array<xamInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if collectionType == 1 {
            //返回json
            helper.getCollectionInfoWithType("1", handle: { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let list =  newsInfoModel(response as! JSONDecoder).data
                        self.dataSource.addObjectsFromArray(list)
                        self.tableView.reloadData()
                    })
                }
            })
            tableView.registerNib(UINib(nibName:"HSArticleCollectCell",bundle: nil), forCellReuseIdentifier: "cell")
        } else if collectionType == 2 {
            
//            helper.GetCollectList(QCLoginUserInfo.currentInfo.userid, type: "2") { (success, response) in
//                self.collectListArray = response as! Array<CollectList>
//                self.tableView.reloadData()
//            }
            
            helper.getCollectionInfoWith("2") { (success, response) in
                self.fansListArray = response as! Array<xamInfo>
                self.tableView.reloadData()
            }
            tableView.registerClass(GMyErrorTableViewCell.self, forCellReuseIdentifier: "cell")
        } else if collectionType == 3 {
            
            helper.getCollectionInfoWithType("4", handle: { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let list = ForumlistModel(response as! JSONDecoder)
                        self.dataSource.addObjectsFromArray(list.datas)
                        self.tableView.reloadData()
                    })
                }
            })
            tableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        } else {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        }
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionType == 2 {
            return fansListArray.count
        }else{
            
            return dataSource.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if collectionType == 1 {
            (cell as! HSArticleCollectCell).showforModel(dataSource[indexPath.row] as! NewsInfo)
            return cell!

        }
        else if collectionType == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GMyErrorTableViewCell
            cell.selectionStyle = .None
            cell.inde = indexPath.row
            
            //        if tableView.tag == 410 {
            let model = fansListArray[indexPath.row]
            //            model.post_title = "每日一练"
            cell.fanModel = model
            return cell

        }
        else if collectionType == 3 {

            (cell as! HSComTableCell).showForForumModel(dataSource[indexPath.row] as! PostModel)
            return cell!
        }
        return cell!
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if collectionType == 1{
            if dataSource.count > indexPath.row {
                let next = NewsContantViewController()
                next.newsInfo = dataSource[indexPath.row] as? NewsInfo
                navigationController!.pushViewController(next, animated: true)
            }
        }else if collectionType == 3 {
            let vc = HSPostDetailViewController(nibName: "HSPostDetailViewController",bundle: nil)
            vc.postInfo = dataSource[indexPath.row] as? PostModel
            print((dataSource[indexPath.row] as? PostModel)?.mid)
            
            navigationController?.pushViewController(vc, animated: true)
        }else if collectionType == 2 {
//            let userPageVC = GMyExamViewController()
//            userPageVC.type = 1
//            userPageVC.subType = 1
//            print(fansListArray[indexPath.row])
//            userPageVC.a = indexPath.row
//            userPageVC.dataSource = fansListArray
//            
//            self.navigationController?.pushViewController(userPageVC, animated: true)

        }
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if collectionType == 1 {
            return 60
        }else if collectionType == 2{
            return 70
        }else if collectionType == 3 {
            return 140
        }
        
        return 0
    }
}
