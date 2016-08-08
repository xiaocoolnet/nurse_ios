//
//  MineRecruitTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineRecruitTableViewCell: UITableViewCell {

    let timeLab = UILabel()
    let ones = UIButton()
    let time = UIImageView()
    let nameTit = UILabel()
    let one = UILabel()
    let job = UILabel()
    let two = UILabel()
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        ones.frame = CGRectMake(WIDTH-35, 26, 20, 20)
        ones.setImage(UIImage(named: "ic_you.png"), forState: .Normal)
        timeLab.frame = CGRectMake(15, 40, 80, 20)
        timeLab.font = UIFont.systemFontOfSize(10)
        timeLab.textColor = GREY
        time.frame = CGRectMake(15, 46.5, 7, 7)
        time.image = UIImage(named: "ic_time_gray@.png")
        let line = UILabel(frame: CGRectMake(0, 71.5, WIDTH, 0.5))
        line.backgroundColor = GREY
        
        
        self.addSubview(line)
        self.addSubview(ones)
//        self.addSubview(timeLab)
        self.addSubview(time)
        self.addSubview(nameTit)
        self.addSubview(one)
        self.addSubview(job)
        self.addSubview(two)
        
    }
    
    func showforCVModel(model:CVModel) {
        timeLab.text = "15分钟前"
        timeLab.sizeToFit()
        
        nameTit.frame = CGRectMake(15, 15, 50, 20)
        nameTit.font = UIFont.systemFontOfSize(14)
        nameTit.textColor = COLOR

        nameTit.text = model.name
        nameTit.sizeToFit()
        one.frame =  CGRectMake(15+nameTit.bounds.size.width, 15, 59, 20)
        one.font = UIFont.systemFontOfSize(14)
        one.textColor = UIColor.grayColor()
        one.text = "申请面试"
        one.sizeToFit()
        job.frame = CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width, 15, 50, 20)
        job.textColor = COLOR
        job.font = UIFont.systemFontOfSize(14)
    
        job.text = model.wantposition
        job.sizeToFit()
        two.frame = CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width+job.bounds.size.width, 15, 50, 20)
        two.textColor = UIColor.grayColor()
        two.text = "的职位"
        two.font = UIFont.systemFontOfSize(14)
        two.sizeToFit()

    }
    
    func showforUserModel(model:InvitedInfo) {
        timeLab.text = "15分钟前"
        timeLab.sizeToFit()
        
        nameTit.frame = CGRectMake(15, 15, 50, 20)
        nameTit.font = UIFont.systemFontOfSize(14)
        nameTit.textColor = COLOR
        
        nameTit.text = model.companyname
        nameTit.sizeToFit()
        one.frame =  CGRectMake(15+nameTit.bounds.size.width, 15, 59, 20)
        one.font = UIFont.systemFontOfSize(14)
        one.textColor = UIColor.grayColor()
        one.text = "诚邀您参加面试"
        one.sizeToFit()
        job.frame = CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width, 15, 50, 20)
        job.textColor = COLOR
        job.font = UIFont.systemFontOfSize(14)
        
        job.text = ""
        job.sizeToFit()
        two.frame = CGRectMake(15+nameTit.bounds.size.width+one.bounds.size.width+job.bounds.size.width, 15, 50, 20)
        two.textColor = UIColor.grayColor()
        two.text = ""
        two.font = UIFont.systemFontOfSize(14)
        two.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
