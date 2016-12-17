//
//  DataPickerView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

typealias dateBlock = (_ date:Date)->()
class DatePickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    fileprivate static let _shareInstance = DatePickerView()
    class func getShareInstance()-> DatePickerView{
        return _shareInstance;
    }
    var block:dateBlock?
    
    var num = 1
    var showType:HSEditUserInfo = .default
    
    var textColor:UIColor = UIColor.black; //字体颜色 默认为黑色
    var buColor:UIColor = UIColor.white; //按钮栏背景颜色 默认为白色
    var pickerColor:UIColor = UIColor.white; //选择器背景色 默认为白色
    var alphas:CGFloat = 0.6;         //背景透明度默认为0.6
    fileprivate var endDate:Date = Date();
    fileprivate var currentYear:Int = 0
    fileprivate var currentMonth:Int = 0
    fileprivate var currentDay:Int = 0;
    fileprivate var datePicker:UIPickerView?;
    fileprivate let calendar:Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
    fileprivate var comps:DateComponents = DateComponents()
    fileprivate init()
    {
        super.init(frame: (UIApplication.shared.keyWindow?.bounds)!)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal  func showWithDate(_ date:Date?)
    {
        endDate = date!
        comps = (calendar as NSCalendar).components([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.minute,NSCalendar.Unit.second], from: endDate)
        currentYear = comps.year!;
        currentMonth = comps.month!;
        currentDay = comps.day!;
        comps.day = 1
        comps.year = currentYear
        comps.month = currentMonth
        self.endDate = calendar.date(from: comps)!;
        UIApplication.shared.keyWindow?.addSubview(self)
        datePicker?.reloadAllComponents();
        datePicker?.selectRow(0, inComponent: 0, animated: false)
        datePicker?.selectRow(currentMonth-1, inComponent: 1, animated: false)
        datePicker?.selectRow(0, inComponent: 2, animated: false)
    }
    
    func initUI()
    {
        
        comps = (calendar as NSCalendar).components([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day,NSCalendar.Unit.hour,NSCalendar.Unit.month,NSCalendar.Unit.second], from: endDate)
        currentYear = comps.year!;
        currentMonth = comps.month!;
        currentDay = comps.day!;
        comps.day = 1;
        self.endDate = calendar.date(from: comps)!;
        self.backgroundColor = UIColor.clear
        let colorView:UIView = UIView(frame: self.bounds)
        colorView.backgroundColor = UIColor.black
        colorView.alpha = alphas;
        self.addSubview(colorView)
        let buttonView:UIView = UIView(frame: CGRect( x: 0, y: self.frame.size.height/2.0, width: self.frame.size.width, height: 45))
        self.addSubview(buttonView)
        buttonView.backgroundColor = buColor
        for i in 0...4
        {
            let btn:UIButton = UIButton(type: UIButtonType.custom)
            btn.setTitleColor(textColor, for: UIControlState())
            buttonView.addSubview(btn)
            if (i==0)
            {
                btn.frame = CGRect(x: 10, y: 0, width: 60, height: buttonView.frame.size.height);
                btn.setTitle("取消", for: UIControlState())
                btn.addTarget(self,action:#selector(cancelClick(_:)),for:.touchUpInside)
            }else{
                btn.frame = CGRect(x: buttonView.frame.size.width-70, y: 0, width: 60, height: buttonView.frame.size.height);
                btn.setTitle("完成", for: UIControlState())
                btn.addTarget(self, action: #selector(doneClick(_:)), for: .touchUpInside)
            }
        }
        
        datePicker = UIPickerView(frame: CGRect(x: 0, y: self.frame.size.height/2.0+45, width: self.frame.size.width, height: self.frame.size.height/2.0-45))
        datePicker?.backgroundColor = pickerColor;
        datePicker?.delegate = self
        datePicker?.dataSource = self
        self.addSubview(datePicker!)
        datePicker?.showsSelectionIndicator =  true;
        datePicker?.selectRow(0, inComponent: 0, animated: false)
        datePicker?.selectRow(currentMonth-1, inComponent: 1, animated: false)
        datePicker?.selectRow(0, inComponent: 2, animated: false)
        
    }
    
    func dayFromeMonthAndYear(_ year:Int,month:Int)->Int //计算每月天数
    {
        var days = 0;
        if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
        {
            days = 31;
        }
        else if (month == 4 || month == 6 || month == 9 || month == 11)
        {
            days = 30;
        }
        else{
            if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0)
            {
                days = 29;
            }else {
                days = 28;
            }
        }
        
        return days;
    }
    
    func cancelClick(_ sender:UIButton) //取消事件
    {
        self.removeFromSuperview()
    }
    
    func doneClick(_ sender:UIButton) //完成事件
    {
        block!(endDate)
//        if num == 2 {
//            <#code#>
//        }
        self.removeFromSuperview()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if ( component == 0)
        {
            return 1000;
        }
        else if ( component == 1)
        {
            if (comps.year == currentYear)
            {
                return currentMonth;
            }
            else{
                return 12;
            }
            
        }else{
            if ( currentYear == comps.year && currentMonth == comps.month)
            {
                return currentDay;
            }
            else{
                return dayFromeMonthAndYear(comps.year!, month: comps.month!);
            }
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50;
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return self.frame.size.width/3.0;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width/3.0, height: 50))
        label.textColor = textColor
        label.textAlignment = NSTextAlignment.center
        if ( component == 0)
        {
            let y = currentYear - row;
            label.text = String(y)+"年"
        }
        else if ( component == 1)
        {
            label.text = String(row+1)+"月"
            
        }else{
            
            label.text = String(row+1)+"日"
        }
        return label;
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ( component == 0 ) {
            comps.year = currentYear-row;
        }
        else if (component == 1) {
            comps.month = row+1;
        }
        else{
            comps.day = row+1;
        }
        comps.day = comps.day! > dayFromeMonthAndYear(comps.year!, month: comps.month!) ? dayFromeMonthAndYear(comps.year!, month: comps.month!) : comps.day;
        self.endDate = calendar.date(from: comps)!;
        pickerView.reloadAllComponents()
        
    }
    
    
}
