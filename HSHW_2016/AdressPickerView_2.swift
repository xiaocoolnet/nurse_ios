//
//  AdressPickerView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

typealias selBlock_2 = (dressArray:NSArray)->()

class AdressPickerView_2: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    internal var showTown=Bool()  // 设置是否显示区县，默认为false.
    internal var pickArray:NSArray? // 第一次传入已有的地址，跳转到选择好的位置
    
    private let picker=UIPickerView()
    private var block:selBlock_2?
    private var bgView=UIView()
    private var width=CGFloat()
    private var height=CGFloat()
    private var addressArray:NSMutableArray? // 需返回的数据
    private var countyArray=NSDictionary() // 国
    private var provinceArray=NSArray() // 省
    private var cityArray=NSArray()  // 市
    private var areaArray=NSArray() // 区县州
    
    class var shareInstance: AdressPickerView_2 {
        struct Static {
            static var onceToken:dispatch_once_t=0
            static var instance:AdressPickerView_2?=nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance=AdressPickerView_2()
            Static.instance?.initdata()
            Static.instance?.width=UIApplication.sharedApplication().keyWindow!.bounds.size.width
            Static.instance?.height=UIApplication.sharedApplication().keyWindow!.bounds.size.height
            Static.instance?.initUserInterface()
        }
        return Static.instance!
    }
    
    
    
    internal func selectAdress(adressArray:selBlock)->Void{
        block=adressArray
    }
    
    internal func show(view:UIView)->Void{
        view.addSubview(self)
        if pickArray != nil {
            if showTown {
                if !provinceArray.containsObject(pickArray![0]){
                    assertionFailure("erro: Province is not contains this province!")
                }
                let first=provinceArray.indexOfObject(pickArray![0])
                picker.selectRow(first, inComponent: 0, animated: true)
                picker.reloadComponent(1)
                picker.reloadComponent(2)
                if !cityArray.containsObject(pickArray![1]) {
                    assertionFailure("erro: Cities is not contains this city!")
                }
                let secon=cityArray.indexOfObject(pickArray![1])
                picker.selectRow(secon, inComponent: 1, animated: true)
                picker.reloadComponent(2)
                if !areaArray.containsObject(pickArray![2]) {
                    assertionFailure("erro: town is not contains this town!")
                }
                let three=areaArray.indexOfObject(pickArray![2])
                picker.selectRow(three, inComponent: 2, animated: true)
            }else{
                if !provinceArray.containsObject(pickArray![0]){
                    assertionFailure("erro: Province is not contains this province!")
                }
                let first=provinceArray.indexOfObject(pickArray![0])
                picker.selectRow(first, inComponent: 0, animated: true)
                picker.reloadComponent(1)
                if !cityArray.containsObject(pickArray![1]) {
                    assertionFailure("erro: Cities is not contains this city!")
                }
                let secon=cityArray.indexOfObject(pickArray![1])
                picker.selectRow(secon, inComponent: 1, animated: true)
            }
            
            addressArray=NSMutableArray()
            if showTown {
                // 添加数据
                addressArray!.addObject(provinceArray[picker.selectedRowInComponent(0)])
                addressArray!.addObject(cityArray[picker.selectedRowInComponent(1)])
                addressArray!.addObject(areaArray[picker.selectedRowInComponent(2)])
            }else{
                // 添加数据
                addressArray!.addObject(provinceArray[picker.selectedRowInComponent(0)])
                addressArray!.addObject(cityArray[picker.selectedRowInComponent(1)])
            }
            
           
        }
        // 改动
//        UIView.animateWithDuration(0.3) {
//            self.bgView.frame=CGRectMake(self.bgView.frame.origin.x, view.bounds.height-300, self.bgView.bounds.size.width, self.bgView.bounds.size.height)
//        }
        UIView.animateWithDuration(0.3) {
            self.bgView.frame=CGRectMake(self.bgView.frame.origin.x, view.bounds.height-self.bgView.bounds.size.height, self.bgView.bounds.size.width, self.bgView.bounds.size.height)
        }
    }
    
    private func  initUserInterface()->Void{
        self.frame=CGRectMake(0, 0, width, height)
        self.backgroundColor=UIColor.clearColor()
        bgView.frame=CGRectMake(0, height - 220, width, 220)
        bgView.backgroundColor=UIColor ( red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0 )
        self.addSubview(bgView)
        
//        // 加一手势，适用于点击空白处返回
//        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(AdressPickerView.cancle))
//        self.addGestureRecognizer(tapGes)
        
        
        // 添加两个按钮
        let cancle=UIButton.init(type: .System)
        cancle.frame=CGRectMake(5, 0, 40, 40)
        cancle.setTitle("取消", forState: .Normal)
        cancle.setTitleColor(UIColor ( red: 0.298, green: 0.298, blue: 0.298, alpha: 1.0 ), forState: .Normal)
        cancle.addTarget(self, action: #selector(AdressPickerView.cancle), forControlEvents: .TouchUpInside)
        bgView.addSubview(cancle)
        
        let done=UIButton.init(type: .System)
        done.frame=CGRectMake(width-45, 0, 40, 40)
        done.setTitle("完成", forState: .Normal)
        done.addTarget(self, action: #selector(AdressPickerView.done), forControlEvents: .TouchUpInside)
        bgView.addSubview(done)
        
        // 地址选择器
        picker.frame=CGRectMake(0, 40, width, 180)
        picker.backgroundColor=UIColor.whiteColor()
        picker.delegate=self
        picker.dataSource=self
        bgView.addSubview(picker)
        
    }
    
    // 获取数据
    private func initdata()->Void{
        countyArray = NSDictionary.init(contentsOfFile: NSBundle.mainBundle().pathForAuxiliaryExecutable("area.plist")!)!
        provinceArray=countyArray.allKeys
    }
    
    internal func cancle()->Void{
        UIView.animateWithDuration(0.3, animations: {
            self.bgView.frame=CGRectMake(self.bgView.frame.origin.x, self.height, self.bgView.bounds.size.width, self.bgView.bounds.size.height)
        }) { (flag) in
            self.removeFromSuperview()
        }
    }
    
    internal func done()->Void{
        if block != nil {
            if addressArray != nil {
                block!(dressArray: addressArray!)
            }
        }
        UIView.animateWithDuration(0.3, animations: {
            self.bgView.frame=CGRectMake(self.bgView.frame.origin.x, self.height, self.bgView.bounds.size.width, self.bgView.bounds.size.height)
        }) { (flag) in
            self.removeFromSuperview()
        }
    }
    //MARK: UIPickerViewDataSource
    internal func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if showTown {
            return 3
        }else{
            return 2
        }
    }
    internal func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if showTown {
            if component==0 {
                return provinceArray.count
            }else if component==1{
                let index=pickerView.selectedRowInComponent(0)
                cityArray=countyArray[provinceArray[index] as! String]!.allKeys
                return cityArray.count
            }else{
                let row1=pickerView.selectedRowInComponent(0)
                let row=pickerView.selectedRowInComponent(1)
                areaArray=(countyArray[provinceArray[row1] as! String] as! Dictionary)[cityArray[row] as! String]!
                return areaArray.count
            }
        }else{
            if component==0 {
                return provinceArray.count
            }else{
                let row=pickerView.selectedRowInComponent(0)
                cityArray=countyArray[provinceArray[row] as! String]!.allKeys
                return cityArray.count
            }
        }
    }
    //MARK: UIPickerViewDelegate
//    internal func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        if showTown {
//            if component==0 {
//                return provinceArray[row] as? String
//            }else if component==1{
//                let index=pickerView.selectedRowInComponent(0)
//                cityArray=countyArray[provinceArray[index] as! String]!.allKeys
//                return cityArray[row] as? String
//            }else{
//                let index=pickerView.selectedRowInComponent(0)
//                let index1=pickerView.selectedRowInComponent(1)
//                areaArray=(countyArray[provinceArray[index] as! String] as! Dictionary)[cityArray[index1] as! String]!
//                return areaArray[row] as? String
//            }
//        }else{
//            if component==0 {
//                return provinceArray[row] as? String
//            }else{
//                let index=pickerView.selectedRowInComponent(0)
//                cityArray=countyArray[provinceArray[index] as! String]!.allKeys
//                return cityArray[row] as? String
//            }
//        }
//    }
    // 上方方法改动为下方可以自动调节字体大小的方法
    internal func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let lable=UILabel()
        
        lable.sizeToFit()
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = NSTextAlignment.Center
        
        if showTown {
            if component==0 {
                lable.text = provinceArray[row] as? String
            }else if component==1{
                let index=pickerView.selectedRowInComponent(0)
                cityArray=countyArray[provinceArray[index] as! String]!.allKeys
                lable.text = cityArray[row] as? String
            }else{
                let index=pickerView.selectedRowInComponent(0)
                let index1=pickerView.selectedRowInComponent(1)
                areaArray=(countyArray[provinceArray[index] as! String] as! Dictionary)[cityArray[index1] as! String]!
                lable.text = areaArray[row] as? String
            }
        }else{
            if component==0 {
                lable.text = provinceArray[row] as? String
            }else{
                let index=pickerView.selectedRowInComponent(0)
                cityArray=countyArray[provinceArray[index] as! String]!.allKeys
                lable.text = cityArray[row] as? String
            }
        }
        
        return    lable
    }
    
    internal func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    internal func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addressArray=NSMutableArray()
        if showTown {
            if component==0 {
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                // 添加数据
                addressArray!.addObject(provinceArray[row])
                addressArray!.addObject(cityArray[0])
                addressArray!.addObject(areaArray[0])
            }else if component==1{
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                
                let index1=pickerView.selectedRowInComponent(0)
                addressArray!.addObject(provinceArray[index1])
                addressArray!.addObject(cityArray[row])
                addressArray!.addObject(areaArray[0])
            }else{
                let index1=pickerView.selectedRowInComponent(0)
                let index2=pickerView.selectedRowInComponent(1)
                addressArray!.addObject(provinceArray[index1])
                addressArray!.addObject(cityArray[index2])
                addressArray!.addObject(areaArray[row])
            }
        }else{
            if component==0 {
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                
                addressArray!.addObject(provinceArray[row])
                addressArray!.addObject(cityArray[0])
            }else{
                let index1=pickerView.selectedRowInComponent(0)
                addressArray!.addObject(provinceArray[index1])
                addressArray!.addObject(cityArray[row])
            }
        }
    }
    
}
