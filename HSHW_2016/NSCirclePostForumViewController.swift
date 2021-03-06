//
//  NSCirclePostForumViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

import CoreLocation

import TZImagePickerController

class NSCirclePostForumViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ChooseCircleDelegate, CircleImagePreviewDelegate, CLLocationManagerDelegate, BMKGeoCodeSearchDelegate, TZImagePickerControllerDelegate {

    var couldSelectedCircle = false
    
    // 选择图片、圈子、位置等 底图
    let toolBgView = UIView()
    // 标题
    let titleTextField = UIPlaceHolderTextView()
    // 内容
    let contentTextView = UIPlaceHolderTextView()
    
    // 图片
    var imageArray = [UIImage]()
    
    var selectedCircle:PublishCommunityDataCommunityModel?
    
    var locationManager:CLLocationManager!
    
    let addresssLab = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSubviews()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        findMe()
        
    }
    
    func findMe() {
        
        /** 由于IOS8中定位的授权机制改变 需要进行手动授权
         * 获取授权认证，两个方法：
         * [self.locationManager requestWhenInUseAuthorization];
         * [self.locationManager requestAlwaysAuthorization];
         */
        if self.locationManager.responds(to: #selector(self.locationManager.requestAlwaysAuthorization)) {
            self.locationManager.requestAlwaysAuthorization()
        }

        //开始定位，不断调用其代理方法
        self.locationManager.startUpdatingLocation()
        print("start gps")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 1.获取用户位置的对象
        let location = locations.last
        let coordinate = location?.coordinate
        print("纬度: \(coordinate?.latitude) 经度: \(coordinate?.longitude)");
        
        let searcher = BMKGeoCodeSearch()
        searcher.delegate = self
        let reverseGeoCodeSearchOption = BMKReverseGeoCodeOption()
        reverseGeoCodeSearchOption.reverseGeoPoint = coordinate!
        
        let flag = searcher.reverseGeoCode(reverseGeoCodeSearchOption)
        if flag {
            print("反geo检索发送成功")
        }else{
            print("反geo检索发送失败")
        }
        
        
        // 2.停止定位
        manager.stopUpdatingLocation()
    }
    
    // MARK: - 实现Deleage处理回调结果
    //接收反向地理编码结果
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error == BMK_SEARCH_NO_ERROR {
            print(result.address)
            if result.addressDetail.province == nil || result.addressDetail.province == "" {
                addresssLab.text = result.addressDetail.city+"-"+result.addressDetail.city
            }else{
                addresssLab.text = result.addressDetail.province+"-"+result.addressDetail.city
            }

        }else{
            print("抱歉，未找到结果")
            
            addresssLab.text = "定位失败，点击重试"

        }
    }

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
        
        addresssLab.text = "定位失败，点击重试"

        print("定位失败")
//        if error.code == kCLErrorDenied {
//            // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
//        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.title = "发布贴子"
        
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "发布"), style: .done, target: self, action: #selector(postBtnClick))
        
        let line1 = UIView(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line1.backgroundColor = COLOR
        self.view.addSubview(line1)
        
        // 标题
        titleTextField.frame = CGRect(x: 8, y: 1, width: WIDTH-16, height: 44)
        titleTextField.tag = 101
        titleTextField.font = UIFont.systemFont(ofSize: 14)
        titleTextField.placeholder = "请填写标题"
        titleTextField.placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        titleTextField.delegate = self
        self.view.addSubview(titleTextField)
        
        let deadSpace:CGFloat = (titleTextField.bounds.size.height - titleTextField.contentSize.height);
        let inset:CGFloat = max(0, deadSpace/2)
        titleTextField.contentInset = UIEdgeInsetsMake(inset, titleTextField.contentInset.left, inset, titleTextField.contentInset.right)
   
        let line2 = UIView(frame: CGRect(x: 0, y: titleTextField.frame.maxY, width: WIDTH, height: 1/UIScreen.main.scale))
        line2.backgroundColor = UIColor.lightGray
        self.view.addSubview(line2)
        
        setToolView()
        
        // 内容
        contentTextView.frame = CGRect(x: 8, y: line2.frame.maxY, width: WIDTH-16, height: toolBgView.frame.minY-line2.frame.maxY)
        contentTextView.tag = 102
        contentTextView.font = UIFont.systemFont(ofSize: 14)
        contentTextView.placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        contentTextView.placeholder = "对圈子内的朋友说点什么吧"
        contentTextView.delegate = self
        self.view.addSubview(contentTextView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setToolView() {
        
        // 选择图片、圈子、位置等 底图
        for subView in toolBgView.subviews {
            subView.removeFromSuperview()
        }
        
        toolBgView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 0)
        self.view.addSubview(toolBgView)
        
        var imageX:CGFloat = 8
        var imageY:CGFloat = 10
        
        for (i,image) in imageArray.enumerated() {
            // 图片
            let imageBtn = UIButton(frame: CGRect(x: imageX, y: imageY, width: 76, height: 60))
            imageBtn.tag = 100+i
            imageBtn.addTarget(self, action: #selector(imageBtnClick(imageBtn:)), for: .touchUpInside)
            imageBtn.setImage(image, for: .normal)
            toolBgView.addSubview(imageBtn)
            
            imageX = imageBtn.frame.maxX+8
            
            if WIDTH-imageBtn.frame.maxX-10-76-10 < 0 {
                imageY = imageY+60+8
                imageX = 8
            }
        }
        
        if imageArray.count < 9 {
            
            // 图片
            let imageBtn = UIButton(frame: CGRect(x: imageX, y: imageY, width: 76, height: 60))
            imageBtn.setImage(UIImage(named: "插入图片"), for: UIControlState())
            imageBtn.addTarget(self, action: #selector(insertImageBtnClick), for: .touchUpInside)
            toolBgView.addSubview(imageBtn)
        }
        
        // line3
        let line3 = UIView(frame: CGRect(x: 0, y: imageY+60+10, width: WIDTH, height: 1/UIScreen.main.scale))
        line3.backgroundColor = UIColor.lightGray
        toolBgView.addSubview(line3)
        
        // 选择圈子
        let chooseCircleBtn = UIButton(frame: CGRect(x: 0, y: line3.frame.maxY, width: WIDTH, height: 40))
        chooseCircleBtn.addTarget(self, action: #selector(chooseCircleBtnClick), for: .touchUpInside)
        toolBgView.addSubview(chooseCircleBtn)
        
        let chooseCircleImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        chooseCircleImg.contentMode = .scaleAspectFit
        chooseCircleImg.clipsToBounds = true
        chooseCircleImg.image = UIImage(named: "选择圈子2")
        chooseCircleBtn.addSubview(chooseCircleImg)
        
        let chooseCircleLab = UILabel(frame: CGRect(x: chooseCircleImg.frame.maxX+8, y: 0, width: WIDTH-(chooseCircleImg.frame.maxX+8)-38, height: 40))
        chooseCircleLab.text = self.selectedCircle == nil ? "选择圈子":self.selectedCircle?.community_name
        chooseCircleBtn.addSubview(chooseCircleLab)
        
        // line4
        let line4 = UIView(frame: CGRect(x: chooseCircleLab.frame.minX, y: chooseCircleBtn.frame.maxY, width: WIDTH-chooseCircleLab.frame.minX, height: 1/UIScreen.main.scale))
        line4.backgroundColor = UIColor.lightGray
        toolBgView.addSubview(line4)
        
        // 所在位置
        let addressBtn = UIButton(frame: CGRect(x: 0, y: line4.frame.maxY, width: WIDTH, height: 40))
        addressBtn.addTarget(self, action: #selector(addressBtnClick), for: .touchUpInside)
        toolBgView.addSubview(addressBtn)
        
        let addressImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        addressImg.contentMode = .scaleAspectFit
        addressImg.clipsToBounds = true
        addressImg.image = UIImage(named: "所在位置")
        addressBtn.addSubview(addressImg)
        
        addresssLab.frame = CGRect(x: addressImg.frame.maxX+8, y: 0, width: WIDTH-(addressImg.frame.maxX+8)-38, height: 40)
        if addresssLab.text == nil || addresssLab.text == "" {
            addresssLab.text = "正在获取位置..."
        }else{
            addresssLab.text = addresssLab.text
        }
        addressBtn.addSubview(addresssLab)
        
        // line5
        let line5 = UIView(frame: CGRect(x: 0, y: addressBtn.frame.maxY, width: WIDTH, height: 1/UIScreen.main.scale))
        line5.backgroundColor = UIColor.lightGray
        toolBgView.addSubview(line5)
        
        toolBgView.frame.size.height = line5.frame.maxY
        toolBgView.frame.origin.y = HEIGHT-65-toolBgView.frame.size.height
        
        contentTextView.frame.size.height = toolBgView.frame.minY-contentTextView.frame.minY
    }
    
    // MARK: - UITextFieldDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" && textView.tag == 101 {//判断输入的字是否是回车，即按下return
            //在这里做你响应return键的代码
            return false//这里返回false，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        }
        return true
    }
   
    // MARK: - 获取键盘信息并改变视图
    func keyboardWillAppear(_ notification: Notification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = ((keyboardinfo as AnyObject).cgRectValue.size.height)
        
        toolBgView.frame.origin.y = HEIGHT-65-toolBgView.frame.size.height-keyboardheight
        contentTextView.frame.size.height = toolBgView.frame.minY-titleTextField.frame.maxY-1
        UIView.animate(withDuration: 0.3, animations: {
        }) 
    }
    
    func keyboardDidAppear(_ notification:Notification) {
    }
    
    func keyboardWillDisappear(_ notification:Notification){
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.toolBgView.frame.origin.y = HEIGHT-65-self.toolBgView.frame.size.height
            self.contentTextView.frame.size.height = self.toolBgView.frame.minY-self.titleTextField.frame.maxY-1
        }) 
    }
    // MARK: -
    
    // MARK: - 点击图片按钮
    func imageBtnClick(imageBtn:UIButton) {
        
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
        
        let circleImagePreviewController = NSCircleImagePreviewViewController()
        circleImagePreviewController.delegate = self
        circleImagePreviewController.imageArray = imageArray
        circleImagePreviewController.currentImageIndex = imageBtn.tag-100
        self.navigationController?.pushViewController(circleImagePreviewController, animated: true)
    }
    // MARK: - 点击插入图片按钮
    func insertImageBtnClick() {
        print("点击插入图片按钮")
        
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
        
        let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
        imagePickerVc?.oKButtonTitleColorNormal = COLOR
        imagePickerVc?.oKButtonTitleColorDisabled = UIColor.lightGray
        imagePickerVc?.sortAscendingByModificationDate = false
        
        self.present(imagePickerVc!, animated: true, completion: nil)
        
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        self.present(alert, animated: true, completion: nil)
//        
//        alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {(UIAlertAction) in
//            DispatchQueue.main.async(execute: {
//                self.takePhoto()
//            })
//        }))
//        
//        alert.addAction(UIAlertAction(title: "从相册获取", style: .default, handler: { (UIAlertAction) in
//            DispatchQueue.main.async(execute: {
//                
//                let imagePickerVc = TZImagePickerController(maxImagesCount: 9, delegate: self)
//                imagePickerVc?.oKButtonTitleColorNormal = COLOR
//                imagePickerVc?.oKButtonTitleColorDisabled = UIColor.lightGray
//                imagePickerVc?.sortAscendingByModificationDate = false
//                
//                self.present(imagePickerVc!, animated: true, completion: nil)
////                imagePickerVc?.didFinishPickingPhotosHandle
////                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
////                
////                // You can get the photos by block, the same as by delegate.
////                // 你可以通过block或者代理，来得到用户选择的照片.
////                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
////                    
////                    }];
////                [self presentViewController:imagePickerVc animated:YES completion:nil];
////                self.LocalPhoto()
//            })
//        }))
//        
//        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingPhotos photos: [UIImage]!, sourceAssets assets: [Any]!, isSelectOriginalPhoto: Bool) {
        
//        let type = info[UIImagePickerControllerMediaType] as! String
//        if type != "public.image" {
//            return
//        }
//        
//        //裁剪后图片
//        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        
        self.imageArray = photos
        self.setToolView()
        
//        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - 点击发布按钮
    func postBtnClick() {
        print("点击发布按钮")
        
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.removeFromSuperViewOnHide = true
        hud.margin = 10
        
        
        if titleTextField.text.isEmpty {
            hud.mode = .text
            hud.label.text = "请输入标题"
            hud.hide(animated: true, afterDelay: 1)
            return
        }else if (titleTextField.text?.characters.count ?? 0)! < 5 {
            
            hud.mode = .text
            hud.label.text = "标题至少5个字"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        if contentTextView.text.isEmpty {
            hud.mode = .text
            hud.label.text = "请输入内容"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        if selectedCircle == nil {
            hud.mode = .text
            hud.label.text = "请选择圈子"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        if addresssLab.text == "正在获取位置..." || addresssLab.text == "定位失败，点击重试" || addresssLab.text == "" || addresssLab.text == nil {
            hud.mode = .text
            hud.label.text = "请获取位置"
            hud.hide(animated: true, afterDelay: 1)
            return
        }
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        if imageArray.count > 0 {
            hud.label.text = "正在上传图片"
            
            var flag = 0
            
            var photoStr = ""
            
            for image in imageArray {
                
                let data = UIImageJPEGRepresentation(image, 0.1)!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmmssSSS"
                let dateStr = dateFormatter.string(from: Date())
                let imageName = "circle" + dateStr + QCLoginUserInfo.currentInfo.userid
                
                
                ConnectModel.upload(withImageName: imageName, imageData: data, url: "\(PARK_URL_Header)uploadavatar") {  (data) in
                    
                    DispatchQueue.main.async(execute: {
                        let result = Http(JSONDecoder(data as AnyObject))
                        if result.status != nil {
                            if result.status! == "success"{
                                
                                flag += 1
                                if flag == 1 {
                                    photoStr = imageName+".png"
                                }else{
                                    photoStr = photoStr+","+imageName+".png"
                                }
                                if flag >= self.imageArray.count {
                                    
                                    self.publishForum(photoStr: photoStr, andHud: hud)
                                }
                                
                                
                            }else{
                                
                                let alertController = UIAlertController(title: "图片上传失败", message: "", preferredStyle: .alert)
                                self.present(alertController, animated: true, completion: nil)
                                
                                let replyAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                                    self.postBtnClick()
                                })
                                alertController.addAction(replyAction)
                                
                                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                                alertController.addAction(cancelAction)
                            }
                            
                        }
                    })
                }
//                NurseUtil.net.uploadWithPOST(PARK_URL_Header, data: data, name: "uploadavatar", fileName: imageName, mimeType: "image/png", block: { (resultType) in
//                    if resultType == .success {
//                        flag += 1
//                        photoStr = photoStr+imageName+","
//                        if flag >= self.imageArray.count {
//                            photoStr.remove(at: photoStr.endIndex)
//                            self.publishForum(photoStr: photoStr, andHud: hud)
//                        }
//                    }
//                })
            }
        }else{
            self.publishForum(photoStr: "", andHud: hud)

        }
        
    }
    
    func publishForum(photoStr:String,andHud hud:MBProgressHUD) {
        
        hud.label.text = "正在发布贴子"
        
        CircleNetUtil.PublishForum(userid: QCLoginUserInfo.currentInfo.userid, cid: (selectedCircle?.id ?? "")!, title: titleTextField.text, content: contentTextView.text, description: contentTextView.text, photo: photoStr, address: addresssLab.text!) { (success, response) in
            if success {
                hud.mode = .text
                hud.label.text = "贴子发布成功"
                hud.hide(animated: true, afterDelay: 1)
                
                var time: TimeInterval = 1.0

                let result = response as! SetLikeDataModel
                if result.event != "" {
                    NursePublicAction.showScoreTips(self.view, nameString: result.event, score: result.score)
                    
                    time += 2
                }
                
                let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true

                    _ = self.navigationController?.popViewController(animated: true)
                }
            }else{
                hud.mode = .text
                hud.label.text = "贴子发布失败"
                hud.hide(animated: true, afterDelay: 1)
                
                let time: TimeInterval = 1.0
                
                let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: delay) {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                }

            }
            

        }
    }
    
    // MARK: - 点击选择圈子按钮
    func chooseCircleBtnClick() {
        print("点击选择圈子按钮")
        
        if couldSelectedCircle {
            let chooseCircleController = NSCirclePostChooseCircleViewController()
            chooseCircleController.delegate = self
            self.navigationController?.pushViewController(chooseCircleController, animated: true)
        }
    }
    
    func chooseCircle(circle: PublishCommunityDataCommunityModel) {
        self.selectedCircle = circle
        
        self.setToolView()
    }
    
    // MARK: - 点击发贴位置按钮
    func addressBtnClick() {
        print("点击发贴位置按钮")
        
        addresssLab.text = "正在获取位置..."
        
        findMe()

//        //初始化BMKLocationService
//        let locService = BMKLocationService()
//        locService.delegate = self
//        //启动LocationService
//        locService.startUserLocationService()
        
    }
    
    // MARK: - CircleImagePreviewDelegate
    func imageArrayChanged(imageArray: [UIImage]) {
        self.imageArray = imageArray
        self.setToolView()
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
