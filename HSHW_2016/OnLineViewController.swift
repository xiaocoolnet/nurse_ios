//
//  WordViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class OnLineViewController: UIViewController,UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var timer = Timer()
    
    let choose:[String] = ["A、消化道症状","B、胃液分析","C、胃镜检查","D、血清学检查","E、胃肠X线检查"]
    let picArr:[String] = ["btn_arrow_left.png","btn_arrow_right.png","ic_fenlei.png","btn_eye.png","btn_collect.png"]
    
    let picName:[String] = ["答题卡","答案","收藏"]
    var TitCol = UILabel()
    var TitAns = UILabel()
    var TitQues = UILabel()
    var btnOne = UIButton()
    var btnTwo = UIButton()
    var time = UILabel()
    let grayBack = UIView()
    var hear = Bool()
    var timeNow = Timer()
    var hour : Int = 0
    var minute:Int = 0
    var second:Int = 0
    var exam_time = 0 // 考试时间 单位：秒
        {
        didSet {
            hour = exam_time/60/60
            minute = exam_time/60%60
            second = exam_time%60
//            // print("考试时间   ===   \(hour):\(minute):\(second)")
        }
    }
    var dataSource = Array<ExamInfo>()
    let questBack = UIView()//答题卡视图
    let questBack_uncommit = UIView()//答题卡视图
    var over = Bool()
    var isSubmit = Bool()
    var collection = Bool()//是否收藏
    var timeText:String?
    let totalloc:Int = 5
    let rightAnswer = NSMutableArray()//正确答案
    var myChoose = Array<Int>() //已选答案
    var chooseId = Array<String>() //已选择的答案ID
//    var HSStudyNetHelper() = HSStudyNetHelper()
    var startPage = 0
    var questionCount = "100"
    var hasChooseIndex = NSMutableArray()
    let touch = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-54))
    
    let number = UILabel()
    var num = 1
    var totalNum = UILabel()
//    var isSubmit:Bool = false
    var numb = Int()
    
    var type = ""
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "学习 "+(self.title ?? "")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.title = "在线考试"
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        let rightBtn = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(takeUpTheTest))
        navigationItem.rightBarButtonItem = rightBtn
        
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "ic_back_big"), style: .done, target: self, action: #selector(clickBackBarButton))
        
        self.view.backgroundColor = UIColor.white
        self.isSubmit  = false
        collection = false
        // Do any additional setup after loading the view.
        
    }
    
    func clickBackBarButton() {
        
        if (hour != 0 || minute != 0 || second != 0) && !isSubmit {
            
            let alertController = UIAlertController(title: "时间尚未结束", message: "是否退出？", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "是", style: .cancel) { (cancelAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            
            let answerAction = UIAlertAction(title: "否", style: .default){
                (cancelAction) in
                
            }
            alertController.addAction(answerAction)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
//        else{
//            let alertController = UIAlertController(title: "尚未提交", message: "是否提交？", preferredStyle: .Alert)
//            self.presentViewController(alertController, animated: true, completion: nil)
//            
//            let cancelAction = UIAlertAction(title: "退出", style: .Cancel) { (cancelAction) in
//                self.navigationController?.popViewControllerAnimated(true)
//            }
//            alertController.addAction(cancelAction)
//            
//            let answerAction = UIAlertAction(title: "提交", style: .Default){
//                (cancelAction) in
//                self.takeUpTheTest()
//            }
//            alertController.addAction(answerAction)
//        }
    }
    
    func submit(){
//        if isSubmit == false {
            let rightBtn = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(self.takeUpTheTest))
            navigationItem.rightBarButtonItem = rightBtn
//        }else if isSubmit == true {
//            let rightBtn = UIBarButtonItem(title: "提交", style: .Done, target: self, action: nil)
//            navigationItem.rightBarButtonItem = rightBtn
//        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        if timeNow.isValid {
            timeNow.invalidate()
        }
        if over == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack_uncommit.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
                self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), for: UIControlState())
            TitQues.textColor = GREY
            over = true
        }
    }
    
    func getData(){
        let user = UserDefaults.standard
        let uid = user.string(forKey: "userid")
        let url = PARK_URL_Header+"getDaliyExamList"
        let param = [
            "userid":uid,
            "type":type,
            "count":questionCount
        ]
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.Text;
        hud?.labelText = "正在获取试题详情"
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in

            DispatchQueue.main.async(execute: {
                if(error != nil){
                    hud?.mode = MBProgressHUDMode.text;
                    hud?.labelText = error?.localizedDescription
                    hud?.hide(true, afterDelay: 1)
                }else{
                    let status = EveryDayModel(JSONDecoder(json!))
                    // print("状态是")
                    // print(status.status)
                    if(status.status == "success"){
                        
                        // print(status)
                        self.dataSource = DaliyExamList(status.data!).objectlist
                        // print(self.dataSource.count)
                        
                        hud?.hide(true, afterDelay: 1)

                        if self.dataSource.count == 0 {
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = "尚无试题"
                            hud?.hide(true, afterDelay: 1)
                            
                        }else{
                            hud?.hide(true, afterDelay: 1)
                        
                            self.createScrollerView()
                            self.AnswerView()
                            self.backBottomView()
                            self.questionCard_uncommit()
                            self.questionCard_commit()
                            self.timeDow()
                        }


                    }else{
                        //                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = status.errorData
                        //                        hud.margin = 10.0
                        //                        hud.removeFromSuperViewOnHide = true
                        hud?.hide(true, afterDelay: 1)
                    }
                }
            })
        }
    }
    
    func timeDow()
    {
        timeNow = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(OnLineViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime()
    {
        //  // print(self.scrollView.subviews)
//        let index :Int = self.pageControl.currentPage
//        var time = UILabel()
//        if self.scrollView.subviews.count==0 {
//            
//        }else{
//            time = self.view.viewWithTag(10+index) as! UILabel
//        }
        
        exam_time -= 1
        if exam_time <= 0 {
            timeNow.invalidate()
            timeOver()
        }
//        else{
//            hour = exam_time/60/60
//            minute = exam_time/60%60
//            second = exam_time%60
//        }
        
//        minute -= 1
//        
//        if minute <= 0 {
//            if hour <= 0 {
//                timeNow.invalidate()
//                timeOver()
//            }else{
//                
//                hour -= 1
//                minute = 59
//            }
//        }
        
        time.text = String.init(format: "%02d:%02d:%02d", hour,minute,second)
        self.timeText = time.text


//        if hour>=0 {
//            if (minute <= 0)
//            {
//                minute = 59
//                hour -= 1
//                
//            }
//            // print(time.text)
//            if hour == -1 {
//                hour = 2
//                minute = 59
//                
//                time.text = "0"+"\(hour)"+":"+"\(minute)"
//                self.timeText = time.text
//                timeNow.invalidate()
//            }
//            time.text = "0"+"\(hour)"+":"+"\(minute)"
//            if hour<10 {
//                
//                if minute<10 {
//                    time.text = "0"+"\(hour)"+":"+"0"+"\(minute)"
//                    self.timeText = time.text
//                    
//                }
//            }else{
//                
//                time.text = "\(hour)"+":"+"\(minute)"
//                self.timeText = time.text
//                
//            }
//        }
    }
    
    func timeOver() {
        // print("提交")
        self.isSubmit = true
        var idStr = ""
        var answerStr = ""
        self.num = 2
        //        self.submit()
        //        self.navigationItem.rightBarButtonItem
        
        if myChoose.count > 0 {
            
            for i in 0...myChoose.count-1 {
                let exer = dataSource[i] 
                idStr += (i==0 ? exer.id! : ","+exer.id!)
            }
            
            for i in 0...myChoose.count-1 {
                answerStr += (i==0 ? chooseId[i] : ","+chooseId[i])
            }
        }else{
//            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            hud.mode = MBProgressHUDMode.Text;
//            hud.labelText = "时间到"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(true, afterDelay: 1)
            
            let alertController = UIAlertController(title: "时间到", message: "尚未答题", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let cancelAction = UIAlertAction(title: "退出", style: .cancel) { (cancelAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            
            let answerAction = UIAlertAction(title: "答案解析", style: .default){
                (cancelAction) in
                
                DispatchQueue.main.async(execute: {
                    
                    //                            let btn = UIButton()
                    //                            btn.tag = 4
                    self.bottomBtnClick(self.btnTwo)
                    
                    let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
                    hud?.mode = MBProgressHUDMode.text
                    hud?.labelText = "点击 < 答案 > 按钮即可查看答案"
                    hud?.margin = 10.0
                    hud?.removeFromSuperViewOnHide = true
                    hud?.hide(true, afterDelay: 1.5)
                })
            }
            alertController.addAction(answerAction)

            return
        }
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.mode = MBProgressHUDMode.;
        hud?.labelText = "时间到"
        hud?.detailsLabelText = "正在提交..."
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        HSStudyNetHelper.sendtestAnswerByType("2", count: String(dataSource.count), questionlist: idStr, answerlist: answerStr) { (success, response) in
            
            if(success){
                DispatchQueue.main.async(execute: {
                    hud?.hide(true)
                    self.navigationItem.rightBarButtonItem = nil
                    let result = response as! ScoreDataModel
                    
                    var time: TimeInterval = 0.0
                    if result.event != "" {
                        self.showScoreTips(result.event, score: result.score)
                        time = 3.0
                    }
                    
                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        
                        let alertController = UIAlertController(title: "提交成功", message: "得分\(result.allscore)", preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        
                        let cancelAction = UIAlertAction(title: "退出", style: .cancel) { (cancelAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(cancelAction)
                        
                        let answerAction = UIAlertAction(title: "答案解析", style: .default){
                            (cancelAction) in
                            
                            DispatchQueue.main.async(execute: {
                                
                                //                            let btn = UIButton()
                                //                            btn.tag = 4
                                self.bottomBtnClick(self.btnTwo)
                                
                                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
                                hud?.mode = MBProgressHUDMode.text
                                hud?.labelText = "点击 < 答案 > 按钮即可查看答案"
                                hud?.margin = 10.0
                                hud?.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 1.5)
                            })
                        }
                        alertController.addAction(answerAction)
                    }
                })
            }else{
                DispatchQueue.main.async(execute: {
                    
                    hud?.hide(false)
                    
                    let hud2 = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud2?.mode = MBProgressHUDMode.text;
                    hud2?.labelText = "提交失败，请稍后再试"
                    hud2?.margin = 10.0
                    hud2?.removeFromSuperViewOnHide = true
                    hud2?.hide(true, afterDelay: 2)
                })
            }
            // print(response)
        }
    }
    

    // MARK: 显示积分提示
    func showScoreTips(_ name:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.opacity = 0.3
        hud?.margin = 10
        hud?.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud?.mode = .customView
        let customView = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH*0.8, height: WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*30/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .left
        titLab.font = UIFont.systemFont(ofSize: 16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*100/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .left
        scoreLab.font = UIFont.systemFont(ofSize: 24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRect(
            x: scoreLab.frame.maxX+5,
            y: customView.frame.height*100/238,
            width: customView.frame.width-scoreLab.frame.maxX-5-customView.frame.width*13/537,
            height: customView.frame.height*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .center
        jifenLab.font = UIFont.systemFont(ofSize: 16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud?.customView = customView
        hud?.hide(true, afterDelay: 3)
    }



    // MARK: 答题卡视图
    func questionCard_uncommit() {
        // print(self.pageControl.currentPage)
        // print(self.myChoose)
        // print(self.rightAnswer)
        
        let labelArray = ["已答","未答","当前题"]
        questBack_uncommit.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
        questBack_uncommit.backgroundColor = UIColor.white
        over = true
        var window = UIWindow()
        window = ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(questBack_uncommit)
        let big = UIView(frame: CGRect(x: 0, y: 44, width: WIDTH, height: HEIGHT-163))
        big.backgroundColor = COLOR
        questBack_uncommit.addSubview(big)
        let smart = UIScrollView(frame: CGRect(x: 10, y: 10, width: WIDTH-20, height: HEIGHT-183))
        smart.backgroundColor = UIColor.white
        smart.layer.cornerRadius = 5
        big.addSubview(smart)
        for i in 0..<3 {
            let view = UIView()
            view.frame = CGRect(x: WIDTH/3 * CGFloat(i), y: 5, width: WIDTH/3, height: WIDTH*30/375)
            let circleView = UIView()
//            circleView.frame = CGRectMake(10, 10, WIDTH*10/375, WIDTH*10/375)
            circleView.frame = CGRect(x: (view.frame.size.width-WIDTH*110/375)/2.0, y: 10, width: WIDTH*10/375, height: WIDTH*10/375)
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            let label = UILabel()
            label.frame = CGRect(x: circleView.frame.origin.x+circleView.frame.size.width+3, y: 5, width: WIDTH*100/375, height: WIDTH*20/375)
            label.text = labelArray[i]
            if i==0 {
                circleView.backgroundColor = UIColor.green
            }else if i==1{
                circleView.backgroundColor = UIColor.gray
            }else{
                circleView.backgroundColor = UIColor.purple
            }
            view.addSubview(circleView)
            view.addSubview(label)
            questBack_uncommit.addSubview(view)
        }
        let cirecleArray = NSMutableArray()
        let smartWidth = smart.frame.size.width
        let margin:CGFloat = (smartWidth - CGFloat(self.totalloc) * smartWidth/CGFloat(self.totalloc))/(CGFloat(self.totalloc)+1);
        for j in 0 ..< self.dataSource.count {
            // print(self.myChoose)
            // print(self.rightAnswer)
            let row:Int = j / totalloc;//行号
            let loc:Int = j % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+smartWidth/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+90) * CGFloat(row)
            let view = UIView()
            view.frame = CGRect(x: appviewx, y: appviewy, width: smartWidth/CGFloat(self.totalloc), height: WIDTH*90/375)
            let number = UIButton(type: .custom)
            let tihao = j+1
            number.tag = tihao
            number.addTarget(self, action: #selector(answerBtnClicked), for: .touchUpInside)
            number.setTitle(String(tihao), for: UIControlState())
            number.frame = CGRect(x: 10, y: 10, width: view.frame.size.width-30, height: view.frame.size.width-30)
            number.setTitleColor(UIColor.black, for: UIControlState())
            number.layer.cornerRadius = 0.5 * (view.frame.size.width-30)
            number.clipsToBounds = true
            
            if j==self.pageControl.currentPage {
                number.backgroundColor = UIColor.purple
                number.setTitleColor(UIColor.white, for: UIControlState())
            }
            
            let circleView = UIView()
            circleView.frame = CGRect(x: 0, y: number.frame.origin.y+number.frame.size.height+10, width: WIDTH*10/375, height: WIDTH*10/375)
            circleView.center.x = number.center.x
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            circleView.backgroundColor = UIColor.gray
            cirecleArray.add(circleView)
            view.addSubview(number)
            view.addSubview(circleView)
            smart.addSubview(view)
            smart.bounces = false
            smart.contentSize = CGSize(width: smart.frame.width,height: view.frame.maxY)
        }
        
        if myChoose.count != 0 {
            for i in self.myChoose.indices.suffix(from: 0) {
                let myCircleView = cirecleArray[i] as! UIView
                if Int(self.myChoose[i])==Int(self.rightAnswer[i] as! NSNumber) {
                    myCircleView.backgroundColor =  UIColor.green
                }else if Int(self.myChoose[i]) != Int(self.rightAnswer[i] as! NSNumber)&&Int(self.myChoose[i]) != 0 {
                    myCircleView.backgroundColor = UIColor.green
//                    myCircleView.backgroundColor = UIColor.redColor()
                }else if Int(self.myChoose[i]) != Int(self.rightAnswer[i] as! NSNumber)&&Int(self.myChoose[i]) == 0{
                    myCircleView.backgroundColor = UIColor.gray
                }
            }
        }
        
    }
    func questionCard_commit() {
        // print(self.pageControl.currentPage)
        // print(self.myChoose)
        // print(self.rightAnswer)
        
        let labelArray = ["答对","答错","未答","当前题"]
        questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
        questBack.backgroundColor = UIColor.white
        over = true
        var window = UIWindow()
        window = ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(questBack)
        let big = UIView(frame: CGRect(x: 0, y: 44, width: WIDTH, height: HEIGHT-163))
        big.backgroundColor = COLOR
        questBack.addSubview(big)
        let smart = UIScrollView(frame: CGRect(x: 10, y: 10, width: WIDTH-20, height: HEIGHT-183))
        smart.backgroundColor = UIColor.white
        smart.layer.cornerRadius = 5
        big.addSubview(smart)
        for i in 0..<4 {
            let view = UIView()
            view.frame = CGRect(x: WIDTH/4 * CGFloat(i), y: 5, width: WIDTH/4, height: WIDTH*30/375)
            let circleView = UIView()
            circleView.frame = CGRect(x: 10, y: 10, width: WIDTH*10/375, height: WIDTH*10/375)
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            let label = UILabel()
            label.frame = CGRect(x: circleView.frame.origin.x+circleView.frame.size.width+3, y: 5, width: WIDTH*100/375, height: WIDTH*20/375)
            label.text = labelArray[i]
            if i==0 {
                circleView.backgroundColor = UIColor.green
            }else if i==1{
                circleView.backgroundColor = UIColor.red
            }else if i==2{
                circleView.backgroundColor = UIColor.gray
            }else{
                circleView.backgroundColor = UIColor.purple
            }
            view.addSubview(circleView)
            view.addSubview(label)
            questBack.addSubview(view)
        }
        let cirecleArray = NSMutableArray()
        let smartWidth = smart.frame.size.width
        let margin:CGFloat = (smartWidth - CGFloat(self.totalloc) * smartWidth/CGFloat(self.totalloc))/(CGFloat(self.totalloc)+1);
        for j in 0 ..< self.dataSource.count {
            // print(self.myChoose)
            // print(self.rightAnswer)
            let row:Int = j / totalloc;//行号
            let loc:Int = j % totalloc;//列号
            let appviewx:CGFloat = margin+(margin+smartWidth/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+90) * CGFloat(row)
            let view = UIView()
            view.frame = CGRect(x: appviewx, y: appviewy, width: smartWidth/CGFloat(self.totalloc), height: WIDTH*90/375)
            let number = UIButton(type: .custom)
            let tihao = j+1
            number.tag = tihao
            number.addTarget(self, action: #selector(answerBtnClicked), for: .touchUpInside)
            number.setTitle(String(tihao), for: UIControlState())
            number.frame = CGRect(x: 10, y: 10, width: view.frame.size.width-30, height: view.frame.size.width-30)
            number.setTitleColor(UIColor.black, for: UIControlState())
            number.layer.cornerRadius = 0.5 * (view.frame.size.width-30)
            number.clipsToBounds = true
            
            if j==self.pageControl.currentPage {
                number.backgroundColor = UIColor.purple
                number.setTitleColor(UIColor.white, for: UIControlState())
            }
            
            let circleView = UIView()
            circleView.frame = CGRect(x: 0, y: number.frame.origin.y+number.frame.size.height+10, width: WIDTH*10/375, height: WIDTH*10/375)
            circleView.center.x = number.center.x
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            circleView.backgroundColor = UIColor.gray
            cirecleArray.add(circleView)
            view.addSubview(number)
            view.addSubview(circleView)
            smart.addSubview(view)
            smart.bounces = false
            smart.contentSize = CGSize(width: smart.frame.width,height: view.frame.maxY)
        }
        
        if myChoose.count != 0 {
            for i in self.myChoose.indices.suffix(from: 0) {
                let myCircleView = cirecleArray[i] as! UIView
                if Int(self.myChoose[i])==Int(self.rightAnswer[i] as! NSNumber) {
                    myCircleView.backgroundColor =  UIColor.green
                }else if Int(self.myChoose[i]) != Int(self.rightAnswer[i] as! NSNumber)&&Int(self.myChoose[i]) != 0 {
                    myCircleView.backgroundColor = UIColor.red
                }else if Int(self.myChoose[i]) != Int(self.rightAnswer[i] as! NSNumber)&&Int(self.myChoose[i]) == 0{
                    myCircleView.backgroundColor = UIColor.gray
                }
            }
        }
        
    }
    
    let backeView = UIView()
    // MARK:   答案视图
    func AnswerView() {
        //将正确答案放在一个数组中
        let examInfo = self.dataSource[self.pageControl.currentPage]
        
        if rightAnswer.count <= pageControl.currentPage {
            for _ in rightAnswer.count-1...pageControl.currentPage {
                rightAnswer.add(9)
            }
        }
        
        for i in 0 ..< examInfo.answerlist.count {
            let answerInfo = examInfo.answerlist[i]
            if answerInfo.isanswer == "1" {
                rightAnswer[pageControl.currentPage] = i+1
                // print(answerInfo.answer_title)
                // print(answerInfo.isanswer)
                break
            }
        }
        grayBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-54)
        grayBack.backgroundColor = UIColor.clear
        hear = true
        var window = UIWindow()
        window = ((UIApplication.shared.delegate?.window)!)!
        window.addSubview(grayBack)
        
        touch.backgroundColor = UIColor.gray
        touch.alpha = 0.4
        touch.addTarget(self, action: #selector(self.touchUp), for: .touchUpInside)
        grayBack.addSubview(touch)
        
        for view in backeView.subviews {
            view.removeFromSuperview()
        }
        backeView.frame = CGRect(x: 0, y: HEIGHT-54-WIDTH*260/375, width: WIDTH, height: WIDTH*260/375)
        backeView.backgroundColor = UIColor.white
        grayBack.addSubview(backeView)
        
        let line = UILabel(frame: CGRect(x: 10, y: WIDTH*48/375, width: WIDTH-20, height: 2))
        line.backgroundColor = COLOR
        backeView.addSubview(line)
        
        let answer = UILabel(frame: CGRect(x: WIDTH/2-40, y: WIDTH*10/375, width: 80, height: WIDTH*38/375))
        answer.font = UIFont.systemFont(ofSize: 18)
        answer.textColor = COLOR
        answer.textAlignment = .center
        answer.text = "参考答案"
        backeView.addSubview(answer)
        let labelArray = ["您的答案","正确答案","题目难度"]
        for i in 0..<3 {
            let view = UIView()
            //  view.backgroundColor = UIColor.redColor()
            view.frame = CGRect(x: WIDTH*60/375+(WIDTH*90/375)*CGFloat(i), y: line.frame.origin.y+12, width: WIDTH*80/375, height: WIDTH*70/375)
            backeView.addSubview(view)
            let answer = UILabel()
            answer.font = UIFont.systemFont(ofSize: 25)
            answer.textAlignment = NSTextAlignment.center
            answer.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height-30)
            answer.textColor = COLOR
            let label = UILabel()
            label.frame = CGRect(x: 0, y: view.frame.size.height-30, width: view.frame.size.width, height: 20)
            label.textColor = UIColor.gray
            label.text = labelArray[i]
            if i==0 {
                // print(self.myChoose)
                // print(self.myChoose.count)
                // print(self.pageControl.currentPage)
                
                if self.myChoose.count == 0 || self.pageControl.currentPage+1>self.myChoose.count{
                    answer.text = " "
                }else{
                    let isanswer = 64 + myChoose[self.pageControl.currentPage]
                    let asc:UniChar = UInt16(isanswer)
                    let chara:Character = Character(UnicodeScalar(asc)!)
                    var string = ""
                    string.append(chara)
                    answer.text = string
                }
                //answer.text = self.myChoose[self.pageControl.currentPage] as! String
            }else if i==1{
                // print(self.rightAnswer)
                // print(self.pageControl.currentPage)
                // print(self.rightAnswer[self.pageControl.currentPage])
                let isanswer = 64 + (self.rightAnswer[self.pageControl.currentPage] as! Int)
                let asc:UniChar = UInt16(isanswer)
                let chara:Character = Character(UnicodeScalar(asc)!)
                var string = ""
                string.append(chara)
                answer.text = string
            }else{
                var difficultyValue = Int()
                let examInfo = self.dataSource[self.pageControl.currentPage]
                // print(examInfo)
                difficultyValue = Int(examInfo.post_difficulty!)!
                // print(difficultyValue)
                let imageArray = NSMutableArray()
                // let imageView = UIImageView()
                for i in 0..<3 {
                    let imageView = UIImageView()
                    imageView.frame = CGRect(x: answer.frame.size.width/2-answer.frame.size.height/2+CGFloat(i)*answer.frame.size.height/3, y: 5, width: answer.frame.size.height/3, height: answer.frame.size.height/3)
                    imageView.image = UIImage(named:"ic_collect" )
                    answer.addSubview(imageView)
                    imageArray.add(imageView)
                }
                for i in 0..<2 {
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRect(x: answer.frame.size.width/2-answer.frame.size.height/2+answer.frame.size.height/6+CGFloat(i)*answer.frame.size.height/3, y: 5+answer.frame.size.height/3, width: answer.frame.size.height/3, height: answer.frame.size.height/3)
                    imageView1.image = UIImage(named:"ic_collect" )
                    answer.addSubview(imageView1)
                    imageArray.add(imageView1)
                }
                for i in 0..<difficultyValue {
                    let imageView = imageArray[i] as! UIImageView
                    imageView.image = UIImage(named:"ic_collect_sel")
                }
            }
            view.addSubview(answer)
            view.addSubview(label)
        }
        
        //答案解析
        let analysis = UILabel()
        analysis.frame = CGRect(x: 10, y: line.frame.origin.y+12+WIDTH*70/375+10, width: WIDTH*100/375, height: WIDTH*20/375)
        analysis.text = "答案解析:"
        analysis.textColor = COLOR
        //      analysis.backgroundColor = UIColor.redColor()
        backeView.addSubview(analysis)
        let analysisContent = UILabel()
        analysisContent.textColor = UIColor.gray
        analysisContent.text = examInfo.post_description
        analysisContent.numberOfLines = 0
        analysisContent.font = UIFont.systemFont(ofSize: 15)
        //      analysisContent.backgroundColor = UIColor.greenColor()
        let height: CGFloat = calculateHeight(examInfo.post_description!, size: 15, width:backeView.frame.size.width-20)
        // print(height)
        analysisContent.frame = CGRect(x: 10, y: analysis.frame.size.height+analysis.frame.origin.y, width: backeView.frame.size.width-20, height: height)
        if height > WIDTH*20/375 {
            backeView.frame = CGRect(x: 0, y: HEIGHT-54-WIDTH*260/375-(height-WIDTH*20/375), width: WIDTH, height: WIDTH*260/375+(height-WIDTH*20/375))
        }
        backeView.addSubview(analysisContent)
    }
    // MARK:    底部视图
    func backBottomView() {
        let backView = UIView(frame: CGRect(x: 0, y: HEIGHT-118, width: WIDTH, height: 54))
        backView.backgroundColor = UIColor.white
        self.view.addSubview(backView)
        
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        backView.addSubview(line)
        
        let left = UIButton(frame: CGRect(x: 10, y: 13, width: 28, height: 28))
        left.setBackgroundImage(UIImage(named: picArr[0]), for: UIControlState())
        left.tag = 1
        left.addTarget(self, action: #selector(self.bottomBtnClick(_:)), for: .touchUpInside)
        backView.addSubview(left)
        let right = UIButton(frame: CGRect(x: WIDTH-38, y: 13, width: 28, height: 28))
        right.setBackgroundImage(UIImage(named: picArr[1]), for: UIControlState())
        right.tag = 2
        right.addTarget(self, action: #selector(self.bottomBtnClick(_:)), for: .touchUpInside)
        backView.addSubview(right)
        for i in 0...2 {
            let btn = UIButton(frame: CGRect(x: WIDTH/5*1.5+CGFloat(i)*(WIDTH/5-11), y: 9, width: 22, height: 22))
            btn.tag = i+3
            btn.setImage(UIImage(named: picArr[i+2]), for: UIControlState())
            btn.addTarget(self, action: #selector(self.bottomBtnClick(_:)), for: .touchUpInside)
            backView.addSubview(btn)
            if btn.tag == 3 {
                btnOne = btn
            }
            if btn.tag == 4 {
                btnTwo = btn
            }
            let tit = UILabel(frame: CGRect(x: WIDTH/5*1.5+CGFloat(i)*(WIDTH/5-11)-4, y: 35, width: 30, height: 10))
            tit.font = UIFont.systemFont(ofSize: 10)
            tit.textColor = GREY
            tit.tag = i+3
            tit.textAlignment = .center
            tit.text = picName[i]
            backView.addSubview(tit)
            if tit.tag == 4 {
                TitAns = tit
            }
            if tit.tag == 3 {
                TitQues = tit
            }
            
            if tit.tag == 5 {
                TitCol = tit
            }
        }
    }
    // MARK: 答题区
    func createScrollerView() {
        
        let bgView = UIView(frame: CGRect(x: 0, y: 1,width: WIDTH, height: HEIGHT-119))
        self.view.addSubview(bgView)

        let backGound = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH,height: 44))
        
        let dan = UIImageView(frame: CGRect(x: 10, y: 16, width: 12, height: 12))
        dan.image = UIImage(named: "ic_choice.png")
        backGound.addSubview(dan)
        let danxuan = UILabel(frame: CGRect(x: 24, y: 12.5, width: 40, height: 17))
        danxuan.font = UIFont.systemFont(ofSize: 18)
        danxuan.text = "单选题"
        danxuan.sizeToFit()
        backGound.addSubview(danxuan)
//        let tit = UILabel(frame: CGRectMake(28+danxuan.bounds.size.width, 18.5, 40, 12))
//        tit.font = UIFont.systemFontOfSize(12)
//        tit.textColor = GREY
//        tit.text = "（A1，2分）"
//        tit.sizeToFit()
//        backGound.addSubview(tit)
        time.frame = CGRect(x: WIDTH-75, y: 16, width: 75, height: 12)
//        time.tag = 10+i
        //time.backgroundColor = UIColor.redColor()
        time.font = UIFont.systemFont(ofSize: 14)
        //time.textAlignment = .Right
        time.textColor = COLOR
        time.text = String.init(format: "%02d:%02d:%02d", hour,minute,second)
        //time.sizeToFit()
        backGound.addSubview(time)
        let timelab = UILabel(frame: CGRect(x: time.frame.minX-75, y: 15, width: 71, height: 12))
        // let timelab = UILabel(frame: CGRectMake(WIDTH-time.bounds.size.width-83, 15, 71, 12))
        // timelab.backgroundColor = UIColor.greenColor()
        timelab.font = UIFont.systemFont(ofSize: 12)
        timelab.textColor = GREY
        timelab.text = "剩余答题时间："
        timelab.textAlignment = .right
        timelab.sizeToFit()
        timelab.frame.origin.x = time.frame.minX-timelab.frame.size.width
        timelab.center.y = time.center.y
        backGound.addSubview(timelab)
        
        bgView.addSubview(backGound)
        
        let backView = UIImageView()
        backView.isUserInteractionEnabled = true
        
        backView.frame = CGRect(x: 0, y: 45, width: WIDTH, height: HEIGHT-64-49-1-44)//背景
        //            backView.backgroundColor = COLOR
        
        backView.image = UIImage.init(named: "ic_exam_backgroundImage")
//        backView.tag = i+1
        bgView.addSubview(backView)
        
        scrollView.frame = CGRect(x: 0, y: 45,width: WIDTH, height: HEIGHT-64-49-1-44)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        // print(self.dataSource.count)
        for  i in 0 ..< self.dataSource.count {
            let examInfo = self.dataSource[i]
            let contentScrollView :UIScrollView = UIScrollView.init()
            contentScrollView.frame = CGRect(x: CGFloat(i)*WIDTH+10, y: 10, width: WIDTH-20, height: HEIGHT-64-49-1-44-10-50)
            contentScrollView.backgroundColor = UIColor.white
            contentScrollView.layer.cornerRadius = 5
 
//            let back = UIView(frame: CGRectMake(WIDTH+10, 54, WIDTH-20, HEIGHT-221))//白色答题区域
//            back.backgroundColor = UIColor.whiteColor()
//            back.layer.cornerRadius = 5
            
            //问题
            let question = UILabel(frame: CGRect(x: WIDTH*20/375, y: WIDTH*15/375, width: contentScrollView.bounds.size.width-WIDTH*38/375, height: 40))
            question.numberOfLines = 0
            question.textAlignment = .natural
            question.font = UIFont.systemFont(ofSize: 14)
            question.text = examInfo.post_title
            question.sizeToFit()
            contentScrollView.addSubview(question)
            //back.addSubview(question)
            //选项列表
            let heightArray = NSMutableArray()
            for j in 0 ..< examInfo.answerlist.count {
                var string = ""
                let ascInt:Int = 65+j
                let asc:UniChar = UInt16(ascInt)
                let chara:Character = Character(UnicodeScalar(asc)!)
                string.append(chara)
                
                let btn = UIButton(type: .custom)
                let answerInfo = examInfo.answerlist[j]
                let height:CGFloat = calculateHeight(string+"、"+answerInfo.answer_title, size: 17, width: WIDTH*314/375-10)
                if j>0 {
                    // print(j)
                    // print(heightArray)
                    btn.frame =  CGRect(
                        x: WIDTH*21/375,
                        y: 10+(CGFloat(heightArray[j-1] as! NSNumber))*CGFloat(1),
                        width: WIDTH*314/375,
                        height: height+10)
                }else{
                    btn.frame = CGRect(
                        x: WIDTH*21/375,
                        y: 5+question.frame.size.height+question.frame.origin.y+(15+WIDTH*46/375)*CGFloat(0),
                        width: WIDTH*314/375,
                        height: height+10)
                }
                
                btn.setTitle(string+"、"+answerInfo.answer_title, for: UIControlState())
                btn.sizeToFit()
                heightArray.add(btn.frame.size.height+btn.frame.origin.y)

                btn.backgroundColor = UIColor.cyan
                
                //选项按钮
                btn.tag = j+1
                btn.layer.cornerRadius = 10
                btn.layer.borderColor = COLOR.cgColor
                btn.layer.borderWidth = 1
                btn.addTarget(self, action: #selector(self.pleaseChooseOne(_:)), for: .touchUpInside)
                btn.setTitleColor(COLOR, for: UIControlState())
                btn.contentHorizontalAlignment = .left;
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 17)
                btn.titleLabel?.numberOfLines = 0
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                //back.addSubview(btn)
                
                contentScrollView.addSubview(btn)
                //根据题号赋值
                contentScrollView.tag = i+110
                
                var AllHeight = CGFloat()
                AllHeight = CGFloat(heightArray.lastObject as! NSNumber)
                contentScrollView.contentSize = CGSize(width: 0, height: AllHeight+10*CGFloat(examInfo.answerlist.count-1))
            }
//            scrollView.addSubview(backGound)
//            scrollView.addSubview(backView)
            scrollView.addSubview(contentScrollView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(self.dataSource.count)*self.view.frame.size.width, height: 0)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        bgView.addSubview(scrollView)
        let ques = UILabel(frame: CGRect(x: WIDTH/2-80, y: HEIGHT-146, width: 80, height: 12))
        ques.font = UIFont.systemFont(ofSize: 12)
        ques.textAlignment = .right
        ques.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
        ques.text = "考试进度："
        self.view.addSubview(ques)
        number.frame = CGRect(x: WIDTH/2+5, y: HEIGHT-150, width: 50, height: 14)
        number.font = UIFont.systemFont(ofSize: 16)
        number.textColor = UIColor.yellow
        number.text = "1"
//        number.text = String(scrollView.contentOffset.x/scrollView.frame.size.width)
        number.sizeToFit()
        self.view.addSubview(number)
        totalNum.frame = CGRect(x: WIDTH/2+5+number.bounds.size.width, y: HEIGHT-150, width: 30, height: 14)
        totalNum.textColor = UIColor.white
        totalNum.font = UIFont.systemFont(ofSize: 16)
        //        String(self.dataSource.count)
        totalNum.text = " /"+String(self.dataSource.count)
        totalNum.sizeToFit()
        self.view.addSubview(totalNum)
        
        pageControl.frame = CGRect(x: 0, y: HEIGHT-167, width: WIDTH, height: 48)
        pageControl.pageIndicatorTintColor = UIColor.red
        //        pageControl.addTarget(self, action: #selector(self.pageContorllerNumber(_:)), forControlEvents: .TouchUpInside)
        pageControl.numberOfPages = self.dataSource.count
        pageControl.currentPage = 0

    }
    
    func pageContorllerNumber(_ pageControl:UIPageControl) {
        let offSetX:CGFloat = CGFloat(pageControl.currentPage) * WIDTH
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    func dismissCard(){
        if over == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack.frame = CGRect(x: 0, y: 65, width: WIDTH, height: HEIGHT-119)
                self.grayBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-54)
                self.hear = true
            })
            btnOne.setImage(UIImage(named: "ic_fenlei_sel.png"), for: UIControlState())
            TitQues.textColor = COLOR
            over = false
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), for: UIControlState())
            TitQues.textColor = GREY
            over = true
        }
    }
    func dismissCard_uncommit(){
        if over == true {
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack_uncommit.frame = CGRect(x: 0, y: 65, width: WIDTH, height: HEIGHT-119)
                self.grayBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-54)
                self.hear = true
            })
            btnOne.setImage(UIImage(named: "ic_fenlei_sel.png"), for: UIControlState())
            TitQues.textColor = COLOR
            over = false
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack_uncommit.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), for: UIControlState())
            TitQues.textColor = GREY
            over = true
        }
    }
//     MARK:   底部按钮  
    func bottomBtnClick(_ btn:UIButton) {
        // print(btn.tag)
        if btn.tag == 1 {
            self.pageControl.currentPage -= 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            self.AnswerView()
            number.text = "\(self.pageControl.currentPage+1)"
            number.sizeToFit()
            totalNum.frame.origin.x = WIDTH/2+5+number.bounds.size.width
//            numb -= 1
//            let offSetX:CGFloat = CGFloat(numb) * WIDTH
//            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
        }else if btn.tag == 2 {
            self.pageControl.currentPage += 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            number.text = "\(self.pageControl.currentPage+1)"
            number.sizeToFit()
            totalNum.frame.origin.x = WIDTH/2+5+number.bounds.size.width
            self.AnswerView()
        }else if btn.tag == 3 {
            if self.num == 2 {
                dismissCard()
            }else{
                dismissCard_uncommit()
                
            }
        }else if btn.tag == 4{
            
            if self.num != 2 {
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.mode = MBProgressHUDMode.text;
                hud?.labelText = "没交卷不可以看答案哦"
                hud?.margin = 10.0
                hud?.removeFromSuperViewOnHide = true
                hud?.hide(true, afterDelay: 1)
                
                return
            }
            if hear == true {
                AnswerView()
                UIView.animate(withDuration: 0.3, animations: {
                    self.grayBack.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-54)
                    self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
                    self.questBack_uncommit.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)

                    if btn.tag == 4 {
                        self.btnOne.setImage(UIImage(named: self.picArr[2]), for: UIControlState())
                        self.TitQues.textColor = GREY
                    }
                    self.over = true
                })
                btn.setImage(UIImage(named: "btn_eye_sel.png"), for: UIControlState())
                TitAns.textColor = COLOR
                hear = false
            }else{
                
                UIView.animate(withDuration: 0.3, animations: {
                    
                    self.grayBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-54)
                    
                    }, completion: { (bool) in
                        if bool {
                            for obj in self.grayBack.subviews {
                                obj.removeFromSuperview()
                            }
                        }
                })
                
//                UIView.animateWithDuration(0.3, animations: {
//                    self.grayBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-54)
//                })
                btn.setImage(UIImage(named: picArr[3]), for: UIControlState())
                TitAns.textColor = GREY
                hear = true
            }
        }else if btn.tag == 5 {
            
            // MARK:要求登录
            if !requiredLogin(self.navigationController!, previousViewController: self, hiddenNavigationBar: false) {
                return
            }
            
            // print(collection)
            // print("收藏")
            let examInfo = self.dataSource[self.pageControl.currentPage]
            let user = UserDefaults.standard
            let uid = user.string(forKey: "userid")
            // print(uid)
            if uid==nil {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc  = mainStoryboard.instantiateViewController(withIdentifier: "Login")
                self.navigationController?.pushViewController(vc, animated: true)
                btn.setImage(UIImage(named: picArr[4]), for: UIControlState())
                TitCol.textColor = GREY
                collection = false
            }else if collection == false {
                
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//                hud.mode = MBProgressHUDMode.Text;
//                hud.labelText = status.errorData
                hud?.margin = 10.0
                hud?.removeFromSuperViewOnHide = true
                
                let url = PARK_URL_Header+"addfavorite"
                let param = [
                    
                    "refid":examInfo.id,
                    "type":"2",
                    "userid":uid,
                    "title":examInfo.post_title,
                    "description":examInfo.post_description
                ];
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in

                    // print(request)
                    if(error != nil){
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "收藏失败"
                        hud?.hide(true, afterDelay: 0.5)
                    }else{
                        let status = Http(JSONDecoder(json!))
                        // print("状态是")
                        // print(status.status)
                        DispatchQueue.main.async(execute: {
                            if(status.status == "error"){
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = status.errorData
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 0.5)
                            }
                            if(status.status == "success"){
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = "收藏成功"
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 0.5)
                                btn.setImage(UIImage(named: "btn_collect_sel.png"), for: UIControlState())
                                self.TitCol.textColor = COLOR
                                self.collection = true
                                // print(status.data)
                            }
                        })
                    }
                }
            }else{
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud?.margin = 10.0
                hud?.removeFromSuperViewOnHide = true
                let url = PARK_URL_Header+"cancelfavorite"
                let param = [
                    "refid":examInfo.id,
                    "type":"2",
                    "userid":uid
                ];
                
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as? [String:String] as [String : AnyObject]?) { (json, error) in

                    // print(request)
                    if(error != nil){
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "取消收藏失败"
                        hud?.hide(true, afterDelay: 0.5)
                    }else{
                        let status = Http(JSONDecoder(json!))
                        // print("状态是")
                        // print(status.status)
                        DispatchQueue.main.async(execute: {
                            if(status.status == "error"){
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = status.errorData
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 0.5)
                            }
                            if(status.status == "success"){
//                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud?.mode = MBProgressHUDMode.text;
                                hud?.labelText = "取消收藏成功"
//                                hud.margin = 10.0
//                                hud.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 0.5)
                                btn.setImage(UIImage(named: self.picArr[4]), for: UIControlState())
                                self.TitCol.textColor = GREY
                                self.collection = false
                                // print(status.data)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func touchUp() {
        // print("触摸")
        self.bottomBtnClick(btnTwo)
    }
    // 选项
    func pleaseChooseOne(_ btn:UIButton) {
        if hasChooseIndex.contains(pageControl.currentPage) {
            return
        }else{
            hasChooseIndex.add(pageControl.currentPage)
        }
//        let backView = scrollView.viewWithTag(pageControl.currentPage+110)
//        let rightBtn = backView?.viewWithTag(rightAnswer[pageControl.currentPage] as! Int)
//        rightBtn?.backgroundColor = UIColor.greenColor()
//        if btn.tag != rightBtn?.tag {
        btn.backgroundColor = UIColor.init(red: 159/255.0, green: 43/255.0, blue: 136/255.0, alpha: 1)
        btn.setTitleColor(UIColor.white, for: UIControlState())
//        }
        let exam = dataSource[pageControl.currentPage]
        
        if self.pageControl.currentPage+1 > self.myChoose.count {
            if self.pageControl.currentPage>0{
                for i in self.myChoose.endIndex..<self.pageControl.currentPage {
                    self.myChoose.insert(0, at: i)
                    chooseId.insert("0", at: i)
                }
            }
            self.chooseId.append(exam.answerlist[btn.tag-1].id)
            self.myChoose.append(btn.tag)
        }else{
            self.myChoose.remove(at: pageControl.currentPage)
            chooseId.remove(at: pageControl.currentPage)
            self.myChoose.insert(btn.tag, at: pageControl.currentPage)
            chooseId.insert(exam.answerlist[btn.tag-1].id, at: pageControl.currentPage)
        }
        self.questionCard_uncommit()
        self.questionCard_commit()
        pageControl.currentPage += 1
        setControlPage(true)
        self.AnswerView()
    }
    
    func setControlPage(_ animate:Bool){
        let offSetX:CGFloat = CGFloat(pageControl.currentPage) * WIDTH
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: animate)
    }
    
    func takeUpTheTest() {
        // print("提交")
        self.isSubmit = true
        var idStr = ""
        var answerStr = ""
        self.num = 2
//        self.submit()
//        self.navigationItem.rightBarButtonItem
        if myChoose.count > 0 {
            
            for i in 0...myChoose.count-1 {
                let exer = dataSource[i]
                idStr += (i==0 ? exer.id! : ","+exer.id!)
            }
            
            for i in 0...myChoose.count-1 {
                answerStr += (i==0 ? chooseId[i] : ","+chooseId[i])
            }
        }else{
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud?.mode = MBProgressHUDMode.text;
            hud?.labelText = "请答题后提交"
            hud?.margin = 10.0
            hud?.removeFromSuperViewOnHide = true
            hud?.hide(true, afterDelay: 1)
            return
        }

        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = MBProgressHUDMode.;
        hud?.labelText = "正在提交..."
        hud?.margin = 10.0
        hud?.removeFromSuperViewOnHide = true
        
        HSStudyNetHelper.sendtestAnswerByType("2", count: String(dataSource.count), questionlist: idStr, answerlist: answerStr) { (success, response) in
            
            if(success){
                DispatchQueue.main.async(execute: {
                    hud?.hide(true)
                    self.navigationItem.rightBarButtonItem = nil

                    let result = response as! ScoreDataModel
                    
                    var time: TimeInterval = 0.0
                    if result.event != "" {
                        self.showScoreTips(result.event, score: result.score)
                        time = 3.0
                    }
                    
                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    
                    DispatchQueue.main.asyncAfter(deadline: delay) {
                        
                        let alertController = UIAlertController(title: "提交成功", message: "得分\(result.allscore)", preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        
                        let cancelAction = UIAlertAction(title: "退出", style: .cancel) { (cancelAction) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alertController.addAction(cancelAction)
                        
                        let answerAction = UIAlertAction(title: "答案解析", style: .default){
                            (cancelAction) in
                            
                            DispatchQueue.main.async(execute: {
                                
                                //                            let btn = UIButton()
                                //                            btn.tag = 4
                                self.bottomBtnClick(self.btnTwo)
                                
                                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
                                hud?.mode = MBProgressHUDMode.text
                                hud?.labelText = "点击 < 答案 > 按钮即可查看答案"
                                hud?.margin = 10.0
                                hud?.removeFromSuperViewOnHide = true
                                hud?.hide(true, afterDelay: 1.5)
                            })
                        }
                        alertController.addAction(answerAction)
                    }
                })
            }else{
                DispatchQueue.main.async(execute: {

                    hud?.hide(false)
                    
                    let hud2 = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud2?.mode = MBProgressHUDMode.text;
                    hud2?.labelText = "提交失败，请稍后再试"
                    hud2?.margin = 10.0
                    hud2?.removeFromSuperViewOnHide = true
                    hud2?.hide(true, afterDelay: 2)
                })
            }
            // print(response)
        }
    }
    
    func answerBtnClicked(_ btn:UIButton) {
        btn.backgroundColor = UIColor.purple
        btn.setTitleColor(UIColor.white, for: UIControlState())
        pageControl.currentPage = btn.tag - 1
        pageContorllerNumber(pageControl)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x)/Int(WIDTH) != pageControl.currentPage {
            pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
            number.text = "\(self.pageControl.currentPage+1)"
            number.sizeToFit()
            totalNum.frame.origin.x = WIDTH/2+5+number.bounds.size.width
            self.AnswerView()
            self.questionCard_uncommit()
            self.questionCard_commit()
        }
    }
}
