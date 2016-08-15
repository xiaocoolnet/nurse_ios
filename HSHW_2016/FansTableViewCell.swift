//
//  FansTableViewCell.swift
//  HSHW_2016
//
//  Created by apple on 16/5/18.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import Alamofire

class FansTableViewCell: UITableViewCell {

    let titImg = UIImageView()
    let nameLab = UILabel()
    let fansBtn = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        titImg.frame = CGRectMake(15, 10, 50, 50)
        titImg.layer.cornerRadius = 25
        titImg.clipsToBounds = true
        titImg.layer.borderColor = UIColor.lightGrayColor().CGColor
        titImg.layer.borderWidth = 0.5
        
        nameLab.frame = CGRectMake(75, 25, 50, 20)
        nameLab.font = UIFont.systemFontOfSize(15)
        
        fansBtn.frame = CGRectMake(75+nameLab.bounds.size.width+5, 26, 19, 18)
        fansBtn.setBackgroundImage(UIImage(named: "ic_shield_purple.png"), forState: .Normal)
        fansBtn.titleLabel?.font = UIFont.systemFontOfSize(9)
        fansBtn.setTitleColor(COLOR, forState: .Normal)
        
        self.addSubview(titImg)
        self.addSubview(nameLab)
        self.addSubview(fansBtn)
        
    }
    
    var fansModel:HSFansAndFollowModel?{
        didSet {
            
//            self.titImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+fansModel!.photo))
//            self.nameLab.text = fansModel!.name
//            self.nameLab.sizeToFit()
//            
//            self.fansBtn.frame = CGRectMake(75+self.nameLab.bounds.size.width+5, 26, 19, 18)
//            self.fansBtn.setTitle(fansModel!.level, forState: .Normal)
            
//            HSMineHelper().getUserInfo((fansModel?.id)!) { (success, response) in

                self.setUI(fansModel!)
//            }
        }
    }
    
    var followModel:HSFansAndFollowModel?{
        didSet {
//            HSMineHelper().getUserInfo((followModel?.userid)!) { (success, response) in
            
                self.setUI(followModel!)
//            }
            
        }
        
    }
    
    private func setUI(model:HSFansAndFollowModel) {
        dispatch_async(dispatch_get_main_queue(), {
            //TODO:image 后期要改，从网上获取
            //            titImg.image = UIImage(named: newValue.headerImage)
            
            // TODO: 数据问题 理应删掉model.photo == "21.jpg"
            if model.photo == "" || model.photo == "21.jpg" {
                
                self.titImg.image = UIImage.init(named: "img_head_nor")
            }else{
                if  !(NetworkReachabilityManager()?.isReachableOnEthernetOrWiFi)! && loadPictureOnlyWiFi {
                    self.titImg.image = UIImage.init(named: "img_head_nor")
                }else{
                    self.titImg.sd_setImageWithURL(NSURL.init(string: SHOW_IMAGE_HEADER+model.photo), placeholderImage: UIImage.init(named: "img_head_nor"))
                }
//                self.titImg.sd_setImageWithURL(NSURL(string: SHOW_IMAGE_HEADER+model.photo))
            }
            self.nameLab.text = model.name
            self.nameLab.sizeToFit()
            
            self.fansBtn.frame = CGRectMake(75+self.nameLab.bounds.size.width+5, 26, 19, 18)
            self.fansBtn.setTitle(model.level, forState: .Normal)
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
