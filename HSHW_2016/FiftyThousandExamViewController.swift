//
//  FiftyThousandExamViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/11/4.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class FiftyThousandExamViewController: UIViewController {
    
    var term_id = ""
    
    let cateId = [
        "130":["185","186","187","188","189","190"],
        "131":["191","192","193","194","195","196"],
        "132":["197","198","199","200","201","202"]
    ]
    
    let imageNameArray = ["模拟试题","历年真题","考前冲刺","辅导精华","核心考点","押题密卷"]
    let nameArray = ["模拟试题","历年真题","考前冲刺","辅导精华","核心考点","押题密卷"]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("学习 8万题库 "+(self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("学习 8万题库 "+(self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setSubviews()
    }
    
    // MARK: 设置子视图
    func setSubviews() {
        
//        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
//        line.backgroundColor = COLOR
//        self.view.addSubview(line)
//        self.view.backgroundColor = UIColor.whiteColor()
        
        let rootScrollView = UIScrollView(frame: CGRectMake(0, 1, WIDTH, HEIGHT-64-40-1))
        self.view.addSubview(rootScrollView)
        
        let sideMargin:CGFloat = 30
        let midMargin:CGFloat = sideMargin
        let bgBtnWidth:CGFloat = (WIDTH-2*sideMargin-2*midMargin)/3.0
        var bgBtnHeight:CGFloat = 0
        
        for (i,imageName) in imageNameArray.enumerate() {
            
            bgBtnHeight = bgBtnWidth + 5 + calculateHeight(nameArray[i], size: 13, width: bgBtnWidth)
            
            let bgBtn = UIButton(frame: CGRectMake(
                sideMargin+bgBtnWidth*CGFloat(i%3)+midMargin*CGFloat(i%3),
                sideMargin+bgBtnHeight*CGFloat(i/3)+midMargin*CGFloat(i/3),
                bgBtnWidth,
                bgBtnHeight))
            bgBtn.tag = 100+i
            bgBtn.addTarget(self, action: #selector(btnClick(_:)), forControlEvents: .TouchUpInside)
            rootScrollView.addSubview(bgBtn)
            
            let imageBgView = UIImageView(frame: CGRectMake(0, 0, bgBtnWidth, bgBtnWidth))
            imageBgView.layer.cornerRadius = bgBtnWidth/2.0
            imageBgView.clipsToBounds = true
            imageBgView.backgroundColor = UIColor(red: 243/255.0, green: 229/255.0, blue: 242/255.0, alpha: 1)
            bgBtn.addSubview(imageBgView)
            
            let imageView1 = UIImageView(frame: CGRectMake(bgBtnWidth/4.0, bgBtnWidth/4.0, bgBtnWidth/2.0, bgBtnWidth/2.0))
            imageView1.contentMode = .ScaleAspectFit
            imageView1.image = UIImage(named: imageName)
            bgBtn.addSubview(imageView1)
            
            let titLab = UILabel(frame: CGRectMake(0, CGRectGetMaxY(imageBgView.frame)+5, bgBtnWidth, calculateHeight(nameArray[i], size: 13, width: bgBtnWidth)))
            titLab.font = UIFont.systemFontOfSize(13)
            titLab.textColor = UIColor.blackColor()
            titLab.textAlignment = .Center
            titLab.text = nameArray[i]
            bgBtn.addSubview(titLab)
            
            
            rootScrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(titLab.frame))
        }
    }
    
    func btnClick(btn:UIButton) {
        
        let fiftyThousandExamController = FiftyThousandExamSubCateViewController()
        fiftyThousandExamController.term_id = cateId[self.term_id]![btn.tag-100]
        fiftyThousandExamController.term_name = (self.title ?? "")!
        fiftyThousandExamController.title = nameArray[btn.tag-100]
        self.navigationController?.pushViewController(fiftyThousandExamController, animated: true)
        
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
