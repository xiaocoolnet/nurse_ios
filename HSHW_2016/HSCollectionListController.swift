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
            
            helper.getCollectionInfoWithType("2", handle: { (success, response) in
                if success {
                    
                }
            })
            tableView.registerClass(EveryDayTableViewCell.self, forCellReuseIdentifier: "cell")
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
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if collectionType == 1 {
            (cell as! HSArticleCollectCell).showforModel(dataSource[indexPath.row] as! NewsInfo)
        }
        else if collectionType == 2 {
            
        }
        else if collectionType == 3 {
            (cell as! HSComTableCell).showForForumModel(dataSource[indexPath.row] as! PostModel)
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
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if collectionType == 1 {
            return 60
        }else if collectionType == 2{
            return 50
        }else if collectionType == 3 {
            return 140
        }
        
        return 0
    }
}
