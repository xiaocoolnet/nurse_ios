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

class HSPostResumeView: UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, ChangeDelegate, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate {
    
    @IBOutlet weak var myScrollview: UIScrollView!
    @IBOutlet weak var borderView1: UIView!
    @IBOutlet weak var borderView2: UIView!
    // 自我介绍
    @IBOutlet weak var selfEvaluate: UITextView!
    // 保存简历
    @IBOutlet weak var savaResume: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var sexLable: UILabel!
    @IBOutlet weak var sexImg: UIImageView!
    @IBOutlet weak var nameTextFeild: UITextField!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var clickLable: UILabel!
    @IBOutlet weak var birthLable: UILabel!
    @IBOutlet weak var birthBtn: UIButton!
    @IBOutlet weak var eduLable: UILabel!
    @IBOutlet weak var eduImg: UIImageView!
    @IBOutlet weak var educationBtn: UIButton!
    @IBOutlet weak var plaLable: UILabel!
    @IBOutlet weak var placeLab_1: UILabel!
    @IBOutlet weak var placeLab_2: UILabel!
    @IBOutlet weak var placeLab_3: UILabel!
    @IBOutlet weak var placeImg_1: UIImageView!
    @IBOutlet weak var placeImg_2: UIImageView!
    @IBOutlet weak var placeImg_3: UIImageView!
    
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var workLab: UILabel!
    @IBOutlet weak var workImg: UIImageView!
    @IBOutlet weak var work_year: UILabel!

    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var salaryLab: UILabel!
    @IBOutlet weak var salaryImg: UIImageView!
    @IBOutlet weak var salary_Lab: UILabel!
    @IBOutlet weak var moneyBtn: UIButton!
    @IBOutlet weak var jobStatusLab: UILabel!
    @IBOutlet weak var jobStatusImg: UIImageView!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var timeImg: UIImageView!
    @IBOutlet weak var targetCity_1_Lab: UILabel!
    @IBOutlet weak var targetCity_2_Lab: UILabel!
    @IBOutlet weak var targetCity_3_Lab: UILabel!
    @IBOutlet weak var targetCity_1_Img: UIImageView!
    @IBOutlet weak var targetCity_2_Img: UIImageView!
    @IBOutlet weak var targetCity_3_Img: UIImageView!
    @IBOutlet weak var expectSalaryLab: UILabel!
    @IBOutlet weak var expectSalaryImg: UIImageView!
    @IBOutlet weak var expectPostionLab: UILabel!
    @IBOutlet weak var expectPostionImg: UIImageView!
    @IBOutlet weak var targetCityBtn: UIButton!
    @IBOutlet weak var entryTimeBtn: UIButton!
    @IBOutlet weak var expectPayBtn: UIButton!
    @IBOutlet weak var expectPostBtn: UIButton!
    @IBOutlet weak var selfLab: UILabel!
    
    var view = UIView()
    var albumBtn = UIButton()
    var myActionSheet:UIAlertController?
    var avatarView = UIButton(type: UIButtonType.Custom)
    var mainHelper = HSMineHelper()
    var selfNav:UINavigationController?
    
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = NSArray()
    var optionDictionary = [String:Array<String>]()
    
    var vc = HSEditResumeViewController()
    var next = HSEditResumeViewController()
    var nextVC = HSEditResumeViewController()
    var VC = HSEditResumeViewController()
    
    let help = HSNurseStationHelper()
    let userid = "1"
    let picurl = ""
    
    var imageName = String()
    
    
    
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
        let tabBar = UIApplication.sharedApplication().keyWindow?.rootViewController as! UITabBarController
        selfNav = tabBar.selectedViewController as? UINavigationController
        
        array = ["北京市","北京市","朝阳区"]
        
        optionDictionary = ["sex":["男","女"],
                            "edu":["博士后","博士","硕士","本科","专科","高中","其他"],
                            "work":["<01","01","02","03","04","05","06","07","08","09","10+"],
                            "salary":["1000","2000","3000","4000","5000","6000","7000","8000","9000","1万","1万+"],
                            "jobStatus":["在职","离职"],
                            "time":["立即到岗","一月以内","暂不考虑"],
                            "expectPostion":["院长","护士","护士长","主治医生","护工"]]
        
        selfEvaluate.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HSPostDetailViewController.keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    @IBAction func avatarButtonClicked(sender: AnyObject) {
        delegate?.uploadAvatar()
        
        print("lalal")
        
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
    
    @IBAction func saveResumeCilcked(sender: AnyObject) {
//        delegate?.saveResumeBtnClicked()
        if delegate != nil {
            if sexLable.text != "" && nameTextFeild.text != "" && birthBtn.titleLabel?.text != "" && educationBtn.titleLabel?.text != "" && placeBtn.titleLabel?.text != "" && phoneField.text != "" && entryTimeBtn.titleLabel?.text != "" && targetCityBtn.titleLabel?.text != "" && expectPostBtn.titleLabel?.text != "" && expectPayBtn.titleLabel?.text != "" {
                
                delegate?.saveResumeBtnClicked()
            }else{
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请完善简历信息", comment: "empty message"), preferredStyle: .Alert)
                let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                alertController.addAction(doneAction)

                let vc = responderVC()
                vc!.presentViewController(alertController, animated: true, completion: nil)

            }
        }
        
        if sexLable.text != "" && nameTextFeild.text != "" && birthBtn.titleLabel?.text != "" && educationBtn.titleLabel?.text != "" && placeBtn.titleLabel?.text != "" && phoneField.text != "" && entryTimeBtn.titleLabel?.text != "" && targetCityBtn.titleLabel?.text != "" && expectPostBtn.titleLabel?.text != "" && expectPayBtn.titleLabel?.text != ""{
            
            help.postForum(userid, avatar:imageName, name: nameTextFeild.text!, experience: workLab.text!, sex: sexLable.text!, birthday:(brith_year.text!+brith_month.text!+brith_day.text!), marital:eduLable.text! , address:placeLab_1.text!+placeLab_2.text!+placeLab_3.text!, jobstate:jobStatusLab.text!, currentsalary:salaryLab.text!, phone:phoneField.text!, email:mailboxField.text!, hiredate:timeLab.text!, wantcity:targetCity_1_Lab.text!+targetCity_2_Lab.text!+targetCity_3_Lab.text!, wantsalary:expectSalaryLab.text!, wantposition:expectPostionLab.text!, description:selfEvaluate.text, handle: { (success, response) in
                if success {
                    dispatch_async(dispatch_get_main_queue(), {
                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                        hud.mode = MBProgressHUDMode.Text;
                        hud.labelText = "发布成功"
                        hud.margin = 10.0
                        hud.removeFromSuperViewOnHide = true
                        hud.hide(true, afterDelay: 1)
                        print(success)
                    })
                }
            })
        }

    }
    
    // TODO:
    func resignTextFieldFirstResponder() {
        nameTextFeild.resignFirstResponder()
        postField.resignFirstResponder()
        phoneField.resignFirstResponder()
        mailboxField.resignFirstResponder()
        selfEvaluate.resignFirstResponder()
    }
    
    // 性别选择
    @IBAction func sexBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .sex)
    }
    
    // 点击学历
    @IBAction func educationbtnClick(sender: AnyObject) {
        //        let vc = HSEditResumeViewController()
        //        vc.delegate = self
        //        vc.num = "1"
        //        selfNav?.pushViewController(vc, animated: true)
        
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .edu)
        
    }
    
    // 工作经验
    @IBAction func workBtnClick(sender: AnyObject) {
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .work)
    }
    
    // 目前薪资
    @IBAction func moneyBtnClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .salary)
        
    }
    
    // 求职状态
    @IBAction func jobStatusClick(sender: AnyObject) {
        
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .jobStatus)
    }
    
    // 到岗时间
    @IBAction func entryTimeBtnClick(sender: AnyObject) {
        
        //        picker = DatePickerView.getShareInstance()
        //        picker!.textColor = UIColor.redColor()
        //        picker!.showWithDate(NSDate())
        //        picker?.block = {
        //            (date:NSDate)->() in
        //            let formatter = NSDateFormatter()
        //            formatter.dateFormat = "yyyy-MM-dd zzz"
        //            let string = formatter.stringFromDate(date)
        //            let range:Range = string.rangeOfString(" ")!
        //            let time = string.substringToIndex(range.endIndex)
        //            self.entryTimeBtn.setTitle(time, forState: .Normal)
        //        
        //        }
        
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .time)
        
    }
    
    // 期望薪资
    @IBAction func expectPayBtn(sender: AnyObject) {
//        nextVC.delegate = self
//        nextVC.num = "12"
//        selfNav?.pushViewController(nextVC, animated: true)
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .expectSalary)
    }
    
    // 期望职位
    @IBAction func expectPostBtnClick(sender: AnyObject) {
//        VC.delegate = self
//        VC.num = "13"
//        selfNav?.pushViewController(VC, animated: true)
        resignTextFieldFirstResponder()
        
        listShow(sender as! UIView, andType: .expectPostion)
    }
    
    // MARK:- 设置弹出视图
    /*****             开始             *****/
    var bgView = UIView()
    
    var chooseTableView = UITableView()
    var chooseList = Array<String>()
    
    var optionType: OptionType = .defaut
    
    func listShow(onView:UIView, andType type:OptionType) {
        optionType = type
        dataGet(type)
        bgView.frame = CGRectMake(0, 0, WIDTH, HEIGHT)
        onView.superview?.superview?.addSubview(bgView)
        
        chooseTableView = UITableView.init(frame: CGRectMake(CGRectGetMinX(onView.frame), CGRectGetMinY((onView.superview?.frame)!)+10, CGRectGetWidth(onView.frame)-20, 60), style: .Plain)
        chooseTableView.rowHeight = 30
        chooseTableView.backgroundColor = UIColor.whiteColor()
        chooseTableView.layer.borderWidth = 1
        chooseTableView.layer.borderColor = UIColor.lightGrayColor().CGColor
        chooseTableView.delegate = self
        chooseTableView.dataSource = self
        chooseTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        chooseTableView.bounces = false
        onView.superview?.superview?.addSubview(chooseTableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chooseList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        //        cell.selectionStyle = .None
        
        cell.textLabel?.text = self.chooseList[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(1111)

        chooseTableView.removeFromSuperview()
        bgView.removeFromSuperview()
        
        let string = self.chooseList[indexPath.row]
        
        switch optionType {
        case PortType.sex:
            sexLable.text = string
            sexLable.enabled = true
            sexLable.sizeToFit()
            sexImg.frame = CGRectMake(CGRectGetMaxX(sexLable.frame), sexImg.frame.origin.y, 12, 12)
        case PortType.edu:
            eduLable.text = string
            eduLable.enabled = true
            eduLable.sizeToFit()
            eduImg.frame = CGRectMake(CGRectGetMaxX(eduLable.frame), eduImg.frame.origin.y, 12, 12)
        case PortType.work:
            workLab.text = string
            workLab.enabled = true
            workLab.sizeToFit()
            workImg.frame = CGRectMake(CGRectGetMaxX(workLab.frame), workImg.frame.origin.y, 12, 12)
            work_year.frame = CGRectMake(CGRectGetMaxX(workImg.frame), work_year.frame.origin.y, work_year.frame.size.width, work_year.frame.size.height)
        case PortType.salary:
            salaryLab.text = string
            salaryLab.enabled = true
            salaryLab.sizeToFit()
            salaryImg.frame = CGRectMake(CGRectGetMaxX(salaryLab.frame), salaryImg.frame.origin.y, 12, 12)
            salary_Lab.frame = CGRectMake(CGRectGetMaxX(salaryImg.frame), salary_Lab.frame.origin.y, salary_Lab.frame.size.width, salary_Lab.frame.size.height)
        case PortType.jobStatus:
            jobStatusLab.text = string
            jobStatusLab.enabled = true
            jobStatusLab.sizeToFit()
            jobStatusImg.frame = CGRectMake(CGRectGetMaxX(jobStatusLab.frame), jobStatusImg.frame.origin.y, 12, 12)
        case PortType.time:
            timeLab.text = string
            timeLab.enabled = true
            timeLab.sizeToFit()
            timeImg.frame = CGRectMake(CGRectGetMaxX(timeLab.frame), timeImg.frame.origin.y, 12, 12)
        case PortType.expectSalary:
            expectSalaryLab.text = string
            expectSalaryLab.enabled = true
            expectSalaryLab.sizeToFit()
            expectSalaryImg.frame = CGRectMake(CGRectGetMaxX(expectSalaryLab.frame), expectSalaryImg.frame.origin.y, 12, 12)
        case PortType.expectPostion:
            expectPostionLab.text = string
            expectPostionLab.enabled = true
            expectPostionLab.sizeToFit()
            expectPostionImg.frame = CGRectMake(CGRectGetMaxX(expectPostionLab.frame), expectPostionImg.frame.origin.y, 12, 12)
            
        default:
            print("defaut")
        }
    }
    
    func dataGet(optionType:OptionType){
        
        switch optionType {
        case .sex:
            self.chooseList = optionDictionary["sex"]!
        case .edu:
            self.chooseList = optionDictionary["edu"]!
        case .work:
            self.chooseList = optionDictionary["work"]!
        case .salary,.expectSalary:
            self.chooseList = optionDictionary["salary"]!
        case .jobStatus:
            self.chooseList = optionDictionary["jobStatus"]!
        case .time:
            self.chooseList = optionDictionary["time"]!
        case .expectPostion:
            self.chooseList = optionDictionary["expectPostion"]!
        default:
            print("defaut")
        }
             
        self.chooseTableView .reloadData()
   
        
    }
    
    /*****             结束             *****/
    // MARK:-
    
    @IBOutlet weak var brith_year: UILabel!
    @IBOutlet weak var brith_month: UILabel!
    @IBOutlet weak var brith_day: UILabel!
    @IBAction func birthbuttonClick(sender: AnyObject) {

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
//            self.birthBtn.setTitle(time, forState: .Normal)
            self.brith_year.text = timeArr.first
            self.brith_month.text = timeArr[1]
            self.brith_day.text = timeArr.last
            
            self.brith_year.enabled = true
            self.brith_month.enabled = true
            self.brith_day.enabled = true
            
        }
 
    }
    

    func change(controller:HSEditResumeViewController,string:String,idStr:String){

        if idStr == "1" {
            educationBtn.setTitle(string, forState: .Normal)
        }else if idStr == "14"{
            moneyBtn.setTitle(string, forState: .Normal)
        }else if idStr == "12"{
            expectPayBtn.setTitle(string, forState: .Normal)
        }else if idStr == "13"{
            expectPostBtn.setTitle(string, forState: .Normal)
        }
        
    }
    
    
    
    @IBAction func placeBtnClick(sender: AnyObject) {

        print(22)
        // 初始化
        
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true
        pick.pickArray=array // 设置第一次加载时需要跳转到相对应的地址
//        self.addSubview(pick)
         pick.show((UIApplication.sharedApplication().keyWindow)!)
        
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in

            self.array=dressArray
            print("选择的地区是: \(dressArray)")
            //            self.workplaceBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)

            self.placeLab_1.text =  (dressArray[0] as! String)
            self.placeLab_2.text =  (dressArray[1] as! String)
            self.placeLab_3.text =  (dressArray[2] as! String)

            self.placeLab_1.enabled = true
            self.placeLab_2.enabled = true
            self.placeLab_3.enabled = true

            self.placeLab_1.sizeToFit()
            self.placeImg_1.frame = CGRectMake(CGRectGetMaxX(self.placeLab_1.frame), self.placeImg_1.frame.origin.y, 12, 12)


            self.placeLab_2.frame = CGRectMake(CGRectGetMaxX(self.placeImg_1.frame)+5, self.placeLab_2.frame.origin.y, self.placeLab_2.frame.size.width, 12)
            self.placeLab_2.adjustsFontSizeToFitWidth = true
            self.placeLab_2.sizeToFit()
            self.placeImg_2.frame = CGRectMake(CGRectGetMaxX(self.placeLab_2.frame), self.placeImg_2.frame.origin.y, 12, 12)

            self.placeLab_3.frame = CGRectMake(CGRectGetMaxX(self.placeImg_2.frame)+5, self.placeLab_3.frame.origin.y, self.placeLab_3.frame.size.width, 12)
            self.placeLab_3.adjustsFontSizeToFitWidth = true
            self.placeLab_3.sizeToFit()
            self.placeImg_3.frame = CGRectMake(CGRectGetMaxX(self.placeLab_3.frame), self.placeImg_3.frame.origin.y, 12, 12)
        }
        
    }
    
  

    
    @IBAction func targetCityBtnClick(sender: AnyObject) {
        let pick = AdressPickerView.shareInstance
        
        // 设置是否显示区县等，默认为false不显示
        pick.showTown=true
        pick.pickArray=array // 设置第一次加载时需要跳转到相对应的地址
        //        self.addSubview(pick)
        pick.show((UIApplication.sharedApplication().keyWindow)!)
        // 选择完成之后回调
        pick.selectAdress { (dressArray) in
            
            self.array=dressArray
            print("选择的地区是: \(dressArray)")

            self.targetCity_1_Lab.text =  (dressArray[0] as! String)
            self.targetCity_2_Lab.text =  (dressArray[1] as! String)
            self.targetCity_3_Lab.text =  (dressArray[2] as! String)
            
            self.targetCity_1_Lab.enabled = true
            self.targetCity_2_Lab.enabled = true
            self.targetCity_3_Lab.enabled = true
            
            self.targetCity_1_Lab.sizeToFit()
            self.targetCity_1_Img.frame = CGRectMake(CGRectGetMaxX(self.targetCity_1_Lab.frame), self.targetCity_1_Img.frame.origin.y, 12, 12)
            
            
            self.targetCity_2_Lab.frame = CGRectMake(CGRectGetMaxX(self.targetCity_1_Img.frame)+5, self.targetCity_2_Lab.frame.origin.y, self.targetCity_2_Lab.frame.size.width, 12)
            self.targetCity_2_Lab.adjustsFontSizeToFitWidth = true
            self.targetCity_2_Lab.sizeToFit()
            self.targetCity_2_Img.frame = CGRectMake(CGRectGetMaxX(self.targetCity_2_Lab.frame), self.targetCity_2_Img.frame.origin.y, 12, 12)
            
            self.targetCity_3_Lab.frame = CGRectMake(CGRectGetMaxX(self.targetCity_2_Img.frame)+5, self.targetCity_3_Lab.frame.origin.y, self.targetCity_3_Lab.frame.size.width, 12)
            self.targetCity_3_Lab.adjustsFontSizeToFitWidth = true
            self.targetCity_3_Lab.sizeToFit()
            self.targetCity_3_Img.frame = CGRectMake(CGRectGetMaxX(self.targetCity_3_Lab.frame), self.targetCity_3_Img.frame.origin.y, 12, 12)
            
        }

    }


    func click(){
        view.removeFromSuperview()
        albumBtn.removeFromSuperview()
        let imagePicker = UIImagePickerController();
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        let vc = responderVC()
        vc!.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
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
                            self.avatarBtn.setImage(image, forState: .Normal)
                            self.mainHelper.changeUserAvatar(result.data!, handle: { (success, response) in
                                if success {
                                    QCLoginUserInfo.currentInfo.avatar = result.data!
                                }
                            })
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
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
        avatarBtn.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar) , forState: .Normal)
        avatarBtn.layer.cornerRadius = 40
        avatarBtn.clipsToBounds = true
        avatarBtn.userInteractionEnabled = true

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var keyboardHeight:CGFloat = 0.0
    
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameBeginUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        if selfEvaluate.isFirstResponder() {
            
            UIView.animateWithDuration(0.3) {
                self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height+keyboardheight)
                self.myScrollview.frame = CGRectMake(self.myScrollview.frame.origin.x, self.myScrollview.frame.origin.y, self.myScrollview.frame.size.width, self.myScrollview.frame.size.height-keyboardheight)
            }
        }
        
        keyboardHeight = keyboardheight
        print("键盘弹起")
        print(keyboardheight)
        
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        
        if self.myScrollview.frame.size.height<=HEIGHT-64-49-keyboardHeight {

            UIView.animateWithDuration(0.3) {
    //            self.myScrollview.contentOffset = CGPoint.init(x: 0, y: self.myScrollview.contentSize.height-self.myScrollview.frame.size.height)

                self.myScrollview.frame = CGRectMake(self.myScrollview.frame.origin.x, self.myScrollview.frame.origin.y, self.myScrollview.frame.size.width, self.myScrollview.frame.size.height+self.keyboardHeight)
            }
        }
        print("键盘落下")
    }
    
    //MARK:UITextViewDelegate
    func textViewDidChange(textView: UITextView) {
        if (textView.text == "") {
            selfLab.text = "自我介绍"
        }else{
            selfLab.text = ""
        }
    }
}



