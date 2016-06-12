//
//  UserViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    let titImage = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rightBtn = UIBarButtonItem(image: UIImage(named: "ic_fenxiang.png"), style: .Done, target: self, action: #selector(self.goToNext))
        navigationItem.rightBarButtonItem = rightBtn
        
        myTableView.frame = CGRectMake(0, 0, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerClass(UserPostTableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        self.view.addSubview(myTableView)
        myTableView.separatorColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return 20
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return WIDTH*314/375
        }else{
            return 160
        }
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 40
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let one = UIView()
        one.backgroundColor = UIColor.whiteColor()
        let lineone = UILabel(frame: CGRectMake(10, 39, WIDTH-20, 1))
        lineone.backgroundColor = COLOR
        one.addSubview(lineone)
        let tit = UILabel(frame: CGRectMake(10, 10, 100, 30))
        tit.textColor = COLOR
        tit.font = UIFont.systemFontOfSize(14)
        tit.text = "他的帖子"
        one.addSubview(tit)
        return one
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.backgroundColor = COLOR
            titImage.frame = CGRectMake(WIDTH*128/375, WIDTH*23/375, WIDTH*120/375, WIDTH*120/375)
            titImage.setBackgroundImage(UIImage(named: "6.png"), forState: .Normal)
            titImage.addTarget(self, action: #selector(MineViewController.changeTitImage), forControlEvents: .TouchUpInside)
            titImage.layer.cornerRadius = WIDTH*120/375/2
            titImage.clipsToBounds = true
            titImage.layer.borderWidth = 2
            titImage.layer.borderColor = UIColor.whiteColor().CGColor
            cell.addSubview(titImage)

            let name = UILabel()
            name.frame = CGRectMake(WIDTH*160/375, WIDTH*164/375, WIDTH*55/375, 30)
            name.textAlignment = .Center
            name.font = UIFont.systemFontOfSize(18)
            name.textColor = UIColor.whiteColor()
            name.text = "苏珍贞"
            name.sizeToFit()
            name.frame = CGRectMake(WIDTH/2-name.bounds.size.width/2, WIDTH*164/375, name.bounds.size.width, name.bounds.size.height)
            cell.addSubview(name)
            let btn = UIButton(frame: CGRectMake(name.bounds.size.width/2+5+WIDTH/2, WIDTH*164/375, 20, 19))
            btn.setBackgroundImage(UIImage(named: "ic_shield_yellow.png"), forState: .Normal)
            btn.setTitleColor(UIColor.yellowColor(), forState: .Normal)
            btn.setTitle("25", forState: .Normal)
            btn.titleLabel?.font = UIFont.systemFontOfSize(9)
            cell.addSubview(btn)
            
            let contant = UIButton(frame: CGRectMake(WIDTH*68/375, WIDTH*252/375, WIDTH*240/375, WIDTH*42/375))
            contant.layer.cornerRadius = WIDTH*21/375
            contant.layer.borderColor = UIColor.whiteColor().CGColor
            contant.layer.borderWidth = 1
            contant.titleLabel?.font = UIFont.systemFontOfSize(18)
            contant.setTitle("关注Ta", forState: .Normal)
            contant.addTarget(self, action: #selector(self.contactForShe), forControlEvents: .TouchUpInside)
            cell.addSubview(contant)
            
            let hospital = UILabel(frame: CGRectMake(0, 200, 150, 30))
            hospital.font = UIFont.systemFontOfSize(12)
            hospital.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
            hospital.text = "医院：北京大学第二附属医院"
            hospital.sizeToFit()
            hospital.frame = CGRectMake(WIDTH/2-hospital.bounds.size.width/2, WIDTH*221/375, hospital.bounds.size.width, hospital.bounds.size.height)
            cell.addSubview(hospital)
            
            let sax = UILabel(frame: CGRectMake(WIDTH*124/375, WIDTH*200/375, 50, 20))
            sax.font = UIFont.systemFontOfSize(12)
            sax.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
            sax.text = "性别：女"
            sax.sizeToFit()
            cell.addSubview(sax)
            let room = UILabel(frame: CGRectMake(WIDTH*144/375+sax.bounds.size.width, WIDTH*200/375, 50, 20))
            room.font = UIFont.systemFontOfSize(12)
            room.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
            room.text = "科室：外科"
            room.sizeToFit()
            cell.addSubview(room)
            
            
            
            return cell

        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer", forIndexPath: indexPath)as!UserPostTableViewCell
            cell.selectionStyle = .None
            cell.titImage.image = UIImage(named: "1.png")
            cell.titLab.text = "苏珍贞"
            cell.timeLab.text = "7分钟"
            cell.titTit.text = "各位，如何才能感冒不流鼻涕呢？"
            cell.contant.text = "你不愿意种花，你说，我不愿看见它一点点凋落。是的，为了避免结束，你避免了一切开始。"
            cell.from.text = "来自"
            cell.fromRoom.text = "外科"
            cell.zanNum.text = "2345"
            cell.comment.text = "5722"
            return cell
        }
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        
    }
    func contactForShe() {
        print("关注")
        
        
    }
    func goToNext() {
        print("分享")
        
        
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
