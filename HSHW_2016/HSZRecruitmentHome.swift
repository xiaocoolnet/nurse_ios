//
//  HSZRecruitmentHome.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import PagingMenuController

class HSZRecruitmentHome: UIViewController {
    let findJob = RecruitmentViewController()
    let findPersonnel = RecruitmentViewController()
    var workPlace:HSWorkPlaceController?
    weak var superViewController:NurseStationViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        workPlace = HSWorkPlaceController(nibName: "HSWorkPlaceController", bundle: nil)
        workPlace?.articleID = "26"
        findJob.title = "找工作"
        findPersonnel.title = "找人才"
        findPersonnel.showType = 2
        workPlace!.title = "职场宝典"
        let viewControllers = [findJob,findPersonnel,workPlace!]
        let options = PagingMenuOptions()
        options.menuItemMargin = 5
        options.menuHeight = 40
        options.menuDisplayMode = .SegmentedControl
        options.backgroundColor = UIColor.clearColor()
        options.selectedBackgroundColor = UIColor.whiteColor()
        options.font = UIFont.systemFontOfSize(16)
        options.selectedFont = UIFont.systemFontOfSize(16)
        options.selectedTextColor = COLOR
        options.menuItemMode = .Underline(height: 3, color: COLOR, horizontalPadding: 0, verticalPadding: 0)
        let pagingMenuController = PagingMenuController(viewControllers: viewControllers, options: options)
        pagingMenuController.view.frame = CGRectMake(0, 1, WIDTH, HEIGHT-45)
        pagingMenuController.view.frame.origin.y += 0
        pagingMenuController.view.frame.size.height -= 0
        addChildViewController(pagingMenuController)
        view.addSubview(pagingMenuController.view)
        pagingMenuController.didMoveToParentViewController(self)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        findJob.superViewController = superViewController ?? nil
        findPersonnel.superViewController = superViewController ?? nil
    }
    
    func rightBarButtonClicked(){
        findJob.rightBarButtonClicked()
        findPersonnel.rightBarButtonClicked()
    }
}
