//
//  NSCircleApplyMasterViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/3.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleApplyMasterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 圈子名称
    let circleNameInput = UITextField()

    // 真实姓名
    let userNameInput = UITextField()
    
    // 身份证号
    let idInput = UITextField()
    
    // 联系地址
    let addressInput = UITextField()

    // 手机号码
    let telInput = UITextField()

    // QQ号码
    let qqInput = UITextField()

    // 申请感言
//    let testimonialsInput = UITextField()
    let testimonialsInput = UIPlaceHolderTextView()
    
    var selected1Image:UIImage?
    var selected2Image:UIImage?

    let cer1Btn = UIButton()
    
    let cer2Btn = UIButton()

    var selectedImage = ""  // 0  1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        self.title = "申请圈主"
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        let rootScrollView = TPKeyboardAvoidingScrollView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65))
        
        self.view.addSubview(rootScrollView)
        
        let inputBgView = UIView(frame: CGRect(x: 15, y: 15, width: WIDTH-30, height: 0))
        inputBgView.layer.borderColor = UIColor.lightGray.cgColor
        inputBgView.layer.borderWidth = 1/UIScreen.main.scale
        rootScrollView.addSubview(inputBgView)
        
        // MARK: 圈子名称
        let typeLab = UILabel(frame: CGRect(x: 0, y: 0, width: inputBgView.frame.width*0.275, height: 44))
        typeLab.textAlignment = .center
        typeLab.font = UIFont.systemFont(ofSize: 16)
        typeLab.adjustsFontSizeToFitWidth = true
        typeLab.text = "圈子名称"
        inputBgView.addSubview(typeLab)
        
        let typeLine = UIView(frame: CGRect(x: typeLab.frame.maxX, y: typeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: typeLab.frame.height-10))
        typeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(typeLine)
        
        circleNameInput.frame = CGRect(x: typeLine.frame.maxX+20, y: 0, width: inputBgView.frame.width-(typeLine.frame.maxX+20), height: 44)
        circleNameInput.font = UIFont.systemFont(ofSize: 14)
        circleNameInput.adjustsFontSizeToFitWidth = true
        circleNameInput.textAlignment = .left
        circleNameInput.placeholder = "请填写圈子名称"
        inputBgView.addSubview(circleNameInput)
        
        
        let line1 = UIView(frame: CGRect(x: 0, y: typeLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line1.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line1)
        
        // MARK: 真实姓名
        let placeLab = UILabel(frame: CGRect(x: 0, y: line1.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        placeLab.textAlignment = .center
        placeLab.font = UIFont.systemFont(ofSize: 16)
        placeLab.adjustsFontSizeToFitWidth = true
        placeLab.text = "真实姓名"
        inputBgView.addSubview(placeLab)
        
        let placeLine = UIView(frame: CGRect(x: placeLab.frame.maxX, y: placeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: placeLab.frame.height-10))
        placeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(placeLine)
        
        userNameInput.frame = CGRect(x: placeLine.frame.maxX+20, y: line1.frame.maxY, width: inputBgView.frame.width-(placeLine.frame.maxX+20), height: 44)
        userNameInput.font = UIFont.systemFont(ofSize: 14)
        userNameInput.adjustsFontSizeToFitWidth = true
        userNameInput.textAlignment = .left
        userNameInput.placeholder = "请输入您的真实姓名"
        inputBgView.addSubview(userNameInput)
        
        let line2 = UIView(frame: CGRect(x: 0, y: placeLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line2.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line2)
        
        // MARK: 身份证号
        let idLab = UILabel(frame: CGRect(x: 0, y: line2.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        idLab.textAlignment = .center
        idLab.font = UIFont.systemFont(ofSize: 16)
        idLab.adjustsFontSizeToFitWidth = true
        idLab.text = "身份证号"
        inputBgView.addSubview(idLab)
        
        let idLine = UIView(frame: CGRect(x: idLab.frame.maxX, y: idLab.frame.minY+5, width: 1/UIScreen.main.scale, height: idLab.frame.height-10))
        idLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(idLine)
        
        idInput.frame = CGRect(x: idLine.frame.maxX+20, y: line2.frame.maxY, width: inputBgView.frame.width-(idLine.frame.maxX+20), height: 44)
        idInput.font = UIFont.systemFont(ofSize: 14)
        idInput.adjustsFontSizeToFitWidth = true
        idInput.textAlignment = .left
        idInput.placeholder = "请输入您的身份证号码"
        inputBgView.addSubview(idInput)
        
        let line3 = UIView(frame: CGRect(x: 0, y: idLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line3.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line3)
        
        // MARK: 联系地址
        let addressLab = UILabel(frame: CGRect(x: 0, y: line3.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        addressLab.textAlignment = .center
        addressLab.font = UIFont.systemFont(ofSize: 16)
        addressLab.adjustsFontSizeToFitWidth = true
        addressLab.text = "联系地址"
        inputBgView.addSubview(addressLab)
        
        let addressLine = UIView(frame: CGRect(x: addressLab.frame.maxX, y: addressLab.frame.minY+5, width: 1/UIScreen.main.scale, height: addressLab.frame.height-10))
        addressLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(addressLine)
        
        addressInput.frame = CGRect(x: addressLine.frame.maxX+20, y: line3.frame.maxY, width: inputBgView.frame.width-(addressLine.frame.maxX+20), height: 44)
        addressInput.font = UIFont.systemFont(ofSize: 14)
        addressInput.adjustsFontSizeToFitWidth = true
        addressInput.textAlignment = .left
        addressInput.placeholder = "请输入您的联系地址"
        inputBgView.addSubview(addressInput)
        
        let line4 = UIView(frame: CGRect(x: 0, y: addressLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line4.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line4)
        
        // MARK: 手机号码
        let telLab = UILabel(frame: CGRect(x: 0, y: line4.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        telLab.textAlignment = .center
        telLab.font = UIFont.systemFont(ofSize: 16)
        telLab.adjustsFontSizeToFitWidth = true
        telLab.text = "手机号码"
        inputBgView.addSubview(telLab)
        
        let telLine = UIView(frame: CGRect(x: telLab.frame.maxX, y: telLab.frame.minY+5, width: 1/UIScreen.main.scale, height: telLab.frame.height-10))
        telLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(telLine)
        
        telInput.frame = CGRect(x: telLine.frame.maxX+20, y: line4.frame.maxY, width: inputBgView.frame.width-(telLine.frame.maxX+20), height: 44)
        telInput.font = UIFont.systemFont(ofSize: 14)
        telInput.adjustsFontSizeToFitWidth = true
        telInput.textAlignment = .left
        telInput.placeholder = "请输入您的手机号码"
        inputBgView.addSubview(telInput)
        
        let line5 = UIView(frame: CGRect(x: 0, y: telLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line5.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line5)
        
        // MARK: QQ号码
        let qqLab = UILabel(frame: CGRect(x: 0, y: line5.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        qqLab.textAlignment = .center
        qqLab.font = UIFont.systemFont(ofSize: 16)
        qqLab.adjustsFontSizeToFitWidth = true
        qqLab.text = "QQ号码"
        inputBgView.addSubview(qqLab)
        
        let qqLine = UIView(frame: CGRect(x: qqLab.frame.maxX, y: qqLab.frame.minY+5, width: 1/UIScreen.main.scale, height: qqLab.frame.height-10))
        qqLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(qqLine)
        
        qqInput.frame = CGRect(x: qqLine.frame.maxX+20, y: line5.frame.maxY, width: inputBgView.frame.width-(qqLine.frame.maxX+20), height: 44)
        qqInput.font = UIFont.systemFont(ofSize: 14)
        qqInput.adjustsFontSizeToFitWidth = true
        qqInput.textAlignment = .left
        qqInput.placeholder = "请输入您的QQ号码"
        inputBgView.addSubview(qqInput)
        
        let line6 = UIView(frame: CGRect(x: 0, y: qqLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line6.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line6)
        
        // MARK: 申请感言
        let officeLab = UILabel(frame: CGRect(x: 0, y: line6.frame.maxY, width: inputBgView.frame.width*0.275, height: 132))
        officeLab.textAlignment = .center
        officeLab.font = UIFont.systemFont(ofSize: 16)
        officeLab.adjustsFontSizeToFitWidth = true
        officeLab.text = "申请感言"
        inputBgView.addSubview(officeLab)
        
        let officeLine = UIView(frame: CGRect(x: officeLab.frame.maxX, y: officeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: officeLab.frame.height-10))
        officeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(officeLine)
        
        testimonialsInput.frame = CGRect(x: officeLine.frame.maxX+15, y: line6.frame.maxY, width: inputBgView.frame.width-(officeLine.frame.maxX+20), height: 132)
        testimonialsInput.placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 205/255.0, alpha: 1)
        testimonialsInput.font = UIFont.systemFont(ofSize: 14)
        testimonialsInput.textAlignment = .left
        testimonialsInput.placeholder = "请输入您的申请理由、每天上网时间、是否有贴吧论坛等管理经验；越详细通过几率越大"
        inputBgView.addSubview(testimonialsInput)
        
        inputBgView.frame.size.height = officeLab.frame.maxY
        
        // MARK: 证件验证
        let cerLab = UILabel(frame: CGRect(x: 15, y: inputBgView.frame.maxY+20, width: WIDTH-30, height: 20))
        cerLab.font = UIFont.systemFont(ofSize: 14)
        cerLab.adjustsFontSizeToFitWidth = true
        cerLab.textAlignment = .left
        cerLab.textColor = COLOR
        cerLab.text = "证件验证"
        rootScrollView.addSubview(cerLab)
        
        let line7 = UIView(frame: CGRect(x: 15, y: cerLab.frame.maxY, width: WIDTH-30, height: 1))
        line7.backgroundColor = COLOR
        rootScrollView.addSubview(line7)
        
        cer1Btn.frame = CGRect(x: 15, y: line7.frame.maxY+10, width: WIDTH-30, height: 40*(WIDTH-30)/69)
        cer1Btn.setBackgroundImage(UIImage(named: "个人日常生活照"), for: UIControlState())
        cer1Btn.addTarget(self, action: #selector(cerBtnClick), for: .touchUpInside)
        rootScrollView.addSubview(cer1Btn)
        
        let cerTagLab = UILabel(frame: CGRect(x: 15, y: cer1Btn.frame.maxY+5, width: WIDTH-30, height: 20))
        cerTagLab.font = UIFont.systemFont(ofSize: 14)
        cerTagLab.adjustsFontSizeToFitWidth = true
        cerTagLab.textAlignment = .center
        cerTagLab.textColor = UIColor.lightGray
        cerTagLab.text = "个人日常生活照"
        rootScrollView.addSubview(cerTagLab)
        
        cer2Btn.frame = CGRect(x: 15, y: cerTagLab.frame.maxY+10, width: WIDTH-30, height: 40*(WIDTH-30)/69)
        //        cerBtn.backgroundColor = UIColor.lightGray
        cer2Btn.setBackgroundImage(UIImage(named: "手持身份证照"), for: UIControlState())
        cer2Btn.addTarget(self, action: #selector(cerBtnClick), for: .touchUpInside)
        rootScrollView.addSubview(cer2Btn)
        
        let cerTag2Lab = UILabel(frame: CGRect(x: 15, y: cer2Btn.frame.maxY+5, width: WIDTH-30, height: 20))
        cerTag2Lab.font = UIFont.systemFont(ofSize: 14)
        cerTag2Lab.adjustsFontSizeToFitWidth = true
        cerTag2Lab.textAlignment = .center
        cerTag2Lab.textColor = UIColor.lightGray
        cerTag2Lab.text = "手持身份证照"
        rootScrollView.addSubview(cerTag2Lab)

        
        let applyBtn = UIButton(frame: CGRect(x: 20, y: cerTag2Lab.frame.maxY+20, width: WIDTH-40, height: 44))
        applyBtn.layer.cornerRadius = 22
        applyBtn.layer.borderColor = COLOR.cgColor
        applyBtn.layer.borderWidth = 1
        applyBtn.setImage(UIImage(named: "发布"), for: UIControlState())
        applyBtn.setTitleColor(COLOR, for: UIControlState())
        applyBtn.setTitle("提交申请", for: UIControlState())
        applyBtn.addTarget(self, action: #selector(applyBtnClick), for: .touchUpInside)
        rootScrollView.addSubview(applyBtn)
        
        rootScrollView.contentSize.height = applyBtn.frame.maxY+20
        
    }
    
    // MARK: - cerBtn click
    func cerBtnClick(cerBtn:UIButton) {
        
        if cerBtn == cer1Btn {
            self.selectedImage = "0"
        }else if cerBtn == cer2Btn {
            self.selectedImage = "1"
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        self.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {(UIAlertAction) in
            DispatchQueue.main.async(execute: {
                self.takePhoto()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "从相册获取", style: .default, handler: { (UIAlertAction) in
            DispatchQueue.main.async(execute: {
                self.LocalPhoto()
            })
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        
    }
    
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.present(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type = info[UIImagePickerControllerMediaType] as! String
        if type != "public.image" {
            return
        }
        
        //裁剪后图片
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        switch self.selectedImage {
        case "0":
            self.selected1Image = image
            cer1Btn.setImage(image, for: UIControlState())
        case "1":
            self.selected2Image = image
            cer2Btn.setImage(image, for: UIControlState())
        default:
            break
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - applyBtn Click
    func applyBtnClick() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        
        hud.mode = .text
        hud.label.text = "尚未完成"
        hud.hide(animated: true, afterDelay: 1)
        return
        
        if (self.circleNameInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请填写圈子名称"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.userNameInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入真实姓名"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.idInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入身份证号"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.addressInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入联系地址"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.telInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入手机号码"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.qqInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入QQ号码"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (self.testimonialsInput.text?.isEmpty)! {
            hud.mode = .text
            hud.label.text = "请输入申请感言"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if self.selected1Image == nil {
            hud.mode = .text
            hud.label.text = "请选择个人日常生活照"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if self.selected2Image == nil {
            hud.mode = .text
            hud.label.text = "请选择手持身份证照"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else{
            
            hud.label.text = "正在上传个人日常生活照"
            
            let data = UIImageJPEGRepresentation(self.selected1Image!, 0.1)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
            let dateStr = dateFormatter.string(from: Date())
            let imageName1 = "master" + dateStr + QCLoginUserInfo.currentInfo.userid
            
            ConnectModel.upload(withImageName: imageName1, imageData: data, url: "\(PARK_URL_Header)uploadavatar") { (data) in
                
                DispatchQueue.main.async(execute: {
                    let result = Http(JSONDecoder(data as AnyObject))
                    if result.status != nil {
                        if result.status! == "success"{
                            
                            hud.label.text = "正在上传手持身份证照"
                            
                            let data = UIImageJPEGRepresentation(self.selected1Image!, 0.1)!
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
                            let dateStr = dateFormatter.string(from: Date())
                            let imageName2 = "master" + dateStr + QCLoginUserInfo.currentInfo.userid
                            
                            ConnectModel.upload(withImageName: imageName2, imageData: data, url: "\(PARK_URL_Header)uploadavatar") { (data) in
                                
                                DispatchQueue.main.async(execute: {
                                    let result = Http(JSONDecoder(data as AnyObject))
                                    if result.status != nil {
                                        if result.status! == "success"{
                                            
                                            hud.label.text = "正在上传资料"
                                            
                                            CircleNetUtil.apply_community(c_name: self.circleNameInput.text!, userid: QCLoginUserInfo.currentInfo.userid, real_name: self.userNameInput.text!, real_code: self.idInput.text!, real_address: self.addressInput.text!, real_tel: self.telInput.text!, real_qq: self.qqInput.text!, real_content: self.testimonialsInput.text!, real_photo: imageName1, real_photo_2: imageName2, handle: { (success, response) in
                                                if success {
                                                    let str = response as! String
                                                    if str == "success" {
                                                        hud.mode = .text
                                                        hud.label.text = "资料上传成功"
                                                        hud.hide(animated: true, afterDelay: 1)
                                                    }else{
                                                        hud.mode = .text
                                                        hud.label.text = "您已申请过"
                                                        hud.hide(animated: true, afterDelay: 1)
                                                    }
                
                                                    let time: TimeInterval = 1.0
                                                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                                                    DispatchQueue.main.asyncAfter(deadline: delay) {
                                                        _ = self.navigationController?.popViewController(animated: true)
                                                    }
                
                                                }else{
                                                    hud.mode = .text
                                                    hud.label.text = "资料上传失败"
                                                    hud.hide(animated: true, afterDelay: 1)
                                                }
                                            })
                                            
                                        }else{
                                            hud.hide(animated: true)
                                            
                                            let alertController = UIAlertController(title: "图片上传失败", message: "", preferredStyle: .alert)
                                            self.present(alertController, animated: true, completion: nil)
                                            
                                            let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                                                self.applyBtnClick()
                                            })
                                            alertController.addAction(replyAction)
                                            
                                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                            alertController.addAction(cancelAction)
                                        }
                                        
                                    }
                                })
                            }
                            
                        }else{
                            hud.hide(animated: true)
                            
                            let alertController = UIAlertController(title: "图片上传失败", message: "", preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                            
                            let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                                self.applyBtnClick()
                            })
                            alertController.addAction(replyAction)
                            
                            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                            alertController.addAction(cancelAction)
                        }
                        
                    }
                })
            }
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
