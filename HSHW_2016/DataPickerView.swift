//
//  DataPickerView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

typealias dateBlock = (date:NSDate)->()
class DatePickerView: UIView,UIPickerViewDataSource,UIPickerViewDelegate {
    
    private static let _shareInstance = DatePickerView()
    class func getShareInstance()-> DatePickerView{
        return _shareInstance;
    }
    var block:dateBlock?
    
    var num = 1
    var showType:HSEditUserInfo = .Default
    
    var textColor:UIColor = UIColor.blackColor(); //字体颜色 默认为黑色
    var buColor:UIColor = UIColor.whiteColor(); //按钮栏背景颜色 默认为白色
    var pickerColor:UIColor = UIColor.whiteColor(); //选择器背景色 默认为白色
    var alphas:CGFloat = 0.6;         //背景透明度默认为0.6
    private var endDate:NSDate = NSDate();
    private var currentYear:Int = 0
    private var currentMonth:Int = 0
    private var currentDay:Int = 0;
    private var datePicker:UIPickerView?;
    private let calendar:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    private var comps:NSDateComponents = NSDateComponents()
    private init()
    {
        super.init(frame: (UIApplication.sharedApplication().keyWindow?.bounds)!)
        initUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    internal  func showWithDate(date:NSDate?)
    {
        endDate = date!
        comps = calendar.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: endDate)
        currentYear = comps.year;
        currentMonth = comps.month;
        currentDay = comps.day;
        comps.day = 1
        comps.year = currentYear
        comps.month = currentMonth
        self.endDate = calendar.dateFromComponents(comps)!;
        UIApplication.sharedApplication().keyWindow?.addSubview(self)
        datePicker?.reloadAllComponents();
        datePicker?.selectRow(0, inComponent: 0, animated: false)
        datePicker?.selectRow(currentMonth-1, inComponent: 1, animated: false)
        datePicker?.selectRow(0, inComponent: 2, animated: false)
    }
    
    func initUI()
    {
        
        comps = calendar.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day,NSCalendarUnit.Hour,NSCalendarUnit.Month,NSCalendarUnit.Second], fromDate: endDate)
        currentYear = comps.year;
        currentMonth = comps.month;
        currentDay = comps.day;
        comps.day = 1;
        self.endDate = calendar.dateFromComponents(comps)!;
        self.backgroundColor = UIColor.clearColor()
        let colorView:UIView = UIView(frame: self.bounds)
        colorView.backgroundColor = UIColor.blackColor()
        colorView.alpha = alphas;
        self.addSubview(colorView)
        let buttonView:UIView = UIView(frame: CGRectMake( 0, self.frame.size.height/2.0, self.frame.size.width, 45))
        self.addSubview(buttonView)
        buttonView.backgroundColor = buColor
        for i in 0...4
        {
            let btn:UIButton = UIButton(type: UIButtonType.Custom)
            btn.setTitleColor(textColor, forState: UIControlState.Normal)
            buttonView.addSubview(btn)
            if (i==0)
            {
                btn.frame = CGRectMake(10, 0, 60, buttonView.frame.size.height);
                btn.setTitle("取消", forState: UIControlState.Normal)
                btn.addTarget(self,action:#selector(cancelClick(_:)),forControlEvents:.TouchUpInside)
            }else{
                btn.frame = CGRectMake(buttonView.frame.size.width-70, 0, 60, buttonView.frame.size.height);
                btn.setTitle("完成", forState: UIControlState.Normal)
                btn.addTarget(self, action: #selector(doneClick(_:)), forControlEvents: .TouchUpInside)
            }
        }
        
        datePicker = UIPickerView(frame: CGRectMake(0, self.frame.size.height/2.0+45, self.frame.size.width, self.frame.size.height/2.0-45))
        datePicker?.backgroundColor = pickerColor;
        datePicker?.delegate = self
        datePicker?.dataSource = self
        self.addSubview(datePicker!)
        datePicker?.showsSelectionIndicator =  true;
        datePicker?.selectRow(0, inComponent: 0, animated: false)
        datePicker?.selectRow(currentMonth-1, inComponent: 1, animated: false)
        datePicker?.selectRow(0, inComponent: 2, animated: false)
        
    }
    
    func dayFromeMonthAndYear(year:Int,month:Int)->Int //计算每月天数
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
    
    func cancelClick(sender:UIButton) //取消事件
    {
        self.removeFromSuperview()
    }
    
    func doneClick(sender:UIButton) //完成事件
    {
        block!(date:endDate)
//        if num == 2 {
//            <#code#>
//        }
        self.removeFromSuperview()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3;
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
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
                return dayFromeMonthAndYear(comps.year, month: comps.month);
            }
            
        }
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50;
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        return self.frame.size.width/3.0;
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width/3.0, 50))
        label.textColor = textColor
        label.textAlignment = NSTextAlignment.Center
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if ( component == 0 ) {
            comps.year = currentYear-row;
        }
        else if (component == 1) {
            comps.month = row+1;
        }
        else{
            comps.day = row+1;
        }
        comps.day = comps.day > dayFromeMonthAndYear(comps.year, month: comps.month) ? dayFromeMonthAndYear(comps.year, month: comps.month) : comps.day;
        self.endDate = calendar.dateFromComponents(comps)!;
        pickerView.reloadAllComponents()
        
    }
    
    
}
