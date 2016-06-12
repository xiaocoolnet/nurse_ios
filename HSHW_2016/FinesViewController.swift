//
//  FinesViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FinesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-115)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(FineTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 70
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!FineTableViewCell
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        cell.titImg.image = UIImage(named: "1.png")
        
        let nameLab = UILabel(frame: CGRectMake(75, 25, 50, 20))
        nameLab.font = UIFont.systemFontOfSize(15)
        nameLab.text = "张澜澜"
        nameLab.sizeToFit()
        
        let fineBtn = UIButton()
        fineBtn.frame = CGRectMake(75+nameLab.bounds.size.width+5, 26, 19, 18)
        fineBtn.setBackgroundImage(UIImage(named: "ic_shield_purple.png"), forState: .Normal)
        fineBtn.titleLabel?.font = UIFont.systemFontOfSize(9)
        fineBtn.setTitle("31", forState: .Normal)
        fineBtn.setTitleColor(COLOR, forState: .Normal)
        
        cell.addSubview(nameLab)
        cell.addSubview(fineBtn)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
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
