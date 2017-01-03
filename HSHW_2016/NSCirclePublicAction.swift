//
//  NSCirclePublicAction.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCirclePublicAction: NSObject {
    
    class func getAuthColor(with authType:String) -> UIColor {
        switch authType {
        case "在校生","毕业生":
            return UIColor(red: 110/255.0, green: 192/255.0, blue: 56/255.0, alpha: 1)
        case "护士","护师","主管护师":
            return UIColor(red: 128/255.0, green: 0, blue: 128/255.0, alpha: 1)
        case "护士长","主任":
            return UIColor(red: 100/255.0, green: 179/255.0, blue: 223/255.0, alpha: 1)
        default:
            return COLOR
        }
    }
    
    // MARK: - 数据
    func getReportArray() -> [String] {
        let reportArray = ["诽谤辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈（酒托、话费托等行为）","违法行为（涉毒、暴恐、违禁品等行为）"]
        return reportArray
    }
    func getRewardArray() -> [String] {
        let rewardArray = ["1","2","5","10"]
        return rewardArray
    }
    
    // MARK: - 显示举报弹窗
    func showReportAlert() {
        
        let buttonFontSize:CGFloat = 14
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "请告诉我们您举报的理由"
        alert.addSubview(titleLab)
        
        let buttonHeight:CGFloat = 30
        let buttonMargin:CGFloat = 10
        var buttonWidth:CGFloat = (alert.frame.width-116-buttonMargin)/2.0
        var buttonX:CGFloat = 58
        var buttonY = titleLab.frame.maxY+25
        
        for (i,buttonTitle) in getReportArray().enumerated() {
            switch i {
            case 0:
                buttonX = 58
                buttonWidth = 125
                
            case 1:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 2:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = 125
                
            case 3:
                buttonX = 58+(buttonWidth+buttonMargin)
                buttonWidth = 125
                
            case 4:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            case 5:
                buttonY = buttonY+buttonHeight+buttonMargin
                buttonX = 58
                buttonWidth = alert.frame.width-116
                
            default:
                break
            }
            
            let button = UIButton(frame: CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
            button.layer.borderWidth = 1/UIScreen.main.scale
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.backgroundColor = i == 0 ? COLOR:UIColor.clear
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseReportType(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let reportBtn = UIButton(frame: CGRect(x: 35, y: buttonY+buttonHeight+35, width: alert.frame.width-70, height: 40))
        reportBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        reportBtn.layer.cornerRadius = 6
        reportBtn.setTitle("确认举报", for: UIControlState())
        
        reportBtn.setTitleColor(UIColor.white, for: UIControlState())
        reportBtn.backgroundColor = COLOR
        
        reportBtn.addTarget(self, action: #selector(sureReportBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(reportBtn)
        
        alert.frame.size.height = reportBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        }) 
    }
    
    // MARK: - 选择举报理由
    func chooseReportType(_ typeBtn:UIButton) {
        
        for subView in (typeBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor.clear
                    
                }
            }
        }
        
        typeBtn.isSelected = true
        typeBtn.backgroundColor = COLOR
        
        //        reportType = reportArray[typeBtn.tag-1000]
        //        print(reportType)
        print(getReportArray()[typeBtn.tag-1000])
        
    }
    
    // MARK: - 确认举报
    func sureReportBtnClick(_ rewardBtn:UIButton) {

        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getReportArray()[button.tag-1000])
                    alertCancel(rewardBtn)
                }
            }
        }
    }
    
    // MARK: - 显示打赏弹窗
    func showAlert() {
        
        let buttonFontSize:CGFloat = 24
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.white
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFont(ofSize: 18).lineHeight))
        titleLab.font = UIFont.systemFont(ofSize: 18)
        titleLab.textAlignment = .center
        titleLab.textColor = UIColor.black
        titleLab.text = "好的文章，就是要打赏"
        alert.addSubview(titleLab)
        
        let noteLab = UILabel(frame: CGRect(x: 0, y: titleLab.frame.maxY+8, width: alert.frame.width, height: UIFont.systemFont(ofSize: 12).lineHeight))
        noteLab.font = UIFont.systemFont(ofSize: 12)
        noteLab.textAlignment = .center
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.text = "可用护士币：1324"
        alert.addSubview(noteLab)
        
        let buttonWidth:CGFloat = 50
        let buttonMargin = (alert.frame.width-70-buttonWidth*4)/3.0
        
        for (i,buttonTitle) in getRewardArray().enumerated() {
            
            let button = UIButton(frame: CGRect(x: 35+(buttonWidth+buttonMargin)*CGFloat(i), y: noteLab.frame.maxY+25, width: buttonWidth, height: buttonWidth))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.layer.cornerRadius = buttonWidth/2.0
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), for: UIControlState())
            button.setTitleColor(UIColor.white, for: .selected)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
            button.isSelected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseRewardCount(_:)), for: .touchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let rewardBtn = UIButton(frame: CGRect(x: 35, y: noteLab.frame.maxY+25+buttonWidth+25, width: alert.frame.width-70, height: 40))
        rewardBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        rewardBtn.layer.cornerRadius = 6
        rewardBtn.setTitle("打赏", for: UIControlState())
        
        rewardBtn.setTitleColor(UIColor.white, for: UIControlState())
        rewardBtn.backgroundColor = COLOR
        
        rewardBtn.addTarget(self, action: #selector(sureRewardBtnClick(_:)), for: .touchUpInside)
        
        alert.addSubview(rewardBtn)
        
        alert.frame.size.height = rewardBtn.frame.maxY+25
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        }) 
    }
    
    // MARK: - 选择打赏护士币数量
    func chooseRewardCount(_ countBtn:UIButton) {
        
        for subView in (countBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.isSelected = false
                    button.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                    
                }
            }
        }
        
        countBtn.isSelected = true
        countBtn.backgroundColor = COLOR
        
//        rewardCount = rewardArray[countBtn.tag-1000]
//        print(rewardCount)
        print(countBtn.tag-1000)
        print(getRewardArray()[countBtn.tag-1000])
    }
    
    // MARK: - 确认打赏
    func sureRewardBtnClick(_ rewardBtn:UIButton) {

        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.isSelected {
                    
                    print(button.tag,getRewardArray()[button.tag-1000])
                    alertCancel(rewardBtn)

                }
            }
        }
    }
    
    // MARK: - 显示加精置顶等弹出 sheet
    func showSheet(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor], forumId:String) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.black
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
        UIApplication.shared.keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.white
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            
            button.tag = NSString(string: forumId).integerValue*100+i
            button.titleLabel?.font = UIFont.systemFont(ofSize: buttonFontSize)
            button.setTitle(buttonTitle, for: UIControlState())
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), for: UIControlState())
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), for: .touchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), for: .touchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.main.scale, width: button.frame.width, height: 1/UIScreen.main.scale))
            line.backgroundColor = UIColor.lightGray
            button.addSubview(line)
        }
        
        UIView.animate(withDuration: animateWithDuration, animations: {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        }) 
    }
    
    // MARK: - 弹出 sheet 点击选项
    func alertActionClick(_ action:UIButton) {
        print(action.tag)
        
        if action.currentTitle == "举报" {
            alertCancel(action)
            self.showReportAlert()
        }else if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除贴子","取消"], buttonTitleColorArray: [UIColor.black,UIColor.lightGray], forumId: String(action.tag/100))
        }else if action.currentTitle == "删除贴子" {
            alertCancel(action)
            print("删除贴子")
            CircleNetUtil.DeleteForum(tid: String(action.tag/100), handle: { (success, response) in
                if success {
                    print("删除贴子成功")
                }else{
                    print("删除贴子失败")
                }
            })
        }
    }
    
    func alertCancel(_ action:UIView) {
        if action.superview == UIApplication.shared.keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
        }
    }
}
