//
//  HSComOpenHeader.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

typealias selectBlock = (NSInteger) -> ()

class HSComOpenHeader: UIView {
    
    var selectedItemHandle:selectBlock?
    var oldBtn:UIButton?

    @IBOutlet weak var sliderView: UIView!
    
    @IBAction func selectItemWithBtn(_ sender: UIButton) {
        if selectedItemHandle != nil {
            UIView.animate(withDuration: 0.2, animations: {
                self.sliderView.frame = CGRect(x: sender.frame.minX, y: sender.frame.maxY+2, width: sender.frame.width, height: 2)
            })
            if oldBtn != nil {
                oldBtn?.setTitleColor(UIColor.lightGray, for: UIControlState())
            }
            sender.setTitleColor(UIColor(red: 152/255.0, green: 0, blue: 112/255.0, alpha: 1), for: UIControlState())
            oldBtn = sender
            selectedItemHandle!(sender.tag-101)
        }
    }
    func setSelectedItem(_ index:Int){
        let sender = self.viewWithTag(101+index) as? UIButton
        if sender == nil{
            return
        }
        if oldBtn != nil {
            oldBtn?.setTitleColor(UIColor.lightGray, for: UIControlState())
        }
        sender!.setTitleColor(UIColor(red: 152/255.0, green: 0, blue: 112/255.0, alpha: 1), for: UIControlState())
        oldBtn = sender
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sliderView.frame = CGRect(x: oldBtn!.frame.minX, y: oldBtn!.frame.maxY+2, width: oldBtn!.frame.width, height: 2)
    }
    
    func sethandle(_ handle:@escaping selectBlock){
        selectedItemHandle = handle
    }

}
