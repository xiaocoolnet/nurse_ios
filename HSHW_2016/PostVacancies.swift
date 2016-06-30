//
//  PostVacancies.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol PostVacanciesDelegate:NSObjectProtocol {
    func clickedSendBtn()
}

class PostVacancies: UIView {
    
    weak var delegate:PostVacanciesDelegate?
    @IBOutlet weak var bordView:UIView!
    @IBOutlet weak var sendBtn: UIButton!

    @IBAction func sendBtnClicked(sender: AnyObject) {
        if delegate != nil {
            delegate?.clickedSendBtn()
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        sendBtn.layer.borderColor = COLOR.CGColor
        sendBtn.layer.borderWidth = 1
        sendBtn.layer.cornerRadius = sendBtn.frame.height/2
        
        bordView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bordView.layer.borderWidth = 1
    }
}
