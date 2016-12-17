//
//  TalentViewController.swift
//  HSHW_2016
//
//  Created by apple on 16/5/20.
//  Copyright © 2016年 校酷网络科技公司. All rights reserved.
//

import UIKit

class TalentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let myTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let line = UILabel(frame: CGRect(x: 0, y: 0, width: WIDTH, height: 0.5))
        line.backgroundColor = GREY
        self.view.addSubview(line)
        
        self.view.backgroundColor = UIColor.white
        myTableView.frame = CGRect(x: 0, y: 0.5, width: WIDTH, height: HEIGHT-154.5)
        myTableView.backgroundColor = UIColor.white
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(myTableView)

        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 694
        }else if indexPath.section == 1 {
            return 200
        }else{
            return 180
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        
        return cell
    }
}
