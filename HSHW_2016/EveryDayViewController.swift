//
//  EveryDayViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class EveryDayViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    
    let titArr:[String] = ["美国RN","国际护士证ISPN","新加坡护士证","护士资格","初级护师","主管护师"]
    let picArr:[String] = ["ic_rn.png","ic_earth.png","ic_moon.png","ic_maozi_one.png","ic_maozi_two.png","ic_maozi_three.png"]
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 10))
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        
        self.view.backgroundColor = RGREY
        
        self.title = "每日一练"
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(EveryDayTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 60
        self.view.addSubview(line)
        myTableView.tableHeaderView = one
        
//        myTableView.separatorColor = RGREY
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!EveryDayTableViewCell
        cell.selectionStyle = .None
        cell.titLab.text = titArr[indexPath.row]
        cell.titImage.setImage(UIImage(named: picArr[indexPath.row]), forState: .Normal)
        cell.start.addTarget(self, action: #selector(self.startTheTest), forControlEvents: .TouchUpInside)
        let line = UILabel(frame: CGRectMake(55, 59.5, WIDTH-55, 0.5))
        line.backgroundColor = UIColor.grayColor()
        
        cell.addSubview(line)
        if indexPath.row == 5 {
            line.removeFromSuperview()
        }
        
        cell.num.text = "10"
        
        return cell
        
    }
    
    func startTheTest() {
        print("答题")
        let next = WordViewController()
        self.navigationController?.pushViewController(next, animated: true)
        next.title = "练习题"
        
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
