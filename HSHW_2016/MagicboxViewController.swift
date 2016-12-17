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
    let nameArr:[String] = ["在线翻译","汇率查询","时差查询","学历认证","天气查询","地图查询","机票查询","酒店预订"]
    let picArr:[String] = ["ic_translate.png","ic_huilv.png","ic_shicha.png","ic_xueli.png","ic_weather.png","ic_map.png","ic_jipiao.png","ic_jiudian.png","ic_qianzhen.png"]
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "出国百宝箱 " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "出国百宝箱 " + (self.title ?? "")!)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = COLOR
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-60)
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)
        myTableView.rowHeight = (WIDTH-20)*120/355+63
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
//            return WIDTH*281/375
            return WIDTH*281/3*2/375
        }else{
            return WIDTH*140/375
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        if indexPath.row == 1 {
            for i in 0...7 {
                let line = UILabel(frame: CGRect(x: 0, y: WIDTH*281/3*CGFloat(i%3)/375, width: WIDTH, height: 0.5))
                line.backgroundColor = UIColor.gray
                cell.addSubview(line)
                let linel = UILabel(frame: CGRect(x: WIDTH/4*CGFloat(i), y: 0, width: 0.5, height: WIDTH*281/3*2/375))
                linel.backgroundColor = UIColor.gray
                cell.addSubview(linel)
//                let lineS = UILabel(frame: CGRectMake(WIDTH/4, WIDTH*281/3*2/375, 0.5, WIDTH*281/3/375))
//                lineS.backgroundColor = UIColor.grayColor()
//                cell.addSubview(lineS)

                let name = UILabel(frame: CGRect(x: WIDTH/4*CGFloat(i%4), y: WIDTH*(62+94*CGFloat(i/4))/375, width: WIDTH/4, height: 15))
                name.font = UIFont.systemFont(ofSize: 12)
                name.textAlignment = .center
                name.text = nameArr[i]
                cell.addSubview(name)
                let kindBtn = UIButton(frame: CGRect(x: WIDTH/4*CGFloat(i%4), y: WIDTH*(15+94*CGFloat(i/4))/375, width: WIDTH/4, height: WIDTH/16*3*281/375))
                kindBtn.setImage(UIImage(named: picArr[i]), for: UIControlState())
                
                kindBtn.addTarget(self, action: #selector(selectorCountry), for: .touchUpInside)
                kindBtn.tag = i
                cell.addSubview(kindBtn)
                
            }
            
        }else{
            let backImage = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: WIDTH*140/375))
            backImage.image = UIImage(named: "5.png")
            cell.addSubview(backImage)
            
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        if indexPath.section == 1 {
            
        }
        
        
    }

    //  功能
    func selectorCountry(_ btn:UIButton) {
//        print(btn.tag)
        let vc = HSWebViewDetailController(nibName: "HSWebViewDetailController", bundle: nil)
        vc.navigationController?.navigationBar.isHidden = false
        if btn.tag == 0 {
//            vc.url = NSURL(string: "http://fanyi.youdao.com")
            vc.url = URL(string: "http://m.youdao.com/translate?vendor=fanyi.web")
            vc.title = "翻译"
        }else if btn.tag == 1{
            vc.url = URL(string: "http://www.boc.cn/sourcedb/whpj")
            vc.title = "汇率"
        }else if btn.tag == 2{
            vc.url = URL(string: "http://time.123cha.com")
            vc.title = "时差"
        }else if btn.tag == 3{
            vc.url = URL(string: "http://www.chsi.com.cn/xlcx")
            vc.title = "学历查询"
        }else if btn.tag == 4{
            vc.url = URL(string: "http://www.weather.com.cn")
            vc.title = "天气查询"
        }else if btn.tag == 5{
            vc.url = URL(string: "http://map.baidu.com")
            vc.title = "地图查询"
        }else if btn.tag == 6{
            vc.url = URL(string: "http://flight.qunar.com")
            vc.title = "机票查询"
        }else if btn.tag == 7{
            vc.url = URL(string: "http://m.ctrip.com/html5/")
            vc.title = "酒店"
        }else if btn.tag == 8{
            vc.url = URL(string: "http://baidu.com")
            vc.title = "签证"
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
