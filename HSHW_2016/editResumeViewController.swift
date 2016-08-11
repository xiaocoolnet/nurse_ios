//
//  editResumeViewController.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/5.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class editResumeViewController: UIViewController {

    var height = HEIGHT-64
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "我的简历"
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        let view = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
        view.frame = CGRectMake(0, 1, WIDTH, height)
        self.view.addSubview(view)
    }
    
    func getMyResume() {
        let view = NSBundle.mainBundle().loadNibNamed("HSPostResumeView", owner: nil, options: nil).first as! HSPostResumeView
        HSNurseStationHelper().getResumeInfo(QCLoginUserInfo.currentInfo.userid) { (success, response) in
            if success {
                let model = response as! CVModel
                view.nameTF.text = model.name
                view.eduLab.text = model.education
                
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
