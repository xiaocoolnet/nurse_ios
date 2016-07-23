//
//  QuestionBankViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import AFNetworking
import Alamofire
import MBProgressHUD

class QuestionBankViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    var dataSource = NewsList()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = RGREY
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(QuestionTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 75
        // Do any additional setup after loading the view.
        
        self.GetData()
    }
    
    func GetData(){
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":"11"
        ];
        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            print(request)
            if(error != nil){
                
            }else{
                let status = NewsModel(JSONDecoder(json!))
                print("状态是")
                print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    //hud.labelText = status.errorData
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                }
                if(status.status == "success"){
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    print(LikeList(status.data!).objectlist)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!QuestionTableViewCell
        cell.selectionStyle = .None
        let QuestionInfo = self.dataSource.objectlist[indexPath.row]
        cell.titLab.text = QuestionInfo.post_title
        cell.titLeb.text = QuestionInfo.post_excerpt
        cell.zanNum.text = QuestionInfo.post_hits
//        cell.conNum.text = QuestionInfo.post_hits
        
        return cell
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        let nextVC = NewsContantViewController()
        nextVC.newsInfo = newsInfo
        nextVC.likeNum = newsInfo.likes.count
        nextVC.tagNum = 1
        print(newsInfo.likes.count)
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
}
