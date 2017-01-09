//
//  NSCircleAuthViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class NSCircleAuthViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    let authTypeDropDown = DropDown()
    
    let placeInput = UITextField()
    
    let officeInput = UITextField()
    
    var selectedImage:UIImage?

    let cerBtn = UIButton()
    
    var auth_type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setSubviews()
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        
        self.title = "认证"
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        let rootScrollView = TPKeyboardAvoidingScrollView(frame: CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65))
        
        self.view.addSubview(rootScrollView)
        
        let inputBgView = UIView(frame: CGRect(x: 15, y: 15, width: WIDTH-30, height: 0))
        inputBgView.layer.borderColor = UIColor.lightGray.cgColor
        inputBgView.layer.borderWidth = 1/UIScreen.main.scale
        rootScrollView.addSubview(inputBgView)
        
        // 认证类型
        let typeLab = UILabel(frame: CGRect(x: 0, y: 0, width: inputBgView.frame.width*0.275, height: 44))
        typeLab.textAlignment = .center
        typeLab.font = UIFont.systemFont(ofSize: 16)
        typeLab.adjustsFontSizeToFitWidth = true
        typeLab.text = "认证类型"
        inputBgView.addSubview(typeLab)
        
        let typeLine = UIView(frame: CGRect(x: typeLab.frame.maxX, y: typeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: typeLab.frame.height-10))
        typeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(typeLine)
        
        let typeBtn = ImageBtn(frame: CGRect(x: typeLine.frame.maxX+15, y: 0, width: inputBgView.frame.width-(typeLine.frame.maxX+20), height: 44))
        typeBtn?.lb_title.font = UIFont.systemFont(ofSize: 14)
        typeBtn?.lb_title.adjustsFontSizeToFitWidth = true
        typeBtn?.lb_title_fontSize  = 14
        typeBtn?.lb_titleColor = UIColor.lightGray
        typeBtn?.lb_title.textAlignment = .left
        typeBtn?.resetdata("请选择认证类型", UIImage(named: "认证类型下拉"))
        typeBtn?.addTarget(self, action: #selector(typeBtnClick), for: .touchUpInside)
        inputBgView.addSubview(typeBtn!)
        
        // 学历
        authTypeDropDown.anchorView = typeBtn
        
        authTypeDropDown.bottomOffset = CGPoint(x: 0, y: (typeBtn?.bounds.height ?? 0)!)
        authTypeDropDown.width = 200
        authTypeDropDown.direction = .bottom
        
        authTypeDropDown.dataSource = ["在校生","应届生","护士","护师","主管护师","护士长","主任"]
        
        // 下拉列表选中后的回调方法
        authTypeDropDown.selectionAction = {(index, item) in
            
            typeBtn?.lb_titleColor = UIColor.black
            typeBtn?.resetdata(item, UIImage(named: "认证类型下拉"))
            
            self.auth_type = item
            
        }
        
        let line1 = UIView(frame: CGRect(x: 0, y: typeLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line1.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line1)
        
        // 工作单位
        let placeLab = UILabel(frame: CGRect(x: 0, y: line1.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        placeLab.textAlignment = .center
        placeLab.font = UIFont.systemFont(ofSize: 16)
        placeLab.adjustsFontSizeToFitWidth = true
        placeLab.text = "工作单位"
        inputBgView.addSubview(placeLab)
        
        let placeLine = UIView(frame: CGRect(x: placeLab.frame.maxX, y: placeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: placeLab.frame.height-10))
        placeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(placeLine)
        
        placeInput.frame = CGRect(x: placeLine.frame.maxX+20, y: line1.frame.maxY, width: inputBgView.frame.width-(placeLine.frame.maxX+20), height: 44)
        placeInput.font = UIFont.systemFont(ofSize: 14)
        placeInput.adjustsFontSizeToFitWidth = true
        placeInput.textAlignment = .left
        placeInput.placeholder = "请填写您的工作单位"
        inputBgView.addSubview(placeInput)
        
        let line2 = UIView(frame: CGRect(x: 0, y: placeLab.frame.maxY, width: inputBgView.frame.width, height: 1/UIScreen.main.scale))
        line2.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(line2)
        
        // 工作科室
        let officeLab = UILabel(frame: CGRect(x: 0, y: line2.frame.maxY, width: inputBgView.frame.width*0.275, height: 44))
        officeLab.textAlignment = .center
        officeLab.font = UIFont.systemFont(ofSize: 16)
        officeLab.adjustsFontSizeToFitWidth = true
        officeLab.text = "工作科室"
        inputBgView.addSubview(officeLab)
        
        let officeLine = UIView(frame: CGRect(x: officeLab.frame.maxX, y: officeLab.frame.minY+5, width: 1/UIScreen.main.scale, height: officeLab.frame.height-10))
        officeLine.backgroundColor = UIColor.lightGray
        inputBgView.addSubview(officeLine)
        
        officeInput.frame = CGRect(x: officeLine.frame.maxX+20, y: line2.frame.maxY, width: inputBgView.frame.width-(officeLine.frame.maxX+20), height: 44)
        officeInput.font = UIFont.systemFont(ofSize: 14)
        officeInput.adjustsFontSizeToFitWidth = true
        officeInput.textAlignment = .left
        officeInput.placeholder = "请填写您的工作科室"
        inputBgView.addSubview(officeInput)
        
        inputBgView.frame.size.height = officeLab.frame.maxY
        
        // 相关证件
        let cerLab = UILabel(frame: CGRect(x: 15, y: inputBgView.frame.maxY+20, width: WIDTH-30, height: 20))
        cerLab.font = UIFont.systemFont(ofSize: 14)
        cerLab.adjustsFontSizeToFitWidth = true
        cerLab.textAlignment = .left
        cerLab.textColor = COLOR
        cerLab.text = "相关证件"
        rootScrollView.addSubview(cerLab)
        
        let line3 = UIView(frame: CGRect(x: 15, y: cerLab.frame.maxY, width: WIDTH-30, height: 1))
        line3.backgroundColor = COLOR
        rootScrollView.addSubview(line3)
        
        cerBtn.frame = CGRect(x: 15, y: line3.frame.maxY+10, width: WIDTH-30, height: 40*(WIDTH-30)/69)
//        cerBtn.backgroundColor = UIColor.lightGray
        cerBtn.setBackgroundImage(UIImage(named: "相关证件"), for: UIControlState())
        cerBtn.addTarget(self, action: #selector(cerBtnClick), for: .touchUpInside)
        rootScrollView.addSubview(cerBtn)
        
        let cerTagLab = UILabel(frame: CGRect(x: 15, y: cerBtn.frame.maxY+5, width: WIDTH-30, height: 20))
        cerTagLab.font = UIFont.systemFont(ofSize: 14)
        cerTagLab.adjustsFontSizeToFitWidth = true
        cerTagLab.textAlignment = .center
        cerTagLab.textColor = UIColor.lightGray
        cerTagLab.text = "相关证件"
        rootScrollView.addSubview(cerTagLab)
        
        
        // 相关说明
        let instructionTagLab = UILabel(frame: CGRect(x: 15, y: cerBtn.frame.maxY+20, width: WIDTH-30, height: 20))
        instructionTagLab.font = UIFont.systemFont(ofSize: 14)
        instructionTagLab.adjustsFontSizeToFitWidth = true
        instructionTagLab.textAlignment = .left
        instructionTagLab.textColor = UIColor.gray
        instructionTagLab.text = "相关说明"
        rootScrollView.addSubview(instructionTagLab)
        
        let line4 = UIView(frame: CGRect(x: 15, y: instructionTagLab.frame.maxY, width: WIDTH-30, height: 1))
        line4.backgroundColor = UIColor.gray
        rootScrollView.addSubview(line4)
        
        let instructionStr = "1、认证类型直接关系到你的认证等级，以及显示的样式哦；认证类型包含：在校生、应届生、护士、护师、主管护师、护士长、主任；\n2、如果您在职，请填写工作单位和工作科室，如果是学生可不填；\n3、上传证件：\n\t1）、在校生，请上传学生证；\n\t2）、应届生，请上传毕业证；\n\t3）、护士，请上传护士证；\n\t4）、护师，请上传护师证；\n\t5）、主管护师，请上传主管护师证；\n\t6）、护士长，请上传护士长工作证；\n\t7）、主任，请上传主任工作证；\n4、如果认证类型选择了在校生，则请上传 在校生 对应的证件即可；如上传证件和认证类型不相符，则审核不通过。"
        let instructionLab = UILabel(frame: CGRect(x: 15, y: line4.frame.maxY+10, width: WIDTH-30, height: calculateHeight(instructionStr, size: 14, width: WIDTH-30)+10))
        instructionLab.numberOfLines = 0
        instructionLab.font = UIFont.systemFont(ofSize: 14)
        instructionLab.textAlignment = .left
        instructionLab.textColor = UIColor.gray
        instructionLab.text = instructionStr
        rootScrollView.addSubview(instructionLab)
        
        let applyBtn = UIButton(frame: CGRect(x: 20, y: instructionLab.frame.maxY, width: WIDTH-40, height: 44))
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
    func cerBtnClick() {
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
        
        self.selectedImage = image
        cerBtn.setImage(image, for: UIControlState())
        
        picker.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - typeBtn Click
    func typeBtnClick() {
        _ = authTypeDropDown.show()
    }
    
    // MARK: - applyBtn Click
    func applyBtnClick() {
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        
        if self.auth_type == "" {
            hud.mode = .text
            hud.label.text = "请选择认证类型"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if self.selectedImage == nil {
            hud.mode = .text
            hud.label.text = "请选择相关证件"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else{
            
            hud.label.text = "正在上传证件"

            let data = UIImageJPEGRepresentation(self.selectedImage!, 0.1)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            let dateStr = dateFormatter.string(from: Date())
            let imageName = "auth" + dateStr + QCLoginUserInfo.currentInfo.userid
            
            ConnectModel.upload(withImageName: imageName, imageData: data, url: "\(PARK_URL_Header)uploadavatar") { (data) in
                
                DispatchQueue.main.async(execute: {
                    let result = Http(JSONDecoder(data as AnyObject))
                    if result.status != nil {
                        if result.status! == "success"{
                            
                            hud.label.text = "正在上传认证资料"

                            CircleNetUtil.authentication_person(userid: QCLoginUserInfo.currentInfo.userid, auth_type: self.auth_type, auth_company: self.placeInput.text!, auth_department: self.officeInput.text!, photo: imageName+".png", handle: { (success, response) in
                                if success {
                                    let str = response as! String
                                    if str == "ok" {
                                        hud.mode = .text
                                        hud.label.text = "认证资料上传成功"
                                        hud.hide(animated: true, afterDelay: 1)
                                    }else{
                                        hud.mode = .text
                                        hud.label.text = "您已提交过认证"
                                        hud.hide(animated: true, afterDelay: 1)
                                    }
                                    
                                    let time: TimeInterval = 1.0
                                    let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                                    
                                    DispatchQueue.main.asyncAfter(deadline: delay) {
                                        _ = self.navigationController?.popViewController(animated: true)
                                    }

                                }else{
                                    hud.mode = .text
                                    hud.label.text = "认证资料上传失败"
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
