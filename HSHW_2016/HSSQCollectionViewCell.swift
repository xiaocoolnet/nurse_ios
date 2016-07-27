//
//  HSSQCollectionViewCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//  社区首页

import UIKit

protocol refreshCollectionViewDelegate {
    func refreshCollectionView()
}

class HSSQCollectionViewCell: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bottomTableView: UITableView!
    @IBOutlet weak var hotTableView:UITableView!
    var helper = HSNurseStationHelper()
//    var typeid = "1"
    var dataSource = Array<PostModel>()
    var hotData = Array<PostModel>()
    var cellType:Int?
    
    var firstFlag = 1
    
    var delegate:refreshCollectionViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        bottomTableView.tag = 22
        bottomTableView.rowHeight = UITableViewAutomaticDimension
        hotTableView.registerNib(UINib(nibName:"HSHotPostCell",bundle: nil), forCellReuseIdentifier: "hotcell")
        hotTableView.tag = 11
        hotTableView.estimatedRowHeight = 34
        hotTableView.rowHeight = UITableViewAutomaticDimension
        hotTableView.scrollEnabled = false
        hotTableView.tableFooterView = UIView()
        
        print(hotTableView.frame)
        hotTableView.translatesAutoresizingMaskIntoConstraints = true
        print(hotTableView.frame)
        
    }
    
    var typeid:String = ""{
        didSet {
            helper.getForumList(typeid,isHot:  false) {[unowned self] (success, response) in
                self.dataSource = response as? Array<PostModel> ?? []
                dispatch_async(dispatch_get_main_queue(), {
                    self.bottomTableView.reloadData()
                })
            }
            // TODO: 0 需要改为 typeid
            helper.getForumList("0", isHot: true) { (success, response) in
                self.hotData = response as? Array<PostModel> ?? []
                print("热门数据总共有\(self.hotData.count)条")
                for obj in self.hotData {
                    print("------------",obj.title)
                }
                
                dispatch_async(dispatch_get_main_queue(), {
                    // TODO:这个地方刷新次数有点问题
                    if self.firstFlag < 4 {
                        self.hotTableView.reloadData()
                        self.delegate?.refreshCollectionView()
                        self.firstFlag += 1
                    }
                })
            }
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
            
            return 34
        }
        return 140
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView.tag == 11 {
            let hotcell = tableView.dequeueReusableCellWithIdentifier("hotcell") as! HSHotPostCell
            hotcell.showforForumModel(hotData[indexPath.row])
            hotcell.selectionStyle = .None
//            hotcell.backgroundColor = UIColor.init(red: CGFloat(arc4random_uniform(255))/255.0, green: CGFloat(arc4random_uniform(255))/255.0, blue: CGFloat(arc4random_uniform(255))/255.0, alpha: 1)
            hotTableView.frame = CGRectMake(hotTableView.frame.origin.x, hotTableView.frame.origin.y, hotTableView.frame.size.width, hotcell.frame.size.height*CGFloat(hotData.count))
            print("hotTableView.frame == ",hotTableView.frame,"hotcell.height == ",hotcell.frame.size.height)
            
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
        
     
        //TODO:之前是下边有问题，还需要优化
        if tableView.tag == 11 {
            vc.postDetailWithModel_1(hotData[indexPath.row])
        }else {
            //
            let model:PostModel = dataSource[indexPath.row]
            helper.showPostInfo(model.mid) { (success, response) in
                let postM:PostModel = (response as? PostModel ?? nil)!
                vc.postDetailWithModel_1(postM)
                print(response)
            }
        }
        
    }
}
