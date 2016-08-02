//
//  CompanyAuthViewController.swift
//  HSHW_2016
//
//  Created by DreamCool on 16/7/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class CompanyAuthViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
                
                authView.frame.size = CGSizeMake(WIDTH, HEIGHT)
                self.view.addSubview(authView)
            }else if type == 2 {
                
                waitView.frame.size = CGSizeMake(WIDTH, HEIGHT)
                self.view.addSubview(waitView)
            }else if type == 3 {
                
                successView.frame.size = CGSizeMake(WIDTH, HEIGHT)
                self.view.addSubview(successView)
            }
        }
    }
    
    @IBOutlet weak var waitImg: UIImageView!
    
    @IBOutlet weak var successBgView: UIView!
    
    @IBOutlet weak var successNameLab: UILabel!
    
    @IBOutlet weak var successDescriptionLab: UILabel!
    
    @IBOutlet weak var successContactLab: UILabel!
    
    @IBOutlet weak var successTelLab: UILabel!
    
    @IBOutlet weak var successMailLab: UILabel!
    
    @IBOutlet weak var successLicenseImg: UIImageView!
    
    @IBOutlet weak var successChangeBtn: UIButton!
    
    var authView = UIView()
    var waitView = UIView()
    var successView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        let viewArr = NSBundle.mainBundle().loadNibNamed("CompanyAuthViewController", owner: self, options: nil) as! Array<UIView>
        
        for myView in viewArr {
            
            if myView.restorationIdentifier == "auth" {
                
                bgView.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
                bgView.layer.borderWidth = 1
                
                submitBtn.layer.borderColor = COLOR.CGColor
                submitBtn.layer.borderWidth = 1
                submitBtn.layer.cornerRadius = submitBtn.frame.size.height/2.0
                submitBtn.setTitleColor(COLOR, forState: .Normal)
                
                self.uploadBtn.imageView?.contentMode = .ScaleAspectFit
                
                nameField.borderStyle = .None
                descriptionField.borderStyle = .None
                contactField.borderStyle = .None
                telField.borderStyle = .None
                mailField.borderStyle = .None
                
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
                
                successBgView?.layer.borderColor = UIColor.init(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1).CGColor
                successBgView?.layer.borderWidth = 1
                
                successChangeBtn?.layer.borderColor = COLOR.CGColor
                successChangeBtn?.layer.borderWidth = 1
                successChangeBtn?.layer.cornerRadius = (successChangeBtn?.frame.size.height)!/2.0
                successChangeBtn?.setTitleColor(COLOR, forState: .Normal)
                
                successLicenseImg?.contentMode = .ScaleAspectFit
                
                successView = myView
            }
        }
        
     
        
    }
    
    func startAnimation() {
        let endAngle = CGAffineTransformMakeRotation(360*(CGFloat(M_PI)/180.0))
                                                     
         UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
            
            self.waitImg.transform = endAngle
            
            }, completion: { (finished) in
                self.startAnimation()
                
         })
    }

    @IBAction func uploadBtnClick(sender: AnyObject) {
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        
        //裁剪后图片
        selectedImage = (info[UIImagePickerControllerEditedImage] as! UIImage)
        
        self.uploadBtn.setImage(selectedImage, forState: .Normal)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delBtnClick(delBtn:UIButton) {
//        self.uploadBtn.imageView?.contentMode = .ScaleAspectFit
        self.uploadBtn.setImage(UIImage.init(named: "ic_shangchuan"), forState: .Normal)
        delBtn.removeFromSuperview()
    }
    
    //MARK:点击提交按钮
    @IBAction func submitBtnClick(sender: AnyObject) {
        
        if self.nameField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入企业名称！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.descriptionField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入企业简介！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.contactField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入联系人姓名！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.telField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入联系电话！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if self.mailField.text == "" {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请输入邮箱地址！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else if selectedImage == nil {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("请上传营业执照！", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
        }else {
            
            // 正在上传提示
            let tipHud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            tipHud.labelText = "正在上传营业执照"
            tipHud.margin = 10.0
            tipHud.removeFromSuperViewOnHide = true
            
            let data = UIImageJPEGRepresentation(selectedImage!, 0.1)!
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.stringFromDate(NSDate())
            let imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
            
            ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://nurse.xiaocool.net/index.php?g=apps&m=index&a=uploadavatar") {  (data) in
                dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                    let result = Http(JSONDecoder(data))
                    if result.status != nil {
                        if result.status! == "success"{
                            //                        self.selectImages.append(image)
                            //                        self.imageNames.append(imageName+".png")
                            //                        self.collectImageView?.reloadData()
                            
                            self.imageUrl = imageName+".png"
                            
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "营业执照上传成功"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                            
                            let alertController = UIAlertController(title: "执照上传成功，等待接口！", message: "企业名称：\(self.nameField!.text)\n企业简介：\(self.descriptionField!.text)\n联系人：\(self.contactField!.text)\n企业电话\(self.telField!.text)\n企业邮箱：\(self.mailField!.text)\n营业执照URL：\(self.imageUrl!)", preferredStyle: .Alert)
                            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
                            alertController.addAction(doneAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "营业执照上传失败"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                        
                        tipHud.hide(true)
                    }
                    })
            }
            
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
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
