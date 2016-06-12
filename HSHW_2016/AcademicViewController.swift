//
//  AcademicViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class AcademicViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
    var dataSource = NewsList()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.GetData()
        self.view.backgroundColor = COLOR
//       
//        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-60)
//        myTableView.backgroundColor = UIColor.whiteColor()
//        myTableView.delegate = self
//        myTableView.dataSource = self
//        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
//        self.view.addSubview(myTableView)
//        myTableView.rowHeight = (WIDTH-20)*120/355+63
        
        // Do any additional setup after loading the view.
    }
    
    func GetData(){
    
        
        let url = PARK_URL_Header+"getNewslist"
        let param = [
            "channelid":"7"
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
                    
                    self.createTableView()
                    print(status)
                    self.dataSource = NewsList(status.data!)
                    self.myTableView .reloadData()
                    print(status.data)
                }
            }
            
        }

    
    }
    
    func createTableView() {
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-108)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(AcademicTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*120/355+63

        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!AcademicTableViewCell
        cell.selectionStyle = .None
        let newsInfo = self.dataSource.objectlist[indexPath.row]
        cell.titImage.image = UIImage(named: "2.png")
        cell.titLab.text = newsInfo.post_title
        cell.conNum.text = "3455"
        cell.timeLab.text = newsInfo.create_time
        cell.zanNum.text = "3476"
        cell.zan.addTarget(self, action: #selector(AcademicViewController.getUpZanNum), forControlEvents: .TouchUpInside)
        
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let next = NewsContantViewController()
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    func getUpZanNum() {
        print("赞")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
