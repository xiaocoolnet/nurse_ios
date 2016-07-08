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

class HSPostResumeView: UIView,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate {
    
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
        delegate?.saveResumeBtnClicked()
        
}
    
    @IBAction func birthbuttonClick(sender: AnyObject) {
    }
    
    @IBAction func educationbtnClick(sender: AnyObject) {
    }
    
    @IBAction func placeBtnClick(sender: AnyObject) {
    }
    
    @IBAction func moneyBtnClick(sender: AnyObject) {
    }
    
    @IBAction func entryTimeBtnClick(sender: AnyObject) {
    }
    
    @IBAction func targetCityBtnClick(sender: AnyObject) {
    }

    
    @IBAction func expectPayBtn(sender: AnyObject) {
    }
    
    @IBAction func expectPostBtnClick(sender: AnyObject) {
    }
    
    func click(){
        print(11111)
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
        let imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
        
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
