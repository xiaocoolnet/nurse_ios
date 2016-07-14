//
//  HSSQCollectionViewCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSSQCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var hotTableView:UITableView!
    var helper = HSNurseStationHelper()
    var typeid = "1"
    var dataSource = Array<ForumModel>()
    var hotData = Array<ForumModel>()
    var cellType:Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        bottomTableView.tag = 22
        bottomTableView.rowHeight = UITableViewAutomaticDimension
        hotTableView.registerNib(UINib(nibName:"HSHotPostCell",bundle: nil), forCellReuseIdentifier: "hotcell")
        hotTableView.tag = 11
        hotTableView.scrollEnabled = false
        hotTableView.tableFooterView = UIView()
        helper.getForumList(typeid,isHot:  false) {[unowned self] (success, response) in
            self.dataSource = response as? Array<ForumModel> ?? []
            dispatch_async(dispatch_get_main_queue(), { 
                self.bottomTableView.reloadData()
            })
        }
        helper.getForumList(typeid, isHot: true) { (success, response) in
            self.hotData = response as? Array<ForumModel> ?? []
            dispatch_async(dispatch_get_main_queue(), { 
                self.hotTableView.reloadData()
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 11 {
            return hotData.count
        }
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView.tag == 11 {
            return 60
        }
        return 140
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 11 {
            let hotcell = tableView.dequeueReusableCellWithIdentifier("hotcell") as! HSHotPostCell
            hotcell.showforForumModel(hotData[indexPath.row])
            hotcell.selectionStyle = .None
            return hotcell
        }
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
        
        //
        let model:ForumModel = dataSource[indexPath.row]
        print(model.mid)
        helper.showPostInfo("1") { (success, response) in
            let postM:PostModel = (response as? PostModel ?? nil)!
            vc.postDetailWithModel(postM)

            print(response)
        }
        
    }
}
