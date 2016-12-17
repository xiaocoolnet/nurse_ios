//
//  HSFindPersonDetailView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/28.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
protocol HSFindPersonDetailViewDelegate:NSObjectProtocol {
    func sendInvite(_ model:CVModel)
//    func hiddenResumeDetail()
    func lookContectBtnClick(_ lookContectBtn:UIButton, phoneNumber: UILabel, email: UILabel)
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
        inviteInterView.layer.borderColor = COLOR.cgColor
        inviteInterView.layer.borderWidth = 1
        inviteInterView.cornerRadius = 22
        
//        headerImg.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
        headerImg.contentMode = .scaleAspectFit
        headerImg.clipsToBounds = true
        
        self.phoneNumber.isHidden = true
        self.email.isHidden = true
    }
    @IBAction func sendInvite(_ sender: AnyObject) {
        if delegate != nil {
            delegate!.sendInvite(model!)
        }
    }
    
    
    @IBAction func lookContectBtnClick(_ sender: AnyObject) {
        
        if delegate != nil {
            delegate!.lookContectBtnClick(lookContectBtn, phoneNumber: phoneNumber, email: email)
        }
        
    }
    
    func showFor(_ birthday:NSString){
        self.birthday.text = birthday as String
    }
    func showName(_ userName:NSString){
        self.userName.text = userName as String
    }
    func showSex(_ userSex:NSString){
        self.userSex.text = userSex as String
    }
    func education(_ education:NSString){
        self.education.text = education as String
    }
    func address(_ address:NSString){
        self.address.text = address as String
    }
    func experience(_ experience:NSString){
        self.experience.text = experience as String
    }
    func jobName(_ jobName:NSString){
        self.jobName.text = jobName as String
    }
    func currentSalary(_ currentSalary:NSString){
        self.currentSalary.text = currentSalary as String
    }
    func jobState(_ jobState:NSString){
        self.jobState.text = jobState as String
    }
    func comeTime(_ comeTime:NSString){
        self.comeTime.text = comeTime as String
    }
    func expectSalary(_ expectSalary:NSString){
        self.expectSalary.text = expectSalary as String
    }
    func targetLocation(_ targetLocation:NSString){
        self.targetLocation.text = targetLocation as String
        self.targetLocation.adjustsFontSizeToFitWidth = true
    }
    func targetPosition(_ targetPosition:NSString){
        self.targetPosition.text = targetPosition as String
    }
    func selfEvaluation(_ selfEvaluation:NSString){
        self.selfEvaluation.text = selfEvaluation as String
    }
    func phoneNumber(_ phoneNumber:NSString){
        self.phoneNumber.text = phoneNumber as String
    }
    func email(_ email:NSString){
        self.email.text = email as String
    }
    
    var cvModel: CVModel? {
        didSet {
//            self.count = model.count
//            self.linkman = model.linkman
//            self.tit = model.title
            
            self.headerImg.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+cvModel!.avatar), placeholderImage: UIImage(named: "img_head_nor"))

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
            
            self.expectSalary.text = cvModel!.wantsalary.replacingOccurrences(of: "&lt;", with: "<")
            
            self.targetLocation.text = cvModel!.wantcity.components(separatedBy: "-").last!
            self.targetLocation.adjustsFontSizeToFitWidth = true
            
            self.targetPosition.text = cvModel!.wantposition
            
            self.selfEvaluation.text = cvModel!.description
            
            self.phoneNumber.text = cvModel!.phone
            
            self.email.text = cvModel!.email
        }
    }
    
}
