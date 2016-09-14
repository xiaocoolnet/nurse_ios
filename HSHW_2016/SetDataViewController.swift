//
//  SetDataViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

class SetDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    let myTableView = UITableView()
    var oneArr:[String] = ["头像","用户名","性别","手机","邮箱"]
    var onedeArr:[String] = ["",
                             QCLoginUserInfo.currentInfo.userName,
                             QCLoginUserInfo.currentInfo.sex == "0" ? "女":"男",
                             QCLoginUserInfo.currentInfo.phoneNumber,
                             QCLoginUserInfo.currentInfo.email]
    
    var twoArr:[String] = ["姓名","出生日期","地址"]
    var twodeArr:[String] = [QCLoginUserInfo.currentInfo.realName,
                             QCLoginUserInfo.currentInfo.birthday,
                             QCLoginUserInfo.currentInfo.address]
    
    var threeArr:[String] = ["学校","专业","学历"]
    var threedeArr:[String] = [QCLoginUserInfo.currentInfo.school,
                               QCLoginUserInfo.currentInfo.major,
                               QCLoginUserInfo.currentInfo.education]
    var mainHelper = HSMineHelper()
    var myActionSheet:UIAlertController?
    var avatarView = UIButton(type: UIButtonType.Custom)
    
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = Array<String>()
    
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .Default
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人资料编辑"
        array = ["北京市","北京市","朝阳区"]
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        myTableView.frame = CGRectMake(0, 1, WIDTH, HEIGHT-64-1)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        
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
        
        self.view.addSubview(myTableView)
    }
    
    func takePhoto(){
        
        let sourceType = UIImagePickerControllerSourceType.Camera
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            self.presentViewController(picker, animated: true, completion: nil)
        }else{
            print("无法打开相机")
        }
    }
    
    func LocalPhoto(){
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
        
        ConnectModel.uploadWithImageName(imageName, imageData: data, URL: "\(PARK_URL_Header)uploadavatar") { [unowned self] (data) in
            dispatch_async(dispatch_get_main_queue(), {
                
                let result = addScore_ReadingInformationModel(JSONDecoder(data))
                dispatch_async(dispatch_get_main_queue(), {
                    if result.status == "success"{
                        self.avatarView.setImage(image, forState: .Normal)
                        self.mainHelper.changeUserAvatar((result.data?.avatar)!, handle: { (success, response) in
                            if success {
                                QCLoginUserInfo.currentInfo.avatar = (result.data?.avatar)!
                                if result.data?.event != "" {
                                    self.showScoreTips((result.data?.event)!, score: (result.data?.score)!)
                                }
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

            })
        }

        myTableView.reloadData()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: 显示积分提示
    func showScoreTips(name:String, score:String) {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.opacity = 0.5
        hud.mode = .CustomView
        let customView = UIImageView(frame: CGRectMake(0, 0, WIDTH*0.8, WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*30/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        titLab.textColor = UIColor(red: 251/255.0, green: 148/255.0, blue: 0, alpha: 1)
        titLab.textAlignment = .Left
        titLab.font = UIFont.systemFontOfSize(24)
        titLab.text = name
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRectMake(
            CGRectGetWidth(customView.frame)*351/537,
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)*174/537,
            CGRectGetHeight(customView.frame)*50/238))
        scoreLab.textColor = UIColor(red: 253/255.0, green: 82/255.0, blue: 49/255.0, alpha: 1)
        scoreLab.textAlignment = .Left
        scoreLab.font = UIFont.systemFontOfSize(36)
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.text = "+\(score)"
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRectMake(
            CGRectGetMaxX(scoreLab.frame),
            CGRectGetHeight(customView.frame)*100/238,
            CGRectGetWidth(customView.frame)-CGRectGetMaxX(scoreLab.frame)-CGRectGetWidth(customView.frame)*13/537,
            CGRectGetHeight(customView.frame)*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .Center
        jifenLab.font = UIFont.systemFontOfSize(26)
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.text = "积分"
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud.customView = customView
        hud.hide(true, afterDelay: 3)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView()
        one.backgroundColor = UIColor.clearColor()
        return one
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 72
            }else{
                return 60
            }
        }else{
            return 60
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 3
        }else{
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.selectionStyle = .None
        cell.accessoryType = .DisclosureIndicator
        cell.textLabel?.font = UIFont.systemFontOfSize(18)
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
        if indexPath.section == 0 {
            cell.textLabel?.text = oneArr[indexPath.row]
            cell.detailTextLabel?.text = onedeArr[indexPath.row]
            if indexPath.row == 0 {
                if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                    avatarView.setImage(UIImage.init(named: "img_head_nor"), forState: .Normal)
                }else{
                    avatarView.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), forState: .Normal, placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                avatarView.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar) , forState: .Normal)
                avatarView.frame = CGRectMake(WIDTH-86, 11, 50, 50)
                avatarView.layer.cornerRadius = 25
                avatarView.clipsToBounds = true
                avatarView.userInteractionEnabled = false
                cell.addSubview(avatarView)
            }
        }else if indexPath.section == 1 {
            cell.textLabel?.text = twoArr[indexPath.row]
            cell.detailTextLabel?.text = twodeArr[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.blackColor()
        }else{
            cell.textLabel?.text = threeArr[indexPath.row]
            cell.detailTextLabel?.text = threedeArr[indexPath.row]
        }
        print("text == \((cell.textLabel?.text)!)   detailTextLabel == \((cell.detailTextLabel?.text)!)")
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let changeNameVC = ChangeName()
        changeNameVC.handle = {[unowned self] (type,value) in
            dispatch_async(dispatch_get_main_queue(), {
                if indexPath.section == 0 {
                    self.onedeArr[indexPath.row] = value
                }else if indexPath.section == 1{
                    self.twodeArr[indexPath.row] = value
                }else if indexPath.section == 2{
                    self.threedeArr[indexPath.row] = value
                }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            })
        }
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            presentViewController(myActionSheet!, animated: true, completion:nil)
        case (0,1):
            changeNameVC.showType = .UserName
            changeNameVC.title = "编辑用户名"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,2):
            changeNameVC.showType = HSEditUserInfo.Sex
            changeNameVC.title = "编辑性别"
            changeNameVC.id = "17"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,3):
            changeNameVC.showType = HSEditUserInfo.PhoneNumber
            changeNameVC.title = "编辑手机号"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,4):
            changeNameVC.showType = HSEditUserInfo.Email
            changeNameVC.title = "编辑邮箱"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (1,0):
            changeNameVC.showType = HSEditUserInfo.RealName
            changeNameVC.title = "编辑真实姓名"
            changeNameVC.text1 = twodeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (1,1):
            changeNameVC.showType = HSEditUserInfo.BirthDay
            changeNameVC.title = "编辑出生日期"
//            changeNameVC.text1 = twodeArr[indexPath.row]
            picker = DatePickerView.getShareInstance()
            picker!.textColor = UIColor.redColor()
            picker!.num = 2
            picker!.showWithDate(NSDate())
            picker?.block = {
                (date:NSDate)->() in
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd zzz"
                let string = formatter.stringFromDate(date)
                let range:Range = string.rangeOfString(" ")!
                let time = string.substringToIndex(range.endIndex)
                self.twodeArr[indexPath.row] = time
                let mineHelper = HSMineHelper()
                mineHelper.changeBirthday(time, handle: { (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            QCLoginUserInfo.currentInfo.birthday = time
//                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                })

                self.myTableView.reloadData()
            }
        case (1,2):
            changeNameVC.showType = HSEditUserInfo.Address
            changeNameVC.title = "编辑地址"
            let pick = AdressPickerView.shareInstance
            pick.showTown=true
            let tempArray = self.twodeArr[indexPath.row].componentsSeparatedByString("-")
            pick.pickArray = tempArray.count==3 ? tempArray:array
            pick.show((UIApplication.sharedApplication().keyWindow)!)
            pick.selectAdress { (dressArray) in
                self.array=dressArray as! Array<String>
                self.twodeArr[indexPath.row] = ("\(dressArray[0])-\(dressArray[1])-\(dressArray[2])")
                let mineHelper = HSMineHelper()
                mineHelper.changeAddress(self.twodeArr[indexPath.row], handle: { [unowned self] (success, response) in
                    dispatch_async(dispatch_get_main_queue(), {
                        if success {
                            QCLoginUserInfo.currentInfo.city = self.twodeArr[indexPath.row]
                        }
                    })
                })
                self.myTableView.reloadData()
            }
        case (2,0):
            changeNameVC.showType = HSEditUserInfo.School
            changeNameVC.title = "编辑学校"
            changeNameVC.text1 = threedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (2,1):
            changeNameVC.showType = HSEditUserInfo.Major
            changeNameVC.title = "编辑专业"
//            changeNameVC.text1 = threedeArr[indexPath.row]
            changeNameVC.id = "18"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (2,2):
            changeNameVC.showType = HSEditUserInfo.Education
            changeNameVC.title = "编辑学历"
            changeNameVC.text1 = threedeArr[indexPath.row]
            changeNameVC.id = "1"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        default:
            changeNameVC.showType = HSEditUserInfo.Default
            changeNameVC.title = "默认"
            self.navigationController?.pushViewController(changeNameVC, animated: true)
        }
    }
}
