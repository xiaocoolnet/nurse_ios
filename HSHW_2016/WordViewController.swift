//
//  WordViewController.swift
//  HSHW_2016
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class WordViewController: UIViewController,UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    var timer = NSTimer()
    
    let choose:[String] = ["A、消化道症状","B、胃液分析","C、胃镜检查","D、血清学检查","E、胃肠X线检查"]
    
    let picArr:[String] = ["btn_arrow_left.png","btn_arrow_right.png","ic_fenlei.png","btn_eye.png","btn_collet.png"]
    
    let picName:[String] = ["答题卡","答案","收藏"]
    var TitCol = UILabel()
    var TitAns = UILabel()
    var TitQues = UILabel()
    var btnOne = UIButton()
    var btnTwo = UIButton()
    var time = UILabel()
    let grayBack = UIView()
    var hear = Bool()
    var timeNow:NSTimer!
    var minute : Int = 1
    var dataSource = NSArray()
    var count:Int = 13
    let questBack = UIView()//答题卡视图
    var over = Bool()
    var isSubmit = Bool()
    var collection = Bool()//是否收藏
    var timeText:String?
    let totalloc:Int = 5
    let rightAnswer = NSMutableArray()//正确答案
    var myChoose = Array<Int>() //已选答案
    var chooseId = Array<String>() //已选择的答案ID
    var helper = HSStudyNetHelper()
    var startPage = 0
    var questionCount = "10"
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
        self.getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        let rightBtn = UIBarButtonItem(title: "提交", style: .Done, target: self, action: #selector(takeUpTheTest))
        navigationItem.rightBarButtonItem = rightBtn
        self.view.backgroundColor = UIColor.whiteColor()
         self.isSubmit  = false
        collection = false
        self.timeDow()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if over == false {
            UIView.animateWithDuration(0.3, animations: {
                self.questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), forState: .Normal)
            TitQues.textColor = GREY
            over = true
        }
    }
    
    func getData(){
        let user = NSUserDefaults.standardUserDefaults()
        let uid = user.stringForKey("userid")
        let url = PARK_URL_Header+"getDaliyExamList"
        let param = [
            "userid":uid,
            "type":"1",
            "count":questionCount
        ]
        
        Alamofire.request(.GET, url, parameters: param as? [String:String]).response { [unowned self] request, response, json, error in
            dispatch_async(dispatch_get_main_queue(), { 
                if(error != nil){
                    
                }else{
                    let status = EveryDayModel(JSONDecoder(json!))
                    print("状态是")
                    print(status.status)
                    if(status.status == "error"){
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        //hud.labelText = status.errorData
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                    if(status.status == "success"){
                        
                        print(status)
                        self.dataSource = DaliyExamList(status.data!).objectlist
                        print(self.dataSource)
                        print(self.dataSource.count)
                        print("-----")
                        
                        self.createScrollerView()
                        self.AnswerView()
                        self.backBottomView()
                        self.questionCard()
                        print(status.data)
                    }
                }
            })
        }
    }
    
    func timeDow()
    {
        timeNow = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: #selector(WordViewController.updateTime), userInfo: nil, repeats: true)
    }
    
    func updateTime()
    {
//  print(self.scrollView.subviews)
        let index :Int = self.pageControl.currentPage
        var label = UILabel()
        if self.scrollView.subviews.count==0 {
            
        }else{
          label = self.view.viewWithTag(10+index) as! UILabel
        }
        count -= 1
        if minute>=0 {
            if (count <= 0)
            {
                count = 59
                minute -= 1
                
            }
            print(label.text)
            if minute == -1 {
                minute = 2
                count = 59
                
                label.text = "0"+"\(minute)"+":"+"\(count)"
                self.timeText = label.text
                timeNow.invalidate()
            }
            label.text = "0"+"\(minute)"+":"+"\(count)"
            if minute<10 {
                
                if count<10 {
                    label.text = "0"+"\(minute)"+":"+"0"+"\(count)"
                    self.timeText = label.text
                    
                }
            }else{
                
                label.text = "\(minute)"+":"+"\(count)"
                self.timeText = label.text
                
            }
        }
    }

    // MARK: 答题卡视图
    func questionCard() {
        print(self.pageControl.currentPage)
        print(self.myChoose)
        print(self.rightAnswer)
        
        let labelArray = ["答对","答错","未答","当前题"]
        questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
        questBack.backgroundColor = UIColor.whiteColor()
        over = true
        var window = UIWindow()
        window = ((UIApplication.sharedApplication().delegate?.window)!)!
        window.addSubview(questBack)
        
        let big = UIView(frame: CGRectMake(0, 44, WIDTH, HEIGHT-163))
//        big.backgroundColor = COLOR
        
        // 创建渐变色图层
        let gradientLayer = CAGradientLayer.init()
        gradientLayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT-163)
        gradientLayer.colors = [UIColor.init(red: 186/255.0, green: 125/255.0, blue: 126/255.0, alpha: 1).CGColor,UIColor.init(red: 140/255.0, green: 20/255.0, blue: 139/255.0, alpha: 1).CGColor]
        // 设置渐变方向（0-1）
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        // 设置渐变色的起始位置和终止位置（颜色分割点）
        gradientLayer.locations = [ (0.15), (0.98)]
        gradientLayer.borderWidth = 0.0
        // 添加图层
        big.layer.addSublayer(gradientLayer)
        
        questBack.addSubview(big)
        let smart = UIView(frame: CGRectMake(10, 10, WIDTH-20, HEIGHT-183))
        smart.backgroundColor = UIColor.whiteColor()
        smart.layer.cornerRadius = 5
        big.addSubview(smart)
        for i in 0..<4 {
            let view = UIView()
            view.frame = CGRectMake(WIDTH/4 * CGFloat(i), 5, WIDTH/4, WIDTH*30/375)
            let circleView = UIView()
            circleView.frame = CGRectMake(10, 10, WIDTH*10/375, WIDTH*10/375)
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            let label = UILabel()
            label.frame = CGRectMake(circleView.frame.origin.x+circleView.frame.size.width+3, 5, WIDTH*100/375, WIDTH*20/375)
            label.text = labelArray[i]
            if i==0 {
                circleView.backgroundColor = UIColor.greenColor()
            }else if i==1{
                circleView.backgroundColor = UIColor.redColor()
            }else if i==2{
                circleView.backgroundColor = UIColor.grayColor()
            }else{
                circleView.backgroundColor = UIColor.purpleColor()
            }
            view.addSubview(circleView)
            view.addSubview(label)
            questBack.addSubview(view)
        }
        let cirecleArray = NSMutableArray()
        let smartWidth = smart.frame.size.width
        let margin:CGFloat = (smartWidth - CGFloat(self.totalloc) * smartWidth/CGFloat(self.totalloc))/(CGFloat(self.totalloc)+1);
        for j in 0 ..< self.dataSource.count {
            
            let row:Int = j / totalloc;//行号
            let loc:Int = j % totalloc;//列号
            
            let appviewx:CGFloat = margin+(margin+smartWidth/CGFloat(self.totalloc))*CGFloat(loc)
            let appviewy:CGFloat = margin+(margin+90) * CGFloat(row)
            let view = UIView()
            view.frame = CGRectMake(appviewx, appviewy, smartWidth/CGFloat(self.totalloc), WIDTH*90/375)
            let number = UIButton(type: .Custom)
            let tihao = j+1
            number.tag = tihao
            number.addTarget(self, action: #selector(answerBtnClicked), forControlEvents: .TouchUpInside)
            number.setTitle(String(tihao), forState: .Normal)
            number.frame = CGRectMake(10, 10, view.frame.size.width-30, view.frame.size.width-30)
            number.setTitleColor(UIColor.blackColor(), forState: .Normal)
            number.layer.cornerRadius = 0.5 * (view.frame.size.width-30)
            number.clipsToBounds = true
            
            if j==self.pageControl.currentPage {
                number.backgroundColor = UIColor.purpleColor()
                number.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            }
            
            let circleView = UIView()
            circleView.frame = CGRectMake(0, number.frame.origin.y+number.frame.size.height+10, WIDTH*10/375, WIDTH*10/375)
            circleView.center.x = number.center.x
            circleView.layer.cornerRadius = 0.5*WIDTH*10/375
            circleView.backgroundColor = UIColor.grayColor()
            cirecleArray.addObject(circleView)
            view.addSubview(number)
            view.addSubview(circleView)
            smart.addSubview(view)
        }
        if myChoose.count != 0 {
            for i in 0..<self.myChoose.endIndex {
                let myCircleView = cirecleArray[i] as! UIView
                
                if Int(self.myChoose[i])==Int(self.rightAnswer[i] as! NSNumber) {
                    myCircleView.backgroundColor =  UIColor.greenColor()
                }else if Int(self.myChoose[i]) != Int(self.rightAnswer[i] as! NSNumber)&&Int(self.myChoose[i]) != 0 {
                    myCircleView.backgroundColor = UIColor.redColor()
                }else if Int(self.myChoose[i]) == 0 {
                    myCircleView.backgroundColor = UIColor.grayColor()
                }
            }
        }
    }
    // MARK:   答案视图
    func AnswerView() {
        //将正确答案放在一个数组中
        let examInfo = self.dataSource[self.pageControl.currentPage] as! ExamInfo
        
        if rightAnswer.count <= pageControl.currentPage {
            for _ in rightAnswer.count-1...pageControl.currentPage {
                rightAnswer.addObject(9)
            }
        }
        
        for i in 0 ..< examInfo.answerlist.count {
            let answerInfo = examInfo.answerlist[i]
            if answerInfo.isanswer == "1" {
                rightAnswer[pageControl.currentPage] = i+1
                print(answerInfo.answer_title)
                print(answerInfo.isanswer)
                break
            }
        }
        grayBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-54)
        grayBack.backgroundColor = UIColor.clearColor()
        hear = true
        var window = UIWindow()
        window = ((UIApplication.sharedApplication().delegate?.window)!)!
        window.addSubview(grayBack)
        
        let touch = UIButton(frame: CGRectMake(0, 0, WIDTH, HEIGHT-54))
        touch.backgroundColor = UIColor.grayColor()
        touch.alpha = 0.4
        touch.addTarget(self, action: #selector(self.touchUp), forControlEvents: .TouchUpInside)
        grayBack.addSubview(touch)
        
        let backeView = UIView(frame: CGRectMake(0, HEIGHT-54-WIDTH*260/375, WIDTH, WIDTH*260/375))
        backeView.backgroundColor = UIColor.whiteColor()
        grayBack.addSubview(backeView)
        
        let line = UILabel(frame: CGRectMake(10, WIDTH*48/375, WIDTH-20, 2))
        line.backgroundColor = COLOR
        backeView.addSubview(line)
        
        let answer = UILabel(frame: CGRectMake(WIDTH/2-40, WIDTH*10/375, 80, WIDTH*38/375))
        answer.font = UIFont.systemFontOfSize(18)
        answer.textColor = COLOR
        answer.textAlignment = .Center
        answer.text = "参考答案"
        backeView.addSubview(answer)
        let labelArray = ["您的答案","正确答案","题目难度"]
        for i in 0..<3 {
            let view = UIView()
            //  view.backgroundColor = UIColor.redColor()
            view.frame = CGRectMake(WIDTH*60/375+(WIDTH*90/375)*CGFloat(i), line.frame.origin.y+12, WIDTH*80/375, WIDTH*70/375)
            backeView.addSubview(view)
            let answer = UILabel()
            answer.font = UIFont.systemFontOfSize(25)
            answer.textAlignment = NSTextAlignment.Center
            answer.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height-30)
            answer.textColor = COLOR
            let label = UILabel()
            label.frame = CGRectMake(0, view.frame.size.height-30, view.frame.size.width, 20)
            label.textColor = UIColor.grayColor()
            label.text = labelArray[i]
            if i==0 {
                print(self.myChoose)
                print(self.myChoose.count)
                print(self.pageControl.currentPage)
                
                if self.myChoose.count == 0 || self.pageControl.currentPage+1>self.myChoose.count{
                    answer.text = " "
                }else{
                    let isanswer = 64 + myChoose[self.pageControl.currentPage]
                    let asc:UniChar = UInt16(isanswer)
                    let chara:Character = Character(UnicodeScalar(asc))
                    var string = ""
                    string.append(chara)
                    answer.text = string
                }
    //answer.text = self.myChoose[self.pageControl.currentPage] as! String
            }else if i==1{
                print(self.rightAnswer)
                print(self.pageControl.currentPage)
                print(self.rightAnswer[self.pageControl.currentPage])
                let isanswer = 64 + (self.rightAnswer[self.pageControl.currentPage] as! Int)
                let asc:UniChar = UInt16(isanswer)
                let chara:Character = Character(UnicodeScalar(asc))
                var string = ""
                string.append(chara)
                answer.text = string
            }else{
                var difficultyValue = Int()
                let examInfo = self.dataSource[self.pageControl.currentPage] as! ExamInfo
                print(examInfo)
                difficultyValue = Int(examInfo.post_difficulty!)!
                print(difficultyValue)
                let imageArray = NSMutableArray()
                // let imageView = UIImageView()
                for i in 0..<3 {
                    let imageView = UIImageView()
                    imageView.frame = CGRectMake(answer.frame.size.width/2-answer.frame.size.height/2+CGFloat(i)*answer.frame.size.height/3, 5, answer.frame.size.height/3, answer.frame.size.height/3)
                    imageView.image = UIImage(named:"ic_collect" )
                    answer.addSubview(imageView)
                    imageArray.addObject(imageView)
                }
                for i in 0..<2 {
                    let imageView1 = UIImageView()
                    imageView1.frame = CGRectMake(answer.frame.size.width/2-answer.frame.size.height/2+answer.frame.size.height/6+CGFloat(i)*answer.frame.size.height/3, 5+answer.frame.size.height/3, answer.frame.size.height/3, answer.frame.size.height/3)
                    imageView1.image = UIImage(named:"ic_collect" )
                    answer.addSubview(imageView1)
                    imageArray.addObject(imageView1)
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
        analysis.frame = CGRectMake(10, line.frame.origin.y+12+WIDTH*70/375+10, WIDTH*100/375, WIDTH*20/375)
        analysis.text = "答案解析:"
        analysis.textColor = COLOR
//      analysis.backgroundColor = UIColor.redColor()
        backeView.addSubview(analysis)
        let analysisContent = UILabel()
        analysisContent.textColor = UIColor.grayColor()
        analysisContent.text = examInfo.post_description
        analysisContent.numberOfLines = 0
        analysisContent.font = UIFont.systemFontOfSize(15)
//      analysisContent.backgroundColor = UIColor.greenColor()
        let height: CGFloat = calculateHeight(examInfo.post_description!, size: 15, width:backeView.frame.size.width-20)
        print(height)
        analysisContent.frame = CGRectMake(10, analysis.frame.size.height+analysis.frame.origin.y, backeView.frame.size.width-20, height)
        backeView.addSubview(analysisContent)
    }
    // MARK:    底部视图
    func backBottomView() {
        let backView = UIView(frame: CGRectMake(0, HEIGHT-118, WIDTH, 54))
        backView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backView)
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 0.5))
        line.backgroundColor = GREY
        backView.addSubview(line)
        
        let left = UIButton(frame: CGRectMake(10, 13, 28, 28))
        left.setBackgroundImage(UIImage(named: picArr[0]), forState: .Normal)
        left.tag = 1
        left.addTarget(self, action: #selector(self.bottomBtnClick(_:)), forControlEvents: .TouchUpInside)
        backView.addSubview(left)
        let right = UIButton(frame: CGRectMake(WIDTH-38, 13, 28, 28))
        right.setBackgroundImage(UIImage(named: picArr[1]), forState: .Normal)
        right.tag = 2
        right.addTarget(self, action: #selector(self.bottomBtnClick(_:)), forControlEvents: .TouchUpInside)
        backView.addSubview(right)
        for i in 0...2 {
            let btn = UIButton(frame: CGRectMake(WIDTH/5*1.5+CGFloat(i)*(WIDTH/5-11), 9, 22, 22))
            btn.tag = i+3
            btn.setImage(UIImage(named: picArr[i+2]), forState: .Normal)
            btn.addTarget(self, action: #selector(self.bottomBtnClick(_:)), forControlEvents: .TouchUpInside)
            backView.addSubview(btn)
            if btn.tag == 3 {
                btnOne = btn
            }
            if btn.tag == 4 {
                btnTwo = btn
            }
            let tit = UILabel(frame: CGRectMake(WIDTH/5*1.5+CGFloat(i)*(WIDTH/5-11)-4, 35, 30, 10))
            tit.font = UIFont.systemFontOfSize(10)
            tit.textColor = GREY
            tit.tag = i+3
            tit.textAlignment = .Center
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
        scrollView.frame = CGRectMake(0, 1,WIDTH, HEIGHT-119)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        print(self.dataSource.count)
        for  i in 0 ..< self.dataSource.count {
            let examInfo = self.dataSource[i] as! ExamInfo
            let contentScrollView :UIScrollView = UIScrollView.init()
            contentScrollView.frame = CGRectMake(CGFloat(i)*WIDTH+10, 54, WIDTH-20, HEIGHT-221)
            contentScrollView.backgroundColor = UIColor.whiteColor()
            contentScrollView.layer.cornerRadius = 5
            
            let backView = UIView()
            let backGound = UIView(frame: CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH,44))
            backView.frame = CGRectMake(CGFloat(i)*WIDTH, 44, WIDTH, HEIGHT-163)//背景
//            backView.backgroundColor = COLOR
            
            // 创建渐变色图层
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.frame = CGRectMake(0, 0, WIDTH, HEIGHT-163)
            gradientLayer.colors = [UIColor.init(red: 186/255.0, green: 125/255.0, blue: 126/255.0, alpha: 1).CGColor,UIColor.init(red: 140/255.0, green: 20/255.0, blue: 139/255.0, alpha: 1).CGColor]
            // 设置渐变方向（0-1）
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            // 设置渐变色的起始位置和终止位置（颜色分割点）
            gradientLayer.locations = [ (0.15), (0.98)]
            gradientLayer.borderWidth = 0.0
            // 添加图层
            backView.layer.addSublayer(gradientLayer)
            
            backView.tag = i+1
            let back = UIView(frame: CGRectMake(CGFloat(i)*WIDTH+10, 54, WIDTH-20, HEIGHT-221))//白色答题区域
            back.backgroundColor = UIColor.whiteColor()
            back.layer.cornerRadius = 5
            let dan = UIImageView(frame: CGRectMake(10, 16, 12, 12))
            dan.image = UIImage(named: "ic_choice.png")
            backGound.addSubview(dan)
            let danxuan = UILabel(frame: CGRectMake(24, 12.5, 40, 17))
            danxuan.font = UIFont.systemFontOfSize(18)
            danxuan.text = "单选题"
            danxuan.sizeToFit()
            backGound.addSubview(danxuan)
            let tit = UILabel(frame: CGRectMake(28+danxuan.bounds.size.width, 18.5, 40, 12))
            tit.font = UIFont.systemFontOfSize(12)
            tit.textColor = GREY
            tit.text = "（A1，2分）"
            tit.sizeToFit()
            backGound.addSubview(tit)
            let time = UILabel(frame: CGRectMake(WIDTH-50, 16, 50, 12))
            time.tag = 10+i
            //time.backgroundColor = UIColor.redColor()
            time.font = UIFont.systemFontOfSize(14)
            //time.textAlignment = .Right
            time.textColor = COLOR
            time.text = "00:00"
            //time.sizeToFit()
            backGound.addSubview(time)
            let timelab = UILabel(frame: CGRectMake(WIDTH-time.bounds.origin.x-125, 15, 71, 12))
            // let timelab = UILabel(frame: CGRectMake(WIDTH-time.bounds.size.width-83, 15, 71, 12))
            // timelab.backgroundColor = UIColor.greenColor()
            timelab.font = UIFont.systemFontOfSize(12)
            timelab.textColor = GREY
            timelab.text = "剩余答题时间"
            timelab.textAlignment = .Right
            timelab.sizeToFit()
            backGound.addSubview(timelab)
            //问题
            let question = UILabel(frame: CGRectMake(WIDTH*20/375, WIDTH*15/375, back.bounds.size.width-WIDTH*38/375, 40))
            question.numberOfLines = 0
            question.textAlignment = .Natural
            question.font = UIFont.systemFontOfSize(14)
            question.text = examInfo.post_title
            question.sizeToFit()
            contentScrollView.addSubview(question)
            //back.addSubview(question)
            //选项列表
            let heightArray = NSMutableArray()
            for j in 0 ..< examInfo.answerlist.count {
                var string = ""
                let btn = UIButton(type: .Custom)
                let answerInfo = examInfo.answerlist[j]
                let height:CGFloat = calculateHeight(string+"、"+answerInfo.answer_title, size: 18, width: WIDTH*314/375-10)
                if j>0 {
                    print(j)
                    print(heightArray)
                    btn.frame =  CGRectMake(WIDTH*21/375, 10+(CGFloat(heightArray[j-1] as! NSNumber))*CGFloat(1), WIDTH*314/375, height+10)
                    heightArray.addObject(btn.frame.size.height+btn.frame.origin.y)
                }else{
                    btn.frame = CGRectMake(WIDTH*21/375, 5+question.frame.size.height+question.frame.origin.y+(15+WIDTH*46/375)*CGFloat(0), WIDTH*314/375, height+10)
                    heightArray.addObject(btn.frame.size.height+btn.frame.origin.y)
                }
                //选项按钮
                btn.tag = j+1
                btn.layer.cornerRadius = (height+10)/2
                btn.layer.borderColor = COLOR.CGColor
                btn.layer.borderWidth = 1
                btn.addTarget(self, action: #selector(self.pleaseChooseOne(_:)), forControlEvents: .TouchUpInside)
                btn.setTitleColor(COLOR, forState: .Normal)
                btn.contentHorizontalAlignment = .Left;
                btn.titleLabel?.numberOfLines = 0
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                //back.addSubview(btn)
                contentScrollView.addSubview(btn)
                //根据题号赋值
                contentScrollView.tag = i+110
                let ascInt:Int = 65+j
                let asc:UniChar = UInt16(ascInt)
                let chara:Character = Character(UnicodeScalar(asc))
                string.append(chara)
                btn.setTitle(string+"、"+answerInfo.answer_title, forState: .Normal)
                var AllHeight = CGFloat()
                AllHeight = CGFloat(heightArray.lastObject as! NSNumber)
                contentScrollView.contentSize = CGSizeMake(WIDTH-20, AllHeight+10*CGFloat(examInfo.answerlist.count-1))
            }
            scrollView.addSubview(backGound)
            scrollView.addSubview(backView)
            scrollView.addSubview(contentScrollView)
        }
        
        scrollView.contentSize = CGSizeMake(CGFloat(self.dataSource.count)*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        view.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(0, HEIGHT-167, WIDTH, 48)
        pageControl.pageIndicatorTintColor = UIColor.redColor()
//        pageControl.addTarget(self, action: #selector(self.pageContorllerNumber(_:)), forControlEvents: .TouchUpInside)
        pageControl.addTarget(self, action: #selector(self.pageContorllerNumber(_:)), forControlEvents: .ValueChanged)
        pageControl.numberOfPages = self.dataSource.count
        pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
        //   self.AnswerView()
    }
    
    func pageContorllerNumber(pageControl:UIPageControl) {
        let offSetX:CGFloat = CGFloat(pageControl.currentPage) * WIDTH
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
    func dismissCard(){
        if over == true {
            UIView.animateWithDuration(0.3, animations: {
                self.questBack.frame = CGRectMake(0, 65, WIDTH, HEIGHT-119)
                self.grayBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-54)
                self.hear = true
            })
            btnOne.setImage(UIImage(named: "ic_fenlei_sel.png"), forState: .Normal)
            TitQues.textColor = COLOR
            over = false
        }else{
            UIView.animateWithDuration(0.3, animations: {
                self.questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), forState: .Normal)
            TitQues.textColor = GREY
            over = true
        }
    }
    // MARK:   底部按钮
    func bottomBtnClick(btn:UIButton) {
        print(btn.tag)
        if btn.tag == 1 {
            self.pageControl.currentPage -= 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            self.AnswerView()
        }else if btn.tag == 2 {
            self.pageControl.currentPage += 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            self.AnswerView()
        }else if btn.tag == 3 {
            dismissCard()
        }else if btn.tag == 4 {
            if hear == true {
                UIView.animateWithDuration(0.3, animations: {
                    self.grayBack.frame = CGRectMake(0, 0, WIDTH, HEIGHT-54)
                    self.questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
                    if btn.tag == 4 {
                        self.btnOne.setImage(UIImage(named: self.picArr[2]), forState: .Normal)
                        self.TitQues.textColor = GREY
                    }
                    self.over = true
                })
                btn.setImage(UIImage(named: "btn_eye_sel.png"), forState: .Normal)
                TitAns.textColor = COLOR
                hear = false
            }else{
                UIView.animateWithDuration(0.3, animations: {
                    self.grayBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-54)
                })
                btn.setImage(UIImage(named: picArr[3]), forState: .Normal)
                TitAns.textColor = GREY
                hear = true
            }
        }else if btn.tag == 5 {
            print(collection)
            print("收藏")
            let examInfo = self.dataSource[self.pageControl.currentPage] as! ExamInfo
            let user = NSUserDefaults.standardUserDefaults()
            let uid = user.stringForKey("userid")
            print(uid)
            if uid==nil {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let vc  = mainStoryboard.instantiateViewControllerWithIdentifier("Login")
                self.navigationController?.pushViewController(vc, animated: true)
                btn.setImage(UIImage(named: picArr[4]), forState: .Normal)
                TitCol.textColor = GREY
                collection = false
            }else if collection == false {
                
                let url = PARK_URL_Header+"addfavorite"
                let param = [
                    
                    "refid":examInfo.id,
                    "type":"2",
                    "userid":uid,
                    "title":examInfo.post_title,
                    "description":examInfo.post_description
                ];
                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        dispatch_async(dispatch_get_main_queue(), {
                            if(status.status == "error"){
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = status.errorData
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 0.5)
                            }
                            if(status.status == "success"){
                                
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "收藏成功"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 0.5)
                                btn.setImage(UIImage(named: "btn_collect_sel.png"), forState: .Normal)
                                self.TitCol.textColor = COLOR
                                self.collection = true
                                print(status.data)
                            }
                        })
                    }
                }
            }else{
                let url = PARK_URL_Header+"cancelfavorite"
                let param = [
                    "refid":examInfo.id,
                    "type":"2",
                    "userid":uid
                ];
                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        print("状态是")
                        print(status.status)
                        dispatch_async(dispatch_get_main_queue(), {
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = status.errorData
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 0.5)
                            }
                            if(status.status == "success"){
                                
                                let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                                hud.mode = MBProgressHUDMode.Text;
                                hud.labelText = "取消收藏成功"
                                hud.margin = 10.0
                                hud.removeFromSuperViewOnHide = true
                                hud.hide(true, afterDelay: 0.5)
                                btn.setImage(UIImage(named: self.picArr[4]), forState: .Normal)
                                self.TitCol.textColor = GREY
                                self.collection = false
                                print(status.data)
                            }
                        })
                    }
                }
            }
        }
    }
    
    func touchUp() {
        print("触摸")
        self.bottomBtnClick(btnTwo)
    }
    // 选项
    func pleaseChooseOne(btn:UIButton) {
        
        let backView = scrollView.viewWithTag(pageControl.currentPage+110)
        let rightBtn = backView?.viewWithTag(rightAnswer[pageControl.currentPage] as! Int)
        rightBtn?.backgroundColor = UIColor.greenColor()
        if btn.tag != rightBtn?.tag {
            btn.backgroundColor = UIColor.redColor()
        }
        let exam = dataSource[pageControl.currentPage] as!ExamInfo
        
        if self.pageControl.currentPage+1 > self.myChoose.count {
            if self.pageControl.currentPage>0{
                for i in self.myChoose.endIndex..<self.pageControl.currentPage {
                    self.myChoose.insert(0, atIndex: i)
                    chooseId.insert("0", atIndex: i)
                }
            }
            self.chooseId.append(exam.answerlist[btn.tag-1].id)
            self.myChoose.append(btn.tag)
        }else{
            self.myChoose.removeAtIndex(pageControl.currentPage)
            chooseId.removeAtIndex(pageControl.currentPage)
            self.myChoose.insert(btn.tag, atIndex: pageControl.currentPage)
            chooseId.insert(exam.answerlist[btn.tag-1].id, atIndex: pageControl.currentPage)
        }
        self.questionCard()
        self.AnswerView()
    }
    
    func takeUpTheTest() {
        print("提交")
        self.isSubmit = true
        var idStr = ""
        var answerStr = ""
        if myChoose.count > 0 {
            
            for i in 0...myChoose.count-1 {
                let exer = dataSource[i] as! ExamInfo
                idStr += (i==0 ? exer.id! : ","+exer.id!)
            }
            
            for i in 0...myChoose.count-1 {
                answerStr += (i==0 ? chooseId[i] : ","+chooseId[i])
            }
        }
        
        helper.sendtestAnswerByType("1", count: String(dataSource.count), questionlist: idStr, answerlist: answerStr) { (success, response) in
            if(success){
                dispatch_async(dispatch_get_main_queue(), {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "提交成功，得分为：" + (response as! String)
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                })
            }
        }
    }
    
    func answerBtnClicked(btn:UIButton) {
        btn.backgroundColor = UIColor.purpleColor()
        btn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        pageControl.currentPage = btn.tag - 1
        pageContorllerNumber(pageControl)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x)/Int(WIDTH) != pageControl.currentPage {
            pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(WIDTH)
            self.AnswerView()
            self.questionCard()
        }
    }
}
