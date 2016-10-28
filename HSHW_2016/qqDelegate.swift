//
//  qqDelegate.swift
//  HSHW_2016
//
//  Created by zhang on 16/8/19.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class qqDelegate: NSObject,QQApiInterfaceDelegate {
    
    func onReq(req: QQBaseReq!) {
        switch (req.type){
        case Int32(EGETMESSAGEFROMQQREQTYPE.rawValue):
            break;
        default:
            break;
        }
    }
    
    func onResp(resp: QQBaseResp!) {
        switch resp.type {
        case Int32(ESENDMESSAGETOQQRESPTYPE.rawValue):
            let sendResp = resp as! SendMessageToQQResp
//            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
//            //            hud.mode = MBProgressHUDMode.Text;
//            hud.labelText = "\(sendResp.result)\n\(sendResp.errorDescription)"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(true, afterDelay: 1)
            
            if sendResp.result == "0" {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success {
                        
                        
                        if success {
                            let result = response as! addScore_ReadingInformationDataModel
                            self.showScoreTips(result.event, score: result.score)
                        }
                        //                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        //                    hud.mode = MBProgressHUDMode.Text;
                        //                    hud.labelText = "分享成功 积分增加"
                        //                    print(hud.labelText)
                        //                    hud.margin = 10.0
                        //                    hud.removeFromSuperViewOnHide = true
                        //                    hud.hide(true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "分享成功"
                        print(hud.labelText)
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                hud.mode = MBProgressHUDMode.Text;
                hud.labelText = "分享失败"
                print(hud.labelText)
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(true, afterDelay: 1)
            }
            
        default:
            break
        }
    }
    
    func isOnlineResponse(response: [NSObject : AnyObject]!) {
        
    }
    
    // MARK: 显示积分提示
    func showScoreTips(name:String, score:String) {
        let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
        hud.opacity = 0.3
        hud.margin = 10
        hud.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud.mode = .CustomView
        let customView = UIImageView(frame: CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*30/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .Left
        titLab.font = UIFont.systemFontOfSize(16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .Left
        scoreLab.font = UIFont.systemFontOfSize(24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRectMake(
            CGRectGetMaxX(scoreLab.frame)+5,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)-CGRectGetMaxX(scoreLab.frame)-5-CGRectGetWidth(customView.frame)*13/537,
            CGRectGetHeight(customView.frame)*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .Center
        jifenLab.font = UIFont.systemFontOfSize(16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud.customView = customView
        hud.hide(true, afterDelay: 3)
    }

}
