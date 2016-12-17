//
//  GMyErrorTableViewCell.swift
//  HSHW_2016
//
//  Created by JQ on 16/7/22.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
//import Alamofire

class GMyErrorTableViewCell: UITableViewCell {

//    var inde:Int = 0
//    let indexLab = UILabel()
    let titImg = UIImageView()
    let titleLab = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
//        indexLab.frame = CGRectMake(10, 10, 50, 50)
//        indexLab.textColor = UIColor.darkGrayColor()
        
        titImg.frame = CGRect(x: 8, y: 25, width: 25, height: 30)
        titImg.image = UIImage.init(named: "ic_note")
//        titImg.frame = CGRectMake(70, 10, 50, 50)
//        titImg.layer.cornerRadius = 25
//        titImg.clipsToBounds = true
        
        titleLab.frame = CGRect(x: 75+50+15, y: 15, width: WIDTH - 150, height: 50)
        titleLab.font = UIFont.systemFont(ofSize: 14)
        titleLab.numberOfLines = 0
        
//        self.addSubview(indexLab)
        self.addSubview(titImg)
        self.addSubview(titleLab)

        
    }
    
    var fansModel:xamInfo?{
        didSet {
            
            titleLab.text = fansModel?.post_title
            titleLab.sizeToFit()
            titleLab.frame = CGRect(x: titImg.frame.maxX+15, y: 15, width: WIDTH-titImg.frame.maxX-30, height: 50)
        }
        
    }
    
    var fanModel:xamInfo?{
        didSet {
            
            titleLab.text = fanModel?.title
            titleLab.sizeToFit()
            titleLab.frame = CGRect(x: titImg.frame.maxX+15, y: 15, width: WIDTH-titImg.frame.maxX-30, height: 50)
            
        }
        
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
