//
//  HSPostResumeView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/2.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

//接口类型
enum OptionType{
    case sex,edu,work,salary,jobStatus,time,expectSalary,expectPostion,defaut
}

protocol HSPostResumeViewDelegate:NSObjectProtocol{
    func uploadAvatar() -> UIImage
    func saveResumeBtnClicked()
}

class HSPostResumeView: UIView, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
//    ,,,UIActionSheetDelegate, ChangeDelegate, UITableViewDelegate, UITableViewDataSource,
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    // 边框
    @IBOutlet weak var borderView_1: UIView!
    
    @IBOutlet weak var borderView_2: UIView!
    
    // 头像
    
    @IBOutlet weak var headerBtn: UIButton!
    
    @IBOutlet weak var headerImg: UIImageView!
    
    @IBOutlet weak var headerLab: UILabel!
    
    // 姓名
    @IBOutlet weak var nameTF: UITextField!
    
    // 性别
    @IBOutlet weak var manBtn: UIButton!
    
    @IBOutlet weak var manImg: UIImageView!
    
    @IBOutlet weak var womanBtn: UIButton!
    
    @IBOutlet weak var womanImg: UIImageView!
    
    // 出生日期
    @IBOutlet weak var birthBtn: UIButton!
    
    @IBOutlet weak var birth_year_Lab: UILabel!
    
    @IBOutlet weak var birth_month_Lab: UILabel!
    
    @IBOutlet weak var birth_day_Lab: UILabel!
    
    // 学历
    @IBOutlet weak var eduBtn: UIButton!
    
    @IBOutlet weak var eduLab: UILabel!
    
    @IBOutlet weak var eduImg: UIImageView!
    
    let eduDropDown = DropDown()
    
    // 居住地
    @IBOutlet weak var homeBtn: UIButton!
    
    @IBOutlet weak var homeLab_1: UILabel!
    
    @IBOutlet weak var homeImg_1: UIImageView!
    
    @IBOutlet weak var homeLab_2: UILabel!
    
    @IBOutlet weak var homeImg_2: UIImageView!
    
    @IBOutlet weak var homeLab_3: UILabel!
    
    @IBOutlet weak var homeImg_3: UIImageView!
    
    // 工作经验
    @IBOutlet weak var expBtn: UIButton!
    
    @IBOutlet weak var expLab: UILabel!
    
    @IBOutlet weak var expImg: UIImageView!
    
    @IBOutlet weak var expLab_year: UILabel!
    
    let expDropDown = DropDown()
    
    // 职称
    @IBOutlet weak var professionalBtn: UIButton!
    
    @IBOutlet weak var professionalLab: UILabel!
    
    @IBOutlet weak var professionalImg: UIImageView!
    
    let professionalDropDown = DropDown()
    
    // 目前薪资
    @IBOutlet weak var salaryBtn: UIButton!
    
    @IBOutlet weak var salaryLab: UILabel!
    
    @IBOutlet weak var salaryImg: UIImageView!
    
    @IBOutlet weak var salaryLab_unit: UILabel!
    
    let salaryDropDown = DropDown()
    
    // 求职状态
    @IBOutlet weak var onJobBtn: UIButton!
    
    @IBOutlet weak var onJobImg: UIImageView!
    
    @IBOutlet weak var leaveJobBtn: UIButton!
    
    @IBOutlet weak var leaveJobImg: UIImageView!
    
    @IBOutlet weak var undergraduateBtn: UIButton!
    
    @IBOutlet weak var undergraduateImg: UIImageView!
    
    // 联系电话
    @IBOutlet weak var telTF: UITextField!
    
    // 邮箱
    @IBOutlet weak var mailTF: UITextField!
    
    // 到岗时间
    @IBOutlet weak var jobTimeBtn: UIButton!
    
    @IBOutlet weak var jobTimeLab: UILabel!
    
    @IBOutlet weak var jobTimeImg: UIImageView!
    
    let jobTimeDropDown = DropDown()
    
    // 目标城市
    @IBOutlet weak var targetCityBtn: UIButton!
    
    @IBOutlet weak var targetCityLab_1: UILabel!
    
    @IBOutlet weak var targetCityImg_1: UIImageView!
    
    @IBOutlet weak var targetCityLab_2: UILabel!
    
    @IBOutlet weak var targetCityImg_2: UIImageView!
    
    // 期望薪资
    @IBOutlet weak var expectedSalaryBtn: UIButton!
    
    @IBOutlet weak var expectedSalaryLab: UILabel!
    
    @IBOutlet weak var expectedSalaryImg: UIImageView!
    
    @IBOutlet weak var expectedSalaryLab_unit: UILabel!
    
    let expectedSalaryDropDown = DropDown()
    
    // 期望职位
    @IBOutlet weak var expectedPositionBtn: UIButton!
    
    @IBOutlet weak var expectedPositionLab: UILabel!
    
    @IBOutlet weak var expectedPositionImg: UIImageView!
    
    let expectedPositionDropDown = DropDown()
    
    // 自我评价
    @IBOutlet weak var selfEvaluate: UITextView!
    
    @IBOutlet weak var selfEvaluateLab: UILabel!
    
    // 保存简历
    @IBOutlet weak var saveResumeBtn: UIButton!
    
    var dropDownDic = [String:Array<String>]()
    
//    @IBOutlet weak var myScrollview: UIScrollView!
//    @IBOutlet weak var avatarBtn: UIButton!
//    @IBOutlet weak var nameTextFeild: UITextField!
//    @IBOutlet weak var nameLable: UILabel!
//    @IBOutlet weak var clickLable: UILabel!
//    @IBOutlet weak var birthLable: UILabel!
//    @IBOutlet weak var eduLable: UILabel!
//    @IBOutlet weak var eduImg: UIImageView!
//    @IBOutlet weak var educationBtn: UIButton!
//    @IBOutlet weak var plaLable: UILabel!
//
//    @IBOutlet weak var postField: UITextField!
//    @IBOutlet weak var salaryLab: UILabel!
//    @IBOutlet weak var salaryImg: UIImageView!
//    @IBOutlet weak var salary_Lab: UILabel!
//    @IBOutlet weak var moneyBtn: UIButton!
//    @IBOutlet weak var jobStatusLab: UILabel!
//    @IBOutlet weak var jobStatusImg: UIImageView!
//    @IBOutlet weak var phoneField: UITextField!
//    @IBOutlet weak var mailboxField: UITextField!
//
//    @IBOutlet weak var timeLab: UILabel!
//    @IBOutlet weak var timeImg: UIImageView!
//    var view = UIView()
//    var albumBtn = UIButton()
    var myActionSheet:UIAlertController?
//    var avatarView = UIButton(type: UIButtonType.Custom)
    var mainHelper = HSMineHelper()
//    var selfNav:UINavigationController?

    var picker:DatePickerView?
    var pick:AdressPickerView?
    var homeArray = Array<String>()
    var targetCityArray = Array<String>()
    
//    var vc = HSEditResumeViewController()
//    var next = HSEditResumeViewController()
//    var nextVC = HSEditResumeViewController()
//    var VC = HSEditResumeViewController()
//
//    let help = HSNurseStationHelper()
//    let userid = QCLoginUserInfo.currentInfo.userid
//    let picurl = ""
//
    var imageName = String()
    
    weak var delegate:HSPostResumeViewDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 设置默认样式
        nameTF.borderStyle = .None
        telTF.borderStyle = .None
        mailTF.borderStyle = .None
        
        // 设置边框
        borderView_1.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        borderView_1.layer.borderWidth = 1
        
        borderView_2.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        borderView_2.layer.borderWidth = 1
        
        selfEvaluate.layer.borderWidth = 1
        selfEvaluate.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
        
        saveResumeBtn.layer.borderWidth = 1
        saveResumeBtn.layer.borderColor = COLOR.CGColor
        saveResumeBtn.cornerRadius = saveResumeBtn.frame.height/2
        
        // 设置下拉列表的数据
        let eduArray = ["小学","初中","高中","专科","本科","硕士","博士","博士后"]
        let expArray = ["01","02","03"]
        let professionalArray = ["主管护师","别的"]
        let salaryArray = ["1万多","两万多","其实吧","这些数据","以后要","从网上获取"]
        let jobTimeArray = ["其实吧","这些数据","以后要","从网上获取"]
        let expectedSalaryArray = ["不嫌多","其实吧","这些数据","以后要","从网上获取"]
        let expectedPositionArray = ["护士长","其实吧","这些数据","以后要","从网上获取"]
        dropDownDic = ["edu":eduArray,"exp":expArray,"professional":professionalArray,"salary":salaryArray,"jobTime":jobTimeArray,"expectedSalary":expectedSalaryArray,"expectedPosition":expectedPositionArray]
        
        // 设置下拉列表
        setDropDownMenu()
        
        
//        let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
//        selfNav = tabBar.selectedViewController as? UINavigationController
//        
        // 设置地区的默认城市
        homeArray = ["北京市","北京市","朝阳区"]
        targetCityArray = ["北京市","北京市"]
        
        selfEvaluate.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK:设置下拉列表
    func setDropDownMenu() {
        
        // 设置下拉列表样式
        customizeDropDown()
        
        // 学历
        eduDropDown.anchorView = eduBtn
        
        eduDropDown.bottomOffset = CGPoint(x: 0, y: eduBtn.bounds.height)
        eduDropDown.width = 200
        eduDropDown.direction = .Bottom
        
        eduDropDown.dataSource = dropDownDic["edu"]!
        
        // 下拉列表选中后的回调方法
        eduDropDown.selectionAction = { [unowned self] (index, item) in
            self.eduLab.text = item
            self.eduLab.sizeToFit()
            self.eduImg.frame.origin.x = CGRectGetMaxX(self.eduLab.frame)+5
        }
        
        // 工作经验
        expDropDown.anchorView = expBtn
        
        expDropDown.bottomOffset = CGPoint(x: 0, y: expBtn.bounds.height)
        expDropDown.width = 200
        expDropDown.direction = .Bottom
        
        expDropDown.dataSource = dropDownDic["exp"]!
        
        expDropDown.selectionAction = { [unowned self] (index, item) in
            self.expLab.text = item
            self.expLab.sizeToFit()
            self.expImg.frame.origin.x = CGRectGetMaxX(self.expLab.frame)+5
            self.expLab_year.frame.origin.x = CGRectGetMaxX(self.expImg.frame)+5
        }
        
        // 职称
        professionalDropDown.anchorView = professionalBtn
        
        professionalDropDown.bottomOffset = CGPoint(x: 0, y: professionalBtn.bounds.height)
        professionalDropDown.width = 200
        professionalDropDown.direction = .Bottom
        
        professionalDropDown.dataSource = dropDownDic["professional"]!
        
        professionalDropDown.selectionAction = { [unowned self] (index, item) in
            self.professionalLab.text = item
            self.professionalLab.sizeToFit()
            self.professionalImg.frame.origin.x = CGRectGetMaxX(self.professionalLab.frame)+5
        }
        
        // 目前薪资
        salaryDropDown.anchorView = salaryBtn
        
        salaryDropDown.bottomOffset = CGPoint(x: 0, y: salaryBtn.bounds.height)
        salaryDropDown.width = 200
        salaryDropDown.direction = .Bottom
        
        salaryDropDown.dataSource = dropDownDic["salary"]!
        
        salaryDropDown.selectionAction = { [unowned self] (index, item) in
            self.salaryLab.text = item
            self.salaryLab.sizeToFit()
            self.salaryImg.frame.origin.x = CGRectGetMaxX(self.salaryLab.frame)+5
            self.salaryLab_unit.frame.origin.x = CGRectGetMaxX(self.salaryImg.frame)+5
        }
        
        // 到岗时间
        jobTimeDropDown.anchorView = jobTimeBtn
        
        jobTimeDropDown.bottomOffset = CGPoint(x: 0, y: jobTimeBtn.bounds.height)
        jobTimeDropDown.width = 200
        jobTimeDropDown.direction = .Bottom
        
        jobTimeDropDown.dataSource = dropDownDic["jobTime"]!
        
        jobTimeDropDown.selectionAction = { [unowned self] (index, item) in
            self.jobTimeLab.text = item
            self.jobTimeLab.sizeToFit()
            self.jobTimeImg.frame.origin.x = CGRectGetMaxX(self.jobTimeLab.frame)+5
        }
        
        // 期望薪资
        expectedSalaryDropDown.anchorView = expectedSalaryBtn
        
        expectedSalaryDropDown.bottomOffset = CGPoint(x: 0, y: expectedSalaryBtn.bounds.height)
        expectedSalaryDropDown.width = 200
        expectedSalaryDropDown.direction = .Bottom
        
        expectedSalaryDropDown.dataSource = dropDownDic["expectedSalary"]!
        
        expectedSalaryDropDown.selectionAction = { [unowned self] (index, item) in
            self.expectedSalaryLab.text = item
            self.expectedSalaryLab.sizeToFit()
            self.expectedSalaryImg.frame.origin.x = CGRectGetMaxX(self.expectedSalaryLab.frame)+5
            self.expectedSalaryLab_unit.frame.origin.x = CGRectGetMaxX(self.expectedSalaryImg.frame)+5
        }
        
        // 期望职位
        expectedPositionDropDown.anchorView = expectedPositionBtn
        
        expectedPositionDropDown.bottomOffset = CGPoint(x: 0, y: expectedPositionBtn.bounds.height)
        expectedPositionDropDown.width = 200
        expectedPositionDropDown.direction = .Bottom
        
        expectedPositionDropDown.dataSource = dropDownDic["expectedPosition"]!
        
        expectedPositionDropDown.selectionAction = { [unowned self] (index, item) in
            self.expectedPositionLab.text = item
            self.expectedPositionLab.sizeToFit()
            self.expectedPositionImg.frame.origin.x = CGRectGetMaxX(self.expectedPositionLab.frame)+5
        }
    }
    
    // MARK:- 下拉列表 点击事件   开始
    @IBAction func eduBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        eduDropDown.show()
    }
    
    @IBAction func expBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        expDropDown.show()
    }
    
    @IBAction func professionalBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        professionalDropDown.show()
    }
    
    @IBAction func salaryBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        salaryDropDown.show()
    }
    
    @IBAction func jobTimeBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        jobTimeDropDown.show()
    }
    
    @IBAction func expectedSalaryBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        expectedSalaryDropDown.show()
    }
    
    @IBAction func expectedPositionBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        expectedPositionDropDown.show()
    }
    // MARK:下拉列表 点击事件   结束
    // MARK:-
    
    // MARK:头像点击事件
    @IBAction func headerBtnClick(sender: UIButton) {
        
//        delegate?.uploadAvatar()
        resignTextFieldFirstResponder()
        
        print("头像点击事件")
        
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .Default, handler: {[unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.takePhoto()
            })
            }))
        
        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .Default, handler: { [unowned self] (UIAlertAction) in
            dispatch_async(dispatch_get_main_queue(), {
                self.LocalPhoto()
            })
            }))
        
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .Cancel, handler:nil))
        
        let vc = responderVC()
        vc!.presentViewController(myActionSheet!, animated: true, completion: nil)
    }
    
    // MARK:选择性别
    @IBAction func sexBtnClick(sender: UIButton) {
        
        resignTextFieldFirstResponder()
        
        switch sender.tag {
        case 11:
            manImg.image = UIImage.init(named: "ic_yuan_purple")
            womanImg.image = UIImage.init(named: "ic_yuan")
        case 12:
            manImg.image = UIImage.init(named: "ic_yuan")
            womanImg.image = UIImage.init(named: "ic_yuan_purple")
            
        default:
            break
        }
    }
    
    // MARK:选择求职状态
    @IBAction func jobStatusBtnClick(sender: UIButton) {
        
        resignTextFieldFirstResponder()
        
        switch sender.tag {
        case 101:
            onJobImg.image = UIImage.init(named: "ic_yuan_purple")
            leaveJobImg.image = UIImage.init(named: "ic_yuan")
            undergraduateImg.image = UIImage.init(named: "ic_yuan")
        case 102:
            onJobImg.image = UIImage.init(named: "ic_yuan")
            leaveJobImg.image = UIImage.init(named: "ic_yuan_purple")
            undergraduateImg.image = UIImage.init(named: "ic_yuan")
        case 103:
            onJobImg.image = UIImage.init(named: "ic_yuan")
            leaveJobImg.image = UIImage.init(named: "ic_yuan")
            undergraduateImg.image = UIImage.init(named: "ic_yuan_purple")
            
        default:
            break
        }
    }
    
    // MARK:自定义下拉列表样式
    func customizeDropDown() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 60
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        //		appearance.separatorColor = UIColor(white: 0.7, alpha: 0.8)
        appearance.cornerRadiu = 10
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGrayColor()
        //		appearance.textFont = UIFont(name: "Georgia", size: 14)
    }
    
    @IBAction func saveResumeCilcked(sender: AnyObject) {
        
        resignTextFieldFirstResponder()
//        delegate?.saveResumeBtnClicked()
        
        let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("熬不住了，明天做吧。。。", comment: "empty message"), preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)

            let vc = responderVC()
            vc!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // TODO:
    func resignTextFieldFirstResponder() {
        nameTF.resignFirstResponder()
        telTF.resignFirstResponder()
        mailTF.resignFirstResponder()
        selfEvaluate.resignFirstResponder()
    }
//    // MARK:-
//    func change(controller:HSEditResumeViewController,string:String,idStr:String){
//
//        if idStr == "1" {
//            educationBtn.setTitle(string, forState: .Normal)
//        }else if idStr == "14"{
//            moneyBtn.setTitle(string, forState: .Normal)
//        }else if idStr == "12"{
//            expectPayBtn.setTitle(string, forState: .Normal)
//        }else if idStr == "13"{
//            expectPostBtn.setTitle(string, forState: .Normal)
//        }
//        
//    }
    
    // MARK:选择出生日期
    @IBAction func birthBtnClick(sender: AnyObject) {
        
        picker = DatePickerView.getShareInstance()
        picker!.textColor = UIColor.redColor()
        picker!.showWithDate(NSDate())
        picker?.block = {
            (date:NSDate)->() in
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd zzz"
            let string = formatter.stringFromDate(date)
            let range:Range = string.rangeOfString(" ")!
            let time = string.substringToIndex(range.endIndex)
            let timeArr = time.componentsSeparatedByString("-")
            
            self.birth_year_Lab.text = timeArr.first
            self.birth_month_Lab.text = timeArr[1]
            self.birth_day_Lab.text = timeArr.last
        }
    }
    
    // MARK:选择居住地
    @IBAction func homeBtnClick(sender: AnyObject) {
        
        print("点击居住地")
        // 初始化
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown = true
        pick.pickArray = homeArray // 设置第一次加载时需要跳转到相对应的地址
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.homeArray=dressArray as! Array<String>
            print("选择的地区是: \(dressArray)")
            //            self.workplaceBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)
            
            self.homeLab_1.text =  (dressArray[0] as! String)
            self.homeLab_2.text =  (dressArray[1] as! String)
            self.homeLab_3.text =  (dressArray[2] as! String)
            
            self.homeLab_1.sizeToFit()
            self.homeImg_1.frame.origin.x = CGRectGetMaxX(self.homeLab_1.frame)+5
            
            self.homeLab_2.frame.origin.x = CGRectGetMaxX(self.homeImg_1.frame)+5
            self.homeLab_2.adjustsFontSizeToFitWidth = true
            self.homeLab_2.sizeToFit()
            self.homeImg_2.frame.origin.x = CGRectGetMaxX(self.homeLab_2.frame)+5
            
            self.homeLab_3.frame.origin.x = CGRectGetMaxX(self.homeImg_2.frame)+5
            self.homeLab_3.adjustsFontSizeToFitWidth = true
            self.homeLab_3.sizeToFit()
            self.homeImg_3.frame.origin.x = CGRectGetMaxX(self.homeLab_3.frame)+5            
        }
    }

    // MARK:选择目标城市
    @IBAction func targetCityBtnClick(sender: AnyObject) {
    
        print("点击目标城市")
        // 初始化
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown = false
        pick.pickArray = targetCityArray // 设置第一次加载时需要跳转到相对应的地址
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.targetCityArray = dressArray as! Array<String>
            print("选择的地区是: \(dressArray)")
            //            self.workplaceBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)
            
            self.targetCityLab_1.text =  (dressArray[0] as! String)
            self.targetCityLab_2.text =  (dressArray[1] as! String)
            
            self.targetCityLab_1.sizeToFit()
            self.targetCityImg_1.frame.origin.x = CGRectGetMaxX(self.targetCityLab_1.frame)+5
            
            self.targetCityLab_2.frame.origin.x = CGRectGetMaxX(self.targetCityImg_1.frame)+5
            self.targetCityLab_2.adjustsFontSizeToFitWidth = true
            self.targetCityLab_2.sizeToFit()
            self.targetCityImg_2.frame.origin.x = CGRectGetMaxX(self.targetCityLab_2.frame)+5
        }
    }

//    @IBAction func saveResumeBtnClick(sender: UIButton) {
//        
//        if delegate != nil {
//            if sexLable.text != "" && nameTextFeild.text != "" && birthBtn.titleLabel?.text != "" && educationBtn.titleLabel?.text != "" && placeBtn.titleLabel?.text != "" && phoneField.text != "" && entryTimeBtn.titleLabel?.text != "" && targetCityBtn.titleLabel?.text != "" && expectPostBtn.titleLabel?.text != "" && expectPayBtn.titleLabel?.text != "" {
//                
//                delegate?.saveResumeBtnClicked()
//            }else{
//                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请完善简历信息", comment: "empty message"), preferredStyle: .Alert)
//                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
//                alertController.addAction(doneAction)
//                
//                let vc = responderVC()
//                vc!.presentViewController(alertController, animated: true, completion: nil)
//                
//            }
//        }
//        
//        if sexLable.text != "" && nameTextFeild.text != "" && birthBtn.titleLabel?.text != "" && educationBtn.titleLabel?.text != "" && placeBtn.titleLabel?.text != "" && phoneField.text != "" && entryTimeBtn.titleLabel?.text != "" && targetCityBtn.titleLabel?.text != "" && expectPostBtn.titleLabel?.text != "" && expectPayBtn.titleLabel?.text != ""{
//            
//            help.postForum(userid, avatar:imageName, name: nameTextFeild.text!, experience: workLab.text!, sex: sexLable.text!, birthday:(brith_year.text!+brith_month.text!+brith_day.text!), marital:eduLable.text! , address:placeLab_1.text!+placeLab_2.text!+placeLab_3.text!, jobstate:jobStatusLab.text!, currentsalary:salaryLab.text!, phone:phoneField.text!, email:mailboxField.text!, hiredate:timeLab.text!, wantcity:targetCity_1_Lab.text!+targetCity_2_Lab.text!+targetCity_3_Lab.text!, wantsalary:expectSalaryLab.text!, wantposition:expectPostionLab.text!, description:selfEvaluate.text, handle: { (success, response) in
//                if success {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        hud.mode = MBProgressHUDMode.Text;
//                        hud.labelText = "发布成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
//                        hud.hide(true, afterDelay: 1)
//                        print(success)
//                    })
//                }
//            })
//        }
//    }
    
//    func click(){
//        view.removeFromSuperview()
//        albumBtn.removeFromSuperview()
//        let imagePicker = UIImagePickerController();
//        imagePicker.delegate = self
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        
//        let vc = responderVC()
//        vc!.presentViewController(imagePicker, animated: true, completion: nil)
//        
//    }
//    
    func responderVC() -> (UIViewController?) {
        var temp:AnyObject
        temp = nextResponder()!
        while ((temp.isKindOfClass(UIViewController)) != true) {
            temp = temp.nextResponder()!
        }
        return temp as? UIViewController
    }

    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            let vc = responderVC()
            vc!.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }

    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        let vc = responderVC()
        vc!.presentViewController(picker, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        
        //裁剪后图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
        
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://nurse.xiaocool.net/index.php?g=apps&m=index&a=uploadavatar") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                    dispatch_async(dispatch_get_main_queue(), {
                        if result.status! == "success"{
                            self.headerImg.image = image
                            self.mainHelper.changeUserAvatar(result.data!, handle: { (success, response) in
                                if success {
                                    QCLoginUserInfo.currentInfo.avatar = result.data!
                                }
                            })
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "图片上传失败"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                    })
                }
            })
        }
        headerImg.image = image
        headerImg.layer.cornerRadius = headerImg.frame.size.width/2.0
        headerImg.clipsToBounds = true
        headerImg.userInteractionEnabled = true
        
        headerLab.hidden = true

        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    var keyboardHeight:CGFloat = 0.0
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        if selfEvaluate.isFirstResponder() {
            
            UIView.animateWithDuration(0.3) {
                self.myScrollView.contentOffset = CGPoint.init(x: 0, y: self.myScrollView.contentSize.height-self.myScrollView.frame.size.height+keyboardheight)
                self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height-keyboardheight)
            }
        }
        
        keyboardHeight = keyboardheight
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        if self.myScrollView.frame.size.height<=HEIGHT-64-49-keyboardHeight {

            UIView.animateWithDuration(0.3) {
    //            self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height)

                self.myScrollView.frame = CGRectMake(self.myScrollView.frame.origin.x, self.myScrollView.frame.origin.y, self.myScrollView.frame.size.width, self.myScrollView.frame.size.height+self.keyboardHeight)
            }
        }
        print("键盘落下")
    }
    
    //MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if (textView.text == "") {
            selfEvaluateLab.text = "请填写自我介绍的内容"
        }else{
            selfEvaluateLab.text = ""
        }
    }
}



