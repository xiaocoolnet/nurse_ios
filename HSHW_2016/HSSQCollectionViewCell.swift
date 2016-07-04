//
//  HSSQCollectionViewCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSSQCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var firstNewsView: UIView!
    @IBOutlet weak var secondNewsView: UIView!
    @IBOutlet weak var thirdNewsView: UIView!
    @IBOutlet weak var fourthNewsView: UIView!
    
    @IBOutlet weak var firstNewsLabel: UILabel!
    @IBOutlet weak var secondNewsLabel: UILabel!
    @IBOutlet weak var thirdNewsLabel: UILabel!
    @IBOutlet weak var fourthNewsLabel: UILabel!
    @IBOutlet weak var bottomTableView: UITableView!
    
    var helper = HSNurseStationHelper()
    var typeid = "1"
    var dataSource = Array<ForumModel>()
    var cellType:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        bottomTableView.rowHeight = UITableViewAutomaticDimension
        helper.getForumList(typeid) {[unowned self] (success, response) in
            self.dataSource = response as? Array<ForumModel> ?? []
            dispatch_async(dispatch_get_main_queue(), { 
                self.bottomTableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSComTableCell
        cell.showForForumModel(dataSource[indexPath.row])
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var a:UIResponder = self
        
        while !a.isKindOfClass(HSWCommunityHome.self){
            a = a.nextResponder()!
        }
        let vc = a as! HSWCommunityHome
        vc.postDetailWithModel()
    }
}
