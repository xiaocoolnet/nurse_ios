//
//  HSSelectController.swift
//  HSHW_2016
//  Created by xiaocool on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSSelectController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let dataList = UITableView()
    var datasource = Array<String>()
    var selectHandle:selectBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataList.frame = self.view.frame
        dataList.delegate = self
        dataList.dataSource = self
        dataList.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dataList.tableFooterView = UIView()
        view.addSubview(dataList)
    }
    func setDataSource(datas:Array<String>){
        datasource.removeAll()
        datasource += datas
        dataList.reloadData()
    }
    func setSelectHandleWith(handle:selectBlock){
        selectHandle = handle
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        cell?.textLabel?.text = datasource[indexPath.row]
        return cell!
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectHandle != nil {
            selectHandle!(indexPath.row)
        }
        navigationController?.popViewControllerAnimated(true)
    }
}