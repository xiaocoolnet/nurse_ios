//
//  NSCirclePublicAction.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCirclePublicAction: NSObject {
    
    // MARK: - 数据
    class func getReportArray() -> [String] {
        let reportArray = ["诽谤辱骂","淫秽色情","垃圾广告","血腥暴力","欺诈（酒托、话费托等行为）","违法行为（涉毒、暴恐、违禁品等行为）"]
        return reportArray
    }
    class func getRewardArray() -> [String] {
        let rewardArray = ["1","2","5","10"]
        return rewardArray
    }
    
    // MARK: - 显示举报弹窗
    class func showReportAlert() {
        
        let buttonFontSize:CGFloat = 14
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
        UIApplication.sharedApplication().keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.whiteColor()
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFontOfSize(18).lineHeight))
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textAlignment = .Center
        titleLab.textColor = UIColor.blackColor()
        titleLab.text = "请告诉我们您举报的理由"
        alert.addSubview(titleLab)
        
        let buttonHeight:CGFloat = 30
        let buttonMargin:CGFloat = 10
        var buttonWidth:CGFloat = (alert.frame.width-116-buttonMargin)/2.0
        var buttonX:CGFloat = 58
        var buttonY = titleLab.frame.maxY+25
        
        for (i,buttonTitle) in getReportArray().enumerate() {
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
            button.titleLabel?.font = UIFont.systemFontOfSize(buttonFontSize)
            button.titleLabel?.adjustsFontSizeToFitWidth = true
            button.layer.cornerRadius = 3
            button.layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
            button.layer.borderWidth = 1/UIScreen.mainScreen().scale
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            
            button.setTitle(buttonTitle, forState: .Normal)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor.clearColor()
            button.selected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseReportType(_:)), forControlEvents: .TouchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let reportBtn = UIButton(frame: CGRect(x: 35, y: buttonY+buttonHeight+35, width: alert.frame.width-70, height: 40))
        reportBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        reportBtn.layer.cornerRadius = 6
        reportBtn.setTitle("确认举报", forState: .Normal)
        
        reportBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        reportBtn.backgroundColor = COLOR
        
        reportBtn.addTarget(self, action: #selector(sureReportBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        alert.addSubview(reportBtn)
        
        alert.frame.size.height = reportBtn.frame.maxY+25
        
        UIView.animateWithDuration(animateWithDuration) {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        }
    }
    
    // MARK: - 选择举报理由
    class func chooseReportType(typeBtn:UIButton) {
        
        for subView in (typeBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.selected = false
                    button.backgroundColor = UIColor.clearColor()
                    
                }
            }
        }
        
        typeBtn.selected = true
        typeBtn.backgroundColor = COLOR
        
        //        reportType = reportArray[typeBtn.tag-1000]
        //        print(reportType)
        print(getReportArray()[typeBtn.tag-1000])
        
    }
    
    // MARK: - 确认举报
    class func sureReportBtnClick(rewardBtn:UIButton) {

        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.selected {
                    
                    print(button.tag,getReportArray()[button.tag-1000])
                    alertCancel(rewardBtn)
                }
            }
        }
    }
    
    // MARK: - 显示打赏弹窗
    class func showAlert() {
        
        let buttonFontSize:CGFloat = 24
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
        UIApplication.sharedApplication().keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: WIDTH*0.06, y: HEIGHT, width: WIDTH*0.88, height: 0))
        alert.backgroundColor = UIColor.whiteColor()
        alert.layer.cornerRadius = 8
        bgView.addSubview(alert)
        
        let titleLab = UILabel(frame: CGRect(x: 0, y: 20, width: alert.frame.width, height: UIFont.systemFontOfSize(18).lineHeight))
        titleLab.font = UIFont.systemFontOfSize(18)
        titleLab.textAlignment = .Center
        titleLab.textColor = UIColor.blackColor()
        titleLab.text = "好的文章，就是要打赏"
        alert.addSubview(titleLab)
        
        let noteLab = UILabel(frame: CGRect(x: 0, y: titleLab.frame.maxY+8, width: alert.frame.width, height: UIFont.systemFontOfSize(12).lineHeight))
        noteLab.font = UIFont.systemFontOfSize(12)
        noteLab.textAlignment = .Center
        noteLab.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1)
        noteLab.text = "可用护士币：1324"
        alert.addSubview(noteLab)
        
        let buttonWidth:CGFloat = 50
        let buttonMargin = (alert.frame.width-70-buttonWidth*4)/3.0
        
        for (i,buttonTitle) in getRewardArray().enumerate() {
            
            let button = UIButton(frame: CGRect(x: 35+(buttonWidth+buttonMargin)*CGFloat(i), y: noteLab.frame.maxY+25, width: buttonWidth, height: buttonWidth))
            button.tag = 1000+i
            button.titleLabel?.font = UIFont.systemFontOfSize(buttonFontSize)
            button.layer.cornerRadius = buttonWidth/2.0
            button.setTitle(buttonTitle, forState: .Normal)
            
            button.setTitleColor(UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1), forState: .Normal)
            button.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            
            button.backgroundColor = i == 0 ? COLOR:UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
            button.selected = i == 0 ? true:false
            
            button.addTarget(self, action: #selector(chooseRewardCount(_:)), forControlEvents: .TouchUpInside)
            
            alert.addSubview(button)
            
        }
        
        let rewardBtn = UIButton(frame: CGRect(x: 35, y: noteLab.frame.maxY+25+buttonWidth+25, width: alert.frame.width-70, height: 40))
        rewardBtn.titleLabel?.font = UIFont.systemFontOfSize(18)
        rewardBtn.layer.cornerRadius = 6
        rewardBtn.setTitle("打赏", forState: .Normal)
        
        rewardBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        rewardBtn.backgroundColor = COLOR
        
        rewardBtn.addTarget(self, action: #selector(sureRewardBtnClick(_:)), forControlEvents: .TouchUpInside)
        
        alert.addSubview(rewardBtn)
        
        alert.frame.size.height = rewardBtn.frame.maxY+25
        
        UIView.animateWithDuration(animateWithDuration) {
            
            alert.frame.origin.y = (HEIGHT-alert.frame.size.height)/2.0
        }
    }
    
    // MARK: - 选择打赏护士币数量
    class func chooseRewardCount(countBtn:UIButton) {
        
        for subView in (countBtn.superview?.subviews ?? [UIView]())! {
            if subView.tag >= 1000 && subView.tag <= 2000 {
                if subView is UIButton {
                    let button = subView as! UIButton
                    button.selected = false
                    button.backgroundColor = UIColor(red: 229/255.0, green: 229/255.0, blue: 229/255.0, alpha: 1)
                    
                }
            }
        }
        
        countBtn.selected = true
        countBtn.backgroundColor = COLOR
        
//        rewardCount = rewardArray[countBtn.tag-1000]
//        print(rewardCount)
        print(countBtn.tag-1000)
        print(getRewardArray()[countBtn.tag-1000])
    }
    
    // MARK: - 确认打赏
    class func sureRewardBtnClick(rewardBtn:UIButton) {

        for subView in (rewardBtn.superview?.subviews ?? [UIView]())! {
            if (subView.tag >= 1000 && subView.tag <= 2000) && subView is UIButton {
                let button = subView as! UIButton
                if button.selected {
                    
                    print(button.tag,getRewardArray()[button.tag-1000])
                    alertCancel(rewardBtn)

                }
            }
        }
    }
    
    // MARK: - 显示加精置顶等弹出 sheet
    class func showSheet(with buttonTitleArray:[String], buttonTitleColorArray:[UIColor]) {
        
        let buttonFontSize:CGFloat = 15
        let buttonTitleDefaultColor = UIColor.blackColor()
        let animateWithDuration = 0.3
        
        let bgView = UIButton(frame: CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT))
        bgView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        bgView.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
        UIApplication.sharedApplication().keyWindow?.addSubview(bgView)
        
        let alert = UIView(frame: CGRect(x: 0, y: HEIGHT, width: WIDTH, height: 0))
        alert.backgroundColor = UIColor.whiteColor()
        bgView.addSubview(alert)
        
        for (i,buttonTitle) in buttonTitleArray.enumerate() {
            let button = UIButton(frame: CGRect(x: 0, y: 44*CGFloat(i), width: WIDTH, height: 44))
            button.tag = 100+i
            button.titleLabel?.font = UIFont.systemFontOfSize(buttonFontSize)
            button.setTitle(buttonTitle, forState: .Normal)
            
            button.setTitleColor((i<buttonTitleColorArray.count ? buttonTitleColorArray[i]:buttonTitleDefaultColor), forState: .Normal)
            if i == buttonTitleArray.count-1 {
                button.addTarget(self, action: #selector(alertCancel(_:)), forControlEvents: .TouchUpInside)
            }else{
                button.addTarget(self, action: #selector(alertActionClick(_:)), forControlEvents: .TouchUpInside)
            }
            alert.addSubview(button)
            
            let line = UIView(frame: CGRect(x: 0, y: button.frame.height-1/UIScreen.mainScreen().scale, width: button.frame.width, height: 1/UIScreen.mainScreen().scale))
            line.backgroundColor = UIColor.lightGrayColor()
            button.addSubview(line)
        }
        
        UIView.animateWithDuration(animateWithDuration) {
            
            alert.frame = CGRect(x: 0, y: HEIGHT-44*CGFloat(buttonTitleArray.count), width: WIDTH, height: 44*CGFloat(buttonTitleArray.count))
        }
    }
    
    // MARK: - 弹出 sheet 点击选项
    class func alertActionClick(action:UIButton) {
        print(action.tag)
        
        if action.currentTitle == "举报" {
            alertCancel(action)
            self.showReportAlert()
        }else if action.currentTitle == "删除" {
            alertCancel(action)
            self.showSheet(with: ["删除帖子","取消"], buttonTitleColorArray: [UIColor.blackColor(),UIColor.lightGrayColor()])
        }else if action.currentTitle == "删除帖子" {
            alertCancel(action)
            print("删除帖子")
        }
    }
    
    class func alertCancel(action:UIView) {
        if action.superview == UIApplication.sharedApplication().keyWindow {
            action.removeFromSuperview()
        }else{
            alertCancel(action.superview!)
        }
    }
}
