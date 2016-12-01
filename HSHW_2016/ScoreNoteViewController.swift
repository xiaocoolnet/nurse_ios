//
//  ScoreNoteViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2016/12/1.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit
import WebKit

class ScoreNoteViewController: UIViewController {

    var urlStr = ""
    
    let progressView = UIProgressView()
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 线
        let line = UILabel(frame: CGRectMake(0, 0, WIDTH, 1))
        line.backgroundColor = COLOR
        self.view.addSubview(line)

        // webview
        webView.frame = CGRect(x: 0, y: 1, width: WIDTH, height: HEIGHT-65)
        let url = NSURL(string: urlStr)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        self.view.addSubview(webView)
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.New, context: nil)
        webView.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.New, context: nil)

        progressView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 1)
        self.view.addSubview(progressView)
        
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "title" {
            self.title = self.webView.title
        }else if keyPath == "estimatedProgress" {
            self.progressView.progress = Float(self.webView.estimatedProgress)
        }
        
        if object as! NSObject == self.webView && keyPath! == "estimatedProgress" {
            let newprogress = change![NSKeyValueChangeNewKey] as! Double
            
            if newprogress == 1 {
                self.progressView.hidden = true
                self.progressView.setProgress(0, animated: false)
            }else {
                self.progressView.hidden = false
                self.progressView.setProgress(Float(newprogress), animated: false)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        webView.removeObserver(self, forKeyPath: "title")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
