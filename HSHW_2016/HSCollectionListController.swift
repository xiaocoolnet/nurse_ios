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
    override func viewDidLoad() {
        super.viewDidLoad()
        if collectionType == 1 {
            tableView.registerNib(UINib(nibName:"HSArticleCollectCell",bundle: nil), forCellReuseIdentifier: "cell")
        } else if collectionType == 2 {
            tableView.registerClass(EveryDayTableViewCell.self, forCellReuseIdentifier: "cell")
        } else if collectionType == 3 {
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
        if collectionType == 1 {
            return 10
        }else if collectionType == 2{
            return 1
        }else if collectionType == 3 {
            return 10
        }
        
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if collectionType == 1 {
            return 60
        }else if collectionType == 2{
            return 50
        }else if collectionType == 3 {
            return 100
        }
        
        return 0
    }
}
