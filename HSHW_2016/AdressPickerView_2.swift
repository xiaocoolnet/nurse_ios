//
//  AdressPickerView.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/11.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import Foundation

typealias selBlock_2 = (_ dressArray:NSArray)->()

class AdressPickerView_2: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    struct Static {
        static var onceToken:Int=0
        static var instance:AdressPickerView_2?=nil
    }
    
    private static var __once: () = {
        
            Static.instance=AdressPickerView_2()
            Static.instance?.initdata()
            Static.instance?.width=UIApplication.shared.keyWindow!.bounds.size.width
            Static.instance?.height=UIApplication.shared.keyWindow!.bounds.size.height
            Static.instance?.initUserInterface()
        }()
    
    internal var showTown=Bool()  // 设置是否显示区县，默认为false.
    internal var pickArray:NSArray? // 第一次传入已有的地址，跳转到选择好的位置
    
    fileprivate let picker=UIPickerView()
    fileprivate var block:selBlock_2?
    fileprivate var bgView=UIView()
    fileprivate var width=CGFloat()
    fileprivate var height=CGFloat()
    fileprivate var addressArray:NSMutableArray? // 需返回的数据
    fileprivate var countyArray=NSDictionary() // 国
    fileprivate var provinceArray=NSArray() // 省
    fileprivate var cityArray=NSArray()  // 市
    fileprivate var areaArray=NSArray() // 区县州
    
    class var shareInstance: AdressPickerView_2 {
//        struct Static {
//            static var onceToken:Int=0
//            static var instance:AdressPickerView_2?=nil
//        }
        _ = AdressPickerView_2.__once
        return Static.instance!
    }
    
    
    
    internal func selectAdress(_ adressArray:@escaping selBlock)->Void{
        block=adressArray
    }
    
    internal func show(_ view:UIView)->Void{
        view.addSubview(self)
        if pickArray != nil {
            if showTown {
                if !provinceArray.contains(pickArray![0]){
                    assertionFailure("erro: Province is not contains this province!")
                }
                let first=provinceArray.index(of: pickArray![0])
                picker.selectRow(first, inComponent: 0, animated: true)
                picker.reloadComponent(1)
                picker.reloadComponent(2)
                if !cityArray.contains(pickArray![1]) {
                    assertionFailure("erro: Cities is not contains this city!")
                }
                let secon=cityArray.index(of: pickArray![1])
                picker.selectRow(secon, inComponent: 1, animated: true)
                picker.reloadComponent(2)
                if !areaArray.contains(pickArray![2]) {
                    assertionFailure("erro: town is not contains this town!")
                }
                let three=areaArray.index(of: pickArray![2])
                picker.selectRow(three, inComponent: 2, animated: true)
            }else{
                if !provinceArray.contains(pickArray![0]){
                    assertionFailure("erro: Province is not contains this province!")
                }
                let first=provinceArray.index(of: pickArray![0])
                picker.selectRow(first, inComponent: 0, animated: true)
                picker.reloadComponent(1)
                if !cityArray.contains(pickArray![1]) {
                    assertionFailure("erro: Cities is not contains this city!")
                }
                let secon=cityArray.index(of: pickArray![1])
                picker.selectRow(secon, inComponent: 1, animated: true)
            }
            
            addressArray=NSMutableArray()
            if showTown {
                // 添加数据
                addressArray!.add(provinceArray[picker.selectedRow(inComponent: 0)])
                addressArray!.add(cityArray[picker.selectedRow(inComponent: 1)])
                addressArray!.add(areaArray[picker.selectedRow(inComponent: 2)])
            }else{
                // 添加数据
                addressArray!.add(provinceArray[picker.selectedRow(inComponent: 0)])
                addressArray!.add(cityArray[picker.selectedRow(inComponent: 1)])
            }
            
           
        }
        // 改动
//        UIView.animateWithDuration(0.3) {
//            self.bgView.frame=CGRectMake(self.bgView.frame.origin.x, view.bounds.height-300, self.bgView.bounds.size.width, self.bgView.bounds.size.height)
//        }
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.frame=CGRect(x: self.bgView.frame.origin.x, y: view.bounds.height-self.bgView.bounds.size.height, width: self.bgView.bounds.size.width, height: self.bgView.bounds.size.height)
        }) 
    }
    
    fileprivate func  initUserInterface()->Void{
        self.frame=CGRect(x: 0, y: 0, width: width, height: height)
        self.backgroundColor=UIColor.clear
        bgView.frame=CGRect(x: 0, y: height - 220, width: width, height: 220)
        bgView.backgroundColor=UIColor ( red: 0.902, green: 0.902, blue: 0.902, alpha: 1.0 )
        self.addSubview(bgView)
        
//        // 加一手势，适用于点击空白处返回
//        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(AdressPickerView.cancle))
//        self.addGestureRecognizer(tapGes)
        
        
        // 添加两个按钮
        let cancle=UIButton.init(type: .system)
        cancle.frame=CGRect(x: 5, y: 0, width: 40, height: 40)
        cancle.setTitle("取消", for: UIControlState())
        cancle.setTitleColor(UIColor ( red: 0.298, green: 0.298, blue: 0.298, alpha: 1.0 ), for: UIControlState())
        cancle.addTarget(self, action: #selector(AdressPickerView.cancle), for: .touchUpInside)
        bgView.addSubview(cancle)
        
        let done=UIButton.init(type: .system)
        done.frame=CGRect(x: width-45, y: 0, width: 40, height: 40)
        done.setTitle("完成", for: UIControlState())
        done.addTarget(self, action: #selector(AdressPickerView.done), for: .touchUpInside)
        bgView.addSubview(done)
        
        // 地址选择器
        picker.frame=CGRect(x: 0, y: 40, width: width, height: 180)
        picker.backgroundColor=UIColor.white
        picker.delegate=self
        picker.dataSource=self
        bgView.addSubview(picker)
        
    }
    
    // 获取数据
    fileprivate func initdata()->Void{
        countyArray = NSDictionary.init(contentsOfFile: Bundle.main.path(forAuxiliaryExecutable: "area.plist")!)!
        provinceArray=countyArray.allKeys as NSArray
    }
    
    internal func cancle()->Void{
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.frame=CGRect(x: self.bgView.frame.origin.x, y: self.height, width: self.bgView.bounds.size.width, height: self.bgView.bounds.size.height)
        }, completion: { (flag) in
            self.removeFromSuperview()
        }) 
    }
    
    internal func done()->Void{
        if block != nil {
            if addressArray != nil {
                block!(addressArray!)
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.bgView.frame=CGRect(x: self.bgView.frame.origin.x, y: self.height, width: self.bgView.bounds.size.width, height: self.bgView.bounds.size.height)
        }, completion: { (flag) in
            self.removeFromSuperview()
        }) 
    }
    //MARK: UIPickerViewDataSource
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if showTown {
            return 3
        }else{
            return 2
        }
    }
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if showTown {
            if component==0 {
                return provinceArray.count
            }else if component==1{
                let index=pickerView.selectedRow(inComponent: 0)
                cityArray=(countyArray[provinceArray[index] as! String]! as AnyObject).allKeys as NSArray
                return cityArray.count
            }else{
                let row1=pickerView.selectedRow(inComponent: 0)
                let row=pickerView.selectedRow(inComponent: 1)
                areaArray=(countyArray[provinceArray[row1] as! String] as! Dictionary)[cityArray[row] as! String]!
                return areaArray.count
            }
        }else{
            if component==0 {
                return provinceArray.count
            }else{
                let row=pickerView.selectedRow(inComponent: 0)
                cityArray=(countyArray[provinceArray[row] as! String]! as AnyObject).allKeys as NSArray
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
    internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let lable=UILabel()
        
        lable.sizeToFit()
        lable.adjustsFontSizeToFitWidth = true
        lable.textAlignment = NSTextAlignment.center
        
        if showTown {
            if component==0 {
                lable.text = provinceArray[row] as? String
            }else if component==1{
                let index=pickerView.selectedRow(inComponent: 0)
                cityArray=(countyArray[provinceArray[index] as! String]! as AnyObject).allKeys as NSArray
                lable.text = cityArray[row] as? String
            }else{
                let index=pickerView.selectedRow(inComponent: 0)
                let index1=pickerView.selectedRow(inComponent: 1)
                areaArray=(countyArray[provinceArray[index] as! String] as! Dictionary)[cityArray[index1] as! String]!
                lable.text = areaArray[row] as? String
            }
        }else{
            if component==0 {
                lable.text = provinceArray[row] as? String
            }else{
                let index=pickerView.selectedRow(inComponent: 0)
                cityArray=(countyArray[provinceArray[index] as! String]! as AnyObject).allKeys as NSArray
                lable.text = cityArray[row] as? String
            }
        }
        
        return    lable
    }
    
    internal func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        addressArray=NSMutableArray()
        if showTown {
            if component==0 {
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                // 添加数据
                addressArray!.add(provinceArray[row])
                addressArray!.add(cityArray[0])
                addressArray!.add(areaArray[0])
            }else if component==1{
                pickerView.reloadComponent(2)
                pickerView.selectRow(0, inComponent: 2, animated: true)
                
                let index1=pickerView.selectedRow(inComponent: 0)
                addressArray!.add(provinceArray[index1])
                addressArray!.add(cityArray[row])
                addressArray!.add(areaArray[0])
            }else{
                let index1=pickerView.selectedRow(inComponent: 0)
                let index2=pickerView.selectedRow(inComponent: 1)
                addressArray!.add(provinceArray[index1])
                addressArray!.add(cityArray[index2])
                addressArray!.add(areaArray[row])
            }
        }else{
            if component==0 {
                pickerView.reloadComponent(1)
                pickerView.selectRow(0, inComponent: 1, animated: true)
                
                addressArray!.add(provinceArray[row])
                addressArray!.add(cityArray[0])
            }else{
                let index1=pickerView.selectedRow(inComponent: 0)
                addressArray!.add(provinceArray[index1])
                addressArray!.add(cityArray[row])
            }
        }
    }
    
}
