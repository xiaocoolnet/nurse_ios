//
//  HSPostResumeView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/2.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol HSPostResumeViewDelegate:NSObjectProtocol{
    func uploadAvatar() -> UIImage
    func saveResumeBtnClicked()
}

class HSPostResumeView: UIView {
    
    @IBOutlet weak var borderView1: UIView!
    @IBOutlet weak var borderView2: UIView!
    @IBOutlet weak var selfEvaluate: UITextView!
    @IBOutlet weak var savaResume: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    
    weak var delegate:HSPostResumeViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        borderView1.layer.borderWidth = 1
        borderView1.layer.borderColor = UIColor.lightGrayColor().CGColor
        borderView2.layer.borderWidth = 1
        borderView2.layer.borderColor = UIColor.lightGrayColor().CGColor
        selfEvaluate.layer.borderWidth = 1
        selfEvaluate.layer.borderColor = UIColor.lightGrayColor().CGColor
        savaResume.layer.borderWidth = 1
        savaResume.layer.borderColor = COLOR.CGColor
        savaResume.cornerRadius = savaResume.frame.height/2
    }
    
    @IBAction func avatarButtonClicked(sender: AnyObject) {
        delegate?.uploadAvatar()
    }
    
    @IBAction func saveResumeCilcked(sender: AnyObject) {
        delegate?.saveResumeBtnClicked()
    }
}