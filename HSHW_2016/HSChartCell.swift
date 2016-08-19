//
//  HSChartCell.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/7/14.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSChartCell: UITableViewCell {
    @IBOutlet weak var rightRate: UILabel!
    @IBOutlet weak var rightContent: NSLayoutConstraint!
    @IBOutlet weak var biteRate: UILabel!
    @IBOutlet weak var chartLineView: UIView!
    var chartView:CFLineChartView?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func layoutSubviews() {
        chartView = NSBundle.mainBundle().loadNibNamed("CFLineChartView", owner: nil, options: nil).last as? CFLineChartView
        chartView!.frame = CGRectMake(0, 0, WIDTH-20, chartLineView.frame.height)
        chartView?.selfConfigure()
        chartView!.xValues = ["7月1", "7月2", "7月3", "7月4", "7月5", "7月6", "7月7"]
        chartView!.yValues = [35, 5, 80, 40,100,60,80,57];
        chartView!.isShowLine = true
        chartView!.isShowPoint = true
        chartView!.isShowPillar = false
        chartView!.isShowValue = false
        chartView!.drawChartWithLineChartType(LineChartType.Straight, pointType: PointType.Circel)
        chartLineView.addSubview(chartView!)
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
