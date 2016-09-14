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
    
    var examDataArray = Array<examDataModel>() {
        didSet {
            var xValues = Array<String>()
            var yValues = Array<Int>()
            
            let min = examDataArray.count>7 ? (examDataArray.count-7):0
            for examData in examDataArray[min ..< examDataArray.count] {
                xValues.append(timeStampToString(examData.create_time))
                yValues.append((examData.rightcount as NSString).integerValue*100/(examData.count as NSString).integerValue)
            }
            var rate = 0.0
            for examData in examDataArray {
                if (examData.count as NSString).doubleValue == 0 {
                    
                    rate += 1
                }else{
                    
                    rate += (examData.rightcount as NSString).doubleValue/(examData.count as NSString).doubleValue
                }
            }
            rate = rate/Double(examDataArray.count)
            self.rightRate.text = String(format: "%.2f%%", rate*100)
            self.biteRate.text = String(format: "%.2f%%", rate*100*rate)
            
            chartView = NSBundle.mainBundle().loadNibNamed("CFLineChartView", owner: nil, options: nil).last as? CFLineChartView
            chartView!.frame = CGRectMake(0, 0, chartLineView.frame.size.width, chartLineView.frame.size.height)
            chartView?.selfConfigure()
            
            chartView?.xValues = xValues
            chartView?.yValues = yValues
            //        chartView!.xValues = ["7月1", "7月2", "7月3", "7月4", "7月5", "7月6", "7月7"]
            //        chartView!.yValues = [35, 5, 80, 40,100,60,80,57];
            chartView!.isShowLine = true
            chartView!.isShowPoint = true
            chartView!.isShowPillar = false
            chartView!.isShowValue = false
            chartView!.drawChartWithLineChartType(LineChartType.Straight, pointType: PointType.Circel)
            chartLineView.addSubview(chartView!)
        }
    }
    
    // Linux时间戳转标准时间
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="MM-dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date))
        return dfmatter.stringFromDate(date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
