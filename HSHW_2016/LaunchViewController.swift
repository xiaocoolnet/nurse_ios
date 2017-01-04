//
//  LaunchViewController.swift
//  HSHW_2016
//
//  Created by 高扬 on 2017/1/4.
//  Copyright © 2017年 校酷网络科技公司. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    @IBOutlet weak var launchImageView: UIImageView!
    
    let Imageview = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
//        let data = try Data(contentsOf: <#T##URL#>)
//        NSMutableData * data = [[NSUserDefaults standardUserDefaults]objectForKey:@"imageu"];
//        if (data.length>0) {
//            Imageview.image = [UIImage imageWithData:data];
//        }else{
//            
//            Imageview.image = [UIImage imageNamed:@"Test"];
//        }
    }
    
    func skipBtnClick() {
        
        Imageview.removeFromSuperview()

//        let viewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MainView")
////        self.present(viewController, animated: true, completion: nil)
//        UIApplication.shared.keyWindow?.rootViewController = viewController
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
