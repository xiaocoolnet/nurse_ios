//
//  NSCircleForumImagePreviewViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/29.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import SDWebImage

class NSCircleForumImagePreviewViewController: UIViewController {
    
    var imageArray = [String]()
    var currentImageIndex = 0
    
    let bgView = UIScrollView()
    
//    var delegate:CircleImagePreviewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "护士站 圈子 贴子详情 预览")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "护士站 圈子 贴子详情 预览")
    }
    
    // MARK: - 设置子视图
    func setSubviews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.black
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .done, target: self, action: #selector(saveBtnClick))
        
        self.title = "预览"
        
        bgView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT-65)
        bgView.tag = 123456
        bgView.isPagingEnabled = true
        self.view.addSubview(bgView)
        
        var imageX:CGFloat = 0
        
        for image in imageArray {
            // 图片
            let imageBtn = UIButton(frame: CGRect(x: imageX, y: 0, width: WIDTH, height: HEIGHT-65))
            imageBtn.addTarget(self, action: #selector(imageBtnClick), for: .touchUpInside)
            imageBtn.sd_setImage(with: URL(string: SHOW_IMAGE_HEADER+image), for: UIControlState(), placeholderImage: nil)
            imageBtn.imageView?.contentMode = .scaleAspectFit
            bgView.addSubview(imageBtn)
            
            imageX = imageBtn.frame.maxX
            
        }
        
        bgView.contentSize.width = imageX
        bgView.contentOffset.x = CGFloat(currentImageIndex)*WIDTH
    }
    
    // MARK: - 保存按钮点击事件
    func saveBtnClick() {
//        let downloader = SDWebImageDownloader()
//        downloader.downloadImage(with: URL(string: SHOW_IMAGE_HEADER+imageArray[Int(bgView.contentOffset.x/WIDTH)]), options: SDWebImageDownloaderOptions.progressiveDownload, progress: { (<#Int#>, <#Int#>) in
//            <#code#>
//        }) { (image, data, error, bool) in
//            
//            if image == nil {
//                
//            }else{
//                
//                UIImageWriteToSavedPhotosAlbum(image!, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), <#T##contextInfo: UnsafeMutableRawPointer?##UnsafeMutableRawPointer?#>)
//            }
//
//        }
//        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);

    }
    
//    @objc func image(image:UIImage, didFinishSavingWithError error:NSError, contextInfo:Void) {
//        print("image = %@, error = %@, contextInfo = %@", image, error, contextInfo)
//    }
//    - (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
//    {
//    
//    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
//    }
    
    
    func imageBtnClick() {
        //        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
