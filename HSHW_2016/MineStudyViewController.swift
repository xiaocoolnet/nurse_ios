//
//  MineStudyViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineStudyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let myTableView = UITableView()
    let downNum = UILabel()
    var collNum = UILabel()
    let picArr:[String] = ["ic_pen.png","ic_yuan_purple.png","ic_lifang.png","ic_folder.png"]
    let picName:[String] = ["做题记录","错题集","收藏试题","其它收藏"]
//    let picName:[String] = ["做 题 记 录","错 题 集","收 藏 试 题","其 它 收 藏"]

    var helper = HSMineHelper()
    private var fansListArray:Array<GTestExamList> = []
    private var focusListArray:Array<GTestExamList> = []
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-65)
        myTableView.backgroundColor = UIColor.clearColor()
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.separatorStyle = .None
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTableView.registerNib(UINib(nibName:"HSChartCell",bundle: nil), forCellReuseIdentifier: "chartcell")
        self.view.addSubview(myTableView)
        
        self.loadData_Exampaper()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return WIDTH*243/375
        }else if indexPath.row == 1 {
            return WIDTH*60/375
        }else{
            return WIDTH*310/375
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let chartCell = tableView.dequeueReusableCellWithIdentifier("chartcell") as! HSChartCell
            chartCell.selectionStyle = .None
//            chartCell.examDataArray = self.examDataArray
            chartCell.lineChartData = self.lineChartData
            chartCell.synAccuracy = self.synAccuracy
            return chartCell
        }
            
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            cell.backgroundColor = UIColor(red: 129/255.0, green: 0, blue: 121/255.0, alpha: 1.0)
            let line = UILabel(frame: CGRectMake(WIDTH/2-0.5, WIDTH*18/375, 1, WIDTH*25/375))
            line.backgroundColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
            cell.addSubview(line)
            let titArr:[String] = ["已经做题的次数","收藏试题(题)"]
            downNum.frame = CGRectMake(0, 7, WIDTH/2, WIDTH*25/375)
            downNum.font = UIFont.systemFontOfSize(22)
            downNum.textAlignment = .Center
            downNum.textColor = UIColor.whiteColor()
//            downNum.text = "124"
            downNum.text = String( self.fansListArray.count + self.focusListArray.count)
            cell.addSubview(downNum)
            collNum.frame = CGRectMake(WIDTH/2, WIDTH*8/375, WIDTH/2, WIDTH*25/375)
            collNum.font = UIFont.systemFontOfSize(22)
            collNum.textAlignment = .Center
            collNum.textColor = UIColor.whiteColor()
//            collNum.text = "876"
            cell.addSubview(collNum)
            for i in 0...1 {
                let tit = UILabel(frame: CGRectMake(WIDTH/2*CGFloat(i), WIDTH*34/375, WIDTH/2, 15))
                tit.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
                tit.textAlignment = .Center
                tit.font = UIFont.systemFontOfSize(12)
                tit.text = titArr[i]
                cell.addSubview(tit)
            }
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.selectionStyle = .None
            let lineH = UILabel(frame: CGRectMake(WIDTH/2-0.25, 0, 0.5, WIDTH*310/375))
            lineH.backgroundColor = GREY
            let lineL = UILabel(frame: CGRectMake(0, WIDTH*155/375-0.25, WIDTH, 0.5))
            lineL.backgroundColor = GREY
            let lineLl = UILabel(frame: CGRectMake(0, WIDTH*310/375-0.3, WIDTH, 0.5))
            lineLl.backgroundColor = GREY
            for i in 0...3 {
                let btn = UIButton(frame: CGRectMake(WIDTH/2*CGFloat(i%2), WIDTH*155/375*CGFloat(i/2), WIDTH/2, WIDTH*155/375-20))
                btn.tag = i+1
                btn.addTarget(self, action: #selector(self.studyTheKind(_:)), forControlEvents: .TouchUpInside)
                btn.setImage(UIImage(named: picArr[i]), forState: .Normal)
                
            
                cell.addSubview(btn)
                
//                let iconImg = UIImageView(frame: CGRectMake(WIDTH/2*CGFloat(i%2), WIDTH*100/375+WIDTH*155/375*CGFloat(i/2), WIDTH/2, 16))
////                iconImg.font = UIFont.systemFontOfSize(12)
////                iconImg.textColor = UIColor.grayColor()
////                iconImg.textAlignment = .Center
////                iconImg.text = picArr[i]
//                iconImg.image = UIImage(named: picArr[i])
//                cell.addSubview(iconImg)
//                
                let name = UILabel(frame: CGRectMake(WIDTH/2*CGFloat(i%2), WIDTH*100/375+WIDTH*155/375*CGFloat(i/2), WIDTH/2, 16))
                name.font = UIFont.systemFontOfSize(12)
                name.textColor = UIColor.grayColor()
                name.textAlignment = .Center
                name.text = picName[i]
                cell.addSubview(name)
                
            }
            cell.addSubview(lineH)
            cell.addSubview(lineL)
            cell.addSubview(lineLl)
            return cell
        }
    }
    func changeButton(btn: UIButton) {
        
        btn.contentHorizontalAlignment = .Center//使图片和文字水平居中显示
        btn.titleEdgeInsets = UIEdgeInsetsMake(btn.imageView!.frame.size.height ,-btn.imageView!.frame.size.width, 0.0,0.0)//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        btn.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0,0.0, -btn.titleLabel!.bounds.size.width)//图片距离右边框距离减少图片的宽度，其它不边
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
        
    }

    func studyTheKind(btn:UIButton) {
//        print(btn.tag)
        switch btn.tag {
        case 1:
            let examVC = GMyExamListViewController()
//            let examVC = GMyExamViewController()
            
            //        examVC.type = btn.tag
            self.navigationController?.pushViewController(examVC, animated: true)
        case 2:
//                    examVC.type = btn.tag
//            HSMineHelper().GetErrorExampaper("1", type: "1") { (success, response) in
                let examVC = GMyErrorViewController()
//                examVC.type = 2
//                examVC.dataSource = response as! Array<GExamInfo>
                self.navigationController?.pushViewController(examVC, animated: true)
//            }
        case 3:
            let collect = MineExaminationViewController()
            self.navigationController?.pushViewController(collect, animated: true)
        default:
            print("MineStudyViewController.swift  studyTheKind")
            let vc = CollectDetailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }

//    var examDataArray = Array<examDataModel>()
    var lineChartData:LineChartDataModel?
    var synAccuracy:Double = 0
    // 加载数据_做题记录
    func loadData_Exampaper() {
        
        helper.GetExampaper(QCLoginUserInfo.currentInfo.userid, type: "1") { (success, response) in
            
            if success {
                
                self.fansListArray = response as! Array<GTestExamList>
                self.myTableView.reloadData()
            }else{
                if String((response ?? "")!) == "no data" {
                    self.fansListArray = Array<GTestExamList>()
                    self.myTableView.reloadData()
                }else{
                    
                }
            }
        }
        
        helper.GetExampaper(QCLoginUserInfo.currentInfo.userid, type: "2") { (success, response) in
            if success {
                
                self.focusListArray = response as! Array<GTestExamList>
                self.myTableView.reloadData()
            }else{
                if String((response ?? "")!) == "no data" {
                    self.focusListArray = Array<GTestExamList>()
                    self.myTableView.reloadData()
                }else{
                    
                }
            }
        }
        
        helper.getCollectionInfoWith("2") { (success, response) in
            
            if success {
                let array = response as! Array<xamInfo>
                self.collNum.text = "\(array.count)"
            }else{
                
            }
            
        }
        
//        helper.GetMyExamData { (success, response) in
//            if success {
//                
//                self.examDataArray = response as! Array<examDataModel>
//                self.myTableView.reloadData()
//            }else{
//                if String((response ?? "")!) == "no data" {
//                    self.examDataArray = Array<examDataModel>()
//                    self.myTableView.reloadData()
//                }else{
//                    
//                }
//            }
//        }
        
        helper.GetLineChartData { (success, response) in
            if success {
                self.lineChartData = response as? LineChartDataModel
                self.myTableView.reloadData()
            }
        }
        
        helper.getSynAccuracy { (success, response) in
            if success {
                self.synAccuracy = (response as! SynAccuracyModel).rates_average
                self.myTableView.reloadData()
            }
        }
    }

}
