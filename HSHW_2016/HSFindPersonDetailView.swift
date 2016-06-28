//
//  HSFindPersonDetailView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
protocol HSFindPersonDetailViewDelegate:NSObjectProtocol {
    func sendInvite()
}

class HSFindPersonDetailView: UIView {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userSex: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var education: UILabel!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var experience: UILabel!
    @IBOutlet weak var jobName: UILabel!
    @IBOutlet weak var currentSalary: UILabel!
    @IBOutlet weak var jobState: UILabel!
    @IBOutlet weak var comeTime: UILabel!
    @IBOutlet weak var expectSalary: UILabel!
    @IBOutlet weak var targetLocation: UILabel!
    @IBOutlet weak var targetPosition: UILabel!
    @IBOutlet weak var selfEvaluation: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var inviteInterView: UIButton!
    weak var delegate:HSFindPersonDetailViewDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inviteInterView.layer.borderColor = COLOR.CGColor
        inviteInterView.layer.borderWidth = 1
        inviteInterView.cornerRadius = 22
    }
    @IBAction func sendInvite(sender: AnyObject) {
        if delegate != nil {
            delegate!.sendInvite()
        }
    }
    
}
