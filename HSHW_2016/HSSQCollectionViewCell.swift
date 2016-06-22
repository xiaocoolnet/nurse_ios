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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bottomTableView.registerNib(UINib(nibName: "HSComTableCell",bundle: nil), forCellReuseIdentifier: "cell")
        bottomTableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HSComTableCell
        cell.selectionStyle = .None
        return cell
    }

}
