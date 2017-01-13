//
//  CompanyAuthViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import TZImagePickerController

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class CompanyAuthViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TZImagePickerControllerDelegate {
    
    @IBOutlet weak var bigScrollview: UIScrollView!
    
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var descriptionField: UITextField!
    
    @IBOutlet weak var contactField: UITextField!
    
    @IBOutlet weak var telField: UITextField!
    
    @IBOutlet weak var mailField: UITextField!
    
    
    var imageUrl:String?
    
    var selectedImage:UIImage?
    
    var type = 0 {
        didSet {
            print("-=-=-=-==-  \(type)")
            
            if type == 1 {
                
                authView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
                self.view.addSubview(authView)
            }else if type == 2 {
                
                waitView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
                self.view.addSubview(waitView)
            }else if type == 3 {
                successNameLab.text = companyInfo?.companyname
                successDescriptionLab.text = companyInfo?.companyinfo
                successContactLab.text = companyInfo?.linkman
                successTelLab.text = companyInfo?.phone
                successMailLab.text = companyInfo?.email
                
                if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {

                    successLicenseImg.image = UIImage.init(named: "defaultImage.png")
                }else{
                    successLicenseImg.sd_setImage(with: URL.init(string: SHOW_IMAGE_HEADER+(companyInfo?.license)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
                }
//                successLicenseImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+(companyInfo?.license)!), placeholderImage: UIImage.init(named: "defaultImage.png"))
                successView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
                self.view.addSubview(successView)
            }else if type == 4 {
                failView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
                self.view.addSubview(failView)
            }
        }
    }
    
    var companyInfo:CompanyInfo?
    
    @IBOutlet weak var waitImg: UIImageView!
    
    @IBOutlet weak var successBgView: UIView!
    
    @IBOutlet weak var successNameLab: UILabel!
    
    @IBOutlet weak var successDescriptionLab: UILabel!
    
    @IBOutlet weak var successContactLab: UILabel!
    
    @IBOutlet weak var successTelLab: UILabel!
    
    @IBOutlet weak var successMailLab: UILabel!
    
    @IBOutlet weak var successLicenseImg: UIImageView!
    
    @IBOutlet weak var successChangeBtn: UIButton!
    
    @IBOutlet weak var reCertifyBtn: UIButton!
    
    var authView = UIView()
    var waitView = UIView()
    var successView = UIView()
    var failView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let viewArr = Bundle.main.loadNibNamed("CompanyAuthViewController", owner: self, options: nil) as! Array<UIView>
        
        for myView in viewArr {
            
            if myView.restorationIdentifier == "auth" {
                
                bgView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
                bgView.layer.borderWidth = 1
                
                submitBtn.layer.borderColor = COLOR.cgColor
                submitBtn.layer.borderWidth = 1
                submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2.0
                submitBtn.setTitleColor(COLOR, for: UIControlState())
                
                self.uploadBtn.imageView?.contentMode = .scaleAspectFit
                
                nameField.borderStyle = .none
                descriptionField.borderStyle = .none
                contactField.borderStyle = .none
                telField.borderStyle = .none
                mailField.borderStyle = .none
                
                authView = myView
            }else if myView.restorationIdentifier == "wait" {
                
                //                [UIView beginAnimations:nil context:nil];
                //                [UIView setAnimationDuration:0.01];
                //                [UIView setAnimationDelegate:self];
                //                [UIView setAnimationDidStopSelector:@selector(endAnimation)];
                //                imageView.transform = CGAffineTransformMakeRotation(angle * (M_PI / 180.0f));
                //                [UIView commitAnimations];
                
                self.startAnimation()
                
                waitView = myView
            }else if myView.restorationIdentifier == "success" {
                
                successBgView?.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).cgColor
                successBgView?.layer.borderWidth = 1
                
                successChangeBtn?.layer.borderColor = COLOR.cgColor
                successChangeBtn?.layer.borderWidth = 1
                successChangeBtn?.layer.cornerRadius = (successChangeBtn?.frame.size.height)!/2.0
                successChangeBtn?.setTitleColor(COLOR, for: UIControlState())
                
                successLicenseImg?.contentMode = .scaleAspectFit
                
                successView = myView
            }else if myView.restorationIdentifier == "fail" {
                reCertifyBtn?.layer.borderColor = COLOR.cgColor
                reCertifyBtn?.layer.borderWidth = 1
                reCertifyBtn?.layer.cornerRadius = (successChangeBtn?.frame.size.height)!/2.0
                reCertifyBtn?.setTitleColor(COLOR, for: UIControlState())
                
                failView = myView
            }
        }
        
        
        
    }
    
    func startAnimation() {
        let endAngle = CGAffineTransform(rotationAngle: 360*(CGFloat(M_PI)/180.0))
        
        UIView.animate(withDuration: 1, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            
            self.waitImg.transform = endAngle
            
            }, completion: { (finished) in
                
                if finished {
                    
                    self.startAnimation()
                }
                
        })
    }
    
    @IBAction func uploadBtnClick(_ sender: AnyObject) {
        
        let imagePickerVc = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerVc?.allowCrop = false
        imagePickerVc?.sortAscendingByModificationDate = false
        self.present(imagePickerVc!, animated: true, completion: nil)
        
//        let picker = UIImagePickerController()
//        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        //裁剪后图片
        selectedImage = photos.first
        
        self.uploadBtn.setImage(selectedImage, for: UIControlState())
        
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        
//        let type = info[UIImagePickerControllerMediaType] as! String
//        if type != "public.image" {
//            return
//        }
//        
//        //裁剪后图片
//        selectedImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
//        
//        self.uploadBtn.setImage(selectedImage, for: UIControlState())
//        
//        picker.dismiss(animated: true, completion: nil)
//    }
    
    func delBtnClick(_ delBtn:UIButton) {
        //        self.uploadBtn.imageView?.contentMode = .ScaleAspectFit
        self.uploadBtn.setImage(UIImage.init(named: "ic_shangchuan"), for: UIControlState())
        delBtn.removeFromSuperview()
    }
    
    //MARK:点击提交按钮
    @IBAction func submitBtnClick(_ sender: AnyObject) {
        
        if self.nameField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入企业名称！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.descriptionField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入企业简介！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.contactField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入联系人姓名！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.telField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入联系电话！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.mailField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入邮箱地址！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if selectedImage == nil {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请上传营业执照！", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(doneAction)
        }else {
            
            if !PhoneNumberIsValidated(telField.text!) {
                var messageStr = "请填写正确的电话号码"
                
                if telField.text!.hasPrefix("0") {
                    messageStr = "请填写正确的电话号码\n区号与座机号之间用-隔开"
                }else if 7 <= telField.text!.characters.count && telField.text!.characters.count <= 8 && telField.text?.trimmingCharacters(in: CharacterSet.decimalDigits).characters.count <= 0 {
                    messageStr = "请填写正确的电话号码\n（包含区号）"
                }
                
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString(messageStr, comment: "empty message"), preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
            if !EmailIsValidated(mailField.text!) {
                let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请填写正确的邮箱地址", comment: "empty message"), preferredStyle: .alert)
                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(doneAction)
                
                self.present(alertController, animated: true, completion: nil)
                return
            }
           uploadLicense()
        }
        
    }
    
    // MARK:- 上传营业执照
    func uploadLicense() {
        // 正在上传提示
        let tipHud = MBProgressHUD.showAdded(to: self.view, animated: true)
        tipHud.label.text = "正在上传营业执照"
        tipHud.margin = 10.0
        tipHud.removeFromSuperViewOnHide = true
        
        let data = UIImageJPEGRepresentation(selectedImage!, 0.1)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.string(from: Date())
        let imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
        
        ConnectModel.upload(withImageName: imageName, imageData: data, url: "\(PARK_URL_Header)uploadavatar") {  (data) in
        
            DispatchQueue.main.async(execute: {
                let result = Http(JSONDecoder(data as AnyObject))
                if result.status != nil {
                    if result.status! == "success"{
                        //                        self.selectImages.append(image)
                        //                        self.imageNames.append(imageName+".png")
                        //                        self.collectImageView?.reloadData()
                        
                        self.imageUrl = imageName+".png"
                        
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        hud.mode = MBProgressHUDMode.Text;
//                        hud.label.text = "营业执照上传成功"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
//                        hud.hide(animated: true, afterDelay: 1)
                        
                        tipHud.label.text = "正在提交企业信息"
                        
                        self.submit(tipHud)
                       //                            let alertController = UIAlertController(title: "执照上传成功，等待接口！", message: "企业名称：\(self.nameField!.text)\n企业简介：\(self.descriptionField!.text)\n联系人：\(self.contactField!.text)\n企业电话\(self.telField!.text)\n企业邮箱：\(self.mailField!.text)\n营业执照URL：\(self.imageUrl!)", preferredStyle: .Alert)
                        //                            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                        //                            alertController.addAction(doneAction)
                        //                            self.presentViewController(alertController, animated: true, completion: nil)
                    }else{
//                        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//                        hud.mode = MBProgressHUDMode.Text;
//                        hud.label.text = "营业执照上传失败"
//                        hud.margin = 10.0
//                        hud.removeFromSuperViewOnHide = true
//                        hud.hide(animated: true, afterDelay: 1)
                        tipHud.hide(animated: true)
                        
                        let alertController = UIAlertController(title: "营业执照上传失败", message: "", preferredStyle: .alert)
                        self.present(alertController, animated: true, completion: nil)
                        
                        let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                            self.uploadLicense()
                        })
                        alertController.addAction(replyAction)
                        
                        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                    }
                    
                }
                })
        }
    }
    
    // MARK:- 提交
    func submit(_ hud:MBProgressHUD) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
//        let dateStr = dateFormatter.stringFromDate(NSDate())
        let dateStr = String(Date().timeIntervalSince1970)
        
        HSMineHelper().updataCompanyCertifyWith(self.nameField.text!, companyinfo: self.descriptionField.text!, create_time: dateStr, phone: self.telField.text!, email: self.mailField.text!, linkman: self.contactField.text!, license: self.imageUrl!, handle: { (success, response) in
            print("=-=-+++++-=-=-=  \(success) \(response)")
            
            hud.hide(animated: true, afterDelay: 0.5)
            
            if success {
                let alertController = UIAlertController(title: "提交成功", message: "", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                let doneAction = UIAlertAction(title: "确定", style: .cancel, handler: { (action) in
                    self.authView.removeFromSuperview()
                    self.waitView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
                    self.view.addSubview(self.waitView)
                })
                alertController.addAction(doneAction)
            }else {
                let alertController = UIAlertController(title: "提交失败", message: "", preferredStyle: .alert)
                self.present(alertController, animated: true, completion: nil)
                
                let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                    self.submit(hud)
                })
                alertController.addAction(replyAction)
                
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
            }
        })
    }
    
    // MARK: 修改认证信息
    @IBAction func changeCompanyInfo(_ sender: UIButton) {
        let alertController = UIAlertController(title: "修改企业信息需要重新认证", message: "是否确认修改？", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
        
        let replyAction = UIAlertAction(title: "确认", style: .default, handler: { (action) in
            self.successView.removeFromSuperview()
            self.authView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
            self.view.addSubview(self.authView)
        })
        alertController.addAction(replyAction)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    }
    
    // MARK: 重新认证
    @IBAction func reCertify(_ sender: UIButton) {
        self.failView.removeFromSuperview()
        self.authView.frame.size = CGSize(width: WIDTH, height: HEIGHT)
        self.view.addSubview(self.authView)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        for view in self.view.subviews {
//            view.removeFromSuperview()
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
