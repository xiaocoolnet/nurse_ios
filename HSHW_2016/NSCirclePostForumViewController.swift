//
//  NSCirclePostForumViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/16.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class NSCirclePostForumViewController: UIViewController, UITextViewDelegate {

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
        
        // 选择图片、圈子、位置等 底图
        toolBgView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 0)
        self.view.addSubview(toolBgView)
        
        // 图片
        let imageBtn = UIButton(frame: CGRect(x: 8, y: 10, width: 76, height: 60))
        imageBtn.setImage(UIImage(named: "插入图片"), for: UIControlState())
        toolBgView.addSubview(imageBtn)
        
        // line3
        let line3 = UIView(frame: CGRect(x: 0, y: imageBtn.frame.maxY+10, width: WIDTH, height: 1/UIScreen.main.scale))
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
        chooseCircleLab.text = "选择圈子"
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
        
        let addresssLab = UILabel(frame: CGRect(x: addressImg.frame.maxX+8, y: 0, width: WIDTH-(addressImg.frame.maxX+8)-38, height: 40))
        addresssLab.text = "所在位置"
        addressBtn.addSubview(addresssLab)
        
        // line5
        let line5 = UIView(frame: CGRect(x: 0, y: addressBtn.frame.maxY, width: WIDTH, height: 1/UIScreen.main.scale))
        line5.backgroundColor = UIColor.lightGray
        toolBgView.addSubview(line5)
        
        toolBgView.frame.size.height = line5.frame.maxY
        toolBgView.frame.origin.y = HEIGHT-65-toolBgView.frame.size.height
        
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
    
    // MARK: - 点击发布按钮
    func postBtnClick() {
        print("点击发布按钮")
    }
    
    // MARK: - 点击选择圈子按钮
    func chooseCircleBtnClick() {
        print("点击选择圈子按钮")
        
        self.navigationController?.pushViewController(NSCirclePostChooseCircleViewController(), animated: true)
    }
    
    // MARK: - 点击发贴位置按钮
    func addressBtnClick() {
        print("点击发贴位置按钮")
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
