//
//  HSWebViewDetailController.swift
//  HSHW_2016
//
//  Created by xiaocool on 16/6/30.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import MBProgressHUD

class HSWebViewDetailController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var netView:UIWebView!
    var url:NSURL?
    
    var hud = MBProgressHUD()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.defaultStat().pageviewStartWithName("出国百宝箱（第三方） " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.defaultStat().pageviewEndWithName("出国百宝箱（第三方） " + (self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.hidden = false
        if url != nil {
            netView.loadRequest(NSURLRequest(URL: url!))
            netView.scalesPageToFit = true
            netView.delegate = self
            hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        

        
        return true
    }
    func webViewDidStartLoad(webView: UIWebView) {
//        hud.hide(true)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        hud.hide(true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        hud.hide(true)
        if webView.request?.URLString == self.url {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("获取详情失败 \(error.debugDescription)", comment: "empty message"), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true, completion: nil)
            let doneAction = UIAlertAction(title: "重试", style: .Default, handler: { (action) in
                self.netView.loadRequest(NSURLRequest(URL: self.url!))
            })
            alertController.addAction(doneAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: { (action) in
                self.navigationController?.popViewControllerAnimated(true)
            })
            alertController.addAction(cancelAction)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        hud.hide(true)
    }

}
