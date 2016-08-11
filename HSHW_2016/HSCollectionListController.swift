//
//  HSCollectionListController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/15.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSCollectionListController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let myTableView: UITableView! = UITableView()
    var collectionType = 0
    var helper = HSMineHelper()
    var dataSource = NSMutableArray()
    
    private var collectListArray:Array<CollectList> = []
    private var fansListArray:Array<xamInfo> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-110)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadData))
        self.view.addSubview(myTableView)
        
        myTableView.backgroundColor = UIColor.whiteColor()
        
        loadData()
    }
    
    // MARK: 获取数据
    func loadData() {
        if collectionType == 1 {
            
            myTableView.registerNib(UINib(nibName:"HSArticleCollectCell",bundle: nil), forCellReuseIdentifier: "cell")
            
            //返回json
            helper.getCollectionInfoWithType("1", handle: { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let list =  newsInfoModel(response as! JSONDecoder).data
                        self.dataSource.addObjectsFromArray(list)
                        self.myTableView.reloadData()
                    })
                }
                if self.myTableView.mj_header.isRefreshing(){
                    self.myTableView.mj_header.endRefreshing()
                }
            })
        } else if collectionType == 2 {
            
            myTableView.registerClass(GHSExamCollectTableViewCell.self, forCellReuseIdentifier: "cell")

            helper.getCollectionInfoWith("2") { (success, response) in
                self.fansListArray = response as! Array<xamInfo>
                self.myTableView.reloadData()
                
                if self.myTableView.mj_header.isRefreshing(){
                    self.myTableView.mj_header.endRefreshing()
                }
            }
        } else if collectionType == 3 {
            
            myTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
            
            helper.getCollectionInfoWithType("4", handle: { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let list = PostCollectListModel(response as! JSONDecoder)
                        self.dataSource.addObjectsFromArray(list.datas)
                        self.myTableView.reloadData()
                    })
                }
                
                if self.myTableView.mj_header.isRefreshing(){
                    self.myTableView.mj_header.endRefreshing()
                }
            })
        }
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if collectionType == 2 {
            print(fansListArray.count)
            return fansListArray.count
        }else{
            
            return dataSource.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if collectionType == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
            cell?.selectionStyle = .None
            (cell as! HSArticleCollectCell).showforModel(dataSource[indexPath.row] as! NewsInfo)
            return cell!

        }else if collectionType == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GHSExamCollectTableViewCell
            cell.selectionStyle = .None
//            cell.inde = indexPath.row
            
            cell.showforModel(fansListArray[indexPath.row])
            
            //        if tableView.tag == 410 {
//            let model = fansListArray[indexPath.row]
            //            model.post_title = "每日一练"
//            cell.fanModel = model
            return cell

        }else if collectionType == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")

            (cell as! HSComTableCell).showForForumModel(dataSource[indexPath.row] as! PostModel)
            return cell!
        }else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell")
            
            return cell!
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if collectionType == 1{
            if dataSource.count > indexPath.row {
                let next = NewsContantViewController()
                next.newsInfo = dataSource[indexPath.row] as? NewsInfo
//                next.navTitle = dataSource[indexPath.row] as? NewsInfo)
                navigationController!.pushViewController(next, animated: true)
            }
        }else if collectionType == 3 {
            let vc = HSPostDetailViewController(nibName: "HSPostDetailViewController",bundle: nil)
            vc.postInfo = dataSource[indexPath.row] as? PostModel
            print((dataSource[indexPath.row] as? PostModel)?.mid)
            
            navigationController?.pushViewController(vc, animated: true)
        }else if collectionType == 2 {
            let userPageVC = GMyExamViewController()
            userPageVC.type = 1
            userPageVC.subType = 1
            print(fansListArray[indexPath.row])
            // TODO:接口数据，收藏的试题 examInfo.post_difficulty 有时为空
            userPageVC.currentIndex = indexPath.row
            userPageVC.dataSource = fansListArray
            
            self.navigationController?.pushViewController(userPageVC, animated: true)

        }
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if collectionType == 1 {
            return 56
        }else if collectionType == 2{
            return 56
        }else if collectionType == 3 {
            return 140
        }
        
        return 0
    }
}
