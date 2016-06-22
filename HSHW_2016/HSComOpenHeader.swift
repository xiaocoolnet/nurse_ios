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
    
    @IBAction func selectItemWithBtn(sender: UIButton) {
        if selectedItemHandle != nil {
            UIView.animateWithDuration(0.2, animations: {
                self.sliderView.frame = CGRectMake(sender.frame.minX, sender.frame.maxY+2, sender.frame.width, 2)
            })
            if oldBtn != nil {
                oldBtn?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            }
            sender.setTitleColor(UIColor(red: 152/255.0, green: 0, blue: 112/255.0, alpha: 1), forState: .Normal)
            oldBtn = sender
            selectedItemHandle!(sender.tag-101)
        }
    }
    func setSelectedItem(index:Int){
        let sender = self.viewWithTag(101+index) as? UIButton
        if sender == nil{
            return
        }
        if oldBtn != nil {
            oldBtn?.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        }
        sender!.setTitleColor(UIColor(red: 152/255.0, green: 0, blue: 112/255.0, alpha: 1), forState: .Normal)
        oldBtn = sender
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.sliderView.frame = CGRectMake(oldBtn!.frame.minX, oldBtn!.frame.maxY+2, oldBtn!.frame.width, 2)
    }
    
    func sethandle(handle:selectBlock){
        selectedItemHandle = handle
    }

}
