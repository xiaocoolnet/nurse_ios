//
//  NSCirclePostForumViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCirclePostForumViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    // 选择图片、圈子、位置等 底图
    let toolBgView = UIView()
    // 标题
    let titleTextField = UIPlaceHolderTextView()
    // 内容
    let contentTextView = UIPlaceHolderTextView()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSubviews()
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.title = "发布贴子"
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "发布"), style: .Done, target: self, action: #selector(postBtnClick))
        
        let line1 = UIView(frame: CGRectMake(0, 0, WIDTH, 1))
        line1.backgroundColor = COLOR
        self.view.addSubview(line1)
        
        // 标题
        titleTextField.frame = CGRect(x: 8, y: 1, width: WIDTH-16, height: 44)
        titleTextField.tag = 101
        titleTextField.font = UIFont.systemFontOfSize(14)
        titleTextField.placeholder = "请填写标题"
        titleTextField.placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        titleTextField.delegate = self
        self.view.addSubview(titleTextField)
        
        let deadSpace:CGFloat = (titleTextField.bounds.size.height - titleTextField.contentSize.height);
        let inset:CGFloat = max(0, deadSpace/2)
        titleTextField.contentInset = UIEdgeInsetsMake(inset, titleTextField.contentInset.left, inset, titleTextField.contentInset.right)
   
        let line2 = UIView(frame: CGRect(x: 0, y: titleTextField.frame.maxY, width: WIDTH, height: 1/UIScreen.mainScreen().scale))
        line2.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(line2)
        
        // 选择图片、圈子、位置等 底图
        toolBgView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 0)
        self.view.addSubview(toolBgView)
        
        // 图片
        let imageBtn = UIButton(frame: CGRect(x: 8, y: 10, width: 76, height: 60))
        imageBtn.setImage(UIImage(named: "插入图片"), forState: .Normal)
        toolBgView.addSubview(imageBtn)
        
        // line3
        let line3 = UIView(frame: CGRect(x: 0, y: imageBtn.frame.maxY+10, width: WIDTH, height: 1/UIScreen.mainScreen().scale))
        line3.backgroundColor = UIColor.lightGrayColor()
        toolBgView.addSubview(line3)
        
        // 选择圈子
        let chooseCircleBtn = UIButton(frame: CGRect(x: 0, y: line3.frame.maxY, width: WIDTH, height: 40))
        toolBgView.addSubview(chooseCircleBtn)
        
        let chooseCircleImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        chooseCircleImg.contentMode = .ScaleAspectFit
        chooseCircleImg.clipsToBounds = true
        chooseCircleImg.image = UIImage(named: "选择圈子2")
        chooseCircleBtn.addSubview(chooseCircleImg)
        
        let chooseCircleLab = UILabel(frame: CGRect(x: chooseCircleImg.frame.maxX+8, y: 0, width: WIDTH-(chooseCircleImg.frame.maxX+8)-38, height: 40))
        chooseCircleLab.text = "选择圈子"
        chooseCircleBtn.addSubview(chooseCircleLab)
        
        // line4
        let line4 = UIView(frame: CGRect(x: chooseCircleLab.frame.minX, y: chooseCircleBtn.frame.maxY, width: WIDTH-chooseCircleLab.frame.minX, height: 1/UIScreen.mainScreen().scale))
        line4.backgroundColor = UIColor.lightGrayColor()
        toolBgView.addSubview(line4)
        
        // 所在位置
        let addressBtn = UIButton(frame: CGRect(x: 0, y: line4.frame.maxY, width: WIDTH, height: 40))
        toolBgView.addSubview(addressBtn)
        
        let addressImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        addressImg.contentMode = .ScaleAspectFit
        addressImg.clipsToBounds = true
        addressImg.image = UIImage(named: "所在位置")
        addressBtn.addSubview(addressImg)
        
        let addresssLab = UILabel(frame: CGRect(x: addressImg.frame.maxX+8, y: 0, width: WIDTH-(addressImg.frame.maxX+8)-38, height: 40))
        addresssLab.text = "所在位置"
        addressBtn.addSubview(addresssLab)
        
        // line5
        let line5 = UIView(frame: CGRect(x: 0, y: addressBtn.frame.maxY, width: WIDTH, height: 1/UIScreen.mainScreen().scale))
        line5.backgroundColor = UIColor.lightGrayColor()
        toolBgView.addSubview(line5)
        
        toolBgView.frame.size.height = line5.frame.maxY
        toolBgView.frame.origin.y = HEIGHT-65-toolBgView.frame.size.height
        
        // 内容
        contentTextView.frame = CGRect(x: 8, y: line2.frame.maxY, width: WIDTH-16, height: toolBgView.frame.minY-line2.frame.maxY)
        contentTextView.font = UIFont.systemFontOfSize(14)
        contentTextView.placeholderColor = UIColor(red: 199/255.0, green: 199/255.0, blue: 199/255.0, alpha: 1)
        contentTextView.placeholder = "对圈子内的朋友说点什么吧"
        contentTextView.delegate = self
        self.view.addSubview(contentTextView)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidAppear), name: UIKeyboardDidShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name:UIKeyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UITextFieldDelegate
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        
//    }
    
    // MARK:- 获取键盘信息并改变视图
    func keyboardWillAppear(notification: NSNotification) {
        
        // 获取键盘信息
        let keyboardinfo = notification.userInfo![UIKeyboardFrameEndUserInfoKey]
        
        let keyboardheight:CGFloat = (keyboardinfo?.CGRectValue.size.height)!
        
        toolBgView.frame.origin.y = HEIGHT-65-toolBgView.frame.size.height-keyboardheight
        contentTextView.frame.size.height = toolBgView.frame.minY-titleTextField.frame.maxY-1
        UIView.animateWithDuration(0.3) {
        }
        
    }
    
    func keyboardDidAppear(notification:NSNotification) {
    }
    
    func keyboardWillDisappear(notification:NSNotification){
        UIView.animateWithDuration(0.3) {
            self.toolBgView.frame.origin.y = HEIGHT-65-self.toolBgView.frame.size.height
            self.contentTextView.frame.size.height = self.toolBgView.frame.minY-self.titleTextField.frame.maxY-1
//            self.replyView.frame = CGRectMake(0, HEIGHT-46-64, WIDTH, 46)
//            self.replyTextField.frame.size = CGSizeMake(WIDTH-90-75, 30)
//            self.comment_bottom_Btn.hidden = false
//            self.collect_bottom_Btn.hidden = false
//            self.share_bottom_Btn.hidden = false
            //            self.myTableView.frame.size.height = HEIGHT-64-1-46
        }
        // print("键盘落下")
    }
    // MARK:-
    
    func postBtnClick() {
        print("点击发布按钮")
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
