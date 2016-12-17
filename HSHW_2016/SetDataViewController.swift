//
//  SetDataViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

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
    var avatarView = UIButton(type: UIButtonType.custom)
    
    var picker:DatePickerView?
    var pick:AdressPickerView?
    var array = [String]()
    
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "个人资料编辑"
        array = ["北京市","北京市","朝阳区"]
        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        
        myTableView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-64-1)
        myTableView.backgroundColor = RGREY
        myTableView.delegate = self
        myTableView.dataSource = self
        
        myActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        myActionSheet?.addAction(UIAlertAction(title: "拍照", style: .default, handler: {(UIAlertAction) in
            DispatchQueue.main.async(execute: {
                self.takePhoto()
            })
        }))
        
        myActionSheet?.addAction(UIAlertAction(title: "从相册获取", style: .default, handler: { (UIAlertAction) in
            DispatchQueue.main.async(execute: {
                self.LocalPhoto()
            })
        }))
        
        myActionSheet?.addAction(UIAlertAction(title: "取消", style: .cancel, handler:nil))
        
        self.view.addSubview(myTableView)
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
        let data = UIImageJPEGRepresentation(image, 0.1)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let dateStr = dateFormatter.string(from: Date())
        let imageName = "avatar" + dateStr + QCLoginUserInfo.currentInfo.userid
        
        ConnectModel.upload(withImageName: imageName, imageData: data, url: "\(PARK_URL_Header)uploadavatar") { (data) in
            DispatchQueue.main.async(execute: {
                
                let result = Http(JSONDecoder(data as AnyObject))
                DispatchQueue.main.async(execute: {
                    if result.status != nil {
                        if result.status == "success"{
                            self.avatarView.setImage(image, for: UIControlState())
                            self.mainHelper.changeUserAvatar(imageName+".png", handle: { (success, response) in
                                if success {
                                    let respo = response as! addScore_ReadingInformationDataModel
                                    QCLoginUserInfo.currentInfo.avatar = imageName+".png"
                                    if respo.event != "" {
                                        self.showScoreTips((respo.event), score: (respo.score))
                                    }
                                }
                            })
                        }else{
                            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                            hud?.mode = MBProgressHUDMode.text;
                            hud?.labelText = "图片上传失败"
                            hud?.margin = 10.0
                            hud?.removeFromSuperViewOnHide = true
                            hud?.hide(true, afterDelay: 1)
                        }
                    }
                })

            })
        }

        myTableView.reloadData()
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: 显示积分提示
    func showScoreTips(_ name:String, score:String) {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud?.opacity = 0.3
        hud?.margin = 10
        hud?.color = UIColor(red: 145/255.0, green: 26/255.0, blue: 107/255.0, alpha: 0.3)
        hud?.mode = .customView
        let customView = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH*0.8, height: WIDTH*0.8*238/537))
        customView.image = UIImage(named: "scorePopImg.png")
        let titLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*30/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        titLab.textColor = UIColor(red: 140/255.0, green: 39/255.0, blue: 90/255.0, alpha: 1)
        titLab.textAlignment = .left
        titLab.font = UIFont.systemFont(ofSize: 16)
        titLab.text = name
        titLab.adjustsFontSizeToFitWidth = true
        customView.addSubview(titLab)
        
        let scoreLab = UILabel(frame: CGRect(
            x: customView.frame.width*351/537,
            y: customView.frame.height*100/238,
            width: customView.frame.width*174/537,
            height: customView.frame.height*50/238))
        scoreLab.textColor = UIColor(red: 252/255.0, green: 13/255.0, blue: 27/255.0, alpha: 1)
        
        scoreLab.textAlignment = .left
        scoreLab.font = UIFont.systemFont(ofSize: 24)
        scoreLab.text = "+\(score)"
        scoreLab.adjustsFontSizeToFitWidth = true
        scoreLab.sizeToFit()
        customView.addSubview(scoreLab)
        
        let jifenLab = UILabel(frame: CGRect(
            x: scoreLab.frame.maxX+5,
            y: customView.frame.height*100/238,
            width: customView.frame.width-scoreLab.frame.maxX-5-customView.frame.width*13/537,
            height: customView.frame.height*50/238))
        jifenLab.textColor = UIColor(red: 107/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1)
        jifenLab.textAlignment = .center
        jifenLab.font = UIFont.systemFont(ofSize: 16)
        jifenLab.text = "护士币"
        jifenLab.adjustsFontSizeToFitWidth = true
        jifenLab.center.y = scoreLab.center.y
        customView.addSubview(jifenLab)
        
        hud?.customView = customView
        hud?.hide(true, afterDelay: 3)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let one = UIView()
        one.backgroundColor = UIColor.clear
        return one
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }else if section == 1 {
            return 3
        }else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        if indexPath.section == 0 {
            cell.textLabel?.text = oneArr[indexPath.row]
            cell.detailTextLabel?.text = onedeArr[indexPath.row]
            if indexPath.row == 0 {

                if  !NurseUtil.net.isWifi() && loadPictureOnlyWiFi {
                    avatarView.setImage(UIImage.init(named: "img_head_nor"), for: UIControlState())
                }else{
                    avatarView.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar), for: UIControlState(), placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                avatarView.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+QCLoginUserInfo.currentInfo.avatar) , forState: .Normal)
                avatarView.frame = CGRect(x: WIDTH-86, y: 11, width: 50, height: 50)
                avatarView.layer.cornerRadius = 25
                avatarView.clipsToBounds = true
                avatarView.isUserInteractionEnabled = false
                cell.addSubview(avatarView)
            }
        }else if indexPath.section == 1 {
            cell.textLabel?.text = twoArr[indexPath.row]
            cell.detailTextLabel?.text = twodeArr[indexPath.row]
            cell.detailTextLabel?.textColor = UIColor.black
        }else{
            cell.textLabel?.text = threeArr[indexPath.row]
            cell.detailTextLabel?.text = threedeArr[indexPath.row]
        }
//        print("text == \((cell.textLabel?.text)!)   detailTextLabel == \((cell.detailTextLabel?.text)!)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let changeNameVC = ChangeName()
        changeNameVC.handle = {(type,value) in
            DispatchQueue.main.async(execute: {
                if indexPath.section == 0 {
                    self.onedeArr[indexPath.row] = value
                }else if indexPath.section == 1{
                    self.twodeArr[indexPath.row] = value
                }else if indexPath.section == 2{
                    self.threedeArr[indexPath.row] = value
                }
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            })
        }
        switch (indexPath.section,indexPath.row) {
        case (0,0):
            present(myActionSheet!, animated: true, completion:nil)
        case (0,1):
            changeNameVC.showType = .userName
            changeNameVC.title = "编辑用户名"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,2):
            changeNameVC.showType = HSEditUserInfo.sex
            changeNameVC.title = "编辑性别"
            changeNameVC.id = "17"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,3):
            changeNameVC.showType = HSEditUserInfo.phoneNumber
            changeNameVC.title = "编辑手机号"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (0,4):
            changeNameVC.showType = HSEditUserInfo.email
            changeNameVC.title = "编辑邮箱"
            changeNameVC.text1 = onedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (1,0):
            changeNameVC.showType = HSEditUserInfo.realName
            changeNameVC.title = "编辑真实姓名"
            changeNameVC.text1 = twodeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (1,1):
            changeNameVC.showType = HSEditUserInfo.birthDay
            changeNameVC.title = "编辑出生日期"
//            changeNameVC.text1 = twodeArr[indexPath.row]
            picker = DatePickerView.getShareInstance()
            picker!.textColor = UIColor.red
            picker!.num = 2
            picker!.showWithDate(Date())
            picker?.block = {
                (date:Date)->() in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd zzz"
                let string = formatter.string(from: date)
                let range:Range = string.range(of: " ")!
                let time = string.substring(to: range.upperBound)
                self.twodeArr[indexPath.row] = time
                let mineHelper = HSMineHelper()
                mineHelper.changeBirthday(time, handle: { (success, response) in
                    DispatchQueue.main.async(execute: {
                        if success {
                            QCLoginUserInfo.currentInfo.birthday = time
//                            self.navigationController?.popViewControllerAnimated(true)
                        }
                    })
                })

                self.myTableView.reloadData()
            }
        case (1,2):
            changeNameVC.showType = HSEditUserInfo.address
            changeNameVC.title = "编辑地址"
            let pick = AdressPickerView.shareInstance
            pick.showTown=true
            let tempArray = self.twodeArr[indexPath.row].components(separatedBy: "-")
            pick.pickArray = (tempArray.count==3 ? tempArray:array) as NSArray
            pick.show((UIApplication.shared.keyWindow)!)
            pick.selectAdress { (dressArray) in
                self.array=dressArray as! Array<String>
                self.twodeArr[indexPath.row] = ("\(dressArray[0])-\(dressArray[1])-\(dressArray[2])")
                let mineHelper = HSMineHelper()
                mineHelper.changeAddress(self.twodeArr[indexPath.row], handle: {(success, response) in
                    DispatchQueue.main.async(execute: {
                        if success {
                            QCLoginUserInfo.currentInfo.city = self.twodeArr[indexPath.row]
                        }
                    })
                })
                self.myTableView.reloadData()
            }
        case (2,0):
            changeNameVC.showType = HSEditUserInfo.school
            changeNameVC.title = "编辑学校"
            changeNameVC.text1 = threedeArr[indexPath.row]
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (2,1):
            changeNameVC.showType = HSEditUserInfo.major
            changeNameVC.title = "编辑专业"
//            changeNameVC.text1 = threedeArr[indexPath.row]
            changeNameVC.id = "18"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        case (2,2):
            changeNameVC.showType = HSEditUserInfo.education
            changeNameVC.title = "编辑学历"
            changeNameVC.text1 = threedeArr[indexPath.row]
            changeNameVC.id = "1"
            self.navigationController?.pushViewController(changeNameVC, animated: true)

        default:
            changeNameVC.showType = HSEditUserInfo.default
            changeNameVC.title = "默认"
            self.navigationController?.pushViewController(changeNameVC, animated: true)
        }
    }
}
