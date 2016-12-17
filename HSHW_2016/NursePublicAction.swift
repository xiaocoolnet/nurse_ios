//
//  NursePublicAction.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NursePublicAction: NSObject {
    // MARK: 显示积分提示
    class func showScoreTips(_ view:UIView, nameString:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        //        hud.bezelView.alpha = 0.3
        hud.margin = 10
        hud.bezelView.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud.mode = .customView
        let customBgView = UIView(frame: CGRect(x: (view.frame.width-WIDTH*0.8-15)/2, y: (view.frame.height-WIDTH*0.8*238/537-15)/2, width: WIDTH*0.8+15, height: WIDTH*0.8*238/537+15))
        customBgView.backgroundColor = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        customBgView.layer.cornerRadius = 8
        
        let customView = UIImageView(frame: CGRect(x: 7.5, y: 7.5, width: WIDTH*0.8, height: WIDTH*0.8*238/537))
        customView.backgroundColor = UIColor.green
        customView.image = UIImage(named: "scorePopImg.png")
        customBgView.addSubview(customView)
        
        let titLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*30/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .left
        titLab.font = UIFont.systemFont(ofSize: 16)
        titLab.text = nameString
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
        hud.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
        hud.addSubview(customBgView)
        //        hud.customView = customView
        hud.hide(animated: true, afterDelay: 3)
    }

}
