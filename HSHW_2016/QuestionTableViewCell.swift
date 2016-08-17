//
//  QuestionTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

    let titLab = UILabel()
    let titLeb = UILabel()
    let conNum = UILabel()
    let zanNum = UILabel()
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        let titImage = UIButton(frame: CGRectMake(10, 20, 25, 35))
        titImage.setImage(UIImage(named: "ic_wirte.png"), forState: .Normal)
        titLab.frame = CGRectMake(40, 18, WIDTH/2, 18)
        titLab.font = UIFont.systemFontOfSize(14)
        titLeb.frame = CGRectMake(40, 40, WIDTH/2, 17)
        titLeb.font = UIFont.systemFontOfSize(14)
        let zanImage = UIButton(frame: CGRectMake(WIDTH-60, 21, 12, 8))
        zanImage.setBackgroundImage(UIImage(named: "ic_eye_purple.png"), forState: .Normal)
        
        conNum.frame = CGRectMake(WIDTH-40, 16, 35, 18)
        conNum.font = UIFont.systemFontOfSize(15)
        conNum.textColor = UIColor.grayColor()
        let conImage = UIButton(frame: CGRectMake(WIDTH-60, 43, 10, 10))
//        conImage.setImage(UIImage(named: "ic_collect_sel.png"), forState: .Normal)
        conImage.setBackgroundImage(UIImage(named: "ic_like_sel.png"), forState: .Normal)
        zanNum.frame = CGRectMake(WIDTH-40, 40, 35, 17)
        zanNum.font = UIFont.systemFontOfSize(15)
        zanNum.textColor = UIColor.grayColor()
        let line = UILabel(frame: CGRectMake(0, 74.5, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        self.addSubview(line)
        self.addSubview(titImage)
        self.addSubview(titLab)
        self.addSubview(titLeb)
        self.addSubview(zanImage)
        self.addSubview(conNum)
        self.addSubview(conImage)
        self.addSubview(zanNum)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
