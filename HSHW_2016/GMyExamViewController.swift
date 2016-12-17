//
//  GMyExamViewController.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class GMyExamViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    
    var type = 0 // 1 做题记录  2 错题集  3 收藏记录  4 其他收藏
    var subType = 0 // 1 每日一练  2 在线考试
    
    let choose:[String] = ["A、消化道症状","B、胃液分析","C、胃镜检查","D、血清学检查","E、胃肠X线检查"]
    let picArr:[String] = ["btn_arrow_left.png","btn_arrow_right.png","ic_fenlei.png","btn_eye.png","btn_collect.png"]
    let picName:[String] = ["答题卡","答案","收藏"]
    let number = UILabel()
    var numb = Int()
    
    var TitCol = UILabel()
    var TitAns = UILabel()
    var TitQues = UILabel()
    var btnOne = UIButton()
    var btnTwo = UIButton()
    var dataSource = Array<xamInfo>()
    let totalloc:Int = 5
    let pageControl = UIPageControl()
    //    let rightAnswer = NSMutableArray()
    let rightAnswer = NSMutableArray()//正确答案
    var myChoose: [Int] = NSArray() as! [Int] //已选答案
    var chooseId = Array<String>()
    let grayBack = UIView()
    var hear = Bool()
    
    let questBack = UIView()
    var over = Bool()
    var collection = Bool()
    var isSubmit = Bool()
    var minute : Int = 1
    var count:Int = 13
//    var helper = HSStudyNetHelper()
//    var mineHelper = HSMineHelper()
    
    var questionCount = "10"
    
    var hasChooseIndex = NSMutableArray()
    let touch = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-54))
    
    var segment:UISegmentedControl?
    var currentVCIndex:Int = 0
    var currentIndex = NSInteger()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.title = "收藏记录"
        
        numb = 1
        self.view.backgroundColor = UIColor.white
        isSubmit = false
        collection = false
        
        setSpecificView_ExamPaper_OnView(self.view)
        
        self.createScrollerView()
        if self.dataSource.count > 0 {
            self.AnswerView()
        }
        self.backBottomView()
        self.questionCard()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if over == false {
            UIView.animate(withDuration: 0.3, animations: {
                self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
            })
            btnOne.setImage(UIImage(named: picArr[2]), for: UIControlState())
            TitQues.textColor = GREY
            over = true
        }
    }
    
    // MARK:    答题卡视图
    func questionCard() {
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
    // MARK:   答案视图
    func AnswerView() {
        //将正确答案放在一个数组中
        if self.dataSource.count != 0{
            
            
            let examInfo = self.dataSource[self.pageControl.currentPage]
            if rightAnswer.count <= pageControl.currentPage {
                for _ in rightAnswer.count-1...pageControl.currentPage {
                    rightAnswer.add(9)
                }
            }
            for i in 0 ..< examInfo.answers.count {
                let answerInfo = examInfo.answers[i]
                if answerInfo.isanswer == "1" {
                    rightAnswer[pageControl.currentPage] = i+1
                    // print(answerInfo.title)
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
            
            //        let touch = UIButton(frame: CGRectMake(0, 0, WIDTH, HEIGHT-54))
            touch.backgroundColor = UIColor.gray
            touch.alpha = 0.4
            touch.addTarget(self, action: #selector(self.touchUp), for: .touchUpInside)
            grayBack.addSubview(touch)
            
            let backeView = UIView(frame: CGRect(x: 0, y: HEIGHT-54-WIDTH*260/375, width: WIDTH, height: WIDTH*260/375))
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
                    difficultyValue = Int(examInfo.post_difficulty)!
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
            let height: CGFloat = calculateHeight(examInfo.post_description, size: 15, width:backeView.frame.size.width-20)
            // print(height)
            analysisContent.frame = CGRect(x: 10, y: analysis.frame.size.height+analysis.frame.origin.y, width: backeView.frame.size.width-20, height: height)
            backeView.addSubview(analysisContent)
        }
    }
    // MARK:  底部视图
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
    // MARK:   答题区
    func createScrollerView() {
        scrollView.frame = CGRect(x: 0, y: 1+44,width: WIDTH, height: HEIGHT-119)
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        scrollView.contentOffset = CGPoint(x: CGFloat( currentIndex )  * WIDTH, y: 0)
        
        for  i in 0 ..< self.dataSource.count {
            let examInfo = self.dataSource[i]
            let contentScrollView :UIScrollView = UIScrollView.init()
            contentScrollView.frame = CGRect(x: CGFloat(i)*WIDTH+10, y: 10, width: WIDTH-20, height: HEIGHT-221)
            contentScrollView.backgroundColor = UIColor.white
            contentScrollView.layer.cornerRadius = 5
            let backView = UIView()
            let backGound = UIView(frame: CGRect(x: CGFloat(i)*self.view.frame.size.width, y: 0, width: self.view.frame.size.width,height: 44))
            
            backView.frame = CGRect(x: CGFloat(i)*self.view.frame.size.width, y: 0, width: self.view.frame.size.width, height: HEIGHT-163)
            
            // 创建渐变色图层
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-163)
            gradientLayer.colors = [UIColor.init(red: 216/255.0, green: 121/255.0, blue: 168/255.0, alpha: 1).cgColor,UIColor.init(red: 160/255.0, green: 43/255.0, blue: 134/255.0, alpha: 1).cgColor]
            // 设置渐变方向（0-1）
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            // 设置渐变色的起始位置和终止位置（颜色分割点）
            gradientLayer.locations = [ (0.15), (0.98)]
            gradientLayer.borderWidth = 0.0
            // 添加图层
            backView.layer.addSublayer(gradientLayer)
            
            backView.tag = i+1
            let back = UIView(frame: CGRect(x: CGFloat(i)*self.view.frame.size.width+10, y: 10, width: self.view.frame.size.width-20, height: HEIGHT-221))
            back.backgroundColor = UIColor.white
            back.layer.cornerRadius = 5
            
            
            
            let question = UILabel(frame: CGRect(x: WIDTH*20/375, y: WIDTH*15/375, width: back.bounds.size.width-WIDTH*38/375, height: 40))
            question.numberOfLines = 0
            question.textAlignment = .natural
            question.font = UIFont.systemFont(ofSize: 14)
            question.text = examInfo.post_title
            question.sizeToFit()
            contentScrollView.addSubview(question)
            
            let heightArray = NSMutableArray()
            for j in 0 ..< examInfo.answers.count {
                var string = ""
                let btn = UIButton()
                let answerInfo = examInfo.answers[j]
                let height:CGFloat = calculateHeight(string+"、"+answerInfo.title, size: 18, width: WIDTH*314/375-10)
                if j>0 {
                    // print(j)
                    // print(heightArray)
                    btn.frame =  CGRect(x: WIDTH*21/375, y: 10+(CGFloat(heightArray[j-1] as! NSNumber))*CGFloat(1), width: WIDTH*314/375, height: height+10)
                    heightArray.add(btn.frame.size.height+btn.frame.origin.y)
                }else{
                    btn.frame = CGRect(x: WIDTH*21/375, y: 5+question.frame.size.height+question.frame.origin.y+(15+WIDTH*46/375)*CGFloat(0), width: WIDTH*314/375, height: height+10)
                    heightArray.add(btn.frame.size.height+btn.frame.origin.y)
                }
                //选项按钮
                btn.tag = j+1
                btn.layer.cornerRadius = (height+10)/2
                btn.layer.borderColor = COLOR.cgColor
                btn.layer.borderWidth = 1
                btn.addTarget(self, action: #selector(self.pleaseChooseOne(_:)), for: .touchUpInside)
                btn.setTitleColor(COLOR, for: UIControlState())
                btn.contentHorizontalAlignment = .left;
                btn.titleLabel?.numberOfLines = 0
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                contentScrollView.addSubview(btn)
                //根据题号赋值
                contentScrollView.tag = i+110
                let ascInt:Int = 65+j
                let asc:UniChar = UInt16(ascInt)
                let chara:Character = Character(UnicodeScalar(asc)!)
                string.append(chara)
                btn.setTitle(string+"、"+answerInfo.title, for: UIControlState())
                var AllHeight = CGFloat()
                AllHeight = CGFloat(heightArray.lastObject as! NSNumber)
                contentScrollView.contentSize = CGSize(width: WIDTH-20, height: AllHeight+10*CGFloat(examInfo.answers.count-1))
            }
            
            scrollView.addSubview(backGound)
            scrollView.addSubview(backView)
            scrollView.addSubview(contentScrollView)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(self.dataSource.count)*self.view.frame.size.width, height: 0)
        //        scrollView.contentOffset = CGPointMake(0, 0)
        scrollView.contentOffset = CGPoint(x: CGFloat( currentIndex )  * WIDTH, y: 0)
        view.addSubview(scrollView)
        let ques = UILabel(frame: CGRect(x: WIDTH/2-80, y: HEIGHT-146, width: 80, height: 12))
        ques.font = UIFont.systemFont(ofSize: 12)
        ques.textAlignment = .right
        ques.textColor = UIColor(red: 250/255.0, green: 118/255.0, blue: 210/255.0, alpha: 1.0)
        ques.text = "考试进度："
        self.view.addSubview(ques)
        number.frame = CGRect(x: WIDTH/2+5, y: HEIGHT-150, width: 30, height: 14)
        number.font = UIFont.systemFont(ofSize: 16)
        number.textColor = UIColor.yellow
        number.text = String(currentIndex + 1)
        number.sizeToFit()
        self.view.addSubview(number)
        let num = UILabel(frame: CGRect(x: WIDTH/2+5+number.bounds.size.width, y: HEIGHT-150, width: 30, height: 14))
        num.textColor = UIColor.white
        num.font = UIFont.systemFont(ofSize: 16)
        //        String(self.dataSource.count)
        num.text = "  /"+String(self.dataSource.count)
        num.sizeToFit()
        self.view.addSubview(num)
        
        pageControl.frame = CGRect(x: 0, y: HEIGHT-167, width: WIDTH, height: 48)
        pageControl.pageIndicatorTintColor = UIColor.red
        //        pageControl.addTarget(self, action: #selector(self.pageContorllerNumber(_:)), forControlEvents: .TouchUpInside)
        pageControl.numberOfPages = self.dataSource.count
        pageControl.currentPage = currentIndex
        //self.view.addSubview(self.pageControl)
    }
    
    // 设置不同的头——做题记录
    func setSpecificView_ExamPaper_OnView(_ backGound:UIView) {
        
        self.createScrollerView()
        
        let dian = UIImageView(frame: CGRect(x: 10, y: 16, width: 12, height: 12))
        dian.image = UIImage(named: "ic_choice.png")
        backGound.addSubview(dian)
        let dianxuan = UILabel(frame: CGRect(x: 24, y: 12.5, width: 40, height: 17))
        dianxuan.font = UIFont.systemFont(ofSize: 18)
        dianxuan.text = "单选题"
        dianxuan.sizeToFit()
        backGound.addSubview(dianxuan)
        
        let tit = UILabel(frame: CGRect(x: 28+dianxuan.bounds.size.width, y: 18.5, width: 40, height: 12))
        tit.font = UIFont.systemFont(ofSize: 12)
        tit.textColor = GREY
        tit.text = "（A1，2分）"
        tit.sizeToFit()
        backGound.addSubview(tit)
        // let time = UILabel(frame: CGRectMake(WIDTH-50, 14, 40, 12))
        let time = UILabel(frame: CGRect(x: WIDTH-50, y: 16, width: 50, height: 12))
        //        time.tag = 10+i
        time.font = UIFont.systemFont(ofSize: 14)
        time.textAlignment = .right
        time.textColor = COLOR
        time.text = "00:00"
        time.sizeToFit()
        //            backGound.addSubview(time)
        
        // let timelab = UILabel(frame: CGRectMake(WIDTH-time.bounds.size.width-83, 15, 71, 12))
        let timelab = UILabel(frame: CGRect(x: WIDTH-time.bounds.origin.x-125, y: 15, width: 71, height: 12))
        timelab.font = UIFont.systemFont(ofSize: 12)
        timelab.textColor = GREY
        timelab.text = "剩余答题时间"
        timelab.textAlignment = .right
        timelab.sizeToFit()
        //            backGound.addSubview(timelab)
        
    }
    
    
      // MARK:   底部按钮
    func bottomBtnClick(_ btn:UIButton) {
        // print(btn.tag)
        if numb == 1 {
            if btn.tag == 1 {
                btn.isUserInteractionEnabled = false
            }else{
                btn.isUserInteractionEnabled = true
            }
        }
        if numb == 100 {
            if btn.tag == 2 {
                btn.isUserInteractionEnabled = false
            }else{
                btn.isUserInteractionEnabled = true
            }
        }
        if btn.tag == 1 {
            numb -= 1
            let offSetX:CGFloat = CGFloat(numb) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            number.text = "\(numb+1)"
            number.sizeToFit()
        }else if btn.tag == 2 {
            numb += 1
            let offSetX:CGFloat = CGFloat(numb) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
            number.text = "\(numb+1)"
            number.sizeToFit()
        }else if btn.tag == 3 {
            //            if isSubmit==false {
            //                // print("请提交答案")
            //            }else{
            if over == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.questBack.frame = CGRect(x: 0, y: 65, width: WIDTH, height: HEIGHT-119)
                    self.grayBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-54)
                    if btn.tag == 4 {
                        self.btnTwo.setImage(UIImage(named: self.picArr[3]), for: UIControlState())
                        self.TitAns.textColor = GREY
                    }
                    self.hear = true
                })
                btn.setImage(UIImage(named: "ic_fenlei_sel.png"), for: UIControlState())
                TitQues.textColor = COLOR
                over = false
            }else{
                UIView.animate(withDuration: 0.3, animations: {
                    self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
                })
                btn.setImage(UIImage(named: picArr[2]), for: UIControlState())
                TitQues.textColor = GREY
                over = true
            }
            //            }
            
        }else if btn.tag == 4 {
            if hear == true {
                UIView.animate(withDuration: 0.3, animations: {
                    self.grayBack.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-54)
                    self.questBack.frame = CGRect(x: 0, y: HEIGHT, width: WIDTH, height: HEIGHT-119)
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
                })
                btn.setImage(UIImage(named: picArr[3]), for: UIControlState())
                TitAns.textColor = GREY
                hear = true
            }
            
        }else if btn.tag == 5 {
            // print(collection)
            // print("收藏")
            let examInfo = self.dataSource[self.pageControl.currentPage]
            let user = UserDefaults.standard
            let uid = user.string(forKey: "userid")
            // print(uid)
            if uid==nil {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let vc  = mainStoryboard.instantiateViewController(withIdentifier: "Login")
                //self.presentViewController(vc, animated: true, completion: nil)
                self.navigationController?.pushViewController(vc, animated: true)
                btn.setImage(UIImage(named: picArr[4]), for: UIControlState())
                TitCol.textColor = GREY
                collection = false
            }else if collection == false {
                
                let url = PARK_URL_Header+"addfavorite"
                let param = [
                    
                    "refid":examInfo.questionid,
                    "type":"1",
                    "userid":uid!,
                    "title":examInfo.post_title,
                    "description":examInfo.post_description
                ];
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in

//                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    // print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        // print("状态是")
                        // print(status.status)
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = status.errorData
                            hud?.margin = 10.0
                            hud?.removeFromSuperViewOnHide = true
                            hud?.hide(true, afterDelay: 3)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = "收藏成功"
                            hud?.margin = 10.0
                            hud?.removeFromSuperViewOnHide = true
                            hud?.hide(true, afterDelay: 3)
                            btn.setImage(UIImage(named: "btn_collect_sel.png"), for: UIControlState())
                            self.TitCol.textColor = COLOR
                            self.collection = true
                            // print(status.data)
                        }
                    }
                }
            }else{
                let url = PARK_URL_Header+"cancelfavorite"
                let param = [
                    
                    "refid":examInfo.questionid,
                    "type":"1",
                    "userid":uid!
                ];
                
                NurseUtil.net.request(RequestType.requestTypeGet, URLString: url, Parameter: param as [String : AnyObject]?) { (json, error) in
//
//                Alamofire.request(.GET, url, parameters: param as? [String:String] ).response { request, response, json, error in
                    // print(request)
                    if(error != nil){
                        
                    }else{
                        let status = Http(JSONDecoder(json!))
                        // print("状态是")
                        // print(status.status)
                        if(status.status == "error"){
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = status.errorData
                            hud?.margin = 10.0
                            hud?.removeFromSuperViewOnHide = true
                            hud?.hide(true, afterDelay: 3)
                        }
                        if(status.status == "success"){
                            
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = "取消收藏成功"
                            hud?.margin = 10.0
                            hud?.removeFromSuperViewOnHide = true
                            hud?.hide(true, afterDelay: 3)
                            btn.setImage(UIImage(named: self.picArr[4]), for: UIControlState())
                            self.TitCol.textColor = GREY
                            self.collection = false
                            // print(status.data)
                            
                        }
                    }
                    
                }
                
            }
        }
    }
    
    func setControlPage(_ animate:Bool){
        let offSetX:CGFloat = CGFloat(pageControl.currentPage) * WIDTH
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: animate)
    }
    
    func touchUp() {
        // print("触摸")
        self.bottomBtnClick(btnTwo)
    }
    //    选项
    func pleaseChooseOne(_ btn:UIButton) {
        
//        let backView = scrollView.viewWithTag(pageControl.currentPage+110)
//        let rightBtn = backView?.viewWithTag(rightAnswer[pageControl.currentPage] as! Int)
        //        rightBtn?.backgroundColor = UIColor.greenColor()
        //        if btn.tag != rightBtn?.tag {
        // MARK: 这里更改了选中答案的颜色
        //        btn.backgroundColor = UIColor.greenColor()
        let exam = dataSource[pageControl.currentPage]
        
        if hasChooseIndex.contains(pageControl.currentPage) {
            return
        }else{
            hasChooseIndex.add(pageControl.currentPage)
        }
        btn.backgroundColor = UIColor.red
        
        if self.pageControl.currentPage+1 > self.myChoose.count {
            if self.pageControl.currentPage>0{
                for i in self.myChoose.endIndex..<self.pageControl.currentPage {
                    self.myChoose.insert(0, at: i)
                    chooseId.insert("0", at: i)
                }
            }
            self.chooseId.append(exam.answers[btn.tag-1].id)
            self.myChoose.append(btn.tag)
        }else{
            self.myChoose.remove(at: pageControl.currentPage)
            chooseId.remove(at: pageControl.currentPage)
            self.myChoose.insert(btn.tag, at: pageControl.currentPage)
            chooseId.insert(exam.answers[btn.tag-1].id, at: pageControl.currentPage)
        }
        
        
        self.questionCard()
        pageControl.currentPage += 1
        setControlPage(true)
        self.AnswerView()
        
    }
    
    func answerBtnClicked(_ btn:UIButton) {
        btn.backgroundColor = UIColor.purple
        btn.setTitleColor(UIColor.white, for: UIControlState())
        pageControl.currentPage = btn.tag - 1
        setControlPage(false)
        resetQuestion()
    }
    
    func resetQuestion(){
        numb = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
        number.text = "\(numb+1)"
        number.sizeToFit()
        self.AnswerView()
        self.questionCard()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x)/Int(WIDTH) != pageControl.currentPage {
            pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
            numb = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
            number.text = "\(numb+1)"
            number.sizeToFit()
            self.AnswerView()
            self.questionCard()
        }
    }
}
