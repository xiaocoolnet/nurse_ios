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
        
        ones.frame = CGRect(x: WIDTH-35, y: 26, width: 20, height: 20)
        ones.setImage(UIImage(named: "ic_you.png"), for: UIControlState())
        timeLab.frame = CGRect(x: 15, y: 40, width: 80, height: 20)
        timeLab.font = UIFont.systemFont(ofSize: 10)
        timeLab.textColor = GREY
        time.frame = CGRect(x: 15, y: 46.5, width: 7, height: 7)
        time.image = UIImage(named: "ic_time_gray@.png")
        let line = UILabel(frame: CGRect(x: 0, y: 71.5, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        
        
        self.addSubview(line)
        self.addSubview(ones)
        self.addSubview(timeLab)
        self.addSubview(time)
        self.addSubview(nameTit)
        self.addSubview(one)
        self.addSubview(job)
        self.addSubview(two)
        
    }
    
    func showforCVModel(_ model:CVModel) {
        timeLab.text = self.timeStampToString(model.create_time)
        timeLab.sizeToFit()
        
        nameTit.frame = CGRect(x: 15, y: 15, width: 50, height: 20)
        nameTit.font = UIFont.systemFont(ofSize: 14)
        nameTit.textColor = COLOR

        nameTit.text = model.name
        nameTit.sizeToFit()
        one.frame =  CGRect(x: 15+nameTit.bounds.size.width, y: 15, width: 59, height: 20)
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.gray
        one.text = "申请面试"
        one.sizeToFit()
        job.frame = CGRect(x: 15+nameTit.bounds.size.width+one.bounds.size.width, y: 15, width: 50, height: 20)
        job.textColor = COLOR
        job.font = UIFont.systemFont(ofSize: 14)
    
        job.text = model.wantposition
        job.sizeToFit()
        two.frame = CGRect(x: 15+nameTit.bounds.size.width+one.bounds.size.width+job.bounds.size.width, y: 15, width: 50, height: 20)
        two.textColor = UIColor.gray
        two.text = "的职位"
        two.font = UIFont.systemFont(ofSize: 14)
        two.sizeToFit()

    }
    
    func showforUserModel(_ model:InvitedInfo) {
        timeLab.text = self.timeStampToString(model.create_time)
        timeLab.sizeToFit()
        
        nameTit.frame = CGRect(x: 15, y: 15, width: 50, height: 20)
        nameTit.font = UIFont.systemFont(ofSize: 14)
        nameTit.textColor = COLOR
        
        nameTit.text = model.companyname
        nameTit.sizeToFit()
        one.frame =  CGRect(x: 15+nameTit.bounds.size.width, y: 15, width: 59, height: 20)
        one.font = UIFont.systemFont(ofSize: 14)
        one.textColor = UIColor.gray
        one.text = "诚邀您参加面试"
        one.sizeToFit()
        job.frame = CGRect(x: 15+nameTit.bounds.size.width+one.bounds.size.width, y: 15, width: 50, height: 20)
        job.textColor = COLOR
        job.font = UIFont.systemFont(ofSize: 14)
        
        job.text = model.title
        job.sizeToFit()
        two.frame = CGRect(x: 15+nameTit.bounds.size.width+one.bounds.size.width+job.bounds.size.width, y: 15, width: 50, height: 20)
        two.textColor = UIColor.gray
        two.text = "的职位"
        two.font = UIFont.systemFont(ofSize: 14)
        two.sizeToFit()
        
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(_ timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd   hh:mm"
        
        let date = Date(timeIntervalSince1970: timeSta)
        
        //        print(dfmatter.stringFromDate(date))
        return dfmatter.string(from: date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
