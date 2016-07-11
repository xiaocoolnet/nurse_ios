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
    @IBOutlet weak var postNameField: UITextField!
    @IBOutlet weak var firmNameField: UITextField!
    @IBOutlet weak var resumeFeild: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    @IBOutlet weak var workplaceBtn: UIButton!
    @IBOutlet weak var positionBtn: UIButton!
    @IBOutlet weak var conditionBtn: UIButton!
    @IBOutlet weak var treatmentBtn: UIButton!
    @IBOutlet weak var personBtn: UIButton!
    @IBOutlet weak var moneyBtn: UIButton!
    @IBOutlet weak var requestField: UITextView!
    var selfNav:UINavigationController?
   
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
        
        let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        selfNav = tabBar.selectedViewController as? UINavigationController
    }
    
    @IBAction func workplaceBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func positionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func conditionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func treatmentBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func personBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        selfNav?.pushViewController(vc, animated: true)
    }
    
}
