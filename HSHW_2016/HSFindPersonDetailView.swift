//
//  HSFindPersonDetailView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
protocol HSFindPersonDetailViewDelegate:NSObjectProtocol {
    func sendInvite(model:CVModel)
    func hiddenResumeDetail()
}


class HSFindPersonDetailView: UIView {
    
    var model:CVModel?
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
    
    @IBOutlet weak var backBtn: UIButton!
    override func layoutSubviews() {
        super.layoutSubviews()
        inviteInterView.layer.borderColor = COLOR.CGColor
        inviteInterView.layer.borderWidth = 1
        inviteInterView.cornerRadius = 22
        
        backBtn.layer.borderColor = COLOR.CGColor
        backBtn.layer.borderWidth = 1
        backBtn.cornerRadius = 17
    }
    @IBAction func sendInvite(sender: AnyObject) {
        if delegate != nil {
            delegate!.sendInvite(model!)
        }
    }
    
    @IBAction func backBtnClick(sender: AnyObject) {
        if delegate != nil {
            delegate!.hiddenResumeDetail()
        }
    }
    
    func showFor(birthday:NSString){
        self.birthday.text = birthday as String
    }
    func showName(userName:NSString){
        self.userName.text = userName as String
    }
    func showSex(userSex:NSString){
        self.userSex.text = userSex as String
    }
    func education(education:NSString){
        self.education.text = education as String
    }
    func address(address:NSString){
        self.address.text = address as String
    }
    func experience(experience:NSString){
        self.experience.text = experience as String
    }
    func jobName(jobName:NSString){
        self.jobName.text = jobName as String
    }
    func currentSalary(currentSalary:NSString){
        self.currentSalary.text = currentSalary as String
    }
    func jobState(jobState:NSString){
        self.jobState.text = jobState as String
    }
    func comeTime(comeTime:NSString){
        self.comeTime.text = comeTime as String
    }
    func expectSalary(expectSalary:NSString){
        self.expectSalary.text = expectSalary as String
    }
    func targetLocation(targetLocation:NSString){
        self.targetLocation.text = targetLocation as String
    }
    func targetPosition(targetPosition:NSString){
        self.targetPosition.text = targetPosition as String
    }
    func selfEvaluation(selfEvaluation:NSString){
        self.selfEvaluation.text = selfEvaluation as String
    }
    func phoneNumber(phoneNumber:NSString){
        self.phoneNumber.text = phoneNumber as String
    }
    func email(email:NSString){
        self.email.text = email as String
    }
}
