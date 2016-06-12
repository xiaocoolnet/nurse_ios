//
//  WordViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class WordViewController: UIViewController,UIScrollViewDelegate {

    let scrollView = UIScrollView()
    let pageControl = UIPageControl()
    //    var timer = NSTimer()
    let choose:[String] = ["A、消化道症状","B、胃液分析","C、胃镜检查","D、血清学检查","E、胃肠X线检查"]
    let picArr:[String] = ["btn_arrow_left.png","btn_arrow_right.png","ic_fenlei.png","btn_eye.png","btn_collet.png"]
    let picName:[String] = ["答题卡","答案","收藏"]
    var TitCol = UILabel()
    var TitAns = UILabel()
    var TitQues = UILabel()
    var btnOne = UIButton()
    var btnTwo = UIButton()
   
    let grayBack = UIView()
    var hear = Bool()
    
    let questBack = UIView()
    var over = Bool()
    
    var collection = Bool()
    
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        let rightBtn = UIBarButtonItem(title: "提交", style: .Done, target: self, action: #selector(self.takeUpTheTest))
        navigationItem.rightBarButtonItem = rightBtn
        
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.createScrollerView()
        self.backBottomView()
        
        self.questionCard()
        self.AnswerView()
        
        collection = true
        
        // Do any additional setup after loading the view.
    }
//    答题卡视图
    func questionCard() {
        questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
        questBack.backgroundColor = UIColor.whiteColor()
        over = true
        var window = UIWindow()
        window = ((UIApplication.sharedApplication().delegate?.window)!)!
        window.addSubview(questBack)
        
        let big = UIView(frame: CGRectMake(0, 44, WIDTH, HEIGHT-163))
        big.backgroundColor = COLOR
        questBack.addSubview(big)
        let smart = UIView(frame: CGRectMake(10, 10, WIDTH-20, HEIGHT-183))
        smart.backgroundColor = UIColor.whiteColor()
        smart.layer.cornerRadius = 5
        big.addSubview(smart)
        
    }
    //    答案视图
    func AnswerView() {
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
        
        
    }
    //    底部视图
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
//    答题区
    func createScrollerView() {
        scrollView.frame = CGRectMake(0, 1,WIDTH, HEIGHT-119)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        for i in 0...9 {
            let backView = UIView()
            let backGound = UIView(frame: CGRectMake(CGFloat(i)*WIDTH, 0, WIDTH,44))
            
            backView.frame = CGRectMake(CGFloat(i)*WIDTH, 44, WIDTH, HEIGHT-163)
            backView.backgroundColor = COLOR
            backView.tag = i+1
            let back = UIView(frame: CGRectMake(CGFloat(i)*WIDTH+10, 54, WIDTH-20, HEIGHT-221))
            back.backgroundColor = UIColor.whiteColor()
            back.layer.cornerRadius = 5
            let dian = UIImageView(frame: CGRectMake(10, 16, 12, 12))
            dian.image = UIImage(named: "ic_choice.png")
            backGound.addSubview(dian)
            let dianxuan = UILabel(frame: CGRectMake(24, 12.5, 40, 17))
            dianxuan.font = UIFont.systemFontOfSize(18)
            dianxuan.text = "单选题"
            dianxuan.sizeToFit()
            backGound.addSubview(dianxuan)
            let tit = UILabel(frame: CGRectMake(28+dianxuan.bounds.size.width, 18.5, 40, 12))
            tit.font = UIFont.systemFontOfSize(12)
            tit.textColor = GREY
            tit.text = "（A1，2分）"
            tit.sizeToFit()
            backGound.addSubview(tit)
            let time = UILabel(frame: CGRectMake(WIDTH-50, 14, 40, 12))
            time.font = UIFont.systemFontOfSize(14)
            time.textAlignment = .Right
            time.textColor = COLOR
            time.text = "02:59"
            time.sizeToFit()
            backGound.addSubview(time)
            let timelab = UILabel(frame: CGRectMake(WIDTH-time.bounds.size.width-83, 15, 71, 12))
            timelab.font = UIFont.systemFontOfSize(12)
            timelab.textColor = GREY
            timelab.text = "剩余答题时间"
            timelab.textAlignment = .Right
            timelab.sizeToFit()
            backGound.addSubview(timelab)
            let question = UILabel(frame: CGRectMake(WIDTH*20/375, WIDTH*15/375, back.bounds.size.width-WIDTH*38/375, 40))
            question.numberOfLines = 0
            question.textAlignment = .Natural
            question.font = UIFont.systemFontOfSize(14)
            question.text = "1、你看过海鸥捕食吗？ 一群海鸥绕着海岸飞啊飞啊， 看准了水下的鱼，收了翅膀， 一猛子就扎下去， 那样子，根本就像寻死。 自由落体似的掉进水里，不管不顾，就如同爱情。 只不过，有的满载而归， 有的，一无所获……"
            question.sizeToFit()
            back.addSubview(question)
            
            
            for j in 0...4 {
                let tit = UILabel(frame: CGRectMake(WIDTH*51/375, back.bounds.size.height-WIDTH*316/375+CGFloat(j)*65/375*WIDTH, WIDTH/2, 17))
                tit.font = UIFont.systemFontOfSize(18)
                tit.textColor = COLOR
                tit.text = choose[j]
                tit.sizeToFit()
                back.addSubview(tit)

                let btn = UIButton(frame: CGRectMake(WIDTH*21/375, back.bounds.size.height-WIDTH*330/375+CGFloat(j)*66/375*WIDTH, WIDTH*314/375, WIDTH*46/375))
                btn.tag = j+1
                btn.layer.cornerRadius = WIDTH*23/375
                btn.layer.borderColor = COLOR.CGColor
                btn.layer.borderWidth = 1
                btn.addTarget(self, action: #selector(self.pleaseChooseOne(_:)), forControlEvents: .TouchUpInside)
                back.addSubview(btn)
                
            }
            
            scrollView.addSubview(backGound)
            scrollView.addSubview(backView)
            scrollView.addSubview(back)
        }

        scrollView.contentSize = CGSizeMake(10*WIDTH, 0)
        scrollView.contentOffset = CGPointMake(0, 0)
        view.addSubview(scrollView)
        
        pageControl.frame = CGRectMake(0, HEIGHT-167, WIDTH, 48)
        pageControl.pageIndicatorTintColor = UIColor.redColor()
        pageControl.addTarget(self, action: #selector(self.pageContorllerNumber(_:)), forControlEvents: .TouchUpInside)
        pageControl.numberOfPages = 10
        pageControl.currentPage = 0
        self.view.addSubview(self.pageControl)
    }
    func pageContorllerNumber(pageControl:UIPageControl) {
        
        let offSetX:CGFloat = CGFloat(pageControl.currentPage) * WIDTH
        scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
    }
//    底部按钮
    func bottomBtnClick(btn:UIButton) {
        print(btn.tag)
        if btn.tag == 1 {
            self.pageControl.currentPage -= 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
        }else if btn.tag == 2 {
            self.pageControl.currentPage += 1
            let offSetX:CGFloat = CGFloat(self.pageControl.currentPage) * WIDTH
            scrollView.setContentOffset(CGPoint(x: offSetX,y: 0), animated: true)
        }else if btn.tag == 3 {
            if over == true {
                UIView.animateWithDuration(0.3, animations: {
                    self.questBack.frame = CGRectMake(0, 65, WIDTH, HEIGHT-119)
                    self.grayBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-54)
                    if btn.tag == 4 {
                        self.btnTwo.setImage(UIImage(named: self.picArr[3]), forState: .Normal)
                        self.TitAns.textColor = GREY
                    }
                    self.hear = true
                })
                btn.setImage(UIImage(named: "ic_fenlei_sel.png"), forState: .Normal)
                TitQues.textColor = COLOR
                over = false
            }else{
                UIView.animateWithDuration(0.3, animations: {
                    self.questBack.frame = CGRectMake(0, HEIGHT, WIDTH, HEIGHT-119)
                })
                btn.setImage(UIImage(named: picArr[2]), forState: .Normal)
                TitQues.textColor = GREY
                over = true
            }
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
            if collection == true {
                btn.setImage(UIImage(named: "btn_collect_sel.png"), forState: .Normal)
                TitCol.textColor = COLOR
                collection = false
            }else{
                btn.setImage(UIImage(named: picArr[4]), forState: .Normal)
                TitCol.textColor = GREY
                collection = true
            }
        }
        
        
    }
    func touchUp() {
        print("触摸")
        self.bottomBtnClick(btnTwo)
    }
//    选项
    func pleaseChooseOne(btn:UIButton) {
        print(btn.tag)
        
        
    }
    func takeUpTheTest() {
        print("提交")
        
        
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x)/Int(self.view.frame.size.width)
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
