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
            let hud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow, animated: true)
            //            hud.mode = MBProgressHUDMode.Text;
            hud.labelText = "\(sendResp.result)\n\(sendResp.errorDescription)"
            hud.margin = 10.0
            hud.removeFromSuperViewOnHide = true
            hud.hide(true, afterDelay: 1)
        default:
            break
        }
    }
    
    func isOnlineResponse(response: [NSObject : AnyObject]!) {
        
    }

}
