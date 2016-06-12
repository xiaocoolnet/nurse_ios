//
//  NewsContantViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NewsContantViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {

    let myTableView = UITableView()
    let shareArr:[String] = ["ic_pengyouquan.png","ic_wechat.png","ic_weibo.png"]
    var newsInfo :NewsInfo?
    

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.leftBarButtonItem?.title = "返回"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新闻内容"
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 3))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 3, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellIntenfer")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "titleCell")
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "zanCell")
        myTableView.registerClass(TouTiaoTableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib.init(nibName: "NewsSourceCell", bundle: nil), forCellReuseIdentifier: "sourceCell")
        myTableView.registerNib(UINib.init(nibName: "contentCell", bundle: nil), forCellReuseIdentifier: "webView")
        self.view.addSubview(myTableView)
        myTableView.separatorColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView(frame: CGRectMake(0, 0, WIDTH, 30))
        one.backgroundColor = UIColor.whiteColor()
        let lineone = UILabel(frame: CGRectMake(10, 29, WIDTH-20, 1))
        lineone.backgroundColor = COLOR
        one.addSubview(lineone)
        let tit = UILabel(frame: CGRectMake(10, 0, 100, 30))
        tit.textColor = COLOR
        tit.font = UIFont.systemFontOfSize(14)
        tit.text = "相关阅读"
        one.addSubview(tit)
        
        return one
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return  0
        }else{
            return 30
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        }else{
            return 10
        }
    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//          return  100
//        }else{
//           return 100
//        }
//       
//    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell1:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer")!
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cellIntenfer", forIndexPath: indexPath)
        cell1.selectionStyle = .None
        if indexPath.section == 0 {
            
            cell1.selectionStyle = .None
            cell1.textLabel?.numberOfLines = 0
            if indexPath.row == 0 {
                //if cell1== nil {
                   cell1 = UITableViewCell.init(style: .Default, reuseIdentifier: "cellIntenfer")
               // }
                cell1.textLabel?.text = newsInfo?.post_title
                tableView.rowHeight=40
                //cell.backgroundColor = UIColor.greenColor()
                
            }else if indexPath.row == 1 {
//                if cell==nil {
//                    <#code#>
//                }
                let cell = tableView.dequeueReusableCellWithIdentifier("sourceCell", forIndexPath: indexPath)as! NewsSourceCell
               
                cell.source.text = cell.source.text!+(newsInfo?.post_source)!
                cell.checkNum.text = "1223"
               // cell.checkNum.text = newsInfo?.post_like
                let time:Array = (newsInfo?.post_date?.componentsSeparatedByString(" "))!
                cell.createTime.text = time[0]
                //cell.backgroundColor = UIColor.redColor()
                tableView.rowHeight=30

            }else if indexPath.row == 2 {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("webView", forIndexPath: indexPath)as! contentCell
                //let url = NewsInfo_Header+(newsInfo?.id)!
               // print(url)


                let url = "http://api.interface.canka168.com/m.php/ntes/special/NewsMatter/?ids=1829"
                let requestUrl = NSURL(string:url)
                let request = NSURLRequest(URL:requestUrl!)
                cell.contentWebView.loadRequest(request)
                
                let height = Int(NSUserDefaults.standardUserDefaults().stringForKey("height")!)
                tableView.rowHeight = CGFloat(height!)
                print(height)
               
               
            }else{
                
                 let cell3 = tableView.dequeueReusableCellWithIdentifier("zanCell", forIndexPath: indexPath)
                cell3.selectionStyle = .None
                let line = UILabel(frame: CGRectMake(WIDTH*63/375, 14.5, WIDTH*250/375, 1))
                line.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
                let share = UILabel(frame: CGRectMake(WIDTH/2-30, 5, 60, 20))
                share.font = UIFont.systemFontOfSize(12)
                share.textAlignment = .Center
                share.textColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
                share.text = "分享到"
                share.backgroundColor = UIColor.whiteColor()
                for i in 0...2 {
                    let shareBtn = UIButton(frame: CGRectMake(WIDTH*(15+119*CGFloat(i))/375, WIDTH*30/375, WIDTH*108/375, WIDTH*30/375))
                    shareBtn.tag = i
                    shareBtn.layer.cornerRadius = 4
                    shareBtn.layer.borderColor = UIColor.grayColor().CGColor
                    shareBtn.layer.borderWidth = 0.5
                    shareBtn.setImage(UIImage(named: shareArr[i]), forState: .Normal)
                    shareBtn.addTarget(self, action: #selector(self.shareTheNews(_:)), forControlEvents: .TouchUpInside)
                    cell3.addSubview(shareBtn)
                    //tableView.rowHeight=250
                    
                }
                let zan = UIButton(frame: CGRectMake(WIDTH*148/375, WIDTH*80/375, WIDTH*80/375, WIDTH*80/375))
                zan.setImage(UIImage(named: "img_like.png"), forState: .Normal)
                zan.addTarget(self, action: #selector(self.zanAddNum), forControlEvents: .TouchUpInside)
                let number = UILabel()
                number.frame = CGRectMake(WIDTH/2-25, WIDTH*170/375, 50, 18)
                number.text = newsInfo?.post_like
                number.sizeToFit()
                number.font = UIFont.systemFontOfSize(12)
                number.frame = CGRectMake(WIDTH/2-number.bounds.size.width/2-8, WIDTH*170/375, number.bounds.size.width, 18)
                number.textAlignment = .Center
                number.textColor = COLOR
                let one = UILabel(frame: CGRectMake(WIDTH/2-number.bounds.size.width/2-48, WIDTH*170/375, 40, 18))
                one.font = UIFont.systemFontOfSize(12)
                one.textColor = UIColor.grayColor()
                one.textAlignment = .Right
                one.text = "已有"
               
                let two = UILabel(frame: CGRectMake(WIDTH/2+number.bounds.size.width/2-8, WIDTH*170/375, 50, 18))
                two.font = UIFont.systemFontOfSize(12)
                two.textColor = UIColor.grayColor()
                two.text = "人点赞"
                
                cell3.addSubview(one)
                cell3.addSubview(two)
                cell3.addSubview(number)
                cell3.addSubview(zan)
                cell3.addSubview(line)
                cell3.addSubview(share)
                tableView.rowHeight=200
                return cell3
            }

            
        }else{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)as!TouTiaoTableViewCell
            //cell.backgroundColor = UIColor.redColor()
            cell.selectionStyle = .None
            cell.titLab.text = "保护好你的眼睛"
            cell.conNum.text = newsInfo?.recommended
            cell.timeLab.text = "2016/05/23"
            cell.contant.text = "真的很累吗？累就对了，舒服是留给死人的！苦-才是人生 ，累-才是工作， 变-才是命运 ， 忍-才是历练，容-才是智慧 ， 静-才是修养，舍-才是得到 ，做-才是拥有！"
            cell.titImage.image = UIImage(named: "1.png")
            tableView.rowHeight=100
//            if indexPath.row == 0 {
//                print(tableView.rowHeight)
//                
//                cell.backgroundColor = UIColor.redColor()
//            }
            return cell
        }
        return cell1
        
    }
    
   
    func shareTheNews(btn:UIButton) {
        print(btn.tag)
        
        
        
    }
    func zanAddNum() {
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
