//
//  AllViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class AllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        
        myTableView.frame = CGRectMake(0, 0.5, WIDTH, HEIGHT-144.5)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellOne")
        myTableView.registerClass(PostTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = 100
        
        let posted = UIButton()
        posted.frame = CGRectMake(WIDTH-70 , HEIGHT-230, 50, 50)
        posted.setImage(UIImage(named: "ic_edit.png"), forState: .Normal)
        posted.addTarget(self, action: #selector(self.postedTheView), forControlEvents: .TouchUpInside)
        self.view.addSubview(posted)
        posted.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 12
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH*167/375
        }else{
            return WIDTH*80/375+175
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "真的很累吗？累就对了，舒服是留给死人的！苦-才是人生 ，累-才是工作， 变-才是命运 ， 忍-才是历练，容-才是智慧 ， 静-才是修养，舍-才是得到 ，做-才是拥有！"
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!PostTableViewCell
            cell.selectionStyle = .None
            cell.titImage.setImage(UIImage(named: "1.png"), forState: .Normal)
            cell.titImage.addTarget(self, action: #selector(self.userGoToView), forControlEvents: .TouchUpInside)
            cell.titLab.text = "天使的羽翼"
            cell.nurse.text = "护理室护士"
            cell.timeLab.text = "7分钟"
            cell.titTit.text = "各位，如何才能感冒不流鼻涕呢？"
            cell.contant.text = "你不愿意种花，你说，我不愿看见它一点点凋落。是的，为了避免结束，你避免了一切开始。"
            cell.from.text = "来自"
            cell.fromRoom.text = "外科"
            cell.zanNum.text = "2345"
            cell.comment.text = "5722"
            cell.one.image = UIImage(named: "2.png")
            cell.two.image = UIImage(named: "3.png")
            cell.three.image = UIImage(named: "4.png")
            
            return cell
        }
        
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        let next = NewsContantViewController()
        self.navigationController?.pushViewController(next, animated: true)
        
        
        
    }
    func userGoToView() {
        print("其他用户")
        let next = UserViewController()
        self.navigationController?.pushViewController(next, animated: true)
        next.title = "苏珍贞"
        
    }
    func postedTheView() {
        print("发帖")
        let next = PostViewController()
        self.navigationController?.pushViewController(next, animated: true)
        next.title = "发帖"
        
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
