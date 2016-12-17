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
    var url:URL?
    
    var hud = MBProgressHUD()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        BaiduMobStat.default().pageviewStart(withName: "出国百宝箱（第三方） " + (self.title ?? "")!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        BaiduMobStat.default().pageviewEnd(withName: "出国百宝箱（第三方） " + (self.title ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        if url != nil {
            netView.loadRequest(URLRequest(url: url!))
            netView.scalesPageToFit = true
            netView.delegate = self
            hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.removeFromSuperViewOnHide = true
        }
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        

        
        return true
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
//        hud.hide(animated: true)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        hud.hide(animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        hud.hide(animated: true)
        if webView.request?.url == self.url {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment: "Warn"), message: NSLocalizedString("获取详情失败 \(error.localizedDescription)", comment: "empty message"), preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let doneAction = UIAlertAction(title: "重试", style: .default, handler: { (action) in
                self.netView.loadRequest(URLRequest(url: self.url!))
            })
            alertController.addAction(doneAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            })
            alertController.addAction(cancelAction)
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        hud.hide(animated: true)
    }

}
