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
        title.frame = CGRect(x: 10, y: 5, width: WIDTH-20, height: 30)
        title.font = UIFont.systemFont(ofSize: 20)
        title.textColor = COLOR
        title.numberOfLines = 0
        
//        eyeImage.image = UIImage(named: "ic_eye_purple.png")
        eyeImage.frame = CGRect(x: 10,y: 10,width: 8,height: 8)
        lookCount.frame = CGRect(x: 20,y: 10,width: 30,height: 10)
        lookCount.font = UIFont.systemFont(ofSize: 10)
//        lookCount.text = "3346"
//        timeImage.image = UIImage(named: "ic_time_purple.png")
        timeImage.frame = CGRect(x: 55, y: 10, width: 8, height: 8)
        timeLabel.frame = CGRect(x: 65,y: 10,width: 100,height: 10)
        timeLabel.font = UIFont.systemFont(ofSize: 10)
//        timeLabel.text = "2016/03/16"
//
        nameLabel.frame = CGRect(x: 10,y: 10,width: 100,height: 25)
        nameLabel.font = UIFont.boldSystemFont(ofSize: 15)
//        nameLabel.text = "企业名称:"
        name.frame = CGRect(x: 120,y: 10,width: 200,height: 25)
        name.font = UIFont.systemFont(ofSize: 14)
        
        descript.frame = CGRect(x: 10,y: 10,width: WIDTH-20,height: 50)
        descript.font = UIFont.boldSystemFont(ofSize: 15)
        descript.numberOfLines = 0

        criteria.frame = CGRect(x: 10,y: 10,width: 70,height: 25)
        criteria.font = UIFont.boldSystemFont(ofSize: 15)
//        criteria.text = "招聘条件:"
        criteriaLabel.frame = CGRect(x: 80,y: 10,width: 75,height: 25)
        criteriaLabel.font = UIFont.systemFont(ofSize: 14)
        address.frame = CGRect(x: 170,y: 10,width: 70,height: 25)
        address.font = UIFont.boldSystemFont(ofSize: 15)
//        address.text = "工作地点:"
        addressLabel.frame = CGRect(x: 240,y: 10,width: WIDTH-240,height: 25)
        addressLabel.font = UIFont.systemFont(ofSize: 14)
        
        criteri.frame = CGRect(x: 10,y: 10,width: 70,height: 25)
        criteri.font = UIFont.boldSystemFont(ofSize: 15)
//        criteri.text = "招聘人数:"
        criteriLabel.frame = CGRect(x: 80,y: 10,width: 75,height: 25)
        criteriLabel.font = UIFont.systemFont(ofSize: 14)
        addres.frame = CGRect(x: 170,y: 10,width: 70,height: 25)
        addres.font = UIFont.boldSystemFont(ofSize: 15)
//        addres.text = "福利待遇:"
        addresLabel.frame = CGRect(x: 240,y: 10,width: WIDTH-240,height: 25)
        addresLabel.font = UIFont.systemFont(ofSize: 14)

        positionDescript.frame = CGRect(x: 10,y: 10,width: 100,height: 25)
        positionDescript.font = UIFont.boldSystemFont(ofSize: 15)
//        positionDescript.text = "职位描述:"
        descripDetail.frame = CGRect(x: 10,y: 40,width: WIDTH-20,height: 200)
        descripDetail.font = UIFont.systemFont(ofSize: 14)
        descripDetail.textColor = UIColor.lightGray
        descripDetail.numberOfLines = 0
        
        namLabel.frame = CGRect(x: 10,y: 10,width: 80,height: 25)
        namLabel.font = UIFont.boldSystemFont(ofSize: 15)
//        namLabel.text = "联系方式:"
        
        nam = UIButton(type: UIButtonType.custom)
        nam.frame = CGRect(x: 100, y: 10, width: 100, height: 25)
        nam.setTitleColor(COLOR, for: UIControlState())
        nam.titleLabel!.font = UIFont.systemFont(ofSize: 14)

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
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
