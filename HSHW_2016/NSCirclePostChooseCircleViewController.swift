//
//  NSCirclePostChooseCircleViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

protocol ChooseCircleDelegate {
    func chooseCircle(circle:PublishCommunityDataCommunityModel)
}


class NSCirclePostChooseCircleViewController: UIViewController {

    let circleArray = [
        ["cate":"交流","circle":["一线护士心声","学习交流","工作经验分享","灌水吐槽","晒照片"]],
        ["cate":"护士站","circle":["内科","外科","妇产科","儿科","急诊科","手术室","ICU","护理部","实习生"]],
        ["cate":"护理管理","circle":["我是护士长","我是护理部主任","管理经验分享","学术会议"]],
        ["cate":"考试","circle":["护士资格","初级护师","主管护师（中级）","副主任护师","主任护师","专升本","护理硕士研究生","护理博士站"]],
    ]
    
    var communityModelArray = [PublishCommunityDataModel]()

    var selectedCircle = PublishCommunityDataCommunityModel()
    
    var delegate:ChooseCircleDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSubviews()
        self.loadData()
    }
    
    func loadData() {
        
        CircleNetUtil.getPublishCommunity(userid: QCLoginUserInfo.currentInfo.userid, parentid: "295") { (success, response) in
            self.communityModelArray = response as! [PublishCommunityDataModel]
            self.setCircleList()
        }
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.title = "选择发布圈子"
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "确定", style: .done, target: self, action: #selector(sureBtnClick))
        
        let line1 = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line1.backgroundColor = COLOR
        self.view.addSubview(line1)
        
    }
    
    // MARK: - 设置圈子列表
    func setCircleList() {
        
        let rootScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-65))
        self.view.addSubview(rootScrollView)
        
        let padding:CGFloat = 10
        let margin:CGFloat = 10

        var cateY:CGFloat = 10
        
        for (i,circle) in communityModelArray.enumerated() {
            
            let cateLab = UILabel(frame: CGRect(x: padding, y: cateY, width: 0, height: 0))
            cateLab.textColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1)
            cateLab.font = UIFont.systemFont(ofSize: 14)
            cateLab.text = circle.name
            cateLab.sizeToFit()
            rootScrollView.addSubview(cateLab)
            
            let line = UIView(frame: CGRect(x: cateLab.frame.maxX+margin, y: 0, width: WIDTH-(cateLab.frame.maxX+margin)-padding, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1)
            line.center.y = cateLab.center.y
            rootScrollView.addSubview(line)
            
            let subCircleArray = circle.community
            
            var circleBtnX:CGFloat = padding
            var circleBtnY:CGFloat = cateLab.frame.maxY+margin
            let circleBtnHeight:CGFloat = 30

            for (j,subCircle) in subCircleArray.enumerated() {
                
                let circleBtn = UIButton(frame: CGRect(x: circleBtnX, y: circleBtnY, width: calculateWidth(subCircle.community_name, size: 14, height: circleBtnHeight)+16, height: circleBtnHeight))
                circleBtn.tag = (i+1)*1000+j
                circleBtn.layer.cornerRadius = 3
                circleBtn.layer.borderColor = COLOR.cgColor
                circleBtn.layer.borderWidth = 1
                circleBtn.backgroundColor = UIColor.white
                
                circleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                circleBtn.setTitleColor(COLOR, for: UIControlState())
                circleBtn.setTitleColor(UIColor.white, for: .selected)
                
                circleBtn.setTitle(subCircle.community_name, for: UIControlState())
                circleBtn.addTarget(self, action: #selector(circleBtnClick(_:)), for: .touchUpInside)
                rootScrollView.addSubview(circleBtn)
                
                if j+1 < subCircleArray.count {
                    let nextBtnWidth = calculateWidth(subCircleArray[j+1].community_name, size: 14, height: circleBtnHeight)+16
                    if circleBtn.frame.maxX+margin+nextBtnWidth <= WIDTH-padding {
                        circleBtnX = circleBtn.frame.maxX+margin
                    }else{
                        circleBtnX = padding
                        circleBtnY = circleBtn.frame.maxY+margin
                    }
                }
            }
            
            cateY = circleBtnY+circleBtnHeight+margin
        }
    }
    
    // MARK: - 点击圈子
    func circleBtnClick(_ circleBtn:UIButton) {
        print("点击圈子 \(circleBtn.currentTitle)")
        
        for circleView in (circleBtn.superview?.subviews ?? [])! {
            if circleView is UIButton && circleView.tag >= 1000 {
                let circle = circleView as! UIButton
                if circle.isSelected {
                    circle.isSelected = false
                    circle.backgroundColor = UIColor.white
                    break
                }
            }
        }
        
        circleBtn.isSelected = true
        circleBtn.backgroundColor = COLOR
        
        selectedCircle = self.communityModelArray[circleBtn.tag/1000-1].community[circleBtn.tag%1000]
//        selectedCircle = (circleBtn.currentTitle ?? "")!
    }
    
    // MARK: - 点击确定按钮
    func sureBtnClick() {
        print("点击确定按钮  选择的圈子是  \(selectedCircle.community_name)")
        
        if selectedCircle.community_name == "" {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
            hud.mode = .text
            hud.label.text = "请选择圈子"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        self.delegate?.chooseCircle(circle: selectedCircle)
        
        _ = self.navigationController?.popViewController(animated: true)
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
