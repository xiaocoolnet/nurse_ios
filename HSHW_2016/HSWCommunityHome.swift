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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.registerNib(UINib(nibName: "HSSQCollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "cell")
        collectionView.pagingEnabled = true
        collectionView.bounces = false
    }
    
    override func viewDidAppear(animated: Bool) {
        if sliderMenu.selectIndex == nil {
            sliderMenu.frame = sliderHead.frame
            sliderMenu.menuNameArray = ["全部","精华","内科","外科" ,"妇产科","儿科","男科","中医科","五官科","神经科"]
            sliderMenu.setSelectTilteIndex(0)
            sliderMenu.delegate = self
            view.addSubview(sliderMenu)
        }
        collectionView.reloadData()
    }
    // MARK: ---sliderMenuDelegate----
    func sliderMenuClickIndex(index: NSInteger) {
        
        collectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
    }
    // MARK: ---CollectionView----
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return sliderMenu.menuNameArray.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! HSSQCollectionViewCell
        cell.backgroundColor = .whiteColor()
        return cell
    }
    //
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
        return collectionView.frame.size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat{
        return 0
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView){
        print(scrollView.contentOffset.x/view.frame.width)
        let index = Int(scrollView.contentOffset.x/view.frame.width)
        sliderMenu.setSelectTilteIndex(index)
    }
}
