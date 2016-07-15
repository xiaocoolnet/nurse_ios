//
//  HSWCommunityHome.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class HSWCommunityHome: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,SliderMenuViewDelegate {
    
    var sliderMenu: HSZSliderMenuView = HSZSliderMenuView()
    var viewControllers:Array<UIViewController> = []
    @IBOutlet weak var sliderHead: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var forumHelper = HSNurseStationHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge.None
        collectionView.registerNib(UINib(nibName: "HSSQCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.pagingEnabled = true
        collectionView.bounces = false
        forumHelper.getForumList("1",isHot: false) { (success, response) in
        }
        
        let posted = UIButton()
        posted.frame = CGRectMake(WIDTH-70 , HEIGHT-230, 50, 50)
        posted.setImage(UIImage(named: "ic_edit.png"), forState: .Normal)
        posted.addTarget(self, action: #selector(RecruitmentViewController.postedTheView), forControlEvents: .TouchUpInside)
        self.view.addSubview(posted)
        posted.becomeFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if sliderMenu.selectIndex == nil {
            sliderMenu.frame = sliderHead.frame
            
            forumHelper.getBBSTypeData({ (success, response) in
                let array:Array<ForumTypeModel> = response as! Array<ForumTypeModel>

                let tempArray:NSMutableArray = []
                
                if !array.isEmpty {
                    for obj in array {
                        tempArray.addObject(obj.name)
                    }
                    self.sliderMenu.menuNameArray = tempArray
                    self.sliderMenu.setSelectTilteIndex(0)
                    self.collectionView.reloadData()
                }

            })

            sliderMenu.delegate = self
            view.addSubview(sliderMenu)
        }
        collectionView.reloadData()
    }
    // MARK: ---sliderMenuDelegate----
    func sliderMenuClickIndex(index: NSInteger) {
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    
    func postedTheView() {
        let next = PostViewController()
        self.navigationController?.pushViewController(next, animated: true)
        print("发帖")
    }
    
    func postDetailWithModel_1(model:PostModel){
        let vc = HSPostDetailViewController()
        vc.postInfo = model
        navigationController?.pushViewController(vc, animated: true)
    }
//    func postDetailWithModel(model:ForumModel){
//        let vc = HSPostDetailController()
//        vc.postInfo = model
//        navigationController?.pushViewController(vc, animated: true)
//    }
    // MARK: ---CollectionView---
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return sliderMenu.menuNameArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HSSQCollectionViewCell
        cell.backgroundColor = .whiteColor()
        return cell
    }
    //每个cell大小
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return collectionView.frame.size
    }
    //边距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    //行距
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        print(scrollView.contentOffset.x/view.frame.width)
        let index = Int(scrollView.contentOffset.x/view.frame.width)
        sliderMenu.setSelectTilteIndex(index)
    }
}
