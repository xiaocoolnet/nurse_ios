//
//  MineJobDetailsTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/17.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class MineJobDetailsTableViewCell: UITableViewCell {

    let title = UILabel()
    let eyeImage = UIImageView()
    let lookCount = UILabel()
    let timeImage = UIImageView()
    let timeLabel = UILabel()
    let nameLabel = UILabel()
    let name = UILabel()
    let descript = UILabel()
    let criteria = UILabel()
    let criteriaLabel = UILabel()
    let address = UILabel()
    let addressLabel = UILabel()
    let criteri = UILabel()
    let criteriLabel = UILabel()
    let addres = UILabel()
    let addresLabel = UILabel()
    let positionDescript = UILabel()
    let descripDetail = UILabel()
    let namLabel = UILabel()
    var nam = UIButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
//        let height = calculateHeight(jobModel.title, size: 18, width: WIDTH-20)
        title.frame = CGRectMake(10, 5, WIDTH-20, 30)
        title.font = UIFont.systemFontOfSize(20)
        title.textColor = COLOR
        title.numberOfLines = 0
        
//        eyeImage.image = UIImage(named: "ic_eye_purple.png")
        eyeImage.frame = CGRectMake(10,10,8,8)
        lookCount.frame = CGRectMake(20,10,30,10)
        lookCount.font = UIFont.systemFontOfSize(10)
//        lookCount.text = "3346"
//        timeImage.image = UIImage(named: "ic_time_purple.png")
        timeImage.frame = CGRectMake(55, 10, 8, 8)
        timeLabel.frame = CGRectMake(65,10,100,10)
        timeLabel.font = UIFont.systemFontOfSize(10)
//        timeLabel.text = "2016/03/16"
//
        nameLabel.frame = CGRectMake(10,10,100,25)
        nameLabel.font = UIFont.boldSystemFontOfSize(15)
//        nameLabel.text = "企业名称:"
        name.frame = CGRectMake(120,10,200,25)
        name.font = UIFont.systemFontOfSize(14)
        
        descript.frame = CGRectMake(10,10,WIDTH-20,50)
        descript.font = UIFont.boldSystemFontOfSize(15)
        descript.numberOfLines = 0

        criteria.frame = CGRectMake(10,10,70,25)
        criteria.font = UIFont.boldSystemFontOfSize(15)
//        criteria.text = "招聘条件:"
        criteriaLabel.frame = CGRectMake(80,10,75,25)
        criteriaLabel.font = UIFont.systemFontOfSize(14)
        address.frame = CGRectMake(170,10,70,25)
        address.font = UIFont.boldSystemFontOfSize(15)
//        address.text = "工作地点:"
        addressLabel.frame = CGRectMake(240,10,WIDTH-240,25)
        addressLabel.font = UIFont.systemFontOfSize(14)
        
        criteri.frame = CGRectMake(10,10,70,25)
        criteri.font = UIFont.boldSystemFontOfSize(15)
//        criteri.text = "招聘人数:"
        criteriLabel.frame = CGRectMake(80,10,75,25)
        criteriLabel.font = UIFont.systemFontOfSize(14)
        addres.frame = CGRectMake(170,10,70,25)
        addres.font = UIFont.boldSystemFontOfSize(15)
//        addres.text = "福利待遇:"
        addresLabel.frame = CGRectMake(240,10,WIDTH-240,25)
        addresLabel.font = UIFont.systemFontOfSize(14)

        positionDescript.frame = CGRectMake(10,10,100,25)
        positionDescript.font = UIFont.boldSystemFontOfSize(15)
//        positionDescript.text = "职位描述:"
        descripDetail.frame = CGRectMake(10,40,WIDTH-20,200)
        descripDetail.font = UIFont.systemFontOfSize(14)
        descripDetail.textColor = UIColor.lightGrayColor()
        descripDetail.numberOfLines = 0
        
        namLabel.frame = CGRectMake(10,10,80,25)
        namLabel.font = UIFont.boldSystemFontOfSize(15)
//        namLabel.text = "联系方式:"
        
        nam = UIButton(type: UIButtonType.Custom)
        nam.frame = CGRectMake(100, 10, 100, 25)
        nam.setTitleColor(COLOR, forState: .Normal)
        nam.titleLabel!.font = UIFont.systemFontOfSize(14)

        self.addSubview(title)
        self.addSubview(eyeImage)
        self.addSubview(lookCount)
        self.addSubview(timeImage)
        self.addSubview(timeLabel)
        self.addSubview(name)
        self.addSubview(nameLabel)
        self.addSubview(descript)
        self.addSubview(criteria)
        self.addSubview(criteriaLabel)
        self.addSubview(address)
        self.addSubview(addressLabel)
        self.addSubview(criteri)
        self.addSubview(criteriLabel)
        self.addSubview(addres)
        self.addSubview(addresLabel)
        self.addSubview(positionDescript)
        self.addSubview(descripDetail)
        self.addSubview(namLabel)
        self.addSubview(nam)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
