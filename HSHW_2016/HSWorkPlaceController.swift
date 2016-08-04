//
//  HSWorkPlaceController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/21.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSWorkPlaceController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var listTableView:UITableView!
    var helper = HSNurseStationHelper()
    var newsList:Array<NewsInfo>?
    var articleID:String?
    
    override func viewDidLoad() {
        listTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "cell")
        if articleID != nil {
            helper.getArticleListWithID(articleID!) {[unowned self] (success, response) in
                if success {
                    self.newsList = response as? Array<NewsInfo> ?? []
                    dispatch_async(dispatch_get_main_queue(), {
                        self.listTableView.reloadData()
                    })
                }
            }
        }
        listTableView.tableFooterView = UIView()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let newsInfo = newsList![indexPath.row]
        
        let options : NSStringDrawingOptions = NSStringDrawingOptions.UsesLineFragmentOrigin
        let screenBounds:CGRect = UIScreen.mainScreen().bounds
        let boundingRect = String(newsInfo.post_title).boundingRectWithSize(CGSizeMake(screenBounds.width, 0), options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
        print(boundingRect.height)
        if boundingRect.height+60>100 {
            return boundingRect.height+60
        }else{
            return 100
        }
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if newsList != nil {
            return newsList!.count
        }else{
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TouTiaoTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.newsList![indexPath.row]
        cell.setCellWithNewsInfo(newsInfo)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let newsInfo = newsList![indexPath.row]
        let next = NewsContantViewController()
        next.newsInfo = newsInfo
        next.likeNum = newsInfo.likes.count
        print(newsInfo.likes.count)
        self.navigationController?.pushViewController(next, animated: true)
    }
}