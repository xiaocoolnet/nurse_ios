//
//  HSPostResumeView.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/2.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol HSPostResumeViewDelegate:NSObjectProtocol{
    func uploadAvatar() -> UIImage
    func saveResumeBtnClicked()
}

class HSPostResumeView: UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate, ChangeDelegate {
    
    @IBOutlet weak var borderView1: UIView!
    @IBOutlet weak var borderView2: UIView!
    @IBOutlet weak var selfEvaluate: UITextView!
    @IBOutlet weak var savaResume: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var sexLable: UILabel!
    @IBOutlet weak var sexTextField: UITextField!
    @IBOutlet weak var nameTextFeild: UITextField!
    @IBOutlet weak var nameLable: UILabel!
    @IBOutlet weak var clickLable: UILabel!
    @IBOutlet weak var birthLable: UILabel!
    @IBOutlet weak var birthBtn: UIButton!
    @IBOutlet weak var eduLable: UILabel!
    @IBOutlet weak var educationBtn: UIButton!
    @IBOutlet weak var plaLable: UILabel!
    @IBOutlet weak var placeBtn: UIButton!
    @IBOutlet weak var workTextField: UITextField!
    @IBOutlet weak var postField: UITextField!
    @IBOutlet weak var moneyBtn: UIButton!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var mailboxField: UITextField!
    @IBOutlet weak var targetCityBtn: UIButton!
    @IBOutlet weak var entryTimeBtn: UIButton!
    @IBOutlet weak var expectPayBtn: UIButton!
    @IBOutlet weak var expectPostBtn: UIButton!
    
    var view = UIView()
    var albumBtn = UIButton()
    var myActionSheet:UIAlertController?
    var avatarView = UIButton(type: UIButtonType.Custom)
    var mainHelper = HSMineHelper()
    var selfNav:UINavigationController?
    
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = NSArray()
    
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
        print(userid)
        print(imageName)
        print(nameTextFeild.text)
        print(workTextField.text)
        print(sexTextField.text)
        print(birthBtn.titleLabel?.text)
        print(educationBtn.titleLabel?.text)
        print(placeBtn.titleLabel?.text)
        print(stateField.text)
        print(moneyBtn.titleLabel?.text)
        print(phoneField.text)
        print(mailboxField.text)
        print(entryTimeBtn.titleLabel?.text)
        print(targetCityBtn.titleLabel?.text)
        print(expectPayBtn.titleLabel?.text)
        print(expectPostBtn.titleLabel?.text)
        print(selfEvaluate.text)
        
        help.postForum(userid, avatar:imageName, name: nameTextFeild.text!, experience: workTextField.text!, sex: sexTextField.text!, birthday:(birthBtn.titleLabel?.text!)!, marital:(educationBtn.titleLabel?.text!)! , address:(placeBtn.titleLabel?.text!)!, jobstate:stateField.text!, currentsalary:(moneyBtn.titleLabel?.text!)!, phone:phoneField.text!, email:mailboxField.text!, hiredate:(entryTimeBtn.titleLabel?.text)!, wantcity:(targetCityBtn.titleLabel?.text!)!, wantsalary:(expectPayBtn.titleLabel?.text!)!, wantposition:(expectPostBtn.titleLabel?.text!)!, description:selfEvaluate.text, handle: { (success, response) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text;
                    hud.labelText = "发布成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                    
                })
            }
        })

    }
    
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
            self.birthBtn.setTitle(time, forState: .Normal)
            
        }
 
    }
    
    @IBAction func educationbtnClick(sender: AnyObject) {
//        let vc = HSEditResumeViewController()
        vc.delegate = self
        vc.num = "1"
        selfNav?.pushViewController(vc, animated: true)
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
            
//            self.placeBtn.text="\(dressArray[0])  \(dressArray[1])  \(dressArray[2])"
            self.placeBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)
            print(1111)
        }
               
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
        
        next.num = "14"
        next.delegate = self
        selfNav?.pushViewController(next, animated: true)

    }
    
    @IBAction func entryTimeBtnClick(sender: AnyObject) {
        
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
            self.entryTimeBtn.setTitle(time, forState: .Normal)
            
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
            
            //            self.placeBtn.text="\(dressArray[0])  \(dressArray[1])  \(dressArray[2])"
            self.targetCityBtn.setTitle("\(dressArray[0])  \(dressArray[1])  \(dressArray[2])", forState: .Normal)
            print(1111)
        }

    }

    
    @IBAction func expectPayBtn(sender: AnyObject) {
        nextVC.delegate = self
        nextVC.num = "12"
        selfNav?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func expectPostBtnClick(sender: AnyObject) {
        VC.delegate = self
        VC.num = "13"
        selfNav?.pushViewController(VC, animated: true)
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
}



