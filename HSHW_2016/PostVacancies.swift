//
//  PostVacancies.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

protocol PostVacanciesDelegate:NSObjectProtocol{
    func clickedSendBtn()
}

class PostVacancies: UIView , ChangeWordDelegate{
    
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
    
    var array = NSArray()
   
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
        
        array = ["北京市","北京市","朝阳区"]

        
    }
    
    @IBAction func workplaceBtnClick(sender: AnyObject) {

        // 初始化
        
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true
        pick.pickArray=array // 设置第一次加载时需要跳转到相对应的地址
//        self.view.addSubview(pick)
//        self.addSubview(pick)
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.array=dressArray
            print("选择的地区是: \(dressArray)")
            self.workplaceBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)
        }
        
    }
    
    func  changeWord(controller:HSStateEditResumeController,string:String){
        switch controller.portType {
            case PortType.position:
                positionBtn.setTitle(string, forState: UIControlState.Normal)
            case PortType.condition:
                conditionBtn.setTitle(string, forState: UIControlState.Normal)
            case PortType.welfare:
                treatmentBtn.setTitle(string, forState: UIControlState.Normal)
            case PortType.number:
                personBtn.setTitle(string, forState: UIControlState.Normal)
            case PortType.money:
                moneyBtn.setTitle(string, forState: UIControlState.Normal)
            default:
                print("defaut")
        }
    }

    
    @IBAction func positionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.position
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func conditionBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.condition
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func treatmentBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.welfare
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func personBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.number
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        let vc = HSStateEditResumeController()
        vc.portType = PortType.money
        vc.delegate = self
        selfNav?.pushViewController(vc, animated: true)
    }
    
}
