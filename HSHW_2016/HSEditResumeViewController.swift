//
//  HSEditResumeViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/12.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

//定义协议改变Btn的标题
protocol ChangeDelegate:NSObjectProtocol{
    //回调方法
    func change(_ controller:HSEditResumeViewController,string:String, idStr:String)
}

class HSEditResumeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var myTableView = UITableView()
    var dateSource = EduList()
    
    var num = String()
    var id = String()
    
    
    
    var delegate:ChangeDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myTableView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-108)
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.bounces = false
        self.view.addSubview(myTableView)
        
        self.dataGet()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateSource.objectlist.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        let eduInfo  = self.dateSource.objectlist[indexPath.row]
        cell.textLabel?.text = eduInfo.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(1111)
        let eduInfo = self.dateSource.objectlist[indexPath.row].name
        id = num
        // print(eduInfo)
//        if((delegate) != nil){
            delegate?.change(self, string: eduInfo, idStr: id)

//        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func dataGet(){
        
        let url = PARK_URL_Header+"getDictionaryList"
        let param = ["type":num]
        // print(param)
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//        Alamofire.request(.GET, url, parameters: param).response { request, response, json, error in
            if(error != nil){
                
            }else{
                let status = EduModel(JSONDecoder(json!))
                // print("状态是")
                // print(status.status)
                if(status.status == "error"){
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text;
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(animated: true, afterDelay: 1)
                }
                if(status.status == "success"){
                    // print(status)
                    self.dateSource = EduList(status.data!)
                    
                    self.myTableView .reloadData()
                }
            }
            
        }
        
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
