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
//    func hiddenResumeDetail()
    func lookContectBtnClick(lookContectBtn:UIButton, phoneNumber: UILabel, email: UILabel)
}


class HSFindPersonDetailView: UIView {
    
    var model:CVModel?
    
    @IBOutlet weak var headerImg: UIImageView!
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
    
    
    @IBOutlet weak var lookContectBtn: UIButton!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        inviteInterView.layer.borderColor = COLOR.CGColor
        inviteInterView.layer.borderWidth = 1
        inviteInterView.cornerRadius = 22
        
//        headerImg.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        headerImg.contentMode = .ScaleAspectFit
        headerImg.clipsToBounds = true
        
        self.phoneNumber.hidden = true
        self.email.hidden = true
    }
    @IBAction func sendInvite(sender: AnyObject) {
        if delegate != nil {
            delegate!.sendInvite(model!)
        }
    }
    
    
    @IBAction func lookContectBtnClick(sender: AnyObject) {
        
        if delegate != nil {
            delegate!.lookContectBtnClick(lookContectBtn, phoneNumber: phoneNumber, email: email)
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
        self.targetLocation.adjustsFontSizeToFitWidth = true
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
    
    var cvModel: CVModel? {
        didSet {
//            self.count = model.count
//            self.linkman = model.linkman
//            self.tit = model.title
            
            self.headerImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+cvModel!.avatar), placeholderImage: UIImage(named: "img_head_nor"))

            self.birthday.text = cvModel!.birthday
            
            self.userName.text = cvModel!.name
            
            self.userSex.text = cvModel!.sex == "0" ? "女":"男"
            
            self.education.text = cvModel!.education
            
            self.address.text = cvModel!.address
            
            self.experience.text = cvModel!.experience
            
            self.jobName.text = cvModel!.certificate
            
            self.currentSalary.text = cvModel!.currentsalary
            
            self.jobState.text = cvModel!.jobstate
            
            self.comeTime.text = cvModel!.hiredate
            
            self.expectSalary.text = cvModel!.wantsalary.stringByReplacingOccurrencesOfString("&lt;", withString: "<")
            
            self.targetLocation.text = cvModel!.wantcity.componentsSeparatedByString("-").last!
            self.targetLocation.adjustsFontSizeToFitWidth = true
            
            self.targetPosition.text = cvModel!.wantposition
            
            self.selfEvaluation.text = cvModel!.description
            
            self.phoneNumber.text = cvModel!.phone
            
            self.email.text = cvModel!.email
        }
    }
    
}
