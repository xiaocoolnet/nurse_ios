//
//  MagicboxViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MagicboxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var myTableView = UITableView()
    let nameArr:[String] = ["在线翻译","汇率查询","时差查询","学历认证","天气查询","地图查询","机票查询","酒店预订","签证查询"]
    let picArr:[String] = ["ic_translate.png","ic_huilv.png","ic_shicha.png","ic_xueli.png","ic_weather.png","ic_map.png","ic_jipiao.png","ic_jiudian.png","ic_qianzhen.png"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-60)
        myTableView.backgroundColor = UIColor.whiteColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*120/355+63
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return WIDTH*281/375
        }else{
            return WIDTH*140/375
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.selectionStyle = .None
        
        if indexPath.row == 1 {
            for i in 0...8 {
                let line = UILabel(frame: CGRectMake(0, WIDTH*281/3*CGFloat(i%4)/375, WIDTH, 0.5))
                line.backgroundColor = UIColor.grayColor()
                cell.addSubview(line)
                let linel = UILabel(frame: CGRectMake(WIDTH/4*CGFloat(i), 0, 0.5, WIDTH*281/3*2/375))
                linel.backgroundColor = UIColor.grayColor()
                cell.addSubview(linel)
                let lineS = UILabel(frame: CGRectMake(WIDTH/4, WIDTH*281/3*2/375, 0.5, WIDTH*281/3/375))
                lineS.backgroundColor = UIColor.grayColor()
                cell.addSubview(lineS)

                let name = UILabel(frame: CGRectMake(WIDTH/4*CGFloat(i%4), WIDTH*(62+94*CGFloat(i/4))/375, WIDTH/4, 15))
                name.font = UIFont.systemFontOfSize(12)
                name.textAlignment = .Center
                name.text = nameArr[i]
                cell.addSubview(name)
                let kindBtn = UIButton(frame: CGRectMake(WIDTH/4*CGFloat(i%4), WIDTH*(15+94*CGFloat(i/4))/375, WIDTH/4, WIDTH/16*3*281/375))
                kindBtn.setImage(UIImage(named: picArr[i]), forState: .Normal)
                kindBtn.addTarget(self, action: #selector(MagicboxViewController.selectorCountry(_:)), forControlEvents: .TouchUpInside)
                kindBtn.tag = i
                cell.addSubview(kindBtn)
                
            }
            
        }else{
            let backImage = UIImageView(frame: CGRectMake(0, 0, WIDTH, WIDTH*140/375))
            backImage.image = UIImage(named: "5.png")
            cell.addSubview(backImage)
            
        }
        return cell
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        
        
    }

    //  功能
    func selectorCountry(btn:UIButton) {
        print(btn.tag)
        
        
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
