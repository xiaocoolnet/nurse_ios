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
    
    func onReq(_ req: QQBaseReq!) {
        switch (req.type){
        case Int32(EGETMESSAGEFROMQQREQTYPE.rawValue):
            break;
        default:
            break;
        }
    }
    
    func onResp(_ resp: QQBaseResp!) {
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
                        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
                        hud?.mode = MBProgressHUDMode.text;
                        hud?.labelText = "分享成功"
                        print(hud?.labelText)
                        hud?.margin = 10.0
                        hud?.removeFromSuperViewOnHide = true
                        hud?.hide(true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
                hud?.mode = MBProgressHUDMode.text;
                hud?.labelText = "分享失败"
                print(hud?.labelText)
                hud?.margin = 10.0
                hud?.removeFromSuperViewOnHide = true
                hud?.hide(true, afterDelay: 1)
            }
            
        default:
            break
        }
    }
    
    func isOnlineResponse(_ response: [AnyHashable: Any]!) {
        
    }
    
    // MARK: 显示积分提示
    func showScoreTips(_ name:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow, animated: true)
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

}
