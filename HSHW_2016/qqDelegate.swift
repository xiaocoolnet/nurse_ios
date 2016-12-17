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
//            hud.label.text = "\(sendResp.result)\n\(sendResp.errorDescription)"
//            hud.margin = 10.0
//            hud.removeFromSuperViewOnHide = true
//            hud.hide(animated: true, afterDelay: 1)
            
            if sendResp.result == "0" {
                NewsPageHelper().addScore_fenxiang({ (success, response) in
                    if success {
                        
                        
                        if success {
                            let result = response as! addScore_ReadingInformationDataModel
                            NursePublicAction.showScoreTips(UIApplication.shared.keyWindow!, nameString: result.event, score: result.score)
                        }
                        //                    let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
                        //                    hud.mode = MBProgressHUDMode.Text;
                        //                    hud.label.text = "分享成功 积分增加"
                        //                    
                        //                    hud.margin = 10.0
                        //                    hud.removeFromSuperViewOnHide = true
                        //                    hud.hide(animated: true, afterDelay: 1)
                    }else{
                        let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                        hud.mode = MBProgressHUDMode.text;
                        hud.label.text = "分享成功"
                        
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(animated: true, afterDelay: 1)
                    }
                })
            }else{
                let hud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                hud.mode = MBProgressHUDMode.text;
                hud.label.text = "分享失败"
                
                hud.margin = 10.0
                hud.removeFromSuperViewOnHide = true
                hud.hide(animated: true, afterDelay: 1)
            }
            
        default:
            break
        }
    }
    
    func isOnlineResponse(_ response: [AnyHashable: Any]!) {
        
    }
    
}
