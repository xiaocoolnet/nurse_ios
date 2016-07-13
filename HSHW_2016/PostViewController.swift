//
//  PostViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class PostViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    let titLab = UITextField()
    let textContent = UITextView()
    let textLab = UILabel()
    let bottom = UIView()
    let roomKind = UIButton(type:.Custom)
    let addImg = UIButton(type: .Custom)
    var collectImageView:UICollectionView?
    var selectImages = Array<UIImage>()
    var imageNames = Array<String>()
    let helper = HSNurseStationHelper()
    var picurl = ""
    var columnDatas:Array<ForumTypeModel>?
    var selectTypeModel:ForumTypeModel?
    override func viewWillAppear(animated: Bool) {
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let rightBtn = UIBarButtonItem(title: "发布", style: .Done, target: self, action: #selector(self.takeUpTheTest))
        navigationItem.rightBarButtonItem = rightBtn
        
        self.accessibilityFrame = CGRectMake(0, 0, WIDTH, WIDTH)
        
        let linel = UILabel(frame: CGRectMake(10, 59.5, WIDTH-20, 0.5))
        linel.backgroundColor = GREY
        self.view.addSubview(linel)
        
        titLab.frame = CGRectMake(12, 10, WIDTH-24, 40)
        titLab.font = UIFont.systemFontOfSize(18)
        titLab.placeholder = "我只是个标题（必填）"
        titLab.delegate = self
        self.view.addSubview(titLab)
        
        textContent.frame = CGRectMake(8, 70, WIDTH-16, 80)
        textContent.delegate = self
        textContent.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(textContent)
        
        let contLine = UIView(frame: CGRectMake(0,165,WIDTH,1))
        contLine.backgroundColor = UIColor.blackColor()
        view.addSubview(contLine)
        
        collectImageView = UICollectionView(frame: CGRectMake(0, 170, WIDTH, 60), collectionViewLayout: UICollectionViewFlowLayout())
        collectImageView!.registerNib(UINib(nibName:"HSImageCollectionCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectImageView?.dataSource = self
        collectImageView?.delegate = self
        collectImageView?.backgroundColor = UIColor.whiteColor()
        view.addSubview(collectImageView!)
        
        textLab.frame = CGRectMake(12, 78, 50, 20)
        textLab.textColor = UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        textLab.font = UIFont.systemFontOfSize(14)
        textLab.text = "我只是个正文（不少于五个字）"
        textLab.sizeToFit()
        self.view.addSubview(textLab)
        
        bottom.frame = CGRectMake(0, HEIGHT-114, WIDTH, 50)
        bottom.backgroundColor = UIColor(red: 244/255.0, green: 229/255.0, blue: 240/255.0, alpha: 1.0)
        self.view.addSubview(bottom)
        
        let selector = UILabel(frame: CGRectMake(15, 15, 70, 20))
        selector.font = UIFont.systemFontOfSize(16)
        selector.textColor = COLOR
        selector.text = "选择栏目"
        bottom.addSubview(selector)
        let jiantou = UIImageView(frame: CGRectMake(WIDTH-17, 19, 7, 12))
        jiantou.image = UIImage(named: "ic_arrow_purple.png")
        bottom.addSubview(jiantou)
        roomKind.frame = CGRectMake(WIDTH-68, 10, 51, 30)
        roomKind.setTitle("请选择", forState: .Normal)
        roomKind.titleLabel?.font = UIFont.systemFontOfSize(16)
        roomKind.setTitleColor(COLOR, forState: .Normal)
        roomKind.addTarget(self, action: #selector(self.selectorTheRoom), forControlEvents: .TouchUpInside)
        bottom.addSubview(roomKind)
        
        addImg.frame = CGRectMake(WIDTH-WIDTH*70/375-10, HEIGHT-WIDTH*70/375-124, WIDTH*70/375, WIDTH*70/375)
        addImg.setBackgroundImage(UIImage(named: "img_bg_nor.png"), forState: .Normal)
        addImg.contentVerticalAlignment = .Bottom
        addImg.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 8, 0)
        addImg.setTitle("插入图片", forState: .Normal)
        addImg.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        addImg.titleLabel?.font = UIFont.systemFontOfSize(14)
        addImg.addTarget(self, action: #selector(self.addTheImage), forControlEvents: .TouchUpInside)
        self.view.addSubview(addImg)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyBoardChangFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)

        // Do any additional setup after loading the view.
    }
    
    func addTheImage() {
        print("添加图片")
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
        let image = info[UIImagePickerControllerEditedImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.stringFromDate(NSDate())
        let imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
        
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "http://nurse.xiaocool.net/index.php?g=apps&m=index&a=uploadavatar") {  (data) in
            dispatch_async(dispatch_get_main_queue(), { [unowned self] in
                let result = Http(JSONDecoder(data))
                if result.status != nil {
                        if result.status! == "success"{
                            self.selectImages.append(image)
                            self.imageNames.append(imageName)
                            self.collectImageView?.reloadData()
                        }else{
                            let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            hud.mode = MBProgressHUDMode.Text;
                            hud.labelText = "图片上传失败"
                            hud.margin = 10.0
                            hud.removeFromSuperViewOnHide = true
                            hud.hide(true, afterDelay: 1)
                        }
                }
            })
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }

    func textViewDidChange(textView: UITextView) {
        if textView.text.isEmpty {
            textLab.hidden = false
        }else{
            textLab.hidden = true
        }
    }
    //MARK:---collectionAbout----
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    //设置每个分区元素个数
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  selectImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HSImageCollectionCell
        cell.imageView.image = selectImages[indexPath.row]
        return cell
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return CGSizeMake(50, 50)
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(4, 4, 4, 4);
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        imageNames.removeAtIndex(indexPath.row)
        selectImages.removeAtIndex(indexPath.row)
        collectionView.reloadData()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        titLab.resignFirstResponder()
        textContent.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func keyBoardChangFrame(info:NSNotification) {
        let infoDic = info.userInfo
        let keyBoardRect = infoDic!["UIKeyboardFrameEndUserInfoKey"]?.CGRectValue()
        let keyBoardTranslate = CGFloat((keyBoardRect?.origin.y)!-114)
        
        UIView.animateWithDuration((infoDic!["UIKeyboardAnimationCurveUserInfoKey"]?.doubleValue)!, delay: 0.2, options: .TransitionNone, animations: {
            self.bottom.frame = CGRectMake(0, keyBoardTranslate, WIDTH, 50)
            self.textContent.frame = CGRectMake(8, 70, WIDTH-16, keyBoardTranslate-WIDTH*70/375-90)
            self.addImg.frame = CGRectMake(WIDTH-WIDTH*70/375-10, keyBoardTranslate-WIDTH*70/375-10, WIDTH*70/375, WIDTH*70/375)
            }, completion: nil)
    }
    
    func takeUpTheTest() {
        print("提交")
        titLab.resignFirstResponder()
        textContent.resignFirstResponder()
        
        if (textContent.text!.isEmpty||textContent.text?.characters.count <= 2)
        {
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("字数太少，请继续编辑？", comment: "empty message"), preferredStyle: .Alert)
            let doneAction = UIAlertAction(title: "确定", style: .Cancel, handler: nil)
            alertController.addAction(doneAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if titLab.text!.isEmpty {
            return
        }
        if selectTypeModel == nil {
            return
        }
        picurl = NSArray(array: imageNames).componentsJoinedByString(",")
        helper.postForumCard(selectTypeModel!.term_id, title: titLab.text!, content: textContent.text, picurl: picurl, handle: { (success, response) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                    hud.mode = MBProgressHUDMode.Text
                    hud.labelText = "发布成功"
                    hud.margin = 10.0
                    hud.removeFromSuperViewOnHide = true
                    hud.hide(true, afterDelay: 1)
                })
            }
        })
        
    }
    
    func selectorTheRoom() {
        helper.getBBSTypeData { (success, response) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.columnDatas = response as? Array<ForumTypeModel>
                    var names = Array<String>()
                    for model in self.columnDatas! {
                        names.append(model.name)
                    }
                    if !names.isEmpty {
                        let vc = HSSelectController()
                        vc.setSelectHandleWith({ [unowned self] (index) in
                            dispatch_async(dispatch_get_main_queue(), {
                                self.roomKind.setTitle(self.columnDatas![index].name, forState: .Normal)
                                self.selectTypeModel = self.columnDatas![index]
                            })
                        })
                        vc.setDataSource(names)
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                })
            }
        }
    }
}
